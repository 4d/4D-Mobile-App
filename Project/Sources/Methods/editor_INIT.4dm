//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_INIT
// ID[F59AB4219B794E8E94DDB5849F25D76D]
// Created 21-12-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// 
// ----------------------------------------------------
// Declarations
#DECLARE($form : Text)->$value : Object

var $formName : Text
var $value : Object

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

// Optional parameters
If (Count parameters:C259>=1)
	
	$formName:=$form
	
End if 

If (Length:C16($formName)=0)
	
	$formName:=Current form name:C1298
	
End if 

// ----------------------------------------------------
If (Form:C1466.$dialog=Null:C1517)
	
	RECORD.info("Create $dialog")
	
	Form:C1466.$dialog:=New object:C1471
	
End if 

If (Form:C1466.$dialog[$formName]=Null:C1517)
	
	RECORD.info("Create context for: "+$formName)
	
	Form:C1466.$dialog[$formName]:=New object:C1471
	
End if 

$value:=Form:C1466.$dialog[$formName]