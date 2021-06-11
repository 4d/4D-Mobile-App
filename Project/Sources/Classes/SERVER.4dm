Class extends form

//=== === === === === === === === === === === === === === === === === === === === === 
Class constructor
	
	Super:C1705("editor_CALLBACK")
	
	This:C1470.context:=editor_Panel_init(This:C1470.name)
	
	If (OB Is empty:C1297(This:C1470.context))
		
		This:C1470.isSubform:=True:C214
		
		This:C1470.init()
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function init()
	
	This:C1470.toBeInitialized:=False:C215
	
	// Widgets definition
	This:C1470.productionURL:=cs:C1710.widget.new("02_prodURL")
	This:C1470.webSettings:=cs:C1710.button.new("webSettings")
	This:C1470.webSettingsLabel:=cs:C1710.static.new("webSettings.label")
	This:C1470.webSettingsGroup:=cs:C1710.group.new(This:C1470.webSettingsLabel; This:C1470.webSettings)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function settings
	
	OPEN SETTINGS WINDOW:C903("/Database/Web/Config")
	