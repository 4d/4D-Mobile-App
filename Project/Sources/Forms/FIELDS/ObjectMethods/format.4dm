var $0 : Integer
var $ƒ : Object

$0:=-1  // 💪 We manage data entry

$ƒ:=panel

If (Shift down:C543)
	
	$ƒ.showFormatOnDisk(FORM Event:C1606)
	
Else 
	
	$ƒ.doFormatMenu(FORM Event:C1606)
	
End if 

$ƒ.inEdition:=$ƒ.fieldList