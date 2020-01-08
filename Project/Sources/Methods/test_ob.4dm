//%attributes = {}
C_OBJECT:C1216($o;$o1;$ob)
C_COLLECTION:C1488($c)

TRY 

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

$o1:=$ob.copy()
ASSERT:C1129($ob.equal($o1))
ASSERT:C1129(Not:C34($ob.equal(New object:C1471)))

OB REMOVE:C1226($o1;"server")
ASSERT:C1129(Not:C34($ob.equal($o1)))

$ob.set(New collection:C1472)
ASSERT:C1129($ob.isCollection())
ASSERT:C1129(Not:C34($ob.isObject()))
ASSERT:C1129($ob.isEmpty())

$c:=New collection:C1472(\
New object:C1471(\
"a";New object:C1471("b";1);\
"test";New collection:C1472(1;2;New object:C1471(\
"b";1);\
4;5)))

$ob.set($c)
ASSERT:C1129($ob.isCollection())
ASSERT:C1129(Not:C34($ob.isObject()))
ASSERT:C1129(Not:C34($ob.isEmpty()))

$ob.set($c[0])
ASSERT:C1129($ob.isObject())
ASSERT:C1129(Not:C34($ob.isCollection()))

ASSERT:C1129($ob.getByPath("a.b")=1)
ASSERT:C1129($ob.getByPath("test[0]")=1)
ASSERT:C1129($ob.getByPath("test[2].b")=1)

FINALLY 