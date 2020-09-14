//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : mobile_Check_installation
// ID[684C0081C1734937A99F71EC2516C9F8]
// Created 30-6-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
var $0 : Object
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(mobile_Check_installation; $0)
	C_OBJECT:C1216(mobile_Check_installation; $1)
End if 

var $in; $out : Object

// ----------------------------------------------------
// Declarations

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

// Optional parameters
If (Count parameters:C259>=1)
	
	$in:=$1
	
End if 

// ----------------------------------------------------

Case of 
		//______________________________________________________
	: (Is macOS:C1572)
		
		$out:=Xcode_CheckInstall($in)
		
		//______________________________________________________
	: (Is Windows:C1573)
		
		ASSERT:C1129(DATABASE.isMatrix)
		
		$out:=New object:C1471(\
			"platform"; Windows:K25:3; \
			"XcodeAvailable"; False:C215; \
			"toolsAvalaible"; False:C215; \
			"ready"; False:C215)
		
		//______________________________________________________
	Else 
		
		TRACE:C157
		
		//______________________________________________________
End case 


// ----------------------------------------------------
// Return
If (Bool:C1537($in.caller))
	
	CALL FORM:C1391($in.caller; "editor_CALLBACK"; "checkInstall"; $out)
	
Else 
	
	$0:=$out
	
End if 

// ----------------------------------------------------
// End