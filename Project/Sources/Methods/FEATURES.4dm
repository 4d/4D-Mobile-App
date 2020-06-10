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
var $ƒ;$e : Object

  // ----------------------------------------------------
  // Initialisations
$ƒ:=panel_Definition 

ASSERT:C1129(Not:C34(Shift down:C543))

  // ----------------------------------------------------
If (FORM Event:C1606.objectName=Null:C1517)  // <== Form method
	
	$e:=panel_Form (On Load:K2:1;On Timer:K2:25)
	
	Case of 
			
			  //______________________________________________
		: ($e.code=On Load:K2:1)
			
			$ƒ.loginRequired.bestSize()
			$ƒ.pushNotification.bestSize()
			$ƒ.authenticationGroup.distributeHorizontally()\
				.show(Form:C1466.server.authentication.email)
			
			  //______________________________________________
		: ($e.code=On Timer:K2:25)
			
			$ƒ.certificat.show(Form:C1466.server.pushNotification).touch()
			$ƒ.checkAuthenticationMethod()
			
			  //______________________________________________
	End case 
	
Else   // <== Widgets method
	
	$e:=$ƒ.event
	
	Case of 
			
			  //==============================================
		: ($ƒ.certificat.catch($e;On Data Change:K2:15))
			
			If ($ƒ.certificat.picker.target#Null:C1517)
				
				If (Bool:C1537($ƒ.certificat.picker.target.exists))
					
					If ($ƒ.certificat.picker.path#String:C10(Form:C1466.server.pushCertificate))
						
						Form:C1466.server.pushCertificate:=cs:C1710.doc.new($ƒ.certificat.picker.target).relativePath
						project.save()
						
					End if 
				End if 
			End if 
			
			  //==============================================
		: ($ƒ.loginRequired.catch($e;On Clicked:K2:4))
			
			Form:C1466.server.authentication.email:=Bool:C1537(Form:C1466.server.authentication.email)
			$ƒ.authenticationGroup.show(Form:C1466.server.authentication.email)
			project.save()
			
			  //==============================================
		: ($ƒ.authenticationButton.catch($e;On Clicked:K2:4))
			
			$ƒ.editAuthenticationMethod()
			
			  //==============================================
		: ($ƒ.pushNotification.catch($e;On Clicked:K2:4))
			
			Form:C1466.server.pushNotification:=Bool:C1537(Form:C1466.server.pushNotification)
			$ƒ.certificat.show(Form:C1466.server.pushNotification)
			project.save()
			
			  //==============================================
	End case 
End if 