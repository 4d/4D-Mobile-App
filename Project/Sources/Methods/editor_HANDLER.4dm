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

var $worker : Text
var $bottom; $height; $left; $middle; $right; $top; $width : Integer
var $e; $form; $IN; $o; $project : Object

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
				
				//#MARK_TODO: keep current 4D/Database tips values
				
				OBJECT SET VISIBLE:C603(*; "debug.@"; Bool:C1537(DATABASE.isMatrix))
				
				$o:=UI.tips
				$o.enable()
				$o.defaultDelay()
				$o.defaultDuration()
				
				//editor_PAGE("general")
				Form:C1466.$dialog.EDITOR.pages:=cs:C1710.editor.new()
				Form:C1466.$dialog.EDITOR.pages.gotoPage("general")
				
				// Set ribbon and description
				$form.form.ribbon:=New object:C1471(\
					"state"; "open"; \
					"tab"; "section"; \
					"page"; Form:C1466.currentPage)
				
				(OBJECT Get pointer:C1124(Object named:K67:5; $form.description))->:=Form:C1466.currentPage
				(OBJECT Get pointer:C1124(Object named:K67:5; $form.ribbon))->:=Form:C1466.$dialog.EDITOR.ribbon
				
				// Load the project
				PROJECT:=cs:C1710.project.new()
				PROJECT.load(Form:C1466.file)
				
				PROJECT.$project:=Form:C1466
				
				// Set the dialog title
				SET WINDOW TITLE:C213(Get localized string:C991("4dProductName")+": "+Form:C1466.file.parent.fullName; $form.window)
				
				// Touch the project subform
				(OBJECT Get pointer:C1124(Object named:K67:5; $form.project))->:=PROJECT
				
				// Display the greeting message if any [
				If (Bool:C1537(editor_Preferences.doNotShowGreetingMessage))
					
					editor_HANDLER(New object:C1471(\
						"action"; "open"))
					
				Else 
					
					FORM GOTO PAGE:C247(2)
					
				End if 
				//]
				
				SET TIMER:C645(-1)
				
				//______________________________________________________
			: ($e.code=On Close Box:K2:21)
				
				ACCEPT:C269
				
				//______________________________________________________
			: ($e.code=On Data Change:K2:15)
				
				// Autosave
				PROJECT.save()
				
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
				
				CALL WORKER:C1389("4D Mobile ("+String:C10($form.window)+")"; "killWorker")
				
				//______________________________________________________
			: ($e.code=On Resize:K2:27)
				
				If (OBJECT Get visible:C1075(*; "picker"))
					
					CALL FORM:C1391($form.window; "editor_CALLBACK"; "pickerHide")
					
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
				(OBJECT Get pointer:C1124(Object named:K67:5; $form.greeting))->:=1+(OBJECT Get pointer:C1124(Object named:K67:5; $form.greeting))->
				
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
	: ($IN.action="open")
		
		//editor_PAGE("general")
		Form:C1466.$dialog.EDITOR.pages.gotoPage("general")
		
		OBJECT SET VISIBLE:C603(*; $form.ribbon; True:C214)
		OBJECT SET VISIBLE:C603(*; $form.description; True:C214)
		
		// Launch project verifications
		editor_PROJECT_AUDIT
		
		$worker:="4D Mobile ("+String:C10($form.window)+")"
		
		// Launch checking the development environment
		CALL WORKER:C1389($worker; "mobile_Check_installation"; New object:C1471(\
			"caller"; $form.window))
		
		If (DATABASE.isMacOs)
			// Launch recovering the list of available simulator devices
			CALL WORKER:C1389($worker; "simulator"; New object:C1471(\
				"action"; "devices"; \
				"filter"; "available"; \
				"minimumVersion"; SHARED.iosDeploymentTarget; \
				"caller"; $form.window))
		Else 
			//
		End if 
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$IN.action+"\"")
		
		//=========================================================
End case 