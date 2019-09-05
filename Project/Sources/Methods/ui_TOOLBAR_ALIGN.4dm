//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ui_TOOLBAR_ALIGN
  // ID[DE16575F729743C0B3CBD61072008DFE]
  // Created 14-6-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_bottom;$Lon_height;$Lon_left;$Lon_parameters;$Lon_right;$Lon_top)
C_LONGINT:C283($Lon_width)
C_TEXT:C284($Txt_widget)
C_OBJECT:C1216($Obj_in)

If (False:C215)
	C_OBJECT:C1216(ui_TOOLBAR_ALIGN ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
For each ($Txt_widget;$Obj_in.widgets)
	
	  // Get localized width
	OBJECT GET BEST SIZE:C717(*;$Txt_widget;$Lon_width;$Lon_height)
	
	  // Add 10% for margins
	$Lon_width:=Round:C94($Lon_width*1.1;0)
	
	  // Minimum width
	$Lon_width:=Choose:C955($Lon_width<Num:C11($Obj_in.minWidth);Num:C11($Obj_in.minWidth);$Lon_width)
	
	  // Get current object coordinates
	OBJECT GET COORDINATES:C663(*;$Txt_widget;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
	
	  // Resize current object
	$Lon_left:=Num:C11($Obj_in.start)
	$Lon_right:=$Lon_left+$Lon_width
	OBJECT SET COORDINATES:C1248(*;$Txt_widget;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
	
	  // Calculate the cumulative shift
	$Obj_in.start:=$Lon_right+Num:C11($Obj_in.gap)
	
End for each 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End