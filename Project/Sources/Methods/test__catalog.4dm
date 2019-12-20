//%attributes = {}
C_BOOLEAN:C305($b)
C_OBJECT:C1216($o;$datastore)

COMPONENT_INIT 

TRY 

  //_____________________________________________________________
$o:=_catalog ("UNIT_1")
ASSERT:C1129($o.success)
ASSERT:C1129($o.result.infos#Null:C1517)
ASSERT:C1129($o.result.infos.name="UNIT_1")
ASSERT:C1129($o.result.infos.primaryKey="ID")
ASSERT:C1129($o.result.infos.tableNumber=11)
ASSERT:C1129($o.result.fields#Null:C1517)
ASSERT:C1129($o.result.fields.length=6)

  //_____________________________________________________________
$o:=_catalog ("HELLO WORLD")
ASSERT:C1129(Not:C34($o.success))
ASSERT:C1129($o.result=Null:C1517)
ASSERT:C1129($o.errors.length=1)
ASSERT:C1129($o.errors[0]="Table not found \"HELLO WORLD\"")

  //_____________________________________________________________
$o:=_catalog .table("UNIT_1";"storage")
ASSERT:C1129($o.success)
ASSERT:C1129($o.result.infos#Null:C1517)
ASSERT:C1129($o.result.infos.name="UNIT_1")
ASSERT:C1129($o.result.infos.primaryKey="ID")
ASSERT:C1129($o.result.infos.tableNumber=11)
ASSERT:C1129($o.result.fields#Null:C1517)
ASSERT:C1129($o.result.fields.length=3)

  //_____________________________________________________________
$datastore:=_catalog .datastore

$o:=_catalog ("UNIT_1";$datastore)
ASSERT:C1129($o.success)
ASSERT:C1129($o.result.infos#Null:C1517)
ASSERT:C1129($o.result.infos.name="UNIT_1")
ASSERT:C1129($o.result.infos.primaryKey="ID")
ASSERT:C1129($o.result.infos.tableNumber=11)
ASSERT:C1129($o.result.fields#Null:C1517)
ASSERT:C1129($o.result.fields.length=6)

$o:=_catalog ("UNIT_1";$datastore).table("UNIT_1";"storage")
ASSERT:C1129($o.success)
ASSERT:C1129($o.result.infos#Null:C1517)
ASSERT:C1129($o.result.infos.name="UNIT_1")
ASSERT:C1129($o.result.infos.primaryKey="ID")
ASSERT:C1129($o.result.infos.tableNumber=11)
ASSERT:C1129($o.result.fields#Null:C1517)
ASSERT:C1129($o.result.fields.length=3)

$o:=_catalog ("UNIT_1";$datastore).table("UNIT_1";"relatedEntities")
ASSERT:C1129($o.success)
ASSERT:C1129($o.result.infos#Null:C1517)
ASSERT:C1129($o.result.infos.name="UNIT_1")
ASSERT:C1129($o.result.infos.primaryKey="ID")
ASSERT:C1129($o.result.infos.tableNumber=11)
ASSERT:C1129($o.result.fields#Null:C1517)
ASSERT:C1129($o.result.fields.length=2)

$o:=_catalog ("UNIT_1";$datastore).table("UNIT_1";"relatedEntity")
ASSERT:C1129($o.success)
ASSERT:C1129($o.result.infos#Null:C1517)
ASSERT:C1129($o.result.infos.name="UNIT_1")
ASSERT:C1129($o.result.infos.primaryKey="ID")
ASSERT:C1129($o.result.infos.tableNumber=11)
ASSERT:C1129($o.result.fields#Null:C1517)
ASSERT:C1129($o.result.fields.length=1)


FINALLY 