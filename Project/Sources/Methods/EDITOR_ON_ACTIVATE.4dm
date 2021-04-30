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
If (FORM Get current page:C276=1)  // #MARK_OBSOLETE : with the wizards the 2nd page is ne more used
	
	// Update according to the color scheme
	EDITOR.updateColorScheme()
	
	// Verify the web server configuration
	EDITOR.post("checkingServerConfiguration")
	EDITOR.post("refreshServer")
	
	If (FEATURE.with("android"))
		
		EDITOR.checkDevTools()
		
	Else 
		
		// Recovering the list of available devices
		CALL WORKER:C1389(Form:C1466.$worker; "editor_GET_DEVICES"; New object:C1471(\
			"caller"; Form:C1466.$mainWindow; "project"; PROJECT))
		
		// Audit of development tools
		CALL WORKER:C1389(Form:C1466.$worker; "editor_CHECK_INSTALLATION"; New object:C1471(\
			"caller"; Form:C1466.$mainWindow; "project"; PROJECT))
		
	End if 
	
	// Launch project verifications
	_o_editor_PROJECT_AUDIT
	
	// Refresh displayed panels
	For each ($panel; panel_Objects)
		
		EDITOR.executeInSubform($panel; "panel_REFRESH")
		
	End for each 
End if 