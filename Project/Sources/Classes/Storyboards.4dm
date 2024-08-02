Class constructor($path : Object)
	
	var $file : Object
	
	This:C1470.path:=$path
	ASSERT:C1129(OB Instance of:C1731($path; 4D:C1709.Folder))
	
	This:C1470.storyboards:=New collection:C1472()
	
	For each ($file; This:C1470.path.files(fk recursive:K87:7))
		
		If ($file.extension=".storyboard")
			
			This:C1470.storyboards.push(cs:C1710.Storyboard.new($file))
			
		End if 
	End for each 
	
Function colorAssetFix($theme : Object)->$Obj_out : Object
	
	var $result; $storyboard : Object
	
	$Obj_out:=New object:C1471
	$Obj_out.files:=New collection:C1472
	
	For each ($storyboard; This:C1470.storyboards)
		
		$Obj_out.files.push($storyboard.path.platformPath)
		
		$result:=$storyboard.colorAssetFix($theme)
		ob_error_combine($Obj_out; $result)
		
	End for each 
	
	$Obj_out.success:=Not:C34(ob_error_has($Obj_out))
	
Function imageAssetFix()->$Obj_out : Object
	
	var $result; $storyboard : Object
	
	$Obj_out:=New object:C1471
	$Obj_out.files:=New collection:C1472
	
	For each ($storyboard; This:C1470.storyboards)
		
		$Obj_out.files.push($storyboard.path.platformPath)
		
		$result:=$storyboard.imageAssetFix()
		ob_error_combine($Obj_out; $result)
		
	End for each 
	
	$Obj_out.success:=Not:C34(ob_error_has($Obj_out))
	