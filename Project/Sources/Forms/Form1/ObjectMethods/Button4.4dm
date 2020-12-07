C_OBJECT:C1216($menu)


If (True:C214)
	
	$menu:=cs:C1710.menu.new().fonts()
	$menu.popup()
	
	
	$menu:=cs:C1710.menu.new().fonts(True:C214)
	$menu.popup()
	
	
Else 
	
	$menu:=cs:C1710.menu.new().windows()
	$menu.popup()
	
	If ($menu.selected)
		
		window($menu.choice).bringToFront()
		
	End if 
	
End if 
