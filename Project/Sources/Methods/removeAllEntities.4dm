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

For each ($dataClassName; $ds)
	For each ($entity; $ds[$dataClassName].all())
		$entity.drop()
	End for each 
End for each 