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
C_BOOLEAN:C305($bEnabled;$bReset)
C_LONGINT:C283($l;$lCurrentVersion;$lLastBuild;$lMainVersion;$lMode)
C_PICTURE:C286($p)
C_TEXT:C284($t;$tKey;$tProcess)
C_OBJECT:C1216($o;$oPreferences;$signal)

C_OBJECT:C1216(featuresFlags)
C_OBJECT:C1216(shared)
C_OBJECT:C1216(ui)
C_OBJECT:C1216(record)

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
	
	  // Get the last build number
	$lLastBuild:=Num:C11($oPreferences.lastBuild)
	
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
  //                                                            COMMON VALUES
  // ================================================================================================================================
If (OB Is empty:C1297(shared)) | $bReset
	
	shared:=New object:C1471
	
	shared.extension:=".4dmobileapp"
	shared.archiveExtension:=".zip"
	
	shared.theme:=New object:C1471(\
		"colorjuicer";New object:C1471(\
		"scale";64))
	
	  // minimum requierement
	shared.xCodeVersion:="11.2"
	shared.iosDeploymentTarget:="13.2"
	
	shared.useXcodeDefaultPath:=True:C214
	
	  // Project config
	shared.swift:=New object:C1471(\
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
	shared.targetedDeviceFamily:="1,2"
	
	  // https://developer.apple.com/library/content/documentation/FileManagement/Conceptual/On_Demand_Resources_Guide/index.html#//apple_ref/doc/uid/TP40015083
	shared.onDemandResources:=True:C214
	
	  // https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/AppThinning/AppThinning.html
	shared.bitcode:=True:C214
	
	  // iOS simulator time out
	shared.simulatorTimeout:=10000
	
	  // Info.plist
	shared.infoPlist:=New object:C1471(\
		"build";"1.0.0";\
		"developmentRegion";"en";\
		"storyboard";New object:C1471(\
		"LaunchScreen";"LaunchScreen";\
		"Main";"Main";\
		"backgroundColor";"white"))
	
	shared.urlScheme:=""
	
	  // Exclude some file from copy
	shared.template:=New object:C1471(\
		"exclude";New collection:C1472("layoutIconx2.png";"manifest.json";"template.gif";"template.svg";\
		"relationButton.xib";"README.md";"Package.swift";"Package.resolved";"Cartfile";"Cartfile.resolved"))
	
	  // Data dump
	shared.data:=New object:C1471(\
		"dump";New object:C1471(\
		"limit";1000000;\
		"page";1))
	
	shared.lastBuild:=Num:C11(COMPONENT_Infos ("componentBuild"))
	
	If (shared.lastBuild#$lLastBuild) | $bReset
		
		  // Invalid the cache
		$o:=Folder:C1567("/Library/Caches/com.4d.mobile/sdk")
		
		If ($o.exists)
			
			$o.delete(Delete with contents:K24:24)
			
		End if 
		
		  // Save the preferences
		$oPreferences.lastBuild:=shared.lastBuild
		Folder:C1567(fk user preferences folder:K87:10).file("4d.mobile").setText(JSON Stringify:C1217($oPreferences;*))
		
	End if 
	
	shared.version:=COMPONENT_Infos ("componentVersion")  // Display into the main dialog
	
	shared.keyExtension:="mobileapp"
	
	  // Override common conf by file settings [
	If ($oPreferences.common#Null:C1517)
		
		ob_deepMerge (shared;$oPreferences.common)
		
	End if 
	  //]
	
	  //commonValues.defaultFieldBindingTypes:=JSON Parse(File("/RESOURCES/resources.json").getText()).defaultFieldBindingTypes
	
	shared.defaultFieldBindingTypes:=New collection:C1472
	shared.defaultFieldBindingTypes[Is alpha field:K8:1]:="text"
	shared.defaultFieldBindingTypes[Is boolean:K8:9]:="falseOrTrue"
	shared.defaultFieldBindingTypes[Is integer:K8:5]:="integer"
	shared.defaultFieldBindingTypes[Is longint:K8:6]:="integer"
	shared.defaultFieldBindingTypes[Is integer 64 bits:K8:25]:="integer"
	shared.defaultFieldBindingTypes[Is real:K8:4]:="real"
	shared.defaultFieldBindingTypes[_o_Is float:K8:26]:="real"
	shared.defaultFieldBindingTypes[Is date:K8:7]:="mediumDate"
	shared.defaultFieldBindingTypes[Is time:K8:8]:="mediumTime"
	shared.defaultFieldBindingTypes[Is text:K8:3]:="text"
	shared.defaultFieldBindingTypes[Is picture:K8:10]:="restImage"
	
	  // XXX check table & filed names in https://project.4d.com/issues/90770
	shared.deletedRecordsTable:=New object:C1471(\
		"name";"__DeletedRecords";\
		"fields";New collection:C1472)
	
	shared.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"ID";\
		"type";"INT64";\
		"indexed";True:C214;\
		"primaryKey";True:C214;\
		"autoincrement";True:C214))
	
	shared.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"__Stamp";\
		"type";"INT64";\
		"indexed";True:C214))
	
	shared.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"__TableNumber";\
		"type";"INT32"))
	
	shared.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"__TableName";\
		"type";"VARCHAR(255)"))
	
	shared.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"__PrimaryKey";\
		"type";"VARCHAR(255)"))
	
	shared.stampField:=New object:C1471(\
		"name";"__GlobalStamp";\
		"type";"INT64";\
		"indexed";True:C214)
	
	  // Common project tags
	shared.tags:=New object:C1471(\
		"componentBuild";String:C10(shared.lastBuild);\
		"ideVersion";COMPONENT_Infos ("ideVersion");\
		"ideBuildVersion";COMPONENT_Infos ("ideBuildVersion");\
		"iosDeploymentTarget";shared.iosDeploymentTarget;\
		"swiftVersion";shared.swift.Version;\
		"swiftFlagsDebug";shared.swift.Flags.Debug;\
		"swiftFlagsRelease";shared.swift.Flags.Release;\
		"swiftOptimizationLevelDebug";shared.swift.OptimizationLevel.Debug;\
		"swiftOptimizationLevelRelease";shared.swift.OptimizationLevel.Release;\
		"swiftCompilationModeDebug";shared.swift.CompilationMode.Debug;\
		"swiftCompilationModeRelease";shared.swift.CompilationMode.Release;\
		"onDemandResources";Choose:C955(shared.onDemandResources;"YES";"NO");\
		"bitcode";Choose:C955(shared.bitcode;"YES";"NO");\
		"targetedDeviceFamily";shared.targetedDeviceFamily;\
		"build";shared.infoPlist.build;\
		"developmentRegion";shared.infoPlist.developmentRegion;\
		"storyboardLaunchScreen";shared.infoPlist.storyboard.LaunchScreen;\
		"storyboardMain";shared.infoPlist.storyboard.Main;\
		"urlScheme";shared.urlScheme)
	
	shared.thirdParty:="Carthage"
	shared.thirdPartySources:=shared.thirdParty+"/Checkouts"
	
	record:=logger ("~/Library/Logs/"+Folder:C1567(fk database folder:K87:14).name+".log")
	record.verbose:=(Structure file:C489=Structure file:C489(*))
	
	  // ================================================================================================================================
	  //                                                           ONLY UI PROCESS
	  // ================================================================================================================================
	PROCESS PROPERTIES:C336(Current process:C322;$tProcess;$l;$l;$lMode)
	
	If (Not:C34($lMode ?? 1))  // Not preemptive mode (always false in dev mode!)
		
		If ($tProcess#"4D Mobile (@")
			
			record.reset()
			
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
		ui.colors.strokeColor:=color ("4dColor";New object:C1471(\
			"value";ui.strokeColor))
		ui.colors.highlightColor:=color ("4dColor";New object:C1471(\
			"value";ui.highlightColor))
		ui.colors.highlightColorNoFocus:=color ("4dColor";New object:C1471(\
			"value";ui.highlightColorNoFocus))
		ui.colors.selectedColor:=color ("4dColor";New object:C1471(\
			"value";ui.selectedColor))
		ui.colors.alternateSelectedColor:=color ("4dColor";New object:C1471(\
			"value";ui.alternateSelectedColor))
		ui.colors.backgroundSelectedColor:=color ("4dColor";New object:C1471(\
			"value";ui.backgroundSelectedColor))
		ui.colors.backgroundUnselectedColor:=color ("4dColor";New object:C1471(\
			"value";ui.backgroundUnselectedColor))
		ui.colors.errorColor:=color ("4dColor";New object:C1471(\
			"value";ui.errorColor))
		ui.colors.warningColor:=color ("4dColor";New object:C1471(\
			"value";ui.warningColor))
		
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
$lCurrentVersion:=Num:C11(Application version:C493)
$lMainVersion:=1830

If (OB Is empty:C1297(featuresFlags)) | $bReset
	
	featuresFlags:=New object:C1471(\
		"with";Formula:C1597(Bool:C1537(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3;$1;"_"+String:C10($1))]));\
		"unstable";Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3;$1;"_"+String:C10($1))]:=($lCurrentVersion>=$lMainVersion));\
		"delivered";Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3;$1;"_"+String:C10($1))]:=($lCurrentVersion>=Num:C11($2)));\
		"debug";Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3;$1;"_"+String:C10($1))]:=(Structure file:C489=Structure file:C489(*)));\
		"wip";Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3;$1;"_"+String:C10($1))]:=(Structure file:C489=Structure file:C489(*)));\
		"alias";Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3;$1;"_"+String:C10($1))]:=Bool:C1537(This:C1470[Choose:C955(Value type:C1509($2)=Is text:K8:3;$2;"_"+String:C10($2))]))\
		)
	
	  // ________________________________________________________________________________________________________________________________
	  //                                                             | TOOLS |
	  // ________________________________________________________________________________________________________________________________
	  //featuresFlags._97117:=True    // Deactivate image dump (test purpose)
	  //featuresFlags._917:=True // commit to git generated project
	  //featuresFlags._405:=True // add framework sources to workspace
	  //featuresFlags._406:=True // do not add compiled frameworks to workspace
	  //featuresFlags._475:=True // deactivate code signing on framework
	  //featuresFlags._234:=True // Add in coreData model Record abstract entity
	  //featuresFlags._568:=True // use previous project build SDK as new SDK (ie. fast sdk move, bug exists)
	featuresFlags.debug(8858)  // Activates a debug mode for UI
	
	  // Use old behaviour
	  //featuresFlags._677:=True // Format fields when dumping data from rest (userless if iOS app could translate)
	
	  // ________________________________________________________________________________________________________________________________
	  //                                                             | 17R2 |
	  // ________________________________________________________________________________________________________________________________
	  //featuresFlags._89556:=True    // Reload embedded data from iOS application
	  //featuresFlags._92293:=True    // Support user defined tables
	  //featuresFlags._93674:=True    // Main menu
	  //featuresFlags._8122017:=True  // Turn around bug close window
	  //featuresFlags._96674:=True    // Archive app
	
	  // ________________________________________________________________________________________________________________________________
	  //                                                             | 17R3 |
	  // ________________________________________________________________________________________________________________________________
	  //featuresFlags._100157:=($Lon_version>=1730)  // Template creation
	  //featuresFlags._100353:=featuresFlags._100157  // Template creation: inject any sources
	  //featuresFlags._100191:=($Lon_version>=1730)  // Data Formatter
	
	  // ________________________________________________________________________________________________________________________________
	  //                                                             | 17R4 |
	  // ________________________________________________________________________________________________________________________________
	  //featuresFlags._98105:=($Lon_version>=1740)  // Multi-criteria Search
	  //featuresFlags._100990:=($Lon_version>=1740)  // Custom Data Formatter
	  //featuresFlags._100174:=($Lon_version>=1740)  // Restricted queries
	  //featuresFlags._101725:=featuresFlags._100174  // Restricted queries: Use NSDataSet (beter way to store resources)
	  //featuresFlags._103112:=featuresFlags._100174  // Restricted queries: Move dataSet into database in Mobile Projects
	  //featuresFlags._102457:=($Lon_version>=1740)  // Data file access with /mobileapp key
	
	  // ________________________________________________________________________________________________________________________________
	  //                                                             | 17R5 |
	  // ________________________________________________________________________________________________________________________________
	  //featuresFlags._101637:=($Lon_version>=1750)  // Display n-1 relations
	  //featuresFlags._103850:=featuresFlags._101637  // Reload data from iOS with N-1 relation (Generate core data model with real relation)
	  //featuresFlags._103411:=($Lon_version>=1750)  // Incremental synchronization
	  //featuresFlags._103505:=($Lon_version>=1750)  // Add, Update and Save Actions
	  //featuresFlags.withNewFieldProperties:=($Lon_version>=1750)  // Enable LR works on ds (redmine:98145 - Replace, for data structure access, EXPORT STRUCTURE by ds)
	  //featuresFlags.withRecursiveLink:=True  // Enable recursive link management
	featuresFlags.delivered(98145;1750)  // Replace, for data structure access, EXPORT STRUCTURE by ds
	
	  // ________________________________________________________________________________________________________________________________
	  //                                                             | 17R6 |
	  // ________________________________________________________________________________________________________________________________
	  //featuresFlags._105413:=($Lon_version>=1760)  //  [MOBILE] Actions with parameters
	  //featuresFlags.parameterListOfValues:=featuresFlags._105413  //     Manage field formatters as list of values for parameters
	  //featuresFlags.allowPictureAsActionParameters:=featuresFlags._105413  // #107932 - [Mobile] Allow to use picture as action parameters
	
	  // ________________________________________________________________________________________________________________________________
	  //                                                             |  18  |
	  // ________________________________________________________________________________________________________________________________
	featuresFlags.delivered(105431;1800)  // Display 1-n relations
	featuresFlags.delivered(110882;1800)  // Dump data into core data SQLLite database
	
	featuresFlags.delivered("newDataModel";1800)
	
	  // ________________________________________________________________________________________________________________________________
	  //                                                             | 18R2 |
	  // ________________________________________________________________________________________________________________________________
	featuresFlags.delivered("repairStructureMoreVisible";1820)
	featuresFlags.delivered(113164;1820)  // Enable/disable image dump
	
	  // ________________________________________________________________________________________________________________________________
	  //                                                             |  WIP |
	  // ________________________________________________________________________________________________________________________________
	featuresFlags.wip("withWidgetActions")  // Enable widget actions
	featuresFlags.wip("accentColors")  // Manage colors according to user system parameters
	
	featuresFlags.wip(114338)  // Support Collection of field injected into detail template https://project.4d.com/issues/114338
	
	featuresFlags.unstable(113016)  // Svg improvement in forms section
	featuresFlags.unstable(112225)  // Select / install / use custom templates
	
	featuresFlags.wip("formatMarketPlace")  // Manage format as archive
	
