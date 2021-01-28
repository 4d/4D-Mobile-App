Class extends MobileProject

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
//
Class constructor
	var $1 : Object
	
	Super:C1705($1)
	
	This:C1470.isOnError:=False:C215
	
	// Artifactory identifiers
	This:C1470.artifactoryIds:=New collection:C1472
	This:C1470.artifactoryIds.push(New object:C1471("ARTIFACTORY_USERNAME"; "admin"))
	This:C1470.artifactoryIds.push(New object:C1471("ARTIFACTORY_PASSWORD"; "password"))
	This:C1470.artifactoryIds.push(New object:C1471("ARTIFACTORY_MACHINE_IP"; "192.168.5.12"))
	
	This:C1470.androidProcess:=cs:C1710.androidProcess.new()
	This:C1470.studio:=cs:C1710.studio.new()
	
	This:C1470.project:=OB Copy:C1225(This:C1470.input)
	
	// Cleaning inner $objects
	var $o : Object
	For each ($o; OB Entries:C1720(This:C1470.project.project).query("key=:1"; "$@"))
		OB REMOVE:C1226(This:C1470.project.project; $o.key)
	End for each 
	
	This:C1470.project.sdk:=This:C1470.androidProcess.androidSDKFolder().path
	This:C1470.project.path:=Convert path system to POSIX:C1106(This:C1470.project.path)
	
	This:C1470.file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+"projecteditor.json")
	This:C1470.file.setText(JSON Stringify:C1217(This:C1470.project))
	
	If (Structure file:C489=Structure file:C489(*))
		
		SHOW ON DISK:C922(This:C1470.file.platformPath)
		
	End if 
	
	This:C1470.package:=Lowercase:C14(String:C10(This:C1470.project.project.organization.identifier))
	This:C1470.version:="debug"
	This:C1470.apk:=Folder:C1567(This:C1470.project.path).folder("app/build/outputs/apk").folder(This:C1470.version).file("app-"+This:C1470.version+".apk")
	This:C1470.activity:="com.qmobile.qmobileui.activity.loginactivity.LoginActivity"
	
	This:C1470.avdName:="TestAndroid30Device"  // Allowed characters are: a-z A-Z 0-9 . _ -
	This:C1470.serial:=""
	
	// Class for create()
	This:C1470.androidprojectgenerator:=cs:C1710.androidprojectgenerator.new(This:C1470.studio.java; This:C1470.studio.kotlinc)
	
	// Class for build()
	This:C1470.gradlew:=cs:C1710.gradlew.new(This:C1470.project.path)
	
	// Classes for run()
	This:C1470.avd:=cs:C1710.avd.new()
	This:C1470.emulator:=cs:C1710.androidEmulator.new()
	This:C1470.adb:=cs:C1710.adb.new()
	
	This:C1470.init()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function init
	
	This:C1470.setJavaHome()
	This:C1470.setAndroidHome()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function setEnvVarToAll
	var $1 : Variant  // Object or Collection of objects
	
	This:C1470.androidprojectgenerator.setEnvironnementVariable($1)
	This:C1470.gradlew.setEnvironnementVariable($1)
	This:C1470.avd.setEnvironnementVariable($1)
	This:C1470.emulator.setEnvironnementVariable($1)
	This:C1470.adb.setEnvironnementVariable($1)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function setJavaHome
	
	This:C1470.setEnvVarToAll(New object:C1471("JAVA_HOME"; This:C1470.studio.javaHome.path))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function setAndroidHome
	
	This:C1470.setEnvVarToAll(New object:C1471("ANDROID_HOME"; This:C1470.project.sdk))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function create()->$result : Object
	
	var $o : Object
	
	$result:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	If (Not:C34(This:C1470.isOnError))
		
		// * GENERATE PROJECT FILES
		This:C1470.postStep("workspaceCreation")
		
		$o:=This:C1470.androidprojectgenerator.generate(This:C1470.file)
		
		If ($o.success)
			
			// * GRADLEW ACCESS RIGHTS
			If (Is macOS:C1572)  // No need to change permissions on Windows
				
				//This.postStep(".Adjusting access rights")  //#MARK_LOCALIZE
				$o:=This:C1470.androidprojectgenerator.chmod(This:C1470.project.path)
				
			End if 
			
			If ($o.success)
				
				// * BUILD EMBEDDED DATA LIBRARY
				This:C1470.postStep("dataSetGeneration")
				
				$o:=This:C1470.androidprojectgenerator.buildEmbeddedDataLib(This:C1470.project.path; This:C1470.package)
				
				If ($o.success)
					
					// * COPY EMBEDDED DATA LIBRARY
					$o:=This:C1470.androidprojectgenerator.copyEmbeddedDataLib(This:C1470.project.path)
					
					If ($o.success)
						
						// * COPY RESOURCES
						This:C1470.postStep(".Copying resources")  //#MARK_LOCALIZE
						
						$o:=This:C1470.androidprojectgenerator.copyResources(This:C1470.project.path; This:C1470.project.project._folder)
						
						If (Not:C34($o.success))
							
							This:C1470.isOnError:=True:C214
							
						End if 
						
					Else 
						
						This:C1470.isOnError:=True:C214
						
					End if 
					
				Else 
					
					This:C1470.isOnError:=True:C214
					
				End if 
				
			Else 
				
				This:C1470.isOnError:=True:C214
				
			End if 
			
		Else 
			
			This:C1470.isOnError:=True:C214
			
		End if 
		
		If (This:C1470.isOnError)
			
			$o.errors.insert(".Failure in project creation"; 0)  // #MARK_LOCALIZE
			
			This:C1470.postError($o.errors.join("\r"))
			$result.errors.combine($o.errors)
			
		Else 
			
			$result.success:=True:C214
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function build()->$result : Object
	
	var $o : Object
	
	$result:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	This:C1470.gradlew.setEnvironnementVariable(This:C1470.artifactoryIds)\
		.setEnvironnementVariable("currentDirectory"; This:C1470.project.path)
	
	If (Not:C34(This:C1470.isOnError))
		
		// * BUILD PROJECT
		This:C1470.postStep("projectBuild")
		
		$o:=This:C1470.gradlew.assembleDebug()
		
		If ($o.success)
			
			// * CREATE EMBEDDED DATABASE
			//This.postStep("Creating embedded database")  // #MARK_LOCALIZE
			
			$o:=This:C1470.gradlew.createEmbeddedDatabase()
			
			If ($o.success)
				
				// * BUILD PROJECT WITH EMBEDDED DATA
				//This.postStep("Building project with embedded data")  // #MARK_LOCALIZE
				
				$o:=This:C1470.gradlew.assembleDebug()
				
				If ($o.success)
					
					// * CHECK APK
					//This.postStep("Checking APK")  // #MARK_LOCALIZE
					
					$o:=This:C1470.gradlew.checkAPKExists(This:C1470.apk)
					
					If (Not:C34($o.success))
						
						This:C1470.isOnError:=True:C214
						
					End if 
					
				Else 
					
					This:C1470.isOnError:=True:C214
					
				End if 
				
			Else 
				
				This:C1470.isOnError:=True:C214
				
			End if 
			
		Else 
			
			This:C1470.isOnError:=True:C214
			
		End if 
		
		If (This:C1470.isOnError)
			
			$o.errors.insert(".Building project failed"; 0)  // #MARK_LOCALIZE
			
			This:C1470.postError($o.errors.join("\r"))
			$result.errors.combine($o.errors)
			
		Else 
			
			$result.success:=True:C214
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function run()->$result : Object
	
	var $o : Object
	
	$result:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	If (Not:C34(This:C1470.isOnError))
		
		// * CREATE AVD IF DOESN'T EXIST
		This:C1470.postStep("launchingTheSimulator")
		
		If (Not:C34(This:C1470.avd.isAvdExisting(This:C1470.avdName)))
			
			This:C1470.avd.createAvd(This:C1470.avdName; "system-images;android-30;google_apis;x86"; "pixel_xl")
			
		End if 
		
		// * GET EMULATOR SERIAL
		$o:=This:C1470.adb.getSerial(This:C1470.avdName)
		
		If ($o.success)
			
			This:C1470.serial:=$o.serial
			
		End if 
		
		// * START EMULATOR
		$o:=This:C1470.emulator.start(This:C1470.avdName)
		
		If ($o.success)
			
			// * WAIT FOR EMULATOR BOOT
			$o:=This:C1470.adb.waitForBoot(This:C1470.serial)
			
			If ($o.success)
				
				If (This:C1470.serial="")
					
					// * GET EMULATOR SERIAL (if emulator was not already booted, it now is)
					$o:=This:C1470.adb.getSerial(This:C1470.avdName)
					
					If ($o.success)
						
						This:C1470.serial:=$o.serial
						
					Else 
						
						This:C1470.isOnError:=True:C214
						
						If ($o.errors.length=0)
							
							// Serial not found, but no error in command
							This:C1470.postError(".Could not retrieve emulator serial")  // #MARK_LOCALIZE
							
						End if 
					End if 
				End if 
				
				If (Not:C34(This:C1470.isOnError))
					
					// * INSTALL APP
					This:C1470.postStep("installingTheApplication")
					
					$o:=This:C1470.adb.forceInstallApp(This:C1470.serial; This:C1470.package; This:C1470.apk)
					
					If ($o.success)
						
						// * LAUNCH APP
						This:C1470.postStep("launchingTheApplication")
						
						$o:=This:C1470.adb.startApp(This:C1470.serial; This:C1470.package; This:C1470.activity)
						
						If (Not:C34($o.success))
							
							This:C1470.isOnError:=True:C214
							
						End if 
						
					Else 
						
						This:C1470.isOnError:=True:C214
						
					End if 
				End if 
				
			Else 
				
				This:C1470.isOnError:=True:C214
				
			End if 
			
		Else 
			
			This:C1470.isOnError:=True:C214
			
		End if 
		
		If (This:C1470.isOnError)
			
			$o.errors.insert("failedToLaunchTheSimulator"; 0)
			
			This:C1470.postError($o.errors.join("\r"))
			$result.errors.combine($o.errors)
			
		Else 
			
			$result.success:=True:C214
			
		End if 
	End if 