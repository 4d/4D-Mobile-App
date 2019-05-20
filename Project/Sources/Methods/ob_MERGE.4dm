//%attributes = {"invisible":true}
/*
***ob_MERGE*** ( target ; model )
 -> target (Object)
 -> model (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : ob_MERGE
  // Database: 4D Mobile App
  // ID[30A5CD6BFBC3423AAFBF097521C3A034]
  // Created #23-5-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Add the missing properties of the model to the target
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_property)
C_OBJECT:C1216($Obj_model;$Obj_target)

If (False:C215)
	C_OBJECT:C1216(ob_MERGE ;$1)
	C_OBJECT:C1216(ob_MERGE ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Obj_target:=$1
	$Obj_model:=$2
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
For each ($Txt_property;$Obj_model)
	
	If ($Obj_target[$Txt_property]=Null:C1517)
		
		$Obj_target[$Txt_property]:=$Obj_model[$Txt_property]
		
	Else 
		
		If (Value type:C1509($Obj_model[$Txt_property])=Is object:K8:27)
			
			ob_MERGE ($Obj_target[$Txt_property];$Obj_model[$Txt_property])  // <=========== RECURSIVE
			
		End if 
	End if 
End for each 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End