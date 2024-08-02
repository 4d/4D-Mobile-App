//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : sdk
// Created 21-8-2017 by Eric Marchand
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
#DECLARE($Obj_param : Object)->$Obj_result : Object

C_BOOLEAN:C305($Boo_install)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_buffer; $Txt_cmd; $Txt_error; $Txt_fileRef; $Txt_in; $Txt_out)
C_OBJECT:C1216($Obj_; $Obj_objects)
C_COLLECTION:C1488($Col_)


// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
Else 
	
	ABORT:C156
	
End if 

$Obj_result:=New object:C1471(\
"success"; False:C215)

// ----------------------------------------------------
If (Asserted:C1132($Obj_param.action#Null:C1517; "Missing the tag \"action\""))
	
	Case of 
			
			// MARK:- install
		: ($Obj_param.action="install")
			
			If (String:C10($Obj_param.file)#"")
				
				$Obj_result.file:=$Obj_param.file
				
				// Check if there is a source version SDK, if yes use it instead
				$Txt_buffer:=Replace string:C233($Obj_param.file; "zip"; "src.zip")
				If (File:C1566($Txt_buffer; fk platform path:K87:2).exists)
					$Obj_param.file:=$Txt_buffer
				End if 
				
				$Obj_result.success:=False:C215
				
				$Obj_param.cacheFolder:=cs:C1710.path.new().cacheSdkAppleUnzipped()
				
				If ($Obj_param.cacheFolder.exists)
					
					$Obj_param.cache:=$Obj_param.cacheFolder.platformPath  // for zip
					
					$Obj_result.cacheVersion:=sdk(New object:C1471(\
						"action"; "sdkVersion"; \
						"file"; $Obj_param.cacheFolder.platformPath))
					
					If (File:C1566($Obj_param.file; fk platform path:K87:2).exists)
						// If zip version and cache folder different, remove the cache
						$Obj_result.fileVersion:=sdk(New object:C1471(\
							"action"; "sdkVersion"; \
							"file"; $Obj_param.file))
						
						If (Num:C11(String:C10($Obj_result.cacheVersion.build))<Num:C11(String:C10($Obj_result.fileVersion.build)))
							
							$Obj_param.cacheFolder.delete(Delete with contents:K24:24)
							
						End if 
						
					Else 
						
						$Obj_param.file:=$Obj_param.cacheFolder.file("sdkVersion").platformPath  // tricky way to make unzip code to just copy without failing
						$Obj_result.fileVersion:=$Obj_result.cacheVersion
						$Obj_result.noZip:=True:C214
						
					End if 
					
				End if 
				
				If (Not:C34(File:C1566($Obj_param.file; fk platform path:K87:2).exists))
					
					var $request : 4D:C1709.HTTPRequest
					$request:=downloadSDK("github"; "ios"; /*silent=*/True:C214; 0; True:C214)
					$request.wait(60)
					
					If ($Obj_param.cacheFolder.file("sdkVersion").exists)  // already unziped
						
						$Obj_param.cache:=$Obj_param.cacheFolder.platformPath  // for zip
						$Obj_param.file:=$Obj_param.cacheFolder.file("sdkVersion").platformPath  // tricky way to make unzip code to just copy without failing
						$Obj_result.fileVersion:=$Obj_result.cacheVersion
						$Obj_result.noZip:=True:C214
						
					End if 
					
				End if 
				// Unzip the SDK
				$Obj_result:=copyOrUnzip($Obj_param)
				$Obj_result.file:=$Obj_param.file
				
			End if 
			
			If ($Obj_result.success)
				
				$Obj_result.version:=sdk(New object:C1471(\
					"action"; "sdkVersion"; \
					"file"; $Obj_param.target)).version
				
			End if 
			
			
			// MARK:- link
		: ($Obj_param.action="link")
			
			ASSERT:C1129(Feature.with("buildWithCmd"))
			
			$Obj_result.version:=String:C10($Obj_param.version)
			$Obj_result.success:=True:C214
			
			// TODO write into $Obj_param.target sdkVersion file with needed version info
			// and maybe other things
			
			// MARK:- installAdditionnalSDK
		: ($Obj_param.action="installAdditionnalSDK")
			
			// Check
			$Obj_param.file:=Folder:C1567(String:C10($Obj_param.template.source); fk platform path:K87:2).folder("sdk").file(String:C10($Obj_param.template.sdk.name)+".zip")
			If (Not:C34($Obj_param.file.exists))
				$Obj_param.file:=Folder:C1567(String:C10($Obj_param.template.source); fk platform path:K87:2).folder("../sdk").file(String:C10($Obj_param.template.sdk.name)+".zip")
			End if 
			
			If (Not:C34($Obj_param.file.exists))
				
				$Obj_param.file:=cs:C1710.path.new().sdk().file(String:C10($Obj_param.template.sdk.name)+".zip")
				
			End if 
			
			If (Not:C34($Obj_param.file.exists))
				
				$Obj_param.file:=cs:C1710.path.new().hostSDK(True:C214).file(String:C10($Obj_param.template.sdk.name)+".zip")
				
			End if 
			
			If (Not:C34($Obj_param.file.exists))
				// in last resort try to download latest release
				var $map : Object
				$map:=New object:C1471("TRMosaicLayout"; "https://github.com/4d-for-ios/TRMosaicLayout/releases/latest/download/TRMosaicLayout.zip"; \
					"AnimatedCollectionViewLayout"; "https://github.com/4d-for-ios/AnimatedCollectionViewLayout/releases/latest/download/AnimatedCollectionViewLayout.zip")
				// TODO: extract map of templates into config files instead
				
				var $url : Text
				$url:=String:C10($map[String:C10($Obj_param.template.sdk.name)])
				
				If (Length:C16($url)>0)
					
					var $code : Integer
					var $data : Blob
					var $content : Text
					$code:=HTTP Request:C1158(HTTP GET method:K71:1; $url; $content; $data)
					
					If (($code<300) && ($code>=200))
						
						$Obj_param.file.setContent($data)
						
					End if 
					
					If (($Obj_param.file.exists) && ($Obj_param.file.size=0))  // it seems that dowload failure could create empty file
						$Obj_param.file.delete()
					End if 
					
				End if 
			End if 
			
			
			If ($Obj_param.file.exists)
				
				// Get the root template to keep SDK information in it
				$Obj_:=$Obj_param.template
				
				While (Value type:C1509($Obj_.parent)=Is object:K8:27)
					
					$Obj_:=$Obj_.parent
					
				End while 
				
				$Boo_install:=True:C214
				
				If ($Obj_.sdk.installed=Null:C1517)
					
					$Obj_.sdk.installed:=New object:C1471
					
				Else 
					
					$Boo_install:=$Obj_.sdk.installed[$Obj_param.file.platformPath]=Null:C1517
					
					If (Not:C34($Boo_install))
						
						$Obj_result:=$Obj_.sdk.installed[$Obj_param.file.platformPath]
						
					End if 
				End if 
				
				If ($Boo_install)
					
					// TODO maybe do some additional stuff like merging Cartfile.resolved instead of replace it
					
					$Obj_param.file:=$Obj_param.file.platformPath  // to keep compatibility
					$Obj_result:=copyOrUnzip($Obj_param)
					
					// Add to installed framework
					$Obj_.sdk.installed[$Obj_param.file]:=$Obj_result
					
				End if 
				
			Else 
				
				$Obj_result.errors:=New collection:C1472("No SDK file for template sdk name '"+String:C10($Obj_param.template.sdk.name)+"'")
				
			End if 
			
			// MARK:- inject
		: ($Obj_param.action="inject")
			
			$Obj_param.projfile.mustSave:=True:C214
			
			$Obj_objects:=$Obj_param.projfile.value.objects
			$Obj_result.group:=New object:C1471(\
				"qmobile"; $Obj_objects["A0152FA2B08DC7DAB2CD6DB4"].children; \
				"thirdparty"; $Obj_objects["48FB2CF71E93C0FA00F4F685"].children)
			
			$Obj_result.phase:=New object:C1471(\
				"linked"; $Obj_objects["48861A161E8953B800C1A97C"]; \
				"embed"; $Obj_objects["48FDD0DF1E94FA1000EEDE31"]; \
				"copy"; $Obj_objects["D9BA4A381EC4A6D9001A997B"])
			
			var $folder; $child : 4D:C1709.Folder
			var $children : Collection
			$folder:=Folder:C1567($Obj_param.target; fk platform path:K87:2).folder($Obj_param.folder)
			If ($folder.exists)
				
				$children:=$folder.folders()
				If ($children.length>0)
					$Obj_param.projfile.mustSave:=True:C214
				End if 
				
				For each ($child; $children)
					
					
					If ($child.extension=".framework")
						
						// in source tree group
						$Txt_buffer:=XcodeProj(New object:C1471("action"; "randomObjectId"; "proj"; $Obj_param.projfile.value)).value
						
						If (Feature.disabled("generateForDev"))  // # feature to not add framework
							$Obj_:=New object:C1471("name"; $child.fullName; "isa"; "PBXFileReference"; "lastKnownFileType"; "wrapper.framework"; "path"; $Obj_param.folder+$child.fullName; "sourceTree"; "<group>")
						Else 
							// XXX for source not in compiled, maybe do thi code elsewhere, or change $Obj_param.folder in caller function
							$Obj_:=New object:C1471("name"; $child.fullName; "isa"; "PBXFileReference"; "lastKnownFileType"; "wrapper.framework"; "path"; $child.fullName; "sourceTree"; "BUILT_PRODUCTS_DIR")
							
						End if 
						
						$Obj_objects[$Txt_buffer]:=$Obj_
						If (Position:C15("QMobile"; $child.name)=1)
							$Col_:=$Obj_result.group["qmobile"]
						Else 
							$Col_:=$Obj_result.group["thirdparty"]
						End if 
						$Col_.push($Txt_buffer)
						$Txt_fileRef:=$Txt_buffer
						
						// in Frameworks // PBXFrameworksBuildPhase
						$Txt_buffer:=XcodeProj(New object:C1471("action"; "randomObjectId"; "proj"; $Obj_param.projfile.value)).value
						$Obj_:=New object:C1471("isa"; "PBXBuildFile"; "fileRef"; $Txt_fileRef)
						$Obj_objects[$Txt_buffer]:=$Obj_
						$Col_:=$Obj_result.phase.linked.files
						$Col_.push($Txt_buffer)
						
						If (str_cmpVersion(SHARED.swift.Version; "4.1")<1)
							// in Embed Frameworks // PBXCopyFilesBuildPhase
							$Txt_buffer:=XcodeProj(New object:C1471("action"; "randomObjectId"; "proj"; $Obj_param.projfile.value)).value
							
							$Obj_:=New object:C1471("isa"; "PBXBuildFile"; "fileRef"; $Txt_fileRef)
							If (Feature.disabled("generateForDev"))
								$Obj_.settings:=New object:C1471("ATTRIBUTES"; New collection:C1472("CodeSignOnCopy"))  // ;"RemoveHeadersOnCopy"
							End if 
							$Obj_objects[$Txt_buffer]:=$Obj_
							
							$Col_:=$Obj_result.phase.embed.files
							$Col_.push($Txt_buffer)
							//Else swift 4.2: do not embed or will result in duplicate objects error
						End if 
						
						// in Copy Frameworks // PBXShellScriptBuildPhase
						If (Value type:C1509($Obj_result.phase.copy)=Is object:K8:27)
							
							$Obj_result.phase.copy.inputPaths.push("$(SRCROOT)/"+$Obj_param.folder+$child.fullName)
							$Obj_result.phase.copy.outputPaths.push("$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/"+$child.fullName)
							
						End if 
					End if 
				End for each 
				
				$Obj_result.success:=True:C214
				
			Else 
				
				$folder:=$folder.parent  // check parent without "iOS" for xcframework
				var $paramfolder : Text
				$paramfolder:=Path to object:C1547($Obj_param.folder; Path is POSIX:K24:26).parentFolder
				
				If ($folder.exists)
					
					$children:=$folder.folders().filter(Formula:C1597($1.value.extension=".xcframework"))
					If ($children.length>0)
						$Obj_param.projfile.mustSave:=True:C214
					Else 
						
						$Obj_result.errors:=New collection:C1472("Framework folder '"+$Obj_param.folder+"' does not exist")
						
					End if 
					
					For each ($child; $children)
						
						$Txt_buffer:=XcodeProj(New object:C1471("action"; "randomObjectId"; "proj"; $Obj_param.projfile.value)).value
						$Obj_:=New object:C1471("name"; $child.fullName; "isa"; "PBXFileReference"; "lastKnownFileType"; "wrapper.xcframework"; "path"; $paramfolder+$child.fullName; "sourceTree"; "<group>")
						
						
						$Obj_objects[$Txt_buffer]:=$Obj_
						If (Position:C15("QMobile"; $child.name)=1)
							$Col_:=$Obj_result.group["qmobile"]
						Else 
							$Col_:=$Obj_result.group["thirdparty"]
						End if 
						$Col_.push($Txt_buffer)
						$Txt_fileRef:=$Txt_buffer
						
						// in Frameworks // PBXFrameworksBuildPhase
						$Txt_buffer:=XcodeProj(New object:C1471("action"; "randomObjectId"; "proj"; $Obj_param.projfile.value)).value
						$Obj_:=New object:C1471("isa"; "PBXBuildFile"; "fileRef"; $Txt_fileRef)
						$Obj_objects[$Txt_buffer]:=$Obj_
						$Col_:=$Obj_result.phase.linked.files
						$Col_.push($Txt_buffer)
						
						// in Embed Frameworks // PBXCopyFilesBuildPhase
						$Txt_buffer:=XcodeProj(New object:C1471("action"; "randomObjectId"; "proj"; $Obj_param.projfile.value)).value
						
						$Obj_:=New object:C1471("isa"; "PBXBuildFile"; "fileRef"; $Txt_fileRef)
						$Obj_.settings:=New object:C1471("ATTRIBUTES"; New collection:C1472("CodeSignOnCopy"))  // ;"RemoveHeadersOnCopy"
						
						$Col_:=$Obj_result.phase.embed.files
						$Col_.push($Txt_buffer)
						
						
						// in Copy Frameworks // PBXShellScriptBuildPhase
						If (Value type:C1509($Obj_result.phase.copy)=Is object:K8:27)
							
							$Obj_result.phase.copy.inputPaths.push("$(SRCROOT)/"+$Obj_param.folder+$child.fullName)
							$Obj_result.phase.copy.outputPaths.push("$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/"+$child.fullName)
							
						End if 
						
						
					End for each 
					
				Else 
					
					$Obj_result.errors:=New collection:C1472("Framework folder '"+$Obj_param.folder+"' does not exist")
					
				End if 
			End if 
			
			// MARK:- cache
		: ($Obj_param.action="cache")
			
			If (String:C10($Obj_param.path)#"")
				
				$Obj_:=Folder:C1567($Obj_param.path)
				$Obj_:=Folder:C1567($Obj_.platformPath+SHARED.thirdParty; fk platform path:K87:2)
				
				If ($Obj_.exists)  // well known sdk path
					
					var $cacheFolder : 4D:C1709.Folder
					$cacheFolder:=cs:C1710.path.new().userHome().folder("Library/Caches")
					
					If (Not:C34($cacheFolder.exists))
						
						$cacheFolder.create()
						
					End if 
					
					$cacheFolder:=$cacheFolder.folder(".sdk")
					
					If (Not:C34($cacheFolder.exists))
						
						$cacheFolder.create()
						
					End if 
					
					$Txt_cmd:="mv -f "+str_singleQuoted($Obj_.path)\
						+" "+str_singleQuoted($cacheFolder.path)
					
					LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
					
					If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
						
						If (Length:C16($Txt_error)=0)
							
							$Obj_result.success:=True:C214
							
						Else 
							
							$Obj_result.error:=$Txt_error
							
						End if 
					End if 
				End if 
				
			Else 
				
				$Obj_result.errors:=New collection:C1472("path must be defined")
				
			End if 
			
			// MARK:- sdkVersion
		: ($Obj_param.action="sdkVersion")
			
			$Obj_result.version:=""
			
			var $sdkVersionFile : Object
			$sdkVersionFile:=New object:C1471("exists"; False:C215)
			
			var $isFolder : Boolean
			$isFolder:=TestPathName($Obj_param.file)=Is a folder:K24:2
			
			Case of 
					
					// ----------------------------------------
				: (Not:C34($isFolder) && (File:C1566($Obj_param.file; fk platform path:K87:2).exists))  // /!!\ error if trying to pass folder path to File
					
					$sdkVersionFile:=ZIP Read archive:C1637(File:C1566($Obj_param.file; fk platform path:K87:2)).root.file("sdkVersion")  // suppose zip
					
					// ----------------------------------------
				: ($isFolder && (Folder:C1567($Obj_param.file; fk platform path:K87:2).exists))
					
					$sdkVersionFile:=Folder:C1567($Obj_param.file; fk platform path:K87:2).file("sdkVersion")
					
					// ----------------------------------------
			End case 
			
			If ($sdkVersionFile.exists)
				
				$Obj_result.version:=$sdkVersionFile.getText()
				$Obj_result.version:=Replace string:C233($Obj_result.version; Char:C90(Line feed:K15:40); "")
				$Obj_result.version:=Replace string:C233($Obj_result.version; Char:C90(Carriage return:K15:38); "")
				
				var $colTemp : Collection
				$colTemp:=Split string:C1554($Obj_result.version; "@")
				If ($colTemp.length>1)
					$Obj_result.branch:=$colTemp[0]
					$colTemp:=Split string:C1554($colTemp[1]; ".")
					If ($colTemp.length>0)
						$Obj_result.build:=$colTemp[0]
						If ($colTemp.length>4)
							$Obj_result.api:=$colTemp[1]
							$Obj_result.dataStore:=$colTemp[2]
							$Obj_result.dataSync:=$colTemp[3]
							$Obj_result.ui:=$colTemp[4]
						End if 
					End if 
					$Obj_result.success:=True:C214
				End if 
				
			Else 
				
				$Obj_result.errors:=New collection:C1472("SDK folder "+String:C10($Obj_param.file)+" do not contains sdkVersion file")
				
			End if 
			
			//________________________________________
		Else 
			
			$Obj_result.success:=False:C215
			$Obj_result.errors:=New collection:C1472("Unknown entry point "+$Obj_param.action)
			
			//________________________________________
	End case 
End if 

