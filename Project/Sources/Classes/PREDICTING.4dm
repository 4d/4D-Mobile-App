Class extends form

Class constructor
	
	Super:C1705()
	
	This:C1470.isSubform:=True:C214
	
	This:C1470.init()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	This:C1470.toBeInitialized:=False:C215
	
	This:C1470.listbox("predicting").setScrollbars(0; 2)
	This:C1470.formObject("background")
	
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function validate()
	
	This:C1470.callParent(-1)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function open()
	
	This:C1470.callParent(-2)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function close()
	
	This:C1470.callParent(-3)
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Returns the height according to the found items
Function bestSize()->$height : Integer
	
	// #MARK_TODO
	// Must be called from the host allow to resize the container
	If (This:C1470.predicting.data.length<3)
		
		$height:=This:C1470.predicting.properties.rowHeight*3
		
	Else 
		
		$height:=This:C1470.predicting.properties.rowHeight*This:C1470.predicting.data.length
		
	End if 
	
	$height:=$height+3
	