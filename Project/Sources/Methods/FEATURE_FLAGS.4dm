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

feature:=New object:C1471(\
"with"; Formula:C1597(Bool:C1537(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))])); \
"unstable"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=(Num:C11(SHARED.ide.version)>=$stableVersion)); \
"delivered"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=(Num:C11(SHARED.ide.version)>=Num:C11($2))); \
"debug"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=(Structure file:C489=Structure file:C489(*))); \
"wip"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=(Structure file:C489=Structure file:C489(*))); \
"alias"; Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3; $1; "_"+String:C10($1))]:=Bool:C1537(This:C1470[Choose:C955(Value type:C1509($2)=Is text:K8:3; $2; "_"+String:C10($2))]))\
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
//featuresFlags._568:=True // use previous project build SDK as new SDK (ie. fast sdk move, bug exists)
feature.debug(8858)  // Activates a debug mode for UI
feature.alias("debug"; 8858)

// Use old behaviour
//featuresFlags._677:=True // Format fields when dumping data from rest (userless if iOS app could translate)

/* _____________
17R2
_____________*/
feature.delivered(89556; 1720)  // Reload embedded data from iOS application
feature.delivered(92293; 1720)  // Support user defined tables
feature.delivered(93674; 1720)  // Main menu
feature.delivered(8122017; 1720)  // Turn around bug close window
feature.delivered(96674; 1720)  // Archive app

/* _____________
17R3
_____________*/
feature.delivered(100157; 1730)  // Template creation
feature.delivered(100353; 1730)  // Template creation: inject any sources
feature.delivered(100191; 1730)  // Data Formatter

/* _____________
17R4
_____________*/
feature.delivered(98105; 1740)  // Multi-criteria Search
feature.delivered(100990; 1740)  // Custom Data Formatter
feature.delivered(100174; 1740)  // Restricted queries
feature.delivered(101725; 1740)  // Restricted queries: Use NSDataSet (beter way to store resources)
feature.delivered(103112; 1740)  // Restricted queries: Move dataSet into database in Mobile Projects
feature.delivered(102457; 1740)  // Data file access with /mobileapp key

/* _____________
17R5
_____________*/
feature.delivered(101637; 1750)  // Display n-1 relations
feature.delivered(103850; 1750)  // Reload data from iOS with N-1 relation (Generate core data model with real relation)
feature.delivered(103411; 1750)  // Incremental synchronization
feature.delivered(103505; 1750)  // Add, Update and Save Actions
feature.delivered("withNewFieldProperties"; 1750)  // Enable LR works on ds (redmine:98145 - Replace, for data structure access, EXPORT STRUCTURE by ds)
feature.delivered("withRecursiveLink"; 1750)  // Enable recursive link management
feature.delivered(98145; 1750)  // Replace, for data structure access, EXPORT STRUCTURE by ds

/* _____________
17R6
_____________*/
feature.delivered(105413; 1760)  // [MOBILE] Actions with parameters
feature.delivered("parameterListOfValues"; 1760)  // Manage field formatters as list of values for parameters
feature.delivered("allowPictureAsActionParameters"; 1760)  // #107932 - [Mobile] Allow to use picture as action parameters

/* _____________
18
_____________*/
feature.delivered(105431; 1800)  // Display 1-n relations
feature.delivered(110882; 1800)  // Dump data into core data SQLLite database
feature.delivered("newDataModel"; 1800)

/* _____________
18R2
_____________*/
feature.delivered("repairStructureMoreVisible"; 1820)
feature.delivered(113164; 1820)  // Enable/disable image dump

/* _____________
18R3
_____________*/
feature.delivered(112225; 1830)  // Select/install/use custom templates

/* _____________
18R4
_____________*/
feature.delivered(113016)  // Svg improvement in forms section
feature.delivered(107526)  // Push Notifications

/* _____________
18R5
_____________*/

feature.unstable(117601)  // Relation management optimisation
feature.unstable(117618)  // Deep Linking

/* _____________
WIP
_____________*/

// Enable widget actions
feature.wip("withWidgetActions")

// Manage colors according to user system parameters
feature.wip("accentColors")

// Manage format as archive
feature.wip("formatMarketPlace")

// Support Collection of field injected into detail template https://project.4d.com/issues/114338
feature.wip(114338)

// Allow to drop a multivalued field next to another existing dropped multivalued fields to have two fields next to each other
feature.alias("droppingNext"; 114338)

// Work with Source class to test tge data source
feature.wip("sourceClass")

/* -------------------------------------
OVERRIDE WITH LOCAL PREFERENCES
________________________________________*/

If ($preferences.features#Null:C1517)
	
	For each ($o; $preferences.features)
		
		If (Value type:C1509($o.enabled)=Is boolean:K8:9)
			
			feature["_"+String:C10($o.id)]:=Bool:C1537($o.enabled)
			
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
			
			feature["_"+String:C10($o.id)]:=$enabled
			
		End if 
	End for each 
End if 

/* _____________
ALIAS
_____________*/
feature.alias("newViewUI"; 113016)
feature.alias("resourcesBrowser"; 112225)
feature.alias("pushNotification"; 107526)
feature.alias("deepLinking"; 117618)
feature.alias("moreRelations"; 117601)