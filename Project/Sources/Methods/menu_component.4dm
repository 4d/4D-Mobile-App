//%attributes = {"invisible":true}
C_BLOB:C604($Blb_data)
C_LONGINT:C283($Lon_error;$Lon_i)
C_TEXT:C284($Dir_dst;$Dir_src;$Dom_buildAppPath;$Dom_root;$File_buildApp;$File_buildAppPath)
C_TEXT:C284($Txt_baseName;$Txt_cmd;$Txt_err;$Txt_in;$Txt_name;$Txt_out)
C_TEXT:C284($Txt_parameter;$Txt_path)
C_OBJECT:C1216($o)
C_COLLECTION:C1488($Col_)

ARRAY TEXT:C222($tTxt_headerNames;0)
ARRAY TEXT:C222($tTxt_headerValues;0)

$Txt_name:="4D Mobile App"  // XXX method to get the name?
$Txt_baseName:=$Txt_name+".4dbase"

$File_buildApp:=Get 4D folder:C485(Database folder:K5:14)+"Preferences"+Folder separator:K24:12+"BuildApp"+Folder separator:K24:12+"BuildApp.xml"

$Txt_parameter:=Get selected menu item parameter:C1005

  // read build path from build app xml
$Dom_root:=DOM Parse XML source:C719($File_buildApp)
$Dom_buildAppPath:=Choose:C955(Is macOS:C1572;DOM Find XML element:C864($Dom_root;"Preferences4D/BuildApp/BuildMacDestFolder");DOM Find XML element:C864($Dom_root;"Preferences4D/BuildApp/BuildWinDestFolder"))

$File_buildAppPath:=""
DOM GET XML ELEMENT VALUE:C731($Dom_buildAppPath;$File_buildAppPath)

