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
			$f.authenticationGroup.distributeHorizontally()\
				.show(Form:C1466.server.authentication.email)
			
			  //______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			$f.certificat.show(Form:C1466.server.pushNotification)
			$f.checkAuthenticationMethod()
			
			  //______________________________________________________
	End case 
	
Else   // <== Widgets method
	
	$e:=$f.event
	
	Case of 
			
			  //==================================================
		: ($f.certificat.catch($e;On Data Change:K2:15))
			
			  //If (Length($f.certificat.picker.platformPath)>0)
			
			If (Bool:C1537($f.certificat.picker._target.exists))
				
				If ($f.certificat.picker._target.path#String:C10(Form:C1466.server.pushCertificate))
					
					Form:C1466.server.pushCertificate:=$f.certificat.picker._target.path
					project.save()
					
				End if 
			End if 
			
			  //==================================================
		: ($f.loginRequired.catch($e;On Clicked:K2:4))
			
			Form:C1466.server.authentication.email:=Bool:C1537(Form:C1466.server.authentication.email)
			$f.authenticationGroup.show(Form:C1466.server.authentication.email)
			project.save()
			
			  //==================================================
		: ($f.authenticationButton.catch($e;On Clicked:K2:4))
			
			$f.editAuthenticationMethod()
			
			  //  //==================================================
		: ($f.pushNotification.catch($e;On Clicked:K2:4))
			
			Form:C1466.server.pushNotification:=Bool:C1537(Form:C1466.server.pushNotification)
			$f.certificat.show(Form:C1466.server.pushNotification)
			project.save()
			
			  //==================================================
	End case 
End if 