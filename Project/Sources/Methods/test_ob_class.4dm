//%attributes = {}
var $o : cs:C1710.ob

TRY

$o:=cs:C1710.ob.new()
ASSERT:C1129(OB Is empty:C1297($o.content))

$o:=cs:C1710.ob.new(New object:C1471)
ASSERT:C1129(OB Is empty:C1297($o.content))

$o:=cs:C1710.ob.new(Null:C1517)
ASSERT:C1129(Value type:C1509($o.content)=Is null:K8:31)

$o:=cs:C1710.ob.new(New object:C1471("hello"; "world"))
ASSERT:C1129(Not:C34(OB Is empty:C1297($o.content)))
ASSERT:C1129($o.content.hello="world")
ASSERT:C1129($o.checkPath("hello"))


$o:=ob_createPath(New object:C1471; "level1.level2.level3")
ASSERT:C1129($o.level1#Null:C1517)
ASSERT:C1129($o.level1.level2#Null:C1517)
ASSERT:C1129($o.level1.level2.level3#Null:C1517)

$o:=cs:C1710.ob.new().createPath("level1.level2.level3")
ASSERT:C1129($o.level1#Null:C1517)
ASSERT:C1129($o.level1.level2#Null:C1517)
ASSERT:C1129($o.level1.level2.level3#Null:C1517)

$o:=cs:C1710.ob.new().createPath(New collection:C1472("level1"; "level2"; "level3"))
ASSERT:C1129($o.level1#Null:C1517)
ASSERT:C1129($o.level1.level2#Null:C1517)
ASSERT:C1129($o.level1.level2.level3#Null:C1517)

FINALLY
