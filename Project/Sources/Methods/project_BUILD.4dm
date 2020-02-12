//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : project_BUILD
  // ID[7568C2BF25664764BE3D8F3E0B9EAEB0]
  // Created 4-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // common initializations and confirmations
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_BOOLEAN:C305($b;$Boo_OK)
C_LONGINT:C283($l;$Lon_parameters;$Win_target)
C_TEXT:C284($Dir_tgt;$t;$tt)
C_OBJECT:C1216($o;$Obj_cancel;$Obj_in;$Obj_ok;$Obj_project)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(project_BUILD ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	ob_MERGE ($Obj_in;project_Defaults )
	
	$Obj_project:=$Obj_in.project
	
	$Win_target:=Current form window:C827
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Asserted:C1132($Obj_project#Null:C1517))
	
	If (project_Check_param ($Obj_in).success)
		
		  //#99788 ========================================================
		EXECUTE METHOD IN SUBFORM:C1085("project";"views_Handler";*;New object:C1471(\
			"action";"updateForms"))  //=====================================
		
		$Obj_project.organization.identifier:=$Obj_project.organization.id+"."+str ($Obj_project.product.name).uperCamelCase()
		$Obj_project.product.bundleIdentifier:=formatString ("bundleApp";$Obj_project.organization.id+"."+$Obj_project.product.name)
		
		$Dir_tgt:=COMPONENT_Pathname ("products").folder($Obj_project.product.name).platformPath
		
		$Obj_in.path:=$Dir_tgt
		
		$Boo_OK:=Not:C34($Obj_in.create)
		
		If (Not:C34($Boo_OK))
			
			$Boo_OK:=(Test path name:C476($Dir_tgt+"Sources"+Folder separator:K24:12)=-43)
			
			If (Not:C34($Boo_OK))
				
				  // Check if the project was modified by another application
				  // Compare to the signature of the sources folder
				$o:=env_userPathname ("cache";$Obj_project.$project.product)
				
				If ($o.exists)
					
					$Boo_OK:=(doc_folderDigest ($Dir_tgt+"Sources"+Folder separator:K24:12)=$o.getText())
					
				End if 
			End if 
		End if 
		
		If (Not:C34($Boo_OK))
			
			  // Product folder already exist. user MUST CONFIRM
			$Obj_ok:=New object:C1471(\
				"action";"build_deleteProductFolder";\
				"build";$Obj_in)
			
			POST_FORM_MESSAGE (New object:C1471(\
				"target";$Win_target;\
				"action";"show";\
				"type";"confirm";\
				"title";"theProductFolderAlreadyExist";\
				"additional";"allContentWillBeReplaced";\
				"okAction";JSON Stringify:C1217($Obj_ok);\
				"cancelFormula";Formula:C1597(CALL FORM:C1391($Win_target;"editor_CALLBACK";"build_stop"))))
			
		Else 
			
			  //If ($Obj_in.create)
			  //  // Must also close and delete folders if no change and want to recreate.
			  // Xcode (New object(\
																																																				"action";"safeDelete";\
																																																				"path";$Obj_in.path))
			  // End if
			
		End if 
		
		If ($Boo_OK)
			
			  // Verify the structure
			$c:=New collection:C1472
			
			If (feature.with("newDataModel"))
				
				For each ($t;$Obj_project.dataModel)
					
					$c.push($Obj_project.dataModel[$t][""].name)
					
					For each ($tt;$Obj_project.dataModel[$t])
						
						If (Length:C16($tt)>0)
							
							If ($Obj_project.dataModel[$t][$tt].relatedDataClass#Null:C1517)
								
								$c.push($Obj_project.dataModel[$t][$tt].relatedDataClass)
								
							End if 
						End if 
					End for each 
				End for each 
				
			Else 
				
				For each ($t;$Obj_project.dataModel)
					
					$c.push($Obj_project.dataModel[$t].name)
					
					For each ($tt;$Obj_project.dataModel[$t])
						
						If (Value type:C1509($Obj_project.dataModel[$t][$tt])=Is object:K8:27)
							
							If ($Obj_project.dataModel[$t][$tt].relatedDataClass#Null:C1517)
								
								$c.push($Obj_project.dataModel[$t][$tt].relatedDataClass)
								
							End if 
						End if 
					End for each 
				End for each 
			End if 
			
			If ($Obj_project.dataSource.source="local")
				
				  // Check host-database structure
				If (Not:C34(structure (New object:C1471(\
					"action";"verify";\
					"tables";$c)).success))
					
					$Boo_OK:=(Bool:C1537($Obj_project.allowStructureAdjustments))\
						 | (Bool:C1537($Obj_project.$_allowStructureAdjustments))
					
					If ($Boo_OK)
						
						$Boo_OK:=structure (New object:C1471(\
							"action";"create";\
							"tables";$c)).success
						
						If (Not:C34($Boo_OK))
							
							  //#MARK_TODO - DISPLAY ERROR
							
						End if 
						
					Else 
						
						POST_FORM_MESSAGE (New object:C1471(\
							"target";$Win_target;\
							"action";"show";\
							"type";"confirm";\
							"title";"someStructuralAdjustmentsAreNeeded";\
							"additional";str .setText("doYouAllow4dMobileToModifyStructure").localized("4dProductName");\
							"option";New object:C1471("title";"rememberMyChoice";"value";False:C215);\
							"ok";"allow";\
							"cancelFormula";Formula:C1597(CALL FORM:C1391($Win_target;"editor_CALLBACK";"build_stop"));\
							"okFormula";Formula:C1597(CALL FORM:C1391($Win_target;"editor_CALLBACK";"allowStructureModification";Form:C1466.option))))
						
					End if 
				End if 
				
				If ($Boo_OK)
					
					  // Local web server is mandatory only if data are embedded
					For each ($t;$Obj_project.dataModel) Until ($b)
						If (feature.with("newDataModel"))
							$b:=Bool:C1537($Obj_project.dataModel[$t][""].embedded)
						Else 
							$b:=Bool:C1537($Obj_project.dataModel[$t].embedded)
						End if 
						
					End for each 
					
					$Boo_OK:=Not:C34($b)
					
					If (Not:C34($Boo_OK))
						
						$Boo_OK:=WEB Is server running:C1313 | Bool:C1537($Obj_in.ignoreServer)
						
						If (Not:C34($Boo_OK))
							
							$Obj_ok:=New object:C1471(\
								"action";"build_startWebServer";\
								"build";$Obj_in)
							
							$Obj_cancel:=New object:C1471(\
								"action";"build_ignoreServer";\
								"build";$Obj_in)
							
							  // Web server must running to test data synchronization
							POST_FORM_MESSAGE (New object:C1471(\
								"target";$Win_target;\
								"action";"show";\
								"type";"confirm";\
								"title";"theWebServerIsNotStarted";\
								"additional";"DoYouWantToStartTheWebServer";\
								"okAction";JSON Stringify:C1217($Obj_ok);\
								"cancel";"notNow";\
								"cancelAction";JSON Stringify:C1217($Obj_cancel)))
							
						End if 
					End if 
				End if 
				
			Else 
				
				  // Check server-database structure, if any
				$o:=Rest (New object:C1471(\
					"action";"tables";\
					"handler";"mobileapp";\
					"url";String:C10($Obj_project.server.urls.production);\
					"headers";New object:C1471(\
					"X-MobileApp";"1";\
					"Authorization";"Bearer "+COMPONENT_Pathname ("key").getText())))
				
				$Boo_OK:=$o.success
				
				If ($o.success)
					
					$o:=$o.response
					
					$Boo_OK:=($o.dataClasses.extract("name").indexOf(String:C10(shared.deletedRecordsTable.name))#-1)
					
					If ($Boo_OK)
						
						For each ($t;$c) While ($Boo_OK)
							
							$l:=$o.dataClasses.extract("name").indexOf($t)
							
							$Boo_OK:=($l#-1)
							
							If ($Boo_OK)
								
								$Boo_OK:=($o.dataClasses[$l].attributes.extract("name").indexOf(String:C10(shared.stampField.name))#-1)
								
							End if 
						End for each 
					End if 
					
					If (Not:C34($Boo_OK))
						
						  // SERVER STRUCTURE IS NOT OK. Confirm if data embed, Alert else
						For each ($t;$Obj_project.dataModel) Until ($b)
							
							If (feature.with("newDataModel"))
								$b:=Bool:C1537($Obj_project.dataModel[$t][""].embedded)
							Else 
								$b:=Bool:C1537($Obj_project.dataModel[$t].embedded)
							End if 
							
						End for each 
						
						$Boo_OK:=Not:C34($b)
						
						If (Not:C34($Boo_OK))
							
							$Boo_OK:=(Bool:C1537($Obj_project.$_ignoreServerStructureAdjustement))
							OB REMOVE:C1226($Obj_project;"$_ignoreServerStructureAdjustement")
							
						End if 
						
						If (Not:C34($Boo_OK))
							
							If (True:C214)
								
								POST_FORM_MESSAGE (New object:C1471(\
									"target";$Win_target;\
									"action";"show";\
									"type";"confirm";\
									"title";"theStructureOfTheProductionServerIsNotOptimizedForThisProject";\
									"additional";"youMustUpdateTheStructureOfTheProductionServer";\
									"help";Formula:C1597(OPEN URL:C673(Get localized string:C991("doc_structureAdjustment");*));\
									"cancelFormula";Formula:C1597(CALL FORM:C1391($Win_target;"editor_CALLBACK";"build_stop"));\
									"ok";Get localized string:C991("continue");\
									"okFormula";Formula:C1597(CALL FORM:C1391($Win_target;"editor_CALLBACK";"ignoreServerStructureAdjustement"))))
								
							Else 
								
								$o:=New object:C1471(\
									"target";$Win_target;\
									"action";"show";\
									"type";"confirm";\
									"title";"theStructureOfTheProductionServerIsNotOptimizedForThisProject";\
									"additional";"youMustUpdateTheStructureOfTheProductionServer";\
									"help";Formula:C1597(OPEN URL:C673(Get localized string:C991("doc_structureAdjustment");*));\
									"cancelFormula";Formula:C1597(This:C1470.choice:="cancel");\
									"ok";Get localized string:C991("continue");\
									"okFormula";Formula:C1597(This:C1470.choice:="ignore"))
								
								WAIT_FORM_MESSAGE ($o)
								
							End if 
						End if 
					End if 
					
				Else 
					
					  // SERVER NOT REACHABLE - Ignore if no data embed, Confirm else
					For each ($t;$Obj_project.dataModel) Until ($b)
						
						If (feature.with("newDataModel"))
							$b:=Bool:C1537($Obj_project.dataModel[$t][""].embedded)
						Else 
							$b:=Bool:C1537($Obj_project.dataModel[$t].embedded)
						End if 
						
					End for each 
					
					$Boo_OK:=Not:C34($b)
					
					If (Not:C34($Boo_OK))
						
						POST_FORM_MESSAGE (New object:C1471(\
							"target";$Win_target;\
							"action";"show";\
							"type";"alert";\
							"title";"theProductionServerIsNotAvailable";\
							"additional";SERVER_Handler (New object:C1471(\
							"action";"localization";\
							"code";$o.httpError)).message))
						
					End if 
				End if 
			End if 
		End if 
		
		If ($Boo_OK)
			
			If (Bool:C1537($Obj_in.archive))
				
				$Boo_OK:=Bool:C1537($Obj_in.manualInstallation)
				
				If (Not:C34($Boo_OK))
					
					If (Not:C34(Bool:C1537($Obj_in.configurator)))
						
						  // Verify that Apple Configurator 2 application is installed
						$Obj_in.configurator:=device (New object:C1471("action";"appPath")).success
						
					End if 
					
					$Boo_OK:=Bool:C1537($Obj_in.configurator)
					
					If ($Boo_OK)
						
						  // Verify that at least one device is plugged
						$Boo_OK:=device (New object:C1471("action";"plugged")).success
						
						If (Not:C34($Boo_OK))
							
							  // Ask for a device
							$Obj_ok:=New object:C1471(\
								"action";"build_deviceOnline";\
								"build";$Obj_in)
							
							$Obj_cancel:=New object:C1471(\
								"action";"build_manualInstallation";\
								"build";$Obj_in)
							
							POST_FORM_MESSAGE (New object:C1471(\
								"target";$Win_target;\
								"action";"show";\
								"type";"confirm";\
								"title";Get localized string:C991("noDeviceFound");\
								"additional";Get localized string:C991("makeSureThatADeviceIsConnected");\
								"ok";Get localized string:C991("continue");\
								"okAction";JSON Stringify:C1217($Obj_ok);\
								"cancel";Get localized string:C991("manualInstallation");\
								"cancelAction";JSON Stringify:C1217($Obj_cancel)))
							
						End if 
						
					Else 
						
						  // Ask for installation
						$Obj_ok:=New object:C1471(\
							"action";"build_waitingForConfigurator";\
							"build";$Obj_in)
						
						$Obj_cancel:=New object:C1471(\
							"action";"build_manualInstallation";\
							"build";$Obj_in)
						
						$t:=device (New object:C1471("action";"appName")).value
						
						POST_FORM_MESSAGE (New object:C1471(\
							"target";$Win_target;\
							"action";"show";\
							"type";"confirm";\
							"title";New collection:C1472("appIsNotInstalled";$t);\
							"additional";New collection:C1472("wouldYouLikeToInstallFromTheAppStoreNow";$t);\
							"okAction";JSON Stringify:C1217($Obj_ok);\
							"cancel";Get localized string:C991("manualInstallation");\
							"cancelAction";JSON Stringify:C1217($Obj_cancel)))
						
					End if 
				End if 
			End if 
		End if 
		
		If ($Boo_OK)
			
			CALL WORKER:C1389("4D Mobile ("+String:C10($Obj_in.caller)+")";"mobile_Project";$Obj_in)
			
		End if 
	End if 
	
	OB REMOVE:C1226(Form:C1466;"build")
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End