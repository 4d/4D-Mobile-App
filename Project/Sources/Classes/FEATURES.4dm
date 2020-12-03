/*===============================================
FEATURES pannel Class
===============================================*/
Class extends form

//________________________________________________________________
Class constructor
	
	Super:C1705("editor_CALLBACK")
	
	This:C1470.context:=editor_INIT
	
	If (OB Is empty:C1297(This:C1470.context)) | Shift down:C543
		
		This:C1470.loginRequired:=cs:C1710.button.new("01_login")
		
		This:C1470.authenticationLabel:=cs:C1710.static.new("authentication.label")
		This:C1470.authenticationButton:=cs:C1710.button.new("authentication")
		
		This:C1470.authenticationGroup:=cs:C1710.group.new(\
			This:C1470.authenticationLabel; \
			This:C1470.authenticationButton)
		
		This:C1470.pushNotification:=cs:C1710.button.new("02_pushNotification")
		
		This:C1470.certificate:=cs:C1710.widget.new("certificatePicker")
		This:C1470.certificate.picker:=cs:C1710.pathPicker.new(String:C10(Form:C1466.server.pushCertificate); New object:C1471(\
			"options"; Package open:K24:8+Use sheet window:K24:11; \
			"fileTypes"; ".p8"; \
			"directory"; 8858; \
			"copyPath"; False:C215; \
			"openItem"; False:C215; \
			"message"; Get localized string:C991("selectACertificate"); \
			"placeHolder"; Get localized string:C991("selectACertificate")+"…"))
		
		This:C1470.certificateLabel:=cs:C1710.static.new("certificateLabel")
		This:C1470.certificateGroup:=cs:C1710.group.new(\
			This:C1470.certificateLabel; \
			This:C1470.certificate)
		
		This:C1470.deepLinking:=cs:C1710.button.new("03_deepLinking")
		
		This:C1470.deepScheme:=cs:C1710.input.new("03_urlScheme.input")
		This:C1470.deepSchemeLabel:=cs:C1710.static.new("urlScheme.label")
		This:C1470.deepSchemeAlert:=cs:C1710.attention.new("urlScheme.alert")
		
		This:C1470.deepLink:=cs:C1710.input.new("04_associatedDomain.input")
		This:C1470.deepLinkLabel:=cs:C1710.static.new("associatedDomain.label")
		
		This:C1470.deepLinkingGroup:=cs:C1710.group.new(\
			This:C1470.deepSchemeLabel; \
			cs:C1710.static.new("urlScheme.border"); \
			This:C1470.deepScheme; \
			This:C1470.deepLinkLabel; \
			This:C1470.deepSchemeAlert; \
			cs:C1710.static.new("associatedDomain.border"); \
			This:C1470.deepLink)
		
		// Constraints definition
		ob_createPath(This:C1470.context; "constraints.rules"; Is collection:K8:32)
		
	End if 
	
/*===============================================*/
Function checkAuthenticationMethod
	
	ARRAY TEXT:C222($methods; 0x0000)
	METHOD GET PATHS:C1163(Path database method:K72:2; $methods; *)
	$methods{0}:=METHOD Get path:C1164(Path database method:K72:2; "onMobileAppAuthentication")
	
	This:C1470.authenticationButton\
		.setTitle(Choose:C955(Find in array:C230($methods; $methods{0})=-1; "create..."; "edit..."))\
		.bestSize()\
		.show(Form:C1466.server.authentication.email)
	
/*===============================================*/
Function editAuthenticationMethod
	
	var $file : Object
	var $text : Text
	
	ARRAY TEXT:C222($methods; 0x0000)
	METHOD GET PATHS:C1163(Path database method:K72:2; $methods; *)
	$methods{0}:=METHOD Get path:C1164(Path database method:K72:2; "onMobileAppAuthentication")
	
	// Create method if not exist
	If (Find in array:C230($methods; $methods{0})=-1)
		
		If (Command name:C538(1)="Somme")
			
			// FR language
			$file:=File:C1566("/RESOURCES/fr.lproj/onMobileAppAuthentication.4dm")
			
		Else 
			
			$file:=File:C1566("/RESOURCES/onMobileAppAuthentication.4dm")
			
		End if 
		
		If ($file.exists)
			
			$text:=$file.getText()
			METHOD SET CODE:C1194($methods{0}; $text; *)
			
		End if 
	End if 
	
	// Open method
	METHOD OPEN PATH:C1213($methods{0}; *)
	
	This:C1470.checkAuthenticationMethod()
	
/*===============================================*/
Function initScheme
	
	If (Length:C16(String:C10(Form:C1466.deepLinking.urlScheme))=0)
		
		Form:C1466.deepLinking.urlScheme:=formatString("urlScheme"; Form:C1466.product.name)+"://"
		
	End if 
	
/*===============================================*/
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