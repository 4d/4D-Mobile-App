

Class constructor
	
	C_TEXT:C284($1)
	
	This:C1470.dataSource:=$1
	This:C1470.value:=Formula from string:C1601($1).call()
	
Function this
	
	C_VARIANT:C1683($0)
	$0:=Formula from string:C1601(This:C1470.dataSource).call()
	
Function value
	
	C_VARIANT:C1683($0)
	$0:=This:C1470.value
	
Function setValue
	
	C_VARIANT:C1683($1)
	This:C1470.value:=$1
	EXECUTE FORMULA:C63(This:C1470.dataSource+":=This.value")