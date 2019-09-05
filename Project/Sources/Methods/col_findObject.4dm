//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : col_findObject
  // Created 21-8-2018 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Find object using ob_equal in collection of objects.
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)
C_OBJECT:C1216($2)

If (False:C215)
	C_OBJECT:C1216(col_findObject ;$1)
	C_OBJECT:C1216(col_findObject ;$2)
End if 

  // ----------------------------------------------------
$1.result:=ob_equal ($1.value;$2)