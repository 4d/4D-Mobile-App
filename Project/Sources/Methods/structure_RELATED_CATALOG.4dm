//%attributes = {}
#DECLARE($tableName : Text; $relationName : Text; $recursive : Boolean)->$result : Object

var $fieldName : Text
var $withRecursiveLinks : Boolean
var $field; $o; $related; $relatedDataClass; $relatedField : Object

$result:=New object:C1471(\
"success"; False:C215)

If (Count parameters:C259>=3)
	
	$withRecursiveLinks:=$recursive
	
End if 

$field:=ds:C1482[$tableName][$relationName]

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
		$result.relatedTableNumber:=ds:C1482[$field.relatedDataClass].getInfo().tableNumber
		$result.relatedDataClass:=$field.relatedDataClass
		$result.inverseName:=$field.inverseName
		
		$relatedDataClass:=ds:C1482[$field.relatedDataClass]
		
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
					
					If (Choose:C955($withRecursiveLinks; True:C214; ($o.relatedDataClass#$tableName)))
						
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
	Else 
		
		ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
		
		//…………………………………………………………………………………………………
End case 