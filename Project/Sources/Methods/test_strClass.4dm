//%attributes = {}
var $t; $tt; $in; $out : Text
var $i : Integer
var $str : cs:C1710.str

err_TRY

$str:=cs:C1710.str.new()
ASSERT:C1129(Length:C16($str.value)=0)
ASSERT:C1129($str.length=0)

$str:=cs:C1710.str.new("hello world")
ASSERT:C1129($str.value="hello world")
ASSERT:C1129($str.length=11)

$str.setText(Pi:K30:1)
GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $t)
ASSERT:C1129($str.value=Replace string:C233("3.14159265359"; "."; $t))
ASSERT:C1129($str.length=(12+Length:C16($t)))

// mark:-trim()
ASSERT:C1129($str.setText("Hello World").trimTrailing()="Hello World")
ASSERT:C1129($str.setText("Hello World").trimTrailing("_")="Hello World")
ASSERT:C1129($str.setText("Hello World       ").trimTrailing()="Hello World")
ASSERT:C1129($str.setText("Hello World_____").trimTrailing("_")="Hello World")

ASSERT:C1129($str.setText("       Hello World").trimLeading()="Hello World")
ASSERT:C1129($str.setText("_____Hello World").trimLeading("_")="Hello World")

ASSERT:C1129($str.setText("").trim()="")
ASSERT:C1129($str.setText("       Hello world          ").trim()="Hello World")
ASSERT:C1129($str.setText("_____Hello world_____").trim("_")="Hello World")

$str.setText("")

ASSERT:C1129($str.trimTrailing("")="")
ASSERT:C1129($str.trimTrailing("_"; "_")="")
ASSERT:C1129($str.trimTrailing(""; "_")="")

ASSERT:C1129($str.trimTrailing("Hello World")="Hello World")
ASSERT:C1129($str.trimTrailing("Hello World"; "_")="Hello World")

ASSERT:C1129($str.trimTrailing("Hello World     ")="Hello World")
ASSERT:C1129($str.trimTrailing("Hello World_____"; "_")="Hello World")
ASSERT:C1129($str.trimTrailing("Hello World$"; "$")="Hello World")

ASSERT:C1129($str.trimLeading("Hello World")="Hello World")
ASSERT:C1129($str.trimLeading("Hello World"; "_")="Hello World")
ASSERT:C1129($str.trimLeading("       Hello World")="Hello World")
ASSERT:C1129($str.trimLeading("_____Hello World"; "_")="Hello World")
ASSERT:C1129($str.trimLeading("$Hello World"; "$")="Hello World")

// mark:-wordWrap()
$in:="The principle of the XLIFF norm drives to determine a language source in which "\
+"are written all the strings. This language will be the reference language (the "\
+"one from which will be done all the translations). The second language is the "\
+"language said target Who will be used for the dialogs, warnings, prints… This is "\
+"the language of the user."

$out:="The principle of the XLIFF norm drives to determine a language source in which "\
+"\rare written all the strings. This language will be the reference language (the "\
+"\rone from which will be done all the translations). The second language is the "\
+"\rlanguage said target Who will be used for the dialogs, warnings, prints… This "\
+"\ris the language of the user."

ASSERT:C1129($str.setText($in).wordWrap()=$out)

$str.setText("")
ASSERT:C1129($str.wordWrap($in)=$out)

// Mark:-keywords()
$str.setText($in)

var $c : Collection
$c:=$str.keywords()
ASSERT:C1129($c.length=36)
ASSERT:C1129($c[0]="The")
ASSERT:C1129($c[35]="user")

$c:=$str.keywords(True:C214)
ASSERT:C1129($c.length=36)
ASSERT:C1129($c[0]="a")
ASSERT:C1129($c[35]="XLIFF")

$c:=$str.keywords("world hello")
ASSERT:C1129($c.length=2)
ASSERT:C1129($c[0]="world")
ASSERT:C1129($c[1]="hello")

$c:=$str.keywords("world hello"; True:C214)
ASSERT:C1129($c.length=2)
ASSERT:C1129($c[0]="hello")
ASSERT:C1129($c[1]="world")

