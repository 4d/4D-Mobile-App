Class extends FormTemplate

Class constructor
	C_OBJECT:C1216($1)
	Super:C1705($1)
	ASSERT:C1129(This:C1470.template.type="listform")
	
	
Function doRun
	C_OBJECT:C1216($0)
	$0:=Super:C1706.doRun()  // copy files
	
	This:C1470.template.inject:=True:C214  // request always to inject files
	
	// If (Bool(featuresFlags._103505))
	$0.storyboard:=storyboard(New object:C1471(\
		"action"; "listform"; \
		"template"; This:C1470.template; \
		"target"; This:C1470.input.path; \
		"tags"; This:C1470.input.tags\
		))
	ob_error_combine($0; $0.storyboard)
	
	// End if
	$0.success:=ob_error_has($0)