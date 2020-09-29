Class extends externalProcess

Class constructor
	
	Super:C1705()
	
Function androidSDKFolder
	var $0 : 4D:C1709.Folder
	
	If (Is macOS:C1572)
		
		$0:=This:C1470.homeFolder().folder("Library/Android/sdk")
		
	Else 
		
		$0:=This:C1470.homeFolder().folder("Library/Android/sdk")
		
	End if 
	
	// or find it
	