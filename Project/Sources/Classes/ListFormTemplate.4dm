Class extends FormTemplate

Class constructor
	C_OBJECT:C1216($1)
	Super:C1705($1)
	ASSERT:C1129(This:C1470.template.type="listform")
	
Function doRun
	C_OBJECT:C1216($0)
	This:C1470.template.inject:=True:C214  // request always to inject files
	
	$0:=Super:C1706.doRun()  // copy files
	
	$0.storyboard:=This:C1470.storyboard().run(This:C1470.template; Folder:C1567(This:C1470.input.path; fk platform path:K87:2); This:C1470.input.tags)
	ob_error_combine($0; $0.storyboard)
	
	$0.success:=ob_error_has($0)
	
Function storyboard->$result : Object
	$result:=cs:C1710.ListFormStoryboard.new()