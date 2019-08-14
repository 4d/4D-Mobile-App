//%attributes = {}
C_TEXT:C284($t)
C_OBJECT:C1216($o;$Obj_2)
C_COLLECTION:C1488($c)

TRY 

$c:=New collection:C1472(\
New object:C1471("a";New object:C1471("b";1);\
"test";New collection:C1472(1;2;New object:C1471(\
"b";1);\
4;5)))

  // ======================================================================= ob_createPath
$o:=ob_createPath (New object:C1471;"level1.level2.level3")
ASSERT:C1129($o.level1#Null:C1517)
ASSERT:C1129($o.level1.level2#Null:C1517)
ASSERT:C1129($o.level1.level2.level3#Null:C1517)

$o:=ob_createPath (New object:C1471;"server.authentication";Is collection:K8:32)
ASSERT:C1129(Value type:C1509($o.server.authentication)=Is collection:K8:32)

$o:=ob_createPath (New object:C1471;"server.urls.production";Is text:K8:3)
ASSERT:C1129(Value type:C1509($o.server.urls.production)=Is text:K8:3)

  // ======================================================================= ob_deepMerge
ASSERT:C1129(JSON Stringify:C1217(ob_deepMerge (New object:C1471;$c[0]))=JSON Stringify:C1217($c[0]))

  // ======================================================================= ob_equal
$o:=New object:C1471(\
"build";False:C215;\
"run";False:C215;\
"sdk";"iphonesimulator";\
"template";"list";\
"testing";False:C215;\
"caller";0)

$Obj_2:=New object:C1471(\
"build";False:C215;\
"run";False:C215;\
"sdk";"iphonesimulator";\
"template";"list";\
"testing";False:C215;\
"caller";0)

ASSERT:C1129(ob_equal ($o;$Obj_2))

OB REMOVE:C1226($Obj_2;"build")

ASSERT:C1129(Not:C34(ob_equal ($o;$Obj_2)))

  // ======================================================================= ob_getByPath

ASSERT:C1129(ob_getByPath ($c[0];"a.b").value=1)
ASSERT:C1129(ob_getByPath ($c[0];"test[0]").value=1)
ASSERT:C1129(ob_getByPath ($c[0];"test[2].b").value=1)

  // ======================================================================= ob_MERGE
  // Template
$o:=New object:C1471(\
"build";False:C215;\
"run";False:C215;\
"sdk";"iphonesimulator";\
"template";"list";\
"testing";False:C215;\
"caller";0)

  // Target
$Obj_2:=New object:C1471(\
"build";True:C214;\
"caller";8858)

ob_MERGE ($Obj_2;$o)

For each ($t;$o)
	
	ASSERT:C1129($Obj_2[$t]#Null:C1517)
	
	Case of 
			
			  //______________________________________________________
		: (Position:C15($t;"create")>0)
			
			ASSERT:C1129($Obj_2[$t]=$o[$t])
			
			  //______________________________________________________
		: (Position:C15($t;"buildcaller")>0)
			
			ASSERT:C1129($Obj_2[$t]#$o[$t])
			
			  //______________________________________________________
	End case 
End for each 

  // ======================================================================= ob_testPath
$o:=ob_createPath (New object:C1471;"server.authentication";Is collection:K8:32)
$o.server.authentication[5]:=8858

$Obj_2:=ob_createPath (New object:C1471;"server.urls.production";Is text:K8:3)
ob_MERGE ($o;$Obj_2)

$Obj_2:=ob_createPath (New object:C1471;"server.icon";Is picture:K8:10)
ob_MERGE ($o;$Obj_2)

ASSERT:C1129(ob_testPath ($o;"server";"authentication"))
ASSERT:C1129(Not:C34(ob_testPath ($o;"server";"test")))

ASSERT:C1129(Value type:C1509($o.server.authentication)=Is collection:K8:32)
ASSERT:C1129(Value type:C1509($o.server.urls.production)=Is text:K8:3)
ASSERT:C1129(Value type:C1509($o.server.icon)=Is picture:K8:10)

$Obj_2:=ob_createPath (New object:C1471;"server.urls.test";Is text:K8:3)
$Obj_2.server.urls.test:="localhost"
ASSERT:C1129(ob_testPath ($Obj_2;"server";"urls";"test"))

$Obj_2.server.urls.test:=Null:C1517
ASSERT:C1129(ob_testPath ($Obj_2;"server";"urls";"test"))

$o:=New object:C1471
ASSERT:C1129(ob_testPath ($o;"sub1")=Not:C34($o.sub1=Null:C1517))

$o:=New object:C1471(\
"sub1";Null:C1517)
ASSERT:C1129(ob_testPath ($o;"sub1")=($o.sub1=Null:C1517))

  // ======================================================================= ob_findProperty

$o:=New object:C1471()
$Obj_2:=ob_findProperty ($o;"dummy")
ASSERT:C1129(Not:C34($Obj_2.success);"Must not found property in empty object")

$o:=New object:C1471("uuid";Generate UUID:C1066)
$Obj_2:=ob_findProperty ($o;"uuid")
ASSERT:C1129($Obj_2.success;"Must found at first level property")
ASSERT:C1129($Obj_2.value[0]=$o.uuid;"Must found at first level property and provide good value")

$o:=New object:C1471("test";"test";"level";New object:C1471("uuid";Generate UUID:C1066))
$Obj_2:=ob_findProperty ($o;"uuid")
ASSERT:C1129($Obj_2.success;"Must found at second level property")
ASSERT:C1129($Obj_2.value[0]=$o.level.uuid;"Must found at second level property and provide good value")

$o:=New object:C1471("test";"test";"level";New collection:C1472(New object:C1471("uuid";Generate UUID:C1066)))
$Obj_2:=ob_findProperty ($o;"uuid")
ASSERT:C1129($Obj_2.success;"Must found in collection")
ASSERT:C1129($Obj_2.value[0]=$o.level[0].uuid;"Must found in collection and good value")

$o:=New object:C1471("uuid";"Generate UUID";"level";New collection:C1472(New object:C1471("uuid";Generate UUID:C1066)))
$Obj_2:=ob_findProperty ($o;"uuid")
ASSERT:C1129($Obj_2.success;"Must found in collection")
ASSERT:C1129($Obj_2.value[0]=$o.uuid;"Must found in first level object and provide good value")
ASSERT:C1129($Obj_2.value[1]=$o.level[0].uuid;"Must found in collection after and object and good value")

$o:=New object:C1471("uuid";"Generate UUID";"level";New collection:C1472(New object:C1471("uuid";Generate UUID:C1066)))
$Obj_2:=ob_findProperty ($o;"dummy")
ASSERT:C1129(Not:C34($Obj_2.success);"Must not found in collection")


  // ======================================================================= ob_removeFormula

$o:=New object:C1471("attribute";"value";"formula";Formula:C1597(1+1))
ARRAY TEXT:C222($arrNames;0)
ARRAY LONGINT:C221($arrTypes;0)
OB GET PROPERTY NAMES:C1232($o;$arrNames;$arrTypes)
ASSERT:C1129(Size of array:C274($arrNames)=2)

ob_removeFormula ($o)
OB GET PROPERTY NAMES:C1232($o;$arrNames;$arrTypes)
ASSERT:C1129(Size of array:C274($arrNames)=1)
ASSERT:C1129($o.attribute="value")
ASSERT:C1129($o.formula=Null:C1517)

FINALLY 

