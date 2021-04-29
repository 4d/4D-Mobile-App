//%attributes = {}
// Refresh displayed panels
var $panel : Text

For each ($panel; panel_Objects)
	
	EDITOR.executeInSubform($panel; "panel_REFRESH")
	
End for each 