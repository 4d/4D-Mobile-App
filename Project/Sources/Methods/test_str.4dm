//%attributes = {}
C_LONGINT:C283($i)
C_TEXT:C284($t;$tt;$Txt_in;$Txt_out)
C_OBJECT:C1216($o)

TRY 

$o:=str 
ASSERT:C1129(Length:C16($o.value)=0)
ASSERT:C1129($o.length=0)

$o.setText("hello world")
ASSERT:C1129($o.value="hello world")
ASSERT:C1129($o.length=11)

$o.setText(Pi:K30:1)
GET SYSTEM FORMAT:C994(Decimal separator:K60:1;$t)
ASSERT:C1129($o.value=Replace string:C233("3.14159265359";".";$t))
ASSERT:C1129($o.length=(12+Length:C16($t)))

  // ============================================
  // trim()
ASSERT:C1129(str ("").trim()="")
ASSERT:C1129(str ("       Hello World").trimTrailing()="Hello World")
ASSERT:C1129(str ("Hello World       ").trimLeading()="Hello World")
ASSERT:C1129(str ("HELLO WORLD").trimLeading()="HELLO WORLD")
ASSERT:C1129(str ("       Hello world          ").trim()="Hello World")

ASSERT:C1129(str ("").trim("_")="")
ASSERT:C1129(str ("_____Hello World").trimTrailing("_")="Hello World")
ASSERT:C1129(str ("Hello World_____").trimLeading("_")="Hello World")
ASSERT:C1129(str ("HELLO WORLD").trimLeading("_")="HELLO WORLD")
ASSERT:C1129(str ("_____Hello world_____").trim("_")="Hello World")

  // ============================================
  // wordWrap()
$Txt_in:="The principle of the XLIFF norm drives to determine a language source in which "\
+"are written all the strings. This language will be the reference language (the "\
+"one from which will be done all the translations). The second language is the "\
+"language said target Who will be used for the dialogs, warnings, prints… This is "\
+"the language of the user."

$Txt_out:="The principle of the XLIFF norm drives to determine a language source in which "\
+"\rare written all the strings. This language will be the reference language (the "\
+"\rone from which will be done all the translations). The second language is the "\
+"\rlanguage said target Who will be used for the dialogs, warnings, prints… This "\
+"\ris the language of the user."

ASSERT:C1129(str ($Txt_in).wordWrap()=$Txt_out)

  // ============================================
  // uperCamelCase()
ASSERT:C1129(str ("").uperCamelCase()="")

$o:=str ("Category ID Element")

$Txt_in:="CategoryIDElement"
$Txt_out:=$o.uperCamelCase()

For ($i;1;Length:C16($Txt_in);1)
	
	ASSERT:C1129(Character code:C91($Txt_out[[$i]])=Character code:C91($Txt_in[[$i]]);"uperCamelCase('CategoryIDElement')")
	
End for 

$Txt_out:=$o.uperCamelCase()

For ($i;1;Length:C16($Txt_in);1)
	
	ASSERT:C1129(Character code:C91($Txt_out[[$i]])=Character code:C91($Txt_in[[$i]]);"uperCamelCase('Category ID Element')")
	
End for 

$Txt_out:=str ("Category_ID_element").uperCamelCase()

For ($i;1;Length:C16($Txt_in);1)
	
	ASSERT:C1129(Character code:C91($Txt_out[[$i]])=Character code:C91($Txt_in[[$i]]);"uperCamelCase('CategoryIDElement')")
	
End for 

$Txt_in:="Category"
$Txt_out:=str ("category").uperCamelCase()

For ($i;1;Length:C16($Txt_in);1)
	
	ASSERT:C1129(Character code:C91($Txt_out[[$i]])=Character code:C91($Txt_in[[$i]]);"uperCamelCase('Category')")
	
End for 

  // ============================================
  // length
ASSERT:C1129(str ("").length=0)
ASSERT:C1129(str ("Hello world").length=Length:C16("Hello world"))

  // ============================================
  // isStyled()
ASSERT:C1129(Not:C34(str ("Hello world").isStyled()))
ASSERT:C1129(Not:C34(str ("xxx\r\nyyy").isStyled()))
ASSERT:C1129(str ("<SPAN STYLE=\"font-family: DESDEMONA\">Hello world</SPAN>").isStyled())
ASSERT:C1129(str ("<span style=\"text-align:left;font-family:'Segoe UI';font-size:9pt;color:#009900\">This is the word <span style=\"color:#D81E05\">red</span></span>").isStyled())

  // ============================================
  // isBoolean()
