//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : ORGANIZATION
// Created 20-11-2020 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// ORGANIZATION pannel management
// ----------------------------------------------------
// Declarations
var $e; $ƒ : Object

// ----------------------------------------------------
// Initialisations
$ƒ:=panel_Definition

// ----------------------------------------------------
If (FORM Event:C1606.objectName=Null:C1517)  // <== FORM METHOD
	
	$e:=panel_Form_common()
	
Else   // <== WIDGETS METHOD
	
	$e:=$ƒ.event
	
	Case of 
			
			//==============================================
		: ($ƒ.name.catch())
			
			$ƒ.nameHelp.show($e.code=On Getting Focus:K2:7)
			
			//==============================================
		: ($ƒ.nameHelp.catch($e; On Clicked:K2:4))
			
			OPEN URL:C673(Get localized string:C991("doc_orgName"); *)
			
			//==============================================
		: ($ƒ.identifier.catch())
			
			Case of 
					
					//______________________________________________________
				: ($e.code=On Getting Focus:K2:7)
					
					$ƒ.identifierHelp.show()
					
					//______________________________________________________
				: ($e.code=On Losing Focus:K2:8)
					
					$ƒ.identifierHelp.hide()
					
					//______________________________________________________
				: ($e.code=On Data Change:K2:15)
					
					// Update bundleIdentifier
					Form:C1466.product.bundleIdentifier:=Form:C1466.organization.id+"."+formatString("bundleApp"; Form:C1466.product.name)
					
					//______________________________________________________
			End case 
			
			$ƒ.identifierHelp.show($e.code=On Getting Focus:K2:7)
			
			//==============================================
		: ($ƒ.identifierHelp.catch($e; On Clicked:K2:4))
			
			OPEN URL:C673(Get localized string:C991("doc_orgIdentifier"); *)
			
			//________________________________________
	End case 
End if 