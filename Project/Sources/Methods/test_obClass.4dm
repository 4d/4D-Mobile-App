//%attributes = {}
var $t : Text
var $o : Object
var $c : Collection
var $file : 4D:C1709.File
var $ob : cs:C1710.ob

err_TRY


//MARK: - new()
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

ASSERT:C1129($ob.findPropertyValues("dummy").length=0)

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
ASSERT:C1129(JSON Parse:C1218("[1,3,11,13,11,13,11,13,11,13]").equal($ob.findPropertyValues("uuid")))

$ob.remove("uuid")
ASSERT:C1129($ob.inHierarchy("uuid")=Null:C1517)
ASSERT:C1129($ob.findPropertyValues("uuid").length=0)

//MARK: - setContent()
$ob.setContent()
ASSERT:C1129($ob.isEmpty)
ASSERT:C1129($ob.isObject)
ASSERT:C1129(Not:C34($ob.isCollection))
ASSERT:C1129($ob.count=0)

//MARK: - assign()
$ob.assign(New object:C1471("a"; 1))
ASSERT:C1129($ob.get().a=1; "Must be created")

$ob.assign(New object:C1471("b"; 2))
ASSERT:C1129($ob.get().a=1; "Must be unchanged")
ASSERT:C1129($ob.get().b=2; "Must be created")

$ob.assign(New object:C1471("a"; 2; "b"; 3))
ASSERT:C1129($ob.get().a=2; "Must be overriden")
ASSERT:C1129($ob.get().b=3; "Must be overriden")

$ob.assign()
ASSERT:C1129($ob.get()=Null:C1517; "Must be overriden")

$ob.assign(New object:C1471("a"; 1; "b"; 2))
ASSERT:C1129($ob.get().a=1; "Must be created")
ASSERT:C1129($ob.get().b=2; "Must be created")

$ob.assign(Null:C1517)
ASSERT:C1129($ob.get()=Null:C1517; "Must be overriden")

//MARK: - merge()
$o:=New object:C1471(\
"build"; False:C215; \
"run"; False:C215; \
"sdk"; "iphonesimulator"; \
"template"; "list"; \
"testing"; False:C215; \
"caller"; 0)

$ob.setContent($o)

var $o2 : Object
$o2:=New object:C1471(\
"build"; True:C214; \
"caller"; 8858; \
"create"; Pi:K30:1)

$ob.merge($o2)

$o:=$ob.get()

For each ($t; $o2)
	
	ASSERT:C1129($o2[$t]#Null:C1517)
	
	Case of 
			
			//________________________________________
		: (Position:C15($t; "create")>0)
			
			ASSERT:C1129($o2[$t]=$o[$t]; "Must be created")
			
			//________________________________________
		: (Split string:C1554("build|caller"; "|").indexOf($t)#-1)
			
			ASSERT:C1129($o2[$t]#$o[$t]; "Must not be overridden")
			
			//________________________________________
	End case 
End for each 

//MARK: - coalesce()
$o:=New object:C1471(\
"null"; Null:C1517; \
"test"; New object:C1471("b"; 1))
$ob.setContent($o)
ASSERT:C1129(JSON Stringify:C1217($ob.coalesce())=JSON Stringify:C1217(New object:C1471("b"; 1)))

$o:=New object:C1471(\
"null"; Null:C1517; \
"test"; New collection:C1472(1; 2; New object:C1471("b"; 1); 4; 5))
$ob.setContent($o)
ASSERT:C1129(New collection:C1472(1; 2; New object:C1471("b"; 1); 4; 5).equal($ob.coalesce()))

$o:=New object:C1471(\
"a"; Null:C1517; "b"; New object:C1471("aa"; Null:C1517; "hh"; Pi:K30:1); \
"c"; Null:C1517; "d"; New collection:C1472(); \
"e"; Null:C1517; "f"; True:C214; \
"g"; Null:C1517; "h"; Pi:K30:1; \
"i"; Null:C1517; "j"; "hello world")
$ob.setContent($o)
$ob.coalescence()
ASSERT:C1129($ob.count=5)

$o:=$ob.get()

ASSERT:C1129($o.a=Null:C1517)
ASSERT:C1129($o.c=Null:C1517)
ASSERT:C1129($o.e=Null:C1517)
ASSERT:C1129($o.g=Null:C1517)
ASSERT:C1129($o.i=Null:C1517)

ASSERT:C1129($o.b.aa=Null:C1517)
ASSERT:C1129($o.b.hh#Null:C1517)

ASSERT:C1129($o.d#Null:C1517)
ASSERT:C1129($o.f#Null:C1517)
ASSERT:C1129($o.h#Null:C1517)
ASSERT:C1129($o.j#Null:C1517)

//MARK: - deepMerge()
$o:=New object:C1471(\
"a"; New object:C1471("b"; 1); \
"test"; New collection:C1472(1; 2; New object:C1471("b"; 1); 4; 5))
$ob.setContent(New object:C1471)
$ob.deepMerge($o)
ASSERT:C1129(JSON Stringify:C1217($ob.get())=JSON Stringify:C1217($o))

$o:=New object:C1471(\
"a"; New object:C1471("c"; Pi:K30:1))
$ob.deepMerge($o)
$o:=$ob.get()
ASSERT:C1129($o.a#Null:C1517)
ASSERT:C1129($o.a.b=1)
ASSERT:C1129($o.a.c=Pi:K30:1)
ASSERT:C1129($o.test[0]=1)
ASSERT:C1129($o.test[1]=2)
ASSERT:C1129($o.test[2].b=1)
ASSERT:C1129($o.test[3]=4)
ASSERT:C1129($o.test[4]=5)

$o:=New object:C1471(\
"test"; New collection:C1472("c"; Pi:K30:1))
$ob.deepMerge($o)


//MARK: - clear()
$ob.clear()

ASSERT:C1129($ob.isEmpty)
ASSERT:C1129($ob.isObject)
ASSERT:C1129(Not:C34($ob.isCollection))
ASSERT:C1129($ob.count=0)
ASSERT:C1129($ob.entries().length=0)
ASSERT:C1129($ob.isEqual(New object:C1471()))

err_FINALLY

BEEP:C151
