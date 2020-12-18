Class extends MobileProject

Class constructor
	var $1 : Object
	
	Super:C1705($1)
	
	This:C1470.isOnError:=False:C215
	
	If (Is macOS:C1572)
		This:C1470.filesToCopy:=Folder:C1567("/Users/qmarciset/Downloads/KotlinScripts/__FILES_TO_COPY__")
		This:C1470.templateFiles:=Folder:C1567("/Users/qmarciset/Downloads/KotlinScripts/__TEMPLATE_FILES__")
		This:C1470.templateForms:=Folder:C1567("/Users/qmarciset/Downloads/KotlinScripts/__TEMPLATE_FORMS__")
	Else 
		This:C1470.filesToCopy:=Folder:C1567("C:/Users/test/Downloads/__FILES_TO_COPY__")
		This:C1470.templateFiles:=Folder:C1567("C:/Users/test/Downloads/__TEMPLATE_FILES__")
		This:C1470.templateForms:=Folder:C1567("C:/Users/test/Downloads/__TEMPLATE_FORMS__")
	End if 
	
	// Artifactory identifiers
	This:C1470.artifactoryIds:=New collection:C1472
	This:C1470.artifactoryIds.push(New object:C1471("ARTIFACTORY_USERNAME"; "admin"))
	This:C1470.artifactoryIds.push(New object:C1471("ARTIFACTORY_PASSWORD"; "password"))
	This:C1470.artifactoryIds.push(New object:C1471("ARTIFACTORY_MACHINE_IP"; "192.168.5.12"))
	
	This:C1470.androidProcess:=cs:C1710.androidProcess.new()
	
	This:C1470.project:=OB Copy:C1225(This:C1470.input)
	This:C1470.project.sdk:=This:C1470.androidProcess.androidSDKFolder().path
	This:C1470.project.path:=Convert path system to POSIX:C1106(This:C1470.project.path)
	
	This:C1470.file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+"projecteditor.json")
	This:C1470.file.setText(JSON Stringify:C1217(This:C1470.project))
	SHOW ON DISK:C922(This:C1470.file.platformPath)
	
	This:C1470.package:=Lowercase:C14(String:C10(This:C1470.project.project.organization.identifier))
	This:C1470.version:="debug"
	This:C1470.apk:=Folder:C1567(This:C1470.project.path).folder("app/build/outputs/apk").folder(This:C1470.version).file("app-"+This:C1470.version+".apk")
	This:C1470.activity:="com.qmobile.qmobileui.activity.loginactivity.LoginActivity"
	
	This:C1470.avdName:="TestAndroid29Device"  // Allowed characters are: a-z A-Z 0-9 . _ -
	This:C1470.serial:=""
	
	
	This:C1470.androidprojectgenerator:=cs:C1710.androidprojectgenerator.new()
	This:C1470.gradlew:=cs:C1710.gradlew.new(This:C1470.project.path)
	This:C1470.avd:=cs:C1710.avd.new()
	This:C1470.emulator:=cs:C1710.androidEmulator.new()
	This:C1470.adb:=cs:C1710.adb.new()
	
	This:C1470.init()
	
	
Function init
	This:C1470.setJavaHome()
	This:C1470.setAndroidHome()
	
	If ((Not:C34(This:C1470.filesToCopy.exists))\
		 | (Not:C34(This:C1470.templateFiles.exists))\
		 | (Not:C34(This:C1470.templateForms.exists)))
		This:C1470.postError("Missing directories for project templating")
		This:C1470.isOnError:=True:C214
	Else 
		// All ok
	End if 
	
	
	//====================================================================
	
	
Function setEnvVarToAll
	var $1 : Variant  // Object or Collection of objects
	
	This:C1470.androidprojectgenerator.setEnvironnementVariable($1)
	This:C1470.gradlew.setEnvironnementVariable($1)
	This:C1470.avd.setEnvironnementVariable($1)
	This:C1470.emulator.setEnvironnementVariable($1)
	This:C1470.adb.setEnvironnementVariable($1)
	
	
	//====================================================================
	
	
