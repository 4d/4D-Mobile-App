/*===============================================*/
Class constructor
	
	C_OBJECT:C1216($o)
	
	$o:=editor_INIT 
	
	If (OB Is empty:C1297($o))
		
		This:C1470.window:=Current form window:C827
		This:C1470.productionURL:=cs:C1710.widget.new("02_prodURL")
		This:C1470.webSettings:=cs:C1710.button.new("webSettings")
		This:C1470.webSettingsLabel:=cs:C1710.static.new("webSettings.label")
		This:C1470.webSettingsGroup:=cs:C1710.group.new(This:C1470.webSettingsLabel;This:C1470.webSettings)
		
		  // Constraints definition
		ob_createPath ($o;"constraints.rules";Is collection:K8:32)
		
	End if 
	
/*===============================================*/
Function settings
	
	OPEN SETTINGS WINDOW:C903("/Database/Web/Config")
	
/*===============================================*/