//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : Xcode
// ID[CD89C14B0BE64405988542C627ED2C2E]
// Created 27-6-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
#DECLARE($Obj_param : Object)->$Obj_result : Object

var $Boo_search : Boolean
var $Lon_i; $Lon_x : Integer
var $File_subpath; $Txt_buffer : Text
var $Txt_cmd; $Txt_error; $Txt_in; $Txt_name; $Txt_newPath; $Txt_out : Text
var $Obj_buffer; $Obj_version : Object
var $Dom_fileRef; $Dom_root; $Dom_group; $Dom_child : Object
var $subfolder : Object
var $Col_folder; $Col_paths : Collection
var $regex : cs:C1710.regex


$Obj_result:=New object:C1471("success"; False:C215)

// ----------------------------------------------------

Case of 
		
		//______________________________________________________
	: ($Obj_param.action=Null:C1517)
		
		ASSERT:C1129(dev_Matrix; "Missing the tag \"action\"")
		
		// MARK:- appStore
	: ($Obj_param.action="appStore")
		
		OPEN URL:C673(Get localized string:C991("appstore_xcode"); *)
		
		//________________________________________
	: ($Obj_param.action="isdefaultpath")
		
		$Obj_result:=Xcode(New object:C1471(\
			"action"; "defaultpath"))
		
		$Txt_buffer:=$Obj_result.path
		
		$Obj_result:=Xcode(New object:C1471(\
			"action"; "path"))
		
		$Obj_result.success:=($Obj_result.path=$Txt_buffer)
		
		//________________________________________
	: ($Obj_param.action="defaultpath")
		
		$Txt_buffer:="/Applications/Xcode.app"
		$Obj_result.success:=True:C214
		
		$Obj_result.path:=Convert path POSIX to system:C1107($Txt_buffer)
		$Obj_result.posix:=$Txt_buffer
		
		// MARK:- path
	: ($Obj_param.action="path")
		
		// return by default the default path,
		// and if not exist the tool path,
		// and if not exist one of the path found by spotlight. The last version.
		
		$Boo_search:=True:C214
		
		// Test the default path
		$Obj_result:=Xcode(New object:C1471(\
			"action"; "defaultpath"))
		
		If (Bool:C1537(SHARED.useXcodeDefaultPath)\
			 & (Test path name:C476($Obj_result.path)#-43))
			
			$Boo_search:=False:C215  // do nothing but in case
			
		Else 
			
			// Test the tools path
			$Obj_result:=Xcode(New object:C1471(\
				"action"; "tools-path"))
			
			If ($Obj_result.success)
				
				$Txt_buffer:=Replace string:C233($Obj_result.posix; "Contents/Developer"; "")
				
				If (($Txt_buffer#$Obj_result.posix)\
					 & (Test path name:C476(Convert path POSIX to system:C1107($Txt_buffer))#-43))
					
					$Obj_result.posix:=$Txt_buffer
					$Obj_result.path:=Convert path POSIX to system:C1107($Txt_buffer)
					
					$Boo_search:=False:C215
					
				End if 
			End if 
		End if 
		
		If ($Boo_search)
			
			$Obj_result:=Xcode(New object:C1471(\
				"action"; "lastpath"))
			
		End if 
		
		// MARK:- lastpath
	: ($Obj_param.action="lastpath")
		
		$Obj_result:=Xcode(New object:C1471(\
			"action"; "paths"))
		
		If ($Obj_result.success)
			
			$Col_paths:=$Obj_result.paths
			
			$Txt_buffer:=""
			
			For each ($Txt_newPath; $Col_paths)
				
				$Obj_version:=Xcode(New object:C1471(\
					"action"; "version"; \
					"posix"; $Txt_newPath))
				
				If ($Obj_version.success)
					
					If (str_cmpVersion(String:C10($Obj_version.version); $Txt_buffer)>=0)  // Equal or higher
						
						$Txt_buffer:=String:C10($Obj_version.version)
						$Obj_result.version:=$Txt_buffer
						$Obj_result.posix:=$Txt_newPath
						$Obj_result.path:=Convert path POSIX to system:C1107($Obj_result.posix)
						$Obj_result.success:=True:C214
						
					End if 
				End if 
			End for each 
		End if 
		
		// MARK:- masupgrade
	: ($Obj_param.action="masupgrade")
		
		// work only with mas installed: brew install mas
		$Txt_cmd:="mas upgrade 497799835"
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
		
		If (Asserted:C1132(OK=1; "Get paths failed: "+$Txt_cmd))
			
			If (Length:C16($Txt_error)=0)
				
				$Obj_result.success:=True:C214
				$Obj_result.value:=$Txt_out
				
			Else 
				
				$Obj_result.errors:=New collection:C1472($Txt_error)
				
			End if 
		End if 
		
		// MARK:- masaccount
	: ($Obj_param.action="masaccount")
		
		// work only with mas installed: brew install mas
		$Txt_cmd:="mas account"  // get the email
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
		
		If (Asserted:C1132(OK=1; "Get paths failed: "+$Txt_cmd))
			
			If (Length:C16($Txt_error)=0)
				
				$Obj_result.success:=True:C214
				$Obj_result.value:=$Txt_out
				
			Else 
				
				$Obj_result.errors:=New collection:C1472($Txt_error)
				
			End if 
		End if 
		
		// MARK:- paths
	: ($Obj_param.action="paths")  // Get al installed xcode using spotlight
		
		$Txt_cmd:="mdfind \"kMDItemCFBundleIdentifier == 'com.apple.dt.Xcode'\""
		
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
		
		If (Asserted:C1132(OK=1; "Get paths failed: "+$Txt_cmd))
			
			If ((Length:C16($Txt_error)=0)\
				 & (Length:C16($Txt_out)#0))
				
				$Col_paths:=New collection:C1472
				
				$Lon_x:=Position:C15("\n"; $Txt_out)
				
				While ($Lon_x#0)
					
					$Txt_buffer:=Substring:C12($Txt_out; 1; $Lon_x-1)
					$Col_paths.push($Txt_buffer)
					$Txt_out:=Substring:C12($Txt_out; $Lon_x+1)
					$Lon_x:=Position:C15("\n"; $Txt_out)
					
				End while 
				
				$Obj_result.success:=True:C214
				$Obj_result.paths:=$Col_paths
				
			Else 
				
				$Obj_result.error:=Choose:C955(Length:C16($Txt_error)=0; "No Xcode installed"; $Txt_error)
				
			End if 
		End if 
		
		// MARK:- version
	: ($Obj_param.action="version")
		
		Case of 
				
				// ----------------------------------------
				//----------------------------------------
			: ($Obj_param.posix#Null:C1517)
				
				$Txt_buffer:=$Obj_param.posix
				
				// ----------------------------------------
				//----------------------------------------
			: ($Obj_param.path#Null:C1517)
				
				$Txt_buffer:=Convert path system to POSIX:C1106($Obj_param.path)
				
				// ----------------------------------------
				//----------------------------------------
			Else 
				
				$Obj_result:=Xcode(New object:C1471(\
					"action"; "path"))
				
				If ($Obj_result.success)
					
					$Txt_buffer:=$Obj_result.posix
					
				End if 
				
				// ----------------------------------------
				
				//----------------------------------------
		End case 
		
		If (Length:C16($Txt_buffer)#0)
			
			$Obj_result:=New object:C1471
			$Obj_result.version:=String:C10(cs:C1710.plist.new(Folder:C1567($Txt_buffer).file("Contents/Info.plist")).content["CFBundleShortVersionString"])
			$Obj_result.success:=Length:C16($Obj_result.version)>0
			
		Else 
			
			ASSERT:C1129(dev_Matrix)
			
		End if 
		
		// MARK:- xbuild-version
	: ($Obj_param.action="xbuild-version")
		
		$Obj_result:=cs:C1710.Xcode.new().xcodeBuildVersion()
		
		// MARK:- swift-version
	: ($Obj_param.action="swift-version")
		
		$Obj_result:=cs:C1710.Xcode.new().swiftVersion()
		
		
		// MARK:- find
	: ($Obj_param.action="find")
		
		Case of 
				
				//……………………………………………………………………………………
			: ($Obj_param.posix#Null:C1517)
				
				$Txt_buffer:=Convert path POSIX to system:C1107($Obj_param.posix)
				
				//……………………………………………………………………………………
			: ($Obj_param.path#Null:C1517)
				
				$Txt_buffer:=$Obj_param.path
				
				// TODO: allow Folder object
				
				//……………………………………………………………………………………
			Else 
				
				ASSERT:C1129(dev_Matrix)
				
				//……………………………………………………………………………………
		End case 
		
		If (Length:C16($Txt_buffer)>0)
			
			If ($Obj_param.type#Null:C1517)
				
				$folder:=Folder:C1567($Txt_buffer; fk platform path:K87:2)
				
				If ($folder.extension=("."+$Obj_param.type))
					
					$Obj_result.success:=True:C214
					$Obj_result.path:=$Txt_buffer
					$Obj_result.posix:=$folder.path
					$Obj_result.folder:=$folder
					
				Else 
					
					If ($folder.exists)
						// Return last with wanted extension
						For each ($subfolder; $folder.folders())  // .. to change add Until($Obj_result.success)
							
							If ($subfolder.extension=("."+$Obj_param.type))
								
								$Obj_result.success:=True:C214
								$Obj_result.path:=$subfolder.platformPath
								$Obj_result.posix:=$subfolder.path
								$Obj_result.folder:=$subfolder
								
							End if 
						End for each 
					End if 
				End if 
				
			Else 
				
				ASSERT:C1129(dev_Matrix; "Type must be defined")
				
			End if 
			
		Else 
			
			$Obj_result.error:="path or posix must be defined to look for Xcode "+String:C10($Obj_param.type)
			
		End if 
		
		// MARK:- project-infos
	: ($Obj_param.action="project-infos")
		
		$Obj_param.action:="find"
		$Obj_param.type:="xcodeproj"
		$Obj_result:=Xcode($Obj_param)
		
		If ($Obj_result.success)
			
			$Txt_buffer:=$Obj_result.posix
			
		End if 
		
		If (Length:C16($Txt_buffer)>0)
			
			$Txt_cmd:="xcodebuild -list -json -project "+str_singleQuoted($Txt_buffer)
			
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
			
			If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
				
				If (Length:C16($Txt_out)>0)
					
					$Obj_result.success:=True:C214
					$Obj_result.infos:=JSON Parse:C1218($Txt_out)
					
				Else 
					
					$Obj_result.error:=$Txt_error
					
				End if 
			End if 
			
		Else 
			
			$Obj_result.error:="path or posix must be defined when getting xcode project information"
			
		End if 
		
		// MARK:- workspace-infos
	: ($Obj_param.action="workspace-infos")
		
		$Obj_param.action:="find"
		$Obj_param.type:="xcworkspace"
		$Obj_result:=Xcode($Obj_param)
		
		If ($Obj_result.success)
			
			$Txt_buffer:=$Obj_result.posix
			
		End if 
		
		If (Length:C16($Txt_buffer)>0)
			
			$Txt_cmd:="xcodebuild -list -json -workspace "+str_singleQuoted($Txt_buffer)
			
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
			
			If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
				
				If (Length:C16($Txt_out)>0)
					
					$Obj_result.success:=True:C214
					$Obj_result.infos:=JSON Parse:C1218($Txt_out)
					
				Else 
					
					$Obj_result.error:=$Txt_error
					
				End if 
			End if 
		End if 
		
		// MARK:- workspace-addsources
	: ($Obj_param.action="workspace-addsources")
		
		// add all subprojects in third party group if source found
		
		$Obj_param.action:="find"
		$Obj_param.type:="xcworkspace"
		$Obj_result:=Xcode($Obj_param)
		
		If ($Obj_param.folder=Null:C1517)
			$Obj_param.folder:=Folder:C1567($Obj_param.path; fk platform path:K87:2)
		End if 
		
		// path of the sources?
		Case of 
			: (Length:C16(String:C10($Obj_param.from))>0)
				$File_subpath:=$Obj_param.from
			: (Length:C16(String:C10(SHARED.thirdPartySources))>0)
				$File_subpath:=SHARED.thirdPartySources
			Else 
				$File_subpath:="Carthage/Checkouts"
				ASSERT:C1129(False:C215; "Must have defined commonValues.thirdPartySources")
		End case 
		
		If ($Obj_result.success)
			
			var $workSpaceFolder : 4D:C1709.Folder
			$workSpaceFolder:=$Obj_result.folder
			
			$Col_paths:=New collection:C1472
			
			// From carthage checkouts
			
			var $child : 4D:C1709.Folder
			For each ($child; $Obj_param.folder.folder($File_subpath).folders())  // TODO check if $File_subpath instead
				If ($child.extension=".xcarchive")
					continue
				End if 
				
				$Obj_result:=Xcode(New object:C1471(\
					"action"; "find"; \
					"type"; "xcodeproj"; \
					"path"; $child.platformPath))
				
				$Col_folder:=New collection:C1472($child.fullName; $child.fullName+"Example"; "Example")
				
				// Some times projects are under subfolder
				$Lon_x:=0
				
				While (Not:C34($Obj_result.success)\
					 & ($Lon_x<$Col_folder.length))
					
					If ($child.folder($Col_folder[$Lon_x]).exists)
						
						$Obj_result:=Xcode(New object:C1471(\
							"action"; "find"; \
							"type"; "xcodeproj"; \
							"path"; $child.folder($Col_folder[$Lon_x]).platformPath))
						
					End if 
					
					$Lon_x:=$Lon_x+1
					
				End while 
				
				If ($Obj_result.success)
					
					$Col_paths.push("group:"+Replace string:C233($Obj_result.folder.path; $Obj_param.folder.path; ""))
					
				End if 
			End for each 
			
			// From config files
			If (Value type:C1509(SHARED.xcworkspace.projects)=Is collection:K8:32)
				
				For each ($Txt_buffer; SHARED.xcworkspace.projects)
					
					If (Length:C16(String:C10(SHARED.xcworkspace.root))>0)
						$Txt_buffer:=String:C10(SHARED.xcworkspace.root)+$Txt_buffer
					End if 
					
					$Obj_result:=Xcode(New object:C1471(\
						"action"; "find"; \
						"type"; "xcodeproj"; \
						"posix"; $Txt_buffer))
					
					If ($Obj_result.success)
						
						For each ($Txt_buffer; $Col_paths)
							
							If (Position:C15($Obj_result.folder.name; $Txt_buffer)>0)
								
								$Col_paths.remove($Col_paths.indexOf($Txt_buffer))
								
							End if 
						End for each 
						
						$Txt_buffer:="absolute:"+$Obj_result.posix
						$Col_paths.push($Txt_buffer)
						
					End if 
				End for each 
			End if 
			
			$Dom_root:=_o_xml("load"; $workSpaceFolder.file("contents.xcworkspacedata"))
			
			If ($Dom_root.success)
				
				$Dom_group:=$Dom_root.findByXPath("/Workspace/Group")
				
				// Remove current group children if any
				$Dom_child:=$Dom_group.firstChild()
				
				While ($Dom_child.success)
					
					$Dom_child.remove()
					$Dom_child:=$Dom_group.firstChild()
					
				End while 
				
				// For each third party projects
				For each ($Txt_buffer; $Col_paths)
					
					// create a link in xml under third party group
					$Dom_fileRef:=$Dom_group.create("FileRef")
					$Dom_fileRef.setAttribute("location"; $Txt_buffer)
					
				End for each 
				
				$Dom_root.setOption(XML indentation:K45:34; XML with indentation:K45:35)
				$Dom_root.save($workSpaceFolder.file("contents.xcworkspacedata"))
				$Dom_root.close()
				
			End if 
		End if 
		
		// MARK:- project-object-infos
	: ($Obj_param.action="project-object-infos")
		
		$Obj_param.action:="find"
		$Obj_param.type:="xcodeproj"
		$Obj_result:=Xcode($Obj_param)
		
		If ($Obj_result.success)
			
			$Obj_result:=plistconvert(New object:C1471(\
				"action"; "object"; \
				"domain"; $Obj_result.folder.file("project.pbxproj").path))
			
		End if 
		
		// MARK:- set-project-object-infos
	: ($Obj_param.action="set-project-object-infos")
		
		$Obj_param.action:="find"
		$Obj_param.type:="xcodeproj"
		$Obj_result:=Xcode($Obj_param)
		
		If ($Obj_result.success)
			
			If ($Obj_param.object#Null:C1517)
				
				$Obj_param.action:="fromobject"
				$Obj_param.format:="openstep"
				$Obj_param.domain:=$Obj_result.folder.file("project.pbxproj").path
				
				$Obj_result:=plistconvert($Obj_param)
				
			Else 
				
				$Obj_result.success:=False:C215
				$Obj_result.errors:=New collection:C1472("object must be defined")
				
			End if 
		End if 
		
		// MARK:- open
	: ($Obj_param.action="open")
		
		If ($Obj_param.path#Null:C1517)\
			 | ($Obj_param.posix#Null:C1517)
			
			// open workspace or project
			$Obj_param.action:="find"
			$Obj_param.type:="xcworkspace"
			$Obj_result:=Xcode($Obj_param)
			
			If ($Obj_result.success)
				
				$Txt_buffer:=$Obj_result.posix
				
			Else 
				
				$Obj_param.type:="xcodeproj"
				$Obj_result:=Xcode($Obj_param)
				
				If ($Obj_result.success)
					
					$Txt_buffer:=$Obj_result.posix
					
				End if 
			End if 
			
			If (Length:C16($Txt_buffer)>0)
				
				$Txt_newPath:=Xcode(New object:C1471("action"; "path")).posix
				
				$Txt_cmd:="open "
				
				If (Length:C16(String:C10($Txt_newPath))>0)
					
					$Txt_cmd:=$Txt_cmd+"-a "+str_singleQuoted($Txt_newPath)+" "
					
				End if 
				
				$Txt_cmd:=$Txt_cmd+str_singleQuoted($Txt_buffer)
				LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
				
				If (Length:C16($Txt_error)=0)
					
					$Obj_result.success:=True:C214
					
				Else 
					
					$Obj_result.error:=$Txt_error
					
				End if 
			End if 
			
		Else 
			
			// open xcode
			$Obj_result:=Xcode(New object:C1471(\
				"action"; "path"))
			
			If ($Obj_result.success)
				
				$Txt_cmd:="open "
				$Txt_cmd:=$Txt_cmd+str_singleQuoted($Obj_result.posix)
				LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
				
				If (Length:C16($Txt_error)=0)
					
					$Obj_result.success:=True:C214
					
				Else 
					
					$Obj_result.error:=$Txt_error
					
				End if 
			End if 
		End if 
		
		// MARK:- couldOpen
	: ($Obj_param.action="couldOpen")
		
		If ($Obj_param.path#Null:C1517)\
			 | ($Obj_param.posix#Null:C1517)
			
			// open workspace or project
			$Obj_param.action:="find"
			$Obj_param.type:="xcworkspace"
			$Obj_result:=Xcode($Obj_param)
			
			If ($Obj_result.success)
				
				$Txt_buffer:=$Obj_result.posix
				
			Else 
				
				$Obj_param.type:="xcodeproj"
				$Obj_result:=Xcode($Obj_param)
				
			End if 
		End if 
		
		// MARK:- safeDelete
	: ($Obj_param.action="safeDelete")
		
		var $folder : 4D:C1709.Folder
		$folder:=Folder:C1567($Obj_param.path; fk platform path:K87:2)
		
		If ($folder.exists)
			
			// Workonly if project or workspace if selected
			
			If (Is macOS:C1572)
				// Close project
				Xcode(New object:C1471(\
					"action"; "close"; \
					"folder"; $folder; \
					"path"; $Obj_param.path; \
					"type"; "xcodeproj"))
				
				// or workspace
				Xcode(New object:C1471(\
					"action"; "close"; \
					"folder"; $folder; \
					"path"; $Obj_param.path; \
					"type"; "xcworkspace"))
				
				If (Feature.with(568))  // FAST SDK MOVE
					
					sdk(New object:C1471(\
						"action"; "cache"; \
						"folder"; $folder; \
						"path"; $Obj_param.path))
					
				End if 
				
				cs:C1710.lep.new().unlockDirectory($folder)
			End if 
			
			$folder.delete(Delete with contents:K24:24)
			
		End if 
		
		// MARK:- tools-path
	: ($Obj_param.action="tools-path")
		
		$Txt_cmd:="xcode-select --print-path"
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
		
		If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
			
			If (Length:C16($Txt_out)>0)
				
				$Obj_result.success:=True:C214
				
				$Txt_out:=Replace string:C233($Txt_out; "\n"; "")
				
				$Obj_result.path:=Convert path POSIX to system:C1107($Txt_out)
				$Obj_result.posix:=$Txt_out
				
			Else 
				
				$Obj_result.error:=$Txt_error
				
			End if 
		End if 
		
		// MARK:- showsdks
	: ($Obj_param.action="showsdks")
		
		$Obj_result:=cs:C1710.Xcode.new().sdks()
		
		// MARK:- set-tool-path
	: ($Obj_param.action="set-tool-path")
		
		If ($Obj_param.posix=Null:C1517)
			
			$Obj_result:=Xcode(New object:C1471(\
				"action"; "path"))
			
			If ($Obj_result.success)
				
				$Obj_param.posix:=$Obj_result.posix
				
			End if 
		End if 
		
		If ($Obj_param.posix#Null:C1517)
			
			var $xcodePath : Object
			$xcodePath:=Folder:C1567($Obj_param.posix; fk posix path:K87:1)
			
			$Lon_x:=Position:C15("Contents/Developer"; $Obj_param.posix)
			
			If ($Lon_x=0)
				
				$xcodePath:=$xcodePath.folder("Contents/Developer")
				
			End if 
			
			SET ENVIRONMENT VARIABLE:C812("SUDO_ASKPASS_TITLE"; cs:C1710.str.new("fixThePath").localized("4dForIos"))
			SET ENVIRONMENT VARIABLE:C812("SUDO_ASKPASS_MESSAGE"; Get localized string:C991("enterYourPasswordToAllowThis"))
			SET ENVIRONMENT VARIABLE:C812("SUDO_ASKPASS"; cs:C1710.path.new().scripts().file("sudo-askpass").path)
			
			LAUNCH EXTERNAL PROCESS:C811("sudo -A /usr/bin/xcode-select -s "+cs:C1710.str.new($xcodePath.path).singleQuoted(); $Txt_in; $Txt_out; $Txt_error)
			
			If (Asserted:C1132(OK=1; "set-tool-path"))
				
				If (Length:C16($Txt_error)>0)
					
					$Obj_result.error:=$Txt_error
					$Obj_result.success:=False:C215
					
				Else 
					
					$Obj_buffer:=Xcode(New object:C1471(\
						"action"; "tools-path"))
					If ($Obj_buffer.posix=Null:C1517)
						$Obj_result.success:=False:C215
					Else 
						$Obj_result.success:=$Obj_buffer.posix=$Txt_newPath
					End if 
					
				End if 
				
				// #FIXME could have error if failed to enter password many times, but action could success
				// maybe remove this errors before testing Length($Txt_error), or just check path has been modified
				//If (Length($Txt_error)=0)
				//$Obj_result.success:=True
				// Else
				//$Obj_result.error:=$Txt_error
				// #MARK_TODO maybe add $error to a detail panel of error message?
				// ALERT("Failed to set Xcode Tool Path")
				//CALL FORM($Obj_param.caller;"LOG_EVENT";New object("message";"Failed to set Xcode Tool Path: "+$Txt_error;"importance";Warning message))
				// End if
				// Else
				// ALERT("Failed to set Xcode Tool Path")
				
			End if 
			
			// Else
			// ASSERT(False)
			
		End if 
		
		// MARK:- build
	: ($Obj_param.action="build")
		
		If ($Obj_param.destination#Null:C1517)
			
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $Obj_param.destination)
			
		End if 
		
		$Txt_cmd:="xcodebuild"
		
		If (Bool:C1537($Obj_param.test))
			
			$Txt_cmd:=$Txt_cmd+" test"
			
		End if 
		
		$Txt_cmd:=$Txt_cmd+(" -verbose"*Num:C11(Bool:C1537($Obj_param.verbose)))
		
		If ($Obj_param.scheme#Null:C1517)
			
			$Txt_cmd:=$Txt_cmd+" -scheme "+str_singleQuoted($Obj_param.scheme)
			
		Else 
			
			ASSERT:C1129(Bool:C1537($Obj_param.exportArchive); "Scheme missing to build")
			
		End if 
		
		If ($Obj_param.sdk#Null:C1517)
			
			$Txt_cmd:=$Txt_cmd+" -sdk "+$Obj_param.sdk
			
			If (Position:C15("simulator"; $Obj_param.sdk)>0)
				
				If (Feature.with("isForceIntelSimulator") && (Get system info:C1571().processor="@Apple@"))
					
					$Txt_cmd:=$Txt_cmd+" -arch x86_64"  // not more needed with xcframework (XXX: maybe add it if old framework?)
					
				End if 
				
			End if 
			
		End if 
		
		If ($Obj_param.configuration#Null:C1517)
			
			$Txt_cmd:=$Txt_cmd+" -configuration "+$Obj_param.configuration  // Release, Debug
			
		End if 
		
		If ($Obj_param.target#Null:C1517)
			
			$Txt_cmd:=$Txt_cmd+" -derivedDataPath "+str_singleQuoted($Obj_param.target)
			
		End if 
		
		Case of 
				
				//----------------------------------------
			: (Bool:C1537($Obj_param.archive))
				
				$Txt_cmd:=$Txt_cmd+" archive"
				
				If (Length:C16(String:C10($Obj_param.archivePath))>0)
					
					$Txt_cmd:=$Txt_cmd+" -archivePath "+str_singleQuoted($Obj_param.archivePath)
					$Obj_result.archivePath:=$Obj_param.archivePath
					
				End if 
				
				//----------------------------------------
			: (Bool:C1537($Obj_param.exportArchive))
				
				$Txt_cmd:=$Txt_cmd+" -exportArchive"
				
				If (Asserted:C1132(Length:C16(String:C10($Obj_param.archivePath))>0; "archivePath must be defined with exportArchive"))
					
					$Txt_cmd:=$Txt_cmd+" -archivePath "+str_singleQuoted($Obj_param.archivePath)
					$Obj_result.archivePath:=$Obj_param.archivePath
					
				End if 
				
				If (Asserted:C1132(Length:C16(String:C10($Obj_param.exportPath))>0; "exportPath must be defined with exportArchive"))
					
					$Txt_cmd:=$Txt_cmd+" -exportPath "+str_singleQuoted($Obj_param.exportPath)
					$Obj_result.exportPath:=$Obj_param.exportPath
					
				End if 
				
				If (Length:C16(String:C10($Obj_param.exportOptionsPlist))=0)
					
					$Txt_buffer:="<?xml version=\"1.0\"Encoding=\"UTF-8\"?>"+"\r\n"+"<!DOCTYPE plist PUBLIC\"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">"+"\r\n"+"<plist version=\"1\">"+"\r\n"+"<dict>"+"\r\n"
					
					// Add team id
					If (Length:C16(String:C10($Obj_param.teamID))>0)
						
						$Txt_buffer:=$Txt_buffer+"<key>teamID</key>"+"\r\n"+"<string>"+$Obj_param.teamID+"</string>"+"\r\n"
						
					End if 
					
					// Signing options
					If (Length:C16(String:C10($Obj_param.signingStyle))>0)
						
						// Manual
						$Txt_buffer:=$Txt_buffer+"<key>signingStyle</key>"+"\r\n"+"<string>"+$Obj_param.signingStyle+"</string>"+"\r\n"
						
					Else 
						
						// Automatic
						$Txt_buffer:=$Txt_buffer+"<key>signingStyle</key>"+"\r\n"+"<string>automatic</string>"+"\r\n"
						
					End if 
					
					If (Length:C16(String:C10($Obj_param.signingCertificate))>0)
						
						$Txt_buffer:=$Txt_buffer+"<key>signingCertificate</key>"+"\r\n"+"<string>"+$Obj_param.signingCertificate+"</string>"+"\r\n"
						
					End if 
					
					// provisioningProfiles
					If ($Obj_param.provisioningProfiles#Null:C1517)
						
						If (Value type:C1509($Obj_param.provisioningProfiles)=Is object:K8:27)
							
							$Txt_buffer:=$Txt_buffer+"<key>provisioningProfiles</key>"+"\r\n"+"<dict>"+"\r\n"
							
							For each ($Txt_name; $Obj_param.provisioningProfiles)  // XXX for each on objet return key?
								
								$Txt_buffer:=$Txt_buffer+"<key>"+$Txt_name+"</key>"+"\r\n"+"<string>"+String:C10($Obj_param.provisioningProfiles[$Txt_name])+"</string>"+"\r\n"
								
							End for each 
							
							$Txt_buffer:=$Txt_buffer+"</dict>"+"\r\n"
							
						End if 
					End if 
					
					// Describes how Xcode should export the archive.
					// Available options: app-store, package, ad-hoc, enterprise, development, developer-id.
					If (Length:C16(String:C10($Obj_param.exportMethod))=0)
						
						$Obj_param.exportMethod:="development"  // Defaults to development
						
					End if 
					
					$Txt_buffer:=$Txt_buffer+"<key>method</key>"+"\r\n"+"<string>"+$Obj_param.exportMethod+"</string>"+"\r\n"
					
					// Bool options
					If ($Obj_param.uploadSymbols#Null:C1517)
						
						$Txt_buffer:=Choose:C955(Bool:C1537($Obj_param.uploadSymbols); $Txt_buffer+"<key>uploadSymbols</key>"+"\r\n"+"<true/>"+"\r\n"; $Txt_buffer+"<key>uploadSymbols</key>"+"\r\n"+"<false/>"+"\r\n")
						
					End if 
					
					If ($Obj_param.uploadBitcode#Null:C1517)
						
						$Txt_buffer:=Choose:C955(Bool:C1537($Obj_param.uploadBitcode); $Txt_buffer+"<key>uploadBitcode</key>"+"\r\n"+"<true/>"+"\r\n"; $Txt_buffer+"<key>uploadBitcode</key>"+"\r\n"+"<false/>"+"\r\n")
						
					End if 
					
					If ($Obj_param.stripSwiftSymbols#Null:C1517)
						
						$Txt_buffer:=Choose:C955(Bool:C1537($Obj_param.stripSwiftSymbols); $Txt_buffer+"<key>stripSwiftSymbols</key>"+"\r\n"+"<true/>"+"\r\n"; $Txt_buffer+"<key>stripSwiftSymbols</key>"+"\r\n"+"<false/>"+"\r\n")
						
					End if 
					
					// Development or Production
					If (Length:C16(String:C10($Obj_param.iCloudContainerEnvironment))>0)
						
						$Txt_buffer:=$Txt_buffer+"<key>iCloudContainerEnvironment</key>"+"\r\n"+"<string>"+$Obj_param.iCloudContainerEnvironment+"</string>"+"\r\n"
						
					End if 
					
					// For non-App Store exports
					
					// Should Xcode re-compile the app from bitcode? Defaults to YES.
					If ($Obj_param.compileBitcode#Null:C1517)
						
						$Txt_buffer:=Choose:C955(Bool:C1537($Obj_param.compileBitcode); $Txt_buffer+"<key>compileBitcode</key>"+"\r\n"+"<true/>"+"\r\n"; $Txt_buffer+"<key>compileBitcode</key>"+"\r\n"+"<false/>"+"\r\n")
						
					End if 
					
					// should Xcode thin the package for one or more device variants?
					// Available options:
					// *None(Xcode produces a non-thinned universal app)
					// *thin-For -all-variants(Xcode produces a universal app and all available thinned variants)
					// *(a model identifier for a specific device(e.g."iPhone7,1"))
					//    Defaults to <none>.
					If (Length:C16(String:C10($Obj_param.thining))>0)
						
						$Txt_buffer:=$Txt_buffer+"<key>thining</key>"+"\r\n"+"<string>"+$Obj_param.thining+"</string>"+"\r\n"
						
					End if 
					
					Case of 
							
							//........................................
						: (Bool:C1537($Obj_param.embedOnDemandResourcesAssetPacksInBundle))
							
							// if the app uses On Demand Resources and this is YES, asset packs are embedded in the app bundle so that the app can be tested without a server to packs.
							// Defaults to YES unless "onDemandResourcesAssetPacksBaseURL" is specified
							$Txt_buffer:=$Txt_buffer+"<key>embedOnDemandResourcesAssetPacksInBundle</key>"+"\r\n"+"<true/>"+"\r\n"
							
							//........................................
						: (Length:C16(String:C10($Obj_param.onDemandResourcesAssetPacksBaseURL))>0)
							
							// If the app uses "On Demand Resources" and "embedOnDemandResourcesAssetPacksInBundle"isn't YES, this should be a base
							// URL specifying where asset packs are going to be hosted.This configures the app to download asset packs from the specified URL.
							$Txt_buffer:=$Txt_buffer+"<key>onDemandResourcesAssetPacksBaseURL</key>"+"\r\n"+"<string>"+$Obj_param.onDemandResourcesAssetPacksBaseURL+"</string>"+"\r\n"
							
							//........................................
					End case 
					
					// / Manifest : users can download your app over the web by opening your dist
					
					If ($Obj_param.manifest#Null:C1517)
						
						If (Value type:C1509($Obj_param.manifest)=Is object:K8:27)
							
							// /  you can generate a manifest by providing some urls
							
							$Txt_buffer:=$Txt_buffer+"<key>manifest</key>"+"\r\n"+"<dict>"+"\r\n"
							
							$Txt_buffer:=$Txt_buffer+"<key>appURL</key>"+"\r\n"+"<string>"+String:C10($Obj_param.manifest.appURL)+"</string>"+"\r\n"
							$Txt_buffer:=$Txt_buffer+"<key>displayImageURL</key>"+"\r\n"+"<string>"+String:C10($Obj_param.manifest.displayImageURL)+"</string>"+"\r\n"
							$Txt_buffer:=$Txt_buffer+"<key>fullSizeImageURL</key>"+"\r\n"+"<string>"+String:C10($Obj_param.manifest.fullSizeImageURL)+"</string>"+"\r\n"
							
							If (Length:C16(String:C10($Obj_param.assetPackManifestURL))>0)
								
								$Txt_buffer:=$Txt_buffer+"<key>assetPackManifestURL</key>"+"\r\n"+"<string>"+String:C10($Obj_param.manifest.assetPackManifestURL)+"</string>"+"\r\n"
								
							End if 
							
							$Txt_buffer:=$Txt_buffer+"</dict>"+"\r\n"
							
						End if 
					End if 
					
					// End
					$Txt_buffer:=$Txt_buffer+"</dict>"+"\r\n"+"</plist>"+"\r\n"
					
					$Obj_param.exportOptionsPlist:=String:C10($Obj_param.exportPath)+"Options.plist"
					
					File:C1566($Obj_param.exportOptionsPlist).setText($Txt_buffer; "UTF-8"; Document with LF:K24:22)
					
				End if 
				
				$Txt_cmd:=$Txt_cmd+" -exportOptionsPlist "+str_singleQuoted($Obj_param.exportOptionsPlist)
				$Obj_result.exportOptionsPlist:=$Obj_param.exportOptionsPlist
				
				//----------------------------------------
		End case 
		
		If (Bool:C1537($Obj_param.allowProvisioningUpdates))
			
			$Txt_cmd:=$Txt_cmd+" -allowProvisioningUpdates"
			
			If (Bool:C1537($Obj_param.allowProvisioningDeviceRegistration))
				
				$Txt_cmd:=$Txt_cmd+" -allowProvisioningDeviceRegistration"
				
			End if 
		End if 
		
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
		
		If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
			
			// Check build ok
			If (Length:C16($Txt_out)>0)
				
				$Obj_result.out:=$Txt_out
				
				Case of 
						
						//________________________________________
					: (Bool:C1537($Obj_param.archive))
						
						$Txt_buffer:="ARCHIVE SUCCEEDED"
						
						//________________________________________
					: (Bool:C1537($Obj_param.exportArchive))
						
						$Txt_buffer:="EXPORT SUCCEEDED"
						
						//________________________________________
					Else 
						
						$Txt_buffer:="BUILD SUCCEEDED"
						
						//________________________________________
				End case 
				
				// Cannot check command return status so, check output content
				$regex:=cs:C1710.regex.new($Txt_out; $Txt_buffer)
				
				If ($regex.match())
					
					$Obj_result.success:=True:C214
					
					// Get the app pathname
					If ($regex.setPattern("(?mi-s)builtin-validationUtility\\s([^\\n]*)\\n").match())
						
						$Obj_result.app:=Replace string:C233($regex.matches[1].data; "\\"; "")
						
					Else 
						
						If ($regex.setPattern("(?mi-s)/usr/bin/touch -c\\s([^\\n]*)\\n").match())
							
							$Obj_result.app:=Replace string:C233($regex.matches[1].data; "\\"; "")
							
						End if 
					End if 
					
					// remove some trailing data like -infoplist-subpath Info.plist
					If (Position:C15(".app "; $Obj_result.app)>0)  // XXX: last pos
						
						$Obj_result.app:=Substring:C12($Obj_result.app; 1; Position:C15(".app "; $Obj_result.app)+3)
						
					End if 
					
				Else 
					
					$Obj_result.error:=$Txt_error
					$Obj_result.out:=$Txt_out
					
				End if 
				
			Else 
				
				$Obj_result.error:=$Txt_error
				
			End if 
		End if 
		
		// MARK:- clean
	: ($Obj_param.action="clean")
		
		If ($Obj_param.destination#Null:C1517)
			
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $Obj_param.destination)
			
		End if 
		
		$Txt_cmd:="xcodebuild clean"
		
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
		
		If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
			
			// Check clean ok
			If (Length:C16($Txt_out)>0)
				
				// Cannot check command return status so, check output content
				$Obj_result.success:=cs:C1710.regex.new($Txt_out; "CLEAN SUCCEEDED").match()
				$Obj_result.error:=$Txt_error
				$Obj_result.out:=$Txt_out
				
			End if 
		End if 
		
		// MARK:- runFirstLaunch
	: ($Obj_param.action="runFirstLaunch")  // Install packages and agree to the license.
		
		$Txt_cmd:="xcodebuild -runFirstLaunch"
		
		If (Bool:C1537($Obj_param.sudo))
			
			SET ENVIRONMENT VARIABLE:C812("SUDO_ASKPASS_TITLE"; cs:C1710.str.new().setText("fixThePath").localized("4dForIos"))
			SET ENVIRONMENT VARIABLE:C812("SUDO_ASKPASS_MESSAGE"; Get localized string:C991("enterYourPasswordToAllowThis"))
			SET ENVIRONMENT VARIABLE:C812("SUDO_ASKPASS"; cs:C1710.path.new().scripts().file("sudo-askpass").path)
			
			$Txt_cmd:="sudo -A "+$Txt_cmd
			
		End if 
		
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
		
		If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
			
			If (Length:C16($Txt_error)>0)
				
				$Obj_result.error:=$Txt_error
				$Obj_result.out:=$Txt_out
				
			Else 
				
				$Obj_result.success:=True:C214
				$Obj_result.out:=$Txt_out
				
			End if 
		End if 
		
		// MARK:- checkFirstLaunchStatus
	: ($Obj_param.action="checkFirstLaunchStatus")  // Check if any First Launch tasks need to be performed.
		
		$Txt_in:="xcodebuild -checkFirstLaunchStatus"
		$Txt_cmd:=str_singleQuoted(cs:C1710.path.new().scripts().file("echoStatus").path)
		
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
		
		If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
			
			If (Length:C16($Txt_error)>0)
				
				$Obj_result.error:=$Txt_error
				$Obj_result.out:=$Txt_out
				
			Else 
				
				$Obj_result.out:=$Txt_out
				
			End if 
			
			$Obj_result.success:=($Obj_result.out="0\n")  // Success even if there is some error logs. Only check status.
			
		End if 
		
		// MARK:- clean build
	: ($Obj_param.action="clean build")
		
		$Obj_param.action:="clean"
		$Obj_result:=Xcode($Obj_param)
		
		If ($Obj_result.success)
			
			$Obj_param.action:="build"
			$Obj_result:=Xcode($Obj_param)
			
		End if 
		
		// MARK:- close
	: ($Obj_param.action="close")
		
		$Txt_cmd:="/usr/bin/osascript"
		$Txt_cmd:=$Txt_cmd+" -e 'if application \"Xcode\" is running then'"
		$Txt_cmd:=$Txt_cmd+" -e 'tell application \"Xcode\"'"
		
		Case of 
				
				//______________________________________________________
			: (String:C10($Obj_param.window)#"")
				
				$Txt_cmd:=$Txt_cmd+" -e 'close window \""+$Obj_param.window+"\"'"
				
				//______________________________________________________
			: (String:C10($Obj_param.path)#"")
				
				$Obj_param.action:="find"
				
				If (Length:C16(String:C10($Obj_param.type))=0)
					
					$Obj_param.type:="xcodeproj"
					
				End if 
				
				$Obj_result:=Xcode($Obj_param)
				
				If ($Obj_result.success)
					
					$Txt_buffer:=$Obj_result.folder.fullName
					$Txt_cmd:=$Txt_cmd+" -e 'close window \""+$Txt_buffer+"\"'"
					
				Else 
					
					$Obj_result.error:="No project in path "+$Obj_param.path
					
				End if 
				
				//______________________________________________________
			Else 
				
				$Txt_cmd:=$Txt_cmd+" -e 'quit'"
				
				//----------------------------------------
		End case 
		
		$Txt_cmd:=$Txt_cmd+" -e 'end tell'"
		$Txt_cmd:=$Txt_cmd+" -e 'end if'"
		
		If ($Obj_result.error=Null:C1517)
			
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
			
			If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
				
				If (Length:C16($Txt_error)=0)
					
					$Obj_result.success:=True:C214
					
				Else 
					
					$Obj_result.error:=$Txt_error
					$Obj_result.success:=False:C215
					
				End if 
				
			Else 
				
				$Obj_result.success:=False:C215
				
			End if 
		End if 
		
		// MARK:- reveal
	: ($Obj_param.action="reveal")
		
		$Txt_cmd:="/usr/bin/osascript"
		$Txt_cmd:=$Txt_cmd+" -e 'if application \"Xcode\" is running then'"
		$Txt_cmd:=$Txt_cmd+" -e ' tell application \"Xcode\"'"
		
		$Txt_cmd:=$Txt_cmd+" -e ' activate'"
		
		If (String:C10($Obj_param.path)#"")
			
			$Txt_cmd:=$Txt_cmd+" -e '  open file \""+$Obj_param.path+"\"'"
			
		End if 
		
		$Txt_cmd:=$Txt_cmd+" -e ' end tell'"
		$Txt_cmd:=$Txt_cmd+" -e 'end if'"
		$Txt_cmd:=$Txt_cmd+" -e 'delay 0.1'"
		$Txt_cmd:=$Txt_cmd+" -e 'tell application \"System Events\"'"
		$Txt_cmd:=$Txt_cmd+" -e ' tell process \"Xcode\"'"
		
		// Move focus to next area, the individual file
		$Txt_cmd:=$Txt_cmd+" -e '  keystroke \"`\" using {command down, option down}'"
		$Txt_cmd:=$Txt_cmd+" -e '  delay 0.1'"
		
		// Reveal in Project Navigator
		$Txt_cmd:=$Txt_cmd+" -e '  keystroke \"j\" using {shift down, command down}'"
		$Txt_cmd:=$Txt_cmd+" -e ' end tell'"
		$Txt_cmd:=$Txt_cmd+" -e 'end tell'"
		
		If ($Obj_result.error=Null:C1517)
			
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
			
			If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
				
				If (Length:C16($Txt_error)=0)
					
					$Obj_result.success:=True:C214
					
				Else 
					
					$Obj_result.error:=$Txt_error
					$Obj_result.success:=False:C215
					
				End if 
				
			Else 
				
				$Obj_result.success:=False:C215
				
			End if 
		End if 
		
		
		// MARK:- enableForDevelopment
	: ($Obj_param.action="enableForDevelopment")
		
		If (String:C10($Obj_param.identifier)#"")
			
			OPEN URL:C673("xcdevice://enableForDevelopment?identifier="+$Obj_param.identifier)
			$Obj_result.success:=True:C214
			
		Else 
			
			$Obj_result.errors:=New collection:C1472("No identifier for device provided")
			
		End if 
		
		// MARK:- openPrefs
	: ($Obj_param.action="openPrefs")  // Quick Access to Preferences
		
		$Txt_cmd:="xcpref:// GeneralPrefs"
		
		If (String:C10($Obj_param.tab)#"")
			
			// General, Accounts, Alert, KeyBindings, FontAndColor, Navigation, Locations
			$Txt_cmd:="xcpref://"+$Obj_param.tab+"Prefs"
			
		End if 
		
		OPEN URL:C673($Txt_cmd)
		$Obj_result.success:=True:C214
		
		// MARK:- openXXXPrefs
	: (Match regex:C1019("open(.*)Prefs"; $Obj_param.action; 1; $Lon_i; $Lon_x))
		
		$Obj_param.tag:=Substring:C12($Obj_param.action; $Lon_i+4; $Lon_x-8)
		$Obj_param.action:="openPrefs"
		
		$Obj_result:=Xcode($Obj_param)
		
		//______________________________________________________
End case 

If (Length:C16($Txt_cmd)>0)
	
	var $log : Collection
	$log:=New collection:C1472
	$log.push("CMD: "+$Txt_cmd)
	$log.push("STATUS: "+($Obj_result.success ? "success" : "failed"))
	$log.push("OUTPUT: "+String:C10($Obj_result.out))
	$log.push("ERROR: "+String:C10($Obj_result.error))
	
	LOG EVENT:C667(Into 4D debug message:K38:5; $log.join("\r"); ($Obj_result.success ? Information message:K38:1 : Error message:K38:3))
	
End if 