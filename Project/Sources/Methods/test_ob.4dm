//%attributes = {}
C_TEXT:C284($t)
C_OBJECT:C1216($o;$o1;$o2;$ob)
C_COLLECTION:C1488($c)

TRY 

  // === === === === === === === === === === === === === === === === === === === === constructor()
$ob:=ob ("{}")
ASSERT:C1129($ob.isObject())
ASSERT:C1129(Not:C34($ob.isCollection()))
ASSERT:C1129($ob.isEmpty())
ASSERT:C1129(Not:C34($ob.testPath("dummy")))

$ob:=ob 
ASSERT:C1129($ob.isObject())
ASSERT:C1129(Not:C34($ob.isCollection()))
ASSERT:C1129($ob.isEmpty())
ASSERT:C1129(Not:C34($ob.testPath("dummy")))

  // === === === === === === === === === === === === === === === === === === === === createPath(), testPath(), isEmpty()
$o:=$ob.createPath("level1.level2.level3").contents
ASSERT:C1129($o.level1#Null:C1517)
ASSERT:C1129($o.level1.level2#Null:C1517)
ASSERT:C1129($o.level1.level2.level3#Null:C1517)
ASSERT:C1129($ob.testPath("level1.level2.level3"))
ASSERT:C1129(Not:C34($ob.isEmpty()))

$o:=$ob.createPath("server.authentication";Is collection:K8:32).contents
ASSERT:C1129(Value type:C1509($o.server.authentication)=Is collection:K8:32)
ASSERT:C1129($o.server.authentication.length=0)

$o:=$ob.createPath("server.authentication";Is collection:K8:32;New collection:C1472(1;2;Null:C1517;3;4)).contents
ASSERT:C1129($ob.testPath("server.authentication"))
ASSERT:C1129(Not:C34($ob.testPath("server.dummy")))
ASSERT:C1129(Value type:C1509($o.server.authentication)=Is collection:K8:32)
ASSERT:C1129($o.server.authentication.length=5)

$o:=$ob.createPath("server.urls.production";Is text:K8:3;"hello world").contents
ASSERT:C1129(Value type:C1509($o.server.urls.production)=Is text:K8:3)
ASSERT:C1129(String:C10($o.server.urls.production)="hello world")

  // === === === === === === === === === === === === === === === === === === === === copy(), equal()
$o1:=$ob.copy()
ASSERT:C1129($ob.equal($o1);"Must be equal")
ASSERT:C1129(Not:C34($ob.equal(New object:C1471));"Must not be equal")

OB REMOVE:C1226($o1;"server")
ASSERT:C1129(Not:C34($ob.equal($o1));"Must not be equal")

  // === === === === === === === === === === === === === === === === === === === === isCollection(), isObject(), isEmpty()
$ob.set(New collection:C1472)
ASSERT:C1129($ob.isCollection();"Must be true")
ASSERT:C1129(Not:C34($ob.isObject());"Must be false")
ASSERT:C1129($ob.isEmpty();"Must be true")

$c:=New collection:C1472(New object:C1471("a";New object:C1471("b";1);"test";New collection:C1472(1;2;New object:C1471("b";1);4;5)))

$ob.set($c)
ASSERT:C1129($ob.isCollection();"Must be true")
ASSERT:C1129(Not:C34($ob.isObject());"Must be false")
ASSERT:C1129(Not:C34($ob.isEmpty());"Must be false")

$ob.set($c[0])
ASSERT:C1129($ob.isObject();"Must be true")
ASSERT:C1129(Not:C34($ob.isCollection());"Must be false")

  // === === === === === === === === === === === === === === === === === === === === getByPath()
ASSERT:C1129($ob.getByPath("a.b")=1)
ASSERT:C1129($ob.getByPath("test[0]")=1)
ASSERT:C1129($ob.getByPath("test[2].b")=1)

  // === === === === === === === === === === === === === === === === === === === === clone()
$ob.set(New object:C1471)
$o:=New object:C1471("uuid";"hello world";"level";New collection:C1472(New object:C1471("uuid";Generate UUID:C1066)))
$ob.clone($o)
ASSERT:C1129(JSON Stringify:C1217($ob.contents)=JSON Stringify:C1217($o))


  // === === === === === === === === === === === === === === === === === === === assign()
$ob.set(New object:C1471)
$ob.assign(New object:C1471("a";1))
ASSERT:C1129($ob.contents.a=1;"Must be created")

$ob.assign(New object:C1471("b";2))
ASSERT:C1129($ob.contents.a=1;"Must be unchanged")
ASSERT:C1129($ob.contents.b=2;"Must be created")

$ob.set(New object:C1471("a";1;"b";1))
$o:=New object:C1471("b";2)
$ob.assign($o)
ASSERT:C1129($ob.contents.a=1;"Must be unchanged")
ASSERT:C1129($ob.contents.b=2;"Must be overriden")

$ob.set(New object:C1471("a";1;"b";1;"c";1))
$o1:=New object:C1471("b";2;"c";2)
$o2:=New object:C1471("c";3)
$ob.assign($o1;$o2)
ASSERT:C1129($ob.contents.a=1;"Must be unchanged")
ASSERT:C1129($ob.contents.b=2;"Must be overriden")
ASSERT:C1129($ob.contents.c=3;"Must be overriden")

$ob.set(New object:C1471("a";1;"b";1;"c";1))
$o1:=New object:C1471("b";2;"c";2)
$o2:=New object:C1471("c";Null:C1517)
$ob.assign($o1;$o2)
ASSERT:C1129($ob.contents.a=1;"Must be unchanged")
ASSERT:C1129($ob.contents.b=2;"Must be overriden")
ASSERT:C1129($ob.contents.c=2;"Null must not be ignored")

$ob.set(New object:C1471("a";1;"b";1;"c";1))
$ob.assign()
ASSERT:C1129($ob.contents.a=1;"Must be unchanged")
ASSERT:C1129($ob.contents.b=1;"Must be unchanged")
ASSERT:C1129($ob.contents.c=1;"Must be unchanged")

  // === === === === === === === === === === === === === === === === === === === === merge()
$o:=New object:C1471("build";False:C215;"run";False:C215;"sdk";"iphonesimulator";"template";"list";"testing";False:C215;"caller";0)
$ob.set($o)
$o2:=New object:C1471("build";True:C214;"caller";8858;"create";Pi:K30:1)
$ob.merge($o2)
$o:=$ob.contents
For each ($t;$o2)
	ASSERT:C1129($o2[$t]#Null:C1517)
	Case of 
		: (Position:C15($t;"create")>0)
			ASSERT:C1129($o2[$t]=$o[$t];"Must be created")
		: (Split string:C1554("build|caller";"|").indexOf($t)#-1)
			ASSERT:C1129($o2[$t]#$o[$t];"Must not be overridden")
	End case 
End for each 

  // === === === === === === === === === === === === === === === === === === === === deepMerge()
$o:=New object:C1471(\
"a";New object:C1471("b";1);\
"test";New collection:C1472(1;2;New object:C1471("b";1);4;5))
$ob.set(New object:C1471)
$ob.deepMerge($o)
ASSERT:C1129(JSON Stringify:C1217($ob.contents)=JSON Stringify:C1217($o))


  // === === === === === === === === === === === === === === === === === === === === findPropertyValues()
$ob.set(New object:C1471)
$o:=$ob.findPropertyValues("dummy")
ASSERT:C1129(Not:C34($o.success);"Must not found property in empty object")

$ob.set(New object:C1471("uuid";Generate UUID:C1066))
$o:=$ob.findPropertyValues("uuid")
ASSERT:C1129($o.success;"Must found at first level property")
ASSERT:C1129($o.value[0]=$ob.contents.uuid;"Must found at first level property and provide good value")

$ob.set(New object:C1471("test";"test";"level";New object:C1471("uuid";Generate UUID:C1066)))
$o:=$ob.findPropertyValues("uuid")
ASSERT:C1129($o.success;"Must found at second level property")
ASSERT:C1129($o.value[0]=$ob.contents.level.uuid;"Must found at second level property and provide good value")

$ob.set(New object:C1471("test";"test";"level";New collection:C1472(New object:C1471("uuid";Generate UUID:C1066))))
$o:=$ob.findPropertyValues("uuid")
ASSERT:C1129($o.success;"Must found in collection")
ASSERT:C1129($o.value[0]=$ob.contents.level[0].uuid;"Must found in collection and good value")

$ob.set(New object:C1471("uuid";"hello world";"level";New collection:C1472(New object:C1471("uuid";Generate UUID:C1066))))
$o:=$ob.findPropertyValues("uuid")
ASSERT:C1129($o.success;"Must found in collection")
ASSERT:C1129($o.value[0]=$ob.contents.uuid;"Must found in first level object and provide good value")
ASSERT:C1129($o.value[1]=$ob.contents.level[0].uuid;"Must found in collection after and object and good value")

$o:=$ob.findPropertyValues("dummy")
ASSERT:C1129(Not:C34($o.success);"Must not found in collection")


FINALLY 

If (Structure file:C489=Structure file:C489(*))
	
	ALERT:C41("Done")
	
End if 
