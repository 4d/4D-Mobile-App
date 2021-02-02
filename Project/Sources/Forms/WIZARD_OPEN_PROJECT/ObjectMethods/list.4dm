var $e : Object

$e:=FORM Event:C1606

Case of 
		
		//__________________________________________________________________________________________
	: ($e.code=On Scroll:K2:57)
		
		If (Form:C1466._index#0)
			
			Form:C1466._selection.setCoordinates(Form:C1466._list.getRowCoordinates(Form:C1466._index)).show()
			
		End if 
		
		//________________________________________
End case 