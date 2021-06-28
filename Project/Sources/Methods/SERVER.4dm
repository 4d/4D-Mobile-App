//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : SERVER
// ID[75B0A66E1CF34B9282671E12991D64C9]
// Created 17-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// SERVER pannel management
// ----------------------------------------------------
// Declarations
var $e; $ƒ : Object

// ----------------------------------------------------
// Initialisations
$ƒ:=panel_Load
$e:=$ƒ.event

// ----------------------------------------------------
If ($e.objectName=Null:C1517)  // <== Form method
	
	$e:=panel_Common(On Load:K2:1)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			$ƒ.onLoad()
			
			//______________________________________________________
	End case 
	
Else   // <== Widgets method
	
	Case of 
			
			//==================================================
		: ($ƒ.productionURL.catch($e; On Data Change:K2:15))
			
			// Verify the web server configuration
			EDITOR.callMeBack("checkingServerConfiguration")
			
			//==================================================
		: ($ƒ.webSettings.catch($e; On Clicked:K2:4))
			
			$ƒ.doSettings()
			
			//==================================================
	End case 
End if 