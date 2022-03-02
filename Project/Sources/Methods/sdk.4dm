//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : sdk
// Created 21-8-2017 by Eric Marchand
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BLOB:C604($x)
C_BOOLEAN:C305($Boo_install)
C_LONGINT:C283($Lon_httpResponse; $Lon_i; $Lon_parameters)
C_TEXT:C284($Txt_buffer; $Txt_cmd; $Txt_error; $Txt_fileRef; $Txt_in; $Txt_out)
C_OBJECT:C1216($errors; $Obj_; $Obj_objects; $Obj_param; $Obj_result)
C_COLLECTION:C1488($Col_)

ARRAY TEXT:C222($tTxt_folders; 0)

If (False:C215)
	C_OBJECT:C1216(sdk; $0)
	C_OBJECT:C1216(sdk; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	// Required parameters
	$Obj_param:=$1
	
	// Optional parameters
	If ($Lon_parameters>=2)
		
		// <NONE>
		
	End if 
	
	$Obj_result:=New object:C1471(\
		"success"; False:C215)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Asserted:C1132($Obj_param.action#Null:C1517; "Missing the tag \"action\""))
	
	Case of 
			
			// MARK:- install
		: ($Obj_param.action="install")
			
			If (String:C10($Obj_param.file)#"")
				
				$Obj_result.file:=$Obj_param.file
				
				// Check if there is a source version SDK, if yes use it instead
				$Txt_buffer:=Replace string:C233($Obj_param.file; "zip"; "src.zip")
				If (Test path name:C476($Txt_buffer)=Is a document:K24:1)
					$Obj_param.file:=$Txt_buffer
				End if 
				
				// Finally unzip if SDK exist
				If (Test path name:C476($Obj_param.file)=Is a document:K24:1)
					
					$Obj_result.success:=False:C215
					
					$Obj_param.cacheFolder:=cs:C1710.path.new().cacheSdkAppleUnzipped()
					$Obj_param.cache:=$Obj_param.cacheFolder.platformPath  // for zip
					If ($Obj_param.cacheFolder.exists)
						
						// If zip version and cache folder different, remove the cache
						$Obj_result.fileVersion:=sdk(New object:C1471(\
							"action"; "sdkVersion"; \
							"file"; $Obj_param.file))
						
						$Obj_result.cacheVersion:=sdk(New object:C1471(\
							"action"; "sdkVersion"; \
							"file"; $Obj_param.cacheFolder.platformPath))
						
						If (Num:C11(String:C10($Obj_result.cacheVersion.build))<Num:C11(String:C10($Obj_result.fileVersion.build)))
							
							$Obj_param.cacheFolder.delete(Delete with contents:K24:24)
							
						End if 
					End if 
					
					// Unzip the SDK
					$Obj_result:=_o_unzip($Obj_param)
					$Obj_result.file:=$Obj_param.file
					
				End if 
				
				If ($Obj_result.success)
					
					$Obj_result.version:=sdk(New object:C1471(\
						"action"; "sdkVersion"; \
						"file"; $Obj_param.target)).version
					
				End if 
				
			Else 
				
				$Obj_result.errors:=New collection:C1472("No SDK")
				
			End if 
			
			// MARK:- installAdditionnalSDK
		: ($Obj_param.action="installAdditionnalSDK")
			
			// Check
			$Obj_param.file:=String:C10($Obj_param.template.source)+"sdk"+Folder separator:K24:12+String:C10($Obj_param.template.sdk.name)+".zip"
			If (Test path name:C476(String:C10($Obj_param.file))#Is a document:K24:1)
				$Obj_param.file:=String:C10($Obj_param.template.source)+".."+Folder separator:K24:12+"sdk"+Folder separator:K24:12+String:C10($Obj_param.template.sdk.name)+".zip"
			End if 
			
			If (Test path name:C476(String:C10($Obj_param.file))#Is a document:K24:1)
				
				$Obj_param.file:=cs:C1710.path.new().sdk().file(String:C10($Obj_param.template.sdk.name)+".zip").platformPath
				
			End if 
			
			If (Test path name:C476(String:C10($Obj_param.file))=Is a document:K24:1)
				
				// Get the root template to keep SDK information in it
				$Obj_:=$Obj_param.template
				
				While (Value type:C1509($Obj_.parent)=Is object:K8:27)
					
					$Obj_:=$Obj_.parent
					
				End while 
				
				$Boo_install:=True:C214
				
				If ($Obj_.sdk.installed=Null:C1517)
					
					$Obj_.sdk.installed:=New object:C1471
					
				Else 
					
					$Boo_install:=$Obj_.sdk.installed[$Obj_param.file]=Null:C1517
					
					If (Not:C34($Boo_install))
						
						$Obj_result:=$Obj_.sdk.installed[$Obj_param.file]
						
					End if 
				End if 
				
				If ($Boo_install)
					
					// TODO maybe do some additional stuff like merging Cartfile.resolved instead of replace it
					
					$Obj_result:=_o_unzip($Obj_param)
					
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
			
			$Txt_buffer:=$Obj_param.target+Convert path POSIX to system:C1107($Obj_param.folder)
			If (Test path name:C476($Txt_buffer)=Is a folder:K24:2)
				
				FOLDER LIST:C473($Txt_buffer; $tTxt_folders)
				
				If (Size of array:C274($tTxt_folders)>0)
					$Obj_param.projfile.mustSave:=True:C214
				End if 
				
				For ($Lon_i; 1; Size of array:C274($tTxt_folders); 1)
					
					If (Path to object:C1547($tTxt_folders{$Lon_i}).extension=".framework")
						
						// in source tree group
						$Txt_buffer:=XcodeProj(New object:C1471("action"; "randomObjectId"; "proj"; $Obj_param.projfile.value)).value
						
						If (Not:C34(Bool:C1537(FEATURE.with("generateForDev"))))  // # feature to not add framework
							$Obj_:=New object:C1471("name"; $tTxt_folders{$Lon_i}; "isa"; "PBXFileReference"; "lastKnownFileType"; "wrapper.framework"; "path"; $Obj_param.folder+$tTxt_folders{$Lon_i}; "sourceTree"; "<group>")
						Else 
							// XXX for source not in compiled, maybe do thi code elsewhere, or change $Obj_param.folder in caller function
							$Obj_:=New object:C1471("name"; $tTxt_folders{$Lon_i}; "isa"; "PBXFileReference"; "lastKnownFileType"; "wrapper.framework"; "path"; $tTxt_folders{$Lon_i}; "sourceTree"; "BUILT_PRODUCTS_DIR")
							
						End if 
						
						$Obj_objects[$Txt_buffer]:=$Obj_
						If (Position:C15("QMobile"; $tTxt_folders{$Lon_i})=1)
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
							If (Not:C34(Bool:C1537(FEATURE.with("generateForDev"))))
								$Obj_.settings:=New object:C1471("ATTRIBUTES"; New collection:C1472("CodeSignOnCopy"))  // ;"RemoveHeadersOnCopy"
							End if 
							$Obj_objects[$Txt_buffer]:=$Obj_
							
							$Col_:=$Obj_result.phase.embed.files
							$Col_.push($Txt_buffer)
							//Else swift 4.2: do not embed or will result in duplicate objects error
						End if 
						
						// in Copy Frameworks // PBXShellScriptBuildPhase
						If (Value type:C1509($Obj_result.phase.copy)=Is object:K8:27)
							
							$Obj_result.phase.copy.inputPaths.push("$(SRCROOT)/"+$Obj_param.folder+$tTxt_folders{$Lon_i})
							$Obj_result.phase.copy.outputPaths.push("$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/"+$tTxt_folders{$Lon_i})
							
						End if 
					End if 
				End for 
				
				$Obj_result.success:=True:C214
				
			Else 
				
				$Obj_result.errors:=New collection:C1472("Framework folder '"+$Txt_buffer+"' does not exist")
				
			End if 
			
			// MARK:- cache
		: ($Obj_param.action="cache")
			
			If (String:C10($Obj_param.path)#"")
				
				$Obj_:=Path to object:C1547($Obj_param.path)
				$Obj_.isFolder:=True:C214  // Ensure ensure end separator
				$Obj_param.path:=Object to path:C1548($Obj_)
				
				If (Test path name:C476($Obj_param.path+SHARED.thirdParty)=Is a folder:K24:2)  // well known sdk path
					
					$Txt_buffer:=cs:C1710.path.new().home.folder("Library/Caches").platformPath
					
					If (Test path name:C476($Txt_buffer)#Is a folder:K24:2)
						
						CREATE FOLDER:C475($Txt_buffer)
						
					End if 
					
					$Txt_buffer:=$Txt_buffer+".sdk"
					
					If (Test path name:C476($Txt_buffer)#Is a folder:K24:2)
						
						CREATE FOLDER:C475($Txt_buffer)
						
					End if 
					
					$Txt_cmd:="mv -f "+str_singleQuoted(Convert path system to POSIX:C1106($Obj_param.path+SHARED.thirdParty))\
						+" "+str_singleQuoted(Convert path system to POSIX:C1106($Txt_buffer))
					
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
			
			Case of 
					
					// ----------------------------------------
				: (Test path name:C476($Obj_param.file)=Is a document:K24:1)
					
					$sdkVersionFile:=ZIP Read archive:C1637(File:C1566($Obj_param.file; fk platform path:K87:2)).root.file("sdkVersion")  // suppose zip
					
					// ----------------------------------------
				: (Test path name:C476($Obj_param.file)=Is a folder:K24:2)
					
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

// ----------------------------------------------------
// Return
$0:=$Obj_result

// ----------------------------------------------------
// End