End if 

If ($oPreferences.features#Null:C1517)  // Update feature flags with the local preferences
	
	For each ($o;$oPreferences.features)
		
		If (Value type:C1509($o.enabled)=Is boolean:K8:9)
			
			featuresFlags["_"+String:C10($o.id)]:=Bool:C1537($o.enabled)
			
		Else 
			
			For each ($tKey;$o.enabled) Until (Not:C34($bEnabled))
				
				Case of 
						
						  //______________________________________________________
					: ($tKey="os")
						
						$bEnabled:=((Num:C11(Is macOS:C1572)+1)=Num:C11($o.enabled[$tKey]))
						
						  //______________________________________________________
					: ($tKey="matrix")
						
						$bEnabled:=(Bool:C1537($o.enabled[$tKey]))
						
						  //______________________________________________________
					: ($tKey="debug")
						
						If ($o.enabled[$tKey])
							
							  // Only into a debug version
							$bEnabled:=Not:C34(Is compiled mode:C492)
							
						Else 
							
							  // Not into a debug version
							$bEnabled:=Is compiled mode:C492
							
						End if 
						
						  //______________________________________________________
					: ($tKey="bitness")
						
						Case of 
								
								  //……………………………………………………………………………………………………
							: (Num:C11($o.enabled[$tKey])=64)
								
								$bEnabled:=(Version type:C495 ?? 64 bit version:K5:25)
								
								  //……………………………………………………………………………………………………
							: (Num:C11($o.enabled[$tKey])=32)
								
								$bEnabled:=Not:C34(Version type:C495 ?? 64 bit version:K5:25)
								
								  //……………………………………………………………………………………………………
							Else 
								
								ASSERT:C1129(False:C215;"Unknown value ("+$o.enabled[$tKey]+") for the key : \""+$tKey+"\"")
								$bEnabled:=False:C215
								
								  //……………………………………………………………………………………………………
						End case 
						
						  //______________________________________________________
					: ($tKey="version")
						
						$bEnabled:=($lCurrentVersion>=Num:C11($o.enabled[$tKey]))
						
						  //______________________________________________________
					: ($tKey="type")
						
						$bEnabled:=(Application type:C494=Num:C11($o.enabled[$tKey]))
						
						  //______________________________________________________
					Else 
						
						ASSERT:C1129(False:C215;"Unknown key: \""+$tKey+"\"")
						
						  //______________________________________________________
				End case 
			End for each 
			
			featuresFlags["_"+String:C10($o.id)]:=$bEnabled
			
		End if 
	End for each 
End if 

  // ________________________________________________________________________________________________________________________________
  //                                                             | ALIAS |
  // ________________________________________________________________________________________________________________________________
featuresFlags.alias("oneToManyRelations";105431)
featuresFlags.alias("setImageDump";113164)
featuresFlags.alias("newViewUI";113016)
featuresFlags.alias("resourcesBrowser";112225)

If (Not:C34($lMode ?? 1))\
 & ($tProcess#"4D Mobile (@")
	
	For each ($t;featuresFlags)
		
		If (Value type:C1509(featuresFlags[$t])=Is boolean:K8:9)
			
			record.log("feature "+$t+": "+Choose:C955(featuresFlags[$t];"Enabled";"Disabled"))
			
		End if 
	End for each 
	
	record.line()
	
End if 

  // ________________________________________________________________________________________________________________________________
  //                                                         | AFTER FLAGS |
  // ________________________________________________________________________________________________________________________________

COMPONENT_DEFINE_TOOLS 

If (featuresFlags.with("accentColors"))
	
	  // Ui.selectedColor:=Highlight menu background color
	  // Ui.highlightColor:=Highlight menu background color
	
	  //ui.backgroundSelectedColor:=Highlight menu background color // 0x004BA6F8
	  //ui.backgroundUnselectedColor:=Background color none // 0x005A5A5A
	
End if 

If (Bool:C1537(featuresFlags._8858))
	
	SET ASSERT ENABLED:C1131(True:C214;*)
	
End if 

record.info("Assert "+Choose:C955(Get assert enabled:C1130;"Enabled";"Disabled"))

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End