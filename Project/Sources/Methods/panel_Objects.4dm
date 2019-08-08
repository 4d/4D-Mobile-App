//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : panel_Objects
  // Database: 4D Mobile Express
  // ID[B68517EA8DD94B4FB2C87ECF876A1F2F]
  // Created 10-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Returns a collection of the panels of the current form
  // ----------------------------------------------------
  // Declarations
C_COLLECTION:C1488($0)

C_LONGINT:C283($Lon_parameters;$Lon_x)
C_COLLECTION:C1488($Col_panels)

If (False:C215)
	C_COLLECTION:C1488(panel_Objects ;$0)
End if 

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
ARRAY TEXT:C222($tTxt_objects;0x0000)
FORM GET OBJECTS:C898($tTxt_objects)

$Col_panels:=New collection:C1472

Repeat 
	
	$Lon_x:=Find in array:C230($tTxt_objects;"panel.@";$Lon_x+1)
	
	If ($Lon_x>0)
		
		$Col_panels.push($tTxt_objects{$Lon_x})
		
	End if 
Until ($Lon_x=-1)

  // ----------------------------------------------------
  // Return
$0:=$Col_panels

  // ----------------------------------------------------
  // End