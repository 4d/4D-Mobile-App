//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : device
// ID[94544ADDC4DD4700BE3FF62AAE2E5D2F]
// Created 27-6-2017 by Eric Marchand
// ----------------------------------------------------
// Description:
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters; $Lon_x)
C_TEXT:C284($kTxt_bundleName; $Txt_buffer; $Txt_cmd; $Txt_error; $Txt_in; $Txt_out)
C_OBJECT:C1216($Obj_; $Obj_in; $Obj_out)

If (False:C215)
	C_OBJECT:C1216(device; $0)
	C_OBJECT:C1216(device; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	// Required parameters
	$Obj_in:=$1
	
	// Optional parameters
	If ($Lon_parameters>=2)
		
		// <NONE>
		
	End if 
	
	$kTxt_bundleName:="Apple Configurator 2.app"
	
	$Obj_out:=New object:C1471("success"; False:C215; "param"; $Obj_in)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Obj_in.action=Null:C1517)
		
		ASSERT:C1129(False:C215; "Missing parameter \"action\"")
		
		//______________________________________________________
	: ($Obj_in.action="appName")
		
		$Obj_out.value:=Replace string:C233($kTxt_bundleName; ".app"; "")
		
		//______________________________________________________
	: ($Obj_in.action="appStore")
		
		OPEN URL:C673(Get localized string:C991("appstore_configurator"); *)
		
		//______________________________________________________
	: ($Obj_in.action="appPath")
		
		// Default path, to speed up
		If ((Test path name:C476(Convert path POSIX to system:C1107("/Applications/"+$kTxt_bundleName))=Is a folder:K24:2))
			
			$Obj_out.path:="/Applications/"+$kTxt_bundleName+"/Contents/MacOS/cfgutil"
			$Obj_out.success:=(Test path name:C476(Convert path POSIX to system:C1107($Obj_out.path))=Is a document:K24:1)
			
		Else 
			
			$Obj_out:=device(New object:C1471("action"; "appConfiguratorPaths"))  // Using spotlight
			
			If ($Obj_out.success)
				
				$Obj_out.path:=$Obj_out.paths[0]+"/Contents/MacOS/cfgutil"
				$Obj_out.success:=(Test path name:C476(Convert path POSIX to system:C1107($Obj_out.path))=Is a document:K24:1)
				
			Else 
				
				// Last try, by watching at path
				$Txt_cmd:="which cfgutil"
				
				LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
				
				If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
					
					If ((Length:C16($Txt_error)=0) & (Length:C16($Txt_out)>0))
						
						$Obj_out.success:=True:C214
						$Obj_out.path:=$Txt_out
						
					End if 
				End if 
			End if 
		End if 
		
		//______________________________________________________
	: ($Obj_in.action="appConfiguratorPaths")
		
		// Get all installed apple configurator using spotlight
		$Txt_cmd:="mdfind \"kMDItemCFBundleIdentifier == 'com.apple.configurator.ui'\""
		
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
		
		If (Asserted:C1132(OK=1; "Get paths failed: "+$Txt_cmd))
			
			If ((Length:C16($Txt_error)=0) & (Length:C16($Txt_out)#0))
				
				$Obj_out.paths:=New collection:C1472
				
				$Lon_x:=Position:C15("\n"; $Txt_out)
				
				While ($Lon_x#0)
					
					$Txt_buffer:=Substring:C12($Txt_out; 1; $Lon_x-1)
					$Obj_out.paths.push($Txt_buffer)
					$Txt_out:=Substring:C12($Txt_out; $Lon_x+1)
					$Lon_x:=Position:C15("\n"; $Txt_out)
					
				End while 
				
				$Obj_out.success:=($Obj_out.paths.length>0)
				
			Else 
				
				$Obj_out.error:=Choose:C955(Length:C16($Txt_error)=0; "No apple configurator installed"; $Txt_error)  //#MARK_LOCALIZE
				
			End if 
		End if 
		
		//______________________________________________________
	: ($Obj_in.action="ecid")
		
		If (Length:C16(String:C10($Obj_in.udid))=0)
			
			$Obj_out.errors:=New collection:C1472("You must define a search criteria like udid")  //#MARK_LOCALIZE
			
		Else 
			
			$Obj_out:=device(New object:C1471("action"; "appPath"))
			
			If ($Obj_out.success)
				
				$Txt_cmd:=str_singleQuoted($Obj_out.path)+" --format JSON list"
				
				LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
				
				If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
					
					If (Match regex:C1019("(?msi)^\\{.*\\}$"; $Txt_out; 1))
						
						$Obj_out.value:=JSON Parse:C1218($Txt_out)
						
						If (Value type:C1509($Obj_out.value.Output)=Is object:K8:27)
							
							For each ($Txt_buffer; $Obj_out.value.Output) Until ($Obj_out.device#Null:C1517)  // ecid(s)
								
								If ($Obj_out.value.Output[$Txt_buffer].UDID=$Obj_in.udid)
									
									$Obj_out.device:=$Obj_out.value.Output[$Txt_buffer]
									$Obj_out.value:=$Txt_buffer  // ecid
									
								End if 
							End for each 
						End if 
					End if 
				End if 
			End if 
		End if 
		
		//______________________________________________________
	: ($Obj_in.action="plugged")
		
		// Get devices plugged
		$Obj_out:=device(New object:C1471("action"; "appPath"))
		
		If ($Obj_out.success)
			
			$Txt_cmd:=str_singleQuoted($Obj_out.path)+" --format JSON list"
			
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
			
			If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
				
				$Lon_x:=Position:C15("{"; $Txt_out)
				
				If ((Length:C16($Txt_error)=0) | ($Lon_x=1))
					
					$Obj_out.value:=JSON Parse:C1218($Txt_out)
					
					If (Value type:C1509($Obj_out.value.Output)=Is object:K8:27)
						
						$Obj_out.idType:="edid"
						
						$Obj_out.devices:=New collection:C1472
						
						For each ($Txt_buffer; $Obj_out.value.Output)  //  ecid(s)
							
							$Obj_:=$Obj_out.value.Output[$Txt_buffer]
							$Obj_.ecid:=String:C10($Obj_.ECID)
							$Obj_.udid:=String:C10($Obj_.UDID)
							
							$Obj_out.devices.push($Obj_)
							
						End for each 
					End if 
					
					$Obj_out.success:=($Obj_out.devices.length>0)
					
					If (Length:C16($Txt_error)>0)
						
						$Obj_out.error:=$Txt_error  // and error could be not fatal here
						
					End if 
					
				Else 
					
					$Obj_out.error:=$Txt_error
					$Obj_out.out:=$Txt_out
					$Obj_out.success:=False:C215
					
				End if 
			End if 
			
		Else 
			
			$Txt_cmd:="instruments -s devices"  // Other options if no cfgutil list
			
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
			
			If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
				
				If (Length:C16($Txt_error)=0)
					
					For each ($Txt_buffer; Split string:C1554($Txt_out; "\\n"); 1)
						
						ARRAY TEXT:C222($tTxt_buffer; 0x0000)
						
						If (Rgx_MatchText("(.*) \\((.*)\\) \\[(.*)]$"; $Txt_buffer; ->$tTxt_buffer)=0)
							
							$Obj_:=New object:C1471("name"; $tTxt_buffer{1}; "os"; $tTxt_buffer{2}; "udid"; $tTxt_buffer{3})
							
							If ($Obj_out.devices=Null:C1517)
								
								$Obj_out.success:=True:C214
								$Obj_out.devices:=New collection:C1472($Obj_)
								$Obj_out.device:=$Obj_
								
							Else 
								
								$Obj_out.devices.push($Obj_)
								
							End if 
						End if 
					End for each 
					
					$Obj_out.idType:="udid"
					$Obj_out.success:=True:C214
					
				Else 
					
					$Obj_out.error:=$Txt_error
					$Obj_out.out:=$Txt_out
					
				End if 
			End if 
		End if 
		
		//______________________________________________________
	: ($Obj_in.action="fromProvisioningProfiles")
		
		// Get devices in local provisioning profiles
		$Obj_out:=provisioningProfiles(New object:C1471("action"; "read"))
		
		If ($Obj_out.success)
			
			If (Bool:C1537($Obj_in.indexed))
				
				// hash: udid as key, collection of provisioningProfiles
				$Obj_out.devices:=New object:C1471
				
			Else 
				
				// list of udid
				$Obj_out.devices:=New collection:C1472
				
			End if 
			
			For each ($Obj_; $Obj_out.value)
				
				If ($Obj_.ProvisionedDevices#Null:C1517)
					
					If (Value type:C1509($Obj_.ProvisionedDevices)=Is collection:K8:32)
						
						For each ($Txt_buffer; $Obj_.ProvisionedDevices)
							
							If (Bool:C1537($Obj_in.indexed))
								
								If ($Obj_out.devices[$Txt_buffer]=Null:C1517)
									
									$Obj_out.devices[$Txt_buffer]:=New collection:C1472
									
								End if 
								
								$Obj_out.devices[$Txt_buffer].push($Obj_)
								
							Else 
								
								If ($Obj_out.devices.indexOf($Txt_buffer)<0)
									
									$Obj_out.devices.push($Txt_buffer)
									
								End if 
							End if 
						End for each 
					End if 
				End if 
			End for each 
		End if 
		
		//______________________________________________________
	: ($Obj_in.action="installApp")
		
		If (Test path name:C476(String:C10($Obj_in.path))=Is a document:K24:1)  // Check if folder or archive file
			
			$Obj_:=device(New object:C1471("action"; "appPath"))
			
			Case of 
					
					// ----------------------------------------
				: ($Obj_.success)
					
					$Txt_cmd:=str_singleQuoted($Obj_.path)
					
					$Txt_cmd:=$Txt_cmd+" --format JSON"
					
					If (Bool:C1537($Obj_in.debug))
						
						$Txt_cmd:=$Txt_cmd+" --verbose"
						
					End if 
					
					Case of 
							
							// ........................................
						: (Length:C16(String:C10($Obj_in.device))>0)
							
							$Txt_cmd:=$Txt_cmd+" --ecid "+$Obj_in.device
							
							// ........................................
						: (Length:C16(String:C10($Obj_in.ecid))>0)
							
							$Txt_cmd:=$Txt_cmd+" --ecid "+$Obj_in.ecid
							
							// ........................................
						: (Length:C16(String:C10($Obj_in.udid))>0)
							
							$Obj_out:=device(New object:C1471("action"; "ecid"; "udid"; $Obj_in.udid))
							
							If ($Obj_out.success)
								
								$Txt_cmd:=$Txt_cmd+" --ecid "+$Obj_out.value
								
							Else 
								
								ASSERT:C1129(False:C215; "No ecid for udid "+$Obj_in.udid)  // TODO do not try to install app
								
							End if 
							
							// ........................................
					End case 
					
					$Txt_cmd:=$Txt_cmd+" install-app "+str_singleQuoted(Convert path system to POSIX:C1106($Obj_in.path))
					
					LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
					
					If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
						
						If (Match regex:C1019("(?msi)^\\{.*\\}$"; $Txt_out; 1))
							
							$Obj_out.value:=JSON Parse:C1218($Txt_out)
							
							Case of 
									
									// ........................................
								: (String:C10($Obj_out.value.Type)="Error")
									
									$Obj_out.success:=False:C215
									$Obj_out.errors:=New collection:C1472(String:C10($Obj_out.value.Message))
									
									// ........................................
								: (String:C10($Obj_out.value.Type)="CommandOutput")
									
									$Obj_out.success:=True:C214
									
									// ........................................
								Else 
									
									$Obj_out.success:=False:C215
									$Obj_out.errors:=New collection:C1472("Unknown output type: "+String:C10($Obj_out.value.Type))  //#MARK_LOCALIZE
									
									// ........................................
							End case 
							
						Else 
							
							$Obj_out.errors:=New collection:C1472($Txt_error)
							$Obj_out.out:=$Txt_out
							
						End if 
					End if 
					
					// ----------------------------------------
				: (Test path name:C476(Convert path POSIX to system:C1107("/usr/local/bin/ios-deploy"))=Is a folder:K24:2)  // XXX better check in path
					
					// if ipa unzip to get app
					
					$Txt_cmd:="/usr/local/bin/ios-deploy"
					
					If (Bool:C1537($Obj_in.debug))
						
						$Txt_cmd:=$Txt_cmd+" --debug"
						
					End if 
					
					If (Length:C16(String:C10($Obj_in.device))>0)
						
						$Txt_cmd:=$Txt_cmd+" --id "+$Obj_in.device
						
					End if 
					
					$Txt_cmd:=$Txt_cmd+" --bundle "+str_singleQuoted(Convert path system to POSIX:C1106($Obj_in.path))
					
					LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
					
					If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
						
						If (Length:C16($Txt_error)=0)
							
							$Obj_out.success:=True:C214
							
						Else 
							
							$Obj_out.errors:=New collection:C1472($Txt_error)
							
						End if 
					End if 
					
					// ----------------------------------------
				Else 
					
					$Obj_out.errors:=New collection:C1472("No method to install app on device")  //#MARK_LOCALIZE
					
					// ----------------------------------------
			End case 
			
		Else 
			
			$Obj_out.errors:=New collection:C1472("No path for ipa to install")  //#MARK_LOCALIZE
			
		End if 
		
		//______________________________________________________
	: ($Obj_in.action="removeApp")
		
		If (Length:C16(String:C10($Obj_in.identifier))>0)  // identifier
			
			$Obj_:=device(New object:C1471("action"; "appPath"))
			
			Case of 
					
					// ----------------------------------------
				: ($Obj_.success)
					
					$Txt_cmd:=str_singleQuoted($Obj_.path)
					
					$Txt_cmd:=$Txt_cmd+" --format JSON"
					
					If (Bool:C1537($Obj_in.debug))
						
						$Txt_cmd:=$Txt_cmd+" --verbose"
						
					End if 
					
					Case of 
							
							// ........................................
						: (Length:C16(String:C10($Obj_in.device))>0)
							
							$Txt_cmd:=$Txt_cmd+" --ecid "+$Obj_in.device
							
							// ........................................
						: (Length:C16(String:C10($Obj_in.ecid))>0)
							
							$Txt_cmd:=$Txt_cmd+" --ecid "+$Obj_in.ecid
							
							// ........................................
						: (Length:C16(String:C10($Obj_in.udid))>0)
							
							$Obj_out:=device(New object:C1471("action"; "ecid"; "udid"; $Obj_in.udid))
							
							If ($Obj_out.success)
								
								$Txt_cmd:=$Txt_cmd+" --ecid "+$Obj_.value
								
							Else 
								
								ASSERT:C1129(False:C215; "No ecid for udid "+$Obj_in.udid)  // TODO do not try to install app
								
							End if 
							
							// ........................................
					End case 
					
					$Txt_cmd:=$Txt_cmd+" remove-app "+str_singleQuoted($Obj_in.identifier)
					
					LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
					
					If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
						
						If (Match regex:C1019("(?msi)^\\{.*\\}$"; $Txt_out; 1))
							
							$Obj_out.value:=JSON Parse:C1218($Txt_out)
							
							Case of 
									
									// ........................................
								: (String:C10($Obj_out.value.Type)="Error")
									
									$Obj_out.success:=False:C215
									$Obj_out.errors:=New collection:C1472(String:C10($Obj_out.value.Message))
									$Obj_out.error:=String:C10($Obj_out.value.Message)
									$Obj_out.errorCode:=Num:C11($Obj_out.value.Code)
									
									// ........................................
								: (String:C10($Obj_out.value.Type)="CommandOutput")
									
									$Obj_out.success:=True:C214
									
									// ........................................
								Else 
									
									$Obj_out.success:=False:C215
									$Obj_out.errors:=New collection:C1472("Unknown output type: "+String:C10($Obj_out.value.Type))  //#MARK_LOCALIZE
									
									// ........................................
							End case 
							
						Else 
							
							$Obj_out.errors:=New collection:C1472($Txt_error)
							$Obj_out.out:=$Txt_out
							
						End if 
					End if 
					
					// ----------------------------------------
				: (Test path name:C476(Convert path POSIX to system:C1107("/usr/local/bin/ios-deploy"))=Is a folder:K24:2)  // XXX better check in path
					
					$Txt_cmd:="/usr/local/bin/ios-deploy"
					
					If (Bool:C1537($Obj_in.debug))
						
						$Txt_cmd:=$Txt_cmd+" --debug"
						
					End if 
					
					If (Length:C16(String:C10($Obj_in.device))>0)
						
						$Txt_cmd:=$Txt_cmd+" --id "+$Obj_in.device
						
					End if 
					
					$Txt_cmd:=$Txt_cmd+" --uninstall_only --bundle_id "+str_singleQuoted($Obj_in.identifier)
					
					LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
					
					If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
						
						If (Length:C16($Txt_error)=0)
							
							$Obj_out.success:=True:C214
							
						Else 
							
							$Obj_out.errors:=New collection:C1472($Txt_error)
							
						End if 
					End if 
					
					// ----------------------------------------
					ASSERT:C1129(False:C215; "RemoveApp not implemented without apple configurator")
					
					// ----------------------------------------
			End case 
			
		Else 
			
			$Obj_out.errors:=New collection:C1472("app 'identifier' must be specified to remove app")  //#MARK_LOCALIZE
			
		End if 
		
		//______________________________________________________
	: ($Obj_in.action="activate")
		
		$Obj_:=device(New object:C1471("action"; "appPath"))
		
		If ($Obj_.success)
			
			$Txt_cmd:=str_singleQuoted($Obj_.path)
			
			$Txt_cmd:=$Txt_cmd+" --format JSON"
			
			If (Bool:C1537($Obj_in.debug))
				
				$Txt_cmd:=$Txt_cmd+" --debug"
				
			End if 
			
			Case of 
					
					// ........................................
				: (Length:C16(String:C10($Obj_in.device))>0)
					
					$Txt_cmd:=$Txt_cmd+" --ecid "+$Obj_in.device
					
					// ........................................
				: (Length:C16(String:C10($Obj_in.ecid))>0)
					
					$Txt_cmd:=$Txt_cmd+" --ecid "+$Obj_in.ecid
					
					// ........................................
				: (Length:C16(String:C10($Obj_in.udid))>0)
					
					$Obj_out:=device(New object:C1471("action"; "ecid"; "udid"; $Obj_in.udid))
					
					If ($Obj_out.success)
						
						$Txt_cmd:=$Txt_cmd+" --ecid "+$Obj_.value
						
					Else 
						
						ASSERT:C1129(False:C215; "No ecid for udid "+$Obj_in.udid)  // TODO do not try to install app
						
					End if 
					
					// ........................................
			End case 
			
			$Txt_cmd:=$Txt_cmd+" activate"
			
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
			
			If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
				
				If ((Length:C16($Txt_error)=0) & (Length:C16($Txt_out)>0))
					
					$Obj_out.value:=JSON Parse:C1218($Txt_out)
					
					Case of 
							
							// ----------------------------------------
						: (String:C10($Obj_out.value.Type)="Error")
							
							$Obj_out.success:=False:C215
							$Obj_out.errors:=New collection:C1472(String:C10($Obj_out.value.Message))
							
							// ----------------------------------------
						: (String:C10($Obj_out.value.Type)="CommandOutput")
							
							$Obj_out.success:=True:C214
							
							// ----------------------------------------
						Else 
							
							$Obj_out.success:=False:C215
							$Obj_out.errors:=New collection:C1472("Unknown output type: "+String:C10($Obj_out.value.Type))  //#MARK_LOCALIZE
							
							// ----------------------------------------
					End case 
					
				Else 
					
					$Obj_out.errors:=New collection:C1472($Txt_error)
					$Obj_out.out:=$Txt_out
					
				End if 
			End if 
			
		Else 
			
			$Obj_out.errors:=New collection:C1472("No app configurator")  //#MARK_LOCALIZE
			
		End if 
		
		//______________________________________________________
	: ($Obj_in.action="appInstalled")
		
		ASSERT:C1129(False:C215; "appInstalled not implemented")
		
		// cfgutil --format JSON get installedApps
		// ios-deploy --list_bundle_id
		
		//______________________________________________________
	: ($Obj_in.action="wait")
		
		$Txt_cmd:="xcrun xcdevice check"
		
		If ($Obj_in.timeout#Null:C1517)
			
			$Txt_cmd:=$Txt_cmd+" --timeout="+String:C10($Obj_in.timeout)
			
		End if 
		
		If ($Obj_in.udid#Null:C1517)
			
			$Txt_cmd:=$Txt_cmd+" "+String:C10($Obj_in.udid)
			
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
			
			If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
				
				If (Length:C16($Txt_error)=0)
					
					$Obj_out.success:=True:C214
					
				Else 
					
					$Obj_out.error:=$Txt_error
					
				End if 
			End if 
			
		Else 
			
			ASSERT:C1129(dev_Matrix; "Must provide udid")
			
		End if 
		
		//________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$Obj_in.action+"\"")
		
		//………………………………………………………………………………………
End case 

// ----------------------------------------------------
// Return
If (Bool:C1537($Obj_in.caller))
	
	CALL FORM:C1391($Obj_in.caller; "editor_CALLBACK"; "device"; $Obj_out)
	
Else 
	
	$0:=$Obj_out
	
End if 

// ----------------------------------------------------
// End