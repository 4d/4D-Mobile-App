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

// Launch checking the structure
EDITOR.callWorker("_o_structure"; New object:C1471(\
"action"; "catalog"; \
"caller"; EDITOR.window))

// Launch project verifications
EDITOR.callMeBack("projectAudit")
// ----------------------------------------------------
// End