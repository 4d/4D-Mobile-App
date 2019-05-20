//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : ob_error_string
  // Database: 4D Mobile App
  // Created #21-01-2019 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Try to convert errors to strings
  // ----------------------------------------------------

  // Declarations
C_OBJECT:C1216($1)
C_TEXT:C284($0)

If (False:C215)
	C_TEXT:C284(ob_error_string ;$0)
	C_OBJECT:C1216(ob_error_string ;$1)
End if 

C_OBJECT:C1216($Obj_out;$Obj_buffer)
C_TEXT:C284($Txt_message)
C_LONGINT:C283($Lon_parameters;$Lon_limit;$Lon_i)

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$Obj_out:=$1
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Value type:C1509($Obj_out.errors)#Is collection:K8:32)
	
	$Txt_message:=String:C10($Obj_out.error)  // could be empty
	
Else 
	
	$Txt_message:=""
	$Lon_limit:=$Obj_out.errors.length-1
	
	For ($Lon_i;0;$Obj_out.errors.length-1;1)
		
		Case of 
				
				  //________________________________________
			: (Value type:C1509($Obj_out.errors[$Lon_i])=Is text:K8:3)
				
				$Txt_message:=$Txt_message+$Obj_out.errors[$Lon_i]
				
				  //________________________________________
			: (Value type:C1509($Obj_out.errors[$Lon_i])=Is object:K8:27)
				
				If (Value type:C1509($Obj_out.errors[$Lon_i].message)=Is text:K8:3)
					
					  // Add the message
					$Txt_message:=$Txt_message+$Obj_out.errors[$Lon_i].message
					  // Add other information if any
					$Obj_buffer:=OB Copy:C1225($Obj_out.errors[$Lon_i])
					OB REMOVE:C1226($Obj_buffer;"message")
					
					If (Not:C34(OB Is empty:C1297($Obj_buffer)))
						
						$Txt_message:=$Txt_message+": "+JSON Stringify:C1217($Obj_buffer)
						
					End if 
					
				Else 
					
					$Txt_message:=$Txt_message+JSON Stringify:C1217($Obj_out.errors[$Lon_i])
					
				End if 
				
				  //________________________________________
			Else 
				
				$Txt_message:=$Txt_message+String:C10($Obj_out.errors[$Lon_i])
				
				  //________________________________________
		End case 
		
		If ($Lon_i#$Lon_limit)
			
			$Txt_message:=$Txt_message+"\n"
			
		End if 
	End for 
End if 

  // ----------------------------------------------------
$0:=$Txt_message