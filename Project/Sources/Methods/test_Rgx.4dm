//%attributes = {}
C_LONGINT:C283($i)
C_TEXT:C284($Txt_pattern;$Txt_target)
C_OBJECT:C1216($o;$Obj_test)

ARRAY TEXT:C222($tTxt_values;0)

TRY 

  // Success matchs [
$Obj_test:=New object:C1471
$Obj_test.pattern:="world"
$Obj_test.target:="Hello world"

$o:=Rgx_match ($Obj_test)

ASSERT:C1129($o.success)
ASSERT:C1129($o.match.length=1)
ASSERT:C1129($o.match[0].data="world")
ASSERT:C1129($o.match[0].position=7)
ASSERT:C1129($o.match[0].length=5)

$Obj_test:=New object:C1471
$Obj_test.pattern:="^Hello world$"
$Obj_test.target:="Hello world"

$o:=Rgx_match ($Obj_test)

ASSERT:C1129($o.success)
ASSERT:C1129($o.match.length=1)
ASSERT:C1129($o.match[0].data=$Obj_test.target)
ASSERT:C1129($o.match[0].position=1)
ASSERT:C1129($o.match[0].length=11)

$Txt_target:="fields[10]"

$o:=Rgx_match (New object:C1471(\
"pattern";"(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$";\
"target";$Txt_target))

ASSERT:C1129($o.success)
ASSERT:C1129($o.match.length=3)
ASSERT:C1129($o.match.extract("data").equal(New collection:C1472("fields[10]";"fields";"10")))
ASSERT:C1129($o.match.extract("position").equal(New collection:C1472(1;1;8)))
ASSERT:C1129($o.match.extract("length").equal(New collection:C1472(10;6;2)))

  // Stop after the first match
$Txt_target:="fields[10] fields[11]"
$Txt_pattern:="(?mi-s)(\\w+)\\[(\\d+)]"

$o:=Rgx_match (New object:C1471(\
"pattern";$Txt_pattern;\
"target";$Txt_target))

ASSERT:C1129($o.success)
ASSERT:C1129($o.match.length=3)
ASSERT:C1129($o.match.extract("data").equal(New collection:C1472("fields[10]";"fields";"10")))
ASSERT:C1129($o.match.extract("position").equal(New collection:C1472(1;1;8)))
ASSERT:C1129($o.match.extract("length").equal(New collection:C1472(10;6;2)))
  //]

  // All occurences
$Txt_target:="fields[10] fields[11]"

$o:=Rgx_match (New object:C1471(\
"pattern";"(?mi-s)(\\w+)\\[(\\d+)]";\
"target";$Txt_target;\
"all";True:C214))

ASSERT:C1129($o.success)
ASSERT:C1129($o.match.length=6)
ASSERT:C1129($o.match.extract("data").equal(New collection:C1472("fields[10]";"fields";"10";"fields[11]";"fields";"11")))
ASSERT:C1129($o.match.extract("position").equal(New collection:C1472(1;1;8;12;12;19)))
ASSERT:C1129($o.match.extract("length").equal(New collection:C1472(10;6;2;10;6;2)))
  //]

  // Failed match [
$Txt_target:="fields[]"

$o:=Rgx_match (New object:C1471(\
"pattern";"(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$";\
"target";$Txt_target))

ASSERT:C1129(Not:C34($o.success))
ASSERT:C1129($o.match=Null:C1517)
  //]

  // Pattern error [
$Txt_pattern:="(\\w+\\[(\\d+)]"

$o:=Rgx_match (New object:C1471(\
"pattern";$Txt_pattern;\
"target";$Txt_target))

ASSERT:C1129(Not:C34($o.success))
ASSERT:C1129($o.match=Null:C1517)
ASSERT:C1129($o.error=-1)
  //]

$Txt_pattern:="(?mi-s)^(:?https?://)?+(:?www\\.)?+([^:]*)(:?[^\\n$]*)$"

$Txt_target:="fr.wikipedia.org"
$o:=Rgx_match (New object:C1471(\
"pattern";$Txt_pattern;\
"target";$Txt_target))
ASSERT:C1129($o.match.extract("data").equal(New collection:C1472($Txt_target;"";"";"fr.wikipedia.org";"")))

$Txt_target:="http://www.testbugs.4d.fr:8880/"
$o:=Rgx_match (New object:C1471(\
"pattern";$Txt_pattern;\
"target";$Txt_target))
ASSERT:C1129($o.match.extract("data").equal(New collection:C1472($Txt_target;"http://";"www.";"testbugs.4d.fr";":8880/")))

$Txt_target:="https://Testbugs.4d.fr"
$o:=Rgx_match (New object:C1471(\
"pattern";$Txt_pattern;\
"target";$Txt_target))
ASSERT:C1129($o.match.extract("data").equal(New collection:C1472($Txt_target;"https://";"";"testbugs.4d.fr";"")))

$Txt_target:="www.testbugs.4d.fr"
$o:=Rgx_match (New object:C1471(\
"pattern";$Txt_pattern;\
"target";$Txt_target))
ASSERT:C1129($o.match.extract("data").equal(New collection:C1472($Txt_target;"";"www.";"testbugs.4d.fr";"")))

  // Compare with Rgx_MatchText [
$Txt_target:="fields[10]"
$Txt_pattern:="(?mi-s)(\\w+)\\[(\\d+)]"

$o:=Rgx_match (New object:C1471(\
"pattern";$Txt_pattern;\
"target";$Txt_target))

ASSERT:C1129($o.success)

ASSERT:C1129(Rgx_MatchText ($Txt_pattern;$Txt_target;->$tTxt_values)=0)

ASSERT:C1129($o.match.length=(Size of array:C274($tTxt_values)+1))

For ($i;0;Size of array:C274($tTxt_values);1)
	
	ASSERT:C1129($o.match[$i].data=$tTxt_values{$i})
	
End for 
  //]

FINALLY 