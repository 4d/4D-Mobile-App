//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : panel_Count
  // Database: 4D Mobile Express
  // ID[8F15843F50E74326BFE2E6117CA0A57E]
  // Created #12-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Returns the number of panels of the form
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($0)

C_LONGINT:C283($Lon_number;$Lon_parameters;$Lon_x)

If (False:C215)
	C_LONGINT:C283(panel_Count ;$0)
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

Repeat 
	
	$Lon_x:=Find in array:C230($tTxt_objects;"panel.@";$Lon_x+1)
	$Lon_number:=$Lon_number+Num:C11($Lon_x>0)
	
Until ($Lon_x=-1)

  // ----------------------------------------------------
  // Return
$0:=$Lon_number  //number of panels into the form

  // ----------------------------------------------------
  // End