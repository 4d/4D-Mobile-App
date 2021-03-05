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
#DECLARE($message : Text; $form : Object; $in : Object)

var $t; $title : Text
var $o : Object

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($message="description")  // Update UI of the TITLE subform
		
		EXECUTE METHOD IN SUBFORM:C1085("description"; "editor_description"; *; $in)
		
		//______________________________________________________
	: ($message="setURL")
		
		//record.log("--> setURL")
		(OBJECT Get pointer:C1124(Object named:K67:5; "browser"))->:=$in
		
		//______________________________________________________
	: ($message="hideBrowser")
		
		//record.log("--> hideBrowser")
		OBJECT SET SUBFORM:C1138(*; "browser"; "EMPTY")
		OBJECT SET VISIBLE:C603(*; "browser"; False:C215)
		
		//______________________________________________________
	: ($message="showBrowser")
		
		//record.log("--> showBrowser")
		OBJECT SET VISIBLE:C603(*; "browser"; True:C214)
		
		//______________________________________________________
	: ($message="initBrowser")
		
		//record.log("--> initBrowser")
		OBJECT SET VISIBLE:C603(*; "browser"; True:C214)
		OBJECT SET SUBFORM:C1138(*; "browser"; "BROWSER")
		
		CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "setURL"; $in)
		
		//______________________________________________________
	: ($message="projectAuditResult")
		
		PROJECT_Handler(New object:C1471(\
			"action"; $message; \
			"audit"; $in))
		
		//______________________________________________________
	: ($message="structureCheckingResult")  // Callback from 'structure'
		
		If ($in.success)
			
			STRUCTURE_AUDIT($in.value)
			
		Else 
			
			ASSERT:C1129(False:C215)
			
			// Display an error message ?
			
		End if 
		
		//______________________________________________________
	: ($message="simulator")
		
		If (FEATURE.with("android"))  //🚧
			
			Form:C1466.$dialog[$form.editor].ribbon.devices:=$in
			
			// Touch
			OBJECT SET VALUE:C1742($form.ribbon; OBJECT Get value:C1743($form.ribbon))
			
		Else 
			
			If ($in.success)
				
				Form:C1466.$dialog[$form.editor].ribbon.devices:=$in.devices
				
				// Touch the ribbon subform
				(OBJECT Get pointer:C1124(Object named:K67:5; $form.ribbon))->:=Form:C1466.$dialog[$form.editor].ribbon
				
			Else 
				
