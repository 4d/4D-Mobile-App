//%attributes = {"invisible":true}
// Refresh displayed panels
var $panel : Text

For each ($panel; panels)
	
	EDITOR.callChild($panel; "panel_REFRESH")
	
End for each 