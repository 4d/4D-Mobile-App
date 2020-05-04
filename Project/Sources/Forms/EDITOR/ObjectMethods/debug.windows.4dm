C_OBJECT:C1216($o)

$o:=cs:C1710.menu.new().windows().popup()

If ($o.selected)
	
	window ($o.choice).bringToFront()
	
End if 