/*
Usage: xcrun [options] <tool name> ... arguments ...

Find and execute the named command line tool from the active developer
directory.

The active developer directory can be set using `xcode-select`, or via the
DEVELOPER_DIR environment variable. See the xcrun and xcode-select manual
pages for more information.

Options:
  -h, --help                  show this help message and exit
  --version                   show the xcrun version
  -v, --verbose               show verbose logging output
  --sdk <sdk name>            find the tool for the given SDK name
  --toolchain <name>          find the tool for the given toolchain
  -l, --log                   show commands to be executed (with --run)
  -f, --find                  only find and print the tool path
  -r, --run                   find and execute the tool (the default behavior)
  -n, --no-cache              do not use the lookup cache
  -k, --kill-cache            invalidate all existing cache entries
  --show-sdk-path             show selected SDK install path
  --show-sdk-version          show selected SDK version
  --show-sdk-build-version    show selected SDK build version
  --show-sdk-platform-path    show selected SDK platform path
  --show-sdk-platform-version show selected SDK platform version

=== === === === === === === === === === === === === === === === === === 

usage: simctl [--set <path>] [--profiles <path>] <subcommand> ...
simctl help [subcommand]
Command line utility to control the Simulator

For subcommands that require a <device> argument, you may specify a device UDID
or the special "booted" string which will cause simctl to pick a booted device.

If multiple devices are booted when the "booted" device is selected, simctl
will choose one of them.

Subcommands:
create              Create a new device.
clone               Clone an existing device.
upgrade             Upgrade a device to a newer runtime.
delete              Delete spcified devices, unavailable devices, or all devices.
pair                Create a new watch and phone pair.
unpair              Unpair a watch and phone pair.
pair_activate       Set a given pair as active.
erase               Erase a device's contents and settings.
boot                Boot a device.
shutdown            Shutdown a device.
rename              Rename a device.
getenv              Print an environment variable from a running device.
openurl             Open a URL in a device.
addmedia            Add photos, live photos, videos, or contacts to the library of a device.
install             Install an app on a device.
uninstall           Uninstall an app from a device.
get_app_container   Print the path of the installed app's container
install_app_data    Install an xcappdata package to a device, replacing the current contents of the container.
launch              Launch an application by identifier on a device.
terminate           Terminate an application by identifier on a device.
spawn               Spawn a process by executing a given executable on a device.
list                List available devices, device types, runtimes, or device pairs.
icloud_sync         Trigger iCloud sync on a device.
pbsync              Sync the pasteboard content from one pasteboard to another.
pbcopy              Copy standard input onto the device pasteboard.
pbpaste             Print the contents of the device's pasteboard to standard output.
help                Prints the usage for a given subcommand.
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
	
	This:C1470.cmd:="xcrun simctl"
	
	If (Count parameters:C259>=1)
		
		This:C1470.minimumVersion:=$iosDeploymentTarget
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function availableDevices($iosDeploymentTarget : Text)->$availableDevices : Collection
	
	var $key; $minVers : Text
	var $device; $devices; $runtime : Object
	var $runtimes : Collection
	var $str : cs:C1710.str
	
	If (Count parameters:C259>=1)
		
		$minVers:=$iosDeploymentTarget
		
	Else 
		
		If (Asserted:C1132(This:C1470.minimumVersion#Null:C1517))
			
			$minVers:=This:C1470.minimumVersion
			
		End if 
	End if 
	
	$devices:=This:C1470.devices()
	
	If (This:C1470.success)
		
		$runtimes:=This:C1470.runtimes()
		
		If (This:C1470.success)
			
			$str:=cs:C1710.str.new()
			
			$availableDevices:=New collection:C1472
			
			For each ($key; $devices)
				
				If (Value type:C1509($devices[$key])=Is collection:K8:32)
					
					For each ($device; $devices[$key])
						
						If ((String:C10($device.availability)="(available)")\
							 | (Bool:C1537($device.isAvailable)))\
							 & ((String:C10($device.name)="iPhone@") | (String:C10($device.name)="iPad@"))
							
							For each ($runtime; $runtimes)
								
								If (($runtime.name=$key)\
									 | ($runtime.identifier=$key))
									
									If ($str.setText($runtime.version).versionCompare($minVers)>=0)  // Equal or higher
										
										$device.runtime:=$runtime
										$availableDevices.push($device)
										
									End if 
								End if 
							End for each 
						End if 
					End for each 
				End if 
			End for each 
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// List available devices
Function devices()->$devices : Object
	
	// Usage: simctl list [-j | --json] [-v] [devices|devicetypes|runtimes|pairs]
	This:C1470.launch(This:C1470.cmd; "list devices --json devices")
	
	If (This:C1470.success)
		
		$devices:=JSON Parse:C1218(This:C1470.outputStream).devices
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// List Simulator Runtimes
Function runtimes()->$runtimes : Collection
	
	This:C1470.launch(This:C1470.cmd; "list runtimes --json")
	
	If (This:C1470.success)
		
		$runtimes:=JSON Parse:C1218(This:C1470.outputStream).runtimes
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// List Device Types
Function deviceTypes($type : Text)->$devices : Collection
	
	This:C1470.launch(This:C1470.cmd; "list devicetypes --json")
	
	If (This:C1470.success)
		
		$devices:=JSON Parse:C1218(This:C1470.outputStream).devicetypes
		
		If (Count parameters:C259>=1)
			
			$devices:=$devices.query("productFamily = :1"; $type)
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Return a device definition from its ID
Function device($udid : Text)->$device : Object
	
	ASSERT:C1129(Count parameters:C259>=1)
	
	$device:=This:C1470.availableDevices().query("udid = :1"; $udid).pop()
	
	If ($device#Null:C1517)
		
		This:C1470.success:=True:C214
		
	Else 
		
		This:C1470.success:=False:C215
		This:C1470._pushError("device \""+$udid+"\" not available")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// 
Function open($udid : Text)
	
	// Boot the device
	This:C1470.launch(This:C1470.cmd; "boot "+$udid)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns true if the simulator App is launched
Function isLaunched()->$launched : Boolean
	
	This:C1470.launch("ps -e")
	$launched:=(Position:C15(cs:C1710.Xcode.new().tools.file("Applications/Simulator.app").path; This:C1470.outputStream)>0)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the state booted of a device from its ID
Function isBooted($udid : Text)->$booted : Boolean
	
	ASSERT:C1129(Count parameters:C259>=1)
	
	var $device : Object
	$device:=This:C1470.device($udid)
	
	If ($device#Null:C1517)
		
		$booted:=(String:C10($device.state)="Booted")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Kills a simulator from its ID
Function kill($udid : Text)
	
	If (Count parameters:C259=0)  // Kill all
		
		This:C1470.launch(This:C1470.cmd; "shutdown all")
		
	Else 
		
		This:C1470.launch(This:C1470.cmd; "shutdown "+$udid)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Delete simulator(s)
Function delete($udid : Text)
	
	If (Count parameters:C259=0)  // All
		
		This:C1470.launch(This:C1470.cmd; "delete all")
		
	Else 
		
		This:C1470.launch(This:C1470.cmd; "delete "+$udid)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Erase a simulator from its ID
Function erase($udid : Text)
	
	ASSERT:C1129(Count parameters:C259>=1)
	This:C1470.launch(This:C1470.cmd; "delete "+$udid)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Return the default simulator UDID
Function default()->$udid : Text
	
	var $o : Object
	var $file : 4D:C1709.File
	
	$file:=This:C1470.plist()
	
	If (Not:C34($file.exists))
		
		This:C1470.fixDefault()
		
	End if 
	
	This:C1470.success:=($file.exists)
	
	If (This:C1470.success)
		
		$o:=plist(New object:C1471(\
			"action"; "object"; \
			"domain"; $file.path))
		
		This:C1470.success:=($o.success)
		
		If (This:C1470.success)
			
			$udid:=$o.value.CurrentDeviceUDID
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Fix a default simulator
Function fixDefault($udid : Text)
	
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
Function bringToFront()
	
	This:C1470.launch("osascript -e 'tell app \"Simulator\" to activate'")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function deviceFolder($udid : Text; $data : Boolean)->$folder : 4D:C1709.Folder
	
	$folder:=This:C1470.home.folder("Library/Developer/CoreSimulator/Devices/").folder($udid)
	
	If (Count parameters:C259>=1)
		
		If ($data)
			
			$folder:=$folder.folder("data")
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function plist()->$file : 4D:C1709.File
	
	$file:=This:C1470.home.file("Library/Preferences/com.apple.iphonesimulator.plist")
	
	
	