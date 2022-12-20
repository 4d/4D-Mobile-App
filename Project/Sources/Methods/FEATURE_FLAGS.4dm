//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($version : Integer; $file : 4D:C1709.File)

var $c : Collection

Feature:=cs:C1710.Feature.new($version; $file)

If (True:C214)  // DELIVERED
	
	// Mark:-1️⃣7️⃣
	
	// Mark:R2
	Feature.delivered(89556; 1720)  // Reload embedded data from iOS application
	Feature.delivered(92293; 1720)  // Support user defined tables
	Feature.delivered(93674; 1720)  // Main menu
	Feature.delivered(8122017; 1720)  // Turn around bug close window
	Feature.delivered(96674; 1720)  // Archive app
	
	// Mark:R3
	Feature.delivered(100157; 1730)  // Template creation
	Feature.delivered(100353; 1730)  // Template creation: inject any sources
	Feature.delivered(100191; 1730)  // Data Formatter
	
	// Mark:R4
	Feature.delivered(98105; 1740)  // Multi-criteria Search
	Feature.delivered(100990; 1740)  // Custom Data Formatter
	Feature.delivered(100174; 1740)  // Restricted queries
	
	Feature.delivered(101725; 1740)  // Restricted queries: Use NSDataSet (beter way to store resources)
	
	Feature.delivered(103112; 1740)  // Restricted queries: Move dataSet into database in Mobile Projects
	Feature.delivered(102457; 1740)  // Data file access with /mobileapp key
	
	// Mark:R5
	Feature.delivered(101637; 1750)  // Display n-1 relations
	Feature.delivered(103850; 1750)  // Reload data from iOS with N-1 relation (Generate core data model with real relation)
	Feature.delivered(103411; 1750)  // Incremental synchronization
	Feature.delivered(103505; 1750)  // Add, Update and Save Actions
	Feature.delivered("withNewFieldProperties"; 1750)  // Enable LR works on ds (redmine:98145 - Replace, for data structure access, EXPORT STRUCTURE by ds)
	Feature.delivered("withRecursiveLink"; 1750)  // Enable recursive link management
	Feature.delivered(98145; 1750)  // Replace, for data structure access, EXPORT STRUCTURE by ds
	
	// Mark:R6
	Feature.delivered(105413; 1760)  // [MOBILE] Actions with parameters
	Feature.delivered("parameterListOfValues"; 1760)  // Manage field formatters as list of values for parameters
	Feature.delivered("allowPictureAsActionParameters"; 1760)  // #107932 - [Mobile] Allow to use picture as action parameters
	
	// Mark:-1️⃣8️⃣
	Feature.delivered(105431; 1800)  // Display 1-n relations
	Feature.delivered(110882; 1800)  // Dump data into core data SQLLite database
	Feature.delivered("newDataModel"; 1800)
	
	// Mark:R2
	Feature.delivered("repairStructureMoreVisible"; 1820)
	Feature.delivered(113164; 1820)  // Enable/disable image dump
	
	// Mark:R3
	Feature.delivered(112225; 1830)  // Select/install/use custom templates
	
	// Mark:R4
	Feature.delivered(113016; 1840)  // Svg improvement in forms section
	Feature.delivered(107526; 1840)  // Push Notifications
	
	// Mark:R5
	Feature.delivered(117618; 1850)  // Deep Linking
	
	// Mark:R6
	Feature.delivered(117601; 1860)  // Relation management optimisation
	Feature.delivered("templateClass"; 1860)
	Feature.delivered("searchWithBarCode"; 1860)
	
	// Mark:-1️⃣9️⃣
	Feature.delivered("withSimulatorClass"; 1900)  // Use simctl class intead of _o_simulator
	
	Feature.delivered("wizards"; 1900)  // Use a wizard instead of standard dialogs to create or open a project
	
	// Mark:R2
	Feature.delivered("android"; 1920)  // Android support global flag
	
	Feature.delivered("targetPannel"; 1920)  // Use a separate pannel for the target OS
	
	Feature.delivered("dominantColor"; 1920)  // Feature #127813: BackgroundColor picker
	
	Feature.delivered("iconActionMenu"; 1920)  // Use action button for icon on product panel
	
	Feature.delivered("plistClass"; 1920)  // Use plist class instead of plist method
	
	Feature.delivered("sortAction"; 1920)  // https:// Project.4d.com/issues/117660
	Feature.delivered("ConnectedDevices"; 1920)  // Add connected devices to the simulator tool
	
	// Mark:R3
	Feature.delivered("predictiveEntryInActionParam"; 1930)  // #128898 Name of the action parameters and sorting criteria can be modified
	Feature.delivered("customActionFormatterWithCode"; 1930)  // #129036 custom input control for action parameter with ios code
	Feature.delivered("customActionFormatter"; 1930)  // #128195 custom input control for action parameter
	Feature.delivered("newActionFormatterChoiceList"; 1930)  // Menu to create action formatter choice list directly
	
	Feature.delivered("computedProperties"; 1930)  // #130206 [MOBILE] Use computed attributes
	
	// Mark:R4
	Feature.delivered("androidActions"; 1940)  // [Mobile] Feature flag pour activer les actions dans le projet mobile
	Feature.delivered("objectFieldManagement"; 1940)  // [MOBILE] Object fields Management
	Feature.delivered("android1ToNRelations"; 1940)  // [ANDROID] 1 to N relations
	Feature.delivered("cancelableDatasetGeneration"; 1940)  // [MOBILE] Data generation
	Feature.delivered("useTextRestResponse"; 1940)  // [MOBILE] Data generation : for optis
	
	// Mark:R5
	Feature.delivered("xcDataModelClass"; 1950)  // Use class to create core data model ie. xcDataModel (useful to refactor for alias)
	Feature.delivered("iosBuildWithClass"; 1950)  // Use cs.MobileProjectIOS class
	Feature.delivered("modernStructure"; 1950)
	
	// Mark:R6
	Feature.delivered("alias"; 1960)  // [MOBILE] Use aliases
	Feature.delivered("androidDataSet"; 1960)  // [ANDROID] Data set
	
	// Mark:R7
	Feature.delivered("openURLAction"; 1970)  // azure:3625 [MOBILE] Execute an action that open web area
	
