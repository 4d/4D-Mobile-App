//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_HANDLER
// ID[A10EF3BB0680451287316759D2D9A5B9]
// Created 17-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(editor_HANDLER; $1)
End if 

var $bottom; $left; $middle; $right; $top : Integer
var $e; $form; $IN; $o : Object

// NO PARAMETERS REQUIRED

// Optional parameters
If (Count parameters:C259>=1)
	
	$IN:=$1
	
End if 

// ----------------------------------------------------
Case of 
		
		//=========================================================
	: ($IN=Null:C1517)  // Form method
		
		$form:=New object:C1471(\
			"window"; Current form window:C827; \
			"form"; editor_INIT; \
			"ribbon"; "ribbon"; \
			"description"; "description"; \
			"project"; "project"; \
			"message"; "message"; \
			"greeting"; "welcome"; \
			"footer"; "footer")
		
		$e:=FORM Event:C1606
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Load:K2:1)
				
				If (EDITOR=Null:C1517)
					
					// Direct open not after the wizard
					EDITOR:=cs:C1710.EDITOR.new()
					
				Else 
					
					// Update the form name
					EDITOR.name:=Current form name:C1298
					
				End if 
				
				Form:C1466.$dialog.EDITOR.message:=cs:C1710.subform.new("message").setValue(New object:C1471)
				
				//#MARK_TODO: keep current 4D/Database tips values
				
				// Launch the worker
				EDITOR.callWorker("COMPILER_COMPONENT")
				
				// DEV items
				OBJECT SET VISIBLE:C603(*; "debug.@"; Bool:C1537(DATABASE.isMatrix))
				
				$o:=UI.tips
				$o.enable()
				$o.defaultDelay()
				$o.defaultDuration()
				
				EDITOR.gotoPage("general")
				
				// Load the project
				PROJECT:=cs:C1710.project.new().load(Form:C1466.file)
				
				//************************************************
				PROJECT.$worker:=EDITOR.worker
				PROJECT.$mainWindow:=EDITOR.window
				PROJECT.$project:=Form:C1466
				//************************************************
				
				EDITOR.android:=PROJECT.$android
				EDITOR.ios:=PROJECT.$ios
				
				If (FEATURE.with("wizards"))
					
					EDITOR.setTitle(cs:C1710.str.new("editorWindowTitle").localized(PROJECT._name))
					
					// Update the ribbon
					$form.form.ribbon:=New object:C1471(\
						"state"; "open"; \
						"tab"; "section"; \
						"page"; EDITOR.currentPage; \
						"editor"; Form:C1466)
					
					OBJECT SET VALUE:C1742($form.ribbon; Form:C1466.$dialog.EDITOR.ribbon)
					
					// Update the description
					EDITOR.setHeader()
					
				Else 
					
					// Set the dialog title
					SET WINDOW TITLE:C213(cs:C1710.str.new("editorWindowTitle").localized(Form:C1466.file.parent.fullName); $form.window)
					
					// Set ribbon and description
					$form.form.ribbon:=New object:C1471(\
						"state"; "open"; \
						"tab"; "section"; \
						"page"; EDITOR.currentPage)
					
					(OBJECT Get pointer:C1124(Object named:K67:5; $form.description))->:=EDITOR.currentPage
					(OBJECT Get pointer:C1124(Object named:K67:5; $form.ribbon))->:=Form:C1466.$dialog.EDITOR.ribbon
					
				End if 
				
				// Touch the project subform
				OBJECT SET VALUE:C1742($form.project; PROJECT)
				
				If (FEATURE.with("wizards"))
					
					editor_OPEN_PROJECT
					
				Else 
					
					// Display the greeting message if any
					If (Bool:C1537(EDITOR.preferences.get("doNotShowGreetingMessage")))
						
						editor_OPEN_PROJECT
						
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
				
				//#MARK_TODO: keep current tips values And restore the 4D values
				
				//______________________________________________________
			: ($e.code=On Activate:K2:9)
				
				//#MARK_TODO: restore current tips values
				
				ENV.update()
				
				EDITOR_ON_ACTIVATE
				
				EDITOR.executeInSubform("project"; "PROJECT_ON_ACTIVATE")
				
				//______________________________________________________
			: ($e.code=On Unload:K2:2)
				
				//#MARK_TODO: restore 4D tips values
				
				EDITOR.callWorker("killWorker")
				
				//______________________________________________________
			: ($e.code=On Resize:K2:27)
				
				// Mask picker during resizing
				EDITOR.executeInSubform($form.project; EDITOR.callback; "pickerHide"; New object:C1471(\
					"action"; "forms"; \
					"onResize"; True:C214))
				
				// Execute geometry rules in each loaded pannel
				EDITOR.executeInSubform($form.project; "call_MESSAGE_DISPATCH"; New object:C1471(\
					"target"; "panel."; \
					"method"; "UI_SET_GEOMETRY"))
				
				// Footer
				OBJECT GET COORDINATES:C663(*; $form.footer; $left; $top; $right; $bottom)
				$right:=$left+EDITOR.width()+1
				OBJECT SET COORDINATES:C1248(*; $form.footer; $left; $top; $right; $bottom)
				
				// Center message
				Form:C1466.$dialog.EDITOR.message.alignHorizontally(Align center:K42:3)
				
				//______________________________________________________
			: ($e.code=On Timer:K2:25)
				
				SET TIMER:C645(0)
				
				OBJECT SET VISIBLE:C603(*; $form.project; True:C214)
				
				// Footer
				OBJECT GET COORDINATES:C663(*; $form.footer; $left; $top; $right; $bottom)
				$right:=$left+EDITOR.width()+1
				OBJECT SET COORDINATES:C1248(*; $form.footer; $left; $top; $right; $bottom)
				
				EDITOR.executeInSubform($form.project; "call_MESSAGE_DISPATCH"; New object:C1471(\
					"target"; "panel."; \
					"method"; "UI_SET_GEOMETRY"))
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//=========================================================
	: ($IN.action=Null:C1517)
		
		ASSERT:C1129(False:C215; "Missing parameter \"action\"")
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$IN.action+"\"")
		
		//=========================================================
End case 