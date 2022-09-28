Class constructor($version : Integer; $file : 4D:C1709.File)
	
	var $build : Integer
	
	Super:C1705()
	
	This:C1470.ideVersion:=Num:C11(Application version:C493($build))
	This:C1470.ideBuild:=String:C10($build)
	This:C1470.currentUser:=Current system user:C484
	
	This:C1470.internalVersion:=$version
	This:C1470._features:=New object:C1471
	
	// Get the config file, if any
	This:C1470.localFile:=$file
	
	//MARK:[CHECK STATE]
	//====================================================================
	/// Returns True if the feature is activated
Function with($feature) : Boolean
	
	return (Bool:C1537(This:C1470._features[This:C1470._feature($feature)]))
	
	//====================================================================
	/// Returns True if the feature is activated
Function enabled($feature) : Boolean
	
	return (Bool:C1537(This:C1470._features[This:C1470._feature($feature)]))
	
	//====================================================================
	/// Returns True if the feature is NOT activated
Function disabled($feature) : Boolean
	
	return (Not:C34(Bool:C1537(This:C1470._features[This:C1470._feature($feature)])))
	
	//MARK:-[STORING]
	//====================================================================
	/// Storing a feature as unstable
Function unstable($feature)
	
	This:C1470._features[This:C1470._feature($feature)]:=(This:C1470.internalVersion>=This:C1470.ideVersion)
	
	//====================================================================
	/// Storing a feature as delivered
Function delivered($feature; $version : Integer)
	
	This:C1470._features[This:C1470._feature($feature)]:=(This:C1470.internalVersion>=$version)
	
	//====================================================================
	/// Storing a feature as debug (only available in dev mode)
Function debug($feature)
	
	This:C1470._features[This:C1470._feature($feature)]:=(Structure file:C489=Structure file:C489(*))
	
	//====================================================================
	/// Storing a feature as only available in main branch
Function main($feature)
	
	This:C1470._features[This:C1470._feature($feature)]:=(Application version:C493(*)[[1]]="A")
	
	//====================================================================
	/// Storing a feature as work in progress (only available in dev mode)
Function wip($feature)
	
	This:C1470._features[This:C1470._feature($feature)]:=(Structure file:C489=Structure file:C489(*))
	
	//====================================================================
	/// Storing an alias name for a feature
Function alias($alias; $original)
	
	This:C1470._features[This:C1470._feature($alias)]:=This:C1470._features[This:C1470._feature(String:C10($original))]
	
	//====================================================================
	/// Storing a feature as pending (not available)
Function pending($feature)
	
	This:C1470._features[This:C1470._feature($feature)]:=False:C215
	
	//====================================================================
	/// Storing a feature as only available for a particular user
Function dev($feature; $user)
	
	Case of 
			//______________________________________________________
		: (Value type:C1509($user)=Is collection:K8:32)
			
			This:C1470._features[This:C1470._feature($feature)]:=($user.indexOf(This:C1470.currentUser)#-1)
			
			//______________________________________________________
		: (Value type:C1509($user)=Is text:K8:3)
			
			This:C1470._features[This:C1470._feature($feature)]:=($user=This:C1470.currentUser)
			
			//______________________________________________________
		Else 
			
			This:C1470._features[This:C1470._feature($feature)]:=False:C215
			
			//______________________________________________________
	End case 
	
	//MARK:-[TOOLS]
	//====================================================================
	/// Override features activation with local preferences, if any
Function loadLocal()
	
	var $key : Text
	var $enabled : Boolean
	var $o : Object
	
	If ((This:C1470.localFile#Null:C1517) && This:C1470.localFile.exists)
		
		This:C1470.local:=JSON Parse:C1218(This:C1470.localFile.getText()).features
		
		If (This:C1470.local#Null:C1517)
			
			For each ($o; This:C1470.local)
				
				If (Value type:C1509($o.enabled)=Is boolean:K8:9)
					
					This:C1470._features[This:C1470._feature($o.id)]:=Bool:C1537($o.enabled)
					
				Else 
					
					For each ($key; $o.enabled) Until (Not:C34($enabled))
						
						Case of 
								
								//______________________________________________________
							: ($key="os")
								
								$enabled:=((Num:C11(Is macOS:C1572)+1)=Num:C11($o.enabled[$key]))
								
								//______________________________________________________
							: ($key="matrix")
								
								$enabled:=(Structure file:C489=Structure file:C489(*))
								
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
								
								$enabled:=(This:C1470.ideVersion>=Num:C11($o.enabled[$key]))
								
								//______________________________________________________
							: ($key="type")
								
								$enabled:=(Application type:C494=Num:C11($o.enabled[$key]))
								
								//______________________________________________________
							Else 
								
								ASSERT:C1129(False:C215; "Unknown key: \""+$key+"\"")
								
								//______________________________________________________
						End case 
					End for each 
					
					This:C1470._features[This:C1470._feature($o.id)]:=$enabled
					
				End if 
			End for each 
		End if 
	End if 
	
	//====================================================================
/** 
Logs the status (enabled/disabled) of all declared features
using the host database logging system passed as a formula.
*/
Function log($logger : 4D:C1709.Function)
	
	var $key; $t : Text
	
	$logger.call(Null:C1517; "Features:\n")
	
	For each ($key; This:C1470._features)
		
		If (Value type:C1509(This:C1470._features[$key])=Is boolean:K8:9)
			
			$t:=(This:C1470._features[$key] ? " ✅ " : " ❌ ")+Replace string:C233($key; "_"; "")
			$logger.call(Null:C1517; $t)
			
		End if 
	End for each 
	
	// MARK:-[PRIVATE]
	//====================================================================
Function _feature($feature) : Text
	
	return (Value type:C1509($feature)=Is text:K8:3 ? $feature : "_"+String:C10($feature))