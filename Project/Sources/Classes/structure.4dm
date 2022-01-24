//mark: dependencies
/*
{ "class" : "str" }
*/

Class constructor($sorted : Boolean)
	
	This:C1470.stampFieldName:="__GlobalStamp"
	This:C1470.deletedRecordsTableName:="__DeletedRecords"
	
	This:C1470.warnings:=New collection:C1472
	This:C1470.errors:=New collection:C1472
	
	This:C1470.success:=True:C214
	
	This:C1470.allowedTypes:=New collection:C1472("string"; "bool"; "date"; "number"; "image")
	
	If (FEATURE.with("objectFieldManagement"))
		
		This:C1470.allowedTypes.push("object")
		
	End if 
	
	This:C1470.datastore:=This:C1470.exposedDatastore()
	This:C1470.catalog:=This:C1470.exposedCatalog($sorted)
	
	//==================================================================
Function exposedDatastore()->$datastore : Object
	
	
	If (FEATURE.with("modernStructure")) & False:C215
		
		$datastore:=New object:C1471
		
		var $tableName : Text
		For each ($tableName; ds:C1482)
			
			If ($tableName=This:C1470.deletedRecordsTableName)
				
				// DON'T DISPLAY DELETED RECORDS TABLE
				continue
				
			Else 
				
				If (ds:C1482[$tableName].getInfo().exposed)
					
					$datastore[$tableName]:=ds:C1482[$tableName]
					
					var $o : Object
					For each ($o; OB Entries:C1720($datastore[$tableName]))
						
						If (Not:C34(Bool:C1537($o.value.exposed)))
							
							OB REMOVE:C1226($datastore[$tableName]; String:C10($o.key))
							
						End if 
					End for each 
				End if 
			End if 
		End for each 
		
	Else 
		
		$datastore:=_4D_Build Exposed Datastore:C1598
		
	End if 
	
	//==================================================================
