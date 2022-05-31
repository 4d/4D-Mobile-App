//%attributes = {}

var $projects : Collection
$projects:=_createPrjForTesting()

var $project; $result : Object

For each ($project; $projects)
	
	$result:=dataSet(New object:C1471(\
		"action"; "create"; \
		"project"; $project; \
		"verbose"; True:C214; \
		"digest"; True:C214; \
		"dataSet"; True:C214; \
		"key"; cs:C1710.path.new().key().platformPath))
	
	If (Shift down:C543)
		SHOW ON DISK:C922($result.path)
	End if 
	
End for each 