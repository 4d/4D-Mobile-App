//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : ob_error_combine
  // Created 02-08-2017 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Combine error of second parameter to first one
  // ----------------------------------------------------
  // Declarations
#DECLARE($Obj_out: Object; $Obj_with: Object; $Txt_message: Text)

  // TODO: maybe add a parameters to inject error domain in errors object to know the original of errors

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