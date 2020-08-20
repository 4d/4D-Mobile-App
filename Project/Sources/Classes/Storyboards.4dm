Class constructor
	C_OBJECT:C1216($1)
	This:C1470.path:=$1
	ASSERT:C1129(OB Instance of:C1731($1; 4D:C1709.Folder))
	
	This:C1470.storyboards:=New collection:C1472()
	
	C_OBJECT:C1216($file)
	For each ($file; This:C1470.path.files(fk recursive:K87:7))
		If ($file.extension=".storyboard")
			This:C1470.storyboards.push(cs:C1710.Storyboard.new($file))
		End if 
	End for each 
	
Function colorAssetFix
	C_OBJECT:C1216($Obj_out; $0)
	$Obj_out:=New object:C1471
	$Obj_out.files:=New collection:C1472
	C_OBJECT:C1216($theme; $1)
	$theme:=$1
	
	C_OBJECT:C1216($storyboard; $result)
	For each ($storyboard; This:C1470.storyboards)
		
		$Obj_out.files.push($storyboard.path.platformPath)
		
		$result:=$storyboard.colorAssetFix($theme)
		ob_error_combine($Obj_out; $result)
		
	End for each 
	
	$Obj_out.success:=Not:C34(ob_error_has($Obj_out))
	$0:=$Obj_out
	
Function imageAssetFix
	C_OBJECT:C1216($Obj_out; $0)
	$Obj_out:=New object:C1471
	$Obj_out.files:=New collection:C1472
	
	C_OBJECT:C1216($storyboard; $result)
	For each ($storyboard; This:C1470.storyboards)
		
		$Obj_out.files.push($storyboard.path.platformPath)
		
		$result:=$storyboard.imageAssetFix()
		ob_error_combine($Obj_out; $result)
		
	End for each 
	
	$Obj_out.success:=Not:C34(ob_error_has($Obj_out))
	$0:=$Obj_out
	