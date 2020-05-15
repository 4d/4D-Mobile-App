//%attributes = {"invisible":true}
var $t : Text
$t:=Current form name:C1298

If (OB Is empty:C1297(editor_INIT ))\
 | (Shift down:C543 & Not:C34(Is compiled mode:C492))
	
	Form:C1466["$"+$t]:=cs:C1710[$t].new()
	
End if 

Form:C1466["$"+$t].event:=FORM Event:C1606
Form:C1466["$"+$t].refresh:=Formula:C1597(SET TIMER:C645(-1))

var $0 : Object
$0:=Form:C1466["$"+$t]