//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : FEATURES
  // ID[CA478BCE7E114BD7B13F6A623C605879]
  // Created 29-4-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // FEATURES pannel management
  // ----------------------------------------------------
  // Declarations
  // var $1
var $f;$e : Object

  // ----------------------------------------------------
  // Initialisations
$f:=panel_Definition 

ASSERT:C1129(Not:C34(Shift down:C543))

  // ----------------------------------------------------
If (FORM Event:C1606.objectName=Null:C1517)  // <== Form method
	
	$e:=panel_Form (On Load:K2:1;On Timer:K2:25)
	
	Case of 
			
			  //______________________________________________________
		: ($e.code=On Load:K2:1)
			
			$f.loginRequired.bestSize()
			$f.pushNotification.bestSize()
			$f.authenticationGroup.distributeHorizontally()
			
			  //______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			$f.checkAuthenticationMethod()
			
			  //______________________________________________________
	End case 
	
Else   // <== Widgets method
	
	$e:=$f.event
	
	Case of 
			
			  //==================================================
		: ($f.loginRequired.catch($e))
			
			Form:C1466.server.authentication.email:=Bool:C1537(Form:C1466.server.authentication.email)
			ui.saveProject()
			
			  //==================================================
		: ($f.authenticationButton.catch($e))
			
			$f.editAuthenticationMethod()
			
			  //  //==================================================
		: ($f.pushNotification.catch($e))
			
			Form:C1466.server.pushNotification:=Bool:C1537(Form:C1466.server.pushNotification)
			ui.saveProject()
			
			  //==================================================
	End case 
End if 