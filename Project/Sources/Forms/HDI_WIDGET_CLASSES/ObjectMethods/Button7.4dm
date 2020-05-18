C_OBJECT:C1216($menu)

If (Bool:C1537(Form:C1466.trace))
	
	TRACE:C157
	
End if 

GOTO OBJECT:C206(*;"Input2")

  // Create edit menu
$menu:=cs:C1710.menu.new().edit()

  // Display as popup
$menu.popup()
