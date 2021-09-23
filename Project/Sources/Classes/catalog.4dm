Class constructor
	
	This:C1470.success:=True:C214
	
	//==================================================================
Function buildExposedDatastore()->$datastore : Object
	
	var $key : Text
	var $infos; $o; $table : Object
	
	$datastore:=New object:C1471
	
	For each ($key; ds:C1482)
		
		$o:=ds:C1482[$key].getInfo()
		
		Case of 
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			: (Not:C34($o.exposed))
				
				// Table is not exposed
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			Else 
				
				$table:=New object:C1471
				$table[""]:=$o
				
				For each ($o; OB Entries:C1720(ds:C1482[$key]))
					
					If (Bool:C1537($o.value.exposed))
						
						If ($o.value.type#"blob")
							
							$table[$o.key]:=$o.value
							
						End if 
					End if 
				End for each 
				
				$datastore[$key]:=$table
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		End case 
	End for each 
	
	//==================================================================
Function buildExposedCatalog()->$catalog : Collection
	
	var $key : Text
	var $attribute; $datastore; $entry; $field; $o; $table : Object
	
	$catalog:=New collection:C1472
	$datastore:=ds:C1482
	
	For each ($entry; OB Entries:C1720($datastore))
		
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