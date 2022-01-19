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
#DECLARE($in : Object)->$form : Object

If (False:C215)
	C_OBJECT:C1216(SOURCE_Handler; $1)
	C_OBJECT:C1216(SOURCE_Handler; $0)
End if 

var $t; $format; $url : Text
var $ok : Boolean
var $eventCode : Integer
var $o; $oServer; $oSystem; $result : Object
var $file : 4D:C1709.File
var $regex : cs:C1710.regex
var $oSource : cs:C1710.sources

// ----------------------------------------------------
// Initialisations
$form:=New object:C1471(\
"window"; Current form window:C827; \
"ui"; editor_Panel_init; \
"local"; "local"; \
"server"; "server"; \
"doNotGenerate"; "doNotGenerate"; \
"doNotExportImages"; "doNotExportImages"; \
"generate"; "generate"; \
"serverStatus"; "serverStatus")

If (OB Is empty:C1297($form.ui))
	
	$form.ui.help:=Get localized string:C991("help_source")
	
	// Define form methods
	$form.ui.testServer:=Formula:C1597(SOURCE_Handler(New object:C1471(\
		"action"; "checkingServerConfiguration")))
	
	$form.ui.remote:=Formula:C1597(String:C10(Form:C1466.dataSource.source)="server")
	
End if 

