C_OBJECT:C1216($menu)

$menu:=menu .windows().popup()

If ($menu.selected)
	
	window ($menu.choice).bringToFront()
	
End if 