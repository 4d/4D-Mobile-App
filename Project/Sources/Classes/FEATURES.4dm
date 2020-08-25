/*===============================================
FEATURES pannel Class
===============================================*/
Class constructor
	
	var $o : Object
	$o:=editor_INIT
	
	If (OB Is empty:C1297($o)) | Shift down:C543
		
		This:C1470.window:=Current form window:C827
		This:C1470.loginRequired:=cs:C1710.button.new("01_login")
		This:C1470.authenticationLabel:=cs:C1710.static.new("authentication.label")
		This:C1470.authenticationButton:=cs:C1710.button.new("authentication")
		This:C1470.authenticationGroup:=cs:C1710.group.new(This:C1470.authenticationLabel; This:C1470.authenticationButton)
		
		This:C1470.pushNotification:=cs:C1710.button.new("02_pushNotification")
		This:C1470.certificate:=cs:C1710.widget.new("certificatePicker"; Formula:C1597(Form:C1466.$FEATURES.certificate.picker))
		This:C1470.certificate.picker:=cs:C1710.pathPicker.new(String:C10(Form:C1466.server.pushCertificate); New object:C1471(\
			"options"; Package open:K24:8+Use sheet window:K24:11; \
			"fileTypes"; ".p8"; \
			"directory"; 8858; \
			"copyPath"; False:C215; \
			"openItem"; False:C215; \
			"message"; Get localized string:C991("selectACertificate"); \
			"placeHolder"; Get localized string:C991("selectACertificate")+"…"))
		
		This:C1470.certificateLabel:=cs:C1710.static.new("certificateLabel")
		This:C1470.certificateGroup:=cs:C1710.group.new(This:C1470.certificateLabel; This:C1470.certificate)
		
		This:C1470.deepLinking:=cs:C1710.button.new("03_deepLinking")
		This:C1470.deepLinkingUrlSchemeLabel:=cs:C1710.static.new("urlScheme.label")
		This:C1470.deepLinkingUrlScheme:=cs:C1710.input.new("03_urlScheme.input")  //; "Form.deepLinking.urlScheme")
		This:C1470.deepLinkingAssociatedDomainLabel:=cs:C1710.static.new("associatedDomain.label")
		This:C1470.deepLinkingAssociatedDomain:=cs:C1710.input.new("04_associatedDomain.input")  //; "Form.deepLinking.associatedDomain")
		This:C1470.deepLinkingGroup:=cs:C1710.group.new(\
			This:C1470.deepLinkingUrlSchemeLabel; \
			cs:C1710.static.new("urlScheme.border"); \
			This:C1470.deepLinkingUrlScheme; \
			This:C1470.deepLinkingAssociatedDomainLabel; \
			cs:C1710.static.new("associatedDomain.border"); \
			This:C1470.deepLinkingAssociatedDomain)
		
		// Constraints definition
		ob_createPath($o; "constraints.rules"; Is collection:K8:32)
		
	End if 
	
/*===============================================*/
Function checkAuthenticationMethod
	
	ARRAY TEXT:C222($tTxt_; 0x0000)
	METHOD GET PATHS:C1163(Path database method:K72:2; $tTxt_; *)
	$tTxt_{0}:=METHOD Get path:C1164(Path database method:K72:2; "onMobileAppAuthentication")
	
	This:C1470.authenticationButton\
		.setTitle(Choose:C955(Find in array:C230($tTxt_; $tTxt_{0})=-1; "create..."; "edit..."))\
		.bestSize()\
		.show(Form:C1466.server.authentication.email)
	
/*===============================================*/
Function editAuthenticationMethod
	
	var $o : Object
	var $t : Text
	
	ARRAY TEXT:C222($tTxt_; 0x0000)
	METHOD GET PATHS:C1163(Path database method:K72:2; $tTxt_; *)
	$tTxt_{0}:=METHOD Get path:C1164(Path database method:K72:2; "onMobileAppAuthentication")
	
	// Create method if not exist
	If (Find in array:C230($tTxt_; $tTxt_{0})=-1)
		
		If (Command name:C538(1)="Somme")
			
			// FR language
			$o:=File:C1566("/RESOURCES/fr.lproj/onMobileAppAuthentication.4dm")
			
		Else 
			
			$o:=File:C1566(Get localized document path:C1105("onMobileAppAuthentication.4dm"); fk platform path:K87:2)
			
		End if 
		
		If ($o.exists)
			
			$t:=$o.getText()
			METHOD SET CODE:C1194($tTxt_{0}; $t; *)
			
		End if 
	End if 
	
	// Open method
	METHOD OPEN PATH:C1213($tTxt_{0}; *)
	
	This:C1470.checkAuthenticationMethod()
	
/*===============================================*/