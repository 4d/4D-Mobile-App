//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_CHECK_INSTALLATION
// ID[684C0081C1734937A99F71EC2516C9F8]
// Created 30-6-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Carries out controls of the development environment
// according to platform and OS target
// ----------------------------------------------------
// Declarations
var $0 : Object
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(editor_CHECK_INSTALLATION; $0)
	C_OBJECT:C1216(editor_CHECK_INSTALLATION; $1)
End if 

var $in; $out; $androidStudio; $xCode : Object

// ----------------------------------------------------
// Initialisations
$in:=$1

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: (Is macOS:C1572)
		
		If (FEATURE.with("android"))  //🚧
			
			If (Bool:C1537($in.project.$studio.ready))
				
				$androidStudio:=$in.project.$studio
				
			Else 
				
				// Silent mode if not Android target
				$in.silent:=Not:C34(Bool:C1537($in.project.$android))
				$androidStudio:=studioCheckInstall($in)
				
			End if 
			
			If (Bool:C1537($in.project.$xCode.ready))
				
				$xCode:=$in.project.$xCode
				
			Else 
				
				$in.silent:=Not:C34(Bool:C1537($in.project.$ios))
				$xCode:=Xcode_CheckInstall($in)
				
			End if 
			
			$out:=New object:C1471(\
				"xCode"; $xCode; \
				"studio"; $androidStudio)
			
		Else 
			
			$out:=Xcode_CheckInstall($in)
			
		End if 
		
		//______________________________________________________
	: (Is Windows:C1573)
		
		$out:=New object:C1471(\
			"xCode"; New object:C1471(\
			"platform"; Windows:K25:3; \
			"XcodeAvailable"; False:C215; \
			"toolsAvalaible"; False:C215; \
			"ready"; False:C215); \
			"studio"; studioCheckInstall($in))
		
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