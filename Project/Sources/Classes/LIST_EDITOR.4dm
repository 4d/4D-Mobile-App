Class extends form

Class constructor
	
	Super:C1705()
	
	//keep the old name
	This:C1470.name:=Form:C1466.name
	
	This:C1470.init()
	This:C1470.onLoad()
	
	//MARK:-COMPUTED ATTRIBUTES
	// === === === === === === === === === === === === === === === === === === === === ===
Function get format()->$value : Text
	
	If (This:C1470.formatDropdown#Null:C1517)
		
		$value:=This:C1470.formatDropdown.data.binding[This:C1470.formatDropdown.data.index]
		
	End if 
	
	//MARK:-FUNCTIONS
	// === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	var $t : Text
	var $group : cs:C1710.group
	
	If (This:C1470.toBeInitialized)
		
		This:C1470.toBeInitialized:=False:C215
		
		This:C1470.input("name")
		This:C1470.formObject("nameEdge")
		This:C1470.button("revealFolder")
		
		This:C1470.selector("formatDropdown")
		This:C1470.formatDropdown.binding:=New collection:C1472("push"; "segmented"; "popover"; "sheet"; "picker")
		
		// Localization
		var $c : Collection
		$c:=New collection:C1472
		
		For each ($t; This:C1470.formatDropdown.binding)
			
			$c.push(Get localized string:C991("_"+$t))
			
		End for each 
		
		This:C1470.formatDropdown.values:=$c
		This:C1470.formatDropdown.current:=Get localized string:C991("select")
		
		$group:=This:C1470.group("source")
		This:C1470.button("static").addToGroup($group)
		This:C1470.button("datasource").addToGroup($group)
		This:C1470.source.distributeLeftToRight()  // Adjust button size
		
		$group:=This:C1470.group("binding")
		This:C1470.button("label").addToGroup($group)
		This:C1470.button("image").addToGroup($group)
		This:C1470.binding.distributeLeftToRight()  // Adjust button size
		
		This:C1470.formObject("_binding").addToGroup($group)
		This:C1470.formObject("_value").addToGroup($group)
		This:C1470.formObject("_label").addToGroup($group)
		This:C1470.listbox("list"; "choiceList").setScrollbars(0; 2).addToGroup($group)
		This:C1470.button("add").addToGroup($group)
		This:C1470.button("remove").addToGroup($group).disable()
		$group.hide()  // Hide all elements
		
		This:C1470.formObject("dropCursor")
		
		$group:=This:C1470.group("dataclass")
		This:C1470.formObject("_table").addToGroup($group)
		This:C1470.formObject("_fields").addToGroup($group)
		This:C1470.listbox("dataclasses").setScrollbars(0; 2).addToGroup($group)
		This:C1470.listbox("attributes").setScrollbars(0; 2).addToGroup($group)
		$group.hide()  // Hide all elements
		
		$group:=This:C1470.group("buttons")
		This:C1470.button("ok").disable().addToGroup($group)
		This:C1470.button("cancel").addToGroup($group)
		$group.distributeRigthToLeft()  // Adjust button size
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	This:C1470.appendEvents(On Double Clicked:K2:5)  // Allow double click to edit list items
	
	This:C1470.dropCursor.setColors(Highlight menu background color:K23:7)
	
	// Select the format (push if not defined)
	Form:C1466.format:=Form:C1466.format#Null:C1517 ? Form:C1466.format : "push"
	This:C1470.formatDropdown.current:=Form:C1466.format
	
	// Select the datasource type
	This:C1470.static.setValue(Form:C1466.choiceList.dataSource=Null:C1517)
	
	// Select binding type
	This:C1470.label.setValue(Form:C1466.binding=Null:C1517)
	
	// Define the format of the keys column
	This:C1470.setValueType()
	
	// Populate the choice list values, if exists
	Form:C1466._choiceList:=Form:C1466.choiceList#Null:C1517 ? OB Entries:C1720(Form:C1466.choiceList) : New collection:C1472
	
	// Initialize database structure MARK:FILTER?
	//todo:Only if necessary
	If (Value type:C1509(PROJECT)#Is undefined:K8:13)
		
		Form:C1466._dataclasses:=PROJECT.getCatalog()
		This:C1470.dataclasses.select(1)
		Form:C1466._attributes:=Form:C1466._dataclasses[0].field
		This:C1470.attributes.select(1)
		
	End if 
	
	// Go to name box
	This:C1470.name.focus().highlight()
	
	//fixme:In works
	This:C1470.datasource.disable()
	
	This:C1470.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function update()
	
	var $isValid : Boolean
	
	SET TIMER:C645(0)
	
	// Name is mandatory
	This:C1470.nameEdge.setColors((This:C1470.name.getValue()="") ? EDITOR.errorRGB : 0x00C0C0C0)
	This:C1470.revealFolder.show((Form:C1466._folder#Null:C1517) && (Form:C1466._folder.exists))
	
	Form:C1466._static:=This:C1470.static.getValue()
	Form:C1466.binding:=This:C1470.image.getValue()
	
	If (Form:C1466._static)
		
		This:C1470.binding.show()
		This:C1470.dataclass.hide()
		
		$isValid:=(Form:C1466._choiceList.length>0)
		This:C1470.remove.enable($isValid & (This:C1470.list.itemPosition>0))
		
		// Limit to 2 lines for booleans
		This:C1470.add.enable(Form:C1466.type#"bool" || (Form:C1466._choiceList=Null:C1517 ? True:C214 : Form:C1466._choiceList.length<2))
		
	Else 
		
		This:C1470.binding.hide()
		This:C1470.dataclass.show()
		
		If (Form:C1466._dataclasses=Null:C1517)
			
			Form:C1466._dataclasses:=PROJECT.getCatalog()
			Form:C1466._attributes:=Form:C1466._dataclasses[0].field
			
			This:C1470.dataclasses.selectFirstRow()
			
		End if 
		
		$isValid:=(Form:C1466.choiceList.dataSource.dataClass#Null:C1517)\
			 & (Form:C1466.choiceList.dataSource.field#Null:C1517)
		
		This:C1470.add.enable()
		
	End if 
	
	This:C1470.ok.enable((Length:C16(Form:C1466.name)>0) & $isValid)
	
	// === === === === === === === === === === === === === === === === === === === === ===
	//Define the format of the value column
Function setValueType($type : Integer)
	
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
	
	If (Form:C1466._dataclassesItem#Null:C1517)
		
		If (Form:C1466.choiceList.dataSource=Null:C1517)
			
			Form:C1466.choiceList.dataSource:=New object:C1471("dataClass"; Form:C1466._dataclassesItem.name)
			
		Else 
			
			Form:C1466.choiceList.dataSource.dataClass:=Form:C1466._dataclassesItem.name
			
		End if 
		
		If (Form:C1466._attributesItem#Null:C1517)
			
			Form:C1466.choiceList.dataSource.field:=Form:C1466._attributesItem.name
			
		Else 
			
			OB REMOVE:C1226(Form:C1466.choiceList.dataSource; "field")
			
		End if 
		
	Else 
		
		If (Form:C1466.choiceList.dataSource#Null:C1517)
			
			OB REMOVE:C1226(Form:C1466.choiceList.dataSource; "dataClass")
			OB REMOVE:C1226(Form:C1466.choiceList.dataSource; "field")
			
		End if 
	End if 
	
	This:C1470.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function doType()
	
	var $autoDrag; $autoDrop; $drag; $drop : Boolean
	
	If (This:C1470.image.getValue())
		
		If (Form:C1466._folder#Null:C1517)
			
			This:C1470._label.setTitle("image")
			This:C1470.setValueType(Is text:K8:3)
			
			OBJECT GET DRAG AND DROP OPTIONS:C1184(*; "value"; $drag; $autoDrag; $drop; $autoDrop)
			OBJECT SET DRAG AND DROP OPTIONS:C1183(*; "value"; True:C214; $autoDrag; True:C214; $autoDrop)
			
			Form:C1466._folder.folder("images").create()
			
		Else 
			
			BEEP:C151
			
			This:C1470.label.setValue(True:C214)
			This:C1470.image.setValue(False:C215)
			This:C1470.name.focus()
			
		End if 
		
	Else 
		
		This:C1470._label.setTitle("label")
		This:C1470.setValueType()
		
		OBJECT GET DRAG AND DROP OPTIONS:C1184(*; "value"; $drag; $autoDrag; $drop; $autoDrop)
		OBJECT SET DRAG AND DROP OPTIONS:C1183(*; "value"; $drag; $autoDrag; False:C215; $autoDrop)
		
	End if 
	
	This:C1470.list.touch()
	This:C1470.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function doAdd()
	
	var $length : Integer
	var $o : Object
	
	Form:C1466._choiceList:=Form:C1466._choiceList=Null:C1517 ? New collection:C1472 : Form:C1466._choiceList
	$length:=Form:C1466._choiceList.length+1
	
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
				
				$o:=Form:C1466._choiceList.query("key = :1"; "false").pop()
				
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
	
	Form:C1466._choiceList.push($o)
	
	This:C1470.list.selectLastRow().edit()
	This:C1470.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function doRemove()
	
	var $index : Integer
	
	$index:=Form:C1466._choiceList.indexOf(This:C1470.list.item)
	Form:C1466._choiceList.remove($index; 1)
	This:C1470.list.doSafeSelect($index+1)
	This:C1470.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Manage Choice list D&D
Function doStaticDragAndDrop()->$allowed : Integer
	
	var $document : Text
	var $e : Object
	var $file : 4D:C1709.File
	var $folder : 4D:C1709.Folder
	
	$allowed:=-1  // 💪 We manage data entry
	This:C1470.setCursor(9019)
	
	$e:=FORM Event:C1606
	
	If (This:C1470.image.getValue())
		
		$document:=Get file from pasteboard:C976(1)
		
		If ($document#"")
			
			If (Is picture file:C1113($document))
				
				// Allow
				$allowed:=0
				
				If ($e.code=On Drop:K2:12)
					
					$file:=File:C1566($document; fk platform path:K87:2)
					$folder:=Form:C1466._folder.folder("images")
					
					If ($file.parent.path#$folder.path)
						
						$file.copyTo($folder; fk overwrite:K87:5)
						
					End if 
					
					//todo:Convert to PNG?
					//todo:Set dimensions?
					
					This:C1470.list.focus()  // Give focus to the list
					This:C1470.list.autoSelect()  // Select, if any
					
					// Update the value
					This:C1470.list.item.value:=$file.fullName
					
					This:C1470.setCursor()
					This:C1470.list.touch()  // Redraw
					
				Else 
					
					This:C1470.setCursor(9016)
					
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
	//$rows:=$list.rowsNumber()
	//If ($o.src#$rows)  // Not if the source was the last line
	//$allowed:=0
	//$o:=$list.getRowCoordinates($rows)
	//$o.top:=$o.bottom
	//$o.right:=$list.coordinates.right
	//End if 
	//Else 
	//If ($o.src#$e.row)\
						 & ($e.row#($o.src+1))  // Not the same or the next one
	//$allowed:=0
	//$o:=$list.getRowCoordinates($e.row)
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
	
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Initialization of the internal D&D for actions
Function doBeginDrag()
	
	var $x : Blob
	var $o : Object
	
	$o:=New object:C1471(\
		"src"; This:C1470.list.itemPosition)
	
	// Put into the container
	VARIABLE TO BLOB:C532($o; $x)
	APPEND DATA TO PASTEBOARD:C403("com.4d.private.4dmobile.choicelist"; $x)
	SET BLOB SIZE:C606($x; 0)
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Choice list Meta info expression
Function staticMeta($this : Object)->$style
	
	$style:=New object:C1471(\
		"stroke"; Choose:C955(EDITOR.isDark; "white"; "black"); \
		"fontWeight"; "normal"; \
		"cell"; New object:C1471(\
		"values"; New object:C1471; \
		"keys"; New object:C1471))
	
	If (Form:C1466._choiceList.query("key = :1"; $this.key).length>1)
		
		$style.cell.keys.stroke:=EDITOR.errorRGB
		
	End if 
	
	If (This:C1470.image.getValue())  // Test the file
		
		If (Not:C34(Form:C1466._folder.file("images/"+$this.value).exists))
			
			$style.cell.values.stroke:=EDITOR.errorRGB
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===