//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_CALLBACK
// ID[5690C64849C740CF84EA709314ABDED7]
// Created 11-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Manage all callbacks to the editor window.
// Some messages can be addressed to a specific panel. In this case & if the panel is
// displayed on the current screen, the message is sent to it
// otherwise nothing more is do.
// ----------------------------------------------------
// Declarations
#DECLARE($selector : Text; $data : Object)

If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	If (Current form name:C1298="PROJECT_EDITOR")
		
		If (Count parameters:C259>=2)
			
			editor_PROCESS_MESSAGES($selector; $data)
			
		Else 
			
			editor_PROCESS_MESSAGES($selector)
			
		End if 
		
	Else 
		
		If (Count parameters:C259>=2)
			
			project_PROCESS_MESSAGES($selector; $data)
			
		Else 
			
			project_PROCESS_MESSAGES($selector)
			
		End if 
	End if 
End if 