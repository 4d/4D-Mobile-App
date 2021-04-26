//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_CHECK_INSTALLATION
// ID[684C0081C1734937A99F71EC2516C9F8]
// Created 30-6-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Carries out controls of the development environment
// According to platform and OS target
// ----------------------------------------------------
// Declarations
#DECLARE($in : Object)->$out : Object

If (False:C215)
	C_OBJECT:C1216(editor_CHECK_INSTALLATION; $0)
	C_OBJECT:C1216(editor_CHECK_INSTALLATION; $1)
End if 

//var $in; $out; $studio; $xCode : Object
var $studio; $xCode : Object

// ----------------------------------------------------
// Initialisations
//$in:=$1

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: (Is macOS:C1572)
		
		If (FEATURE.with("android"))  // 🚧
			
			If ($in.project.$project#Null:C1517)
				
				// From Ribbon
				$studio:=$in.project.$project.$studio
				$xCode:=$in.project.$project.$xCode
				
			Else 
				
				// From Product panel
				$studio:=$in.project.$studio
				$xCode:=$in.project.$xCode
				
			End if 
			
			If (Not:C34(Bool:C1537($studio.ready)))
				
				If (Not:C34(Bool:C1537($studio.canceled)))
					
					// Silent mode if not Android target
					$in.silent:=Not:C34(Bool:C1537($in.project.$android))
					$studio:=studioCheckInstall($in)
					
				End if 
			End if 
			
			If ($studio.ready)
				
				If (Bool:C1537($in.project.$android))
					
					// Get the last 4D Mobile Android SDK from AWS server if any
					CALL WORKER:C1389($in.project.$worker; "downloadSDK"; "aws"; "android")  //;True)
					
				End if 
				
			Else 
				
				$studio.canceled:=Bool:C1537($studio.canceled)
				
			End if 
			
			If (Not:C34(Bool:C1537($xCode.ready)))
				
				If (Not:C34(Bool:C1537($xCode.canceled)))
					
					$in.silent:=Not:C34(Bool:C1537($in.project.$ios))
					$xCode:=Xcode_CheckInstall($in)
					
				End if 
				
				If ($xCode.ready)
					
					// 
					
				Else 
					
					$xCode.canceled:=Bool:C1537($xCode.canceled)
					
				End if 
			End if 
			
			$out:=New object:C1471(\
				"xCode"; $xCode; \
				"studio"; $studio)
			
		Else 
			
			$out:=Xcode_CheckInstall($in)
			
		End if 
		
		//______________________________________________________
	: (Is Windows:C1573)
		
		$studio:=$in.project.$project.$studio
		
		If (Not:C34(Bool:C1537($studio.canceled)))
			
			$out:=New object:C1471(\
				"xCode"; New object:C1471("platform"; Windows:K25:3; \
				"XcodeAvailable"; False:C215; \
				"toolsAvalaible"; False:C215; \
				"ready"; False:C215); \
				"studio"; studioCheckInstall($in))
			
			If (Bool:C1537($out.studio.ready))
				
				// Get the last 4D Mobile Android SDK
				CALL WORKER:C1389($in.project.$worker; "downloadSDK"; "aws"; "android")  //;True)
				
			End if 
		End if 
		
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
	
	//$0:=$out
	
End if 

// ----------------------------------------------------
// End