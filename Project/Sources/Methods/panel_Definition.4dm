//%attributes = {"invisible":true}
#DECLARE ($name : Text)->$formDef : Object

var $formName : Text
var $o : Object

// The name of the managed form
If (Count parameters:C259>=1)
	
	$formName:=$name
	
Else 
	
	// Default
	$formName:=Current form name:C1298
	
End if 

// The root of the forms
$o:=Form:C1466.$dialog

// Create the object if any
If ($o=Null:C1517)
	
	$o:=New object:C1471(\
		$formName; New object:C1471)
	
Else 
	
	If ($o[$formName]=Null:C1517)
		
		$o[$formName]:=New object:C1471
		
	End if 
End if 

// Instantiate the corresponding class if any
If (OB Is empty:C1297(Form:C1466.$dialog[$formName]))
	// | (Shift down & Not(Is compiled mode))
	
	$o[$formName]:=cs:C1710[$formName].new()
	
	// Define local functions
	$o[$formName].refresh:=Formula:C1597(SET TIMER:C645(-1))
	//$o[$formName].call:=Formula(CALL FORM(This.window; "editor_CALLBACK"; $1; $2))
	
End if 

// Always return the current event
$o[$formName].event:=FORM Event:C1606

$formDef:=$o[$formName]