/* 
If $query is a table name or number, the catalog is that table's if found.
	
Note: The catalog property is filled in during the construction phase of the class.
      Thus, this function must only be called to obtain an updated catalog.
*/
Function exposedCatalog($query; $sorted : Boolean)->$catalog : Collection
	
	var $fieldName; $t; $tableName : Text
	var $field; $inquiry; $o; $table : Object
	var $str : cs:C1710.str
	
	$sorted:=(Value type:C1509($query)=Is boolean:K8:9) ? Bool:C1537($query) : $sorted
	
	This:C1470.success:=(This:C1470.datastore#Null:C1517)
	
	If (This:C1470.success)
		
		$catalog:=New collection:C1472
		
		If (Count parameters:C259>=0) && (Value type:C1509($query)#Is boolean:K8:9)
			
			Case of 
					
					//…………………………………………………………………………………………………
				: (Value type:C1509($query)=Is text:K8:3)  // Table name
					
					
					$o:=This:C1470.datastore[$query]
					
					If ($o#Null:C1517)
						
						$o:=$o.getInfo()
						
						If ($o.exposed)
							
							$table:=This:C1470.datastore[$t]
							
						Else 
							
							This:C1470.errors.push("The table #"+String:C10($query)+" is not exposed!")
							
						End if 
						
					Else 
						
						This:C1470.errors.push("The table #"+String:C10($query)+" is not exposed!")
						
					End if 
					
					$table:=This:C1470.datastore[$query]
					
					//…………………………………………………………………………………………………
				: (Value type:C1509($query)=Is longint:K8:6)\
					 | (Value type:C1509($query)=Is real:K8:4)  // Table number
					
					For each ($t; This:C1470.datastore)
						
						$o:=This:C1470.datastore[$t].getInfo()
						
						If ($o.tableNumber=$query)
							
							If ($o.exposed)
								
								$table:=This:C1470.datastore[$t]
								
							Else 
								
								This:C1470.errors.push("The table #"+String:C10($query)+" is not exposed")
								
							End if 
							
							break
							
						End if 
					End for each 
					
				Else 
					
					This:C1470.errors.push("Query parameter must be a Text or a Number: "+String:C10($query))
					
					//…………………………………………………………………………………………………
			End case 
			
			This:C1470.success:=$table#Null:C1517
			
			If (This:C1470.success)
				
				$catalog.push($table.getInfo())
				
			Else 
				
				This:C1470.errors.push("Table not found: "+String:C10($query))
				
			End if 
			
		Else 
			
			For each ($tableName; This:C1470.datastore)
				
				If ($tableName=This:C1470.deletedRecordsTableName)
					
					// DON'T DISPLAY DELETED RECORDS TABLE
					continue
					
				Else 
					
					$o:=This:C1470.datastore[$tableName].getInfo()
					
					If ($o.exposed)
						
						$catalog.push(This:C1470.datastore[$tableName].getInfo())
						
					End if 
				End if 
			End for each 
		End if 
		
	Else 
		
		// <NO DATASTORE>
		
	End if 
	
	If (This:C1470.success)
		
		$str:=cs:C1710.str.new()
		
		For each ($table; $catalog)
			
			$table.field:=New collection:C1472
			
			For each ($fieldName; This:C1470.datastore[$table.name])
				
				If ($fieldName=This:C1470.stampFieldName)\
					 || (Position:C15("."; $fieldName)>0)
					
/*
DON'T DISPLAY STAMP FIELD
DON'T ALLOW FIELD OR RELATION NAME WITH DOT !
*/
					
					continue
					
				End if 
				
				$field:=This:C1470.datastore[$table.name][$fieldName]
				
				// Get a field with the same name already exists
				$inquiry:=$table.field.query("name = :1"; $fieldName).pop()
				
				Case of 
						
						//…………………………………………………………………………………………………
					: ($inquiry#Null:C1517 && $str.setText($inquiry.name).equal($fieldName))
						
						// NOT ALLOW DUPLICATE NAMES !
						This:C1470.warnings.push("Name conflict for \""+$fieldName+"\"")
						
						//…………………………………………………………………………………………………
					: ($field.kind="storage")
						
/*
Storage (or scalar) attribute,
i.e. attribute storing a value, not a reference to another attribute
*/
						
						If (This:C1470.allowedTypes.indexOf($field.type)>=0)
							
							// #TEMPO [
							$field.id:=$field.fieldNumber
							$field.valueType:=$field.type
							$field.type:=This:C1470.__fielddType($field.fieldType)
							// ]
							
							$table.field.push($field)
							
						End if 
						
						//…………………………………………………………………………………………………
					: ($field.kind="relatedEntity")
						
/*
N -> 1 relation attribute (reference to an entity)
*/
						
						If (This:C1470.datastore[$field.relatedDataClass]#Null:C1517)
							
							$table.field.push(New object:C1471(\
								"name"; $fieldName; \
								"inverseName"; $field.inverseName; \
								"type"; -1; \
								"relatedDataClass"; $field.relatedDataClass; \
								"relatedTableNumber"; This:C1470.datastore[$field.relatedDataClass].getInfo().tableNumber))
							
						End if 
						
						//…………………………………………………………………………………………………
					: ($field.kind="relatedEntities")
						
/*
1 -> N relation attribute (reference to an entity selection)
*/
						
						$table.field.push(New object:C1471(\
							"name"; $fieldName; \
							"inverseName"; $field.inverseName; \
							"type"; -2; \
							"relatedDataClass"; $field.relatedDataClass; \
							"relatedTableNumber"; This:C1470.datastore[$field.relatedDataClass].getInfo().tableNumber; \
							"isToMany"; True:C214))
						
						//…………………………………………………………………………………………………
					: (Not:C34(Bool:C1537($field.exposed)))
						
						// <IGNORE NOT EXPOSED ATTRIBUTES>
						
						//…………………………………………………………………………………………………
					: ($field.kind="calculated")
						
/*
Attribute with a data type that masks a calculation
*/
						
						If (This:C1470.allowedTypes.indexOf($field.type)>=0)
							
							$table.field.push(New object:C1471(\
								"name"; $fieldName; \
								"kind"; $field.kind; \
								"type"; -3; \
								"fieldType"; $field.fieldType; \
								"valueType"; $field.type))
							
						End if 
						
						//…………………………………………………………………………………………………
					: (Not:C34(FEATURE.with("alias")))
						
						// <NOT YET AVAILABLE>
						
						//…………………………………………………………………………………………………
					: ($field.kind="alias")
						
/*
Attribute built above another attribute of the data model
the target can be a storage attribute or an entity selection
*/
						
						Case of 
								
								//______________________________________
							: ($field.relatedDataClass#Null:C1517)  // Selection
								
								$table.field.push($field)
								
								//______________________________________
							: (This:C1470.allowedTypes.indexOf($field.type)>=0)  // Attribute
								
								$table.field.push($field)
								
								//______________________________________
							Else 
								
								ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
								
								//______________________________________
						End case 
						
						//…………………………………………………………………………………………………
					Else 
						
						ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
						
						//…………………………………………………………………………………………………
				End case 
			End for each 
			
			If ($sorted)
				
				$table.field:=$table.field.orderBy("name asc")
				
			End if 
		End for each 
		
		If ($sorted)
			
			$catalog:=$catalog.orderBy("name asc")
			
		End if 
	End if 
	
	//==================================================================
Function isStorage($field : Object)->$is : Boolean
	
	If (String:C10($field.kind)="storage")
		
		// Don't allow stamp field
		If ($field.name#This:C1470.stampFieldName)
			
			$is:=This:C1470._allowPublication($field)
			
		End if 
	End if 
	
	//==================================================================
Function isRelatedEntity($field : Object)->$is : Boolean
	
	$is:=($field.kind="relatedEntity")
	
	//==================================================================
Function isRelatedEntities($field : Object)->$is : Boolean
	
	$is:=($field.kind="relatedEntities")
	
	//==================================================================
Function isComputedAttribute($field : Object)->$is : Boolean
	
	If (String:C10($field.kind)="calculated")
		
		$is:=This:C1470._allowPublication($field)
		
	End if 
	
	//==================================================================
Function isAlias($field : Object)->$is : Boolean
	
	If (String:C10($field.kind)="alias")
		
		$is:=This:C1470._allowPublication($field)
		
	End if 
	
	//==================================================================
Function fieldDefinition($table; $fieldPath : Text)->$field : Object
	var $tableNumber : Integer
	var $field; $tableCatalog : Object
	var $c : Collection
	
	If (Value type:C1509($table)=Is longint:K8:6)\
		 | (Value type:C1509($table)=Is real:K8:4)
		
		$tableNumber:=$table
		
	Else 
		
		$tableNumber:=This:C1470.tableNumber(String:C10($table))
		
	End if 
	
	$field:=New object:C1471
	
	$tableCatalog:=This:C1470.catalog.query("tableNumber=:1"; $tableNumber).pop()
	This:C1470.success:=($tableCatalog#Null:C1517)
	
	If (This:C1470.success)
		
		$c:=Split string:C1554($fieldPath; ".")
		
		$field:=$tableCatalog.field.query("name = :1"; $c[0]).pop()
		This:C1470.success:=($field#Null:C1517)
		
		If (This:C1470.success)
			
			If ($c.length=1)
				
				$field.path:=$fieldPath
				$field.tableNumber:=$tableNumber
				$field.tableName:=Table name:C256($tableNumber)
				
				If ($field.type=-2)  // 1 to N relation
					
					$field.fieldType:=8859
					$field.type:=-2
					$field.relatedDataClass:=$field.relatedDataClass
					$field.relatedTableNumber:=$field.relatedTableNumber
					
				Else 
					
					$field.fieldNumber:=$field.fieldNumber
					$field.fieldType:=$field.fieldType
					$field.name:=Field name:C257($tableNumber; $field.fieldNumber)
					$field.type:=This:C1470.__fielddType($field.fieldType)
					
				End if 
				
			Else 
				
				$tableNumber:=$field.relatedTableNumber
				
				If ($c.length>2)
					
					$field:=This:C1470.fieldDefinition($tableNumber; $c.copy().remove(0).join("."))
					$field.path:=$fieldPath
					
				Else 
					
					$tableCatalog:=This:C1470.catalog.query("tableNumber=:1"; $tableNumber).pop()
					This:C1470.success:=($tableCatalog#Null:C1517)
					
					If (This:C1470.success)
						
						$field:=$tableCatalog.field.query("name=:1"; $c[1]).pop()
						This:C1470.success:=($field#Null:C1517)
						
						If (This:C1470.success)
							
							$field.path:=$fieldPath
							$field.tableName:=Table name:C256($tableNumber)
							$field.tableNumber:=$tableNumber
							$field.fieldNumber:=$field.fieldNumber
							
							$field.name:=Choose:C955($field.relatedDataClass=Null:C1517; Field name:C257($tableNumber; $field.fieldNumber); $c[0])
							
							$field.fieldType:=$field.fieldType
							
							$field.valueType:=$field.type
							$field.type:=This:C1470.__fielddType($field.fieldType)
							
						Else 
							
							This:C1470.errors.push("Field "+$c[1]+" not found")
							
						End if 
						
					Else 
						
						This:C1470.errors.push("Related table not found #"+String:C10($tableNumber))
						
					End if 
				End if 
			End if 
			
		Else 
			
			This:C1470.errors.push("Field "+$c[0]+" not found")
			
		End if 
		
	Else 
		
		This:C1470.errors.push("Table not found #"+String:C10($tableNumber))
		
	End if 
	
	//==================================================================
	// Return related entity catalog
Function relatedCatalog($tableName : Text; $relationName : Text; $recursive : Boolean)->$result : Object
	
	var $fieldName : Text
	var $withRecursiveLinks : Boolean
	var $field; $o; $related; $relatedDataClass; $relatedField : Object
	
	$result:=New object:C1471(\
		"success"; False:C215)
	
	If (Count parameters:C259>=3)
		
		$withRecursiveLinks:=$recursive
		
	End if 
	
	$field:=This:C1470.datastore[$tableName][$relationName]
	
	Case of 
			
			//…………………………………………………………………………………………………
		: ($field=Null:C1517)
			
			// <NOTHING MORE TO DO>
			
			//…………………………………………………………………………………………………
		: (This:C1470.isStorage($field))
			
			
			
			//…………………………………………………………………………………………………
		: (This:C1470.isRelatedEntity($field))  // N -> 1 relation
			
			$result.success:=True:C214
			$result.fields:=New collection:C1472
			$result.relatedEntity:=$field.name
			$result.relatedTableNumber:=This:C1470.datastore[$field.relatedDataClass].getInfo().tableNumber
			$result.relatedDataClass:=$field.relatedDataClass
			$result.inverseName:=$field.inverseName
			
			$relatedDataClass:=This:C1470.datastore[$field.relatedDataClass]
			
			For each ($fieldName; $relatedDataClass)
				
				$o:=$relatedDataClass[$fieldName]
				
				Case of 
						
						//___________________________________________
					: (This:C1470.isStorage($o))
						
						// #TEMPO
						$o.valueType:=$o.type
						
						$o.path:=$o.name
						$o.type:=This:C1470.__fielddType($o.fieldType)
						$o.relatedTableNumber:=$result.relatedTableNumber
						$result.fields.push($o)
						
						//___________________________________________
					: (This:C1470.isRelatedEntity($o))  // N -> 1 relation
						
						If ($withRecursiveLinks ? True:C214 : ($o.relatedDataClass#$tableName))
							
							// FIXME: MUST NOT BE DEPENDANT OF Form
							For each ($relatedField; Form:C1466.$project.$catalog.query("name = :1"; $o.relatedDataClass).pop().field)
								
								Case of 
										
										//______________________________________________________
									: (This:C1470.isStorage($relatedField))
										
										$related:=This:C1470.fieldDefinition(This:C1470.tableNumber($o.relatedDataClass); $relatedField.name)
										
										If ($related#Null:C1517)
											
											$related.path:=$o.name+"."+$related.name
											$result.fields.push($related)
											
										End if 
										
										//______________________________________________________
									: (This:C1470.isComputedAttribute($relatedField))
										
										$related:=OB Copy:C1225($relatedField)
										$related.path:=$o.name
										$related.tableNumber:=$result.relatedTableNumber
										$result.fields.push($related)
										
										//______________________________________________________
									: (This:C1470.isRelatedEntity($field))
										
										// NOT MANAGED
										
										//______________________________________________________
									: (This:C1470.isRelatedEntities($field))
										
										// NOT MANAGED
										
										//______________________________________________________
									Else 
										
										ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
										
										//______________________________________________________
								End case 
							End for each 
						End if 
						
						//…………………………………………………………………………………………………
					: (This:C1470.isRelatedEntities($o))  // 1 -> N relation
						
						If (Choose:C955($withRecursiveLinks; True:C214; ($o.relatedDataClass#$tableName)))
							
							$result.fields.push(New object:C1471(\
								"name"; $o.name; \
								"path"; $o.name; \
								"fieldType"; 8859; \
								"relatedDataClass"; $o.relatedDataClass; \
								"relatedTableNumber"; This:C1470.tableNumber($o.relatedDataClass); \
								"inverseName"; $o.inverseName; \
								"isToMany"; True:C214))
							
						End if 
						
						//…………………………………………………………………………………………………
					: (This:C1470.isComputedAttribute($o))  // Computed
						
						
						// #TEMPO
						$o.valueType:=$o.type
						$o.path:=$o.name
						$o.type:=-3
						$o.computed:=True:C214
						$o.relatedTableNumber:=$result.relatedTableNumber
						$result.fields.push($o)
						
						//…………………………………………………………………………………………………
					Else 
						
						//ASSERT(Not(DATABASE.isMatrix); "😰 I wonder why I'm here")
						
						//___________________________________________
				End case 
			End for each 
			
			//…………………………………………………………………………………………………
		: (This:C1470.isRelatedEntities($field))  // 1 -> N relation
			
			// <NOT YET  MANAGED>
			
			//…………………………………………………………………………………………………
		: (This:C1470.isComputedAttribute($field))  // Computed
			
			//
			
			//…………………………………………………………………………………………………
		: (This:C1470.isAlias($field))  // Alias
			
			//
			
			//…………………………………………………………………………………………………
		Else 
			
			ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
			
			//…………………………………………………………………………………………………
	End case 
	
	//==================================================================
	// Returns a table catalog
Function tableDefinition($name : Text)->$tableDefinition : Object
	
	$tableDefinition:=This:C1470.catalog.query("name = :1"; "UNIT_0").pop()
	
	//==================================================================
	/// Returns the tables infos
Function tableInfo($tableName : Text)->$tableInfos : Object
	
	var $o : Object
	
	$o:=This:C1470.catalog.query("name= :1"; $tableName).pop()
	
	This:C1470.success:=$o#Null:C1517
	
	If (This:C1470.success)
		
		$tableInfos:=$o.getInfo()
		
	End if 
	
	//==================================================================
	// Returns table number from name
Function tableNumber($tableName : Text)->$tableNumber : Integer
	
	var $o : Object
	
	$o:=This:C1470.catalog.query("name= :1"; $tableName).pop()
	
	This:C1470.success:=$o#Null:C1517
	
	If (This:C1470.success)
		
		$tableNumber:=$o.tableNumber
		
	End if 
	
	//==================================================================
	// Adding a field to a table data model
Function addField($table : Object; $field : Object)
	var $fieldID : Text
	var $type : Integer
	var $relatedCatalog; $relatedField : Object
	var $c : Collection
	
	$type:=Num:C11($field.type)
	
	Case of 
			
			//………………………………………………………………………………………………………
		: ($type=-1)  // N -> 1 relation
			
			// Add all related fields
			$relatedCatalog:=This:C1470.relatedCatalog($table[""].name; $field.name; True:C214)
			
			$table[$field.name]:=New object:C1471(\
				"relatedDataClass"; $relatedCatalog.relatedDataClass; \
				"relatedTableNumber"; $relatedCatalog.relatedTableNumber; \
				"inverseName"; $relatedCatalog.inverseName; \
				"label"; PROJECT.label($relatedField.name); \
				"shortLabel"; PROJECT.shortLabel($relatedField.name))
			
			For each ($relatedField; $relatedCatalog.fields)
				
				$fieldID:=String:C10($relatedField.fieldNumber)
				$c:=Split string:C1554($relatedField.path; ".")
				
				// Create the field, if any
				If ($c.length>1)
					
					If ($table[$field.name][$c[0]]=Null:C1517)
						
						$table[$field.name][$c[0]]:=New object:C1471(\
							"relatedDataClass"; $relatedField.tableName; \
							"relatedTableNumber"; $relatedField.tableNumber; \
							"inverseName"; This:C1470.tableDefinition($table[""].name).field.query("name=:1"; $field.name).pop().inverseName)
						
					End if 
					
					If ($table[$field.name][$c[0]][$fieldID]=Null:C1517)
						
						$table[$field.name][$c[0]][$fieldID]:=New object:C1471(\
							"name"; $relatedField.name; \
							"path"; $relatedField.path; \
							"label"; PROJECT.label($relatedField.name); \
							"shortLabel"; PROJECT.shortLabel($relatedField.name); \
							"type"; $relatedField.type; \
							"fieldType"; $relatedField.fieldType)
						
					End if 
					
				Else 
					
					If (Bool:C1537($relatedField.isToMany))
						
						If ($table[$field.name][$relatedField.name]=Null:C1517)
							
							$table[$field.name][$relatedField.name]:=New object:C1471(\
								"name"; $relatedField.name; \
								"relatedDataClass"; $relatedField.relatedDataClass; \
								"relatedTableNumber"; This:C1470.tableNumber($relatedField.relatedDataClass); \
								"path"; $field.name+"."+$relatedField.path; \
								"label"; PROJECT.labelList($relatedField.name); \
								"shortLabel"; PROJECT.label($relatedField.name); \
								"inverseName"; $relatedField.inverseName; \
								"isToMany"; True:C214)
							
						End if 
						
					Else 
						
						
						Case of 
								//______________________________________________________
							: (Bool:C1537($relatedField.computed))
								
								//TODO: Publish the computed attributes
								
								//______________________________________________________
							: ($table[$field.name][$fieldID]=Null:C1517)
								
								$table[$field.name][$fieldID]:=New object:C1471(\
									"name"; $relatedField.name; \
									"path"; $relatedField.path; \
									"label"; PROJECT.label($relatedField.name); \
									"shortLabel"; PROJECT.shortLabel($relatedField.name); \
									"type"; $relatedField.type; \
									"fieldType"; $relatedField.fieldType)
								
								//______________________________________________________
							Else 
								
								// A "Case of" statement should never omit "Else"
								
								//______________________________________________________
						End case 
					End if 
				End if 
			End for each 
			
			//………………………………………………………………………………………………………
		: ($type=-2)  // 1 -> N relation
			
			$table[$field.name]:=New object:C1471(\
				"label"; PROJECT.label(cs:C1710.str.new("listOf").localized($field.name)); \
				"shortLabel"; PROJECT.label($field.name); \
				"relatedEntities"; $field.relatedDataClass; \
				"relatedTableNumber"; $field.relatedTableNumber; \
				"inverseName"; $field.inverseName)
			
			//………………………………………………………………………………………………………
		: ($type=-3)  // Computed attribute
			
			$table[$field.name]:=New object:C1471(\
				"name"; $field.name; \
				"label"; PROJECT.label($field.name); \
				"shortLabel"; PROJECT.label($field.name); \
				"fieldType"; $field.fieldType; \
				"computed"; True:C214)
			
			// #TEMPO
			$table[$field.name].type:=$field.type
			
			//………………………………………………………………………………………………………
		Else 
			
			// Add the field to data model
			$table[String:C10($field.id)]:=New object:C1471(\
				"name"; $field.name; \
				"label"; PROJECT.label($field.name); \
				"shortLabel"; PROJECT.label($field.name); \
				"fieldType"; $field.fieldType)
			
			// #TEMPO
			$table[String:C10($field.id)].type:=$field.type
			
			//………………………………………………………………………………………………………
	End case 
	
	//==================================================================
	// Removing a field from a table data model
Function removeField($table : Object; $fieldOrKey : Variant)
	
	If (Value type:C1509($fieldOrKey)=Is object:K8:27)
		
		If (Num:C11($fieldOrKey.type)<0)  // Relation
			
			If ($table[$fieldOrKey.name]#Null:C1517)
				
				OB REMOVE:C1226($table; $fieldOrKey.name)
				
			End if 
			
		Else 
			
			OB REMOVE:C1226($table; String:C10($fieldOrKey.id))
			
		End if 
		
	Else 
		
		OB REMOVE:C1226($table; String:C10($fieldOrKey))
		
	End if 
	
	//==================================================================
	// Returns True if a field could be published
Function _allowPublication($field : Object)->$allow : Boolean
	
	If ($field.name#This:C1470.stampFieldName)
		
		$allow:=(This:C1470.allowedTypes.indexOf($field.type)>=0)
		
	End if 
	
	//==================================================================
Function __fielddType  // #TEMPORARY REMAPPING FOR THE FIELD TYPE
	var $0 : Integer
	var $1 : Integer
	
	var $c : Collection
	
	$c:=New collection:C1472
	$c[0]:=10  // Text
	$c[Is boolean:K8:9]:=1
	$c[Is integer:K8:5]:=3
	$c[Is longint:K8:6]:=4
	$c[Is integer 64 bits:K8:25]:=5
	$c[Is real:K8:4]:=6
	$c[_o_Is float:K8:26]:=6
	$c[Is date:K8:7]:=8
	$c[Is time:K8:8]:=9
	$c[Is text:K8:3]:=10
	$c[Is picture:K8:10]:=12
	$c[Is BLOB:K8:12]:=18
	$c[Is object:K8:27]:=21
	
	$c[5]:=10  // ACI0100285
	
	$0:=$c[$1]
	
Function check
	
	//#WIP
	
	
	