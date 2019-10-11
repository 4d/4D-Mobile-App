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
C_BOOLEAN:C305($Boo_enabled;$Boo_reset)
C_LONGINT:C283($l;$Lon_lastBuild;$Lon_Mode;$Lon_version)
C_PICTURE:C286($p)
C_TEXT:C284($t;$Txt_key)
C_OBJECT:C1216($o;$Obj_preferences)

C_OBJECT:C1216(featuresFlags)
C_OBJECT:C1216(commonValues)
C_OBJECT:C1216(ui)

  // ----------------------------------------------------
  // Initialisations
$Boo_reset:=Macintosh option down:C545

  // ----------------------------------------------------
  // Disable asserts in release mode
SET ASSERT ENABLED:C1131(Not:C34(Is compiled mode:C492);*)

  // Get the config file
$o:=Folder:C1567(fk user preferences folder:K87:10).file("4d.mobile")

If ($o.exists)
	
	$Obj_preferences:=JSON Parse:C1218($o.getText())
	
	  // Get the last build number
	$Lon_lastBuild:=Num:C11($Obj_preferences.lastBuild)
	
Else 
	
	  // Create the preferences
	$Obj_preferences:=New object:C1471
	
End if 

$o:=New signal:C1641
CALL WORKER:C1389(1;"INIT";$o)
$o.wait()

  // ================================================================================================================================
  //                                                            COMMON VALUES
  // ================================================================================================================================
