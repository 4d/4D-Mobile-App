//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE ($in : Object)->$result : Object

var $isDebug : Boolean
var $cache; $project : Object
var $artifactoryIds : Collection
var $file : 4D:C1709.File
var $lep; $lep2 : cs:C1710.lep
var $filesToCopy; $templateFiles; $templateForms : 4D:C1709.Folder
var $APK : 4D:C1709.File
var $version; $buildTask; $package; $avdName; $apkLocation; $activity : Text

C_LONGINT:C283($Lon_start)


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

$result:=New object:C1471("success"; False:C215)

$project:=OB Copy:C1225($in)
$project.sdk:="/Users/quentinmarciset/Library/Android/sdk"
$project.path:=Convert path system to POSIX:C1106($project.path)

$package:=Lowercase:C14(String:C10($project.project.organization.identifier))
$version:="debug"
$buildTask:="assembleDebug"
$avdName:="TestAndroid29Device"
$activity:="com.qmobile.qmobileui.activity.loginactivity.LoginActivity"
$apkLocation:=$project.path+"app/build/outputs/apk/"+$version+"/app-"+$version+".apk"

// Add Artifactory identifiers
$artifactoryIds:=New collection:C1472
$artifactoryIds.push(New object:C1471("ARTIFACTORY_USERNAME"; "admin"))
$artifactoryIds.push(New object:C1471("ARTIFACTORY_PASSWORD"; "password"))
$artifactoryIds.push(New object:C1471("ARTIFACTORY_MACHINE_IP"; "192.168.5.12"))

$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+"projecteditor.json")
$file.setText(JSON Stringify:C1217($project))

//Parameters

$filesToCopy:=Folder:C1567("/Users/quentinmarciset/Downloads/KotlinScripts/__FILES_TO_COPY__")

If (Not:C34($filesToCopy.exists))
	ASSERT:C1129(False:C215; "Missing folder at path "+$filesToCopy.path)
End if 

$templateFiles:=Folder:C1567("/Users/quentinmarciset/Downloads/KotlinScripts/__TEMPLATE_FILES__")

If (Not:C34($templateFiles.exists))
	ASSERT:C1129(False:C215; "Missing folder at path "+$templateFiles.path)
End if 

$templateForms:=Folder:C1567("/Users/quentinmarciset/Downloads/KotlinScripts/__TEMPLATE_FORMS__")

If (Not:C34($templateForms.exists))
	ASSERT:C1129(False:C215; "Missing folder at path "+$templateForms.path)
End if 


// Kscript templating

$lep:=cs:C1710.lep.new()\
.setEnvironnementVariable("currentDirectory"; path.scripts().platformPath)

$lep.launch("androidprojectgenerator"+\
" --project-editor "+$lep.singleQuoted($file.path)+\
" --files-to-copy "+$lep.singleQuoted($filesToCopy.path)+\
" --template-files "+$lep.singleQuoted($templateFiles.path)+\
" --template-forms "+$lep.singleQuoted($templateForms.path))

$result.out:=$lep.outputStream
$result.errors:=Split string:C1554(String:C10($lep.errorStream); "\n")
$result.success:=$lep.success


// Build embedded data shared code

$lep.reset()\
.launch("/usr/local/bin/kotlinc "+$lep.singleQuoted($project.path+"buildSrc/src/main/java/"+$package+".android.build/database/StaticDataInitializer.kt")+" -d "+$lep.singleQuoted($project.path+"buildSrc/libs/prepopulation.jar"))

$result.out:=$lep.outputStream
$result.errors:=Split string:C1554(String:C10($lep.errorStream); "\n")
$result.success:=$lep.success

$lep.reset()\
.launch("cp "+$lep.singleQuoted($project.path+"buildSrc/libs/prepopulation.jar")+" "+$lep.singleQuoted($project.path+"app/libs/prepopulation.jar"))


// Build project

// Chmod
$lep.reset()\
.launch("chmod +x "+$lep.singleQuoted($project.path+"gradlew"))

// Set JAVA_HOME
$lep.reset()\
.launch("/usr/libexec/java_home")
$lep.setEnvironnementVariable("JAVA_HOME"; $lep.outputStream)


// Build
$lep.reset()\
.setEnvironnementVariable($artifactoryIds)\
.setEnvironnementVariable("currentDirectory"; $project.path)\
.launch("gradlew "+$buildTask)

$result.out:=$lep.outputStream
$result.errors:=Split string:C1554(String:C10($lep.errorStream); "\n")
$result.success:=$lep.success

