Class extends androidProcess

Class constructor
	
	Super:C1705()
	
	This:C1470.cmd:=This:C1470.avdmanagerFile().path
	
Function avdmanagerFile
	var $0 : 4D:C1709.File
	
	$0:=This:C1470.androidSDKFolder().folder("tools").folder("bin").file("avdmanager")
	
	
Function listAvds  // List emulators
	var $0 : Text  // returns complete output
	
	This:C1470.launch(This:C1470.cmd+" list avd")
	$0:=This:C1470.errorStream
	
	
Function isAvdExisting  // Check if avd already exists
	var $0 : Boolean
	var $1 : Text  // avd name
	var $listOutput : Text
	
	$listOutput:=This:C1470.listAvds()
	
	// Searching for "/avd_name.avd" expression
	If (Position:C15("/"+$1+".avd\n"; String:C10($listOutput))=0)
		// avd name not found, means it doesn't exists
		$0:=False:C215
	Else 
		// avd name found, means it already exists
		$0:=True:C214
	End if 
	
	
Function createAvd
	var $0 : Text  // output
	var $1 : Text  // avd name
	var $2 : Text  // Package path of the system image for this AVD (e.g. 'system-images;android-29;google_apis;x86'
	var $3 : Text  // The optional device definition to use. Can be a device index or id
	
	This:C1470.launch(This:C1470.cmd+" create avd -n \""+$1+"\" -k \""+$2+"\" --device \""+$3+"\"")
	
	$0:=This:C1470.errorStream
	