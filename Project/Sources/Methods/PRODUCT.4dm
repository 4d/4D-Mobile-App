//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : PRODUCT
// Created 16-9-2020 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// PRODUCT pannel management
// ----------------------------------------------------
// Declarations
var $e; $ƒ : Object

// ----------------------------------------------------
// Initialisations
$ƒ:=panel_Definition

// ----------------------------------------------------
If (FORM Event:C1606.objectName=Null:C1517)  // <== FORM METHOD
	
	$e:=panel_Form(On Load:K2:1; On Timer:K2:25; On Bound Variable Change:K2:52)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			//______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			$ƒ.checkName(Form:C1466.product.name)
			$ƒ.loadIcon()
			
			//______________________________________________________
		: ($e.code=On Bound Variable Change:K2:52)
			
			SET TIMER:C645(-1)
			
			//______________________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	$e:=$ƒ.event
	
	Case of 
			
			//==============================================
		: ($ƒ.productName.catch())
			
			If ($e.code=On After Edit:K2:43)
				
				$ƒ.checkName(Get edited text:C655)
				
			Else 
				
				$ƒ.checkName(Form:C1466.product.name)
				
			End if 
			
			//==============================================
		: ($ƒ.icon.catch())
			
			// ❗️MANAGED INTO OBJECT METHOD BECAUSE DRAG AND DROP
			
			//________________________________________
	End case 
End if 