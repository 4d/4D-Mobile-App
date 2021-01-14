Class extends lep

Class constructor
	
	Super:C1705()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the Android SDK folder object
Function androidSDKFolder()->$folder : 4D:C1709.Folder
	
	If (Is macOS:C1572)
		
		$folder:=This:C1470.homeFolder().folder("Library/Android/sdk")
		
	Else 
		
		$folder:=This:C1470.homeFolder().folder("AppData/Local/Android/Sdk")
		
	End if 
	
	// or find it
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the User Home folder object
Function homeFolder()->$folder : 4D:C1709.Folder
	
	$folder:=Folder:C1567(fk desktop folder:K87:19).parent  // Maybe there is a better way for all OS