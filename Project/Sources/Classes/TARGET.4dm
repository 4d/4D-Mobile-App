/*===============================================
PRODUCTS pannel Class
===============================================*/
Class extends form

//=== === === === === === === === === === === === === === === === === === === === === === === === === === === === 
Class constructor
	
	Super:C1705("editor_CALLBACK")
	
	This:C1470.context:=editor_INIT
	
	If (OB Is empty:C1297(This:C1470.context)) | Shift down:C543
		
		This:C1470.ios:=cs:C1710.button.new("ios")
		This:C1470.android:=cs:C1710.button.new("android")
		This:C1470.os:=cs:C1710.group.new(This:C1470.ios; This:C1470.android)
		
		This:C1470.preview:=cs:C1710.static.new("target.preview")
		
		// Constraints definition
		ob_createPath(This:C1470.context; "constraints.rules"; Is collection:K8:32)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === === 
	// Manage UI for the target
Function displayTarget
	
	This:C1470.ios.setValue(EDITOR.ios)
	This:C1470.android.setValue(EDITOR.android)