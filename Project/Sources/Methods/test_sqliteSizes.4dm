//%attributes = {}


var $stats; $object : Object

var $file : 4D:C1709.File
$file:=Folder:C1567(fk resources folder:K87:11).file("scripts/Structures.sqlite")

If (Not:C34($file.exists))
	$file:=Folder:C1567(fk database folder:K87:14).folder("Mobile Projects/New project/project.dataSet/Sources/Structures.sqlite")
End if 

If ($file.exists)
	
	$stats:=cs:C1710.sqliteSizes.new()
	$object:=$stats.stats($file)
	
	If (Shift down:C543)
		ALERT:C41(JSON Stringify:C1217($object; *))
		
	End if 
	
	ASSERT:C1129($object.total>0; "no total size for sqlite")
	ASSERT:C1129(OB Keys:C1719($object.tables).length>0; "no table for sqlite sizes")
	
End if 