Class extends androidProcess

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705()
	
	This:C1470.cmd:=This:C1470.avdmanagerFile().path
	
	If (Is Windows:C1573)
		
		This:C1470.cmd:=This:C1470.cmd+".bat"
		
	Else 
		
		// Already set
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a collection of available device simulators
Function devices()->$devices : Collection
	
	var $start : Integer
	var $o : Object
	
	$devices:=New collection:C1472
	
	This:C1470.launch(This:C1470.cmd+" list device")
	
	If (This:C1470.success)
		
		$start:=1
		
		ARRAY LONGINT:C221($pos; 0x0000; 0x0000)
		ARRAY LONGINT:C221($len; 0x0000; 0x0000)
		
		While (Match regex:C1019("(?m-si)id:\\s(\\d+)\\sor\\s\"([^\"]*)\"\\s*Name:\\s(\\V*)\\s*OEM\\s*:\\s(\\V*)"; This:C1470.outputStream; $start; $pos; $len))
			
			$o:=New object:C1471(\
				"uid"; Substring:C12(This:C1470.outputStream; $pos{1}; $len{1}); \
				"id"; Substring:C12(This:C1470.outputStream; $pos{2}; $len{2}); \
				"name"; Substring:C12(This:C1470.outputStream; $pos{3}; $len{3}); \
				"OEM"; Substring:C12(This:C1470.outputStream; $pos{4}; $len{4}))
			
			$start:=$pos{4}+$len{4}  //+1
			
			If (Position:C15("tv_"; $o.id)=0) & (Position:C15("wear_"; $o.id)=0)
				
				$devices.push($o)
				
			End if 
		End while 
		
	Else 
		
		// A "If" statement should never omit "Else" 
		
	End if 
	
	
	
	
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a collection of available device simulators
Function _o_devices()->$devices : Collection
	
	var $start : Integer
	
	$devices:=New collection:C1472
	
	This:C1470.ignoreErrorInOutputStream:=True:C214
	This:C1470.launch(This:C1470.cmd+" list avd")
	
	If (This:C1470.success)
		
		$start:=1
		
		ARRAY LONGINT:C221($pos; 0x0000; 0x0000)
		ARRAY LONGINT:C221($len; 0x0000; 0x0000)
		
		While (Match regex:C1019("(?m-si)Name:\\s(\\V*)\\s*Path:\\s(\\V*)"; This:C1470.outputStream; $start; $pos; $len))
			
			$devices.push(New object:C1471(\
				"name"; Substring:C12(This:C1470.outputStream; $pos{1}; $len{1}); \
				"path"; Substring:C12(This:C1470.outputStream; $pos{2}; $len{2})))
			
			$start:=$pos{2}+$len{2}+1
			
		End while 
		
	Else 
		
		// A "If" statement should never omit "Else" 
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Tests if a given device name or path is available
Function isDeviceAvailable($device : Text)->$available : Boolean
	
	$available:=This:C1470.devices().query("(name = :1) or (path = :1)"; $device).pop()#Null:C1517
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function avdmanagerFile()->$file : 4D:C1709.File
	
	$file:=This:C1470.androidSDKFolder().file("tools/bin/avdmanager")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function listAvds  // List emulators
	var $0 : Text  // returns complete output
	
	This:C1470.launch(This:C1470.cmd+" list avd")
	
	If (This:C1470.errorStream#Null:C1517)
		$0:=This:C1470.errorStream
	Else 
		$0:=String:C10(This:C1470.outputStream)
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
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
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
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
	