// Mark:-htmlEncode()
$str.setText($in)
ASSERT:C1129($str.htmlEncode()=$in)

ASSERT:C1129($str.htmlEncode("\"hello\" & <world>")="&quot;hello&quot; &amp; &lt;world&gt;")

// Mark:-multistyleCompatible()
$str.setText($in)
ASSERT:C1129($str.multistyleCompatible()=$in)

ASSERT:C1129($str.multistyleCompatible("hello & world")="hello &amp; world")

// mark:-uperCamelCase()
ASSERT:C1129($str.setText("").uperCamelCase()="")

$str.setText("Category ID Element")

$in:="CategoryIDElement"
$out:=$str.uperCamelCase()

For ($i; 1; Length:C16($in); 1)
	
	ASSERT:C1129(Character code:C91($out[[$i]])=Character code:C91($in[[$i]]); "uperCamelCase('CategoryIDElement')")
	
End for 

$out:=$str.uperCamelCase()

For ($i; 1; Length:C16($in); 1)
	
	ASSERT:C1129(Character code:C91($out[[$i]])=Character code:C91($in[[$i]]); "uperCamelCase('Category ID Element')")
	
End for 

$out:=$str.setText("Category_ID_element").uperCamelCase()

For ($i; 1; Length:C16($in); 1)
	
	ASSERT:C1129(Character code:C91($out[[$i]])=Character code:C91($in[[$i]]); "uperCamelCase('CategoryIDElement')")
	
End for 

$in:="Category"
$out:=$str.setText("category").uperCamelCase()

For ($i; 1; Length:C16($in); 1)
	
	ASSERT:C1129(Character code:C91($out[[$i]])=Character code:C91($in[[$i]]); "uperCamelCase('Category')")
	
End for 

// mark:-spaceSeparated()
ASSERT:C1129($str.setText($str.spaceSeparated("Last Name")).equal("Last Name"))
ASSERT:C1129($str.setText($str.spaceSeparated("Last_Name")).equal("Last Name"))
ASSERT:C1129($str.setText($str.spaceSeparated("_Last_Name")).equal("Last Name"))
ASSERT:C1129($str.setText($str.spaceSeparated("__Last_Name__")).equal("Last Name"))
ASSERT:C1129($str.setText($str.spaceSeparated("LastName")).equal("Last Name"))
ASSERT:C1129($str.setText($str.spaceSeparated("LASTNAME")).equal("LASTNAME"))
ASSERT:C1129($str.setText($str.spaceSeparated("LAST NAME")).equal("LAST NAME"))

// mark:-lowerCamelCase()
ASSERT:C1129($str.setText($str.lowerCamelCase("First Name")).equal("firstName"))
ASSERT:C1129($str.setText($str.lowerCamelCase("firstName")).equal("firstName"))
ASSERT:C1129($str.setText($str.lowerCamelCase("FirstName")).equal("firstName"))

// mark:-length
ASSERT:C1129($str.setText("").length=0)
ASSERT:C1129($str.setText("Hello world").length=Length:C16("Hello world"))

/// mark-:isStyled()
ASSERT:C1129(Not:C34($str.setText("Hello world").isStyled()))
ASSERT:C1129(Not:C34($str.setText("xxx\r\nyyy").isStyled()))
ASSERT:C1129($str.setText("<SPAN STYLE=\"font-family: DESDEMONA\">Hello world</SPAN>").isStyled())
ASSERT:C1129($str.setText("<span style=\"text-align:left;font-family:'Segoe UI';font-size:9pt;color:#009900\">This is the word <span style=\"color:#D81E05\">red</span></span>").isStyled())

// mark:-isBoolean()
ASSERT:C1129($str.setText("true").isBoolean())
ASSERT:C1129($str.setText("True").isBoolean())
ASSERT:C1129($str.setText("false").isBoolean())
ASSERT:C1129($str.setText("False").isBoolean())
ASSERT:C1129(Not:C34($str.setText("hello").isBoolean()))

