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
var $f : Object
var $e : Object
var $o : Object

// ----------------------------------------------------
// Initialisations
$f:=panel_Definition
$e:=$f.event

// ----------------------------------------------------
If ($e.objectName=Null:C1517)  // <== Form method
	
	$e:=panel_Form(On Load:K2:1)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			$f.webSettings.bestSize()
			$f.webSettingsGroup.distributeHorizontally()
			
			$o:=New object:C1471(\
				"buffer"; New object:C1471(\
				"deepLinking"; New object:C1471(); \
				"server"; New object:C1471(\
				"authentication"; New object:C1471; \
				"urls"; New object:C1471)))
			
			ob_MERGE(Form:C1466; $o.buffer)
			
			//______________________________________________________
	End case 
	
Else   // <== Widgets method
	
	Case of 
			
			//==================================================
		: ($f.productionURL.catch($e))
			
			Case of 
					
					//_____________________________________
				: ($e.code=On Data Change:K2:15)
					
					PROJECT.save()
					
					// Verify the web server configuration
					CALL FORM:C1391($f.window; "editor_CALLBACK"; "checkingServerConfiguration")
					
					//_____________________________________
				: ($e.code=On Getting Focus:K2:7)\
					 | ($e.code=On Losing Focus:K2:8)
					
					//#TURNAROUND - THE EVENT SHOULD NOT BE TRIGGERED
					
					//_____________________________________
				Else 
					
					ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
					
					//_____________________________________
			End case 
			
			//==================================================
		: ($f.webSettings.catch($e))
			
			$f.settings()
			
			//==================================================
	End case 
End if 