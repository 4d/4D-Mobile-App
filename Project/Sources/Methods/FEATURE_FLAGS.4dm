//%attributes = {"invisible":true}
//%attributes = {"invisible":true}
var $1 : Integer
var $2 : Object

If (False:C215)
	C_LONGINT:C283(FEATURE_FLAGS; $1)
	C_OBJECT:C1216(FEATURE_FLAGS; $2)
End if 

var $key : Text
var $enabled : Boolean
var $stableVersion : Integer
var $o; $preferences : Object

$stableVersion:=$1
$preferences:=$2

FEATURE:=New object:C1471(\
"with"; Formula:C1597(Bool:C1537(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))])); \
"isUnstable"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=(Num:C11(SHARED.ide.version)>=$stableVersion)); \
"isDelivered"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=(Num:C11(SHARED.ide.version)>=Num:C11($2))); \
"isDebug"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=(Structure file:C489=Structure file:C489(*))); \
"isWIP"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=(Structure file:C489=Structure file:C489(*))); \
"isPending"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=False:C215); \
"vdl"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=(Current system user:C484="vdelachaux") | (Current system user:C484="Vincent de LACHAUX")); \
"erm"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=(Current system user:C484="emarchand") | (Current system user:C484="phimage")); \
"makeAlias"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=Bool:C1537(This:C1470[Choose:C955(Value type:C1509($2)=Is text:K8:3; $2; "_"+String:C10($2))])); \
"main"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=(Application version:C493(*)="A@"))\
)

/* _____________
TOOLS
_____________*/

FEATURE.isDebug(8858)  // Activates a debug mode for UI
FEATURE.makeAlias("debug"; 8858)

If (True:C214)  // DELIVERED
	
	// Mark:-1️⃣7️⃣
	
	// Mark:-R2
	FEATURE.isDelivered(89556; 1720)  // Reload embedded data from iOS application
	FEATURE.isDelivered(92293; 1720)  // Support user defined tables
	FEATURE.isDelivered(93674; 1720)  // Main menu
	FEATURE.isDelivered(8122017; 1720)  // Turn around bug close window
	FEATURE.isDelivered(96674; 1720)  // Archive app
	
	// Mark:-R3
	FEATURE.isDelivered(100157; 1730)  // Template creation
	FEATURE.isDelivered(100353; 1730)  // Template creation: inject any sources
	FEATURE.isDelivered(100191; 1730)  // Data Formatter
	
	// Mark:-R4
	FEATURE.isDelivered(98105; 1740)  // Multi-criteria Search
	FEATURE.isDelivered(100990; 1740)  // Custom Data Formatter
	FEATURE.isDelivered(100174; 1740)  // Restricted queries
	FEATURE.isDelivered(101725; 1740)  // Restricted queries: Use NSDataSet (beter way to store resources)
	FEATURE.isDelivered(103112; 1740)  // Restricted queries: Move dataSet into database in Mobile Projects
	FEATURE.isDelivered(102457; 1740)  // Data file access with /mobileapp key
	
	// Mark:-R5
	FEATURE.isDelivered(101637; 1750)  // Display n-1 relations
	FEATURE.isDelivered(103850; 1750)  // Reload data from iOS with N-1 relation (Generate core data model with real relation)
	FEATURE.isDelivered(103411; 1750)  // Incremental synchronization
	FEATURE.isDelivered(103505; 1750)  // Add, Update and Save Actions
	FEATURE.isDelivered("withNewFieldProperties"; 1750)  // Enable LR works on ds (redmine:98145 - Replace, for data structure access, EXPORT STRUCTURE by ds)
	FEATURE.isDelivered("withRecursiveLink"; 1750)  // Enable recursive link management
	FEATURE.isDelivered(98145; 1750)  // Replace, for data structure access, EXPORT STRUCTURE by ds
	
	// Mark:-R6
	FEATURE.isDelivered(105413; 1760)  // [MOBILE] Actions with parameters
	FEATURE.isDelivered("parameterListOfValues"; 1760)  // Manage field formatters as list of values for parameters
	FEATURE.isDelivered("allowPictureAsActionParameters"; 1760)  // #107932 - [Mobile] Allow to use picture as action parameters
	
	// Mark:-1️⃣8️⃣
	FEATURE.isDelivered(105431; 1800)  // Display 1-n relations
	FEATURE.isDelivered(110882; 1800)  // Dump data into core data SQLLite database
	FEATURE.isDelivered("newDataModel"; 1800)
	
	// Mark:-R2
	FEATURE.isDelivered("repairStructureMoreVisible"; 1820)
	FEATURE.isDelivered(113164; 1820)  // Enable/disable image dump
	
	// Mark:-R3
	FEATURE.isDelivered(112225; 1830)  // Select/install/use custom templates
	
	// Mark:-R4
	FEATURE.isDelivered(113016; 1840)  // Svg improvement in forms section
	FEATURE.isDelivered(107526; 1840)  // Push Notifications
	
	// Mark:-R5
	FEATURE.isDelivered(117618; 1850)  // Deep Linking
	
	// Mark:-R6
	FEATURE.isDelivered(117601; 1860)  // Relation management optimisation
	FEATURE.isDelivered("templateClass"; 1860)
	FEATURE.isDelivered("searchWithBarCode"; 1860)
	
	// Mark:-1️⃣9️⃣
	FEATURE.isDelivered("withSimulatorClass"; 1900)  // Use simctl class intead of _o_simulator
	FEATURE.isDelivered("wizards"; 1900)  // Use a wizard instead of standard dialogs to create or open a project
	
	// Mark:-R2
	FEATURE.isDelivered("android"; 1920)  // Android support global flag
	FEATURE.isDelivered("targetPannel"; 1920)  // Use a separate pannel for the target OS
	FEATURE.isDelivered("dominantColor"; 1920)  // Feature #127813: BackgroundColor picker
	FEATURE.isDelivered("iconActionMenu"; 1920)  // Use action button for icon on product panel
	FEATURE.isDelivered("plistClass"; 1920)  // Use plist class instead of plist method
	FEATURE.isDelivered("sortAction"; 1920)  // https:// Project.4d.com/issues/117660
	FEATURE.isDelivered("ConnectedDevices"; 1920)  // Add connected devices to the simulator tool
	
	// Mark:-R3
	FEATURE.isDelivered("predictiveEntryInActionParam"; 1930)  // #128898 Name of the action parameters and sorting criteria can be modified
	FEATURE.isDelivered("customActionFormatterWithCode"; 1930)  // #129036 custom input control for action parameter with ios code
	FEATURE.isDelivered("customActionFormatter"; 1930)  // #128195 custom input control for action parameter
	FEATURE.isDelivered("newActionFormatterChoiceList"; 1930)  // Menu to create action formatter choice list directly
	FEATURE.isDelivered("computedProperties"; 1930)  // #130206 [MOBILE] Use computed attributes
	
