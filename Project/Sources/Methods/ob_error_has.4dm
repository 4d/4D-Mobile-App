//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : ob_error_has
  // Created 02-08-2017 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Return if there is an error
  // ----------------------------------------------------

  // Declarations
C_BOOLEAN:C305($0)
C_OBJECT:C1216($1)

If (False:C215)
	C_BOOLEAN:C305(ob_error_has ;$0)
	C_OBJECT:C1216(ob_error_has ;$1)
End if 

C_OBJECT:C1216($Obj_in)
C_BOOLEAN:C305($Boo_has)

$Obj_in:=$1  // no parameter count check
$Boo_has:=False:C215

Case of 
	: ($Obj_in.error#Null:C1517)
		$Boo_has:=True:C214
	: ($Obj_in.errors#Null:C1517)
		$Boo_has:=True:C214
End case 

$0:=$Boo_has