/*
								DO_MESSAGE(New object(\
										"action"; "show"; \
										"type"; "alert"; \
										"title"; "noDevices"; \
										"additional"; ""))
*/
				
			End if 
		End if 
		
		//______________________________________________________
	: ($message="syncDataModel")
		
		structure_REPAIR
		
		//______________________________________________________
	: ($message="goToPage")
		
		Form:C1466.$dialog.EDITOR.pages.gotoPage($in.page)
		
		Form:C1466.$dialog[$form.editor].ribbon.page:=Form:C1466.$currentPage
		
		// Touch the ribbon subform
		(OBJECT Get pointer:C1124(Object named:K67:5; "ribbon"))->:=Form:C1466.$dialog[$form.editor].ribbon
		
		Case of 
				
				//………………………………………………………………………………
			: ($in.panel#Null:C1517)
				
				CALL FORM:C1391($form.window; $form.callback; "goTo"; $in)
				
				//………………………………………………………………………………
			: ($in.tab#Null:C1517)
				
				CALL FORM:C1391($form.window; $form.callback; "selectTab"; $in)
				
				//………………………………………………………………………………
		End case 
		
		//______________________________________________________
	: ($message="checkInstall")
		
		If (FEATURE.with("android"))  //🚧
			
			// Store the result
			Form:C1466.$xCode:=$in.xCode
			Form:C1466.$studio:=$in.studio
			
			Form:C1466.$status.xCode:=$in.xCode.ready
			Form:C1466.$status.studio:=$in.studio.ready
			
		Else 
			
			// Store the result
			Form:C1466.xCode:=$in
			
			If (Form:C1466.status=Null:C1517)
				
				Form:C1466.status:=New object:C1471(\
					"xCode"; $in.ready)
				
			Else 
				
				Form:C1466.status.xCode:=$in.ready
				
			End if 
		End if 
		
		editor_CALLBACK("updateRibbon")
		
		//______________________________________________________
	: ($message="updateRibbon")
		
		If (FEATURE.with("android"))  //🚧
			
			Form:C1466.$status.teamId:=(Length:C16(String:C10(PROJECT.organization.teamId))>0)
			
		Else 
			
			// Old
			Form:C1466.status.teamId:=(Length:C16(String:C10(PROJECT.organization.teamId))>0)
			
		End if 
		
		// Give status to ribbon
		$o:=OBJECT Get value:C1743($form.ribbon)
		$o.status:=Form:C1466.$status
		
		// Touch
		OBJECT SET VALUE:C1742($form.ribbon; $o)
		
		//______________________________________________________
	: ($message="build@")
		
		// build = Result of the build/archive action
		// build_stop =  Cancel build process
		OB REMOVE:C1226(Form:C1466; "build")
		
		// Remove the temporary authorizations, if any
		$o:=(OBJECT Get pointer:C1124(Object named:K67:5; "project"))->
		
		For each ($t; $o)
			
			If ($t="$_@")
				
				OB REMOVE:C1226($o; $t)
				
			End if 
		End for each 
		
		If ($message="build")
			
			$title:=Get localized string:C991(Choose:C955($in.param.project._buildTarget="ios"; "4dForIos"; "4dForAndroid"))
			
			Case of 
					
					//…………………………………………………………………………………………………………………………
				: (Not:C34($in.success))
					
					// Could show the issue
					If (Not:C34(Is compiled mode:C492))
						
						// ALERT(JSON Stringify($Obj_callback;*))  // Need to test
						
					End if 
					
					//…………………………………………………………………………………………………………………………
				: (Bool:C1537($in.param.archive))
					
					If (Bool:C1537($in.param.manualInstallation))
						
						DISPLAY NOTIFICATION:C910($title; cs:C1710.str.new("theApplicationHasBeenSuccessfullyGenerated").localized($in.param.project.product.name))
						
					Else 
						
						DISPLAY NOTIFICATION:C910($title; cs:C1710.str.new("theApplicationHasBeenSuccessfullyInstalled").localized($in.param.project.product.name))
						
					End if 
					
					//…………………………………………………………………………………………………………………………
				Else 
					
					DISPLAY NOTIFICATION:C910($title; cs:C1710.str.new("theApplicationHasBeenSuccessfullyGenerated").localized($in.param.project.product.name))
					
					var $file : 4D:C1709.File
					
					If ($in.param.project._buildTarget="iOS")
						
						$file:=ENV.caches("com.4D.mobile/").file($in.param.project._name+"_ios")
						
						var $sources : 4D:C1709.Folder
						$sources:=$in.param.appFolder.folder("Sources")
						
						If ($sources.exists)
							
							$file.setText(doc_folderDigest($sources.platformPath))
							
						End if 
						
					Else 
						
						$file:=ENV.caches("com.4D.mobile/").file($in.param.project._name+"_android")
						
						//#MARK_TODO
						
					End if 
					
					If (Bool:C1537($in.param.create)\
						 & Not:C34(Bool:C1537($in.param.archive))\
						 & Not:C34(Bool:C1537($in.param.build))\
						 & Not:C34(Bool:C1537($in.param.run)))
						
						POST_MESSAGE(New object:C1471(\
							"target"; Choose:C955((Num:C11(Form:C1466.window)>0); Form:C1466.window; $form.window); \
							"action"; "show"; \
							"type"; "confirm"; \
							"title"; "projectCreationSuccessful"; \
							"additional"; "wouldYouLikeToRevealInFinder"; \
							"okFormula"; Formula:C1597(SHOW ON DISK:C922(String:C10($in.param.path)))))
						
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
			"caller"; Current form window:C827; \
			"project"; $o; \
			"create"; True:C214; \
			"build"; True:C214; \
			"run"; True:C214; \
			"verbose"; Bool:C1537(Form:C1466.verbose)))
		
		//______________________________________________________
	: ($message="allowStructureModification")
		
		// Get the project
		$o:=(OBJECT Get pointer:C1124(Object named:K67:5; "project"))->
		
		// Set the temporary authorization
		$o.$_allowStructureAdjustments:=True:C214
		
		If (Bool:C1537($in.value))  // Remember my choice
			
			// Set the option & save
			$o.allowStructureAdjustments:=Bool:C1537($in.value)
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
		EXECUTE METHOD IN SUBFORM:C1085($form.project; $form.callback; *; $message; $in)
		
		//______________________________________________________
End case 

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End