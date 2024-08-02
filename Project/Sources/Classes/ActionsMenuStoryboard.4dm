Class extends Storyboard

Class constructor($in : Object)
	If (Count parameters:C259>0)
		Super:C1705($in)
	Else 
		Super:C1705()
	End if 
	This:C1470.type:="actionsmenuform"
	
Function run($template : Object; $target : Object; $Obj_tags : Object)->$Obj_out : Object
	$Obj_out:=New object:C1471()
	
	This:C1470.checkStoryboardPath($template)  // set default path if not defined
	If (This:C1470.path.exists)
		
		// If we want to edit or o something special on copied files
		$Obj_out.success:=True:C214
		
	Else   // Not a document
		
		ASSERT:C1129(dev_Matrix; "Missing "+This:C1470.type+" storyboard")
		$Obj_out.errors:=New collection:C1472("Missing "+This:C1470.type+" storyboard: "+This:C1470.path.path)
		
	End if 