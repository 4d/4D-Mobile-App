
ARRAY TEXT:C222($names; 0)
ARRAY TEXT:C222($values; 0)
C_LONGINT:C283($vlItem)
WEB GET HTTP HEADER:C697($names; $values)
$vlItem:=Find in array:C230($names; "Cookie")
If ($vlItem>0)
	// $values{$vlItem}
End if 