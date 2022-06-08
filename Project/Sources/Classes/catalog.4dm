Class constructor
	
	This:C1470.stampFieldName:="__GlobalStamp"
	This:C1470.deletedRecordsTableName:="__DeletedRecords"
	
	This:C1470.allowedTypes:=New collection:C1472("string"; "bool"; "date"; "number"; "image"; "object")
	
	This:C1470.warnings:=New collection:C1472
	This:C1470.errors:=New collection:C1472
	
	This:C1470.success:=True:C214
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function buildExposedCatalog() : Collection
	
	var $key : Text
	var $attribute; $entry; $field; $meta; $table : Object
	var $catalog : Collection
	
	$catalog:=New collection:C1472
	
	For each ($entry; OB Entries:C1720(ds:C1482))
		
		$meta:=ds:C1482[$entry.key].getInfo()
		
		If (Not:C34($meta.exposed))
			
			continue
			
		End if 
		
		$table:=New object:C1471(\
			"name"; $entry.key; \
			"fields"; New collection:C1472; \
			"infos"; $meta)
		
		For each ($attribute; OB Entries:C1720($entry))
			
			If (Value type:C1509($attribute.value)=Is object:K8:27)
				
				For each ($key; $attribute.value)
					
					$field:=$attribute.value[$key]
					
					If ($field.exposed=Null:C1517)\
						 || ($field.type="blob")
						
						continue
						
					End if 
					
					$table.fields.push($field)
					
				End for each 
				
			End if 
		End for each 
		
		$catalog.push($table)
		
	End for each 
	
	return $catalog
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function buildExposedDatastore($localID : Text) : Object
	
	var $tableName : Text
	var $datastore; $meta; $o; $table : Object
	var $ds : cs:C1710.DataStore
	
	$datastore:=New object:C1471
	
	$ds:=$localID=Null:C1517 ? ds:C1482 : ds:C1482($localID)
	
	For each ($tableName; $ds)
		
		If ($tableName=This:C1470.deletedRecordsTableName)
			
			// DON'T DISPLAY DELETED RECORDS TABLE
			continue
			
		End if 
		
		$meta:=$ds[$tableName].getInfo()
		
		If (Not:C34($meta.exposed))
			
			continue
			
		End if 
		
		$table:=New object:C1471
		$table[""]:=$meta
		
		For each ($o; OB Entries:C1720($ds[$tableName]))
			
/*
DON'T DISPLAY STAMP FIELD
DON'T ALLOW FIELD OR RELATION NAME WITH DOT !
*/
			
			If ($o.key=This:C1470.stampFieldName)\
				 || (Position:C15("."; $o.key)>0)\
				 || (Not:C34(Bool:C1537($o.value.exposed)))\
				 || (This:C1470.allowedTypes.indexOf($o.value.type)=-1)
				
				continue
				
			End if 
			
			If ($o.value.kind="alias")
				
				
				
			End if 
			
			$table[$o.key]:=$o.value
			
		End for each 
		
		ARRAY TEXT:C222($properties; 0x0000)
		OB GET PROPERTY NAMES:C1232($table; $properties)
		
		If (Size of array:C274($properties)>0)
			
			$datastore[$tableName]:=$table
			
		End if 
	End for each 
	
	return $datastore
	
