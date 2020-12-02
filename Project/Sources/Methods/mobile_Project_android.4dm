//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE ($in : Object)->$result : Object

var $isDebug; $isOnError : Boolean
var $cache; $project : Object
var $artifactoryIds; $emulatorList; $extractedAvdNameLines : Collection
var $lep : cs:C1710.lep
var $file; $copySrc; $copyDest; $APK : 4D:C1709.File
var $filesToCopy; $templateFiles; $templateForms : 4D:C1709.Folder
var $version; $buildTask; $package; $avdName; $emulatorLine; $emulatorName; $apkLocation; $activity; $serial : Text

C_LONGINT:C283($Lon_start; $Lon_step)

// get emulator device list: $ANDROID_HOME/platform-tools/adb devices
// get avd list: $ANDROID_HOME/emulator/emulator -list-avds
// delete avd: $ANDROID_HOME/tools/bin/avdmanager delete avd -n TestAndroid29Device5


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

$isOnError:=False:C215

$project:=OB Copy:C1225($in)
// TODO : get SDK path
$project.sdk:="/Users/qmarciset/Library/Android/sdk"
$project.path:=Convert path system to POSIX:C1106($project.path)

$package:=Lowercase:C14(String:C10($project.project.organization.identifier))
$version:="debug"
$buildTask:="assembleDebug"
$avdName:="TestAndroid29Device4"
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

// TODO : get different folder paths

$filesToCopy:=Folder:C1567("/Users/qmarciset/Downloads/KotlinScripts/__FILES_TO_COPY__")

If (Not:C34($filesToCopy.exists))
	ASSERT:C1129(False:C215; "Missing folder at path "+$filesToCopy.path)
End if 

$templateFiles:=Folder:C1567("/Users/qmarciset/Downloads/KotlinScripts/__TEMPLATE_FILES__")

If (Not:C34($templateFiles.exists))
	ASSERT:C1129(False:C215; "Missing folder at path "+$templateFiles.path)
End if 

$templateForms:=Folder:C1567("/Users/qmarciset/Downloads/KotlinScripts/__TEMPLATE_FORMS__")

If (Not:C34($templateForms.exists))
	ASSERT:C1129(False:C215; "Missing folder at path "+$templateForms.path)
End if 


$lep:=cs:C1710.lep.new()\
.setDirectory(path.scripts())\
.setEnvironnementVariable($artifactoryIds)\
.setEnvironnementVariable("ANDROID_HOME"; $project.sdk)


// Set JAVA_HOME

Case of 
		
		//______________________________________________________
	: (Is macOS:C1572)
		
		$lep.launch("/usr/libexec/java_home")
		
		//______________________________________________________
	: (Is Windows:C1573)
		
		$lep.launch("echo %JAVA_HOME%")
		
		//______________________________________________________
	Else 
		
		// A "Case of" statement should never omit "Else"
		
		//______________________________________________________
End case 

