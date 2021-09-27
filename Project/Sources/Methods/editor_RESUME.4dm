//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_RESUME
// ID[ED02AB7186F243EC934AAF4A70A66505]
// Created 4-10-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $1 : Text
var $2 : Object

If (False:C215)
	C_TEXT:C284(editor_RESUME; $1)
	C_OBJECT:C1216(editor_RESUME; $2)
End if 

var $callback; $databasePatgname; $message; $selector : Text
var $target : Integer
var $cancel; $errors; $in; $ok; $params; $webServerInfos : Object

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=0; "Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	
	// Optional parameters
	If (Count parameters:C259>=1)
		
		$selector:=$1
		
		// #ACI0098517
		//If ($Txt_selector="{@}")
		If (Match regex:C1019("(?m-si)^\\{.*\\}$"; $selector; 1))
			
			$in:=JSON Parse:C1218($selector)
			$selector:=String:C10($in.action)
			
		End if 
		
		If (Count parameters:C259>=2)
			
			$params:=$2
			
		End if 
	End if 
	
	$target:=Current form window:C827
	$callback:="editor_CALLBACK"
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: (Length:C16($selector)=0)
		
		// NOTHING MORE TO DO
		
		//______________________________________________________
	: ($selector="page_@")
		
		If ($in#Null:C1517)
			
			$in.action:="goToPage"
			$in.page:=Delete string:C232($selector; 1; 5)
			
			EDITOR.callMeBack("goToPage"; $in)
			
		Else 
			
			EDITOR.callMeBack("goToPage"; New object:C1471(\
				"page"; Delete string:C232($selector; 1; 5)\
				))
			
		End if 
		
		//______________________________________________________
	: ($selector="build_stop")  // #MARK_TO_REMOVE
		
		EDITOR.callMeBack($selector)
		
		//______________________________________________________
	: ($selector="build_deleteProductFolder")  // #MARK_TO_REMOVE
		
		If (Asserted:C1132($in.build#Null:C1517))
			
			If (Asserted:C1132(Test path name:C476($in.build.path)=Is a folder:K24:2))
				
				Xcode(New object:C1471(\
					"action"; "safeDelete"; \
					"path"; $in.build.path))
				
				BUILD($in.build)  // Relaunch the build process
				
			End if 
		End if 
		
		//______________________________________________________
	: ($selector="build_ignoreServer")
		
		$in.build.ignoreServer:=True:C214
		
		BUILD($in.build)  // Relaunch the build process
		
		//______________________________________________________
	: ($selector="build_startWebServer")\
		 | ($selector="startWebServer")
		
/* START TRAPPING ERRORS */
		$errors:=err.capture()
		WEB START SERVER:C617
		$errors.release()
/* STOP TRAPPING ERRORS */
		
		If (OK=1)
			
			If ($selector="build_startWebServer")
				
				BUILD($in.build)  // Relaunch the build process
				
			End if 
			
		Else 
			
			$webServerInfos:=WEB Get server info:C1531
			
			Case of 
					
					//______________________________________________________
				: ($webServerInfos.security.HTTPEnabled)
					
					// Port conflict?
					If (Num:C11($errors.lastError().error)=-1)
						
						$message:=cs:C1710.str.new("someListeningPortsAreAlreadyUsed").localized(New collection:C1472(String:C10($webServerInfos.options.webPortID); String:C10($webServerInfos.options.webHTTPSPortID)))
						
					Else 
						
						// Display error number
						$message:=Get localized string:C991("error:")+String:C10($errors.lastError().error)
						
					End if 
					
					//______________________________________________________
				: ($webServerInfos.security.HTTPSEnabled)
					
					// Port conflict? or certificates are missing?
					$databasePatgname:=Get 4D folder:C485(Database folder:K5:14; *)
					
					If (Test path name:C476($databasePatgname+"cert.pem")#Is a document:K24:1)\
						 | (Test path name:C476($databasePatgname+"key.pem")#Is a document:K24:1)
						
						$message:=Get localized string:C991("checkThatTheCertificatesAreProperlyInstalled")
						
					Else 
						
						If (Num:C11($errors.lastError().error)=-1)
							
							$message:=cs:C1710.str.new("someListeningPortsAreAlreadyUsed").localized(New collection:C1472(String:C10($webServerInfos.options.webPortID); String:C10($webServerInfos.options.webHTTPSPortID)))
							
						Else 
							
							// Display error number
							$message:=Get localized string:C991("error:")+String:C10($errors.lastError().error)
							
						End if 
					End if 
					
					//______________________________________________________
				Else 
					
					$message:=Get localized string:C991("httpsServerIsNotEnabledInWebConfigurationSettings")
					
					//______________________________________________________
			End case 
			
			POST_MESSAGE(New object:C1471(\
				"target"; $target; \
				"action"; "show"; \
				"type"; "alert"; \
				"title"; Get localized string:C991("failedToStartTheWebServer"); \
				"additional"; $message))
			
		End if 
		
		//______________________________________________________
	: ($selector="build_waitingForConfigurator")
		
		// Open App Store
		device(New object:C1471(\
			"action"; "appStore"))
		
		// Warning build is into in.build
		$ok:=New object:C1471(\
			"action"; "build_configuratorInstalled"; \
			"build"; $in.build)
		
		$cancel:=New object:C1471(\
			"action"; "build_manualInstallation"; \
			"build"; $in.build)
		
		POST_MESSAGE(New object:C1471(\
			"target"; $target; \
			"action"; "show"; \
			"type"; "confirm"; \
			"title"; Get localized string:C991("appleConfigurator2Installation"); \
			"additional"; Get localized string:C991("clicContinueWhenAppleConfigurator2IsInstalledOnYourMac"); \
			"ok"; Get localized string:C991("continue"); \
			"okAction"; JSON Stringify:C1217($ok); \
			"cancelAction"; JSON Stringify:C1217($cancel)))
		
		//______________________________________________________
	: ($selector="build_configuratorInstalled")\
		 | ($selector="build_manualInstallation")
		
		$in.build.manualInstallation:=($selector="build_manualInstallation")
		
		CALL FORM:C1391($target; "BUILD"; $in.build)  // Relaunch the build process
		
		//______________________________________________________
	: ($selector="projectFixErrors")
		
		CALL FORM:C1391($target; $callback; $selector; $in)
		
		//______________________________________________________
	: ($selector="stopWebServer")
		
		WEB STOP SERVER:C618
		CALL FORM:C1391($target; $callback; "testServer"; $in)
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$selector+"\"")
		
		//______________________________________________________
End case 