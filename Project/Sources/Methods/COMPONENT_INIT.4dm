//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : COMPONENT_INIT
// ID[F84912DC921C45C49366AD32CAA443C7]
// Created 15-9-2017 by Vincent de Lachaux
// ----------------------------------------------------
// #THREAD-SAFE
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $t : Text
var $icon : Picture
var $reset : Boolean
var $l : Integer
var $o; $pref : Object

var $folder : 4D:C1709.Folder
var $file : 4D:C1709.File
var $process : cs:C1710.process

var _o_UI : Object  // UI constants

$reset:=Macintosh option down:C545
$process:=cs:C1710.process.new()

// MARK:-COMPONENT
var Component : cs:C1710.component
Component:=Component || cs:C1710.component.new()

// Disable asserts in release mode
SET ASSERT ENABLED:C1131(Component.isInterpreted; *)

// MARK:-DATABASE
var Database : cs:C1710.database
Database:=Database || cs:C1710.database.new()
Database.projects:=Database.databaseFolder.folder("Mobile Projects")
Database.projects.create()  // Make sure the directory exists
Database.products:=Database.databaseFolder.parent.folder(Database.structureFile.name+" - Mobile")

// MARK:-LOGGER
var Logger : cs:C1710.logger  // General journal
Logger:=$reset ? Null:C1517 : Logger
Logger:=Logger || cs:C1710.logger.new()

If (Not:C34($process.worker))
	
	Logger.clear()
	
End if 

Logger.verbose:=(Component.isMatrix)

var Motor : cs:C1710.motor
Motor:=Motor || cs:C1710.motor.new()

var PROJECT : cs:C1710.project
PROJECT:=PROJECT || cs:C1710.project.new()

