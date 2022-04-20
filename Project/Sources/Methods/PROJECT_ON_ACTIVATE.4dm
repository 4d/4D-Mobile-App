//%attributes = {"invisible":true}
// Refresh displayed panels
var $panel : Text

For each ($panel; panels)
	
	UI.callChild($panel; "panel_REFRESH")
	
End for each 