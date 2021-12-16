//%attributes = {}
#DECLARE($index : Integer)->$name : Text

If (False:C215)
	C_LONGINT:C283(panel_FindByIndex; $1)
	C_TEXT:C284(panel_FindByIndex; $0)
End if 

var $indx : Integer
var $ptr : Pointer

ARRAY TEXT:C222($widgets; 0x0000)
FORM GET OBJECTS:C898($widgets)

$indx:=Find in array:C230($widgets; "panel."+String:C10($index))

If ($indx>0)
	
	OBJECT GET SUBFORM:C1139(*; $widgets{$indx}; $ptr; $name)
	
End if 