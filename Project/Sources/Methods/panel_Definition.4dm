//%attributes = {"invisible":true}
#DECLARE($formName : Text)->$definition : Object

var $name : Text

// The name of the managed form
If (Count parameters:C259>=1)
	
	$name:=$formName
	
Else 
	
	// Default
	$name:=Current form name:C1298
	
End if 

// Create the object if any
If (Form:C1466.$dialog=Null:C1517)
	
	Form:C1466.$dialog:=New object:C1471(\
		$name; New object:C1471)
	
Else 
	
	If (Form:C1466.$dialog[$name]=Null:C1517)
		
		Form:C1466.$dialog[$name]:=New object:C1471
		
	End if 
End if 

// Instantiate the corresponding class if any
If (OB Is empty:C1297(Form:C1466.$dialog[$name]))\
 | (Shift down:C543 & Not:C34(Is compiled mode:C492))
	
	Form:C1466.$dialog[$name]:=cs:C1710[$name].new()
	
	// Define local functions
	Form:C1466.$dialog[$name].refresh:=Formula:C1597(SET TIMER:C645(-1))
	
	Form:C1466.$dialog[$name].call:=Formula:C1597(CALL FORM:C1391(Form:C1466.$dialog[$name].window; Form:C1466.$dialog[$name].callback; $1))
	
End if 

// Always return the current event
Form:C1466.$dialog[$name].event:=FORM Event:C1606

$definition:=Form:C1466.$dialog[$name]