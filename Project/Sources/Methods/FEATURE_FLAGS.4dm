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
"unstable"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=(Num:C11(SHARED.ide.version)>=$stableVersion)); \
"delivered"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=(Num:C11(SHARED.ide.version)>=Num:C11($2))); \
"debug"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=(Structure file:C489=Structure file:C489(*))); \
"wip"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=(Structure file:C489=Structure file:C489(*))); \
"vdl"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=(Current system user:C484="vdelachaux")); \
"alias"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=Bool:C1537(This:C1470[Choose:C955(Value type:C1509($2)=Is text:K8:3; $2; "_"+String:C10($2))])); \
"main"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=(Application version:C493(*)="A@"))\
)

/* _____________
TOOLS
_____________*/
//featuresFlags._97117:=True    // Deactivate image dump (test purpose)
//featuresFlags._917:=True // commit to git generated project
//featuresFlags._405:=True // add framework sources to workspace
//featuresFlags._406:=True // do not add compiled frameworks to workspace
//featuresFlags._475:=True // deactivate code signing on framework
//featuresFlags._234:=True // Add in coreData model Record abstract entity
FEATURE.debug(8858)  // Activates a debug mode for UI
FEATURE.alias("debug"; 8858)
//FEATURE.wip("devGallery")  // Allow to dev with local http gallery

// Use old behaviour
//featuresFlags._677:=True // Format fields when dumping data from rest (userless if iOS app could translate)

If (True:C214)  // Delivered
	
/* _____________
17R2 - REMOVED
_____________*/
	FEATURE.delivered(89556; 1720)  // Reload embedded data from iOS application
	FEATURE.delivered(92293; 1720)  // Support user defined tables
	FEATURE.delivered(93674; 1720)  // Main menu
	FEATURE.delivered(8122017; 1720)  // Turn around bug close window
	FEATURE.delivered(96674; 1720)  // Archive app
	
/* _____________
17R3 - REMOVED
_____________*/
	FEATURE.delivered(100157; 1730)  // Template creation
	FEATURE.delivered(100353; 1730)  // Template creation: inject any sources
	FEATURE.delivered(100191; 1730)  // Data Formatter
	
/* _____________
17R4 - REMOVED
_____________*/
	FEATURE.delivered(98105; 1740)  // Multi-criteria Search
	FEATURE.delivered(100990; 1740)  // Custom Data Formatter
	FEATURE.delivered(100174; 1740)  // Restricted queries
	FEATURE.delivered(101725; 1740)  // Restricted queries: Use NSDataSet (beter way to store resources)
	FEATURE.delivered(103112; 1740)  // Restricted queries: Move dataSet into database in Mobile Projects
	FEATURE.delivered(102457; 1740)  // Data file access with /mobileapp key
	
/* _____________
17R5 - REMOVED
_____________*/
	FEATURE.delivered(101637; 1750)  // Display n-1 relations
	FEATURE.delivered(103850; 1750)  // Reload data from iOS with N-1 relation (Generate core data model with real relation)
	FEATURE.delivered(103411; 1750)  // Incremental synchronization
	FEATURE.delivered(103505; 1750)  // Add, Update and Save Actions
	FEATURE.delivered("withNewFieldProperties"; 1750)  // Enable LR works on ds (redmine:98145 - Replace, for data structure access, EXPORT STRUCTURE by ds)
	FEATURE.delivered("withRecursiveLink"; 1750)  // Enable recursive link management
	FEATURE.delivered(98145; 1750)  // Replace, for data structure access, EXPORT STRUCTURE by ds
	
/* _____________
17R6 - REMOVED
_____________*/
	FEATURE.delivered(105413; 1760)  // [MOBILE] Actions with parameters
	FEATURE.delivered("parameterListOfValues"; 1760)  // Manage field formatters as list of values for parameters
	FEATURE.delivered("allowPictureAsActionParameters"; 1760)  // #107932 - [Mobile] Allow to use picture as action parameters
	
/* _____________
1800 - REMOVED
_____________*/
	FEATURE.delivered(105431; 1800)  // Display 1-n relations
	FEATURE.delivered(110882; 1800)  // Dump data into core data SQLLite database
	FEATURE.delivered("newDataModel"; 1800)
	
