//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : panel_Find_by_name
  // ID[837B32A43E2F4E69B0396B4EF86C015B]
  // Created 11-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_POINTER:C301($2)

C_LONGINT:C283($Lon_index;$Lon_parameters;$Lon_x)
C_POINTER:C301($Ptr_;$Ptr_index)
C_TEXT:C284($Txt_form;$Txt_panel;$Txt_subform)

If (False:C215)
	C_TEXT:C284(panel_Find_by_name ;$0)
	C_TEXT:C284(panel_Find_by_name ;$1)
	C_POINTER:C301(panel_Find_by_name ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_panel:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Ptr_index:=$2
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
ARRAY TEXT:C222($tTxt_objects;0x0000)
FORM GET OBJECTS:C898($tTxt_objects)

Repeat 
	
	$Lon_x:=Find in array:C230($tTxt_objects;"panel.@";$Lon_x+1)
	
	If ($Lon_x>0)
		
		$Lon_index:=$Lon_index+1
		
		OBJECT GET SUBFORM:C1139(*;$tTxt_objects{$Lon_x};$Ptr_;$Txt_form)
		
		If ($Txt_form=$Txt_panel)
			
			$Txt_subform:=$tTxt_objects{$Lon_x}
			$Lon_x:=-1  // Break
			
		End if 
	End if 
Until ($Lon_x=-1)

  // ----------------------------------------------------
  // Return
$0:=$Txt_subform

If ($Lon_parameters>=2)
	
	$Ptr_index->:=$Lon_index
	
End if 

  // ----------------------------------------------------
  // End