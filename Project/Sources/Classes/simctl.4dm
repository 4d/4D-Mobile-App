/*
usage: simctl [--set <path>] [--profiles <path>] <subcmd> ...
simctl help [subcmd]
cmd line utility to control the Simulator

For subcmds that require a <device> argument, you may specify a device UDID
or the special "booted" string which will cause simctl to pick a booted device.

If multiple devices are booted when the "booted" device is selected, simctl
will choose one of them.

Subcmds:
  create              Create a new device.
  clone               Clone an existing device.
  upgrade             Upgrade a device to a newer runtime.
• delete              Delete spcified devices, unavailable devices, or all devices.
  pair                Create a new watch and phone pair.
  unpair              Unpair a watch and phone pair.
  pair_activate       Set a given pair as active.
• erase               Erase a device's contents and settings.
• boot                Boot a device.
• shutdown            Shutdown a device.
  rename              Rename a device.
  getenv              Print an environment variable from a running device.
• openurl             Open a URL in a device.
  addmedia            Add photos, live photos, videos, or contacts to the library of a device.
• install             Install an app on a device.
• uninstall           Uninstall an app from a device.
  get_app_container   Print the path of the installed app's container
  install_app_data    Install an xcappdata package to a device, replacing the current contents of the container.
• launch              Launch an application by identifier on a device.
• terminate           Terminate an application by identifier on a device.
  spawn               Spawn a process by executing a given executable on a device.
• list                List available devices, device types, runtimes, or device pairs.
  icloud_sync         Trigger iCloud sync on a device.
  pbsync              Sync the pasteboard content from one pasteboard to another.
  pbcopy              Copy standard input onto the device pasteboard.
  pbpaste             Print the contents of the device's pasteboard to standard output.
  help                Prints the usage for a given subcmd.
  io                  Set up a device IO operation.
  diagnose            Collect diagnostic information and logs.
  logverbose          enable or disable verbose logging for a device
  status_bar          Set or clear status bar overrides
  ui                  Get or Set UI options
  push                Send a simulated push notification
  privacy             Grant, revoke, or reset privacy and permissions
  keychain            Manipulate a device's keychain
*/

Class extends lep

// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($iosDeploymentTarget : Text)
	
	Super:C1705()
	
	This:C1470.simulatorTimeout:=10000
	This:C1470.minimumVersion:=""
	This:C1470.simulatorApp:=cs:C1710.Xcode.new().tools.file("Applications/Simulator.app")
	
	If (Count parameters:C259>=1)
		
		This:C1470.minimumVersion:=$iosDeploymentTarget
		
	End if 
	
	This:C1470._cleanup()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns (and set if any) the default device
