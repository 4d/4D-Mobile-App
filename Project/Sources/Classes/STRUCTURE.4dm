Class extends panel

// === === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($form : Object)
	
	Super:C1705(Formula:C1597(editor_CALLBACK).source)
	
	//This.context:=Super.init()
	
	//If (OB Is empty(This.context))
	
	This:C1470.init()
	
	//// Constraints definition
	//cs.ob.new(This.context).createPath("constraints.rules"; Is collection)
	
	//End if
	
	// FIXME:TEMPO
	This:C1470.form:=$form
	
	// MARK:-[Computed attributse]
	// MARK:-
	// === === === === === === === === === === === === === === === === === === === === ===
Function get tablesPtr()->$ptr : Pointer
	
	$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; String:C10(This:C1470.form.tables))
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get fieldsPtr()->$ptr : Pointer
	
	$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; String:C10(This:C1470.form.fields))
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get iconsPtr()->$ptr : Pointer
	
	$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; String:C10(This:C1470.form.icons))
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get publishedPtr()->$ptr : Pointer
	
	$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; String:C10(This:C1470.form.published))
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get context()->$context : Object
	
	$context:=Form:C1466.$dialog.STRUCTURE
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get ExposedStructure()->$structure : Object
	
	$structure:=Form:C1466.$project.ExposedStructure
	
	// MARK:-[FUNCTIONS]
	// MARK:-
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Design definition
Function init()
	
	This:C1470.toBeInitialized:=False:C215
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Builds the list of fields for the selected table
Function tableList()
	
	var $index; $row : Integer
	var $tablesPtr : Pointer
	var $dataModel; $form; $ƒ : Object
	var $catalog : Collection
	var $table : cs:C1710.table
	
	$ƒ:=Form:C1466.$dialog.STRUCTURE
	$dataModel:=Form:C1466.dataModel
	
	$form:=This:C1470.form
	
	$tablesPtr:=This:C1470.tablesPtr
	CLEAR VARIABLE:C89($tablesPtr->)
	
	$catalog:=PROJECT.getCatalog()
	
	Case of 
			
			//________________________________________
		: ($catalog=Null:C1517)
			
			// NOTHING MORE TO DO
			
			//______________________________________________________
		: (Length:C16(String:C10($ƒ.tableFilter))>0)\
			 & (Bool:C1537($ƒ.tableFilterPublished))
			
			For each ($table; $catalog)
				
				If (Position:C15($ƒ.tableFilter; $table.name)>0)\
					 & ($dataModel[String:C10($table.tableNumber)]#Null:C1517)
					
					APPEND TO ARRAY:C911($tablesPtr->; $table.name)
					
				End if 
			End for each 
			
			//______________________________________________________
		: (Length:C16(String:C10($ƒ.tableFilter))>0)  // Filter by name
			
			For each ($table; $catalog)
				
				If (Position:C15($ƒ.tableFilter; $table.name)>0)
					
					APPEND TO ARRAY:C911($tablesPtr->; $table.name)
					
				End if 
			End for each 
			
			//______________________________________________________
		: (Bool:C1537($ƒ.tableFilterPublished))  // Filter published
			
			For each ($table; $catalog)
				
				If ($dataModel[String:C10($table.tableNumber)]#Null:C1517)
					
					APPEND TO ARRAY:C911($tablesPtr->; $table.name)
					
				End if 
			End for each 
			
			//______________________________________________________
		Else   // No filter
			
			COLLECTION TO ARRAY:C1562($catalog; $tablesPtr->; "name")
			
			//______________________________________________________
	End case 
	
	// ----------------------
	// HIGHLIGHT ERRORS
	// ----------------------
	For each ($table; $catalog)
		
		If (Find in array:C230($tablesPtr->; $table.name)>0)
			
			$row:=$row+1
			
			If (UI.unsynchronizedTables=Null:C1517)\
				 || (UI.unsynchronizedTables.length<=$table.tableNumber)\
				 || (UI.unsynchronizedTables[$table.tableNumber]=Null:C1517)
				
				LISTBOX SET ROW COLOR:C1270(*; $form.tableList; $row; lk inherited:K53:26; lk font color:K53:24)
				
			Else 
				
				LISTBOX SET ROW COLOR:C1270(*; $form.tableList; $row; UI.errorColor; lk font color:K53:24)
				
			End if 
			
			// Highlight published table name
			LISTBOX SET ROW FONT STYLE:C1268(*; $form.tableList; $row; Choose:C955($dataModel[String:C10($table.tableNumber)]=Null:C1517; Plain:K14:1; Bold:K14:2))
			
		End if 
	End for each 
	
	// Sort if any
	If (Bool:C1537($ƒ.tableSortByName))
		
		LISTBOX SORT COLUMNS:C916(*; $form.tableList; 1; >)
		
	End if 
	
	// Select the first table if any
	If ($ƒ.currentTable=Null:C1517)
		
		GOTO OBJECT:C206(*; $form.tableList)
		
		If (Size of array:C274($tablesPtr->)>0)
			
			$index:=$catalog.extract("name").indexOf($tablesPtr->{1})
			$ƒ.currentTable:=$catalog[$index]
			
		End if 
		
	Else 
		
		GOTO OBJECT:C206(*; $ƒ.focus)
		
	End if 
	
	// Get the current table & update the field list
	$index:=Find in array:C230($tablesPtr->; String:C10($ƒ.currentTable.name))
	
	If ($index>0)
		
		LISTBOX SELECT ROW:C912(*; $form.tableList; $index; lk replace selection:K53:1)
		OBJECT SET SCROLL POSITION:C906(*; $form.tableList; $index)
		
		cs:C1710.STRUCTURE.new($form).fieldList()
		
	Else 
		
		LISTBOX SELECT ROW:C912(*; $form.tableList; 0; lk remove from selection:K53:3)
		OBJECT SET SCROLL POSITION:C906(*; $form.tableList)
		
		OB REMOVE:C1226($ƒ; "currentTable")
		
		CLEAR VARIABLE:C89((OBJECT Get pointer:C1124(Object named:K67:5; $form.fields))->)
		
		This:C1470.refresh()
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Builds the list of fields for the selected table
Function fieldList()
	
	var $item; $t; $tableID : Text
	var $withError : Boolean
	var $color; $column; $i; $row; $style : Integer
	var $fieldsPtr; $iconsPtr; $ptr; $publishedPtr : Pointer
	var $dataModel; $form; $ƒ; $o : Object
	var $selectedItems; $unsynchronized : Collection
	var $relatedDataClasses : 4D:C1709.DataClass
	var $field : cs:C1710.field
	var $table : cs:C1710.table
	
	$fieldsPtr:=This:C1470.fieldsPtr
	$iconsPtr:=This:C1470.iconsPtr
	$publishedPtr:=This:C1470.publishedPtr
	
	$ƒ:=Form:C1466.$dialog.STRUCTURE
	$dataModel:=Form:C1466.dataModel
	
	$form:=This:C1470.form
	
	// Keep the selected field to restore the selection if necessary
	
	$selectedItems:=New collection:C1472
	
	If (Size of array:C274($fieldsPtr->)>0)
		
		LISTBOX GET CELL POSITION:C971(*; $form.fieldList; $column; $row)
		
		$ƒ.fieldName:=$fieldsPtr->{$row}
		
		// Keep the selection
		$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; $form.fieldList)
		
		For ($i; 1; LISTBOX Get number of rows:C915(*; $form.fieldList); 1)
			
			If ($ptr->{$i})
				
				$selectedItems.push($fieldsPtr->{$i})
				
				break  // Single line selection
				
			End if 
		End for 
	End if 
	
	CLEAR VARIABLE:C89($fieldsPtr->)
	CLEAR VARIABLE:C89($publishedPtr->)
	CLEAR VARIABLE:C89($iconsPtr->)
	
	// Is there a selected table?
	If ($ƒ.currentTable#Null:C1517)
		
		// ----------------------
		// POPULATE THE LIST
		// ----------------------
		
		$table:=$ƒ.currentTable
		
		$tableID:=String:C10($table.tableNumber)
		
		Case of 
				
				// MARK:Filter by name & published
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			: (Length:C16(String:C10($ƒ.fieldFilter))>0)\
				 & (Bool:C1537($ƒ.fieldFilterPublished))
				
				For each ($field; $table.fields)
					
					If (Position:C15($ƒ.fieldFilter; $field.name)>0)
						
						This:C1470._getField($dataModel[$tableID]; $field)
						
					End if 
				End for each 
				
				// MARK:Filter by name
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			: (Length:C16(String:C10($ƒ.fieldFilter))>0)
				
				For each ($field; $table.fields)
					
					If (Position:C15($ƒ.fieldFilter; $field.name)>0)
						
						This:C1470._appendField($table; $field)
						
					End if 
				End for each 
				
				// MARK:Filter by published
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			: (Bool:C1537($ƒ.fieldFilterPublished))
				
				For each ($field; $table.fields)
					
					This:C1470._getField($dataModel[$tableID]; $field)
					
				End for each 
				
				// MARK:No filter
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			Else 
				
				For each ($field; $table.fields)
					
					This:C1470._appendField($table; $field)
					
				End for each 
				
				If (Feature.with("many-one-many"))
					
					For each ($field; $table.fields.query("kind = relatedEntities & relatedDataClass != :1"; $table.name))
						
						$relatedDataClasses:=ds:C1482[ds:C1482[$table.name][$field.name].relatedDataClass]
						
						For each ($t; $relatedDataClasses)
							
							If ($relatedDataClasses[$t].kind="relatedEntity")\
								 & (String:C10($relatedDataClasses[$t].relatedDataClass)#$table.name)
								
								$o:=New object:C1471(\
									"kind"; "oneToOne"; \
									"oneToOne"; True:C214; \
									"name"; $relatedDataClasses[$t].relatedDataClass; \
									"path"; New collection:C1472($field.name; $t; $relatedDataClasses[$t].relatedDataClass).join(".")\
									)
								
								This:C1470._appendField($table; $o)
								
							End if 
						End for each 
					End for each 
				End if 
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		End case 
		
		// MARK: HIGHLIGHT
		If (Form:C1466.$dialog.unsynchronizedTables#Null:C1517)
			
			If (Form:C1466.$dialog.unsynchronizedTables.length>$table.tableNumber)
				
				$unsynchronized:=Form:C1466.$dialog.unsynchronizedTables[$table.tableNumber]
				
			End if 
		End if 
		
		CLEAR VARIABLE:C89($row)  // ⚠️ USED ABOVE
		
		For each ($field; $table.fields)
			
			If (Find in array:C230($fieldsPtr->; $field.name)>0)  // In list
				
				$row+=1
				
				$withError:=($unsynchronized#Null:C1517) && ($unsynchronized.length>0)
				
				If ($withError)
					
					$withError:=($unsynchronized.query("name = :1 OR parent = :1"; $field.name).pop()#Null:C1517)\
						 | ($unsynchronized.length=0)
					
				End if 
				
				If ($withError)
					
					$color:=UI.errorColor
					$style:=($field.kind="alias") ? Italic:K14:3 : ($field.kind="relatedEntity") ? Underline:K14:4 : Plain:K14:1
					
				Else 
					
					$style:=Plain:K14:1
					$color:=lk inherited:K53:26
					
					Case of 
							
							//______________________________________________________
						: ($field.kind="alias")
							
							$style:=Italic:K14:3
							
							If ($field.relatedDataClass#Null:C1517)
								
								If ($field.fieldType=Is object:K8:27)  // -> relatedEntity
									
									$style:=$style+Underline:K14:4
									$color:=UI.darkScheme ? Highlight menu text color:K23:8 : UI.selectedColor
									
									
								Else   // -> relatedEntities
									
									If ($field.relatedTableNumber#$table.tableNumber)\
										 && ($dataModel[String:C10($field.relatedTableNumber)]=Null:C1517)\
										 && ($dataModel[$tableID][$field.name]#Null:C1517)
										
										$color:=UI.errorColor
										
									End if 
								End if 
							End if 
							
							//______________________________________________________
						: ($field.kind="relatedEntity")
							
							$style:=Underline:K14:4
							$color:=UI.darkScheme ? Highlight menu text color:K23:8 : UI.selectedColor
							
							//______________________________________________________
						: ($field.kind="relatedEntities")
							
							If ($field.relatedTableNumber#$table.tableNumber)\
								 && ($dataModel[String:C10($field.relatedTableNumber)]=Null:C1517)\
								 && ($dataModel[$tableID][$field.name]#Null:C1517)
								
								$color:=UI.errorColor
								
							End if 
							
							//______________________________________________________
						Else 
							
							// Highlight primary key
							If ($field.name=$table.primaryKey)
								
								$style:=Bold:K14:2
								
							End if 
							
							//______________________________________________________
					End case 
				End if 
				
				LISTBOX SET ROW FONT STYLE:C1268(*; $form.fieldList; $row; $style)
				LISTBOX SET ROW COLOR:C1270(*; $form.fieldList; $row; $color; lk font color:K53:24)
				
			End if 
		End for each 
		
	End if 
	
	// Disable field publication if the table is missing
	OBJECT SET ENTERABLE:C238($publishedPtr->; PROJECT.isNotLocked())
	
	// Sort if any
	If ($ƒ.fieldSortByName)
		
		LISTBOX SORT COLUMNS:C916(*; $form.fieldList; 3; >)
		
	End if 
	
	// Restore the selection
	LISTBOX SELECT ROW:C912(*; $form.fieldList; 0; lk remove from selection:K53:3)
	
	If ($selectedItems.length>0)
		
		For each ($item; $selectedItems)
			
			$row:=Find in array:C230($fieldsPtr->; $item)
			
			If ($row>0)
				
				LISTBOX SELECT ROW:C912(*; $form.fieldList; $row; lk add to selection:K53:2)
				
			End if 
		End for each 
		
		$row:=Find in array:C230($fieldsPtr->; String:C10($ƒ.fieldName))
		
		If ($row>0)
			
			OBJECT SET SCROLL POSITION:C906(*; $form.fieldList; $row)
			
		Else 
			
			OBJECT SET SCROLL POSITION:C906(*; $form.fieldList)
			OB REMOVE:C1226($ƒ; "fieldName")
			
		End if 
		
	Else 
		
		OBJECT SET SCROLL POSITION:C906(*; $form.fieldList)
		OB REMOVE:C1226($ƒ; "fieldName")
		
	End if 
	
	This:C1470.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Displays related field picker
Function doFieldPicker()->$publishedNumber : Integer
	
	var $t : Text
	var $context; $currentDataModel; $o; $relatedCatalog; $relatedDataModel; $tableDataModel : Object
	var $target : Object
	var $path : Collection
	var $field : cs:C1710.field
	var $currentTable : cs:C1710.table
	
	$context:=This:C1470.context
	$currentTable:=$context.currentTable
	
	$relatedCatalog:=This:C1470.ExposedStructure.relatedCatalog($currentTable.name; $context.fieldName; True:C214)
	
	If ($relatedCatalog.success)  // Open field picker
		
		$currentDataModel:=Form:C1466.dataModel
		
		If (Bool:C1537($context.fieldSortByName))
			
			$relatedCatalog.fields:=$relatedCatalog.fields.orderBy("path asc")
			
		End if 
		
		$tableDataModel:=$currentDataModel[String:C10($currentTable.tableNumber)]
		
		If ($relatedCatalog.alias=Null:C1517)
			
			$relatedDataModel:=$tableDataModel[$relatedCatalog.relatedEntity]
			
		Else 
			
			$relatedDataModel:=$currentDataModel[String:C10($currentTable.tableNumber)]
			
		End if 
		
		For each ($field; $relatedCatalog.fields)
			
			// Recover the publication status
			$path:=Split string:C1554(($field.label=Null:C1517) ? $field.path : $field.label; ".")
			
			$t:=$field.kind="storage" ? String:C10($field.fieldNumber) : $field.name
			
			If ($path.length>1)
				
				If ($field.kind="alias")
					
					$field.published:=($relatedDataModel[$path[0]][$path[1]]#Null:C1517)
					
				Else 
					
					$field.published:=($relatedDataModel[$path[0]][$t]#Null:C1517)
					
				End if 
				
			Else 
				
				If ($currentTable.fields.query("name = :1"; $context.fieldName).pop().kind="alias")
					
					$field.published:=($relatedDataModel[$context.fieldName][$t]#Null:C1517)
					
				Else 
					
					$field.published:=($relatedDataModel[$t]#Null:C1517)
					
				End if 
			End if 
			
			// Set icon
			$field.icon:=UI.fieldIcons[$field.fieldType]
			
		End for each 
		
		$relatedCatalog.window:=Open form window:C675("RELATED"; Sheet form window:K39:12; *)
		DIALOG:C40("RELATED"; $relatedCatalog)
		
		// The number of published
		$publishedNumber:=$relatedCatalog.fields.query("published=true").length
		
		If ($relatedCatalog.success)
			
			If ($publishedNumber>0)  // At least one related field is published
				
				If ($tableDataModel=Null:C1517)\
					 | OB Is empty:C1297($tableDataModel)
					
					$tableDataModel:=PROJECT.addTable($currentTable)
					
				End if 
				
				For each ($field; $relatedCatalog.fields)
					
					$target:=$tableDataModel[$context.fieldName]
					
					$path:=Split string:C1554(($field.label=Null:C1517) ? $field.path : $field.label; ".")
					
					If ($field.published)
						
						If ($target=Null:C1517)
							
							If ($relatedCatalog.alias=Null:C1517)
								
								$target:=New object:C1471(\
									"kind"; "relatedEntity")
								
							Else 
								
								$target:=New object:C1471(\
									"kind"; "alias"; \
									"path"; $relatedCatalog.alias.levels.extract("path").join("."); \
									"fieldType"; Is object:K8:27; \
									"isToOne"; True:C214)
								
							End if 
							
							$target.relatedDataClass:=$relatedCatalog.relatedDataClass
							$target.relatedTableNumber:=$relatedCatalog.relatedTableNumber
							$target.inverseName:=$relatedCatalog.inverseName
							$target.label:=PROJECT.label($field.name)
							$target.shortLabel:=PROJECT.shortLabel($field.name)
							
							$tableDataModel[$context.fieldName]:=$target
							
						End if 
						
						// Create the field, if any
						If ($path.length>1)
							
							If ($target[$path[0]]=Null:C1517)
								
								$target[$path[0]]:=New object:C1471(\
									"kind"; "relatedEntity"; \
									"relatedDataClass"; $field.tableName; \
									"inverseName"; $currentTable.field.query("name=:1"; $context.fieldName).pop().inverseName; \
									"relatedTableNumber"; $field.tableNumber)
								
							End if 
							
							Case of 
									
									//______________________________________________________
								: ($target[$path[0]][Choose:C955($field.kind="storage"; String:C10($field.fieldNumber); $field.name)]#Null:C1517)
									
									// THE FIELD IS ALREADY IN THE DATA MODEL
									
									//______________________________________________________
								: ($field.kind="storage")  // Attribute
									
									$o:=New object:C1471(\
										"name"; $field.name; \
										"kind"; $field.kind; \
										"fieldType"; $field.fieldType; \
										"path"; $field.path; \
										"label"; PROJECT.label($field.name); \
										"shortLabel"; PROJECT.shortLabel($field.name); \
										"valueType"; $field.valueType)
									
									// mark:#TEMPO
									$o.type:=$field.type
									
									$target[$path[0]][String:C10($field.fieldNumber)]:=$o
									
									//______________________________________________________
								: ($field.kind="alias")  // Alias
									
									$o:=New object:C1471(\
										"kind"; $field.kind; \
										"fieldType"; $field.fieldType; \
										"path"; $field.path)
									
									Case of 
											
											//______________________________________________________
										: ($field.fieldType=Is collection:K8:32)  // Selection
											
											$o.label:=PROJECT.label(UI.str.localize("listOf"; $field.name))
											$o.shortLabel:=PROJECT.label($field.name)
											
											//______________________________________________________
										Else 
											
											$o.label:=PROJECT.label($field.name)
											$o.shortLabel:=PROJECT.label($field.name)
											
											//______________________________________________________
									End case 
									
									$o.fieldType:=$field.fieldType
									
									$target[$path[0]][$field.name]:=$o
									
									//______________________________________________________
								: ($field.kind="calculated")  // Computed attribute
									
									$o:=New object:C1471(\
										"kind"; $field.kind; \
										"fieldType"; $field.fieldType; \
										"path"; $field.path; \
										"label"; PROJECT.label($field.name); \
										"shortLabel"; PROJECT.shortLabel($field.name))
									
									// MARK:#TEMPO
									// TODO:Remove computed
									$o.computed:=True:C214
									
									$target[$path[0]][$field.name]:=$o
									
									//______________________________________________________
								Else 
									
									oops
									
									//______________________________________________________
							End case 
							
						Else 
							
							Case of 
									
									//______________________________________________________
								: ($target[Choose:C955($field.kind="storage"; String:C10($field.fieldNumber); $field.name)]#Null:C1517)
									
									// THE FIELD IS ALREADY IN THE DATA MODEL
									
									//______________________________________________________
								: ($field.kind="storage")
									
									$o:=New object:C1471(\
										"name"; $field.name; \
										"kind"; $field.kind; \
										"fieldType"; $field.fieldType; \
										"valueType"; $field.valueType; \
										"label"; PROJECT.label($field.name); \
										"shortLabel"; PROJECT.shortLabel($field.name); \
										"type"; $field.type)
									
									$target[String:C10($field.fieldNumber)]:=$o
									
									//______________________________________________________
								: ($field.kind="relatedEntities")
									
									$o:=New object:C1471(\
										"kind"; $field.kind; \
										"relatedDataClass"; $field.relatedDataClass; \
										"relatedTableNumber"; $field.relatedTableNumber; \
										"inverseName"; $field.inverseName; \
										"path"; New collection:C1472($context.fieldName; $field.path).join("."); \
										"label"; PROJECT.labelList($field.name); \
										"shortLabel"; PROJECT.label($field.name))
									
									// MARK:#TEMPO
									$o.isToMany:=True:C214
									
									$target[$field.name]:=$o
									
									//______________________________________________________
								: ($field.kind="calculated")
									
									$o:=New object:C1471(\
										"kind"; $field.kind; \
										"fieldType"; $field.fieldType; \
										"valueType"; $field.valueType; \
										"label"; PROJECT.label($field.name); \
										"shortLabel"; PROJECT.shortLabel($field.name))
									
									// MARK:#TEMPO
									//TODO:Remove computed
									$o.computed:=True:C214
									
									$target[$field.name]:=$o
									
									//______________________________________________________
								: ($field.kind="alias")
									
									$o:=New object:C1471(\
										"kind"; $field.kind; \
										"fieldType"; $field.fieldType; \
										"valueType"; $field.valueType; \
										"path"; $field.path; \
										"label"; PROJECT.label($field.name); \
										"shortLabel"; PROJECT.shortLabel($field.name))
									
									$target[$field.name]:=$o
									
									//______________________________________________________
								Else 
									
									oops
									
									//______________________________________________________
							End case 
						End if 
						
					Else 
						
						// Remove the field, if any
						Case of 
								
								//______________________________________________________
							: ($field.kind="relatedEntities")
								
								If ($target#Null:C1517)
									
									OB REMOVE:C1226($target; $field.name)
									
								End if 
								
								//______________________________________________________
							Else 
								
								If ($path.length>1)
									
									If (($target[$path[0]][($field.kind="storage") ? String:C10($field.fieldNumber) : $field.name])#Null:C1517)
										
										OB REMOVE:C1226($target[$path[0]]; $field.kind="storage" ? String:C10($field.fieldNumber) : $field.name)
										
										If (OB Keys:C1719($target[$path[0]]).length=3)  //description keys ("kind", "inverseName", "relatedTableNumber")
											
											// Empty -> remove
											OB REMOVE:C1226($target; $path[0])
											
										End if 
									End if 
									
								Else 
									
									If (($target[($field.kind="storage") ? String:C10($field.fieldNumber) : $field.name])#Null:C1517)
										
										OB REMOVE:C1226($target; $field.kind="storage" ? String:C10($field.fieldNumber) : $field.name)
										
									End if 
								End if 
								
								//______________________________________________________
						End case 
					End if 
				End for each 
				
			Else 
				
				OB REMOVE:C1226($tableDataModel; $context.fieldName)
				
			End if 
			
			If (OB Entries:C1720($tableDataModel).query("key != ''").length=0)
				
				// Empty -> remove
				PROJECT.removeTable($currentTable)
				
			End if 
			
		Else 
			
			// User has cancelled
			
		End if 
		
		// Checkbox value according to the count
		If ($publishedNumber>0)
			
			$publishedNumber:=1+Num:C11($publishedNumber#$relatedCatalog.fields.length)
			
		End if 
		
	Else 
		
		oops
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Update the project according to the published fields
Function updateProject()
	
	var $key : Text
	var $found : Boolean
	var $indx : Integer
	var $o : Object
	var $published : Collection
	var $tableModel; $currentTable; $tableBackup : cs:C1710.table
	var $field; $fieldModel : cs:C1710.field
	var $structure : cs:C1710.ExposedStructure
	var $form : Object
	var $context : Object
	
	$form:=This:C1470.form
	$context:=This:C1470.context
	$currentTable:=$context.currentTable
	$structure:=This:C1470.ExposedStructure
	
	// ----------------------------------------------------
	// GET THE PUBLISHED FIELD NAMES LIST
	$published:=New collection:C1472
	
	var $fieldPtr; $publishedPtr : Pointer
	$publishedPtr:=This:C1470.publishedPtr
	$fieldPtr:=OBJECT Get pointer:C1124(Object named:K67:5; $form.fields)
	ARRAY TO COLLECTION:C1563($published; $publishedPtr->; "published"; $fieldPtr->; "name")
	
	If ($published.extract("published").countValues(0)=$published.length)\
		 && ($published.extract("published").indexOf(2)=-1)\
		 && (Length:C16(String:C10($context.fieldFilter))=0)\
		 && (Not:C34(Bool:C1537($context.fieldFilterPublished)))
		
		// NO FIELD PUBLISHED
		PROJECT.removeTable($currentTable)
		
		// UI - De-emphasize the table name
		$indx:=Find in array:C230((OBJECT Get pointer:C1124(Object named:K67:5; $form.tableList))->; True:C214)
		LISTBOX SET ROW FONT STYLE:C1268(*; $form.tableList; $indx; Plain:K14:1)
		
	Else 
		
		$tableModel:=Form:C1466.dataModel[String:C10($currentTable.tableNumber)]
		$tableBackup:=OB Copy:C1225($tableModel)
		
		If ($tableModel=Null:C1517)
			
			// Add the table to the data model
			$tableModel:=PROJECT.addTable($currentTable)
			
			// UI - Emphasize the table name
			$indx:=Find in array:C230((OBJECT Get pointer:C1124(Object named:K67:5; $form.tableList))->; True:C214)
			LISTBOX SET ROW FONT STYLE:C1268(*; $form.tableList; $indx; Bold:K14:2)
			
		End if 
		
		// For each item into the list…
		For each ($o; $published)
			
			// Search if the item exists in the data model
			$found:=False:C215
			
			For each ($key; $tableModel) Until ($found)
				
				If (Length:C16($key)=0)  // Metadata
					
					continue
					
				Else 
					
					$fieldModel:=$tableModel[$key]
					
					Case of 
							
							//………………………………………………………………………………………………………
						: ($fieldModel.kind="storage")
							
							$found:=(String:C10($fieldModel.name)=$o.name)
							$key:=$o.name
							
							//………………………………………………………………………………………………………
						: ($fieldModel.kind="relatedEntity")
							
							$found:=(String:C10($o.name)=$key) & (Num:C11($o.published)#2)  // Not mixed
							
							//………………………………………………………………………………………………………
						: ($fieldModel.kind="relatedEntities")
							
							If (Feature.with("many-one-many"))
								
								
								
							Else 
								
								$found:=(String:C10($o.name)=$key)
								
							End if 
							
							//………………………………………………………………………………………………………
						: ($fieldModel.kind="calculated")
							
							$found:=(String:C10($o.name)=$key)
							
							//………………………………………………………………………………………………………
						: ($fieldModel.kind="alias")
							
							$found:=(String:C10($o.name)=$key)
							
							//………………………………………………………………………………………………………
						Else 
							
							oops
							
							//………………………………………………………………………………………………………
					End case 
				End if 
			End for each 
			
			If ($found)
				
				$field:=$currentTable.fields.query("name = :1"; $key).pop()
				
			Else 
				
				// Get from cache
				$field:=$currentTable.fields.query("name = :1"; $o.name).pop()
				
			End if 
			
			Case of 
					
					//_____________________________________________________
				: (Num:C11($o.published)=1) & Not:C34($found)  // ADDED
					
					$structure.addField($tableModel; $field)
					
					//_____________________________________________________
				: (Num:C11($o.published)=0) & $found  // REMOVED
					
					If ($field.kind="alias")\
						 || ($field.kind="calculated")
						
						$structure.removeField($tableModel; $field.name)
						
					Else 
						
						$structure.removeField($tableModel; Choose:C955(Num:C11($field.type)<0; $o.name; $field.id))
						
					End if 
					
					//_____________________________________________________
			End case 
		End for each 
		
		// REMOVE TABLE IF NO MORE PUBLISHED FIELDS
		If (OB Keys:C1719($tableModel).length=1)
			
			PROJECT.removeTable($currentTable)
			
			// UI - De-emphasize the table name
			$indx:=Find in array:C230((OBJECT Get pointer:C1124(Object named:K67:5; $form.tableList))->; True:C214)
			LISTBOX SET ROW FONT STYLE:C1268(*; $form.tableList; $indx; Plain:K14:1)
			
		End if 
	End if 
	
	If (Feature.with("androidDataSet"))
		
		If (Not:C34(New collection:C1472($tableModel).equal(New collection:C1472($tableBackup))))
			
			UI.deleteDBFiles()
			
		End if 
	End if 
	
	PROJECT.save()
	
	// Update field list
	This:C1470.fieldList()
	
	$context.setHelpTip($form.fieldList; $form)
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Manage teh action button
Function doActionMenu()
	
	var $Boo_value : Boolean
	var $i; $number; $row; $indx : Integer
	var $mePtr; $publishedPtr : Pointer
	var $context; $form : Object
	var $menu : cs:C1710.menu
	
	$form:=This:C1470.form
	$context:=This:C1470.context
	
	$publishedPtr:=This:C1470.publishedPtr
	
	// ----------------------------------------------------
	$menu:=cs:C1710.menu.new()
	
	Case of 
			
			//________________________________________
		: ($context.focus=$form.tables)
			
			$menu.append(":xliff:sortByTableName"; "sortByName"; Bool:C1537($context.tableSortByName))
			$menu.append(":xliff:sortByTableNumber"; "sortDefault"; Not:C34(Bool:C1537($context.tableSortByName)))
			$menu.line()
			$menu.append(":xliff:onlyPublishedTables"; "published"; Bool:C1537($context.tableFilterPublished))
			
			//________________________________________
		: ($context.focus=$form.fields)
			
			$mePtr:=OBJECT Get pointer:C1124(Object named:K67:5; $form.fieldList)
			$number:=Size of array:C274($mePtr->)
			
			$row:=Find in array:C230($mePtr->; True:C214)
			
			$menu.append(":xliff:sortByFieldName"; "sortByName"; Bool:C1537($context.fieldSortByName))
			$menu.append(":xliff:sortByFieldNumber"; "sortDefault"; Not:C34(Bool:C1537($context.fieldSortByName)))
			$menu.line()
			$menu.append(":xliff:onlyPublishedFields"; "published"; Bool:C1537($context.fieldFilterPublished))
			$menu.line()
			
			If ($number>0)\
				 & ($row>0)
				
				If (Bool:C1537($publishedPtr->{$row}))
					
					$menu.append(":xliff:unpublish"; "unpublish")
					
				Else 
					
					$menu.append(":xliff:publish"; "publish")
					
				End if 
				
				//$Obj_popup.shortcut(Char(Space);Command key mask)
				
				If (PROJECT.isLocked())
					
					$menu.disable()
					
				End if 
				
			Else 
				
				$menu.append(":xliff:publish"; "publish").disable()
				
			End if 
			
			If (Count in array:C907($mePtr->; True:C214)#$number)
				
				$menu.line()
				
				If (Count in array:C907($publishedPtr->; 0)=0)
					
					$menu.append(":xliff:unpublishAll"; "unpublishAll")
					
				Else 
					
					$menu.append(":xliff:publishAll"; "publishAll")
					
				End if 
			End if 
			
			// #93984
			If ($number=0)\
				 | (PROJECT.isLocked())
				
				$menu.disable()
				
			End if 
			
			//…………………………………………………………………………………………………
	End case 
	
	$menu.line()
	$menu.append(":xliff:search"; "search").shortcut("f"; Command key mask:K16:1)
	
	If ($menu.popup().selected)
		
		Case of 
				
				//………………………………………………………………………………………
			: ($menu.choice="sortByName")\
				 | ($menu.choice="sortDefault")
				
				If ($context.focus=$form.tables)
					
					$context.tableSortByName:=Not:C34(Bool:C1537($context.tableSortByName))
					
					This:C1470.tableList()
					
				Else 
					
					$context.fieldSortByName:=Not:C34(Bool:C1537($context.fieldSortByName))
					This:C1470.fieldList()
					
				End if 
				
				//………………………………………………………………………………………
			: ($menu.choice="published")  // Add-remove published filter
				
				If ($context.focus=$form.tables)
					
					$context.tableFilterPublished:=Not:C34(Bool:C1537($context.tableFilterPublished))
					
					This:C1470.tableList()
					ST SET TEXT:C1115(*; $form.tableFilter; This:C1470.tableFilterLabel(); ST Start text:K78:15; ST End text:K78:16)
					
				Else 
					
					$context.fieldFilterPublished:=Not:C34(Bool:C1537($context.fieldFilterPublished))
					
					This:C1470.fieldList()
					ST SET TEXT:C1115(*; $form.fieldFilter; This:C1470.fieldFilterLabel(); ST Start text:K78:15; ST End text:K78:16)
					
				End if 
				
				//………………………………………………………………………………………
			: ($menu.choice="search")
				
				This:C1470.callChild("search"; Formula:C1597(search_HANDLER).source; New object:C1471(\
					"action"; "search"))
				
				//………………………………………………………………………………………
			: ($menu.choice="publish")\
				 | ($menu.choice="unpublish")
				
				$mePtr:=OBJECT Get pointer:C1124(Object named:K67:5; $form.fieldList)
				$Boo_value:=($menu.choice="publish")
				
				// For each selected items
				
				Repeat 
					
					$indx:=Find in array:C230($mePtr->; True:C214; $indx+1)
					
					If ($indx>0)
						
						$publishedPtr->{$indx}:=Num:C11($Boo_value)
						
					End if 
				Until ($indx=-1)
				
				This:C1470.updateProject()
				
				//………………………………………………………………………………………
			: ($menu.choice="publishAll")\
				 | ($menu.choice="unpublishAll")
				
				$Boo_value:=($menu.choice="publishAll")
				
				For ($i; 1; Size of array:C274($publishedPtr->); 1)
					
					$publishedPtr->{$i}:=Num:C11($Boo_value)
					
				End for 
				
				This:C1470.updateProject()
				
				//………………………………………………………………………………………
			Else 
				
				If (Length:C16($menu.choice)>0)
					
					ASSERT:C1129(False:C215; "Unknown menu action ("+$menu.choice+")")
					
				End if 
				
				//………………………………………………………………………………………
		End case 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Returns the table filter label
Function tableFilterLabel()->$label : Text
	
	var $context : Object
	$context:=This:C1470.context
	
	Case of 
			
			//………………………………………………………………………………………
		: (Length:C16(String:C10($context.tableFilter))=0)\
			 & (Not:C34(Bool:C1537($context.tableFilterPublished)))
			
			// NOTHING MORE TO DO
			
			//………………………………………………………………………………………
		: (Length:C16(String:C10($context.tableFilter))>0)\
			 & (Bool:C1537($context.tableFilterPublished))
			
			$label:=Get localized string:C991("filteredBy")\
				+Char:C90(Space:K15:42)\
				+"<span style=\"-d4-ref-user:'filter'\">"\
				+Get localized string:C991("structName")\
				+" ("+Get localized string:C991("published")+")"\
				+"</span>"
			
			//………………………………………………………………………………………
		: (Length:C16(String:C10($context.tableFilter))>0)
			
			$label:=Get localized string:C991("filteredBy")\
				+Char:C90(Space:K15:42)\
				+"<span style=\"-d4-ref-user:'filter'\">"\
				+Get localized string:C991("structName")\
				+"</span>"
			
			//………………………………………………………………………………………
		: (Bool:C1537($context.tableFilterPublished))
			
			$label:=Get localized string:C991("filteredBy")\
				+Char:C90(Space:K15:42)\
				+"<span style=\"-d4-ref-user:'filter'\">"\
				+Get localized string:C991("published")\
				+"</span>"
			
			//………………………………………………………………………………………
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Update the field filter label
Function fieldFilterLabel()->$label : Text
	
	var $context : Object
	$context:=This:C1470.context
	
	Case of 
			
			//………………………………………………………………………………………
		: (Length:C16(String:C10($context.fieldFilter))=0)\
			 & (Not:C34(Bool:C1537($context.fieldFilterPublished)))
			
			// NOTHING MORE TO DO
			
			//………………………………………………………………………………………
		: (Length:C16(String:C10($context.fieldFilter))>0)\
			 & (Bool:C1537($context.fieldFilterPublished))
			
			$label:=Get localized string:C991("filteredBy")\
				+Char:C90(Space:K15:42)\
				+"<span style=\"-d4-ref-user:'filter'\">"\
				+Get localized string:C991("structName")\
				+" ("+Get localized string:C991("published")+")"\
				+"</span>"
			
			//………………………………………………………………………………………
		: (Length:C16(String:C10($context.fieldFilter))>0)
			
			$label:=Get localized string:C991("filteredBy")\
				+Char:C90(Space:K15:42)\
				+"<span style=\"-d4-ref-user:'filter'\">"\
				+Get localized string:C991("structName")\
				+"</span>"
			
			//………………………………………………………………………………………
		: (Bool:C1537($context.fieldFilterPublished))
			
			$label:=Get localized string:C991("filteredBy")\
				+Char:C90(Space:K15:42)\
				+"<span style=\"-d4-ref-user:'filter'\">"\
				+Get localized string:C991("published")\
				+"</span>"
			
			//………………………………………………………………………………………
	End case 
	
	// MARK:-[PRIVATE]
	// MARK:-
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function _appendField($table : cs:C1710.table; $field : cs:C1710.field)
	
	var $published; $type : Integer
	var $dataModel; $relatedCatalog : Object
	var $c : Collection
	var $fieldModel; $o : cs:C1710.field
	
	$dataModel:=PROJECT.dataModel
	
	$type:=$field.fieldType
	
	Case of 
			
			//…………………………………………………………………………………………………
		: ($field.kind="storage") && ($type<=UI.fieldIcons.length)
			
			$published:=Num:C11($dataModel[String:C10($table.tableNumber)][String:C10($field.id)]#Null:C1517)
			
			//…………………………………………………………………………………………………
		: ($field.kind="calculated") && ($type<=UI.fieldIcons.length)
			
			$published:=Num:C11($dataModel[String:C10($table.tableNumber)][$field.name]#Null:C1517)
			
			//…………………………………………………………………………………………………
		: ($field.kind="relatedEntity")\
			 || (($field.kind="alias") && Bool:C1537($field.isToOne))
			
			$fieldModel:=$dataModel[String:C10($table.tableNumber)][$field.name]
			
			If ($fieldModel#Null:C1517)
				
				$published:=1  // All related fields are published
				
				$relatedCatalog:=This:C1470.ExposedStructure.relatedCatalog($table.name; $field.name; True:C214)
				
				If ($relatedCatalog.success)
					
					For each ($o; $relatedCatalog.fields)
						
						Case of 
								
								//______________________________________________________
							: ($o.kind="storage")
								
								$c:=Split string:C1554($o.path; "."; sk ignore empty strings:K86:1)
								
								If ($c.length=1)
									
									// Field
									$published+=Num:C11($fieldModel[String:C10($o.fieldNumber)]=Null:C1517)
									
								Else 
									
									// Link
									$published+=Num:C11($fieldModel[$c[0]][String:C10($o.fieldNumber)]=Null:C1517)
									
								End if 
								
								//______________________________________________________
							: ($o.kind="calculated")
								
								$c:=Split string:C1554($o.path; "."; sk ignore empty strings:K86:1)
								
								If ($c.length=1)
									
									// Field
									$published+=Num:C11($fieldModel[$o.name]=Null:C1517)
									
								Else 
									
									// Link
									$published+=Num:C11($fieldModel[$c[0]][$o.name]=Null:C1517)
									
								End if 
								
								//______________________________________________________
							: ($o.kind="alias")
								
								$published+=Num:C11($fieldModel[$o.name]=Null:C1517)
								
								//______________________________________________________
							: ($o.fieldType=8859)
								
								$published+=Num:C11($fieldModel[$o.name]=Null:C1517)
								
								//______________________________________________________
							: ($o.fieldType=8858)
								
								$published+=Num:C11($fieldModel[$o.name]=Null:C1517)
								
								//______________________________________________________
							Else 
								
								oops
								
								//______________________________________________________
						End case 
					End for each 
				End if 
			End if 
			
			$type:=8858
			
			//…………………………………………………………………………………………………
		: ($field.kind="relatedEntities")\
			 || (($field.kind="alias") && Bool:C1537($field.isToMany))
			
			//*******************************************************************************************
			$published:=Num:C11($dataModel[String:C10($table.tableNumber)][String:C10($field.name)]#Null:C1517)
			
			//
			// C'EST FAUX SI LE LIEN A ÉTÉ RENOMMÉ
			// REGARDER DANS : Form.$dialog.unsynchronizedTableFields[String($Obj_in.table.tableNumber)]
			//
			//*******************************************************************************************
			$type:=8859
			
			//…………………………………………………………………………………………………
		: ($field.kind="alias") && ($type<=UI.fieldIcons.length)
			
			$published:=Num:C11($dataModel[String:C10($table.tableNumber)][$field.name]#Null:C1517)
			
			//…………………………………………………………………………………………………
		: (Bool:C1537($field.oneToOne))  // 1 -> N -> 1
			
			$published:=Num:C11($dataModel[String:C10($table.tableNumber)][$field.name]#Null:C1517)
			
			$type:=8860
			
			//…………………………………………………………………………………………………
		Else 
			
			If ($type<=UI.fieldIcons.length)
				
				$published:=Num:C11($dataModel[String:C10($table.tableNumber)][String:C10($field.id)]#Null:C1517)
				
			End if 
			
			//…………………………………………………………………………………………………
	End case 
	
	APPEND TO ARRAY:C911((This:C1470.publishedPtr)->; $published)
	APPEND TO ARRAY:C911((This:C1470.iconsPtr)->; UI.fieldIcons[$type])
	APPEND TO ARRAY:C911((This:C1470.fieldsPtr)->; $field.name)
	
	LISTBOX SET ROW FONT STYLE:C1268(*; This:C1470.form.fieldList; Size of array:C274((This:C1470.fieldsPtr)->); Plain:K14:1)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function _getField($table : cs:C1710.table; $field : cs:C1710.field)
	
	Case of 
			
			//======================================
		: ($field.kind="storage")
			
			If ($table[String:C10($field.fieldNumber)]#Null:C1517)
				
				This:C1470._appendField($table; $field)
				
			End if 
			
			//======================================
		: ($field.kind="relatedEntity")  // N -> 1 relation
			
			var $o : cs:C1710.field
			
			For each ($o; This:C1470.ExposedStructure.getCatalog($table.name))
				
				If ($table[$field.name][String:C10($o.id)]#Null:C1517)
					
					This:C1470._appendField($table; $field)
					
					break
					
				End if 
			End for each 
			
			//======================================
		Else 
			
			If ($table[String:C10($field.name)]#Null:C1517)
				
				This:C1470._appendField($table; $field)
				
			End if 
			
			//======================================
	End case 