$str.setText("")
ASSERT:C1129($str.isBoolean("true"))
ASSERT:C1129($str.isBoolean("True"))
ASSERT:C1129($str.isBoolean("false"))
ASSERT:C1129($str.isBoolean("False"))
ASSERT:C1129(Not:C34($str.isBoolean("hello")))

// mark:-isDate()
ASSERT:C1129($str.setText("1/1/01").isDate())
ASSERT:C1129($str.setText("01/12/2015").isDate())
ASSERT:C1129($str.setText(String:C10(Current date:C33)).isDate())
ASSERT:C1129(Not:C34($str.setText("1/1").isDate()))
ASSERT:C1129(Not:C34($str.setText("hello").isDate()))

$str.setText("")
ASSERT:C1129($str.isDate("1/1/01"))
ASSERT:C1129($str.isDate("01/12/2015"))
ASSERT:C1129($str.isDate(String:C10(Current date:C33)))
ASSERT:C1129(Not:C34($str.isDate("1/1")))
ASSERT:C1129(Not:C34($str.isDate("hello")))

// mark:-isNum()
GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $t)
ASSERT:C1129($str.setText("100").isNum())
ASSERT:C1129($str.setText("+1").isNum())
ASSERT:C1129($str.setText("-10").isNum())
ASSERT:C1129($str.setText("12"+$t+"5").isNum())
ASSERT:C1129($str.setText(String:C10(Pi:K30:1)).isNum())
ASSERT:C1129(Not:C34($str.setText("1/1").isNum()))
ASSERT:C1129(Not:C34($str.setText("hello").isNum()))

$str.setText("")
ASSERT:C1129($str.isNum("100"))
ASSERT:C1129($str.isNum("+1"))
ASSERT:C1129($str.isNum("-10"))
ASSERT:C1129($str.isNum("12"+$t+"5"))
ASSERT:C1129($str.isNum(String:C10(Pi:K30:1)))
ASSERT:C1129(Not:C34($str.isNum("1/1")))
ASSERT:C1129(Not:C34($str.isNum("hello")))

// mark:-isTime()
GET SYSTEM FORMAT:C994(Time separator:K60:11; $t)
ASSERT:C1129($str.setText("12"+$t+"50").isTime())
ASSERT:C1129($str.setText("0"+$t+"0"+$t+"30").isTime())
ASSERT:C1129($str.setText(String:C10(Current time:C178)).isTime())
ASSERT:C1129(Not:C34($str.setText("-10").isTime()))
ASSERT:C1129(Not:C34($str.setText(String:C10(Pi:K30:1)).isTime()))
ASSERT:C1129(Not:C34($str.setText("1/1").isTime()))
ASSERT:C1129(Not:C34($str.setText("hello").isTime()))

$str.setText("")
ASSERT:C1129($str.isTime("12"+$t+"50"))
ASSERT:C1129($str.isTime("0"+$t+"0"+$t+"30"))
ASSERT:C1129($str.isTime(String:C10(Current time:C178)))
ASSERT:C1129(Not:C34($str.isTime("-10")))
ASSERT:C1129(Not:C34($str.isTime(String:C10(Pi:K30:1))))
ASSERT:C1129(Not:C34($str.isTime("1/1")))
ASSERT:C1129(Not:C34($str.isTime("hello")))

// mark:-match()
ASSERT:C1129($str.setText("today").match("(?m-si)^(?:today|tomorrow|yesterday)$"))
ASSERT:C1129($str.setText("tomorrow").match("(?m-si)^(?:today|tomorrow|yesterday)$"))
ASSERT:C1129($str.setText("Hello world").match("h|Hello"))
ASSERT:C1129(Not:C34($str.setText("Hello world").match("(?m-si)^(?:today|tomorrow|yesterday)$")))

$str.setText("")
ASSERT:C1129($str.match("today"; "(?m-si)^(?:today|tomorrow|yesterday)$"))
ASSERT:C1129($str.match("tomorrow"; "(?m-si)^(?:today|tomorrow|yesterday)$"))
ASSERT:C1129($str.match("Hello world"; "h|Hello"))
ASSERT:C1129(Not:C34($str.match("Hello world"; "(?m-si)^(?:today|tomorrow|yesterday)$")))