Function setJavaHome
	var $Obj_java_home : Object
	
	$Obj_java_home:=This:C1470.androidProcess.getJavaHome()
	
	If ($Obj_java_home.success)
		
		This:C1470.setEnvVarToAll(New object:C1471("JAVA_HOME"; $Obj_java_home.java_home))
		
	Else 
		
		This:C1470.isOnError:=True:C214
		This:C1470.postError($Obj_java_home.errors.join("\r"))
		
	End if 
	
	
	//====================================================================
	
	
Function setAndroidHome
	This:C1470.setEnvVarToAll(New object:C1471("ANDROID_HOME"; This:C1470.project.sdk))
	
	
	//====================================================================
	
	
Function create
	var $0 : Object
	
	var $Obj_generate; $Obj_buildEmbeddedLib; $Obj_copyEmbeddedLib; $Obj_chmod : Object
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	//_____________________________________________________
	// GENERATE PROJECT FILES
	
	If (This:C1470.isOnError=False:C215)
		
		This:C1470.postStep("Generating files")
		
		$Obj_generate:=This:C1470.androidprojectgenerator.generate(This:C1470.file; This:C1470.filesToCopy; This:C1470.templateFiles; This:C1470.templateForms)
		
		If (Not:C34($Obj_generate.success))
			
			This:C1470.isOnError:=True:C214
			This:C1470.postError($Obj_generate.errors.join("\r"))
			$0.errors.combine($Obj_generate.errors)
			
		Else 
			// All ok
		End if 
		
	Else 
		// Already on error
	End if 
	
	
	//_____________________________________________________
	// BUILD EMBEDDED DATA LIBRARY
	
	If (This:C1470.isOnError=False:C215)
		
		This:C1470.postStep("Building embedded data library")
		
		$Obj_buildEmbeddedLib:=This:C1470.androidprojectgenerator.buildEmbeddedDataLib(This:C1470.project.path; This:C1470.package)
		
		If (Not:C34($Obj_buildEmbeddedLib.success))
			
			This:C1470.isOnError:=True:C214
			This:C1470.postError($Obj_buildEmbeddedLib.errors.join("\r"))
			$0.errors.combine($Obj_buildEmbeddedLib.errors)
			
		Else 
			// All ok
		End if 
		
	Else 
		// Already on error
	End if 
	
	
	//_____________________________________________________
	// COPY EMBEDDED DATA LIBRARY
	
	If (This:C1470.isOnError=False:C215)
		
		This:C1470.postStep("Copying embedded data library")
		
		$Obj_copyEmbeddedLib:=This:C1470.androidprojectgenerator.copyEmbeddedDataLib(This:C1470.project.path)
		
		If (Not:C34($Obj_copyEmbeddedLib.success))
			
			This:C1470.isOnError:=True:C214
			This:C1470.postError($Obj_copyEmbeddedLib.errors.join("\r"))
			$0.errors.combine($Obj_copyEmbeddedLib.errors)
			
		Else 
			// All ok
		End if 
		
	Else 
		// Already on error
	End if 
	
	
	//_____________________________________________________
	// GRADLEW ACCESS RIGHTS
	
	If (This:C1470.isOnError=False:C215)
		
		If (Is macOS:C1572)
			
			This:C1470.postStep("Changing gradlew access rights")
			
			$Obj_chmod:=This:C1470.androidprojectgenerator.chmodGradlew(This:C1470.project.path)
			
			If (Not:C34($Obj_chmod.success))
				
				This:C1470.isOnError:=True:C214
				This:C1470.postError($Obj_chmod.errors.join("\r"))
				$0.errors.combine($Obj_chmod.errors)
				
			Else 
				// All ok
			End if 
			
		Else 
			// Not need to change permissions on Windows
		End if 
		
	Else 
		// Already on error
	End if 
	
	
	//_____________________________________________________
	// END OF PROCEDURE
	
	If (This:C1470.isOnError=False:C215)
		$0.success:=True:C214
	Else 
		// Error occurred
		This:C1470.postError("Creating project failed")
	End if 
	
	
	
	//====================================================================
	
	
