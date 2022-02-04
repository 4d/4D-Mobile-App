//%attributes = {}

var $testAndroid : Boolean
$testAndroid:=False:C215

var $stats; $object : Object

var $file : 4D:C1709.File
$file:=Folder:C1567(fk resources folder:K87:11).file("scripts/Structures.sqlite")  // a file to force test on

If (Not:C34($file.exists))
	$file:=Folder:C1567(fk database folder:K87:14).file("Mobile Projects/New project/project.dataSet/Resources/Structures.sqlite")  // normal path for test app
End if 

If ($file.exists)
	
	var $sqlite3 : 4D:C1709.File
	$sqlite3:=cs:C1710.androidProcess.new().androidSDKFolder().folder("platform-tools").file(Is Windows:C1573 ? "sqlite3.exe" : "sqlite3")
	If ($sqlite3.exists & $testAndroid)
		$stats:=cs:C1710.sqliteSizes.new($sqlite3)
	Else 
		$stats:=cs:C1710.sqliteSizes.new()
	End if 
	
	$object:=$stats.stats($file)
	
	If (Shift down:C543)
		ALERT:C41(JSON Stringify:C1217($object; *))
	End if 
	
	ASSERT:C1129($object.total>0; "no total size for sqlite")
	ASSERT:C1129(OB Keys:C1719($object.tables).length>0; "no table for sqlite sizes")
	
End if 