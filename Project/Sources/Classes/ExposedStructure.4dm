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
	
	This:C1470.sorted:=(Count parameters:C259>=1) ? $sorted : False:C215
	
	This:C1470.update()
	
	//==================================================================
	/// Update the datastore & the catalog
Function update()
	
	This:C1470.datastore:=This:C1470.getDatastore()
	This:C1470.catalog:=This:C1470.getCatalog()
	
	//==================================================================
/** Returns a datastore like object of the exposed dataclass and attributes
- Only references tables with a single primary key (tables without a primary key or with composite primary keys are not referenced).
- Only references tables & fields exposed as REST resource.
- BLOB type attributes are not managed in the datastore.
- A relation N -> 1 is not referenced if the field isn't exposed !
- A relation 1 -> N is not referenced if the related dataclass isn't exposed !
	
Note: The datastore property is filled in during the construction phase of the class.
      Thus, this function must only be called to obtain an updated datastore.
*/
Function getDatastore()->$datastore : Object
	
	If (FEATURE.with("modernStructure"))
		
		var $key : Text
		var $o : Object
		var $table : cs:C1710.table
		var $ds : cs:C1710.DataStore
		
		$datastore:=New object:C1471
		$ds:=ds:C1482
		
		For each ($key; $ds)
			
			$o:=$ds[$key].getInfo()
			
			If ($key=This:C1470.deletedRecordsTableName)\
				 || Not:C34($o.exposed)
				
				continue
				
			Else 
				
				$table:=New object:C1471
				$table[""]:=$o
				
				For each ($o; OB Entries:C1720($ds[$key]))
					
					If ($o.key=This:C1470.stampFieldName)\
						 || (Not:C34(Bool:C1537($o.value.exposed)))\
						 || (This:C1470.allowedTypes.indexOf($o.value.type)=-1)
						
						continue
						
					Else 
						
						$table[$o.key]:=$o.value
						
					End if 
				End for each 
				
				$datastore[$key]:=$table
				
			End if 
		End for each 
		
	Else 
		
		$datastore:=_4D_Build Exposed Datastore:C1598
		
	End if 
	
	//==================================================================