// mark:-fixedLength()
ASSERT:C1129($str.setText("").fixedLength(5; "0")="00000")
ASSERT:C1129($str.setText("").fixedLength(5)="*****")
ASSERT:C1129($str.setText("75").fixedLength(5; "0")="75000")
ASSERT:C1129($str.setText("750").fixedLength(5; "0")="75000")
ASSERT:C1129($str.setText("75013").fixedLength(5; "0")="75013")
ASSERT:C1129($str.setText("75").fixedLength(5; "_"; Align right:K42:4)="___75")
ASSERT:C1129($str.setText("75").fixedLength(10; Null:C1517; Align right:K42:4)="********75")
ASSERT:C1129($str.setText("75,1").fixedLength(5; "0")="75,10")

// mark:-unaccented()
$t:="àáâãäå"
$tt:="ÀÁÂÃÄÅ"
$in:=$t+$tt
$out:=$str.setText($in).unaccented()
ASSERT:C1129(Length:C16($in)=Length:C16($out))

For ($i; 1; Length:C16($t); 1)
	
	ASSERT:C1129(Character code:C91($out[[$i]])=Character code:C91("a"); "unaccented()")
	
End for 

For ($i; Length:C16($t)+1; Length:C16($out); 1)
	
	ASSERT:C1129(Character code:C91($out[[$i]])=Character code:C91("A"); "unaccented()")
	
End for 

$t:="èéêë"
$tt:="ÈÉÊË"
$in:=$t+$tt
$out:=$str.setText($in).unaccented()
ASSERT:C1129(Length:C16($in)=Length:C16($out))

For ($i; 1; Length:C16($t); 1)
	
	ASSERT:C1129(Character code:C91($out[[$i]])=Character code:C91("e"); "unaccented()")
	
End for 

For ($i; Length:C16($t)+1; Length:C16($out); 1)
	
	ASSERT:C1129(Character code:C91($out[[$i]])=Character code:C91("E"); "unaccented()")
	
End for 

$t:=""
$tt:="ÌÍÎÏ"
$in:=$t+$tt
$out:=$str.setText($in).unaccented()
ASSERT:C1129(Length:C16($in)=Length:C16($out))

For ($i; 1; Length:C16($t); 1)
	
	ASSERT:C1129(Character code:C91($out[[$i]])=Character code:C91("i"); "unaccented()")
	
End for 

For ($i; Length:C16($t)+1; Length:C16($out); 1)
	
	ASSERT:C1129(Character code:C91($out[[$i]])=Character code:C91("I"); "unaccented()")
	
End for 

$t:="ðòóôõö"
$tt:="ÒÓÔÕÖ"
$in:=$t+$tt
$out:=$str.setText($in).unaccented()
ASSERT:C1129(Length:C16($in)=Length:C16($out))

For ($i; 1; Length:C16($t); 1)
	
	ASSERT:C1129(Character code:C91($out[[$i]])=Character code:C91("o"); "unaccented()")
	
End for 

For ($i; Length:C16($t)+1; Length:C16($out); 1)
	
	ASSERT:C1129(Character code:C91($out[[$i]])=Character code:C91("O"); "unaccented()")
	
End for 

$t:="ùúûü"
$tt:="ÙÚÛÜ"
$in:=$t+$tt
$out:=$str.setText($in).unaccented()
ASSERT:C1129(Length:C16($in)=Length:C16($out))

For ($i; 1; Length:C16($t); 1)
	
	ASSERT:C1129(Character code:C91($out[[$i]])=Character code:C91("u"); "unaccented()")
	
End for 

For ($i; Length:C16($t)+1; Length:C16($out); 1)
	
	ASSERT:C1129(Character code:C91($out[[$i]])=Character code:C91("U"); "unaccented()")
	
End for 

$t:="ćĉčċçḉȼ"
$tt:="ĆĈČĊÇḈȻ"
$in:=$t+$tt
$out:=$str.setText($in).unaccented()
ASSERT:C1129(Length:C16($in)=Length:C16($out))

