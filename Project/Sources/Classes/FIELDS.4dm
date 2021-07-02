Class extends form

//=== === === === === === === === === === === === === === === === === === === === ===
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
	
	This:C1470.listbox("fieldList"; "01_fields")
	This:C1470.widget("ids")
	This:C1470.widget("names")
	This:C1470.widget("icons")
	This:C1470.widget("labels"; "label")
	This:C1470.widget("shortLabels"; "shortLabel")
	This:C1470.widget("formats"; "format")
	This:C1470.formObject("formatLabel")
	This:C1470.widget("titles")
	
	
	This:C1470.widget("picker")
	
	This:C1470.widget("tabSelector")
	This:C1470.tabSelector.data:=0
	
	var $group : cs:C1710.group
	$group:=This:C1470.group("selectors")
	This:C1470.button("selectorFields").addToGroup($group)
	This:C1470.button("selectorRelations").addToGroup($group)
	
	This:C1470.formObject("empty")
	This:C1470.button("resources")
	
	// Link to the TABLES panel
	This:C1470.tableLink:=Formula:C1597(panel("TABLES").currentTableNumber)
	
	//This.form:=Form.$dialog[This.name]  // ????????????????????????????
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	// This trick remove the horizontal gap
	This:C1470.fieldList.setScrollbars(False:C215; 2)
	
	// Place the tabs according to the localization
	This:C1470.selectors.distributeLeftToRight()
	
	// Place the download button
	This:C1470.resources.setTitle(EDITOR.str.setText("downloadMoreResources").localized(Lowercase:C14(Get localized string:C991("formatters"))))
	This:C1470.resources.bestSize(Align right:K42:4)
	
	// Initialize the Fields/Relations tab
	This:C1470.setTab()
	
	// Update widget pointers after a reload
	This:C1470.ids.updatePointer()
	This:C1470.names.updatePointer()
	This:C1470.icons.updatePointer()
	This:C1470.labels.updatePointer()
	This:C1470.shortLabels.updatePointer()
	This:C1470.formats.updatePointer()
	This:C1470.titles.updatePointer()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Update UI
Function update()
	
	This:C1470.tableNumber:=This:C1470.tableLink.call()
	This:C1470.updateFieldList()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Updates the list of fields/relation according to the selected table
Function updateFieldList
	
	var $i : Integer
	var $enterable : Boolean
	var $o : Object
	
	$o:=This:C1470.getFieldList()
	
	If ($o.success)
		
		This:C1470.empty.setTitle(Choose:C955(Num:C11(This:C1470.tabSelector.data); "noFieldPublishedForThisTable"; "noPublishedRelationForThisTable"))
		
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
	
	$enterable:=PROJECT.isNotLocked()
	This:C1470.labels.enterable($enterable)
	This:C1470.shortLabels.enterable($enterable)
	This:C1470.formats.enterable($enterable)
	This:C1470.titles.enterable($enterable)
	
	This:C1470.fieldList.unselect()
	
	editor_ui_LISTBOX(This:C1470.fieldList.name)
	
	If (Num:C11(This:C1470.tabSelector.data)=1)  // Relations
		
		tempoDatamodelWith1toNRelation(This:C1470.tableNumber)
		
	Else 
		
		androidLimitations(False:C215; "")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Updates the list of fields/reports according to the selected table
