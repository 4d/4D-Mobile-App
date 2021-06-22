//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_HANDLER
// ID[A10EF3BB0680451287316759D2D9A5B9]
// Created 17-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// EDITOR Form Method
// ----------------------------------------------------
// Declarations
#DECLARE($IN : Object)

var $_in; $e; $o : Object

If (Count parameters:C259>=1)
	
	$_in:=$IN
	
End if 

// ----------------------------------------------------
Case of 
		
		//=========================================================
	: ($_in=Null:C1517)  // Form method
		
		$e:=FORM Event:C1606
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Load:K2:1)
				
				If (FEATURE.with("wizards"))\
					 & (EDITOR#Null:C1517)
					
					// We come from a wizard,
					// so we need to update the form name
					EDITOR.name:=Current form name:C1298
					
				Else 
					
					// Direct open we need to create the EDITOR
					EDITOR:=cs:C1710.EDITOR.new()
					
				End if 
				
				EDITOR.init()
				
				// Launch the worker
				EDITOR.callWorker("COMPILER_COMPONENT")
				
				EDITOR.tips.default()
				
				EDITOR.goToPage("general")
				
				// Load the project
				PROJECT:=cs:C1710.project.new().load(Form:C1466.file)
				
				//************************************************ TO BE REMOVED
				PROJECT.$worker:=EDITOR.worker
				PROJECT.$mainWindow:=EDITOR.window
				PROJECT.$project:=Form:C1466
				//************************************************
				
				EDITOR.android:=PROJECT.$android
				EDITOR.ios:=PROJECT.$ios
				
				If (FEATURE.with("wizards"))
					
					EDITOR.setTitle(EDITOR.str.setText("editorWindowTitle").localized(PROJECT._name))
					
					EDITOR.context.ribbon:=New object:C1471(\
						"state"; "open"; \
						"tab"; "section"; \
						"page"; EDITOR.currentPage; \
						"editor"; Form:C1466)
					
					EDITOR.ribbon.setValue(EDITOR.context.ribbon)
					
					// Update the description
					EDITOR.setHeader()
					
					// Initialize the project subform
					EDITOR.project.setValue(PROJECT)
					
				Else 
					
					
					var $form : Object
					$form:=New object:C1471(\
						"window"; Current form window:C827; \
						"form"; editor_Panel_init; \
						"ribbon"; "ribbon"; \
						"description"; "description"; \
						"project"; "project"; \
						"message"; "message"; \
						"greeting"; "welcome"; \
						"footer"; "footer")
					
					// Set the dialog title
					SET WINDOW TITLE:C213(cs:C1710.str.new("editorWindowTitle").localized(Form:C1466.file.parent.fullName); $form.window)
					
					// Set ribbon and description
					$form.form.ribbon:=New object:C1471(\
						"state"; "open"; \
						"tab"; "section"; \
						"page"; EDITOR.currentPage)
					
					(OBJECT Get pointer:C1124(Object named:K67:5; "description"))->:=EDITOR.currentPage
					(OBJECT Get pointer:C1124(Object named:K67:5; "ribbon"))->:=Form:C1466.$dialog.EDITOR.ribbon
					
					OBJECT SET VALUE:C1742($form.project; PROJECT)
					
				End if 
				
				If (FEATURE.with("wizards"))
					
					EDITOR.ribbon.show()
					EDITOR.description.show()
					
					// Launch project verifications
					EDITOR.checkProject()
					
					// Audit of development tools
					EDITOR.checkDevTools()
					
				Else 
					
					// Display the greeting message if any
					If (Bool:C1537(EDITOR.preferences.get("doNotShowGreetingMessage")))
						
						_o_editor_OPEN_PROJECT
						
					Else 
						
						FORM GOTO PAGE:C247(2)
						
					End if 
				End if 
				
				EDITOR.refresh()
				
				//______________________________________________________
			: ($e.code=On Close Box:K2:21)
				
				ACCEPT:C269
				
				//______________________________________________________
			: ($e.code=On Data Change:K2:15)
				
				If (Not:C34(OB Is empty:C1297(PROJECT)))
					
					// Autosave
					PROJECT.save()
					
				End if 
				
				//______________________________________________________
			: ($e.code=On Deactivate:K2:10)
				
				EDITOR.tips.restore()
				
				//______________________________________________________
			: ($e.code=On Activate:K2:9)
				
				ENV.update()
				
				EDITOR.tips.set()
				
				If (FEATURE.with("wizards"))
					
					EDITOR.updateColorScheme()
					
					// Verify the web server configuration
					EDITOR.callMeBack("checkingServerConfiguration")
					EDITOR.callMeBack("refreshServer")
					
					EDITOR.refreshPanels()
					
					// Launch project verifications
					EDITOR.checkProject()
					
				Else 
					
					EDITOR_ON_ACTIVATE
					
				End if 
				
				EDITOR.callChild("project"; "PROJECT_ON_ACTIVATE")
				
				//______________________________________________________
			: ($e.code=On Unload:K2:2)
				
				EDITOR.tips.restore()
				EDITOR.callWorker("killWorker")
				
				//______________________________________________________
			: ($e.code=On Resize:K2:27)
				
				// Mask picker during resizing
				EDITOR.callChild(EDITOR.project.name; EDITOR.callback; "pickerHide"; New object:C1471(\
					"action"; "forms"; \
					"onResize"; True:C214))
				
				// Execute geometry rules in each loaded pannel
				EDITOR.callChild(EDITOR.project.name; "call_MESSAGE_DISPATCH"; New object:C1471(\
					"target"; "panel."; \
					"method"; "UI_SET_GEOMETRY"))
				
				// Footer
				$o:=EDITOR.footer.updateCoordinates().coordinates
				EDITOR.footer.setCoordinates($o.left; $o.top; $o.left+EDITOR.width(); $o.bottom)
				
				// Center message
				EDITOR.message.alignHorizontally(Align center:K42:3)
				
				//______________________________________________________
			: ($e.code=On Timer:K2:25)
				
				SET TIMER:C645(0)
				
				EDITOR.project.show()
				
				// Footer
				$o:=EDITOR.footer.updateCoordinates().coordinates
				EDITOR.footer.setCoordinates($o.left; $o.top; $o.left+EDITOR.width(); $o.bottom)
				
				EDITOR.callChild(EDITOR.project.name; "call_MESSAGE_DISPATCH"; New object:C1471(\
					"target"; "panel."; \
					"method"; "UI_SET_GEOMETRY"))
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//=========================================================
	: ($_in.action=Null:C1517)
		
		ASSERT:C1129(False:C215; "Missing parameter \"action\"")
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$_in.action+"\"")
		
		//=========================================================
End case 