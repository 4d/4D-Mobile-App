//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_CALLBACK
// ID[5690C64849C740CF84EA709314ABDED7]
// Created 11-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Manage all callbacks to the editor window.
// Some reminders can be addressed to a specific panel. In this case & if the panel is
// displayed on the current screen, the message is sent to it
// otherwise nothing more is do.
// ----------------------------------------------------
// Declarations
var $1 : Text
var $2 : Object

If (False:C215)
	C_TEXT:C284(EDITOR_CALLBACK; $1)
	C_OBJECT:C1216(EDITOR_CALLBACK; $2)
End if 

var $selector : Text
var $form; $in : Object

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	$selector:=$1
	
	// Optional parameters
	If (Count parameters:C259>=2)
		
		$in:=$2
		
	End if 
	
	$form:=New object:C1471(\
		"window"; Current form window:C827; \
		"callback"; Current method name:C684; \
		"currentForm"; Current form name:C1298; \
		"editor"; "PROJECT_EDITOR"; \
		"project"; "PROJECT"; \
		"developer"; "DEVELOPER"; \
		"structure"; "STRUCTURE"; \
		"tableProperties"; "TABLES"; \
		"fieldProperties"; "FIELDS"; \
		"mainMenu"; "MAIN"; \
		"views"; "VIEWS"; \
		"server"; "SERVER"; \
		"data"; "DATA"; \
		"dataSource"; "SOURCE"; \
		"actions"; "ACTIONS"; \
		"actionParameters"; "ACTIONS_PARAMS"; \
		"ribbon"; "RIBBON"; \
		"footer"; "FOOTER")
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If ($form.currentForm=$form.editor)
	
	editor_PROCESS_MESSAGES($selector; $form; $in)
	
Else 
	
	project_PROCESS_MESSAGES($selector; $form; $in)
	
End if 