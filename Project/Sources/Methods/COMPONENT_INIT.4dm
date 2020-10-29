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
var $initLog; $reset : Boolean
var $l : Integer
var $o; $pref : Object

var $folder : 4D:C1709.Folder
var $file : 4D:C1709.File
var $process : cs:C1710.process

var SHARED : Object  // Common values
var UI : Object  // UI constants

var FEATURE : Object  // Feature flags

var RECORD : Object  // General journal

var PROJECT : cs:C1710.project
var DATABASE : cs:C1710.database

// ----------------------------------------------------
// Initialisations
$reset:=Macintosh option down:C545

PROJECT:=cs:C1710.project.new()
DATABASE:=cs:C1710.database.new()
DATABASE.projects:=DATABASE.root.folder("Mobile Projects")
DATABASE.projects.create()  // Make sure the directory exists
DATABASE.products:=DATABASE.root.parent.folder(DATABASE.structure.name+" - Mobile")

$process:=cs:C1710.process.new()

// ----------------------------------------------------
// Disable asserts in release mode
SET ASSERT ENABLED:C1131(DATABASE.isInterpreted; *)

// Get the config file
$file:=Folder:C1567(fk user preferences folder:K87:10).file("4d.mobile")

If ($file.exists)
	
	$pref:=JSON Parse:C1218($file.getText())
	
Else 
	
	// Create the preferences
	$pref:=New object:C1471
	
End if 

// ================================================================================================================================
//                                                               LOGGER
// ================================================================================================================================


If (OB Is empty:C1297(RECORD)) | $reset
	
	Case of 
			//______________________________________________________
		: (Is macOS:C1572)
			
			RECORD:=logger("~/Library/Logs/"+Folder:C1567(fk database folder:K87:14).name+".log")
			
			//______________________________________________________
		: (Is Windows:C1573)
			
			RECORD:=logger(Folder:C1567(fk user preferences folder:K87:10).folder(Folder:C1567(fk database folder:K87:14; *).name).file(Folder:C1567(fk database folder:K87:14).name+".log"))
			
			//______________________________________________________
		Else 
			
			TRACE:C157
			
			//______________________________________________________
	End case 
	
	RECORD.verbose:=(DATABASE.isMatrix)
	$initLog:=True:C214
	
End if 

