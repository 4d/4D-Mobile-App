//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : panel_GOTO
  // ID[74102A95AA7E491B932F5FA1A1F9FB75]
  // Created 12-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Selects a panel
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($1)

C_BOOLEAN:C305($Boo_opened)
C_LONGINT:C283($Lon_cursor;$Lon_panel;$Lon_panelCount;$Lon_parameters)
C_POINTER:C301($Ptr_pannel)

If (False:C215)
	C_LONGINT:C283(panel_GOTO ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Lon_panel:=$1  // Next open panel if not passed
		
	End if 
	
	$Lon_panelCount:=panel_Count 
	
	$Lon_cursor:=$Lon_panel
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

Repeat 
	
	$Lon_cursor:=$Lon_cursor+1
	
	If ($Lon_cursor<=$Lon_panelCount)
		
		  // Is the panel opened?
		$Ptr_pannel:=OBJECT Get pointer:C1124(Object named:K67:5;"title.button."+String:C10($Lon_cursor))
		
		If (Not:C34(Is nil pointer:C315($Ptr_pannel)))
			
			$Boo_opened:=($Ptr_pannel->=1)
			
			If ($Boo_opened)
				
				GOTO OBJECT:C206(*;"panel."+String:C10($Lon_cursor))
				
				EXECUTE METHOD IN SUBFORM:C1085("panel."+String:C10($Lon_cursor);"panel_SET_FOCUS")
				
			End if 
		End if 
		
	Else 
		
		  // Restart at the first
		$Lon_cursor:=0
		
	End if 
Until ($Boo_opened)\
 | ($Lon_cursor=$Lon_panel)

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End