For ($i; 1; Length:C16($t); 1)
	
	ASSERT:C1129(Character code:C91($out[[$i]])=Character code:C91("c"); "unaccented()")
	
End for 

For ($i; Length:C16($t)+1; Length:C16($out); 1)
	
	ASSERT:C1129(Character code:C91($out[[$i]])=Character code:C91("C"); "unaccented()")
	
End for 

// WARNING: Special case for n̈ & N̈
// LENGTH IS ONE MORE FOR THESE 2 CHAR
$t:="ņńǹňñṅṇṋṉn̈"
$tt:="ŃǸŇÑṄŅṆṊṈN̈"
$in:=$t+$tt
$out:=$str.setText($in).unaccented()

//ASSERT(Length($Txt_in)=Length($Txt_out))
ASSERT:C1129(Length:C16($in)-2=Length:C16($out))

//For ($i;1;Length($t);1)
For ($i; 1; Length:C16($t)-1; 1)
	
	ASSERT:C1129(Character code:C91($out[[$i]])=Character code:C91("n"); "unaccented()")
	
End for 

//For ($i;Length($t)+1;Length($Txt_out);1)
For ($i; Length:C16($t); Length:C16($out); 1)
	
	ASSERT:C1129(Character code:C91($out[[$i]])=Character code:C91("N"); "unaccented()")
	
End for 

// mark:-distinctLetters()
$str:=$str.setText("unchecked")
ASSERT:C1129(New collection:C1472("c"; "d"; "e"; "h"; "k"; "n"; "u").equal($str.distinctLetters()))
ASSERT:C1129($str.distinctLetters(";")="c;d;e;h;k;n;u")

$str:=$str.setText("")
ASSERT:C1129($str.distinctLetters().length=0)
ASSERT:C1129($str.distinctLetters(";")="")

// mark:-equal()
ASSERT:C1129($str.setText("Hello world").equal("Hello world"))
ASSERT:C1129(Not:C34($str.setText("Hello world").equal("HELLO WORLD")))
ASSERT:C1129(Not:C34($str.setText("HELLO WORLD").equal("Hello world")))
ASSERT:C1129(Not:C34($str.setText("Hello world").equal("Hello world!")))
ASSERT:C1129($str.setText("").equal(""))

$str.setText("")
ASSERT:C1129($str.equal("Hello world"; "Hello world"))
ASSERT:C1129(Not:C34($str.equal("Hello world"; "HELLO WORLD")))

// mark:-urlEncode()
ASSERT:C1129($str.setText("'Command Name' != '_@'").urlEncode()="%27Command%20Name%27%20%21%3D%20%27_@%27")

$str.setText("")
ASSERT:C1129($str.urlEncode("'Command Name' != '_@'")="%27Command%20Name%27%20%21%3D%20%27_@%27")

// mark:-urlDecode()
ASSERT:C1129($str.setText("%27Command%20Name%27%20%21%3D%20%27_@%27").urlDecode()="'Command Name' != '_@'")

$str.setText("")
ASSERT:C1129($str.urlDecode("%27Command%20Name%27%20%21%3D%20%27_@%27")="'Command Name' != '_@'")

// mark:-containsString()
$str:=$str.setText("Hello World")
ASSERT:C1129($str.containsString("Hello"))
ASSERT:C1129($str.containsString("WORLD"))
ASSERT:C1129(Not:C34($str.containsString("toto")))
ASSERT:C1129($str.containsString("Hello"; True:C214))
ASSERT:C1129(Not:C34($str.containsString("WORLD"; True:C214)))

$str.setText("")
ASSERT:C1129($str.containsString("Hello World"; "Hello"))
ASSERT:C1129($str.containsString("Hello World"; "WORLD"))
ASSERT:C1129($str.containsString("Hello World"; "Hello"; True:C214))
ASSERT:C1129(Not:C34($str.containsString("Hello World"; "WORLD"; True:C214)))

// mark:-contains()
$str:=$str.setText("Hello World")
ASSERT:C1129($str.contains("Hello"; "world"))
ASSERT:C1129(Not:C34($str.contains("Hello"; "vincent")))
ASSERT:C1129(Not:C34($str.contains("Hello"; "world"; "vincent")))

