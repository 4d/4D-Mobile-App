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
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function generate
	var $0 : Object
	var $1 : 4D:C1709.File  // project editor json
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"outputStream"; ""; \
		"errorStream"; ""; \
		"errors"; New collection:C1472)
	
	
	If ((This:C1470.path.androidProjectFilesToCopy().exists)\
		 & (This:C1470.path.androidProjectTemplateFiles().exists)\
		 & (This:C1470.path.androidForms().exists))
		
		If (This:C1470.path.scripts().exists)
			
			This:C1470.setDirectory(This:C1470.path.scripts())
			
			This:C1470.launch(This:C1470.androidprojectgeneratorCmd\
				+" generate"\
				+" --project-editor \""+$1.path\
				+"\" --files-to-copy \""+This:C1470.path.androidProjectFilesToCopy().path\
				+"\" --template-files \""+This:C1470.path.androidProjectTemplateFiles().path\
				+"\" --template-forms \""+This:C1470.path.androidForms().path\
				+"\" --host-db \""+This:C1470.path.host().path\
				+"\"")
			
			var $exceptionPos; $errorPos : Integer
			
			$exceptionPos:=Position:C15("Exception"; String:C10(This:C1470.errorStream))
			$errorPos:=Position:C15("Error"; String:C10(This:C1470.errorStream))
			
			If ($exceptionPos>0)
				// Removes illegal capsule access warnings
				This:C1470.errorStream:=Substring:C12(This:C1470.errorStream; $exceptionPos)
			End if 
			
			$0.success:=Not:C34(($exceptionPos>0) | ($errorPos>0))
			$0.outputStream:=This:C1470.outputStream
			$0.errorStream:=This:C1470.errorStream
			
			If (Not:C34($0.success))
				
				$0.errors.push("Failed to generate files")
				$0.errors.push(This:C1470.errorStream)
				
				// Else : all ok
			End if 
			
		Else 
			
			$0.errors.push("Missing scripts directory")
			
		End if 
		
	Else 
		
		$0.errors.push("Missing directories for project templating")
		
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
Function copyResources
	var $0 : Object
	var $1 : 4D:C1709.Folder  // 4D Mobile Project
	var $androidAssets; $currentFolder : 4D:C1709.Folder
	var $currentFile; $copyDest : 4D:C1709.File
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	// Copy "android" resources
	$androidAssets:=$1.folder("android")
	
	If ($androidAssets.exists)
		
		$0.success:=True:C214
		
		For each ($currentFolder; $androidAssets.folders())
			
			For each ($currentFile; $currentFolder.files())
				
				If ($currentFolder.name="main")
					
					// for Play Store
					$copyDest:=$currentFile.copyTo(Folder:C1567(This:C1470.projectPath+"app/src/main"); fk overwrite:K87:5)
					
				Else 
					
					// for API > 25
					$copyDest:=$currentFile.copyTo(Folder:C1567(This:C1470.projectPath+"app/src/main/res/"+$currentFolder.name); fk overwrite:K87:5)
					
					// for API 25
					$copyDest:=$currentFile.copyTo(Folder:C1567(This:C1470.projectPath+"app/src/main/res/"+$currentFolder.name); "ic_launcher_round.png"; fk overwrite:K87:5)
					
					// for API < 25
					$copyDest:=$currentFile.copyTo(Folder:C1567(This:C1470.projectPath+"app/src/main/res/"+$currentFolder.name); "ic_launcher.png"; fk overwrite:K87:5)
					
					If ($currentFolder.name="mipmap-xxxhdpi")
						
						// for login form, splash screen
						$copyDest:=$currentFile.copyTo(Folder:C1567(This:C1470.projectPath+"app/src/main/res/drawable"); "logo.png"; fk overwrite:K87:5)
						
					End if 
					
				End if 
				
				If (Not:C34($copyDest.exists))
					// Copy failed
					$0.success:=False:C215
					$0.errors.push("Could not copy file to destination: "+$copyDest.path)
					
					//Else : all ok
				End if 
				
			End for each 
			
		End for each 
		
	Else 
		// Missing Android folder
		$0.errors.push("Missing source file for copy: "+$androidAssets.path)
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
	var $2 : Collection  // Actions collection
	
	var $tableIcons : 4D:C1709.Folder
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$tableIcons:=This:C1470.path.tableIcons()
	
	If ($tableIcons.exists)
		
		$0.success:=True:C214
		
		var $dataModel; $field : Object
		
		For each ($dataModel; OB Entries:C1720($1))
			
			// Check for table image
			var $Obj_handleDataModelIcon : Object
			
			$Obj_handleDataModelIcon:=This:C1470.handleDataModelIcon($dataModel)
			
			If (Not:C34($Obj_handleDataModelIcon.success))
				
				$0.success:=False:C215
				$0.errors.combine($Obj_handleDataModelIcon.errors)
				
				// Else : all ok
			End if 
			
			
			var $shouldCreateMissingIcon : Boolean
			
			$shouldCreateMissingIcon:=This:C1470.willRequireFieldIcons($dataModel)
			
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
					
					$Obj_handleField:=This:C1470.handleField($dataModel.key; $field; $shouldCreateMissingIcon)
					
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
		If ($2#Null:C1517)
			
			var $shouldCreateMissingActionIcon : Boolean
			
			$shouldCreateMissingActionIcon:=This:C1470.willRequireActionIcons($2)
			
			var $action : Object
			
			For each ($action; $2)
				
				// Check for action icon
				var $Obj_handleAction : Object
				
				$Obj_handleAction:=This:C1470.handleActionIcon($action; $shouldCreateMissingActionIcon)
				
				If (Not:C34($Obj_handleAction.success))
					
					$0.success:=False:C215
					$0.errors.combine($Obj_handleAction.errors)
					
					// Else : all ok
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
	var $field : Object
	
	$0:=False:C215
	
	For each ($field; OB Entries:C1720($1.value))  // For each field in dataModel
		
		If ($field.key#"")
			
			If ($field.value.icon#Null:C1517)
				
				If (Value type:C1509($field.value.icon)=Is text:K8:3)
					
					If ($field.value.icon#"")
						
						$0:=True:C214
						
					End if 
					
				End if 
				
			End if 
			
			// check in related fields
			If ($field.value.relatedDataClass#Null:C1517)
				
				var $relatedField : Object
				
				For each ($relatedField; OB Entries:C1720($field.value))  // For each field in related table
					
					If (Value type:C1509($relatedField.value)=Is object:K8:27)
						
						If ($relatedField.value.icon#Null:C1517)
							
							If (Value type:C1509($relatedField.value.icon)=Is text:K8:3)
								
								If ($relatedField.value.icon#"")
									
									$0:=True:C214
									
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
Function willRequireActionIcons
	var $0 : Boolean
	var $1 : Collection  // actions collection
	var $action : Object
	
	$0:=False:C215
	
	For each ($action; $1)  // For each action
		
		If ($action.icon#Null:C1517)
			
			If (Value type:C1509($action.icon)=Is text:K8:3)
				
				If ($action.icon#"")
					
					$0:=True:C214
					
				End if 
				
			End if 
			
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
	
	$Obj_handleFieldIcon:=This:C1470.handleFieldIcon($1; $2; $3; -1)
	
	If (Not:C34($Obj_handleFieldIcon.success))
		
		$0.success:=False:C215
		$0.errors:=$Obj_handleFieldIcon.errors
		
		// Else : all ok
	End if 
	
	$isRelation:=($2.value.relatedDataClass#Null:C1517)
	
	If ($isRelation)  // related field
		
		var $relatedField : Object
		
		For each ($relatedField; OB Entries:C1720($2.value))  // For each field in related table
			
			If (Value type:C1509($relatedField.value)=Is object:K8:27)
				
				If ($relatedField.value.name#Null:C1517)  // can be a sub field or a sub 1->N relation (ignore sub N->1 relation)
					
					$Obj_handleFieldIcon:=This:C1470.handleFieldIcon($1; $relatedField.value; $3; $2.value.relatedTableNumber)
					
					If (Not:C34($Obj_handleFieldIcon.success))
						
						$0.success:=False:C215
						$0.errors.combine($Obj_handleFieldIcon.errors)
						
						// Else : all ok
					End if 
					
					// Else : not a sub field (can be inverseName, relatedTableNumber, relatedDataClass, etc)
				End if 
				
			End if 
			
		End for each 
		
	End if 
	
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function handleFieldIcon
	var $0 : Object
	var $1 : Text  // dataModel key
	var $2 : Object  // field key value object
	var $3 : Boolean  // if should create icon if missing
	var $4 : Integer  // relatedTableNumber if is related field
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
		
		// For 1-N relation, set name as id
		If ($field.id=Null:C1517)
			
			$field.id:=$2.name
			
		End if 
		
	End if 
	
	// Computed fields has no id
	If (Bool:C1537($field.computed))
		
		$field.id:=$field.name
		
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
			
			$newName:=Replace string:C233($newName; "qmobile_android_missing_icon"; "related_field_icon_"+$1+"_"+String:C10($4)+"_"+String:C10($field.id))
			
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
	var $2 : Boolean  // if should create icon if missing
	
	var $currentFile : 4D:C1709.File
	var $shouldCreateMissingActionIcon : Boolean
	var $action : Object
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	$action:=$1
	$shouldCreateMissingActionIcon:=$2
	
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
	
	// Create icon if missing
	If ((Not:C34(Bool:C1537($currentFile.exists))) & ($shouldCreateMissingActionIcon=True:C214))
		
		var $Obj_createIcon : Object
		
		$Obj_createIcon:=This:C1470.createIconAssets($action)
		
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
		
		$newName:=Replace string:C233($newName; "qmobile_android_missing_icon"; "action_icon_"+String:C10($action.name))
		
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
	
	// Check for formatter image to copy
	If ($1.value.format#Null:C1517)
		
		var $format; $formatName : Text
		var $copyDest : 4D:C1709.File
		var $copyFormatterImagesToApp : Object
		
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
							
							$copyFormatterImagesToApp:=This:C1470.copyFormatterImagesToApp($customFormatterFolder; $formatName)
							
							If (Not:C34($copyFormatterImagesToApp.success))
								
								$0.success:=False:C215
								$0.errors.combine($copyFormatterImagesToApp.errors)
								
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
									
									$copyFormatterImagesToApp:=This:C1470.copyFormatterImagesToApp($unzipDest; $formatName)
									
									If (Not:C34($copyFormatterImagesToApp.success))
										
										$0.success:=False:C215
										$0.errors.combine($copyFormatterImagesToApp.errors)
										
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
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copyFormatterImagesToApp
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
	
	If ($imagesFolderInFormatter.exists)
		
		For each ($imageFile; $imagesFolderInFormatter.files(fk ignore invisible:K87:22))
			
			var $correctedFormatName; $correctedImageName : Text
			
			$correctedFormatName:=Lowercase:C14($formatName)
			Rgx_SubstituteText("[^a-z0-9]"; "_"; ->$correctedFormatName; 0)
			
			$correctedImageName:=Lowercase:C14($imageFile.name)
			Rgx_SubstituteText("[^a-z0-9]"; "_"; ->$correctedImageName; 0)
			
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
	
	var $packageName; $packageNamePath; $format; $formatName; $fileContent : Text
	$packageName:=$2
	var $dataModel; $field; $copyFormatterFilesToApp : Object
	var $bindingAdapterFile; $copyDest : 4D:C1709.File
	var $bindingFolder; $formattersFolder; $customFormatterFolder; $formattersFolderInFormatter : 4D:C1709.Folder
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	For each ($dataModel; OB Entries:C1720($1))
		
		For each ($field; OB Entries:C1720($dataModel.value))  // For each field in dataModel
			
			If ($field.key#"")
				
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
				
				// Else : table metadata
			End if 
			
		End for each 
		
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copyFormatterFilesToApp
	var $0 : Object
	var $1 : 4D:C1709.Folder  // Formatter folder
	var $2 : Text  // package name
	
	var $formattersFolderInFormatter; $bindingFolder; $resInFormatter; $mainFolder; $resCopyDest : 4D:C1709.Folder
	var $bindingAdapterFile; $copyDest; $res : 4D:C1709.File
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
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copyFilesRecursively($entry : 4D:C1709.Folder; $target : 4D:C1709.Folder)->$result : Object
	
	$result:=New object:C1471(\
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
	If ($entry.exists)
		
		var $file; $fileCopyDest : 4D:C1709.File
		
		For each ($file; $entry.files(fk ignore invisible:K87:22))
			
			$fileCopyDest:=$file.copyTo($target; fk overwrite:K87:5)
			
			If (Not:C34($fileCopyDest.exists))
				
				$result.success:=False:C215
				$result.errors.push("Could not copy kotlin custom formatter resource file to destination: "+$fileCopyDest.path)
				
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
Function adjustIconName
	var $0 : Text
	var $1 : Text  // File name
	var $2 : Text  // File extension
	var $newName : Text
	
	$newName:=Lowercase:C14($1)
	Rgx_SubstituteText("[^a-z0-9]"; "_"; ->$newName; 0)
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
	$file:=File:C1566("/RESOURCES/Images/missingIcon.svg")
	
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
	
	This:C1470.launch(This:C1470.chmodCmd+" +x "+This:C1470.singleQuoted(This:C1470.projectPath+"gradlew")+" "+This:C1470.singleQuoted(This:C1470.kotlinc))
	
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
	
	$cacheSdkAndroid:=This:C1470.path.cacheSdkAndroid()
	
	If ($cacheSdkAndroid.exists)
		
		$archive:=ZIP Read archive:C1637($cacheSdkAndroid)
		
		$unzipDest:=$archive.root.copyTo($cacheSdkAndroid.parent; fk overwrite:K87:5)
		
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
Function copySdkVersion
	var $0 : Object
	var $sdkVersion; $copyDest : 4D:C1709.File
	var $unzippedSdk : 4D:C1709.Folder
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$unzippedSdk:=This:C1470.path.cacheSdkAndroid().parent.folder("sdk")
	
	If ($unzippedSdk.exists)
		
		$sdkVersion:=$unzippedSdk.file("sdkVersion")
		
		If ($sdkVersion.exists)
			
			$copyDest:=$sdkVersion.copyTo(Folder:C1567(This:C1470.projectPath+"app/src/main/assets"); fk overwrite:K87:5)
			
			If ($copyDest.exists)
				
				$0.success:=True:C214
				
			Else 
				
				// Copy failed
				$0.errors.push("Could not copy sdkVersion file to destination: "+$copyDest.path)
				
			End if 
			
		Else 
			// Missing sdkVersion file
			$0.errors.push("Could not find sdkVersion file at destination: "+$sdkVersion.path)
			
		End if 
		
	Else 
		// Missing unzipped sdk
		$0.errors.push("Could not find unzipped sdk folder at destination: "+$unzippedSdk.path)
	End if 