ASSERT:C1129(str ("true").isBoolean())
ASSERT:C1129(str ("True").isBoolean())
ASSERT:C1129(str ("false").isBoolean())
ASSERT:C1129(str ("False").isBoolean())
ASSERT:C1129(Not:C34(str ("hello").isBoolean()))

  // ============================================
  // isDate()
ASSERT:C1129(str ("1/1/01").isDate())
ASSERT:C1129(str ("01/12/2015").isDate())
ASSERT:C1129(str (String:C10(Current date:C33)).isDate())
ASSERT:C1129(Not:C34(str ("1/1").isDate()))
ASSERT:C1129(Not:C34(str ("hello").isDate()))

  // ============================================
  // isNum()
GET SYSTEM FORMAT:C994(Decimal separator:K60:1;$t)
ASSERT:C1129(str ("100").isNum())
ASSERT:C1129(str ("+1").isNum())
ASSERT:C1129(str ("-10").isNum())
ASSERT:C1129(str ("12"+$t+"5").isNum())
ASSERT:C1129(str (String:C10(Pi:K30:1)).isNum())
ASSERT:C1129(Not:C34(str ("1/1").isNum()))
ASSERT:C1129(Not:C34(str ("hello").isNum()))

  // ============================================
  // isTime()
GET SYSTEM FORMAT:C994(Time separator:K60:11;$t)
ASSERT:C1129(str ("12"+$t+"50").isTime())
ASSERT:C1129(str ("0"+$t+"0"+$t+"30").isTime())
ASSERT:C1129(str (String:C10(Current time:C178)).isTime())
ASSERT:C1129(Not:C34(str ("-10").isTime()))
ASSERT:C1129(Not:C34(str (String:C10(Pi:K30:1)).isTime()))
ASSERT:C1129(Not:C34(str ("1/1").isTime()))
ASSERT:C1129(Not:C34(str ("hello").isTime()))

  // ============================================
  // match()
ASSERT:C1129(str ("today").match("(?m-si)^(?:today|tomorrow|yesterday)$"))
ASSERT:C1129(str ("tomorrow").match("(?m-si)^(?:today|tomorrow|yesterday)$"))
ASSERT:C1129(str ("Hello world").match("h|Hello"))
ASSERT:C1129(Not:C34(str ("Hello world").match("(?m-si)^(?:today|tomorrow|yesterday)$")))

  // ============================================
  // fixedLength()
ASSERT:C1129(str ("").fixedLength(5;"0")="00000")
ASSERT:C1129(str ("").fixedLength(5)="*****")
ASSERT:C1129(str ("75").fixedLength(5;"0")="75000")
ASSERT:C1129(str ("750").fixedLength(5;"0")="75000")
ASSERT:C1129(str ("75013").fixedLength(5;"0")="75013")
ASSERT:C1129(str ("75").fixedLength(5;"_";Align right:K42:4)="___75")
ASSERT:C1129(str ("75").fixedLength(10;Null:C1517;Align right:K42:4)="********75")
ASSERT:C1129(str ("75,1").fixedLength(5;"0")="75,10")

  // ============================================
  // unaccented()
$t:="àáâãäå"
$tt:="ÀÁÂÃÄÅ"
$Txt_in:=$t+$tt
$Txt_out:=str ($Txt_in).unaccented()
ASSERT:C1129(Length:C16($Txt_in)=Length:C16($Txt_out))

For ($i;1;Length:C16($t);1)
	
	ASSERT:C1129(Character code:C91($Txt_out[[$i]])=Character code:C91("a");"unaccented()")
	
End for 

For ($i;Length:C16($t)+1;Length:C16($Txt_out);1)
	
	ASSERT:C1129(Character code:C91($Txt_out[[$i]])=Character code:C91("A");"unaccented()")
	
End for 

$t:="èéêë"
$tt:="ÈÉÊË"
$Txt_in:=$t+$tt
$Txt_out:=str ($Txt_in).unaccented()
ASSERT:C1129(Length:C16($Txt_in)=Length:C16($Txt_out))

For ($i;1;Length:C16($t);1)
	
	ASSERT:C1129(Character code:C91($Txt_out[[$i]])=Character code:C91("e");"unaccented()")
	
