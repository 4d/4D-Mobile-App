//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : call_MESSAGE_DISPATCH
  // ID[2EA9710049454153B1F0AF42D2215894]
  // Created 15-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:

  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_i;$Lon_parameters;$Lon_type)
C_OBJECT:C1216($Obj_message)

ARRAY TEXT:C222($tTxt_objects;0)

If (False:C215)
	C_OBJECT:C1216(call_MESSAGE_DISPATCH ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Obj_message:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
EXECUTE METHOD:C1007($Obj_message.method)

FORM GET OBJECTS:C898($tTxt_objects)

For ($Lon_i;1;Size of array:C274($tTxt_objects);1)
	
	$Lon_type:=OBJECT Get type:C1300(*;$tTxt_objects{$Lon_i})
	
	If ($Lon_type=Object type subform:K79:40)
		
		If (Position:C15($Obj_message.target;$tTxt_objects{$Lon_i})=1)
			
			EXECUTE METHOD IN SUBFORM:C1085($tTxt_objects{$Lon_i};$Obj_message.method)
			
		End if 
		
		EXECUTE METHOD IN SUBFORM:C1085($tTxt_objects{$Lon_i};"call_MESSAGE_DISPATCH";*;$Obj_message)
		
	End if 
End for 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End