End if 

//mark:-R4
FEATURE.isUnstable("androidActions")  //[Mobile] Feature flag pour activer les actions dans le projet mobile
FEATURE.isUnstable("objectFieldManagement")  //[MOBILE] Object fields Management 
FEATURE.isUnstable("android1ToNRelations")  // [ANDROID] 1 to N relations
FEATURE.isUnstable("cancelableDatasetGeneration")  // [MOBILE] Data generation 
FEATURE.isUnstable("useTextRestResponse")  // [MOBILE] Data generation : for optis

//mark:-R5
FEATURE.isUnstable("listEditor")  // [MOBILE] Create and edit an input control from the project editor
FEATURE.isUnstable("xcDataModelClass")  // Use class to create core data model ie. xcDataModel (useful to refactor for alias)
FEATURE.isUnstable("iosBuildWithClass")  // Use cs.MobileProjectIOS class
FEATURE.isUnstable(131225)  // [MOBILE] Use aliases
FEATURE.isUnstable("modernStructure")

//mark:-🚧 WIP
FEATURE.isWIP(127558)  // [ANDROID] Data set
FEATURE.isWIP(131983)  // [MOBILE] Launch an action from the Tab bar

// FEATURE.isWIP("simuARMOnAppleProcessor") // Mac M1 build for simu using arm64
FEATURE.isWIP("duplicateTemplate")  // Allow to duplicate template in host database and show on disk https:// Project.4d.com/issues/98054
FEATURE.isWIP("newFormatterChoiceList")  // Menu to create formatter choice list directly , from data

FEATURE.isWIP("taskIndicator")  // UI for background tasks executing

FEATURE.isWIP("sourceClass")  // Work with Source class to test the data source

