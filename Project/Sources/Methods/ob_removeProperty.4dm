//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Description:
  // Find recursively property in object
  // ----------------------------------------------------
  // Declarations

C_OBJECT:C1216($0)
C_OBJECT:C1216($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_parameters;$Lon_i)
C_TEXT:C284($Txt_property;$Txt_buffer)
C_OBJECT:C1216($Obj_in;$Obj_out)

If (False:C215)
	C_OBJECT:C1216(ob_removeProperty ;$0)
	C_OBJECT:C1216(ob_removeProperty ;$1)
	C_TEXT:C284(ob_removeProperty ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	$Txt_property:=$2
	
	$Obj_out:=New object:C1471("success";True:C214)
	
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

For each ($Txt_buffer;$Obj_in)
	
	Case of 
			
			  //________________________________________
		: ($Txt_buffer=$Txt_property)  // we found an instance
			
			OB REMOVE:C1226($Obj_in;$Txt_buffer)
			
			  //________________________________________
		: (Value type:C1509($Obj_in[$Txt_buffer])=Is collection:K8:32)
			
			For ($Lon_i;0;$Obj_in[$Txt_buffer].length-1;1)
				
				If (Value type:C1509($Obj_in[$Txt_buffer][$Lon_i])=Is object:K8:27)
					
					ob_removeProperty ($Obj_in[$Txt_buffer][$Lon_i];$Txt_property;$Obj_out)
					
				End if 
			End for 
			
			  //________________________________________
		: (Value type:C1509($Obj_in[$Txt_buffer])=Is object:K8:27)
			
			Case of 
					
					  //----------------------------------------
				: ($Obj_in[$Txt_buffer].isFile#Null:C1517)
					
					  // Exclude special object with cycle: File
					  // XXX other object
					  //----------------------------------------
				Else   // normal object
					
					ob_removeProperty ($Obj_in[$Txt_buffer];$Txt_property;$Obj_out)
					
					  //----------------------------------------
			End case 
			
			  //________________________________________
		Else 
			
			  // Ignore
			
			  //________________________________________
	End case 
End for each 

$Obj_out.success:=True:C214

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End