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
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function init()
	
	This:C1470.toBeInitialized:=False:C215
	
	This:C1470.noSelection:=cs:C1710.static.new("empty")
	This:C1470.noAction:=cs:C1710.static.new("noAction")
	This:C1470.noTable:=cs:C1710.static.new("noTable")
	This:C1470.noParameters:=cs:C1710.static.new("noParameters")
	
	This:C1470.parameters:=cs:C1710.listbox.new("01_Parameters").updateDefinition()
	This:C1470.parametersBorder:=cs:C1710.static.new("01_Parameters.border")
	This:C1470.remove:=cs:C1710.button.new("parameters.remove")
	This:C1470.add:=cs:C1710.button.new("parameters.add")
	This:C1470.parameterGroup:=cs:C1710.group.new(This:C1470.parameters; This:C1470.parametersBorder; This:C1470.remove; This:C1470.add)
	
	This:C1470.paramName:=cs:C1710.input.new("02_property_name")
	This:C1470.paramNameBorder:=cs:C1710.static.new("02_property_name.border")
	This:C1470.paramNameLabel:=cs:C1710.static.new("02_property_name.label")
	This:C1470.paramNameGroup:=cs:C1710.group.new(This:C1470.paramName; This:C1470.paramNameBorder; This:C1470.paramNameLabel)
	
	This:C1470.mandatory:=cs:C1710.button.new("02_property_mandatory")
	
	This:C1470.label:=cs:C1710.input.new("03_property_label")
	This:C1470.labelBorder:=cs:C1710.static.new("03_property_label.border")
	This:C1470.labelLabel:=cs:C1710.static.new("03_property_label.label")
	This:C1470.labelGroup:=cs:C1710.group.new(This:C1470.label; This:C1470.labelBorder; This:C1470.labelLabel)
	
	This:C1470.short:=cs:C1710.input.new("04_property_shortLabel")
	This:C1470.shortBorder:=cs:C1710.static.new("04_property_shortLabel.border")
	This:C1470.shortLabel:=cs:C1710.static.new("04_property_shortLabel.label")
	This:C1470.shortGroup:=cs:C1710.group.new(This:C1470.short; This:C1470.shortBorder; This:C1470.shortLabel)
	
	This:C1470.format:=cs:C1710.input.new("05_property_type")
	This:C1470.formatBorder:=cs:C1710.static.new("05_property_type.border")
	This:C1470.formatLabel:=cs:C1710.static.new("05_property_type.label")
	This:C1470.formatPopup:=cs:C1710.button.new("05_property_type.popup")
	This:C1470.formatPopupBorder:=cs:C1710.static.new("05_property_type.popup.border")
	This:C1470.formatGroup:=cs:C1710.group.new(This:C1470.format; This:C1470.formatBorder; This:C1470.formatLabel; This:C1470.formatPopup; This:C1470.formatPopupBorder)
	
	This:C1470.placeholder:=cs:C1710.input.new("06_property_placeholder")
	This:C1470.placeholderBorder:=cs:C1710.static.new("06_property_placeholder.border")
	This:C1470.placeholderLabel:=cs:C1710.static.new("06_property_placeholder.label")
	This:C1470.placeholderGroup:=cs:C1710.group.new(This:C1470.placeholder; This:C1470.placeholderBorder; This:C1470.placeholderLabel)
	
	This:C1470.defaultValue:=cs:C1710.input.new("07_variable_default")
	This:C1470.defaultValueBorder:=cs:C1710.static.new("07_variable_default.border")
	This:C1470.defaultValueLabel:=cs:C1710.static.new("07_variable_default.label")
	This:C1470.defaultValueGroup:=cs:C1710.group.new(This:C1470.defaultValue; This:C1470.defaultValueBorder; This:C1470.defaultValueLabel)
	
	This:C1470.min:=cs:C1710.input.new("09_property_constraint_number_min")
	This:C1470.minBorder:=cs:C1710.static.new("09_property_constraint_number_min.border")
	This:C1470.minLabel:=cs:C1710.static.new("09_property_constraint_number_min.label")
	This:C1470.minGroup:=cs:C1710.group.new(This:C1470.min; This:C1470.minBorder; This:C1470.minLabel)
	
	This:C1470.max:=cs:C1710.input.new("10_property_constraint_number_max")
	This:C1470.maxBorder:=cs:C1710.static.new("10_property_constraint_number_max.border")
	This:C1470.maxLabel:=cs:C1710.static.new("10_property_constraint_number_max.label")
	This:C1470.maxGroup:=cs:C1710.group.new(This:C1470.max; This:C1470.maxBorder; This:C1470.maxLabel)
	
	This:C1470.field:=cs:C1710.input.new("00_field_comment")
	This:C1470.description:=cs:C1710.input.new("01_description")
	
	This:C1470.dropCursor:=cs:C1710.static.new("dropCursor").setColors(Highlight menu background color:K23:7)
	
	This:C1470.number:=cs:C1710.group.new()\
		.addMember(This:C1470.minGroup.members)\
		.addMember(This:C1470.maxGroup.members)
	
	This:C1470.properties:=cs:C1710.group.new()\
		.addMember(This:C1470.paramNameGroup.members)\
		.addMember(This:C1470.mandatory)\
		.addMember(This:C1470.labelGroup.members)\
		.addMember(This:C1470.shortGroup.members)\
		.addMember(This:C1470.formatGroup.members)\
		.addMember(This:C1470.placeholderGroup.members)\
		.addMember(This:C1470.defaultValueGroup.members)\
		.addMember(This:C1470.number.members)
	
	This:C1470.withSelection:=cs:C1710.group.new()\
		.addMember(This:C1470.parameterGroup.members)\
		.addMember(This:C1470.properties.members)
	
	This:C1470.linked:=cs:C1710.group.new()\
		.addMember(This:C1470.paramName)\
		.addMember(This:C1470.label)\
		.addMember(This:C1470.short)\
		.addMember(This:C1470.placeholder)\
		.addMember(This:C1470.defaultValue)\
		.addMember(This:C1470.description)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Update UI
