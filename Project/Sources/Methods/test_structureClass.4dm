//%attributes = {}
var $i; $start; $tableNumber : Integer
var $o; $structure : Object
var $c : Collection

TRY

COMPONENT_INIT

//=============================================================
//=                        catalog                            =
//=============================================================
$structure:=cs:C1710.structure.new()

If (Asserted:C1132($structure.success))
	
	If (Asserted:C1132($structure.catalog#Null:C1517))
		
		If (Asserted:C1132($structure.catalog.length>0))
			
			$c:=$structure.catalog
			
		End if 
	End if 
End if 

//_____________________________________________________________
$structure:=cs:C1710.structure.new()
$c:=$structure.exposedCatalog("HELLO_WORLD")

If (Asserted:C1132(Not:C34($structure.success)))
	
	If (Asserted:C1132($structure.errors#Null:C1517))
		
		If (Asserted:C1132($structure.errors.length>0))
			
			ASSERT:C1129($structure.errors[0]="Table not found: HELLO_WORLD")
			
		End if 
	End if 
End if 

//_____________________________________________________________
$structure:=cs:C1710.structure.new()
$c:=$structure.exposedCatalog(8858)

If (Asserted:C1132(Not:C34($structure.success)))
	
	If (Asserted:C1132($structure.errors#Null:C1517))
		
		If (Asserted:C1132($structure.errors.length>0))
			
			ASSERT:C1129($structure.errors[0]="Table not found: 8858")
			
		End if 
	End if 
End if 

//_____________________________________________________________
$structure:=cs:C1710.structure.new()
$tableNumber:=$structure.tableNumber("UNIT_0")
$c:=$structure.exposedCatalog("UNIT_0")

If (Asserted:C1132($structure.success))
	
	If (Asserted:C1132($c#Null:C1517))
		
		If (Asserted:C1132($c.length=1))
			
			ASSERT:C1129($c[0].name="UNIT_0")
			ASSERT:C1129($c[0].tableNumber=$tableNumber)
			ASSERT:C1129($c[0].primaryKey="ID")
			
			If (Asserted:C1132($c[0].field#Null:C1517))
				
				If (Asserted:C1132($c[0].field.length>0))
					
					ASSERT:C1129($c[0].field.length=10)
					
					$o:=$c[0].field.query("name = ID").pop()
					
					If (Asserted:C1132($o#Null:C1517))
						
						ASSERT:C1129($o.id=1)
						ASSERT:C1129($o.name="ID")
						ASSERT:C1129($o.type=4)
						ASSERT:C1129($o.relatedDataClass=Null:C1517)
						ASSERT:C1129($o.relatedTableNumber=Null:C1517)
						
					End if 
					
					$o:=$c[0].field.query("name = Field_2").pop()
					
					If (Asserted:C1132($o#Null:C1517))
						
						ASSERT:C1129($o.id=2)
						ASSERT:C1129($o.name="Field_2")
						ASSERT:C1129($o.type=10)
						ASSERT:C1129($o.relatedDataClass=Null:C1517)
						ASSERT:C1129($o.relatedTableNumber=Null:C1517)
						
					End if 
					
					$o:=$c[0].field.query("name = Field_3").pop()
					
					If (Asserted:C1132($o#Null:C1517))
						
						ASSERT:C1129($o.id=3)
						ASSERT:C1129($o.name="Field_3")
						ASSERT:C1129($o.type=10)
						ASSERT:C1129($o.relatedDataClass=Null:C1517)
						ASSERT:C1129($o.relatedTableNumber=Null:C1517)
						
					End if 
					
					$o:=$c[0].field.query("name = Field_4").pop()
					
					If (Asserted:C1132($o#Null:C1517))
						
						ASSERT:C1129($o.id=4)
						ASSERT:C1129($o.name="Field_4")
						ASSERT:C1129($o.type=10)
						ASSERT:C1129($o.relatedDataClass=Null:C1517)
						ASSERT:C1129($o.relatedTableNumber=Null:C1517)
						
					End if 
					
					$o:=$c[0].field.query("name = Field_5").pop()
					
					If (Asserted:C1132($o#Null:C1517))
						
						ASSERT:C1129($o.id=5)
						ASSERT:C1129($o.name="Field_5")
						ASSERT:C1129($o.type=10)
						ASSERT:C1129($o.relatedDataClass=Null:C1517)
						ASSERT:C1129($o.relatedTableNumber=Null:C1517)
						
					End if 
					
					$o:=$c[0].field.query("name = recursive_0").pop()
					
					If (Asserted:C1132($o#Null:C1517))
						
						ASSERT:C1129($o.id=Null:C1517)
						ASSERT:C1129($o.name="recursive_0")
						ASSERT:C1129($o.type=-1)
						ASSERT:C1129($o.relatedDataClass="UNIT_0")
						ASSERT:C1129($o.relatedTableNumber=$tableNumber)
						
					End if 
					
					$o:=$c[0].field.query("name = r_1").pop()
					
					If (Asserted:C1132($o#Null:C1517))
						
						ASSERT:C1129($o.id=Null:C1517)
						ASSERT:C1129($o.name="r_1")
						ASSERT:C1129($o.type=-1)
						ASSERT:C1129($o.relatedDataClass="UNIT_1")
						ASSERT:C1129($o.relatedTableNumber=$structure.tableNumber("UNIT_1"))
						
					End if 
					
					$o:=$c[0].field.query("name = r_2").pop()
					
					If (Asserted:C1132($o#Null:C1517))
						
						ASSERT:C1129($o.id=Null:C1517)
						ASSERT:C1129($o.name="r_2")
						ASSERT:C1129($o.type=-1)
						ASSERT:C1129($o.relatedDataClass="UNIT_1")
						ASSERT:C1129($o.relatedTableNumber=$structure.tableNumber("UNIT_1"))
						
					End if 
				End if 
			End if 
		End if 
	End if 
End if 

//=============================================================
//=                    fieldDefinition                        =
//=============================================================
$structure:=cs:C1710.structure.new()
$o:=$structure.fieldDefinition(8858; "ID")

If (Asserted:C1132(Not:C34($structure.success)))
	
	If (Asserted:C1132($structure.errors#Null:C1517))
		
		If (Asserted:C1132($structure.errors.length>0))
			
			ASSERT:C1129($structure.errors[0]="Table not found #8858")
			
		End if 
	End if 
End if 

For ($i; 1; Get last table number:C254; 1)
	
	If (Is table number valid:C999($i))
		
		If (Table name:C256($i)="UNIT_0")
			
			$tableNumber:=$i
			$i:=MAXLONG:K35:2-1
			
		End if 
	End if 
End for 

//_____________________________________________________________
$structure:=cs:C1710.structure.new()
$o:=$structure.fieldDefinition("UNIT_0"; "ID")

If (Asserted:C1132($structure.success))
	
	ASSERT:C1129($o.tableNumber=$tableNumber)
	ASSERT:C1129($o.tableName="UNIT_0")
	
	ASSERT:C1129($o.fieldNumber=1)
	ASSERT:C1129($o.name="ID")
	
	ASSERT:C1129($o.path="ID")
	
	ASSERT:C1129($o.type=4)
	
	ASSERT:C1129($o.fieldType=Is longint:K8:6)
	
End if 

//_____________________________________________________________
$structure:=cs:C1710.structure.new()
$o:=$structure.fieldDefinition($tableNumber; "ID")

If (Asserted:C1132($structure.success))
	
	ASSERT:C1129($o.tableNumber=$tableNumber)
	ASSERT:C1129($o.tableName="UNIT_0")
	
	ASSERT:C1129($o.fieldNumber=1)
	ASSERT:C1129($o.name="ID")
	
	ASSERT:C1129($o.path="ID")
	
	ASSERT:C1129($o.type=4)
	
	ASSERT:C1129($o.fieldType=Is longint:K8:6)
	
End if 

//_____________________________________________________________
$structure:=cs:C1710.structure.new()
$tableNumber:=$structure.tableNumber("UNIT_0")

If (Asserted:C1132($structure.success))
	
	$o:=$structure.fieldDefinition($tableNumber; "r_1.Field_1_2")
	
	If (Asserted:C1132($structure.success))
		
		ASSERT:C1129($o.tableNumber=$structure.tableNumber("UNIT_1"))
		ASSERT:C1129($o.tableName="UNIT_1")
		
		ASSERT:C1129($o.fieldNumber=2)
		ASSERT:C1129($o.name="Field_1_2")
		
		ASSERT:C1129($o.path="r_1.Field_1_2")
		
		ASSERT:C1129($o.type=3)
		ASSERT:C1129($o.fieldType=Is integer:K8:5)
		
	End if 
End if 

//_____________________________________________________________
$structure:=cs:C1710.structure.new()
$tableNumber:=$structure.tableNumber("UNIT_0")

If (Asserted:C1132($structure.success))
	
	$o:=$structure.fieldDefinition($tableNumber; "r_2.Field_1_2")
	
	If (Asserted:C1132($structure.success))
		
		ASSERT:C1129($o.tableNumber=$structure.tableNumber("UNIT_1"))
		ASSERT:C1129($o.tableName="UNIT_1")
		
		ASSERT:C1129($o.fieldNumber=2)
		ASSERT:C1129($o.name="Field_1_2")
		
		ASSERT:C1129($o.path="r_2.Field_1_2")
		
		ASSERT:C1129($o.type=3)
		ASSERT:C1129($o.fieldType=Is integer:K8:5)
		
	End if 
End if 

//_____________________________________________________________
$structure:=cs:C1710.structure.new()
$tableNumber:=$structure.tableNumber("UNIT_0")

If (Asserted:C1132($structure.success))
	
	$o:=$structure.fieldDefinition($tableNumber; "r_1.r_1_2.Field_2_3")
	
	If (Asserted:C1132($structure.success))
		
		ASSERT:C1129($o.tableNumber=$structure.tableNumber("UNIT_2"))
		ASSERT:C1129($o.tableName="UNIT_2")
		
		ASSERT:C1129($o.fieldNumber=3)
		ASSERT:C1129($o.name="Field_2_3")
		
		ASSERT:C1129($o.path="r_1.r_1_2.Field_2_3")
		
		ASSERT:C1129($o.type=1)
		ASSERT:C1129($o.fieldType=Is boolean:K8:9)
		
	End if 
End if 

//_____________________________________________________________
$structure:=cs:C1710.structure.new()
$o:=$structure.fieldDefinition("UNIT_0"; "r_1.r_1_2.r_2_3.Field_3_2")

If (Asserted:C1132($structure.success))
	
	ASSERT:C1129($o.tableNumber=$structure.tableNumber("UNIT_3"))
	ASSERT:C1129($o.tableName="UNIT_3")
	
	ASSERT:C1129($o.fieldNumber=2)
	ASSERT:C1129($o.name="Field_3_2")
	
	ASSERT:C1129($o.path="r_1.r_1_2.r_2_3.Field_3_2")
	
	ASSERT:C1129($o.type=12)
	ASSERT:C1129($o.fieldType=Is picture:K8:10)
	
End if 

//_____________________________________________________________
$structure:=cs:C1710.structure.new()
$o:=$structure.fieldDefinition("UNIT_0"; "r_2.r_1_2.r_2_3.Field_3_2")

If (Asserted:C1132($structure.success))
	
	ASSERT:C1129($o.tableNumber=$structure.tableNumber("UNIT_3"))
	ASSERT:C1129($o.tableName="UNIT_3")
	
	ASSERT:C1129($o.fieldNumber=2)
	ASSERT:C1129($o.name="Field_3_2")
	
	ASSERT:C1129($o.path="r_2.r_1_2.r_2_3.Field_3_2")
	
	ASSERT:C1129($o.type=12)
	ASSERT:C1129($o.fieldType=Is picture:K8:10)
	
End if 

If (False:C215)  //============================================================ LOCAL ONLY
	
	If (Structure file:C489=Structure file:C489(*))
		
		//=============================================================
		//=                   __DeletedRecords                        =
		//=============================================================
		
		DOCUMENT:="DROP TABLE IF EXISTS "+String:C10(SHARED.deletedRecordsTable.name)
		
		Begin SQL
			
			EXECUTE IMMEDIATE :DOCUMENT
			
		End SQL
		
		$o:=_o_structure(New object:C1471(\
			"action"; "verifyDeletedRecords"))
		
		If (Asserted:C1132(Not:C34($o.success); "verifyDeletedRecords when the table doesn't exist"))
			
			$o:=_o_structure(New object:C1471(\
				"action"; "createDeletedRecords"))
			
			If (Asserted:C1132($o.success; "createDeletedRecords when the table doesn't exist"))
				
				$o:=_o_structure(New object:C1471(\
					"action"; "verifyDeletedRecords"))
				
				If (Asserted:C1132($o.success; "verifyDeletedRecords when the table exist"))
					
					$o:=_o_structure(New object:C1471(\
						"action"; "createDeletedRecords"))
					
					ASSERT:C1129($o.success; "createDeletedRecords when the table already exist")
					
					$o:=_o_structure(New object:C1471(\
						"action"; "catalog"; \
						"name"; SHARED.deletedRecordsTable.name))
					
					ASSERT:C1129(Not:C34($o.success); "catalog doesn't filter the deletedRecords table")
					
				End if 
			End if 
		End if 
		
		//=============================================================
		//=                         __stamps                          =
		//=============================================================
		
		DOCUMENT:="CREATE TABLE IF NOT EXISTS UNIT_STRUCTURE (ID INT32, PRIMARY KEY (ID));"
		
		Begin SQL
			
			EXECUTE IMMEDIATE :DOCUMENT
			
		End SQL
		
		$o:=_o_structure(New object:C1471(\
			"action"; "verifyStamps"; \
			"tableName"; "UNIT_STRUCTURE"))
		
		ASSERT:C1129(Not:C34($o.success); "verifyStamps when field is missing")
		
		$o:=_o_structure(New object:C1471(\
			"action"; "createStamps"; \
			"tableName"; "UNIT_STRUCTURE"))
		
		If (Asserted:C1132($o.success; "createStamps when the stamp doesn't exist"))
			
			$o:=_o_structure(New object:C1471(\
				"action"; "createStamps"; \
				"tableName"; "UNIT_STRUCTURE"))
			
			ASSERT:C1129($o.success; "createStamps when the stamp already exist")
			
			$o:=_o_structure(New object:C1471(\
				"action"; "verifyStamps"; \
				"tableName"; "UNIT_STRUCTURE"))
			
			ASSERT:C1129($o.success; "verifyStamps when the field exist")
			
		End if 
		
		$o:=_o_structure(New object:C1471(\
			"action"; "verify"; \
			"tables"; "UNIT_STRUCTURE"))
		
		ASSERT:C1129($o.success; "verify for a table")
		
		$o:=_o_structure(New object:C1471(\
			"action"; "verify"; \
			"tables"; New collection:C1472("UNIT_STRUCTURE")))
		
		ASSERT:C1129($o.success; "verify for collection of tables")
		
		$o:=_o_structure(New object:C1471(\
			"action"; "verifyStamps"; \
			"tableName"; "UNKNOWN"))
		
		ASSERT:C1129(Not:C34($o.success); "verifyStamps for an unknown table")
		
		DOCUMENT:="DROP TABLE IF EXISTS UNIT_STRUCTURE;"
		
		Begin SQL
			
			EXECUTE IMMEDIATE :DOCUMENT
			
		End SQL
		
	End if 
End if 

FINALLY

BEEP:C151