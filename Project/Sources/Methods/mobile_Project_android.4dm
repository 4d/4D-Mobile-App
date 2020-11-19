//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE ($in : Object)->$result : Object

var $isDebug : Boolean
var $cache; $project : Object
var $c : Collection
var $file : 4D:C1709.File
var $lep : cs:C1710.lep


// NO PARAMETERS REQUIRED
$isDebug:=DATABASE.isInterpreted

$cache:=ENV.caches()
$cache.create()

// Optional parameters
If (Count parameters:C259>=1)
	
	// Add choice lists if any to action parameters
	actions("addChoiceList"; $in)
	
	If ($isDebug)
		
		// Cache the last build for debug purpose
		ob_writeToFile($in; $cache.file("lastBuild.4dmobile"); True:C214)
		
	End if 
	
Else 
	
	If ($isDebug)
		
		// IF no parameters, load from previous launched file
		If (SHARED=Null:C1517)
			
			RECORD.warning("SHARED=Null")
			RECORD.trace()
			COMPONENT_INIT
			
		End if 
		
		$in:=ob_parseFile($cache.file("lastBuild.4dmobile")).value
		
	End if 
End if 

//Artifactory
$result:=New object:C1471("success"; False:C215)

$project:=OB Copy:C1225($in)
$project.sdk:="/Users/quentinmarciset/Library/Android/sdk"
$project.path:=Convert path system to POSIX:C1106($project.path)

$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+"projecteditor.json")
$file.setText(JSON Stringify:C1217($project))

$c:=New collection:C1472
$c.push(New object:C1471("ARTIFACTORY_USERNAME"; "admin"))
$c.push(New object:C1471("ARTIFACTORY_PASSWORD"; "password"))
$c.push(New object:C1471("ARTIFACTORY_MACHINE_IP"; "192.168.5.12"))

$lep:=cs:C1710.lep.new()\
.setEnvironnementVariable($c)

$lep.launch("/Users/quentinmarciset/Downloads/KotlinScripts/build-and-run.sh "+$lep.singleQuoted($file.path))

$result.out:=$lep.outputStream
$result.errors:=Split string:C1554($lep.errorStream; "\n")
$result.success:=$lep.success

If ($result.success)
	
	$file.delete()
	
	POST_MESSAGE(New object:C1471(\
		"target"; $in.caller; \
		"action"; "hide"))
	
	SHOW ON DISK:C922($in.path)
	
Else 
	
	POST_MESSAGE(New object:C1471(\
		"target"; $in.caller; \
		"type"; "alert"; \
		"title"; ".Android Buid Failure"; \
		"additional"; $result.errors.join("\r")))
	
	SHOW ON DISK:C922($file.platformPath)
	
End if 

//Else
//SET ENVIRONMENT VARIABLE("ARTIFACTORY_USERNAME"; "admin")
//SET ENVIRONMENT VARIABLE("ARTIFACTORY_PASSWORD"; "password")
//SET ENVIRONMENT VARIABLE("ARTIFACTORY_MACHINE_IP"; "192.168.5.12")
//$project:=OB Copy($in)
//$project.sdk:="/Users/quentinmarciset/Library/Android/sdk"
//$project.path:=Convert path system to POSIX($project.path)
//$result:=New object("success"; False)
//$file:=Folder(Temporary folder; fk platform path).file(Generate UUID+"projecteditor.json")
//$file.setText(JSON Stringify($project))
//$Txt_cmd:="/Users/quentinmarciset/Downloads/KotlinScripts/build-and-run.sh '"+$file.path+"'"
//LAUNCH EXTERNAL PROCESS($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
////$file.delete()
//SHOW ON DISK($file.platformPath)
//$result.out:=$Txt_out
//$result.errors:=Split string($Txt_error; "\n")
//$result.success:=Length($Txt_error)=0
//End if



ob_writeToDocument($result; $cache.file("lastBuild_android.json").platformPath; True:C214)

// ----------------------------------------------------
If ($in.caller#Null:C1517)
	
	// Send result
	CALL FORM:C1391($in.caller; "EDITOR_CALLBACK"; "build"; $result)
	
Else 
	
	// Return result
	
End if 