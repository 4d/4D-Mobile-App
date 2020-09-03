Class extends externalProcess

Function androidSDKFolder
	var $0 : 4D:C1709.Folder
	$0:=This:C1470.homeFolder().folder("Library/Android/sdk")  // if window or other make If is window
	// or find it
	