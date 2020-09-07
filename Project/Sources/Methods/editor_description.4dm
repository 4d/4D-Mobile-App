//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_description
// ID[52B9CF85751D403F890C4F37EB6E491D]
// Created 3-12-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Manage UI of the subform TITLE into the container "description"
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($1)

C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(editor_description; $1)
End if 

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=0; "Missing parameter"))
	
	// <NO PARAMETERS REQUIRED>
	
	// Optional parameters
	If (Count parameters:C259>=1)
		
		If ($1.action#Null:C1517)
			
			Form:C1466.action:=$1.action
			
		Else 
			
			If (Form:C1466.action#Null:C1517)
				
				Form:C1466.action.show:=Bool:C1537($1.show)
				
			End if 
		End if 
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
$o:=UI.button("action")

If (Form:C1466.action#Null:C1517)
	
	$o.setTitle(String:C10(Form:C1466.action.title)).bestSize(Align right:K42:4)
	
End if 

$o.setVisible(Bool:C1537(Form:C1466.action.show))