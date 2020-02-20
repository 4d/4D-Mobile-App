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
C_BOOLEAN:C305($bReset)
C_LONGINT:C283($l;$lMode)
C_PICTURE:C286($p)
C_TEXT:C284($t;$tProcess)
C_OBJECT:C1216($o;$oPreferences;$signal)

C_OBJECT:C1216(feature)
C_OBJECT:C1216(SHARED)
C_OBJECT:C1216(ui)
C_OBJECT:C1216(RECORD)

  // ----------------------------------------------------
  // Initialisations
$bReset:=Macintosh option down:C545

  // ----------------------------------------------------
  // Disable asserts in release mode
SET ASSERT ENABLED:C1131(Not:C34(Is compiled mode:C492);*)

  // Get the config file
$o:=Folder:C1567(fk user preferences folder:K87:10).file("4d.mobile")

If ($o.exists)
	
	$oPreferences:=JSON Parse:C1218($o.getText())
	
Else 
	
	  // Create the preferences
	$oPreferences:=New object:C1471
	
End if 

If (Storage:C1525.database=Null:C1517)
	
/* #ACI0099986
$o:=New signal
CALL WORKER(1;"INIT";$o)
$o.wait()
*/
	
	$signal:=New signal:C1641
	CALL WORKER:C1389("$";"INIT";$signal)
	$signal.wait()
	KILL WORKER:C1390("$")
	
End if 

  // ================================================================================================================================
  //                                                               LOGGER
  // ================================================================================================================================

If (OB Is empty:C1297(RECORD)) | $bReset
	
	RECORD:=logger ("~/Library/Logs/"+Folder:C1567(fk database folder:K87:14).name+".log")
	RECORD.verbose:=(Structure file:C489=Structure file:C489(*))
	
End if 

  // ================================================================================================================================
  //                                                            COMMON VALUES
  // ================================================================================================================================
