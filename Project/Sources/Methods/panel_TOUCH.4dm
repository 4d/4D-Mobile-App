//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : panel_TOUCH
  // Database: 4D Mobile Express
  // ID[F7BCCE684B5F4360906F800B8FF8E6A9]
  // Created 11-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:

  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_parameters;$Lon_x)
C_OBJECT:C1216($Obj_project)

ARRAY TEXT:C222($tTxt_objects;0)

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  //NO PARAMETERS REQUIRED
	
	  //Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Obj_project:=(OBJECT Get pointer:C1124(Object subform container:K67:4))->

FORM GET OBJECTS:C898($tTxt_objects)

Repeat 
	
	$Lon_x:=Find in array:C230($tTxt_objects;"panel.@";$Lon_x+1)
	
	If ($Lon_x>0)
		
		(OBJECT Get pointer:C1124(Object named:K67:5;$tTxt_objects{$Lon_x}))->:=$Obj_project
		
	End if 
Until ($Lon_x=-1)

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End