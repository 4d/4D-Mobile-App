//%attributes = {"invisible":true}
/*
panels := ***panel_State*** ( panels )
 -> panels (Collection)
 <- panels (Collection)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : panel_State
  // Database: 4D Mobile Express
  // ID[90E3EE33DB934208BAE62A1AEF948213]
  // Created #4-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_COLLECTION:C1488($0)
C_COLLECTION:C1488($1)

C_LONGINT:C283($Lon_;$Lon_bottom;$Lon_i;$Lon_index;$Lon_j;$Lon_panelNumber)
C_LONGINT:C283($Lon_parameters;$Lon_top;$Lon_vOffset;$Lon_x)
C_POINTER:C301($Ptr_)
C_TEXT:C284($Txt_form)
C_OBJECT:C1216($Obj_panel)
C_COLLECTION:C1488($Col_panels)

ARRAY TEXT:C222($tTxt_objects;0)

If (False:C215)
	C_COLLECTION:C1488(panel_State ;$0)
	C_COLLECTION:C1488(panel_State ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Col_panels:=$1
		
	Else 
		
		$Col_panels:=New collection:C1472
		
	End if 
	
	FORM GET OBJECTS:C898($tTxt_objects)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Col_panels.length>0)
	
	  // Restore
	$Lon_panelNumber:=panel_Count 
	
	For each ($Obj_panel;$Col_panels)
		
		If (Not:C34($Obj_panel.open))
			
			OBJECT GET SUBFORM:C1139(*;$Obj_panel.name;$Ptr_;$Txt_form)
			
			OBJECT GET COORDINATES:C663(*;$Obj_panel.name;$Lon_;$Lon_top;$Lon_;$Lon_bottom)
			
			(OBJECT Get pointer:C1124(Object named:K67:5;"title.button."+String:C10($Lon_i)))->:=0
			
			OBJECT SET VISIBLE:C603(*;$Obj_panel.name;False:C215)
			
			$Lon_vOffset:=-($Lon_bottom-$Lon_top)
			
			For ($Lon_j;$Lon_i+1;$Lon_panelNumber;1)
				
				OBJECT MOVE:C664(*;"title.@."+String:C10($Lon_j);0;$Lon_vOffset)
				OBJECT MOVE:C664(*;"panel."+String:C10($Lon_j);0;$Lon_vOffset)
				
			End for 
		End if 
	End for each 
	
Else 
	
	  // Get the state
	Repeat 
		
		$Lon_x:=Find in array:C230($tTxt_objects;"panel.@";$Lon_x+1)
		
		If ($Lon_x>0)
			
			$Lon_index:=$Lon_index+1
			
			OBJECT GET SUBFORM:C1139(*;$tTxt_objects{$Lon_x};$Ptr_;$Txt_form)
			
			$Col_panels.push(New object:C1471(\
				"name";"panel."+String:C10($Lon_index);\
				"form";$Txt_form;\
				"open";OBJECT Get visible:C1075(*;"panel."+String:C10($Lon_index))))
			
		End if 
	Until ($Lon_x=-1)
End if 

  // ----------------------------------------------------
  // Return
$0:=$Col_panels

  // ----------------------------------------------------
  // End