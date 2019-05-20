//%attributes = {"invisible":true,"preemptive":"capable"}
/*
out := ***Xcode_CheckInstall*** ( in )
 -> in (Object)
 <- out (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : Xcode_CheckInstall
  // Database: 4D Mobile Express
  // ID[5178EE9219FD423C896557C7E4ACD66C]
  // Created #29-6-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Checking the installation of Xcode
  //    - Is Xcode installed?
  //    - Is Xcode version ≥ minimum version?
  //    - Is development tools installed?
  //    - Is the Xcode licence accepted?
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($kTxt_minimumVersion;$Txt_buffer)
C_OBJECT:C1216($Obj_in;$Obj_out;$Obj_xcode)

If (False:C215)
	C_OBJECT:C1216(Xcode_CheckInstall ;$0)
	C_OBJECT:C1216(Xcode_CheckInstall ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
	End if 
	
	$kTxt_minimumVersion:=commonValues.xCodeVersion
	
	$Obj_out:=New object:C1471(\
		"platform";Mac OS:K25:2;\
		"XcodeAvailable";False:C215;\
		"toolsAvalaible";False:C215;\
		"ready";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // Check install [
$Obj_xcode:=Xcode (New object:C1471(\
"action";"path"))

If ($Obj_xcode.success)
	
	$Obj_out.XcodePosix:=$Obj_xcode.posix
	$Obj_out.XcodePath:=$Obj_xcode.path
	
	$Obj_out.XcodeAvailable:=(Test path name:C476($Obj_out.XcodePath)#-43)
	
End if 

If ($Obj_out.XcodeAvailable)
	
	  // Check version [
	$Obj_xcode:=Xcode (New object:C1471(\
		"action";"version";"path";$Obj_out.XcodePath))
	
	If ($Obj_xcode.success)
		
		  // Keep the version
		$Obj_out.version:=$Obj_xcode.version
		
		$Txt_buffer:=Replace string:C233($Obj_xcode.version;".";"")
		
		$Obj_out.ready:=str_cmpVersion ($Obj_xcode.version;$kTxt_minimumVersion)>=0  // Equal or higher
		
		If (Not:C34($Obj_out.ready))
			
			  // Maybe there is a more recent one
			$Obj_xcode:=Xcode (New object:C1471(\
				"action";"lastpath"))
			
			If ($Obj_xcode.success)
				
				$Obj_out.XcodePosix:=$Obj_xcode.posix
				$Obj_out.XcodePath:=$Obj_xcode.path
				
				$Obj_out.ready:=str_cmpVersion ($Obj_xcode.version;$kTxt_minimumVersion)>=0  // Equal or higher
				
			End if 
			
			If (Not:C34($Obj_out.ready))
				
				  // No version available using spotlight search, ask to update
				POST_FORM_MESSAGE (New object:C1471(\
					"target";$Obj_in.caller;\
					"action";"show";\
					"type";"confirm";\
					"title";New collection:C1472("obsoleteVersionOfXcode";"4dProductName";$kTxt_minimumVersion);\
					"additional";New collection:C1472("wouldYouLikeToInstallFromTheAppStoreNow";"\"Xcode\"");\
					"cancelAction";"";\
					"okAction";"installXcode"))
				
			End if 
		End if 
		  //]
		
		  // Check tools-path [
		$Obj_xcode:=Xcode (New object:C1471(\
			"action";"tools-path"))
		
		$Obj_out.toolsAvalaible:=$Obj_xcode.success
		
		If ($Obj_out.toolsAvalaible)
			
			$Obj_out.toolsPosix:=$Obj_xcode.posix
			
			$Obj_out.toolsAvalaible:=($Obj_out.toolsPosix=($Obj_out.XcodePosix+"/Contents/Developer"))\
				 | ($Obj_out.toolsPosix=($Obj_out.XcodePosix+"Contents/Developer"))
			
		End if 
		
		If (Not:C34($Obj_out.toolsAvalaible))
			
			$Obj_out.ready:=False:C215
			
			POST_FORM_MESSAGE (New object:C1471(\
				"target";$Obj_in.caller;\
				"action";"show";\
				"type";"confirm";\
				"title";"theDevelopmentToolsAreNotProperlyInstalled";\
				"additional";"wantToFixThePath";\
				"cancelAction";"";\
				"okAction";JSON Stringify:C1217(New object:C1471(\
				"action";"setToolPath";\
				"posix";$Obj_out.XcodePosix))))
			
		End if 
	End if 
	  //]
	
Else 
	
	POST_FORM_MESSAGE (New object:C1471(\
		"target";$Obj_in.caller;\
		"action";"show";\
		"type";"confirm";\
		"title";New collection:C1472("4dMobileRequiresToInstallDeveloperTools";"4dProductName");\
		"additional";New collection:C1472("wouldYouLikeToInstallFromTheAppStoreNow";"\"Xcode\"");\
		"cancelAction";"";\
		"okAction";"installXcode"))
	
End if 

If ($Obj_out.ready)
	
	  // Check licence agreement [
	$Obj_xcode:=Xcode (New object:C1471(\
		"action";"checkFirstLaunchStatus"))
	
	If (Not:C34($Obj_xcode.success))
		
		  // Alternatively you can launch with admin privileges 'sudo xcodebuild -runFirstLaunch'
		  // $Obj_buffer:=Xcode (New object("action";"runFirstLaunch"))
		
		POST_FORM_MESSAGE (New object:C1471(\
			"target";$Obj_in.caller;\
			"action";"show";\
			"type";"confirm";\
			"title";"youHaveNotYetAcceptedTheXcodeLicense";\
			"additional";"wouldYouLikeToLaunchXcodeNow";\
			"cancelAction";"";\
			"okAction";"openXcode"))
		
	End if 
	  //]
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End