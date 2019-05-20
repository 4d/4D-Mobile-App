//%attributes = {"invisible":true}
/*
***col_notNull*** ( Param_1 )
 -> Param_1 (Object)
________________________________________________________

*/
  // Ignore null values (use with .filter)
C_OBJECT:C1216($1)

If (False:C215)
	C_OBJECT:C1216(col_notNull ;$1)
End if 

$1.result:=($1.value#Null:C1517)