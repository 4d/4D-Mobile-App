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
var $panel : Text

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

// ----------------------------------------------------
If (FORM Get current page:C276=1)
	
	// Update according to the color scheme
	EDITOR.init()
	
	// Verify the web server configuration
	CALL FORM:C1391(Form:C1466.$mainWindow; "editor_CALLBACK"; "checkingServerConfiguration")
	CALL FORM:C1391(Form:C1466.$mainWindow; "editor_CALLBACK"; "refreshServer")
	
	// Audit of development tools
	CALL WORKER:C1389(Form:C1466.$worker; "editor_CHECK_INSTALLATION"; New object:C1471(\
		"caller"; Form:C1466.$mainWindow; "project"; PROJECT))
	
	// Recovering the list of available devices
	CALL WORKER:C1389(Form:C1466.$worker; "editor_GET_DEVICES"; New object:C1471(\
		"caller"; Form:C1466.$mainWindow; "project"; PROJECT))
	
	// Launch project verifications
	editor_PROJECT_AUDIT
	
	// Refresh displayed panels
	For each ($panel; panel_Objects)
		
		EDITOR.executeInSubform($panel; "panel_REFRESH")
		
	End for each 
End if 