//%attributes = {}

var $object : Object
$object:=Null:C1517
ASSERT:C1129(let(->$object; Formula:C1597(New object:C1471("success"; True:C214)); Formula:C1597($1.success)))
ASSERT:C1129($object#Null:C1517)

$object:=Null:C1517
ASSERT:C1129(Not:C34(let(->$object; Formula:C1597(New object:C1471("success"; False:C215)); Formula:C1597($1.success))))
ASSERT:C1129($object#Null:C1517)