If (($lep.errorStream#Null:C1517) & (String:C10($lep.errorStream)#""))
	
	$isOnError:=True:C214
	
	// Failed to generate files
	POST_MESSAGE(New object:C1471(\
		"type"; "alert"; \
		"target"; $in.caller; \
		"additional"; "Failed to get JAVA_HOME"))
	
Else 
	$lep.setEnvironnementVariable("JAVA_HOME"; $lep.outputStream)
End if 


//____________________________________________________________
// GENERATE FILES

If ($isOnError=False:C215)
	
	POST_MESSAGE(New object:C1471(\
		"target"; $in.caller; \
		"additional"; "Generating files"))
	
	// Generating files
	$lep.launch("androidprojectgenerator"+\
		" --project-editor "+$lep.singleQuoted($file.path)+\
		" --files-to-copy "+$lep.singleQuoted($filesToCopy.path)+\
		" --template-files "+$lep.singleQuoted($templateFiles.path)+\
		" --template-forms "+$lep.singleQuoted($templateForms.path))
	
	$result.out:=$lep.outputStream
	$result.errors:=Split string:C1554(String:C10($lep.errorStream); "\n")
	$result.success:=$lep.success
	
	If (($lep.errorStream#Null:C1517) & (String:C10($lep.errorStream)#""))
		
		$isOnError:=True:C214
		
		// Failed to generate files
		POST_MESSAGE(New object:C1471(\
			"type"; "alert"; \
			"target"; $in.caller; \
			"additional"; "Failed to generate files"))
		
	Else 
		// All ok
	End if 
	
Else 
	// Already on error
End if 


//____________________________________________________________
// BUILD EMBEDDED DATA LIBRARY

If ($isOnError=False:C215)
	
	POST_MESSAGE(New object:C1471(\
		"target"; $in.caller; \
		"additional"; "Building embedded data library"))
	
	// TODO : know where kotlinc is
	
	// Building embedded data library
	$lep.launch("/usr/local/bin/kotlinc "+$lep.singleQuoted($project.path+"buildSrc/src/main/java/"+$package+".android.build/database/StaticDataInitializer.kt")+" -d "+$lep.singleQuoted($project.path+"buildSrc/libs/prepopulation.jar"))
	
	$result.out:=$lep.outputStream
	$result.errors:=Split string:C1554(String:C10($lep.errorStream); "\n")
	$result.success:=$lep.success
	
	If (($lep.errorStream#Null:C1517) & (String:C10($lep.errorStream)#""))
		
		$isOnError:=True:C214
		
		// Failed to build embedded data library
		POST_MESSAGE(New object:C1471(\
			"type"; "alert"; \
			"target"; $in.caller; \
			"additional"; "Failed to build embedded data library"))
		
	Else 
		// All ok
	End if 
	
Else 
	// Already on error
End if 


//____________________________________________________________
// COPY EMBEDDED DATA LIBRARY

If ($isOnError=False:C215)
	
	$copySrc:=File:C1566($project.path+"buildSrc/libs/prepopulation.jar")
	
	If ($copySrc.exists)
		
		$copyDest:=$copySrc.copyTo(Folder:C1567($project.path+"app/libs"); fk overwrite:K87:5)
		
		If (Not:C34($copyDest.exists))
			
			// Copy failed
			$isOnError:=True:C214
			$result.out:=Null:C1517
			$result.errors:=New collection:C1472("Could not copy file to destination: "+$copyDest.path)
			$result.success:=False:C215
			
		Else 
			// All ok
		End if 
		
	Else 
		
		// Missing file
		$isOnError:=True:C214
		$result.out:=Null:C1517
		$result.errors:=New collection:C1472("Missing source file for copy: "+$copySrc.path)
		$result.success:=False:C215
		
	End if 
	
Else 
	// Already on error
End if 


//____________________________________________________________
// GRADLEW ACCESS RIGHTS

If ($isOnError=False:C215)
	
	// Chmod
	$lep.launch("chmod +x "+$lep.singleQuoted($project.path+"gradlew"))
	
	$result.out:=$lep.outputStream
	$result.errors:=Split string:C1554(String:C10($lep.errorStream); "\n")
	$result.success:=$lep.success
	
	If (($lep.errorStream#Null:C1517) & (String:C10($lep.errorStream)#""))
		
		$isOnError:=True:C214
		
		// Failed to change access rights
		POST_MESSAGE(New object:C1471(\
			"type"; "alert"; \
			"target"; $in.caller; \
			"additional"; "Failed chmod command"))
		
	Else 
		// All ok
	End if 
	
Else 
	// Already on error
End if 


//____________________________________________________________
// BUILD PROJECT

If ($isOnError=False:C215)
	
	POST_MESSAGE(New object:C1471(\
		"target"; $in.caller; \
		"additional"; "Building project"))
	
	// Building project
	$lep.setEnvironnementVariable("currentDirectory"; $project.path)\
		.launch("gradlew "+$buildTask)
	
	$result.out:=$lep.errorStream
	$result.errors:=Split string:C1554(String:C10($lep.errorStream); "\n")
	$result.success:=$lep.success
	
Else 
	// Already on error
End if 


//____________________________________________________________
// CREATE EMBEDDED DATABASE

If ($isOnError=False:C215)
	
	POST_MESSAGE(New object:C1471(\
		"target"; $in.caller; \
		"additional"; "Creating embedded database"))
	
	// Creating embedded database
	$lep.launch("gradlew app:createDataBase")
	
	$result.out:=$lep.outputStream
	$result.errors:=Split string:C1554(String:C10($lep.errorStream); "\n")
	$result.success:=$lep.success
	
	If (($lep.errorStream#Null:C1517) & (String:C10($lep.errorStream)#""))
		
		$isOnError:=True:C214
		
		// Failed to create embedded database
		POST_MESSAGE(New object:C1471(\
			"type"; "alert"; \
			"target"; $in.caller; \
			"additional"; "Failed to create embedded database"))
		
	Else 
		// All ok
	End if 
	
Else 
	// Already on error
End if 


//____________________________________________________________
// BUILD PROJECT WITH EMBEDDED DATA

If ($isOnError=False:C215)
	
	POST_MESSAGE(New object:C1471(\
		"target"; $in.caller; \
		"additional"; "Building project with embedded database"))
	
	// Building project with embedded database
	$lep.launch("gradlew "+$buildTask)
	
	$result.out:=$lep.errorStream
	$result.errors:=Split string:C1554(String:C10($lep.errorStream); "\n")
	$result.success:=$lep.success
	
Else 
	// Already on error
End if 


//____________________________________________________________
// CHECK APK IS BUILT

If ($isOnError=False:C215)
	
	$APK:=File:C1566($apkLocation)
	
	// CHECK APK EXISTS
	
	If (Not:C34($APK.exists))
		
		// Missing file
		$isOnError:=True:C214
		
		POST_MESSAGE(New object:C1471(\
			"type"; "alert"; \
			"target"; $in.caller; \
			"additional"; "Build failed. No APK found: "+$APK.path))
		
		$result.out:=Null:C1517
		$result.errors:=New collection:C1472("Missing APK file: "+$APK.path)
		$result.success:=False:C215
		
	Else 
		// APK exists
	End if 
	
Else 
	// Already on error
End if 


//____________________________________________________________
// CHECK IF AVD EXISTS

// TODO: get avd list beforehand

If ($isOnError=False:C215)
	
	POST_MESSAGE(New object:C1471(\
		"target"; $in.caller; \
		"additional"; "Preparing emulator"))
	
	// List emulators
	$lep.launch($lep.singleQuoted($project.sdk+"/tools/bin/avdmanager")+" list avd")
	
	$result.out:=$lep.errorStream
	$result.errors:=Split string:C1554(String:C10($lep.errorStream); "\n")
	$result.success:=$lep.success
	
Else 
	// Already on error
End if 


//____________________________________________________________
// CREATE AVD IF DOESN'T EXIST

// TODO : AVD must be created beforehand

If ($isOnError=False:C215)
	
	If (Position:C15($avdName; String:C10($lep.errorStream))=0)
		
		POST_MESSAGE(New object:C1471(\
			"target"; $in.caller; \
			"additional"; "Creating emulator"))
		
		// Emulator doesn't exist yet, now creating with name $avdName
		$lep.launch($lep.singleQuoted($project.sdk+"/tools/bin/avdmanager")+" create avd -n \""+$avdName+"\" -k \"system-images;android-29;google_apis;x86\" --device \"pixel_xl\"")
		
		$result.out:=$lep.errorStream
		$result.errors:=Split string:C1554(String:C10($lep.errorStream); "\n")
		$result.success:=$lep.success
		
	Else 
		// Emulator already exists
	End if 
	
Else 
	// Already on error
End if 


//____________________________________________________________
// LIST ADB DEVICES

// If avd is being created just before, it won't be found here yet, because we need to start the device first. 
// But to wait for the boot, we need its serial. So the creation should be done earlier

If ($isOnError=False:C215)
	
	// List adb devices
	$lep.launch($lep.singleQuoted($project.sdk+"/platform-tools/adb")+" devices")
	
	$result.out:=$lep.outputStream
	$result.errors:=Split string:C1554(String:C10($lep.errorStream); "\n")
	$result.success:=$lep.success
	
	If (($lep.errorStream#Null:C1517) & (String:C10($lep.errorStream)#""))
		
		$isOnError:=True:C214
		
		// Failed to get adb device list
		POST_MESSAGE(New object:C1471(\
			"type"; "alert"; \
			"target"; $in.caller; \
			"additional"; "Failed to get adb device list"))
		
	Else 
		// All ok
	End if 
	
Else 
	// Already on error
End if 


//____________________________________________________________
// FIND EMULATOR SERIAL

If ($isOnError=False:C215)
	
	$emulatorList:=Split string:C1554(String:C10($lep.outputStream); "\n")
	// Removing 'List of devices attached'
	$emulatorList.shift()
	// Removing empty entry (last one)
	$emulatorList.pop()
	
	For each ($emulatorLine; $emulatorList) Until (String:C10($emulatorName)#"")
		
		$serial:=Substring:C12($emulatorLine; 1; (Position:C15("\tdevice"; $emulatorLine)-1))
		
		// Get associated avd name
		$lep.launch($lep.singleQuoted($project.sdk+"/platform-tools/adb")+" -s "+$lep.singleQuoted($serial)+" emu avd name")
		
		If (($lep.outputStream#Null:C1517) & (String:C10($lep.outputStream)#""))
			
			$extractedAvdNameLines:=Split string:C1554(String:C10($lep.outputStream); "\r")
			
			// First line is the avd name
			If ($extractedAvdNameLines[0]=$avdName)
				
				$emulatorName:=$serial
				
			Else 
				// not the associated serial
			End if 
			
		Else 
			// $serial name not found
		End if 
		
		
	End for each 
	
	If (String:C10($emulatorName)="")
		
		$isOnError:=True:C214
		$result.out:=Null:C1517
		$result.errors:=New collection:C1472("Emulator name could not be found")
		$result.success:=False:C215
		
	Else 
		// All ok
	End if 
	
Else 
	// Already on error
End if 


//____________________________________________________________
// START EMULATOR

If ($isOnError=False:C215)
	
	POST_MESSAGE(New object:C1471(\
		"target"; $in.caller; \
		"additional"; "Starting emulator"))
	
	// Starting emulator
	$lep.asynchronous()\
		.launch($lep.singleQuoted($project.sdk+"/emulator/emulator")+" -avd \""+$avdName+"\" -no-boot-anim")
	
	$result.out:=$lep.outputStream
	$result.errors:=Split string:C1554(String:C10($lep.errorStream); "\n")
	$result.success:=$lep.success
	
	If (($lep.errorStream#Null:C1517) & (String:C10($lep.errorStream)#""))
		
		$isOnError:=True:C214
		
		// Failed to start emulator
		POST_MESSAGE(New object:C1471(\
			"type"; "alert"; \
			"target"; $in.caller; \
			"additional"; "Failed to start emulator"))
		
	Else 
		// All ok
	End if 
	
Else 
	// Already on error
End if 


//____________________________________________________________
// WAIT FOR EMULATOR BOOT

If ($isOnError=False:C215)
	
	$lep.synchronous()
	
	// Time elapsed
	$Lon_start:=Milliseconds:C459
	
	Repeat 
		
		IDLE:C311
		DELAY PROCESS:C323(Current process:C322; 120)
		// Get emulator boot status
		$lep.launch($lep.singleQuoted($project.sdk+"/platform-tools/adb")+" -s "+$lep.singleQuoted($emulatorName)+" shell getprop sys.boot_completed")
		
		$Lon_step:=Milliseconds:C459-$Lon_start
		
	Until (String:C10($lep.outputStream)="1")\
		 | ($Lon_step>30000)
	
	// Timeout
	If ((String:C10($lep.outputStream)#"1")\
		 & ($Lon_step>30000))
		
		$isOnError:=True:C214
		$result.out:=Null:C1517
		$result.errors:=New collection:C1472("Timeout when booting emulator.")
		$result.success:=False:C215
		
	End if 
	
Else 
	// Already on error
End if 


//____________________________________________________________
// CHECK APP ALREADY INSTALLED

If ($isOnError=False:C215)
	
	POST_MESSAGE(New object:C1471(\
		"target"; $in.caller; \
		"additional"; "Checking package list"))
	
	// Get package list
	$lep.launch($lep.singleQuoted($project.sdk+"/platform-tools/adb")+" -s "+$lep.singleQuoted($emulatorName)+" shell pm list packages")
	
	$result.out:=$lep.outputStream
	$result.errors:=Split string:C1554(String:C10($lep.errorStream); "\n")
	$result.success:=$lep.success
	
	If (($lep.errorStream#Null:C1517) & (String:C10($lep.errorStream)#""))
		
		$isOnError:=True:C214
		
		// Failed to get package list
		POST_MESSAGE(New object:C1471(\
			"type"; "alert"; \
			"target"; $in.caller; \
			"additional"; "Failed to get package list"))
		
	Else 
		// All ok
	End if 
	
Else 
	// Already on error
End if 


//____________________________________________________________
// UNINSTALL APP IF ALREADY INSTALLED

If ($isOnError=False:C215)
	
	// Uninstall app if already in package list
	If (Position:C15($package; String:C10($lep.outputStream))>0)
		
		POST_MESSAGE(New object:C1471(\
			"target"; $in.caller; \
			"additional"; "Uninstalling application on device"))
		
		// APK already installed, uninstalling first
		$lep.launch($lep.singleQuoted($project.sdk+"/platform-tools/adb")+" -s "+$lep.singleQuoted($emulatorName)+" uninstall \""+$package+"\"")
		
		$result.out:=$lep.outputStream
		$result.errors:=Split string:C1554(String:C10($lep.errorStream); "\n")
		$result.success:=$lep.success
		
		If (($lep.errorStream#Null:C1517) & (String:C10($lep.errorStream)#""))
			
			$isOnError:=True:C214
			
			// Failed to uninstall the app
			POST_MESSAGE(New object:C1471(\
				"type"; "alert"; \
				"target"; $in.caller; \
				"additional"; "Failed to uninstall the app"))
			
		Else 
			// All ok
		End if 
		
	Else 
		// APK not installed yet
	End if 
Else 
	// Already on error
End if 


//____________________________________________________________
// INSTALL APPLICATION ON DEVICE

If ($isOnError=False:C215)
	
	POST_MESSAGE(New object:C1471(\
		"target"; $in.caller; \
		"additional"; "Installing application on device"))
	
	// Installing application on device
	$lep.launch($lep.singleQuoted($project.sdk+"/platform-tools/adb")+" -s "+$lep.singleQuoted($emulatorName)+" install -t "+$lep.singleQuoted($apkLocation))
	
	$result.out:=$lep.outputStream
	$result.errors:=Split string:C1554(String:C10($lep.errorStream); "\n")
	$result.success:=$lep.success
	
	If (($lep.errorStream#Null:C1517) & (String:C10($lep.errorStream)#""))
		
		$isOnError:=True:C214
		
		// Failed to install the app
		POST_MESSAGE(New object:C1471(\
			"type"; "alert"; \
			"target"; $in.caller; \
			"additional"; "Failed to install the app"))
		
	Else 
		// All ok
	End if 
	
Else 
	// Already on error
End if 


//____________________________________________________________
// START APP ON DEVICE

If ($isOnError=False:C215)
	
	POST_MESSAGE(New object:C1471(\
		"target"; $in.caller; \
		"additional"; "Starting application on device"))
	
	// Starting application on device
	$lep.launch($lep.singleQuoted($project.sdk+"/platform-tools/adb")+" -s "+$lep.singleQuoted($emulatorName)+" shell am start -n "+$lep.singleQuoted($package+"/"+$activity))
	
	$result.out:=$lep.outputStream
	$result.errors:=Split string:C1554(String:C10($lep.errorStream); "\n")
	$result.success:=$lep.success
	
	If (($lep.errorStream#Null:C1517) & (String:C10($lep.errorStream)#""))
		
		$isOnError:=True:C214
		
		// Failed to start the app
		POST_MESSAGE(New object:C1471(\
			"type"; "alert"; \
			"target"; $in.caller; \
			"additional"; "Failed to start the app"))
		
	Else 
		// All ok
	End if 
	
Else 
	// Already on error
End if 

// END OF PROCEDURE

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

ob_writeToDocument($result; $cache.file("lastBuild_android.json").platformPath; True:C214)

// ----------------------------------------------------
If ($in.caller#Null:C1517)
	
	// Send result
	CALL FORM:C1391($in.caller; "EDITOR_CALLBACK"; "build"; $result)
	
Else 
	
	// Return result
	
End if 