End for 

For ($i;Length:C16($t)+1;Length:C16($Txt_out);1)
	
	ASSERT:C1129(Character code:C91($Txt_out[[$i]])=Character code:C91("E");"unaccented()")
	
End for 

$t:=""
$tt:="ÌÍÎÏ"
$Txt_in:=$t+$tt
$Txt_out:=str ($Txt_in).unaccented()
ASSERT:C1129(Length:C16($Txt_in)=Length:C16($Txt_out))

For ($i;1;Length:C16($t);1)
	
	ASSERT:C1129(Character code:C91($Txt_out[[$i]])=Character code:C91("i");"unaccented()")
	
End for 

For ($i;Length:C16($t)+1;Length:C16($Txt_out);1)
	
	ASSERT:C1129(Character code:C91($Txt_out[[$i]])=Character code:C91("I");"unaccented()")
	
End for 

$t:="ðòóôõö"
$tt:="ÒÓÔÕÖ"
$Txt_in:=$t+$tt
$Txt_out:=str ($Txt_in).unaccented()
ASSERT:C1129(Length:C16($Txt_in)=Length:C16($Txt_out))

For ($i;1;Length:C16($t);1)
	
	ASSERT:C1129(Character code:C91($Txt_out[[$i]])=Character code:C91("o");"unaccented()")
	
End for 

For ($i;Length:C16($t)+1;Length:C16($Txt_out);1)
	
	ASSERT:C1129(Character code:C91($Txt_out[[$i]])=Character code:C91("O");"unaccented()")
	
End for 

$t:="ùúûü"
$tt:="ÙÚÛÜ"
$Txt_in:=$t+$tt
$Txt_out:=str ($Txt_in).unaccented()
ASSERT:C1129(Length:C16($Txt_in)=Length:C16($Txt_out))

For ($i;1;Length:C16($t);1)
	
	ASSERT:C1129(Character code:C91($Txt_out[[$i]])=Character code:C91("u");"unaccented()")
	
End for 

For ($i;Length:C16($t)+1;Length:C16($Txt_out);1)
	
	ASSERT:C1129(Character code:C91($Txt_out[[$i]])=Character code:C91("U");"unaccented()")
	
End for 

$t:="ćĉčċçḉȼ"
$tt:="ĆĈČĊÇḈȻ"
$Txt_in:=$t+$tt
$Txt_out:=str ($Txt_in).unaccented()
ASSERT:C1129(Length:C16($Txt_in)=Length:C16($Txt_out))

For ($i;1;Length:C16($t);1)
	
	ASSERT:C1129(Character code:C91($Txt_out[[$i]])=Character code:C91("c");"unaccented()")
	
End for 

For ($i;Length:C16($t)+1;Length:C16($Txt_out);1)
	
	ASSERT:C1129(Character code:C91($Txt_out[[$i]])=Character code:C91("C");"unaccented()")
	
End for 

  // WARNING: Special case for n̈ & N̈
  // LENGTH IS ONE MORE FOR THESE 2 CHAR
$t:="ņńǹňñṅṇṋṉn̈"
$tt:="ŃǸŇÑṄŅṆṊṈN̈"
$Txt_in:=$t+$tt
$Txt_out:=str ($Txt_in).unaccented()

  //ASSERT(Length($Txt_in)=Length($Txt_out))
ASSERT:C1129(Length:C16($Txt_in)-2=Length:C16($Txt_out))

  //For ($i;1;Length($t);1)
For ($i;1;Length:C16($t)-1;1)
	
	ASSERT:C1129(Character code:C91($Txt_out[[$i]])=Character code:C91("n");"unaccented()")
	
End for 

  //For ($i;Length($t)+1;Length($Txt_out);1)
For ($i;Length:C16($t);Length:C16($Txt_out);1)
	
	ASSERT:C1129(Character code:C91($Txt_out[[$i]])=Character code:C91("N");"unaccented()")
	
End for 

  // ============================================
  // distinctLetters()
$o:=str ("unchecked")
ASSERT:C1129(New collection:C1472("c";"d";"e";"h";"k";"n";"u").equal($o.distinctLetters()))
ASSERT:C1129($o.distinctLetters(";")="c;d;e;h;k;n;u")

