//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : panel_Find
// ID[837B32A43E2F4E69B0396B4EF86C015B]
// Created 11-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
#DECLARE($panel : Text; $ptr : Pointer) : Text

If (False:C215)
	C_TEXT:C284(panel_Find; $1)
	C_POINTER:C301(panel_Find; $2)
	C_TEXT:C284(panel_Find; $0)
End if 

var $form; $subform : Text
var $count; $indx : Integer
var $nil : Pointer

ARRAY TEXT:C222($widgets; 0)

// ----------------------------------------------------
FORM GET OBJECTS:C898($widgets)

Repeat 
	
	$indx:=Find in array:C230($widgets; "panel.@"; $indx+1)
	
	If ($indx>0)
		
		$count+=1
		
		OBJECT GET SUBFORM:C1139(*; $widgets{$indx}; $nil; $form)
		
		If ($form=$panel)
			
			$subform:=$widgets{$indx}
			break
			
		End if 
	End if 
Until ($indx=-1)

If (Not:C34(Is nil pointer:C315($ptr)))
	
	$ptr->:=$count
	
End if 

return ($subform)