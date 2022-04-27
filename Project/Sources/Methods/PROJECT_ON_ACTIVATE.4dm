//%attributes = {"invisible":true}
// Refresh displayed panels
var $panel : Text

For each ($panel; panels)
	
	UI.callChild($panel; Formula:C1597(panel_REFRESH).source)
	
End for each 