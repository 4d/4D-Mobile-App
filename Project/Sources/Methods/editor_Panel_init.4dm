//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_Panel_init
// ID[F59AB4219B794E8E94DDB5849F25D76D]
// Created 21-12-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Defines, if necessary, the context of the panel and returns it
// ----------------------------------------------------
#DECLARE($name : Text)->$context : Object

var $form : Text
var $context : Object

If (Count parameters:C259>=1)
	
	$form:=$name
	
Else 
	
	// Get the current form
	$form:=Current form name:C1298
	
End if 

// ----------------------------------------------------
If (Form:C1466.$dialog=Null:C1517)
	
	Form:C1466.$dialog:=New object:C1471
	
End if 

If (Form:C1466.$dialog[$form]=Null:C1517)
	
	Form:C1466.$dialog[$form]:=New object:C1471
	
End if 

$context:=Form:C1466.$dialog[$form]