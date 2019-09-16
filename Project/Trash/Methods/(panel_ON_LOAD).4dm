//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : panel_ON_LOAD
  // Database: 4D Mobile Express
  // ID[559BA94C87BF447A8AA3B27C0B384E0E]
  // Created #10-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Common actions to perform at the onload event of the panel
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_height;$Lon_i;$Lon_parameters;$Lon_type;$Lon_width)

ARRAY TEXT:C222($tTxt_entryOrder;0)
ARRAY TEXT:C222($tTxt_objects;0)

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // Place the background & the bottom line {
FORM GET PROPERTIES:C674(Current form name:C1298;$Lon_width;$Lon_height)

  //OBJECT SET COORDINATES(*;"_background";0;0;$Lon_width;$Lon_height)
OBJECT SET COORDINATES:C1248(*;"bottom.line";16;$Lon_height-1;$Lon_width-16;$Lon_height-1)

  //OBJECT GET COORDINATES(*;"viewport";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
  //OBJECT SET COORDINATES(*;"viewport";$Lon_left;0;$Lon_right;$Lon_height)
  //}

  // ENTRY ORDER IS BASED UPON THE OBJECT NAMES {
FORM GET OBJECTS:C898($tTxt_objects)
SORT ARRAY:C229($tTxt_objects)

For ($Lon_i;1;Size of array:C274($tTxt_objects);1)
	
	$Lon_type:=OBJECT Get type:C1300(*;$tTxt_objects{$Lon_i})
	
	If (OBJECT Get enterable:C1067(*;$tTxt_objects{$Lon_i}))\
		 | ($Lon_type=Object type listbox:K79:8)
		
		APPEND TO ARRAY:C911($tTxt_entryOrder;$tTxt_objects{$Lon_i})
		
	End if 
End for 

FORM SET ENTRY ORDER:C1468($tTxt_entryOrder)
  //}

  // Activate essential events to the form {
ARRAY LONGINT:C221($tLon_events;0x0000)
APPEND TO ARRAY:C911($tLon_events;On Load:K2:1)
APPEND TO ARRAY:C911($tLon_events;On Unload:K2:2)
APPEND TO ARRAY:C911($tLon_events;On Timer:K2:25)
APPEND TO ARRAY:C911($tLon_events;On Activate:K2:9)
APPEND TO ARRAY:C911($tLon_events;On Getting Focus:K2:7)
APPEND TO ARRAY:C911($tLon_events;On Losing Focus:K2:8)

OBJECT SET EVENTS:C1239(*;"";$tLon_events;Enable events others unchanged:K42:38)
  //}

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End