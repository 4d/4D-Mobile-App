//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : sharedObject
  // ID[2F1797A750894D62BAE334F4A6385106]
  // Created 4-2-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_property)
C_OBJECT:C1216($Obj_shared;$Obj_src)

If (False:C215)
	C_OBJECT:C1216(sharedObject ;$1)
	C_OBJECT:C1216(sharedObject ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Obj_src:=$1
	$Obj_shared:=$2
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Use ($Obj_shared)
	
	For each ($Txt_property;$Obj_src)
		
		Case of 
				
				  //______________________________________________________
			: (Value type:C1509($Obj_src[$Txt_property])=Is object:K8:27)
				
				$Obj_shared[$Txt_property]:=New shared object:C1526
				sharedObject ($Obj_src[$Txt_property];$Obj_shared[$Txt_property])
				
				  //______________________________________________________
			: (Value type:C1509($Obj_src[$Txt_property])=Is collection:K8:32)
				
				$Obj_shared[$Txt_property]:=New shared collection:C1527
				sharedCollection ($Obj_src[$Txt_property];$Obj_shared[$Txt_property])
				
				  //______________________________________________________
			Else 
				
				$Obj_shared[$Txt_property]:=$Obj_src[$Txt_property]
				
				  //______________________________________________________
		End case 
	End for each 
End use 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End