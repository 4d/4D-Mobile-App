//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_PROCESS_MESSAGES
// ID[FBCD164D418F4DC18E4AEE9871391F89]
// Created 10-1-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Management of messages addressed to the main form
// ----------------------------------------------------
// Declarations
#DECLARE($message : Text; $data : Object)

var $t; $title : Text
var $o : Object

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($message="dataSetInWorks")
		
		If (EDITOR.message.isVisible())
			
			ASSERT:C1129(False:C215)
			
		End if 
		
		//______________________________________________________
	: ($message="footer")
		
		var $offset
		$offset:=Choose:C955(Length:C16(String:C10($data.message))>0; -20; 20)  // Default is hide
		
		If ($offset<0)  // Show
			
			If (EDITOR.footer.isHidden())
				
				EDITOR.project.resizeVertically($offset)
				EDITOR.footer.show()
				
			End if 
			
		Else   // Hide
			
			If (EDITOR.footer.isVisible())
				
				EDITOR.project.resizeVertically($offset)
				EDITOR.footer.hide()
				
			End if 
		End if 
		
		EDITOR.footer.setValue($data)
		
		//______________________________________________________
	: ($message="description")  // Update UI of the TITLE subform
		
		EDITOR.updateHeader($data)
		
		//______________________________________________________
	: ($message="setURL")  // **** SEEMS TO BE OBSOLETE *****
		
		EDITOR.browser.setValue($data)
		
		//______________________________________________________
	: ($message="hideBrowser")
		
		EDITOR.browser.setSubform("EMPTY")
		EDITOR.browser.hide()
		
		//______________________________________________________
	: ($message="showBrowser")
		
		EDITOR.browser.show()
		
		//______________________________________________________
	: ($message="initBrowser")
		
		EDITOR.browser.show()
		EDITOR.browser.setSubform("BROWSER")
		EDITOR.browser.setValue($data)  //EDITOR.callMeBack("setURL"; $in)
		
		//______________________________________________________
	: ($message="projectAuditResult")
		
		//ASSERT(Not(DATABASE.isMatrix))
		
		PROJECT_Handler(New object:C1471(\
			"action"; $message; \
			"audit"; $data))
		
		//______________________________________________________
	: ($message="checkProject")  // Callback from 'structure'
		
		EDITOR.removeTask($message)  // Update task list
		
		If ($data.success)
			
			STRUCTURE_AUDIT($data.value)
			
		Else 
			
			ASSERT:C1129(False:C215)  // Display an error message ?
			
		End if 
		
		//______________________________________________________
	: ($message="getDevices")  // Callback from 'editor_GET_DEVICES'
		
		EDITOR.removeTask($message)  // Update task list
		EDITOR.devices:=$data  // Store the result
		EDITOR.ribbon.touch()
		
		//______________________________________________________
	: ($message="syncDataModel")
		
		structure_REPAIR
		
		//______________________________________________________
	: ($message="goToPage")
		
		EDITOR.goToPage($data.page)
		EDITOR.context.ribbon.page:=EDITOR.currentPage
		EDITOR.ribbon.touch()
		
		Case of 
				
				//………………………………………………………………………………
			: ($data.panel#Null:C1517)
				
				EDITOR.callMeBack("goTo"; $data)
				
				//………………………………………………………………………………
			: ($data.tab#Null:C1517)
				
				EDITOR.callMeBack("selectTab"; $data)
				
				//………………………………………………………………………………
		End case 
		
		//______________________________________________________
	: ($message="checkDevTools")  // Callback from 'editor_CHECK_INSTALLATION'
		
		// Update task list
		EDITOR.removeTask($message)
		
		If ($data#Null:C1517)  // Store the result
			
			EDITOR.studio:=$data.studio
			EDITOR.xCode:=$data.xCode
			
			If (EDITOR.devices=Null:C1517)  // First time -> Update the device list
				
				EDITOR.getDevices()
				
			End if 
		End if 
		
		//______________________________________________________
	: ($message="updateRibbon")
		
		EDITOR.teamId:=(Length:C16(String:C10(PROJECT.organization.teamId))>0)
		EDITOR.ribbon.touch()
		
		//______________________________________________________
	: ($message="build@")
		
		// build = Result of the build/archive action
		// build_stop =  Cancel build process
		OB REMOVE:C1226(EDITOR; "build")
		
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
							EDITOR.str.setText("theApplicationHasBeenSuccessfullyGenerated")\
							.localized($project.product.name))
						
					Else 
						
						DISPLAY NOTIFICATION:C910($title; \
							EDITOR.str.setText("theApplicationHasBeenSuccessfullyInstalled")\
							.localized(New collection:C1472($project.product.name; $project._device.name)))
						
					End if 
					
					//…………………………………………………………………………………………………………………………
				Else 
					
					If ($project._device.type="device")
						
						DISPLAY NOTIFICATION:C910($title; \
							EDITOR.str.setText("theApplicationHasBeenSuccessfullyInstalled")\
							.localized(New collection:C1472($project.product.name; $project._device.name)))
						
					Else 
						
						DISPLAY NOTIFICATION:C910($title; \
							EDITOR.str.setText("theApplicationHasBeenSuccessfullyGenerated")\
							.localized($project.product.name))
						
					End if 
					
					// Keep a digest of the sources
					var $file : 4D:C1709.File
					
					If ($project._buildTarget="iOS")
						
						$file:=EDITOR.path.userCache().file($project._name+".ios.fingerprint")
						
						If ($data.param.appFolder.folder("iOS/Sources").exists)
							
							$file.setText(cs:C1710.tools.new().folderDigest($data.param.appFolder.folder("iOS/Sources")))
							
						End if 
						
					Else 
						
						$file:=EDITOR.path.userCache().file($project._name+".android.fingerprint")
						
						//#MARK_TODO
						
					End if 
					
					If (Bool:C1537($data.param.create)\
						 & Not:C34(Bool:C1537($data.param.archive))\
						 & Not:C34(Bool:C1537($data.param.build))\
						 & Not:C34(Bool:C1537($data.param.run)))
						
						POST_MESSAGE(New object:C1471(\
							"target"; EDITOR.window; \
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
		BUILD(New object:C1471(\
			"caller"; EDITOR.window; \
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
		BUILD(New object:C1471(\
			"caller"; Current form window:C827; \
			"project"; PROJECT; \
			"create"; True:C214; \
			"build"; True:C214; \
			"run"; True:C214; \
			"verbose"; Bool:C1537(Form:C1466.verbose)))
		
		//______________________________________________________
	Else 
		
		// Pass to PROJECT subform
		If (Count parameters:C259>=2)
			
			EDITOR.callChild(EDITOR.project; EDITOR.callback; $message; $data)
			
		Else 
			
			EDITOR.callChild(EDITOR.project; EDITOR.callback; $message)
			
		End if 
		
		//______________________________________________________
End case 