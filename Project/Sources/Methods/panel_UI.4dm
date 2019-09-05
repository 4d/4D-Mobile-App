//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : panel_UI
  // ID[87678F8FC386485E9EBD815F82C945EA]
  // Created 12-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:

  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_i;$Lon_parameters;$Lon_type)
C_OBJECT:C1216($Obj_UISettings)

If (False:C215)
	C_OBJECT:C1216(panel_UI ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Obj_UISettings:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (OB Is defined:C1231($Obj_UISettings;"background"))
	
	OBJECT SET RGB COLORS:C628(*;"background";Background color none:K23:10;$Obj_UISettings.background)
	
End if 

If (OB Is defined:C1231($Obj_UISettings;"line"))
	
	OBJECT SET RGB COLORS:C628(*;"bottom.line";$Obj_UISettings.line;Background color:K23:2)
	
End if 

If (OB Is defined:C1231($Obj_UISettings;"labels"))
	
	ARRAY TEXT:C222($tTxt_objects;0x0000)
	FORM GET OBJECTS:C898($tTxt_objects)
	
	For ($Lon_i;1;Size of array:C274($tTxt_objects);1)
		
		$Lon_type:=OBJECT Get type:C1300(*;$tTxt_objects{$Lon_i})
		
		If ($Lon_type=Object type static text:K79:2)\
			 | ($Lon_type=Object type groupbox:K79:31)
			
			OBJECT SET RGB COLORS:C628(*;$tTxt_objects{$Lon_i};$Obj_UISettings.labels;Background color:K23:2)
			
		End if 
	End for 
End if 


OBJECT SET RGB COLORS:C628(*;"@.warning";0x00FF2600;Background color none:K23:10)

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End