End if 

If (True:C214)  // UNSTABLE
	
	// Mark:R8
	Feature.unstable("customLoginForms")  // [Android] Custom login
	Feature.unstable("inputControlArchive")  // Allow to use zip for inputControl, as requested by azure:5424 The mobile project shall support a zip format for input control with Android and iOS.
	Feature.unstable("inputControlWithCodeAndroid")  // Allow to use inputControl with code, feature by azure:3862 [Android] Input controls with Kotlin code
	
End if 

// Mark:-🚧 MAIN
Feature.main("listEditor")  // #130828 [MOBILE] Create and edit an input control from the project editor
Feature.main("actionsInTabBar")
Feature.main("iosSDKfromAWS")  // Download iOS SDK from AWS

// Mark:-🚧 WIP
Feature.wip("buildWithCmd")  // Allow to create/build using cmd only: azure:3628

// FEATURE.wip("simuARMOnAppleProcessor") // Mac M1 build for simu using arm64
Feature.wip("duplicateTemplate")  // Allow to duplicate template in host database and show on disk https:// Project.4d.com/issues/98054
Feature.wip("newFormatterChoiceList")  // Menu to create formatter choice list directly , from data
Feature.wip("taskIndicator")  // UI for background tasks executing
Feature.wip("DataSourceClass")  // Work with DataSource class class to test the data source

// Mark:-👨‍💻 Eric
$c:=New collection:C1472("emarchand"; "phimage")
Feature.dev("gitCommit"; $c)  // Commit to git generated project
Feature.dev("generateForDev"; $c)  // Add framework sources and do not add compiled frameworks to workspace, deactivate code signing on framework
//Feature.dev("buildWith4DAction"; $c)  // Use a 4DAction to launch app build from prj editor

//FEATURE.dev("devGallery"; $c)  // Allow to dev with local http gallery

// Mark:-👴🏻 Vincent
$c:=New collection:C1472("vdelachaux"; "Vincent de LACHAUX")
Feature.dev("vdl"; $c)

// Mark:-⛔ PENDING
Feature.pending(129953)  // [MOBILE] Handle Many-one-Many relations

Feature.pending("compressionOfTemplates")  // Use the archive "/RESOURCES/template.zip" instead of "templates" folder in builded component

//FEATURE.dev("testCompression";New collection("vdelachaux"; "Vincent de LACHAUX"))
Feature.pending("formatMarketPlace")  // Manage format as archive
Feature.pending("sharedActionWithDescription")  // [MOBILE] Add a description parameter to predefined share action
Feature.pending("withWidgetActions")  // Enable widget actions
Feature.pending(114338)  // Support Collection of field injected into detail template https:// Project.4d.com/issues/114338
Feature.pending("droppingNext"; 114338)  // Allow to drop a multivalued field next to another existing dropped multivalued fields

Feature.pending("coreDataAbstractEntity")  // Add in coreData model Record abstract entity

Feature.pending("nonScalarAlias")  // Manage non scalar alias

// Mark:-→ Local preferences
Feature.loadLocal()

// Mark:-→ Alias
Feature.alias("debug"; 8858)
Feature.alias("many-one-many"; 129953)
