Class extends form

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
	
	This:C1470.formObject("noPublishedTable")
	
	var $group : cs:C1710.group
	$group:=This:C1470.group("withDataModel")
	This:C1470.listbox("tables"; "01_available").addToGroup($group)
	This:C1470.formObject("tablesBorder"; "01_available.border").addToGroup($group)
	
	This:C1470.listbox("mains"; "02_displayed").addToGroup($group)
	This:C1470.formObject("mainsBorder"; "02_displayed.border").addToGroup($group)
	
	This:C1470.button("addOne"; "b.add.one").addToGroup($group)
	This:C1470.button("addAll"; "b.add.all").addToGroup($group)
	This:C1470.button("removeOne"; "b.remove.one").addToGroup($group)
	This:C1470.button("removeAll"; "b.remove.all").addToGroup($group)
	
	This:C1470.button("up"; "b.up")
	This:C1470.button("down"; "b.down")
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	This:C1470.tables.setScrollbars(0; 2).noHighlight().updateDefinition()
	This:C1470.mains.setScrollbars(0; 2).noHighlight().updateDefinition()
	
	// Give the focus to the tables listbox
	This:C1470.tables.focus()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function saveContext($current : Object)
	
	//
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function restoreContext()
	
	//
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function update()
	
	// Available tables
	This:C1470.available:=New collection:C1472
	
	If (Form:C1466.dataModel#Null:C1517)
		
		var $tableID : Text
		
		For each ($tableID; Form:C1466.dataModel)
			
			This:C1470.available.push(New object:C1471(\
				"name"; Form:C1466.dataModel[$tableID][""].label; \
				"id"; $tableID))
			
		End for each 
	End if 
	
	This:C1470.noPublishedTable.show(This:C1470.available.length=0)
	
	// Selected tables
	This:C1470.main:=New collection:C1472
	
	If (Value type:C1509(Form:C1466.main.order)#Is collection:K8:32)
		
		Form:C1466.main.order:=New collection:C1472
		
	End if 
	
	For each ($tableID; Form:C1466.main.order)
		
		If (Form:C1466.dataModel[$tableID]#Null:C1517)
			
			This:C1470.main.push(New object:C1471(\
				"name"; Form:C1466.dataModel[$tableID][""].label; \
				"id"; $tableID))
			
		End if 
	End for each 
	
	If (This:C1470.available.length=0)
		
		This:C1470.noPublishedTable.show()
		This:C1470.withDataModel.hide()
		
	Else 
		
		This:C1470.noPublishedTable.hide()
		This:C1470.withDataModel.show()
		
	End if 
	
	If (PROJECT.isLocked())
		
		This:C1470.tables.notDraggable()\
			.notSelectable()\
			.unselect()
		
		This:C1470.mains.notSelectable()\
			.nonMovableLines()\
			.notDraggable()\
			.notDroppable()\
			.unselect()
		
	Else 
		
		This:C1470.tables.multipleSelectable()\
			.draggable()
		
		This:C1470.mains.singleSelectable()\
			.movableLines()\
			.draggable()\
			.droppable()
		
	End if 
	
	This:C1470.updateButtons()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function updateButtons()
	
	If (PROJECT.isLocked())
		
		This:C1470.addOne.disable()
		This:C1470.addAll.disable()
		This:C1470.removeOne.disable()
		This:C1470.removeAll.disable()
		
	Else 
		
		This:C1470.addOne.setEnabled((This:C1470.available.length>Form:C1466.main.order.length) & (This:C1470.availableCurrent#Null:C1517))
		This:C1470.addAll.setEnabled(This:C1470.available.length>Form:C1466.main.order.length)
		This:C1470.removeOne.setEnabled(This:C1470.mainsCurrent#Null:C1517)
		This:C1470.removeAll.setEnabled(Form:C1466.main.order.length>0)
		
	End if 
	