ASSERT:C1129($str.contains(New collection:C1472("Hello"; "world")))
ASSERT:C1129(Not:C34($str.contains(New collection:C1472("Hello"; "vincent"))))
ASSERT:C1129(Not:C34($str.contains(New collection:C1472("Hello"; "vincent"; "world"))))

$str.append("8858"; " ")
ASSERT:C1129($str.contains(New collection:C1472(8858; "Hello"; "world")))
ASSERT:C1129(Not:C34($str.contains(New collection:C1472(88; "Hello"; "world"))))

$str.setText("")
ASSERT:C1129($str.contains("Hello world"; New collection:C1472("Hello"; "world")))
ASSERT:C1129(Not:C34($str.contains("Hello world"; New collection:C1472("Hello"; "vincent"))))

// mark:-toNum()
ASSERT:C1129($str.setText("12.5").toNum()=12.5)
ASSERT:C1129($str.setText("12,5").toNum()=12.5)
ASSERT:C1129($str.setText("12 500").toNum()=12500)
ASSERT:C1129($str.setText("test 25").toNum()=25)
ASSERT:C1129($str.setText("+0003,14").toNum()=3.14)
ASSERT:C1129($str.setText("-3.14000").toNum()=-3.14)
ASSERT:C1129($str.setText("hello world").toNum()=0)

// mark:-concat()
ASSERT:C1129($str.setText("Hello").concat("world")="Hello world")
ASSERT:C1129($str.setText("Hello").concat("world"; "_")="Hello_world")
ASSERT:C1129($str.setText("Hello").concat(New collection:C1472("AAA"; "NNN"; "ZZZ"))="Hello AAA NNN ZZZ")
ASSERT:C1129($str.setText("Hello").concat(New collection:C1472("AAA"; "NNN"; "ZZZ"); ", ")="Hello, AAA, NNN, ZZZ")

// mark:-occurrencesOf()
$t:="The Split string command returns a collection of strings, created by splitting stringToSplit into substrings at the boundaries specified by the separator parameter."
ASSERT:C1129($str.setText($t).occurrencesOf("string")=4)
ASSERT:C1129($str.setText($t).occurrencesOf("s")=14)
ASSERT:C1129($str.setText($t).occurrencesOf(" ")=22)
ASSERT:C1129($str.setText($t).occurrencesOf("hello")=0)
ASSERT:C1129($str.setText($t).occurrencesOf("\r")=0)

$str.setText("")
ASSERT:C1129($str.occurrencesOf($t; "string")=4)
ASSERT:C1129($str.occurrencesOf($t; "s")=14)
ASSERT:C1129($str.occurrencesOf($t; " ")=22)
ASSERT:C1129($str.occurrencesOf($t; "hello")=0)
ASSERT:C1129($str.occurrencesOf($t; "\r")=0)

// mark:-insert()
$str.setText("hello world")

$str.insert(" great"; 6)
ASSERT:C1129($str.value="hello great world")
ASSERT:C1129($str.length=17)
ASSERT:C1129($str.begin=6)
ASSERT:C1129($str.end=12)

$str.insert("Vincent"; 7; MAXLONG:K35:2)
ASSERT:C1129($str.value="hello Vincent")
ASSERT:C1129($str.length=13)
ASSERT:C1129($str.begin=7)
ASSERT:C1129($str.end=13)

// mark:-append()
$str.append("in Paris"; " ")
ASSERT:C1129($str.value="hello Vincent in Paris")
ASSERT:C1129($str.length=22)
ASSERT:C1129($str.begin=13)
ASSERT:C1129($str.end=22)

$str.setText("hello ")
$str.append("world")
ASSERT:C1129($str.value="hello world")
ASSERT:C1129($str.length=11)
ASSERT:C1129($str.begin=6)
ASSERT:C1129($str.end=11)

