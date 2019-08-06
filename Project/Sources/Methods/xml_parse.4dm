//%attributes = {"invisible":true,"preemptive":"capable"}
If (False:C215)
	C_OBJECT:C1216(xml_parse ;$0)
	C_TEXT:C284(xml_parse ;$1)
End if 

C_OBJECT:C1216($0)
C_TEXT:C284($1)
$0:=xml ("parse";New object:C1471("variable";$1))