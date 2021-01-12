//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : studioCheckInstall
// ID[2A1B62E6BC6F46899AFA3FFA6F418242]
// Created 11-1-2021 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Checking the installation of Android Studio
// ----------------------------------------------------
// Declarations
#DECLARE($in : Object)->$out : Object

If (False:C215)
	C_OBJECT:C1216(studioCheckInstall; $0)
	C_OBJECT:C1216(studioCheckInstall; $1)
End if 

var $inƒ; $signal : Object
var $studio : cs:C1710.studio

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

If (Value type:C1509(SHARED)=Is undefined:K8:13)  // For testing purposes
	
	COMPONENT_INIT
	
End if 

// Optional parameters
If (Count parameters:C259>=1)
	
	$inƒ:=$in
	
End if 

$out:=New object:C1471(\
"platform"; Choose:C955(Is macOS:C1572; Mac OS:K25:2; Windows:K25:3); \
"studioAvailable"; False:C215; \
"ready"; False:C215)

// ----------------------------------------------------
// Check if Android Studio is available into the "Applications" folder
$studio:=cs:C1710.studio.new(True:C214)

If ($studio.success)
	
	$out.studioAvailable:=$studio.application.exists
	
End if 

If ($out.studioAvailable)
	
	// Check version
	$out.ready:=$studio.checkVersion(SHARED.studioVersion)
	
Else 
	
	If ($studio.isWindows) | Bool:C1537($inƒ.mandatory)
		
		$signal:=await_MESSAGE(New object:C1471(\
			"target"; $inƒ.caller; \
			"action"; "show"; \
			"type"; "confirm"; \
			"title"; New collection:C1472("4dMobileRequiresAndroidStudio"; "4dProductName"); \
			"additional"; New collection:C1472("wouldYouLikeToInstallNow"; "\"Android Studio\"")))
		
		If ($signal.validate)
			
			OPEN URL:C673(Get localized string:C991("androidStudio"); *)
			
		End if 
	End if 
End if 

// ----------------------------------------------------
// End