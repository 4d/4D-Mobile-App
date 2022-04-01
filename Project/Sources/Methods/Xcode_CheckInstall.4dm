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
// - Is the wanted tools are the active developper directory?
// - Is the Xcode licence accepted?
// ----------------------------------------------------
// Declarations
#DECLARE($in : Object)->$out : Object

If (False:C215)
	C_OBJECT:C1216(Xcode_CheckInstall; $0)
	C_OBJECT:C1216(Xcode_CheckInstall; $1)
End if 

var $inƒ; $requirement; $signal : Object
var $requestedVersion : Text
var $Xcode : cs:C1710.Xcode

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

If (SHARED=Null:C1517)  // FIXME #105596
	
	var Logger : cs:C1710.logger
	Logger:=Logger || cs:C1710.logger.new()
	Logger.warning("SHARED=Null")
	Logger.trace()
	
	COMPONENT_INIT
	
End if 

// Optional parameters
If (Count parameters:C259>=1)
	
	$inƒ:=$in
	
Else 
	
	$inƒ:=New object:C1471
	
End if 

$out:=New object:C1471(\
"platform"; Mac OS:K25:2; \
"applicationAvailable"; False:C215; \
"toolsAvalaible"; False:C215; \
"ready"; False:C215)

// ----------------------------------------------------
// *CHECK IF XCODE IS AVAILABLE INTO THE "APPLICATIONS" FOLDER
$Xcode:=cs:C1710.Xcode.new(True:C214)

