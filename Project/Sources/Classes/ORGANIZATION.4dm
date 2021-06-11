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
	This:C1470.name:=cs:C1710.widget.new("10_name")
	This:C1470.nameHelp:=cs:C1710.button.new("10_name.help")
	This:C1470.identifier:=cs:C1710.widget.new("30_identifier")
	This:C1470.identifierHelp:=cs:C1710.button.new("30_identifier.help")