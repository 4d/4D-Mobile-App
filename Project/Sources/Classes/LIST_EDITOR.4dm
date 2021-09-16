Class extends form

Class constructor
	
	Super:C1705()
	
	This:C1470.init()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	var $group : cs:C1710.group
	
	If (This:C1470.toBeInitialized)
		
		This:C1470.toBeInitialized:=False:C215
		
		This:C1470.input("name")
		
		$group:=This:C1470.group("typeGroup")
		This:C1470.button("push").addToGroup($group)
		This:C1470.button("segmented").addToGroup($group)
		This:C1470.button("popover").addToGroup($group)
		This:C1470.button("sheet").addToGroup($group)
		This:C1470.button("picker").addToGroup($group)
		This:C1470.typeGroup.distributeLeftToRight()
		
		This:C1470.button("static")
		This:C1470.button("datasource")
		
		$group:=This:C1470.group("choiceListGroup")
		This:C1470.button("label").addToGroup($group)
		This:C1470.button("image").addToGroup($group)
		This:C1470.choiceListGroup.distributeLeftToRight()
		
		This:C1470.formObject("binding"; "binding.label").addToGroup($group)
		This:C1470.formObject("valueLabel"; "value.label").addToGroup($group)
		This:C1470.formObject("labelLabel"; "label.label").addToGroup($group)
		This:C1470.listbox("choicelist"; "choicelist").addToGroup($group)
		This:C1470.button("add").addToGroup($group)
		This:C1470.button("remove").addToGroup($group)
		
	End if 