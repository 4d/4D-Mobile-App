Class extends FormTemplate

Class constructor($input : Object)
	Super:C1705($input)
	ASSERT:C1129(This:C1470.template.type="actionopenurlform")
	
Function storyboard()->$result : Object
	$result:=cs:C1710.ActionsMenuStoryboard.new()  // XXX: change if needed
	
Function doRun()->$Obj_out : Object
	$Obj_out:=New object:C1471()
	
	This:C1470.template.inject:=True:C214
	
	var $Obj_result : Object
	$Obj_result:=Super:C1706.doRun()  // copy files: done after modyfing tags in creteIcoAssets and by settings detailsFields
	ob_error_combine($Obj_out; $Obj_result)
	
	$Obj_out.template:=This:C1470.copyFilesResult
	
	This:C1470.input.projfile.mustSave:=True:C214  // project modified
	
	//$Obj_out.storyboard:=This.storyboard().run(This.template; Folder(This.input.path; fk platform path); This.input.tags)
	