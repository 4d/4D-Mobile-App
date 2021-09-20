Class extends form

Class constructor
	
	Super:C1705()
	
	This:C1470.init()
	This:C1470.onLoad()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	var $group : cs:C1710.group
	
	If (This:C1470.toBeInitialized)
		
		This:C1470.toBeInitialized:=False:C215
		
		This:C1470.input("name")
		
		$group:=This:C1470.group("type")
		This:C1470.button("push").addToGroup($group)
		This:C1470.button("segmented").addToGroup($group)
		This:C1470.button("popover").addToGroup($group)
		This:C1470.button("sheet").addToGroup($group)
		This:C1470.button("picker").addToGroup($group)
		This:C1470.type.distributeLeftToRight()  // Adjust button size
		
		$group:=This:C1470.group("source")
		This:C1470.button("static").addToGroup($group)
		This:C1470.button("datasource").addToGroup($group)
		This:C1470.source.distributeLeftToRight()  // Adjust button size
		
		$group:=This:C1470.group("choiceList")
		This:C1470.button("label").addToGroup($group)
		This:C1470.button("image").addToGroup($group)
		This:C1470.choiceList.distributeLeftToRight()  // Adjust button size
		This:C1470.formObject("_binding").addToGroup($group)
		This:C1470.formObject("_value").addToGroup($group)
		This:C1470.formObject("_label").addToGroup($group)
		This:C1470.listbox("list"; "choiceList").setScrollbars(0; 2).addToGroup($group)
		This:C1470.button("add").addToGroup($group)
		This:C1470.button("remove").addToGroup($group)
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
			: (Not:C34(OB Is empty:C1297(Form:C1466.choiceList)))
				
				// <NOTHING MORE TO DO>
				
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
			Else 
				
				// A "Case of" statement should never omit "Else"
				//______________________________________________________
		End case 
	End if 
	
	// Select the format radio button
	This:C1470[Form:C1466.format].setValue(True:C214)
	
	// Select the datasource type
	This:C1470.static.setValue(Form:C1466.choiceList.dataSource=Null:C1517)
	
	// Choice list values
	Form:C1466._choiceList:=OB Entries:C1720(Form:C1466.choiceList)
	
	// Set binding
	This:C1470.label.setValue(Form:C1466.binding=Null:C1517)
	
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
	
	If (This:C1470.static.getValue())
		
		This:C1470.choiceList.show()
		This:C1470.dataclass.hide()
		
		$isValid:=$isValid\
			 & (Form:C1466._choiceList.length>0)
		
	Else 
		
		If (Form:C1466._dataclasses=Null:C1517)
			
			Form:C1466._dataclasses:=PROJECT.getCatalog()
			Form:C1466._attributes:=Form:C1466._dataclasses[0].field
			
			This:C1470.dataclasses.select(1)
			
		End if 
		
		This:C1470.choiceList.hide()
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
	
	