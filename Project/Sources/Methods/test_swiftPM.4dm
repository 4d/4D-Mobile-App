//%attributes = {"invisible":true,"preemptive":"capable"}
var $Obj_in; $Obj_out; $Obj_target; $Obj_targetPath : Object
var $Obj_framework : 4D:C1709.Folder

//_____________________________________________________________
TRY
//_____________________________________________________________

$Obj_framework:=cs:C1710.path.new().cacheSdkApple().parent.folder("sdk")

If ($Obj_framework.exists)
	// Else maybe unzip it later...
	
	$Obj_in:=New object:C1471("action"; "describe"; "path"; $Obj_framework)
	$Obj_out:=swiftPM($Obj_in)
	ASSERT:C1129($Obj_out.success; JSON Stringify:C1217($Obj_out))
	
	$Obj_in:=New object:C1471("action"; "package"; "path"; $Obj_framework)
	$Obj_out:=swiftPM($Obj_in)
	ASSERT:C1129($Obj_out.success; JSON Stringify:C1217($Obj_out))
	
	If ($Obj_out.success)
		
		// Prepare sources if needed for target
		For each ($Obj_target; $Obj_out.package.targets)
			
			$Obj_targetPath:=$Obj_framework.folder($Obj_target.path)
			If (Not:C34($Obj_framework.exists))
				// simulate local source folder
				$Obj_targetPath.create()
			End if 
			If ($Obj_targetPath.files().length=0)
				$Obj_targetPath.file("Version.swift").setText("let sdkVersion=\""+$Obj_framework.file("sdkVersion").getText()+"\"")
			End if 
			
		End for each 
		
		// get dependencies, could be time consuming to checkout its
		$Obj_in:=New object:C1471("action"; "dependencies"; "path"; $Obj_framework)
		$Obj_out:=swiftPM($Obj_in)
		ASSERT:C1129($Obj_out.success; JSON Stringify:C1217($Obj_out))
		
	End if 
	
End if 

//_____________________________________________________________
FINALLY