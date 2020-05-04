//%attributes = {"invisible":true}
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_TEXT:C284($t)

If (False:C215)
	C_OBJECT:C1216(panel_Form_definition ;$0)
	C_TEXT:C284(panel_Form_definition ;$1)
End if 

$t:="$"+$1

If (OB Is empty:C1297(editor_INIT )) | (Shift down:C543 & Not:C34(Is compiled mode:C492))
	
	Form:C1466[$t]:=cs:C1710[$1].new()
	
End if 

Form:C1466[$t].event:=FORM Event:C1606

$0:=Form:C1466[$t]