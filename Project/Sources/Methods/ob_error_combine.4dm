//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : ob_error_combine
  // Created 02-08-2017 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Combine error of second parameter to first one
  // ----------------------------------------------------
  // Declarations

C_OBJECT:C1216($1)
C_OBJECT:C1216($2)
C_TEXT:C284($3)

If (False:C215)
	C_OBJECT:C1216(ob_error_combine ;$1)
	C_OBJECT:C1216(ob_error_combine ;$2)
	C_TEXT:C284(ob_error_combine ;$3)
End if 

C_OBJECT:C1216($Obj_out;$Obj_with)
C_TEXT:C284($Txt_message)
C_LONGINT:C283($Lon_parameters)

  // TODO: maybe add a parameters to inject error domain in errors object to know the original of errors

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Obj_out:=$1
	$Obj_with:=$2
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		$Txt_message:=$3
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // Check result object, must have only errors, not error
If ($Obj_out.error#Null:C1517)
	
	If ($Obj_out.errors=Null:C1517)
		
		$Obj_out.errors:=New collection:C1472($Obj_out.error)
		
	Else 
		
		$Obj_out.errors.push($Obj_out.error)
		
	End if 
	
	OB REMOVE:C1226($Obj_out;"error")
	
End if 

  // then add errors from other parameters
Case of 
		
		  //________________________________________
	: ($Obj_with.error#Null:C1517)
		
		If ($Obj_out.errors=Null:C1517)
			
			$Obj_out.errors:=New collection:C1472()
			
		End if 
		
		$Obj_out.errors.push($Obj_with.error)
		
		  //________________________________________
	: ($Obj_with.errors#Null:C1517)
		
		If ($Obj_out.errors=Null:C1517)
			
			$Obj_out.errors:=New collection:C1472()
			
		End if 
		
		$Obj_out.errors.combine($Obj_with.errors)
		
		  //________________________________________
	: (Length:C16(String:C10($Txt_message))>0)
		
		  // there is no error in $Obj_with, add a default error $Txt_message
		If ($Obj_out.errors=Null:C1517)
			
			$Obj_out.errors:=New collection:C1472()
			
		End if 
		
		$Obj_out.errors.push($Txt_message)
		
		  //________________________________________
End case 