Function defaultDevice()->$device : Object
	
	var $o : Object
	var $file : 4D:C1709.File
	
	$file:=This:C1470.plist()
	
	If (Not:C34($file.exists))
		
		This:C1470.setDefaultDevice()
		
	End if 
	
	This:C1470.success:=($file.exists)
	
	If (This:C1470.success)
		
		$o:=plist(New object:C1471(\
			"action"; "object"; \
			"domain"; $file.path))
		
		This:C1470.success:=($o.success)
		
		If (This:C1470.success)
			
			$device:=This:C1470.device($o.value.CurrentDeviceUDID)
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Set a default device
Function setDefaultDevice($udid : Text)
	
	var $o : Object
	var $file : 4D:C1709.File
	
	$file:=This:C1470.plist()
	
	If (Count parameters:C259=0)
		
		$o:=This:C1470.availableDevices().query("name = :1"; "iPhone@").pop()
		This:C1470.success:=($o#Null:C1517)
		
		If (This:C1470.success)
			
			This:C1470.success:=plist(New object:C1471(\
				"action"; "write"; \
				"domain"; $file.path; \
				"key"; "CurrentDeviceUDID"; \
				"value"; $o.udid)).success
			
		End if 
		
	Else 
		
		This:C1470.success:=plist(New object:C1471(\
			"action"; "write"; \
			"domain"; $file.path; \
			"key"; "CurrentDeviceUDID"; \
			"value"; $udid)).success
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// List devices
Function devices()->$devices : Object
	
	This:C1470.launch("xcrun simctl"; "list devices --json devices")
	
	If (This:C1470.success)
		
		$devices:=JSON Parse:C1218(This:C1470.outputStream).devices
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// List Simulator Runtimes
Function runtimes()->$runtimes : Collection
	
	This:C1470.launch("xcrun simctl"; "list runtimes --json")
	
	If (This:C1470.success)
		
		$runtimes:=JSON Parse:C1218(This:C1470.outputStream).runtimes
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// List Device Types
Function deviceTypes($type : Text)->$devices : Collection
	
	This:C1470.launch("xcrun simctl"; "list devicetypes --json")
	
	If (This:C1470.success)
		
		$devices:=JSON Parse:C1218(This:C1470.outputStream).devicetypes
		
		If (Count parameters:C259>=1)
			
			$devices:=$devices.query("productFamily = :1"; $type)
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// List available devices (iPhone & iPad) according to the minimum iOS version target
Function availableDevices($iosDeploymentTarget : Text)->$availableDevices : Collection
	
	var $key; $minVers : Text
	var $devices : Object
	var $str : cs:C1710.str
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	If (Count parameters:C259>=1)
		
		$minVers:=$iosDeploymentTarget
		
	Else 
		
		$minVers:=String:C10(This:C1470.minimumVersion)
		
	End if 
	
	This:C1470.launch("xcrun simctl"; "list devices --json devices")
	
	If (This:C1470.success)
		
		$str:=cs:C1710.str.new()
		
		$availableDevices:=New collection:C1472
		
		$devices:=JSON Parse:C1218(This:C1470.outputStream).devices
		
		For each ($key; $devices) While ($availableDevices.length=0)
			
			If (Match regex:C1019("(?m-si)(?:\\.iOS-(\\d+)-(\\d+))+"; $key; 1; $pos; $len))
				
				If ($str.setText(Substring:C12($key; $pos{1}; $len{1})+"."+Substring:C12($key; $pos{2}; $len{2})).versionCompare($minVers)>=0)
					
					$availableDevices:=$devices[$key].query("isAvailable = :1 AND name IN :2"; True:C214; New collection:C1472("iPad@"; "iPhone@"))
					
				End if 
			End if 
		End for each 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// List of booted devices
Function bootedDevices()->$bootedDevices : Collection
	
	var $key : Text
	var $device; $devices : Object
	
	$devices:=This:C1470.devices()
	
	If (This:C1470.success)
		
		$bootedDevices:=New collection:C1472
		
		For each ($key; $devices)
			
			If (Value type:C1509($devices[$key])=Is collection:K8:32)
				
				For each ($device; $devices[$key])
					
					If (String:C10($device.state)="Booted")
						
						$bootedDevices.push($device)
						
					End if 
				End for each 
			End if 
		End for each 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Return a device from its UDID or name
Function device($simulator : Text)->$device : Object
	
	ASSERT:C1129(Count parameters:C259>=1)
	
	$device:=This:C1470.availableDevices().query("udid = :1"; $simulator).pop()
	
	If ($device=Null:C1517)
		
		$device:=This:C1470.availableDevices().query("name = :1"; $simulator).pop()
		
	End if 
	
	If ($device#Null:C1517)
		
		This:C1470.success:=True:C214
		
	Else 
		
		This:C1470.success:=False:C215
		This:C1470._pushError("device \""+$simulator+"\" not found")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the device (data) folder from its UDID or name
Function deviceFolder($simulator : Text; $data : Boolean)->$folder : 4D:C1709.Folder
	
	var $device : Object
	$device:=This:C1470.device($simulator)
	
	If ($device#Null:C1517)
		
		$folder:=This:C1470.home.folder("Library/Developer/CoreSimulator/Devices/").folder($device.udid)
		
		If (Count parameters:C259>=1)
			
			If ($data)
				
				$folder:=$folder.folder("data")
				
			End if 
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the device log file from its UDID or name
Function deviceLog($simulator : Text)->$log : 4D:C1709.File
	
	var $device : Object
	If (Count parameters:C259>=1)
		
		$device:=This:C1470.device($simulator)
		
	Else 
		
		// Use current default device
		$device:=This:C1470.defaultDevice()
		
	End if 
	
	If ($device#Null:C1517)
		
		$log:=This:C1470.home.folder("Library/Logs/"+$device.udid)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function showDeviceLog($simulator : Text)
	
	var $device : Object
	var $file : 4D:C1709.File
	
	If (Count parameters:C259>=1)
		
		$file:=This:C1470.deviceLog($simulator)
		
	Else 
		
		// Use current default device
		$file:=This:C1470.deviceLog()
		
	End if 
	
	If ($file.exists)
		
		SHOW ON DISK:C922($file.platformPath)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Boot a device from its UDID or name
Function bootDevice($simulator : Text; $wait : Boolean)
	
	// Ensure the Simulator App is launched
	This:C1470.openSimulatorApp()
	
	var $device : Object
	If (Count parameters:C259>=1)
		
		$device:=This:C1470.device($simulator)
		
	Else 
		
		$device:=This:C1470.defaultDevice()
		
	End if 
	
	If ($device#Null:C1517)
		
		If (This:C1470.isDeviceShutdown($device.udid))
			
			// Boot the device
			This:C1470.launch("xcrun simctl"; "boot "+$device.udid)
			
			If (Count parameters:C259>=2)
				
				If ($wait)
					
					var $start : Integer
					$start:=Milliseconds:C459
					
					Repeat 
						
						IDLE:C311
						
					Until (This:C1470.isDeviceBooted($device.udid)\
						 | ((Milliseconds:C459-$start)>This:C1470.simulatorTimeout))
				End if 
			End if 
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns true if a device is booted from its UDID or name
Function isDeviceBooted($simulator : Text)->$isBooted : Boolean
	
	var $device : Object
	If (Count parameters:C259>=1)
		
		$device:=This:C1470.device($simulator)
		
	Else 
		
		$device:=This:C1470.defaultDevice()
		
	End if 
	
	If ($device#Null:C1517)
		
		$isBooted:=(String:C10($device.state)="Booted")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Shutdown a device from its UDID or name
Function shutdownDevice($simulator : Text; $wait : Boolean)
	
	var $device : Object
	If (Count parameters:C259>=1)
		
		$device:=This:C1470.device($simulator)
		
	Else 
		
		$device:=This:C1470.defaultDevice()
		
	End if 
	
	If (This:C1470.isDeviceBooted($device.udid))
		
		If (Count parameters:C259>=2)
			
			This:C1470._kill($device.udid; $wait)
			
		Else 
			
			This:C1470._kill($device.udid)
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns true if a device is shutdown from its UDID or name
Function isDeviceShutdown($simulator : Text)->$shutdown : Boolean
	
	var $device : Object
	If (Count parameters:C259>=1)
		
		$device:=This:C1470.device($simulator)
		
	Else 
		
		$device:=This:C1470.defaultDevice()
		
	End if 
	
	$shutdown:=Not:C34(This:C1470.isDeviceBooted($device.udid))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Shutdowns all devices
Function shutdownAllDevices()
	
	This:C1470._kill()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Delete a device or all the devices if no parameter
Function deleteDevice($simulator : Text)
	
	If (Count parameters:C259=0)  // All
		
		This:C1470.launch("xcrun simctl"; "delete all")
		
	Else 
		
		var $device : Object
		$device:=This:C1470.device($simulator)
		
		If ($device#Null:C1517)
			
			This:C1470.launch("xcrun simctl"; "delete "+$device.udid)
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Erase a device's contents and settings from its UDID or name
Function eraseDevice($simulator : Text)
	
	var $device : Object
	If (Count parameters:C259>=1)
		
		$device:=This:C1470.device($simulator)
		
	Else 
		
		$device:=This:C1470.defaultDevice()
		
	End if 
	
	If ($device#Null:C1517)
		
		var $isBooted : Boolean
		$isBooted:=(String:C10($device.state)="Booted")
		
		If ($isBooted)
			
			This:C1470._kill($device.udid)
			
		End if 
		
		This:C1470.launch("xcrun simctl"; "erase "+$device.udid)
		
		If ($isBooted)  // relaunch
			
			This:C1470.bootDevice($device.udid)
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Open the Simulator App, if any
Function openSimulatorApp()
	
	If (Not:C34(This:C1470.isSimulatorAppLaunched()))
		
		This:C1470.launch("open -a "+This:C1470.singleQuoted(This:C1470.simulatorApp.path))
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Quit the Simulator App
Function quitSimulatorApp($killAll : Boolean)
	
	If (This:C1470.isSimulatorAppLaunched())
		
		If (Count parameters:C259>=1)
			
			If ($killAll)
				
				This:C1470.shutdownAllDevices()
				
			End if 
			
		End if 
		
		This:C1470.launch("osascript -e 'quit app \"Simulator\"'")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Bringing the Simulator App to the forefront
Function bringSimulatorAppToFront()
	
	This:C1470.launch("osascript -e 'tell app \"Simulator\" to activate'")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns true if the Simulator App is launched
Function isSimulatorAppLaunched()->$launched : Boolean
	
	This:C1470.launch("ps -e")
	$launched:=(Position:C15(This:C1470.simulatorApp.path; This:C1470.outputStream)>0)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Install an app by identifier on a device.
Function installApp($bundleID : Text; $simulator : Text)
	
	var $cmd : Text
	var $device : Object
	
	If (Asserted:C1132(Count parameters:C259>=1))
		
		$cmd:="xcrun simctl install"
		
		If (Count parameters:C259>=2)
			
			$device:=This:C1470.device($simulator)
			$cmd:=$cmd+" "+$device.udid+" "
			
		Else 
			
			// Use the current device
			$cmd:=$cmd+" booted "
			
		End if 
		
		This:C1470.launch($cmd+This:C1470.singleQuoted($bundleID))
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Uninstall an app by identifier from a device
Function uninstallApp($bundleID : Text; $simulator : Text)
	
	var $cmd : Text
	var $device : Object
	
	If (Asserted:C1132(Count parameters:C259>=1))
		
		$cmd:="xcrun simctl uninstall"
		
		If (Count parameters:C259>=2)
			
			$device:=This:C1470.device($simulator)
			$cmd:=$cmd+" "+$device.udid+" "
			
		Else 
			
			// Use the current device
			$cmd:=$cmd+" booted "
			
		End if 
		
		This:C1470.launch($cmd+This:C1470.singleQuoted($bundleID))
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Launch an application by identifier on a device
Function launchApp($bundleID : Text; $simulator : Text)
	
	var $cmd : Text
	var $device : Object
	
	If (Asserted:C1132(Count parameters:C259>=1))
		
		$cmd:="xcrun simctl launch"
		
		If (Count parameters:C259>=2)
			
			$device:=This:C1470.device($simulator)
			$cmd:=$cmd+" "+$device.udid+" "
			
		Else 
			
			// Use the current device
			$cmd:=$cmd+" booted "
			
		End if 
		
		This:C1470.launch($cmd+This:C1470.singleQuoted($bundleID))
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Terminate an application by identifier on a device
Function terminateApp($bundleID : Text; $simulator : Text)
	
	var $cmd : Text
	var $device : Object
	
	If (Asserted:C1132(Count parameters:C259>=1))
		
		$cmd:="xcrun simctl terminate"
		
		If (Count parameters:C259>=2)
			
			$device:=This:C1470.device($simulator)
			$cmd:=$cmd+" "+$device.udid+" "
			
		Else 
			
			// Use the current device
			$cmd:=$cmd+" booted "
			
		End if 
		
		This:C1470.launch($cmd+This:C1470.singleQuoted($bundleID))
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Open up the specified URL on a device
Function openUrl($url : Text; $simulator : Text)
	
	var $cmd : Text
	var $device : Object
	
	If (Asserted:C1132(Count parameters:C259>=1))
		
		$cmd:="xcrun simctl openurl"
		
		If (Count parameters:C259>=2)
			
			$device:=This:C1470.device($simulator)
			$cmd:=$cmd+" "+$device.udid+" "
			
		Else 
			
			// Use the current device
			$cmd:=$cmd+" booted "
			
		End if 
		
		This:C1470.launch($cmd+This:C1470.singleQuoted($url))
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Open up a custom scheme associated with an app
Function openUrlScheme($scheme : Text; $simulator : Text)
	
	
	If (Asserted:C1132(Count parameters:C259>=1))
		
		If (Count parameters:C259>=2)
			
			This:C1470.openUrl($scheme; $simulator)
			
		Else 
			
			This:C1470.openUrl($scheme)
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function plist()->$file : 4D:C1709.File
	
	$file:=This:C1470.home.file("Library/Preferences/com.apple.iphonesimulator.plist")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Shutdown all devices or a device from its UDID or name
Function _kill($simulator : Text; $wait : Boolean)
	
	If (Count parameters:C259=0)  // Kill all
		
		This:C1470.launch("xcrun simctl"; "shutdown all")
		
	Else 
		
		var $device : Object
		$device:=This:C1470.device($simulator)
		
		If ($device#Null:C1517)
			
			This:C1470.launch("xcrun simctl"; "shutdown "+$device.udid)
			
			If (Count parameters:C259>=1)
				
				If ($wait)
					
					var $start : Integer
					$start:=Milliseconds:C459
					
					Repeat 
						
						IDLE:C311
						
					Until (This:C1470.isDeviceBooted($device.udid)\
						 | ((Milliseconds:C459-$start)>This:C1470.simulatorTimeout))
				End if 
			End if 
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Delete accumulated a sizable cache of old devices
Function _cleanup()
	
	This:C1470.launch("xcrun simctl delete unavailable")