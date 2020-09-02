//%attributes = {"invisible":true}

var $1; $ds : Object
If (Count parameters:C259>0)
	$ds:=$1
Else 
	$ds:=ds:C1482
End if 

var $dataClassName : Text
var $entity : 4D:C1709.Entity
For each ($dataClassName; $ds)
	For each ($entity; $ds[$dataClassName].all())
		$entity.drop()
	End for each 
End for each 