Class extends FormTemplate

Class constructor
	C_OBJECT:C1216($1)
	Super:C1705($1)
	ASSERT:C1129(This:C1470.template.type="listform")
	
Function secondPass
	C_OBJECT:C1216($0; $Obj_out)
	$Obj_out:=New object:C1471()
	
	C_OBJECT:C1216($Obj_in; $Obj_template)
	$Obj_in:=This:C1470.input
	$Obj_template:=This:C1470.template
	
	If (This:C1470.copyFilesResult.success)  // we have copied the source in previous case of
		
		$Obj_out.project:=XcodeProjInject(New object:C1471(\
			"node"; This:C1470.copyFilesResult; \
			"mapping"; $Obj_in.projfile.mapping; \
			"proj"; $Obj_in.projfile.value; \
			"target"; $Obj_in.path; \
			"uuid"; $Obj_template.parent.parent.uuid\
			))
		ob_error_combine($Obj_out; $Obj_out.project)
		
		$Obj_in.projfile.mustSave:=True:C214  // project modified
		
	End if 
	
	// If (Bool(featuresFlags._103505))
	$Obj_out.storyboard:=storyboard(New object:C1471(\
		"action"; "listform"; \
		"template"; $Obj_template; \
		"target"; $Obj_in.path; \
		"tags"; $Obj_in.tags\
		))
	ob_error_combine($Obj_out; $Obj_out.storyboard)
	
	// End if
	$Obj_out.success:=ob_error_has($Obj_out)
	
	$0:=$Obj_out