/** Returns a collection of all project's dataclasses and their attributes
	
- If $query is a dataclasses name or number, the catalog is that dataclasses's if found.
	
Note: The catalog property is filled in during the construction phase of the class.
      Thus, this function must only be called to obtain an updated catalog.
*/
Function getCatalog($query; $sorted : Boolean)->$catalog : Collection
	
	var $tableName : Text
	var $o : Object
	var $table : cs:C1710.table
	var $datastore : Object
	var $ds : cs:C1710.DataStore
	
	$datastore:=This:C1470.datastore
	$ds:=ds:C1482
	
	This:C1470.success:=($datastore#Null:C1517)
	
	If (This:C1470.success)
		
		$sorted:=(Value type:C1509($query)=Is boolean:K8:9) ? Bool:C1537($query) : This:C1470.sorted
		
		$catalog:=New collection:C1472
		
		If (Count parameters:C259>=1) && (Value type:C1509($query)#Is boolean:K8:9)
			
			// Query on dataclasses name or number
			
			Case of 
					
					//…………………………………………………………………………………………………
				: (Value type:C1509($query)=Is text:K8:3)  // Table name
					
					If ($datastore[$query]#Null:C1517)\
						 && ($ds[$query].getInfo().exposed)
						
						$table:=$ds[$query].getInfo()
						$catalog.push($table)
						
					Else 
						
						This:C1470.errors.push("The table "+String:C10($query)+" is not exposed!")
						
					End if 
					
					//…………………………………………………………………………………………………
				: (Value type:C1509($query)=Is longint:K8:6)\
					 | (Value type:C1509($query)=Is real:K8:4)  // Table number
					
					For each ($tableName; $datastore)
						
						$o:=$ds[$tableName].getInfo()
						
						If ($o.tableNumber=$query)
							
							If ($o.exposed)
								
								$table:=$ds[$tableName].getInfo()
								$catalog.push($table)
								
							Else 
								
								This:C1470.errors.push("The table #"+String:C10($query)+" is not exposed")
								
							End if 
							
							break
							
						End if 
					End for each 
					
					//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
				Else 
					
					This:C1470.errors.push("Query parameter must be a Text or a Number: "+String:C10($query))
					
					//…………………………………………………………………………………………………
			End case 
			
			This:C1470.success:=($table#Null:C1517)
			
			If (Not:C34(This:C1470.success))
				
				This:C1470.errors.push("Table not found: "+String:C10($query))
				
			End if 
			
		Else 
			
			// All dataclasses
			For each ($tableName; $datastore)
				
				$table:=$ds[$tableName].getInfo()
				$catalog.push($table)
				
			End for each 
		End if 
		
	Else 
		
		// <NO DATASTORE>
		
	End if 
	
	If (This:C1470.success)
		
		For each ($table; $catalog)
			
			$table.field:=This:C1470._fields($table.name)
			
			If ($sorted)
				
				$table.field:=$table.field.orderBy("name asc")
				
			End if 
			
			//MARK: temporary add fields collection to replace field
			$table.fields:=$table.field
			
		End for each 
		
		If ($sorted)
			
			$catalog:=$catalog.orderBy("name asc")
			
		End if 
	End if 
	
	//==================================================================
	/// Returns a table definition object from its name or number
Function table($query)->$table : cs:C1710.table
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($query)=Is text:K8:3)
			
			$table:=This:C1470.catalog.query("name = :1"; $query).pop()
			
			//______________________________________________________
		: (Value type:C1509($query)=Is real:K8:4)\
			 | (Value type:C1509($query)=Is longint:K8:6)
			
			$table:=This:C1470.catalog.query("tableNumber = :1"; Num:C11($query)).pop()
			
			//______________________________________________________
		Else 
			
			This:C1470.errors.push("The query parameter must be a Text or a Number ("+String:C10(Value type:C1509($query))+")")
			
			//______________________________________________________
	End case 
	
	This:C1470.success:=($table#Null:C1517)
	
	//==================================================================
	/// Returns Info of the table from its name or number.
Function tableInfos($query)->$infos : Object
	
	var $table : Object
	
	$table:=This:C1470.table($query)
	
	If (This:C1470.success)
		
		$infos:=ds:C1482[$table.name].getInfo()
		
	End if 
	
	//==================================================================
	/// Returns the table number from its name or number
Function tableNumber($query)->$number : Integer
	
	var $table : Object
	
	$table:=This:C1470.table($query)
	
	If (This:C1470.success)
		
		$number:=$table.tableNumber
		
	End if 
	
	//==================================================================
	/// Returns the table name from its name or number
Function tableName($query)->$name : Text
	
	var $table : Object
	
	$table:=This:C1470.table($query)
	
	If (This:C1470.success)
		
		$name:=$table.name
		
	End if 
	
	//==================================================================
	/// Returns a field definition object
	// FIXME: ? MUST NOT BE INTO THIS CLASSE -> PROJECT
Function fieldDefinition($tableIdentifier; $fieldPath : Text)->$field : Object
	
	var $table : Object
	var $c : Collection
	
	$table:=This:C1470.table($tableIdentifier)
	
	If (This:C1470.success)
		
		$c:=Split string:C1554($fieldPath; ".")
		
		$field:=$table.field.query("name = :1"; $c[0]).pop()
		This:C1470.success:=($field#Null:C1517)
		
		If (This:C1470.success)
			
			// Don't alter the original
			$field:=OB Copy:C1225($field)
			
			Case of 
					
					//______________________________________________________
				: ($c.length=1)
					
					$field.path:=$fieldPath
					$field.tableNumber:=$table.tableNumber
					$field.tableName:=$table.name
					
					// MARK: ??????
					If ($field.type=-2)  // 1 to N relation
						
						$field.fieldType:=8859
						
					Else 
						
						//
						
					End if 
					
					//______________________________________________________
				: ($field.relatedTableNumber#Null:C1517)
					
					$field:=This:C1470.fieldDefinition($field.relatedTableNumber; $c.copy().remove(0).join("."))
					$field.path:=$fieldPath
					
					//______________________________________________________
				Else 
					
					ASSERT:C1129(DATABASE.isComponent; "😰 I wonder why I'm here")
					
					//______________________________________________________
			End case 
			
		Else 
			
			This:C1470.errors.push("Field "+$c[0]+" not found")
			
		End if 
		
	Else 
		
		This:C1470.errors.push("Table "+String:C10($tableIdentifier)+" not found")
		
	End if 
	
	//==================================================================
Function isStorage($field : Object)->$is : Boolean
	
	If (($field#Null:C1517) && (String:C10($field.kind)="storage"))
		
		// Don't allow stamp field
		If ($field.name#This:C1470.stampFieldName)
			
			$is:=This:C1470._allowPublication($field)
			
		End if 
	End if 
	
	//==================================================================
Function isRelatedEntity($field : Object)->$is : Boolean
	
	$is:=($field#Null:C1517) && ($field.kind="relatedEntity")
	
	//==================================================================
Function isRelatedEntities($field : Object)->$is : Boolean
	
	$is:=($field#Null:C1517) && ($field.kind="relatedEntities")
	
	//==================================================================
Function isComputedAttribute($field : Object)->$is : Boolean
	
	$is:=(($field#Null:C1517) && (String:C10($field.kind)="calculated"))
	
	//==================================================================
Function isAlias($field : Object)->$is : Boolean
	
	$is:=(($field#Null:C1517) && (String:C10($field.kind)="alias"))
	
	//==================================================================
	// Return related entity catalog
Function relatedCatalog($tableName : Text; $relationName : Text; $recursive : Boolean)->$result : Object
	
	var $fields : Collection
	var $ds : cs:C1710.DataStore
	var $field : cs:C1710.field
	
	$result:=New object:C1471(\
		"success"; False:C215)
	
	$ds:=ds:C1482
	$field:=$ds[$tableName][$relationName]
	
	If ($field.kind="relatedEntity")  // N -> 1 relation
		
		$result.success:=True:C214
		$result.relatedEntity:=$field.name
		$result.relatedTableNumber:=$ds[$field.relatedDataClass].getInfo().tableNumber
		$result.relatedDataClass:=$field.relatedDataClass
		$result.inverseName:=$field.inverseName
		$result.fields:=New collection:C1472
		
		var $relatedDataClass : Object
		$relatedDataClass:=$ds[$field.relatedDataClass]
		
		var $fieldName : Text
		For each ($fieldName; $relatedDataClass)
			
			$field:=$relatedDataClass[$fieldName]
			
			Case of 
					
					//______________________________________________________
				: ($field.kind="storage")  // Storage attribute
					
					If ($field.name#"__GlobalStamp")\
						 && (This:C1470.allowedTypes.indexOf($field.type)>=0)
						
						// MARK: TEMPO
						$field.valueType:=$field.type
						$field.id:=$field.fieldNumber
						$field.type:=This:C1470.__fielddType($field.fieldType)
						
						$field.path:=$field.name
						$field.relatedTableNumber:=$field.relatedTableNumber
						
						$result.fields.push($field)
						
					End if 
					
					//…………………………………………………………………………………………………
				: ($field.kind="calculated")  // Calculated scalar attribute
					
					If (This:C1470.allowedTypes.indexOf($field.type)>=0)
						
						// MARK: #TEMPO
						$field.valueType:=$field.type
						$field.type:=-3
						
						$field.path:=New collection:C1472($relationName; $field.name).join(".")
						$field.relatedTableNumber:=$result.relatedTableNumber
						
						$result.fields.push($field)
						
					End if 
					
					//…………………………………………………………………………………………………
				: ($field.kind="alias")  // Alias
					
					// MARK: TEMPO
					$field.valueType:=$field.type
					//$field.type:=This.__fielddType($field.fieldType)
					
					$field.path:=$field.name
					$field.relatedTableNumber:=$field.relatedTableNumber
					
					$result.fields.push($field)
					
					//___________________________________________
				: ($field.kind="relatedEntity")  // N -> 1 relation attribute (reference to an entity)
					
					If ($recursive)
						
						var $relatedField; $related : cs:C1710.field
						For each ($relatedField; This:C1470.catalog.query("name = :1"; $result.relatedDataClass).pop().field)
							
							Case of 
									
									//______________________________________________________
								: ($relatedField.kind="storage")  // Storage attribute
									
									If (This:C1470.allowedTypes.indexOf($relatedField.valueType)>=0)
										
										$related:=OB Copy:C1225($relatedField)
										$related.path:=New collection:C1472($field.name; $related.name).join(".")
										$related.tableNumber:=This:C1470.tableNumber($result.relatedDataClass)
										
										$result.fields.push($related)
										
									End if 
									
									//______________________________________________________
								: ($relatedField.kind="calculated")  // Calculated scalar attribute
									
									If (This:C1470.allowedTypes.indexOf($relatedField.valueType)>=0)
										
										$related:=OB Copy:C1225($relatedField)
										$related.path:=New collection:C1472($field.name; $related.name).join(".")
										$related.tableNumber:=This:C1470.tableNumber($result.relatedDataClass)
										
										$result.fields.push($related)
										
									End if 
									
									//______________________________________________________
								: ($relatedField.kind="relatedEntity")
									
									// NOT MANAGED
									
									//______________________________________________________
								: ($relatedField.kind="relatedEntities")
									
									// NOT MANAGED
									
									//…………………………………………………………………………………………………
								: (Not:C34(FEATURE.with("alias")))
									
									// <NOT YET AVAILABLE>
									
									//…………………………………………………………………………………………………
								: ($relatedField.kind="alias")  // Alias
									
									$related:=OB Copy:C1225($relatedField)
									$related.path:=New collection:C1472($field.name; $related.name).join(".")
									$related.tableNumber:=This:C1470.tableNumber($result.relatedDataClass)
									
									$result.fields.push($related)
									
									//______________________________________________________
								Else 
									
									ASSERT:C1129(DATABASE.isComponent; "😰 I wonder why I'm here")
									
									//______________________________________________________
							End case 
						End for each 
					End if 
					
					//___________________________________________
				: ($field.kind="relatedEntities")
					
					// <NOT YET  MANAGED>
					
					//______________________________________________________
				Else 
					
					ASSERT:C1129(DATABASE.isComponent; "😰 I wonder why I'm here")
					
					//______________________________________________________
			End case 
			
			
		End for each 
		
	Else 
		
		//ASSERT(DATABASE.isComponent; "😰 I wonder why I'm here")
		
	End if 
	
	//If (This.isRelatedEntity($field))  // N -> 1 relation
	//$fields:=This._relatedFields($field; $relationName; $recursive)
	//$result.success:=True
	//$result.relatedEntity:=$field.name
	//$result.relatedTableNumber:=$ds[$field.relatedDataClass].getInfo().tableNumber
	//$result.relatedDataClass:=$field.relatedDataClass
	//$result.inverseName:=$field.inverseName
	//$result.fields:=$fields
	//Else 
	//ASSERT(DATABASE.isComponent; "😰 I wonder why I'm here")
	//End if
	
	//==================================================================
	// FIXME: Move to project class
	// Adding a field to a table data model
Function addField($table : Object; $field : cs:C1710.field)
	
	var $fieldID : Text
	var $o; $relatedCatalog; $relatedField : Object
	var $path : Collection
	
	Case of 
			
			//………………………………………………………………………………………………………
		: ($field.kind="storage")  // Attribute
			
			$o:=New object:C1471(\
				"kind"; $field.kind; \
				"name"; $field.name; \
				"label"; PROJECT.label($field.name); \
				"shortLabel"; PROJECT.label($field.name); \
				"valueType"; $field.valueType; \
				"fieldType"; $field.fieldType)
			
			// mark:#TEMPO
			$o.type:=$field.type
			
			$table[String:C10($field.id)]:=$o
			
			//………………………………………………………………………………………………………
		: ($field.kind="alias")
			
			$o:=New object:C1471(\
				"kind"; $field.kind; \
				"name"; $field.name; \
				"path"; $field.path; \
				"label"; PROJECT.label($field.name); \
				"shortLabel"; PROJECT.label($field.name); \
				"valueType"; $field.valueType; \
				"fieldType"; $field.fieldType)
			
			// mark:#TEMPO
			$o.type:=$field.type
			
			$table[$field.name]:=$o
			
			//………………………………………………………………………………………………………
		: ($field.kind="calculated")  // Computed attribute
			
			$o:=New object:C1471(\
				"kind"; $field.kind; \
				"name"; $field.name; \
				"label"; PROJECT.label($field.name); \
				"shortLabel"; PROJECT.label($field.name); \
				"valueType"; $field.valueType; \
				"fieldType"; $field.fieldType)
			
			// mark:#TEMPO
			$o.type:=$field.type
			$o.computed:=True:C214
			
			$table[$field.name]:=$o
			
			//………………………………………………………………………………………………………
		: ($field.kind="relatedEntities")  // 1 -> N relation
			
			$o:=New object:C1471(\
				"kind"; $field.kind; \
				"label"; PROJECT.label(cs:C1710.str.new("listOf").localized($field.name)); \
				"shortLabel"; PROJECT.label($field.name); \
				"relatedEntities"; $field.relatedDataClass; \
				"inverseName"; $field.inverseName)
			
			// mark:#TEMPO
			$o.relatedTableNumber:=$field.relatedTableNumber
			
			$table[$field.name]:=$o
			
			//………………………………………………………………………………………………………
		: ($field.kind="relatedEntity")  // N -> 1 relation
			
			// Add all related fields
			$relatedCatalog:=This:C1470.relatedCatalog($table[""].name; $field.name; True:C214)
			
			$o:=New object:C1471(\
				"kind"; $field.kind; \
				"label"; PROJECT.label($field.name); \
				"shortLabel"; PROJECT.shortLabel($field.name); \
				"relatedDataClass"; $relatedCatalog.relatedDataClass; \
				"inverseName"; $relatedCatalog.inverseName)
			
			// mark:#TEMPO
			$o.relatedTableNumber:=$relatedCatalog.relatedTableNumber
			
			$table[$field.name]:=$o
			
			For each ($relatedField; $relatedCatalog.fields)
				
				$fieldID:=String:C10($relatedField.fieldNumber)
				
				$path:=Split string:C1554($relatedField.path; ".")
				
				// Create the field, if any
				If ($path.length>1)
					
					If ($table[$path[0]]=Null:C1517)
						
						$table[$path[0]]:=New object:C1471(\
							"relatedDataClass"; $relatedField.tableName; \
							"relatedTableNumber"; $relatedField.tableNumber; \
							"inverseName"; This:C1470.table($table[""].name).field.query("name=:1"; $field.name).pop().inverseName)
						
					End if 
					
					If ($table[$path[0]][$fieldID]=Null:C1517)
						
						$table[$path[0]][$fieldID]:=New object:C1471(\
							"kind"; $relatedField.kind; \
							"name"; $relatedField.name; \
							"path"; $relatedField.path; \
							"label"; PROJECT.label($relatedField.name); \
							"shortLabel"; PROJECT.shortLabel($relatedField.name); \
							"type"; $relatedField.type; \
							"fieldType"; $relatedField.fieldType)
						
					End if 
					
				Else 
					
					
					Case of 
							//______________________________________________________
						: ($relatedField.kind="storage") && ($o[$fieldID]=Null:C1517)
							
							$o[$fieldID]:=New object:C1471(\
								"kind"; $relatedField.kind; \
								"name"; $relatedField.name; \
								"path"; $relatedField.path; \
								"label"; PROJECT.label($relatedField.name); \
								"shortLabel"; PROJECT.shortLabel($relatedField.name); \
								"type"; $relatedField.type; \
								"fieldType"; $relatedField.fieldType)
							
							//______________________________________________________
						: ($relatedField.kind="calculated") && ($o[$relatedField.name]=Null:C1517)
							
							$o[$relatedField.name]:=New object:C1471(\
								"kind"; $relatedField.kind; \
								"name"; $relatedField.name; \
								"path"; $relatedField.path; \
								"label"; PROJECT.label($relatedField.name); \
								"shortLabel"; PROJECT.shortLabel($relatedField.name); \
								"type"; $relatedField.type; \
								"fieldType"; $relatedField.fieldType)
							
							//______________________________________________________
						: ($relatedField.kind="alias") && ($o[$relatedField.name]=Null:C1517)
							
							$o[$relatedField.name]:=New object:C1471(\
								"kind"; $relatedField.kind; \
								"name"; $relatedField.name; \
								"path"; $relatedField.path; \
								"label"; PROJECT.label($relatedField.name); \
								"shortLabel"; PROJECT.shortLabel($relatedField.name); \
								"type"; $relatedField.type; \
								"fieldType"; $relatedField.fieldType)
							
							
							
							//______________________________________________________
						: (Bool:C1537($relatedField.isToMany))
							
							If ($o[$relatedField.name]=Null:C1517)
								
								$o[$relatedField.name]:=New object:C1471(\
									"name"; $relatedField.name; \
									"relatedDataClass"; $relatedField.relatedDataClass; \
									"relatedTableNumber"; This:C1470.tableNumber($relatedField.relatedDataClass); \
									"path"; $field.name+"."+$relatedField.path; \
									"label"; PROJECT.labelList($relatedField.name); \
									"shortLabel"; PROJECT.label($relatedField.name); \
									"inverseName"; $relatedField.inverseName; \
									"isToMany"; True:C214)
								
							End if 
							
							
							
							//______________________________________________________
						: (False:C215)
							
							
							
							//______________________________________________________
						Else 
							
							// A "Case of" statement should never omit "Else"
							
							//______________________________________________________
					End case 
				End if 
			End for each 
			
			//………………………………………………………………………………………………………
		Else 
			
			ASSERT:C1129(DATABASE.isComponent; "😰 I wonder why I'm here")
			
			//………………………………………………………………………………………………………
	End case 
	
	//==================================================================
	// FIXME: Move to project class
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
Function check
	
	//TODO: #WIP
	//#WIP
	
	// MARK:-[PRIVATE]
	//==================================================================
	// Returns the collection of exposed fields of a table
Function _fields($tableName : Text)->$fields : Collection
	
	var $fieldName : Text
	var $equal : Boolean
	var $inquiry : Object
	var $ds : cs:C1710.DataStore
	var $field : cs:C1710.field
	var $str : cs:C1710.str
	
	$ds:=ds:C1482
	$str:=cs:C1710.str.new()
	
	$fields:=New collection:C1472
	
	For each ($fieldName; $ds[$tableName])
		
		$field:=$ds[$tableName][$fieldName]
		
		If ($fieldName=This:C1470.stampFieldName)\
			 || (Position:C15("."; $fieldName)>0)\
			 || Not:C34(Bool:C1537($field.exposed))
			
/*
Don't keep:
- not exposed field
- stamp field
- attribute name with dot
			
*/
			
			continue
			
		End if 
		
		// Get a field with the same name already exists
		$inquiry:=$fields.query("name = :1"; $fieldName).pop()
		
		//FIXME: TURNAROUND
		If ($inquiry#Null:C1517)
			
			$equal:=$str.setText($inquiry.name).equal($fieldName)
			
		Else 
			
			$equal:=False:C215
			
		End if 
		
		Case of 
				
				//…………………………………………………………………………………………………
			: ($equal)  //(($inquiry#Null) && $str.setText($inquiry.name).equal($fieldName))
				
				// NOT ALLOW DUPLICATE NAMES !
				This:C1470.warnings.push("Name conflict for the attribute \""+$fieldName+"\" of the dataclass \""+$tableName+"\"")
				
				//…………………………………………………………………………………………………
			: ($field.kind="storage")  // Storage attribute
				
				If (This:C1470.allowedTypes.indexOf($field.type)>=0)
					
					// Mark: #TEMPO
					$field.valueType:=$field.type
					$field.id:=$field.fieldNumber
					$field.type:=This:C1470.__fielddType($field.fieldType)
					
					$fields.push($field)
					
				End if 
				
				//…………………………………………………………………………………………………
			: ($field.kind="calculated")  // Calculated scalar attribute
				
				If (This:C1470.allowedTypes.indexOf($field.type)>=0)
					
					// Mark: #TEMPO
					$field.valueType:=$field.type
					$field.type:=-3
					
					$fields.push($field)
					
				End if 
				
				//…………………………………………………………………………………………………
			: ($field.kind="relatedEntity")  // N -> 1 relation attribute (reference to an entity)
				
				If ($ds[$field.relatedDataClass]#Null:C1517)
					
					$field.relatedTableNumber:=$ds[$field.relatedDataClass].getInfo().tableNumber
					$field.isToOne:=True:C214
					
					// Mark: #TEMPO
					$field.valueType:=$field.type
					$field.type:=-1
					
					$fields.push($field)
					
				End if 
				
				//…………………………………………………………………………………………………
			: ($field.kind="relatedEntities")  // 1 -> N relation attribute (reference to an entity selection)
				
				$field.relatedTableNumber:=$ds[$field.relatedDataClass].getInfo().tableNumber
				$field.isToMany:=True:C214
				
				// Mark: #TEMPO
				$field.valueType:=$field.type
				$field.type:=-2
				
				$fields.push($field)
				
				//…………………………………………………………………………………………………
			: (Not:C34(FEATURE.with("alias")))
				
				// <NOT YET AVAILABLE>
				
				//…………………………………………………………………………………………………
			: ($field.kind="alias")
				
				Case of 
						
						//______________________________________
					: (This:C1470.allowedTypes.indexOf($field.type)>=0)  // Scalar Attribute
						
						// Mark: #TEMPO
						$field.valueType:=$field.type
						$field.id:=$field.fieldNumber
						$field.type:=This:C1470.__fielddType($field.fieldType)
						
						$fields.push($field)
						
						//______________________________________
					: ($field.relatedDataClass#Null:C1517)  // Relation
						
						$field.relatedTableNumber:=$ds[$field.relatedDataClass].getInfo().tableNumber
						
						$field.isToMany:=($field.type="@Selection")
						$field.isToOne:=Not:C34($field.isToMany)
						
						// Mark: #TEMPO
						$field.valueType:=$field.type
						$field.type:=$field.isToMany ? -2 : -1
						
						$fields.push($field)
						
						//______________________________________
					Else 
						
						ASSERT:C1129(DATABASE.isComponent; "😰 I wonder why I'm here")
						
						//______________________________________
				End case 
				
				//…………………………………………………………………………………………………
			Else 
				
				ASSERT:C1129(DATABASE.isComponent; "😰 I wonder why I'm here")
				
				//…………………………………………………………………………………………………
		End case 
	End for each 
	
	//==================================================================
Function _relatedFields($field : cs:C1710.field; $relationName : Text; $recursive : Boolean)->$fields : Collection
	
	var $result : Object
	var $related; $relatedField : cs:C1710.field
	
	$fields:=New collection:C1472
	
	Case of 
			
			//___________________________________________
		: ($field.kind="storage")  // Storage attribute
			
			If (This:C1470.allowedTypes.indexOf($field.type)>=0)
				
				// MARK: #TEMPO
				$field.valueType:=$field.type
				$field.id:=$field.fieldNumber
				$field.type:=This:C1470.__fielddType($field.fieldType)
				
				$field.path:=New collection:C1472($relationName; $field.name).join(".")
				$field.relatedTableNumber:=$result.relatedTableNumber
				
				$fields.push($field)
				
			End if 
			
			//…………………………………………………………………………………………………
		: ($field.kind="calculated")  // Calculated scalar attribute
			
			If (This:C1470.allowedTypes.indexOf($field.type)>=0)
				
				// MARK: #TEMPO
				$field.valueType:=$field.type
				$field.type:=-3
				
				$field.path:=New collection:C1472($relationName; $field.name).join(".")
				$field.relatedTableNumber:=$result.relatedTableNumber
				
				$fields.push($field)
				
			End if 
			
			//…………………………………………………………………………………………………
		: ($field.kind="alias")  // 
			
			// TODO: manage alias
			
			//___________________________________________
		: ($field.kind="relatedEntity")  // N -> 1 relation attribute (reference to an entity)
			
			If ($recursive)
				
				For each ($relatedField; This:C1470.catalog.query("name = :1"; $field.relatedDataClass).pop().field)
					
					Case of 
							
							//______________________________________________________
						: ($relatedField.kind="storage")  // Storage attribute
							
							If (This:C1470.allowedTypes.indexOf($relatedField.valueType)>=0)
								
								$related:=OB Copy:C1225($relatedField)
								$related.path:=New collection:C1472($field.name; $related.name).join(".")
								$related.tableNumber:=This:C1470.tableNumber($field.relatedDataClass)
								
								$fields.push($related)
								
							End if 
							
							//______________________________________________________
						: ($relatedField.kind="calculated")  // Calculated scalar attribute
							
							If (This:C1470.allowedTypes.indexOf($relatedField.valueType)>=0)
								
								$related:=OB Copy:C1225($relatedField)
								$related.path:=New collection:C1472($field.name; $related.name).join(".")
								$related.tableNumber:=This:C1470.tableNumber($field.relatedDataClass)
								
								$fields.push($related)
								
							End if 
							
							//______________________________________________________
						: ($relatedField.kind="relatedEntity")
							
							// NOT MANAGED
							
							//______________________________________________________
						: ($relatedField.kind="relatedEntities")
							
							// NOT MANAGED
							
							//…………………………………………………………………………………………………
						: (Not:C34(FEATURE.with("alias")))
							
							// <NOT YET AVAILABLE>
							
							//…………………………………………………………………………………………………
						: ($relatedField.kind="alias")  // Alias
							
							$related:=OB Copy:C1225($relatedField)
							$related.path:=New collection:C1472($field.name; $related.name).join(".")
							$related.tableNumber:=This:C1470.tableNumber($field.relatedDataClass)
							
							$fields.push($related)
							
							//______________________________________________________
						Else 
							
							ASSERT:C1129(DATABASE.isComponent; "😰 I wonder why I'm here")
							
							//______________________________________________________
					End case 
				End for each 
			End if 
			
			//…………………………………………………………………………………………………
		: ($field.kind="relatedEntities")  // 1 -> N relation
			
			If ($recursive)
				
				$related:=OB Copy:C1225($relatedField)
				$related.path:=$related.name
				$related.tableNumber:=$result.relatedTableNumber
				
				$fields.push($related)
				
			End if 
			
			//…………………………………………………………………………………………………
		: (Not:C34(FEATURE.with("alias")))
			
			// <NOT YET AVAILABLE>
			
			//______________________________________________________
		: ($relatedField.kind="alias")  // Alias
			
			$related:=OB Copy:C1225($relatedField)
			$related.path:=$field.name+"."+$related.name
			$related.tableNumber:=$result.relatedTableNumber
			
			$fields.push($related)
			
			//…………………………………………………………………………………………………
		Else 
			
			ASSERT:C1129(DATABASE.isComponent; "😰 I wonder why I'm here")
			
			//___________________________________________
	End case 
	
	//==================================================================
	// Returns True if a field could be published
Function _allowPublication($field : cs:C1710.field)->$allow : Boolean
	
	If ($field.name#This:C1470.stampFieldName)
		
		$allow:=(This:C1470.allowedTypes.indexOf($field.valueType)>=0) || (This:C1470.allowedTypes.indexOf($field.type)>=0)
		
	End if 
	
	//==================================================================
Function __fielddType($old : Integer)->$type : Integer  // #TEMPORARY REMAPPING FOR THE FIELD TYPE
	
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
	
	$type:=$c[$old]
	