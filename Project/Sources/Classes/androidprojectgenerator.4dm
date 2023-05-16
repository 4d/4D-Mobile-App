Class extends androidProcess

Class constructor($java : 4D:C1709.File; $kotlinc : 4D:C1709.File; $projectPath : Text)
	
	Super:C1705()
	
	This:C1470.androidprojectgeneratorCmd:="\""+$java.path+"\" -jar androidprojectgenerator.jar"
	This:C1470.kotlinc:=$kotlinc.path
	This:C1470.chmodCmd:="chmod"
	
	This:C1470.projectPath:=$projectPath
	This:C1470.drawableFolder:=Folder:C1567(This:C1470.projectPath+"app/src/main/res/drawable")
	
	This:C1470.path:=cs:C1710.path.new()
	This:C1470.vdtool:=cs:C1710.vdtool.new()
	
	This:C1470._copyJarIfmissing()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function generate($project : Object; $mobileProj : 4D:C1709.Folder)->$result : Object
	
	$result:=New object:C1471(\
		"success"; True:C214; \
		"outputStream"; ""; \
		"errorStream"; ""; \
		"errors"; New collection:C1472)
	
	var $catalogfile : 4D:C1709.File
	
	$catalogfile:=$mobileProj.file("catalog.json")
	
	If (Not:C34(This:C1470.path.androidProjectFilesToCopy().exists)\
		 | Not:C34(This:C1470.path.androidProjectTemplateFiles().exists)\
		 | Not:C34(This:C1470.path.androidForms().exists))
		
		$result.errors.push("Missing directories for project templating")
		return 
		
	End if 
	
	If (Not:C34(This:C1470.path.scripts().exists))
		
		$result.errors.push("Missing scripts directory")
		return 
		
	End if 
	
	If (Not:C34($catalogFile.exists))
		
		$result.errors.push("Missing catalog.json file")
		return 
		
	End if 
	
	This:C1470.setDirectory(This:C1470.path.scripts())
	
	This:C1470.launch(This:C1470.androidprojectgeneratorCmd\
		+" generate"\
		+" --project-editor \""+$project.path\
		+"\" --files-to-copy \""+This:C1470.path.androidProjectFilesToCopy().path\
		+"\" --template-files \""+This:C1470.path.androidProjectTemplateFiles().path\
		+"\" --template-forms \""+This:C1470.path.androidForms().path\
		+"\" --host-db \""+This:C1470.path.host().path\
		+"\" --catalog \""+$catalogFile.path\
		+"\"")
	
	var $exceptionPos; $errorPos : Integer
	
	$exceptionPos:=Position:C15("Exception"; String:C10(This:C1470.errorStream))
	$errorPos:=Position:C15("Error"; String:C10(This:C1470.errorStream))
	
	If ($exceptionPos>0)
		// Removes illegal capsule access warnings
		This:C1470.errorStream:=Substring:C12(This:C1470.errorStream; $exceptionPos)
	End if 
	
	$result.success:=Not:C34(($exceptionPos>0) | ($errorPos>0))
	$result.outputStream:=This:C1470.outputStream
	$result.errorStream:=This:C1470.errorStream
	
	If (Not:C34($result.success))
		
		$result.errors.push("Failed to generate files")
		$result.errors.push(This:C1470.errorStream)
		
		// Else : all ok
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function _copyJarIfmissing
	var $file : 4D:C1709.File
	$file:=Folder:C1567(fk resources folder:K87:11).folder("scripts").file("androidprojectgenerator.jar")
	
	If (Not:C34($file.exists))
		// try from 4d app (deprecated)
		If (Folder:C1567(Application file:C491; fk platform path:K87:2).file("Contents/Resources/Internal User Components/4D Mobile App.4dbase/Resources/scripts/androidprojectgenerator.jar").exists)
			
			Folder:C1567(Application file:C491; fk platform path:K87:2).file("Contents/Resources/Internal User Components/4D Mobile App.4dbase/Resources/scripts/androidprojectgenerator.jar")\
				.copyTo($file.parent)
			
		End if 
		
	End if 
	
	
	If (Not:C34($file.exists))
		
		var $url; $content : Text
		$url:="https://github.com/4d/android-ProjectGenerator/releases/latest/download/androidprojectgenerator.jar"
		
		var $data : Blob
		var $code : Integer
		$code:=HTTP Request:C1158(HTTP GET method:K71:1; $url; $content; $data)
		
		If (($code>=200) && ($code<300))
			
			$file.setContent($data)
			
		End if 
		
	End if 
	
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function buildEmbeddedDataLib
	var $0 : Object
	var $1 : Text  // package name (app name)
	var $staticDataInitializerFile; $targetFile : 4D:C1709.File
	var $libFolder : 4D:C1709.Folder
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$staticDataInitializerFile:=File:C1566(This:C1470.projectPath+"buildSrc/src/main/java/"+$1+".android.build/database/StaticDataInitializer.kt")
	
	If ($staticDataInitializerFile.exists)
		
		$libFolder:=Folder:C1567(This:C1470.projectPath+"buildSrc/libs")
		$libFolder.create()
		
		$targetFile:=$libFolder.file("prepopulation.jar")
		
		This:C1470.launch("\""+This:C1470.kotlinc+"\""\
			+" -verbose \""+$staticDataInitializerFile.path+"\""\
			+" -d \""+$targetFile.path+"\"")
		
		$0.success:=$targetFile.exists
		
	Else 
		
		$0.errors.push("Missing file : "+$staticDataInitializerFile.path)
		
	End if 
	
	If (Not:C34($0.success))
		
		$0.errors.push("Failed to build embedded data library")
		
		// Else : all ok
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copyEmbeddedDataLib
	var $0 : Object
	var $copySrc; $copyDest : 4D:C1709.File
	var $targetLibFolder : 4D:C1709.Folder
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$copySrc:=File:C1566(This:C1470.projectPath+"buildSrc/libs/prepopulation.jar")
	
	If ($copySrc.exists)
		
		$targetLibFolder:=Folder:C1567(This:C1470.projectPath+"app/libs")
		$targetLibFolder.create()
		
		$copyDest:=$copySrc.copyTo(Folder:C1567(This:C1470.projectPath+"app/libs"); fk overwrite:K87:5)
		
		If ($copyDest.exists)
			
			$0.success:=True:C214
			
		Else 
			// Copy failed
			$0.errors.push("Could not copy file to destination: "+$copyDest.path)
		End if 
		
	Else 
		// Missing file
		$0.errors.push("Missing source file for copy: "+$copySrc.path)
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copyResources($project : cs:C1710.project)->$result : Object
	
	var $projectFolder; $androidAssets; $currentFolder : 4D:C1709.Folder
	var $currentFile; $copyDest; $googleServices : 4D:C1709.File
	
	$result:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	// Copy "android" resources
	$projectFolder:=$project._folder
	$androidAssets:=$projectFolder.folder("android")
	
	If (Not:C34($androidAssets.exists) && ($projectFolder.file("app_icon.png").exists))
		
		var $picture : Picture
		READ PICTURE FILE:C678($projectFolder.file("app_icon.png").platformPath; $picture)
		$project.AndroidIconSet($picture)
		
	End if 
	
	If ($androidAssets.exists)
		
		$result.success:=True:C214
		
		For each ($currentFolder; $androidAssets.folders())
			
			For each ($currentFile; $currentFolder.files())
				
				If ($currentFolder.name="main")
					
					// for Play Store
					$copyDest:=$currentFile.copyTo(Folder:C1567(This:C1470.projectPath+"app/src/main"); fk overwrite:K87:5)
					
					// for login form, splash screen
					$copyDest:=$currentFile.copyTo(Folder:C1567(This:C1470.projectPath+"app/src/main/res/drawable"); "logo.png"; fk overwrite:K87:5)
					
				Else 
					
					// for API > 25
					$copyDest:=$currentFile.copyTo(Folder:C1567(This:C1470.projectPath+"app/src/main/res/"+$currentFolder.name); fk overwrite:K87:5)
					
					// for API 25
					$copyDest:=$currentFile.copyTo(Folder:C1567(This:C1470.projectPath+"app/src/main/res/"+$currentFolder.name); "ic_launcher_round.png"; fk overwrite:K87:5)
					
					// for API < 25
					$copyDest:=$currentFile.copyTo(Folder:C1567(This:C1470.projectPath+"app/src/main/res/"+$currentFolder.name); "ic_launcher.png"; fk overwrite:K87:5)
					
				End if 
				
				If (Not:C34($copyDest.exists))
					// Copy failed
					$result.success:=False:C215
					$result.errors.push("Could not copy file to destination: "+$copyDest.path)
					
					//Else : all ok
				End if 
				
			End for each 
			
		End for each 
		
	Else 
		// Missing Android folder
		$result.errors.push("Missing source file for copy: "+$androidAssets.path)
	End if 
	
	If (Bool:C1537($project.server.pushNotification))
		// Copy google-services.json for push notifications
		
		$googleServices:=$projectFolder.file("google-services.json")
		
		If ($googleServices.exists)
			
			$copyDest:=$googleServices.copyTo(Folder:C1567(This:C1470.projectPath+"app"); fk overwrite:K87:5)
			
			If (Not:C34($copyDest.exists))
				// Copy failed
				$result.success:=False:C215
				$result.errors.push("Could not copy file to destination: "+$copyDest.path)
				
				//Else : all ok
			End if 
			
		Else 
			// Missing google-services.json file
			$result.errors.push("Missing google-services.json file : "+$googleServices.path)
			
		End if 
		
	End if 
	
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copyDataSet
	var $0 : Object
	var $1 : 4D:C1709.Folder  // 4D Mobile Project
	var $xcassets; $copyDest : 4D:C1709.Folder
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	// Copy dataSet resources
	$xcassets:=$1.folder("project.dataSet/Resources/Assets.xcassets")
	
	If ($xcassets.exists)
		
		$copyDest:=$xcassets.copyTo(Folder:C1567(This:C1470.projectPath+"app/src/main/assets"); "datadump"; fk overwrite:K87:5)
		
		If ($copyDest.exists)
			
			$0.success:=True:C214
			
		Else 
			// Copy failed
			$0.success:=False:C215
			$0.errors.push("Could not copy directory to destination: "+$copyDest.path)
			
		End if 
		
	Else 
		// Missing Assets.xcassets folder
		$0.errors.push("Missing source directory for copy: "+$xcassets.path)
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copyGeneratedDb
	var $0 : Object
	var $1 : 4D:C1709.Folder  // 4D Mobile Project
	var $dbFile; $copyDest : 4D:C1709.File
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	// Copy db file
	$dbFile:=This:C1470.path.androidDb($1.path)
	
	If ($dbFile.exists)
		
		$copyDest:=$dbFile.copyTo(Folder:C1567(This:C1470.projectPath+"app/src/main/assets/databases"); fk overwrite:K87:5)
		
		If ($copyDest.exists)
			
			$0.success:=True:C214
			
		Else 
			// Copy failed
			$0.success:=False:C215
			$0.errors.push("Could not copy db file to destination: "+$copyDest.path)
			
		End if 
		
	Else 
		// Missing generated db file
		$0.errors.push("Missing db file for copy: "+$dbFile.path)
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copyDataSetPictures
	var $0 : Object
	var $1 : 4D:C1709.Folder  // 4D Mobile Project
	var $picturesFolder; $copyDest : 4D:C1709.Folder
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	// Copy dataSet pictures
	$picturesFolder:=$1.folder("project.dataSet/Resources/Assets.xcassets/Pictures")
	
	If ($picturesFolder.exists)
		
		$copyDest:=$picturesFolder.copyTo(Folder:C1567(This:C1470.projectPath+"app/src/main/assets"); fk overwrite:K87:5)
		
		If (Not:C34($copyDest.exists))
			
			// Copy failed
			$0.success:=False:C215
			$0.errors.push("Could not copy directory to destination: "+$copyDest.path)
			
			// Else : all ok
		End if 
		
		// Else : no Pictures folder
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copyIcons
	var $0 : Object
	var $1 : Object  // Datamodel object
	var $2 : Collection  // navigation table order
	var $3 : Collection  // Actions collection
	
	var $tableIcons : 4D:C1709.Folder
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$tableIcons:=This:C1470.path.tableIcons()
	
	If ($tableIcons.exists)
		
		$0.success:=True:C214
		
		var $shouldCreateMissingDMIcon : Boolean
		
		$shouldCreateMissingDMIcon:=This:C1470.willRequireDataModelIcons($2; $1; $3)
		
		var $dataModel; $field; $subField : Object
		
		For each ($dataModel; OB Entries:C1720($1))
			
			var $navKey : Variant
			
			For each ($navKey; $2)
				
				If (Value type:C1509($navKey)=Is text:K8:3)
					
					// Only do the following if is a navigation item
					If ($navKey=$dataModel.key)
						
						If ($shouldCreateMissingDMIcon)
							
							// Check for table image
							var $Obj_handleDataModelIcon : Object
							
							$Obj_handleDataModelIcon:=This:C1470.handleDataModelIcon($dataModel)
							
							If (Not:C34($Obj_handleDataModelIcon.success))
								
								$0.success:=False:C215
								$0.errors.combine($Obj_handleDataModelIcon.errors)
								
								// Else : all ok
							End if 
							
						End if 
						
					End if 
					
				End if 
				
			End for each 
			
			var $shouldCreateMissingFieldIcon : Boolean
			
			$shouldCreateMissingFieldIcon:=This:C1470.willRequireFieldIcons($dataModel)
			
			For each ($field; OB Entries:C1720($dataModel.value))  // For each field in dataModel
				
				If ($field.key#"")
					
					// Check for formatter image
					var $Obj_copyFormatterImage : Object
					
					$Obj_copyFormatterImage:=This:C1470.copyFormatterImage($field)
					
					If (Not:C34($Obj_copyFormatterImage.success))
						
						$0.success:=False:C215
						$0.errors.combine($Obj_copyFormatterImage.errors)
						
						// Else : all ok
					End if 
					
					// Check for field icon
					var $Obj_handleField : Object
					
					$Obj_handleField:=This:C1470.handleField($dataModel.key; $field; $shouldCreateMissingFieldIcon)
					
					If (Not:C34($Obj_handleField.success))
						
						$0.success:=False:C215
						$0.errors.combine($Obj_handleField.errors)
						
						// Else : all ok
					End if 
					
					// Else : table metadata
				End if 
				
			End for each 
			
		End for each 
		
		// Actions images
		If ($3#Null:C1517)
			
			var $action : Object
			
			For each ($action; $3)
				
				If ($action.scope="global")
					
					If ($shouldCreateMissingDMIcon)
						
						If (Feature.with("openURLActionsInTabBar"))
							
							var $Obj_handleGlobalActionIcon : Object
							
							$Obj_handleGlobalActionIcon:=This:C1470.handleGlobalActionIcon($action)
							
							If (Not:C34($Obj_handleGlobalActionIcon.success))
								
								$0.success:=False:C215
								$0.errors.combine($Obj_handleGlobalActionIcon.errors)
								
								// Else : all ok
							End if 
							
						End if 
						
					End if 
					
				Else 
					
					// Check for action icon
					var $Obj_handleActionIcon : Object
					
					$Obj_handleActionIcon:=This:C1470.handleActionIcon($action)
					
					If (Not:C34($Obj_handleActionIcon.success))
						
						$0.success:=False:C215
						$0.errors.combine($Obj_handleActionIcon.errors)
						
						// Else : all ok
					End if 
					
					// Check for input control image files
					var $Obj_handleInputControlImages : Object
					
					$Obj_handleInputControlImages:=This:C1470.handleInputControlImages($action)
					
					If (Not:C34($Obj_handleInputControlImages.success))
						
						$0.success:=False:C215
						$0.errors.combine($Obj_handleInputControlImages.errors)
						
						// Else : all ok
					End if 
					
				End if 
				
			End for each 
			// Else : no action defined
		End if 
		
		// Convert SVG to XML
		This:C1470.vdtool.convert(This:C1470.drawableFolder; This:C1470.drawableFolder)
		
		If (Not:C34(This:C1470.vdtool.success))
			
			$0.success:=False:C215
			$0.errors.push("Error when converting SVG to XML files")
			
			// Else : all ok
		End if 
		
		// Delete SVG files converted
		If ($0.success)
			
			var $drawable : 4D:C1709.File
			
			For each ($drawable; This:C1470.drawableFolder.files())
				
				If ($drawable.extension=".svg")
					
					$drawable.delete()
					
					// Else : nothing to do
				End if 
				
			End for each 
			
			// Else : already on error
		End if 
		
	Else 
		// Missing icons folder
		$0.errors.push("Missing icons folder : "+$tableIcons.path)
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function willRequireFieldIcons
	var $0 : Boolean
	var $1 : Object  // dataModel key value object
	
	var $field; $subField : Object
	
	$0:=False:C215
	
	For each ($field; OB Entries:C1720($1.value))  // For each field in dataModel
		
		If ($field.key#"")
			
			If (Value type:C1509($field.value)=Is object:K8:27)
				
				If ($field.value.icon#Null:C1517)
					
					If (Value type:C1509($field.value.icon)=Is text:K8:3)
						
						If ($field.value.icon#"")
							
							$0:=True:C214
							return 
							
						End if 
						
					End if 
					
				End if 
				
				For each ($subField; OB Entries:C1720($field.value))  // For each subField in field
					
					If (Value type:C1509($subField.value)=Is object:K8:27)
						
						If ($subField.value.icon#Null:C1517)
							
							If (Value type:C1509($subField.value.icon)=Is text:K8:3)
								
								If ($subField.value.icon#"")
									
									$0:=True:C214
									return 
									
								End if 
								
							End if 
							
						End if 
						
					End if 
					
				End for each 
				
			End if 
			
			// Else: table metadata
		End if 
		
	End for each 
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function willRequireDataModelIcons
	var $0 : Boolean
	var $1 : Collection  // navigation table order
	var $2 : Object  // dataModel object
	var $3 : Collection  // Actions collection
	
	var $tableId : Variant
	var $dataModel; $elem; $action : Object
	
	$0:=False:C215
	
	For each ($tableId; $1)
		var $dmFound : Boolean
		
		$dmFound:=False:C215
		
		For each ($dataModel; OB Entries:C1720($2)) Until ($dmFound)
			
			If (Value type:C1509($tableId)=Is text:K8:3)
				
				If ($dataModel.key=$tableId)
					
					$dmFound:=True:C214
					
					var $mainElemFound : Boolean
					
					$mainElemFound:=False:C215
					
					For each ($elem; OB Entries:C1720($dataModel.value)) Until ($mainElemFound)
						
						If ($elem.key="")
							
							$mainElemFound:=True:C214
							
							If (String:C10($elem.value.icon)#"")
								
								$0:=True:C214
								return 
								
							End if 
							
						End if 
						
					End for each 
					
				End if 
				
			End if 
			
		End for each 
		
		If (($3#Null:C1517) & (Feature.with("openURLActionsInTabBar")))
			// Check for global scope actions
			For each ($action; $3)
				
				If ((String:C10($action.scope)="global") & (String:C10($action.icon)#""))
					
					$0:=True:C214
					return 
					
				End if 
				
			End for each 
			
		End if 
		
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function handleDataModelIcon
	var $0 : Object
	var $1 : Object  // dataModel key value object
	var $currentFile : 4D:C1709.File
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	// Get defined icon
	If ($1.value[""].icon#Null:C1517)
		
		If (Value type:C1509($1.value[""].icon)=Is text:K8:3)
			
			var $iconPath : Text
			
			$iconPath:=$1.value[""].icon
			
			If ($iconPath#"")
				
				$currentFile:=This:C1470.path.icon($iconPath)
				
				// Else : icon empty
			End if 
			
			// Else : $dataModel.value[""].icon is not Text
		End if 
		
		// Else : no icon
	End if 
	
	
	// Create icon if missing
	If (Not:C34(Bool:C1537($currentFile.exists)))
		
		var $Obj_createIcon : Object
		
		$Obj_createIcon:=This:C1470.createIconAssets($1.value[""])
		
		If ($Obj_createIcon.success)
			
			$currentFile:=$Obj_createIcon.icon
			
		Else 
			
			$0.success:=False:C215
			$0.errors.combine($Obj_createIcon.errors)
			
		End if 
		
		// Else : already handled
	End if 
	
	
	// Copy icon
	If (Bool:C1537($currentFile.exists))
		
		var $Obj_copy : Object
		var $newName : Text
		
		$newName:=Replace string:C233($currentFile.name; "qmobile_android_missing_icon"; "nav_icon_"+$1.key)
		
		$Obj_copy:=This:C1470.copyIcon($currentFile; $newName)
		
		If (Not:C34($Obj_copy.success))
			
			$0.success:=False:C215
			$0.errors.combine($Obj_copy.errors)
			
			// Else : all ok
		End if 
		
		// Else : already handled
	End if 
	
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function handleGlobalActionIcon
	var $0 : Object
	var $1 : Object  // action object
	var $currentFile : 4D:C1709.File
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	// Get defined icon
	If ($1.icon#Null:C1517)
		
		If (Value type:C1509($1.icon)=Is text:K8:3)
			
			var $iconPath : Text
			
			$iconPath:=$1.icon
			
			If ($iconPath#"")
				
				$currentFile:=This:C1470.path.icon($iconPath)
				
				// Else : icon empty
			End if 
			
			// Else : $action.icon is not Text
		End if 
		
		// Else : no icon
	End if 
	
	
	// Create icon if missing
	If (Not:C34(Bool:C1537($currentFile.exists)))
		
		var $Obj_createIcon : Object
		
		$Obj_createIcon:=This:C1470.createIconAssets($1)
		
		If ($Obj_createIcon.success)
			
			$currentFile:=$Obj_createIcon.icon
			
		Else 
			
			$0.success:=False:C215
			$0.errors.combine($Obj_createIcon.errors)
			
		End if 
		
		// Else : already handled
	End if 
	
	
	// Copy icon
	If (Bool:C1537($currentFile.exists))
		
		var $Obj_copy : Object
		var $newName : Text
		
		$newName:=Replace string:C233($currentFile.name; "qmobile_android_missing_icon"; "nav_icon_"+$1.name)
		
		$Obj_copy:=This:C1470.copyIcon($currentFile; $newName)
		
		If (Not:C34($Obj_copy.success))
			
			$0.success:=False:C215
			$0.errors.combine($Obj_copy.errors)
			
			// Else : all ok
		End if 
		
		// Else : already handled
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function handleField
	var $0 : Object
	var $1 : Text  // dataModel key
	var $2 : Object  // field key value object
	var $3 : Boolean  // if should create icon if missing
	var $isRelation : Boolean
	var $Obj_handleFieldIcon : Object
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	$Obj_handleFieldIcon:=This:C1470.handleFieldIcon($1; $2; $3; -1; ""; "")
	
	If (Not:C34($Obj_handleFieldIcon.success))
		
		$0.success:=False:C215
		$0.errors:=$Obj_handleFieldIcon.errors
		
		// Else : all ok
	End if 
	
	
	If (Value type:C1509($2.value)=Is object:K8:27)
		
		$isRelation:=($2.value.relatedDataClass#Null:C1517)
		
		If ($isRelation)  // related field
			
			var $relatedField : Object
			
			For each ($relatedField; OB Entries:C1720($2.value))  // For each field in related table
				
				If (Value type:C1509($relatedField.value)=Is object:K8:27)
					
					If (String:C10($relatedfield.value.kind)="alias")
						
						// Add alias name key in object
						$relatedField.value.aliasName:=$relatedField.key
						
					End if 
					
					$Obj_handleFieldIcon:=This:C1470.handleFieldIcon($1; $relatedField.value; $3; $2.value.relatedTableNumber; $2.value.id; "")
					
					If (Not:C34($Obj_handleFieldIcon.success))
						
						$0.success:=False:C215
						$0.errors.combine($Obj_handleFieldIcon.errors)
						
						// Else : all ok
					End if 
					
					// Checking subFields
					var $subField : Object
					
					For each ($subField; OB Entries:C1720($relatedField.value))  // For each subField in relatedFields
						
						If (Value type:C1509($subField.value)=Is object:K8:27)
							
							If (String:C10($subField.value.kind)="alias")
								
								// Add alias name key in object
								$subField.value.aliasName:=$subField.key
								
							End if 
							
							$Obj_handleFieldIcon:=This:C1470.handleFieldIcon($1; $subField.value; $3; $2.value.relatedTableNumber; $2.value.id; $relatedField.key)
							
							If (Not:C34($Obj_handleFieldIcon.success))
								
								$0.success:=False:C215
								$0.errors.combine($Obj_handleFieldIcon.errors)
								
								// Else : all ok
							End if 
							
						End if 
						
					End for each 
					
					// Else : not a sub field (can be inverseName, relatedTableNumber, relatedDataClass, etc)
				End if 
				
			End for each 
			
		End if 
		
	End if 
	
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function handleFieldIcon
	var $0 : Object
	var $1 : Text  // dataModel key
	var $2 : Object  // field key value object
	var $3 : Boolean  // if should create icon if missing
	var $4 : Integer  // relatedTableNumber if is related field
	var $5 : Text  // parent name if is related field
	var $6 : Text  // grand parent name if is sub related field
	var $currentFile : 4D:C1709.File
	var $shouldCreateMissingIcon : Boolean
	var $field : Object
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	$shouldCreateMissingIcon:=$3
	
	If ($2.value#Null:C1517)  // direct field
		
		$field:=$2.value
		
		// For 1-N relation, set key as id
		If ($field.id=Null:C1517)
			
			$field.id:=$2.key
			
		End if 
		
	Else   // related field
		
		$field:=$2
		
		If ($field.id=Null:C1517)
			
			$field.id:=$2.name
			
		End if 
		
	End if 
	
	// Computed fields has no id
	//TODO:Remove computed
	If (String:C10($field.kind)="calculated") || (Bool:C1537($field.computed))
		
		$field.id:=$field.name
		
	End if 
	
	If ($field.id=Null:C1517)
		
		// If id is Null here, it's a path element that doesn't need an icon
		return 
		
	End if 
	
	// Get defined icon
	If ($field.icon#Null:C1517)
		
		If (Value type:C1509($field.icon)=Is text:K8:3)
			
			var $iconPath : Text
			
			$iconPath:=$field.icon
			
			If ($iconPath#"")
				
				$currentFile:=This:C1470.path.icon($iconPath)
				
				// Else : icon empty
			End if 
			
			// Else : field.icon is not Text
		End if 
		
		// Else : no icon
	End if 
	
	// Create icon if missing
	If ((Not:C34(Bool:C1537($currentFile.exists))) & ($shouldCreateMissingIcon=True:C214))
		
		var $Obj_createIcon : Object
		
		$Obj_createIcon:=This:C1470.createIconAssets($field)
		
		If ($Obj_createIcon.success)
			
			$currentFile:=$Obj_createIcon.icon
			
		Else 
			
			$0.success:=False:C215
			$0.errors.combine($Obj_createIcon.errors)
			
		End if 
		
		// Else : already handled
	End if 
	
	// Copy icon
	If (Bool:C1537($currentFile.exists))
		
		var $Obj_copy : Object
		var $newName : Text
		
		$newName:=$currentFile.name
		
		If ($4>0)  // related field
			
			var $fieldName : Text
			If ($field.name#Null:C1517)
				If ($6="")
					$fieldName:=String:C10($5)+"_"+String:C10($field.name)
				Else 
					$fieldName:=String:C10($5)+"_"+String:C10($6)+"_"+String:C10($field.name)
				End if 
			Else 
				If ($6="")
					$fieldName:=String:C10($5)+"_"+String:C10($2.aliasName)
				Else 
					$fieldName:=String:C10($5)+"_"+String:C10($6)+"_"+String:C10($2.aliasName)
				End if 
			End if 
			
			$fieldName:=cs:C1710.regex.new(Lowercase:C14($fieldName); "[^a-z0-9]").substitute("_")
			
			$newName:=Replace string:C233($newName; "qmobile_android_missing_icon"; "related_field_icon_"+$1+"_"+String:C10($4)+"_"+$fieldName)
			
		Else   // direct field
			
			$newName:=Replace string:C233($newName; "qmobile_android_missing_icon"; "field_icon_"+$1+"_"+String:C10($field.id))
			
		End if 
		
		$Obj_copy:=This:C1470.copyIcon($currentFile; $newName)
		
		If (Not:C34($Obj_copy.success))
			
			$0.success:=False:C215
			$0.errors.combine($Obj_copy.errors)
			
			// Else : all ok
		End if 
		
		// Else : already handled
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function handleActionIcon
	var $0 : Object
	var $1 : Object  // Action object
	
	var $currentFile : 4D:C1709.File
	var $action : Object
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	$action:=$1
	
	// Get defined icon
	If ($action.icon#Null:C1517)
		
		If (Value type:C1509($action.icon)=Is text:K8:3)
			
			var $iconPath : Text
			
			$iconPath:=$action.icon
			
			If ($iconPath#"")
				
				$currentFile:=This:C1470.path.icon($iconPath)
				
				// Else : icon empty
			End if 
			
			// Else : field.icon is not Text
		End if 
		
		// Else : no icon
	End if 
	
	// Copy icon
	If (Bool:C1537($currentFile.exists))
		
		var $Obj_copy : Object
		
		$Obj_copy:=This:C1470.copyIcon($currentFile; $currentFile.name)
		
		If (Not:C34($Obj_copy.success))
			
			$0.success:=False:C215
			$0.errors.combine($Obj_copy.errors)
			
			// Else : all ok
		End if 
		
		// Else : already handled
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copyIcon
	var $0 : Object
	var $1 : Object  // icon file
	var $2 : Text  // new icon name
	var $newName : Text
	var $copyDest : 4D:C1709.File
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	$newName:=This:C1470.adjustIconName($2; $1.extension)
	
	$copyDest:=$1.copyTo(This:C1470.drawableFolder; $newName; fk overwrite:K87:5)
	
	If (Not:C34($copyDest.exists))  // Copy failed
		
		$0.success:=False:C215
		$0.errors.push("Could not copy file to destination: "+$copyDest.path)
		
		// Else : all ok
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copyFormatterImage
	var $0 : Object
	var $1 : Object  // field key value object
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	
	If (Value type:C1509($1.value)=Is object:K8:27)
		
		// Check for formatter image to copy
		If ($1.value.format#Null:C1517)
			
			var $format; $formatName : Text
			var $copyDest : 4D:C1709.File
			var $copyFolderImagesToApp : Object
			
			If (Value type:C1509($1.value.format)=Is text:K8:3)
				
				$format:=$1.value.format
				
				If ($format#"")
					
					If (Substring:C12($format; 1; 1)="/")
						
						var $formattersFolder; $customFormatterFolder; $imagesFolderInFormatter : 4D:C1709.Folder
						
						$formattersFolder:=This:C1470.path.hostFormatters()
						
						If ($formattersFolder.exists)
							
							$formatName:=Substring:C12($format; 2)
							
							$customFormatterFolder:=$formattersFolder.folder($formatName)
							
							If ($customFormatterFolder.exists)
								
								$copyFolderImagesToApp:=This:C1470.copyFolderImagesToApp($customFormatterFolder; $formatName)
								
								If (Not:C34($copyFolderImagesToApp.success))
									
									$0.success:=False:C215
									$0.errors.combine($copyFolderImagesToApp.errors)
									
									// Else : all ok
								End if 
								
							Else 
								
								// Check for ZIP
								var $customFormatterZipFile : 4D:C1709.File
								
								$customFormatterZipFile:=$formattersFolder.file($formatName)
								
								If ($customFormatterZipFile.exists)
									
									var $archive : 4D:C1709.ZipArchive
									
									$archive:=ZIP Read archive:C1637($customFormatterZipFile)
									
									var $unzipDest : 4D:C1709.Folder
									
									$unzipDest:=$archive.root.copyTo($customFormatterZipFile.parent; "android_temporary_"+$customFormatterZipFile.name; fk overwrite:K87:5)
									
									If ($unzipDest.exists)
										
										$copyFolderImagesToApp:=This:C1470.copyFolderImagesToApp($unzipDest; $formatName)
										
										If (Not:C34($copyFolderImagesToApp.success))
											
											$0.success:=False:C215
											$0.errors.combine($copyFolderImagesToApp.errors)
											
											// Else : all ok
										End if 
										
										$unzipDest.delete(Delete with contents:K24:24)
										
									Else 
										// error
										$0.success:=False:C215
										$0.errors.push("Could not unzip to destination: "+$unzipDest.path)
										
									End if 
									
								Else 
									// error
									$0.success:=False:C215
									$0.errors.push("Custom formatter \""+$format+"\" couldn't be found at path: "+$customFormatterFolder.path)
								End if 
								
							End if 
							
							// Else : no formatters folder
						End if 
						
						// Else : no custom formatter
					End if 
					
					// Else : format empty
				End if 
				
				// Else : field.format is not Text
			End if 
			
			// Else : no formatter
		End if 
		
		// Checking for subFields
		
		var $subField; $copyFormatterImage : Object
		
		For each ($subField; OB Entries:C1720($1.value))  // For each subField in field
			
			If (Value type:C1509($subField)=Is object:K8:27)
				
				$copyFormatterImage:=This:C1470.copyFormatterImage($subField)
				
				If (Not:C34($copyFormatterImage.success))
					
					$0.success:=False:C215
					$0.errors.combine($copyFormatterImage.errors)
					
					// Else : all ok
				End if 
				
			End if 
			
		End for each 
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function handleInputControlImages
	var $0 : Object
	var $1 : Object  // Action object
	
	var $currentFile : 4D:C1709.File
	var $action; $parameter; $copyFolderImagesToApp : Object
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	$action:=$1
	
	If ($action.parameters#Null:C1517)
		
		If (Value type:C1509($action.parameters)=Is collection:K8:32)
			
			For each ($parameter; $action.parameters)
				
				If (Value type:C1509($parameter)=Is object:K8:27)
					
					If ($parameter.source#Null:C1517)
						
						If (Value type:C1509($parameter.source)=Is text:K8:3)
							
							var $inputControlsFolder : 4D:C1709.Folder
							
							$inputControlsFolder:=This:C1470.path.hostInputControls()
							
							If ($inputControlsFolder.exists)
								
								var $source : Text
								
								$source:=Substring:C12($parameter.source; 2)
								
								var $Obj_findFolderByManifestName : Object
								
								$Obj_findFolderByManifestName:=This:C1470.findFolderByManifestName($inputControlsFolder; $source)
								
								If ($Obj_findFolderByManifestName.folder#Null:C1517)
									
									$copyFolderImagesToApp:=This:C1470.copyFolderImagesToApp($Obj_findFolderByManifestName.folder; $source)
									
									If (Not:C34($copyFolderImagesToApp.success))
										
										$0.success:=False:C215
										$0.errors.combine($copyFolderImagesToApp.errors)
										
										// Else : all ok
									End if 
									
								Else 
									
									// Check for ZIP
									
									var $Obj_findZipByManifestName : Object
									
									$Obj_findZipByManifestName:=This:C1470.findZipByManifestName($inputControlsFolder; $source)
									
									If ($Obj_findZipByManifestName.success)
										
										If ($Obj_findZipByManifestName.folder#Null:C1517)
											
											$copyFolderImagesToApp:=This:C1470.copyFolderImagesToApp($Obj_findZipByManifestName.folder; $source)
											
											If (Not:C34($copyFolderImagesToApp.success))
												
												$0.success:=False:C215
												$0.errors.combine($copyFolderImagesToApp.errors)
												
												// Else : all ok
											End if 
											
											$Obj_findZipByManifestName.folder.delete(Delete with contents:K24:24)
											
										End if 
										
									Else 
										
										$0.success:=False:C215
										$0.errors.combine($Obj_findZipByManifestName.errors)
										
									End if 
									
								End if 
								
								// Else : no input control folder
							End if 
						End if 
						
					End if 
					
				End if 
				
			End for each 
			
		End if 
		
		// Else: no parameter
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copyFolderImagesToApp
	var $0 : Object
	var $1 : 4D:C1709.Folder  // Formatter folder
	var $2 : Text  // format name
	
	var $imagesFolderInFormatter; $copyDest : 4D:C1709.Folder
	var $imageFile : 4D:C1709.File
	var $formatName : Text
	
	$formatName:=$2
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	$imagesFolderInFormatter:=$1.folder("Images")
	
	If (Not:C34($imagesFolderInFormatter.exists))
		
		$imagesFolderInFormatter:=$1.folder("images")
		
	End if 
	
	If ($imagesFolderInFormatter.exists)
		
		For each ($imageFile; $imagesFolderInFormatter.files(fk ignore invisible:K87:22))
			
			var $correctedFormatName; $correctedImageName : Text
			
			$correctedFormatName:=cs:C1710.regex.new(Lowercase:C14($formatName); "[^a-z0-9]").substitute("_")
			$correctedImageName:=cs:C1710.regex.new(Lowercase:C14($imageFile.name); "[^a-z0-9]").substitute("_")
			
			$correctedImageName:=$correctedFormatName+"_"+$correctedImageName+$imageFile.extension
			
			$copyDest:=$imageFile.copyTo(This:C1470.drawableFolder; $correctedImageName; fk overwrite:K87:5)
			
			If (Not:C34($copyDest.exists))  // Copy failed
				
				$0.success:=False:C215
				$0.errors.push("Could not copy file to destination: "+$copyDest.path)
				
				//Else : all ok
			End if 
			
		End for each 
		
		// Else : no image to copy
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copyKotlinCustomFormatterFiles
	var $0 : Object
	var $1 : Object  // Datamodel object
	var $2 : Text  // Package name
	
	var $dataModel; $field; $handleKotlinCustomFormatterFile : Object
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	For each ($dataModel; OB Entries:C1720($1))
		
		For each ($field; OB Entries:C1720($dataModel.value))  // For each field in dataModel
			
			If ($field.key#"")
				
				$handleKotlinCustomFormatterFile:=This:C1470.handleKotlinCustomFormatterFiles($field; $2)
				
				If (Not:C34($handleKotlinCustomFormatterFile.success))
					
					$0.success:=False:C215
					$0.errors.combine($handleKotlinCustomFormatterFile.errors)
					
					// Else : all ok
				End if 
				
				// Else : table metadata
			End if 
			
		End for each 
		
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function handleKotlinCustomFormatterFiles
	var $0 : Object
	var $1 : Object  // field object
	var $2 : Text  // Package name
	
	var $packageName; $format; $formatName : Text
	$packageName:=$2
	var $field; $copyFormatterFilesToApp : Object
	var $formattersFolder; $customFormatterFolder : 4D:C1709.Folder
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	$field:=$1
	
	If (Value type:C1509($field.value)=Is object:K8:27)
		
		If ($field.value.format#Null:C1517)
			
			If (Value type:C1509($field.value.format)=Is text:K8:3)
				
				$format:=$field.value.format
				
				If ($format#"")
					
					If (Substring:C12($format; 1; 1)="/")
						
						$formattersFolder:=This:C1470.path.hostFormatters()
						
						If ($formattersFolder.exists)
							
							$formatName:=Substring:C12($format; 2)
							
							$customFormatterFolder:=$formattersFolder.folder($formatName)
							
							If ($customFormatterFolder.exists)
								
								$copyFormatterFilesToApp:=This:C1470.copyFormatterFilesToApp($customFormatterFolder; $packageName)
								
								If (Not:C34($copyFormatterFilesToApp.success))
									
									$0.success:=False:C215
									$0.errors.combine($copyFormatterFilesToApp.errors)
									
									// Else : all ok
								End if 
								
							Else 
								
								// check for ZIP
								
								var $customFormatterZipFile : 4D:C1709.File
								
								$customFormatterZipFile:=$formattersFolder.file($formatName)
								
								If ($customFormatterZipFile.exists)
									
									var $archive : 4D:C1709.ZipArchive
									
									$archive:=ZIP Read archive:C1637($customFormatterZipFile)
									
									var $unzipDest : 4D:C1709.Folder
									
									$unzipDest:=$archive.root.copyTo($customFormatterZipFile.parent; "android_temporary_"+$customFormatterZipFile.name; fk overwrite:K87:5)
									
									If ($unzipDest.exists)
										
										$copyFormatterFilesToApp:=This:C1470.copyFormatterFilesToApp($unzipDest; $packageName)
										
										If (Not:C34($copyFormatterFilesToApp.success))
											
											$0.success:=False:C215
											$0.errors.combine($copyFormatterFilesToApp.errors)
											
											// Else : all ok
										End if 
										
										$unzipDest.delete(Delete with contents:K24:24)
										
									Else 
										// error
										$0.success:=False:C215
										$0.errors.push("Could not unzip to destination: "+$unzipDest.path)
										
									End if 
									
								Else 
									// error
									$0.success:=False:C215
									$0.errors.push("Custom formatter \""+$format+"\" couldn't be found at path: "+$customFormatterFolder.path)
								End if 
								
								
							End if 
							
							// Else : no formatters folder
						End if 
						
						// Else : no custom formatter
					End if 
					
					// Else : format empty
				End if 
				
				// Else : field.format is not Text
			End if 
			
			// Else : no formatter
		End if 
		
		// Checking for subFields
		
		var $subField; $handleKotlinCustomFormatterFile : Object
		
		For each ($subField; OB Entries:C1720($field.value))  // For each subField in field
			
			If (Value type:C1509($subField)=Is object:K8:27)
				
				$handleKotlinCustomFormatterFile:=This:C1470.handleKotlinCustomFormatterFiles($subField; $2)
				
				If (Not:C34($handleKotlinCustomFormatterFile.success))
					
					$0.success:=False:C215
					$0.errors.combine($handleKotlinCustomFormatterFile.errors)
					
					// Else : all ok
				End if 
				
			End if 
			
		End for each 
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copyFormatterFilesToApp
	var $0 : Object
	var $1 : 4D:C1709.Folder  // Formatter folder
	var $2 : Text  // package name
	
	var $formattersFolderInFormatter; $bindingFolder : 4D:C1709.Folder
	var $bindingAdapterFile; $copyDest : 4D:C1709.File
	var $packageName; $packageNamePath; $fileContent : Text
	
	$packageName:=$2
	$packageNamePath:=Replace string:C233($packageName; "."; "/")
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	$formattersFolderInFormatter:=$1.folder("android/Formatters")
	
	If ($formattersFolderInFormatter.exists)
		
		For each ($bindingAdapterFile; $formattersFolderInFormatter.files(fk ignore invisible:K87:22))
			
			$bindingFolder:=Folder:C1567(This:C1470.projectPath+"app/src/main/java/"+$packageNamePath+"/binding")
			
			$copyDest:=$bindingAdapterFile.copyTo($bindingFolder; $bindingAdapterFile.fullName; fk overwrite:K87:5)
			
			If ($copyDest.exists)
				
				// replace ___PACKAGE___ in file content
				$fileContent:=$copyDest.getText()
				$fileContent:=Replace string:C233($fileContent; "___PACKAGE___"; $packageName+".binding")
				$copyDest.setText($fileContent)
				
			Else 
				// Copy failed
				$0.success:=False:C215
				$0.errors.push("Could not copy file to destination: "+$copyDest.path)
			End if 
			
		End for each 
		
		// Else : no Formatters folder inside kotlin custom data formatter
	End if 
	
	var $Obj_copyFilesRecursively : Object
	
	$Obj_copyFilesRecursively:=This:C1470.copyFilesRecursively($1.folder("android/res"); Folder:C1567(This:C1470.projectPath+"app/src/main/res"))
	
	If (Not:C34($Obj_copyFilesRecursively.success))
		
		// Copy failed
		$0.success:=False:C215
		$0.errors.combine($Obj_copyFilesRecursively.errors)
		
	End if 
	
	This:C1470.concatLocalProperties($1.folder("android").file("local.properties"); Folder:C1567(This:C1470.projectPath).file("local.properties"))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copyKotlinInputControlFiles
	var $0 : Object
	var $1 : Collection  // actions collection
	var $2 : Text  // Package name
	
	var $action; $actionParameter; $handleKotlinInputControlFile : Object
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	If ($1#Null:C1517)
		
		For each ($action; $1)
			
			If ($action.parameters#Null:C1517)
				
				If (Value type:C1509($action.parameters)=Is collection:K8:32)
					
					For each ($actionParameter; $action.parameters)
						
						$handleKotlinInputControlFile:=This:C1470.handleKotlinInputControlFiles($actionParameter; $2)
						
						If (Not:C34($handleKotlinInputControlFile.success))
							
							$0.success:=False:C215
							$0.errors.combine($handleKotlinInputControlFile.errors)
							
							// Else : all ok
						End if 
						
					End for each 
					
				End if 
				
			End if 
			
		End for each 
		
		// Else : no action
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function handleKotlinInputControlFiles
	var $0 : Object
	var $1 : Object  // action parameter object
	var $2 : Text  // Package name
	
	var $packageName; $format; $inputControlName : Text
	$packageName:=$2
	var $actionParameter; $copyInputControlFilesToApp : Object
	var $inputControlsFolder : 4D:C1709.Folder
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	$actionParameter:=$1
	
	If (Value type:C1509($actionParameter)=Is object:K8:27)
		
		If ($actionParameter.format#Null:C1517)
			
			If (Value type:C1509($actionParameter.format)=Is text:K8:3)
				
				$format:=$actionParameter.format
				
				If (($format#"") && ($actionParameter.source=Null:C1517))  // If source is not null, it's a custom input control
					
					If (Substring:C12($format; 1; 1)="/")
						
						$inputControlsFolder:=This:C1470.path.hostInputControls()
						
						If ($inputControlsFolder.exists)
							
							$inputControlName:=Substring:C12($format; 2)
							
							var $Obj_findFolderByManifestName : Object
							
							$Obj_findFolderByManifestName:=This:C1470.findFolderByManifestName($inputControlsFolder; $inputControlName)
							
							If ($Obj_findFolderByManifestName.folder#Null:C1517)
								
								$copyInputControlFilesToApp:=This:C1470.copyInputControlFilesToApp($Obj_findFolderByManifestName.folder; $packageName)
								
								If (Not:C34($copyInputControlFilesToApp.success))
									
									$0.success:=False:C215
									$0.errors.combine($copyInputControlFilesToApp.errors)
									
									// Else : all ok
								End if 
								
							Else 
								
								// Check for zip
								
								var $Obj_findZipByManifestName : Object
								
								$Obj_findZipByManifestName:=This:C1470.findZipByManifestName($inputControlsFolder; $inputControlName)
								
								If ($Obj_findZipByManifestName.success)
									
									If ($Obj_findZipByManifestName.folder#Null:C1517)
										
										$copyInputControlFilesToApp:=This:C1470.copyInputControlFilesToApp($Obj_findZipByManifestName.folder; $packageName)
										
										If (Not:C34($copyInputControlFilesToApp.success))
											
											$0.success:=False:C215
											$0.errors.combine($copyInputControlFilesToApp.errors)
											
											// Else : all ok
										End if 
										
										$Obj_findZipByManifestName.folder.delete(Delete with contents:K24:24)
										
									End if 
									
								Else 
									
									$0.success:=False:C215
									$0.errors.combine($Obj_findZipByManifestName.errors)
									
								End if 
								
							End if 
							
							// Else : no input control folder
						End if 
						
						// Else : no custom input control
					End if 
					
					// Else : format empty
				End if 
				
				// Else : actionParameter.format is not Text
			End if 
			
			// Else : no input control
		End if 
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copyInputControlFilesToApp
	var $0 : Object
	var $1 : 4D:C1709.Folder  // Input Control folder
	var $2 : Text  // package name
	
	var $inputControlFolderInFormatter; $inputControlFolder : 4D:C1709.Folder
	var $inputControlFile; $copyDest : 4D:C1709.File
	var $packageName; $packageNamePath; $fileContent : Text
	
	$packageName:=$2
	$packageNamePath:=Replace string:C233($packageName; "."; "/")
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	$inputControlFolderInFormatter:=$1.folder("android/inputControl")
	
	If ($inputControlFolderInFormatter.exists)
		
		For each ($inputControlFile; $inputControlFolderInFormatter.files(fk ignore invisible:K87:22))
			
			$inputControlFolder:=Folder:C1567(This:C1470.projectPath+"app/src/main/java/"+$packageNamePath+"/inputcontrol")
			
			$copyDest:=$inputControlFile.copyTo($inputControlFolder; $inputControlFile.fullName; fk overwrite:K87:5)
			
			If ($copyDest.exists)
				
				// replace ___PACKAGE___ in file content
				$fileContent:=$copyDest.getText()
				$fileContent:=Replace string:C233($fileContent; "___PACKAGE___"; $packageName+".inputcontrol")
				$fileContent:=Replace string:C233($fileContent; "___APP_PACKAGE___"; $packageName)
				$copyDest.setText($fileContent)
				
			Else 
				// Copy failed
				$0.success:=False:C215
				$0.errors.push("Could not copy file to destination: "+$copyDest.path)
			End if 
			
		End for each 
		
		// Else : no Input Control folder
	End if 
	
	var $Obj_copyFilesRecursively : Object
	
	$Obj_copyFilesRecursively:=This:C1470.copyFilesRecursively($1.folder("android/res"); Folder:C1567(This:C1470.projectPath+"app/src/main/res"))
	
	If (Not:C34($Obj_copyFilesRecursively.success))
		
		// Copy failed
		$0.success:=False:C215
		$0.errors.combine($Obj_copyFilesRecursively.errors)
		
	End if 
	
	This:C1470.concatLocalProperties($1.folder("android").file("local.properties"); Folder:C1567(This:C1470.projectPath).file("local.properties"))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copyCustomLoginFormFiles
	var $0 : Object
	var $1 : Text  // Login form name
	var $2 : Text  // Package name
	
	var $loginFormName; $packageName : Text
	var $copyLoginFormFilesToApp : Object
	var $customLoginFolder; $folder : 4D:C1709.Folder
	
	$packageName:=$2
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	If (String:C10($1)#"")
		
		If (Substring:C12($1; 1; 1)="/")
			
			$customLoginFolder:=This:C1470.path.hostloginForms()
			
			If ($customLoginFolder.exists)
				
				$loginFormName:=Substring:C12($1; 2)
				
				var $found : Boolean
				$found:=False:C215
				
				For each ($folder; $customLoginFolder.folders()) Until ($found)
					
					If ($folder.name=$loginFormName)
						
						$found:=True:C214
						
						$copyLoginFormFilesToApp:=This:C1470.copyLoginFormFilesToApp($folder; $packageName)
						
						If (Not:C34($copyLoginFormFilesToApp.success))
							
							$0.success:=False:C215
							$0.errors.combine($copyLoginFormFilesToApp.errors)
							
							// Else : all ok
						End if 
						
						
					End if 
					
				End for each 
				
				If (Not:C34($found))
					
					// Check for zip
					
					var $zipFile : 4D:C1709.File
					
					For each ($zipFile; $customLoginFolder.files()) Until ($found)
						
						If ($zipFile.extension=".zip")
							
							If ($zipFile.fullName=$loginFormName)
								
								$found:=True:C214
								
								var $archive : 4D:C1709.ZipArchive
								
								$archive:=ZIP Read archive:C1637($zipFile)
								
								If ($archive#Null:C1517)
									
									var $unzipDest : 4D:C1709.Folder
									
									$unzipDest:=$archive.root.copyTo($customLoginFolder; "android_temporary_"+$zipFile.name; fk overwrite:K87:5)
									
									If ($unzipDest.exists)
										
										$copyLoginFormFilesToApp:=This:C1470.copyLoginFormFilesToApp($unzipDest; $packageName)
										
										If (Not:C34($copyLoginFormFilesToApp.success))
											
											$0.success:=False:C215
											$0.errors.combine($copyLoginFormFilesToApp.errors)
											
											// Else : all ok
										End if 
										
										$unzipDest.delete(Delete with contents:K24:24)
										
									Else 
										
										$0.success:=False:C215
										$0.errors.push("Could not unzip archive. Destination does not exist "+$unzipDest.path)
										
									End if 
									
								Else 
									// not a zip archive
									$0.success:=False:C215
									$0.errors.push("Could not read archive: "+$zipFile.path)
									
								End if 
								
							End if 
							
						End if 
						
					End for each 
					
				End if 
				
				If (Not:C34($found))
					
					$0.success:=False:C215
					$0.errors.push("Could not find custom login form: "+$loginFormName)
					
				End if 
				
				// Else : no custom login folder
			End if 
			
			// Else : no custom login form
		End if 
		
		// Else : no custom login form
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copyLoginFormFilesToApp
	var $0 : Object
	var $1 : 4D:C1709.Folder  // Custom login form folder
	var $2 : Text  // package name
	
	var $formFolderInCustomLoginForms; $loginFormFolder : 4D:C1709.Folder
	var $loginFormFile; $copyDest : 4D:C1709.File
	var $packageName; $packageNamePath; $fileContent : Text
	
	$packageName:=$2
	$packageNamePath:=Replace string:C233($packageName; "."; "/")
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	$formFolderInCustomLoginForms:=$1.folder("android/login")
	
	If ($formFolderInCustomLoginForms.exists)
		
		For each ($loginFormFile; $formFolderInCustomLoginForms.files(fk ignore invisible:K87:22))
			
			$loginFormFolder:=Folder:C1567(This:C1470.projectPath+"app/src/main/java/"+$packageNamePath+"/login")
			
			$copyDest:=$loginFormFile.copyTo($loginFormFolder; $loginFormFile.fullName; fk overwrite:K87:5)
			
			If ($copyDest.exists)
				
				// replace ___PACKAGE___ in file content
				$fileContent:=$copyDest.getText()
				$fileContent:=Replace string:C233($fileContent; "___PACKAGE___"; $packageName+".login")
				$fileContent:=Replace string:C233($fileContent; "___APP_PACKAGE___"; $packageName)
				$copyDest.setText($fileContent)
				
			Else 
				// Copy failed
				$0.success:=False:C215
				$0.errors.push("Could not copy file to destination: "+$copyDest.path)
			End if 
			
		End for each 
		
		// Else : no login form folder
	End if 
	
	var $Obj_copyFilesRecursively : Object
	
	$Obj_copyFilesRecursively:=This:C1470.copyFilesRecursively($1.folder("android/res"); Folder:C1567(This:C1470.projectPath+"app/src/main/res"))
	
	If (Not:C34($Obj_copyFilesRecursively.success))
		
		// Copy failed
		$0.success:=False:C215
		$0.errors.combine($Obj_copyFilesRecursively.errors)
		
	End if 
	
	This:C1470.concatLocalProperties($1.folder("android").file("local.properties"); Folder:C1567(This:C1470.projectPath).file("local.properties"))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function concatLocalProperties($newFile : 4D:C1709.File; $oldFile : 4D:C1709.File)->$result : Object
	
	$result:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	If ($newFile.exists && $oldFile.exists)
		
		var $newFileContent; $oldFileContent : Text
		$newFileContent:=$newFile.getText()
		$oldFileContent:=$oldFile.getText()
		
		$oldFileContent:=$oldFileContent+Char:C90(Carriage return:K15:38)+$newFileContent
		$oldFile.setText($oldFileContent)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copyFilesRecursively($entry : 4D:C1709.Folder; $target : 4D:C1709.Folder)->$result : Object
	
	$result:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	If ($entry.exists)
		
		var $file; $fileCopyDest : 4D:C1709.File
		
		For each ($file; $entry.files(fk ignore invisible:K87:22))
			
			var $shouldCopy : Boolean
			$shouldCopy:=True:C214
			
			If (($target.file($file.fullName).exists) && ($file.extension=".xml") && ($file.parent.name="values"))
				
				var $Obj_concat : Object
				
				$Obj_concat:=This:C1470.concatResourceFile($file; $target.file($file.fullName))
				
				$shouldCopy:=Not:C34($Obj_concat.success)
				
			End if 
			
			If ($shouldCopy)
				
				$fileCopyDest:=$file.copyTo($target; fk overwrite:K87:5)
				
				If (Not:C34($fileCopyDest.exists))
					
					$result.success:=False:C215
					$result.errors.push("Could not copy kotlin custom formatter resource file to destination: "+$fileCopyDest.path)
					
				End if 
				
			End if 
			
		End for each 
		
		var $folder; $newTargetFolder : 4D:C1709.Folder
		var $Obj_copyFilesRecursively : Object
		
		For each ($folder; $entry.folders(fk ignore invisible:K87:22))
			
			$newTargetFolder:=$target.folder($folder.name)
			$newTargetFolder.create()
			
			$Obj_copyFilesRecursively:=This:C1470.copyFilesRecursively($folder; $newTargetFolder)
			
			If (Not:C34($Obj_copyFilesRecursively.success))
				
				break
				
			End if 
			
		End for each 
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function concatResourceFile
	var $0 : Object
	var $1 : 4D:C1709.File  // new .xml file
	var $2 : 4D:C1709.File  // old .xml file
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	If (Not:C34($1.exists) || Not:C34($2.exists))
		return 
	End if 
	
	var $newFile; $oldFile : 4D:C1709.File
	$newFile:=$1
	$oldFile:=$2
	
	var $newFileContent; $oldFileContent : Text
	$newFileContent:=$newFile.getText()
	$oldFileContent:=$oldFile.getText()
	
	var $startResourceKey; $endResourceKey : Text
	$startResourceKey:="<resources>"
	$endResourceKey:="</resources>"
	
	If ((Position:C15($startResourceKey; $newFileContent)=0) || (Position:C15($endResourceKey; $newFileContent)=0))
		$0.success:=False:C215
		return 
	End if 
	
	If ((Position:C15($startResourceKey; $oldFileContent)=0) || (Position:C15($endResourceKey; $oldFileContent)=0))
		$0.success:=False:C215
		return 
	End if 
	
	var $startPos; $endPos : Integer
	$startPos:=Position:C15($startResourceKey; $newFileContent)+Length:C16($startResourceKey)
	$endPos:=Position:C15($endResourceKey; $newFileContent)
	
	$newFileContent:=Substring:C12($newFileContent; $startPos; $endPos-$startPos)
	
	var $anchorPos : Integer
	$anchorPos:=Position:C15($endResourceKey; $oldFileContent)
	$oldFileContent:=Insert string:C231($oldFileContent; $newFileContent+Char:C90(Carriage return:K15:38); $anchorPos)
	$oldFile.setText($oldFileContent)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function findFolderByManifestName
	var $0 : Object
	var $1 : 4D:C1709.Folder  // folder to browse
	var $2 : Text  // name value to be found in manifest.json file
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	var $folder : 4D:C1709.Folder
	
	var $found : Boolean
	
	$found:=False:C215
	
	If ($1#Null:C1517)
		
		If ($1.exists)
			
			For each ($folder; $1.folders()) Until ($found)
				
				var $file : 4D:C1709.File
				
				For each ($file; $folder.files()) Until ($found)
					
					If ($file.fullName="manifest.json")
						
						var $manifestContent : Object
						
						$manifestContent:=JSON Parse:C1218($file.getText())
						
						If ($manifestContent.name#Null:C1517)
							
							If (Value type:C1509($manifestContent.name)=Is text:K8:3)
								
								If ($manifestContent.name=$2)
									
									$found:=True:C214
									
									If ($1.folder($folder.name).exists)
										
										$0.success:=True:C214
										$0.folder:=$1.folder($folder.name)
										
									End if 
									
								End if 
								
							End if 
							
						End if 
						
					End if 
					
				End for each 
				
			End for each 
			
		End if 
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function findZipByManifestName
	var $0 : Object  // returns unzipped destination folder
	var $1 : 4D:C1709.Folder  // folder to browse
	var $2 : Text  // name value to be found in manifest.json file
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	var $file : 4D:C1709.File
	
	var $found : Boolean
	
	$found:=False:C215
	
	If ($1#Null:C1517)
		
		If ($1.exists)
			
			For each ($file; $1.files()) Until ($found)
				
				If ($file.extension=".zip")
					
					var $archive : 4D:C1709.ZipArchive
					
					$archive:=ZIP Read archive:C1637($file)
					
					If ($archive#Null:C1517)
						
						var $unzipDest : 4D:C1709.Folder
						
						$unzipDest:=$archive.root.copyTo($1; "android_temporary_"+$file.name; fk overwrite:K87:5)
						
						If ($unzipDest.exists)
							
							var $isTargetZip : Boolean
							
							$isTargetZip:=False:C215
							
							var $archiveChild : 4D:C1709.File
							
							For each ($archiveChild; $unzipDest.files())
								
								If ($archiveChild.fullName="manifest.json")
									
									var $manifestContent : Object
									
									$manifestContent:=JSON Parse:C1218($archiveChild.getText())
									
									If (Value type:C1509($manifestContent.name)=Is text:K8:3)
										
										If ($manifestContent.name=$2)
											
											$found:=True:C214
											$isTargetZip:=True:C214
											$0.success:=True:C214
											$0.folder:=$unzipDest
											
										End if 
										
									End if 
									
								End if 
								
							End for each 
							
							If (Not:C34($isTargetZip))
								
								$unzipDest.delete(Delete with contents:K24:24)
								
								// Else: will be deleted in calling function
							End if 
							
						End if 
						
						// Else : not a zip archive
					End if 
					
				End if 
				
			End for each 
			
		End if 
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function adjustIconName
	var $0 : Text
	var $1 : Text  // File name
	var $2 : Text  // File extension
	var $newName : Text
	
	$newName:=cs:C1710.regex.new(Lowercase:C14($1); "[^a-z0-9]").substitute("_")
	$0:=$newName+$2
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function createIconAssets
	var $0 : Object
	var $1 : Object  // Table or Field or Action object metadata or related field
	
	$0:=New object:C1471(\
		"icon"; New object:C1471; \
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	// Generate asset using first table letter
	var $file : 4D:C1709.File
	$file:=File:C1566("/RESOURCES/images/missingIcon.svg")
	
	var $svg : cs:C1710.svg
	$svg:=cs:C1710.svg.new($file)
	
	If (Asserted:C1132($svg.success; "Failed to parse: "+$file.path))
		
		var $t : Text
		
		Case of 
				
			: ($1.shortLabel#"")
				
				$t:=$1.shortLabel
				
			: ($1.label#"")
				
				$t:=$1.label
				
			Else 
				//%W-533.1
				$t:=$1.name  // 4D table names are not empty
				//%W+533.1
		End case 
		
		
		// Take first letter
		$t:=Uppercase:C13($t[[1]])
		
		$svg.setValue($t; $svg.findByXPath("/svg/textArea"))
		
		$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file("qmobile_android_missing_icon.svg")
		$file.delete()
		
		$svg.exportText($file)
		
		If ($file.exists)
			
			var $source : Text
			$source:=$file.platformPath
			
			var $Pic_buffer : Picture
			READ PICTURE FILE:C678($source; $Pic_buffer)
			
			If (OK=1)
				
				var $Pic_icon : Picture
				CREATE THUMBNAIL:C679($Pic_buffer; $Pic_icon; 32; 32; Scaled to fit:K6:2)
				
				If (OK=1)
					
					var $newFile : 4D:C1709.File
					$newFile:=$file.parent.file($file.name+".png")
					$newFile.delete()
					
					WRITE PICTURE FILE:C680($newFile.platformPath; $Pic_icon; ".png")
					
					If (OK=0)
						
						$0.errors.push("Failed to write picture "+$newFile.path)
						
					Else 
						
						If ($newFile.exists)
							
							$0.success:=True:C214
							$0.icon:=$newFile
							
						Else 
							
							$0.errors.push("Failed to create file "+$newFile.path)
							
						End if 
						
					End if 
					
				Else 
					
					$0.errors.push("Failed to create thumbnail for "+$file.path)
					
				End if 
				
			Else 
				
				$0.errors.push("Failed to read picture : "+$file.path)
				
			End if 
			
		Else 
			
			$0.errors.push("Could not create icon asset : "+$file.path)
			
		End if 
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function chmod
	var $0 : Object
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	This:C1470.launch(This:C1470.chmodCmd+" +x "+This:C1470.singleQuoted(This:C1470.projectPath+"gradlew"))
	
	$0.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
	
	If (Not:C34($0.success))
		
		$0.errors.push("Failed chmod command")
		
		// Else : all ok
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function prepareSdk
	var $0 : Object
	var $cacheSdkAndroid : 4D:C1709.File
	var $archive : 4D:C1709.ZipArchive
	var $unzipDest : 4D:C1709.Folder
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$cacheSdkAndroid:=This:C1470.path.sdkAndroid()
	
	If ($cacheSdkAndroid.exists)
		
		$archive:=ZIP Read archive:C1637($cacheSdkAndroid)
		
		$unzipDest:=$archive.root.copyTo(This:C1470.path.cacheSdkAndroid().parent; fk overwrite:K87:5)  // CLEAN: use cacheSdkAndroidUnzipped? without creating "sdk"?
		
		If ($unzipDest.exists)
			
			$0.success:=True:C214
			
		Else 
			
			$0.errors.push("Could not unzip to destination: "+$unzipDest.path)
			
		End if 
		
	Else 
		// Missing sdk archive
		$0.errors.push("Missing 4D Mobile SDK archive: "+$cacheSdkAndroid.path)
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copySdkVersion()->$result : Object
	var $sdkVersion; $copyDest : 4D:C1709.File
	var $unzippedSdk : 4D:C1709.Folder
	
	If (Feature.with("buildWithCmd") && Bool:C1537(This:C1470.input.noSDK))
		Folder:C1567(This:C1470.projectPath+"app/src/main/assets").file("sdkVersion").setText(String:C10(This:C1470.input.sdkVersion))
		$result:=New object:C1471("success"; This:C1470.input.sdkVersion#Null:C1517)
		return 
	End if 
	
	$result:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$unzippedSdk:=This:C1470.path.cacheSdkAndroidUnzipped()
	
	If (Not:C34($unzippedSdk.exists))
		This:C1470.prepareSdk()
	End if 
	
	If (Not:C34($unzippedSdk.exists))  // Missing unzipped sdk
		$result.errors.push("Could not find unzipped sdk folder at destination: "+$unzippedSdk.path)
		return 
	End if 
	
	$sdkVersion:=$unzippedSdk.file("sdkVersion")
	
	If (Not:C34($sdkVersion.exists))  // Missing sdkVersion file
		$result.errors.push("Could not find sdkVersion file at destination: "+$sdkVersion.path)
		return 
	End if 
	
	var $cacheSdkAndroid; $archive : Object
	$cacheSdkAndroid:=This:C1470.path.sdkAndroid()
	If ($cacheSdkAndroid.exists)
		$archive:=ZIP Read archive:C1637($cacheSdkAndroid)
		
		If (($archive.root.file("sdkVersion").exists) && ($archive.root.file("sdkVersion").getText()#$sdkVersion.getText()))
			
			$unzippedSdk.delete(Delete with contents:K24:24)
			This:C1470.prepareSdk()
			
		End if 
	End if 
	
	$copyDest:=$sdkVersion.copyTo(Folder:C1567(This:C1470.projectPath+"app/src/main/assets"); fk overwrite:K87:5)
	
	If (Not:C34($copyDest.exists))  // Copy failed
		$result.errors.push("Could not copy sdkVersion file to destination: "+$copyDest.path)
		return 
	End if 
	
	$result.success:=True:C214
	
Function copySDKIfNeeded()
	
	var $unzippedSdk : 4D:C1709.Folder
	$unzippedSdk:=This:C1470.path.cacheSdkAndroidUnzipped()
	
	If (Not:C34($unzippedSdk.exists))
		This:C1470.prepareSdk()
	End if 
	
	
	
	