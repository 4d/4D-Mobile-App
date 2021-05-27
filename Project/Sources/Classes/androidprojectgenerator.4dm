Class extends androidProcess

Class constructor($java : 4D:C1709.File; $kotlinc : 4D:C1709.File)
	
	Super:C1705()
	
	This:C1470.androidprojectgeneratorCmd:="\""+$java.path+"\" -jar androidprojectgenerator.jar"
	This:C1470.kotlinc:=$kotlinc.path
	This:C1470.chmodCmd:="chmod"
	
	This:C1470.path:=cs:C1710.path.new()
	This:C1470.vdtool:=cs:C1710.vdtool.new()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function generate
	var $0 : Object
	var $1 : 4D:C1709.File  // project editor json
	
	$0:=New object:C1471(\
		"success"; False:C215; \
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
			
			$0.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
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
	var $1 : Text  // Project path
	var $2 : Text  // package name (app name)
	var $staticDataInitializerFile; $targetFile : 4D:C1709.File
	var $libFolder : 4D:C1709.Folder
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$staticDataInitializerFile:=File:C1566($1+"buildSrc/src/main/java/"+$2+".android.build/database/StaticDataInitializer.kt")
	
	If ($staticDataInitializerFile.exists)
		
		$libFolder:=Folder:C1567($1+"buildSrc/libs")
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
	var $1 : Text  // Project path
	var $copySrc; $copyDest : 4D:C1709.File
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$copySrc:=File:C1566($1+"buildSrc/libs/prepopulation.jar")
	
	If ($copySrc.exists)
		
		$copyDest:=$copySrc.copyTo(Folder:C1567($1+"app/libs"); fk overwrite:K87:5)
		
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
	var $1 : Text  // Project path
	var $2 : 4D:C1709.File  // 4D Mobile Project
	var $androidAssets; $currentFolder : 4D:C1709.Folder
	var $currentFile; $copyDest : 4D:C1709.File
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	// Copy "android" resources
	$androidAssets:=$2.folder("android")
	
	If ($androidAssets.exists)
		
		$0.success:=True:C214
		
		For each ($currentFolder; $androidAssets.folders())
			
			For each ($currentFile; $currentFolder.files())
				
				If ($currentFolder.name="main")
					
					// for Play Store
					$copyDest:=$currentFile.copyTo(Folder:C1567($1+"app/src/main"); fk overwrite:K87:5)
					
				Else 
					
					// for API > 25
					$copyDest:=$currentFile.copyTo(Folder:C1567($1+"app/src/main/res/"+$currentFolder.name); fk overwrite:K87:5)
					
					// for API 25
					$copyDest:=$currentFile.copyTo(Folder:C1567($1+"app/src/main/res/"+$currentFolder.name); "ic_launcher_round.png"; fk overwrite:K87:5)
					
					// for API < 25
					$copyDest:=$currentFile.copyTo(Folder:C1567($1+"app/src/main/res/"+$currentFolder.name); "ic_launcher.png"; fk overwrite:K87:5)
					
					If ($currentFolder.name="mipmap-xxxhdpi")
						
						// for login form, splash screen
						$copyDest:=$currentFile.copyTo(Folder:C1567($1+"app/src/main/res/drawable"); "logo.png"; fk overwrite:K87:5)
						
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
	var $1 : Text  // Project path
	var $2 : 4D:C1709.File  // 4D Mobile Project
	var $xcassets; $copyDest : 4D:C1709.Folder
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	// Copy dataSet resources
	$xcassets:=$2.folder("project.dataSet/Resources/Assets.xcassets")
	
	If ($xcassets.exists)
		
		$copyDest:=$xcassets.copyTo(Folder:C1567($1+"app/src/main/assets"); fk overwrite:K87:5)
		
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
Function copyIcons
	var $0 : Object
	var $1 : Text  // Project path
	var $2 : Object  // Datamodel object
	
	var $tableIcons; $drawableFolder : 4D:C1709.Folder
	var $currentFile; $copyDest; $drawable : 4D:C1709.File
	var $iconPath; $newName : Text
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$tableIcons:=This:C1470.path.tableIcons()
	$drawableFolder:=Folder:C1567($1+"app/src/main/res/drawable")
	
	If ($tableIcons.exists)
		
		$0.success:=True:C214
		
		var $dataModel; $field : Object
		
		For each ($dataModel; OB Entries:C1720($2))
			
			$currentFile:=Null:C1517
			
			If (OB Is defined:C1231($dataModel.value[""]; "icon"))
				
				$iconPath:=$dataModel.value[""].icon
				
				If ($iconPath#"")
					
					$currentFile:=This:C1470.path.icon($iconPath)
					
				End if 
				
			End if 
			
			
			If (Not:C34(Bool:C1537($currentFile.exists)))
				
				var $Obj_createIcon : Object
				
				$Obj_createIcon:=This:C1470.createIconAssets($dataModel.value[""])
				
				If ($Obj_createIcon.success)
					
					$currentFile:=$Obj_createIcon.icon
					
				Else 
					
					$0.success:=False:C215
					$0.errors.combine($Obj_createIcon.errors)
					
				End if 
				
			End if 
			
			If (Bool:C1537($currentFile.exists))
				
				$newName:=Replace string:C233($currentFile.name; "qmobile_android_missing_nav_icon"; "nav_icon_"+$dataModel.key)
				
				$newName:=Lowercase:C14($newName)
				Rgx_SubstituteText("[^a-z0-9]"; "_"; ->$newName; 0)
				$newName:=$newName+$currentFile.extension
				
				$copyDest:=$currentFile.copyTo($drawableFolder; $newName; fk overwrite:K87:5)
				
				If (Not:C34($copyDest.exists))  // Copy failed
					
					$0.success:=False:C215
					$0.errors.push("Could not copy file to destination: "+$copyDest.path)
					
					//Else : all ok
				End if 
				
				// Else : already handled
			End if 
			
			var $field : Object
			
			// Check for formatter image to copy
			For each ($field; OB Entries:C1720($dataModel.value))
				
				If (OB Is defined:C1231($field.value; "format"))
					
					var $format; $formatName : Text
					
					$format:=$field.value.format
					
					If (Length:C16($format)>0)
						
						If (Substring:C12($format; 1; 1)="/")
							
							var $formattersFolder; $customFormatterFolder; $imagesFolderInFormatter : 4D:C1709.Folder
							
							$formattersFolder:=This:C1470.path.hostFormatters()
							
							If ($formattersFolder.exists)
								
								$formatName:=Substring:C12($format; 2)
								
								$customFormatterFolder:=$formattersFolder.folder($formatName)
								
								If ($customFormatterFolder.exists)
									
									$imagesFolderInFormatter:=$customFormatterFolder.folder("Images")
									
									If ($imagesFolderInFormatter.exists)
										
										var $imageFile : 4D:C1709.File
										
										For each ($imageFile; $imagesFolderInFormatter.files(fk ignore invisible:K87:22))
											
											var $correctedFormatName; $correctedImageName : Text
											
											$correctedFormatName:=Lowercase:C14($formatName)
											Rgx_SubstituteText("[^a-z0-9]"; "_"; ->$correctedFormatName; 0)
											
											$correctedImageName:=Lowercase:C14($imageFile.name)
											Rgx_SubstituteText("[^a-z0-9]"; "_"; ->$correctedImageName; 0)
											
											$correctedImageName:=$correctedFormatName+"_"+$correctedImageName+$imageFile.extension
											
											$copyDest:=$imageFile.copyTo($drawableFolder; $correctedImageName; fk overwrite:K87:5)
											
											If (Not:C34($copyDest.exists))  // Copy failed
												
												$0.success:=False:C215
												$0.errors.push("Could not copy file to destination: "+$copyDest.path)
												
												//Else : all ok
											End if 
											
										End for each 
										
										// Else : no image to copy
									End if 
									
								Else 
									
									// custom folder does not exists
									$0.success:=False:C215
									$0.errors.push("Custom formatter \""+$format+"\" couldn't be found at path: "+$customFormatterFolder.path)
									
								End if 
								
								// Else : no formatters folder
							End if 
							
							// Else : no custom formatter
						End if 
						
						// Else : format empty
					End if 
					
					// Else : no formatter
				End if 
				
			End for each 
			
			
		End for each 
		
		// Convert SVG to XML
		This:C1470.vdtool.convert($drawableFolder; $drawableFolder)
		
		If (Not:C34(This:C1470.vdtool.success))
			
			$0.success:=False:C215
			$0.errors.push("Error when converting SVG to XML files")
			
			// Else : all ok
		End if 
		
		// Delete SVG files converted
		If ($0.success)
			
			For each ($drawable; $drawableFolder.files())
				
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
Function createIconAssets
	var $0 : Object
	var $1 : Object  // Table object metadata
	
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
		$t:=$1.shortLabel
		
		If (Length:C16($t)>0)
			
			// Take first letter
			$t:=Uppercase:C13($t[[1]])
			
		Else 
			
			//%W-533.1
			$t:=Uppercase:C13($1.name[[1]])  // 4D table names are not empty
			//%W+533.1
			
		End if 
		
		$svg.setValue($t; $svg.findByXPath("/svg/textArea"))
		
		$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file("qmobile_android_missing_nav_icon.svg")
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
						
						$0.success:=True:C214
						$0.icon:=$newFile
						
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
	var $1 : Text  // Project path
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	This:C1470.launch(This:C1470.chmodCmd+" +x "+This:C1470.singleQuoted($1+"gradlew")+" "+This:C1470.singleQuoted(This:C1470.kotlinc))
	
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
	var $1 : Text  // Project path
	var $sdkVersion; $copyDest : 4D:C1709.File
	var $unzippedSdk : 4D:C1709.Folder
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$unzippedSdk:=This:C1470.path.cacheSdkAndroid().parent.folder("sdk")
	
	If ($unzippedSdk.exists)
		
		$sdkVersion:=$unzippedSdk.file("sdkVersion")
		
		If ($sdkVersion.exists)
			
			$copyDest:=$sdkVersion.copyTo(Folder:C1567($1+"app/src/main/assets"); fk overwrite:K87:5)
			
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