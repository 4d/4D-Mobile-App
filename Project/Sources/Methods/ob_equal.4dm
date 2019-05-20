//%attributes = {"invisible":true,"preemptive":"capable"}
C_BOOLEAN:C305($0)
C_OBJECT:C1216($1)
C_OBJECT:C1216($2)

If (False:C215)
	C_BOOLEAN:C305(ob_equal ;$0)
	C_OBJECT:C1216(ob_equal ;$1)
	C_OBJECT:C1216(ob_equal ;$2)
End if 

$0:=New collection:C1472($1).equal(New collection:C1472($2))