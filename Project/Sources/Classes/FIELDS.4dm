/*===============================================
FIELDS pannel Class
===============================================*/
Class extends form

//________________________________________________________________
Class constructor
	
	Super:C1705("editor_CALLBACK")
	
	This:C1470.context:=editor_INIT
	
	If (OB Is empty:C1297(This:C1470.context)) | Shift down:C543
		
		This:C1470.fieldList:=cs:C1710.listbox.new("01_fields")
		This:C1470.ids:=cs:C1710.widget.new("IDs")
		This:C1470.names:=cs:C1710.widget.new("fields")
		This:C1470.icons:=cs:C1710.widget.new("icons")
		This:C1470.labels:=cs:C1710.widget.new("label")
		This:C1470.shortLabels:=cs:C1710.widget.new("shortLabel")
		This:C1470.formats:=cs:C1710.widget.new("format")
		This:C1470.titles:=cs:C1710.widget.new("title")
		
		This:C1470.formatLabel:=cs:C1710.static.new("format.label")
		This:C1470.picker:=cs:C1710.widget.new("iconGrid")
		
		This:C1470.tabSelector:=cs:C1710.widget.new("tab.selector")
		This:C1470.selectorFields:=cs:C1710.button.new("tab.fields")
		This:C1470.selectorRelations:=cs:C1710.button.new("tab.relations")
		This:C1470.selectors:=cs:C1710.group.new(This:C1470.selectorFields; This:C1470.selectorRelations)
		
		This:C1470.empty:=cs:C1710.static.new("empty")
		This:C1470.resources:=cs:C1710.button.new("resources")
		
		This:C1470.form:=Form:C1466.$dialog[Current form name:C1298]
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
		// Local methods
		//This.loadIcons:=Formula(CALL FORM(This.window; "editor_CALLBACK"; "fieldIcons"))
		//This.showPicker:=Formula(CALL FORM(This.window; "editor_CALLBACK"; "pickerShow"; $1))
		
	End if 
	
	//________________________________________________________________
	// Updates the list of fields/reports according to the selected table
