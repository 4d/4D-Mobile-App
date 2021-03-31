//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : FEATURES
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

// ----------------------------------------------------
If (FORM Event:C1606.objectName=Null:C1517)  // <== FORM METHOD
	
	$e:=panel_Form(On Load:K2:1; On Timer:K2:25)
	
	Case of 
			
			//______________________________________________
		: ($e.code=On Load:K2:1)
			
			$ƒ.loginRequired.bestSize()
			$ƒ.authenticationGroup.distributeLeftToRight()\
				.show(Form:C1466.server.authentication.email)
			
			$ƒ.pushNotification.bestSize()
			$ƒ.certificateGroup.distributeLeftToRight()\
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
			
			If (Form:C1466.deepLinking.enabled)
				
				$ƒ.validateScheme()
				
			End if 
			
			If (FEATURE.with("android"))
				
				Case of 
						
						//______________________________________________________
					: (Form:C1466.server.pushNotification)\
						 & (Form:C1466.deepLinking.enabled)
						
						androidLimitations(False:C215; "Push notifications and Deep Linking are coming soon for Android")
						
						//______________________________________________________
					: (Form:C1466.server.pushNotification)
						
						androidLimitations(False:C215; "Push notifications is coming soon for Android")
						
						//______________________________________________________
					: (Form:C1466.deepLinking.enabled)
						
						androidLimitations(False:C215; "Deep Linking is coming soon for Android")
						
						//______________________________________________________
					Else 
						
						androidLimitations(False:C215; "Push notifications and Deep Linking are coming soon for Android")
						
						//______________________________________________________
				End case 
				
				$ƒ.pushNotification.enable(Is macOS:C1572 & PROJECT.$ios)
				$ƒ.certificateGroup.enable(Is macOS:C1572 & PROJECT.$ios)
				$ƒ.certificate.picker.browse:=(Is macOS:C1572 & PROJECT.$ios)
				$ƒ.deepLinking.enable(Is macOS:C1572 & PROJECT.$ios)
				$ƒ.deepLinkingGroup.enable(Is macOS:C1572 & PROJECT.$ios)
				
			End if 
			
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
						PROJECT.save()
						
					End if 
				End if 
			End if 
			
			//==============================================
		: ($ƒ.loginRequired.catch($e; On Clicked:K2:4))
			
			Form:C1466.server.authentication.email:=Bool:C1537(Form:C1466.server.authentication.email)
			$ƒ.authenticationGroup.show(Form:C1466.server.authentication.email)
			PROJECT.save()
			
			//==============================================
		: ($ƒ.authenticationButton.catch($e; On Clicked:K2:4))
			
			$ƒ.editAuthenticationMethod()
			
			//==============================================
		: ($ƒ.pushNotification.catch($e; On Clicked:K2:4))
			
			Form:C1466.server.pushNotification:=Bool:C1537(Form:C1466.server.pushNotification)
			$ƒ.certificateGroup.show(Form:C1466.server.pushNotification)
			PROJECT.save()
			
			SET TIMER:C645(-1)
			
			//==============================================
		: ($ƒ.deepLinking.catch($e; On Clicked:K2:4))
			
			Form:C1466.deepLinking.enabled:=Bool:C1537(Form:C1466.deepLinking.enabled)
			
			If (Form:C1466.deepLinking.enabled)
				
				$ƒ.deepLinkingGroup.show()
				
				// Create scheme from application name if not defined
				$ƒ.initScheme()
				
				If (Form:C1466.deepLinking.associatedDomain=Null:C1517)
					
					Form:C1466.deepLinking.associatedDomain:=""
					$ƒ.deepLink.setHelpTip()
					
				Else 
					
					$ƒ.deepLink.setHelpTip("universalLinksTips")
					
				End if 
				
			Else 
				
				$ƒ.deepLinkingGroup.hide()
				
			End if 
			
			PROJECT.save()
			
			SET TIMER:C645(-1)
			
			//==============================================
		: ($ƒ.deepScheme.catch($e; On Data Change:K2:15))
			
			If ($ƒ.validateScheme())
				
				PROJECT.save()
				
			End if 
			
			//==============================================
		: ($ƒ.deepSchemeAlert.catch())
			
			$ƒ.deepSchemeAlert.method($e)
			
			//==============================================
		: ($ƒ.deepLink.catch($e; On Data Change:K2:15))
			
			PROJECT.save()
			
			$ƒ.deepLink.setHelpTip(Choose:C955(Length:C16(Form:C1466.deepLinking.associatedDomain)>0; "universalLinksTips"; ""))
			
			//==============================================
	End case 
End if 