$o:=str ("")
ASSERT:C1129($o.distinctLetters().length=0)
ASSERT:C1129($o.distinctLetters(";")="")

  // ============================================
  // equal()
ASSERT:C1129(str ("Hello world").equal("Hello world"))
ASSERT:C1129(Not:C34(str ("Hello world").equal("HELLO WORLD")))
ASSERT:C1129(Not:C34(str ("HELLO WORLD").equal("Hello world")))
ASSERT:C1129(Not:C34(str ("Hello world").equal("Hello world!")))
ASSERT:C1129(str ("").equal(""))

  // ============================================
  // encode()
ASSERT:C1129(str ("'Command Name' != '_@'").encode()="%27Command%20Name%27%20%21%3D%20%27_%40%27")

  // ============================================
  // decode()
ASSERT:C1129(str ("%27Command%20Name%27%20%21%3D%20%27_%40%27").decode()="'Command Name' != '_@'")

  // ============================================
  // contains()
$o:=str ("Hello World")
ASSERT:C1129($o.contains("Hello"))
ASSERT:C1129($o.contains("WORLD"))
ASSERT:C1129(Not:C34($o.contains("toto")))
ASSERT:C1129($o.contains("Hello";True:C214))
ASSERT:C1129(Not:C34($o.contains("WORLD";True:C214)))

  // ============================================
  // toNum()
ASSERT:C1129(str ("12.5").toNum()=12.5)
ASSERT:C1129(str ("12,5").toNum()=12.5)
ASSERT:C1129(str ("12 500").toNum()=12500)
ASSERT:C1129(str ("test 25").toNum()=25)
ASSERT:C1129(str ("+0003,14").toNum()=3.14)
ASSERT:C1129(str ("-3.14000").toNum()=-3.14)
ASSERT:C1129(str ("hello world").toNum()=0)

  // ============================================
  // concat()
ASSERT:C1129(str ("Hello").concat("world")="Hello world")
ASSERT:C1129(str ("Hello").concat("world";"_")="Hello_world")
ASSERT:C1129(str ("Hello").concat(New collection:C1472("AAA";"NNN";"ZZZ"))="Hello AAA NNN ZZZ")
ASSERT:C1129(str ("Hello").concat(New collection:C1472("AAA";"NNN";"ZZZ");", ")="Hello, AAA, NNN, ZZZ")

  // ============================================
  // occurrences()
$t:="The Split string command returns a collection of strings, created by splitting stringToSplit into substrings at the boundaries specified by the separator parameter."
ASSERT:C1129(str ($t).occurrences("string")=4)
ASSERT:C1129(str ($t).occurrences("s")=14)
ASSERT:C1129(str ($t).occurrences(" ")=22)
ASSERT:C1129(str ($t).occurrences("hello")=0)
ASSERT:C1129(str ($t).occurrences("\r")=0)

  // ============================================
ASSERT:C1129(str_cmpVersion ("9.0";"9.1.2")=-1)
ASSERT:C1129(str_cmpVersion ("9.1.2";"9.0")=1)
ASSERT:C1129(str_cmpVersion ("9.1.2";"9.1.2")=0)

ASSERT:C1129(str_cmpVersion ("9";"9.0")=0)
ASSERT:C1129(str_cmpVersion ("9.0.0";"9.0")=0)
ASSERT:C1129(str_cmpVersion ("9";"9.0.0")=0)
ASSERT:C1129(str_cmpVersion ("9.0.0";"9.0.0")=0)

ASSERT:C1129(str_cmpVersion ("9";"9.0.1")=-1)

ASSERT:C1129(str_cmpVersion ("9 0";"9 1 2";" ")=-1)
ASSERT:C1129(str_cmpVersion ("9 1 2";"9 0";" ")=1)
ASSERT:C1129(str_cmpVersion ("9/1/2";"9/0";"/")=1)

  // ============================================
$Txt_in:="ćĉčċçḉȼ"+"ĆĈČĊÇḈȻ"

$Txt_out:=str_format ("replace-accent";$Txt_in)

ASSERT:C1129(Length:C16($Txt_in)=Length:C16($Txt_out))

For ($i;1;7;1)
	
	ASSERT:C1129(Character code:C91($Txt_out[[$i]])=99)
	
End for 

For ($i;8;14;1)
	
	ASSERT:C1129(Character code:C91($Txt_out[[$i]])=67)
	
End for 

FINALLY 