//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : EDITOR_ON_ACTIVATE
  // ID[7D3910538F974FEEBA93C0AFF2216728]
  // Created 17-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Action to performe when the editor is activated
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_parameters;$Win_hdl)
C_TEXT:C284($t;$Txt_worker)

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	$Win_hdl:=Current form window:C827
	
	$Txt_worker:="4D Mobile ("+String:C10($Win_hdl)+")"
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (FORM Get current page:C276=1)
	
	  // Launch project verifications
	editor_PROJECT_AUDIT 
	
	  // Verify the web server configuration
	CALL FORM:C1391($Win_hdl;"editor_CALLBACK";"checkingServerConfiguration")
	CALL FORM:C1391($Win_hdl;"editor_CALLBACK";"refreshServer")
	
	  // Refresh displayed panels
	For each ($t;panel_Objects )
		
		EXECUTE METHOD IN SUBFORM:C1085($t;"panel_REFRESH")
		
	End for each 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End