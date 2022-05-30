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
	
	This:C1470.allowedTypes:=New collection:C1472("string"; "bool"; "date"; "number"; "image"; "object")
	
	If (SHARED=Null:C1517)  // FIXME #105596
		
		var Logger : cs:C1710.logger
		Logger:=Logger || cs:C1710.logger.new()
		Logger.warning("SHARED=Null")
		Logger.trace()
		
		COMPONENT_INIT
		
	End if 
	
	This:C1470.sorted:=(Count parameters:C259>=1) ? $sorted : False:C215
	
	This:C1470.update()
	
	//==================================================================
	/// Update the datastore & the catalog
Function update()
	
	This:C1470.datastore:=This:C1470.exposedDatastore()
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
Function exposedDatastore() : Object
	
	If (Feature.with("modernStructure"))
		
		var $key : Text
		var $datastore; $o : Object
		var $table : cs:C1710.table
		var $ds : cs:C1710.DataStore
		
		$datastore:=New object:C1471
		$ds:=ds:C1482
		
		For each ($key; $ds)
			
			$o:=$ds[$key].getInfo()
			
			If (Not:C34($o.exposed))\
				 || ($key=This:C1470.deletedRecordsTableName)
				
				continue
				
			End if 
			
			$table:=New object:C1471
			$table[""]:=$o
			
			For each ($o; OB Entries:C1720($ds[$key]))
				
				If (Not:C34(Bool:C1537($o.value.exposed)))\
					 || ($o.key=This:C1470.stampFieldName)\
					 || (Not:C34(This:C1470._managedType($o.value.type)) & ($o.value.relatedDataClass=Null:C1517))
					
					continue
					
				End if 
				
				$table[$o.key]:=$o.value
				
			End for each 
			
			$datastore[$key]:=$table
			
		End for each 
		
		return $datastore
		
	Else 
		
		return _4D_Build Exposed Datastore:C1598
		
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
Function tableInfos($query) : Object
	
	var $table : Object
	
	$table:=This:C1470.table($query)
	
	If (This:C1470.success)
		
		return ds:C1482[$table.name].getInfo()
		
	End if 
	
	//==================================================================
	/// Returns the table number from its name or number
Function tableNumber($query) : Integer
	
	var $table : Object
	
	$table:=This:C1470.table($query)
	
	If (This:C1470.success)
		
		return $table.tableNumber
		
	End if 
	
	//==================================================================
	/// Returns the table name from its name or number
Function tableName($query) : Text
	
	var $table : Object
	
	$table:=This:C1470.table($query)
	
	If (This:C1470.success)
		
		return $table.name
		
	End if 
	
	//==================================================================
	/// Returns a field definition object
	// FIXME: ? MUST NOT BE INTO THIS CLASSE -> PROJECT
	//==================================================================
