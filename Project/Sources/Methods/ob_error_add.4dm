//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : ob_error_add
  // Created 02-08-2017 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Add error to object
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_message)
C_OBJECT:C1216($Obj_out)

If (False:C215)
	C_OBJECT:C1216(ob_error_add ;$1)
	C_TEXT:C284(ob_error_add ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	$Obj_out:=$1
	$Txt_message:=$2
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Obj_out.errors=Null:C1517)
	
	$Obj_out.errors:=New collection:C1472($Txt_message)
	
Else 
	
	$Obj_out.errors.push($Txt_message)
	
End if 