Function build
	var $0 : Object
	
	var $Obj_build; $Obj_createEmbeddedDatabase; $Obj_checkAPK : Object
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	This:C1470.gradlew.setEnvironnementVariable(This:C1470.artifactoryIds)\
		.setEnvironnementVariable("currentDirectory"; This:C1470.project.path)
	
	//_____________________________________________________
	// BUILD PROJECT
	
	If (This:C1470.isOnError=False:C215)
		
		This:C1470.postStep("Building project")
		
		$Obj_build:=This:C1470.gradlew.assembleDebug()
		
		If (Not:C34($Obj_build.success))
			
			This:C1470.isOnError:=True:C214
			This:C1470.postError($Obj_build.errors.join("\r"))
			$0.errors.combine($Obj_build.errors)
			
		Else 
			// All ok
		End if 
		
	Else 
		// Already on error
	End if 
	
	
	//_____________________________________________________
	// CREATE EMBEDDED DATABASE
	
	If (This:C1470.isOnError=False:C215)
		
		This:C1470.postStep("Creating embedded database")
		
		$Obj_createEmbeddedDatabase:=This:C1470.gradlew.createEmbeddedDatabase()
		
		If (Not:C34($Obj_createEmbeddedDatabase.success))
			
			This:C1470.isOnError:=True:C214
			This:C1470.postError($Obj_createEmbeddedDatabase.errors.join("\r"))
			$0.errors.combine($Obj_createEmbeddedDatabase.errors)
			
		Else 
			// All ok
		End if 
		
	Else 
		// Already on error
	End if 
	
	
	//_____________________________________________________
	// BUILD PROJECT WITH EMBEDDED DATA
	
	If (This:C1470.isOnError=False:C215)
		
		This:C1470.postStep("Building project with embedded data")
		
		$Obj_build:=This:C1470.gradlew.assembleDebug()
		
		If (Not:C34($Obj_build.success))
			
			This:C1470.isOnError:=True:C214
			This:C1470.postError($Obj_build.errors.join("\r"))
			$0.errors.combine($Obj_build.errors)
			
		Else 
			// All ok
		End if 
		
	Else 
		// Already on error
	End if 
	
	
	//_____________________________________________________
	// CHECK APK
	
	If (This:C1470.isOnError=False:C215)
		
		This:C1470.postStep("Checking APK")
		
		$Obj_checkAPK:=This:C1470.gradlew.checkAPKExists(This:C1470.apk)
		
		If (Not:C34($Obj_checkAPK.success))
			
			This:C1470.isOnError:=True:C214
			This:C1470.postError($Obj_checkAPK.errors.join("\r"))
			$0.errors.combine($Obj_checkAPK.errors)
			
		Else 
			// All ok
		End if 
		
	Else 
		// Already on error
	End if 
	
	
	//_____________________________________________________
	// END OF PROCEDURE
	
	If (This:C1470.isOnError=False:C215)
		$0.success:=True:C214
	Else 
		// Error occurred
		This:C1470.postError("Building project failed")
	End if 
	
	
	//====================================================================
	
	
