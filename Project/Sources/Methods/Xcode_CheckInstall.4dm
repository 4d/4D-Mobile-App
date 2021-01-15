//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : Xcode_CheckInstall
// ID[5178EE9219FD423C896557C7E4ACD66C]
// Created 29-6-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Checking the installation of Xcode
// - Is Xcode installed?
// - Is Xcode version ≥ minimum version?
// - Is development tools installed?
// - Is the Xcode licence accepted?
// ----------------------------------------------------
// Declarations
#DECLARE($in : Object)->$out : Object

If (False:C215)
	C_OBJECT:C1216(Xcode_CheckInstall; $0)
	C_OBJECT:C1216(Xcode_CheckInstall; $1)
End if 

var $in; $out; $signal : Object
var $Xcode : cs:C1710.Xcode

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

If (Value type:C1509(SHARED)=Is undefined:K8:13)  // For testing purposes
	
	COMPONENT_INIT
	
End if 

// Optional parameters
If (Count parameters:C259>=1)
	
	$in:=$1
	
End if 

$out:=New object:C1471(\
"platform"; Mac OS:K25:2; \
"XcodeAvailable"; False:C215; \
"toolsAvalaible"; False:C215; \
"ready"; False:C215)

// ----------------------------------------------------
// Check if Xcode is available into the "Applications" folder
$Xcode:=cs:C1710.Xcode.new(True:C214)

If ($Xcode.success)
	
	$out.XcodeAvailable:=$Xcode.application.exists
	
End if 

If ($out.XcodeAvailable)
	
	// Check version
	$out.ready:=$Xcode.checkVersion(SHARED.xCodeVersion)
	
	If (Not:C34($out.ready))
		
		// Look for the highest version of Xcode installed
		$Xcode.path()
		
		If ($Xcode.success)
			
			$out.XcodeAvailable:=$Xcode.application.exists
			
		End if 
		
		If ($out.XcodeAvailable)
			
			// Check version
			$out.ready:=$Xcode.checkVersion(SHARED.xCodeVersion)
			
		End if 
	End if 
	
	If ($out.ready)
		
		$out.version:=$Xcode.version
		
		// CHECK TOOLS-PATH
		$Xcode.toolsPath()
		
		If ($Xcode.tools.exists)
			
			$out.toolsAvalaible:=($Xcode.tools.parent.parent.path=$Xcode.application.path)
			
		End if 
		
		If (Not:C34($out.toolsAvalaible))
			
			$out.ready:=False:C215
			
			$signal:=await_MESSAGE(New object:C1471(\
				"target"; $in.caller; \
				"action"; "show"; \
				"type"; "confirm"; \
				"title"; "theDevelopmentToolsAreNotProperlyInstalled"; \
				"additional"; "wantToFixThePath"))
			
			If ($signal.validate)
				
				$Xcode.setToolPath(cs:C1710.str.new("4dMobileWantsToMakeChanges").localized("4dForIos"))
				
				If ($Xcode.success)
					
					If ($Xcode.tools.exists)
						
						$out.toolsAvalaible:=($Xcode.tools.parent.parent.path=$Xcode.application.path)
						
					End if 
					
				Else 
					
					If (Position:C15("User canceled. (-128)"; $Xcode.lastError)>0)
						
						// NOTHING MORE TO DO
						
					Else 
						
						POST_MESSAGE(New object:C1471(\
							"target"; $in.caller; \
							"action"; "show"; \
							"type"; "alert"; \
							"title"; "failedToRepairThePathOfTheDevelopmentTools"; \
							"additional"; "tryDoingThisFromTheXcodeApplication"))
						
					End if 
				End if 
			End if 
		End if 
		
	Else 
		
		$signal:=await_MESSAGE(New object:C1471(\
			"target"; $in.caller; \
			"action"; "show"; \
			"type"; "confirm"; \
			"title"; New collection:C1472("obsoleteVersionofApp"; "4dForIos"; SHARED.xCodeVersion; "Xcode"); \
			"additional"; New collection:C1472("wouldYouLikeToUpdateNow"; "xcode")))
		
		If ($signal.validate)
			
			OPEN URL:C673(Get localized string:C991("appstore_xcode"); *)
			
		End if 
	End if 
	
	If ($out.ready)
		
		If ($Xcode.tools=Null:C1517)
			
			$Xcode.toolsPath()
			
		End if 
		
		$out.xcode:=$Xcode.application
		$out.tools:=$Xcode.tools
		
		// CHECK FIRST INSTALL
		If (Not:C34($Xcode.checkFirstLaunchStatus()))
			
			$Xcode.setToolPath(cs:C1710.str.new("4dMobileWantsToMakeChanges").localized("4dForIos"))
			
		End if 
		
		If (Not:C34($Xcode.checkFirstLaunchStatus()))
			
			$signal:=await_MESSAGE(New object:C1471(\
				"target"; $in.caller; \
				"action"; "show"; \
				"type"; "confirm"; \
				"title"; "xcodeIsNotFullyFunctional"; \
				"additional"; New collection:C1472("wouldYouLikeToLaunchAppNow"; "xcode")))
			
			If ($signal.validate)
				
				$Xcode.open()
				
			End if 
		End if 
	End if 
	
Else 
	
	$signal:=await_MESSAGE(New object:C1471(\
		"target"; $in.caller; \
		"action"; "show"; \
		"type"; "confirm"; \
		"title"; New collection:C1472("4dMobileRequiresXcode"; "4dForIos"); \
		"additional"; New collection:C1472("wouldYouLikeToInstallNow"; "xcode")))
	
	If ($signal.validate)
		
		OPEN URL:C673(Get localized string:C991("appstore_xcode"); *)
		
	End if 
End if 

// ----------------------------------------------------
// Return
$0:=$out

// ----------------------------------------------------
// End