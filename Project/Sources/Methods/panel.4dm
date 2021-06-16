//%attributes = {"invisible":true}
#DECLARE($name : Text)->$definition : Object

If (Count parameters:C259>=1)
	
	$definition:=Form:C1466.$dialog[$name]
	
Else 
	
	// Default
	$definition:=Form:C1466.$dialog[Current form name:C1298]
	
End if 



