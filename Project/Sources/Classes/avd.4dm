Class extends androidProcess

Class constructor
	
	Super:C1705()
	
	This:C1470.cmd:=This:C1470.avdmanagerFile().path
	
	If (Is Windows:C1573)
		This:C1470.cmd:=This:C1470.cmd+".bat"
	Else 
		// Already set
	End if 
	
Function avdmanagerFile
	var $0 : 4D:C1709.File
	
	$0:=This:C1470.androidSDKFolder().folder("tools").folder("bin").file("avdmanager")
	
	
Function listAvds  // List emulators
	var $0 : Text  // returns complete output
	
	This:C1470.launch(This:C1470.cmd+" list avd")
	
	If (This:C1470.errorStream#Null:C1517)
		$0:=This:C1470.errorStream
	Else 
		$0:=String:C10(This:C1470.outputStream)
	End if 
	
	
Function isAvdExisting  // Check if avd already exists
	var $0 : Boolean
	var $1 : Text  // avd name
	var $listOutput; $separator : Text
	
	$listOutput:=This:C1470.listAvds()
	
	If (Is macOS:C1572)
		$separator:="/"
	Else 
		$separator:="\\"
	End if 
	
	// Searching for "/avd_name.avd" expression
	If (Position:C15($separator+$1+".avd\n"; String:C10($listOutput))=0)
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
	
	If (This:C1470.errorStream#Null:C1517)
		$0:=This:C1470.errorStream
	Else 
		$0:=String:C10(This:C1470.outputStream)
	End if 
	