//%attributes = {"invisible":true}
#DECLARE($caller : Integer; $callback : Text)

If (False:C215)
	C_LONGINT:C283(editor_UPDATE_EXPOSED_CATALOG; $1)
	C_TEXT:C284(editor_UPDATE_EXPOSED_CATALOG; $2)
End if 

var $data : Object
var $structure : cs:C1710.structure

$data:=New object:C1471

$structure:=cs:C1710.structure.new()
$data.success:=$structure.success

If ($data.success)
	
	$data.catalog:=$structure.catalog
	
	If ($structure.warnings.length>0)
		
		$data.warnings:=$structure.warnings
		
	End if 
	
Else 
	
	$data.errors:=$structure.errors
	
End if 

CALL FORM:C1391($caller; $callback; "checkProject"; $data)