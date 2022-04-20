//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_PROCESS_MESSAGES
// ID[FBCD164D418F4DC18E4AEE9871391F89]
// Created 10-1-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Management of messages addressed to the main form
// ----------------------------------------------------
#DECLARE($message : Text; $data : Object)

var $t; $title : Text
var $o : Object

// ----------------------------------------------------
Case of 
		
		// MARK:-Steps of data generation
	: ($message="dump")  // Cancellable data generation
		
		$o:=UI.message.getValue()
		
		Case of 
				
				//======================================
			: ($data.step="catalog")
				
				$o.additional:=UI.str.localize("dataCatalog"; $data.table.name)
				UI.message.setValue($o)
				
				//======================================
			: ($data.step="table")
				
				If (UI.message.visible)
					
					If ($data.page=Null:C1517)
						
						$o.additional:=UI.str.localize("dataRequest"; $data.table.name)
						
					Else 
						
						$o.additional:=UI.str.localize("dataRequest"; $data.table.name)+" ("+String:C10($data.page)+"/"+String:C10($data.pages)+")"
						$o.additional:=$o.additional+"\r\r"+UI.str.localize("dataConsiderToSetAFilter")
						
					End if 
					
					UI.message.setValue($o)
					
				End if 
				
				//======================================
			: ($data.step="pictures")
				
				// TODO: Change field.id to field.fieldNumber ?
				If ($data.id=Null:C1517)
					
					$o.additional:=UI.str.localize("imageGeneration"; $data.table.name)
					
				Else 
					
					$o.additional:=UI.str.localize("imageGeneration"; $data.table.name)+" ("+$data.id+")"
					
				End if 
				
				UI.message.setValue($o)
				
				//======================================
			: ($data.step="asset")
				
				If (UI.message.visible)
					
					If ($data.page=Null:C1517)
						
						$o.additional:=UI.str.localize("dataCoreDataInjection"; $data.table.name)
						
					Else 
						
						$o.additional:=UI.str.localize("dataCoreDataInjection"; $data.table.name)+" ("+String:C10($data.page)+"/"+String:C10($data.pages)+")"
						$o.additional:=$o.additional+"\r\r"+UI.str.localize("dataConsiderToSetAFilter"; String:C10(SHARED.data.dump.limit))
						
					End if 
					
					UI.message.setValue($o)
					
				End if 
				
				//======================================
			: ($data.step="end")
				
				If (Storage:C1525.flags#Null:C1517)
					
					Use (Storage:C1525.flags)
						
						OB REMOVE:C1226(Storage:C1525.flags; "stopGeneration")
						
					End use 
				End if 
				
				DO_MESSAGE(New object:C1471(\
					"action"; "close"))
				
				//======================================
			Else 
				
				If (UI.message.visible)
					
					$o.additional:=UI.str.localize($data.step)
					UI.message.setValue($o)
					
				End if 
				
				//======================================
		End case 
		
		// MARK:-UPDATE_EXPOSED_CATALOG callback
	: ($message="checkProject")
		
		// Update task list
		UI.removeTask($message)
		
		// Keep the result
		Form:C1466.ExposedStructure:=$data
		
		If ($data.success)
			
			// Perform the structure audit
			STRUCTURE_AUDIT($data)
			
		Else 
			
			// TODO: Display an error message ?
			ASSERT:C1129(False:C215)
			
		End if 
		
		
		// MARK:-CHECK_INSTALLATION callback
	: ($message="checkDevTools")
		
		// Update task list
		UI.removeTask($message)
		
		If ($data#Null:C1517)  // Store the result
			
			UI.studio:=$data.studio
			UI.xCode:=$data.xCode
			
			If (UI.devices=Null:C1517)  // First time -> Update the device list
				
				UI.getDevices()
				
			End if 
		End if 
		
		// MARK:-GET_DEVICES callback
	: ($message="getDevices")
		
		// Update task list
		UI.removeTask($message)
		
		// Keep the result
		UI.devices:=$data
		
		// Update UI
		UI.ribbon.touch()
		
		// MARK:-[UI]
		
		// MARK:Show/Hide Footer
	: ($message="footer")
		
		var $offset
		$offset:=Choose:C955(Length:C16(String:C10($data.message))>0; -20; 20)  // Default is hide
		
		If ($offset<0)  // Show
			
			If (UI.footer.hidden)
				
				UI.project.resizeVertically($offset)
				UI.footer.show()
				
			End if 
			
		Else   // Hide
			
			If (UI.footer.visible)
				
				UI.project.resizeVertically($offset)
				UI.footer.hide()
				
			End if 
		End if 
		
		UI.footer.setValue($data)
		
		// MARK:Update TITLE subform
	: ($message="description")
		
		UI.updateHeader($data)
		
		// MARK:Update RIBBON subform
	: ($message="updateRibbon")
		
		UI.teamId:=(Length:C16(String:C10(PROJECT.organization.teamId))>0)
		UI.ribbon.touch()
		
		// MARK:-BROWSER
	: ($message="hideBrowser")
		
		UI.browser.setSubform("EMPTY")
		UI.browser.hide()
		
		//______________________________________________________
	: ($message="showBrowser")
		
		UI.browser.show()
		
		//______________________________________________________
	: ($message="initBrowser")
		
		UI.browser.show()
		UI.browser.setSubform("BROWSER")
		UI.browser.setValue($data)
		
		// MARK:-
		
		//______________________________________________________
	: ($message="projectAuditResult")
		
		PROJECT_Handler(New object:C1471(\
			"action"; $message; \
			"audit"; $data))
		
		//______________________________________________________
	: ($message="syncDataModel")
		
		structure_REPAIR
		
		//______________________________________________________
	: ($message="goToPage")
		
		UI.goToPage($data.page)
		UI.context.ribbon.page:=UI.currentPage
		UI.ribbon.touch()
		
		Case of 
				
				//………………………………………………………………………………
			: ($data.panel#Null:C1517)
				
				UI.callMeBack("goTo"; $data)
				
				//………………………………………………………………………………
			: ($data.tab#Null:C1517)
				
				UI.callMeBack("selectTab"; $data)
				
				//………………………………………………………………………………
		End case 
		
		//______________________________________________________
	: ($message="build@")
		
		// Build = Result of the build/archive action
		// Build_stop =  Cancel build process
		OB REMOVE:C1226(UI; "build")
		
		// Remove the temporary authorizations, if any
		For each ($t; PROJECT)
			
			If ($t="$_@")
				
				OB REMOVE:C1226(PROJECT; $t)
				
			End if 
		End for each 
		
		var $project : Object
		$project:=$data.param.project
		
		If ($message="build")
			
			$title:=Get localized string:C991(Choose:C955($project._buildTarget="ios"; "4dForIos"; "4dForAndroid"))
			
			Case of 
					
					//…………………………………………………………………………………………………………………………
				: (Not:C34($data.success))
					
					// Could show the issue
					If (Not:C34(Is compiled mode:C492))
						
						// ALERT(JSON Stringify($Obj_callback;*))  // Need to test
						
					End if 
					
					//…………………………………………………………………………………………………………………………
				: (Bool:C1537($data.param.archive))
					
					If (Bool:C1537($data.param.manualInstallation))
						
						DISPLAY NOTIFICATION:C910($title; \
							UI.str.setText("theApplicationHasBeenSuccessfullyGenerated")\
							.localized($project.product.name))
						
					Else 
						
						DISPLAY NOTIFICATION:C910($title; \
							UI.str.setText("theApplicationHasBeenSuccessfullyInstalled")\
							.localized(New collection:C1472($project.product.name; $project._device.name)))
						
					End if 
					
					//…………………………………………………………………………………………………………………………
				Else 
					
					If ($project._device.type="device")
						
						DISPLAY NOTIFICATION:C910($title; \
							UI.str.setText("theApplicationHasBeenSuccessfullyInstalled")\
							.localized(New collection:C1472($project.product.name; $project._device.name)))
						
					Else 
						
						DISPLAY NOTIFICATION:C910($title; \
							UI.str.setText("theApplicationHasBeenSuccessfullyGenerated")\
							.localized($project.product.name))
						
					End if 
					
					// Keep a digest of the sources
					var $file : 4D:C1709.File
					
					If ($project._buildTarget="iOS")
						
						$file:=UI.path.userCache().file($project._name+".ios.fingerprint")
						
						If ($data.param.appFolder.folder("iOS/Sources").exists)
							
							$file.setText(cs:C1710.tools.new().folderDigest($data.param.appFolder.folder("iOS/Sources")))
							
						End if 
						
					Else 
						
						$file:=UI.path.userCache().file($project._name+".android.fingerprint")
						
						// TODO: Android fingerprint
						
					End if 
					
					If (Bool:C1537($data.param.create)\
						 & Not:C34(Bool:C1537($data.param.archive))\
						 & Not:C34(Bool:C1537($data.param.build))\
						 & Not:C34(Bool:C1537($data.param.run)))
						
						UI.postMessage(New object:C1471(\
							"action"; "show"; \
							"type"; "confirm"; \
							"title"; "projectCreationSuccessful"; \
							"additional"; "wouldYouLikeToRevealInFinder"; \
							"okFormula"; Formula:C1597(SHOW ON DISK:C922(String:C10($data.param.path)))))
						
					End if 
					
					//…………………………………………………………………………………………………………………………
			End case 
		End if 
		
		//______________________________________________________
	: ($message="ignoreServerStructureAdjustement")
		
		PROJECT.$_ignoreServerStructureAdjustement:=True:C214
		
		// Relaunch the build process
		UI.runBuild(New object:C1471(\
			"project"; PROJECT; \
			"create"; True:C214; \
			"build"; True:C214; \
			"run"; True:C214; \
			"verbose"; Bool:C1537(Form:C1466.verbose)))
		
		//______________________________________________________
	: ($message="allowStructureModification")
		
		PROJECT.$_allowStructureAdjustments:=True:C214
		
		If (Bool:C1537($data.value))  // Remember my choice
			
			// Set the option & save
			PROJECT.allowStructureAdjustments:=True:C214
			PROJECT.save()
			
		End if 
		
		// Relaunch the build process
		UI.runBuild(New object:C1471(\
			"project"; PROJECT; \
			"create"; True:C214; \
			"build"; True:C214; \
			"run"; True:C214; \
			"verbose"; Bool:C1537(Form:C1466.verbose)))
		//______________________________________________________
	Else 
		
		// Pass to PROJECT subform
		If (Count parameters:C259>=2)
			
			UI.callChild(UI.project; UI.callback; $message; $data)
			
		Else 
			
			UI.callChild(UI.project; UI.callback; $message)
			
		End if 
		
		//______________________________________________________
End case 