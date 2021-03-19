Class extends MobileProject

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	var $1 : Object
	
	Super:C1705($1)
	
	This:C1470.isOnError:=False:C215
	
	This:C1470.androidProcess:=cs:C1710.androidProcess.new()
	This:C1470.studio:=cs:C1710.studio.new()
	
	This:C1470.project:=OB Copy:C1225(This:C1470.input)
	
	// Cleaning inner $objects
	var $o : Object
	For each ($o; OB Entries:C1720(This:C1470.project.project).query("key=:1"; "$@"))
		
		OB REMOVE:C1226(This:C1470.project.project; $o.key)
		
	End for each 
	
	var $theme; $color : Object
	
	$theme:=This:C1470.themeFromImageFile()
	
	If ($theme.success)
		
		$color:=$theme.BackgroundColor
		
		This:C1470.project.backgroundColor:="#"\
			+Replace string:C233(String:C10($color.red; "&x"); "0x00"; "")\
			+Replace string:C233(String:C10($color.green; "&x"); "0x00"; "")\
			+Replace string:C233(String:C10($color.blue; "&x"); "0x00"; "")
		
		// Else : could not retrieve a theme color from logo image
	End if 
	
	This:C1470.project.sdk:=This:C1470.androidProcess.androidSDKFolder().path
	This:C1470.project.cache_4d_sdk:=This:C1470.path.cacheSdkAndroidUnzipped().path
	This:C1470.project.path:=Convert path system to POSIX:C1106(This:C1470.project.path)
	
	var $projectPathFolder : 4D:C1709.Folder
	
	$projectPathFolder:=Folder:C1567(This:C1470.project.path)
	$projectPathFolder:=$projectPathFolder.folder($projectPathFolder.parent.name)
	$projectPathFolder.create()
	This:C1470.project.path:=$projectPathFolder.path
	
	This:C1470.project.remote_url:=This:C1470.remoteUrl()
	
	var $reformatedPackage : Text
	
	$reformatedPackage:=This:C1470.project.project.product.bundleIdentifier
	
	Rgx_SubstituteText("[^a-zA-Z0-9\\.]"; "_"; ->$reformatedPackage; 0)
	
	$reformatedPackage:=Replace string:C233($reformatedPackage; ".."; ".")
	$reformatedPackage:=Lowercase:C14($reformatedPackage)
	
	This:C1470.project.package:=$reformatedPackage
	
	This:C1470.checkPackage()
	
	
	This:C1470.file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+"projecteditor.json")
	This:C1470.file.setText(JSON Stringify:C1217(This:C1470.project))
	
	This:C1470.logFolder:=ENV.caches("com.4D.mobile/"; True:C214)
	This:C1470.file.copyTo(This:C1470.logFolder; "lastAndroidBuild.4dmobile"; fk overwrite:K87:5)
	
	This:C1470.version:="debug"
	This:C1470.apk:=Folder:C1567(This:C1470.project.path).folder("app/build/outputs/apk").folder(This:C1470.version).file("app-"+This:C1470.version+".apk")
	This:C1470.activity:="com.qmobile.qmobileui.activity.loginactivity.LoginActivity"
	
	This:C1470.avdName:=This:C1470.project.project._simulator
	This:C1470.serial:=""
	
	// Class for create()
	This:C1470.androidprojectgenerator:=cs:C1710.androidprojectgenerator.new(This:C1470.studio.java; This:C1470.studio.kotlinc)
	
	// Class for build()
	This:C1470.gradlew:=cs:C1710.gradlew.new(This:C1470.project.path)
	
	// Classes for run()
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
		
		// Log outputs
		This:C1470.logFolder.file("lastAndroidCreate.out.log").setText(String:C10($o.outputStream); "UTF-8"; Document with LF:K24:22)
		This:C1470.logFolder.file("lastAndroidCreate.err.log").setText(String:C10($o.errorStream); "UTF-8"; Document with LF:K24:22)
		
		If ($o.success)
			
			// * GRADLEW ACCESS RIGHTS
			If (Is macOS:C1572)  // No need to change permissions on Windows
				
				$o:=This:C1470.androidprojectgenerator.chmod(This:C1470.project.path)
				
			End if 
			
			If ($o.success)
				
				// * BUILD EMBEDDED DATA LIBRARY
				This:C1470.postStep("dataSetGeneration")
				
				$o:=This:C1470.androidprojectgenerator.buildEmbeddedDataLib(This:C1470.project.path; This:C1470.project.package)
				
				If ($o.success)
					
					// * COPY EMBEDDED DATA LIBRARY
					$o:=This:C1470.androidprojectgenerator.copyEmbeddedDataLib(This:C1470.project.path)
					
					If ($o.success)
						
						// * CREATE DATASET
						
						If (Not:C34(Bool:C1537(This:C1470.project.project.dataSource.doNotGenerateDataAtEachBuild)))
							
							$o:=This:C1470.dataSet()
							
							// Else: asked to not generate data at each build
						End if 
						
						If ($o.success)
							
							// * COPY RESOURCES
							This:C1470.postStep("copyingResources")
							
							$o:=This:C1470.androidprojectgenerator.copyResources(This:C1470.project.path; This:C1470.project.project._folder)
							
							If ($o.success)
								
								// * COPY ICONS
								$o:=This:C1470.androidprojectgenerator.copyIcons(This:C1470.project.path; This:C1470.project.project.dataModel)
								
								If ($o.success)
									
									If (Not:C34(Bool:C1537(This:C1470.project.project.dataSource.doNotGenerateDataAtEachBuild)))
										
										$o:=This:C1470.androidprojectgenerator.copyDataSet(This:C1470.project.path; This:C1470.project.project._folder)
										
										// Else: asked to not generate data at each build
									End if 
									
									If ($o.success)
										
										// * UNZIP 4D MOBILE SDK
										This:C1470.postStep("decompressionOfTheSdk")
										
										$o:=This:C1470.androidprojectgenerator.unzipSdk()
										
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
			
			$o.errors.insert(0; Get localized string:C991("failedToCreateTheProject"))
			
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
	
	This:C1470.gradlew.setEnvironnementVariable("currentDirectory"; This:C1470.project.path)
	
	If (Not:C34(This:C1470.isOnError))
		
		// * BUILD PROJECT
		This:C1470.postStep("projectBuild")
		
		$o:=This:C1470.gradlew.assembleDebug()
		
		// Log outputs
		This:C1470.logFolder.file("lastAndroidBuild.out.log").setText(String:C10($o.outputStream); "UTF-8"; Document with LF:K24:22)
		This:C1470.logFolder.file("lastAndroidBuild.err.log").setText(String:C10($o.errorStream); "UTF-8"; Document with LF:K24:22)
		
		If ($o.success)
			
			// * CREATE EMBEDDED DATABASE
			$o:=This:C1470.gradlew.createEmbeddedDatabase()
			
			If ($o.success)
				
				// * BUILD PROJECT WITH EMBEDDED DATA
				$o:=This:C1470.gradlew.assembleDebug()
				
				If ($o.success)
					
					// * CHECK APK
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
			
			$o.errors.insert(0; "projectBuildFailure")
			
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
		
		// * START EMULATOR
		$o:=This:C1470.emulator.start(This:C1470.avdName)
		
		If ($o.success)
			
			// * WAIT FOR EMULATOR BOOT (AND GET EMULATOR SERIAL)
			$o:=This:C1470.adb.waitForBoot(This:C1470.avdName)
			
			If ($o.success)
				
				This:C1470.serial:=$o.serial
				
				// * INSTALL APP
				This:C1470.postStep("installingTheApplication")
				
				$o:=This:C1470.adb.forceInstallApp(This:C1470.serial; This:C1470.project.package; This:C1470.apk)
				
				If ($o.success)
					
					// * LAUNCH APP
					This:C1470.postStep("launchingTheApplication")
					
					$o:=This:C1470.adb.waitStartApp(This:C1470.serial; This:C1470.project.package; This:C1470.activity)
					
					If (Not:C34($o.success))
						
						This:C1470.isOnError:=True:C214
						
					End if 
					
				Else 
					
					This:C1470.isOnError:=True:C214
					
				End if 
				//End if 
				
			Else 
				
				This:C1470.isOnError:=True:C214
				
			End if 
			
		Else 
			
			This:C1470.isOnError:=True:C214
			
		End if 
		
		If (This:C1470.isOnError)
			
			$o.errors.insert(0; "failedToLaunchTheSimulator")
			
			This:C1470.postError($o.errors.join("\r"))
			$result.errors.combine($o.errors)
			
		Else 
			
			$result.success:=True:C214
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function remoteUrl()->$result : Text
	
	var $info : Object
	var $http; $host; $port : Text
	
	$info:=WEB Get server info:C1531()
	$http:=Choose:C955($info.security.HTTPSEnabled; "https"; "http")
	$host:=$info.options.webIPAddressToListen[0]
	$port:=String:C10(Choose:C955($info.security.HTTPSEnabled; $info.options.webHTTPSPortID; $info.options.webPortID))
	
	$result:=$http+"://"+$host+":"+$port
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function checkPackage()
	
	If (Position:C15("."; This:C1470.project.package)=0)
		
		This:C1470.isOnError:=True:C214
		This:C1470.postError("The package must have at least one '.' separator ("+This:C1470.project.package+")")
		
		// Else : all ok
	End if 
	
	If (Match regex:C1019("^[\\._0-9]"; This:C1470.project.package; 1))
		
		This:C1470.isOnError:=True:C214
		This:C1470.postError("The package name must begin with a letter ("+This:C1470.project.package+")")
		
		// Else : all ok
	End if 
	
	If (Match regex:C1019("[\\.]$"; This:C1470.project.package; 1))
		
		This:C1470.isOnError:=True:C214
		This:C1470.postError("The package name must not end with a separator ("+This:C1470.project.package+")")
		
		// Else : all ok
	End if 
	
	var $packageParts : Collection
	$packageParts:=Split string:C1554(This:C1470.project.package; ".")
	
	var $part : Text
	
	For each ($part; $packageParts)
		
		If (Match regex:C1019("^[\\._0-9]"; $part; 1))
			
			This:C1470.isOnError:=True:C214
			This:C1470.postError("A package segment must begin with a letter ("+This:C1470.project.package+")")
			
			// Else : all ok 
		End if 
		
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function themeImageFile()->$file : 4D:C1709.File
	$file:=This:C1470.input.project._folder.file("android/main/ic_launcher-playstore.png")