/* === === === === === === === === === === === === === === === === === === === === === === === === === ===
Returns True if everything is OK.
Returns False and no error if we can solve the problem.
Returns False and an error list if we can't solve the problem.
*/
Function verifyStructureAdjustments($publishedTableNames : Collection) : Boolean
	
	var $t : Text
	var $field; $o; $pk : Object
	var $dataclass : 4D:C1709.DataClass
	
	// Mark:Verify __DeletedRecords dataclasses
	$dataclass:=ds:C1482[SHARED.deletedRecordsTable.name]
	
	If ($dataclass=Null:C1517)
		
		return 
		
	End if 
	
	$o:=$dataclass.getInfo()
	
	$pk:=$dataclass[SHARED.deletedRecordsTable.fields.query("primaryKey = true").pop().name]
	
	If (Not:C34(Bool:C1537($o.exposed)))\
		 || (String:C10($o.primaryKey)#$pk.name)\
		 || (Not:C34(Bool:C1537($pk.autoFilled)))\
		 || (Not:C34(Bool:C1537($pk.indexed)))
		
		Case of 
				
				//______________________________________________________
			: (Not:C34(Bool:C1537($o.exposed)))
				
				This:C1470.errors.push("The table \""+SHARED.deletedRecordsTable.name+"\" is not exposed")
				
				//______________________________________________________
			: (String:C10($o.primaryKey)#$pk.name)
				
				This:C1470.errors.push("The primary key of the dataclass \""+SHARED.deletedRecordsTable.name+"\" must be named \""+$pk.name+"\"")
				
				//______________________________________________________
		End case 
		
		return 
		
	End if 
	
	For each ($o; SHARED.deletedRecordsTable.fields)
		
		$field:=$dataclass[$o.name]
		
		If ($field=Null:C1517)\
			 || (Not:C34(Bool:C1537($field.exposed)))\
			 || ($field.type#$o._type)
			
			Case of 
					
					//______________________________________________________
				: (Not:C34(Bool:C1537($field.exposed)))
					
					This:C1470.errors.push("The attribute \""+$o.name+"\" of the dataclass \""+SHARED.deletedRecordsTable.name+"\" must be exposed")
					
					//______________________________________________________
				: ($field.type#$o._type)
					
					This:C1470.errors.push("The type of the attribute \""+$o.name+"\" of the dataclass \""+SHARED.deletedRecordsTable.name+"\" is not the expected one")
					
					//______________________________________________________
			End case 
			
			return 
			
		End if 
	End for each 
	
	// Mark:Verify __GlobalStamp for published dataclasses
	If ($publishedTableNames#Null:C1517)\
		 && ($publishedTableNames.length>0)
		
		For each ($t; $publishedTableNames)
			
			$dataclass:=ds:C1482[$t]
			
			If ($dataclass=Null:C1517)\
				 || ($dataclass[SHARED.stampField.name]=Null:C1517)\
				 || ($dataclass[SHARED.stampField.name].type#SHARED.stampField._type)
				
				return 
				
			End if 
		End for each 
	End if 
	
	return True:C214
	
/* === === === === === === === === === === === === === === === === === === === === === === === === === ===
Returns True if everything is OK.
Returns False and an error list if we can't solve the problem.
*/
Function doStructureAdjustments($publishedTableNames : Collection) : Boolean
	
	var $t : Text
	var $o : Object
	var $error : cs:C1710.error
	
	$error:=cs:C1710.error.new()
	$error.capture()
	
	// MARK:Create __DeletedRecords dataclasses
	DOCUMENT:="CREATE TABLE IF NOT EXISTS "+String:C10(SHARED.deletedRecordsTable.name)+" ("
	
	For each ($o; SHARED.deletedRecordsTable.fields)
		
		DOCUMENT:=DOCUMENT+" "+String:C10($o.name)+" "+String:C10($o.type)+","
		
		If (Bool:C1537($o.primaryKey))
			
			DOCUMENT:=DOCUMENT+" PRIMARY KEY ("+String:C10($o.name)+"),"
			
		End if 
	End for each 
	
	// Delete the last ","
	DOCUMENT:=Delete string:C232(DOCUMENT; Length:C16(DOCUMENT); 1)
	
	DOCUMENT:=DOCUMENT+");"
	
	Begin SQL
		
		EXECUTE IMMEDIATE : DOCUMENT
		
	End SQL
	
	If ($error.noError())
		
		For each ($o; SHARED.deletedRecordsTable.fields)
			
			If (Bool:C1537($o.autoincrement))
				
				DOCUMENT:="ALTER TABLE "+String:C10(SHARED.deletedRecordsTable.name)+" MODIFY "+String:C10($o.name)+" ENABLE AUTO_INCREMENT;"
				
				Begin SQL
					
					EXECUTE IMMEDIATE : DOCUMENT
					
				End SQL
				
			End if 
			
			If ($error.withError())
				
				This:C1470.errors.push(JSON Stringify:C1217($error.errors())+" ("+DOCUMENT+")")
				return 
				
			End if 
		End for each 
	End if 
	
	// Create the indexes if any
	If ($error.noError())
		
		For each ($o; SHARED.deletedRecordsTable.fields)
			
			If (Bool:C1537($o.indexed))
				
				DOCUMENT:="CREATE INDEX "+String:C10(SHARED.deletedRecordsTable.name)+String:C10($o.name)+" ON "+String:C10(SHARED.deletedRecordsTable.name)+" ("+String:C10($o.name)+");"
				
				Begin SQL
					
					EXECUTE IMMEDIATE : DOCUMENT
					
				End SQL
				
				If ($error.withError())
					
					If ($error.lastError().stack[0].code=1155)
						
						This:C1470.warnings.push("Index already exists for the attribute \""+$o.name+"\" of the table \""+SHARED.deletedRecordsTable.name+"\"")
						$error.ignoreLastError()
						
					Else 
						
						This:C1470.errors.push(JSON Stringify:C1217($error.errors())+" ("+DOCUMENT+")")
						return 
						
					End if 
				End if 
			End if 
		End for each 
	End if 
	
	If ($error.noError())
		
		// Mark:Create __GlobalStamp for published dataclasses
		If ($publishedTableNames#Null:C1517)\
			 && ($publishedTableNames.length>0)
			
			var $str : cs:C1710.str
			$str:=cs:C1710.str.new()
			
			For each ($t; $publishedTableNames)
				
				DOCUMENT:="ALTER TABLE ["+$t+"] ADD TRAILING "+String:C10(SHARED.stampField.name)+" "+String:C10(SHARED.stampField.type)+";"
				
				Begin SQL
					
					EXECUTE IMMEDIATE : DOCUMENT
					
				End SQL
				
				If ($error.withError())
					
					If ($error.lastError().stack[0].code=1053)
						
						This:C1470.warnings.push("Attribute \""+SHARED.stampField.name+"\" already exists for the dataclass \""+$t+"\"")
						$error.ignoreLastError()
						
					End if 
				End if 
				
				If ($error.noError())
					
					If (Bool:C1537(SHARED.stampField.indexed))
						
						DOCUMENT:="CREATE INDEX "+String:C10(SHARED.stampField.name)+"_"+$str.lowerCamelCase($t)+" ON ["+$t+"] ("+String:C10(SHARED.stampField.name)+");"
						
						Begin SQL
							
							EXECUTE IMMEDIATE : DOCUMENT
							
						End SQL
						
						If ($error.withError())
							
							If ($error.lastError().stack[0].code=1155)
								
								// Index already exists
								This:C1470.warnings.push("Index of the attribute \""+SHARED.stampField.name+"\\ of the dataclass \""+$t+"\" already exists")
								$error.ignoreLastError()
								
							Else 
								
								This:C1470.errors.push(JSON Stringify:C1217($error.errors())+" ("+DOCUMENT+")")
								return 
								
							End if 
						End if 
					End if 
				End if 
			End for each 
		End if 
	End if 
	
	$error.release()
	
	return True:C214