//%attributes = {"invisible":true}
/// ----------------------------------------------------
// Project method : project_UI_DEFINITION
// ID[38A72415F5D34F62A3B62016B961F0EE]
// Created 10-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_COLLECTION:C1488($1)

C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($Obj_geometry)
C_COLLECTION:C1488($Col_panels)

If (False:C215)
	C_COLLECTION:C1488(_o_project_UI_DEFINITION; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	
	// Optional parameters
	If ($Lon_parameters>=1)
		
		$Col_panels:=$1
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
$Obj_geometry:=New object:C1471

// If (Caps lock down)
//  // Special colors
//$Obj_geometry.ui:=New object("background";0x00ECF4FF;"line";0x00054F9F;"labels";0x006699CC)
// Else
//  // Default
//$Obj_geometry.ui:=New object("background";0x00FFFFFF;"line";0x00AAAAAA)
// End if

$Obj_geometry.ui:=New object:C1471

If (ui.colorScheme.isDarkStyle)
	
	$Obj_geometry.ui.background:=Background color none:K23:10
	
End if 

$Obj_geometry.panels:=$Col_panels

panel_INIT($Obj_geometry)

// Keep the UI elements to update the subforms
(OBJECT Get pointer:C1124(Object named:K67:5; "UI"))->:=$Obj_geometry.ui

//Form.ui:=$Obj_geometry.ui

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End