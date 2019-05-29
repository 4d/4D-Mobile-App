//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)
C_LONGINT:C283($1)
C_OBJECT:C1216(${2})

If (False:C215)
	C_OBJECT:C1216(_choose ;$0)
	C_LONGINT:C283(_choose ;$1)
	C_OBJECT:C1216(_choose ;${2})
End if 

$0:=${$1+2}