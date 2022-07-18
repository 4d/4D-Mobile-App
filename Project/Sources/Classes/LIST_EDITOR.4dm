Class extends form

Class constructor  //($formData : Object)
	
	Super:C1705()
	
	//keep the old name
	This:C1470.name:=Form:C1466.name
	
	This:C1470.init()
	This:C1470.onLoad()
	
	//MARK:-COMPUTED ATTRIBUTES
	// === === === === === === === === === === === === === === === === === === === === ===
Function get format()->$value : Text
	
	If (This:C1470.formatDropdown#Null:C1517)
		
		$value:=This:C1470.formatDropdown.binding[This:C1470.formatDropdown.index]
		
	End if 
	
	//MARK:-FUNCTIONS
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Design definition
Function init()
	
	var $t : Text
	var $group : cs:C1710.group
	var $c : Collection
	
	If (This:C1470.toBeInitialized)
		
		This:C1470.toBeInitialized:=False:C215
		
		// Datasource type
		This:C1470.static:=Bool:C1537(Form:C1466.dial.static)
		This:C1470.dynamic:=Not:C34(This:C1470.static)
		
		This:C1470.input("name")
		This:C1470.formObject("nameEdge")
		This:C1470.button("revealFolder")
		This:C1470.formObject("controlAlreadyExists")
		
		// Format dropdown
		This:C1470.selector("formatDropdown")
		This:C1470.formatDropdown.binding:=New collection:C1472("push"; "segmented"; "popover"; "sheet"; "picker")
		
		$c:=New collection:C1472  // Localization
		
		For each ($t; This:C1470.formatDropdown.binding)
			
			$c.push(Get localized string:C991("_"+$t))
			
		End for each 
		
		This:C1470.formatDropdown.values:=$c
		This:C1470.formatDropdown.current:=Get localized string:C991("select")
		
		$group:=This:C1470.group("linkedWith")
		This:C1470.button("label").addToGroup($group)
		This:C1470.button("image").addToGroup($group)
		This:C1470.linkedWith.distributeLeftToRight()  // Adjust button size
		
		This:C1470.formObject("binding_")
		This:C1470.formObject("value_")
		This:C1470.formObject("label_")
		This:C1470.listbox("list"; "choiceList").setScrollbars(0; 2)
		This:C1470.formObject("choiceListBorder")
		This:C1470.button("add")
		This:C1470.button("remove").disable()
		
		This:C1470.formObject("dropCursor")
		
		This:C1470.formObject("table.label")
		This:C1470.formObject("field.label")
		This:C1470.listbox("dataclasses").setScrollbars(0; 2)
		This:C1470.listbox("attributes").setScrollbars(0; 2)
		This:C1470.formObject("datasourceBorder")
		
		$group:=This:C1470.group("buttons")
		This:C1470.button("ok").disable().addToGroup($group)
		This:C1470.button("cancel").addToGroup($group)
		$group.distributeRigthToLeft()  // Adjust button size
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	This:C1470.appendEvents(On Double Clicked:K2:5; On Selection Change:K2:29)  // Allow double click to edit list items
	
	This:C1470.dropCursor.foregroundColor:=Highlight menu background color:K23:7
	
	This:C1470.controlAlreadyExists.foregroundColor:=UI.errorRGB
	
	// Select the format (push if not defined)
	Form:C1466.format:=Form:C1466.format#Null:C1517 ? Form:C1466.format : "push"
	This:C1470.formatDropdown.current:=Form:C1466.format
	
	
	// Select binding type
	This:C1470.label.setValue(Not:C34(Bool:C1537(Form:C1466.binding)))
	
	// Define the format of the keys column
	This:C1470.setKeyType()
	
	If (This:C1470.static)
		
		// Fill in the values of the choice list, if it exists, or create an empty list.
		This:C1470.choiceList:=Form:C1466.choiceList#Null:C1517 ? OB Entries:C1720(Form:C1466.choiceList) : New collection:C1472
		
	Else 
		
		This:C1470.goToPage(2)
		
		// Initialize database structure
		Form:C1466.dial.dataclasses:=PROJECT.getCatalog()
		This:C1470.dataclasses.selectFirstRow()
		
		//Form.dial.attributes:=Form.dial.dataclasses[0].field
		This:C1470.attributes.selectFirstRow()
		
	End if 
	
	// Go to name box
	This:C1470.name.focus().highlight()
	This:C1470.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function update()
	
	var $isValid : Boolean
	
	SET TIMER:C645(0)
	
	ASSERT:C1129(Not:C34(Shift down:C543))
	
	// Name is mandatory
	This:C1470.nameEdge.foregroundColor:=(This:C1470.name.getValue()="") ? UI.errorRGB : UI.backgroundUnselectedColor
	This:C1470.revealFolder.show((Form:C1466.dial.folder#Null:C1517) && (Form:C1466.dial.folder.exists))
	
	Form:C1466.binding:=This:C1470.image.getValue()
	
	If (This:C1470.static)
		
		$isValid:=(This:C1470.choiceList.length>0)
		This:C1470.remove.enable($isValid & (This:C1470.list.itemPosition>0))
		
		// Limit to 2 lines for booleans
		This:C1470.add.enable((Form:C1466.type#"bool") || (This:C1470.choiceList=Null:C1517 ? True:C214 : This:C1470.choiceList.length<2))
		
	Else 
		
		$isValid:=(Form:C1466.choiceList.dataSource.dataClass#Null:C1517)\
			 & (Form:C1466.choiceList.dataSource.field#Null:C1517)
		
		This:C1470.add.enable()
		
	End if 
	
	This:C1470.ok.enable((Length:C16(Form:C1466.name)>0) & $isValid)
	
	// === === === === === === === === === === === === === === === === === === === === ===
	//Define the format of the value column
Function setKeyType($type : Integer)
	
	var $t : Text
	
	$t:=LISTBOX Get column formula:C1202(*; "keys")
	
	If ($type=0)
		
		Case of 
				
				//______________________________________________________
			: ((Form:C1466.type="bool")\
				 | (Form:C1466.type="boolean"))
				
				$type:=Is boolean:K8:9
				
				//________________________________________
			: ((Form:C1466.type="number")\
				 | (Form:C1466.type="integer")\
				 | (Form:C1466.type="real"))
				
				$type:=Is real:K8:4
				
				//________________________________________
			: ((Form:C1466.type="string")\
				 | (Form:C1466.type="text"))
				
				$type:=Is text:K8:3
				
				//______________________________________________________
		End case 
	End if 
	
	LISTBOX SET COLUMN FORMULA:C1203(*; "keys"; $t; $type)
	
	Case of 
			
			//______________________________________________________
		: ($type=Is boolean:K8:9)
			
			OBJECT SET FORMAT:C236(*; "keys"; Get localized string:C991("trueFalse"))
			
			//________________________________________
		: ($type=Is real:K8:4)
			
			OBJECT SET FORMAT:C236(*; "keys"; "")
			
			//________________________________________
		: ($type=Is text:K8:3)
			
			OBJECT SET FORMAT:C236(*; "keys"; "")
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function setDatasource()
	
	Form:C1466.choiceList:=Form:C1466.choiceList#Null:C1517 ? Form:C1466.choiceList : New object:C1471
	Form:C1466.choiceList.dataSource:=Form:C1466.choiceList.dataSource#Null:C1517 ? Form:C1466.choiceList.dataSource : New object:C1471
	
	If (This:C1470.dataclasses.item#Null:C1517)
		
		Form:C1466.choiceList.dataSource.dataClass:=This:C1470.dataclasses.item.name
		
		If (This:C1470.attributes.item#Null:C1517)
			
			Form:C1466.choiceList.dataSource.field:=This:C1470.attributes.item.name
			
		Else 
			
			OB REMOVE:C1226(Form:C1466.choiceList.dataSource; "field")
			
		End if 
		
	Else 
		
		OB REMOVE:C1226(Form:C1466.choiceList.dataSource; "dataClass")
		OB REMOVE:C1226(Form:C1466.choiceList.dataSource; "field")
		
	End if 
	
	This:C1470.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function doLinkedTo()
	
	var $autoDrag; $autoDrop; $drag; $drop : Boolean
	
	If (This:C1470.image.getValue())
		
		If (Form:C1466.dial.folder#Null:C1517)
			
			This:C1470.label_.setTitle("image")
			This:C1470.setKeyType(Is text:K8:3)
			
			OBJECT GET DRAG AND DROP OPTIONS:C1184(*; "value"; $drag; $autoDrag; $drop; $autoDrop)
			OBJECT SET DRAG AND DROP OPTIONS:C1183(*; "value"; True:C214; $autoDrag; True:C214; $autoDrop)
			
			Form:C1466.dial.folder.folder("images").create()
			
		Else 
			
			BEEP:C151
			
			This:C1470.label.setValue(True:C214)
			This:C1470.image.setValue(False:C215)
			This:C1470.name.focus()
			
		End if 
		
	Else 
		
		This:C1470.label_.setTitle("label")
		This:C1470.setKeyType()
		
		OBJECT GET DRAG AND DROP OPTIONS:C1184(*; "value"; $drag; $autoDrag; $drop; $autoDrop)
		OBJECT SET DRAG AND DROP OPTIONS:C1183(*; "value"; $drag; $autoDrag; False:C215; $autoDrop)
		
	End if 
	
	This:C1470.list.touch()
	This:C1470.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function doAdd()
	
	var $length : Integer
	var $o : Object
	
	This:C1470.choiceList:=This:C1470.choiceList=Null:C1517 ? New collection:C1472 : This:C1470.choiceList
	$length:=This:C1470.choiceList.length+1
	
	//todo:localize 🌎
	If (This:C1470.image.getValue())
		
		$o:=New object:C1471(\
			"key"; "value "+String:C10($length); \
			"value"; "Edit or drop an image")
		
	Else 
		
		Case of 
				
				//______________________________________________________
			: ((Form:C1466.type="bool")\
				 | (Form:C1466.type="boolean"))
				
				$o:=This:C1470.choiceList.query("key = :1"; "false").pop()
				
				$o:=New object:C1471(\
					"key"; $o=Null:C1517 ? "false" : "true"; \
					"value"; Get localized string:C991("label")+String:C10($length; " ###0"))
				
				//________________________________________
			: ((Form:C1466.type="number")\
				 | (Form:C1466.type="integer")\
				 | (Form:C1466.type="real"))
				
				$o:=New object:C1471(\
					"key"; "value "+String:C10($length); \
					"value"; Get localized string:C991("label")+String:C10($length; " ###0"))
				
				//________________________________________
			: ((Form:C1466.type="string")\
				 | (Form:C1466.type="text"))
				
				$o:=New object:C1471(\
					"key"; Get localized string:C991("value")+String:C10($length; " ###0"); \
					"value"; Get localized string:C991("label")+String:C10($length; " ###0"))
				
				//______________________________________________________
		End case 
	End if 
	
	$o.button:=New object:C1471("value"; "…"; "behavior"; "alternateButton")
	
	This:C1470.choiceList.push($o)
	
	This:C1470.list.selectLastRow().edit()
	This:C1470.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function doRemove()
	
	var $index : Integer
	
	$index:=This:C1470.choiceList.indexOf(This:C1470.list.item)
	This:C1470.choiceList.remove($index; 1)
	This:C1470.list.doSafeSelect($index+1)
	This:C1470.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Manage Choice list D&D
Function doStaticDragAndDrop()->$allowed : Integer
	
	var $document : Text
	var $e : Object
	var $src : 4D:C1709.File
	var $tgt : 4D:C1709.Folder
	
	$allowed:=-1  // 💪 We manage data entry
	$e:=FORM Event:C1606
	
	If (This:C1470.image.getValue())
		
		$document:=Get file from pasteboard:C976(1)
		
		If ($document#"")
			
			If (Is picture file:C1113($document))
				
				// Allow
				$allowed:=0
				
				If ($e.code=On Drop:K2:12)
					
					$src:=File:C1566($document; fk platform path:K87:2)
					$tgt:=Form:C1466.dial.folder.folder("images")
					
					If ($src.parent.path#$tgt.path)
						
						$src.copyTo($tgt; fk overwrite:K87:5)
						
					End if 
					
					This:C1470.list.focus()  // Give focus to the list
					This:C1470.list.autoSelect()  // Select, if any
					
					// Update the value
					This:C1470.list.item.value:=$src.fullName
					
					This:C1470.releaseCursor()
					This:C1470.list.touch()  // Redraw
					
				Else   //On Drag Over
					
					This:C1470.setCursorDragCopy()
					
				End if 
			End if 
		End if 
	End if 
	
	//If ($allowed=-1)  //test for an internal D&D
	//var $x : Blob
	//var $o; $list : Object
	//$list:=This.list
	//// Get the pastboard
	//GET PASTEBOARD DATA("com.4d.private.4dmobile.choicelist"; $x)
	//If (Bool(OK))
	//If ($e.code=On Drop)
	//If (Bool(OK))
	//BLOB TO VARIABLE($x; $o)
	//SET BLOB SIZE($x; 0)
	//$o.tgt:=Drop position
	//End if 
	//If ($o.src#$o.tgt)
	//If ($o.tgt=-1)  // After the last line
	//Form._choiceList.push($list.item)
	//Form._choiceList.remove($o.src-1)
	//Else 
	//Form._choiceList.insert($o.tgt-1; $list.item)
	//If ($o.tgt<$o.src)
	//Form._choiceList.remove($o.src)
	//Else 
	//Form._choiceList.remove($o.src-1)
	//End if 
	//End if 
	//End if 
	//This.dropCursor.hide()
	//Else 
	//If ($e.row=-1)  // After the last line
	//$rows:=$list.rowsNumber
	//If ($o.src#$rows)  // Not if the source was the last line
	//$allowed:=0
	//$o:=$list.rowCoordinates($rows)
	//$o.top:=$o.bottom
	//$o.right:=$list.coordinates.right
	//End if 
	//Else 
	//If ($o.src#$e.row)\
				 & ($e.row#($o.src+1))  // Not the same or the next one
	//$allowed:=0
	//$o:=$list.rowCoordinates($e.row)
	//$o.bottom:=$o.top
	//$o.right:=$list.coordinates.right
	//End if 
	//End if 
	//If ($allowed=-1)
	//This.dropCursor.hide()
	//Else 
	//This.dropCursor.setCoordinates($o.left; $o.top; $o.right; $o.bottom)
	//This.dropCursor.show()
	//End if 
	//End if 
	//End if 
	//End if 
	//If ($e.code=On Drag Over)
	//If ($allowed)
	//This.setCursor(9016)
	//Else 
	//This.setCursor(9019)
	//End if 
	//Else 
	//This.setCursor()
	////$list.touch()
	//End if 
	
	This:C1470.setCursorNotAllowed($allowed=-1)
	
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Initialization of the internal D&D for actions
Function doBeginDrag()
	
	var $uri : Text
	$uri:=""
	
	This:C1470.beginDrag($uri; New object:C1471(\
		"src"; This:C1470.list.itemPosition))
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Choice list Meta info expression
Function listMeta($this : Object)->$style
	
	$style:=New object:C1471(\
		"stroke"; "Automatic"; \
		"fontWeight"; "normal"; \
		"cell"; New object:C1471(\
		"values"; New object:C1471; \
		"keys"; New object:C1471))
	
	If (This:C1470.choiceList.query("key = :1"; $this.key).length>1)
		
		$style.cell.keys.stroke:=UI.errorRGB
		
	End if 
	
	If (This:C1470.image.getValue())  // Test the file
		
		If (Not:C34(Form:C1466.dial.folder.file("images/"+$this.value).exists))
			
			$style.cell.values.stroke:=UI.errorRGB
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// <Background Color Expression>
Function listBackgroundColor($this : Object)->$color
	
	var $v  // could be an integer or a text
	var $isFocused : Boolean
	
	$color:="transparent"
	
	If (Num:C11(This:C1470.list.itemPosition)#0)
		
		$isFocused:=(OBJECT Get name:C1087(Object with focus:K67:3)=This:C1470.list.name)
		
		If (ob_equal(This:C1470.list.item; $this))  // Selected row
			
			$color:=Choose:C955($isFocused; UI.backgroundSelectedColor; UI.alternateSelectedColor)
			
		Else 
			
			$color:=$isFocused ? UI.highlightColor : UI.highlightColorNoFocus
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	