Function getFieldList()->$result : Object
	
	var $subKey; $key; $label; $tableID : Text
	var $field; $table : Object
	
	var $str : cs:C1710.str
	var $formatters : cs:C1710.path
	var $formater : cs:C1710.formater
	
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
						 & (Num:C11(This:C1470.tabSelector.data)=0)
						
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
							
							$formater:=cs:C1710.formater.new($field.format)
							
							If ($formater.host)
								
								If (Not:C34($formater.isValid()))
									
									$label:=$formater.label
									$result.formatColors[$result.formats.length]:=EDITOR.errorColor  // Missing or invalid
									
								Else 
									
									$label:=$formater.source.name
									
								End if 
								
							Else 
								
								$label:=$str.setText("_"+$field.format).localized()
								
							End if 
							
						Else 
							
							$label:=$str.setText("_"+String:C10(SHARED.defaultFieldBindingTypes[$field.fieldType])).localized()
							
						End if 
						
						$result.formats.push($label)
						
						//……………………………………………………………………………………………………………
					: (Value type:C1509($table[$key])#Is object:K8:27)
						
						// <NOTHING MORE TO DO>
						
						//……………………………………………………………………………………………………………
					: (PROJECT.isRelationToOne($table[$key]))
						
						If (Num:C11(This:C1470.tabSelector.data)=0)
							
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
											
											$formater:=cs:C1710.formater.new($field.format)
											
											If ($formater.host)
												
												If (Not:C34($formater.isValid()))
													
													$label:=$formater.label
													$result.formatColors[$result.formats.length]:=EDITOR.errorColor  // Missing or invalid
													
												Else 
													
													$label:=$formater.source.name
													
												End if 
												
											Else 
												
												$label:=$str.setText("_"+$field.format).localized()
												
											End if 
											
										Else 
											
											$label:=$str.setText("_"+String:C10(SHARED.defaultFieldBindingTypes[$field.fieldType])).localized()
											
										End if 
										
										$result.formats.push($label)
										
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
							$result.formats.push($field.format)
							
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
									
									$result.nameColors[$result.names.length-1]:=EDITOR.errorColor  // Missing or invalid
									
								End if 
							End if 
							
						End if 
						
						//……………………………………………………………………………………………………………
					: (Num:C11(This:C1470.tabSelector.data)=0)
						
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
							
							$result.nameColors[$result.names.length-1]:=EDITOR.errorColor  // Missing or invalid
							
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
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Manages the UI of the tab Fields/Relations
Function setTab()
	
	var $coordinates; $o : Object
	
	// Set style normal for all selectors
	This:C1470.selectors.setFontStyle()
	
	// Then set bold current one
	$o:=This:C1470["selector"+Choose:C955(Num:C11(This:C1470.tabSelector.data); "Fields"; "Relations")]
	$o.setFontStyle(Bold:K14:2)
	
	// Keep the currents elector name
	This:C1470.current:=$o.name
	
	// Update coordinates
	$coordinates:=This:C1470.tabSelector.coordinates
	This:C1470.tabSelector.setCoordinates($o.coordinates.left; $coordinates.top; $o.coordinates.right; $coordinates.bottom)
	
	If (Num:C11(This:C1470.tabSelector.data)=1)  // Relations
		
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
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Returns the field associated with the line
Function field($row : Integer)->$field : Object
	
	var $c : Collection
	var $t : Text
	
	If (Num:C11(This:C1470.tabSelector.data)=1)
		
		//%W-533.3
		$c:=Split string:C1554((This:C1470.fieldList.columns["fields"].pointer)->{$row}; ".")
		//%W+533.3
		
		If ($c.length>1)
			
			// 1 -> 1 -> N
			$field:=Form:C1466.dataModel[String:C10(This:C1470.tableNumber)][String:C10($c[0])][String:C10($c[1])]
			
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
	
	//=== === === === === === === === === === === === === === === === === === === === ===
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
			: ($e.columnName=This:C1470.formats.name)
				
				var $field : Object
				$field:=This:C1470.field($e.row)
				If ($field#Null:C1517)
					If (Length:C16(String:C10($field.format))#0)
						$t:=cs:C1710.formater.new($field.format).toolTip()
					End if 
				End if 
				
				//………………………………………………………………………………
		End case 
		
	Else 
		
		// NO ITEM HOVERED
		
	End if 
	
	This:C1470.fieldList.setHelpTip($t)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Update forms
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
			$o.format:=$field.format
			
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
			$o.format:=$field.format
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Show the icon picker
Function doShowIconPicker($e : Object)
	
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
		$o.top:=-40
		$o.action:="fieldIcons"
		$o.background:=0x00FFFFFF
		$o.backgroundStroke:=EDITOR.strokeColor
		$o.promptColor:=0x00FFFFFF
		$o.promptBackColor:=EDITOR.strokeColor
		$o.hidePromptSeparator:=True:C214
		$o.forceRedraw:=True:C214
		//%W-533.3
		$o.prompt:=cs:C1710.str.new("chooseAnIconForTheField").localized((This:C1470.fieldList.columns["names"].pointer)->{$e.row})
		//%W+533.3
		
		This:C1470.callMeBack("pickerShow"; $o)
		
	Else 
		
		$o.inited:=False:C215
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function doGetResources()
	
	If (FEATURE.with("formatMarketPlace"))
		
		// Show browser
		This:C1470.callMeBack("initBrowser"; New object:C1471(\
			"url"; Get localized string:C991("res_formatters")))
		
	Else 
		
		OPEN URL:C673(Get localized string:C991("res_formatters"); *)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Show format on disk
Function formatShowOnDisk($e : Object)
	
	var $format : Text
	var $field; $o : Object
	
	$field:=This:C1470.field($e.row)  // Get the field definition
	
	// Get current format
	If ($field.format#Null:C1517)
		
		If (Value type:C1509($field.format)=Is object:K8:27)
			
			// Get the name
			$format:=String:C10($field.format.name)
			
		Else 
			
			$format:=$field.format
			
		End if 
	End if 
	
	// Show on disk if host
	$o:=cs:C1710.formater.new($format)
	
	If (Bool:C1537($o.host))
		
		SHOW ON DISK:C922($o.source.platformPath)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Manage the format menu according to the field type
Function formatMenu($e : Object)
	
	var $format; $t : Text
	var $field; $o : Object
	var $formatters : Collection
	var $menu : cs:C1710.menu
	var $str : cs:C1710.str
	var $formatter : cs:C1710.formater
	
	// Get the field definition
	$field:=This:C1470.field($e.row)
	
	$menu:=cs:C1710.menu.new()
	$str:=cs:C1710.str.new()
	$formatter:=cs:C1710.formater.new()
	
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
	
	For each ($o; $formatter.getByType(Num:C11($field.fieldType)))
		
		$t:=String:C10($o.name)
		
		If ($t="-")
			
			$menu.line()
			
		Else 
			
			$menu.append($str.setText("_"+$t).localized(); $t; $format=$t)
			
		End if 
	End for each 
	
	// Append user formatters if any
	$formatters:=$formatter.getByType(Num:C11($field.fieldType); True:C214)
	
	If ($formatters.length>0)
		
		$menu.line()
		
		For each ($o; $formatters.orderBy("name"))
			
			$menu.append($o.name; $o.source.name; $format=$o.source.name)
			
		End for each 
	End if 
	
	If (FEATURE.with("newFormatterChoiceList"))
		
		If (($field.fieldType=Is alpha field:K8:1)\
			 | ($field.fieldType=Is boolean:K8:9)\
			 | ($field.fieldType=Is integer:K8:5)\
			 | ($field.fieldType=Is longint:K8:6)\
			 | ($field.fieldType=Is integer 64 bits:K8:25)\
			 | ($field.fieldType=Is real:K8:4)\
			 | ($field.fieldType=Is text:K8:3)\
			)
			$menu.line()
			
			$menu.append(".New choice list ..."/*TODO newFormatterChoiceList localize*/; "$new"; False:C215)
			
		End if 
		
	End if 
	
	If (This:C1470.fieldList.popup($menu).selected)
		
		If ($menu.choice="$new")
			
			$menu.choice:=Request:C163(".Name of the format"/*TODO newFormatterChoiceList localize*/)
			
			If (Length:C16($menu.choice)#0)
				
				$menu.choice:="/"+$menu.choice
				$o:=cs:C1710.formater.new($menu.choice)
				
				var $table : Object
				$table:=Form:C1466.dataModel[String:C10(This:C1470.tableNumber)]
				var $data : Collection
				$data:=ds:C1482[$table[""].name].all().extract($field.name).distinct()  // XXX maybe limit size
				
				var $manifestFile : 4D:C1709.File
				$manifestFile:=$o.create($field.fieldType; $data)
				
				$formatters.push(New object:C1471(\
					"name"; $o.label; \
					"source"; $o))
				
				// Open JSON file, but we could open a custom format editor instead
				OPEN URL:C673($manifestFile.platformPath)
				
			End if 
		End if 
		
		If (Length:C16($menu.choice)#0)
			
			// Update data model
			$field.format:=$menu.choice
			
			// Update me
			//%W-533.3
			If (PROJECT.isCustomResource($menu.choice))
				
				// User resources
				$o:=$formatters.query("source.name = :1"; $menu.choice).pop()
				Self:C308->{$e.row}:=$o.source.label
				
			Else 
				
				Self:C308->{$e.row}:=$str.setText("_"+$menu.choice).localized()
				
			End if 
			//%W+533.3
			
			This:C1470.updateForms($field; $e.row)
			
			// Remove error color if any
			LISTBOX SET ROW COLOR:C1270(*; This:C1470.formats.name; $e.row; Foreground color:K23:1; lk font color:K53:24)
			
			PROJECT.save()
			
		End if 
		
	End if 
	
	This:C1470.fieldList.focus()
	This:C1470.fieldList.select($e.row)
	
	editor_ui_LISTBOX(This:C1470.fieldList.name)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Manage the tags menu for label & shortlabel
Function tagMenu($e : Object; $values : Collection)
	
	var $t : Text
	var $isSelected : Boolean
	var $end; $start : Integer
	var $menu : cs:C1710.menu
	
	$menu:=cs:C1710.menu.new()
	
	For each ($t; $values)
		
		$menu.append($t; "%"+$t+"%")
		
	End for each 
	
	If ($e.code=On Before Keystroke:K2:6)
		
		This:C1470.fieldList.popup($menu; $values[0])
		
	Else 
		
		$menu.popup($values[0])
		
	End if 
	
	If ($menu.selected)
		
		$t:=Get edited text:C655
		GET HIGHLIGHT:C209(*; $e.columnName; $start; $end)
		
		$isSelected:=($end>$start)
		
		If ($isSelected)
			
			// Replace the selection by the string to be inserted
			// and select the added chain.
			$t:=Substring:C12($t; 1; $start-1)+$menu.choice+Substring:C12($t; $end)
			$end:=$end+Length:C16($menu.choice)
			HIGHLIGHT TEXT:C210(*; $e.columnName; $start; $end)
			
		Else 
			
			$t:=Substring:C12($t; 1; $start-1)+$menu.choice+Substring:C12($t; $end)
			$end:=$start+Length:C16($menu.choice)
			
			HIGHLIGHT TEXT:C210(*; $e.columnName; $end; $end)
			
		End if 
		
		//%W-533.3
		Self:C308->{Self:C308->}:=$t
		//%W+533.3
		
		This:C1470.field($e.row)[$e.columnName]:=$t
		
	End if 