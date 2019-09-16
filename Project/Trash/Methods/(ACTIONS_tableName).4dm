//%attributes = {"invisible":true}
C_TEXT:C284($0)

If (False:C215)
	C_TEXT:C284(ACTIONS_tableName ;$0)
End if 

$0:=Choose:C955(Num:C11(This:C1470.tableNumber)#0;Table name:C256(This:C1470.tableNumber);Get localized string:C991("choose..."))