Function run
	var $0 : Object
	
	var $Obj_serial; $Obj_start; $Obj_wait; $Obj_install; $Obj_launch : Object
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	//_____________________________________________________
	// CREATE AVD IF DOESN'T EXIST
	
	If (This:C1470.isOnError=False:C215)
		
		This:C1470.postStep("Preparing emulator")
		
		If (Not:C34(This:C1470.avd.isAvdExisting(This:C1470.avdName)))
			
			This:C1470.postStep("Creating emulator")
			
			This:C1470.avd.createAvd(This:C1470.avdName; "system-images;android-29;google_apis;x86"; "pixel_xl")
			
		Else 
			// Avd already exists
		End if 
		
	Else 
		// Already on error
	End if 
	
	//_____________________________________________________
	// GET EMULATOR SERIAL
	
	If (This:C1470.isOnError=False:C215)
		
		This:C1470.postStep("Retrieving emulator serial")
		
		$Obj_serial:=This:C1470.adb.getSerial(This:C1470.avdName)
		
		If ($Obj_serial.success)
			
			This:C1470.serial:=$Obj_serial.serial
			
		Else 
			
			If ($Obj_serial.errors.length>0)
				
				// error occurred in getSerial()
				This:C1470.isOnError:=True:C214
				This:C1470.postError($Obj_serial.errors.join("\r"))
				$0.errors.combine($Obj_serial.errors)
				
			Else 
				// Serial not found, but no error
			End if 
			
		End if 
		
	Else 
		// Already on error
	End if 
	
	
	//_____________________________________________________
	// START EMULATOR
	
	If (This:C1470.isOnError=False:C215)
		
		This:C1470.postStep("Starting emulator")
		
		$Obj_start:=This:C1470.emulator.start(This:C1470.avdName)
		
		If (Not:C34($Obj_start.success))
			
			This:C1470.isOnError:=True:C214
			This:C1470.postError($Obj_start.errors.join("\r"))
			$0.errors.combine($Obj_start.errors)
			
		Else 
			// All ok
		End if 
		
	Else 
		// Already on error
	End if 
	
	
	//_____________________________________________________
	// WAIT FOR EMULATOR BOOT
	
	If (This:C1470.isOnError=False:C215)
		
		This:C1470.postStep("Waiting for emulator boot")
		
		$Obj_wait:=This:C1470.adb.waitForBoot(This:C1470.serial)
		
		If (Not:C34($Obj_wait.success))
			
			This:C1470.isOnError:=True:C214
			This:C1470.postError($Obj_wait.errors.join("\r"))
			$0.errors.combine($Obj_wait.errors)
			
		Else 
			// All ok
		End if 
		
	Else 
		// Already on error
	End if 
	
	
	//_____________________________________________________
	// GET EMULATOR SERIAL (if emulator was not already booted, it now is)
	
	If (This:C1470.isOnError=False:C215)
		
		If (This:C1470.serial="")
			
			This:C1470.postStep("Retrieving emulator serial")
			
			$Obj_serial:=This:C1470.adb.getSerial(This:C1470.avdName)
			
			If ($Obj_serial.success)
				
				This:C1470.serial:=$Obj_serial.serial
				
			Else 
				
				This:C1470.isOnError:=True:C214
				
				If ($Obj_serial.errors.length>0)
					
					// error occurred in getSerial()
					This:C1470.postError($Obj_serial.errors.join("\r"))
					$0.errors.combine($Obj_serial.errors)
					
				Else 
					
					// Serial not found, but no error in command
					This:C1470.postError("Could not retrieve emulator serial")
					
				End if 
				
			End if 
			
		Else 
			// serial was already recovered
		End if 
		
	Else 
		// Already on error
	End if 
	
	
	//_____________________________________________________
	// INSTALL APP
	
	If (This:C1470.isOnError=False:C215)
		
		This:C1470.postStep("Installing app")
		
		$Obj_install:=This:C1470.adb.forceInstallApp(This:C1470.serial; This:C1470.package; This:C1470.apk)
		
		If (Not:C34($Obj_install.success))
			
			This:C1470.isOnError:=True:C214
			This:C1470.postError($Obj_install.errors.join("\r"))
			$0.errors.combine($Obj_install.errors)
			
		Else 
			// All ok
		End if 
		
	Else 
		// Already on error
	End if 
	
	
	//_____________________________________________________
	// LAUNCH APP
	
	If (This:C1470.isOnError=False:C215)
		
		This:C1470.postStep("Launching app")
		
		$Obj_launch:=This:C1470.adb.startApp(This:C1470.serial; This:C1470.package; This:C1470.activity)
		
		If (Not:C34($Obj_launch.success))
			
			This:C1470.isOnError:=True:C214
			This:C1470.postError($Obj_launch.errors.join("\r"))
			$0.errors.combine($Obj_launch.errors)
			
		Else 
			// All ok
		End if 
		
	Else 
		// Already on error
	End if 
	
	
	//_____________________________________________________
	// END OF PROCEDURE
	
	If (This:C1470.isOnError=False:C215)
		$0.success:=True:C214
	Else 
		// Error occurred
		This:C1470.postError("Running project failed")
	End if 