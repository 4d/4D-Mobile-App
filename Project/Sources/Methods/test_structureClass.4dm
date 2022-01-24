//%attributes = {}
var $tableNumber : Integer
var $field; $o; $table : Object
var $catalog : Collection
var $structure : cs:C1710.structure

err_TRY

COMPONENT_INIT
$structure:=cs:C1710.structure.new()

If (Asserted:C1132($structure.success; "cs.structure.new() failed"))
	
	If (Asserted:C1132($structure.catalog#Null:C1517; "catalog should not be null"))
		
		If (Asserted:C1132($structure.catalog.length>0; "catalog should not be empty"))
			
			$catalog:=$structure.catalog
			
		End if 
	End if 
	
	ASSERT:C1129($structure.datastore#Null:C1517; "datastore should be defined")
	ASSERT:C1129($structure.errors.length=0; "should not return an error")
	ASSERT:C1129($structure.warnings.length>0; "should return one or more warnings")
	
End if 

// Mark:- exposedCatalog
$catalog:=$structure.exposedCatalog("HELLO_WORLD")

If (Asserted:C1132(Not:C34($structure.success); "should failed"))
	
	ASSERT:C1129($structure.errors.length>0; "should return at least one error")
	
	If (Asserted:C1132($structure.errors.length>0; "should return at least one error"))
		
		ASSERT:C1129($structure.errors.pop()="Table not found: HELLO_WORLD")
		
	End if 
End if 

$catalog:=$structure.exposedCatalog(8858)

If (Asserted:C1132(Not:C34($structure.success); "should failed"))
	
	ASSERT:C1129($structure.errors.length>0; "should return at least one error")
	
	If (Asserted:C1132($structure.errors.length>0; "should return at least one error"))
		
		ASSERT:C1129($structure.errors.pop()="Table not found: 8858")
		
	End if 
End if 

// Mark:- tableCatalog
$table:=$structure.tableDefinition("UNIT_0")

If (Asserted:C1132($table#Null:C1517))
	
	$catalog:=$structure.exposedCatalog("UNIT_0")
	
	ASSERT:C1129($table.exposed=$catalog[0].exposed)
	ASSERT:C1129($table.field.length=$catalog[0].field.length)
	ASSERT:C1129($table.name=$catalog[0].name)
	ASSERT:C1129($table.primaryKey=$catalog[0].primaryKey)
	ASSERT:C1129($table.tableNumber=$catalog[0].tableNumber)
	
	$field:=$table.field.query("name = :1"; "ID").pop()
	
	If (Asserted:C1132($field#Null:C1517))
		
		ASSERT:C1129($field.id=1)
		ASSERT:C1129($field.type=4)
		ASSERT:C1129($field.relatedDataClass=Null:C1517)
		ASSERT:C1129($field.relatedTableNumber=Null:C1517)
		//ASSERT($structure.isStorage($field))
		
	End if 
	
	$field:=$table.field.query("name = :1"; "Field_2").pop()
	
	If (Asserted:C1132($field#Null:C1517))
		
		ASSERT:C1129($field.id=2)
		ASSERT:C1129($field.type=10)
		ASSERT:C1129($field.relatedDataClass=Null:C1517)
		ASSERT:C1129($field.relatedTableNumber=Null:C1517)
		
	End if 
	
	$field:=$table.field.query("name = :1"; "Field_3").pop()
	
	If (Asserted:C1132($field#Null:C1517))
		
		ASSERT:C1129($field.id=3)
		ASSERT:C1129($field.type=10)
		ASSERT:C1129($field.relatedDataClass=Null:C1517)
		ASSERT:C1129($field.relatedTableNumber=Null:C1517)
		
	End if 
	
	$field:=$table.field.query("name = :1"; "Field_4").pop()
	
	If (Asserted:C1132($field#Null:C1517))
		
		ASSERT:C1129($field.id=4)
		ASSERT:C1129($field.type=10)
		ASSERT:C1129($field.relatedDataClass=Null:C1517)
		ASSERT:C1129($field.relatedTableNumber=Null:C1517)
		
	End if 
	
	$field:=$table.field.query("name = :1"; "Field_5").pop()
	
	If (Asserted:C1132($field#Null:C1517))
		
		ASSERT:C1129($field.id=5)
		ASSERT:C1129($field.type=10)
		ASSERT:C1129($field.relatedDataClass=Null:C1517)
		ASSERT:C1129($field.relatedTableNumber=Null:C1517)
		
	End if 
	
	$field:=$table.field.query("name = :1"; "recursive_0").pop()
	
	If (Asserted:C1132($field#Null:C1517))
		
		ASSERT:C1129($field.id=Null:C1517)
		ASSERT:C1129($field.type=-1)
		ASSERT:C1129($field.relatedDataClass="UNIT_0")
		ASSERT:C1129($field.relatedTableNumber=ds:C1482["UNIT_0"].getInfo().tableNumber)
		
	End if 
	
	$field:=$table.field.query("name = :1"; "r_1").pop()
	
	If (Asserted:C1132($field#Null:C1517))
		
		ASSERT:C1129($field.id=Null:C1517)
		ASSERT:C1129($field.type=-1)
		ASSERT:C1129($field.relatedDataClass="UNIT_1")
		ASSERT:C1129($field.relatedTableNumber=ds:C1482["UNIT_1"].getInfo().tableNumber)
		
	End if 
	
	$field:=$table.field.query("name = :1"; "r_2").pop()
	
	If (Asserted:C1132($field#Null:C1517))
		
		ASSERT:C1129($field.id=Null:C1517)
		ASSERT:C1129($field.type=-1)
		ASSERT:C1129($field.relatedDataClass="UNIT_1")
		ASSERT:C1129($field.relatedTableNumber=ds:C1482["UNIT_1"].getInfo().tableNumber)
		
	End if 
	
End if 

// Mark:- fieldDefinition
$structure:=cs:C1710.structure.new()

$o:=$structure.fieldDefinition(8858; "ID")

If (Asserted:C1132(Not:C34($structure.success)))
	
	If (Asserted:C1132($structure.errors#Null:C1517))
		
		If (Asserted:C1132($structure.errors.length>0))
			
			ASSERT:C1129($structure.errors[0]="Table not found #8858")
			
		End if 
	End if 
End if 

$tableNumber:=ds:C1482["UNIT_0"].getInfo().tableNumber

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

ASSERT:C1129(Structure file:C489#Structure file:C489(*); "DONE")

err_FINALLY