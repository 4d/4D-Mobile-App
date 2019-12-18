C_OBJECT:C1216($o)

$o:=menu .windows().popup()

If ($o.selected)
	
	window ($o.choice).bringToFront()
	
End if 