// Creating embedded database
$lep.reset()\
.setEnvironnementVariable("currentDirectory"; $project.path)\
.launch("gradlew app:createDataBase")

// Rebuilding project with embedded data

$lep.reset()\
.setEnvironnementVariable($artifactoryIds)\
.setEnvironnementVariable("currentDirectory"; $project.path)\
.launch("gradlew "+$buildTask)


// Preparing emulator

// Checking emulator exists

$lep.reset()\
.setEnvironnementVariable("ANDROID_HOME"; $project.sdk)\
.launch($lep.singleQuoted($project.sdk+"/tools/bin/avdmanager")+" list avd")

If (Position:C15($avdName; String:C10($lep.errorStream))=0)
	
	// Emulator doesn't exist yet, now creating with name $avdName
	$lep.reset()\
		.setEnvironnementVariable("ANDROID_HOME"; $project.sdk)\
		.launch($lep.singleQuoted($project.sdk+"/tools/bin/avdmanager")+" create avd -n \""+$avdName+"\" -k \"system-images;android-29;google_apis;x86\" --device \"pixel_xl\"")
	
Else 
	// $avdName emulator already exists
End if 

// Checking emulator booted

$lep.reset()\
.launch("ps aux")

If (Position:C15($avdName; String:C10($lep.outputStream))=0)
	
	// Emulator not booted, now booting
	$lep.reset()\
		.setEnvironnementVariable("ANDROID_HOME"; $project.sdk)\
		.asynchronous()\
		.launch($lep.singleQuoted($project.sdk+"/emulator/emulator")+" -avd \""+$avdName+"\" -no-boot-anim")
	
Else 
	// $avdName emulator already booted
End if 


// Wait for boot 
$lep2:=cs:C1710.lep.new()

// Wait for a booted simulator
$Lon_start:=Milliseconds:C459

$lep.reset()\
.setEnvironnementVariable("ANDROID_HOME"; $project.sdk)\
.synchronous()

Repeat 
	
	IDLE:C311
	DELAY PROCESS:C323(Current process:C322; 60)
	$lep.launch($lep.singleQuoted($project.sdk+"/platform-tools/adb")+" shell getprop sys.boot_completed")
	
	$lep2.launch("ps aux")
	
Until (String:C10($lep.outputStream)="1")\
 | (Position:C15($avdName; String:C10($lep2.outputStream))=0)\
 | ((Milliseconds:C459-$Lon_start)>30000)



// Check application already installed

$lep.reset()\
.setEnvironnementVariable("ANDROID_HOME"; $project.sdk)\
.launch($lep.singleQuoted($project.sdk+"/platform-tools/adb")+" shell pm list packages")

If (Position:C15($package; String:C10($lep.outputStream))>0)
	
	// APK already installed, uninstalling first
	$lep.reset()\
		.setEnvironnementVariable("ANDROID_HOME"; $project.sdk)\
		.launch($lep.singleQuoted($project.sdk+"/emulator/emulator")+" -avd \""+$avdName+"\" -no-boot-anim")
	
Else 
	// APK not installed yet
End if 

// Check APK exists

$APK:=File:C1566($apkLocation)

If (Not:C34($APK.exists))
	ASSERT:C1129(False:C215; "Missing APK at path "+$APK.path)
End if 


// Installing application on device

$lep.reset()\
.setEnvironnementVariable("ANDROID_HOME"; $project.sdk)\
.launch($lep.singleQuoted($project.sdk+"/platform-tools/adb")+" install -t "+$lep.singleQuoted($apkLocation))

$result.out:=$lep.outputStream
$result.errors:=Split string:C1554(String:C10($lep.errorStream); "\n")
$result.success:=$lep.success


// Starting the app

$lep.reset()\
.setEnvironnementVariable("ANDROID_HOME"; $project.sdk)\
.launch($lep.singleQuoted($project.sdk+"/platform-tools/adb")+" shell am start -n "+$lep.singleQuoted($package+"/"+$activity))

$result.out:=$lep.outputStream
$result.errors:=Split string:C1554(String:C10($lep.errorStream); "\n")
$result.success:=$lep.success


//$lep.launch($lep.singleQuoted(path.scripts().file("build-and-run.sh").path)+" "+$lep.singleQuoted($file.path))

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
	
	//SHOW ON DISK($file.platformPath)
	
End if 

ob_writeToDocument($result; $cache.file("lastBuild_android.json").platformPath; True:C214)

// ----------------------------------------------------
If ($in.caller#Null:C1517)
	
	// Send result
	CALL FORM:C1391($in.caller; "EDITOR_CALLBACK"; "build"; $result)
	
Else 
	
	// Return result
	
End if 