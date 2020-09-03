Class extends androidPlatformTools

Class constructor
	
	Super:C1705()
	
	This:C1470.cmd:=This:C1470.adbFile().path  // Fill default adb command path
	
Function adbFile
	var $0 : 4D:C1709.File
	
	$0:=This:C1470.androidPlatformToolsFolder().file("adb")
	
Function killServer
	var $0 : Object
	
	$0:=This:C1470.launch(This:C1470.cmd; "kill-server")