/* _____________
18R2 - REMOVED
_____________*/
	FEATURE.delivered("repairStructureMoreVisible"; 1820)
	FEATURE.delivered(113164; 1820)  // Enable/disable image dump
	
/* _____________
18R3 - REMOVED
_____________*/
	FEATURE.delivered(112225; 1830)  // Select/install/use custom templates
	
/* _____________
18R4 - REMOVED
_____________*/
	FEATURE.delivered(113016; 1840)  // Svg improvement in forms section
	FEATURE.delivered(107526; 1840)  // Push Notifications
	
/* _____________
18R5 - REMOVED
_____________*/
	FEATURE.delivered(117618; 1850)  // Deep Linking
	
/* _____________
18R6 - REMOVED
_____________*/
	FEATURE.delivered(117601; 1860)  // Relation management optimisation
	FEATURE.delivered("templateClass"; 1860)
	FEATURE.delivered("searchWithBarCode"; 1860)
	
/* _____________
1900 - REMOVED
_____________*/
	FEATURE.delivered("withSimulatorClass")  // Use simctl class intead of _o_simulator
	FEATURE.delivered("wizards")  // Use a wizard instead of standard dialogs to create or open a project
	
End if 

/* _____________
1920
_____________*/
FEATURE.unstable("android")  // Android support global flag
FEATURE.unstable("targetPannel")  // Use a separate pannel for the target OS
FEATURE.unstable("dominantColor")  // Feature #127813: BackgroundColor picker

FEATURE.unstable("iconActionMenu")  // Use action button for icon on product panel
FEATURE.unstable("plistClass")  // Use plist class instead of plist method

FEATURE.unstable("sortAction")  // https://project.4d.com/issues/117660
FEATURE.unstable("ConnectedDevices")  // Add connected devices to the simulator tool
FEATURE.unstable("freeActionName")  // follow https://project.4d.com/issues/117660 but to please LE

/* _____________
1930
_____________*/
FEATURE.unstable("predictiveEntryInActionParam")  // #128898 Name of the action parameters and sorting criteria can be modified

FEATURE.unstable("customActionFormatter")  // #128195 custom input control for action parameter
FEATURE.unstable("customActionFormatterWithCode")  // #129036 custom input control for action parameter with ios code
FEATURE.unstable("newActionFormatterChoiceList")  // Menu to create action formatter choice list directly

FEATURE.unstable("computedProperties")  // #130206 [MOBILE] Use computed attributes

/* _____________
1940
_____________*/
FEATURE.unstable("androidActions")  //[Mobile] Feature flag pour activer les actions dans le projet mobile


FEATURE.wip(129953)  //[MOBILE] Handle Many-one-Many relations

/* _____________
WIP
_____________*/
// FEATURE.wip("simuARMOnAppleProcessor") // Mac M1 build for simu using arm64
FEATURE.wip("duplicateTemplate")  // Allow to duplicate template in host database and show on disk https:// Project.4d.com/issues/98054
FEATURE.wip("taskIndicator")  // UI for background tasks executing

FEATURE.wip("compressionOfTemplates")  // Use the archive "/RESOURCES/template.zip" instead of "templates" folder in builded component
//FEATURE.vdl("testCompression")

FEATURE.wip("sharedActionWithDescription")  //[MOBILE] Add a description parameter to predefined share action
FEATURE.wip("withWidgetActions")  // Enable widget actions
FEATURE.wip("accentColors")  // Manage colors according to user system parameters
FEATURE.wip("formatMarketPlace")  // Manage format as archive
FEATURE.wip(114338)  // Support Collection of field injected into detail template https://project.4d.com/issues/114338
FEATURE.alias("droppingNext"; 114338)  // Allow to drop a multivalued field next to another existing dropped multivalued fields
FEATURE.wip("sourceClass")  // Work with Source class to test the data source
FEATURE.wip("iosSDKfromAWS")  // Download iOS SDK from AWS

FEATURE.wip("newFormatterChoiceList")  // Menu to create formatter choice list directly , from data
FEATURE.wip("listEditor")  // Allow to create custom Data Source Input Control
FEATURE.wip("objectFieldManagement")  //[MOBILE] Object fields Management 

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

/* _____________
ALIAS
_____________*/
FEATURE.alias("many-one-many"; 129953)