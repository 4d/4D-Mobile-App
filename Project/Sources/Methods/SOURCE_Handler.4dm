//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : SOURCE_Handler
// ID[C28D0503938C4984BE97B6552461F324]
// Created 4-10-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_formEvent; $Lon_parameters)
C_TEXT:C284($t; $Txt_format; $Txt_url)
C_OBJECT:C1216($file; $Obj_form; $Obj_in; $Obj_out; $Obj_result; $oServer)

If (False:C215)
	C_OBJECT:C1216(SOURCE_Handler; $0)
	C_OBJECT:C1216(SOURCE_Handler; $1)
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
	
	$Obj_form:=New object:C1471(\
		"window"; Current form window:C827; \
		"ui"; editor_Panel_init; \
		"local"; "source_local"; \
		"server"; "source_server"; \
		"doNotGenerate"; "doNotGenerate"; \
		"doNotExportImages"; "doNotExportImages"; \
		"generate"; "generate"; \
		"serverStatus"; "serverStatus")
	
	If (OB Is empty:C1297($Obj_form.ui))
		
		$Obj_form.ui.help:=Get localized string:C991("help_source")
		
		// Define form methods
		$Obj_form.ui.testServer:=Formula:C1597(SOURCE_Handler(New object:C1471(\
			"action"; "checkingServerConfiguration")))
		
		$Obj_form.ui.remote:=Formula:C1597(String:C10(Form:C1466.dataSource.source)="server")
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$Lon_formEvent:=_o_panel_Form_common(On Load:K2:1; On Timer:K2:25)
		
		Case of 
				
				//______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				// Constraints definition
				$Obj_form.ui.constraints:=New object:C1471
				
				_o_ui_BEST_SIZE(New object:C1471(\
					"widgets"; New collection:C1472($Obj_form.generate; "dataGeneration"; "dataGeneration.label"); \
					"alignment"; Align left:K42:2; \
					"factor"; 1.15))
				
				_o_ui_BEST_SIZE(New object:C1471(\
					"widgets"; New collection:C1472($Obj_form.local)))
				
				_o_ui_BEST_SIZE(New object:C1471(\
					"widgets"; New collection:C1472($Obj_form.server)))
				
				_o_ui_BEST_SIZE(New object:C1471(\
					"widgets"; New collection:C1472($Obj_form.doNotGenerate)))
				
				// Declare check box as boolean (NO MORE NECESSARY IN JSON FORM)
				// EXECUTE FORMULA("C_BOOLEAN:C305((OBJECT Get pointer:C1124(Object named:K67:5;\"doNotGenerate\"))->)")
				
				$Obj_form.ui.testServer()
				
				ui_SET_ENABLED($Obj_form.generate; False:C215)
				
				OBJECT SET TITLE:C194(*; "dataGeneration.label"; Replace string:C233(Get localized string:C991("dataSetGeneration"); "\n\n"; "\r"))
				
				//______________________________________________________
			: ($Lon_formEvent=On Timer:K2:25)
				
				If ($Obj_form.ui.remote())
					
					(OBJECT Get pointer:C1124(Object named:K67:5; $Obj_form.server))->:=1
					(OBJECT Get pointer:C1124(Object named:K67:5; $Obj_form.local))->:=0
					
				Else 
					
					(OBJECT Get pointer:C1124(Object named:K67:5; $Obj_form.server))->:=0
					(OBJECT Get pointer:C1124(Object named:K67:5; $Obj_form.local))->:=1
					
				End if 
				
				If (Bool:C1537($Obj_form.ui.serverInTest))
					
					(OBJECT Get pointer:C1124(Object named:K67:5; "serverInTest"))->:=1
					OBJECT SET VISIBLE:C603(*; $Obj_form.serverStatus; False:C215)
					OBJECT SET VISIBLE:C603(*; "serverInTest@"; True:C214)
					
					// Disable the generate button & set tips
					ui_SET_ENABLED($Obj_form.generate; False:C215)
					OBJECT SET HELP TIP:C1181(*; $Obj_form.generate; "")
					
				Else 
					
					(OBJECT Get pointer:C1124(Object named:K67:5; "serverInTest"))->:=0
					OBJECT SET VISIBLE:C603(*; "serverInTest@"; False:C215)
					
					// Server status [
					// Title;picture;background;titlePos;titleVisible;iconVisible;style;horMargin;vertMargin;iconOffset;popupMenu;hyperlink;numStates
					$Txt_format:="{title};{picture};;;;;{style};{horMargin};;;;;"
					
					If (Bool:C1537($Obj_form.ui.serverStatus.success))
						
						$Txt_format:=Replace string:C233($Txt_format; "{picture}"; "#images/light_on.png")
						$Txt_format:=Replace string:C233($Txt_format; "{horMargin}"; "0")
						$Txt_format:=Replace string:C233($Txt_format; "{title}"; Get localized string:C991(Choose:C955($Obj_form.ui.remote(); "serverIsOnline"; "theWebServerIsRunning")))
						
						OBJECT SET HELP TIP:C1181(*; $Obj_form.serverStatus; "")
						
						ui_SET_ENABLED($Obj_form.generate; Bool:C1537(Form:C1466.dataSource.doNotGenerateDataAtEachBuild))
						
						OBJECT SET HELP TIP:C1181(*; $Obj_form.generate; Choose:C955(Bool:C1537(Form:C1466.dataSource.doNotGenerateDataAtEachBuild); Get localized string:C991("clickToGenerateADataset"); ""))
						
					Else 
						
						$Txt_format:=Replace string:C233($Txt_format; "{picture}"; Choose:C955(Num:C11($Obj_form.ui.serverStatus.type)=0; "#images/light_off.png"; "0"))
						$Txt_format:=Replace string:C233($Txt_format; "{horMargin}"; "50")
						
						If (Length:C16(String:C10($Obj_form.ui.serverStatus.title))>0)
							
							$Txt_format:=Replace string:C233($Txt_format; "{title}"; $Obj_form.ui.serverStatus.title)
							
						Else 
							
							// Generic message
							$Txt_format:=Replace string:C233($Txt_format; "{title}"; Get localized string:C991("theServerIsNotReady"))
							
						End if 
						
						OBJECT SET HELP TIP:C1181(*; $Obj_form.serverStatus; String:C10($Obj_form.ui.serverStatus.message))
						
						// Disable the generate button
						ui_SET_ENABLED($Obj_form.generate; False:C215)
						
						OBJECT SET HELP TIP:C1181(*; $Obj_form.generate; Choose:C955(Bool:C1537(Form:C1466.dataSource.doNotGenerateDataAtEachBuild); Get localized string:C991("theDataSourceIsNotReady"); ""))
						
					End if 
					
					OBJECT SET HELP TIP:C1181(*; $Obj_form.doNotGenerate; Choose:C955(Bool:C1537(Form:C1466.dataSource.doNotGenerateDataAtEachBuild); ""; Get localized string:C991("aDatasetWillBeGeneratedIfAnyAtEachBuild")))
					
					$Txt_format:=Replace string:C233($Txt_format; "{style}"; String:C10($Obj_form.ui.serverStatus.type))
					OBJECT SET FORMAT:C236(*; $Obj_form.serverStatus; $Txt_format)
					
					_o_ui_BEST_SIZE(New object:C1471(\
						"widgets"; New collection:C1472($Obj_form.serverStatus); \
						"alignment"; Align left:K42:2; \
						"factor"; Choose:C955(Num:C11($Obj_form.ui.serverStatus.type)=0; 1; 1.05)))
					
					OBJECT SET RGB COLORS:C628(*; $Obj_form.serverStatus; Choose:C955(Num:C11($Obj_form.ui.serverStatus.type)#0; Foreground color:K23:1; 0x00808080); Background color none:K23:10)
					
					OBJECT SET VISIBLE:C603(*; $Obj_form.serverStatus; True:C214)
					//]
					
				End if 
				
				(OBJECT Get pointer:C1124(Object named:K67:5; "dataGeneration"))->:=Num:C11(Bool:C1537(Form:C1466.$project.dataSetGeneration))
				OBJECT SET VISIBLE:C603(*; "dataGeneration@"; Bool:C1537(Form:C1466.$project.dataSetGeneration))
				
				//______________________________________________________
		End case 
		
		//=========================================================
	: ($Obj_in.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215; "Missing parameter \"action\"")
		
		//=========================================================
	: ($Obj_in.action="init")  // Return the form objects definition
		
		$0:=$Obj_form
		
		//=========================================================
	: ($Obj_in.action="testServer")
		
		$Obj_form.ui.serverInTest:=False:C215
		
		If ($Obj_form.ui.remote())
			
			$Obj_result:=Choose:C955($Obj_in.response=Null:C1517; New object:C1471; $Obj_in.response)
			
			If (Not:C34(Bool:C1537($Obj_result.success)))
				
				If (String:C10($Obj_result.errors[0].message)="The request is unauthorized")\
					 | (String:C10($Obj_result.errors[0].message)="This request is forbidden")
					
					$Obj_result.title:=Get localized string:C991("locateTheKey")
					$Obj_result.type:=9
					$Obj_result.action:="localizeKeyFile"
					
				Else 
					
					$Obj_result.title:=Get localized string:C991("theServerIsNotReady")
					$Obj_result.type:=0
					
				End if 
				
				If ($Obj_result.errors#Null:C1517)
					
					// Oops - Keep the first error message for the tips
					$Obj_result.message:=_o_SERVER_Handler(New object:C1471("action"; "localization"; "message"; String:C10($Obj_result.errors[0].message))).message
					
				Else 
					
					If ($Obj_result.response=Null:C1517)\
						 & (Num:C11($Obj_result.code)=0)
						
						$Obj_result.code:=30
						
					End if 
					
					// Use error code
					$Obj_result.message:=_o_SERVER_Handler(New object:C1471("action"; "localization"; "code"; Num:C11($Obj_result.code))).message
					
				End if 
				
			Else 
				
				$Obj_result.type:=0
				
			End if 
			
			$Obj_form.ui.serverStatus:=$Obj_result
			
			SET TIMER:C645(-1)
			
		End if 
		
		//=========================================================
	: ($Obj_in.action="checkingServerConfiguration")
		
		ASSERT:C1129(Not:C34(Shift down:C543))
		
		If (FEATURE.with("sourceClass")) & False:C215
			
			BEEP:C151
			
			var $oSource : Object
			$oSource:=cs:C1710.source.new()
			
			If ($Obj_form.ui.remote())
				
				// Verify the production server adress
				If (Length:C16(String:C10(Form:C1466.server.urls.production))>0)
					
					var $oServer : Object
					$oServer:=WEB Get server info:C1531
					
					var $ok : Boolean
					$ok:=Not:C34($oServer.started)
					
					If (Not:C34($ok))
						
						$ok:=(Position:C15("127.0.0.1"; Form:C1466.server.urls.production)=0)\
							 & (Position:C15("localhost"; Form:C1466.server.urls.production)=0)
						
						var $regex : cs:C1710.regex
						$regex:=cs:C1710.regex.new(Form:C1466.server.urls.production; "(?mi-s)(localhost|(?:(?:\\d+\\.){3}\\d+))(?::(\\d+))?").match()
						
						If ($regex.success)
							
							If ($regex.matches[1].data="127.0.0.1")\
								 | ($regex.matches[1].data="localhost")
								
/*
WARNING: "localhost" may not find the server if the computer is connected to a network.
127.0.0.1, on the other hand, will connect directly without going out to the network.
								
$regex.match[1].data:="127.0.0.1"
								
*/
								
								// Check the port
								If ($regex.matches.length>=2)
									
									$ok:=($oServer.options.webPortID#Num:C11($regex.matches[2].data))
									
								Else 
									
									// default port 80
									$ok:=($oServer.options.webPortID#80)
									
								End if 
								
								//______________________________________________________
							End if 
							
							If ($ok)
								
								var $oSystem : Object
								$oSystem:=Get system info:C1571
								
								var $o : Object
								$o:=$oSystem.networkInterfaces.query("ipAddresses[].ip=:1"; $regex.matches[1].data).pop()
								
								If ($o#Null:C1517)
									
									// warning même adresse mais pas moyen de tester le port
									
								Else 
									
									$ok:=True:C214
									
								End if 
							End if 
							
						Else 
							
							$ok:=True:C214
							
						End if 
					End if 
					
					If ($ok)
						
						If (Length:C16(String:C10(Form:C1466.dataSource.keyPath))>0)
							
							var $file : Object
							$file:=cs:C1710.doc.new(Form:C1466.dataSource.keyPath).target
							
							If ($file.exists)  // & Shift down
								
								// Test server
								If (Not:C34(Bool:C1537($Obj_form.ui.serverInTest)))
									
									$Obj_form.ui.serverInTest:=True:C214
									
									CALL WORKER:C1389(EDITOR.worker; "Rest"; New object:C1471(\
										"caller"; EDITOR.window; \
										"action"; "status"; \
										"handler"; "mobileapp"; \
										"timeout"; 60; \
										"url"; Form:C1466.server.urls.production; \
										"headers"; New object:C1471("X-MobileApp"; "1"; \
										"Authorization"; "Bearer "+$file.getText())))
									
								End if 
								
							Else 
								
								$Obj_result:=New object:C1471(\
									"success"; False:C215; \
									"title"; Get localized string:C991("locateTheKey"); \
									"message"; Get localized string:C991("theKeyFileIsNotAvailable")+"\r"+Get localized string:C991("clickHereToFindTheKeyFile"); \
									"action"; "localizeKeyFile"; \
									"type"; 9)
								
							End if 
							
						Else 
							
							CALL WORKER:C1389(EDITOR.worker; "Rest"; New object:C1471(\
								"caller"; EDITOR.window; \
								"action"; "status"; \
								"handler"; "mobileapp"; \
								"timeout"; 60; \
								"url"; Form:C1466.server.urls.production; \
								"headers"; New object:C1471(\
								"X-MobileApp"; "1")))
							
							$Obj_result:=New object:C1471(\
								"success"; False:C215; \
								"message"; Get localized string:C991("theKeyFileIsNotAvailable")+"\r"+Get localized string:C991("clickHereToFindTheKeyFile"); \
								"action"; "localizeKeyFile"; \
								"type"; 9)
							
						End if 
						
					Else 
						
						$Obj_result:=New object:C1471(\
							"success"; False:C215; \
							"title"; Get localized string:C991("setTheServerUrl"); \
							"message"; Get localized string:C991("theProductionUrlIsNotPopulated")+"\r"+Get localized string:C991("clickToFillItIn"); \
							"action"; "goToProductionURL"; \
							"type"; 9)
						
						POST_MESSAGE(New object:C1471(\
							"target"; Current form window:C827; \
							"action"; "show"; \
							"type"; "confirm"; \
							"title"; EDITOR.alert+" "+Get localized string:C991("theLocalWebServerIsStarted"); \
							"additional"; "youNeedToShutDownTheLocalWebServer"; \
							"okAction"; "stopWebServer"; \
							"ok"; "stopTheLocalServer"))
						
					End if 
					
				Else 
					
					$Obj_result:=New object:C1471(\
						"success"; False:C215; \
						"title"; Get localized string:C991("setTheServerUrl"); \
						"message"; Get localized string:C991("theProductionUrlIsNotPopulated")+"\r"+Get localized string:C991("clickToFillItIn"); \
						"action"; "goToProductionURL"; \
						"type"; 9)
					
				End if 
				
			Else 
				
				// Test REST response
				If (WEB Get server info:C1531.started)
					
					// Test the key
					$file:=Folder:C1567(fk mobileApps folder:K87:18; *).file("key.mobileapp")
					
					If (Not:C34($file.exists))
						
						$Obj_result:=$oSource.sendRequest()
						
					End if 
					
					If ($file.exists)
						
						// Make a call to verify
						$oSource.headers.push(New object:C1471(\
							"Authorization"; "Bearer "+$file.getText()))
						
						$Obj_result:=$oSource.status()
						
						If ($Obj_result.errors#Null:C1517)
							
							// Oops - Keep the first error message for the tips
							$Obj_result.message:=_o_SERVER_Handler(New object:C1471("action"; "localization"; "message"; String:C10($Obj_result.errors[0].message))).message
							
						End if 
						
					Else 
						
						// No key
						$Obj_result:=New object:C1471(\
							"success"; False:C215; \
							"message"; Get localized string:C991("failedToGenerateAuthorizationKey"))
						
					End if 
					
					$Obj_result.type:=0
					
				Else 
					
					$Obj_result:=New object:C1471(\
						"success"; False:C215; \
						"message"; Get localized string:C991("theWebServerIsNotStarted")+"\r"+Get localized string:C991("clickToStartIt"); \
						"action"; "startWebServer"; \
						"title"; Get localized string:C991("startWebServer"); \
						"type"; 9)
					
				End if 
			End if 
			
		Else 
			
			If ($Obj_form.ui.remote())
				
				// Verify the production server address
				$Txt_url:=String:C10(Form:C1466.server.urls.production)
				
				If (Length:C16($Txt_url)>0)
					
					C_BOOLEAN:C305($ok)
					$ok:=Not:C34(WEB Get server info:C1531.started)
					
					If (Not:C34($ok))
						
						$ok:=(Position:C15("127.0.0.1"; $Txt_url)=0)\
							 & (Position:C15("localhost"; $Txt_url)=0)
						
					End if 
					
					If ($ok)
						
						If (Length:C16(String:C10(Form:C1466.dataSource.keyPath))>0)
							
							//ACI0100868
							$t:=doc_Absolute_path(Form:C1466.dataSource.keyPath)
							
							If (Test path name:C476($t)#Is a document:K24:1)
								
								$t:=Convert path POSIX to system:C1107(Form:C1466.dataSource.keyPath)
								
							End if 
							
							var $file : Object
							$file:=File:C1566($t; fk platform path:K87:2)
							
							If ($file.exists)  // & Shift down
								
								// Test server
								If (Not:C34(Bool:C1537($Obj_form.ui.serverInTest)))
									
									$Obj_form.ui.serverInTest:=True:C214
									
									CALL WORKER:C1389(EDITOR.worker; "Rest"; New object:C1471(\
										"caller"; EDITOR.window; \
										"action"; "status"; \
										"handler"; "mobileapp"; \
										"timeout"; 60; \
										"url"; $Txt_url; \
										"headers"; New object:C1471("X-MobileApp"; "1"; \
										"Authorization"; "Bearer "+$file.getText())))
									
								End if 
								
							Else 
								
								//#ACI0100687 Generate the key
								$Obj_result:=Rest(New object:C1471(\
									"action"; "request"; \
									"handler"; "mobileapp"; \
									"url"; $Txt_url))
								
								$Obj_result:=New object:C1471(\
									"success"; False:C215; \
									"title"; Get localized string:C991("locateTheKey"); \
									"message"; Get localized string:C991("theKeyFileIsNotAvailable")+"\r"+Get localized string:C991("clickHereToFindTheKeyFile"); \
									"action"; "localizeKeyFile"; \
									"type"; 9)
								
							End if 
							
						Else 
							
							CALL WORKER:C1389(EDITOR.worker; "Rest"; New object:C1471(\
								"caller"; EDITOR.window; \
								"action"; "status"; \
								"handler"; "mobileapp"; \
								"timeout"; 60; \
								"url"; $Txt_url; \
								"headers"; New object:C1471(\
								"X-MobileApp"; "1")))
							
							$Obj_result:=New object:C1471(\
								"success"; False:C215; \
								"message"; Get localized string:C991("theKeyFileIsNotAvailable")+"\r"+Get localized string:C991("clickHereToFindTheKeyFile"); \
								"action"; "localizeKeyFile"; \
								"type"; 9)
							
						End if 
						
					Else 
						
						$Obj_result:=New object:C1471(\
							"success"; False:C215; \
							"title"; Get localized string:C991("setTheServerUrl"); \
							"message"; Get localized string:C991("theProductionUrlIsNotPopulated")+"\r"+Get localized string:C991("clickToFillItIn"); \
							"action"; "goToProductionURL"; \
							"type"; 9)
						
						POST_MESSAGE(New object:C1471(\
							"target"; Current form window:C827; \
							"action"; "show"; \
							"type"; "confirm"; \
							"title"; EDITOR.alert+" "+Get localized string:C991("theLocalWebServerIsStarted"); \
							"additional"; "youNeedToShutDownTheLocalWebServer"; \
							"okAction"; "stopWebServer"; \
							"ok"; "stopTheLocalServer"))
						
					End if 
					
				Else 
					
					$Obj_result:=New object:C1471(\
						"success"; False:C215; \
						"title"; Get localized string:C991("setTheServerUrl"); \
						"message"; Get localized string:C991("theProductionUrlIsNotPopulated")+"\r"+Get localized string:C991("clickToFillItIn"); \
						"action"; "goToProductionURL"; \
						"type"; 9)
					
				End if 
				
			Else 
				
				// Test REST response
				$oServer:=WEB Get server info:C1531
				
				If ($oServer.started)
					
					$Txt_url:="127.0.0.1:"+String:C10($oServer.options.webPortID)
					
					// Test the key
					$file:=Folder:C1567(fk mobileApps folder:K87:18; *).file("key.mobileapp")
					
					If (Not:C34($file.exists))
						
						// Generate the key
						$Obj_result:=Rest(New object:C1471(\
							"action"; "request"; \
							"handler"; "mobileapp"; \
							"url"; $Txt_url))
						
					End if 
					
					// Make a call to verify
					If ($file.exists)
						
						$Obj_result:=Rest(New object:C1471(\
							"action"; "request"; \
							"handler"; "mobileapp"; \
							"url"; $Txt_url; \
							"headers"; New object:C1471(\
							"X-MobileApp"; "1"; \
							"Authorization"; "Bearer "+$file.getText())))
						
						// Test REST response
						If ($Obj_result.__ERRORS#Null:C1517)
							
							// Oops - Keep the first error message for the tips
							$Obj_result.message:=_o_SERVER_Handler(New object:C1471("action"; "localization"; "message"; String:C10($Obj_result.__ERRORS[0].message))).message
							
						End if 
						
					Else 
						
						// No key
						$Obj_result:=New object:C1471(\
							"success"; False:C215; \
							"message"; Get localized string:C991("failedToGenerateAuthorizationKey"))
						
					End if 
					
					$Obj_result.type:=0
					
				Else 
					
					$Obj_result:=New object:C1471(\
						"success"; False:C215; \
						"message"; Get localized string:C991("theWebServerIsNotStarted")+"\r"+Get localized string:C991("clickToStartIt"); \
						"action"; "startWebServer"; \
						"title"; Get localized string:C991("startWebServer"); \
						"type"; 9)
					
				End if 
				
			End if   // A "If" statement should never omit "Else"
			
		End if 
		
		$Obj_form.ui.serverStatus:=$Obj_result
		
		SET TIMER:C645(-1)
		
		//=========================================================
	: ($Obj_in.action="dataset")  // End dataset generation
		
		SET TIMER:C645(-1)
		
		CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "update_data")
		
		If ($Obj_in.data#Null:C1517)
			If (Not:C34($Obj_in.data.success))
				If ($Obj_in.data.errors#Null:C1517)
					POST_MESSAGE(New object:C1471("action"; "show"; "type"; "alert"; "target"; $Obj_in.data.caller; "additional"; $Obj_in.data.errors.join("\n")))
				End if 
			End if 
		End if 
		
		//=========================================================
		
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$Obj_in.action+"\"")
		
		//=========================================================
End case 

// ----------------------------------------------------
// Return
//$0:=$Obj_out

// ----------------------------------------------------
// End