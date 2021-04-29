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

// ----------------------------------------------------
// Initialisations
If (FEATURE.with("wizards"))
	
	// Launch checking the structure
	CALL WORKER:C1389(EDITOR.worker; "_o_structure"; New object:C1471(\
		"action"; "catalog"; \
		"caller"; EDITOR.window))
	
	// Launch project verifications
	EDITOR.call("projectAudit")
	
Else 
	
	var $worker : Text
	var $window : Integer
	$window:=Current form window:C827
	$worker:="4D Mobile ("+String:C10($window)+")"
	
	// Launch checking the structure
	CALL WORKER:C1389($worker; "_o_structure"; New object:C1471(\
		"action"; "catalog"; \
		"caller"; $window))
	
	// Launch project verifications
	CALL FORM:C1391($window; "editor_CALLBACK"; "projectAudit")
	
End if 

// ----------------------------------------------------
// End