// mark:-extract()
ASSERT:C1129($str.extract(String:C10(Pi:K30:1); "numeric")=Pi:K30:1)
ASSERT:C1129($str.extract("hello world"; "numeric")=0)
ASSERT:C1129($str.extract("12 worlds"; "numeric")=12)
ASSERT:C1129($str.extract("3,14"; "numeric")=3.14)
ASSERT:C1129($str.extract("3.14"; "numeric")=3.14)

// mark:-replace()
$t:="If you pass the optional * parameter, you indicate that the object parameter is "\
+"an object name (string). If you do not pass this parameter, you indicate that "\
+"the object parameter is a variable. In this case, you pass a variable reference "\
+"instead of a string. For more information about object names, refer to the "\
+"Object Properties section."

$tt:=$str.setText($t).replace("the"; "_THE_")
ASSERT:C1129(cs:C1710.str.new($tt).occurrencesOf("_THE_")=4)
ASSERT:C1129($tt=$str.replace(New collection:C1472("the"); New collection:C1472("_THE_")))

$tt:=$str.setText("abcaabbcc").replace(New collection:C1472("a"; "c"); New collection:C1472("A"; "©"))
ASSERT:C1129(cs:C1710.str.new($tt).equal("Ab©AAbb©©"))

ASSERT:C1129($str.setText("Hello World").replace("World"; "Vincent")="Hello Vincent")
ASSERT:C1129($str.setText("Hello World").replace(" World"; Null:C1517)="Hello")

// mark:-xmlEncode()
ASSERT:C1129($str.setText("&").xmlEncode()="&amp;")
ASSERT:C1129($str.setText("<").xmlEncode()="&lt;")
ASSERT:C1129($str.setText(">").xmlEncode()=">")
ASSERT:C1129($str.setText("<hello world>").xmlEncode()="&lt;hello world>")

// mark:-isJson(), isJsonArray(), isJsonObject()
ASSERT:C1129($str.setText("{\"test\":1,\"test\":1}").isJson())
ASSERT:C1129($str.setText("[1,2,{\"test\":1}]").isJson())
ASSERT:C1129(Not:C34($str.setText("hello {world}").isJson()))

ASSERT:C1129($str.setText("{\"test\":1,\"test\":1}").isJsonObject())
ASSERT:C1129($str.setText("{\"test\":{\"test\":1}}").isJsonObject())
ASSERT:C1129(Not:C34($str.setText("hello {world}").isJsonObject()))
ASSERT:C1129(Not:C34($str.setText("[\"test\":1,\"test\":1]").isJsonObject()))

ASSERT:C1129($str.setText("[1,2,3,null]").isJsonArray())
ASSERT:C1129($str.setText("[1,2,{\"test\":1}]").isJsonArray())
ASSERT:C1129(Not:C34($str.setText("[hello] {world}").isJsonArray()))
ASSERT:C1129(Not:C34($str.setText("{\"test\":1,\"test\":1}").isJsonArray()))


$str.setText("")

ASSERT:C1129($str.isJson("{\"test\":1,\"test\":1}"))
ASSERT:C1129($str.isJson("[1,2,{\"test\":1}]"))
ASSERT:C1129(Not:C34($str.isJson("hello {world}")))

ASSERT:C1129($str.isJsonObject("{\"test\":1,\"test\":1}"))
ASSERT:C1129($str.isJsonObject("{\"test\":{\"test\":1}}"))
ASSERT:C1129(Not:C34($str.isJsonObject("hello {world}")))
ASSERT:C1129(Not:C34($str.isJsonObject("[\"test\":1,\"test\":1]")))

ASSERT:C1129($str.isJsonArray("[1,2,3,null]"))
ASSERT:C1129($str.isJsonArray("[1,2,{\"test\":1}]"))
ASSERT:C1129(Not:C34($str.isJsonArray("[hello] {world}")))
ASSERT:C1129(Not:C34($str.isJsonArray("{\"test\":1,\"test\":1}")))





// mark:-versionCompare()
ASSERT:C1129($str.setText("9.0").versionCompare("9.1.2")=-1)
ASSERT:C1129($str.setText("9.1.2").versionCompare("9.0")=1)
ASSERT:C1129($str.setText("9.1.2").versionCompare("9.1.2")=0)

