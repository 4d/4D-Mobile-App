//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Project method : C_NEW_MOBILE_PROJECT
// ID[574C8C3337AE4A1098BE3B5ACA721C48]
// Created 13-6-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $data; $o : Object

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

COMPILER_COMPONENT

// ----------------------------------------------------
$data:=New object:C1471(\
"$name"; Get localized string:C991("newProject"); \
"$ios"; Is macOS:C1572; \
"$android"; Is Windows:C1573; \
"_window"; Open form window:C675("PROJECT_EDITOR"; Plain form window:K39:10; Horizontally centered:K39:1; At the top:K39:5; *))

DIALOG:C40("WIZARD_NEW_PROJECT"; $data)

If (Bool:C1537(OK))
	
	editor_CREATE_PROJECT($data)
	
	If (Bool:C1537($data.file.exists))
		
		// Cleaning inner objects
		For each ($o; OB Entries:C1720($data).query("key =:1"; "_@"))
			
			OB REMOVE:C1226($data; $o.key)
			
		End for each 
		
		// Open the project editor
		If (DATABASE.isMatrix)
			
			DIALOG:C40("PROJECT_EDITOR"; $data)
			CLOSE WINDOW:C154(EDITOR.window)
			
		Else 
			
			DIALOG:C40("PROJECT_EDITOR"; $data; *)
			
		End if 
		
	Else 
		
		CLOSE WINDOW:C154(EDITOR.window)
		
	End if 
	
Else 
	
	CLOSE WINDOW:C154(EDITOR.window)
	
End if 