Function getFieldList()->$result : Object
	
	
	var $subKey; $key; $t; $tableID : Text
	var $field; $table : Object
	
	var $str : cs:C1710.str
	var $formatters : cs:C1710.path
	
	$result:=New object:C1471(\
		"success"; Form:C1466.dataModel#Null:C1517)
	
	$tableID:=String:C10(This:C1470.tableNumber)
	
	$str:=cs:C1710.str.new()
	
	// ----------------------------------------------------
	If ($result.success)
		
		$result.success:=(Form:C1466.dataModel[$tableID]#Null:C1517)
		
		If ($result.success)
			
			$formatters:=cs:C1710.path.new().hostFormatters()
			
			$result.ids:=New collection:C1472
			$result.names:=New collection:C1472
			$result.labels:=New collection:C1472
			$result.shortLabels:=New collection:C1472
			$result.iconPaths:=New collection:C1472
			$result.icons:=New collection:C1472
			$result.types:=New collection:C1472
			$result.formats:=New collection:C1472
			$result.formatColors:=New collection:C1472
			$result.nameColors:=New collection:C1472
			$result.paths:=New collection:C1472
			
/* TEMPO */$result.tableNumbers:=New collection:C1472
			
			$table:=Form:C1466.dataModel[$tableID]
			
			For each ($key; $table)
				
				Case of 
						
						//……………………………………………………………………………………………………………
					: (Length:C16($key)=0)
						
						// <META-DATA>
						
						//……………………………………………………………………………………………………………
					: (PROJECT.isField($key))\
						 & (Num:C11(This:C1470.selector)=0)
						
						$result.formatColors.push(Foreground color:K23:1)
						$result.nameColors.push(Foreground color:K23:1)
						
						$field:=$table[$key]
						$field.id:=Num:C11($key)
						$result.ids.push($field.id)
						$result.names.push($field.name)
						$result.paths.push($field.name)
						$result.types.push($field.type)
						
/* TEMPO */$result.tableNumbers.push(Num:C11($tableID))
						
						If ($field.label=Null:C1517)
							
							$field.label:=PROJECT.label($field.name)
							
						End if 
						
						$result.labels.push($field.label)
						
						If ($field.shortLabel=Null:C1517)
							
							$field.shortLabel:=$field.label
							
						End if 
						
						$result.shortLabels.push($field.shortLabel)
						$result.iconPaths.push(String:C10($field.icon))
						$result.icons.push(PROJECT.getIcon(String:C10($field.icon)))
						
						If ($field.format#Null:C1517)
							
							//%W-533.1
							If ($field.format[[1]]="/")  // User resources
								
								$t:=Substring:C12($field.format; 2)
								
								If (Not:C34(formatters(New object:C1471(\
									"action"; "isValid"; \
									"format"; $formatters.folder($t))).success))
									
									$result.formatColors[$result.formats.length]:=UI.errorColor  // Missing or invalid
									
								End if 
								
							Else 
								
								$t:=$str.setText("_"+$field.format).localized()
								
							End if 
							//%W+533.1
							
						Else 
							
							$t:=$str.setText("_"+String:C10(SHARED.defaultFieldBindingTypes[$field.fieldType])).localized()
							
						End if 
						
						$result.formats.push($t)
						
						//……………………………………………………………………………………………………………
					: (Value type:C1509($table[$key])#Is object:K8:27)
						
						// <NOTHING MORE TO DO>
						
						//……………………………………………………………………………………………………………
					: (PROJECT.isRelationToOne($table[$key]))
						
						If (Num:C11(This:C1470.selector)=0)
							
							For each ($subKey; $table[$key])
								
								Case of 
										
										//______________________________________________________
									: (Value type:C1509($table[$key][$subKey])#Is object:K8:27)
										
										// <NOTHING MORE TO DO>
										
										//______________________________________________________
									: (PROJECT.isField($subKey))
										
										$result.formatColors.push(Foreground color:K23:1)
										$result.nameColors.push(Foreground color:K23:1)
										
										$field:=$table[$key][$subKey]
										$field.id:=Num:C11($subKey)
										
/* TEMPO */$result.tableNumbers.push(_o_structure(New object:C1471(\
"action"; "tableNumber"; \
"name"; $table[$key].relatedDataClass)).tableNumber)
										
										$result.ids.push($field.id)
										$result.names.push($field.name)
										$result.paths.push($key+"."+$field.name)
										$result.types.push($field.fieldType)
										$result.labels.push($field.label)
										$result.shortLabels.push($field.shortLabel)
										$result.iconPaths.push(String:C10($field.icon))
										$result.icons.push(PROJECT.getIcon(String:C10($field.icon)))
										
										If ($field.format#Null:C1517)
											
											//%W-533.1
											If ($field.format[[1]]="/")  // User resources
												
												$t:=Substring:C12($field.format; 2)
												
												If (Not:C34(formatters(New object:C1471(\
													"action"; "isValid"; \
													"format"; $formatters.folder($t))).success))
													
													$result.formatColors[$result.formats.length]:=UI.errorColor  // Missing or invalid
													
												End if 
												
											Else 
												
												$t:=$str.setText("_"+$field.format).localized()
												
											End if 
											//%W+533.1
											
										Else 
											
											$t:=$str.setText("_"+String:C10(SHARED.defaultFieldBindingTypes[$field.fieldType])).localized()
											
										End if 
										
										$result.formats.push($t)
										
										//______________________________________________________
									Else 
										
										$field:=$table[$key][$subKey]
										
										If (Bool:C1537($field.isToMany))
											
											
											
										Else 
											
											// A "If" statement should never omit "Else" 
											
										End if 
										
										//______________________________________________________
								End case 
								
							End for each 
							
						Else 
							
							If (FEATURE.with("moreRelations"))
								
								$field:=$table[$key]
								
								$result.formatColors.push(Foreground color:K23:1)
								$result.nameColors.push(Foreground color:K23:1)
								
								$result.ids.push(Null:C1517)
								$result.names.push($key)
								$result.paths.push($key)
								$result.types.push(-1)
								
/* TEMPO */$result.tableNumbers.push(Num:C11($tableID))
								
								If (String:C10($field.label)="")
									
									$field.label:=PROJECT.label($key)
									
								End if 
								
								$result.labels.push($field.label)
								
								If (String:C10($field.shortLabel)="")
									
									$field.shortLabel:=$field.label
									
								End if 
								
								$result.shortLabels.push($field.shortLabel)
								$result.iconPaths.push(String:C10($field.icon))
								$result.icons.push(PROJECT.getIcon(String:C10($field.icon)))
								
								If (PROJECT.isLink($table[$key]))
									
									// N -> 1 -> N relation
									
									For each ($subKey; $table[$key])
										
										If (Value type:C1509($table[$key][$subKey])=Is object:K8:27)
											If (Bool:C1537($table[$key][$subKey].isToMany))
												
												$field:=$table[$key][$subKey]
												
												$result.formatColors.push(Foreground color:K23:1)
												$result.nameColors.push(Foreground color:K23:1)
												
												$result.tableNumbers.push(Num:C11($tableID))
												
												$result.ids.push(Null:C1517)
												$result.names.push($field.path)
												$result.paths.push($field.path)
												$result.types.push(-1)
												
												$result.labels.push($field.label)
												$result.shortLabels.push($field.shortLabel)
												$result.iconPaths.push(String:C10($field.icon))
												$result.icons.push(PROJECT.getIcon(String:C10($field.icon)))
												
												$result.formats.push($field.format)
												
											End if 
										End if 
									End for each 
									
								Else 
									
									If (Form:C1466.dataModel[String:C10($field.relatedTableNumber)]=Null:C1517)
										
										$result.nameColors[$result.names.length-1]:=UI.errorColor  // Missing or invalid
										
									End if 
								End if 
								
								$result.formats.push($field.format)
								
							End if 
						End if 
						
						//……………………………………………………………………………………………………………
					: (Num:C11(This:C1470.selector)=0)
						
						//……………………………………………………………………………………………………………
					: (PROJECT.isRelationToMany($table[$key]))
						
						$result.formatColors.push(Foreground color:K23:1)
						$result.nameColors.push(Foreground color:K23:1)
						
						$result.ids.push(Null:C1517)
						$result.names.push($key)
						$result.paths.push($key)
						$result.types.push(-2)
						
/* TEMPO */$result.tableNumbers.push(Num:C11($tableID))
						
						$field:=$table[$key]
						
						If (String:C10($field.label)="")
							
							$field.label:=PROJECT.label($key)
							
						End if 
						
						$result.labels.push($field.label)
						
						If (String:C10($field.shortLabel)="")
							
							$field.shortLabel:=$field.label
							
						End if 
						
						$result.shortLabels.push($field.shortLabel)
						$result.iconPaths.push(String:C10($field.icon))
						$result.icons.push(PROJECT.getIcon(String:C10($field.icon)))
						
						If (Form:C1466.dataModel[String:C10($field.relatedTableNumber)]=Null:C1517)
							
							$result.nameColors[$result.names.length-1]:=UI.errorColor  // Missing or invalid
							
						End if 
						
						$result.formats.push($field.format)
						
						//……………………………………………………………………………………………………………
				End case 
			End for each 
			
			$result.count:=$result.ids.length
			
		Else 
			
			// No table selected
			
		End if 
		
	Else 
		
		// Empty dataModel
		
	End if 
	
	//________________________________________________________________
	// Updates the list of fields/relation according to the selected table
Function updateFieldList
	
	var $o : Object
	var $i : Integer
	
	$o:=This:C1470.getFieldList()
	
	If ($o.success)
		
		This:C1470.empty.setTitle(Choose:C955(Num:C11(This:C1470.selector); "noFieldPublishedForThisTable"; "noPublishedRelationForThisTable"))
		
		COLLECTION TO ARRAY:C1562($o.ids; This:C1470.ids.pointer->)
		COLLECTION TO ARRAY:C1562($o.paths; This:C1470.names.pointer->)
		COLLECTION TO ARRAY:C1562($o.labels; This:C1470.labels.pointer->)
		COLLECTION TO ARRAY:C1562($o.shortLabels; This:C1470.shortLabels.pointer->)
		COLLECTION TO ARRAY:C1562($o.icons; This:C1470.icons.pointer->)
		COLLECTION TO ARRAY:C1562($o.formats; This:C1470.formats.pointer->)
		COLLECTION TO ARRAY:C1562($o.formats; This:C1470.titles.pointer->)
		
		For ($i; 0; $o.count-1; 1)
			
			LISTBOX SET ROW COLOR:C1270(*; This:C1470.names.name; $i+1; $o.nameColors[$i]; lk font color:K53:24)
			LISTBOX SET ROW COLOR:C1270(*; This:C1470.formats.name; $i+1; $o.formatColors[$i]; lk font color:K53:24)
			
		End for 
		
		// Sort by names
		LISTBOX SORT COLUMNS:C916(*; This:C1470.fieldList.name; 2; >)
		
		This:C1470.fieldList.show(Num:C11($o.count)>0)
		
	Else 
		
		This:C1470.empty.setTitle("selectATableToDisplayItsFields")
		
		This:C1470.fieldList.clear()
		This:C1470.fieldList.hide()
		
	End if 
	
	editor_Locked(This:C1470.labels.name; This:C1470.shortLabels.name; This:C1470.formats.name; This:C1470.titles.name)
	
	This:C1470.fieldList.deselect()
	
	editor_ui_LISTBOX(This:C1470.fieldList.name)
	
	//________________________________________________________________
	// Manages the UI of the tab Fields/Relations
Function setTab
	
	var $coordinates; $o : Object
	
	// Set style normal for all selectors
	This:C1470.selectors.fontStyle()
	
	// Then set bold current one
	$o:=This:C1470["selector"+Choose:C955(Num:C11(This:C1470.selector); "Fields"; "Relations")]
	$o.fontStyle(Bold:K14:2)
	
	// Keep the currents elector name
	This:C1470.current:=$o.name
	
	// Update coordinates
	$coordinates:=This:C1470.tabSelector.coordinates
	This:C1470.tabSelector.setCoordinates($o.coordinates.left; $coordinates.top; $o.coordinates.right; $coordinates.bottom)
	
	If (Num:C11(This:C1470.selector)=1)  // Relations
		
		This:C1470.formatLabel.setTitle("titles")
		This:C1470.formats.hide()
		This:C1470.titles.show()
		This:C1470.resources.hide()
		
	Else 
		
		This:C1470.formatLabel.setTitle("formatters")
		This:C1470.formats.show()
		This:C1470.titles.hide()
		This:C1470.resources.show()
		
	End if 
	
	// Update field list
	This:C1470.updateFieldList()
	
	//________________________________________________________________
	// Returns the field associated with the line
Function field($row : Integer)->$field : Object
	
	var $c : Collection
	var $t : Text
	
	If (FEATURE.with("moreRelations"))
		
		If (Num:C11(This:C1470.selector)=1)
			
			//This.fieldList.update()
			
			//%W-533.3
			$c:=Split string:C1554((This:C1470.fieldList.columns["fields"].pointer)->{$row}; ".")
			//%W+533.3
			
			If ($c.length>1)
				
				// 1 -> 1 -> N
				$field:=Form:C1466.dataModel[String:C10(This:C1470.tableNumber)][String:C10($c[0])][String:C10($c[1])]
				
			End if 
		End if 
	End if 
	
	If ($field=Null:C1517)
		
		$c:=Split string:C1554((This:C1470.names.pointer)->{$row}; ".")
		
		If ($c.length>1)  // RelatedDataclass
			
			$field:=Form:C1466.dataModel[String:C10(This:C1470.tableNumber)][$c[0]][String:C10((This:C1470.ids.pointer)->{$row})]
			
		Else 
			
			$t:=(This:C1470.ids.pointer)->{$row}  // Field number
			
			If (Num:C11($t)#0)
				
				$field:=Form:C1466.dataModel[String:C10(This:C1470.tableNumber)][$t]
				
			Else 
				
				// Take the name
				$field:=Form:C1466.dataModel[String:C10(This:C1470.tableNumber)][String:C10($c[0])]
				
			End if 
		End if 
	End if 
	
	//________________________________________________________________
	// Display tips on the field list
Function setHelpTip($e : Object)
	
	var $t : Text
	var $str : cs:C1710.str
	
	$str:=cs:C1710.str.new()  // init class
	
	// ----------------------------------------------------
	If (Num:C11($e.row)#0)
		
		Case of 
				
				//………………………………………………………………………………
			: ($e.columnName=This:C1470.icons.name)
				
				$t:=$str.setText("clickToSet").localized()
				
				//………………………………………………………………………………
			: ($e.columnName=This:C1470.shortLabels.name)
				
				$t:=$str.setText("doubleClickToEdit").localized()+"\r - "+$str.setText("shouldBe10CharOrLess").localized()
				
				//………………………………………………………………………………
			: ($e.columnName=This:C1470.labels.name)
				
				$t:=$str.setText("doubleClickToEdit").localized()+"\r - "+$str.setText("shouldBe25CharOrLess").localized()
				
				//………………………………………………………………………………
			: ($e.columnName=This:C1470.titles.name)
				
				$t:=$str.setText("doubleClickToEdit").localized()
				
				//………………………………………………………………………………
		End case 
		
	Else 
		
		// NO ITEM HOVERED
		
	End if 
	
	This:C1470.fieldList.setHelpTip($t)
	
	//________________________________________________________________
	// Update forms labels
Function updateForms($field : Object; $row : Integer)
	
	// Update forms if any
	var $o : Object
	$o:=Form:C1466.detail[String:C10(This:C1470.tableNumber)]
	
	If ($o#Null:C1517)
		
		If ($field.name=Null:C1517)  //relation
			
			//%W-533.3
			$o:=$o.fields.query("name = :1"; This:C1470.names.pointer->{$row}).pop()
			//%W+533.3
			
		Else 
			
			$o:=$o.fields.query("name = :1"; $field.name).pop()
			
		End if 
		
		If ($o#Null:C1517)
			
			$o.label:=$field.label
			$o.shortLabel:=$field.shortLabel
			
		End if 
	End if 
	
	$o:=Form:C1466.list[String:C10(This:C1470.tableNumber)]
	
	If ($o#Null:C1517)
		
		If ($field.name=Null:C1517)  //relation
			
			//%W-533.3
			$o:=$o.fields.query("name = :1"; This:C1470.names.pointer->{$row}).pop()
			//%W+533.3
			
		Else 
			
			$o:=$o.fields.query("name = :1"; $field.name).pop()
			
		End if 
		
		If ($o#Null:C1517)
			
			$o.label:=$field.label
			$o.shortLabel:=$field.shortLabel
			
		End if 
	End if 
	
	//________________________________________________________________
	// Show the icon picker
Function iconPicker($e : Object)
	
	var $c : Collection
	var $field; $o : Object
	
	$o:=This:C1470.picker.getValue()
	
	If ($o=Null:C1517)  // First use -> load icons
		
		$o:=editor_LoadIcons(New object:C1471(\
			"target"; "fieldIcons"))
		
		This:C1470.picker.setValue($o)
		
	End if 
	
	If (Not:C34(Bool:C1537($o.inited)))
		
		$o.inited:=True:C214  // Stop the re-entry
		
		// Get the current field
		$field:=This:C1470.field($e.row)
		
		// #MARK_TODO WIDGET WORK WITH ARRAY
		If ($field.icon#Null:C1517)
			
			$o.item:=$o.pathnames.indexOf($field.icon)
			$o.item:=$o.item+1
			
		Else 
			
			$o.item:=1  // <none>
			
		End if 
		
		// Update current cell coordinates
		This:C1470.fieldList.cellCoordinates($e.column; $e.row)
		
		$o.row:=$e.row
		$o.left:=This:C1470.fieldList.cellBox.right
		$o.top:=-56
		$o.action:="fieldIcons"
		$o.background:=0x00FFFFFF
		$o.backgroundStroke:=UI.strokeColor
		$o.promptColor:=0x00FFFFFF
		$o.promptBackColor:=UI.strokeColor
		$o.hidePromptSeparator:=True:C214
		$o.forceRedraw:=True:C214
		//%W-533.3
		$o.prompt:=cs:C1710.str.new("chooseAnIconForTheField").localized((This:C1470.fieldList.columns["fields"].pointer)->{$e.row})
		//%W+533.3
		
		// This.showPicker($o)
		CALL FORM:C1391(This:C1470.window; "editor_CALLBACK"; "pickerShow"; $o)
		
	Else 
		
		$o.inited:=False:C215
		
	End if 
	
	//________________________________________________________________
	// Manage the format menu according to the field type
Function format($e : Object)
	
	var $format; $t : Text
	var $field; $o : Object
	var $c : Collection
	var $menu : cs:C1710.menu
	
	// Get the field definition
	$field:=This:C1470.field($e.row)
	
	$menu:=cs:C1710.menu.new()
	
	// Get current format
	If ($field.format=Null:C1517)
		
		// Default value
		$format:=SHARED.defaultFieldBindingTypes[$field.fieldType]
		
	Else 
		
		If (Value type:C1509($field.format)=Is object:K8:27)
			
			$format:=String:C10($field.format.name)
			
		Else 
			
			// Internal
			$format:=$field.format
			
		End if 
	End if 
	
	For each ($o; formatters(New object:C1471(\
		"action"; "getByType"; \
		"type"; $field.fieldType)).formatters)
		
		$t:=String:C10($o.name)
		
		If ($t="-")
			
			$menu.line()
			
		Else 
			
			$menu.append(cs:C1710.str.new("_"+$t).localized(); $t; $format=$t)
			
		End if 
	End for each 
	
	// Append user formatters if any
	$c:=formatters(New object:C1471("action"; "getByType"; "host"; True:C214; "type"; Num:C11($field.fieldType))).formatters
	
	If ($c.length>0)
		
		$menu.line()
		
		For each ($o; $c)
			
			$menu.append($o.name; "/"+$o.name; $format=("/"+$o.name))
			
		End for each 
	End if 
	
	If (This:C1470.fieldList.popup($menu).selected)
		
		// Update data model
		$field.format:=$menu.choice
		
		// Update me
		//%W-533.3
		//%W-533.1
		If ($menu.choice[[1]]="/")
			
			// User resources
			Self:C308->{$e.row}:=Substring:C12($menu.choice; 2)
			
		Else 
			
			Self:C308->{$e.row}:=cs:C1710.str.new("_"+$menu.choice).localized()
			
		End if 
		//%W+533.1
		//%W+533.3
		
		PROJECT.save()
		
	End if 
	
	This:C1470.fieldList.focus()
	This:C1470.fieldList.select($e.row)
	
	editor_ui_LISTBOX(This:C1470.fieldList.name)
	