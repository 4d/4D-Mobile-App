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
	
	This:C1470.formObject("noDataModel")
	
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
	
	//=== === === === === === === === === === === === === === === === === === === === ==
Function handleEvents($e : Object) : Integer
	
	If ($e.objectName=Null:C1517)  // <== FORM METHOD
		
		$e:=panel_Common(On Load:K2:1; On Timer:K2:25)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Load:K2:1)
				
				This:C1470.onLoad()
				
				//______________________________________________________
			: ($e.code=On Timer:K2:25)
				
				This:C1470.update()
				
				//______________________________________________________
		End case 
		
	Else   // <== WIDGETS METHOD
		
		Case of 
				
				//==============================================
			: (This:C1470.tables.catch())
				
				
				//==============================================
			: (This:C1470.mains.catch())
				
				Case of 
						
						//______________________________________________________
					: ($e.code=On Clicked:K2:4)\
						 | ($e.code=On Selection Change:K2:29)
						
						This:C1470.updateButtons()
						
						editor_ui_LISTBOX(This:C1470.mains.name)
						
						//______________________________________________________
					: ($e.code=On Row Moved:K2:32)
						
						If (PROJECT.isLocked())
							
							// Unable to set "movable rows" to false, so redraw
							This:C1470.update()
							
							BEEP:C151
							
						Else 
							
							This:C1470._updateOrder()
							
						End if 
						
						//______________________________________________________
					: ($e.code=On Drag Over:K2:13)
						
						var $x : Blob
						var $o : Object
						
						GET PASTEBOARD DATA:C401("com.4d.private.4dmobile.table"; $x)
						
						If (Bool:C1537(OK))
							
							BLOB TO VARIABLE:C533($x; $o)
							SET BLOB SIZE:C606($x; 0)
							
							If (Bool:C1537(OK))
								
								// TODO: Don(t allow if already present
								
								return (0)
								
							End if 
						End if 
						
						//______________________________________________________
					: ($e.code=On Drop:K2:12)
						
						GET PASTEBOARD DATA:C401("com.4d.private.4dmobile.table"; $x)
						
						If (Bool:C1537(OK))
							
							BLOB TO VARIABLE:C533($x; $o)
							SET BLOB SIZE:C606($x; 0)
							
							If (Bool:C1537(OK))
								
								// TODO:Don(t allow if already present
								
								This:C1470.__add($o.tableNumber; $o.name; Drop position:C608)
								This:C1470._updateOrder()
								
							End if 
						End if 
						
						editor_ui_LISTBOX(This:C1470.mains.name)
						
						//______________________________________________________
					: ($e.code=On Getting Focus:K2:7)
						
						editor_ui_LISTBOX(This:C1470.mains.name; True:C214)
						
						//______________________________________________________
					: ($e.code=On Losing Focus:K2:8)
						
						editor_ui_LISTBOX(This:C1470.mains.name; False:C215)
						
						//______________________________________________________
				End case 
				
				//==============================================
			: (This:C1470.addOne.catch($e; On Clicked:K2:4))
				
				This:C1470._add("one")
				
				//==============================================
			: (This:C1470.addAll.catch($e; On Clicked:K2:4))
				
				This:C1470._add("all")
				
				//==============================================
			: (This:C1470.removeOne.catch($e; On Clicked:K2:4))
				
				var $indx : Integer
				$indx:=Find in array:C230((This:C1470.mains.pointer())->; True:C214)
				
				If ($indx>0)
					
					This:C1470.mains.deleteRow($indx)
					
				End if 
				
				This:C1470._updateOrder()
				
				//==============================================
			: (This:C1470.removeAll.catch($e; On Clicked:K2:4))
				
				This:C1470.mains.deleteAllRows()
				Form:C1466.main.order:=New collection:C1472
				
				//==============================================
			: (This:C1470.up.catch($e; On Clicked:K2:4))
				
				
				//==============================================
			: (This:C1470.down.catch($e; On Clicked:K2:4))
				
				
				
				//==============================================
		End case 
	End if 
	
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
	
	This:C1470.noDataModel.show(This:C1470.available.length=0)
	
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
		
		This:C1470.noDataModel.show()
		This:C1470.withDataModel.hide()
		
	Else 
		
		This:C1470.noDataModel.hide()
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
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function _add($target : Text)
	
	var $found; $i; $indx : Integer
	var $idsPtr; $namesPtr : Pointer
	
	$target:=$target || "one"
	
	$namesPtr:=This:C1470.mains.columnPtr("table_names")
	$idsPtr:=This:C1470.mains.columnPtr("table_ids")
	
	If ($target="one")
		
		$indx:=Find in array:C230((This:C1470.tables.pointer())->; True:C214)
		
		If ($indx>0)
			
			$found:=Find in array:C230((This:C1470.mains.pointer())->; True:C214)
			
			If ($found>0)
				
				This:C1470.__add($idsPtr->{$indx}; $namesPtr->{$indx}; $found)
				
			Else 
				
				This:C1470.__add($idsPtr->{$indx}; $namesPtr->{$indx})
				
			End if 
		End if 
		
	Else 
		
		For ($i; 1; Size of array:C274($idsPtr->); 1)
			
			This:C1470.__add($idsPtr->{$i}; $namesPtr->{$i})
			
		End for 
	End if 
	
	This:C1470._updateOrder()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function __add($id : Text; $name : Text; $row : Integer)
	
	var $idsPtr; $namesPtr : Pointer
	
	$idsPtr:=This:C1470.mains.columnPtr("main_ids")
	
	If (Find in array:C230($idsPtr->; $id)=-1)
		
		$namesPtr:=This:C1470.mains.columnPtr("main_names")
		
		If ($row>=0)
			
			INSERT IN ARRAY:C227($idsPtr->; $row)
			INSERT IN ARRAY:C227($namesPtr->; $row)
			
			//%W-533.3
			$idsPtr->{$row}:=$id
			$namesPtr->{$row}:=$name
			//%W+533.3
			
		Else 
			
			APPEND TO ARRAY:C911($idsPtr->; $id)
			APPEND TO ARRAY:C911($namesPtr->; $name)
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function _updateOrder()
	
	var $i : Integer
	var $ptr : Pointer
	
	$ptr:=This:C1470.mains.columnPtr("main_ids")
	
	Form:C1466.main.order:=New collection:C1472
	
	For ($i; 1; Size of array:C274($ptr->); 1)
		
		Form:C1466.main.order[$i-1]:=$ptr->{$i}
		
	End for 
	
	This:C1470.updateButtons()
	
	
	