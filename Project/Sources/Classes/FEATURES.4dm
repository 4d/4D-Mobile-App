Class extends panel

//=== === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705(Formula:C1597(editor_CALLBACK).source)
	
	This:C1470.context:=Super:C1706.init()
	
	If (OB Is empty:C1297(This:C1470.context))
		
		This:C1470.init()
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Design definition
Function init()
	
	var $group : cs:C1710.group
	
	This:C1470.toBeInitialized:=False:C215
	
	// * LOGIN
	This:C1470.button("loginRequired"; "01_login")
	
	$group:=This:C1470.group("authenticationGroup")
	This:C1470.formObject("authenticationLabel"; "authentication.label").addToGroup($group)
	This:C1470.button("authenticationButton"; "authentication").addToGroup($group)
	
	// * PUSH NOTIFICATION
	This:C1470.button("pushNotification"; "02_pushNotification")
	
	$group:=This:C1470.group("certificateGroup")
	This:C1470.formObject("certificateLabel").addToGroup($group)
	This:C1470.widget("certificate"; "certificatePicker").addToGroup($group)
	
	This:C1470.certificate.picker:=cs:C1710.pathPicker.new(String:C10(Form:C1466.server.pushCertificate); New object:C1471(\
		"options"; Package open:K24:8+Use sheet window:K24:11; \
		"fileTypes"; ".p8"; \
		"directory"; 8858; \
		"copyPath"; False:C215; \
		"openItem"; False:C215; \
		"message"; Get localized string:C991("selectACertificate"); \
		"placeHolder"; Get localized string:C991("selectACertificate")+"…"))
	
	// * DEEP LINKING
	This:C1470.button("deepLinking"; "03_deepLinking")
	
	$group:=This:C1470.group("deepLinkingGroup")
	This:C1470.input("deepScheme"; "03_urlScheme.input").addToGroup($group)
	This:C1470.formObject("deepSchemeLabel"; "urlScheme.label").addToGroup($group)
	This:C1470.formObject("deepSchemeBorder"; "urlScheme.border").addToGroup($group)
	
	This:C1470.deepSchemeAlert:=cs:C1710.attention.new("urlScheme.alert")
	$group.addMember(This:C1470.deepSchemeAlert)
	
	This:C1470.input("deepLink"; "04_associatedDomain.input").addToGroup($group)
	This:C1470.formObject("deepLinkLabel"; "associatedDomain.label").addToGroup($group)
	This:C1470.formObject("deepLinkBorder"; "associatedDomain.border").addToGroup($group)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Events handler
