
ARRAY LONGINT:C221($tLon_check; 7)
ARRAY TEXT:C222($tTxt_check; 7)

$tLon_check{1}:=0
$tTxt_check{1}:="0 = unchecked box"

$tLon_check{2}:=1
$tTxt_check{2}:="1 = checked box"

$tLon_check{3}:=2
$tTxt_check{3}:="2 (or any value >1) = semi-checked box"

$tLon_check{4}:=-1
$tTxt_check{4}:="-1 = invisible check box"

$tLon_check{5}:=-2
$tTxt_check{5}:="-2 = unchecked box, not enterable"

$tLon_check{6}:=-3
$tTxt_check{6}:="-3 = checked box, not enterable"

$tLon_check{7}:=-4
$tTxt_check{7}:="-4 = semi-checked box, not enterable"


//%W-518.1
COPY ARRAY:C226($tLon_check; (OBJECT Get pointer:C1124(Object named:K67:5; "Column1"))->)
COPY ARRAY:C226($tTxt_check; (OBJECT Get pointer:C1124(Object named:K67:5; "Column2"))->)
//%W+518.1

Form:C1466.tablist:=cs:C1710.widget.new("tab.list")
Form:C1466.tabdetail:=cs:C1710.widget.new("tab.detail")

// A password input
Form:C1466.password:=cs:C1710.input.new("password")
Form:C1466.password.asPassword:=True:C214