// ----------------------------------------------------
Case of 
		
		//=========================================================
	: ($in=Null:C1517)  // Form method
		
		$eventCode:=_o_panel_Form_common(On Load:K2:1; On Timer:K2:25)
		
		Case of 
				
				//______________________________________________________
			: ($eventCode=On Load:K2:1)
				
				// Constraints definition
				$form.ui.constraints:=New object:C1471
				
				If (FEATURE.with("cancelableDatasetGeneration"))
					
					_o_ui_BEST_SIZE(New object:C1471(\
						"widgets"; New collection:C1472($form.generate)))
					
					//TODO: align lastGeneration
					
				Else 
					
					_o_ui_BEST_SIZE(New object:C1471(\
						"widgets"; New collection:C1472($form.generate; "dataGeneration"; "dataGenerationLabel"); \
						"alignment"; Align left:K42:2; \
						"factor"; 1.15))
					
					OBJECT SET TITLE:C194(*; "dataGenerationLabel"; Replace string:C233(Get localized string:C991("dataSetGeneration"); "\n\n"; "\r"))
					
				End if 
				
				_o_ui_BEST_SIZE(New object:C1471(\
					"widgets"; New collection:C1472($form.local)))
				
				_o_ui_BEST_SIZE(New object:C1471(\
					"widgets"; New collection:C1472($form.server)))
				
				_o_ui_BEST_SIZE(New object:C1471(\
					"widgets"; New collection:C1472($form.doNotGenerate)))
				
				$form.ui.testServer()
				
				OBJECT SET ENABLED:C1123(*; $form.generate; False:C215)
				
				//______________________________________________________
			: ($eventCode=On Timer:K2:25)
				
				If ($form.ui.remote())
					
					(OBJECT Get pointer:C1124(Object named:K67:5; $form.server))->:=True:C214
					(OBJECT Get pointer:C1124(Object named:K67:5; $form.local))->:=False:C215
					
				Else 
					
					(OBJECT Get pointer:C1124(Object named:K67:5; $form.server))->:=False:C215
					(OBJECT Get pointer:C1124(Object named:K67:5; $form.local))->:=True:C214
					
				End if 
				
				If (Bool:C1537($form.ui.doTestServer))
					
					(OBJECT Get pointer:C1124(Object named:K67:5; "serverInTest"))->:=1
					OBJECT SET VISIBLE:C603(*; $form.serverStatus; False:C215)
					OBJECT SET VISIBLE:C603(*; "serverInTest@"; True:C214)
					
					// Disable the generate button & set tips
					OBJECT SET ENABLED:C1123(*; $form.generate; False:C215)
					OBJECT SET HELP TIP:C1181(*; $form.generate; "")
					
				Else 
					
					//MARK: UI update
					(OBJECT Get pointer:C1124(Object named:K67:5; "serverInTest"))->:=0
					OBJECT SET VISIBLE:C603(*; "serverInTest@"; False:C215)
					
					// Server status [
					// Title;picture;background;titlePos;titleVisible;iconVisible;style;horMargin;vertMargin;iconOffset;popupMenu;hyperlink;numStates
					$format:="{title};{picture};;;;;{style};{horMargin};;;;;"
					
					If (Bool:C1537($form.ui.serverStatus.success))
						
						$format:=Replace string:C233($format; "{picture}"; "#images/light_on.png")
						$format:=Replace string:C233($format; "{horMargin}"; "0")
						$format:=Replace string:C233($format; "{title}"; Get localized string:C991(Choose:C955($form.ui.remote(); "serverIsOnline"; "theWebServerIsRunning")))
						
						OBJECT SET HELP TIP:C1181(*; $form.serverStatus; "")
						OBJECT SET ENABLED:C1123(*; $form.generate; Bool:C1537(Form:C1466.dataSource.doNotGenerateDataAtEachBuild))
						OBJECT SET HELP TIP:C1181(*; $form.generate; Choose:C955(Bool:C1537(Form:C1466.dataSource.doNotGenerateDataAtEachBuild); Get localized string:C991("clickToGenerateADataset"); ""))
						
					Else 
						
						$format:=Replace string:C233($format; "{picture}"; Choose:C955(Num:C11($form.ui.serverStatus.type)=0; "#images/light_off.png"; "0"))
						$format:=Replace string:C233($format; "{horMargin}"; "50")
						
						If (Length:C16(String:C10($form.ui.serverStatus.title))>0)
							
							$format:=Replace string:C233($format; "{title}"; $form.ui.serverStatus.title)
							
						Else 
							
							// Generic message
							$format:=Replace string:C233($format; "{title}"; Get localized string:C991("theServerIsNotReady"))
							
						End if 
						
						OBJECT SET HELP TIP:C1181(*; $form.serverStatus; String:C10($form.ui.serverStatus.message))
						
						// Disable the generate button
						OBJECT SET ENABLED:C1123(*; $form.generate; False:C215)
						OBJECT SET HELP TIP:C1181(*; $form.generate; Choose:C955(Bool:C1537(Form:C1466.dataSource.doNotGenerateDataAtEachBuild); Get localized string:C991("theDataSourceIsNotReady"); ""))
						
					End if 
					
					OBJECT SET HELP TIP:C1181(*; $form.doNotGenerate; Choose:C955(Bool:C1537(Form:C1466.dataSource.doNotGenerateDataAtEachBuild); ""; Get localized string:C991("aDatasetWillBeGeneratedIfAnyAtEachBuild")))
					
					$format:=Replace string:C233($format; "{style}"; String:C10($form.ui.serverStatus.type))
					OBJECT SET FORMAT:C236(*; $form.serverStatus; $format)
					
					_o_ui_BEST_SIZE(New object:C1471(\
						"widgets"; New collection:C1472($form.serverStatus); \
						"alignment"; Align left:K42:2; \
						"factor"; Choose:C955(Num:C11($form.ui.serverStatus.type)=0; 1; 1.05)))
					
					OBJECT SET RGB COLORS:C628(*; $form.serverStatus; Choose:C955(Num:C11($form.ui.serverStatus.type)#0; Foreground color:K23:1; 0x00808080); Background color none:K23:10)
					OBJECT SET VISIBLE:C603(*; $form.serverStatus; True:C214)
					//]
					
				End if 
				
				If (FEATURE.with("cancelableDatasetGeneration"))
					
					$file:=PROJECT._folder.file("project.dataSet/Resources/Structures.sqlite")
					OBJECT SET TITLE:C194(*; "lastGeneration"; EDITOR.str.localize("lastGeneration"; New collection:C1472(String:C10($file.modificationDate); Time string:C180($file.modificationTime))))
					OBJECT SET VISIBLE:C603(*; "lastGeneration@"; $file.exists)
					
					If (Bool:C1537(Form:C1466.$project.dataSetGeneration))
						
						// Disable the generate button during generation
						OBJECT SET ENABLED:C1123(*; $form.generate; False:C215)
						
					End if 
					
				Else 
					
					(OBJECT Get pointer:C1124(Object named:K67:5; "dataGeneration"))->:=Num:C11(Bool:C1537(Form:C1466.$project.dataSetGeneration))
					OBJECT SET VISIBLE:C603(*; "dataGeneration@"; Bool:C1537(Form:C1466.$project.dataSetGeneration))
					
				End if 
				
				//______________________________________________________
		End case 
		
		//=========================================================
	: ($in.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215; "Missing parameter \"action\"")
		
		//=========================================================
	: ($in.action="init")
		
		// Return the form objects definition
		
		//=========================================================
	: ($in.action="testServer")
		
		$form.ui.doTestServer:=False:C215
		
		If ($form.ui.remote())
			
			$result:=Choose:C955($in.response=Null:C1517; New object:C1471; $in.response)
			
			If (Not:C34(Bool:C1537($result.success)))
				
				If (String:C10($result.errors[0])="The request is unauthorized")\
					 | (String:C10($result.errors[0])="This request is forbidden")
					
					$result.title:=Get localized string:C991("locateTheKey")
					$result.type:=9
					$result.action:="localizeKeyFile"
					
				Else 
					
					$result.title:=Get localized string:C991("theServerIsNotReady")
					$result.type:=0
					
				End if 
				
				If ($result.errors#Null:C1517)
					
					// Oops - Keep the first error message for the tips
					$result.message:=_o_SERVER_Handler(New object:C1471("action"; "localization"; "message"; String:C10($result.errors[0].message))).message
					
				Else 
					
					If ($result.response=Null:C1517)\
						 & (Num:C11($result.code)=0)
						
						$result.code:=30
						
					End if 
					
					// Use error code
					$result.message:=_o_SERVER_Handler(New object:C1471("action"; "localization"; "code"; Num:C11($result.code))).message
					
				End if 
				
			Else 
				
				$result.type:=0
				
			End if 
			
			$form.ui.serverStatus:=$result
			
			SET TIMER:C645(-1)
			
		End if 
		
		//=========================================================
	: ($in.action="checkingServerConfiguration")
		
		If (FEATURE.with("sourceClass")) & False:C215
			
			BEEP:C151
			
			$oSource:=cs:C1710.sources.new()
			
			If ($form.ui.remote())
				
				// Verify the production server adress
				If (Length:C16(String:C10(Form:C1466.server.urls.production))>0)
					
					$oServer:=WEB Get server info:C1531
					
					$ok:=Not:C34($oServer.started)
					
					If (Not:C34($ok))
						
						$ok:=(Position:C15("127.0.0.1"; Form:C1466.server.urls.production)=0)\
							 & (Position:C15("localhost"; Form:C1466.server.urls.production)=0)
						
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
								
								$oSystem:=Get system info:C1571
								
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
							
							$file:=cs:C1710.doc.new(Form:C1466.dataSource.keyPath).target
							
							If ($file.exists)  // & Shift down
								
								// Test server
								If (Not:C34(Bool:C1537($form.ui.doTestServer)))
									
									$form.ui.doTestServer:=True:C214
									
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
								
								$result:=New object:C1471(\
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
							
							$result:=New object:C1471(\
								"success"; False:C215; \
								"message"; Get localized string:C991("theKeyFileIsNotAvailable")+"\r"+Get localized string:C991("clickHereToFindTheKeyFile"); \
								"action"; "localizeKeyFile"; \
								"type"; 9)
							
						End if 
						
					Else 
						
						$result:=New object:C1471(\
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
					
					$result:=New object:C1471(\
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
						
						$result:=$oSource.sendRequest()
						
					End if 
					
					If ($file.exists)
						
						// Make a call to verify
						$oSource.headers.push(New object:C1471(\
							"Authorization"; "Bearer "+$file.getText()))
						
						$result:=$oSource.status()
						
						If ($result.errors#Null:C1517)
							
							// Oops - Keep the first error message for the tips
							$result.message:=_o_SERVER_Handler(New object:C1471("action"; "localization"; "message"; String:C10($result.errors[0].message))).message
							
						End if 
						
					Else 
						
						// No key
						$result:=New object:C1471(\
							"success"; False:C215; \
							"message"; Get localized string:C991("failedToGenerateAuthorizationKey"))
						
					End if 
					
					$result.type:=0
					
				Else 
					
					$result:=New object:C1471(\
						"success"; False:C215; \
						"message"; Get localized string:C991("theWebServerIsNotStarted")+"\r"+Get localized string:C991("clickToStartIt"); \
						"action"; "startWebServer"; \
						"title"; Get localized string:C991("startWebServer"); \
						"type"; 9)
					
				End if 
			End if 
			
		Else 
			
			If ($form.ui.remote())
				
				// Verify the production server address
				$url:=String:C10(Form:C1466.server.urls.production)
				
				If (Length:C16($url)>0)
					
					$ok:=Not:C34(WEB Get server info:C1531.started)
					
					If (Not:C34($ok))
						
						$ok:=(Position:C15("127.0.0.1"; $url)=0)\
							 & (Position:C15("localhost"; $url)=0)
						
					End if 
					
					If ($ok)
						
						If (Length:C16(String:C10(Form:C1466.dataSource.keyPath))>0)
							
							//%W-533.1
							If (Form:C1466.dataSource.keyPath[[1]]="/")
								
								// Relative path
								$file:=Folder:C1567(Folder:C1567(fk database folder:K87:14; *).platformPath; fk platform path:K87:2)\
									.file(Substring:C12(Form:C1466.dataSource.keyPath; 2))
								
							Else 
								
								$file:=File:C1566(Form:C1466.dataSource.keyPath)
								
							End if 
							//%W+533.1
							
							If ($file.exists)  // & Shift down
								
								// Test server
								If (Not:C34(Bool:C1537($form.ui.doTestServer)))
									
									$form.ui.doTestServer:=True:C214
									
									CALL WORKER:C1389(EDITOR.worker; "Rest"; New object:C1471(\
										"caller"; EDITOR.window; \
										"action"; "status"; \
										"handler"; "mobileapp"; \
										"timeout"; 60; \
										"url"; $url; \
										"headers"; New object:C1471("X-MobileApp"; "1"; \
										"Authorization"; "Bearer "+$file.getText())))
									
								End if 
								
							Else 
								
								//#ACI0100687 Generate the key
								$result:=Rest(New object:C1471(\
									"action"; "request"; \
									"handler"; "mobileapp"; \
									"url"; $url))
								
								$result:=New object:C1471(\
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
								"url"; $url; \
								"headers"; New object:C1471(\
								"X-MobileApp"; "1")))
							
							$result:=New object:C1471(\
								"success"; False:C215; \
								"message"; Get localized string:C991("theKeyFileIsNotAvailable")+"\r"+Get localized string:C991("clickHereToFindTheKeyFile"); \
								"action"; "localizeKeyFile"; \
								"type"; 9)
							
						End if 
						
					Else 
						
						$result:=New object:C1471(\
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
					
					$result:=New object:C1471(\
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
					
					$url:="127.0.0.1:"+String:C10($oServer.options.webPortID)
					
					// Test the key
					$file:=Folder:C1567(fk mobileApps folder:K87:18; *).file("key.mobileapp")
					
					If (Not:C34($file.exists))
						
						// Generate the key
						$result:=Rest(New object:C1471(\
							"action"; "request"; \
							"handler"; "mobileapp"; \
							"url"; $url))
						
					End if 
					
					// Make a call to verify
					If ($file.exists)
						
						$result:=Rest(New object:C1471(\
							"action"; "request"; \
							"handler"; "mobileapp"; \
							"url"; $url; \
							"headers"; New object:C1471(\
							"X-MobileApp"; "1"; \
							"Authorization"; "Bearer "+$file.getText())))
						
						// Test REST response
						If ($result.__ERRORS#Null:C1517)
							
							// Oops - Keep the first error message for the tips
							$result.message:=_o_SERVER_Handler(New object:C1471("action"; "localization"; "message"; String:C10($result.__ERRORS[0].message))).message
							
						End if 
						
					Else 
						
						// No key
						$result:=New object:C1471(\
							"success"; False:C215; \
							"message"; Get localized string:C991("failedToGenerateAuthorizationKey"))
						
					End if 
					
					$result.type:=0
					
				Else 
					
					$result:=New object:C1471(\
						"success"; False:C215; \
						"message"; Get localized string:C991("theWebServerIsNotStarted")+"\r"+Get localized string:C991("clickToStartIt"); \
						"action"; "startWebServer"; \
						"title"; Get localized string:C991("startWebServer"); \
						"type"; 9)
					
				End if 
			End if 
		End if 
		
		$form.ui.serverStatus:=$result
		
		SET TIMER:C645(-1)
		
		//=========================================================
	: ($in.action="dataset")  // End dataset generation
		
		OB REMOVE:C1226(Form:C1466.$project; "dataSetGeneration")
		
		SET TIMER:C645(-1)
		
		CALL FORM:C1391(Current form window:C827; Formula:C1597(editor_CALLBACK).source; "update_data")
		
		If ($in.data#Null:C1517)
			
			If (Not:C34($in.data.success))
				
				If ($in.data.errors#Null:C1517)
					
					POST_MESSAGE(New object:C1471(\
						"action"; "show"; \
						"type"; "alert"; \
						"target"; $in.data.caller; \
						"additional"; $in.data.errors.join("\n")))
					
				End if 
			End if 
		End if 
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$in.action+"\"")
		
		//=========================================================
End case 