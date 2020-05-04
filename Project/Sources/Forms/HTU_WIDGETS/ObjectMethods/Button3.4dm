C_LONGINT:C283($bottom;$left;$right;$top)
C_OBJECT:C1216($o)

Form:C1466.button1.bestSize()
Form:C1466.button2.bestSize(Align right:K42:4)
Form:C1466.button3.bestSize()
Form:C1466.button4.bestSize(Align right:K42:4)

Form:C1466.static1.moveHorizontally(50)
Form:C1466.static6.moveVertically(10)
Form:C1466.static3.resizeVertically(10)
Form:C1466.static4.resizeHorizontally(20)

$o:=Form:C1466.static2.getCoordinates()
$left:=$o.left-10
$top:=$o.top-5
$right:=$o.right+10
$bottom:=$o.bottom+5

Form:C1466.static2.setCoordinates($left;$top;$right;$bottom)

Form:C1466.static5.moveHorizontally(100).resizeHorizontally(-141).resizeVertically(10)

Form:C1466.group1.distributeHorizontally()