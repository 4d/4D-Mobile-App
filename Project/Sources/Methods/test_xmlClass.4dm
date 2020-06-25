//%attributes = {}
C_TEXT:C284($node;$t)
C_OBJECT:C1216($o)
C_COLLECTION:C1488($c)

TRY

//======================================================================================
// Create from scratch
var $xml : cs:C1710.xml
$xml:=cs:C1710.xml.new().new()
ASSERT:C1129($xml.success;".new()")

// Export to an internal variable
$t:=$xml.getText()  // Must autoclose
ASSERT:C1129($xml.success;".getText()")
ASSERT:C1129($t="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\" ?>\r<root/>\r")

// Must failed
$xml.close()
ASSERT:C1129(Not:C34($xml.success);".close()")

//======================================================================================
// Create by parsing
$xml:=cs:C1710.xml.new("<html><header></header><body></body></html>")
ASSERT:C1129($xml.success;".new(\"<html><header></header><body></body></html>\")")
$xml.close()

//======================================================================================
// Create from file
$o:=Folder:C1567(fk resources folder:K87:11).file("templates/form/list/Simple Table/Sources/Forms/Tables/___TABLE___/___TABLE___ListForm.storyboard")
$xml:=cs:C1710.xml.new($o)
ASSERT:C1129($xml.success;".new($file)")

$node:=$xml.findByXPath("/document/scenes")
ASSERT:C1129($xml.success;".findByXPath(\"/document/scenes\")")
ASSERT:C1129($node#"00000000000000000000000000000000")

// All elements with the attribute "userLabel"
$c:=$xml.findByAttribute($node;"userLabel")
ASSERT:C1129($c.length=5;".findByAttribute()")

// All elements with the attribute "userLabel='List Form'"
$c:=$xml.findByAttribute($node;"userLabel";"List Form")
ASSERT:C1129($c.length=1;".findByAttribute()")

$c:=$xml.findByAttribute($node;"key";"backgroundColor")
ASSERT:C1129($c.length=5;".findByAttribute()")

// All "color" elements with the attribute "key='backgroundColor'"
$c:=$xml.findByAttribute($node;"key";"backgroundColor";"color")
ASSERT:C1129($c.length=5;".findByAttribute()")

$c:=$xml.findByAttribute($node;"value")
ASSERT:C1129($c.length=9;".findByAttribute()")

$c:=$xml.findByAttribute($node;"value";"___SEARCHABLE_FIELD___")
ASSERT:C1129($c.length=1;".findByAttribute()")

$c:=$xml.findByAttribute($node;"value";"hello")
ASSERT:C1129($c.length=0;".findByAttribute()")
ASSERT:C1129(Not:C34($xml.success);".findByAttribute()")

$node:=$xml.findById("Dxc-Bl-At2")
ASSERT:C1129($xml.success;".findById()")

$c:=$xml.findByName("scene")
ASSERT:C1129($xml.success;".findByName()")
ASSERT:C1129($c.length=3;".findByName()")

$xml.close()

//======================================================================================
$xml:=cs:C1710.xml.new().new()
ASSERT:C1129($xml.success;".new()")

$node:=DOM Create XML element:C865($xml.root;"document";\
"title";"hello world";\
"author";"me";\
"year";1958;\
"published";True:C214;\
"date";!1958-08-08!)

$o:=$xml.getAttributes($node)
ASSERT:C1129($o#Null:C1517;".getAttributes()")
ASSERT:C1129($o.title#Null:C1517;".getAttributes()")
ASSERT:C1129($o.title="hello world";".getAttributes()")
ASSERT:C1129($o.author#Null:C1517;".getAttributes()")
ASSERT:C1129($o.author="me";".getAttributes()")
ASSERT:C1129($o.year#Null:C1517;".getAttributes()")
ASSERT:C1129($o.year=1958;".getAttributes()")
ASSERT:C1129($o.published#Null:C1517;".getAttributes()")
ASSERT:C1129($o.published=True:C214;".getAttributes()")
ASSERT:C1129($o.date#Null:C1517;".getAttributes()")
ASSERT:C1129($o.date=!1958-08-08!;".getAttributes()")

$c:=$xml.getAttributesCollection($node)
ASSERT:C1129($c.length=5;".attributesToCollection()")
$o:=$c.query("key=title").pop()
ASSERT:C1129($o#Null:C1517;".attributesToCollection()")
ASSERT:C1129($o.value="hello world";".attributesToCollection()")
$o:=$c.query("key=author").pop()
ASSERT:C1129($o#Null:C1517;".attributesToCollection()")
ASSERT:C1129($o.value="me";".attributesToCollection()")
$o:=$c.query("key=year").pop()
ASSERT:C1129($o#Null:C1517;".attributesToCollection()")
ASSERT:C1129($o.value=1958;".attributesToCollection()")
$o:=$c.query("key=published").pop()
ASSERT:C1129($o#Null:C1517;".attributesToCollection()")
ASSERT:C1129($o.value=True:C214;".attributesToCollection()")
$o:=$c.query("key=date").pop()
ASSERT:C1129($o#Null:C1517;".attributesToCollection()")
ASSERT:C1129($o.value=!1958-08-08!;".attributesToCollection()")

ASSERT:C1129($xml.getAttribute($node;"title")="hello world";".getAttribute()")
ASSERT:C1129($xml.getAttribute($node;"author")="me";".getAttribute()")
ASSERT:C1129($xml.getAttribute($node;"date")=!1958-08-08!;".getAttribute()")

// Must failed
$t:=$xml.getAttribute($node;"unknown")
ASSERT:C1129(Not:C34($xml.success);"getAttribute()")

$xml.setAttribute($node;"author";"him")
ASSERT:C1129($xml.success;".setAttribute()")
$c:=$xml.getAttributesCollection($node)
ASSERT:C1129($c.length=5;".attributesToCollection()")
$o:=$c.query("key=author").pop()
ASSERT:C1129($o#Null:C1517;".attributesToCollection()")
ASSERT:C1129($o.value="him";".attributesToCollection()")
$t:=$xml.getAttribute($node;"author")
ASSERT:C1129($xml.success;".setAttribute()")
ASSERT:C1129($t="him";".getAttribute()")

FINALLY

BEEP:C151