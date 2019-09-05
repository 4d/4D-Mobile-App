//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : editor_PROJECT_AUDIT
  // ID[4E068BB188A548B8A85C59D3D99C9EC9]
  // Created 5-9-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Launch project verifications
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_parameters;$Win_hdl)
C_TEXT:C284($Txt_worker)

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // <NO PARAMETERS REQUIRED>
	
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
  // Launch checking the structure
CALL WORKER:C1389($Txt_worker;"structure";New object:C1471(\
"action";"catalog";\
"caller";$Win_hdl))

  // Launch project verifications
CALL FORM:C1391($Win_hdl;"editor_CALLBACK";"projectAudit")


  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End