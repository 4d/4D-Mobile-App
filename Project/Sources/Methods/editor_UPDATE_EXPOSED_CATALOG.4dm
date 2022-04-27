//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($in : Object)

If (False:C215)
	C_OBJECT:C1216(editor_UPDATE_EXPOSED_CATALOG; $1)
End if 

var $data : cs:C1710.ExposedStructure

$data:=cs:C1710.ExposedStructure.new(True:C214)
CALL FORM:C1391($in.caller; $in.method; $in.message; $data)