//%attributes = {}
var $number : Integer
var $field; $o; $table : Object
var $catalog; $fields : Collection
var $structure : cs:C1710.ExposedStructure

err_TRY

COMPONENT_INIT

// Mark:- constructor
$structure:=cs:C1710.ExposedStructure.new()

If (Asserted:C1132($structure.success; "cs.ExposedStructure.new() failed"))
	
	If (Asserted:C1132($structure.catalog#Null:C1517; "catalog should not be null"))
		
		If (Asserted:C1132($structure.catalog.length>0; "catalog should not be empty"))
			
			$catalog:=$structure.catalog
			
		End if 
	End if 
	
	ASSERT:C1129($structure.errors.length=0; "should not return an error")
	
	If (Asserted:C1132($structure.warnings.length>=2; "should return 2 or more warnings"))
		
		
		
	End if 
	
	// Check if a dataclass "__DeletedRecords" is not referenced
	ASSERT:C1129($catalog.query("name = __DeletedRecords").pop()=Null:C1517)
	
	// Check if a dataclass with composite primary is not referenced
	ASSERT:C1129($catalog.query("name = 'COMPOSITE PRIMARY KEY'").pop()=Null:C1517)
	
	// Check if a dataclass without primary is not referenced
	ASSERT:C1129($catalog.query("name = 'NO PRIMARY KEY'").pop()=Null:C1517)
	
	// Check if a dataclass not exposed is not referenced
	ASSERT:C1129($catalog.query("name = 'NOT EXPOSED'").pop()=Null:C1517)
	
	// Check if an attribute not exposed is not referenced
	ASSERT:C1129($catalog.query("name = 'とてもとても長いフィールド'").pop()["NOT EXPOSED"]=Null:C1517)
	
	$fields:=$structure.catalog.query("name = :1"; "ALL_TYPES").pop().fields
	
	// Check if attribute "__GlobalStamp" is not referenced
	ASSERT:C1129($fields.query("name = __GlobalStamp").pop()=Null:C1517)
	
	// Check if BLOB type attributes are not referenced
	ASSERT:C1129($fields.query("name = 'Blob field'").pop()=Null:C1517)
	
	// Check if a relation N -> 1 is not referenced if the field isn't exposed
	ASSERT:C1129($fields.query("name = toNotExposedField").pop()=Null:C1517)
	
	// Check if a relation 1 -> N is not referenced if the related dataclass isn't exposed
	ASSERT:C1129($fields.query("name = ToNotExposedTable").pop()=Null:C1517)
	
End if 

// Get a sorted catalog
$structure:=cs:C1710.ExposedStructure.new(True:C214)

// Mark:- exposedCatalog()
$catalog:=$structure.getCatalog("HELLO_WORLD")

If (Asserted:C1132(Not:C34($structure.success); "should failed"))
	
	ASSERT:C1129($structure.errors.length>0; "should return at least one error")
	
	If (Asserted:C1132($structure.errors.length>0; "should return at least one error"))
		
		ASSERT:C1129($structure.errors.pop()="Table not found: HELLO_WORLD")
		
	End if 
End if 

$catalog:=$structure.getCatalog(8858)

If (Asserted:C1132(Not:C34($structure.success); "should failed"))
	
	ASSERT:C1129($structure.errors.length>0; "should return at least one error")
	
	If (Asserted:C1132($structure.errors.length>0; "should return at least one error"))
		
		ASSERT:C1129($structure.errors.pop()="Table not found: 8858")
		
	End if 
End if 

// Check the consistency of the catalog and the datastore
$table:=$structure.catalog.query("name = :1"; "ALL_TYPES").pop()
$fields:=$table.fields

For each ($o; OB Entries:C1720($structure.datastore["ALL_TYPES"]).query("key!=''"))
	
	ASSERT:C1129($fields.query("name = :1"; $o.key).pop()#Null:C1517)
	
End for each 

// Mark:- table()
$table:=$structure.table(5)

If (Asserted:C1132($structure.success))
	
	ASSERT:C1129(New collection:C1472($table).equal(New collection:C1472($structure.table("ALL_TYPES"))))
	
End if 

// Mark:- tableInfos()
$o:=$structure.tableInfos(5)

If (Asserted:C1132($structure.success))
	
	ASSERT:C1129($o.exposed=True:C214; "tableInfos(5).exposed should be True")
	ASSERT:C1129($o.name="ALL_TYPES"; "tableInfos(5).name should be 'ALL_TYPES'")
	ASSERT:C1129($o.primaryKey="ID"; "tableInfos(5).primaryKey should be 'ID'")
	ASSERT:C1129($o.tableNumber=5; "tableInfos(5).tableNumberhould be 5")
	
End if 

$o:=$structure.tableInfos("ALL_TYPES")

If (Asserted:C1132($structure.success))
	
	ASSERT:C1129($o.exposed=True:C214; "tableInfos(5).exposed should be True")
	ASSERT:C1129($o.name="ALL_TYPES"; "tableInfos(5).name should be 'ALL_TYPES'")
	ASSERT:C1129($o.primaryKey="ID"; "tableInfos(5).primaryKey should be 'ID'")
	ASSERT:C1129($o.tableNumber=5; "tableInfos(5).tableNumberhould be 5")
	
End if 

$o:=$structure.tableInfos("HELLO_WORLD")
ASSERT:C1129(Not:C34($structure.success); "tableInfos() should failed")
ASSERT:C1129($o=Null:C1517; "tableInfos() should return a null result")

// Mark:- tableNumber()
ASSERT:C1129($structure.tableNumber("ALL_TYPES")=5; "tableNumber()")
ASSERT:C1129($structure.tableNumber(5)=5; "tableNumber()")

// Mark:- tableName()
ASSERT:C1129($structure.tableName("ALL_TYPES")="ALL_TYPES"; "tableName()")
ASSERT:C1129($structure.tableName(5)="ALL_TYPES"; "tableName()")

// Mark:- tableCatalog()
$table:=$structure.table("UNIT_0")

If (Asserted:C1132($table#Null:C1517))
	
	$catalog:=$structure.getCatalog("UNIT_0")
	
	ASSERT:C1129($table.exposed=$catalog[0].exposed)
	ASSERT:C1129($table.field.length=$catalog[0].fields.length)
	ASSERT:C1129($table.name=$catalog[0].name)
	ASSERT:C1129($table.primaryKey=$catalog[0].primaryKey)
	ASSERT:C1129($table.tableNumber=$catalog[0].tableNumber)
	
	$field:=$table.fields.query("name = :1"; "ID").pop()
	
	If (Asserted:C1132($field#Null:C1517))
		
		ASSERT:C1129($field.id=1)
		ASSERT:C1129($field.type=4)
		ASSERT:C1129($field.relatedDataClass=Null:C1517)
		ASSERT:C1129($field.relatedTableNumber=Null:C1517)
		//ASSERT($structure.isStorage($field))
		
	End if 
	
	$field:=$table.fields.query("name = :1"; "Field_2").pop()
	
	If (Asserted:C1132($field#Null:C1517))
		
		ASSERT:C1129($field.id=2)
		ASSERT:C1129($field.type=10)
		ASSERT:C1129($field.relatedDataClass=Null:C1517)
		ASSERT:C1129($field.relatedTableNumber=Null:C1517)
		
	End if 
	
	$field:=$table.fields.query("name = :1"; "Field_3").pop()
	
	If (Asserted:C1132($field#Null:C1517))
		
		ASSERT:C1129($field.id=3)
		ASSERT:C1129($field.type=10)
		ASSERT:C1129($field.relatedDataClass=Null:C1517)
		ASSERT:C1129($field.relatedTableNumber=Null:C1517)
		
	End if 
	
	$field:=$table.fields.query("name = :1"; "Field_4").pop()
	
	If (Asserted:C1132($field#Null:C1517))
		
		ASSERT:C1129($field.id=4)
		ASSERT:C1129($field.type=10)
		ASSERT:C1129($field.relatedDataClass=Null:C1517)
		ASSERT:C1129($field.relatedTableNumber=Null:C1517)
		
	End if 
	
	$field:=$table.fields.query("name = :1"; "Field_5").pop()
	
	If (Asserted:C1132($field#Null:C1517))
		
		ASSERT:C1129($field.id=5)
		ASSERT:C1129($field.type=10)
		ASSERT:C1129($field.relatedDataClass=Null:C1517)
		ASSERT:C1129($field.relatedTableNumber=Null:C1517)
		
	End if 
	
	$field:=$table.fields.query("name = :1"; "recursive_0").pop()
	
	If (Asserted:C1132($field#Null:C1517))
		
		ASSERT:C1129($field.id=Null:C1517)
		ASSERT:C1129($field.type=-1)
		ASSERT:C1129($field.relatedDataClass="UNIT_0")
		ASSERT:C1129($field.relatedTableNumber=ds:C1482["UNIT_0"].getInfo().tableNumber)
		
	End if 
	
	$field:=$table.fields.query("name = :1"; "r_1").pop()
	
	If (Asserted:C1132($field#Null:C1517))
		
		ASSERT:C1129($field.id=Null:C1517)
		ASSERT:C1129($field.type=-1)
		ASSERT:C1129($field.relatedDataClass="UNIT_1")
		ASSERT:C1129($field.relatedTableNumber=ds:C1482["UNIT_1"].getInfo().tableNumber)
		
	End if 
	
	$field:=$table.fields.query("name = :1"; "r_2").pop()
	
	If (Asserted:C1132($field#Null:C1517))
		
		ASSERT:C1129($field.id=Null:C1517)
		ASSERT:C1129($field.type=-1)
		ASSERT:C1129($field.relatedDataClass="UNIT_1")
		ASSERT:C1129($field.relatedTableNumber=ds:C1482["UNIT_1"].getInfo().tableNumber)
		
	End if 
End if 

// Mark:- fieldDefinition()
$structure:=cs:C1710.ExposedStructure.new()

$o:=$structure.fieldDefinition(8858; "ID")

If (Asserted:C1132(Not:C34($structure.success)))
	
	If (Asserted:C1132($structure.errors#Null:C1517))
		
		If (Asserted:C1132($structure.errors.length>0))
			
			ASSERT:C1129($structure.errors[0]="Table not found #8858")
			
		End if 
	End if 
End if 

$number:=ds:C1482["UNIT_0"].getInfo().tableNumber

$o:=$structure.fieldDefinition("UNIT_0"; "ID")

If (Asserted:C1132($structure.success))
	
	ASSERT:C1129($o.tableNumber=$number)
	ASSERT:C1129($o.tableName="UNIT_0")
	
	ASSERT:C1129($o.fieldNumber=1)
	ASSERT:C1129($o.name="ID")
	
	ASSERT:C1129($o.path="ID")
	
	ASSERT:C1129($o.type=4)
	
	ASSERT:C1129($o.fieldType=Is longint:K8:6)
	
End if 

$o:=$structure.fieldDefinition($number; "ID")

If (Asserted:C1132($structure.success))
	
	ASSERT:C1129($o.tableNumber=$number)
	ASSERT:C1129($o.tableName="UNIT_0")
	
	ASSERT:C1129($o.fieldNumber=1)
	ASSERT:C1129($o.name="ID")
	
	ASSERT:C1129($o.path="ID")
	
	ASSERT:C1129($o.type=4)
	
	ASSERT:C1129($o.fieldType=Is longint:K8:6)
	
End if 

$number:=$structure.tableNumber("UNIT_0")

If (Asserted:C1132($structure.success))
	
	$o:=$structure.fieldDefinition($number; "r_1.Field_1_2")
	
	If (Asserted:C1132($structure.success))
		
		ASSERT:C1129($o.tableNumber=$structure.tableNumber("UNIT_1"))
		ASSERT:C1129($o.tableName="UNIT_1")
		
		ASSERT:C1129($o.fieldNumber=2)
		ASSERT:C1129($o.name="Field_1_2")
		
		ASSERT:C1129($o.path="r_1.Field_1_2")
		
		ASSERT:C1129($o.type=3)
		ASSERT:C1129($o.fieldType=Is integer:K8:5)
		
	End if 
	
	$o:=$structure.fieldDefinition("UNIT_0"; "r_2.Field_1_2")
	
	If (Asserted:C1132($structure.success))
		
		ASSERT:C1129($o.tableNumber=$structure.tableNumber("UNIT_1"))
		ASSERT:C1129($o.tableName="UNIT_1")
		
		ASSERT:C1129($o.fieldNumber=2)
		ASSERT:C1129($o.name="Field_1_2")
		
		ASSERT:C1129($o.path="r_2.Field_1_2")
		
		ASSERT:C1129($o.type=3)
		ASSERT:C1129($o.fieldType=Is integer:K8:5)
		
	End if 
	
	$o:=$structure.fieldDefinition($number; "r_1.r_1_2.Field_2_3")
	
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

err_FINALLY
