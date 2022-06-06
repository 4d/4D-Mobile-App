//%attributes = {}

// test with current project
COMPONENT_INIT

var $projectFolder : 4D:C1709.Folder
// test on all project (if not, nothing done[bad])
For each ($projectFolder; Folder:C1567(fk database folder:K87:14).folder("Mobile Projects").folders())
	
	var $project : Object
	$project:=JSON Parse:C1218($projectFolder.file("project.4dmobileapp").getText())
	
	var $input : Object
	$input:=New object:C1471()
	$input.catalog:=JSON Parse:C1218($projectFolder.file("catalog.json").getText()).structure.definition
	
	var $result : Object
	
	var $tableId : Text
	For each ($tableId; $project.dataModel)
		
		$input.table:=$project.dataModel[$tableId]
		
		$result:=dumpFieldNames($input)
		
		ASSERT:C1129($result.success; JSON Stringify:C1217($result))
		
	End for each 
	
End for each 