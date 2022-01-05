//%attributes = {}
var $t : Text
var $o : Object
var $c : Collection
var $file : 4D:C1709.File
var $obj : cs:C1710.ob

$obj:=cs:C1710.ob.new()
ASSERT:C1129($obj.isEmpty)
ASSERT:C1129($obj.isObject)
ASSERT:C1129(Not:C34($obj.isCollection))

$o:=New object:C1471
$o.one:=New object:C1471("name"; "one"; "value"; 1)
$o.two:=New object:C1471("name"; "two"; "value"; 2)
$o.three:=New object:C1471("name"; "three"; "value"; 3)
$o.deep:=OB Copy:C1225($o)
$o.scalar:="hello world"

$obj.setContent($o)
ASSERT:C1129(Not:C34($obj.isEmpty))
ASSERT:C1129($obj.isObject)
ASSERT:C1129(Not:C34($obj.isCollection))

$obj.clear()
ASSERT:C1129($obj.isEmpty)
ASSERT:C1129($obj.isObject)
ASSERT:C1129(Not:C34($obj.isCollection))

$obj:=cs:C1710.ob.new($o)
ASSERT:C1129(Not:C34($obj.isEmpty))
ASSERT:C1129($obj.isObject)
ASSERT:C1129(Not:C34($obj.isCollection))

$c:=$obj.toCollection()

$c:=$obj.toCollection($o.deep)

$t:=$obj.stringify()
$t:=$obj.stringify(False:C215)
$t:=$obj.stringify(True:C214)

$obj.prettyPrint:=False:C215
$t:=$obj.stringify()

$obj.prettyPrint:=True:C214
$file:=Folder:C1567(fk desktop folder:K87:19).file("DEV/test_ob.json")
$obj.save($file)

//$out:=ob_removeProperty($o; "two")

$obj.content.coll:=New collection:C1472(OB Copy:C1225($o.deep); OB Copy:C1225($o.deep); OB Copy:C1225($o.deep))
$obj.remove("two")

$obj.setContent()
ASSERT:C1129($obj.isEmpty)
ASSERT:C1129($obj.isObject)
ASSERT:C1129(Not:C34($obj.isCollection))

