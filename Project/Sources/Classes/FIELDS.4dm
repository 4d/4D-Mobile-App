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
	
	// Add the events that we cannot select in the form properties 😇
	This:C1470.appendEvents(New collection:C1472(\
		On Data Change:K2:15; \
		On Before Data Entry:K2:39))
	
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
		
		If (Not:C34(FEATURE.with("android1ToNRelations")))
			
			tempoDatamodelWith1toNRelation(This:C1470.tableNumber)
			
		End if 
		
	Else 
		
		androidLimitations(False:C215; "")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Updates the list of fields/reports according to the selected table
Function getFieldList()->$result : Object
	
	var $key; $subKey; $tableID : Text
	var $field; $table : Object
	var $target : Collection
	var $formatters : 4D:C1709.Folder
	
	$result:=New object:C1471(\
		"success"; Form:C1466.dataModel#Null:C1517)
	
	$tableID:=String:C10(This:C1470.tableNumber)
	
	// ----------------------------------------------------
	If ($result.success)
		
		$result.success:=(Form:C1466.dataModel[$tableID]#Null:C1517)
		
		If ($result.success)
			
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
			
			$target:=Value type:C1509(PROJECT.info.target)=Is collection:K8:32 ? PROJECT.info.target : New collection:C1472(PROJECT.info.target)
			
			For each ($key; $table)
				
				Case of 
						
						//……………………………………………………………………………………………………………
					: (Length:C16($key)=0)
						
						// <META-DATA>
						
						//……………………………………………………………………………………………………………
					: (PROJECT.isField($key))\
						 & (Num:C11(This:C1470.tabSelector.data)=0)
						
						
						$field:=$table[$key]
						$field.id:=Num:C11($key)
						
						$field.label:=($field.label#Null:C1517) ? $field.label : PROJECT.label($field.name)
						$field.shortLabel:=($field.shortLabel#Null:C1517) ? $field.shortLabel : $field.label
						
						
						//mark:-
/* TEMPO */$result.tableNumbers.push(Num:C11($tableID))
						$result.ids.push($field.id)
						$result.names.push($field.name)
						$result.paths.push($field.name)
						$result.types.push($field.type)
						$result.labels.push($field.label)
						$result.shortLabels.push($field.shortLabel)
						$result.iconPaths.push(String:C10($field.icon))
						$result.formatColors.push(Foreground color:K23:1)
						$result.nameColors.push(Foreground color:K23:1)
						$result.icons.push(PROJECT.getIcon(String:C10($field.icon)))
						$result.formats.push(This:C1470._computeFormat($field; $result; $target))
						
						//……………………………………………………………………………………………………………
					: (Value type:C1509($table[$key])#Is object:K8:27)
						
						// <NOTHING MORE TO DO>
						
						//……………………………………………………………………………………………………………
					: (PROJECT.isComputedAttribute($table[$key]))\
						 & (Num:C11(This:C1470.tabSelector.data)=0)
						
						$field:=$table[$key]
						
						$field.label:=($field.label#Null:C1517) ? $field.label : PROJECT.label($field.name)
						$field.shortLabel:=($field.shortLabel#Null:C1517) ? $field.shortLabel : $field.label
						
						//mark:-
/* TEMPO */$result.tableNumbers.push(Num:C11($tableID))
						$result.ids.push(0)
						$result.names.push($field.name)
						$result.paths.push($field.name)
						$result.types.push($field.fieldType)
						$result.labels.push($field.label)
						$result.shortLabels.push($field.shortLabel)
						$result.iconPaths.push(String:C10($field.icon))
						$result.formatColors.push(Foreground color:K23:1)
						$result.nameColors.push(Foreground color:K23:1)
						$result.icons.push(PROJECT.getIcon(String:C10($field.icon)))
						$result.formats.push(This:C1470._computeFormat($field; $result; $target))
						
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
										
										$field:=$table[$key][$subKey]
										$field.id:=Num:C11($subKey)
										
										$result.tableNumbers.push(ds:C1482[$table[$key].relatedDataClass].getInfo().tableNumber)
										$result.ids.push($field.id)
										$result.names.push($field.name)
										$result.paths.push($key+"."+$field.name)
										$result.types.push($field.fieldType)
										$result.labels.push($field.label)
										$result.shortLabels.push($field.shortLabel)
										$result.iconPaths.push(String:C10($field.icon))
										$result.formatColors.push(Foreground color:K23:1)
										$result.nameColors.push(Foreground color:K23:1)
										$result.icons.push(PROJECT.getIcon(String:C10($field.icon)))
										$result.formats.push(This:C1470._computeFormat($field; $result; $target))
										
										//______________________________________________________
									: (PROJECT.isComputedAttribute($table[$key][$subKey]))
										
										$field:=$table[$key][$subKey]
										
										$result.tableNumbers.push(ds:C1482[$table[$key].relatedDataClass].getInfo().tableNumber)
										$result.ids.push(-3)
										$result.names.push($field.name)
										$result.paths.push($key+"."+$field.name)
										$result.types.push($field.fieldType)
										$result.labels.push($field.label)
										$result.shortLabels.push($field.shortLabel)
										$result.iconPaths.push(String:C10($field.icon))
										$result.formatColors.push(Foreground color:K23:1)
										$result.nameColors.push(Foreground color:K23:1)
										$result.icons.push(PROJECT.getIcon(String:C10($field.icon)))
										$result.formats.push(This:C1470._computeFormat($field; $result; $target))
										
										//______________________________________________________
									Else 
										
										$field:=$table[$key][$subKey]
										
										If (Bool:C1537($field.isToMany))
											
											//todo: many to may
											
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
	
	var $t : Text
	var $c : Collection
	
	If (Num:C11(This:C1470.tabSelector.data)=1)
		
		$t:=(This:C1470.fieldList.columns["names"].pointer)->{$row}
		$c:=Split string:C1554($t; ".")
		
		If ($c.length>1)
			
			// 1 -> 1 -> N
			$field:=Form:C1466.dataModel[String:C10(This:C1470.tableNumber)][String:C10($c[0])][String:C10($c[1])]
			
		End if 
	End if 
	
	If ($field=Null:C1517)
		
		$t:=(This:C1470.names.pointer)->{$row}
		$c:=Split string:C1554($t; ".")
		
		If ($c.length>1)  // RelatedDataclass
			
			If (Num:C11((This:C1470.ids.pointer)->{$row})=-3)  // Computed attribute
				
				$field:=Form:C1466.dataModel[String:C10(This:C1470.tableNumber)][$c[0]][$c[1]]
				
			Else 
				
				$field:=Form:C1466.dataModel[String:C10(This:C1470.tableNumber)][$c[0]][String:C10((This:C1470.ids.pointer)->{$row})]
				
			End if 
			
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
	
	var $tips : Text
	
	// ----------------------------------------------------
	If (Num:C11($e.row)#0)
		
		Case of 
				
				//………………………………………………………………………………
			: ($e.columnName=This:C1470.icons.name)
				
				$tips:=EDITOR.str.setText("clickToSet").localized()
				
				//………………………………………………………………………………
			: ($e.columnName=This:C1470.shortLabels.name)
				
				$tips:=EDITOR.str.setText("doubleClickToEdit").localized()+"\r - "+EDITOR.str.setText("shouldBe10CharOrLess").localized()
				
				//………………………………………………………………………………
			: ($e.columnName=This:C1470.labels.name)
				
				$tips:=EDITOR.str.setText("doubleClickToEdit").localized()+"\r - "+EDITOR.str.setText("shouldBe25CharOrLess").localized()
				
				//………………………………………………………………………………
			: ($e.columnName=This:C1470.titles.name)
				
				$tips:=EDITOR.str.setText("doubleClickToEdit").localized()
				
				//………………………………………………………………………………
			: ($e.columnName=This:C1470.formats.name)
				
				var $field : Object
				$field:=This:C1470.field($e.row)
				
				If ($field#Null:C1517)
					
					If (Length:C16(String:C10($field.format))#0)
						
						$tips:=cs:C1710.formater.new($field.format).toolTip("hostFormatters")
						
					End if 
				End if 
				
				//………………………………………………………………………………
		End case 
		
	Else 
		
		// NO ITEM HOVERED
		
	End if 
	
	This:C1470.fieldList.setHelpTip($tips)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Update forms if any
Function updateForms($field : Object; $row : Integer)
	
	This:C1470._updateForms("detail"; $field; $row)
	This:C1470._updateForms("list"; $field; $row)
	
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
		$o.prompt:=EDITOR.str.setText("chooseAnIconForTheField").localized((This:C1470.fieldList.columns["names"].pointer)->{$e.row})
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
Function showFormatOnDisk($e : Object)
	
	var $format : Text
	var $field; $o : Object
	
	$e:=$e=Null:C1517 ? FORM Event:C1606 : $e
	
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
Function doFormatMenu($e : Object)
	
	var $format; $t : Text
	var $field; $o : Object
	var $formatters : Collection
	var $menu : cs:C1710.menu
	var $formatter : cs:C1710.formater
	
	$e:=$e=Null:C1517 ? FORM Event:C1606 : $e
	
	// Get the field definition
	$field:=This:C1470.field($e.row)
	
	$menu:=cs:C1710.menu.new()
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
			
			$menu.append(EDITOR.str.setText("_"+$t).localized(); $t; $format=$t)
			
		End if 
	End for each 
	
	// Append user formatters if any
	$formatters:=$formatter.getByType(Num:C11($field.fieldType); True:C214)
	
	If ($formatters.length>0)
		
		$menu.line()
		
		For each ($o; $formatters.orderBy("name"))
			
			$menu.append($o.name; $o.source.name; $format=$o.source.name).setStyle(Italic:K14:3)
			
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
			
			$menu.append("newChoiceList"; "$new")
			
		End if 
	End if 
	
	If (This:C1470.fieldList.popup($menu).selected)
		
		If ($menu.choice="$new")
			
			$menu.choice:=Request:C163(Get localized string:C991("formatName"))
			
			If (Bool:C1537(OK))\
				 & (Length:C16($menu.choice)#0)
				
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
			var $ptr : Pointer
			$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; $e.columnName)
			
			//%W-533.3
			If (PROJECT.isCustomResource($menu.choice))
				
				// User resources
				$o:=$formatters.query("source.name = :1"; $menu.choice).pop()
				$ptr->{$e.row}:=$o.source.label
				
			Else 
				
				$ptr->{$e.row}:=EDITOR.str.setText("_"+$menu.choice).localized()
				
			End if 
			//%W+533.3
			
			This:C1470.updateForms($field; $e.row)
			PROJECT.save()
			
			// Remove error color if any
			LISTBOX SET ROW COLOR:C1270(*; This:C1470.formats.name; $e.row; Foreground color:K23:1; lk font color:K53:24)
			
		End if 
	End if 
	
	This:C1470.fieldList.focus()
	This:C1470.fieldList.select($e.row)
	
	editor_ui_LISTBOX(This:C1470.fieldList.name)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Manage the tags menu for label & shortlabel
Function doTagMenu($e : Object; $values : Collection)
	
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
		
		FILTER KEYSTROKE:C389("")
		
		$t:=Get edited text:C655
		GET HIGHLIGHT:C209(*; $e.columnName; $start; $end)
		
		$isSelected:=($end>$start)
		
		If ($isSelected)
			
			// Replace the selection by the string to be inserted
			// and select the added chain.
			$t:=Substring:C12($t; 1; $start-1)+$menu.choice+Substring:C12($t; $end)
			$end:=$end+Length:C16($menu.choice)
			
		Else 
			
			$t:=Substring:C12($t; 1; $start-1)+$menu.choice+Substring:C12($t; $end)
			$end:=$start+Length:C16($menu.choice)
			$start:=$end
			
		End if 
		
		var $ptr : Pointer
		$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; $e.columnName)
		//%W-533.3
		$ptr->{$ptr->}:=$t
		//%W+533.3
		
		If ($e.columnName="titles")
			
			This:C1470.field($e.row)["format"]:=$t
			
		Else 
			
			This:C1470.field($e.row)[$e.columnName]:=$t
			
		End if 
		
		HIGHLIGHT TEXT:C210(*; $e.columnName; $start; $end)
		
	End if 
	
	// MARK:-[PRIVATE]
	//=== === === === === === === === === === === === === === === === === === === === ===
Function _computeFormat($field : Object; $result : Object)->$label : Text
	
	var $manifest : Object
	var $target : Collection
	var $formater : cs:C1710.formater
	
	If ($field.format#Null:C1517)
		
		$formater:=cs:C1710.formater.new($field.format)
		
		If ($formater.host)
			
			If ($formater.isValid())
				
				$label:=$formater.source.name
				
				$target:=Value type:C1509(PROJECT.info.target)=Is collection:K8:32 ? PROJECT.info.target : New collection:C1472(PROJECT.info.target)
				
				$manifest:=JSON Parse:C1218($formater.source.file("manifest.json").getText())
				$manifest.type:=(Value type:C1509($manifest.type)=Is collection:K8:32) ? $manifest.type : New collection:C1472(String:C10($manifest.type))
				
				If ($manifest.target#Null:C1517)
					
					$manifest.target:=(Value type:C1509($manifest.target)=Is collection:K8:32) ? $manifest.target : New collection:C1472(String:C10($manifest.target))
					
				Else 
					
					$formater._setTarget($manifest; $formater)
					
				End if 
				
				If (Not:C34((($manifest.target.length=2) & ($target.length=2))\
					 || (($target.length=1) & ($manifest.target.indexOf($target[0])#-1))))
					
					$result.formatColors[$result.formats.length]:=EDITOR.errorColor  // Not compatible with the target
					
				End if 
				
			Else 
				
				$label:=$formater.label
				$result.formatColors[$result.formats.length]:=EDITOR.errorColor  // Missing or invalid
				
			End if 
			
		Else 
			
			$label:=EDITOR.str.setText("_"+$field.format).localized()
			
		End if 
		
	Else 
		
		$label:=EDITOR.str.setText("_"+String:C10(SHARED.defaultFieldBindingTypes[$field.fieldType])).localized()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function _updateForms($type : Text; $field : Object; $row : Integer)
	
	var $o : Object
	
	$o:=Form:C1466[$type][String:C10(This:C1470.tableNumber)]
	
	If ($o.fields#Null:C1517)
		
		If ($field.name=Null:C1517)  //relation
			
			$o:=$o.fields.query("name = :1"; (This:C1470.names.pointer)->{$row}).pop()
			
		Else 
			
			$o:=$o.fields.query("name = :1"; $field.name).pop()
			
		End if 
		
		If ($o#Null:C1517)
			
			$o.label:=$field.label
			$o.shortLabel:=$field.shortLabel
			$o.format:=$field.format
			
			If (Length:C16(String:C10($field.icon))>0)
				
				$o.icon:=$field.icon
				
			Else 
				
				OB REMOVE:C1226($o; "icon")
				
			End if 
		End if 
	End if 
	