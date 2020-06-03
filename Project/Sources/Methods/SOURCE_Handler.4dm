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

C_LONGINT:C283($Lon_formEvent;$Lon_parameters)
C_TEXT:C284($t;$Txt_format;$Txt_url)
C_OBJECT:C1216($file;$Obj_form;$Obj_in;$Obj_out;$Obj_result;$oServer)

If (False:C215)
	C_OBJECT:C1216(SOURCE_Handler ;$0)
	C_OBJECT:C1216(SOURCE_Handler ;$1)
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
	
	$Obj_form:=New object:C1471(\
		"window";Current form window:C827;\
		"ui";editor_INIT ;\
		"local";"source_local";\
		"server";"source_server";\
		"doNotGenerate";"doNotGenerate";\
		"doNotExportImages";"doNotExportImages";\
		"generate";"generate";\
		"serverStatus";"serverStatus")
	
	If (OB Is empty:C1297($Obj_form.ui))
		
		$Obj_form.ui.help:=Get localized string:C991("help_source")
		
		  // Define form methods
		$Obj_form.ui.testServer:=Formula:C1597(SOURCE_Handler (New object:C1471(\
			"action";"checkingServerConfiguration")))
		
		$Obj_form.ui.remote:=Formula:C1597(String:C10(Form:C1466.dataSource.source)="server")
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$Lon_formEvent:=_o_panel_Form_common (On Load:K2:1;On Timer:K2:25)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				  // Constraints definition
				$Obj_form.ui.constraints:=New object:C1471
				
				ui_BEST_SIZE (New object:C1471(\
					"widgets";New collection:C1472($Obj_form.generate;"dataGeneration";"dataGeneration.label");\
					"alignment";Align left:K42:2;\
					"factor";1.15))
				
				ui_BEST_SIZE (New object:C1471(\
					"widgets";New collection:C1472($Obj_form.local)))
				
				ui_BEST_SIZE (New object:C1471(\
					"widgets";New collection:C1472($Obj_form.server)))
				
				ui_BEST_SIZE (New object:C1471(\
					"widgets";New collection:C1472($Obj_form.doNotGenerate)))
				
				  // Declare check box as boolean (NO MORE NECESSARY IN JSON FORM)
				  // EXECUTE FORMULA("C_BOOLEAN:C305((OBJECT Get pointer:C1124(Object named:K67:5;\"doNotGenerate\"))->)")
				
				$Obj_form.ui.testServer()
				
				ui_SET_ENABLED ($Obj_form.generate;False:C215)
				
				OBJECT SET TITLE:C194(*;"dataGeneration.label";Replace string:C233(Get localized string:C991("dataSetGeneration");"\n\n";"\r"))
				
				  //______________________________________________________
			: ($Lon_formEvent=On Timer:K2:25)
				
				If ($Obj_form.ui.remote())
					
					(ui.pointer($Obj_form.server))->:=1
					(ui.pointer($Obj_form.local))->:=0
					
				Else 
					
					(ui.pointer($Obj_form.server))->:=0
					(ui.pointer($Obj_form.local))->:=1
					
				End if 
				
				If (Bool:C1537($Obj_form.ui.serverInTest))
					
					(OBJECT Get pointer:C1124(Object named:K67:5;"serverInTest"))->:=1
					OBJECT SET VISIBLE:C603(*;$Obj_form.serverStatus;False:C215)
					OBJECT SET VISIBLE:C603(*;"serverInTest@";True:C214)
					
					  // Disable the generate button & set tips
					ui_SET_ENABLED ($Obj_form.generate;False:C215)
					OBJECT SET HELP TIP:C1181(*;$Obj_form.generate;"")
					
				Else 
					
					(OBJECT Get pointer:C1124(Object named:K67:5;"serverInTest"))->:=0
					OBJECT SET VISIBLE:C603(*;"serverInTest@";False:C215)
					
					  // Server status [
					  // Title;picture;background;titlePos;titleVisible;iconVisible;style;horMargin;vertMargin;iconOffset;popupMenu;hyperlink;numStates
					$Txt_format:="{title};{picture};;;;;{style};{horMargin};;;;;"
					
					If (Bool:C1537($Obj_form.ui.serverStatus.success))
						
						$Txt_format:=Replace string:C233($Txt_format;"{picture}";"#images/light_on.png")
						$Txt_format:=Replace string:C233($Txt_format;"{horMargin}";"0")
						$Txt_format:=Replace string:C233($Txt_format;"{title}";" "+Get localized string:C991(Choose:C955($Obj_form.ui.remote();"serverIsOnline";"theWebServerIsRunning")))
						
						OBJECT SET HELP TIP:C1181(*;$Obj_form.serverStatus;"")
						
						ui_SET_ENABLED ($Obj_form.generate;Bool:C1537(Form:C1466.dataSource.doNotGenerateDataAtEachBuild))
						
						OBJECT SET HELP TIP:C1181(*;$Obj_form.generate;Choose:C955(Bool:C1537(Form:C1466.dataSource.doNotGenerateDataAtEachBuild);Get localized string:C991("clickToGenerateADataset");""))
						
					Else 
						
						$Txt_format:=Replace string:C233($Txt_format;"{picture}";Choose:C955(Num:C11($Obj_form.ui.serverStatus.type)=0;"#images/light_off.png";"0"))
						$Txt_format:=Replace string:C233($Txt_format;"{horMargin}";"50")
						
						If (Length:C16(String:C10($Obj_form.ui.serverStatus.title))>0)
							
							$Txt_format:=Replace string:C233($Txt_format;"{title}";" "+$Obj_form.ui.serverStatus.title)
							
						Else 
							
							  // Generic message
							$Txt_format:=Replace string:C233($Txt_format;"{title}";" "+Get localized string:C991("theServerIsNotReady"))
							
						End if 
						
						OBJECT SET HELP TIP:C1181(*;$Obj_form.serverStatus;String:C10($Obj_form.ui.serverStatus.message))
						
						  // Disable the generate button
						ui_SET_ENABLED ($Obj_form.generate;False:C215)
						
						OBJECT SET HELP TIP:C1181(*;$Obj_form.generate;Choose:C955(Bool:C1537(Form:C1466.dataSource.doNotGenerateDataAtEachBuild);Get localized string:C991("theDataSourceIsNotReady");""))
						
					End if 
					
					OBJECT SET HELP TIP:C1181(*;$Obj_form.doNotGenerate;Choose:C955(Bool:C1537(Form:C1466.dataSource.doNotGenerateDataAtEachBuild);"";Get localized string:C991("aDatasetWillBeGeneratedIfAnyAtEachBuild")))
					
					$Txt_format:=Replace string:C233($Txt_format;"{style}";String:C10($Obj_form.ui.serverStatus.type))
					OBJECT SET FORMAT:C236(*;$Obj_form.serverStatus;$Txt_format)
					
					ui_BEST_SIZE (New object:C1471(\
						"widgets";New collection:C1472($Obj_form.serverStatus);\
						"alignment";Align left:K42:2;\
						"factor";Choose:C955(Num:C11($Obj_form.ui.serverStatus.type)=0;1;1.05)))
					
					OBJECT SET RGB COLORS:C628(*;$Obj_form.serverStatus;Choose:C955(Num:C11($Obj_form.ui.serverStatus.type)#0;Foreground color:K23:1;0x00808080);Background color none:K23:10)
					
					OBJECT SET VISIBLE:C603(*;$Obj_form.serverStatus;True:C214)
					  //]
					
				End if 
				
				  //______________________________________________________
		End case 
		
		  //=========================================================
	: ($Obj_in.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215;"Missing parameter \"action\"")
		
		  //=========================================================
	: ($Obj_in.action="init")  // Return the form objects definition
		
		$0:=$Obj_form
		
		  //=========================================================
	: ($Obj_in.action="testServer")
		
		$Obj_form.ui.serverInTest:=False:C215
		
		If ($Obj_form.ui.remote())
			
			$Obj_result:=Choose:C955($Obj_in.response=Null:C1517;New object:C1471;$Obj_in.response)
			
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
					$Obj_result.message:=_o_SERVER_Handler (New object:C1471("action";"localization";"message";String:C10($Obj_result.errors[0].message))).message
					
				Else 
					
					If ($Obj_result.response=Null:C1517)\
						 & (Num:C11($Obj_result.code)=0)
						
						$Obj_result.code:=30
						
					End if 
					
					  // Use error code
					$Obj_result.message:=_o_SERVER_Handler (New object:C1471("action";"localization";"code";Num:C11($Obj_result.code))).message
					
				End if 
				
			Else 
				
				$Obj_result.type:=0
				
			End if 
			
			$Obj_form.ui.serverStatus:=$Obj_result
			
			ui.refresh()
			
		End if 
		
		  //=========================================================
	: ($Obj_in.action="checkingServerConfiguration")
		
		If (feature.with("sourceClass"))
			
			var $oSource : Object
			$oSource:=cs:C1710.source.new()
			
			If ($Obj_form.ui.remote())
				
				ASSERT:C1129(Not:C34(Shift down:C543))
				
				  // Verify the production server adress
				If (Length:C16(String:C10(Form:C1466.server.urls.production))>0)
					
					C_BOOLEAN:C305($ok)
					$ok:=Not:C34(WEB Get server info:C1531.started)
					
					If (Not:C34($ok))
						
						$ok:=(Position:C15("127.0.0.1";Form:C1466.server.urls.production)=0)\
							 & (Position:C15("localhost";Form:C1466.server.urls.production)=0)
						
					End if 
					
					If ($ok)
						
						If (Length:C16(String:C10(Form:C1466.dataSource.keyPath))>0)
							
							$t:=doc_Absolute_path (Form:C1466.dataSource.keyPath;Get 4D folder:C485(MobileApps folder:K5:47;*))
							
							If (Test path name:C476($t)#Is a document:K24:1)
								
								$t:=Convert path POSIX to system:C1107(Form:C1466.dataSource.keyPath)
								
							End if 
							
							var $file : Object
							$file:=File:C1566($t;fk platform path:K87:2)
							
							If ($file.exists)  // & Shift down
								
								  // Test server
								If (Not:C34(Bool:C1537($Obj_form.ui.serverInTest)))
									
									$Obj_form.ui.serverInTest:=True:C214
									
									CALL WORKER:C1389(Form:C1466.$worker;"Rest";New object:C1471(\
										"caller";$Obj_form.window;\
										"action";"status";\
										"handler";"mobileapp";\
										"timeout";60;\
										"url";Form:C1466.server.urls.production;\
										"headers";New object:C1471("X-MobileApp";"1";\
										"Authorization";"Bearer "+$file.getText())))
									
								End if 
								
							Else 
								
								$Obj_result:=New object:C1471(\
									"success";False:C215;\
									"title";Get localized string:C991("locateTheKey");\
									"message";Get localized string:C991("theKeyFileIsNotAvailable")+"\r"+Get localized string:C991("clickHereToFindTheKeyFile");\
									"action";"localizeKeyFile";\
									"type";9)
								
							End if 
							
						Else 
							
							CALL WORKER:C1389(Form:C1466.$worker;"Rest";New object:C1471(\
								"caller";$Obj_form.window;\
								"action";"status";\
								"handler";"mobileapp";\
								"timeout";60;\
								"url";Form:C1466.server.urls.production;\
								"headers";New object:C1471(\
								"X-MobileApp";"1")))
							
							$Obj_result:=New object:C1471(\
								"success";False:C215;\
								"message";Get localized string:C991("theKeyFileIsNotAvailable")+"\r"+Get localized string:C991("clickHereToFindTheKeyFile");\
								"action";"localizeKeyFile";\
								"type";9)
							
						End if 
						
					Else 
						
						$Obj_result:=New object:C1471(\
							"success";False:C215;\
							"title";Get localized string:C991("setTheServerUrl");\
							"message";Get localized string:C991("theProductionUrlIsNotPopulated")+"\r"+Get localized string:C991("clickToFillItIn");\
							"action";"goToProductionURL";\
							"type";9)
						
						POST_FORM_MESSAGE (New object:C1471(\
							"target";Current form window:C827;\
							"action";"show";\
							"type";"confirm";\
							"title";ui.alert+" "+Get localized string:C991("theLocalWebServerIsStarted");\
							"additional";"youNeedToShutDownTheLocalWebServer";\
							"okAction";"stopWebServer";\
							"ok";"stopTheLocalServer"))
						
					End if 
					
				Else 
					
					$Obj_result:=New object:C1471(\
						"success";False:C215;\
						"title";Get localized string:C991("setTheServerUrl");\
						"message";Get localized string:C991("theProductionUrlIsNotPopulated")+"\r"+Get localized string:C991("clickToFillItIn");\
						"action";"goToProductionURL";\
						"type";9)
					
				End if 
				
			Else 
				
				  // Test REST response
				If (WEB Get server info:C1531.started)
					
					  // Test the key
					$file:=Folder:C1567(fk mobileApps folder:K87:18).file("key.mobileapp")
					
					If (Not:C34($file.exists))
						
						$Obj_result:=$oSource.sendRequest()
						
					End if 
					
					If ($file.exists)
						
						  // Make a call to verify
						$oSource.headers.push(New object:C1471(\
							"Authorization";"Bearer "+$file.getText()))
						
						$Obj_result:=$oSource.status()
						
						If ($Obj_result.errors#Null:C1517)
							
							  // Oops - Keep the first error message for the tips
							$Obj_result.message:=_o_SERVER_Handler (New object:C1471("action";"localization";"message";String:C10($Obj_result.errors[0].message))).message
							
						End if 
						
					Else 
						
						  // No key
						$Obj_result:=New object:C1471(\
							"success";False:C215;\
							"message";Get localized string:C991("failedToGenerateAuthorizationKey"))
						
					End if 
					
					$Obj_result.type:=0
					
				Else 
					
					$Obj_result:=New object:C1471(\
						"success";False:C215;\
						"message";Get localized string:C991("theWebServerIsNotStarted")+"\r"+Get localized string:C991("clickToStartIt");\
						"action";"startWebServer";\
						"title";Get localized string:C991("startWebServer");\
						"type";9)
					
				End if 
			End if 
			
		Else 
			
			If ($Obj_form.ui.remote())
				
				ASSERT:C1129(Not:C34(Shift down:C543))
				
				  // Verify the production server adress
				If (Length:C16(String:C10(Form:C1466.server.urls.production))>0)
					
					C_BOOLEAN:C305($ok)
					$ok:=Not:C34(WEB Get server info:C1531.started)
					
					If (Not:C34($ok))
						
						$ok:=(Position:C15("127.0.0.1";Form:C1466.server.urls.production)=0)\
							 & (Position:C15("localhost";Form:C1466.server.urls.production)=0)
						
					End if 
					
					If ($ok)
						
						If (Length:C16(String:C10(Form:C1466.dataSource.keyPath))>0)
							
							$t:=doc_Absolute_path (Form:C1466.dataSource.keyPath;Get 4D folder:C485(MobileApps folder:K5:47;*))
							
							If (Test path name:C476($t)#Is a document:K24:1)
								
								$t:=Convert path POSIX to system:C1107(Form:C1466.dataSource.keyPath)
								
							End if 
							
							var $file : Object
							$file:=File:C1566($t;fk platform path:K87:2)
							
							If ($file.exists)  // & Shift down
								
								  // Test server
								If (Not:C34(Bool:C1537($Obj_form.ui.serverInTest)))
									
									$Obj_form.ui.serverInTest:=True:C214
									
									CALL WORKER:C1389(Form:C1466.$worker;"Rest";New object:C1471(\
										"caller";$Obj_form.window;\
										"action";"status";\
										"handler";"mobileapp";\
										"timeout";60;\
										"url";Form:C1466.server.urls.production;\
										"headers";New object:C1471("X-MobileApp";"1";\
										"Authorization";"Bearer "+$file.getText())))
									
								End if 
								
							Else 
								
								$Obj_result:=New object:C1471(\
									"success";False:C215;\
									"title";Get localized string:C991("locateTheKey");\
									"message";Get localized string:C991("theKeyFileIsNotAvailable")+"\r"+Get localized string:C991("clickHereToFindTheKeyFile");\
									"action";"localizeKeyFile";\
									"type";9)
								
							End if 
							
						Else 
							
							CALL WORKER:C1389(Form:C1466.$worker;"Rest";New object:C1471(\
								"caller";$Obj_form.window;\
								"action";"status";\
								"handler";"mobileapp";\
								"timeout";60;\
								"url";Form:C1466.server.urls.production;\
								"headers";New object:C1471(\
								"X-MobileApp";"1")))
							
							$Obj_result:=New object:C1471(\
								"success";False:C215;\
								"message";Get localized string:C991("theKeyFileIsNotAvailable")+"\r"+Get localized string:C991("clickHereToFindTheKeyFile");\
								"action";"localizeKeyFile";\
								"type";9)
							
						End if 
						
					Else 
						
						$Obj_result:=New object:C1471(\
							"success";False:C215;\
							"title";Get localized string:C991("setTheServerUrl");\
							"message";Get localized string:C991("theProductionUrlIsNotPopulated")+"\r"+Get localized string:C991("clickToFillItIn");\
							"action";"goToProductionURL";\
							"type";9)
						
						POST_FORM_MESSAGE (New object:C1471(\
							"target";Current form window:C827;\
							"action";"show";\
							"type";"confirm";\
							"title";ui.alert+" "+Get localized string:C991("theLocalWebServerIsStarted");\
							"additional";"youNeedToShutDownTheLocalWebServer";\
							"okAction";"stopWebServer";\
							"ok";"stopTheLocalServer"))
						
					End if 
					
				Else 
					
					$Obj_result:=New object:C1471(\
						"success";False:C215;\
						"title";Get localized string:C991("setTheServerUrl");\
						"message";Get localized string:C991("theProductionUrlIsNotPopulated")+"\r"+Get localized string:C991("clickToFillItIn");\
						"action";"goToProductionURL";\
						"type";9)
					
				End if 
				
			Else 
				
				  // Test REST response
				$oServer:=WEB Get server info:C1531
				
				If ($oServer.started)
					
					$Txt_url:="127.0.0.1:"+String:C10($oServer.options.webPortID)
					
					  // Test the key
					$file:=Folder:C1567(fk mobileApps folder:K87:18).file("key.mobileapp")
					
					If (Not:C34($file.exists))
						
						  // Generate the key
						$Obj_result:=Rest (New object:C1471(\
							"action";"request";\
							"handler";"mobileapp";\
							"url";$Txt_url))
						
					End if 
					
					  // Make a call to verify
					If ($file.exists)
						
						$Obj_result:=Rest (New object:C1471(\
							"action";"request";\
							"handler";"mobileapp";\
							"url";$Txt_url;\
							"headers";New object:C1471(\
							"X-MobileApp";"1";\
							"Authorization";"Bearer "+$file.getText())))
						
						  // Test REST response
						If ($Obj_result.__ERRORS#Null:C1517)
							
							  // Oops - Keep the first error message for the tips
							$Obj_result.message:=_o_SERVER_Handler (New object:C1471("action";"localization";"message";String:C10($Obj_result.__ERRORS[0].message))).message
							
						End if 
						
					Else 
						
						  // No key
						$Obj_result:=New object:C1471(\
							"success";False:C215;\
							"message";Get localized string:C991("failedToGenerateAuthorizationKey"))
						
					End if 
					
					$Obj_result.type:=0
					
				Else 
					
					$Obj_result:=New object:C1471(\
						"success";False:C215;\
						"message";Get localized string:C991("theWebServerIsNotStarted")+"\r"+Get localized string:C991("clickToStartIt");\
						"action";"startWebServer";\
						"title";Get localized string:C991("startWebServer");\
						"type";9)
					
				End if 
				
			End if   // A "If" statement should never omit "Else"
			
		End if 
		
		$Obj_form.ui.serverStatus:=$Obj_result
		
		ui.refresh()
		
		  //=========================================================
	: ($Obj_in.action="dataset")  // End dataset generation
		
		(OBJECT Get pointer:C1124(Object named:K67:5;"dataGeneration"))->:=0
		OBJECT SET VISIBLE:C603(*;"dataGeneration@";False:C215)
		
		CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"update_data")
		
		  //=========================================================
		
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_in.action+"\"")
		
		  //=========================================================
End case 

  // ----------------------------------------------------
  // Return
  //$0:=$Obj_out

  // ----------------------------------------------------
  // End