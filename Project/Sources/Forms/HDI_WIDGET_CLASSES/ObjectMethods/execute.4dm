
If (Bool:C1537(Form:C1466.trace))
	
	TRACE:C157
	
End if 

Form:C1466.alignLeft.bestSize().enable()
Form:C1466.alignRight.bestSize(Align right:K42:4)
Form:C1466.login.bestSize().enable(Bool:C1537(Form:C1466.trace))
Form:C1466.close.bestSize(Align right:K42:4).enable()

C_OBJECT:C1216($o)
$o:=Form:C1466.blackRect.getCoordinates()
Form:C1466.blackRect.setCoordinates($o.left-10;$o.top-5;$o.right+10;$o.bottom+5)

Form:C1466.greenRect.resizeHorizontally(20)
Form:C1466.yellowRect.moveHorizontally(50)

Form:C1466.redRect.resizeVertically(10)
Form:C1466.blueRect.moveVertically(10)

Form:C1466.grapRect.moveHorizontally(100).resizeHorizontally(-141).resizeVertically(10)

Form:C1466.group1.distributeHorizontally()
