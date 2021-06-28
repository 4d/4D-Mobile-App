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
	: ($message="footer")
		
		var $offset
		$offset:=Choose:C955(Length:C16(String:C10($data.message))>0; -20; 20)  // Show/Hide
		EDITOR.project.resizeVertically($offset)
		EDITOR.footer.show($offset<0)
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
		
		If (FEATURE.with("android"))  //🚧
			
			//
			
		Else 
			
			PROJECT_Handler(New object:C1471(\
				"action"; $message; \
				"audit"; $data))
			
		End if 
		
		//______________________________________________________
	: ($message="checkProject")  // Callback from 'structure'
		
		EDITOR.removeTask($message)  // Update task list
		
		If ($data.success)
			
			STRUCTURE_AUDIT($data.value)
			
		Else 
			
			ASSERT:C1129(False:C215)
			
			// Display an error message ?
			
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
		
		If ($message="build")
			
			$title:=Get localized string:C991(Choose:C955($data.param.project._buildTarget="ios"; "4dForIos"; "4dForAndroid"))
			
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
						
						DISPLAY NOTIFICATION:C910($title; EDITOR.str.setText("theApplicationHasBeenSuccessfullyGenerated").localized($data.param.project.product.name))
						
					Else 
						
						DISPLAY NOTIFICATION:C910($title; EDITOR.str.setText("theApplicationHasBeenSuccessfullyInstalled").localized(New collection:C1472($data.param.project.product.name; $data.param.project._device.name)))
						
					End if 
					
					//…………………………………………………………………………………………………………………………
				Else 
					
					DISPLAY NOTIFICATION:C910($title; EDITOR.str.setText("theApplicationHasBeenSuccessfullyGenerated").localized($data.param.project.product.name))
					
					// Keep a digest of the sources
					var $file : 4D:C1709.File
					
					If ($data.param.project._buildTarget="iOS")
						
						$file:=EDITOR.path.userCache().file($data.param.project._name+".ios.fingerprint")
						
						If ($data.param.appFolder.folder("iOS/Sources").exists)
							
							$file.setText(cs:C1710.tools.new().folderDigest($data.param.appFolder.folder("iOS/Sources")))
							
						End if 
						
					Else 
						
						$file:=EDITOR.path.userCache().file($data.param.project._name+".android.fingerprint")
						
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
		
		// Get the project
		$o:=(OBJECT Get pointer:C1124(Object named:K67:5; "project"))->
		
		// Set the temporary authorization
		$o.$_ignoreServerStructureAdjustement:=True:C214
		
		// Relaunch the build process
		BUILD(New object:C1471(\
			"caller"; EDITOR.window; \
			"project"; $o; \
			"create"; True:C214; \
			"build"; True:C214; \
			"run"; True:C214; \
			"verbose"; Bool:C1537(Form:C1466.verbose)))
		
		//______________________________________________________
	: ($message="allowStructureModification")
		
		// Get the project
		$o:=(OBJECT Get pointer:C1124(Object named:K67:5; "project"))->pr
		
		// Set the temporary authorization
		$o.$_allowStructureAdjustments:=True:C214
		
		If (Bool:C1537($data.value))  // Remember my choice
			
			// Set the option & save
			$o.allowStructureAdjustments:=Bool:C1537($data.value)
			PROJECT.save()
			
		End if 
		
		// Relaunch the build process
		BUILD(New object:C1471(\
			"caller"; Current form window:C827; \
			"project"; $o; \
			"create"; True:C214; \
			"build"; True:C214; \
			"run"; True:C214; \
			"verbose"; Bool:C1537(Form:C1466.verbose)))
		
		//______________________________________________________
	Else 
		
		// Pass to PROJECT subform
		EDITOR.callChild(EDITOR.project; EDITOR.callback; $message; $data)
		
		//______________________________________________________
End case 