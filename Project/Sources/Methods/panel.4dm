//%attributes = {"invisible":true}
#DECLARE($form : Text)->$definition : Object

$form:=$form || Current form name:C1298

$definition:=Form:C1466.$dialog[$form]

If ($definition#Null:C1517)
	
	$definition.event:=FORM Event:C1606
	
End if 
