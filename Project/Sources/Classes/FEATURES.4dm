/*===============================================
           FEATURES pannel Class
===============================================*/
Class constructor
	
	var $o : Object
	
	$o:=editor_INIT 
	
	If (OB Is empty:C1297($o))
		
		This:C1470.window:=Current form window:C827
		This:C1470.loginRequired:=cs:C1710.button.new("01_login")
		This:C1470.authenticationLabel:=cs:C1710.static.new("authentication.label")
		This:C1470.authenticationButton:=cs:C1710.button.new("authentication")
		This:C1470.pushNotification:=cs:C1710.button.new("02_pushNotification")
		This:C1470.authenticationGroup:=cs:C1710.group.new(This:C1470.authenticationLabel;This:C1470.authenticationButton)
		
		  // Constraints definition
		ob_createPath ($o;"constraints.rules";Is collection:K8:32)
		
	End if 
	
/*===============================================*/
Function checkAuthenticationMethod
	
	ARRAY TEXT:C222($tTxt_;0x0000)
	METHOD GET PATHS:C1163(Path database method:K72:2;$tTxt_;*)
	$tTxt_{0}:=METHOD Get path:C1164(Path database method:K72:2;"onMobileAppAuthentication")
	
	This:C1470.authenticationButton\
		.setTitle(Choose:C955(Find in array:C230($tTxt_;$tTxt_{0})=-1;"create...";"edit..."))\
		.bestSize()\
		.show()
	
/*===============================================*/
Function editAuthenticationMethod
	
	C_OBJECT:C1216($o)
	C_TEXT:C284($t)
	
	ARRAY TEXT:C222($tTxt_;0x0000)
	METHOD GET PATHS:C1163(Path database method:K72:2;$tTxt_;*)
	$tTxt_{0}:=METHOD Get path:C1164(Path database method:K72:2;"onMobileAppAuthentication")
	
	  // Create method if not exist
	If (Find in array:C230($tTxt_;$tTxt_{0})=-1)
		
		If (Command name:C538(1)="Somme")
			
			  // FR language
			$o:=File:C1566("/RESOURCES/fr.lproj/onMobileAppAuthentication.4dm")
			
		Else 
			
			$o:=File:C1566(Get localized document path:C1105("onMobileAppAuthentication.4dm");fk platform path:K87:2)
			
		End if 
		
		If ($o.exists)
			
			$t:=$o.getText()
			METHOD SET CODE:C1194($tTxt_{0};$t;*)
			
		End if 
	End if 
	
	  // Open method
	METHOD OPEN PATH:C1213($tTxt_{0};*)
	
	This:C1470.checkAuthenticationMethod()
	
/*===============================================*/