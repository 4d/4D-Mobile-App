//%attributes = {}
C_LONGINT:C283($Lon_table)
C_OBJECT:C1216($o; $Obj_db)

COMPONENT_INIT

err_TRY

$o:=_o_db.exposedDatastore()

If (Asserted:C1132($o.success; "db .exposedDatastore()"))
	
	ASSERT:C1129($o.result#Null:C1517; "db .exposedDatastore()")
	ASSERT:C1129($o.result.length=14; "db .exposedDatastore()")
	ASSERT:C1129($o.result[0].fields.length=14; "db .exposedDatastore()")
	
End if 

// Filter objects & blobs
$o:=_o_db("object;blob").exposedDatastore()

If (Asserted:C1132($o.success; "db .exposedDatastore()"))
	
	ASSERT:C1129($o.result#Null:C1517; "db .exposedDatastore()")
	ASSERT:C1129($o.result.length=14; "db .exposedDatastore()")
	ASSERT:C1129($o.result[0].fields.length=12; "db .exposedDatastore()")
	
End if 

$Obj_db:=_o_db("object;blob")
ASSERT:C1129($Obj_db[""]="db"; "db (\"object;blob\")")
ASSERT:C1129($Obj_db.datastore=Null:C1517; "db (\"object;blob\")")
ASSERT:C1129(New collection:C1472("object"; "blob").equal($Obj_db.exclude); "db (\"object;blob\")")

$o:=$Obj_db.table("Commands")

ASSERT:C1129($Obj_db.warnings#Null:C1517)
ASSERT:C1129($Obj_db.warnings.length=1)
ASSERT:C1129($Obj_db.warnings[0]="Name conflict for \"duplicate\"")

If (Asserted:C1132($o.success; "table(\"Commands\")"))
	
	ASSERT:C1129($o.result#Null:C1517; "table(\"Commands\")")
	ASSERT:C1129($o.result.name="Commands"; "table(\"Commands\")")
	ASSERT:C1129($o.result.tableNumber=1; "table(\"Commands\")")
	ASSERT:C1129($o.result.primaryKey="ID"; "table(\"Commands\")")
	ASSERT:C1129($o.result.fields#Null:C1517; "table(\"Commands\")")
	ASSERT:C1129($o.result.fields.length=10; "table(\"Commands\")")
	ASSERT:C1129($o.result.fields.query("kind = relatedEntity").length=1)
	
End if 

$o:=$Obj_db.table(5)

If (Asserted:C1132($o.success; "table(5)"))
	
	ASSERT:C1129($o.result#Null:C1517; "table(5)")
	ASSERT:C1129($o.result.name="ALL_TYPES"; "table(5)")
	ASSERT:C1129($o.result.tableNumber=5; "table(5)")
	ASSERT:C1129($o.result.primaryKey="ID"; "table(5)")
	ASSERT:C1129($o.result.fields#Null:C1517; "table(5)")
	ASSERT:C1129($o.result.fields.length=12; "table(5)")
	
End if 

$o:=$Obj_db.table(55)

If (Asserted:C1132(Not:C34($o.success); "table(55)"))
	
	ASSERT:C1129($o.errors.length=1; "table(55)")
	ASSERT:C1129($o.errors[0]="Table not found: #55"; "table(55)")
	
End if 

$o:=$Obj_db.table("hello")

If (Asserted:C1132(Not:C34($o.success); "table(\"hello\")"))
	
	ASSERT:C1129($o.errors.length=1; "table(\"hello\")")
	ASSERT:C1129($o.errors[0]="Table not found: \"hello\""; "table(\"hello\")")
	
End if 

$o:=$Obj_db.table(13)

If (Asserted:C1132($o.success; "table(13)"))
	
	ASSERT:C1129($o.result.fields.query("kind = relatedEntities").length=1)
	
End if 

$o:=$Obj_db.field("Commands"; "theme")

If (Asserted:C1132($o.success))
	
	ASSERT:C1129($o.result.fieldNumber=Null:C1517)
	ASSERT:C1129($o.result.name="theme")
	ASSERT:C1129($o.result.kind="relatedEntity")
	ASSERT:C1129($o.result.inverseName="commands")
	ASSERT:C1129($o.result.relatedDataClass="Themes")
	
End if 

$Lon_table:=Num:C11($Obj_db.table("UNIT_0").result.tableNumber)

If (Asserted:C1132($Lon_table#0))
	
	$o:=$Obj_db.field($Lon_table; "ID")
	
	If (Asserted:C1132($o.success))
		
		ASSERT:C1129($o.result.fieldNumber=1)
		ASSERT:C1129($o.result.autoFilled)
		ASSERT:C1129($o.result.unique)
		ASSERT:C1129($o.result.type="number")
		ASSERT:C1129($o.result.fieldType=9)
		ASSERT:C1129($o.result.name="ID")
		
	End if 
	
	$o:=$Obj_db.field($Lon_table; 1)
	
	If (Asserted:C1132($o.success))
		
		ASSERT:C1129($o.result.fieldNumber=1)
		ASSERT:C1129($o.result.autoFilled)
		ASSERT:C1129($o.result.unique)
		ASSERT:C1129($o.result.type="number")
		ASSERT:C1129($o.result.fieldType=9)
		ASSERT:C1129($o.result.name="ID")
		
	End if 
End if 

err_FINALLY