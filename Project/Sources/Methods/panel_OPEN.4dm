//%attributes = {"invisible":true}
/*
***panel_OPEN*** ( index )
 -> index (Long Integer)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : panel_OPEN
  // Database: 4D Mobile Express
  // ID[B91B044D257B4DDCAA77B516A3350C32]
  // Created #4-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($1)

C_LONGINT:C283($Lon_;$Lon_bottom;$Lon_i;$Lon_index;$Lon_parameters;$Lon_top)
C_LONGINT:C283($Lon_vOffset)
C_TEXT:C284($Txt_panel)

If (False:C215)
	C_LONGINT:C283(panel_OPEN ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Lon_index:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Txt_panel:="panel."+String:C10($Lon_index)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Not:C34(OBJECT Get visible:C1075(*;$Txt_panel)))
	
	OBJECT GET COORDINATES:C663(*;$Txt_panel;$Lon_;$Lon_top;$Lon_;$Lon_bottom)
	
	OBJECT SET VISIBLE:C603(*;$Txt_panel;True:C214)
	$Lon_vOffset:=$Lon_bottom-$Lon_top
	
	For ($Lon_i;$Lon_index+1;panel_Count ;1)
		
		OBJECT MOVE:C664(*;"title.@."+String:C10($Lon_i);0;$Lon_vOffset)
		OBJECT MOVE:C664(*;"panel."+String:C10($Lon_i);0;$Lon_vOffset)
		
	End for 
	
	(OBJECT Get pointer:C1124(Object named:K67:5;"title.button."+String:C10($Lon_index)))->:=1
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End