//%attributes = {}

TRY

var $object : Object
$object:=Null:C1517
ASSERT:C1129(let(->$object; Formula:C1597(New object:C1471("success"; True:C214)); Formula:C1597($1.success)))
ASSERT:C1129($object#Null:C1517)

$object:=Null:C1517
ASSERT:C1129(Not:C34(let(->$object; Formula:C1597(New object:C1471("success"; False:C215)); Formula:C1597($1.success))))
ASSERT:C1129($object#Null:C1517)


$object:=Null:C1517
ASSERT:C1129(let(->$object; New object:C1471("success"; True:C214); Formula:C1597($1.success)))
ASSERT:C1129($object#Null:C1517)

$object:=Null:C1517
ASSERT:C1129(Not:C34(let(->$object; New object:C1471("success"; False:C215); Formula:C1597($1.success))))
ASSERT:C1129($object#Null:C1517)

var $integer : Integer
ASSERT:C1129(let(->$integer; 5; Formula:C1597($1=5)))
ASSERT:C1129($integer=5)

ASSERT:C1129(Not:C34(let(->$integer; 6; Formula:C1597($1#6))))
ASSERT:C1129($integer=6)

FINALLY

BEEP:C151
