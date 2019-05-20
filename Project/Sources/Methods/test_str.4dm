//%attributes = {}
C_LONGINT:C283($i)
C_TEXT:C284($Txt_in;$Txt_out)

TRY 

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

ASSERT:C1129(str_trim ("")="")
ASSERT:C1129(str_trimTrailing ("       Hello World")="Hello World")
ASSERT:C1129(str_trimLeading ("Hello World       ")="Hello World")
ASSERT:C1129(str_trimLeading ("HELLO WORLD")="HELLO WORLD")
ASSERT:C1129(str_trim ("       Hello world          ")="Hello World")

ASSERT:C1129(str_trim ("";"_")="")
ASSERT:C1129(str_trimTrailing ("_____Hello World";"_")="Hello World")
ASSERT:C1129(str_trimLeading ("Hello World_____";"_")="Hello World")
ASSERT:C1129(str_trimLeading ("HELLO WORLD";"_")="HELLO WORLD")
ASSERT:C1129(str_trim ("_____Hello world_____";"_")="Hello World")

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

ASSERT:C1129(str_wordWrap ($Txt_in)=$Txt_out)

$Txt_in:=str_URLEncode ("'Command Name' != '_@'")
ASSERT:C1129($Txt_in="%27Command%20Name%27%20%21%3D%20%27_%40%27")

$Txt_out:=str_URLDecode ($Txt_in)
ASSERT:C1129($Txt_out="'Command Name' != '_@'")

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