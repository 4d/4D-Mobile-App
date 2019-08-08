//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : simulator
  // Database: 4D Mobile Express
  // ID[99B8916684A94F25B8BE366E2FF87552]
  // Created 27-6-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_i;$Lon_parameters;$Lon_pid;$Lon_x)
C_TEXT:C284($File_;$Txt_cmd;$Txt_error;$Txt_in;$Txt_key;$Txt_out;$Txt_methodOnErrorCall)
C_OBJECT:C1216($Obj_;$Obj_device;$Obj_in;$Obj_out;$Obj_runtime)
C_COLLECTION:C1488($Col_runtimes)

If (False:C215)
	C_OBJECT:C1216(simulator ;$0)
	C_OBJECT:C1216(simulator ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_out:=New object:C1471(\
		"success";False:C215;\
		"param";$Obj_in)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Obj_in.action=Null:C1517)
		
		ASSERT:C1129(False:C215)
		
		  //______________________________________________________
	: ($Obj_in.action="default")  // Return the default simulator UDID
		
		$File_:=_o_env_userPath ("preferences")+"com.apple.iphonesimulator.plist"
		
		Case of 
				
				  //----------------------------------------
			: (Test path name:C476($File_)=Is a document:K24:1)
				
				$Obj_:=plist (New object:C1471(\
					"action";"object";\
					"domain";Convert path system to POSIX:C1106($File_)))
				
				If ($Obj_.success)
					
					$Obj_out.success:=True:C214
					$Obj_out.udid:=$Obj_.value.CurrentDeviceUDID
					
				End if 
				
				  //----------------------------------------
			: (Bool:C1537($Obj_in.fix))
				
				$Obj_out:=simulator (New object:C1471(\
					"action";"fixdefault"))
				
				If ($Obj_out.success)
					
					$Obj_out:=simulator (New object:C1471(\
						"action";"default"))
					
				End if 
				
				  //----------------------------------------
		End case 
		
		  //______________________________________________________
	: ($Obj_in.action="fixdefault")
		
		$File_:=_o_env_userPath ("preferences")+"com.apple.iphonesimulator.plist"
		
		If (Test path name:C476($File_)#Is a document:K24:1)
			
			$Obj_out:=simulator (New object:C1471(\
				"action";"devices";\
				"filter";"available"))
			
			If ($Obj_out.success)
				
				$Obj_:=Null:C1517
				
				For each ($Obj_device;$Obj_out.devices)
					
					If ($Obj_device.name="iPhone@")  // Fix with only iphone
						
						If ($Obj_=Null:C1517)
							
							$Obj_:=$Obj_device
							
						Else 
							
							If (str_cmpVersion ($Obj_.runtime.version;$Obj_device.runtime.version)>-1)  // same or equal
								
								If ($Obj_.name<$Obj_device.name)  // iPhone X win
									
									$Obj_:=$Obj_device
									
								End if 
							End if 
						End if 
					End if 
				End for each 
				
				If ($Obj_#Null:C1517)
					
					$Obj_out:=plist (New object:C1471(\
						"action";"write";\
						"domain";Convert path system to POSIX:C1106($File_);\
						"key";"CurrentDeviceUDID";\
						"value";$Obj_.udid))
					
				Else 
					
					$Obj_out.success:=False:C215
					$Obj_out.errors:=New collection:C1472("No device to fix default simulator")
					
				End if 
			End if 
			
		Else 
			
			  // File already exit
			$Obj_out.success:=True:C214
			
		End if 
		  //______________________________________________________
	: ($Obj_in.action="isLaunched")\
		
		$Obj_out:=Xcode (New object:C1471(\
			"action";"tools-path"))
		
		If ($Obj_out.success)
			
			$Obj_out.posix:=$Obj_out.posix+"/Applications/Simulator.app"
			$Obj_out.path:=Convert path POSIX to system:C1107($Obj_out.posix)
			
			$Txt_cmd:="ps -e"
			LAUNCH EXTERNAL PROCESS:C811("ps -e";$Txt_in;$Txt_out;$Txt_error)
			
			  // true if list contains the launch path
			$Obj_out.value:=(Position:C15($Obj_out.posix;$Txt_out)>0)
			
			  //If (Bool($Obj_in.pid))
			  // XXX extract line with pid
			  //End if
			
		Else 
			
			$Obj_out.value:=False:C215
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="open")\
		 | ($Obj_in.action="boot")
		
		If ($Obj_in.device=Null:C1517)
			  // use default if no device
			$Obj_in.device:=simulator (New object:C1471("action";"default";"fix";True:C214)).udid
			
		End if 
		
		If ($Obj_in.device#Null:C1517)
			  // boot the selected device
			$Txt_cmd:="xcrun simctl boot "+$Obj_in.device
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error;$Lon_pid)
			If (Length:C16($Txt_error)>0)
				ob_error_add ($Obj_out;$Txt_error)
			End if 
			
		End if 
		
		  // launch process if not already launched
		$Obj_runtime:=simulator (New object:C1471("action";"isLaunched"))
		If (Not:C34($Obj_runtime.value))
			
			$Txt_cmd:="open -a "+str_singleQuoted ($Obj_runtime.posix)
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
			If (Length:C16($Txt_error)>0)
				ob_error_add ($Obj_out;$Txt_error)
			End if 
			
		End if 
		
		If (Asserted:C1132(OK=1;"LEP failed: "+$Txt_cmd))
			
			If ($Lon_pid#0)
				
				$Obj_out.success:=True:C214
				$Obj_out.simulatorPid:=$Lon_pid
				
				If (Bool:C1537($Obj_in.bringToFront))
					
					$Txt_cmd:="osascript -e 'tell app \"Simulator\" to activate'"
					LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
					
					If (Length:C16($Txt_error)>0)
						ob_error_add ($Obj_out;$Txt_error)
					End if 
				End if 
				
			End if 
			
		End if 
		
		If (Bool:C1537($Obj_in.editorToFront))
			
			DELAY PROCESS:C323(Current process:C322;60*5)
			
			$Txt_cmd:="osascript -e 'tell app \"4D\" to activate'"
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="bringToFront")
		
		$Txt_cmd:="osascript -e 'tell app \"Simulator\" to activate'"
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
		
		  //______________________________________________________
	: ($Obj_in.action="install")\
		 | ($Obj_in.action="uninstall")\
		 | ($Obj_in.action="launch")\
		 | ($Obj_in.action="terminate")
		
		If (Asserted:C1132($Obj_in.identifier#Null:C1517))
			
			$Txt_cmd:="xcrun simctl "+$Obj_in.action
			
			If ($Obj_in.device#Null:C1517)
				
				$Txt_cmd:=$Txt_cmd+" "+$Obj_in.device+" "
				
			Else 
				
				  // Use the current device
				$Txt_cmd:=$Txt_cmd+" booted "
				
			End if 
			
			$Txt_cmd:=$Txt_cmd+str_singleQuoted ($Obj_in.identifier)
			
		End if 
		
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
		
		If (Asserted:C1132(OK=1;"LEP failed: "+$Txt_cmd))
			
			If (Length:C16($Txt_error)=0)
				
				$Obj_out.success:=True:C214
				
			Else 
				
				$Obj_out.errors:=New collection:C1472($Txt_error)
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="isBooted")
		
		$Obj_out:=simulator (New object:C1471(\
			"action";"devices";\
			"filter";"booted"))
		
		If ($Obj_out.success)
			
			$Obj_out.booted:=False:C215
			
			For each ($Obj_device;$Obj_out.devices) Until ($Obj_out.booted)
				
				If ($Obj_device.udid=$Obj_in.device)\
					 & ($Obj_device.state="Booted")
					
					$Obj_out.booted:=True:C214
					
				End if 
			End for each 
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="device")
		
		If (String:C10($Obj_in.udid)#"")
			
			$Obj_out:=simulator (New object:C1471(\
				"action";"devices";\
				"filter";"available"))
			
			If ($Obj_out.success)
				
				$Obj_out.success:=False:C215
				
				For each ($Obj_device;$Obj_out.devices) Until ($Obj_out.success)
					
					If ($Obj_device.udid=$Obj_in.udid)
						
						$Obj_out.device:=$Obj_device
						$Obj_out.success:=True:C214
						
					End if 
				End for each 
			End if 
			
		Else 
			
			$Obj_out.errors:=New collection:C1472("uuid not in param")
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="kill")\
		 | ($Obj_in.action="shutdown")
		
		If ($Obj_in.device=Null:C1517)
			
			  // Kill all
			$Txt_cmd:="xcrun simctl shutdown all"
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
			
			
			If (simulator (New object:C1471("action";"isLaunched")).value)
				
				  // use applescript because kill will not remove all subprocess
				$Txt_cmd:="osascript -e 'tell app \"Simulator\" to quit'"
				LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
				
			End if 
			
		Else 
			
			$Txt_cmd:="xcrun simctl shutdown "+$Obj_in.device
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
			
		End if 
		
		$Obj_out.success:=(OK=1)
		
		If (Length:C16($Txt_error)>0)
			
			$Obj_out.errors:=New collection:C1472($Txt_error)
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="delete")\
		 | ($Obj_in.action="erase")
		
		If ($Obj_in.device=Null:C1517)
			
			  // All
			If ($Obj_in.action="delete")
				
				$Txt_cmd:="xcrun simctl delete all"
				LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
				
			End if 
			
		Else 
			
			  // One device
			$Txt_cmd:="xcrun simctl "+$Obj_in.action+" "+$Obj_in.device
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
			
		End if 
		
		$Obj_out.success:=(OK=1)
		
		If (Length:C16($Txt_error)>0)
			
			$Obj_out.errors:=New collection:C1472($Txt_error)
			
		End if 
		
		  //________________________________________
	: ($Obj_in.action="devicePath")
		
		If ($Obj_in.device#Null:C1517)
			
			$Obj_out.path:=_o_env_userPath ("simulators")+$Obj_in.device
			
			If (Bool:C1537($Obj_in.data))
				
				$Obj_out.path:=$Obj_out.path+Folder separator:K24:12+"data"
				
			End if 
			
			$Obj_out.posix:=Convert path system to POSIX:C1106($Obj_out.path)
			$Obj_out.success:=True:C214
			
		Else 
			
			$Obj_out.errors:=New collection:C1472("device must be in parameters")
			
		End if 
		
		  //________________________________________
	: ($Obj_in.action="deviceApp")
		
		If ($Obj_in.device#Null:C1517)
			
			$Obj_out.path:=_o_env_userPath ("simulators")+$Obj_in.device+Folder separator:K24:12+"data"+Folder separator:K24:12+"Containers"+Folder separator:K24:12+"Bundle"+Folder separator:K24:12+"Application"+Folder separator:K24:12
			
			$Obj_out.apps:=New collection:C1472
			
			If (Bool:C1537($Obj_in.data))
				
				$Obj_out.path:=_o_env_userPath ("simulators")+$Obj_in.device+Folder separator:K24:12+"data"+Folder separator:K24:12+"Containers"+Folder separator:K24:12+"Data"+Folder separator:K24:12+"Application"+Folder separator:K24:12
				
				$Obj_out.metaData:=New collection:C1472
				
				If (Test path name:C476($Obj_out.path)=Is a folder:K24:2)
					
					ARRAY TEXT:C222($tTxt_folders;0x0000)
					FOLDER LIST:C473($Obj_out.path;$tTxt_folders)
					
					For ($Lon_i;1;Size of array:C274($tTxt_folders);1)
						
						$File_:=$Obj_out.path+$tTxt_folders{$Lon_i}+Folder separator:K24:12+"Library"+Folder separator:K24:12+"Preferences"
						
						If (Test path name:C476($File_)=Is a folder:K24:2)
							
							ARRAY TEXT:C222($tTxt_files;0x0000)
							DOCUMENT LIST:C474($File_;$tTxt_files)
							
							If (Size of array:C274($tTxt_files)>0)  // Check that app have user default (as any 4d for ios app, this speed up  menu loading ))
								
								$File_:=$Obj_out.path+$tTxt_folders{$Lon_i}+Folder separator:K24:12+".com.apple.mobile_container_manager.metadata.plist"
								
								If (Test path name:C476($File_)=Is a document:K24:1)
									
									$Obj_:=plist (New object:C1471(\
										"action";"object";\
										"path";$File_))
									
									If ($Obj_.success)
										
										$Obj_.value.path:=$Obj_out.path+$tTxt_folders{$Lon_i}
										
										$Obj_out.metaData.push($Obj_.value)
										
									End if 
								End if 
							End if 
						End if 
					End for 
				End if 
			End if 
			
			$Obj_out.path:=_o_env_userPath ("simulators")+$Obj_in.device+Folder separator:K24:12+"data"+Folder separator:K24:12+"Containers"+Folder separator:K24:12+"Bundle"+Folder separator:K24:12+"Application"+Folder separator:K24:12
			
			If (Test path name:C476($Obj_out.path)=Is a folder:K24:2)
				
				ARRAY TEXT:C222($tTxt_folders;0x0000)
				FOLDER LIST:C473($Obj_out.path;$tTxt_folders)
				
				For ($Lon_i;1;Size of array:C274($tTxt_folders);1)
					
					ARRAY TEXT:C222($tTxt_subdir;0x0000)
					FOLDER LIST:C473($Obj_out.path+$tTxt_folders{$Lon_i};$tTxt_subdir)
					
					If (Size of array:C274($tTxt_subdir)>0)
						
						$File_:=$Obj_out.path+$tTxt_folders{$Lon_i}+Folder separator:K24:12+$tTxt_subdir{1}+Folder separator:K24:12+"Info.plist"
						
						If (Test path name:C476($File_)=Is a document:K24:1)
							
							$Obj_:=plist (New object:C1471(\
								"action";"object";\
								"path";$File_))
							
							If ($Obj_.success)
								
								$Obj_.value.path:=$Obj_out.path+$tTxt_folders{$Lon_i}
								$Obj_.value.appPath:=$Obj_.value.path+Folder separator:K24:12+$tTxt_subdir{1}
								$Obj_.value.iconPath:=$Obj_.value.appPath+Folder separator:K24:12+String:C10($Obj_.value.CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles[0])+"@2x.png"
								
								$Obj_out.apps.push($Obj_.value)
								
								If (Bool:C1537($Obj_in.data))
									
									  // Search associated metadata
									$Lon_x:=$Obj_out.metaData.extract("MCMMetadataIdentifier").indexOf($Obj_.value["CFBundleIdentifier"])
									
									If ($Lon_x#-1)
										
										$Obj_.value.metaData:=$Obj_out.metaData[$Lon_x]
										
									End if 
								End if 
							End if 
						End if 
					End if 
				End for 
			End if 
			
			$Obj_out.success:=True:C214
			
		Else 
			
			$Obj_out.errors:=New collection:C1472("device must be in parameters")
			
		End if 
		
		  //________________________________________
	: ($Obj_in.action="devicetypes")
		
		$Txt_cmd:="xcrun simctl list devicetypes --json"
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
		
		If (Asserted:C1132(OK=1;"LEP failed: "+$Txt_cmd))
			
			If (Length:C16($Txt_out)>0)
				
				$Txt_methodOnErrorCall:=Method called on error:C704
				
				ob_Lon_Error:=0
				ON ERR CALL:C155("ob_noError")
				
				$Obj_:=JSON Parse:C1218($Txt_out)
				
				ON ERR CALL:C155($Txt_methodOnErrorCall)
				
				If (ob_Lon_Error=0)
					
					$Obj_out.success:=True:C214
					$Obj_out.devicetypes:=$Obj_.devicetypes
					
				Else 
					
					$Obj_out.errors:=New collection:C1472($Txt_out)
					
				End if 
			End if 
			
		Else 
			
			$Obj_out.errors:=New collection:C1472($Txt_error)
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="runtimes")
		
		$Txt_cmd:="xcrun simctl list runtimes --json"
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
		
		If (Asserted:C1132(OK=1;"LEP failed: "+$Txt_cmd))
			
			If (Length:C16($Txt_out)>0)
				
				$Txt_methodOnErrorCall:=Method called on error:C704
				
				ob_Lon_Error:=0
				ON ERR CALL:C155("ob_noError")
				
				$Obj_:=JSON Parse:C1218($Txt_out)
				
				ON ERR CALL:C155($Txt_methodOnErrorCall)
				
				If (ob_Lon_Error=0)
					
					$Obj_out.success:=True:C214
					
					If ($Obj_in.name=Null:C1517)
						
						$Obj_out.runtimes:=$Obj_.runtimes
						
					End if 
					
				Else 
					
					$Obj_out.errors:=New collection:C1472($Txt_out)
					
				End if 
			End if 
			
		Else 
			
			$Obj_out.errors:=New collection:C1472($Txt_error)
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="devices")
		
		$Txt_cmd:="xcrun simctl list devices --json"
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
		
		If (Asserted:C1132(OK=1;"LEP failed: "+$Txt_cmd))
			
			If (Length:C16($Txt_out)>0)
				
				$Txt_methodOnErrorCall:=Method called on error:C704
				
				ob_Lon_Error:=0
				ON ERR CALL:C155("ob_noError")
				
				$Obj_:=JSON Parse:C1218($Txt_out)
				
				ON ERR CALL:C155($Txt_methodOnErrorCall)
				
				If (ob_Lon_Error=0)
					
					$Obj_out.success:=True:C214
					
					Case of 
							
							  //………………………………………………………………………………………
						: ($Obj_in.filter=Null:C1517)
							
							$Obj_out.devices:=$Obj_.devices
							
							  //………………………………………………………………………………………
						: ($Obj_in.filter="booted")
							
							$Obj_out.devices:=New collection:C1472
							
							For each ($Txt_key;$Obj_.devices)
								
								If (Value type:C1509($Obj_.devices[$Txt_key])=Is collection:K8:32)
									
									For each ($Obj_device;$Obj_.devices[$Txt_key])
										
										If (String:C10($Obj_device.state)="Booted")\
											 & ((String:C10($Obj_device.name)="iPhone@")\
											 | (String:C10($Obj_device.name)="iPad@"))
											
											$Obj_out.devices.push($Obj_device)
											
										End if 
									End for each 
								End if 
							End for each 
							
							  //………………………………………………………………………………………
						: ($Obj_in.filter="available")
							
							$Col_runtimes:=simulator (New object:C1471("action";"runtimes")).runtimes  // XXX could speed up by asking runtimes only time before and filter here
							
							$Obj_out.devices:=New collection:C1472
							
							For each ($Txt_key;$Obj_.devices)
								
								If (Value type:C1509($Obj_.devices[$Txt_key])=Is collection:K8:32)
									
									For each ($Obj_device;$Obj_.devices[$Txt_key])
										
										If ((String:C10($Obj_device.availability)="(available)") | (Bool:C1537($Obj_device.isAvailable)))\
											 & ((String:C10($Obj_device.name)="iPhone@")\
											 | (String:C10($Obj_device.name)="iPad@"))
											
											For each ($Obj_runtime;$Col_runtimes)
												
												If (($Obj_runtime.name=$Txt_key)\
													 | ($Obj_runtime.identifier=$Txt_key))
													
													If (str_cmpVersion ($Obj_runtime.version;$Obj_in.minimumVersion)>=0)  // Equal or higher
														
														$Obj_device.runtime:=$Obj_runtime
														$Obj_out.devices.push($Obj_device)
														
													End if 
												End if 
											End for each 
										End if 
									End for each 
								End if 
							End for each 
							
							  //………………………………………………………………………………………
						Else 
							
							ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_in.filter+"\"")
							
							  //………………………………………………………………………………………
					End case 
					
				Else 
					
					$Obj_out.errors:=New collection:C1472($Txt_out)
					
				End if 
				
			Else 
				
				$Obj_out.errors:=New collection:C1472($Txt_error)
				
			End if 
		End if 
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
If (Bool:C1537($Obj_in.caller))
	
	CALL FORM:C1391($Obj_in.caller;"editor_CALLBACK";"simulator";$Obj_out)
	
Else 
	
	$0:=$Obj_out
	
End if 

  // ----------------------------------------------------
  // End