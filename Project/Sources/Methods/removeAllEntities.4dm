//%attributes = {"invisible":true}
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(removeAllEntities; $1)
End if 

var $dataClassName : Text
var $ds : Object

var $entity : 4D:C1709.Entity

If (Count parameters:C259>0)
	$ds:=$1
Else 
	$ds:=ds:C1482
End if 

var $primaryKeyValue : Variant
var $result : Object
For each ($dataClassName; $ds)
	For each ($entity; $ds[$dataClassName].all())
		$primaryKeyValue:=$entity[$ds[$dataClassName].getInfo().primaryKey]
		
		$result:=$entity.drop()
		If (Not:C34($result.success))
			ASSERT:C1129(False:C215; JSON Stringify:C1217($result))
			TRACE:C157
			
		Else 
			
			C_OBJECT:C1216($inDelete)
			$inDelete:=ds:C1482["__DeletedRecords"].query("__TableName == :1 AND __PrimaryKey == :2"; $dataClassName; $primaryKeyValue)
			ASSERT:C1129($inDelete.length=1; "Record droped not in __DeletedRecords")
			
		End if 
		
		
	End for each 
End for each 