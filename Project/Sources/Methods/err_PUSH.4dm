//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : err_PUSH
  // ID[2BF58939C6654B88BCD34A20C97DDB76]
  // Created 7-2-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)
C_TEXT:C284($2)
C_LONGINT:C283($3)

C_LONGINT:C283($Lon_parameters;$Lon_type)
C_TEXT:C284($Txt_message;$Txt_type)
C_OBJECT:C1216($Obj_container)

If (False:C215)
	C_OBJECT:C1216(err_PUSH ;$1)
	C_TEXT:C284(err_PUSH ;$2)
	C_LONGINT:C283(err_PUSH ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Obj_container:=$1
	$Txt_message:=$2
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		$Lon_type:=$3  // errors by default
		
	Else 
		
		$Lon_type:=Error message:K38:3
		
	End if 
	
	$Txt_type:=Choose:C955($Lon_type;"infos";"warnings";"errors")
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Obj_container[$Txt_type]=Null:C1517)
	
	$Obj_container[$Txt_type]:=New collection:C1472($Txt_message)
	
Else 
	
	$Obj_container[$Txt_type].push($Txt_message)
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End