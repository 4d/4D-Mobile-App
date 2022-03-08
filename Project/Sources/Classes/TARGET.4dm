Class extends form

//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705(Formula:C1597(editor_CALLBACK).source)
	
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
	
	var $group : cs:C1710.group
	$group:=This:C1470.group("os")
	This:C1470.button("ios").addToGroup($group)
	This:C1470.button("android").addToGroup($group)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	If (Is Windows:C1573)
		
		This:C1470.android.setPicture("#images/os/Android-32.png")\
			.setBackgroundPicture()\
			.setNumStates(1)
		
		If (Form:C1466.$ios)
			
			This:C1470.ios.setPicture("#images/os/iOS-32.png")
			
		Else 
			
			This:C1470.ios.setPicture("#images/os/iOS-24.png")
			
		End if 
		
		This:C1470.ios.disable()\
			.setBackgroundPicture()\
			.setNumStates(1)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Manage UI for the target
Function displayTarget()
	
	This:C1470.ios.setValue(EDITOR.ios)
	This:C1470.android.setValue(EDITOR.android)