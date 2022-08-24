//%attributes = {}
var $rgx : cs:C1710.regex

err_TRY

//mark:match()
$rgx:=cs:C1710.regex.new("Hello world"; "world").match()
ASSERT:C1129($rgx.success)
ASSERT:C1129($rgx.matches.length=1)
ASSERT:C1129($rgx.matches[0].data="world")
ASSERT:C1129($rgx.matches[0].position=7)
ASSERT:C1129($rgx.matches[0].length=5)

$rgx.pattern:="^Hello world$"
$rgx.match()
ASSERT:C1129($rgx.success)
ASSERT:C1129($rgx.matches.length=1)
ASSERT:C1129($rgx.matches[0].data="Hello world")
ASSERT:C1129($rgx.matches[0].position=1)
ASSERT:C1129($rgx.matches[0].length=11)

$rgx.target:="fields[10]"
$rgx.pattern:="(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$"
$rgx.match()
ASSERT:C1129($rgx.success)
ASSERT:C1129($rgx.matches.length=3)
ASSERT:C1129($rgx.matches.extract("data").equal(New collection:C1472("fields[10]"; "fields"; "10")))
ASSERT:C1129($rgx.matches.extract("position").equal(New collection:C1472(1; 1; 8)))
ASSERT:C1129($rgx.matches.extract("length").equal(New collection:C1472(10; 6; 2)))

// First occurence
$rgx.setTarget("fields[10] fields[11]").setPattern("(?mi-s)(\\w+)\\[(\\d+)]").match()
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
$rgx.target:="fields[]"
$rgx.pattern:="(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$"
$rgx.match()
ASSERT:C1129(Not:C34($rgx.success))
ASSERT:C1129($rgx.matches.length=0)
ASSERT:C1129($rgx.errorCode=0)
ASSERT:C1129($rgx.errors.length=0)

// Pattern error
$rgx.pattern:="(\\w+\\[(\\d+)]"
$rgx.match()
ASSERT:C1129(Not:C34($rgx.success))
ASSERT:C1129($rgx.matches.length=0)
ASSERT:C1129($rgx.errorCode=-1)



//mark:substitute()
//var $text : Text

//$text:=Lowercase("Hello World")

//Rgx_SubstituteText("[^a-z0-9]"; "_"; ->$text; 0)


//$text:="123helloWorld"
//Rgx_SubstituteText("(?mi-s)^[^[:alpha:]]*([^$]*)$"; "\\1"; ->$text; 0)



err_FINALLY

