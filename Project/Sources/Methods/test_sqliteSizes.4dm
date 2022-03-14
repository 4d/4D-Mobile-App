//%attributes = {}

var $testAndroid : Boolean
$testAndroid:=True:C214

var $stats; $object : Object

var $file : 4D:C1709.File

If ($testAndroid)
	
	$file:=Folder:C1567(fk database folder:K87:14).file("Mobile Projects/New project/project.dataSet/android/static.db")  // Normal path for test app
	
Else 
	
	$file:=Folder:C1567(fk resources folder:K87:11).file("scripts/Structures.sqlite")  // A file to force test on
	
	If (Not:C34($file.exists))
		
		$file:=Folder:C1567(fk database folder:K87:14).file("Mobile Projects/New project/project.dataSet/Resources/Structures.sqlite")  // Normal path for test app
		
	End if 
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