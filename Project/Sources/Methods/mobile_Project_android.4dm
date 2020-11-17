//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_TEXT:C284($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
C_OBJECT:C1216($project; $Obj_cache; $Obj_in)
C_BOOLEAN:C305($isDebug)

If (False:C215)
	C_OBJECT:C1216(mobile_Project_android; $1)
	C_OBJECT:C1216(mobile_Project_android; $0)
End if 


// NO PARAMETERS REQUIRED
$isDebug:=DATABASE.isInterpreted

$Obj_cache:=env_userPathname("cache")
$Obj_cache.create()

// Optional parameters
If (Count parameters:C259>=1)
	
	$Obj_in:=$1
	
	// Add choice lists if any to action parameters
	actions("addChoiceList"; $Obj_in)
	
	If ($isDebug)
		
		// Cache the last build for debug purpose
		ob_writeToFile($Obj_in; $Obj_cache.file("lastBuild.4dmobile"); True:C214)
		
	End if 
	
Else 
	
	If ($isDebug)
		
		// IF no parameters, load from previous launched file
		If (SHARED=Null:C1517)
			
			RECORD.warning("SHARED=Null")
			RECORD.trace()
			COMPONENT_INIT
			
		End if 
		
		$Obj_in:=ob_parseFile($Obj_cache.file("lastBuild.4dmobile")).value
		
	End if 
End if 

//Artifactory

SET ENVIRONMENT VARIABLE:C812("ARTIFACTORY_USERNAME"; "admin")
SET ENVIRONMENT VARIABLE:C812("ARTIFACTORY_PASSWORD"; "password")
SET ENVIRONMENT VARIABLE:C812("ARTIFACTORY_MACHINE_IP"; "192.168.5.12")

$project:=OB Copy:C1225($Obj_in)
$project.sdk:="/Users/quentinmarciset/Library/Android/sdk"
$project.path:=Convert path system to POSIX:C1106($project.path)

$0:=New object:C1471("success"; False:C215)

var $file : 4D:C1709.File
$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+"projecteditor.json")

$file.setText(JSON Stringify:C1217($project))

$Txt_cmd:="/Users/quentinmarciset/Downloads/KotlinScripts/build-and-run.sh '"+$file.path+"'"

LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)

//$file.delete()
SHOW ON DISK:C922($file.platformPath)

$0.out:=$Txt_out
$0.errors:=Split string:C1554($Txt_error; "\n")
$0.success:=Length:C16($Txt_error)=0

SHOW ON DISK:C922($Obj_in.path)

POST_MESSAGE(New object:C1471(\
"target"; $Obj_in.caller; \
"action"; "hide"))

ob_writeToDocument($0; $Obj_cache.file("lastBuild_android.json").platformPath; True:C214)

// ----------------------------------------------------
If ($Obj_in.caller#Null:C1517)
	
	// Send result
	CALL FORM:C1391($Obj_in.caller; "EDITOR_CALLBACK"; "build"; $0)
	
Else 
	
	// Return result
	//$0:=$Obj_out
	
End if 

// ----------------------------------------------------
// End