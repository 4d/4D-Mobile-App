//%attributes = {}
C_LONGINT:C283($1)
C_OBJECT:C1216($2)

C_BOOLEAN:C305($bEnabled)
C_LONGINT:C283($l_stable_version)
C_TEXT:C284($tKey)
C_OBJECT:C1216($o;$o_preferences)

If (False:C215)
	C_LONGINT:C283(FEATURE_FLAGS ;$1)
	C_OBJECT:C1216(FEATURE_FLAGS ;$2)
End if 

$l_stable_version:=$1
$o_preferences:=$2

feature:=New object:C1471(\
"with";Formula:C1597(Bool:C1537(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3;$1;"_"+String:C10($1))]));\
"unstable";Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3;$1;"_"+String:C10($1))]:=(Num:C11(SHARED.ide.version)>=$l_stable_version));\
"delivered";Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3;$1;"_"+String:C10($1))]:=(Num:C11(SHARED.ide.version)>=Num:C11($2)));\
"debug";Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3;$1;"_"+String:C10($1))]:=(Structure file:C489=Structure file:C489(*)));\
"wip";Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3;$1;"_"+String:C10($1))]:=(Structure file:C489=Structure file:C489(*)));\
"alias";Formula:C1597(This:C1470[Choose:C955(Value type:C1509($1)=Is text:K8:3;$1;"_"+String:C10($1))]:=Bool:C1537(This:C1470[Choose:C955(Value type:C1509($2)=Is text:K8:3;$2;"_"+String:C10($2))]))\
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
feature.alias("debug";8858)

  // Use old behaviour
  //featuresFlags._677:=True // Format fields when dumping data from rest (userless if iOS app could translate)

/* _____________
17R2
_____________*/
  //featuresFlags._89556:=True    // Reload embedded data from iOS application
  //featuresFlags._92293:=True    // Support user defined tables
  //featuresFlags._93674:=True    // Main menu
  //featuresFlags._8122017:=True  // Turn around bug close window
  //featuresFlags._96674:=True    // Archive app

/* _____________
17R3
_____________*/
  //featuresFlags._100157:=($Lon_version>=1730)  // Template creation
  //featuresFlags._100353:=featuresFlags._100157  // Template creation: inject any sources
  //featuresFlags._100191:=($Lon_version>=1730)  // Data Formatter

/* _____________
17R4
_____________*/
  //featuresFlags._98105:=($Lon_version>=1740)  // Multi-criteria Search
  //featuresFlags._100990:=($Lon_version>=1740)  // Custom Data Formatter
  //featuresFlags._100174:=($Lon_version>=1740)  // Restricted queries
  //featuresFlags._101725:=featuresFlags._100174  // Restricted queries: Use NSDataSet (beter way to store resources)
  //featuresFlags._103112:=featuresFlags._100174  // Restricted queries: Move dataSet into database in Mobile Projects
  //featuresFlags._102457:=($Lon_version>=1740)  // Data file access with /mobileapp key

/* _____________
17R5
_____________*/
  //featuresFlags._101637:=($Lon_version>=1750)  // Display n-1 relations
  //featuresFlags._103850:=featuresFlags._101637  // Reload data from iOS with N-1 relation (Generate core data model with real relation)
  //featuresFlags._103411:=($Lon_version>=1750)  // Incremental synchronization
  //featuresFlags._103505:=($Lon_version>=1750)  // Add, Update and Save Actions
  //featuresFlags.withNewFieldProperties:=($Lon_version>=1750)  // Enable LR works on ds (redmine:98145 - Replace, for data structure access, EXPORT STRUCTURE by ds)
  //featuresFlags.withRecursiveLink:=True  // Enable recursive link management
feature.delivered(98145;1750)  // Replace, for data structure access, EXPORT STRUCTURE by ds

/* _____________
17R6
_____________*/
  //featuresFlags._105413:=($Lon_version>=1760)  //  [MOBILE] Actions with parameters
  //featuresFlags.parameterListOfValues:=featuresFlags._105413  //     Manage field formatters as list of values for parameters
  //featuresFlags.allowPictureAsActionParameters:=featuresFlags._105413  // #107932 - [Mobile] Allow to use picture as action parameters

/* _____________
18
_____________*/
feature.delivered(105431;1800)  // Display 1-n relations
feature.delivered(110882;1800)  // Dump data into core data SQLLite database

feature.delivered("newDataModel";1800)

/* _____________
18R2
_____________*/
feature.delivered("repairStructureMoreVisible";1820)
feature.delivered(113164;1820)  // Enable/disable image dump

/* _____________
WIP
_____________*/
feature.wip("withWidgetActions")  // Enable widget actions
feature.wip("accentColors")  // Manage colors according to user system parameters

feature.wip(114338)  // Support Collection of field injected into detail template https://project.4d.com/issues/114338

feature.unstable(113016)  // Svg improvement in forms section
feature.unstable(112225)  // Select / install / use custom templates

feature.wip("formatMarketPlace")  // Manage format as archive

/* -------------------------------------
OVERRIDE WITH LOCAL PREFERENCES
________________________________________*/
If ($o_preferences#Null:C1517)
	
	For each ($o;$o_preferences)
		
		If (Value type:C1509($o.enabled)=Is boolean:K8:9)
			
			feature["_"+String:C10($o.id)]:=Bool:C1537($o.enabled)
			
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
						
						$bEnabled:=(Num:C11(SHARED.ide.version)>=Num:C11($o.enabled[$tKey]))
						
						  //______________________________________________________
					: ($tKey="type")
						
						$bEnabled:=(Application type:C494=Num:C11($o.enabled[$tKey]))
						
						  //______________________________________________________
					Else 
						
						ASSERT:C1129(False:C215;"Unknown key: \""+$tKey+"\"")
						
						  //______________________________________________________
				End case 
			End for each 
			
			feature["_"+String:C10($o.id)]:=$bEnabled
			
		End if 
	End for each 
End if 

/* _____________
ALIAS
_____________*/
feature.alias("oneToManyRelations";105431)
feature.alias("setImageDump";113164)
feature.alias("newViewUI";113016)
feature.alias("resourcesBrowser";112225)