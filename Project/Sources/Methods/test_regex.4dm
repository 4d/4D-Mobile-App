//%attributes = {}
var $pattern; $target : Text
var $result : Collection
var $regex : cs:C1710.regex

err_TRY

// Mark:-match()
$regex:=cs:C1710.regex.new("Hello world, the world is wonderful but the world is in danger"; "world")

If ($regex.match())  //Test first occurrence
	
	ASSERT:C1129($regex.matches.length=1)
	ASSERT:C1129($regex.matches[0].data="world")
	ASSERT:C1129($regex.matches[0].position=7)
	ASSERT:C1129($regex.matches[0].length=5)
	
End if 

If ($regex.match(10))  // Starts search at 10th character
	
	ASSERT:C1129($regex.matches.length=1)
	ASSERT:C1129($regex.matches[0].data="world")
	ASSERT:C1129($regex.matches[0].position=18)
	ASSERT:C1129($regex.matches[0].length=5)
	
End if 

If ($regex.match(True:C214))  // Retrieves all occurrences
	
	ASSERT:C1129($regex.matches.length=3)
	ASSERT:C1129($regex.matches[0].data="world")
	ASSERT:C1129($regex.matches[0].position=7)
	ASSERT:C1129($regex.matches[0].length=5)
	
	ASSERT:C1129($regex.matches[1].data="world")
	ASSERT:C1129($regex.matches[1].position=18)
	ASSERT:C1129($regex.matches[1].length=5)
	
	ASSERT:C1129($regex.matches[2].data="world")
	ASSERT:C1129($regex.matches[2].position=45)
	ASSERT:C1129($regex.matches[2].length=5)
	
End if 

If ($regex.match(10; True:C214))  // Starts search at 10th character & retrieves all next occurences
	
	ASSERT:C1129($regex.matches.length=2)
	ASSERT:C1129($regex.matches[0].data="world")
	ASSERT:C1129($regex.matches[0].position=18)
	ASSERT:C1129($regex.matches[0].length=5)
	
	ASSERT:C1129($regex.matches[1].data="world")
	ASSERT:C1129($regex.matches[1].position=45)
	ASSERT:C1129($regex.matches[1].length=5)
	
End if 

$regex.pattern:="^Hello world$"

If ($regex.match())
	
	ASSERT:C1129($regex.matches.length=1)
	ASSERT:C1129($regex.matches[0].data="Hello world")
	ASSERT:C1129($regex.matches[0].position=1)
	ASSERT:C1129($regex.matches[0].length=11)
	
End if 

$regex.target:="fields[10]"
$regex.pattern:="(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$"

If ($regex.match())
	
	ASSERT:C1129($regex.matches.length=3)
	ASSERT:C1129($regex.matches.extract("data").equal(New collection:C1472("fields[10]"; "fields"; "10")))
	ASSERT:C1129($regex.matches.extract("position").equal(New collection:C1472(1; 1; 8)))
	ASSERT:C1129($regex.matches.extract("length").equal(New collection:C1472(10; 6; 2)))
	
End if 

// First occurence
$regex.setTarget("fields[10] fields[11]").setPattern("(?mi-s)(\\w+)\\[(\\d+)]")

If ($regex.match())
	
	ASSERT:C1129($regex.matches.length=3)
	ASSERT:C1129($regex.matches.extract("data").equal(New collection:C1472("fields[10]"; "fields"; "10")))
	ASSERT:C1129($regex.matches.extract("position").equal(New collection:C1472(1; 1; 8)))
	ASSERT:C1129($regex.matches.extract("length").equal(New collection:C1472(10; 6; 2)))
	
End if 

If ($regex.match(1))
	
	ASSERT:C1129($regex.matches.length=3)
	ASSERT:C1129($regex.matches.extract("data").equal(New collection:C1472("fields[10]"; "fields"; "10")))
	ASSERT:C1129($regex.matches.extract("position").equal(New collection:C1472(1; 1; 8)))
	ASSERT:C1129($regex.matches.extract("length").equal(New collection:C1472(10; 6; 2)))
	
End if 

If ($regex.match(1; False:C215))
	
	ASSERT:C1129($regex.matches.length=3)
	ASSERT:C1129($regex.matches.extract("data").equal(New collection:C1472("fields[10]"; "fields"; "10")))
	ASSERT:C1129($regex.matches.extract("position").equal(New collection:C1472(1; 1; 8)))
	ASSERT:C1129($regex.matches.extract("length").equal(New collection:C1472(10; 6; 2)))
	
End if 

