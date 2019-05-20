//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : ob_warning_add
  // Database: 4D Mobile App
  // Created #01-10-2018 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Add error to object
  // ----------------------------------------------------

  // Declarations
C_OBJECT:C1216($1)
C_TEXT:C284($2)

If (False:C215)
	C_OBJECT:C1216(ob_warning_add ;$1)
	C_TEXT:C284(ob_warning_add ;$2)
End if 

C_OBJECT:C1216($Obj_out)
C_TEXT:C284($Txt_message)
C_LONGINT:C283($Lon_parameters)

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
If ($Obj_out.warnings=Null:C1517)
	
	$Obj_out.warnings:=New collection:C1472($Txt_message)
	
Else 
	
	$Obj_out.warnings.push($Txt_message)
	
End if 