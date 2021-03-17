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

var $bottom; $height; $left; $middle; $right; $top; $width : Integer
var $e; $form; $IN; $o : Object

// NO PARAMETERS REQUIRED

// Optional parameters
If (Count parameters:C259>=1)
	
	$IN:=$1
	
End if 

$form:=New object:C1471(\
"window"; Current form window:C827; \
"form"; editor_INIT; \
"ribbon"; "ribbon"; \
"description"; "description"; \
"project"; "project"; \
"message"; "message"; \
"greeting"; "welcome")

// ----------------------------------------------------
Case of 
		
		//=========================================================
	: ($IN=Null:C1517)  // Form method
		
		$e:=FORM Event:C1606
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Load:K2:1)
				
				If (EDITOR=Null:C1517)  // Direct open not after the wizard
					
					EDITOR:=cs:C1710.editor.new()
					
				End if 
				
				//#MARK_TODO: keep current 4D/Database tips values
				
				// Launch the worker
				Form:C1466.$worker:="4D Mobile ("+String:C10(Form:C1466.$mainWindow)+")"
				CALL WORKER:C1389(String:C10(Form:C1466.$worker); "COMPILER_COMPONENT")
				
				// DEV items
				OBJECT SET VISIBLE:C603(*; "debug.@"; Bool:C1537(DATABASE.isMatrix))
				
				$o:=UI.tips
				$o.enable()
				$o.defaultDelay()
				$o.defaultDuration()
				
				EDITOR.gotoPage("general")
				
				// Load the project
				PROJECT:=cs:C1710.project.new().load(Form:C1466.file)
				
				If (FEATURE.with("wizards"))
					
					// Set the dialog title
					SET WINDOW TITLE:C213(cs:C1710.str.new("editorWindowTitle").localized(PROJECT._name); Form:C1466.$mainWindow)
					
					// Update the ribbon
					$form.form.ribbon:=New object:C1471(\
						"state"; "open"; \
						"tab"; "section"; \
						"page"; Form:C1466.$currentPage; \
						"editor"; Form:C1466)
					
					OBJECT SET VALUE:C1742($form.ribbon; Form:C1466.$dialog.EDITOR.ribbon)
					
					// Update the description
					OBJECT SET VALUE:C1742($form.description; Form:C1466.$currentPage)
					
				Else 
					
					// Set the dialog title
					SET WINDOW TITLE:C213(cs:C1710.str.new("editorWindowTitle").localized(Form:C1466.file.parent.fullName); $form.window)
					
					// Set ribbon and description
					$form.form.ribbon:=New object:C1471(\
						"state"; "open"; \
						"tab"; "section"; \
						"page"; Form:C1466.$currentPage)
					
					(OBJECT Get pointer:C1124(Object named:K67:5; $form.description))->:=Form:C1466.$currentPage
					(OBJECT Get pointer:C1124(Object named:K67:5; $form.ribbon))->:=Form:C1466.$dialog.EDITOR.ribbon
					
				End if 
				
				
				//************************************************
				PROJECT.$worker:=Form:C1466.$worker
				PROJECT.$mainWindow:=Form:C1466.$mainWindow
				PROJECT.$project:=Form:C1466
				//************************************************
				
				// Touch the project subform
				OBJECT SET VALUE:C1742($form.project; PROJECT)
				
				var $pref : cs:C1710.preferences
				$pref:=cs:C1710.preferences.new().user("4D Mobile App.preferences")
				
				// Display the greeting message if any
				If (Bool:C1537(cs:C1710.preferences.new().user("4D Mobile App.preferences").get("doNotShowGreetingMessage")))\
					 | (FEATURE.with("wizards"))
					
					editor_OPEN_PROJECT
					
				Else 
					
					FORM GOTO PAGE:C247(2)
					
				End if 
				
				SET TIMER:C645(-1)
				
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
				
				// keep current tips values
				
				// And restore the 4D values
				
				//______________________________________________________
			: ($e.code=On Activate:K2:9)
				
				ENV.update()
				EXECUTE METHOD IN SUBFORM:C1085("project"; "EDITOR_ON_ACTIVATE")
				
				//______________________________________________________
			: ($e.code=On Unload:K2:2)
				
				CALL WORKER:C1389(Form:C1466.$worker; "killWorker")
				
				//______________________________________________________
			: ($e.code=On Resize:K2:27)
				
				If (OBJECT Get visible:C1075(*; "picker"))
					
					If (FEATURE.with("wizards"))
						
						CALL FORM:C1391(Form:C1466.$mainWindow; Form:C1466.$callback; "pickerHide")
						
					Else 
						
						CALL FORM:C1391($form.window; "editor_CALLBACK"; "pickerHide")
						
					End if 
				End if 
				
				// Mask picker during resizing
				EXECUTE METHOD IN SUBFORM:C1085($form.project; "editor_CALLBACK"; *; "pickerHide"; New object:C1471(\
					"action"; "forms"; \
					"onResize"; True:C214))
				
				// Execute geometry rules in each loaded pannel
				EXECUTE METHOD IN SUBFORM:C1085($form.project; "call_MESSAGE_DISPATCH"; *; New object:C1471(\
					"target"; "panel."; \
					"method"; "UI_SET_GEOMETRY"))
				
				// Center message
				OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
				$middle:=$width\2
				
				OBJECT GET COORDINATES:C663(*; $form.message; $left; $top; $right; $bottom)
				$width:=$right-$left
				$left:=$middle-($width\2)
				$right:=$left+$width
				OBJECT SET COORDINATES:C1248(*; $form.message; $left; $top; $right; $bottom)
				
				// Center the greeting screen
				//(OBJECT Get pointer(Object named; $form.greeting))->:=1+(OBJECT Get pointer(Object named; $form.greeting))->
				
				//______________________________________________________
			: ($e.code=On Timer:K2:25)
				
				SET TIMER:C645(0)
				
				OBJECT SET VISIBLE:C603(*; $form.project; True:C214)
				
				EXECUTE METHOD IN SUBFORM:C1085($form.project; "call_MESSAGE_DISPATCH"; *; New object:C1471(\
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