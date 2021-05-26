If (Bool:C1537(OBJECT Get value:C1743("medium")))
	
	Form:C1466.main:=cs:C1710.bmp.new(Self:C308->).getMediumColor()
	
Else 
	
	Form:C1466.main:=cs:C1710.bmp.new(Self:C308->).getDominantColor()
	
End if 

SET TIMER:C645(-1)