Function handleEvents($e : Object)
	
	If ($e.objectName=Null:C1517)  // <== FORM METHOD
		
		$e:=Super:C1706.handleEvents(On Load:K2:1; On Timer:K2:25)
		
		Case of 
				
				//______________________________________________
			: ($e.code=On Load:K2:1)
				
				This:C1470.onLoad()
				
				//______________________________________________
			: ($e.code=On Timer:K2:25)
				
				This:C1470.update()
				
				//______________________________________________
		End case 
		
	Else   // <== WIDGETS METHOD
		
		Case of 
				
				//==============================================
			: (This:C1470.loginRequired.catch($e; On Clicked:K2:4))
				
				Form:C1466.server.authentication.email:=Bool:C1537(Form:C1466.server.authentication.email)
				PROJECT.save()
				
				This:C1470.authenticationGroup.show(Form:C1466.server.authentication.email)
				
				//==============================================
			: (This:C1470.authenticationButton.catch($e; On Clicked:K2:4))
				
				UI.editAuthenticationMethod()
				This:C1470.checkAuthenticationMethod()
				
				//==============================================
			: (This:C1470.pushNotification.catch($e; On Clicked:K2:4))
				
				Form:C1466.server.pushNotification:=Bool:C1537(Form:C1466.server.pushNotification)
				PROJECT.save()
				
				This:C1470.certificateGroup.show(Form:C1466.server.pushNotification)
				This:C1470.refresh()
				
				//==============================================
			: (This:C1470.certificate.catch($e; On Data Change:K2:15))
				
				If (This:C1470.certificate.picker.target#Null:C1517)
					
					If (Bool:C1537(This:C1470.certificate.picker.target.exists))
						
						If (This:C1470.certificate.picker.path#String:C10(Form:C1466.server.pushCertificate))
							
							Form:C1466.server.pushCertificate:=cs:C1710.doc.new(This:C1470.certificate.picker.target).relativePath
							PROJECT.save()
							
						End if 
					End if 
				End if 
				
				//==============================================
			: (This:C1470.deepLinking.catch($e; On Clicked:K2:4))
				
				Form:C1466.deepLinking.enabled:=Bool:C1537(Form:C1466.deepLinking.enabled)
				
				If (Form:C1466.deepLinking.enabled)
					
					This:C1470.deepLinkingGroup.show()
					
					// Create scheme from application name if not defined
					This:C1470.initScheme()
					
					If (Form:C1466.deepLinking.associatedDomain=Null:C1517)
						
						Form:C1466.deepLinking.associatedDomain:=""
						This:C1470.deepLink.setHelpTip()
						
					Else 
						
						This:C1470.deepLink.setHelpTip("universalLinksTips")
						
					End if 
					
				Else 
					
					This:C1470.deepLinkingGroup.hide()
					
				End if 
				
				PROJECT.save()
				
				This:C1470.refresh()
				
				//==============================================
			: (This:C1470.deepScheme.catch($e; On Data Change:K2:15))
				
				If (This:C1470.validateScheme())
					
					PROJECT.save()
					
				End if 
				
				//==============================================
			: (This:C1470.deepSchemeAlert.catch())
				
				This:C1470.deepSchemeAlert.method($e)
				
				//==============================================
			: (This:C1470.deepLink.catch($e; On Data Change:K2:15))
				
				PROJECT.save()
				
				This:C1470.deepLink.setHelpTip(Choose:C955(Length:C16(Form:C1466.deepLinking.associatedDomain)>0; "universalLinksTips"; ""))
				
				//==============================================
		End case 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	This:C1470.loginRequired.bestSize()
	This:C1470.authenticationGroup.distributeLeftToRight()\
		.show(Form:C1466.server.authentication.email)
	
	This:C1470.pushNotification.bestSize()
	This:C1470.certificateGroup.distributeLeftToRight()\
		.show(Form:C1466.server.pushNotification)
	
	This:C1470.deepLinking.bestSize()
	This:C1470.deepLinkingGroup.show(Form:C1466.deepLinking.enabled)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Update UI
Function update()
	
	This:C1470.authenticationGroup.show(Form:C1466.server.authentication.email)
	This:C1470.certificateGroup.show(Form:C1466.server.pushNotification)
	This:C1470.deepLinkingGroup.show(Form:C1466.deepLinking.enabled)
	
	This:C1470.certificate.touch()
	This:C1470.checkAuthenticationMethod()
	
	If (Form:C1466.deepLinking.enabled)
		
		This:C1470.validateScheme()
		
	End if 
	
	Case of 
			
			//______________________________________________________
		: (Bool:C1537(Form:C1466.server.pushNotification))\
			 & (Bool:C1537(Form:C1466.deepLinking.enabled))
			
			androidLimitations(False:C215; "Push notifications and Deep Linking are coming soon for Android")
			
			//______________________________________________________
		: (Bool:C1537(Form:C1466.server.pushNotification))
			
			androidLimitations(False:C215; "Push notifications is coming soon for Android")
			
			//______________________________________________________
		: (Bool:C1537(Form:C1466.deepLinking.enabled))
			
			androidLimitations(False:C215; "Deep Linking is coming soon for Android")
			
			//______________________________________________________
		Else 
			
			androidLimitations(False:C215; "Push notifications and Deep Linking are coming soon for Android")
			
			//______________________________________________________
	End case 
	
	This:C1470.pushNotification.enable(Is macOS:C1572 & PROJECT.$ios)
	This:C1470.certificateGroup.enable(Is macOS:C1572 & PROJECT.$ios)
	This:C1470.certificate.picker.browse:=(Is macOS:C1572 & PROJECT.$ios)
	This:C1470.deepLinking.enable(Is macOS:C1572 & PROJECT.$ios)
	This:C1470.deepLinkingGroup.enable(Is macOS:C1572 & PROJECT.$ios)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function checkAuthenticationMethod
	
	ARRAY TEXT:C222($methods; 0x0000)
	METHOD GET PATHS:C1163(Path database method:K72:2; $methods; *)
	$methods{0}:=METHOD Get path:C1164(Path database method:K72:2; "onMobileAppAuthentication")
	
	This:C1470.authenticationButton\
		.setTitle(Choose:C955(Find in array:C230($methods; $methods{0})=-1; "create..."; "edit..."))\
		.bestSize()\
		.show(Form:C1466.server.authentication.email)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function initScheme
	
	If (Length:C16(String:C10(Form:C1466.deepLinking.urlScheme))=0)
		
		Form:C1466.deepLinking.urlScheme:=formatString("urlScheme"; Form:C1466.product.name)+"://"
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function validateScheme
	var $0 : Boolean
	
	This:C1470.initScheme()
	
	$0:=Match regex:C1019("(?mi-s)^[[:alpha:]][-+\\.[:alpha:][:digit:]]+(?:://)?$"; Form:C1466.deepLinking.urlScheme; 1)
	
	If ($0)
		
		Form:C1466.deepLinking.urlScheme:=formatString("urlScheme"; Replace string:C233(Form:C1466.deepLinking.urlScheme; "://"; ""))+"://"
		This:C1470.deepSchemeAlert.reset()
		
	Else 
		
		This:C1470.deepSchemeAlert.alert("schemeFormat")
		This:C1470.deepScheme.focus()
		
	End if 