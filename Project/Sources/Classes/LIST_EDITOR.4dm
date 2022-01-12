Class extends form

Class constructor
	
	Super:C1705()
	
	//todo: localize values?
	This:C1470.formats:=New object:C1471
	This:C1470.formats.values:=New collection:C1472("Push"; "Segmented"; "Popover"; "Sheet"; "Picker")
	This:C1470.formats.binding:=New collection:C1472("push"; "segmented"; "popover"; "sheet"; "picker")
	This:C1470.formats.currentValue:=Get localized string:C991("select")
	This:C1470.formats.index:=-1
	
	//This.types:=New object
	//This.types.values:=New collection("string"; "bool"; "number")
	//This.types.binding:=New collection("string"; "bool"; "number")
	//This.types.currentValue:=Get localized string("select")
	//This.types.index:=-1
	
	This:C1470.init()
	This:C1470.onLoad()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get format()->$value : Text
	
	
	//mark:🐞 turn around
	//If ((This.formats#Null)\
		 && (This.formats.binding#Null)\
		 && (This.formats.index#Null)\
		 && Num(This.formats.index)>=0\
		 && Num(This.formats.index)<This.formats.binding.length)
	
	$value:=This:C1470.formats.binding[Num:C11(This:C1470.formats.index)]
	
	//End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	var $group : cs:C1710.group
	
	If (This:C1470.toBeInitialized)
		
		This:C1470.toBeInitialized:=False:C215
		
		This:C1470.input("name")
		
		This:C1470.widget("formatDropdown")
		
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
	
	If (Form:C1466.choiceList=Null:C1517)  //#TEMPO
		
		Case of 
				
				//______________________________________________________
			: ((Form:C1466.type="bool")\
				 | (Form:C1466.type="boolean"))
				
				Form:C1466.choiceList:=New object:C1471(\
					"0"; "False"; \
					"1"; "True")
				
				//________________________________________
			: ((Form:C1466.type="number")\
				 | (Form:C1466.type="integer")\
				 | (Form:C1466.type="real"))
				
				Form:C1466.choiceList:=New object:C1471(\
					"0"; "zero"; \
					"1"; "one"; \
					"2"; "two")
				
				//________________________________________
			: ((Form:C1466.type="string")\
				 | (Form:C1466.type="text"))
				
				Form:C1466.choiceList:=New object:C1471(\
					"value1"; "Displayed value1"; \
					"value2"; "Displayed value2")
				
				//______________________________________________________
		End case 
	End if 
	
	This:C1470.appendEvents(On Double Clicked:K2:5)
	
	// Select the format (push if not defined)
	Form:C1466.format:=Form:C1466.format#Null:C1517 ? Form:C1466.format : "push"  // 
	This:C1470.formats.index:=This:C1470.formats.binding.indexOf(Form:C1466.format)
	This:C1470.formats.currentValue:=This:C1470.formats.values[This:C1470.formats.index]
	
	// Select the datasource type
	This:C1470.static.setValue(Form:C1466.choiceList.dataSource=Null:C1517)
	
	// Select binding type
	This:C1470.label.setValue(Form:C1466.binding=Null:C1517)
	
	// Populate the choice list values
	Form:C1466._choiceList:=OB Entries:C1720(Form:C1466.choiceList)
	
	// Initialize database structure MARK:FILTER?
	Form:C1466._dataclasses:=PROJECT.getCatalog()
	This:C1470.dataclasses.select(1)
	Form:C1466._attributes:=Form:C1466._dataclasses[0].field
	This:C1470.attributes.select(1)
	
	// Go to name box
	This:C1470.name.focus().highlight()
	
	This:C1470.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function update()
	
	var $isValid : Boolean
	var $folder : Object
	
	SET TIMER:C645(0)
	
	If (Length:C16(Form:C1466.name)>0)
		
		$folder:=Form:C1466._host.folder(EDITOR.str.setText(Form:C1466.name).suitableWithFileName())
		
		If (Form:C1466._folder.exists)
			
			//todo:🚧 DISPLAY AN ERROR
			BEEP:C151
			
			OB REMOVE:C1226(Form:C1466; "_folder")
			This:C1470.name.focus().highlight()
			
		Else 
			
			Form:C1466._folder:=$folder
			$isValid:=True:C214
			
		End if 
		
	Else 
		
		OB REMOVE:C1226(Form:C1466; "_folder")
		This:C1470.name.focus()
		
	End if 
	
	Form:C1466._static:=This:C1470.static.getValue()
	Form:C1466.binding:=This:C1470.image.getValue()
	
	If (Form:C1466._static)
		
		This:C1470.binding.show()
		This:C1470.dataclass.hide()
		
		$isValid:=$isValid\
			 & (Form:C1466._choiceList.length>0)
		
		This:C1470.remove.enable(This:C1470.list.item#Null:C1517)
		
	Else 
		
		If (Form:C1466._dataclasses=Null:C1517)
			
			Form:C1466._dataclasses:=PROJECT.getCatalog()
			Form:C1466._attributes:=Form:C1466._dataclasses[0].field
			
			This:C1470.dataclasses.select(1)
			
		End if 
		
		This:C1470.binding.hide()
		This:C1470.dataclass.show()
		
		$isValid:=$isValid\
			 & (Form:C1466.choiceList.dataSource.dataClass#Null:C1517)\
			 & (Form:C1466.choiceList.dataSource.field#Null:C1517)
		
	End if 
	
	This:C1470.ok.enable($isValid)
	
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
Function doAdd()
	
	var $length : Integer
	var $o : Object
	
	Form:C1466._choiceList:=Form:C1466._choiceList=Null:C1517 ? New collection:C1472 : Form:C1466._choiceList
	$length:=Form:C1466._choiceList.length+1
	
	//mark:🌎 to localize
	If (This:C1470.image.getValue())
		
		$o:=New object:C1471(\
			"key"; "value "+String:C10($length); \
			"value"; "Browse…")
		
	Else 
		
		$o:=New object:C1471(\
			"key"; "value "+String:C10($length); \
			"value"; "label "+String:C10($length))
		
	End if 
	
	$o.button:=New object:C1471("value"; "…"; "behavior"; "alternateButton")
	
	Form:C1466._choiceList.push($o)
	
	This:C1470.list.selectLastRow().edit()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function doType()
	
	ARRAY LONGINT:C221($events; 0)
	APPEND TO ARRAY:C911($events; On Before Data Entry:K2:39)
	
	If (This:C1470.image.getValue())
		
		This:C1470._label.setTitle("image")
		OBJECT SET EVENTS:C1239(*; "value"; $events; Enable events others unchanged:K42:38)
		
	Else 
		
		This:C1470._label.setTitle("label")
		OBJECT SET EVENTS:C1239(*; "value"; $events; Disable events others unchanged:K42:39)
		
	End if 
	
	This:C1470.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function doImage()->$enterable : Integer
	
	$enterable:=-1  // 💪 We manage data entry
	
	BEEP:C151
	
	
	
	