
/*══════════════════════*/
Class extends scrollable
/*══════════════════════*/

Class constructor
	
	C_TEXT:C284($1;$2)
	
	If (Count parameters:C259>=2)
		
		Super:C1705($1;$2)
		
	Else 
		
		Super:C1705($1)
		
	End if 
	
Function getDimensions
	
	C_OBJECT:C1216($0)
	C_PICTURE:C286($p)
	C_LONGINT:C283($width;$height)
	
	$p:=This:C1470.getValue()
	
	PICTURE PROPERTIES:C457($p;$width;$height)
	
	$0:=New object:C1471(\
		"width";$width;\
		"height";$height)
	