If (OB Is empty:C1297(SHARED)) | $bReset
	
	SHARED:=New object:C1471
	
	SHARED.ide:=New object:C1471(\
		"version";COMPONENT_Infos ("ideVersion");\
		"build";Num:C11(COMPONENT_Infos ("ideBuildVersion")))
	
	SHARED.component:=New object:C1471(\
		"version";COMPONENT_Infos ("componentVersion");\
		"build";Num:C11(COMPONENT_Infos ("componentBuild")))
	
	$o:=xml_fileToObject (Get 4D folder:C485(Database folder:K5:14)+"Info.plist").value.plist.dict
	$l:=$o.key.extract("$").indexOf("CFBundleVersion")
	
	If ($l#-1)
		
		SHARED.componentBuild:=String:C10($o.string[$l].$)
		
	End if 
	
	SHARED.extension:=".4dmobileapp"
	SHARED.archiveExtension:=".zip"
	
	SHARED.theme:=New object:C1471(\
		"colorjuicer";New object:C1471(\
		"scale";64))
	
	  // minimum requierement
	SHARED.xCodeVersion:="11.2"
	SHARED.iosDeploymentTarget:="13.2"
	
	SHARED.useXcodeDefaultPath:=True:C214
	
	  // Project config
	SHARED.swift:=New object:C1471(\
		"Version";"5.1";\
		"Flags";New object:C1471("Debug";"";"Release";"");\
		"OptimizationLevel";New object:C1471(\
		"Debug";"-Onone";\
		"Release";"-O");\
		"CompilationMode";New object:C1471(\
		"Debug";"singlefile";\
		"Release";"wholemodule"))
	
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
		"build";"1.0.0";\
		"developmentRegion";"en";\
		"storyboard";New object:C1471(\
		"LaunchScreen";"LaunchScreen";\
		"Main";"Main";\
		"backgroundColor";"white"))
	
	SHARED.urlScheme:=""
	
	  // Exclude some file from copy
	SHARED.template:=New object:C1471(\
		"exclude";New collection:C1472("layoutIconx2.png";"manifest.json";"template.gif";"template.svg";\
		"relationButton.xib";"README.md";"Package.swift";"Package.resolved";"Cartfile";"Cartfile.resolved"))
	
	  // Data dump
	SHARED.data:=New object:C1471(\
		"dump";New object:C1471(\
		"limit";1000000;\
		"page";1))
	
	If (SHARED.component.build#Num:C11($oPreferences.lastBuild)) | $bReset
		
		  // Invalid the cache
		$o:=Folder:C1567("/Library/Caches/com.4d.mobile/sdk")
		
		If ($o.exists)
			
			$o.delete(Delete with contents:K24:24)
			
		End if 
		
		  // Save the preferences
		$oPreferences.lastBuild:=SHARED.component.build
		Folder:C1567(fk user preferences folder:K87:10).file("4d.mobile").setText(JSON Stringify:C1217($oPreferences;*))
		
	End if 
	
	SHARED.keyExtension:="mobileapp"
	
	  // Override common conf by file settings [
	If ($oPreferences.common#Null:C1517)
		
		ob_deepMerge (SHARED;$oPreferences.common)
		
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
	
	  // XXX check table & filed names in https://project.4d.com/issues/90770
	SHARED.deletedRecordsTable:=New object:C1471(\
		"name";"__DeletedRecords";\
		"fields";New collection:C1472)
	
	SHARED.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"ID";\
		"type";"INT64";\
		"indexed";True:C214;\
		"primaryKey";True:C214;\
		"autoincrement";True:C214))
	
	SHARED.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"__Stamp";\
		"type";"INT64";\
		"indexed";True:C214))
	
	SHARED.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"__TableNumber";\
		"type";"INT32"))
	
	SHARED.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"__TableName";\
		"type";"VARCHAR(255)"))
	
	SHARED.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"__PrimaryKey";\
		"type";"VARCHAR(255)"))
	
	SHARED.stampField:=New object:C1471(\
		"name";"__GlobalStamp";\
		"type";"INT64";\
		"indexed";True:C214)
	
	  // Common project tags
	SHARED.tags:=New object:C1471(\
		"componentBuild";String:C10(SHARED.component.build);\
		"ideVersion";SHARED.ide.version;\
		"ideBuildVersion";SHARED.ide.build;\
		"iosDeploymentTarget";SHARED.iosDeploymentTarget;\
		"swiftVersion";SHARED.swift.Version;\
		"swiftFlagsDebug";SHARED.swift.Flags.Debug;\
		"swiftFlagsRelease";SHARED.swift.Flags.Release;\
		"swiftOptimizationLevelDebug";SHARED.swift.OptimizationLevel.Debug;\
		"swiftOptimizationLevelRelease";SHARED.swift.OptimizationLevel.Release;\
		"swiftCompilationModeDebug";SHARED.swift.CompilationMode.Debug;\
		"swiftCompilationModeRelease";SHARED.swift.CompilationMode.Release;\
		"onDemandResources";Choose:C955(SHARED.onDemandResources;"YES";"NO");\
		"bitcode";Choose:C955(SHARED.bitcode;"YES";"NO");\
		"targetedDeviceFamily";SHARED.targetedDeviceFamily;\
		"build";SHARED.infoPlist.build;\
		"developmentRegion";SHARED.infoPlist.developmentRegion;\
		"storyboardLaunchScreen";SHARED.infoPlist.storyboard.LaunchScreen;\
		"storyboardMain";SHARED.infoPlist.storyboard.Main;\
		"urlScheme";SHARED.urlScheme)
	
	SHARED.thirdParty:="Carthage"
	SHARED.thirdPartySources:=SHARED.thirdParty+"/Checkouts"
	
	$o:=File:C1566("/RESOURCES/Resources.json")
	
	If ($o.exists)
		
		$o:=JSON Resolve pointers:C1478(JSON Parse:C1218(File:C1566("/RESOURCES/Resources.json").getText()))
		
		If ($o.success)
			
			SHARED.resources:=$o.value
			
		Else 
			
			RECORD.error("Failed to parse "+File:C1566("/RESOURCES/Resources.json").path)
			
		End if 
		
	Else 
		
		RECORD.error("Missing file "+$o.path)
		
	End if 
	
	  // ================================================================================================================================
	  //                                                           ONLY UI PROCESS
	  // ================================================================================================================================
	PROCESS PROPERTIES:C336(Current process:C322;$tProcess;$l;$l;$lMode)
	
	If (Not:C34($lMode ?? 1))  // Not preemptive mode (always false in dev mode!)
		
		If ($tProcess#"4D Mobile (@")
			
			RECORD.reset()
			
		End if 
		
		ui:=New object:C1471
		
		ui.debugMode:=(Structure file:C489=Structure file:C489(*))  // True in matrix database
		
		  // Preload icons for field types [
		ui.fieldIcons:=New collection:C1472
		
		For each ($o;Folder:C1567("/RESOURCES/images/fieldsIcons").files(Ignore invisible:K24:16))
			
			READ PICTURE FILE:C678($o.platformPath;$p)
			ui.fieldIcons[Num:C11(Replace string:C233($o.name;"field_";""))]:=$p
			
		End for each 
		
		  // Field type names [
		ui.typeNames:=New collection:C1472
		ui.typeNames[Is alpha field:K8:1]:=Get localized string:C991("alpha")
		ui.typeNames[Is integer:K8:5]:=Get localized string:C991("integer")
		ui.typeNames[Is longint:K8:6]:=Get localized string:C991("longInteger")
		ui.typeNames[Is integer 64 bits:K8:25]:=Get localized string:C991("integer64Bits")
		ui.typeNames[Is real:K8:4]:=Get localized string:C991("real")
		ui.typeNames[_o_Is float:K8:26]:=Get localized string:C991("float")
		ui.typeNames[Is boolean:K8:9]:=Get localized string:C991("boolean")
		ui.typeNames[Is time:K8:8]:=Get localized string:C991("time")
		ui.typeNames[Is date:K8:7]:=Get localized string:C991("date")
		ui.typeNames[Is text:K8:3]:=Get localized string:C991("text")
		ui.typeNames[Is picture:K8:10]:=Get localized string:C991("picture")
		  //]
		
		  // Colors [
		ui.colorScheme:=ui_colorScheme 
		
		If (ui.colorScheme.isDarkStyle)
			
			ui.strokeColor:=0x00083C56
			ui.highlightColor:=Background color:K23:2  // 0x00111111  // 0x00E6F8FF
			ui.highlightColorNoFocus:=Background color:K23:2  // 0x00111111
			
			ui.selectedColor:=0x00034B6D
			ui.alternateSelectedColor:=0x00C1C1FF  // 0x00E7F8FF
			ui.backgroundSelectedColor:=Highlight text background color:K23:5  // 0x004BA6F8
			ui.backgroundUnselectedColor:=Highlight text background color:K23:5  // 0x005A5A5A
			
			ui.selectedFillColor:="darkgray"
			ui.unselectedFillColor:="black"
			
			ui.errorColor:=0x00F28585
			ui.warningColor:=0x00F2B174
			
			ui.errorRGB:="red"
			ui.warningRGB:="orange"
			
		Else 
			
			ui.strokeColor:=0x001AA1E5
			ui.highlightColor:=0x00FFFFFF  // 0x00E6F8FF
			ui.highlightColorNoFocus:=0x00FFFFFF  // XXXX change name
			
			ui.selectedColor:=0x0003A9F4
			ui.alternateSelectedColor:=0x00F4F4F6  // 0x00E7F8FF
			ui.backgroundSelectedColor:=0x00E7F8FF
			ui.backgroundUnselectedColor:=0x00C9C9C9
			
			ui.selectedFillColor:="gray"  // "dodgerblue"
			ui.unselectedFillColor:="white"
			
			ui.errorColor:=0x00FF0000
			ui.warningColor:=0x00F19135
			
			ui.errorRGB:="red"
			ui.warningRGB:="darkorange"
			
		End if 
		  //]
		
		ui.colors:=New object:C1471
		ui.colors.strokeColor:=color ("4dColor";New object:C1471("value";ui.strokeColor))
		ui.colors.highlightColor:=color ("4dColor";New object:C1471("value";ui.highlightColor))
		ui.colors.highlightColorNoFocus:=color ("4dColor";New object:C1471("value";ui.highlightColorNoFocus))
		ui.colors.selectedColor:=color ("4dColor";New object:C1471("value";ui.selectedColor))
		ui.colors.alternateSelectedColor:=color ("4dColor";New object:C1471("value";ui.alternateSelectedColor))
		ui.colors.backgroundSelectedColor:=color ("4dColor";New object:C1471("value";ui.backgroundSelectedColor))
		ui.colors.backgroundUnselectedColor:=color ("4dColor";New object:C1471("value";ui.backgroundUnselectedColor))
		ui.colors.errorColor:=color ("4dColor";New object:C1471("value";ui.errorColor))
		ui.colors.warningColor:=color ("4dColor";New object:C1471("value";ui.warningColor))
		
		ui.noIcon:=File:C1566("/RESOURCES/images/noIcon.svg").platformPath
		ui.errorIcon:=File:C1566("/RESOURCES/images/errorIcon.svg").platformPath
		
		ui.alert:="🚫"
		ui.warning:="❗"
		
		  // Only for data pannel [
		READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/user.png").platformPath;$p)
		ui.user:=$p
		
		READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/filter.png").platformPath;$p)
		ui.filter:=$p
		  //]
		
		ui.checkMark:=Char:C90(19)
		
	End if 
	
	If (Bool:C1537(ui.debugMode))
		
		Folder:C1567(fk desktop folder:K87:19).folder("DEV").create()
		
	End if 
	
	  // Define classes & methods
	EXECUTE METHOD:C1007("ui_CLASSES")
	EXECUTE METHOD:C1007("project_CLASSES")
	
End if 

  // ================================================================================================================================
  //                                                          FEATURES FLAGS
  // ================================================================================================================================
If (OB Is empty:C1297(feature)) | $bReset
	
	FEATURE_FLAGS (1830;$oPreferences.feature)
	
End if 

If (Not:C34($lMode ?? 1))\
 & ($tProcess#"4D Mobile (@")
	
	$t:=SHARED.ide.version
	RECORD.log("4D "+$t[[1]]+$t[[2]]+Choose:C955($t[[3]]="0";"."+$t[[4]];"R"+$t[[3]])+" ("+String:C10(SHARED.ide.build)+")")
	RECORD.log("Component "+SHARED.component.version)
	RECORD.line()
	
	For each ($t;feature)
		
		If (Value type:C1509(feature[$t])=Is boolean:K8:9)
			
			RECORD.log("feature "+Replace string:C233($t;"_";"")+": "+Choose:C955(feature[$t];"Enabled";"Disabled"))
			
		End if 
	End for each 
	
	RECORD.line()
	
End if 

  // ________________________________________________________________________________________________________________________________
  //                                                         | AFTER FLAGS |
  // ________________________________________________________________________________________________________________________________

COMPONENT_DEFINE_TOOLS 

If (feature.with("accentColors"))
	
	  // Ui.selectedColor:=Highlight menu background color
	  // Ui.highlightColor:=Highlight menu background color
	
	  //ui.backgroundSelectedColor:=Highlight menu background color // 0x004BA6F8
	  //ui.backgroundUnselectedColor:=Background color none // 0x005A5A5A
	
End if 

If (feature.with("debug"))
	
	SET ASSERT ENABLED:C1131(True:C214;*)
	
End if 

RECORD.info("Assert "+Choose:C955(Get assert enabled:C1130;"Enabled";"Disabled"))

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End