Class constructor
	
	This:C1470.stampFieldName:="__GlobalStamp"
	This:C1470.deletedRecordsTableName:="__DeletedRecords"
	
	This:C1470.warnings:=New collection:C1472
	This:C1470.errors:=New collection:C1472
	
	This:C1470.success:=True:C214
	
	This:C1470.datastore:=This:C1470.exposedDatastore()
	This:C1470.catalog:=This:C1470.exposedCatalog()
	
	//==================================================================
Function exposedDatastore
	var $0 : Object
	
	$0:=_4D_Build Exposed Datastore:C1598
	
	//==================================================================
Function exposedCatalog
/*
-------------------------------------------------------------------------------------------
	
If 'name' or 'tableNumber is not null, the result is limited to the corresponding table
	
-------------------------------------------------------------------------------------------
	
Build Exposed Datastore:
• Only references tables with a single primary key. Tables without a primary key or with composite primary keys are not referenced.
• Only references tables & fields exposed with 4D Mobile services.
• BLOB type attributes are not managed in the datastore.
	
-------------------------------------------------------------------------------------------
! A relation N -> 1 is not referenced if the field isn't exposed with 4D Mobile services !
-------------------------------------------------------------------------------------------
*/
	var $0 : Collection
	var $1 : Variant  // Table name or table number
	var $2 : Boolean  // Sorted
	
	var $fieldName; $tableName : Text
	var $found; $oneTable : Boolean
	var $l : Integer
	var $field; $table : Object
	
	This:C1470.success:=(This:C1470.datastore#Null:C1517)
	
	If (This:C1470.success)
		
		$0:=New collection:C1472
		
		$oneTable:=(Count parameters:C259>=1)
		
		For each ($tableName; This:C1470.datastore) Until ($found)
			
			$table:=This:C1470.datastore[$tableName].getInfo()
			
			If ($tableName#This:C1470.deletedRecordsTableName)  // DON'T DISPLAY DELETED RECORDS TABLE
				
				If ($oneTable)
					
					Case of 
							
							//…………………………………………………………………………………………………
						: (Value type:C1509($1)=Is text:K8:3)
							
							$found:=($tableName=$1)
							
							//…………………………………………………………………………………………………
						: (Value type:C1509($1)=Is longint:K8:6)
							
							$found:=($table.tableNumber=$1)
							
							//…………………………………………………………………………………………………
					End case 
				End if 
				
				If ($oneTable)
					
					This:C1470.success:=$found
					
				End if 
				
				If (This:C1470.success)
					
					If (Not:C34($oneTable)) | $found
						
						$0.push($table)
						
						$table.field:=New collection:C1472
						
						For each ($fieldName; This:C1470.datastore[$tableName])
							
							If ($fieldName#This:C1470.stampFieldName)  // DON'T DISPLAY STAMP FIELD
								
								$field:=This:C1470.datastore[$tableName][$fieldName]
								
								$l:=$table.field.extract("name").indexOf($fieldName)
								
								If ($l>=0)
									
									If (Not:C34(str_equal($fieldName; $table.field.extract("name")[$l])))
										
										$l:=-1
										
									End if 
								End if 
								
								Case of 
										
										//…………………………………………………………………………………………………
									: ($l#-1)
										
										// NOT ALLOW DUPLICATE NAMES !
										This:C1470.warnings.push("Name conflict for \""+$fieldName+"\"")
										
										//…………………………………………………………………………………………………
									: (Position:C15("."; $fieldName)>0)
										
										// NOT ALLOW FIELD OR RELATION NAME WITH DOT !
										This:C1470.warnings.push("Invalid field name \""+$fieldName+"\"")
										
										//…………………………………………………………………………………………………
									: (This:C1470.isStorage($field))
										
										// Storage (or scalar) attribute, i.e. attribute storing a value, not a reference to another attribute
										
										If ($field.fieldType#Is object:K8:27)\
											 & ($field.fieldType#Is BLOB:K8:12)\
											 & ($field.fieldType#Is subtable:K8:11)  // Exclude object and blob fields [AND SUBTABLE]
											
											// #TEMPO [
											$field.id:=$field.fieldNumber
											$field.valueType:=$field.type
											$field.type:=This:C1470.__fielddType($field.fieldType)
											
											// ]
											
											$table.field.push($field)
											
										End if 
										
										//…………………………………………………………………………………………………
									: (This:C1470.isRelatedEntity($field))
										
										// N -> 1 relation attribute (reference to an entity)
										
										If (This:C1470.datastore[$field.relatedDataClass]#Null:C1517)
											
											$table.field.push(New object:C1471(\
												"name"; $fieldName; \
												"inverseName"; $field.inverseName; \
												"type"; -1; \
												"relatedDataClass"; $field.relatedDataClass; \
												"relatedTableNumber"; This:C1470.datastore[$field.relatedDataClass].getInfo().tableNumber))
											
										End if 
										
										//…………………………………………………………………………………………………
									: (This:C1470.isRelatedEntities($field))
										
										// 1 -> N relation attribute (reference to an entity selection)
										
										$table.field.push(New object:C1471(\
											"name"; $fieldName; \
											"inverseName"; $field.inverseName; \
											"type"; -2; \
											"relatedDataClass"; $field.relatedDataClass; \
											"relatedTableNumber"; This:C1470.datastore[$field.relatedDataClass].getInfo().tableNumber))
										
										//…………………………………………………………………………………………………
								End case 
							End if 
						End for each 
						
						If (Count parameters:C259>=2)
							
							If ($2)
								
								$table.field:=$table.field.orderBy("name asc")
								
							End if 
						End if 
					End if 
				End if 
			End if 
		End for each 
		
		If (This:C1470.success)
			
			If (Count parameters:C259>=2)
				
				If ($2)
					
					$0:=$0.orderBy("name asc")
					
				End if 
			End if 
			
		Else 
			
			If ($oneTable)
				
				This:C1470.errors.push("Table not found: "+String:C10($1))
				
			End if 
		End if 
	End if 
	
	//==================================================================
Function isStorage
	var $0 : Boolean
	var $1 : Object
	
	If (String:C10($1.kind)="storage")
		
		// Don't display stamp field
		If ($1.name#This:C1470.stampFieldName)
			
			// Exclude object and blob fields [AND SUBTABLE]
			If ($1.fieldType#Is object:K8:27)\
				 & ($1.fieldType#Is BLOB:K8:12)\
				 & ($1.fieldType#Is subtable:K8:11)
				
				$0:=True:C214
				
			End if 
		End if 
	End if 
	
	//==================================================================
Function isRelatedEntity
	var $0 : Boolean
	var $1 : Object
	
	$0:=($1.kind="relatedEntity")
	
	//==================================================================
Function isRelatedEntities
	var $0 : Boolean
	var $1 : Object
	
	$0:=($1.kind="relatedEntities")
	
	//==================================================================
Function fieldDefinition
	var $0 : Object
	var $1 : Variant  // Table name/number
	var $2 : Text  // Field path
	
	var $field; $table : Object
	var $c; $fields : Collection
	var $tableNumber : Integer
	
	If (Value type:C1509($1)=Is longint:K8:6)\
		 | (Value type:C1509($1)=Is real:K8:4)
		
		$tableNumber:=$1
		
	Else 
		
		$tableNumber:=This:C1470.tableNumber(String:C10($1))
		
	End if 
	
	$0:=New object:C1471
	
	$c:=Split string:C1554($2; ".")
	
	If ($c.length=1)
		
		$table:=This:C1470.catalog.query("tableNumber=:1"; $tableNumber).pop()
		This:C1470.success:=($table#Null:C1517)
		
		If (This:C1470.success)
			
			$fields:=$table.field
			$field:=$fields.query("name=:1"; $c[0]).pop()
			This:C1470.success:=($field#Null:C1517)
			
			If (This:C1470.success)
				
				$0.path:=$2
				$0.tableNumber:=$tableNumber
				$0.tableName:=Table name:C256($tableNumber)
				
				If ($field.type=-2)  // 1 to N relation
					
					$0.fieldType:=8859
					$0.type:=-2
					$0.relatedDataClass:=$field.relatedDataClass
					$0.relatedTableNumber:=$field.relatedTableNumber
					
				Else 
					
					$0.fieldNumber:=$field.fieldNumber
					$0.fieldType:=$field.fieldType
					$0.name:=Field name:C257($tableNumber; $field.fieldNumber)
					$0.type:=This:C1470.__fielddType($field.fieldType)
					
				End if 
				
			Else 
				
				This:C1470.errors.push("Field not found")
				
			End if 
			
		Else 
			
			This:C1470.errors.push("Table not found #"+String:C10($tableNumber))
			
		End if 
		
	Else 
		
		$table:=This:C1470.catalog.query("tableNumber=:1"; $tableNumber).pop()
		This:C1470.success:=($table#Null:C1517)
		
		If (This:C1470.success)
			
			$field:=$table.field.query("name=:1"; $c[0]).pop()
			This:C1470.success:=($field#Null:C1517)
			
			If (This:C1470.success)
				
				$tableNumber:=$field.relatedTableNumber
				
				If ($c.length>2)
					
					$0:=This:C1470.fieldDefinition($tableNumber; $c.copy().remove(0).join("."))
					$0.path:=$2
					
				Else 
					
					$table:=This:C1470.catalog.query("tableNumber=:1"; $tableNumber).pop()
					This:C1470.success:=($table#Null:C1517)
					
					If (This:C1470.success)
						
						$field:=$table.field.query("name=:1"; $c[1]).pop()
						This:C1470.success:=($field#Null:C1517)
						
						If (This:C1470.success)
							
							$0.path:=$2
							$0.tableName:=Table name:C256($tableNumber)
							$0.tableNumber:=$tableNumber
							$0.fieldNumber:=$field.fieldNumber
							
							$0.name:=Choose:C955($field.relatedDataClass=Null:C1517; Field name:C257($tableNumber; $field.fieldNumber); $c[0])
							
							$0.fieldType:=$field.fieldType
							
							$0.valueType:=$field.type
							$0.type:=This:C1470.__fielddType($field.fieldType)
							
						Else 
							
							This:C1470.errors.push("Field "+$c[1]+" not found")
							
						End if 
						
					Else 
						
						This:C1470.errors.push("Table "+String:C10($tableNumber)+" not found")
						
					End if 
				End if 
				
			Else 
				
				This:C1470.errors.push("Field "+$c[0]+" not found")
				
			End if 
			
		Else 
			
			This:C1470.errors.push("Table "+String:C10($tableNumber)+" not found")
			
		End if 
	End if 
	
	//==================================================================
Function relatedCatalog  // Return related entity catalog
	var $0 : Object
	var $1 : Text  // Table ID
	var $2 : Text  // RelatedEntity
	
	var $fieldID : Text
	var $field; $o; $related; $relatedDataClass; $relatedField : Object
	
	$0:=New object:C1471(\
		"success"; False:C215)
	
	$field:=This:C1470.datastore[$1][$2]
	
	Case of 
			
			//…………………………………………………………………………………………………
		: ($field=Null:C1517)
			
			// <NOTHING MORE TO DO>
			
			//…………………………………………………………………………………………………
		: (This:C1470.isRelatedEntity($field))  // N -> 1 relation
			
			$0.success:=True:C214
			$0.fields:=New collection:C1472
			$0.relatedEntity:=$field.name
			$0.relatedTableNumber:=This:C1470.datastore[$field.relatedDataClass].getInfo().tableNumber
			$0.relatedDataClass:=$field.relatedDataClass
			$0.inverseName:=$field.inverseName
			
			$relatedDataClass:=This:C1470.datastore[$field.relatedDataClass]
			
			For each ($fieldID; $relatedDataClass)
				
				$o:=$relatedDataClass[$fieldID]
				
				Case of 
						
						//___________________________________________
					: (This:C1470.isStorage($o))
						
						// #TEMPO
						$o.valueType:=$o.type
						
						$o.path:=$o.name
						$o.type:=This:C1470.__fielddType($o.fieldType)
						
						$o.relatedTableNumber:=$0.relatedTableNumber
						
						$0.fields.push($o)
						
						//___________________________________________
					: (This:C1470.isRelatedEntity($o))  // N -> 1 relation
						
						If (feature.with("moreRelations"))  // & False
							
							For each ($relatedField; Form:C1466.$project.$catalog.query("name = :1"; $o.relatedDataClass).pop().field)
								
								If (This:C1470.isStorage($relatedField))
									
									$o:=This:C1470.fieldDefinition(Num:C11($0.relatedTableNumber); $relatedField.name)
									$o.path:=$o.tableName+"."+$o.name
									
									$0.fields.push($o)
									
								End if 
							End for each 
						End if 
						
						//…………………………………………………………………………………………………
					: (This:C1470.isRelatedEntities($o))  // 1 -> N relation
						
						// <NOT YET  MANAGED>
						
						//___________________________________________
				End case 
			End for each 
			
			//…………………………………………………………………………………………………
		: (This:C1470.isRelatedEntities($field))  // 1 -> N relation
			
			// <NOT YET  MANAGED>
			
			//…………………………………………………………………………………………………
		Else 
			
			// <NOTHING MORE TO DO>
			
			//…………………………………………………………………………………………………
	End case 
	
	//==================================================================
Function tableNumber
	var $1 : Text
	var $0 : Integer
	
	This:C1470.success:=This:C1470.datastore[$1]#Null:C1517
	
	If (This:C1470.success)
		
		$0:=This:C1470.datastore[$1].getInfo().tableNumber
		
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