//%attributes = {}
var $t : Text
var $c : Collection

err_TRY

// Col_formula
$c:=New collection:C1472(Get 4D folder:C485(Current resources folder:K5:16); Get 4D folder:C485(Database folder:K5:14))
$c:=$c.map(Formula:C1597(col_formula).source; "$1.result:=Convert path system to POSIX:C1106($1.value)")
ASSERT:C1129($c[0]=Convert path system to POSIX:C1106(Get 4D folder:C485(Current resources folder:K5:16)))
ASSERT:C1129($c[1]=Convert path system to POSIX:C1106(Get 4D folder:C485(Database folder:K5:14)))

$c:=New collection:C1472(Get 4D folder:C485(Current resources folder:K5:16); Get 4D folder:C485(Database folder:K5:14))
$c:=$c.map(Formula:C1597(col_formula).source; Formula:C1597($1.result:=Convert path system to POSIX:C1106($1.value)))
ASSERT:C1129($c[0]=Convert path system to POSIX:C1106(Get 4D folder:C485(Current resources folder:K5:16)))
ASSERT:C1129($c[1]=Convert path system to POSIX:C1106(Get 4D folder:C485(Database folder:K5:14)))

// _o_Col_notNull
$c:=New collection:C1472(Null:C1517; 1; Null:C1517; 2)
$c[10]:=10
$c:=$c.filter(Formula:C1597(col_formula).source; Formula:C1597($1.result:=($1.value#Null:C1517)))
ASSERT:C1129($c.length=3)
ASSERT:C1129($c[0]=1)
ASSERT:C1129($c[1]=2)
ASSERT:C1129($c[2]=10)

$c:=New collection:C1472(Null:C1517; 1; Null:C1517; 2)
$c[10]:=10
$c:=$c.filter(Formula:C1597(col_formula).source; "$1.result:=($1.value#Null:C1517)")
ASSERT:C1129($c.length=3)
ASSERT:C1129($c[0]=1)
ASSERT:C1129($c[1]=2)
ASSERT:C1129($c[2]=10)

$c:=New collection:C1472(Null:C1517; 1; Null:C1517; 2)
$c[10]:=10
$c:=$c.filter(Formula:C1597(col_formula).source; Formula:C1597($1.result:=($1.value#Null:C1517)))
ASSERT:C1129($c.length=3)
ASSERT:C1129($c[0]=1)
ASSERT:C1129($c[1]=2)
ASSERT:C1129($c[2]=10)

// Test col_distinctObject
$t:="[{\"target\":\"Macintosh HD:Users:emarchand:perforce:ericm:depot:4DComponents:main:Internal User Components:4D Mobile App \\- Mobile:MApp3:Resources:Formatters.strings\",\"types\":[\"strings\"]},{\"success\":true,\"children\":[{\"success\":true,\"children\":[{\"source\""\
+":"+"\"Macintosh HD:Users:emarchand:perforce:ericm:depot:4DComponents:main:Internal User Components:4D Mobile App.4dbase:Resources:mobile:formatters:url:Sources:Formatters:UILabel+url.swift\",\"target\":\"Macintosh HD:Users:emarchand:perforce:ericm:depot:4DComp"+"onents:main:Internal User Components:4D Mobile App - Mobile:MApp3:Sources:Formatters:UILabel+url.swift\",\"types\":[\"swift\"]}],\"source\":\"Macintosh HD:Users:emarchand:perforce:ericm:depot:4DComponents:main:Internal User Components:4D Mobile App.4dbase:Res"+"ources:mobile:formatters:url:Sources:Formatters:\"}],\"source\":\"Macintosh HD:Users:emarchand:perforce:ericm:depot:4DComponents:main:Internal User Components:4D Mobile App.4dbase:Resources:mobile:formatters:url:Sources:\"},{\"target\":\"Macintosh HD:Users:em"+"archand:perforce:ericm:depot:4DComponents:main:Internal User Components:4D Mobile App - Mobile:MApp3:Resources:Formatters.strings\",\"types\":[\"strings\"]}]"
$c:=JSON Parse:C1218($t)
ASSERT:C1129($c.length=3)

$c:=$c.reduce("col_distinctObject"; New collection:C1472())
ASSERT:C1129($c.length=2)

$c:=New collection:C1472(True:C214)
ASSERT:C1129($c.reduce(Formula:C1597(col_formula).source; False:C215; Formula:C1597($1.accumulator:=$1.accumulator | $1.value)))
$c:=New collection:C1472(False:C215)
ASSERT:C1129(Not:C34($c.reduce(Formula:C1597(col_formula).source; False:C215; Formula:C1597($1.accumulator:=$1.accumulator | $1.value))))
$c:=New collection:C1472(False:C215; True:C214)
ASSERT:C1129($c.reduce(Formula:C1597(col_formula).source; False:C215; Formula:C1597($1.accumulator:=$1.accumulator | $1.value)))

err_FINALLY