Function update()
	
	var $withDefault : Boolean
	var $action; $current : Object
	
	This:C1470.noSelection.hide()
	This:C1470.noTable.hide()
	This:C1470.withSelection.hide()
	This:C1470.noParameters.hide()
	
	If (Form:C1466.actions=Null:C1517)\
		 | (Num:C11(Form:C1466.actions.length)=0)  // No actions
		
		This:C1470.noAction.show()
		
	Else 
		
		This:C1470.noAction.hide()
		
		$action:=This:C1470.action
		$current:=This:C1470.current
		
		This:C1470.goToPage(1)
		
		If ($action=Null:C1517)  // No action selected
			
			This:C1470.noSelection.show()
			
		Else 
			
			Case of 
					
					//______________________________________________________
				: (String:C10($action.preset)="delete")
					
					This:C1470.noParameters.show()
					
					//______________________________________________________
				: (String:C10($action.preset)="share")
					
					If (FEATURE.with("sharedActionWithDescription")) & False:C215
						
						This:C1470.goToPage(2)
						
					Else 
						
						This:C1470.noParameters.show()
						
					End if 
					
					//______________________________________________________
				: ($action.parameters=Null:C1517) | (Num:C11($action.parameters.length)=0)
					
					This:C1470.withSelection.show()
					This:C1470.properties.hide()
					
					//______________________________________________________
				: (String:C10($action.preset)="sort")
					
					This:C1470.withSelection.show()
					
					If ($current=Null:C1517)
						
						This:C1470.properties.hide()
						
					Else 
						
						This:C1470.mandatory.hide()
						This:C1470.formatGroup.hide()
						This:C1470.placeholderGroup.hide()
						This:C1470.defaultValueGroup.hide()
						This:C1470.number.hide()
						
					End if 
					
					//______________________________________________________
				Else 
					
					This:C1470.withSelection.show()
					
					If ($action.tableNumber=Null:C1517)  // No target table
						
						This:C1470.noTable.show()
						This:C1470.properties.hide()
						This:C1470.remove.disable()
						This:C1470.add.disable()
						
					Else 
						
						This:C1470.add.enable()
						
						If ($current=Null:C1517)  // No current parameter
							
							This:C1470.properties.hide()
							This:C1470.remove.disable()
							
						Else 
							
							If ($action.parameters.length>0)
								
								This:C1470.remove.enable()
								This:C1470.properties.show()
								
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
	
	If (Length:C16(String:C10($current.format))=0)
		
		// Take type
		$value:=Choose:C955($current.type="string"; "text"; String:C10($current.type))
		
	Else 
		
		// Prefer format
		$value:=Choose:C955($current.format#$current.type; "f_"+String:C10($current.format); String:C10($current.type))
		
	End if 
	
	If ($value[[1]]="/")
		
		$value:=Substring:C12($value; 2)
		
	Else 
		
		$value:=Get localized string:C991($value)
		
	End if 
	
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
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Add a field linked parameter
Function doAddParameterMenu()
	
	var $t : Text
	var $isSortAction : Boolean
	var $field; $parameter; $table : Object
	var $c; $cc : Collection
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
						
						If (This:C1470.action.parameters.query("fieldNumber = :1"; Num:C11($t)).length=0)
							
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
	
	$menu.popup(This:C1470.add)
	
	Case of 
			
			//______________________________________________________
		: (Not:C34($menu.selected))
			
			// <NOTHING MORE TO DO>
			
			//______________________________________________________
		: ($menu.choice="new")  // Add a user parameter
			
			This:C1470.doNewParameter()
			
			//______________________________________________________
		Else   // Add a field
			
			$c:=$c.query("fieldNumber = :1"; Num:C11($menu.choice))
			
			$parameter:=New object:C1471(\
				"fieldNumber"; $c[0].fieldNumber; \
				"name"; EDITOR.str.setText($c[0].name).lowerCamelCase(); \
				"label"; $c[0].label; \
				"shortLabel"; $c[0].shortLabel; \
				"defaultField"; formatString("field-name"; $c[0].name))
			
			If (Bool:C1537($c[0].mandatory))
				
				$parameter.rules:=New collection:C1472("mandatory")
				
			End if 
			
			$cc:=New collection:C1472
			$cc[Is integer 64 bits:K8:25]:="number"
			$cc[Is alpha field:K8:1]:="string"
			$cc[Is integer:K8:5]:="number"
			$cc[Is longint:K8:6]:="number"
			$cc[Is picture:K8:10]:="image"
			$cc[Is boolean:K8:9]:="bool"
			$cc[_o_Is float:K8:26]:="number"
			$cc[Is text:K8:3]:="string"
			$cc[Is real:K8:4]:="number"
			$cc[Is time:K8:8]:="time"
			$cc[Is date:K8:7]:="date"
			
			$parameter.type:=$cc[$c[0].fieldType]
			
			Case of 
					
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
	// Remove action button
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
	This:C1470.parameters.reveal(This:C1470.parameters.rowsNumber()+Num:C11(This:C1470.parameters.rowsNumber()=0))
	
	This:C1470.refresh()
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Remove action button
Function doRemoveParameter()
	
	var $index : Integer
	
	$index:=This:C1470.action.parameters.indexOf(This:C1470.current)
	This:C1470.action.parameters.remove($index)
	
	$index:=$index+1  // Collection index to listbox index
	
	If ($index<=This:C1470.parameters.rowsNumber())
		
		This:C1470.parameters.select($index)
		
	Else 
		
		This:C1470.parameters.unselect()
		
	End if 
	
	//$form.form.refresh()
	PROJECT.save()
	
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
	// Format choice 
Function doFormatMenu()
	
	var $currentFormat; $format; $label; $newType; $type : Text
	var $index : Integer
	var $current; $form; $formats; $subMenu : Object
	var $menu : cs:C1710.menu
	
	$current:=This:C1470.current
	$currentFormat:=String:C10($current.format)
	$formats:=JSON Parse:C1218(File:C1566("/RESOURCES/actionParameters.json").getText()).formats
	
	$menu:=cs:C1710.menu.new()
	
	If ($current.fieldNumber#Null:C1517)  // Action linked to a field
		
		$menu.append(":xliff:byDefault"; "null"; $current.format=Null:C1517).line()
		
		For each ($format; $formats[Choose:C955($current.type="text"; "string"; $current.type)])
			
			$menu.append(":xliff:f_"+$format; $format; $currentFormat=$format)
			
		End for each 
		
	Else 
		
		For each ($type; $formats)
			
			If ($formats[$type].length>0)
				
				$subMenu:=cs:C1710.menu.new()
				
				$label:=Choose:C955($type="string"; "text"; $type)
				
				$subMenu.append(":xliff:"+$label; $label).line()
				
				For each ($format; $formats[$type])
					
					$subMenu.append(":xliff:f_"+$format; $format; $currentFormat=$format)
					
				End for each 
				
				$menu.append(":xliff:"+$label; $subMenu)
				
			Else 
				
				$menu.append(":xliff:f_"+$type; $type; $currentFormat=$type)
				
			End if 
		End for each 
	End if 
	
	// Position according to the box
	If ($menu.popup(This:C1470.formatBorder).selected)
		
		If ($menu.choice="null")
			
			OB REMOVE:C1226($current; "format")
			
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
		End if 
		
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
	End if 
	
	This:C1470.dropCursor.hide()
	
	This:C1470.parameters.touch()
	
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
	
	If ($current.action.parameters.query("name = :1"; $current.name).pop()#Null:C1517)
		
		// Selected item
		$result.cell.names.stroke:=EDITOR.errorRGB
		
	Else 
		
		$result.cell.names.stroke:=Choose:C955(EDITOR.isDark; "white"; "black")
		
	End if 