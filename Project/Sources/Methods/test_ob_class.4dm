//%attributes = {}
var $t : Text
var $o : Object
var $c : Collection
var $file : 4D:C1709.File
var $ob; $obj2 : cs:C1710.ob


//MARK: - ew()
$ob:=cs:C1710.ob.new()
ASSERT:C1129($ob.isEmpty)
ASSERT:C1129($ob.isObject)
ASSERT:C1129(Not:C34($ob.isCollection))
ASSERT:C1129($ob.count=0)
ASSERT:C1129($ob.get()#Null:C1517)

$ob:=cs:C1710.ob.new(New collection:C1472(1; 2; 3))
ASSERT:C1129($ob.isEmpty)
ASSERT:C1129($ob.isObject)
ASSERT:C1129(Not:C34($ob.isCollection))
ASSERT:C1129($ob.count=0)
ASSERT:C1129($ob.errors.length>0)
ASSERT:C1129($ob.get()=Null:C1517)

//MARK: - clear()
$ob.clear()
ASSERT:C1129($ob.isEmpty)
ASSERT:C1129($ob.isObject)
ASSERT:C1129(Not:C34($ob.isCollection))
ASSERT:C1129($ob.count=0)
ASSERT:C1129($ob.errors.length=0)

//MARK: - setContent()
$o:=New object:C1471
$o.one:=New object:C1471(\
"name"; "one"; \
"value"; 1)
$o.two:=New object:C1471(\
"name"; "two"; \
"value"; 2)
$o.three:=New object:C1471(\
"name"; "three"; \
"value"; 3)
$o.deep:=OB Copy:C1225($o)
$o.deep.three.uuid:=8858
$o.deep.one.null:=Null:C1517
$o.scalar:="hello world"

$ob.setContent($o)
ASSERT:C1129(Not:C34($ob.isEmpty))
ASSERT:C1129($ob.isObject)
ASSERT:C1129(Not:C34($ob.isCollection))
ASSERT:C1129($ob.count=5)
ASSERT:C1129($ob.entries().length=5)
ASSERT:C1129($ob.isEqual($o))

$ob.clear()

$ob:=cs:C1710.ob.new($o)
ASSERT:C1129(Not:C34($ob.isEmpty))
ASSERT:C1129($ob.isObject)
ASSERT:C1129(Not:C34($ob.isCollection))
ASSERT:C1129($ob.count=5)
ASSERT:C1129($ob.entries().length=5)
ASSERT:C1129($ob.isEqual($o))

//MARK: - inHierarchy()
ASSERT:C1129($ob.isEqual($ob.inHierarchy("one")))
ASSERT:C1129($ob.inHierarchy("uuid")#Null:C1517)
ASSERT:C1129($ob.inHierarchy("dummy")=Null:C1517)

//MARK: - exists()

ASSERT:C1129($ob.exists("one"))
ASSERT:C1129($ob.exists("two.value"))
ASSERT:C1129($ob.exists("deep.two.value"))
ASSERT:C1129($ob.exists("deep.three.uuid"))
ASSERT:C1129($ob.exists("deep.one.null"))

ASSERT:C1129($ob.exists(New collection:C1472("one")))
ASSERT:C1129($ob.exists(New collection:C1472("two"; "value")))
ASSERT:C1129($ob.exists(New collection:C1472("deep"; "two"; "value")))
ASSERT:C1129($ob.exists(New collection:C1472("deep"; "three"; "uuid")))
ASSERT:C1129($ob.exists(New collection:C1472("deep"; "one"; "null")))

//MARK: - findPropertyValues()
$o.one.uuid:=1
$o.two.uuid:=2
$o.three.uuid:=3
$o.deep.one.uuid:=11
$o.deep.two.uuid:=12
$o.deep.three.uuid:=13
ASSERT:C1129(New collection:C1472(1; 2; 3; 11; 12; 13).equal($ob.findPropertyValues("uuid")))

//MARK: - toCollection()
$c:=$ob.toCollection()
ASSERT:C1129($c.length=$ob.count)

$c:=$ob.toCollection($o.deep)
ASSERT:C1129($c.length=3)

//MARK: - Stringify()
$t:=$ob.stringify()
ASSERT:C1129($t=$ob.stringify(True:C214))
ASSERT:C1129(Not:C34($t=$ob.stringify(False:C215)))

$ob.prettyPrint:=False:C215
$t:=$ob.stringify()
ASSERT:C1129($t=$ob.stringify(False:C215))
ASSERT:C1129(Not:C34($t=$ob.stringify(True:C214)))
$ob.prettyPrint:=True:C214

//MARK: - Save()
$file:=Folder:C1567(fk desktop folder:K87:19).file("DEV/test_ob.json")
$ob.save($file)

// Compare with loaded from file object
ASSERT:C1129($ob.isEqual(cs:C1710.ob.new($file).content))

//$ob.content.coll:=New collection(OB Copy($o.deep); OB Copy($o.deep); OB Copy($o.deep))

//MARK: - set()
$ob.set("coll"; New collection:C1472(OB Copy:C1225($o.deep); OB Copy:C1225($o.deep); OB Copy:C1225($o.deep)))
ASSERT:C1129($ob.count=6)

//MARK: - remove()
$ob.remove("two")
ASSERT:C1129($ob.toCollection().length=5)
ASSERT:C1129($ob.toCollection($ob.get().deep).length=2)
ASSERT:C1129($ob.inHierarchy("two")=Null:C1517)
ASSERT:C1129(JSON Parse:C1218("[11,13,1,3,11,13,11,13,11,13]").equal($ob.findPropertyValues("uuid")))

$ob.remove("uuid")
ASSERT:C1129($ob.inHierarchy("uuid")=Null:C1517)
ASSERT:C1129($ob.findPropertyValues("uuid").length=0)

//MARK: - setContent()
$ob.setContent()
ASSERT:C1129($ob.isEmpty)
ASSERT:C1129($ob.isObject)
ASSERT:C1129(Not:C34($ob.isCollection))
ASSERT:C1129($ob.count=0)