Function fieldDefinition($table; $fieldPath : Text)->$field : Object
	
	var $tableNumber : Integer
	var $tableCatalog : Object
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
							$field.name:=Choose:C955($field.relatedDataClass=Null:C1517; Field name:C257($tableNumber; $field.fieldNumber); $c[0])
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
Function isStorage($field : Object) : Boolean
	
	If (($field#Null:C1517)\
		 && (String:C10($field.kind)="storage")\
		 && ($field.name#This:C1470.stampFieldName))  // Don't allow stamp field
		
		return This:C1470._allowPublication($field)
		
	End if 
	
	//==================================================================
Function isRelatedEntity($field : Object) : Boolean
	
	return ($field#Null:C1517) && ($field.kind="relatedEntity")
	
	//==================================================================
Function isRelatedEntities($field : Object) : Boolean
	
	return ($field#Null:C1517) && ($field.kind="relatedEntities")
	
	//==================================================================
Function isComputedAttribute($field : Object) : Boolean
	
	return ($field#Null:C1517) && (String:C10($field.kind)="calculated")
	
	//==================================================================
Function isAlias($field : Object) : Boolean
	
	return ($field#Null:C1517) && (String:C10($field.kind)="alias")
	
	//==================================================================
	// Return related entity catalog
Function relatedCatalog($tableName : Text; $relationName : Text; $recursive : Boolean)->$result : Object
	
	var $fieldName : Text
	var $ds : cs:C1710.DataStore
	var $field; $related; $relatedAttribute; $relatedField : cs:C1710.field
	var $relatedDataClass : cs:C1710.table
	
	$result:=New object:C1471(\
		"success"; False:C215)
	
	$ds:=ds:C1482
	$field:=$ds[$tableName][$relationName]
	
	If ($field.kind="relatedEntity")\
		 || (Feature.with("alias") && ($field.kind="alias") && ($field.fieldType=Is object:K8:27) && ($field.relatedDataClass#Null:C1517))
		
		$result:=New object:C1471(\
			"success"; True:C214; \
			"relatedEntity"; $field.name; \
			"relatedTableNumber"; $ds[$field.relatedDataClass].getInfo().tableNumber; \
			"relatedDataClass"; $field.relatedDataClass; \
			"inverseName"; $field.inverseName; \
			"fields"; New collection:C1472)
		
		If ($field.kind="alias")
			
			$result.alias:=This:C1470.aliasTarget($tableName; $field)
			$field:=$result.alias.target
			
		End if 
		
		$relatedDataClass:=$ds[$field.relatedDataClass]
		
		For each ($fieldName; $relatedDataClass)
			
			$relatedAttribute:=$relatedDataClass[$fieldName]
			
			If (Not:C34(Bool:C1537($relatedAttribute.exposed)))\
				 || ($relatedAttribute.name=This:C1470.stampFieldName)
				
				continue
				
			End if 
			
			Case of 
					
					//______________________________________________________
				: ($relatedAttribute.kind="storage")
					
					If (This:C1470._managedType($relatedAttribute.type))
						
						// MARK: TEMPO
						$relatedAttribute.valueType:=$relatedAttribute.type
						
						$relatedAttribute.path:=$relatedAttribute.name
						$relatedAttribute.type:=This:C1470.__fielddType($relatedAttribute.fieldType)
						$relatedAttribute.relatedTableNumber:=$result.relatedTableNumber
						
						$relatedAttribute._order:=""
						$result.fields.push($relatedAttribute)
						
					End if 
					
					//______________________________________________________
				: ($relatedAttribute.kind="relatedEntity")
					
					If ($recursive || ($relatedAttribute.relatedDataClass#$tableName))
						
						$relatedAttribute.relatedTableNumber:=This:C1470.tableNumber($relatedAttribute.relatedDataClass)
						
						For each ($relatedField; This:C1470.catalog.query("name = :1"; $relatedAttribute.relatedDataClass).pop().fields)
							
							If ($relatedField.kind="relatedEntity")\
								 || ($relatedField.kind="relatedEntities")
								
								continue  //Unmanaged at the 2nd level
								
							End if 
							
							Case of 
									
									//…………………………………………………………………………………………………
								: ($relatedField.kind="storage")
									
									If (This:C1470._managedType($relatedField.valueType))
										
										$related:=This:C1470.fieldDefinition($relatedAttribute.relatedTableNumber; $relatedField.name)
										$related.path:=New collection:C1472($relatedAttribute.name; $related.name).join(".")
										$related.tableNumber:=This:C1470.tableNumber($field.relatedDataClass)
										
										$related._order:=$relatedAttribute.name
										$result.fields.push($related)
										
									End if 
									
									//…………………………………………………………………………………………………
								: ($relatedField.kind="calculated")
									
									If (This:C1470._managedType($relatedField.valueType))
										
										$related:=OB Copy:C1225($relatedField)
										$related.path:=New collection:C1472($relatedAttribute.name; $related.name).join(".")
										$related.tableNumber:=$result.relatedTableNumber
										
										// MARK: TEMPO
										$related.valueType:=$relatedAttribute.type
										$related.type:=This:C1470.__fielddType($relatedAttribute.fieldType)
										
										$related._order:=$related.path
										$result.fields.push($related)
										
									End if 
									
									//…………………………………………………………………………………………………
								: ($relatedField.kind="alias")
									
									If (Feature.disabled("alias"))
										
										continue
										
									End if 
									
									// Ignore N -> 1 relations
									If ($relatedField.relatedDataClass=Null:C1517)\
										 || (Not:C34(Bool:C1537($relatedField.isToOne)))
										
										$related:=OB Copy:C1225($relatedField)
										$related.label:=New collection:C1472($relatedAttribute.name; $related.name).join(".")
										$related.tableNumber:=This:C1470.tableNumber($field.relatedDataClass)
										$related.fieldType:=($related.fieldType=Is object:K8:27) ? 8858 : $related.fieldType
										$related._order:=$related.label
										$result.fields.push($related)
										
									End if 
									
									//…………………………………………………………………………………………………
								Else 
									
									oops
									
									//…………………………………………………………………………………………………
							End case 
						End for each 
					End if 
					
					//______________________________________________________
				: ($relatedAttribute.kind="relatedEntities")
					
					If ($recursive || ($relatedAttribute.relatedDataClass#$tableName))
						
						$related:=New object:C1471(\
							"kind"; "relatedEntities"; \
							"name"; $relatedAttribute.name; \
							"path"; $relatedAttribute.name; \
							"relatedDataClass"; $relatedAttribute.relatedDataClass; \
							"relatedTableNumber"; This:C1470.tableNumber($relatedAttribute.relatedDataClass); \
							"inverseName"; $relatedAttribute.inverseName)
						
						// MARK: TEMPO
						$related.fieldType:=8859
						$related.isToMany:=True:C214
						
						$related._order:=""
						$result.fields.push($related)
						
					End if 
					
					//______________________________________________________
				: ($relatedAttribute.kind="calculated")
					
					If (This:C1470._managedType($relatedAttribute.type))
						
						$related:=OB Copy:C1225($relatedAttribute)
						
						// MARK: #TEMPO
						$related.valueType:=$relatedAttribute.type
						$related.type:=This:C1470.__fielddType($relatedAttribute.fieldType)
						
						$related.path:=$related.name
						$related.relatedTableNumber:=$result.relatedTableNumber
						
						$related._order:=""
						$result.fields.push($related)
						
					End if 
					
					//______________________________________________________
				: ($relatedAttribute.kind="alias")
					
					If (Feature.disabled("alias"))
						
						continue
						
					End if 
					
					If (This:C1470._managedType($relatedAttribute.type))
						
						$related:=OB Copy:C1225($relatedAttribute)
						$related.label:=$related.name
						$related.type:=This:C1470.__fielddType($related.fieldType)
						$related.relatedTableNumber:=$result.relatedTableNumber
						
						// MARK: TEMPO
						$related.valueType:=$related.type
						
						$related._order:=""
						$result.fields.push($related)
						
					End if 
					
					//______________________________________________________
				Else 
					
					oops
					
					//______________________________________________________
			End case 
		End for each 
		
	Else 
		
		$result:=New object:C1471(\
			"success"; False:C215)
		
		This:C1470.errors.push("The attribute \""+$relationName+"\" of dataclass \""+$tableName+"\" does not refer to an entity")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the target and levels of an alias {"target": {},"levels":[]}
Function aliasTarget($table; $field; $recursive : Boolean)->$result : Object
	
	var $member : Text
	var $resolve; $target : Object
	var $levels : Collection
	var $ds : 4D:C1709.DataStoreImplementation
	var $previousDataClass; $sourceDataClass : 4D:C1709.DataClass
	
	If (Value type:C1509($field)=Is object:K8:27)\
		 && (String:C10($field.kind)="alias")\
		 && (Length:C16(String:C10($field.path))>0)
		
		$result:=New object:C1471
		$result.levels:=New collection:C1472
		
		$ds:=ds:C1482
		$levels:=Split string:C1554($field.path; ".")
		$sourceDataClass:=(Value type:C1509($table)=Is text:K8:3) ? $ds[$table] : $table
		
		Repeat 
			
			$member:=$levels.shift()
			$target:=$sourceDataClass[$member]
			
			$result.levels.push(New object:C1471(\
				"path"; $member; \
				"dataClass"; $sourceDataClass.getInfo().name))
			
			$previousDataClass:=$sourceDataClass
			
			If ($target.relatedDataClass#Null:C1517)  // Is relatedDataClass filled for alias? like destination field
				
				$sourceDataClass:=$ds[$target.relatedDataClass]
				
			End if 
		Until ($levels.length=0)
		
		$result.target:=$target
		
		If ($recursive)
			
			If (String:C10($result.target.kind)="alias")  // Maybe an alias too
				
				$resolve:=This:C1470.aliasTarget($previousDataClass; $result.target; True:C214)
				
				$result.levels.combine($resolve.levels)
				$result.target:=$resolve.target
				
			End if 
		End if 
		
	Else 
		
		This:C1470.errors.push("The attribute does not refer to an alias")
		
	End if 
	
	//==================================================================
	// FIXME: Move to project class
	// Adding a field to a table data model
Function addField($table : Object; $field : cs:C1710.field)
	
	var $fieldID : Text
	var $o; $relatedCatalog; $relatedField : Object
	var $path : Collection
	
	If (Structure file:C489=Structure file:C489(*))
		
		ON ERR CALL:C155("")
		
	End if 
	
	Case of 
			
			//………………………………………………………………………………………………………
		: ($field.kind="storage")
			
			$table[String:C10($field.id)]:=This:C1470._fieldModel($field)
			
			//………………………………………………………………………………………………………
		: ($field.kind="calculated")\
			 || ($field.kind="relatedEntities")\
			 || (Feature.with("alias") && ($field.kind="alias"))
			
			$table[$field.name]:=This:C1470._fieldModel($field)
			
			//………………………………………………………………………………………………………
		: ($field.kind="relatedEntity")
			
			// Add all related fields
			$relatedCatalog:=This:C1470.relatedCatalog($table[""].name; $field.name; True:C214)
			
			$o:=This:C1470._fieldModel($field; $relatedCatalog)
			
			$table[$field.name]:=$o
			
			For each ($relatedField; $relatedCatalog.fields)
				
				$fieldID:=String:C10($relatedField.fieldNumber)
				
				$path:=Split string:C1554(($relatedField.label#Null:C1517 ? $relatedField.label : $relatedField.path); ".")
				
				// Create the field, if any
				If ($path.length>1) & ($relatedField.kind#"alias")
					
					If ($o[$path[0]]=Null:C1517)
						
						$o[$path[0]]:=New object:C1471(\
							"relatedDataClass"; $relatedField.tableName; \
							"relatedTableNumber"; $relatedField.tableNumber; \
							"inverseName"; This:C1470.table($table[""].name).field.query("name=:1"; $field.name).pop().inverseName)
						
					End if 
					
					Case of 
							
							//______________________________________________________
						: ($relatedField.kind="storage") && ($o[$path[0]][$fieldID]=Null:C1517)
							
							$o[$path[0]][$fieldID]:=This:C1470._fieldModel($relatedField)
							$o[$path[0]][$fieldID].path:=$relatedField.path
							
							//______________________________________________________
						: ($relatedField.kind="calculated") && ($o[$path[0]][$relatedField.name]=Null:C1517)
							
							$o[$path[0]][$relatedField.name]:=This:C1470._fieldModel($relatedField)
							$o[$path[0]][$relatedField.name].path:=$relatedField.path
							
							//______________________________________________________
						: ($relatedField.kind="relatedEntities") && ($o[$path[0]][$relatedField.name]=Null:C1517)
							
							$o[$path[0]][$relatedField.name]:=This:C1470._fieldModel($relatedField)
							$o[$path[0]][$relatedField.name].path:=New collection:C1472($field.name; $relatedField.path).join(".")
							
							//______________________________________________________
						Else 
							
							//oops
							
							//______________________________________________________
					End case 
					
				Else 
					
					Case of 
							
							//______________________________________________________
						: ($relatedField.kind="storage") && ($o[$fieldID]=Null:C1517)
							
							$o[$fieldID]:=This:C1470._fieldModel($relatedField)
							$o[$fieldID].path:=$relatedField.path
							
							//______________________________________________________
						: ($relatedField.kind="calculated") && ($o[$relatedField.name]=Null:C1517)
							
							$o[$relatedField.name]:=This:C1470._fieldModel($relatedField)
							$o[$relatedField.name].path:=$relatedField.path
							
							//______________________________________________________
						: (Feature.with("alias")) && (($relatedField.kind="alias"))
							
							If ($path.length>1)
								
								If ($o[$path[0]]=Null:C1517)
									
									$o[$path[0]]:=New object:C1471
									$o[$path[0]].kind:=$field.kind
									$o[$path[0]].relatedDataClass:=$field.relatedDataClass
									$o[$path[0]].inverseName:=$field.inverseName
									$o[$path[0]].relatedTableNumber:=$field.relatedTableNumber
									
								End if 
								
								$o[$path[0]][$relatedField.name]:=This:C1470._fieldModel($relatedField)
								$o[$path[0]][$relatedField.name].path:=$relatedField.path
								
							Else 
								
								$o[$relatedField.name]:=This:C1470._fieldModel($relatedField)
								$o[$relatedField.name].path:=$relatedField.path
								
							End if 
							
							//______________________________________________________
						: ($relatedField.kind="relatedEntities") && ($o[$relatedField.name]=Null:C1517)
							
							$o[$relatedField.name]:=This:C1470._fieldModel($relatedField)
							$o[$relatedField.name].path:=New collection:C1472($field.name; $relatedField.path).join(".")
							
							//______________________________________________________
						Else 
							
							//oops
							
							//______________________________________________________
					End case 
				End if 
			End for each 
			
			//………………………………………………………………………………………………………
		Else 
			
			oops
			
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
	// === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if a field's type is allowed
Function _managedType($type : Text) : Boolean
	
	return (This:C1470.allowedTypes.indexOf($type)>=0)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function _fieldModel($field : cs:C1710.field; $relatedCatalog : Object)->$fieldModel : Object
	
	var $str : cs:C1710.str
	$str:=cs:C1710.str.new()
	
	Case of 
			
			//………………………………………………………………………………………………………
		: ($field.kind="storage")  // Attribute
			
			$fieldModel:=New object:C1471(\
				"name"; $field.name; \
				"kind"; $field.kind; \
				"fieldType"; $field.fieldType; \
				"label"; PROJECT.label($field.name); \
				"shortLabel"; PROJECT.label($field.name); \
				"valueType"; $field.valueType)
			
			// mark:#TEMPO
			$fieldModel.type:=$field.type
			
			//………………………………………………………………………………………………………
		: (Feature.with("alias") && ($field.kind="alias"))  // Alias
			
			$fieldModel:=New object:C1471(\
				"kind"; $field.kind; \
				"fieldType"; $field.fieldType; \
				"path"; $field.path)
			
			Case of 
					
					//______________________________________________________
				: ($field.fieldType=Is collection:K8:32)  // Selection
					
					$fieldModel.label:=PROJECT.label($str.localize("listOf"; $field.name))
					$fieldModel.shortLabel:=PROJECT.label($field.name)
					
					//______________________________________________________
				Else 
					
					$fieldModel.label:=PROJECT.label($field.name)
					$fieldModel.shortLabel:=PROJECT.label($field.name)
					
					//______________________________________________________
			End case 
			
			$fieldModel.fieldType:=$field.fieldType
			
			//………………………………………………………………………………………………………
		: ($field.kind="calculated")  // Computed attribute
			
			$fieldModel:=New object:C1471(\
				"kind"; $field.kind; \
				"name"; $field.name; \
				"label"; PROJECT.label($field.name); \
				"shortLabel"; PROJECT.label($field.name); \
				"fieldType"; $field.fieldType; \
				"valueType"; $field.valueType)
			
			// mark:#TEMPO
			// TODO:Remove computed
			$fieldModel.computed:=True:C214
			$fieldModel.type:=$field.type
			
			//………………………………………………………………………………………………………
		: ($field.kind="relatedEntities")  // 1 -> N relation
			
			$fieldModel:=New object:C1471(\
				"kind"; $field.kind; \
				"label"; PROJECT.label($str.localize("listOf"; $field.name)); \
				"shortLabel"; PROJECT.label($field.name); \
				"relatedEntities"; $field.relatedDataClass; \
				"inverseName"; $field.inverseName; \
				"relatedDataClass"; $field.relatedDataClass)
			
			// mark:#TEMPO
			$fieldModel.relatedTableNumber:=$field.relatedTableNumber
			$fieldModel.isToMany:=True:C214
			
			//………………………………………………………………………………………………………
		: ($field.kind="relatedEntity")  // N -> 1 relation
			
			$fieldModel:=New object:C1471(\
				"kind"; $field.kind; \
				"label"; PROJECT.label($field.name); \
				"shortLabel"; PROJECT.shortLabel($field.name); \
				"relatedDataClass"; $relatedCatalog.relatedDataClass; \
				"inverseName"; $relatedCatalog.inverseName)
			
			// mark:#TEMPO
			$fieldModel.relatedTableNumber:=$relatedCatalog.relatedTableNumber
			
			//…………………………………………………………………………………………………
		: (Feature.disabled("alias"))
			
			// <NOT YET AVAILABLE>
			
			//………………………………………………………………………………………………………
		Else 
			
			oops
			
			//………………………………………………………………………………………………………
	End case 
	
	//==================================================================
	// Returns the collection of exposed fields of a table
Function _fields($tableName : Text)->$fields : Collection
	
	var $fieldName : Text
	var $inquiry : Object
	var $ds : cs:C1710.DataStore
	var $field : cs:C1710.field
	
	$ds:=ds:C1482
	
	$fields:=New collection:C1472
	
	For each ($fieldName; $ds[$tableName])
		
		$field:=$ds[$tableName][$fieldName]
		
		If (Not:C34(Bool:C1537($field.exposed))\
			 || ($fieldName=This:C1470.stampFieldName))\
			 || (Position:C15("."; $fieldName)>0)
			
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
		
		If ($inquiry#Null:C1517)\
			 && (Length:C16($inquiry.name)=Length:C16($fieldName))\
			 && ((Length:C16($inquiry.name)=0) | (Position:C15($inquiry.name; $fieldName; 1; *)=1))
			
/*
Do not allow duplicate attribute names.
*/
			
			This:C1470.warnings.push("Name conflict for the attribute \""+$fieldName+"\" of the dataclass \""+$tableName+"\"")
			
			continue
			
		End if 
		
		Case of 
				
				//…………………………………………………………………………………………………
			: ($field.kind="storage")  // Storage attribute
				
				If (This:C1470._managedType($field.type))
					
					// Mark: #TEMPO
					$field.valueType:=$field.type
					$field.id:=$field.fieldNumber
					$field.type:=This:C1470.__fielddType($field.fieldType)
					
					$fields.push($field)
					
				End if 
				
				//…………………………………………………………………………………………………
			: ($field.kind="calculated")  // Calculated scalar attribute
				
				If (This:C1470._managedType($field.type))
					
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
			: (Feature.disabled("alias"))
				
				// <NOT YET AVAILABLE>
				
				//…………………………………………………………………………………………………
			: ($field.kind="alias")
				
				Case of 
						
						//______________________________________
					: ($field.fieldType=Is undefined:K8:13)
						
						// INVALID ALIAS
						
						//______________________________________
					: ($field.relatedDataClass#Null:C1517)  // Non scalar Attribute
						
						If (Feature.with("nonScalarAlias"))
							
							$field.relatedTableNumber:=$ds[$field.relatedDataClass].getInfo().tableNumber
							
							$field.isToMany:=($field.fieldType=Is collection:K8:32)  // -> relatedEntities
							$field.isToOne:=($field.fieldType=Is object:K8:27)  // -> relatedEntity
							
							// Mark: #TEMPO
							$field.valueType:=$field.type
							$field.type:=$field.isToMany ? -2 : -1
							
							$fields.push($field)
							
						End if 
						
						//______________________________________
					Else   // Scalar Attribute
						
						If (This:C1470._managedType($field.type))
							
							// Mark: #TEMPO
							$field.valueType:=$field.type
							$field.id:=$field.fieldNumber
							$field.type:=This:C1470.__fielddType($field.fieldType)
							
							$fields.push($field)
							
						End if 
						
						//______________________________________
				End case 
				
				//…………………………………………………………………………………………………
			Else 
				
				oops
				
				//…………………………………………………………………………………………………
		End case 
	End for each 
	
	//==================================================================
	//MARK:Seems unused
Function _relatedFields($field : cs:C1710.field; $relationName : Text; $recursive : Boolean)->$fields : Collection
	
	var $result : Object
	var $related; $relatedField : cs:C1710.field
	
	$fields:=New collection:C1472
	
	Case of 
			
			//___________________________________________
		: ($field.kind="storage")  // Storage attribute
			
			If (This:C1470._managedType($field.type))
				
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
			
			If (This:C1470._managedType($field.type))
				
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
					
					If (Not:C34(Bool:C1537($relatedField.exposed)))\
						 || ($relatedField.kind="relatedEntity")\
						 || ($relatedField.kind="relatedEntities")\
						 || (($relatedField.kind="alias") & Feature.disabled("alias"))
						
						continue
						
					End if 
					
					$related:=OB Copy:C1225($relatedField)
					$related.tableNumber:=This:C1470.tableNumber($related.relatedDataClass)
					
					Case of 
							
							//______________________________________________________
						: ($relatedField.kind="storage")  // Storage attribute
							
							If (This:C1470._managedType($relatedField.valueType))
								
								$related.path:=New collection:C1472($field.name; $related.name).join(".")
								
								$fields.push($related)
								
							End if 
							
							//______________________________________________________
						: ($relatedField.kind="calculated")  // Calculated scalar attribute
							
							If (This:C1470._managedType($relatedField.valueType))
								
								$related.path:=New collection:C1472($field.name; $related.name).join(".")
								
								$fields.push($related)
								
							End if 
							
							//…………………………………………………………………………………………………
						: ($relatedField.kind="alias")  // Alias
							
							$fields.push($related)
							
							//______________________________________________________
						Else 
							
							oops
							
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
		: (Feature.disabled("alias"))
			
			// <NOT YET AVAILABLE>
			
			//______________________________________________________
		: ($relatedField.kind="alias")  // Alias
			
			$related:=OB Copy:C1225($relatedField)
			$related.path:=$field.name+"."+$related.name
			$related.tableNumber:=$result.relatedTableNumber
			
			$fields.push($related)
			
			//…………………………………………………………………………………………………
		Else 
			
			oops
			
			//___________________________________________
	End case 
	
	//==================================================================
	// Returns True if a field could be published
Function _allowPublication($field : cs:C1710.field) : Boolean
	
	If ($field.name#This:C1470.stampFieldName)
		
		return ((This:C1470._managedType($field.valueType)) || (This:C1470._managedType($field.type)))
		
	End if 
	
	//==================================================================
Function __fielddType($old : Integer) : Integer  // #TEMPORARY REMAPPING FOR THE FIELD TYPE
	
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
	
	return $c[$old]
	