FEATURE.isWIP("buildWithCmd")  // allow to build using cmd only

//mark:- DEV

FEATURE.erm("gitCommit")  // commit to git generated project
FEATURE.erm("generateForDev")  // add framework sources and do not add compiled frameworks to workspace, deactivate code signing on framework
//FEATURE.isWip("devGallery")  // Allow to dev with local http gallery
FEATURE.erm("iOSAlias")

//mark:-⛔ PENDING
FEATURE.isPending(129953)  // [MOBILE] Handle Many-one-Many relations
FEATURE.isPending("compressionOfTemplates")  // Use the archive "/RESOURCES/template.zip" instead of "templates" folder in builded component
//FEATURE.vdl("testCompression")
FEATURE.isPending("formatMarketPlace")  // Manage format as archive
FEATURE.isPending("sharedActionWithDescription")  //[MOBILE] Add a description parameter to predefined share action
FEATURE.isPending("withWidgetActions")  // Enable widget actions
FEATURE.isPending(114338)  // Support Collection of field injected into detail template https://project.4d.com/issues/114338
FEATURE.isPending("droppingNext"; 114338)  // Allow to drop a multivalued field next to another existing dropped multivalued fields
FEATURE.isPending("iosSDKfromAWS")  // Download iOS SDK from AWS

FEATURE.isPending("coreDataAbstractEntity")  // Add in coreData model Record abstract entity

/* -------------------------------------
OVERRIDE WITH LOCAL PREFERENCES
________________________________________*/
If ($preferences.features#Null:C1517)
	
	For each ($o; $preferences.features)
		
		If (Value type:C1509($o.enabled)=Is boolean:K8:9)
			
			If (Value type:C1509($o.id)=Is text:K8:3)
				
				FEATURE[$o.id]:=Bool:C1537($o.enabled)
				
			Else 
				
				FEATURE["_"+String:C10($o.id)]:=Bool:C1537($o.enabled)
				
			End if 
			
		Else 
			
			For each ($key; $o.enabled) Until (Not:C34($enabled))
				
				Case of 
						
						//______________________________________________________
					: ($key="os")
						
						$enabled:=((Num:C11(Is macOS:C1572)+1)=Num:C11($o.enabled[$key]))
						
						//______________________________________________________
					: ($key="matrix")
						
						$enabled:=(Bool:C1537($o.enabled[$key]))
						
						//______________________________________________________
					: ($key="debug")
						
						If ($o.enabled[$key])
							
							// Only into a debug version
							$enabled:=Not:C34(Is compiled mode:C492)
							
						Else 
							
							// Not into a debug version
							$enabled:=Is compiled mode:C492
							
						End if 
						
						//______________________________________________________
					: ($key="bitness")
						
						Case of 
								
								//……………………………………………………………………………………………………
							: (Num:C11($o.enabled[$key])=64)
								
								$enabled:=(Version type:C495 ?? 64 bit version:K5:25)
								
								//……………………………………………………………………………………………………
							: (Num:C11($o.enabled[$key])=32)
								
								$enabled:=Not:C34(Version type:C495 ?? 64 bit version:K5:25)
								
								//……………………………………………………………………………………………………
							Else 
								
								ASSERT:C1129(False:C215; "Unknown value ("+$o.enabled[$key]+") for the key : \""+$key+"\"")
								$enabled:=False:C215
								
								//……………………………………………………………………………………………………
						End case 
						
						//______________________________________________________
					: ($key="version")
						
						$enabled:=(Num:C11(SHARED.ide.version)>=Num:C11($o.enabled[$key]))
						
						//______________________________________________________
					: ($key="type")
						
						$enabled:=(Application type:C494=Num:C11($o.enabled[$key]))
						
						//______________________________________________________
					Else 
						
						ASSERT:C1129(False:C215; "Unknown key: \""+$key+"\"")
						
						//______________________________________________________
				End case 
			End for each 
			
			FEATURE["_"+String:C10($o.id)]:=$enabled
			
		End if 
	End for each 
End if 

//mark:-→ ALIAS
FEATURE.makeAlias("actionsInTabBar"; 131983)
FEATURE.makeAlias("androidDataSet"; 127558)
FEATURE.makeAlias("many-one-many"; 129953)
FEATURE.makeAlias("alias"; 131225)
