//%attributes = {"invisible":true}
#DECLARE ($name : Text)->$formDef : Object

var $formName : Text
var $o : Object

If (Count parameters:C259>=1)
	
	$formName:=$name
	
Else 
	
	// Default
	$formName:=Current form name:C1298
	
End if 

$o:=Form:C1466.$dialog

If ($o=Null:C1517)
	
	$o:=New object:C1471(\
		$formName; New object:C1471)
	
Else 
	
	If ($o[$formName]=Null:C1517)
		
		$o[$formName]:=New object:C1471
		
	End if 
End if 

If (OB Is empty:C1297(Form:C1466.$dialog[$formName]))\
 | (Shift down:C543 & Not:C34(Is compiled mode:C492))
	
	// Load the class
	$o[$formName]:=cs:C1710[$formName].new()
	
	// Define local functions
	$o[$formName].refresh:=Formula:C1597(SET TIMER:C645(-1))
	
End if 

$o[$formName].event:=FORM Event:C1606

$formDef:=$o[$formName]