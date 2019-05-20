//%attributes = {"invisible":true}
/*
result := ***provisioningProfiles*** ( param )
 -> param (Object)
 <- result (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : provisioningProfiles
  // Database: 4D Mobile App
  // Created by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Get information about installed provisioning profiles
  // in mac os folder
  // You can find it in your Library folder, MobileDevice/Provisioning Profiles/
  // This file are decodable using security and are in plist format
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_cmd;$Txt_error;$Txt_in;$Txt_out;$Txt_path;$Txt_plist;$Txt_poxix)
C_OBJECT:C1216($Obj_param;$Obj_result)
C_COLLECTION:C1488($Col_result)

ARRAY TEXT:C222($tTxt_files;0)

If (False:C215)
	C_OBJECT:C1216(provisioningProfiles ;$0)
	C_OBJECT:C1216(provisioningProfiles ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_param:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE";"True")
	
	$Obj_result:=New object:C1471("success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

Case of 
		
		  //______________________________________________________
	: ($Obj_param.action=Null:C1517)
		
		ASSERT:C1129(False:C215)
		
		  //______________________________________________________
	: ($Obj_param.action="path")
		
		$Obj_result.success:=True:C214
		
		  // An additional separator
		$Obj_result.posix:=_o_env_userPath ("library";True:C214)+"MobileDevice/Provisioning Profiles/"
		$Obj_result.path:=Convert path POSIX to system:C1107($Obj_result.posix)
		
		  //______________________________________________________
	: ($Obj_param.action="paths")
		
		$Obj_result:=provisioningProfiles (New object:C1471("action";"path"))
		
		If ($Obj_result.success)
			
			If (Test path name:C476(String:C10($Obj_result.path))=Is a folder:K24:2)
				
				DOCUMENT LIST:C474($Obj_result.path;$tTxt_files;Absolute path:K24:14+Posix path:K24:15)
				
				$Col_result:=New collection:C1472
				ARRAY TO COLLECTION:C1563($Col_result;$tTxt_files)
				$Obj_result.paths:=$Col_result
				
			Else 
				
				$Obj_result.paths:=New collection:C1472
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($Obj_param.action="read")
		
		If ($Obj_param.path=Null:C1517)
			
			$Obj_result:=provisioningProfiles (New object:C1471("action";"paths"))
			
			If ($Obj_result.success)
				
				$Col_result:=New collection:C1472
				
				For each ($Txt_path;$Obj_result.paths)
					
					$Obj_result:=provisioningProfiles (New object:C1471("action";"read";"path";$Txt_path))
					
					If ($Obj_result.success)
						
						$Col_result.push($Obj_result.value)
						
					End if 
				End for each 
				
				$Obj_result:=New object:C1471("success";True:C214;"value";$Col_result)
				
			End if 
			
		Else 
			
			  // read one provisionning profile
			$Txt_plist:=Temporary folder:C486+Generate UUID:C1066+"mp.plist"
			
			$Txt_cmd:="/usr/bin/security cms -D -i "+str_singleQuoted ($Obj_param.path)
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
			
			If (Asserted:C1132(OK=1;"LEP failed: "+$Txt_cmd))
				
				If (Length:C16($Txt_out)>0)
					
					TEXT TO DOCUMENT:C1237($Txt_plist;$Txt_out)
					
					$Txt_poxix:=Convert path system to POSIX:C1106($Txt_plist)
					
					  // Remove data not convertible to JSON https://juzhax.com/2013/12/invalid-object-in-plist-for-destination-format/
					plist (New object:C1471("action";"remove";"domain";$Txt_poxix;"key";"ExpirationDate"))
					
					plist (New object:C1471("action";"remove";"domain";$Txt_poxix;"key";"CreationDate"))
					
					plist (New object:C1471("action";"remove";"domain";$Txt_poxix;"key";"DeveloperCertificates"))
					
					  // Read it and convert it
					$Obj_result:=plist (New object:C1471("action";"object";"domain";$Txt_poxix))
					
					
				End if 
				If (Test path name:C476($Txt_plist)=Is a document:K24:1)
					DELETE DOCUMENT:C159($Txt_plist)
				End if 
			End if 
		End if 
		
		  //______________________________________________________
	: ($Obj_param.action="clear")
		
		$Obj_result:=provisioningProfiles (New object:C1471("action";"path"))
		
		If ($Obj_result.success)
			
			If (Test path name:C476(String:C10($Obj_result.path))=Is a folder:K24:2)
				
				DOCUMENT LIST:C474($Obj_result.path;$tTxt_files;Absolute path:K24:14+Posix path:K24:15)
				
				$Col_result:=New collection:C1472
				ARRAY TO COLLECTION:C1563($Col_result;$tTxt_files)
				
				For each ($Txt_path;$Col_result)
					
					DELETE DOCUMENT:C159($Txt_path)
					
				End for each 
				
			End if 
		End if 
		
		  //______________________________________________________
		  //: ($Obj_param.action="teamIdentifiers")
		
		  //$Obj_param.action:="read"
		
		  //$Obj_result:=provisioningProfiles ($Obj_param)
		
		  //If ($Obj_result.success)
		  //  // create a new collection with the values of the property "name" in each object of the collection $people
		  //$Col_extract:=$Obj_result.value.extract("TeamIdentifier")
		
		  //$Col_teamIds:=New collection
		
		  //For each ($Col_;$Col_extract)
		
		  //For each ($Txt_reamID;$Col_)
		
		  //If (Not(collection_containsText ($Col_teamIds;$Txt_reamID)))
		  //$Col_teamIds.push($Txt_reamID)
		
		  // End if
		  // End for each
		  // End for each
		
		  //$Obj_result.value:=$Col_teamIds
		
		  // End if
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_param.action+"\"")
		
		  //______________________________________________________
End case 

If ($Obj_param.caller#Null:C1517)
	
	CALL FORM:C1391($Obj_param.caller;"editor_CALLBACK";"teamId";$Obj_result)
	
Else 
	
	$0:=$Obj_result
	
End if 

  //______________________________________________________

  // Delete a keychain
  // security delete-keychain "keyChain"

  // Create a key chain
  // security create-keychain -p "keychainPass" "keyChain" // keychainPass random string

  // unlock a keychain
  // security unlock-keychain -p "keychainPass" "keyChain"

  // *.p12 fie
  // security import <p12 file> -k "keyChain" -P "a passphrase" -T /usr/bin/codesign -T /usr/bin/productsign "keyChain"

  // Display keychain info for potential troubleshooting
  // security show-keychain-info "keyChain"