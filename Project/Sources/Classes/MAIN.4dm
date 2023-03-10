Class extends panel

Class constructor
	
	Super:C1705(Formula:C1597(editor_CALLBACK).source)
	
	This:C1470.context:=Super:C1706.init()
	
	If (OB Is empty:C1297(This:C1470.context))
		
		This:C1470.init()
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Design definition
Function init()
	
	var $group : cs:C1710.group
	
	This:C1470.toBeInitialized:=False:C215
	
	This:C1470.formObject("noDataModel")
	
	$group:=This:C1470.group("withDataModel")
	This:C1470.listbox("_dataModel").addToGroup($group)
	This:C1470.formObject("_dataModel.border").addToGroup($group)
	
	This:C1470.listbox("displayed"; "02_displayed").addToGroup($group)
	This:C1470.formObject("displayedBorder"; "02_displayed.border").addToGroup($group)
	
	This:C1470.button("addOne").addToGroup($group)
	This:C1470.button("addAll").addToGroup($group)
	This:C1470.button("removeOne").addToGroup($group)
	This:C1470.button("removeAll").addToGroup($group)
	
	This:C1470.button("up")
	This:C1470.button("down")
	
	//=== === === === === === === === === === === === === === === === === === === === ==
	/// Events handler
Function handleEvents($e : Object) : Integer
	
	If ($e.objectName=Null:C1517)  // <== FORM METHOD
		
		$e:=Super:C1706.handleEvents(On Load:K2:1; On Timer:K2:25)
		
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
				// MARK: _dataModel
			: (This:C1470._dataModel.catch())
				
				var $x : Blob
				var $o : Object
				
				//$o:=This._dataModel.cellPosition($e)
				
				Case of 
						
						//______________________________________________________
					: ($e.code=On Clicked:K2:4)\
						 | ($e.code=On Selection Change:K2:29)
						
						This:C1470._updateButtons()
						
						This:C1470._dataModel.foregroundColor:=Foreground color:K23:1
						This:C1470["_dataModel.border"].foregroundColor:=UI.selectedColor
						
						_o_editor_ui_LISTBOX(This:C1470._dataModel.name; True:C214)
						
						//______________________________________________________
					: ($e.code=On Double Clicked:K2:5)
						
						This:C1470._add("one"; $e.row)
						
						This:C1470._dataModel.foregroundColor:=Foreground color:K23:1
						This:C1470["_dataModel.border"].foregroundColor:=UI.selectedColor
						
						_o_editor_ui_LISTBOX(This:C1470._dataModel.name; True:C214)
						
						//______________________________________________________
					: ($e.code=On Begin Drag Over:K2:44)
						
						//%W-533.3
						$o:=New object:C1471(\
							"name"; This:C1470.available[$e.row-1].name; \
							"tableNumber"; This:C1470.available[$e.row-1].id)
						//%W+533.3
						
						This:C1470.beginDrag("com.4d.private.4dmobile.table"; $o)
						
						//______________________________________________________
					: ($e.code=On Getting Focus:K2:7)
						
						This:C1470._dataModel.foregroundColor:=Foreground color:K23:1
						This:C1470["_dataModel.border"].foregroundColor:=UI.selectedColor
						
						//______________________________________________________
					: ($e.code=On Losing Focus:K2:8)
						
						This:C1470._dataModel.foregroundColor:=Foreground color:K23:1
						This:C1470["_dataModel.border"].foregroundColor:=UI.backgroundUnselectedColor
						
						_o_editor_ui_LISTBOX(This:C1470._dataModel.name; False:C215)
						
						//______________________________________________________
				End case 
				
				//==============================================
				// MARK: displayed
			: (This:C1470.displayed.catch())
				
				var $x : Blob
				var $o : Object
				
				//$o:=This.displayed.cellPosition($e)
				
				Case of 
						
						//______________________________________________________
					: ($e.code=On Clicked:K2:4)\
						 | ($e.code=On Selection Change:K2:29)
						
						This:C1470._updateButtons()
						
						This:C1470.displayed.foregroundColor:=Foreground color:K23:1
						This:C1470.displayedBorder.foregroundColor:=UI.selectedColor
						
						_o_editor_ui_LISTBOX(This:C1470.displayed.name; True:C214)
						
						//______________________________________________________
					: ($e.code=On Begin Drag Over:K2:44)
						
						//%W-533.3
						$o:=New object:C1471(\
							"name"; This:C1470.available[$e.row-1].name; \
							"tableNumber"; This:C1470.available[$e.row-1].id)
						//%W+533.3
						
						This:C1470.beginDrag("com.4d.private.4dmobile.table"; $o)
						
						//______________________________________________________
					: ($e.code=On Getting Focus:K2:7)
						
						This:C1470.displayed.foregroundColor:=Foreground color:K23:1
						This:C1470.displayedBorder.foregroundColor:=UI.selectedColor
						
						//______________________________________________________
					: ($e.code=On Losing Focus:K2:8)
						
						This:C1470.displayed.foregroundColor:=Foreground color:K23:1
						This:C1470.displayedBorder.foregroundColor:=UI.backgroundUnselectedColor
						
						_o_editor_ui_LISTBOX(This:C1470.displayed.name; False:C215)
						
						//______________________________________________________
				End case 
				
				//==============================================
				// MARK: addOne
			: (This:C1470.addOne.catch($e; On Clicked:K2:4))
				
				This:C1470._add("one"; This:C1470._dataModel.cellPosition($e).row)
				
				//==============================================
				// MARK: addAll
			: (This:C1470.addAll.catch($e; On Clicked:K2:4))
				
				This:C1470._add("all")
				
				//==============================================
				// MARK: removeOne
			: (This:C1470.removeOne.catch($e; On Clicked:K2:4))
				
				var $indx : Integer
				$indx:=(This:C1470.displayed.pointer)->
				
				If ($indx>0)
					
					This:C1470.displayed.deleteRows($indx)
					
				End if 
				
				This:C1470._updateOrder()
				
				//==============================================
				// MARK: removeAll
			: (This:C1470.removeAll.catch($e; On Clicked:K2:4))
				
				This:C1470.displayed.deleteRows()
				This:C1470._updateOrder()
				
				//==============================================
				// MARK: up
			: (This:C1470.up.catch($e; On Clicked:K2:4))
				
				//TODO:TODO
				
				//==============================================
				// MARK: down
			: (This:C1470.down.catch($e; On Clicked:K2:4))
				
				//TODO:TODO
				
				//==============================================
		End case 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	// Tables available in the data model
	This:C1470.available:=New collection:C1472
	
	// TODO: Add the icon
	If (Form:C1466.dataModel#Null:C1517)
		
		var $tableID : Text
		
		For each ($tableID; Form:C1466.dataModel)
			
			This:C1470.available.push(New object:C1471(\
				"type"; "table"; \
				"name"; Form:C1466.dataModel[$tableID][""].label; \
				"icon"; Form:C1466.dataModel[$tableID][""].icon; \
				"data"; $tableID; \
				"id"; $tableID))
			
		End for each 
		
		If (True:C214)
			For each ($action; Form:C1466.actions || New collection:C1472)
				
				This:C1470.available.push(New object:C1471(\
					"type"; "action"; \
					"name"; $action.name+" ("+$action.label+")"; \
					"icon"; $action.icon; \
					"data"; New object:C1471("action"; $action.name); \
					"id"; $action.name))
				
			End for each 
		End if 
		
	End if 
	
	This:C1470._dataModel.setScrollbars(0; 2).unselect()
	This:C1470.displayed.setScrollbars(0; 2).unselect()
	
	If (UI.isLocked())
		
		This:C1470._dataModel.draggable:=False:C215
		This:C1470._dataModel.selectable:=False:C215
		
		This:C1470.displayed.movableLines:=False:C215
		This:C1470.displayed.selectable:=False:C215
		This:C1470.displayed.draggable:=False:C215
		This:C1470.displayed.droppable:=False:C215
		
	Else 
		
		This:C1470._dataModel.draggable:=True:C214
		This:C1470._dataModel.selectable:=True:C214
		
		This:C1470.displayed.movableLines:=True:C214
		This:C1470.displayed.selectable:=True:C214
		This:C1470.displayed.draggable:=True:C214
		This:C1470.displayed.droppable:=True:C214
		
	End if 
	
	This:C1470._dataModel.focus()
	
	// Add the events that we cannot select in the form properties 😇
	This:C1470.appendEvents(On Row Moved:K2:32)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function saveContext($current : Object)
	
	//TODO:TODO
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function restoreContext()
	
	//TODO:TODO
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function update()
	
	var $item : Variant  // table id or other items
	
	Form:C1466.main.order:=Form:C1466.main.order || New collection:C1472
	
	// Selected tables
	This:C1470.main:=New collection:C1472
	
	For each ($item; Form:C1466.main.order)
		
		If (Value type:C1509($item)=Is text:K8:3)
			
			If (Form:C1466.dataModel[$item]#Null:C1517)
				
				This:C1470.main.push(New object:C1471(\
					"name"; Form:C1466.dataModel[$item][""].label; \
					"id"; $item))
				
			End if 
		End if 
	End for each 
	
	This:C1470.noDataModel.show(This:C1470.available.length=0)
	This:C1470.withDataModel.show(This:C1470.available.length>0)
	
	This:C1470._updateButtons()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function mainHandleEvents($e : Object)->$allow : Integer
	
	var $uri : Text
	var $o : Object
	
	$uri:="com.4d.private.4dmobile.table"
	
	$e:=$e || FORM Event:C1606
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Clicked:K2:4)\
			 | ($e.code=On Selection Change:K2:29)
			
			This:C1470._updateButtons()
			
			This:C1470.displayed.foregroundColor:=Foreground color:K23:1
			This:C1470.displayedBorder.foregroundColor:=UI.selectedColor
			
			//______________________________________________________
		: ($e.code=On Row Moved:K2:32)
			
			If (UI.isLocked())
				
				// Unable to set "movable rows" to false, so redraw
				This:C1470.update()
				
				BEEP:C151
				
			Else 
				
				This:C1470._updateOrder()
				
			End if 
			
			//______________________________________________________
		: ($e.code=On Getting Focus:K2:7)
			
			This:C1470.displayed.foregroundColor:=Foreground color:K23:1
			This:C1470.displayedBorder.foregroundColor:=UI.selectedColor
			
			//______________________________________________________
		: ($e.code=On Losing Focus:K2:8)
			
			This:C1470.displayed.foregroundColor:=Foreground color:K23:1
			This:C1470.displayedBorder.foregroundColor:=UI.backgroundUnselectedColor
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (UI.isLocked())
			
			$allow:=-1  // Reject drop
			
			//______________________________________________________
		: ($e.code=On Begin Drag Over:K2:44)
			
			//BEEP
			
			//______________________________________________________
		: ($e.code=On Drag Over:K2:13)
			
			$allow:=-1  // Reject drop
			
			// TODO: Don't allow if already present
			If (This:C1470.getPasteboard($uri)#Null:C1517)
				
				$allow:=0
				
			End if 
			
			If ($allow=-1)
				
				SET CURSOR:C469(9019)
				
				// This.dropCursor.hide()
				
			Else 
				
				//$me:=This.displayed
				//If ($e.row=-1)  // After the last line
				//If ($o.src#$me.rowsNumber)  // Not if the source was the last line
				//$o:=$me.rowCoordinates($me.rowsNumber)
				//$o.top:=$o.bottom
				//$o.right:=$me.coordinates.right
				//$allow:=0  // Allow drop
				// End if
				// Else
				//If ($o.src#$e.row)\
																																																																																															& ($e.row#($o.src+1))  // Not the same or the next one
				//$o:=$me.rowCoordinates($e.row)
				//$o.bottom:=$o.top
				//$o.right:=$me.coordinates.right
				//$allow:=0  // Allow drop
				// End if
				// End if
				//This.dropCursor.setCoordinates($o.left; $o.top; $o.right; $o.bottom)
				// This.dropCursor.show()
				
			End if 
			
			//______________________________________________________
		: ($e.code=On Drop:K2:12)
			
			$o:=This:C1470.getPasteboard($uri)
			
			If ($o#Null:C1517)
				
				$o.tgt:=Drop position:C608
				
				If ($o.tgt=-1)  // After the last line
					
					// This.action.parameters.push(This.current)
					//This.action.parameters.remove($o.src-1)
					
					This:C1470.__add($o.tableNumber; $o.name)
					
				Else 
					
					//This.action.parameters.insert($o.tgt-1; This.current)
					//If ($o.tgt<$o.src)
					//This.action.parameters.remove($o.src)
					// Else
					//This.action.parameters.remove($o.src-1)
					// End if
					
					This:C1470.__add($o.tableNumber; $o.name; $o.tgt)
					
				End if 
				
				This:C1470._updateOrder()
				
				// This.dropCursor.hide()
				// This.displayed.touch()
				
			End if 
			
			//______________________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function _updateButtons()
	
	If (UI.isLocked())
		
		This:C1470.addOne.disable()
		This:C1470.addAll.disable()
		This:C1470.removeOne.disable()
		This:C1470.removeAll.disable()
		
	Else 
		
		This:C1470.addOne.enable((This:C1470.available.length>Form:C1466.main.order.length) && (This:C1470._dataModel.selected()>0))
		This:C1470.addAll.enable(This:C1470.available.length>Form:C1466.main.order.length)
		This:C1470.removeOne.enable(This:C1470.displayed.selected()>0)
		This:C1470.removeAll.enable(Form:C1466.main.order.length>0)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function _add($target : Text; $row : Integer)
	
	var $i : Integer
	
	$target:=$target || "one"
	
	If ($target="one")
		
		$row:=$row || (This:C1470._dataModel.pointer)->
		
		If ($row>0)
			
			This:C1470.__add(This:C1470.available[$row-1].id; This:C1470.available[$row-1].name; This:C1470.displayed.selectedIndex)
			
		End if 
		
	Else 
		
		For ($i; 1; This:C1470.available.length; 1)
			
			If (This:C1470.main.extract("id").indexOf(This:C1470.available[$i-1].id)>0)
				
				continue
				
			End if 
			
			This:C1470.__add(This:C1470.available[$i-1].id; This:C1470.available[$i-1].name)
			
		End for 
	End if 
	
	This:C1470._updateOrder()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function __add($id : Text; $name : Text; $row : Integer)
	var $obj : Object
	$obj:=New object:C1471("id"; $id; "name"; $name)
	If (This:C1470.main.extract("id").indexOf($id)=-1)
		
		If ($row>0)
			
			This:C1470.main.insert($row; $obj)
			
		Else 
			
			This:C1470.main.push($obj)
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function _updateOrder()
	
	var $index : Integer
	var $item
	var $order : Collection
	
	$order:=Form:C1466.main.order.copy()  // Current order
	
	Form:C1466.main.order:=This:C1470.main.extract("id")
	
	If (Feature.with("openURLActionsInTabBar"))
		
		For each ($item; $order)
			
			If (Form:C1466.main.order.indexOf($item)<0)
				
				// Maybe removed or unknow item type
				If (Value type:C1509($item)=Is object:K8:27)  // Currently object are ignored
					
					Form:C1466.main.order.insert($index; $item)  // Try to put at same pos, not really smart like a Diffable algo
					
				End if 
			End if 
			
			$index+=1
			
		End for each 
		
	End if 
	
	If (Not:C34(Form:C1466.main.order.equal($order)))
		
		PROJECT.save()
		
	End if 
	
	This:C1470.update()
	