If ($regex.match(False:C215))
	
	ASSERT:C1129($regex.matches.length=3)
	ASSERT:C1129($regex.matches.extract("data").equal(New collection:C1472("fields[10]"; "fields"; "10")))
	ASSERT:C1129($regex.matches.extract("position").equal(New collection:C1472(1; 1; 8)))
	ASSERT:C1129($regex.matches.extract("length").equal(New collection:C1472(10; 6; 2)))
	
End if 

// All occurences
If ($regex.match(True:C214))
	
	ASSERT:C1129($regex.matches.length=6)
	ASSERT:C1129($regex.matches.extract("data").equal(New collection:C1472("fields[10]"; "fields"; "10"; "fields[11]"; "fields"; "11")))
	ASSERT:C1129($regex.matches.extract("position").equal(New collection:C1472(1; 1; 8; 12; 12; 19)))
	ASSERT:C1129($regex.matches.extract("length").equal(New collection:C1472(10; 6; 2; 10; 6; 2)))
	
End if 

If ($regex.match(1; True:C214))
	
	ASSERT:C1129($regex.matches.length=6)
	ASSERT:C1129($regex.matches.extract("data").equal(New collection:C1472("fields[10]"; "fields"; "10"; "fields[11]"; "fields"; "11")))
	ASSERT:C1129($regex.matches.extract("position").equal(New collection:C1472(1; 1; 8; 12; 12; 19)))
	ASSERT:C1129($regex.matches.extract("length").equal(New collection:C1472(10; 6; 2; 10; 6; 2)))
	
End if 

// Mark:-Pattern error
$regex.pattern:="(\\w+\\[(\\d+)]"
ASSERT:C1129(Not:C34($regex.match()))
ASSERT:C1129($regex.matches.length=0)
ASSERT:C1129($regex.lastError.code=-1)
ASSERT:C1129($regex.lastError.method="regex.match")
ASSERT:C1129($regex.lastError.desc=("Error while parsing pattern \""+$regex.pattern+"\""))

// Mark:-extract()
$regex:=cs:C1710.regex.new("hello world"; "(?m-si)([[:alnum:]]*)\\s([[:alnum:]]*)")
$result:=$regex.extract()
ASSERT:C1129($result.equal(New collection:C1472("hello world"; "hello"; "world")))
$result:=$regex.extract("0")
ASSERT:C1129($result.equal(New collection:C1472("hello world")))
$result:=$regex.extract(0)
ASSERT:C1129($result.equal(New collection:C1472("hello world")))
$result:=$regex.extract(1)
ASSERT:C1129($result.equal(New collection:C1472("hello")))
$result:=$regex.extract(2)
ASSERT:C1129($result.equal(New collection:C1472("world")))
$result:=$regex.extract("1 2")
ASSERT:C1129($result.equal(New collection:C1472("hello"; "world")))
$result:=$regex.extract(New collection:C1472(1; 2))
ASSERT:C1129($result.equal(New collection:C1472("hello"; "world")))


// Mark:-substitute()
$target:="[This pattern will look for a string of numbers separated by commas and replace "\
+"the final comma with \"and\". It will also trim excess spaces around the final "\
+"comma and after the final number.]\r\r1, 2, 3, 4, 5\r1, 2 , 3\r1, 2, 3, 4 , 5 "\
+"\n1,2"
$pattern:="(?mi-s)\\x20*,\\x20*(\\d+)\\x20*$"

$regex:=cs:C1710.regex.new($target; $pattern)
ASSERT:C1129($regex.substitute(" and \\1")=("[This pattern will look for a string of numbers separated by commas and replace "\
+"the final comma with \"and\". It will also trim excess spaces around the final "\
+"comma and after the final number.]\r\r1, 2, 3, 4 and 5\r1, 2 and 3\r1, 2, 3, 4 "\
+"and 5\n1 and 2"))

ASSERT:C1129($regex.setTarget("hello world").setPattern("[^a-z0-9]").substitute("_")="hello_world")

$regex.target:="123helloWorld"
$regex.pattern:="(?mi-s)^[^[:alpha:]]*([^$]*)$"
ASSERT:C1129($regex.substitute("\\1")="helloWorld")

$regex.target:="Each of these lines ends with some white space. "\
+"This one ends with a space. \n\n"\
+"This one ends with a tab.\t\n\n"\
+"This one ends with some spaces.    \n\n"\
+"This one ends with some tabs.\t\t\t\n\n"\
+"This one ends with a mixture of spaces and tabs.  \t\t  \n\n"\
+"Since the pattern only matches trailing whitespace, we can replace it with nothing to get the result we want."
$regex.pattern:="(?mi-s)[[:blank:]]+$"
ASSERT:C1129(Length:C16($regex.substitute())=327)

err_FINALLY

BEEP:C151