// MARK:-COMMON VALUES
var SHARED : Object  // Common values
If (OB Is empty:C1297(SHARED)) | $reset
	
	//Formula($process.worker ? BEEP : IDLE).call()
	
	SHARED:=New object:C1471
	
	SHARED.ide:=New object:C1471(\
		"version"; motor._version; \
		"build"; motor.buildNumber)
	
	SHARED.component:=New object:C1471(\
		"version"; Component.version; \
		"build"; Component.buildNumber)
	
	SHARED.componentBuild:=SHARED.component.build
	
	SHARED.extension:=".4dmobileapp"
	SHARED.archiveExtension:=".zip"
	
	SHARED.theme:=New object:C1471(\
		"colorjuicer"; New object:C1471(\
		"scale"; 64))
	
	//***********************
	// REQUIREMENTS
	//***********************
	
	// 1] iOS
	SHARED.xCodeMinVersion:="13.4"
	SHARED.iosDeploymentTarget:="15.5"
	SHARED.useXcodeDefaultPath:=True:C214
	
	// 1] Android
	SHARED.studioMinVersion:="4.1"
	
	// Project config
	SHARED.swift:=New object:C1471(\
		"Version"; "5.6"; \
		"Export"; New object:C1471("stripSwiftSymbols"; False:C215; "method"; "development"); \
		"Flags"; New object:C1471("Debug"; ""; "Release"; ""); \
		"OptimizationLevel"; New object:C1471(\
		"Debug"; "-Onone"; \
		"Release"; "-O"); \
		"CompilationMode"; New object:C1471(\
		"Debug"; "singlefile"; \
		"Release"; "wholemodule"))
	
	// OptimizationLevel: -O (speed) -Osize (size) -Onone (nothing, better to debug)
	
	// 1:iphone / 2:ipad / 1,2:universal
	SHARED.targetedDeviceFamily:="1,2"
	
	// https://developer.apple.com/library/content/documentation/FileManagement/Conceptual/On_Demand_Resources_Guide/index.html#//Apple_ref/doc/uid/TP40015083
	SHARED.onDemandResources:=True:C214
	
	// https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/AppThinning/AppThinning.html
	SHARED.bitcode:=True:C214
	
	// IOS simulator time out
	SHARED.simulatorTimeout:=10000
	
	// Info.plist
	SHARED.infoPlist:=New object:C1471(\
		"developmentRegion"; "en"; \
		"storyboard"; New object:C1471(\
		"LaunchScreen"; "LaunchScreen"; \
		"Main"; "Main"; \
		"backgroundColor"; "white"))  // TODO check backgroundColor used?
	
	// Exclude some file from copy
	SHARED.template:=New object:C1471(\
		"exclude"; New collection:C1472("layoutIconx2.png"; "manifest.json"; "template.gif"; "template.svg"; \
		"relationButton.xib"; "README.md"; "LICENSE.md"; "LICENSE"; "LICENSES.md"; "Package.swift"; "Package.resolved"; "Cartfile"; "Cartfile.resolved"))
	
	// Data dump
	If (Structure file:C489=Structure file:C489(*))  // TO test UI with less than 10000 records
		
		SHARED.data:=New object:C1471(\
			"dump"; New object:C1471(\
			"timeout"; 1000; \
			"limit"; 100; \
			"page"; 100))
		
	Else 
		
		SHARED.data:=New object:C1471(\
			"dump"; New object:C1471(\
			"timeout"; 20000; \
			"limit"; 10000; \
			"page"; 10000))
		
	End if 
	
	// Get the config file
	$file:=Folder:C1567(fk user preferences folder:K87:10).file("4d.mobile")
	$pref:=$file.exists ? JSON Parse:C1218($file.getText()) : New object:C1471
	
	If (SHARED.component.build#Num:C11($pref.lastBuild)) | $reset
		
		If (Is macOS:C1572)
			
			// Invalid the cache
			$folder:=cs:C1710.path.new().cacheSdkAppleUnzipped()
			
			If ($folder.exists)
				
				$folder.delete(Delete with contents:K24:24)
				
			End if 
		End if 
		
		// Save the preferences
		$pref.lastBuild:=SHARED.component.build
		$file.setText(JSON Stringify:C1217($pref; *))
		
	End if 
	
	SHARED.keyExtension:="mobileapp"
	
	// Override common conf by file settings [
	If ($pref.common#Null:C1517)
		
		ob_deepMerge(SHARED; $pref.common)
		
	End if 
	//]
	
	SHARED.defaultFieldBindingTypes:=New collection:C1472
	SHARED.defaultFieldBindingTypes[Is alpha field:K8:1]:="text"
	SHARED.defaultFieldBindingTypes[Is boolean:K8:9]:="falseOrTrue"
	SHARED.defaultFieldBindingTypes[Is integer:K8:5]:="integer"
	SHARED.defaultFieldBindingTypes[Is longint:K8:6]:="integer"
	SHARED.defaultFieldBindingTypes[Is integer 64 bits:K8:25]:="integer"
	SHARED.defaultFieldBindingTypes[Is real:K8:4]:="real"
	SHARED.defaultFieldBindingTypes[_o_Is float:K8:26]:="real"
	SHARED.defaultFieldBindingTypes[Is date:K8:7]:="mediumDate"
	SHARED.defaultFieldBindingTypes[Is time:K8:8]:="mediumTime"
	SHARED.defaultFieldBindingTypes[Is text:K8:3]:="text"
	SHARED.defaultFieldBindingTypes[Is picture:K8:10]:="restImage"
	SHARED.defaultFieldBindingTypes[Is object:K8:27]:="yaml"
	SHARED.defaultFieldBindingTypes[8858]:="relation"
	SHARED.defaultFieldBindingTypes[8859]:="relation"
	
	// XXX check table & field names in https:// Project.4d.com/issues/90770
	SHARED.deletedRecordsTable:=New object:C1471(\
		"name"; "__DeletedRecords"; \
		"fields"; New collection:C1472)
	
	SHARED.deletedRecordsTable.fields.push(New object:C1471(\
		"name"; "ID"; \
		"type"; "INT64"; \
		"indexed"; True:C214; \
		"primaryKey"; True:C214; \
		"autoincrement"; True:C214; \
		"_type"; "number"))
	
	SHARED.deletedRecordsTable.fields.push(New object:C1471(\
		"name"; "__Stamp"; \
		"type"; "INT64"; \
		"indexed"; True:C214; \
		"_type"; "number"))
	
	SHARED.deletedRecordsTable.fields.push(New object:C1471(\
		"name"; "__TableNumber"; \
		"type"; "INT32"; \
		"_type"; "number"))
	
	SHARED.deletedRecordsTable.fields.push(New object:C1471(\
		"name"; "__TableName"; \
		"type"; "VARCHAR(255)"; \
		"_type"; "string"))
	
	SHARED.deletedRecordsTable.fields.push(New object:C1471(\
		"name"; "__PrimaryKey"; \
		"type"; "VARCHAR(255)"; \
		"_type"; "string"))
	
	SHARED.stampField:=New object:C1471(\
		"name"; "__GlobalStamp"; \
		"type"; "INT64"; \
		"indexed"; True:C214; \
		"_type"; "number")
	
	// Common project tags
	SHARED.tags:=New object:C1471(\
		"componentBuild"; String:C10(SHARED.component.build); \
		"ideVersion"; SHARED.ide.version; \
		"ideBuildVersion"; SHARED.ide.build; \
		"iosDeploymentTarget"; SHARED.iosDeploymentTarget; \
		"swiftVersion"; SHARED.swift.Version; \
		"swiftFlagsDebug"; SHARED.swift.Flags.Debug; \
		"swiftFlagsRelease"; SHARED.swift.Flags.Release; \
		"swiftOptimizationLevelDebug"; SHARED.swift.OptimizationLevel.Debug; \
		"swiftOptimizationLevelRelease"; SHARED.swift.OptimizationLevel.Release; \
		"swiftCompilationModeDebug"; SHARED.swift.CompilationMode.Debug; \
		"swiftCompilationModeRelease"; SHARED.swift.CompilationMode.Release; \
		"onDemandResources"; Choose:C955(SHARED.onDemandResources; "YES"; "NO"); \
		"bitcode"; Choose:C955(SHARED.bitcode; "YES"; "NO"); \
		"targetedDeviceFamily"; SHARED.targetedDeviceFamily; \
		"build"; SHARED.infoPlist.build; \
		"developmentRegion"; SHARED.infoPlist.developmentRegion; \
		"storyboardLaunchScreen"; SHARED.infoPlist.storyboard.LaunchScreen; \
		"storyboardMain"; SHARED.infoPlist.storyboard.Main)
	
	SHARED.thirdParty:="Carthage"
	SHARED.thirdPartySources:=SHARED.thirdParty+"/Checkouts"
	
	$file:=File:C1566("/RESOURCES/Resources.json")
	
	If ($file.exists)
		
		var $result : Object
		$result:=JSON Resolve pointers:C1478(JSON Parse:C1218($file.getText()))
		
		If ($result.success)
			
			SHARED.resources:=$result.value
			
		Else 
			
			Logger.error("Failed to parse "+File:C1566("/RESOURCES/Resources.json").path)
			
		End if 
		
	Else 
		
		Logger.error("Missing file "+$file.path)
		
	End if 
End if 

// MARK:-FEATURES FLAGS
var Feature : cs:C1710.feature
If (OB Is empty:C1297(Feature)) | $reset
	
	var $version : Integer
	
	$version:=1960  // Current branch version number
	
	If (Structure file:C489=Structure file:C489(*))\
		 && (Num:C11(SHARED.ide.version)#$version)
		
		ALERT:C41("You need to update the last delivered version number in COMPONENT_INIT")
		
		//%T-
		METHOD OPEN PATH:C1213(Current method name:C684; 222)
		//%T+
		
		ABORT:C156
		
	End if 
	
	FEATURE_FLAGS($version; Folder:C1567(fk user preferences folder:K87:10).file("4d.mobile"))
	
	If (Feature.with("vdl"))
		
		Folder:C1567(fk desktop folder:K87:19).folder("DEV").create()
		
	End if 
End if 

If ($process.cooperative)\
 && (Not:C34($process.worker))
	
	$t:=SHARED.ide.version
	
	Logger.log("4D "+$t[[1]]+$t[[2]]+($t[[3]]="0" ? "."+$t[[4]] : "R"+$t[[3]])+" ("+String:C10(SHARED.ide.build)+")")
	Logger.log("Component "+String:C10(SHARED.component.version))
	
	Logger.line()
	
	Feature.log(Formula:C1597(Logger.log($1)))
	
	Logger.line()
	
End if 

Logger.info(Is compiled mode:C492 ? "COMPILED MODE" : "INTERPRETED MODE")

// MARK:-AFTER FLAGS
SET ASSERT ENABLED:C1131(Component.isInterpreted | Feature.with("debug"); *)
Logger.info("Assert "+Choose:C955(Get assert enabled:C1130; "Enabled"; "Disabled"))