// ================================================================================================================================
//                                                            COMMON VALUES
// ================================================================================================================================
If (OB Is empty:C1297(SHARED)) | $reset
	
	SHARED:=New object:C1471
	
	SHARED.ide:=New object:C1471(\
		"version"; COMPONENT_Infos("ideVersion"); \
		"build"; Num:C11(COMPONENT_Infos("ideBuildVersion")))
	
	SHARED.component:=New object:C1471(\
		"version"; COMPONENT_Infos("componentVersion"); \
		"build"; Num:C11(COMPONENT_Infos("componentBuild")))
	
	$o:=xml_fileToObject(Get 4D folder:C485(Database folder:K5:14)+"Info.plist").value.plist.dict
	$l:=$o.key.extract("$").indexOf("CFBundleVersion")
	
	If ($l#-1)
		
		SHARED.componentBuild:=String:C10($o.string[$l].$)
		
	End if 
	
	SHARED.extension:=".4dmobileapp"
	SHARED.archiveExtension:=".zip"
	
	SHARED.theme:=New object:C1471(\
		"colorjuicer"; New object:C1471(\
		"scale"; 64))
	
	// minimum requierement
	SHARED.xCodeVersion:="12.1"
	SHARED.iosDeploymentTarget:="14.1"
	
	SHARED.useXcodeDefaultPath:=True:C214
	
	// Project config
	SHARED.swift:=New object:C1471(\
		"Version"; "5.3"; \
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
	
	// https://developer.apple.com/library/content/documentation/FileManagement/Conceptual/On_Demand_Resources_Guide/index.html#//apple_ref/doc/uid/TP40015083
	SHARED.onDemandResources:=True:C214
	
	// https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/AppThinning/AppThinning.html
	SHARED.bitcode:=True:C214
	
	// iOS simulator time out
	SHARED.simulatorTimeout:=10000
	
	// Info.plist
	SHARED.infoPlist:=New object:C1471(\
		"build"; "1.0.0"; \
		"developmentRegion"; "en"; \
		"storyboard"; New object:C1471(\
		"LaunchScreen"; "LaunchScreen"; \
		"Main"; "Main"; \
		"backgroundColor"; "white"))
	
	// Exclude some file from copy
	SHARED.template:=New object:C1471(\
		"exclude"; New collection:C1472("layoutIconx2.png"; "manifest.json"; "template.gif"; "template.svg"; \
		"relationButton.xib"; "README.md"; "Package.swift"; "Package.resolved"; "Cartfile"; "Cartfile.resolved"))
	
	// Data dump
	SHARED.data:=New object:C1471(\
		"dump"; New object:C1471(\
		"limit"; 1000000; \
		"page"; 1))
	
	If (SHARED.component.build#Num:C11($pref.lastBuild)) | $reset
		
		If (Is macOS:C1572)
			
			// Invalid the cache
			$folder:=sdk(New object:C1471("action"; "cacheFolder"))
			
			If ($folder.exists)
				
				$folder.delete(Delete with contents:K24:24)
				
			End if 
		End if 
		
		// Save the preferences
		$pref.lastBuild:=SHARED.component.build
		Folder:C1567(fk user preferences folder:K87:10).file("4d.mobile").setText(JSON Stringify:C1217($pref; *))
		
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
	SHARED.defaultFieldBindingTypes[8858]:="relation"
	SHARED.defaultFieldBindingTypes[8859]:="relation"
	
	// XXX check table & filed names in https://project.4d.com/issues/90770
	SHARED.deletedRecordsTable:=New object:C1471(\
		"name"; "__DeletedRecords"; \
		"fields"; New collection:C1472)
	
	SHARED.deletedRecordsTable.fields.push(New object:C1471(\
		"name"; "ID"; \
		"type"; "INT64"; \
		"indexed"; True:C214; \
		"primaryKey"; True:C214; \
		"autoincrement"; True:C214))
	
	SHARED.deletedRecordsTable.fields.push(New object:C1471(\
		"name"; "__Stamp"; \
		"type"; "INT64"; \
		"indexed"; True:C214))
	
	SHARED.deletedRecordsTable.fields.push(New object:C1471(\
		"name"; "__TableNumber"; \
		"type"; "INT32"))
	
	SHARED.deletedRecordsTable.fields.push(New object:C1471(\
		"name"; "__TableName"; \
		"type"; "VARCHAR(255)"))
	
	SHARED.deletedRecordsTable.fields.push(New object:C1471(\
		"name"; "__PrimaryKey"; \
		"type"; "VARCHAR(255)"))
	
	SHARED.stampField:=New object:C1471(\
		"name"; "__GlobalStamp"; \
		"type"; "INT64"; \
		"indexed"; True:C214)
	
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
		
		$file:=JSON Resolve pointers:C1478(JSON Parse:C1218(File:C1566("/RESOURCES/Resources.json").getText()))
		
		If ($file.success)
			
			SHARED.resources:=$file.value
			
		Else 
			
			RECORD.error("Failed to parse "+File:C1566("/RESOURCES/Resources.json").path)
			
		End if 
		
	Else 
		
		RECORD.error("Missing file "+$file.path)
		
	End if 
	
	// ================================================================================================================================
	//                                                           ONLY UI PROCESS
	// ================================================================================================================================
	If ($process.cooperative)  // Not preemptive mode (always false in dev mode!)
		
		If (Not:C34($process.worker))
			
			RECORD.reset()
			
		End if 
		
		UI:=New object:C1471
		
		// PRELOAD ICONS FOR FIELD TYPES
		UI.fieldIcons:=New collection:C1472
		
		For each ($file; Folder:C1567("/RESOURCES/images/fieldsIcons").files(Ignore invisible:K24:16))
			
			READ PICTURE FILE:C678($file.platformPath; $icon)
			UI.fieldIcons[Num:C11(Replace string:C233($file.name; "field_"; ""))]:=$icon
			
		End for each 
		
		// FIELD TYPE NAMES
		UI.typeNames:=New collection:C1472
		UI.typeNames[Is alpha field:K8:1]:=Get localized string:C991("alpha")
		UI.typeNames[Is integer:K8:5]:=Get localized string:C991("integer")
		UI.typeNames[Is longint:K8:6]:=Get localized string:C991("longInteger")
		UI.typeNames[Is integer 64 bits:K8:25]:=Get localized string:C991("integer64Bits")
		UI.typeNames[Is real:K8:4]:=Get localized string:C991("real")
		UI.typeNames[_o_Is float:K8:26]:=Get localized string:C991("float")
		UI.typeNames[Is boolean:K8:9]:=Get localized string:C991("boolean")
		UI.typeNames[Is time:K8:8]:=Get localized string:C991("time")
		UI.typeNames[Is date:K8:7]:=Get localized string:C991("date")
		UI.typeNames[Is text:K8:3]:=Get localized string:C991("text")
		UI.typeNames[Is picture:K8:10]:=Get localized string:C991("picture")
		
		// COLORS
		UI.colorScheme:=ui_colorScheme
		
		If (UI.colorScheme.isDarkStyle)
			
			UI.strokeColor:=0x00083C56
			UI.highlightColor:=Background color:K23:2  // 0x00111111  // 0x00E6F8FF
			UI.highlightColorNoFocus:=Background color:K23:2  // 0x00111111
			
			UI.selectedColor:=0x00034B6D
			UI.alternateSelectedColor:=0x00C1C1FF  // 0x00E7F8FF
			UI.backgroundSelectedColor:=Highlight text background color:K23:5  // 0x004BA6F8
			UI.backgroundUnselectedColor:=Highlight text background color:K23:5  // 0x005A5A5A
			
			UI.selectedFillColor:="darkgray"
			UI.unselectedFillColor:="black"
			
			UI.errorColor:=0x00F28585
			UI.warningColor:=0x00F2B174
			
			UI.errorRGB:="red"
			UI.warningRGB:="orange"
			
		Else 
			
			UI.strokeColor:=0x001AA1E5
			UI.highlightColor:=0x00FFFFFF  // 0x00E6F8FF
			UI.highlightColorNoFocus:=0x00FFFFFF  // XXXX change name
			
			UI.selectedColor:=0x0003A9F4
			UI.alternateSelectedColor:=0x00F4F4F6  // 0x00E7F8FF
			UI.backgroundSelectedColor:=0x00E7F8FF
			UI.backgroundUnselectedColor:=0x00C9C9C9
			
			UI.selectedFillColor:="gray"  // "dodgerblue"
			UI.unselectedFillColor:="white"
			
			UI.errorColor:=0x00FF0000
			UI.warningColor:=0x00F19135
			
			UI.errorRGB:="red"
			UI.warningRGB:="darkorange"
			
		End if 
		
		UI.colors:=New object:C1471
		UI.colors.strokeColor:=color("4dColor"; New object:C1471("value"; UI.strokeColor))
		UI.colors.highlightColor:=color("4dColor"; New object:C1471("value"; UI.highlightColor))
		UI.colors.highlightColorNoFocus:=color("4dColor"; New object:C1471("value"; UI.highlightColorNoFocus))
		UI.colors.selectedColor:=color("4dColor"; New object:C1471("value"; UI.selectedColor))
		UI.colors.alternateSelectedColor:=color("4dColor"; New object:C1471("value"; UI.alternateSelectedColor))
		UI.colors.backgroundSelectedColor:=color("4dColor"; New object:C1471("value"; UI.backgroundSelectedColor))
		UI.colors.backgroundUnselectedColor:=color("4dColor"; New object:C1471("value"; UI.backgroundUnselectedColor))
		UI.colors.errorColor:=color("4dColor"; New object:C1471("value"; UI.errorColor))
		UI.colors.warningColor:=color("4dColor"; New object:C1471("value"; UI.warningColor))
		
		UI.noIcon:=File:C1566("/RESOURCES/images/noIcon.svg").platformPath
		UI.errorIcon:=File:C1566("/RESOURCES/images/errorIcon.svg").platformPath
		
		UI.alert:="🚫"
		UI.warning:="❗"
		
		UI.toOne:="⑴"
		UI.toMany:="⒩"
		
		READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/user.png").platformPath; $icon)
		UI.user:=$icon
		
		READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/filter.png").platformPath; $icon)
		UI.filter:=$icon
		
	End if 
	
	If (DATABASE.isMatrix)
		
		Folder:C1567(fk desktop folder:K87:19).folder("DEV").create()
		
	End if 
	
	// Define classes & methods
	EXECUTE METHOD:C1007("ui_CLASSES")
	
End if 

/*================================================================================================================================
FEATURES FLAGS
================================================================================================================================*/
If (OB Is empty:C1297(FEATURE)) | $reset
	
	FEATURE_FLAGS(1860; $pref)
	
End if 

If ($process.cooperative)\
 & (Not:C34($process.worker))\
 & ($initLog)
	
	$t:=SHARED.ide.version
	RECORD.log("4D "+$t[[1]]+$t[[2]]+Choose:C955($t[[3]]="0"; "."+$t[[4]]; "R"+$t[[3]])+" ("+String:C10(SHARED.ide.build)+")")
	RECORD.log("Component "+SHARED.component.version)
	RECORD.line()
	
	For each ($t; FEATURE)
		
		If (Value type:C1509(FEATURE[$t])=Is boolean:K8:9)
			
			RECORD.log("feature "+Replace string:C233($t; "_"; "")+": "+Choose:C955(FEATURE[$t]; "Enabled"; "Disabled"))
			
		End if 
	End for each 
	
	RECORD.line()
	
End if 

/*================================================================================================================================
AFTER FLAGS
================================================================================================================================*/
If (FEATURE.with("accentColors"))
	
	// ui.selectedColor:=Highlight menu background color
	// ui.highlightColor:=Highlight menu background color
	
	// ui.backgroundSelectedColor:=Highlight menu background color // 0x004BA6F8
	// ui.backgroundUnselectedColor:=Background color none // 0x005A5A5A
	
End if 

SET ASSERT ENABLED:C1131(FEATURE.with("debug"); *)

RECORD.info("Assert "+Choose:C955(Get assert enabled:C1130; "Enabled"; "Disabled"))

// ----------------------------------------------------
// End