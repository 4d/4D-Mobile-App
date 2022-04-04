//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($caller : Integer; $callback : Text)

If (False:C215)
	C_LONGINT:C283(editor_UPDATE_EXPOSED_CATALOG; $1)
	C_TEXT:C284(editor_UPDATE_EXPOSED_CATALOG; $2)
End if 

CALL FORM:C1391($caller; $callback; "checkProject"; cs:C1710.ExposedStructure.new(True:C214))