If ($Xcode.success)
	
	// *CHECK IF MORE THAN ONE INSTANCE OF XCODE IS INSTALLED TO USE THE BEST ONE...
	$Xcode.getRequirements()
	$requestedVersion:=$Xcode.requirement
	
	// *** POUR LE TEST ***
	//$requestedVersion:="12.5.1"
	
	$Xcode.checkRequiredVersion($requestedVersion)
	
	If ($requestedVersion="^@")  // Remove '^' if any
		
		$requestedVersion:=Substring:C12($requestedVersion; 2)
		
	End if 
	
	If ($Xcode.success)
		
		$out.applicationAvailable:=$Xcode.application.exists
		$out.version:=$Xcode.version
		
		// *CHECK TOOLS-PATH
		$Xcode.toolsPath()
		
		If ($Xcode.tools.exists)
			
			$out.toolsAvalaible:=($Xcode.tools.parent.parent.path=$Xcode.application.path)
			
		End if 
		
		If ($out.toolsAvalaible)
			
			$out.ready:=True:C214
			
		Else 
			
			// *SETS THE ACTIVE DEVELOPER DIRECTORY
			
			If (Not:C34(Bool:C1537($inƒ.silent)))
				
				$signal:=await_MESSAGE(New object:C1471(\
					"target"; $inƒ.caller; \
					"action"; "show"; \
					"type"; "confirm"; \
					"title"; New collection:C1472("needsSetXcodeAsActiveVersion"; "4dForIos"; $requestedVersion); \
					"additional"; "doYouWantToSwitchTheActiveDevelopperDirectory"\
					))
				
				If ($signal.validate)
					
					$Xcode.switch(cs:C1710.str.new("switchTheActiveDevelopperDirectory").localized("4dForIos"))
					
					Case of 
							
							//______________________________________________________
						: ($Xcode.isCancelled())
							
							$out.canceled:=True:C214
							
							//______________________________________________________
						: ($Xcode.isWrongPassword())
							
							// #WRONG PASSWORD
							
							//______________________________________________________
						Else 
							
							// *RECHECK TOOLS-PATH
							$Xcode.toolsPath()
							
							$out.toolsAvalaible:=($Xcode.tools.parent.parent.path=$Xcode.application.path)
							
							If ($out.toolsAvalaible)
								
								$out.ready:=True:C214
								
							Else 
								
								If (Not:C34(Bool:C1537($inƒ.silent)))
									
									$signal:=await_MESSAGE(New object:C1471(\
										"target"; $inƒ.caller; \
										"action"; "show"; \
										"type"; "confirm"; \
										"title"; "theDevelopmentToolsAreNotProperlyInstalled"; \
										"additional"; "doYouWantToFixTheToolsPath"; \
										"cancel"; "later"))
									
									If ($signal.validate)
										
										$Xcode.setToolPath(cs:C1710.str.new("fixThePath").localized("4dForIos"))
										
										If ($Xcode.success)
											
											If ($Xcode.tools.exists)
												
												$out.toolsAvalaible:=($Xcode.tools.parent.parent.path=$Xcode.application.path)
												$out.ready:=$out.toolsAvalaible
												
											End if 
											
										Else 
											
											Case of 
													
													//______________________________________________________
												: ($Xcode.isCancelled())
													
													$out.canceled:=True:C214
													
													//______________________________________________________
												: ($Xcode.isWrongPassword())
													
													// #WRONG PASSWORD
													
													//______________________________________________________
												Else 
													
													POST_MESSAGE(New object:C1471(\
														"target"; $inƒ.caller; \
														"action"; "show"; \
														"type"; "alert"; \
														"title"; "failedToRepairThePathOfTheDevelopmentTools"; \
														"additional"; "tryDoingThisFromTheXcodeApplication"))
													
													//----------------------------------------
											End case 
										End if 
										
									Else 
										
										$out.canceled:=True:C214
										
									End if   //$signal.validate
								End if   //Not(Bool($inƒ.silent))
							End if   //$out.toolsAvalaible
							
							//______________________________________________________
					End case 
					
				Else 
					
					$out.canceled:=True:C214
					
				End if   //$signal.validate
			End if   //$signal.validate
		End if   //$out.toolsAvalaible
		
	Else 
		
		// #VERSION NOT SUPPORTED
		
		If (Not:C34(Bool:C1537($inƒ.silent)))
			
			If ($Xcode.versionCompare($requestedVersion; $Xcode.version)=1)  // # TO OLD VERSION
				
				$signal:=await_MESSAGE(New object:C1471(\
					"target"; $inƒ.caller; \
					"action"; "show"; \
					"type"; "confirm"; \
					"title"; New collection:C1472("tooOldVersion"; "4dForIos"; "Xcode"; $requestedVersion); \
					"additional"; New collection:C1472("wouldYouLikeToInstallNow"; "xcode"); \
					"cancel"; "later"\
					))
				
				If ($signal.validate)
					
					OPEN URL:C673(Get localized string:C991("appstore_xcode"); *)
					
				Else 
					
					$out.canceled:=True:C214
					
				End if   //$signal.validate
				
			Else   // # TO RECENT VERSION
				
				POST_MESSAGE(New object:C1471(\
					"target"; $inƒ.caller; \
					"action"; "show"; \
					"type"; "alert"; \
					"title"; New collection:C1472("versionNotSupported"; "Xcode"); \
					"additional"; New collection:C1472("tooRecentVersion"; "4dForIos"; "Xcode"; $requestedVersion); \
					"okFormula"; Formula:C1597(EDITOR.xCode.alreadyNotified:=True:C214)\
					))
				
			End if   //$xcode.versionCompare($version; $xcode.version)=1
		End if   //Not(Bool($inƒ.silent))
	End if   //$Xcode.success
	
Else   // #NO XCODE AVAILABLE
	
	If (Not:C34(Bool:C1537($inƒ.silent)))
		
		$signal:=await_MESSAGE(New object:C1471(\
			"target"; $inƒ.caller; \
			"action"; "show"; \
			"type"; "confirm"; \
			"title"; New collection:C1472("4dMobileRequiresXcode"; "4dForIos"); \
			"additional"; New collection:C1472("wouldYouLikeToInstallNow"; "xcode"); \
			"cancel"; "later"\
			))
		
		If ($signal.validate)
			
			OPEN URL:C673(Get localized string:C991("appstore_xcode"); *)
			
		Else 
			
			$out.canceled:=True:C214
			
		End if   //$signal.validate
	End if   //Not(Bool($inƒ.silent))
End if   //$Xcode.success