If (OB Is empty:C1297(commonValues)) | $Boo_reset
	
	commonValues:=New object:C1471
	
	commonValues.extension:=".4dmobileapp"
	
	commonValues.theme:=New object:C1471(\
		"colorjuicer";New object:C1471(\
		"scale";64))
	
	  // minimum requierement
	commonValues.xCodeVersion:="11.0"
	commonValues.iosDeploymentTarget:="13.0"
	
	commonValues.useXcodeDefaultPath:=True:C214
	
	  // Project config
	commonValues.swift:=New object:C1471(\
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
	commonValues.targetedDeviceFamily:="1,2"
	
	  // https://developer.apple.com/library/content/documentation/FileManagement/Conceptual/On_Demand_Resources_Guide/index.html#//apple_ref/doc/uid/TP40015083
	commonValues.onDemandResources:=True:C214
	
	  // https://develoer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/AppThinning/AppThinning.html
	commonValues.bitcode:=True:C214
	
	  // iOS simulator time out
	commonValues.simulatorTimeout:=10000
	
	  // Info.plist
	commonValues.infoPlist:=New object:C1471(\
		"build";"1.0.0";\
		"developmentRegion";"en";\
		"storyboard";New object:C1471(\
		"LaunchScreen";"LaunchScreen";\
		"Main";"Main";\
		"backgroundColor";"white"))
	
	commonValues.urlScheme:=""
	
	  // Exclude some file from copy
	commonValues.template:=New object:C1471(\
		"exclude";New collection:C1472("layoutIconx2.png";\
		"manifest.json";"template.svg";"relationButton.xib"))
	
	  // Data dump
	commonValues.data:=New object:C1471(\
		"dump";New object:C1471(\
		"limit";1000000;\
		"page";1))
	
	commonValues.lastBuild:=Num:C11(COMPONENT_Infos ("componentBuild"))
	
	If (commonValues.lastBuild#$Lon_lastBuild) | $Boo_reset
		
		  // Invalid the cache
		$o:=Folder:C1567("/Library/Caches/com.4d.mobile/sdk")
		
		If ($o.exists)
			
			$o.delete(Delete with contents:K24:24)
			
		End if 
		
		  // Save the preferences
		$Obj_preferences.lastBuild:=commonValues.lastBuild
		Folder:C1567(fk user preferences folder:K87:10).file("4d.mobile").setText(JSON Stringify:C1217($Obj_preferences;*))
		
	End if 
	
	commonValues.version:=COMPONENT_Infos ("componentVersion")  // Display into the main dialog
	
	commonValues.keyExtension:="mobileapp"
	
	  // Override common conf by file settings [
	If ($Obj_preferences.common#Null:C1517)
		
		ob_deepMerge (commonValues;$Obj_preferences.common)
		
	End if 
	  //]
	
	  //commonValues.defaultFieldBindingTypes:=JSON Parse(File("/RESOURCES/resources.json").getText()).defaultFieldBindingTypes
	
	commonValues.defaultFieldBindingTypes:=New collection:C1472
	commonValues.defaultFieldBindingTypes[Is alpha field:K8:1]:="text"
	commonValues.defaultFieldBindingTypes[Is boolean:K8:9]:="falseOrTrue"
	commonValues.defaultFieldBindingTypes[Is integer:K8:5]:="integer"
	commonValues.defaultFieldBindingTypes[Is longint:K8:6]:="integer"
	commonValues.defaultFieldBindingTypes[Is integer 64 bits:K8:25]:="integer"
	commonValues.defaultFieldBindingTypes[Is real:K8:4]:="real"
	commonValues.defaultFieldBindingTypes[_o_Is float:K8:26]:="real"
	commonValues.defaultFieldBindingTypes[Is date:K8:7]:="mediumDate"
	commonValues.defaultFieldBindingTypes[Is time:K8:8]:="mediumTime"
	commonValues.defaultFieldBindingTypes[Is text:K8:3]:="text"
	commonValues.defaultFieldBindingTypes[Is picture:K8:10]:="restImage"
	
	
	  // XXX check table & filed names in https://project.4d.com/issues/90770
	commonValues.deletedRecordsTable:=New object:C1471(\
		"name";"__DeletedRecords";\
		"fields";New collection:C1472)
	
	commonValues.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"ID";\
		"type";"INT64";\
		"indexed";True:C214;\
		"primaryKey";True:C214;\
		"autoincrement";True:C214))
	
	commonValues.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"__Stamp";\
		"type";"INT64";\
		"indexed";True:C214))
	
	commonValues.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"__TableNumber";\
		"type";"INT32"))
	
	commonValues.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"__TableName";\
		"type";"VARCHAR(255)"))
	
	commonValues.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"__PrimaryKey";\
		"type";"VARCHAR(255)"))
	
	commonValues.stampField:=New object:C1471(\
		"name";"__GlobalStamp";\
		"type";"INT64";\
		"indexed";True:C214)
	
	  // Common project tags
	commonValues.tags:=New object:C1471(\
		"componentBuild";String:C10(commonValues.lastBuild);\
		"ideVersion";COMPONENT_Infos ("ideVersion");\
		"ideBuildVersion";COMPONENT_Infos ("ideBuildVersion");\
		"iosDeploymentTarget";commonValues.iosDeploymentTarget;\
		"swiftVersion";commonValues.swift.Version;\
		"swiftFlagsDebug";commonValues.swift.Flags.Debug;\
		"swiftFlagsRelease";commonValues.swift.Flags.Release;\
		"swiftOptimizationLevelDebug";commonValues.swift.OptimizationLevel.Debug;\
		"swiftOptimizationLevelRelease";commonValues.swift.OptimizationLevel.Release;\
		"swiftCompilationModeDebug";commonValues.swift.CompilationMode.Debug;\
		"swiftCompilationModeRelease";commonValues.swift.CompilationMode.Release;\
		"onDemandResources";Choose:C955(commonValues.onDemandResources;"YES";"NO");\
		"bitcode";Choose:C955(commonValues.bitcode;"YES";"NO");\
		"targetedDeviceFamily";commonValues.targetedDeviceFamily;\
		"build";commonValues.infoPlist.build;\
		"developmentRegion";commonValues.infoPlist.developmentRegion;\
		"storyboardLaunchScreen";commonValues.infoPlist.storyboard.LaunchScreen;\
		"storyboardMain";commonValues.infoPlist.storyboard.Main;\
		"urlScheme";commonValues.urlScheme)
	
	commonValues.thirdParty:="Carthage"
	commonValues.thirdPartySources:=commonValues.thirdParty+"/Checkouts"
	
	  // ================================================================================================================================
	  //                                                           ONLY UI PROCESS
	  // ================================================================================================================================
	PROCESS PROPERTIES:C336(Current process:C322;$t;$l;$l;$Lon_Mode)
	
	If (Not:C34($Lon_Mode ?? 1))  // Not preemptive mode (always false in dev mode!)
		
		ui:=New object:C1471
		
		ui.debugMode:=(Structure file:C489=Structure file:C489(*))  // True in matrix database
		
		  // Preload icons for field types [
		
		  // #OLD_MECHANISM =========================================
		ui.typeIcons:=New collection:C1472
		
		For each ($o;Folder:C1567("/RESOURCES/images/fields").files())
			
			READ PICTURE FILE:C678($o.platformPath;$p)
			ui.typeIcons[Num:C11(Replace string:C233($o.name;"field_";""))]:=$p
			
		End for each 
		
		  // ======================================================= ]
		
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
$Lon_version:=Num:C11(Application version:C493)

