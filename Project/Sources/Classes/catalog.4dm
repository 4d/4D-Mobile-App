Class constructor
	
	This:C1470.stampFieldName:="__GlobalStamp"
	This:C1470.deletedRecordsTableName:="__DeletedRecords"
	
	This:C1470.allowedTypes:=New collection:C1472("string"; "bool"; "date"; "number"; "image"; "object")
	
	This:C1470.warnings:=New collection:C1472
	This:C1470.errors:=New collection:C1472
	
	This:C1470.success:=True:C214
	
	//==================================================================
Function buildExposedDatastore($localID : Text)->$datastore : Object
	
	var $tableName : Text
	var $meta; $o; $table : Object
	var $ds : cs:C1710.DataStore
	
	$datastore:=New object:C1471
	
	$ds:=$localID=Null:C1517 ? ds:C1482 : ds:C1482($localID)
	
	For each ($tableName; $ds)
		
		If ($tableName=This:C1470.deletedRecordsTableName)
			
			// DON'T DISPLAY DELETED RECORDS TABLE
			continue
			
		Else 
			
			$meta:=$ds[$tableName].getInfo()
			
			Case of 
					
					//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
				: (Not:C34($meta.exposed))
					
					// Table is not exposed
					
					//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
				Else 
					
					$table:=New object:C1471
					$table[""]:=$meta
					
					For each ($o; OB Entries:C1720($ds[$tableName]))
						
						If ($o.key=This:C1470.stampFieldName)\
							 || (Position:C15("."; $o.key)>0)
							
/*
DON'T DISPLAY STAMP FIELD
DON'T ALLOW FIELD OR RELATION NAME WITH DOT !
*/
							
							continue
							
						End if 
						
						If (Bool:C1537($o.value.exposed))
							
							If (This:C1470.allowedTypes.indexOf($o.value.type)>=0)
								
								$table[$o.key]:=$o.value
								
							End if 
						End if 
					End for each 
					
					$datastore[$tableName]:=$table
					
					//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			End case 
		End if 
		
	End for each 
	
	//==================================================================
Function buildExposedCatalog()->$catalog : Collection
	
	var $key : Text
	var $attribute; $entry; $field; $o; $table : Object
	
	$catalog:=New collection:C1472
	
	For each ($entry; OB Entries:C1720(ds:C1482))
		
		$o:=ds:C1482[$entry.key].getInfo()
		
		Case of 
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			: (Not:C34($o.exposed))
				
				// Dataclass is not exposed
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			Else 
				
				$table:=New object:C1471(\
					"name"; $entry.key; \
					"fields"; New collection:C1472; \
					"infos"; $o)
				
				For each ($attribute; OB Entries:C1720($entry))
					
					If (Value type:C1509($attribute.value)=Is object:K8:27)
						
						For each ($key; $attribute.value)
							
							$field:=$attribute.value[$key]
							
							Case of 
									
									//======================================
								: ($field.exposed=Null:C1517)
									
									// Attribute is not exposed
									
									//======================================
								: ($field.type="blob")
									
									// BLOB type attributes are not managed in the datastore
									
									//======================================
								Else 
									
									$table.fields.push($field)
									
									//======================================
							End case 
						End for each 
						
					End if 
				End for each 
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		End case 
		
		$catalog.push($table)
		
	End for each 