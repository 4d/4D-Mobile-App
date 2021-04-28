//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : provisioningProfiles
// Created by Eric Marchand
// ----------------------------------------------------
// Description:
// Get information about installed provisioning profiles
// in mac os folder
// You can find it in your Library folder, MobileDevice/Provisioning Profiles/
// This file are decodable using security and are in plist format
// ----------------------------------------------------
// Declarations
#DECLARE($params : Object)->$response : Object
var $0 : Object
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(provisioningProfiles; $0)
	C_OBJECT:C1216(provisioningProfiles; $1)
End if 

var $cmd; $errorStream; $inputStream; $outputStream; $pathname : Text
var $o : Object
var $c : Collection
var $file : 4D:C1709.File
var $folder : 4D:C1709.Folder
var $plist : cs:C1710.plist

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	$response:=New object:C1471("success"; False:C215)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------

Case of 
		
		//______________________________________________________
	: ($params.action=Null:C1517)
		
		ASSERT:C1129(False:C215)
		
		//______________________________________________________
	: ($params.action="path")
		
		$response.success:=True:C214
		
		$folder:=cs:C1710.path.new().userlibrary().folder("MobileDevice/Provisioning Profiles")
		$response.posix:=$folder.path
		$response.path:=$folder.platformPath
		
		//______________________________________________________
	: ($params.action="paths")
		
		$response:=provisioningProfiles(New object:C1471(\
			"action"; "path"))
		
		If ($response.success)
			
			$folder:=Folder:C1567($response.posix)
			
			If ($folder.exists)
				
				$response.paths:=$folder.files().extract("path")
				
			Else 
				
				// Empty collection
				$response.paths:=New collection:C1472
				
			End if 
		End if 
		
		//______________________________________________________
	: ($params.action="read")
		
		If ($params.path=Null:C1517)
			
			$response:=provisioningProfiles(New object:C1471(\
				"action"; "paths"))
			
			If ($response.success)
				
				$c:=New collection:C1472
				
				For each ($pathname; $response.paths)
					
					$response:=provisioningProfiles(New object:C1471(\
						"action"; "read"; \
						"path"; $pathname))
					
					If ($response.success)
						
						$c.push($response.value)
						
					End if 
				End for each 
				
				$response:=New object:C1471(\
					"success"; True:C214; \
					"value"; $c)
				
			End if 
			
		Else 
			
			// Read one provisionning profile
			$cmd:="/usr/bin/security cms -D -i "+cs:C1710.tools.new().singleQuoted($params.path)
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "True")
			LAUNCH EXTERNAL PROCESS:C811($cmd; $inputStream; $outputStream; $errorStream)
			
			If (Asserted:C1132(OK=1; "LEP failed: "+$cmd))
				
				If (Length:C16($outputStream)>0)
					
					If (FEATURE.with("plistClass")) & False:C215
						
						$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+"mp.plist")
						$file.setText($outputStream)
						$plist:=cs:C1710.plist.new($file)
						
						$response:=New object:C1471(\
							"success"; $plist.succes; \
							"value"; $plist.content)
						
						If ($plist.success)
							
							$response.value:=$plist.content
							
						End if 
						
						$file.delete()
						
					Else 
						
						var $Txt_plist; $Txt_posix : Text
						$Txt_plist:=Temporary folder:C486+Generate UUID:C1066+"mp.plist"
						TEXT TO DOCUMENT:C1237($Txt_plist; $outputStream)
						$Txt_posix:=Convert path system to POSIX:C1106($Txt_plist)
						
						// Remove data not convertible to JSON https:// Juzhax.com/2013/12/invalid-object-in-plist-for-destination-format/
						_o_plist(New object:C1471("action"; "remove"; "domain"; $Txt_posix; "key"; "ExpirationDate"))
						_o_plist(New object:C1471("action"; "remove"; "domain"; $Txt_posix; "key"; "CreationDate"))
						_o_plist(New object:C1471("action"; "remove"; "domain"; $Txt_posix; "key"; "DeveloperCertificates"))
						
						// Read it and convert it
						$response:=_o_plist(New object:C1471("action"; "object"; "domain"; $Txt_posix))
						
						
						If (Test path name:C476($Txt_plist)=Is a document:K24:1)
							
							DELETE DOCUMENT:C159($Txt_plist)
							
						End if 
					End if 
				End if 
			End if 
		End if 
		
		//______________________________________________________
	: ($params.action="clear")
		
		$response:=provisioningProfiles(New object:C1471("action"; "path"))
		
		If ($response.success)
			
			$folder:=Folder:C1567($response.posix)
			
			If ($folder.exists)
				
				For each ($o; $folder.files())
					
					$o.delete()
					
				End for each 
			End if 
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$params.action+"\"")
		
		//______________________________________________________
End case 

If ($params.caller#Null:C1517)
	
	CALL FORM:C1391($params.caller; "editor_CALLBACK"; "teamId"; $response)
	
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