If (OB Is empty:C1297(featuresFlags)) | $Boo_reset
	
	featuresFlags:=New object:C1471(\
		"with";Formula:C1597(Bool:C1537(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3;$1;"_"+String:C10($1))])))
	
	  // ________________________________________________________________________________________________________________________________
	  //                                                             | TOOLS |
	  // ________________________________________________________________________________________________________________________________
	  //featuresFlags._97117:=True    // Deactivate image dump (test purpose)
	  //featuresFlags._917:=True //      commit to git generated project
	  //featuresFlags._405:=True //      add framework sources to workspace
	  //featuresFlags._406:=True //      do not add compiled frameworks to workspace
	  //featuresFlags._475:=True //      deactivate code signing on framework
	  //featuresFlags._234:=True //      Add in coreData model Record abstract entity
	  //featuresFlags._568:=True //      use previous project build SDK as new SDK (ie. fast sdk move, bug exists)
	featuresFlags._8858:=(Structure file:C489=Structure file:C489(*))  // Activates a debug mode for UI
	
	  // Use old behaviour
	  //featuresFlags._677:=True //     Format fields when dumping data from rest (userless if iOS app could translate)
	
	  // ________________________________________________________________________________________________________________________________
	  //                                                             | 17R2 |
	  // ________________________________________________________________________________________________________________________________
	  //featuresFlags._89556:=True    //   [DONE] Reload embedded data from iOS application
	  //featuresFlags._92293:=True    //   [DONE] Support user defined tables
	  //featuresFlags._93674:=True    //   [DONE] Main menu
	  //featuresFlags._8122017:=True  //   [FIXED] Turn around bug close window
	  //featuresFlags._96674:=True    //   [DONE] Archive app
	
	  // ________________________________________________________________________________________________________________________________
	  //                                                             | 17R3 |
	  // ________________________________________________________________________________________________________________________________
	  //featuresFlags._100157:=($Lon_version>=1730)  //   [MOBILE] Template creation
	  //featuresFlags._100353:=featuresFlags._100157  //  [MOBILE] Template creation: inject any sources
	  //featuresFlags._100191:=($Lon_version>=1730)  //   [MOBILE] Data Formatter
	
	  // ________________________________________________________________________________________________________________________________
	  //                                                             | 17R4 |
	  // ________________________________________________________________________________________________________________________________
	  //featuresFlags._98105:=($Lon_version>=1740)  //    [MOBILE] Multi-criteria Search
	  //featuresFlags._100990:=($Lon_version>=1740)  //   [MOBILE] Custom Data Formatter
	  //featuresFlags._100174:=($Lon_version>=1740)  //   [MOBILE] Restricted queries
	  //featuresFlags._101725:=featuresFlags._100174  //  [MOBILE] Restricted queries: Use NSDataSet (beter way to store resources)
	  //featuresFlags._103112:=featuresFlags._100174  //  [MOBILE] Restricted queries: Move dataSet into database in Mobile Projects
	  //featuresFlags._102457:=($Lon_version>=1740)  //   [MOBILE] Data file access with /mobileapp key
	
	  // ________________________________________________________________________________________________________________________________
	  //                                                             | 17R5 |
	  // ________________________________________________________________________________________________________________________________
	  //featuresFlags._101637:=($Lon_version>=1750)  //   [MOBILE] Display n-1 relations
	  //featuresFlags._103850:=featuresFlags._101637  //  [MOBILE] Reload data from iOS with N-1 relation (Generate core data model with real relation)
	  //featuresFlags._103411:=($Lon_version>=1750)  //   [MOBILE] Incremental synchronization
	  //featuresFlags._103505:=($Lon_version>=1750)  //   [MOBILE] Add, Update and Save Actions
	  //featuresFlags.withNewFieldProperties:=($Lon_version>=1750)  //  Enable LR works on ds (redmine:98145 - Replace, for data structure access, EXPORT STRUCTURE by ds)
	  //featuresFlags.withRecursiveLink:=True  //                       Enable recursive link management
	
	  // ________________________________________________________________________________________________________________________________
	  //                                                             | 17R6 |
	  // ________________________________________________________________________________________________________________________________
	featuresFlags._105413:=($Lon_version>=1760)  //  [MOBILE] Actions with parameters
	featuresFlags.parameterListOfValues:=featuresFlags._105413  //     Manage field formatters as list of values for parameters
	featuresFlags.allowPictureAsActionParameters:=featuresFlags._105413  // #107932 - [Mobile] Allow to use picture as action parameters
	
	  // ________________________________________________________________________________________________________________________________
	  //                                                             |  18  |
	  // ________________________________________________________________________________________________________________________________
	featuresFlags._105431:=($Lon_version>=1800)  //  [MOBILE] Display 1-n relations
	featuresFlags._110882:=($Lon_version>=1800)  //  [MOBILE] Dump data into core data SQLLite database
	
	  // ________________________________________________________________________________________________________________________________
	  //                                                             |  WIP |
	  // ________________________________________________________________________________________________________________________________
	featuresFlags._98145:=($Lon_version>=1750)  //                   Replace, for data structure access, EXPORT STRUCTURE by ds
	featuresFlags.withWidgetActions:=featuresFlags._8858  //         Enable widget actions
	
	
	featuresFlags.accentColors:=featuresFlags._8858  // Manage colors according to user system parameters
	
