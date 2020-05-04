C_OBJECT:C1216($menu)

$menu:=cs:C1710.menu.new().windows()
$menu.popup()

If ($menu.selected)
	
	window ($menu.choice).bringToFront()
	
End if 