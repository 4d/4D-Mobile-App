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
var $e; $ƒ : Object

// ----------------------------------------------------
// Initialisations
$ƒ:=panel_Definition

ASSERT:C1129(Not:C34(Shift down:C543))

// ----------------------------------------------------
If (FORM Event:C1606.objectName=Null:C1517)  // <== FORM METHOD
	
	$e:=panel_Form(On Load:K2:1; On Timer:K2:25)
	
	Case of 
			
			//______________________________________________
		: ($e.code=On Load:K2:1)
			
			$ƒ.loginRequired.bestSize()
			$ƒ.authenticationGroup.distributeHorizontally()\
				.show(Form:C1466.server.authentication.email)
			
			$ƒ.pushNotification.bestSize()
			$ƒ.certificateGroup.distributeHorizontally()\
				.show(Form:C1466.server.pushNotification)
			
			$ƒ.deepLinking.bestSize()
			$ƒ.deepLinkingGroup.show(Form:C1466.deepLinking.enabled)
			
			//______________________________________________
		: ($e.code=On Timer:K2:25)
			
			$ƒ.authenticationGroup.show(Form:C1466.server.authentication.email)
			$ƒ.certificateGroup.show(Form:C1466.server.pushNotification)
			$ƒ.deepLinkingGroup.show(Form:C1466.deepLinking.enabled)
			
			$ƒ.certificate.touch()
			$ƒ.checkAuthenticationMethod()
			
			//______________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	$e:=$ƒ.event
	
	Case of 
			
			//==============================================
		: ($ƒ.certificate.catch($e; On Data Change:K2:15))
			
			If ($ƒ.certificate.picker.target#Null:C1517)
				
				If (Bool:C1537($ƒ.certificate.picker.target.exists))
					
					If ($ƒ.certificate.picker.path#String:C10(Form:C1466.server.pushCertificate))
						
						Form:C1466.server.pushCertificate:=cs:C1710.doc.new($ƒ.certificate.picker.target).relativePath
						project.save()
						
					End if 
				End if 
			End if 
			
			//==============================================
		: ($ƒ.loginRequired.catch($e; On Clicked:K2:4))
			
			Form:C1466.server.authentication.email:=Bool:C1537(Form:C1466.server.authentication.email)
			$ƒ.authenticationGroup.show(Form:C1466.server.authentication.email)
			project.save()
			
			//==============================================
		: ($ƒ.authenticationButton.catch($e; On Clicked:K2:4))
			
			$ƒ.editAuthenticationMethod()
			
			//==============================================
		: ($ƒ.pushNotification.catch($e; On Clicked:K2:4))
			
			Form:C1466.server.pushNotification:=Bool:C1537(Form:C1466.server.pushNotification)
			$ƒ.certificateGroup.show(Form:C1466.server.pushNotification)
			project.save()
			
			//==============================================
		: ($ƒ.deepLinking.catch($e; On Clicked:K2:4))
			
			Form:C1466.deepLinking.enabled:=Bool:C1537(Form:C1466.deepLinking.enabled)
			
			If (Form:C1466.deepLinking.enabled)
				
				$ƒ.deepLinkingGroup.show()
				
				If (Length:C16(String:C10(Form:C1466.deepLinking.urlScheme))=0)
					
					Form:C1466.deepLinking.urlScheme:=formatString("urlScheme"; Form:C1466.product.name)+"://"
					
				End if 
				
				If (Form:C1466.deepLinking.associatedDomain=Null:C1517)
					
					Form:C1466.deepLinking.associatedDomain:=""
					$ƒ.deepLinkingAssociatedDomain.setHelpTip()
					
				Else 
					
					$ƒ.deepLinkingAssociatedDomain.setHelpTip("universalLinksTips")
					
				End if 
				
			Else 
				
				$ƒ.deepLinkingGroup.hide()
				
			End if 
			
			project.save()
			
			//==============================================
		: ($ƒ.deepLinkingUrlScheme.catch($e; On Data Change:K2:15))
			
			If (Match regex:C1019("(?mi-s)^([^:/?#]+)(?:://)?$"; Form:C1466.deepLinking.urlScheme; 1))
				
				Form:C1466.deepLinking.urlScheme:=formatString("urlScheme"; Replace string:C233(Form:C1466.deepLinking.urlScheme; "://"; ""))+"://"
				project.save()
				
			Else 
				
				BEEP:C151  //#TO_DO - display an alert
				$ƒ.deepLinkingUrlScheme.focus()
				
			End if 
			
			//==============================================
		: ($ƒ.deepLinkingAssociatedDomain.catch($e; On Data Change:K2:15))
			
			project.save()
			
			$ƒ.deepLinkingAssociatedDomain.setHelpTip(Choose:C955(Length:C16(Form:C1466.deepLinking.associatedDomain)>0; "universalLinksTips"; ""))
			
			//==============================================
	End case 
End if 