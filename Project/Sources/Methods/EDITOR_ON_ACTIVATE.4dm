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

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

// ----------------------------------------------------
If (FORM Get current page:C276=1)  // #MARK_OBSOLETE : with the wizards the 2nd page is ne more used
	
	// Update according to the color scheme
	EDITOR.updateColorScheme()
	
	// Verify the web server configuration
	EDITOR.callMeBack("checkingServerConfiguration")
	EDITOR.callMeBack("refreshServer")
	EDITOR.checkDevTools()
	
	// Launch project verifications
	_o_editor_PROJECT_AUDIT
	
	// Refresh displayed panels
	var $panel : Text
	For each ($panel; panel_Objects)
		
		EDITOR.callChild($panel; "panel_REFRESH")
		
	End for each 
End if 