If (Length:C16($File_buildAppPath)>0)
	
	  // copy to 4d
	$Dir_src:=$File_buildAppPath+"Components"+Folder separator:K24:12+$Txt_baseName+Folder separator:K24:12
	
	Case of 
			
			  //________________________________________
		: ($Txt_parameter="deploy")
			
			If (Test path name:C476($Dir_src)=Is a folder:K24:2)
				
				$Dir_dst:=Application file:C491+Folder separator:K24:12+"Contents"+Folder separator:K24:12+"Resources"+Folder separator:K24:12+"Internal User Components"+Folder separator:K24:12+$Txt_baseName+Folder separator:K24:12
				
				If (Test path name:C476($Dir_dst)=Is a folder:K24:2)
					
					$Txt_cmd:="rm -R "+str_singleQuoted (Convert path system to POSIX:C1106($Dir_dst))
					LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_err)
					
				End if 
				
				$Txt_cmd:="cp -R "+str_singleQuoted (Convert path system to POSIX:C1106($Dir_src))+" "+str_singleQuoted (Convert path system to POSIX:C1106($Dir_dst))
				LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_err)
				
				If (Length:C16($Txt_err)=0)
					
					RESTART 4D:C1292
					
				Else 
					
					TRACE:C157
					
				End if 
				
			Else 
				
				ALERT:C41("No build source. Launch a build before deploying.")
				
			End if 
			
			  //________________________________________
		: ($Txt_parameter="build")
			
			If (Shift down:C543)  // increment build number
				
				$Dir_src:=Get 4D folder:C485(Database folder:K5:14)+"Info.plist"
				$o:=plist (New object:C1471(\
					"action";"object";\
					"path";$Dir_src+"Info.plist"))
				
				If ($o.success)
					
					$Lon_i:=Num:C11($o.value.CFBundleVersion)+1
					$o.value.CFBundleVersion:=String:C10($Lon_i)
					$o:=plist (New object:C1471(\
						"action";"fromobject";\
						"object";$o.value;\
						"path";$Dir_src+"Info.plist";\
						"format";"xml1"))
					
				End if 
			End if 
			
			BUILD APPLICATION:C871($File_buildApp)
			
			COPY DOCUMENT:C541(Get 4D folder:C485(Database folder:K5:14)+"Info.plist";$Dir_src+"Info.plist";*)
			
			If (OK=1)
				
				DISPLAY NOTIFICATION:C910("Build component";"The component has been builded")
				
			Else 
				
				ALERT:C41("Build failed")
				
			End if 
			
			  //________________________________________
		: ($Txt_parameter="p4")
			
			$Txt_path:="/usr/local/bin/p4"
			
			  // setup env
			$Txt_cmd:="export P4CONFIG=~/.p4settings;source ~/.p4settings"  // source "+str_singleQuoted (Convert path system to POSIX(env_userPath ("home")+".p4setting"))
			
			SET ENVIRONMENT VARIABLE:C812("P4CONFIG";"~/.p4settings")
			
			  //For each ($Txt_parameter;Split string(Document to text(env_userPath ("home")+".p4settings");"\r"))
			For each ($Txt_parameter;Split string:C1554(env_userPathname ("home").file(".p4settings").getText();"\r"))
				
				$Col_:=Split string:C1554($Txt_parameter;"=")
				
				If ($Col_.length>1)
					
					SET ENVIRONMENT VARIABLE:C812($Col_[0];$Col_[1])
					
				End if 
			End for each 
			
			  // binary
			$Txt_cmd:=$Txt_path+" edit "+str_singleQuoted (Convert path system to POSIX:C1106($Dir_src+$Txt_name+".4DC"))
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_err)
			
			$Txt_cmd:=$Txt_path+" edit "+str_singleQuoted (Convert path system to POSIX:C1106($Dir_src+$Txt_name+".4DIndy"))
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_err)
			
			  // source
			$Dir_src:=Get 4D folder:C485(Database folder:K5:14)
			$Txt_cmd:=$Txt_path+" edit "+str_singleQuoted (Convert path system to POSIX:C1106($Dir_src+$Txt_name+".4DB"))
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_err)
			$Txt_cmd:=$Txt_path+" edit "+str_singleQuoted (Convert path system to POSIX:C1106($Dir_src+$Txt_name+".4DIndy"))
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_err)
			
			  //________________________________________
		: ($Txt_parameter="increment")  // increment CFBundleVersion
			
			If (Not:C34(Shift down:C543))
				
				$Dir_src:=Get 4D folder:C485(Database folder:K5:14)
				
				  // Else increment build one
				
			End if 
			
			$o:=plist (New object:C1471(\
				"action";"object";\
				"path";$Dir_src+"Info.plist"))
			
			If ($o.success)
				
				$Lon_i:=Num:C11($o.value.CFBundleVersion)+1
				$o.value.CFBundleVersion:=String:C10($Lon_i)
				$o:=plist (New object:C1471(\
					"action";"fromobject";\
					"object";$o.value;\
					"path";$Dir_src+"Info.plist";\
					"format";"xml1"))
				
				If ($o.success)
					
					DISPLAY NOTIFICATION:C910("Build component";"Incremented to "+String:C10($Lon_i))
					
				Else 
					
					ALERT:C41("FAiled to write to Info.plist to increment CFBundleVersion to "+String:C10($Lon_i))
					
				End if 
				
			Else 
				
				ALERT:C41("Unable to read Info.plist to increment CFBundleVersion")
				
			End if 
			
			  //________________________________________
		: ($Txt_parameter="updateSDK")
			
			If (Length:C16(String:C10(commonValues.sdk.update.url))>0)
				
				If (Value type:C1509(commonValues.sdk.update.headers)=Is object:K8:27)
					
					OB GET PROPERTY NAMES:C1232(commonValues.sdk.update.headers;$tTxt_headerNames)
					ARRAY TEXT:C222($tTxt_headerValues;Size of array:C274($tTxt_headerNames))
					
					For ($Lon_i;1;Size of array:C274($tTxt_headerNames);1)
						
						$tTxt_headerValues{$Lon_i}:=OB Get:C1224(commonValues.sdk.update.headers;$tTxt_headerNames{$Lon_i})
						
					End for 
				End if 
				
				$Lon_error:=HTTP Request:C1158(HTTP GET method:K71:1;commonValues.sdk.update.url;"";$Blb_data;$tTxt_headerNames;$tTxt_headerValues)
				
				If ($Lon_error=200)
					
					$o:=COMPONENT_Pathname ("sdk").file()
					
					If ($o.exists)
						
						$o.delete()
						
					End if 
					
					BLOB TO DOCUMENT:C526($o.platformPath;$Blb_data)
					
					  // remove from cache
					If (env_userPathname ("cache").folder(".sdk").exists)
						
						env_userPathname ("cache").folder(".sdk").delete(fk recursive:K87:7)
						
					End if 
					
					DISPLAY NOTIFICATION:C910("SDK Update";"The SDK has been updated")
					
				Else 
					
					ALERT:C41("Failed to update SDK with error "+String:C10($Lon_error))
					
				End if 
			End if 
			
			  //________________________________________
		Else 
			
			ALERT:C41("Unknown action "+$Txt_parameter)
			
			  //________________________________________
	End case 
	
Else 
	
	ALERT:C41("Unable to find build path")
	
End if 