Class extends form

// === === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($form : Object)
	
	Super:C1705("editor_CALLBACK")
	
	// This.context:=editor_Panel_init(This.name)
	
	// If (OB Is empty(This.context))
	
	This:C1470.isSubform:=True:C214
	
	This:C1470.init()
	
	// Constraints definition
	//cs.ob.new(This.context).createPath("constraints.rules"; Is collection)
	
	// End if
	
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
			
			Case of 
					
					//______________________________________________________
				: (Form:C1466.$dialog.unsynchronizedTables.length<=$table.tableNumber)
					
					LISTBOX SET ROW COLOR:C1270(*; $form.tableList; $row; lk inherited:K53:26; lk font color:K53:24)
					
					//______________________________________________________
				: (Form:C1466.$dialog.unsynchronizedTables[$table.tableNumber]#Null:C1517)
					
					LISTBOX SET ROW COLOR:C1270(*; $form.tableList; $row; EDITOR.errorColor; lk font color:K53:24)
					
					//______________________________________________________
				Else 
					
					LISTBOX SET ROW COLOR:C1270(*; $form.tableList; $row; lk inherited:K53:26; lk font color:K53:24)
					
					//______________________________________________________
			End case 
			
			// Highlight published table name
			LISTBOX SET ROW FONT STYLE:C1268(*; $form.tableList; $row; Choose:C955($dataModel[String:C10($table.tableNumber)]=Null:C1517; Plain:K14:1; Bold:K14:2))
			
		End if 
	End for each 
	
	// Sort if any
	If (Bool:C1537($ƒ.tableSortByName))
		
		LISTBOX SORT COLUMNS:C916(*; $form.tableList; 1; >)
		
	End if 
	
	// Select the first table if any [
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
				
				If (FEATURE.with("many-one-many"))
					
					For each ($field; $table.fields.query("kind = relatedEntities & relatedDataClass != :1"; $table.name))
						
						$relatedDataClasses:=ds:C1482[ds:C1482[$table.name][$field.name].relatedDataClass]
						
						For each ($t; $relatedDataClasses)
							
							If ($relatedDataClasses[$t].kind="relatedEntity")\
								 & (String:C10($relatedDataClasses[$t].relatedDataClass)#$table.name)
								
								$o:=New object:C1471(\
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
				
				$row:=$row+1
				
				$withError:=($unsynchronized#Null:C1517)
				
				If ($withError)
					
					$withError:=($unsynchronized.query("name = :1 OR parent = :1"; $field.name).pop()#Null:C1517)\
						 | ($unsynchronized.length=0)
					
				End if 
				
				$style:=Plain:K14:1
				$color:=lk inherited:K53:26
				
				If ($withError)
					
					$color:=EDITOR.errorColor
					
				Else 
					
					If (($field.kind="alias")\
						 & ($field.relatedDataClass#Null:C1517))
						
					End if 
					
					Case of 
							
							//______________________________________________________
						: ($field.kind="alias")
							
							$style:=Italic:K14:3
							
							If (($field.relatedDataClass#Null:C1517)\
								 & ($field.valueType#"@Selection"))
								
								$style:=$style+Underline:K14:4
								$color:=EDITOR.selectedColor
								
							End if 
							
							//______________________________________________________
						: ($field.kind="relatedEntity")
							
							$style:=Underline:K14:4
							$color:=EDITOR.selectedColor
							
							//______________________________________________________
						: ($field.kind="relatedEntities")
							
							If ($field.relatedTableNumber#$table.tableNumber)  // Not for a recursive relation
								
								If ($dataModel[String:C10($field.relatedTableNumber)]=Null:C1517)\
									 & ($dataModel[$tableID][$field.name]#Null:C1517)
									
									$color:=EDITOR.errorColor
									
								End if 
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
	
	If (Not:C34(FEATURE.with("android1ToNRelations")))
		
		tempoDatamodelWith1toNRelation($ƒ.currentTable)
		
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
Function doFieldPicker()->$count : Integer
	
	var $fieldID : Text
	var $context; $dataModel; $linkDataModel; $relatedCatalog; $tableDataModel; $target : Object
	var $c : Collection
	var $field : cs:C1710.field
	
	$context:=This:C1470.context
	
	$relatedCatalog:=This:C1470.ExposedStructure.relatedCatalog($context.currentTable.name; $context.fieldName; True:C214)
	
	If ($relatedCatalog.success)  // Open field picker
		
		$dataModel:=Form:C1466.dataModel
		
		If (Bool:C1537($context.fieldSortByName))
			
			$relatedCatalog.fields:=$relatedCatalog.fields.orderBy("path")
			
		End if 
		
		$tableDataModel:=$dataModel[String:C10($context.currentTable.tableNumber)]
		$linkDataModel:=$tableDataModel[$relatedCatalog.relatedEntity]
		
		For each ($field; $relatedCatalog.fields)
			
			Case of 
					
					//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
				: ($field.kind="calculated")
					
					$field.published:=($linkDataModel[$field.name]#Null:C1517)
					
					//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
				: ($field.kind="alias")
					
					$field.published:=($linkDataModel[$field.name]#Null:C1517)
					
					// TODO:Replace 8858 by 38 & 8859 by 42
					$field.fieldType:=($field.fieldType=42) ? 8859 : ($field.fieldType=38) ? 8858 : $field.fieldType
					
					//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
				Else 
					
					$fieldID:=String:C10($field.fieldNumber)
					$c:=Split string:C1554($field.path; ".")
					
					If ($c.length=1)
						
						$field.published:=($linkDataModel[$fieldID]#Null:C1517)
						
					Else 
						
						// Enhance_relation
						$field.published:=($linkDataModel[$c[0]][$fieldID]#Null:C1517)
						
					End if 
					
					//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			End case 
			
			$field.icon:=EDITOR.fieldIcons[$field.fieldType]
			
		End for each 
		
		$relatedCatalog.window:=Open form window:C675("RELATED"; Sheet form window:K39:12; *)
		DIALOG:C40("RELATED"; $relatedCatalog)
		
		If ($relatedCatalog.success)  // Dialog was validated
			
			// The number of published
			$count:=$relatedCatalog.fields.query("published=true").length
			
			If ($count>0)  // At least one related field is published
				
				If ($tableDataModel=Null:C1517)\
					 | OB Is empty:C1297($tableDataModel)
					
					$tableDataModel:=PROJECT.addTable($context.currentTable)
					
				End if 
				
				For each ($field; $relatedCatalog.fields)
					
					$fieldID:=String:C10($field.fieldNumber)
					$c:=Split string:C1554($field.path; ".")
					
					If ($field.published)
						
						$target:=$tableDataModel[$context.fieldName]
						
						If ($target=Null:C1517)
							
							// Create the relation
							$target:=New object:C1471(\
								"relatedDataClass"; $relatedCatalog.relatedDataClass; \
								"inverseName"; $relatedCatalog.inverseName; \
								"relatedTableNumber"; $relatedCatalog.relatedTableNumber)
							
							$tableDataModel[$context.fieldName]:=$target
							
						End if 
						
						// Create the field, if any
						If ($c.length>1)
							
							If ($target[$c[0]]=Null:C1517)
								
								$target[$c[0]]:=New object:C1471(\
									"relatedDataClass"; $field.tableName; \
									"inverseName"; $context.currentTable.field.query("name=:1"; $context.fieldName).pop().inverseName; \
									"relatedTableNumber"; $field.tableNumber)
								
							End if 
							
							If ($target[$c[0]][$fieldID]=Null:C1517)
								
								$target[$c[0]][$fieldID]:=New object:C1471(\
									"name"; $field.name; \
									"path"; $field.path; \
									"label"; PROJECT.label($field.name); \
									"shortLabel"; PROJECT.shortLabel($field.name); \
									"type"; $field.type; \
									"fieldType"; $field.fieldType)
								
							End if 
							
						Else 
							
							Case of 
									
									//______________________________________________________
								: ($field.kind="relatedEntities")
									
									If ($target[$field.name]=Null:C1517)
										
										$target[$field.name]:=New object:C1471(\
											"name"; $field.name; \
											"relatedDataClass"; $field.relatedDataClass; \
											"relatedTableNumber"; $field.relatedTableNumber; \
											"path"; $context.fieldName+"."+$field.path; \
											"label"; PROJECT.labelList($field.name); \
											"shortLabel"; PROJECT.label($field.name); \
											"inverseName"; $field.inverseName; \
											"isToMany"; True:C214)
										
									End if 
									
									//______________________________________________________
								: ($field.kind="calculated")
									
									If ($target[$field.name]=Null:C1517)
										
										$target[$field.name]:=New object:C1471(\
											"name"; $field.name; \
											"path"; $field.path; \
											"label"; PROJECT.label($field.name); \
											"shortLabel"; PROJECT.shortLabel($field.name); \
											"fieldType"; $field.fieldType; \
											"computed"; True:C214)
										
									End if 
									
									//______________________________________________________
								Else 
									
									If ($target[$fieldID]=Null:C1517)
										
										$target[$fieldID]:=New object:C1471(\
											"name"; $field.name; \
											"path"; $field.path; \
											"label"; PROJECT.label($field.name); \
											"shortLabel"; PROJECT.shortLabel($field.name); \
											"type"; $field.type; \
											"fieldType"; $field.fieldType)
										
									End if 
									
									//______________________________________________________
							End case 
						End if 
						
					Else 
						
						// Remove the field, if any
						
						Case of 
								
								//______________________________________________________
							: ($field.kind="relatedEntities")
								
								If ($linkDataModel#Null:C1517)
									
									OB REMOVE:C1226($linkDataModel; $field.name)
									
								End if 
								
								//______________________________________________________
							: ($field.kind="calculated")
								
								If ($target#Null:C1517)
									
									OB REMOVE:C1226($target; $field.name)
									
								End if 
								
								//______________________________________________________
							Else 
								
								If ($c.length>1)
									
									If ($target[$c[0]][String:C10($field.fieldNumber)]#Null:C1517)
										
										OB REMOVE:C1226($target[$c[0]]; String:C10($field.fieldNumber))
										
										// Remove the link if no more fields are published
										If (OB Entries:C1720($target[$c[0]]).filter("col_formula"; Formula:C1597($1.result:=Match regex:C1019("^\\d+$"; $1.value.key; 1))).length=0)
											
											OB REMOVE:C1226($target; $c[0])
											
										End if 
									End if 
									
								Else 
									
									If ($target[$fieldID].path#Null:C1517)
										
										If ($target[$fieldID].path=$field.path)
											
											OB REMOVE:C1226($target; $fieldID)
											
										End if 
									End if 
								End if 
								
								//______________________________________________________
						End case 
					End if 
				End for each 
				
				// Checkbox value according to the count
				If ($count>0)
					
					$count:=1+Num:C11($count#$relatedCatalog.fields.length)
					
				End if 
			End if 
			
			//(This.publishedPtr)->{$row}:=$count
			
		End if 
		
	Else 
		
		ASSERT:C1129(DATABASE.isComponent; "😰 I wonder why I'm here")
		
	End if 
	
	// STRUCTURE_UPDATE(This.form)
	This:C1470.updateProject()
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Update the project according to the published fields
Function updateProject()
	
	var $key : Text
	var $found : Boolean
	var $indx : Integer
	var $context; $form; $o : Object
	var $published : Collection
	var $tableModel; $currentTable : cs:C1710.table
	var $field; $fieldModel : cs:C1710.field
	var $structure : cs:C1710.ExposedStructure
	
	// ----------------------------------------------------
	// Initialisations
	$form:=This:C1470.form
	$context:=This:C1470.context
	
	$currentTable:=$context.currentTable
	
	$structure:=cs:C1710.ExposedStructure.new()
	
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
		PROJECT.removeTable($currentTable.tableNumber)
		
		// UI - De-emphasize the table name
		$indx:=Find in array:C230((OBJECT Get pointer:C1124(Object named:K67:5; $form.tableList))->; True:C214)
		LISTBOX SET ROW FONT STYLE:C1268(*; $form.tableList; $indx; Plain:K14:1)
		
	Else 
		
		$tableModel:=PROJECT.dataModel[String:C10($currentTable.tableNumber)]
		
		If ($tableModel=Null:C1517)
			
			// Add the table to the data model
			$tableModel:=PROJECT.addTable($currentTable)
			
			// UI - Emphasize the table name
			$indx:=Find in array:C230((OBJECT Get pointer:C1124(Object named:K67:5; $form.tableList))->; True:C214)
			LISTBOX SET ROW FONT STYLE:C1268(*; $form.tableList; $indx; Bold:K14:2)
			
		End if 
		
		// For each item into the list
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
						: ($fieldModel.kind="relatedEntity")  // N -> 1 relation
							
							$found:=(String:C10($o.name)=$key) & (Num:C11($o.published)#2)  // Not mixed
							
							//………………………………………………………………………………………………………
						: ($fieldModel.kind="relatedEntities")  // 1 -> N relation
							
							$found:=(String:C10($o.name)=$key)
							
							//………………………………………………………………………………………………………
						: ($fieldModel.kind="calculated")  // Computed attribute
							
							$found:=(String:C10($o.name)=$key)
							
							//………………………………………………………………………………………………………
						: ($fieldModel.kind="alias")  // Computed attribute
							
							$found:=(String:C10($o.name)=$key)
							
							//………………………………………………………………………………………………………
						Else 
							
							//ASSERT(DATABASE.isComponent; "😰 I wonder why I'm here")
							
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
						 || ($field.kind="computed")
						
						$structure.removeField($tableModel; $field.name)
						
					Else 
						
						$structure.removeField($tableModel; Choose:C955(Num:C11($field.type)<0; $o.name; $field.id))
						
					End if 
					
					//_____________________________________________________
				: (Num:C11($o.published)=0)
					
					// <NOTHING MORE TO DO>
					
					//_____________________________________________________
				Else 
					
					// MIXED
					
					//_____________________________________________________
			End case 
		End for each 
		
		// REMOVE TABLE IF NO MORE PUBLISHED FIELDS
		If (OB Keys:C1719($tableModel).length=1)
			
			PROJECT.removeTable($currentTable.tableNumber)
			
			// UI - De-emphasize the table name
			$indx:=Find in array:C230((OBJECT Get pointer:C1124(Object named:K67:5; $form.tableList))->; True:C214)
			LISTBOX SET ROW FONT STYLE:C1268(*; $form.tableList; $indx; Plain:K14:1)
			
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
		: (Bool:C1537($field.oneToOne))  // 1 -> N -> 1
			
			$published:=Num:C11($dataModel[String:C10($table.tableNumber)][String:C10($field.name)]#Null:C1517)
			
			$type:=8860
			
			//…………………………………………………………………………………………………
		: ($field.kind="storage")  // Alias
			
			If ($type<=EDITOR.fieldIcons.length)
				
				$published:=Num:C11($dataModel[String:C10($table.tableNumber)][String:C10($field.id)]#Null:C1517)
				
			End if 
			
			//…………………………………………………………………………………………………
		: ($field.kind="alias")  // Alias
			
			If ($type<=EDITOR.fieldIcons.length)
				
				$published:=Num:C11($dataModel[String:C10($table.tableNumber)][String:C10($field.name)]#Null:C1517)
				
				$type:=($type=42) ? 8859 : ($type=38) ? 8858 : $type
				
			End if 
			
			//…………………………………………………………………………………………………
		: ($field.kind="calculated")  // Computed
			
			If ($type<=EDITOR.fieldIcons.length)
				
				$published:=Num:C11($dataModel[String:C10($table.tableNumber)][String:C10($field.name)]#Null:C1517)
				
			End if 
			
			//…………………………………………………………………………………………………
		: ($field.kind="relatedEntity")  // N -> 1 relation
			
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
							: ($o.kind="alias")
								
								//______________________________________________________
							: ($o.fieldType=8859)
								
								$published+=Num:C11($fieldModel[String:C10($o.name)]=Null:C1517)
								
								//______________________________________________________
							: ($o.fieldType=8858)
								
								$published+=Num:C11($fieldModel[String:C10($o.name)]=Null:C1517)
								
								//______________________________________________________
							Else 
								
								$c:=Split string:C1554($o.path; "."; sk ignore empty strings:K86:1)
								
								If ($c.length=1)
									
									// Field
									$published+=Num:C11($fieldModel[String:C10($o.fieldNumber)]=Null:C1517)
									
								Else 
									
									// Link
									$published+=Num:C11($fieldModel[$c[0]][String:C10($o.fieldNumber)]=Null:C1517)
									
								End if 
								
								//______________________________________________________
						End case 
					End for each 
				End if 
			End if 
			
			$type:=8858
			
			//…………………………………………………………………………………………………
		: ($field.kind="relatedEntities")  // 1 -> N relation //($field.type=-2)
			
			//*******************************************************************************************
			$published:=Num:C11($dataModel[String:C10($table.tableNumber)][String:C10($field.name)]#Null:C1517)
			
			//
			// C'EST FAUX SI LE LIEN A ÉTÉ RENOMMÉ
			// REGARDER DANS : Form.$dialog.unsynchronizedTableFields[String($Obj_in.table.tableNumber)]
			//
			//*******************************************************************************************
			$type:=8859
			
			//…………………………………………………………………………………………………
		Else 
			
			If ($type<=EDITOR.fieldIcons.length)
				
				$published:=Num:C11($dataModel[String:C10($table.tableNumber)][String:C10($field.id)]#Null:C1517)
				
			End if 
			
			//…………………………………………………………………………………………………
	End case 
	
	APPEND TO ARRAY:C911((This:C1470.publishedPtr)->; $published)
	APPEND TO ARRAY:C911((This:C1470.iconsPtr)->; EDITOR.fieldIcons[$type])
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