ASSERT:C1129($str.setText("9").versionCompare("9.0")=0)
ASSERT:C1129($str.setText("9.0.0").versionCompare("9.0")=0)
ASSERT:C1129($str.setText("9").versionCompare("9.0.0")=0)
ASSERT:C1129($str.setText("9.0.0").versionCompare("9.0.0")=0)

ASSERT:C1129($str.setText("9").versionCompare("9.0.1")=-1)

ASSERT:C1129($str.setText("9 0").versionCompare("9 1 2"; " ")=-1)
ASSERT:C1129($str.setText("9 1 2").versionCompare("9 0"; " ")=1)
ASSERT:C1129($str.setText("9/1/2").versionCompare("9/0"; "/")=1)

// mark:-truncate()
ASSERT:C1129($str.setText("hello").truncate(1)="h…")
ASSERT:C1129($str.setText("hello").truncate(2)="he…")
ASSERT:C1129($str.setText("hello").truncate(3)="hel…")
ASSERT:C1129($str.setText("hello").truncate(4)="hell…")
ASSERT:C1129($str.setText("hello").truncate(5)="hello")
ASSERT:C1129($str.setText("hello").truncate(10)="hello")
ASSERT:C1129($str.setText("hello world").truncate(12)="hello world")

// mark:-lastOccurrenceOf()
$t:="hello world hello world hello world"
$str.setText($t)
ASSERT:C1129($str.lastOccurrenceOf("hello")=25)
ASSERT:C1129($str.lastOccurrenceOf("world")=31)
ASSERT:C1129($str.lastOccurrenceOf("w")=31)
ASSERT:C1129($str.lastOccurrenceOf("hello world")=25)

ASSERT:C1129($str.lastOccurrenceOf("")=0)
ASSERT:C1129($str.lastOccurrenceOf("z")=0)
ASSERT:C1129($str.lastOccurrenceOf("toto")=0)

$t:="The Split string command returns a collection of strings, created by splitting stringToSplit into substrings at the boundaries specified by the separator parameter."
ASSERT:C1129($str.setText($t).lastOccurrenceOf("string")=102)

$t:="hello world"
$str.setText($t)
ASSERT:C1129($str.lastOccurrenceOf("hello")=1)
ASSERT:C1129($str.lastOccurrenceOf("world")=7)

$t:="Champs-Élysées"
$str.setText($t)
ASSERT:C1129($str.lastOccurrenceOf("é")=13)
ASSERT:C1129($str.lastOccurrenceOf("é"; True:C214)=12)

ASSERT:C1129($str.setText(".monFichier").suitableWithFileName()="monFichier")
ASSERT:C1129($str.setText("mon/fichier").suitableWithFileName()="monFichier")
ASSERT:C1129($str.setText("mon\\fichier").suitableWithFileName()="monFichier")
ASSERT:C1129($str.setText("mon:fichier").suitableWithFileName()="monFichier")
ASSERT:C1129($str.setText("mon*fichier").suitableWithFileName()="monFichier")
ASSERT:C1129($str.setText("mon?fichier").suitableWithFileName()="monFichier")
ASSERT:C1129($str.setText("mon\"fichier").suitableWithFileName()="monFichier")
ASSERT:C1129($str.setText("mon<fichier").suitableWithFileName()="monFichier")
ASSERT:C1129($str.setText("mon>fichier").suitableWithFileName()="monFichier")
ASSERT:C1129($str.setText("mon|fichier").suitableWithFileName()="monFichier")
ASSERT:C1129($str.setText("..m/o\\n:F*i?c\"h<i>e|r  ").suitableWithFileName()="monFichier")

$str.setText("https://doc.4d.com/4Dv19/4D/19.1/BASE64-ENCODE.301-5653982.en.html")
ASSERT:C1129($str.base64()="aHR0cHM6Ly9kb2MuNGQuY29tLzREdjE5LzRELzE5LjEvQkFTRTY0LUVOQ09ERS4zMDEtNTY1Mzk4Mi5lbi5odG1s")

err_FINALLY

BEEP:C151