Class extends MobileProject

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($project : Object)
	
	Super:C1705($project)
	
	This:C1470.isOnError:=False:C215
	
	This:C1470.project:=OB Copy:C1225(This:C1470.input)
	
	// MARK:CLEANING INNER $OBJECTS
	var $o : Object
	For each ($o; OB Entries:C1720(This:C1470.project.project).query("key=:1"; "$@"))
		
		OB REMOVE:C1226(This:C1470.project.project; $o.key)
		
	End for each 
	
	This:C1470.androidProcess:=cs:C1710.androidProcess.new()
	This:C1470.studio:=cs:C1710.studio.new()
	
	This:C1470.project.sdk:=This:C1470.androidProcess.androidSDKFolder().path
	This:C1470.project.cache_4d_sdk:=This:C1470.paths.cacheSdkAndroidUnzipped().path
	This:C1470.project.path:=Folder:C1567(This:C1470.project.path; fk platform path:K87:2).path
	
	// MARK:GET THE PROJECT FOLDER
	var $folder : 4D:C1709.Folder
	$folder:=Folder:C1567(This:C1470.project.path)
	$folder:=$folder.folder($folder.parent.name)
	$folder.create()  // Create, if any
	This:C1470.project.path:=$folder.path
	
	This:C1470.project.remote_url:=This:C1470.remoteUrl()
	This:C1470.project.package:=This:C1470.project.project.product.bundleIdentifier
	
	If (Feature.with("buildWithCmd"))
		This:C1470.project.noData:=Bool:C1537(This:C1470.project.noData)
		This:C1470.project.noSDK:=Bool:C1537(This:C1470.project.noSDK)
	Else 
		This:C1470.project.noData:=False:C215
		This:C1470.project.noSDK:=False:C215
	End if 
	
	This:C1470.project.hasRelations:=True:C214
	This:C1470.project.hasActions:=True:C214
	This:C1470.project.hasDataSet:=True:C214
	This:C1470.project.hasOpenUrlAction:=True:C214
	This:C1470.project.hasAndroidDeepLinking:=Feature.with("androidDeepLinking")
	This:C1470.project.hasKotlinInputControls:=Feature.with("inputControlWithCodeAndroid")
	This:C1470.project.hasCustomLoginForms:=Feature.with("customLoginForms")
	This:C1470.project.hasBuildWithCmd:=Feature.with("buildWithCmd")
	This:C1470.project.hasOpenFromTabBar:=Feature.with("openURLActionsInTabBar")
	This:C1470.project.hasNoData:=This:C1470.project.noData
	This:C1470.project.hasNoSDK:=This:C1470.project.noSDK
	
	This:C1470.project.debugMode:=((Shift down:C543) && (Bool:C1537(dev_Matrix)=True:C214)) ? True:C214 : False:C215
	This:C1470.project.canUseLocalSource:=(Shift down:C543) ? True:C214 : False:C215
	
	This:C1470.project.componentBuild:=String:C10(This:C1470.project.project.info.componentBuild)
	This:C1470.project.ideBuildVersion:=This:C1470.project.project.info.ideBuildVersion
	This:C1470.project.ideVersion:=This:C1470.project.project.info.ideVersion
	
	var $applicationVersion : Text
	var $buildNumber : Integer
	$applicationVersion:=Application version:C493($buildNumber; *)
	
	
	If ($applicationVersion[[1]]="A")
		
		$applicationVersion:="main"
		
	Else 
		
		If (Num:C11($applicationVersion[[7]])=0)
			
			// LTS
			$applicationVersion:=$applicationVersion[[5]]+$applicationVersion[[6]]+".x"
			
		Else 
			
			// Release
			$applicationVersion:=$applicationVersion[[5]]+$applicationVersion[[6]]+"R"+$applicationVersion[[7]]
			
		End if 
		
	End if 
	
	This:C1470.project.branch_version:=String:C10($applicationVersion)
	
	If (Feature.with("openURLActionsInTabBar") || Feature.with("actionsInTabBar"))
		If (This:C1470.project.project._folder.file("mainOrder.json").exists)
			This:C1470.project.project.main.order:=JSON Parse:C1218(This:C1470.project.project._folder.file("mainOrder.json").getText())
		End if 
	End if 
	
	This:C1470.checkPackage()
	
	If (Feature.disabled("androidDataSet"))
		
		This:C1470.file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+"projecteditor.json")
		This:C1470.file.setText(JSON Stringify:C1217(This:C1470.project))
		
		This:C1470.file.copyTo(This:C1470.logFolder; "lastBuild.android.4dmobile"; fk overwrite:K87:5)
	End if 
	
	This:C1470.version:="debug"
	This:C1470.apk:=Folder:C1567(This:C1470.project.path).folder("app/build/outputs/apk").folder(This:C1470.version).file("app-"+This:C1470.version+".apk")
	This:C1470.activity:="com.qmobile.qmobileui.activity.loginactivity.LoginActivity"
	
	This:C1470.avdName:=$project.project._simulator
	This:C1470.serial:=""
	
	// MARK:Class for create()
	This:C1470.androidprojectgenerator:=cs:C1710.androidprojectgenerator.new(This:C1470.studio.java; This:C1470.studio.kotlinc; This:C1470.project.path)
	
	// MARK:Class for build()
	This:C1470.gradlew:=cs:C1710.gradlew.new(This:C1470.project.path)
	
	// MARK:Classes for run()
	If (Is macOS:C1572 || Is Windows:C1573)
		This:C1470.emulator:=cs:C1710.androidEmulator.new()
		This:C1470.adb:=cs:C1710.adb.new()
	End if 
	
	This:C1470.init()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function init
	
	This:C1470.setJavaHome()
	This:C1470.setAndroidHome()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function setEnvVarToAll($envVar : Variant/* Object or Collection of objects */)
	This:C1470.androidprojectgenerator.setEnvironnementVariable($envVar)
	This:C1470.gradlew.setEnvironnementVariable($envVar)
	If (This:C1470.emulator#Null:C1517)
		This:C1470.emulator.setEnvironnementVariable($envVar)
	End if 
	If (This:C1470.adb#Null:C1517)
		This:C1470.adb.setEnvironnementVariable($envVar)
	End if 
	
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
	
	If (This:C1470.isOnError)
		
		return 
		
	End if 
	
	$o:=New object:C1471("success"; True:C214)
	
	// MARK:CREATE DATASET
	If (This:C1470.mustDoDataSet() && Not:C34(This:C1470.project.noData))
		
		This:C1470.postStep("dataSetGeneration")
		
		$o:=This:C1470.dataSet()
		
		If (Not:C34($o.success))
			
			$o.errors:=New collection:C1472
			$o.errors.push("Failed to dump data")
			
		End if 
	End if 
	
	If ($o.success)
		
		// Not in constructor, because we want to add $dumpedTables and $dumpedStamp that is generated after dataSet
		
		var $dumpInfoFile : 4D:C1709.File
		$dumpInfoFile:=This:C1470.project.project._folder.file("project.dataSet/android/dump_info.json")
		
		If ($dumpInfoFile.exists)
			
			var $dumpInfoObj : Object
			
			$dumpInfoObj:=JSON Parse:C1218($dumpInfoFile.getText())
			This:C1470.project.dumpedStamp:=$dumpInfoObj.dumped_stamp
			This:C1470.project.dumpedTables:=$dumpInfoObj.dumped_tables
			
		End if 
		
		This:C1470.file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+"projecteditor.json")
		This:C1470.file.setText(JSON Stringify:C1217(This:C1470.project))
		
		This:C1470.file.copyTo(This:C1470.logFolder; "lastBuild.android.4dmobile"; fk overwrite:K87:5)
		
	End if 
	
	If ($o.success)
		
		// MARK:GENERATE PROJECT FILES
		This:C1470.postStep("workspaceCreation")
		
		$o:=This:C1470.androidprojectgenerator.generate(This:C1470.file; This:C1470.project.project._folder)
		
		// Log outputs
		This:C1470.logFolder.file("lastCreate.android.out.log").setText(String:C10($o.outputStream))
		This:C1470.logFolder.file("lastCreate.android.err.log").setText(String:C10($o.errorStream))
		
		If ($o.success)
			
			// Create the app manifest
			This:C1470.project.project.organization.teamId:=""  // project is a copy of original prj so no worry
			$o.manifest:=This:C1470._createManifest(This:C1470.project.project)
			
			// MARK:GRADLEW ACCESS RIGHTS
			If (Is macOS:C1572)  // No need to change permissions on Windows
				
				$o:=This:C1470.androidprojectgenerator.chmod()
				
			End if 
			
		End if 
		
	End if 
	
	If (Feature.disabled("androidDataSet") && Not:C34(This:C1470.project.noData))
		
		If ($o.success)
			
			If (Not:C34(Bool:C1537(This:C1470.project.project.dataSource.doNotGenerateDataAtEachBuild)))
				
				// * BUILD EMBEDDED DATA LIBRARY
				This:C1470.postStep("dataSetGeneration")
				
			End if 
			
			$o:=This:C1470.androidprojectgenerator.buildEmbeddedDataLib(This:C1470.project.package)
			
		End if 
		
		If ($o.success)
			
			// * COPY EMBEDDED DATA LIBRARY
			$o:=This:C1470.androidprojectgenerator.copyEmbeddedDataLib()
			
		End if 
		
		If ($o.success)
			
			// * CREATE DATASET
			If (Not:C34(Bool:C1537(This:C1470.project.project.dataSource.doNotGenerateDataAtEachBuild)))
				
				$o:=This:C1470.dataSetLegacy()
				
				If (Not:C34($o.success))
					
					If ($o.errors=Null:C1517)
						
						$o.errors.push("Failed to dump data")
						
					End if 
				End if 
				
				If ($o.success)
					
					$o:=This:C1470.androidprojectgenerator.copyDataSet(This:C1470.project.project._folder)
					
				End if 
			End if 
		End if 
	End if 
	
	If (Not:C34(This:C1470.project.noData))
		
		If ($o.success)
			
			$o:=This:C1470.androidprojectgenerator.copyGeneratedDb(This:C1470.project.project._folder)
			
		End if 
		
		If ($o.success)
			
			$o:=This:C1470.androidprojectgenerator.copyDataSetPictures(This:C1470.project.project._folder)
			
		End if 
		
	End if 
	
	If ($o.success)
		
		// MARK:COPY RESOURCES
		This:C1470.postStep("copyingResources")
		
		$o:=This:C1470.androidprojectgenerator.copyResources(This:C1470.project.project)
		
	End if 
	
	// MARK:ACTIONS
	var $actions : Collection
	$actions:=This:C1470.project.project.actions
	
	If ($o.success)
		
		// FIXME:ACI0102883 : reformat coreDataForbiddenNames
		var $reservedName; $t : Text
		var $i : Integer
		var $action; $parameter : Object
		
		If ($actions#Null:C1517) && ($actions.length>0)
			
			//%W-533.1
			For each ($action; $actions)
				
				If ($actions[$i].parameters#Null:C1517)
					
					For each ($parameter; $actions[$i].parameters)
						
						If (Length:C16(String:C10($parameter.defaultField))>0) && ($parameter.defaultField[[Length:C16($parameter.defaultField)]]="_")
							
							$t:=Delete string:C232($parameter.defaultField; Length:C16($parameter.defaultField); 1)
							
							For each ($reservedName; SHARED.resources.coreDataForbiddenNames)
								
								If (SHARED.resources.coreDataForbiddenNames.indexOf($t)#-1)
									
									$parameter.defaultField:=$t
									
								End if 
							End for each 
						End if 
					End for each 
					
				End if 
				
				$i+=1
				
			End for each 
			//%W+533.1
			
		End if 
	End if 
	
	If ($o.success)
		
		// MARK:COPY ICONS
		$o:=This:C1470.androidprojectgenerator.copyIcons(This:C1470.project.project.dataModel; This:C1470.project.project.main.order; $actions)
		
	End if 
	
	If ($o.success)
		
		// MARK:COPY KOTLIN CUSTOM FORMATTER FILES
		$o:=This:C1470.androidprojectgenerator.copyKotlinCustomFormatterFiles(This:C1470.project.project.dataModel; This:C1470.project.package)
		
	End if 
	
	If ($o.success)
		
		If (Feature.with("inputControlWithCodeAndroid"))
			
			// MARK:COPY CUSTOM INPUT CONTROL FILES
			$o:=This:C1470.androidprojectgenerator.copyKotlinInputControlFiles(This:C1470.project.project.actions; This:C1470.project.package)
			
		End if 
		
	End if 
	
	If ($o.success)
		
		If (Feature.with("customLoginForms"))
			
			// MARK:COPY CUSTOM LOGIN FORM FILES
			If (Bool:C1537(This:C1470.project.project.server.authentication.email)=True:C214)
				
				$o:=This:C1470.androidprojectgenerator.copyCustomLoginFormFiles(This:C1470.project.project.login; This:C1470.project.package)
				
			End if 
			
		End if 
		
	End if 
	
	If ($o.success)
		
		$o:=This:C1470.androidprojectgenerator.copySdkVersion()
		
	End if 
	
	If (Not:C34($o.success))
		
		This:C1470.isOnError:=True:C214
		
		$o.errors.insert(0; Get localized string:C991("failedToCreateTheProject"))
		
		This:C1470.postErrors($o.errors)
		$result.errors.combine($o.errors)
		
	Else 
		
		$result.success:=True:C214
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function build()->$result : Object
	
	var $o : Object
	
	$result:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	If (This:C1470.isOnError)
		
		return 
		
	End if 
	
	This:C1470.gradlew.setEnvironnementVariable("currentDirectory"; This:C1470.project.path)
	
	// * BUILD PROJECT
	This:C1470.postStep("projectBuild")
	
	$o:=This:C1470.gradlew.assembleDebug()
	
	If (Feature.with("androidDeepLinking") && (Bool:C1537(This:C1470.project.project.deepLinking.enabled)))
		This:C1470.signingReport:=This:C1470.gradlew.signingReport()
		If (This:C1470.signingReport["SHA-256"]#Null:C1517)
			This:C1470.addToManifest(This:C1470.project.project; "signingReport"; New object:C1471("SHA-256"; This:C1470.signingReport["SHA-256"]))
			// This.addToManifest(This.project.project; "signingReport"; This.signingReport) // to add all if needed
		End if 
	End if 
	// Log outputs
	This:C1470.logFolder.file("lastBuild.android.out.log").setText(String:C10($o.outputStream))
	This:C1470.logFolder.file("lastBuild.android.err.log").setText(String:C10($o.errorStream))
	
	If (Feature.disabled("androidDataSet"))
		
		If ($o.success)
			
			// * CREATE EMBEDDED DATABASE
			$o:=This:C1470.gradlew.createEmbeddedDatabase()
			
		End if 
		
		If ($o.success)
			
			// * BUILD PROJECT WITH EMBEDDED DATA
			$o:=This:C1470.gradlew.assembleDebug()
			
		End if 
	End if 
	
	If ($o.success)
		
		// * CHECK APK
		$o:=This:C1470.gradlew.checkAPKExists(This:C1470.apk)
		
	End if 
	
	If (Not:C34($o.success))
		
		This:C1470.isOnError:=True:C214
		
		$o.errors.insert(0; "projectBuildFailure")
		
		This:C1470.postErrors($o.errors)
		$result.errors.combine($o.errors)
		
	Else 
		
		$result.success:=True:C214
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function run()->$result : Object
	
	var $o : Object
	
	If (This:C1470.isOnError)
		
		return 
		
	End if 
	
	var $project : Object
	$project:=This:C1470.input.project
	
	If (This:C1470.input.realDevice)
		
		// * INSTALL APP
		$result:=This:C1470.install()
		
		If ($result.success)
			
			// * LAUNCH APP
			This:C1470.postStep("launchingTheApplication")
			
			$result:=This:C1470.adb.launchApp($project.product.bundleIdentifier)
			
			This:C1470.postError(cs:C1710.str.new("theApplicationHasBeenSuccessfullyInstalled").localized(New collection:C1472($project.product.name; $project._device.name)))
			
		End if 
		
	Else 
		
		$result:=New object:C1471(\
			"success"; False:C215; \
			"errors"; New collection:C1472)
		
		// * CREATE AVD IF DOESN'T EXIST
		This:C1470.postStep("launchingTheSimulator")
		
		// * START & WAIT EMULATOR
		$o:=This:C1470.emulator.start(This:C1470.avdName)
		
		If ($o.success)
			
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
					
				End if 
			End if 
		End if 
		
		If ($o.success)
			
			$result.success:=True:C214
			
		Else 
			
			This:C1470.isOnError:=True:C214
			
			$o.errors.insert(0; "")  // Insert a blank line before non localized error descriptions
			$o.errors.insert(0; Get localized string:C991("failedToLaunchTheSimulator"))
			This:C1470.postErrors($o.errors)
			
			$result.errors.combine($o.errors)
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Installing the APK on a connected device
Function install()->$result : Object
	
	$result:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	var $device; $o : Object
	
	$device:=This:C1470.project.project._device
	
	If (This:C1470.adb.isDeviceConnected($device.udid))
		
		This:C1470.postStep("installingTheApplication")
		
		This:C1470.adb.uninstallApp(This:C1470.input.project.product.bundleIdentifier; $device.udid)
		
		$o:=This:C1470.adb.installApp(This:C1470.apk.path; $device.udid)
		$result.success:=$o.success
		
		If (Not:C34($result.success))
			
			This:C1470.postError($o.lastError)
			
		End if 
		
	Else 
		
		This:C1470.postError(Replace string:C233(Get localized string:C991("theDeviceIsNotReachable"); "{device}"; $device.name))
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function remoteUrl()->$result : Text
	
	var $host; $http; $port : Text
	var $info : Object
	
	$info:=WEB Get server info:C1531()
	$http:=Choose:C955($info.security.HTTPSEnabled; "https"; "http")
	$host:=$info.options.webIPAddressToListen[0]
	$port:=String:C10(Choose:C955($info.security.HTTPSEnabled; $info.options.webHTTPSPortID; $info.options.webPortID))
	
	$result:=$http+"://"+$host+":"+$port
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Format and check the package name
Function checkPackage()
	
/*
@ https://developer.android.com/studio/build/application-id
	
Every Android app has a unique application ID that looks like
a Java package name, such as com.example.myapp.
	
- All characters must be alphanumeric or an underscore [a-zA-Z0-9_]
(preferably in lowercase for use with adb commands)
	
- It must have at least two segments (one or more dots)
	
- Each segment must start with a letter.
	
*/
	
	var $t : Text
	$t:=Lowercase:C14(This:C1470.project.package)
	
	ARRAY LONGINT:C221($len; 0x0000)
	ARRAY LONGINT:C221($pos; 0x0000)
	
	While (Match regex:C1019("(?m-si)([^[:alnum:]\\._])"; $t; 1; $pos; $len))
		
		$t:=Replace string:C233($t; Substring:C12($t; $pos{1}; $len{1}); "_")
		
	End while 
	
	$t:=Replace string:C233($t; ".."; ".")
	This:C1470.project.package:=$t
	
	// * CHECK PACKAGE NAME CONVENTIONS
	
	This:C1470.isOnError:=True:C214
	
	Case of 
			
			//______________________________________________________
		: (Match regex:C1019("(?m-si)([^[:alnum:]\\._])"; This:C1470.project.package; 1))
			
			This:C1470.postError(Replace string:C233(Get localized string:C991("thePackageNameShouldUseOnlyLettersNumbersAndUnderscores"); "{packageName}"; This:C1470.project.package))
			
			//______________________________________________________
		: (Position:C15("."; This:C1470.project.package)=0)
			
			This:C1470.postError(Replace string:C233(Get localized string:C991("thePackageNameMustHaveAtLeast2SegmentsSeparatedByADot"); "{packageName}"; This:C1470.project.package))
			
			//______________________________________________________
		: (Match regex:C1019("^[\\._0-9]"; This:C1470.project.package; 1))
			
			This:C1470.postError(Replace string:C233(Get localized string:C991("thePackageNameMustBeginWithALetter"); "{packageName}"; This:C1470.project.package))
			
			//______________________________________________________
		: (Match regex:C1019("[\\.]$"; This:C1470.project.package; 1))
			
			This:C1470.postError(Replace string:C233(Get localized string:C991("thePackageNameMustNotEndWithADot"); "{packageName}"; This:C1470.project.package))
			
			//______________________________________________________
		Else 
			
			This:C1470.isOnError:=False:C215
			
			var $t : Text
			For each ($t; Split string:C1554(This:C1470.project.package; ".")) While (Not:C34(This:C1470.isOnError))
				
				If (Match regex:C1019("^[\\._0-9]"; $t; 1))
					
					This:C1470.isOnError:=True:C214
					This:C1470.postError(Replace string:C233(Get localized string:C991("aPackageNameSegmentMustStartWithALetter"); "{packageName}"; This:C1470.project.package))
					
				End if 
			End for each 
			
			//______________________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function _o_themeImageFile()->$file : 4D:C1709.File
	$file:=This:C1470.input.project._folder.file("android/main/ic_launcher-playstore.png")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Override: no team id for android
Function _getAppId($project : Object) : Text
	return String:C10($project.product.bundleIdentifier)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Provide os for manifest
Function _getManifestInfoTarget() : Text
	return "android"