End if 

If ($Obj_preferences.features#Null:C1517)  // Update feature flags with the local preferences
	
	For each ($o;$Obj_preferences.features)
		
		If (Value type:C1509($o.enabled)=Is boolean:K8:9)
			
			featuresFlags["_"+String:C10($o.id)]:=Bool:C1537($o.enabled)
			
		Else 
			
			For each ($Txt_key;$o.enabled) Until (Not:C34($Boo_enabled))
				
				Case of 
						
						  //______________________________________________________
					: ($Txt_key="os")
						
						$Boo_enabled:=((Num:C11(Is macOS:C1572)+1)=Num:C11($o.enabled[$Txt_key]))
						
						  //______________________________________________________
					: ($Txt_key="matrix")
						
						$Boo_enabled:=(Bool:C1537($o.enabled[$Txt_key]))
						
						  //______________________________________________________
					: ($Txt_key="debug")
						
						If ($o.enabled[$Txt_key])
							
							  // Only into a debug version
							$Boo_enabled:=Not:C34(Is compiled mode:C492)
							
						Else 
							
							  // Not into a debug version
							$Boo_enabled:=Is compiled mode:C492
							
						End if 
						
						  //______________________________________________________
					: ($Txt_key="bitness")
						
						Case of 
								
								  //……………………………………………………………………………………………………
							: (Num:C11($o.enabled[$Txt_key])=64)
								
								$Boo_enabled:=(Version type:C495 ?? 64 bit version:K5:25)
								
								  //……………………………………………………………………………………………………
							: (Num:C11($o.enabled[$Txt_key])=32)
								
								$Boo_enabled:=Not:C34(Version type:C495 ?? 64 bit version:K5:25)
								
								  //……………………………………………………………………………………………………
							Else 
								
								ASSERT:C1129(False:C215;"Unknown value ("+$o.enabled[$Txt_key]+") for the key : \""+$Txt_key+"\"")
								$Boo_enabled:=False:C215
								
								  //……………………………………………………………………………………………………
						End case 
						
						  //______________________________________________________
					: ($Txt_key="version")
						
						$Boo_enabled:=($Lon_version>=Num:C11($o.enabled[$Txt_key]))
						
						  //______________________________________________________
					: ($Txt_key="type")
						
						$Boo_enabled:=(Application type:C494=Num:C11($o.enabled[$Txt_key]))
						
						  //______________________________________________________
					Else 
						
						ASSERT:C1129(False:C215;"Unknown key: \""+$Txt_key+"\"")
						
						  //______________________________________________________
				End case 
			End for each 
			
			featuresFlags["_"+String:C10($o.id)]:=$Boo_enabled
			
		End if 
	End for each 
End if 

  // ________________________________________________________________________________________________________________________________
  //                                                             | ALIAS |
  // ________________________________________________________________________________________________________________________________
featuresFlags.actionWithParameters:=featuresFlags._105413  //    [MOBILE] Actions with parameters
featuresFlags.oneToManyRelations:=featuresFlags._105431  //    [MOBILE] Display 1-n relations

  // ________________________________________________________________________________________________________________________________
  //                                                         | AFTER FLAGS |
  // ________________________________________________________________________________________________________________________________

COMPONENT_DEFINE_TOOLS 

If (Bool:C1537(featuresFlags.with("accentColors")))
	
	  //ui.selectedColor:=Highlight menu background color
	  //ui.highlightColor:=Highlight menu background color
	
	  //ui.backgroundSelectedColor:=Highlight menu background color // 0x004BA6F8
	  //ui.backgroundUnselectedColor:=Background color none // 0x005A5A5A
	
End if 

If (Bool:C1537(featuresFlags._8858))
	
	SET ASSERT ENABLED:C1131(True:C214;*)
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End