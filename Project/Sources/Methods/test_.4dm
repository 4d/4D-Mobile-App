//%attributes = {}
C_TEXT:C284($t)

err_TRY

//%W-518.7
C_OBJECT:C1216($o)
ASSERT:C1129(Not:C34(_and(Formula:C1597(Not:C34(Undefined:C82($o))); Formula:C1597($o.test#Null:C1517))); "_and")
$o:=New object:C1471
ASSERT:C1129(Not:C34(_and(Formula:C1597(Not:C34(Undefined:C82($o))); Formula:C1597($o.test#Null:C1517))); "_and")

$o:=New object:C1471(\
"test"; "hello world")

ASSERT:C1129(_and(Formula:C1597(Not:C34(Undefined:C82($o))); Formula:C1597($o.test#Null:C1517)); "_and")
//%W+518.7

ASSERT:C1129(_choose(Count parameters:C259>=1; Formula:C1597($1); Formula:C1597(8858))=8858)
ASSERT:C1129(_choose(2; Formula:C1597($o.test*0); Formula:C1597($o.test*1); Formula:C1597($o.test*2); Formula:C1597($o.test*3))=($o.test*2); "_choose")

ASSERT:C1129(_bool("true"))
ASSERT:C1129(Not:C34(_bool("false")))

ASSERT:C1129(_bool("1"))
ASSERT:C1129(Not:C34(_bool("0")))
ASSERT:C1129(_bool("1.5"))

ASSERT:C1129(Not:C34(_bool(Null:C1517)))

$o:=New object:C1471
//ASSERT(Not(_bool ($o)))  // Null

ASSERT:C1129(Not:C34(_bool($o.test)))  // Null

$o.test:="hello world"
ASSERT:C1129(_bool($o.test))  // Not null

err_FINALLY
