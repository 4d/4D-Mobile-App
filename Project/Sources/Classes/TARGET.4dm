Class extends form

//=== === === === === === === === === === === === === === === === === === === === === === === === === === === === 
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
	This:C1470.ios:=cs:C1710.button.new("ios")
	This:C1470.android:=cs:C1710.button.new("android")
	This:C1470.os:=cs:C1710.group.new(This:C1470.ios; This:C1470.android)
	
	This:C1470.preview:=cs:C1710.static.new("target.preview")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === === 
	// Manage UI for the target
Function displayTarget()
	
	This:C1470.ios.setValue(EDITOR.ios)
	This:C1470.android.setValue(EDITOR.android)