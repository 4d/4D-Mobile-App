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
		This:C1470.listbox("list"; "choiceList").addToGroup($group)
		This:C1470.button("add").addToGroup($group)
		This:C1470.button("remove").addToGroup($group)
		$group.hide()  // Hide all elements
		
		$group:=This:C1470.group("dataclass")
		This:C1470.formObject("_table").addToGroup($group)
		This:C1470.formObject("_fields").addToGroup($group)
		This:C1470.listbox("dataclasses").addToGroup($group)
		This:C1470.listbox("attributes").addToGroup($group)
		$group.hide()  // Hide all elements
		
		$group:=This:C1470.group("buttons")
		This:C1470.button("ok").disable().addToGroup($group)
		This:C1470.button("cancel").addToGroup($group)
		$group.distributeRigthToLeft()  // Adjust button size
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	// Select the format radio button
	This:C1470[Form:C1466.format].setValue(True:C214)
	
	This:C1470.static.setValue(Form:C1466.choiceList.dataSource=Null:C1517)
	
	If (Bool:C1537(This:C1470.static.getValue()))
		
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
		
		Form:C1466._choiceList:=OB Entries:C1720(Form:C1466.choiceList)
		
		This:C1470.label.setValue(Form:C1466.binding=Null:C1517)
		
	Else 
		
	End if 
	
	// Go to name box
	This:C1470.name.focus().highlight()
	
	This:C1470.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function update()
	
	SET TIMER:C645(0)
	
	If (This:C1470.static.getValue())
		
		This:C1470.choiceList.show()
		This:C1470.dataclass.hide()
		
	Else 
		
		This:C1470.choiceList.hide()
		This:C1470.dataclass.show()
		
	End if 