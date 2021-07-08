Class extends form

Class constructor
	
	Super:C1705("editor_CALLBACK")
	
	This:C1470.context:=editor_Panel_init(This:C1470.name)
	
	If (OB Is empty:C1297(This:C1470.context))
		
		This:C1470.isSubform:=True:C214
		
		This:C1470.init()
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
	End if 
	
	This:C1470.path:=cs:C1710.path.new()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	var $group : cs:C1710.group
	
	This:C1470.toBeInitialized:=False:C215
	
	This:C1470.formObject("noSelection")
	This:C1470.formObject("noAction")
	This:C1470.formObject("noTable")
	This:C1470.formObject("noParameters")
	This:C1470.formObject("title")
	
	$group:=This:C1470.group("parameterGroup")
	This:C1470.listbox("parameters"; "01_Parameters").addToGroup($group)
	This:C1470.formObject("parametersBorder"; "01_Parameters.border").addToGroup($group)
	This:C1470.button("add").addToGroup($group)
	This:C1470.button("remove").addToGroup($group)
	
	$group:=This:C1470.group("paramNameGroup")
	This:C1470.input("paramName"; "02_name").addToGroup($group)
	This:C1470.formObject("paramNameBorder"; "02_name.border").addToGroup($group)
	This:C1470.formObject("paramNameLabel"; "02_name.label").addToGroup($group)
	
	This:C1470.button("mandatory"; "02_mandatory")
	
	$group:=This:C1470.group("labelGroup")
	This:C1470.input("label"; "03_label").addToGroup($group)
	This:C1470.formObject("labelBorder"; "03_label.border").addToGroup($group)
	This:C1470.formObject("labelLabel"; "03_label.label").addToGroup($group)
	
	$group:=This:C1470.group("shortGroup")
	This:C1470.input("short"; "04_shortLabel").addToGroup($group)
	This:C1470.formObject("shortBorder"; "04_shortLabel.border").addToGroup($group)
	This:C1470.formObject("shortLabel"; "04_shortLabel.label").addToGroup($group)
	
	$group:=This:C1470.group("formatGroup")
	This:C1470.input("format"; "05_type").addToGroup($group)
	This:C1470.formObject("formatBorder"; "05_type.border").addToGroup($group)
	This:C1470.formObject("formatLabel"; "05_type.label").addToGroup($group)
	This:C1470.button("formatPopup"; "05_type.popup").addToGroup($group)
	This:C1470.formObject("formatPopupBorder"; "05_type.popup.border").addToGroup($group)
	
	$group:=This:C1470.group("sortOrderGroup")
	This:C1470.input("sortOrder"; "03_sortOrder").addToGroup($group)
	This:C1470.formObject("sortOrderBorder"; "03_sortOrder.border").addToGroup($group)
	This:C1470.formObject("sortOrderLabel"; "03_sortOrder.label").addToGroup($group)
	This:C1470.button("sortOrderPopup"; "03_sortOrder.popup").addToGroup($group)
	This:C1470.formObject("sortOrderPopupBorder"; "03_sortOrder.popup.border").addToGroup($group)
	
	$group:=This:C1470.group("placeholderGroup")
	This:C1470.input("placeholder"; "06_placeholder").addToGroup($group)
	This:C1470.formObject("placeholderBorder"; "06_placeholder.border").addToGroup($group)
	This:C1470.formObject("placeholderLabel"; "06_placeholder.label").addToGroup($group)
	
	$group:=This:C1470.group("defaultValueGroup")
	This:C1470.input("defaultValue"; "07_default").addToGroup($group)
	This:C1470.formObject("defaultValueBorder"; "07_default.border").addToGroup($group)
	This:C1470.formObject("defaultValueLabel"; "07_default.label").addToGroup($group)
	
	$group:=This:C1470.group("minGroup")
	This:C1470.input("min"; "09_min").addToGroup($group)
	This:C1470.formObject("minBorder"; "09_min.border").addToGroup($group)
	This:C1470.formObject("minLabel"; "09_min.label").addToGroup($group)
	
	$group:=This:C1470.group("maxGroup")
	This:C1470.input("max"; "10_max").addToGroup($group)
	This:C1470.formObject("maxBorder"; "10_max.border").addToGroup($group)
	This:C1470.formObject("maxLabel"; "10_max.label").addToGroup($group)
	
	This:C1470.input("field")
	This:C1470.input("description"; "01_description")
	
	This:C1470.formObject("dropCursor")
	
	This:C1470.group("number"; \
		This:C1470.minGroup; \
		This:C1470.maxGroup)
	
	This:C1470.group("properties"; \
		This:C1470.paramNameGroup; \
		This:C1470.mandatory; \
		This:C1470.labelGroup; \
		This:C1470.shortGroup; \
		This:C1470.formatGroup; \
		This:C1470.placeholderGroup; \
		This:C1470.defaultValueGroup; \
		This:C1470.number; \
		This:C1470.sortOrderGroup)
	
	This:C1470.group("withSelection"; \
		This:C1470.parameterGroup; \
		This:C1470.properties)
	
	This:C1470.group("linked"; \
		This:C1470.paramName; \
		This:C1470.label; \
		This:C1470.short; \
		This:C1470.placeholder; \
		This:C1470.defaultValue; \
		This:C1470.description)
	
	If (FEATURE.with("predictiveEntryInActionParam"))
		
		This:C1470.subform("predicting")
		
		$group:=This:C1470.group("sortMenu")
		This:C1470.button("namePopup").addToGroup($group)
		This:C1470.formObject("namePopupBorder").addToGroup($group)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	// This trick remove the horizontal gap
	This:C1470.parameters.setScrollbars(0; 2).updateDefinition()
	
	This:C1470.dropCursor.setColors(Highlight menu background color:K23:7)
	
	// Set the initial display
	If (This:C1470.action#Null:C1517)
		
		This:C1470.add.enable()
		
	Else 
		
		This:C1470.noSelection.show()
		This:C1470.noTable.hide()
		This:C1470.withSelection.hide()
		This:C1470.noParameters.hide()
		
	End if 
	
	This:C1470.dropCursor.setColors(Highlight menu background color:K23:7)
	
	// Add the events that we cannot select in the form properties 😇
	This:C1470.appendEvents(On Alternative Click:K2:36)
	
	If (FEATURE.with("predictiveEntryInActionParam"))
		
		This:C1470.predicting.setCoordinates(This:C1470.paramNameBorder.coordinates.left; This:C1470.paramNameBorder.coordinates.bottom)
		This:C1470.predicting.setDimensions(This:C1470.paramNameBorder.dimensions.width)
		This:C1470.appendEvents(On After Keystroke:K2:26)
		This:C1470.appendEvents(On Before Keystroke:K2:6)
		//This.appendEvents(-1)
		//This.appendEvents(-2)
		//This.appendEvents(-3)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function saveContext($current : Object)
	
	If (Count parameters:C259>=1)
		
		This:C1470.$current:=$current
		
	Else 
		
		This:C1470.$current:=This:C1470.current
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function restoreContext()
	
	var $index : Integer
	
	// * Select last used action (or the first one) if any
	Case of 
			
			//_______________________________________
		: (This:C1470.action=Null:C1517)\
			 | (This:C1470.action.parameters=Null:C1517)
			
			// <NOTHING MORE TO DO>
			
			//_______________________________________
		: (OB Keys:C1719(This:C1470).indexOf("$current")=-1)  // First display
			
			This:C1470.parameters.select(1)
			
			If (FEATURE.with("predictiveEntryInActionParam"))
				
				This:C1470.paramName.focus()
				//This.paramName.highlight()
				
			End if 
			
			//_______________________________________
		Else 
			
			If (This:C1470.current#Null:C1517)
				
				$index:=This:C1470.action.parameters.indexOf(This:C1470.current)
				This:C1470.parameters.select($index+1)
				
				If (FEATURE.with("predictiveEntryInActionParam"))
					
					This:C1470.paramName.focus()
					//This.paramName.highlight()
					
				End if 
				
			Else 
				
				If (This:C1470.$current=Null:C1517)
					
					// <NOTHING MORE TO DO>
					
				Else 
					
					$index:=This:C1470.action.parameters.indexOf(This:C1470.$current)
					This:C1470.parameters.select($index+1)
					
					If (FEATURE.with("predictiveEntryInActionParam"))
						This:C1470.paramName.focus()
						//This.paramName.highlight()
					End if 
				End if 
			End if 
			
			//_______________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Update UI
Function update()
	
	var $withDefault : Boolean
	var $action; $current : Object
	
	This:C1470.noSelection.hide()
	This:C1470.noTable.hide()
	This:C1470.withSelection.hide()
	This:C1470.noParameters.hide()
	This:C1470.noAction.hide()
	This:C1470.title.hide()
	This:C1470.field.hide()
	
	If (FEATURE.with("predictiveEntryInActionParam"))
		
		This:C1470.predicting.hide()
		
		If (This:C1470.namePopup.isVisible())
			
			This:C1470.sortMenu.hide()
			
			// Restore position
			This:C1470.paramName.moveAndResizeHorizontally(-33; 33)
			
		End if 
	End if 
	
	This:C1470.paramName.enable()
	
	If (Form:C1466.actions=Null:C1517)\
		 | (Num:C11(Form:C1466.actions.length)=0)  // No actions
		
		This:C1470.noAction.show()
		
	Else 
		
		$action:=This:C1470.action
		$current:=This:C1470.current
		
		If ($action=Null:C1517)  // No action selected
			
			This:C1470.noSelection.show()
			
		Else 
			
			This:C1470.restoreContext()
			
			Case of 
					
					//______________________________________________________
				: (String:C10($action.preset)="delete")
					
					This:C1470.goToPage(1)
					This:C1470.noParameters.show()
					
					//______________________________________________________
				: (String:C10($action.preset)="share")
					
					If (FEATURE.with("sharedActionWithDescription"))
						
						This:C1470.goToPage(2)
						This:C1470.title.setTitle("description").show()
						
					Else 
						
						This:C1470.goToPage(1)
						This:C1470.noParameters.show()
						
					End if 
					
					//______________________________________________________
				: (String:C10($action.preset)="sort")
					
					This:C1470.goToPage(1)
					This:C1470.title.setTitle(\
						EDITOR.str.setText("sortCriteria")\
						.localized(New collection:C1472($action.shortLabel; Table name:C256($action.tableNumber)))).show()
					This:C1470.withSelection.show()
					
					This:C1470.add.enable()
					This:C1470.properties.hide()
					
					If ($current=Null:C1517)
						
						This:C1470.remove.disable()
						
					Else 
						
						This:C1470.remove.enable()
						
						This:C1470.paramNameGroup.show()
						This:C1470.sortOrderGroup.show()
						This:C1470.field.show()  // Linked to a field
						This:C1470.paramName.disable()  // The name isn't editable
						
						If (FEATURE.with("predictiveEntryInActionParam"))
							
							This:C1470.sortMenu.show()
							This:C1470.paramName.moveAndResizeHorizontally(33; -33)
							
						End if 
					End if 
					
					//______________________________________________________
				Else 
					
					This:C1470.goToPage(1)
					
					If ($action.tableNumber=Null:C1517)  // No target table
						
						This:C1470.noTable.show()
						This:C1470.properties.hide()
						This:C1470.remove.disable()
						This:C1470.add.disable()
						
					Else 
						
						This:C1470.title.setTitle(\
							EDITOR.str.setText("actionParameters")\
							.localized(New collection:C1472($action.shortLabel; Table name:C256($action.tableNumber)))).show()
						This:C1470.withSelection.show()
						This:C1470.add.enable()
						This:C1470.remove.enable($current#Null:C1517)
						
						If ($current=Null:C1517)  // No current parameter
							
							This:C1470.properties.hide()
							
						Else 
							
							If ($action.parameters.length>0)
								
								This:C1470.properties.show()
								This:C1470.sortOrderGroup.hide()
								
								This:C1470.defaultValueGroup.show($current.fieldNumber=Null:C1517)  // User parameter
								This:C1470.field.show($current.fieldNumber#Null:C1517)  // Linked to a field
								
								This:C1470.number.show(String:C10($current.type)="number")
								
								This:C1470.mandatory.setValue(This:C1470.mandatoryValue())
								This:C1470.min.setValue(String:C10(This:C1470.ruleValue("min")))
								This:C1470.max.setValue(String:C10(This:C1470.ruleValue("max")))
								
								This:C1470.placeholderGroup.show($current.type#"bool")
								
								If ($current.type#"image")
									
									$withDefault:=Choose:C955(String:C10($action.preset)#"edit"; True:C214; ($current.fieldNumber=Null:C1517))
									
								End if 
								
								If ($withDefault)
									
									This:C1470.defaultValueGroup.show()
									
									This:C1470.defaultValue.setValue(String:C10($current.default))
									
									Case of 
											
											//…………………………………………………………………………………………………………………………………………
										: ($current.type="number")
											
											Case of 
													
													//________________________________________
												: (String:C10($current.format)="integer")
													
													This:C1470.defaultValue.setFilter(Is integer:K8:5)
													
													//________________________________________
												: (String:C10($current.format)="spellOut")
													
													This:C1470.defaultValue.setFilter(Is integer:K8:5)
													
													//________________________________________
												Else 
													
													This:C1470.defaultValue.setFilter(Is real:K8:4)
													
													//________________________________________
											End case 
											
											//…………………………………………………………………………………………………………………………………………
										: ($current.type="date")
											
											// Should accept "today", "yesterday", "tomorrow"
											GET SYSTEM FORMAT:C994(Date separator:K60:10; $t)
											This:C1470.defaultValue.setFilter("&\"0-9;"+$t+";-;/;"+EDITOR.str.setText("todayyesterdaytomorrow").distinctLetters(";")+"\"")
											
											var $t
											$t:=String:C10(This:C1470.defaultValue.getValue())
											
											If (Position:C15($t; "todayyesterdaytomorrow")=0)
												
												var $rgx : cs:C1710.regex
												$rgx:=cs:C1710.regex.new($t; "(?m-si)^(\\d{2})!(\\d{2})!(\\d{4})$").match()
												
												If ($rgx.success)
													
													This:C1470.defaultValue.setValue(String:C10(Add to date:C393(!00-00-00!; Num:C11($rgx.matches[3].data); Num:C11($rgx.matches[2].data); Num:C11($rgx.matches[1].data))))
													
												End if 
											End if 
											
											//…………………………………………………………………………………………………………………………………………
										: ($current.type="time")
											
											This:C1470.defaultValue.setFilter(Is time:K8:8)
											
											//…………………………………………………………………………………………………………………………………………
										: ($current.type="string")
											
											This:C1470.defaultValue.setFilter(Is text:K8:3)
											
											//…………………………………………………………………………………………………………………………………………
										: ($current.type="bool")
											
											If (String:C10($current.format)="check")
												
												If ($current.default#Null:C1517)
													
													If (Value type:C1509($current.default)=Is boolean:K8:9)
														
														This:C1470.defaultValue.setValue(Choose:C955($current.default; "checked"; "unchecked"))
														
													End if 
												End if 
												
												// Should accept "checked", "unchecked", 0 or 1
												This:C1470.defaultValue.setFilter("&\"0;1;"+cs:C1710.str.new("unchecked").distinctLetters(";")+"\"")
												
											Else 
												
												If ($current.default#Null:C1517)
													
													If (Value type:C1509($current.default)=Is boolean:K8:9)
														
														This:C1470.defaultValue.setValue(Choose:C955($current.default; "true"; "false"))
														
													End if 
												End if 
												
												// Should accept "true", "false", 0 or 1
												This:C1470.defaultValue.setFilter("&\"0;1;"+cs:C1710.str.new("truefalse").distinctLetters(";")+"\"")
												
											End if 
											
											//…………………………………………………………………………………………………………………………………………
									End case 
									
								Else 
									
									This:C1470.defaultValueGroup.hide()
									
								End if 
								
							Else 
								
								This:C1470.properties.hide()
								This:C1470.remove.disable()
								
							End if 
						End if 
					End if 
					//______________________________________________________
			End case 
		End if 
		
		This:C1470.restoreContext()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// "format": "descending or "ascending"
Function sortOrderValue()->$value : Text
	
	$value:=Get localized string:C991(This:C1470.current.format)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Format choice
Function doSortOrderMenu()
	
	var $menu : cs:C1710.menu
	
	$menu:=cs:C1710.menu.new()\
		.append(":xliff:ascending"; "ascending"; String:C10(This:C1470.current.format)="ascending")\
		.append(":xliff:descending"; "descending"; String:C10(This:C1470.current.format)="descending")
	
	If ($menu.popup(This:C1470.sortOrderBorder).selected)
		
		This:C1470.current.format:=$menu.choice
		
		PROJECT.save()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function minValue()->$value : Text
	
	$value:=String:C10(This:C1470.ruleValue("min"))
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function maxValue()->$value : Text
	
	$value:=String:C10(This:C1470.ruleValue("max"))
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function mandatoryValue()->$value : Boolean
	
	If (This:C1470.current.rules#Null:C1517)
		
		$value:=(This:C1470.current.rules.countValues("mandatory")>0)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function ruleValue($type : Text)->$value
	
	If (This:C1470.current.rules#Null:C1517)
		
		var $c : Collection
		$c:=This:C1470.current.rules.extract($type)
		
		If ($c.length>0)
			
			$value:=String:C10($c[0])
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function formatValue()->$value : Text
	
	var $current : Object
	$current:=This:C1470.current
	
	Case of 
			
			//________________________________________
		: (Length:C16(String:C10($current.format))=0)
			
			// Take type
			$value:=Choose:C955($current.type="string"; "text"; String:C10($current.type))
			$value:=Get localized string:C991($value)
			
			//________________________________________
		: (PROJECT.isCustomResource($current.format))  // Host custom action parameter format
			
			$value:=Substring:C12($current.format; 2)
			
			//________________________________________
		Else 
			
			// Prefer format
			$value:=Choose:C955($current.format#$current.type; "f_"+String:C10($current.format); String:C10($current.type))
			$value:=Get localized string:C991($value)
			
			//________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function commentValue()->$value : Text
	
	var $current : Object
	$current:=This:C1470.current
	
	//$action:=This.action
	
	If (Num:C11($current.fieldNumber)#0)  // One parameter selected
		
		If (Num:C11(This:C1470.action.tableNumber)#0)
			
			$value:=EDITOR.str\
				.setText("thisParameterIsLinkedToTheField")\
				.localized(String:C10(Form:C1466.dataModel[String:C10(This:C1470.action.tableNumber)][String:C10($current.fieldNumber)].name))
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Add a user parameter except for sort when adding is not possible
Function doAddParameter()
	
	If (String:C10(This:C1470.action.preset)="sort")
		
		This:C1470.doAddParameterMenu()
		
	Else 
		
		This:C1470.doNewParameter()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Add a user parameter
Function doNewParameter()
	
	var $parameter : Object
	
	$parameter:=New object:C1471(\
		"name"; Get localized string:C991("newParameter"); \
		"label"; Get localized string:C991("addParameter"); \
		"shortLabel"; Get localized string:C991("addParameter"); \
		"type"; "string")
	
	This:C1470._addParameter($parameter)
	This:C1470.paramName.focus()
	This:C1470.paramName.highlight()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Add a field linked parameter
Function doAddParameterMenu($target : Object; $update : Boolean)
	
	var $t : Text
	var $isSortAction : Boolean
	var $field; $parameter; $table : Object
	var $c : Collection
	var $menu : cs:C1710.menu
	
	$isSortAction:=String:C10(This:C1470.action.preset)="sort"
	
	$menu:=cs:C1710.menu.new()
	
	If (Not:C34($isSortAction))
		
		$menu.append(":xliff:addParameter"; "new")
		
	End if 
	
	If (This:C1470.action.tableNumber#Null:C1517)
		
		$table:=Form:C1466.dataModel[String:C10(This:C1470.action.tableNumber)]
		
		$c:=New collection:C1472
		
		If (This:C1470.action.parameters=Null:C1517)
			
			For each ($t; $table)
				
				If (PROJECT.isField($t))
					
					If (Not:C34($isSortAction) | PROJECT.isSortable($table[$t]))
						
						$table[$t].fieldNumber:=Num:C11($t)
						$c.push($table[$t])
						
					End if 
				End if 
			End for each 
			
		Else 
			
			For each ($t; $table)
				
				If (PROJECT.isField($t))
					
					If (Not:C34($isSortAction) | PROJECT.isSortable($table[$t]))
						
						If (This:C1470.action.parameters.query("fieldNumber = :1"; Num:C11($t)).pop()=Null:C1517)
							
							$table[$t].fieldNumber:=Num:C11($t)
							$c.push($table[$t])
							
						End if 
					End if 
				End if 
			End for each 
		End if 
		
		If ($c.length>0)
			
			$menu.line()
			
			For each ($field; $c)
				
				$menu.append($field.name; String:C10($field.fieldNumber))
				
			End for each 
		End if 
		
	Else 
		
		// No table affected to action
		
	End if 
	
	$menu.popup($target)
	
	Case of 
			
			//______________________________________________________
		: (Not:C34($menu.selected))
			
			// <NOTHING MORE TO DO>
			
			//______________________________________________________
		: ($menu.choice="new")  // Add a user parameter
			
			This:C1470.doNewParameter()
			
			//______________________________________________________
		: (Count parameters:C259=2)  // Change linked field
			
			$field:=$c.query("fieldNumber = :1"; Num:C11($menu.choice)).pop()
			This:C1470._updateParamater($field.name)
			
			//______________________________________________________
		Else   // Add a field
			
			$field:=$c.query("fieldNumber = :1"; Num:C11($menu.choice)).pop()
			
			If ($isSortAction)
				
				$parameter:=New object:C1471(\
					"fieldNumber"; $field.fieldNumber; \
					"defaultField"; formatString("field-name"; $field.name); \
					"name"; $field.name)
				
			Else 
				
				$parameter:=New object:C1471(\
					"fieldNumber"; $field.fieldNumber; \
					"label"; $field.label; \
					"shortLabel"; $field.shortLabel; \
					"defaultField"; formatString("field-name"; $field.name); \
					"name"; EDITOR.str.setText($field.name).lowerCamelCase())
				
				If (Bool:C1537($field.mandatory))
					
					$parameter.rules:=New collection:C1472("mandatory")
					
				End if 
			End if 
			
			$parameter.type:=PROJECT.fieldType2type($field.fieldType)
			
			Case of 
					
					//……………………………………………………………………
				: ($isSortAction)
					
					$parameter.format:="ascending"
					
					//……………………………………………………………………
				: ($parameter.type="date")
					
					$parameter.format:="mediumDate"
					
					//……………………………………………………………………
				: ($parameter.type="time")
					
					$parameter.format:="hour"
					
					//……………………………………………………………………
			End case 
			
			This:C1470._addParameter($parameter)
			
			//______________________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// [PRIVATE]
Function _addParameter($parameter : Object)
	
	var $label : Text
	var $index : Integer
	var $o : Object
	
	If (This:C1470.action.parameters=Null:C1517)
		
		This:C1470.action.parameters:=New collection:C1472
		
	Else 
		
		$label:=$parameter.name
		
		If (This:C1470.action.parameters.query("name=:1"; $label).length=0)
			
			// <NOTHING MORE TO DO>
			
		Else 
			
			Repeat 
				
				$index:=$index+1
				
				$o:=This:C1470.action.parameters.query("name=:1"; $label+String:C10($index)).pop()
				
				If ($o=Null:C1517)
					
					$parameter.name:=$label+String:C10($index)
					
				End if 
			Until ($o=Null:C1517)
		End if 
	End if 
	
	This:C1470.action.parameters.push($parameter)
	PROJECT.save()
	
	This:C1470.parameters.focus()
	This:C1470.saveContext($parameter)
	This:C1470.parameters.reveal(This:C1470.parameters.rowsNumber()+Num:C11(This:C1470.parameters.rowsNumber()=0))
	This:C1470.refresh()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Remove action button
Function doRemoveParameter()
	
	var $index : Integer
	
	$index:=This:C1470.action.parameters.indexOf(This:C1470.current)
	This:C1470.action.parameters.remove($index)
	PROJECT.save()
	
	This:C1470.parameters.focus()
	This:C1470.parameters.doSafeSelect($index+1)  // Collection index to listbox index
	This:C1470.current:=Null:C1517
	This:C1470.saveContext(This:C1470.current)
	This:C1470.refresh()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Mandatory checkbox
Function doMandatory()
	
	var $index : Integer
	var $current : Object
	
	$current:=This:C1470.current
	
	If (Bool:C1537(This:C1470.mandatory.getValue()))  // Checked
		
		If ($current.rules=Null:C1517)
			
			$current.rules:=New collection:C1472
			
		End if 
		
		If ($current.rules.indexOf("mandatory")=-1)
			
			$current.rules.push("mandatory")
			
		End if 
		
	Else 
		
		If ($current.rules#Null:C1517)
			
			$index:=$current.rules.indexOf("mandatory")
			
			If ($index#-1)
				
				$current.rules.remove($index)
				
			End if 
			
			If ($current.rules.length=0)
				
				OB REMOVE:C1226($current; "rules")
				
			End if 
		End if 
	End if 
	
	PROJECT.save()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Format list
Function getFormats()->$formats : Object
	
	var $type : Text
	var $index : Integer
	var $manifestData : Object
	var $c : Collection
	var $manifest : 4D:C1709.File
	var $folder; $formatterFolder : 4D:C1709.Folder
	
	$formats:=JSON Parse:C1218(File:C1566("/RESOURCES/actionParameters.json").getText()).formats
	
	If (FEATURE.with("customActionFormatter"))
		
		$folder:=This:C1470.path.hostActionParameterFormatters(False:C215)
		
		If ($folder.exists)
			
			For each ($formatterFolder; $folder.folders())
				
				$manifest:=$formatterFolder.file("manifest.json")
				
				If ($manifest.exists)
					
					$manifestData:=JSON Parse:C1218($manifest.getText())
					
					If (Value type:C1509($manifestData.type)=Is text:K8:3)
						
						$manifestData.type:=New collection:C1472($manifestData.type)
						
					End if 
					
					If (Value type:C1509($manifestData.type)=Is collection:K8:32)
						
						$c:=New collection:C1472(\
							"text"; \
							"real"; \
							"integer"; \
							"boolean"; \
							"picture")
						
						For each ($type; $manifestData.type)
							
							$index:=$c.indexOf($type)
							
							If ($index>=0)
								
								$type:=Choose:C955($index; \
									"string"; \
									"number"; \
									"number"; \
									"bool"; \
									"image")
								
							End if 
							
							If ($formats[$type]#Null:C1517)
								
								// ENHANCE: could add maybe object instead of string, to add some other info like helptype or custom label
								If ($formats[$type].indexOf("/"+$formatterFolder.name)<0)
									
									$formats[$type].push("/"+$formatterFolder.name)
									
								End if 
							End if 
						End for each 
					End if 
				End if 
			End for each 
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Show current format on disk
Function formatShowOnDisk
	var $format : Text
	var $folder : 4D:C1709.Folder
	
	$format:=String:C10(This:C1470.current.format)
	
	If (PROJECT.isCustomResource($format))
		
		$folder:=This:C1470.path.hostActionParameterFormatters(True:C214).folder(Delete string:C232($format; 1; 1))
		If ($folder.exists)
			SHOW ON DISK:C922($folder.platformPath)
		End if 
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Format choice
Function doFormatMenu()
	
	var $currentFormat; $format; $label; $newType; $type : Text
	var $tableNumber; $fieldNumber : Text
	var $hasCustom : Boolean
	var $index : Integer
	var $current; $formats; $subMenu : Object
	var $table; $tablesMenu; $field; $fieldsMenu; $dataSource; $formatObject : Object
	var $folder; $manifestFile : Object
	var $menu : cs:C1710.menu
	
	$current:=This:C1470.current
	$currentFormat:=String:C10($current.format)
	$formats:=This:C1470.getFormats()
	
	$menu:=cs:C1710.menu.new()
	
	$hasCustom:=False:C215
	
	If ($current.fieldNumber#Null:C1517)  // Action linked to a field
		
		$menu.append(":xliff:byDefault"; "null"; $current.format=Null:C1517).line()
		
		$type:=Choose:C955($current.type="text"; "string"; $current.type)
		For each ($format; $formats[$type])
			
			If (PROJECT.isCustomResource($format))
				
				If (Not:C34($hasCustom))
					
					$menu.line()  // Separate custom by a line
					
				End if 
				
				$hasCustom:=True:C214
				$menu.append(Substring:C12($format; 2); $format; $currentFormat=$format)
				
			Else 
				
				$menu.append(":xliff:f_"+$format; $format; $currentFormat=$format)
				
			End if 
		End for each 
		
		If (FEATURE.with("newActionFormatterChoiceList"))
			
			If (($type#"image") & ($type#"date") & ($type#"time"))  // TODO newActionFormatterChoiceList make an include list instead
				$menu.line()
				
				$formatObject:=New object:C1471("type"; New collection:C1472($type))
				$menu.append(".New choice list"/*TODO newActionFormatterChoiceList localize*/; "$new:choiceList:"+JSON Stringify:C1217($formatObject))
				
				$tablesMenu:=cs:C1710.menu.new()
				
				For each ($tableNumber; PROJECT.dataModel)
					
					$table:=PROJECT.dataModel[$tableNumber]
					$fieldsMenu:=cs:C1710.menu.new()
					
					For each ($fieldNumber; $table)
						
						If (PROJECT.isField($fieldNumber))
							
							$field:=$table[$fieldNumber]
							
							If (PROJECT.fieldType2type($field.fieldType)=$type)  // OPTI : use reverse convertion on current type instead
								
								$formatObject:=New object:C1471("type"; New collection:C1472($type); "choiceList"; New object:C1471("dataSource"; New object:C1471("dataClass"; $table[""].name; "field"; $field.name)))
								$fieldsMenu.append($field.name; "$new:dataSource:"+JSON Stringify:C1217($formatObject))
								
							End if 
						End if 
					End for each 
					
					If ($fieldsMenu.itemCount()>0)
						$tablesMenu.append($table[""].name; $fieldsMenu)
					End if 
				End for each 
				
				If ($tablesMenu.itemCount()>0)
					$menu.append(".New from dataClass"/*TODO newActionFormatterChoiceList localize*/; $tablesMenu)
				End if 
				
			End if 
		End if 
		
	Else 
		
		For each ($type; $formats)
			
			If ($formats[$type].length>0)
				
				$subMenu:=cs:C1710.menu.new()
				$label:=Choose:C955($type="string"; "text"; $type)
				$subMenu.append(":xliff:"+$label; $label).line()
				
				$hasCustom:=False:C215  // to have a line by type
				For each ($format; $formats[$type])
					
					If (PROJECT.isCustomResource($format))
						
						If (Not:C34($hasCustom))
							
							$subMenu.line()  // Separate custom by a line
							
						End if 
						
						$hasCustom:=True:C214
						$subMenu.append(Substring:C12($format; 2); $format; $currentFormat=$format)
						
					Else 
						
						$subMenu.append(":xliff:f_"+$format; $format; $currentFormat=$format)
						
					End if 
				End for each 
				
				If (FEATURE.with("newActionFormatterChoiceList"))
					
					If (($type#"image") & ($type#"date") & ($type#"time"))  // TODO newActionFormatterChoiceList make an include list instead
						
						$subMenu.line()
						
						$formatObject:=New object:C1471("type"; New collection:C1472($type))
						$subMenu.append(".New choice list"/*TODO newActionFormatterChoiceList localize*/; "$new:choiceList:"+JSON Stringify:C1217($formatObject))
						
						$tablesMenu:=cs:C1710.menu.new()
						
						For each ($tableNumber; PROJECT.dataModel)
							
							$table:=PROJECT.dataModel[$tableNumber]
							$fieldsMenu:=cs:C1710.menu.new()
							
							For each ($fieldNumber; $table)
								
								If (PROJECT.isField($fieldNumber))
									
									$field:=$table[$fieldNumber]
									
									If (PROJECT.fieldType2type($field.fieldType)=$type)  // OPTI : use reverse convertion on current type instead
										
										$formatObject:=New object:C1471("type"; New collection:C1472($type); "choiceList"; New object:C1471("dataSource"; New object:C1471("dataClass"; $table[""].name; "field"; $field.name)))
										$fieldsMenu.append($field.name; "$new:dataSource:"+JSON Stringify:C1217($formatObject))
										
									End if 
								End if 
							End for each 
							
							If ($fieldsMenu.itemCount()>0)
								$tablesMenu.append($table[""].name; $fieldsMenu)
							End if 
						End for each 
						
						If ($tablesMenu.itemCount()>0)
							$subMenu.append(".New from dataClass"/*TODO newActionFormatterChoiceList localize*/; $tablesMenu)
						End if 
					End if 
				End if 
				$menu.append(":xliff:"+$label; $subMenu)
				
			Else 
				
				$menu.append(":xliff:f_"+$type; $type; $currentFormat=$type)
				
			End if 
		End for each 
	End if 
	
	// Position according to the box
	If ($menu.popup(This:C1470.formatBorder).selected)
		
		Case of 
			: ($menu.choice="null")
				
				OB REMOVE:C1226($current; "format")
				
				
			: (Position:C15("$new:"; $menu.choice)=1)
				
				$menu.choice:=Delete string:C232($menu.choice; 1; Length:C16("$new:"))
				$formatObject:=JSON Parse:C1218(Substring:C12($menu.choice; Position:C15(":"; $menu.choice)+1))
				$menu.choice:=Substring:C12($menu.choice; 1; Position:C15(":"; $menu.choice)-1)
				
				$format:=Request:C163(".Name of the format"/*TODO newActionFormatterChoiceList localize*/)
				
				If (Length:C16($format)>0)
					
					$formatObject.name:=formatString("field-name"; $format)  // TODO format the name ; compatible with Folder
					
					$folder:=This:C1470.path.hostActionParameterFormatters(True:C214).folder($formatObject.name)
					
					If (Not:C34($folder.exists))
						
						Case of 
							: ($menu.choice="choiceList")
								
								$formatObject.choiceList:=cs:C1710.formater.new().defaultChoiceList($formatObject.type[0]; False:C215)
								
							: ($menu.choice="dataSource")
								
								// already filled
								
							Else 
								
								$formatObject:=Null:C1517
								
						End case 
						
						If ($formatObject#Null:C1517)
							
							$folder.create()
							$manifestFile:=$folder.file("manifest.json")
							$manifestFile.setText(JSON Stringify:C1217($formatObject; *))
							$current.format:="/"+$formatObject.name  // set as custom/host resource
							
							// TODO newActionFormatterChoiceList maybe affect also $current.type, and some notify maybe
							
							If ($menu.choice="choiceList")
								OPEN URL:C673($manifestFile.platformPath)  // Open JSON file, but we could open a custom format editor instead
							End if 
							
						End if 
						
					Else 
						ALERT:C41("A format with that name exists")
					End if 
				End if 
				
			Else 
				
				$current.format:=$menu.choice
				
				If ($current.defaultField=Null:C1517)  // User parameter
					
					For each ($type; $formats) Until ($index#-1)
						
						$index:=$formats[$type].indexOf($current.format)
						
						If ($index#-1)
							
							$newType:=Choose:C955($type="string"; "text"; $type)
							
						End if 
					End for each 
					
					If ($index=-1)
						
						$newType:=$current.format
						
					End if 
					
					If ($current.type#$newType)  // The type is changed
						
						$current.type:=$newType
						OB REMOVE:C1226($current; "default")
						
						If (This:C1470.defaultValue.focused)
							
							This:C1470.goTo(This:C1470.parameters.name)
							
						End if 
					End if 
				End if 
		End case 
		
		PROJECT.save()
		
		//This.refresh()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function doRule($name : Text)
	
	var $value : Variant
	var $rule : Object
	
	$value:=This:C1470[$name].getValue()
	
	If (Length:C16($value)>0)
		
		$value:=Num:C11($value)
		
		If (This:C1470.current.rules#Null:C1517)
			
			$rule:=This:C1470.current.rules.query($name+" != null").pop()
			
			If ($rule=Null:C1517)
				
				This:C1470.current.rules.push(New object:C1471($name; $value))
				
			Else 
				
				$rule[$name]:=$value
				
			End if 
			
		Else 
			
			If (This:C1470.current.rules=Null:C1517)
				
				This:C1470.current.rules:=New collection:C1472
				
			End if 
			
			This:C1470.current.rules.push(New object:C1471($name; $value))
			
		End if 
		
	Else 
		
		If (This:C1470.current.rules#Null:C1517)
			
			$rule:=This:C1470.current.rules.query($name+" != null").pop()
			
			If ($rule#Null:C1517)
				
				This:C1470.current.rules.remove(This:C1470.current.rules.indexOf($rule))
				
			End if 
			
			If (This:C1470.current.rules.length=0)
				
				OB REMOVE:C1226(This:C1470.current; "rules")
				
			End if 
		End if 
	End if 
	
	PROJECT.save()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function doDefaultValue()
	
	var $value : Text
	var $date : Date
	var $inError; $toRemove : Boolean
	var $current : Object
	
	$value:=This:C1470.defaultValue.getValue()
	
	$current:=This:C1470.current
	
	If (Length:C16(String:C10($value))>0)
		
		Case of 
				
				//______________________________________________________
			: ($current.type="number")
				
				$current.default:=Num:C11($value)
				
				//______________________________________________________
			: ($current.type="date")
				
				If (Match regex:C1019("(?m-si)^(?:today|tomorrow|yesterday)$"; $value; 1))
					
					$current.default:=$value
					
				Else 
					
					If (Match regex:C1019("(?m-si)^\\d+/\\d+/\\d+$"; $value; 1))
						
						// Use internal REST date format
						$date:=Date:C102($value)
						$current.default:=String:C10(Day of:C23($date); "00!")+String:C10(Month of:C24($date); "00!")+String:C10(Year of:C25($date); "0000")
						
					Else 
						
						$inError:=True:C214
						
					End if 
				End if 
				
				//______________________________________________________
			: ($current.type="bool")
				
				If (String:C10($current.format)="check")
					
					If (Match regex:C1019("(?m-is)^(?:checked|unchecked)$"; $value; 1))
						
						$current.default:=Bool:C1537($value="checked")
						
					Else 
						
						If (Match regex:C1019("(?m-is)^(?:0|1)$"; String:C10(Num:C11($value)); 1))
							
							$current.default:=Num:C11($value)
							
						Else 
							
							$inError:=True:C214
							
						End if 
					End if 
					
				Else 
					
					If (Match regex:C1019("(?m-is)^(?:true|false)$"; $value; 1))
						
						$current.default:=Bool:C1537($value="true")
						
					Else 
						
						If (Match regex:C1019("(?m-is)^(?:0|1)$"; String:C10(Num:C11($value)); 1))
							
							$current.default:=Num:C11($value)
							
						Else 
							
							$inError:=True:C214
							
						End if 
					End if 
				End if 
				
				//______________________________________________________
			: ($current.type="time")
				
				$current.default:=String:C10(Time:C179($value); HH MM:K7:2)
				
				//______________________________________________________
			Else 
				
				$current.default:=$value
				
				//______________________________________________________
		End case 
		
	Else 
		
		$toRemove:=True:C214
		
	End if 
	
	If ($inError)
		
		$toRemove:=True:C214
		BEEP:C151
		This:C1470.defaultValue.focus()
		
	End if 
	
	If ($toRemove)
		
		OB REMOVE:C1226($current; "default")
		
	End if 
	
	//This.refresh()
	PROJECT.save()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Initialization of the internal D&D for actions
Function doBeginDrag()
	
	var $x : Blob
	var $o : Object
	
	$o:=New object:C1471(\
		"src"; This:C1470.index)
	
	// Put into the container
	VARIABLE TO BLOB:C532($o; $x)
	APPEND DATA TO PASTEBOARD:C403("com.4d.private.4dmobile.parameter"; $x)
	SET BLOB SIZE:C606($x; 0)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Internal drop for actions
Function doOnDrop()
	
	var $x : Blob
	var $o : Object
	
	// Get the pastboard
	GET PASTEBOARD DATA:C401("com.4d.private.4dmobile.parameter"; $x)
	
	If (Bool:C1537(OK))
		
		BLOB TO VARIABLE:C533($x; $o)
		SET BLOB SIZE:C606($x; 0)
		
		$o.tgt:=Drop position:C608
		
	End if 
	
	If ($o.src#$o.tgt)
		
		If ($o.tgt=-1)  // After the last line
			
			This:C1470.action.parameters.push(This:C1470.current)
			This:C1470.action.parameters.remove($o.src-1)
			
		Else 
			
			This:C1470.action.parameters.insert($o.tgt-1; This:C1470.current)
			
			If ($o.tgt<$o.src)
				
				This:C1470.action.parameters.remove($o.src)
				
			Else 
				
				This:C1470.action.parameters.remove($o.src-1)
				
			End if 
		End if 
		
		PROJECT.save()
		
	End if 
	
	This:C1470.dropCursor.hide()
	This:C1470.parameters.touch()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function doName($e : Object)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Before Keystroke:K2:6)  // Filtering
			
			var $value : Text
			var $charCode; $indx : Integer
			
			$charCode:=Character code:C91(Keystroke:C390)
			$indx:=New collection:C1472(Return key:K12:27; Escape:K15:39; Up arrow key:K12:18; Down arrow key:K12:19).indexOf($charCode)
			
			If ($indx>=0)
				
				Case of 
						
						//_________________________
					: ($indx=0)  // Return key
						
						This:C1470.callChild(This:C1470.predicting; "predictingEvent"; $charCode)
						$value:=String:C10(This:C1470.predicting.getValue().choice.value)
						
						If (Length:C16($value)>0)
							
							This:C1470._updateParamater($value)
							
						Else 
							
							This:C1470._updateParamater(Get edited text:C655)
							
						End if 
						
						This:C1470.postKeyDown(Tab:K15:37)
						This:C1470.update()
						
						//_________________________
					: ($indx=1)  // Escape
						
						This:C1470.callChild(This:C1470.predicting; "predictingEvent"; $charCode)
						$value:=String:C10(This:C1470.predicting.getValue().choice.value)
						This:C1470.predicting.hide()
						
						//_________________________
					: (This:C1470.predicting.isHidden())
						
						// <NOTHING MORE TO DO>
						
						//_________________________
					Else   // Arrow keys
						
						This:C1470.callChild(This:C1470.predicting; "predictingEvent"; $charCode)
						$value:=String:C10(This:C1470.predicting.getValue().choice.value)
						This:C1470.paramName.setValue($value)
						
						//_________________________
				End case 
			End if 
			
			//______________________________________________________
		: ($e.code=On After Keystroke:K2:26)  // Update predicting
			
			var $key : Text
			var $table : Object
			var $c : Collection
			
			$table:=Form:C1466.dataModel[String:C10(This:C1470.action.tableNumber)]
			$c:=New collection:C1472
			
			For each ($key; $table)
				
				If (PROJECT.isField($key))
					
					If (This:C1470.action.parameters.query("fieldNumber = :1"; Num:C11($key)).pop()=Null:C1517)\
						 | ($table[$key].name=This:C1470.current.name)
						
						$c.push($table[$key].name)
						
					End if 
				End if 
			End for each 
			
			This:C1470.predicting.setValue(New object:C1471(\
				"search"; Get edited text:C655; \
				"values"; $c; \
				"withValue"; True:C214))
			
			//______________________________________________________
		: ($e.code=On Losing Focus:K2:8)
			
			This:C1470.predicting.hide()
			
			$value:=This:C1470.paramName.getValue()
			
			If (Length:C16($value)=0)
				
				BEEP:C151
				This:C1470._updateParamater(Get localized string:C991("newParameter"))
				
				This:C1470.paramName.focus()
				
			End if 
			
			//______________________________________________________
		: ($e.code=On Data Change:K2:15)
			
			$value:=This:C1470.paramName.getValue()
			
			If (Length:C16($value)>0)
				
				This:C1470._updateParamater($value)
				
			End if 
			
			//______________________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function _updateParamater($name : Text)->$success : Boolean
	
	var $key : Text
	var $table : Object
	
	$table:=Form:C1466.dataModel[String:C10(This:C1470.action.tableNumber)]
	
	For each ($key; $table) Until ($success)
		
		If (PROJECT.isField($key))
			
			$success:=($table[$key].name=$name)
			
			If ($success)
				
				This:C1470.current.fieldNumber:=Num:C11($key)
				This:C1470.current.name:=$table[$key].name
				This:C1470.current.label:=$table[$key].label
				This:C1470.current.shortLabel:=$table[$key].shortLabel
				This:C1470.current.type:=PROJECT.fieldType2type($table[$key].fieldType)
				
			End if 
		End if 
	End for each 
	
	If (Not:C34($success))
		
		// Keep the user entry
		// & remove field link
		This:C1470.current.name:=$name
		OB REMOVE:C1226(This:C1470.current; "fieldNumber")
		
	End if 
	
	This:C1470.paramName.setValue(This:C1470.current.name)
	PROJECT.save()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Set help tip
Function setHelpTip()  //($e : Object)
	
	var $currentValue : Text
	$currentValue:=String:C10(This:C1470.current.format)
	
	Case of 
			
			//________________________________________
		: (Length:C16($currentValue)=0)
			
			This:C1470.format.setHelpTip("")
			
			//________________________________________
		: (PROJECT.isCustomResource($currentValue))
			
			This:C1470.format.setHelpTip(This:C1470.formatToolTip($currentValue))
			
			//________________________________________
		Else 
			
			This:C1470.format.setHelpTip("")
			
			//________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Format tool tip
Function formatToolTip($format : Text)->$tip
	
	var $manifest : 4D:C1709.File
	
	If (PROJECT.isCustomResource($format))
		
		$manifest:=EDITOR.path.hostActionParameterFormatters().folder(Delete string:C232($format; 1; 1)).file("manifest.json")
		
		// TODO If zip formatter, fix file path(read in zip SHARED.archiveExtension)
		If ($manifest.exists)
			
			$tip:=EDITOR.str.setText(JSON Stringify:C1217(JSON Parse:C1218($manifest.getText()).choiceList; *)).jsonSimplify()
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// <Background Color Expression> ******************** VERY SIMILAR TO ACTIONS.backgroundColor() ********************
Function backgroundColor($current : Object)->$color
	
	var $v  // could be an integer or a text
	var $isFocused : Boolean
	
	$color:="transparent"
	
	If (Num:C11(This:C1470.index)#0)
		
		$isFocused:=(OBJECT Get name:C1087(Object with focus:K67:3)=This:C1470.parameters.name)
		
		If (ob_equal(This:C1470.current; $current))  // Selected row
			
			$color:=Choose:C955($isFocused; EDITOR.backgroundSelectedColor; EDITOR.alternateSelectedColor)
			
		Else 
			
			$v:=Choose:C955($isFocused; EDITOR.highlightColor; EDITOR.highlightColorNoFocus)
			$color:=Choose:C955($isFocused; $v; "transparent")
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// <Meta info expression>
Function metaInfo($current : Object)->$result
	
	$result:=New object:C1471(\
		"stroke"; Choose:C955(EDITOR.isDark; "white"; "black"); \
		"fontWeight"; "normal"; \
		"cell"; New object:C1471(\
		"names"; New object:C1471))
	
	If (This:C1470.action.parameters.query("name = :1"; $current.name).length>1)
		
		// Selected item
		$result.cell.names.stroke:=EDITOR.errorRGB
		
	Else 
		
		$result.cell.names.stroke:=Choose:C955(EDITOR.isDark; "white"; "black")
		
	End if 