//%attributes = {}

var $pattern; $target : Text
var $rgx : cs:C1710.regex

err_TRY

$target:="Hello world"
$pattern:="world"
$rgx:=cs:C1710.regex.new($target; $pattern).match()
ASSERT:C1129($rgx.success)
ASSERT:C1129($rgx.matches.length=1)
ASSERT:C1129($rgx.matches[0].data="world")
ASSERT:C1129($rgx.matches[0].position=7)
ASSERT:C1129($rgx.matches[0].length=5)

$pattern:="^Hello world$"
$rgx.setPattern($pattern).match()
ASSERT:C1129($rgx.success)
ASSERT:C1129($rgx.matches.length=1)
ASSERT:C1129($rgx.matches[0].data=$target)
ASSERT:C1129($rgx.matches[0].position=1)
ASSERT:C1129($rgx.matches[0].length=11)

$target:="fields[10]"
$pattern:="(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$"
$rgx.setTarget($target).setPattern($pattern).match()
ASSERT:C1129($rgx.success)
ASSERT:C1129($rgx.matches.length=3)
ASSERT:C1129($rgx.matches.extract("data").equal(New collection:C1472("fields[10]"; "fields"; "10")))
ASSERT:C1129($rgx.matches.extract("position").equal(New collection:C1472(1; 1; 8)))
ASSERT:C1129($rgx.matches.extract("length").equal(New collection:C1472(10; 6; 2)))

// First occurence
$target:="fields[10] fields[11]"
$pattern:="(?mi-s)(\\w+)\\[(\\d+)]"
$rgx.setTarget($target).setPattern($pattern).match()
ASSERT:C1129($rgx.success)
ASSERT:C1129($rgx.matches.length=3)
ASSERT:C1129($rgx.matches.extract("data").equal(New collection:C1472("fields[10]"; "fields"; "10")))
ASSERT:C1129($rgx.matches.extract("position").equal(New collection:C1472(1; 1; 8)))
ASSERT:C1129($rgx.matches.extract("length").equal(New collection:C1472(10; 6; 2)))

$rgx.match(1)
ASSERT:C1129($rgx.success)
ASSERT:C1129($rgx.matches.length=3)
ASSERT:C1129($rgx.matches.extract("data").equal(New collection:C1472("fields[10]"; "fields"; "10")))
ASSERT:C1129($rgx.matches.extract("position").equal(New collection:C1472(1; 1; 8)))
ASSERT:C1129($rgx.matches.extract("length").equal(New collection:C1472(10; 6; 2)))

$rgx.match(1; False:C215)
ASSERT:C1129($rgx.success)
ASSERT:C1129($rgx.matches.length=3)
ASSERT:C1129($rgx.matches.extract("data").equal(New collection:C1472("fields[10]"; "fields"; "10")))
ASSERT:C1129($rgx.matches.extract("position").equal(New collection:C1472(1; 1; 8)))
ASSERT:C1129($rgx.matches.extract("length").equal(New collection:C1472(10; 6; 2)))

$rgx.match(False:C215)
ASSERT:C1129($rgx.success)
ASSERT:C1129($rgx.matches.length=3)
ASSERT:C1129($rgx.matches.extract("data").equal(New collection:C1472("fields[10]"; "fields"; "10")))
ASSERT:C1129($rgx.matches.extract("position").equal(New collection:C1472(1; 1; 8)))
ASSERT:C1129($rgx.matches.extract("length").equal(New collection:C1472(10; 6; 2)))

// All occurences
$rgx.match(True:C214)
ASSERT:C1129($rgx.success)
ASSERT:C1129($rgx.matches.length=6)
ASSERT:C1129($rgx.matches.extract("data").equal(New collection:C1472("fields[10]"; "fields"; "10"; "fields[11]"; "fields"; "11")))
ASSERT:C1129($rgx.matches.extract("position").equal(New collection:C1472(1; 1; 8; 12; 12; 19)))
ASSERT:C1129($rgx.matches.extract("length").equal(New collection:C1472(10; 6; 2; 10; 6; 2)))

$rgx.match(1; True:C214)
ASSERT:C1129($rgx.success)
ASSERT:C1129($rgx.matches.length=6)
ASSERT:C1129($rgx.matches.extract("data").equal(New collection:C1472("fields[10]"; "fields"; "10"; "fields[11]"; "fields"; "11")))
ASSERT:C1129($rgx.matches.extract("position").equal(New collection:C1472(1; 1; 8; 12; 12; 19)))
ASSERT:C1129($rgx.matches.extract("length").equal(New collection:C1472(10; 6; 2; 10; 6; 2)))

// Failed match
$target:="fields[]"
$pattern:="(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$"
$rgx.setTarget($target).setPattern($pattern).match()
ASSERT:C1129(Not:C34($rgx.success))
ASSERT:C1129($rgx.matches.length=0)

// Pattern error
$pattern:="(\\w+\\[(\\d+)]"
$rgx.setPattern($pattern).match()
ASSERT:C1129(Not:C34($rgx.success))
ASSERT:C1129($rgx.matches.length=0)
ASSERT:C1129($rgx.error=-1)

err_FINALLY

