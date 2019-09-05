//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : panel_SET_CONSTRAINTS
  // ID[6BD14A4A80B84D009542A2F5A3027A55]
  // Created 23-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($Obj_constraints)

If (False:C215)
	C_OBJECT:C1216(_o_panel_SET_CONSTRAINTS ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Obj_constraints:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
(OBJECT Get pointer:C1124(Object named:K67:5;"constraints"))->:=$Obj_constraints

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End