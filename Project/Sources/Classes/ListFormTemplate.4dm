Class extends FormTemplate

Class constructor($in : Object)
	Super:C1705($in)
	ASSERT:C1129(This:C1470.template.type="listform")
	
Function doRun()->$result : Object
	This:C1470.template.inject:=True:C214  // request always to inject files
	
	$result:=Super:C1706.doRun()  // copy files
	
	$result.storyboard:=This:C1470.storyboard().run(This:C1470.template; Folder:C1567(This:C1470.input.path; fk platform path:K87:2); This:C1470.input.tags)
	ob_error_combine($result; $result.storyboard)
	
	$result.success:=ob_error_has($result)
	
Function storyboard->$result : Object
	$result:=cs:C1710.ListFormStoryboard.new()