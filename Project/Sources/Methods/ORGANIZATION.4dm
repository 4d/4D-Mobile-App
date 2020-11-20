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
	
	$e:=panel_Form()
	
Else   // <== WIDGETS METHOD
	
	$e:=$ƒ.event
	
	Case of 
			
			//==============================================
		: ($ƒ.name.catch())
			
			$ƒ.nameHelp.show($e.code=On Getting Focus:K2:7)
			
			//==============================================
		: ($ƒ.nameHelp.catch())
			
			OPEN URL:C673(Get localized string:C991("doc_orgName"); *)
			
			//==============================================
		: ($ƒ.identifier.catch())
			
			$ƒ.identifierHelp.show($e.code=On Getting Focus:K2:7)
			
			//==============================================
		: ($ƒ.identifierHelp.catch())
			
			OPEN URL:C673(Get localized string:C991("doc_orgIdentifier"); *)
			
			//________________________________________
	End case 
End if 