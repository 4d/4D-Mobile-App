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
$studio:=cs:C1710.studio.new()

If ($studio.success)
	
	$out.applicationAvailable:=$studio.exe.exists
	
End if 

If ($out.applicationAvailable)
	
	// Check version
	$out.ready:=$studio.checkVersion(SHARED.studioVersion)
	
	If ($out.ready)
		
		$out.version:=$studio.version
		
		// CHECK SDK
		$out.ready:=$studio.sdkFolder().exists
		
		If ($out.ready)
			
			// CHECK LICENCES
			//$out.ready:=cs.sdkmanager.new().success
			
			//If ($out.ready)
			
			// CHECK JAVA
			$out.ready:=$studio.java.exists
			
			If ($out.ready)
				
				// CHECK KOTLINC
				$out.ready:=$studio.kotlinc.exists
				
				If (Not:C34($out.ready))
					
					//#ERROR - kotlinc not found
					
				End if 
				
			Else 
				
				//#ERROR - java not found
				
			End if 
			
			//Else 
			
			//$signal:=await_MESSAGE(New object(\
								"target"; $in.caller; \
								"action"; "show"; \
								"type"; "confirm"; \
								"title"; "androidStudioMustBeLaunchedAtLeastOnceToBeFullyInstalled"; \
								"additional"; New collection("wouldYouLikeToLaunchAppNow"; "androidStudio")))
			
			//If ($signal.validate)
			
			//$studio.open()
			
			//End if 
			//End if 
			
		Else 
			
			$signal:=await_MESSAGE(New object:C1471(\
				"target"; $in.caller; \
				"action"; "show"; \
				"type"; "confirm"; \
				"title"; ".You must accept Android Studio Tools licences"; \
				"additional"; New collection:C1472("wouldYouLikeToLaunchAppNow"; "androidStudio")))  //#MARK_LOCALIZE
			
			If ($signal.validate)
				
				$studio.open()
				
			End if 
		End if 
		
	Else 
		
		$signal:=await_MESSAGE(New object:C1471(\
			"target"; $in.caller; \
			"action"; "show"; \
			"type"; "confirm"; \
			"title"; New collection:C1472("obsoleteVersionofApp"; "4dForAndroid"; SHARED.studioVersion; "androidStudio"); \
			"additional"; New collection:C1472("wouldYouLikeToUpdateNow"; "androidStudio")))
		
		If ($signal.validate)
			
			OPEN URL:C673(Get localized string:C991("downloadAndroidStudio"); *)
			
		End if 
	End if 
	
Else 
	
	If ($studio.window) | Not:C34(Bool:C1537($inƒ.silent))
		
		$signal:=await_MESSAGE(New object:C1471(\
			"target"; $inƒ.caller; \
			"action"; "show"; \
			"type"; "confirm"; \
			"title"; New collection:C1472("4dMobileRequiresAndroidStudio"; "4dForAndroid"); \
			"additional"; New collection:C1472("wouldYouLikeToInstallNow"; "androidStudio")))
		
		If ($signal.validate)
			
			OPEN URL:C673(Get localized string:C991("downloadAndroidStudio"); *)
			
		End if 
	End if 
End if 

// ----------------------------------------------------
// End