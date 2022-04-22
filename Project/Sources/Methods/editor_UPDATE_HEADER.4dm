//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_UPDATE_HEADER
// ID[52B9CF85751D403F890C4F37EB6E491D]
// Created 3-12-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Manage UI of the subform TITLE into the container "description"
// ----------------------------------------------------
// Declarations
#DECLARE($data : Object)

If (False:C215)
	C_OBJECT:C1216(editor_UPDATE_HEADER; $1)
End if 

var $button : cs:C1710.button

// Optional parameters
If (Count parameters:C259>=1)
	
	If ($data.action#Null:C1517)
		
		Form:C1466.action:=$data.action
		
	Else 
		
		If (Form:C1466.action#Null:C1517)
			
			Form:C1466.action.show:=Bool:C1537($data.show)
			
		End if 
	End if 
End if 

// ----------------------------------------------------
$button:=cs:C1710.button.new("action")

If (Form:C1466.action#Null:C1517)
	
	$button.setTitle(String:C10(Form:C1466.action.title))\
		.bestSize(Align right:K42:4)
	
End if 

$button.show(Bool:C1537(Form:C1466.action.show))