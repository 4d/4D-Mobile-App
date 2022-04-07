//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : SERVER_Handler
// ID[75B0A66E1CF34B9282671E12991D64C9]
// Created 17-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_enabled; $Lon_formEvent; $Lon_parameters)
C_TEXT:C284($Dir_root; $t)
C_OBJECT:C1216($errors; $o; $Obj_form; $Obj_in; $Obj_out)

If (False:C215)
	C_OBJECT:C1216(_o_SERVER_Handler; $0)
	C_OBJECT:C1216(_o_SERVER_Handler; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	
	// Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
	End if 
	
	If (Form:C1466#Null:C1517)
		
		$Obj_form:=New object:C1471(\
			"form"; _o_editor_Panel_init; \
			"window"; Current form window:C827; \
			"email"; "03_email"; \
			"method"; "authenticationMethod"; \
			"productionURL"; "02_prodURL"; \
			"webSettings"; "webSettings")
		
	End if 
	
	$Obj_out:=New object:C1471
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$Lon_formEvent:=_o_panel_Form_common(On Load:K2:1)
		
		Case of 
				
				//______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				// Constraints definition
				$Obj_form.form.constraints:=New object:C1471
				
				_o_ui_BEST_SIZE(New object:C1471(\
					"widgets"; New collection:C1472($Obj_form.webSettings)))
				
				_o_ui_BEST_SIZE(New object:C1471(\
					"widgets"; New collection:C1472($Obj_form.email)))
				
				$Obj_in:=New object:C1471
				$Obj_in.buffer:=New object:C1471(\
					"server"; New object:C1471("authentication"; \
					New object:C1471; "urls"; \
					New object:C1471))
				
				ob_MERGE(Form:C1466; $Obj_in.buffer)
				
				_o_SERVER_Handler(New object:C1471(\
					"action"; "authenticationMethod"))
				
				//______________________________________________________
		End case 
		
		//=========================================================
	: ($Obj_in.action=Null:C1517)
		
		ASSERT:C1129(False:C215; "Missing parameter \"action\"")
		
		//=========================================================
	: ($Obj_in.action="init")  // Return the form objects definition
		
		$Obj_out:=$Obj_form
		
		//=========================================================
	: ($Obj_in.action="authenticationMethod")
		
		ARRAY TEXT:C222($tTxt_; 0x0000)
		METHOD GET PATHS:C1163(Path database method:K72:2; $tTxt_; *)
		
		If (Find in array:C230($tTxt_; METHOD Get path:C1164(Path database method:K72:2; "onMobileAppAuthentication"))=-1)
			
			OBJECT SET TITLE:C194(*; $Obj_form.method; Get localized string:C991("create..."))
			
		Else 
			
			OBJECT SET TITLE:C194(*; $Obj_form.method; Get localized string:C991("edit..."))
			
		End if 
		
		_o_ui_BEST_SIZE(New object:C1471(\
			"widgets"; New collection:C1472($Obj_form.method)))
		
		OBJECT SET VISIBLE:C603(*; $Obj_form.method; True:C214)
		
		//=========================================================
	: ($Obj_in.action="editAuthenticationMethod")
		
		ARRAY TEXT:C222($tTxt_; 0x0000)
		METHOD GET PATHS:C1163(Path database method:K72:2; $tTxt_; *)
		$tTxt_{0}:=METHOD Get path:C1164(Path database method:K72:2; "onMobileAppAuthentication")
		
		// Create method if not exist
		If (Find in array:C230($tTxt_; $tTxt_{0})=-1)
			
			If (Command name:C538(1)="Somme")
				
				// FR language
				$o:=File:C1566("/RESOURCES/fr.lproj/onMobileAppAuthentication.4dm")
				
			Else 
				
				$o:=File:C1566(Get localized document path:C1105("onMobileAppAuthentication.4dm"); fk platform path:K87:2)
				
			End if 
			
			If ($o.exists)
				
				$t:=$o.getText()
				METHOD SET CODE:C1194($tTxt_{0}; $t; *)
				
			End if 
		End if 
		
		// Open method
		METHOD OPEN PATH:C1213($tTxt_{0}; *)
		
		//=========================================================
	: ($Obj_in.action="checkingServerConfiguration")
		
		$Obj_in.buffer:=_o_SERVER_Handler(New object:C1471(\
			"action"; "checkProductionURL"; \
			"url"; Form:C1466.server.urls.production))
		
		If ($Obj_in.buffer.success)
			
			If (False:C215)  //#DISABLED
				$Obj_in.buffer:=_o_SERVER_Handler(New object:C1471(\
					"action"; "checkHttpsConfiguration"))
				
				If ($Obj_in.buffer.configuration.status="OK")
					
					project_UI_ALERT(New object:C1471(\
						"target"; "prodURL.alert"; \
						"reset"; True:C214))
					
				Else 
					
					project_UI_ALERT(New object:C1471(\
						"target"; "prodURL.alert"; \
						"type"; $Obj_in.buffer.configuration.status; \
						"tips"; $Obj_in.buffer.configuration.message))
					
				End if 
				
			Else 
				
				project_UI_ALERT(New object:C1471(\
					"target"; "prodURL.alert"; \
					"reset"; True:C214))
			End if 
			
		Else 
			
			project_UI_ALERT(New object:C1471(\
				"target"; "prodURL.alert"; \
				"type"; "ALERT"; \
				"tips"; $Obj_in.buffer.message))
			
		End if 
		
		//=========================================================
	: ($Obj_in.action="checkProductionURL")
		
		//$Obj_out:=New object
		
		// URL is not mandatory
		$Obj_out.success:=(Length:C16($Obj_in.url)=0)
		
		If (Not:C34($Obj_out.success))
			
			// Verify URL grammar
			$Obj_out.success:=cs:C1710.str.new($Obj_in.url).isUrl()
			
			If ($Obj_out.success)
				
				If (False:C215)  //#DISABLED
					
					// HTTPS is mandatory
					$Obj_out.success:=Match regex:C1019("(?m-si)https://"; $Obj_in.url; 1)
					
					If (Not:C34($Obj_out.success))
						
						$Obj_out.message:=Get localized string:C991("theUrlNeedsToBeginWithHttps")
						
					End if 
				End if 
				
			Else 
				
				$Obj_out.message:=Get localized string:C991("invalidUrl")
				
			End if 
		End if 
		
		//=========================================================
	: ($Obj_in.action="checkHttpsConfiguration")
		
		$Obj_out:=WEB Get server info:C1531
		
		// Create the configuration object
		$Obj_out.configuration:=New object:C1471
		
		// Get the current values for communication over HTTPS.
		//WEB GET OPTION(Web HTTPS enabled; $Lon_enabled)
		$Lon_enabled:=Num:C11($Obj_out.security.HTTPSEnabled)
		
		If ($Obj_out.started)  // Web server is launched
			
			// Check the HTTPS server status
			If (Bool:C1537($Obj_out.security.HTTPSEnabled))
				
				$Obj_out.configuration.status:="OK"
				
			Else 
				
				// HTTPS server is not launched
				If ($Lon_enabled=1)
					
					$Obj_out.configuration.status:="ALERT"
					
					// Is certificates are missing?
					$Dir_root:=HTTP Get certificates folder:C1307
					
					If (Test path name:C476($Dir_root+"cert.pem")#Is a document:K24:1)\
						 | (Test path name:C476($Dir_root+"key.pem")#Is a document:K24:1)
						
						$Obj_out.configuration.message:=Get localized string:C991("checkThatTheCertificatesAreProperlyInstalled")
						
					Else 
						
						// Unknown error ?
						$Obj_out.configuration.message:=Get localized string:C991("unknownErrorOccurred")
						
					End if 
					
				Else 
					
					$Obj_out.configuration.status:="ALERT"
					$Obj_out.configuration.message:=Get localized string:C991("httpsServerIsNotEnabledInWebConfigurationSettings")
					
				End if 
			End if 
			
		Else   // Web server is not started
			
			If ($Lon_enabled=1)
				
				var $status : Object
				var $web : 4D:C1709.WebServer
				
				$web:=WEB Server:C1674
				
				If (Not:C34($web.isRunning))
					
/* START TRAPPING ERRORS */$errors:=_o_err.capture()
					$status:=$web.start()
/* STOP TRAPPING ERRORS */$errors.release()
					
				Else 
					
					// Already started
					$status:=New object:C1471(\
						"success"; True:C214)
					
				End if 
				
				If ($status.success)
					
					$web.stop()
					
					$Obj_out.configuration.status:="OK"
					
				Else 
					
					$Obj_out.configuration.status:="ALERT"
					
					// Port conflict? or certificates are missing?
					$Dir_root:=HTTP Get certificates folder:C1307
					
					If (Test path name:C476($Dir_root+"cert.pem")#Is a document:K24:1)\
						 | (Test path name:C476($Dir_root+"key.pem")#Is a document:K24:1)
						
						$Obj_out.configuration.message:=Get localized string:C991("checkThatTheCertificatesAreProperlyInstalled")
						
					Else 
						
						$Obj_out.configuration.message:=$status.errors[0].message
						
					End if 
				End if 
				
			Else 
				
				$Obj_out.configuration.status:="ALERT"
				$Obj_out.configuration.message:=Get localized string:C991("httpsServerIsNotEnabledInWebConfigurationSettings")
				
			End if 
		End if 
		
		//=========================================================
		//: ($Obj_in.action="ui")
		//  // Test the Web server
		//$Lon_status:=Num(WEB Is server running)  //                  1 if server on
		//If ($Lon_status=1)  //                  Server is ON
		//$Txt_url:=Form.server.urls.test
		//If (Not(Match regex("(?i-ms)http[s]?://";$Txt_url;1)))
		//  // Default to http
		//$Txt_url:="http://"+$Txt_url
		// End if
		//$Obj_result:=WEB_Test (New object("url";$Txt_url))
		//If ($Obj_result.success)
		//  // Test the 4D Mobile Service
		//$Lon_status:=$Lon_status+Num(Rest (New object("action";"request";"path";"$catalog")).success)
		// Else
		//$Lon_error:=$Obj_result.status
		//WEB GET OPTION(Web Port ID;$Lon_port)
		//ARRAY TEXT($tTxt_result;0x0000)
		//If (Rgx_ExtractText ("(?mi-s):(\\d+)";$Txt_url;"1";->$tTxt_result)=0)
		//If ($Lon_port#Num($tTxt_result{1}))
		//$Lon_status:=-1
		// End if
		// End if
		// End if
		// End if
		// Case of
		//  //______________________________________________________
		//: ($Lon_status=0)  // Web server is off
		//$Txt_resources:="#images/light_off.png"
		//$Txt_tip:=message_Text (New collection("theWebServerIsShutDown";"\r";"clickToStartIt"))
		//  //______________________________________________________
		//: ($Lon_status=-1)
		//$Txt_resources:="#images/light_warning.png"
		//$Txt_tip:=Replace string(Replace string(Get localized string("theTcpPortIdDefinedIntoTheUrlIsNotTheSameAsUsedByTheWebServer");"{urlPort}";$tTxt_result{1});"{currentPort}";"String($Lon_port)")
		//project_UI_ALERT (New object("target";"test.alert";"type";"alert";"tips";$Txt_tip))
		//  //______________________________________________________
		//: ($Lon_status=1)  // Web server is running & rest server is off
		//$Txt_resources:="#images/light_warning.png"
		//  // Check the database settings
		//$Txt_buffer:=_4D Get Database Settings as XML
		//$Dom_root:=DOM Parse XML variable($Txt_buffer)
		// If (OK=1)
		//$Obj_settings:=xml_elementToObject ($Dom_root)
		//If ($Obj_settings["com.4d"].web.standalone_server.rest.launch_at_startup#Null)
		//$Boo_OK:=($Obj_settings["com.4d"].web.standalone_server.rest.launch_at_startup)
		// End if
		//DOM CLOSE XML($Dom_root)
		// End if
		//If ($Boo_OK)
		//  // "Activate 4D Mobile" is checked but Web server was not restarted
		//$Txt_tip:=message_Text (New collection("youMustRestartTheServerToActivateThe4dMobileService";"\r";"clickToRestartIt"))
		// Else
		//$Txt_tip:=Get localized string("4dMobileServiceIsDisabled")
		// End if
		//  //______________________________________________________
		//: ($Lon_status=2)  // Web server on & rest server on
		//$Txt_resources:="#images/light_on.png"
		//$Txt_tip:=message_Text (New collection("theWebServerIsRunning";"\r";"clickToRestartIt"))
		//  // ----------------------------------------
		// Else
		//$Txt_resources:="#images/light_warning.png"
		//$Txt_tip:=message_Text (New collection(Replace string(Get localized string("theWebServerIsNotReachable");"{error}";String($Lon_error));"\r";"clickToRestartIt"))
		//  //______________________________________________________
		// End case
		//OBJECT SET FORMAT(*;"testUrl.status";";"+$Txt_resources)
		//OBJECT SET HELP TIP(*;"testUrl.status";$Txt_tip)
		//#MARK_TODO - Register the server status into the form object to check before build
		
		//=========================================================
	: ($Obj_in.action="localization")
		
		If ($Obj_in.message#Null:C1517)
			
			// The returned messages are not localized…
			// …so we do it
			
			$Obj_out:=New object:C1471(\
				"success"; True:C214; \
				"message"; String:C10($Obj_in.message))
			
		Else 
			
			If ($Obj_in.code#Null:C1517)
				
				$Obj_out:=New object:C1471(\
					"success"; True:C214; \
					"message"; Get localized string:C991("error:")+String:C10($Obj_in.code))
				
			Else 
				
				$Obj_out:=New object:C1471(\
					"success"; False:C215)
				
			End if 
		End if 
		
		Case of 
				
				//______________________________________________________
			: (Not:C34($Obj_out.success))
				
				// <NOTHING MORE TO DO>
				
				//______________________________________________________
			: ($Obj_in.code#Null:C1517)
				
				$Obj_out.success:=True:C214
				
				Case of 
						
						//……………………………………………………………………………
					: ($Obj_in.code=30)
						
						$Obj_out.message:=Get localized string:C991("theWebServerIsNotReachable")
						
						//……………………………………………………………………………
					: ($Obj_in.code=403)
						
						$Obj_out.message:=Get localized string:C991("unauthorizedAccess")
						
						//……………………………………………………………………………
					: ($Obj_in.code=404)
						
						$Obj_out.message:=Get localized string:C991("serverNotFound")
						
						//……………………………………………………………………………
					: ($Obj_in.code=503)
						
						$Obj_out.message:=Get localized string:C991("serviceUnavailable")
						
						//……………………………………………………………………………
					Else 
						
						$Obj_out.success:=False:C215
						
						LOG_EVENT(New object:C1471(\
							"message"; "unlocalized http error code: "+String:C10($Obj_in.code)))
						
						//……………………………………………………………………………
				End case 
				
				If (Bool:C1537($Obj_out.success))
					
					$Obj_out.message:=$Obj_out.message+" ("+String:C10($Obj_in.code)+")"
					
				End if 
				
				//______________________________________________________
		End case 
		
		Case of 
				
				//______________________________________________________
			: ($Obj_out.success)
				
				// <NOTHING MORE TO DO>
				
				//______________________________________________________
			: (Length:C16(String:C10($Obj_in.message))=0)
				
				//
				
				//______________________________________________________
			: ($Obj_in.message="The request is mal formed")
				
				$Obj_out.message:=Get localized string:C991("theRequestIsMalformed")
				
				//______________________________________________________
			: ($Obj_in.message="The database method has failed")
				
				$Obj_out.message:=Get localized string:C991("theDatabaseMethodHasFailed")
				
				//______________________________________________________
			: ($Obj_in.message="The database method took too long to execute")
				
				$Obj_out.message:=Get localized string:C991("theDatabaseMethodTookTooLongToExecute")
				
				//______________________________________________________
			: ($Obj_in.message="The database method is not defined")
				
				$Obj_out.message:=Get localized string:C991("theDatabaseMethodIsNotDefined")
				
				//______________________________________________________
			: ($Obj_in.message="The request is unauthorized")\
				 | ($Obj_in.message="This request is forbidden")
				
				$Obj_out.message:=Get localized string:C991("unauthorizedAccess")+\
					"\r"+Get localized string:C991("makeSureThatTheKeyProvidedIsTheKeyOfTheServer")
				
				//______________________________________________________
			: ($Obj_in.message="Max number of sessions reached")
				
				$Obj_out.message:=Get localized string:C991("maxNumberOfSessionsReached")
				
				//______________________________________________________
			: ($Obj_in.message="Unable to generate authorization key")
				
				$Obj_out.message:=Get localized string:C991("failedToGenerateAuthorizationKey")
				
				//______________________________________________________
			Else 
				
				LOG_EVENT(New object:C1471(\
					"message"; "unlocalized http error message: "+String:C10($Obj_in.message)))
				
				//______________________________________________________
		End case 
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$Obj_in.action+"\"")
		
		//=========================================================
End case 

// ----------------------------------------------------
// Return
$0:=$Obj_out

// ----------------------------------------------------
// End