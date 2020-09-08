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
var $0: Object
var $1: Object

If (False:C215)
	C_OBJECT:C1216(Xcode_CheckInstall; $0)
	C_OBJECT:C1216(Xcode_CheckInstall; $1)
End if 

var $in; $out; $Xcode : Object

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

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
// Check install [
$Xcode:=Xcode(New object:C1471(\
"action"; "path"))

If ($Xcode.success)
	
	$out.XcodePosix:=$Xcode.posix
	$out.XcodePath:=$Xcode.path
	
	$out.XcodeAvailable:=(Test path name:C476($out.XcodePath)#-43)
	
End if 

If ($out.XcodeAvailable)
	
	// CHECK VERSION
	$Xcode:=Xcode(New object:C1471(\
		"action"; "version"; "path"; $out.XcodePath))
	
	If ($Xcode.success)
		
		// Keep the version
		$out.version:=$Xcode.version
		
		$out.ready:=str_cmpVersion($Xcode.version; SHARED.xCodeVersion)>=0  // Equal or higher
		
		If (Not:C34($out.ready))
			
			// Maybe there is a more recent one
			$Xcode:=Xcode(New object:C1471(\
				"action"; "lastpath"))
			
			If ($Xcode.success)
				
				$out.XcodePosix:=$Xcode.posix
				$out.XcodePath:=$Xcode.path
				
				$out.ready:=str_cmpVersion($Xcode.version; SHARED.xCodeVersion)>=0  // Equal or higher
				
			End if 
			
			If (Not:C34($out.ready))
				
				// No version available using spotlight search, ask to update
				POST_MESSAGE(New object:C1471(\
					"target"; $in.caller; \
					"action"; "show"; \
					"type"; "confirm"; \
					"title"; New collection:C1472("obsoleteVersionOfXcode"; "4dProductName"; SHARED.xCodeVersion); \
					"additional"; New collection:C1472("wouldYouLikeToInstallFromTheAppStoreNow"; "\"Xcode\""); \
					"cancelAction"; ""; \
					"okAction"; "installXcode"))
				
			End if 
		End if 
		
		// CHECK TOOLS-PATH
		$Xcode:=Xcode(New object:C1471(\
			"action"; "tools-path"))
		
		$out.toolsAvalaible:=$Xcode.success
		
		If ($out.toolsAvalaible)
			
			$out.toolsPosix:=$Xcode.posix
			
			$out.toolsAvalaible:=($out.toolsPosix=($out.XcodePosix+"/Contents/Developer"))\
				 | ($out.toolsPosix=($out.XcodePosix+"Contents/Developer"))
			
		End if 
		
		If (Not:C34($out.toolsAvalaible))
			
			$out.ready:=False:C215
			
			POST_MESSAGE(New object:C1471(\
				"target"; $in.caller; \
				"action"; "show"; \
				"type"; "confirm"; \
				"title"; "theDevelopmentToolsAreNotProperlyInstalled"; \
				"additional"; "wantToFixThePath"; \
				"cancelAction"; ""; \
				"okAction"; JSON Stringify:C1217(New object:C1471(\
				"action"; "setToolPath"; \
				"posix"; $out.XcodePosix))))
			
		End if 
	End if 
	
Else 
	
	POST_MESSAGE(New object:C1471(\
		"target"; $in.caller; \
		"action"; "show"; \
		"type"; "confirm"; \
		"title"; New collection:C1472("4dMobileRequiresToInstallDeveloperTools"; "4dProductName"); \
		"additional"; New collection:C1472("wouldYouLikeToInstallFromTheAppStoreNow"; "\"Xcode\""); \
		"cancelAction"; ""; \
		"okAction"; "installXcode"))
	
End if 

If ($out.ready)
	
	// CHECK LICENCE AGREEMENT
	$Xcode:=Xcode(New object:C1471(\
		"action"; "checkFirstLaunchStatus"))
	
	If (Not:C34($Xcode.success))
		
		// Alternatively you can launch with admin privileges 'sudo xcodebuild -runFirstLaunch'
		// $Obj_buffer:=Xcode (New object("action";"runFirstLaunch"))
		
		POST_MESSAGE(New object:C1471(\
			"target"; $in.caller; \
			"action"; "show"; \
			"type"; "confirm"; \
			"title"; "youHaveNotYetAcceptedTheXcodeLicense"; \
			"additional"; "wouldYouLikeToLaunchXcodeNow"; \
			"cancelAction"; ""; \
			"okAction"; "openXcode"))
		
	End if 
End if 

// ----------------------------------------------------
// Return
$0:=$out

// ----------------------------------------------------
// End