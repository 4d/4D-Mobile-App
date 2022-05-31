//%attributes = {}

var $projects : Collection
$projects:=_createPrjForTesting()

var $project : Object

var $path : 4D:C1709.Folder
$path:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).folder(Current method name:C684+Generate UUID:C1066)

var $options; $result : Object
$options:=New object:C1471

For each ($project; $projects)
	
	// TODO: maybe add subfolder by test prj
	$result:=cs:C1710.xcDataModel.new($project).run($path.platformPath; $options)
	
	ASSERT:C1129($result.success; JSON Stringify:C1217($result))
	
End for each 

If (Shift down:C543)
	
	SHOW ON DISK:C922($path.platformPath)
	
Else 
	
	$path.delete(Delete with contents:K24:24)
	
End if 