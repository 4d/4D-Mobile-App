Class extends androidProcess

/*
Android Debug Bridge version 1.0.41
Version 31.0.2-7242960
Installed as /Users/vdl/Library/Android/sdk/platform-tools/adb

global options:
 -a         listen on all network interfaces, not just localhost
 -d         use USB device (error if multiple devices connected)
 -e         use TCP/IP device (error if multiple TCP/IP devices available)
 -s SERIAL  use device with given serial (overrides $ANDROID_SERIAL)
 -t ID      use device with given transport id
 -H         name of adb server host [default=localhost]
 -P         port of adb server [default=5037]
 -L SOCKET  listen on given socket for adb server [default=tcp:localhost:5037]

general commands:
 devices [-l]             list connected devices (-l for long output)
 help                     show this help message
 version                  show version num

shell:
 shell [-e ESCAPE] [-n] [-Tt] [-x] [COMMAND...] run remote shell command (interactive shell if no command given)
     -e: choose escape character, or "none"; default '~'
     -n: don't read from stdin
     -T: disable pty allocation
     -t: allocate a pty if on a tty (-tt: force pty allocation)
     -x: disable remote exit codes and stdout/stderr separation
 emu COMMAND              run emulator console command

app installation (see also `adb shell cmd package help`):
 install [-lrtsdg] [--instant] PACKAGE push a single package to the device and install it
     -r: replace existing application
     -t: allow test packages
     -d: allow version code downgrade (debuggable packages only)
     -p: partial application install (install-multiple only)
     -g: grant all runtime permissions
     --abi ABI: override platform's default ABI
     --instant: cause the app to be installed as an ephemeral install app
     --no-streaming: always push APK to device and invoke Package Manager as separate steps
     --streaming: force streaming APK directly into Package Manager
     --fastdeploy: use fast deploy
     --no-fastdeploy: prevent use of fast deploy
     --force-agent: force update of deployment agent when using fast deploy
     --date-check-agent: update deployment agent when local version is newer and using fast deploy
     --version-check-agent: update deployment agent when local version has different version code and using fast deploy
     --local-agent: locate agent files from local source build (instead of SDK location)
     (See also `adb shell pm help` for more options.)
 uninstall [-k] PACKAGE
     remove this app package from the device
     '-k': keep the data and cache directories

debugging:
 bugreport [PATH]
     write bugreport to given PATH [default=bugreport.zip];
     if PATH is a directory, the bug report is saved in that directory.
     devices that don't support zipped bug reports output to stdout.
 jdwp                     list pids of processes hosting a JDWP transport
 logcat                   show device log (logcat --help for more)

security:
 disable-verity           disable dm-verity checking on userdebug builds
 enable-verity            re-enable dm-verity checking on userdebug builds
 keygen FILE
     generate adb public/private key; private key stored in FILE,

scripting:
 wait-for[-TRANSPORT]-STATE...
     wait for device to be in a given state
     STATE: device, recovery, rescue, sideload, bootloader, or disconnect
     TRANSPORT: usb, local, or any [default=any]
 get-state                print offline | bootloader | device
 get-serialno             print <serial-number>
 get-devpath              print <device-path>
 remount [-R]
      remount partitions read-write. if a reboot is required, -R will
      will automatically reboot the device.
 reboot [bootloader|recovery|sideload|sideload-auto-reboot]
     reboot the device; defaults to booting system image but
     supports bootloader and recovery too. sideload reboots
     into recovery and automatically starts sideload mode,
     sideload-auto-reboot is the same but reboots after sideloading.
 sideload OTAPACKAGE      sideload the given full OTA package
 root                     restart adbd with root permissions
 unroot                   restart adbd without root permissions
 usb                      restart adbd listening on USB
 tcpip PORT               restart adbd listening on TCP on PORT

internal debugging:
 start-server             ensure that there is a server running
 kill-server              kill the server if it is running
 reconnect                kick connection from host side to force reconnect
 reconnect device         kick connection from device side to force reconnect
 reconnect offline        reset offline/unauthorized devices to force reconnect

environment variables:
 $ADB_TRACE
     comma-separated list of debug info to log:
     all,adb,sockets,packets,rwx,usb,sync,sysdeps,transport,jdwp
 $ADB_VENDOR_KEYS         colon-separated list of keys (files or directories)
 $ANDROID_SERIAL          serial number to connect to (see -s)
 $ANDROID_LOG_TAGS        tags to be used by logcat (see logcat --help)
 $ADB_LOCAL_TRANSPORT_MAX_PORT max emulator scan port (default 5585, 16 emus)
 $ADB_MDNS_AUTO_CONNECT   comma-separated list of mdns services to allow auto-connect (default adb-tls-connect)                        
*/

/*
• https://developer.android.com/studio/command-line/adb
• https://gist.github.com/Pulimet/5013acf2cd5b28e55036c82c91bd56d8
• https://jonfhancock.com/bash-your-way-to-better-android-development-1169bc3e0424
*/

Class constructor
	
	Super:C1705()
	
	This:C1470.exe:=This:C1470.androidSDKFolder().file("platform-tools/adb"+Choose:C955(Is Windows:C1573; ".exe"; ""))
	This:C1470.cmd:=This:C1470.exe.path
	This:C1470.version:=This:C1470._version(This:C1470.cmd)
	
	This:C1470.timeOut:=30000  // 30 seconds
	This:C1470.bootTimeOut:=60000  // 1 minute
	This:C1470.packageListTimeOut:=240000  // 4 minutes
	This:C1470.appStartTimeOut:=60000
	
	This:C1470._adbStartRetried:=False:C215
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a collection of attached devices ID (connected and authorized devices or booted simulators)
	// if 'androidDeploymentTarget' is passed, keeps only devices where the version of Android is higher or equal
Function availableDevices($androidDeploymentTarget : Text)->$devices : Collection
	
	var $minVers; $serial; $t : Text
	var $keep : Boolean
	var $device : Object
	
	ARRAY LONGINT:C221($len; 0x0000)
	ARRAY LONGINT:C221($pos; 0x0000)
	
	If (Count parameters:C259>=1)
		
		$minVers:=$androidDeploymentTarget
		
	Else 
		
		$minVers:=String:C10(This:C1470.minAndroidVersion)
		
	End if 
	
	$devices:=New collection:C1472
	
	This:C1470._devices(True:C214)
	
	If (This:C1470.success)
		
		For each ($t; Split string:C1554(String:C10(This:C1470.outputStream); "\n"))
			
			If (Match regex:C1019("(?m-si)^((?:emulator-\\d*)|[A-Z0-9]*)\\tdevice$"; $t; 1; $pos; $len))
				
				$serial:=Substring:C12($t; $pos{1}; $len{1})
				$keep:=True:C214
				
				If (Count parameters:C259>=1)
					
					$keep:=(This:C1470.versionCompare($minVers; This:C1470.getDeviceAndroidVersion($serial))<=0)
					
				End if 
				
				If ($keep)
					
					$devices.push($serial)
					
				End if 
			End if 
		End for each 
	End if 
	
	/// wait-for-device
Function waiForDevice()->$pluggedDevice : Boolean
	
	Repeat 
		
		This:C1470.launch(This:C1470.cmd+" wait-for-device devices")
		
		If (Not:C34(This:C1470.success))
			
			IDLE:C311
			DELAY PROCESS:C323(Current process:C322; 120)
			
		End if 
	Until (This:C1470.success | Process aborted:C672)
	
	$pluggedDevice:=This:C1470.success
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// List of connected devices
	// if 'androidDeploymentTarget' is passed, keeps only devices where the version of Android is higher or equal
Function plugged($androidDeploymentTarget : Text)->$devices : Collection
	
	var $minVers; $serial; $t : Text
	var $keep : Boolean
	var $device : Object
	
	ARRAY LONGINT:C221($len; 0x0000)
	ARRAY LONGINT:C221($pos; 0x0000)
	
	If (Count parameters:C259>=1)
		
		$minVers:=$androidDeploymentTarget
		
	Else 
		
		$minVers:=String:C10(This:C1470.minAndroidVersion)
		
	End if 
	
	$devices:=New collection:C1472
	
	This:C1470._devices(True:C214)
	
	If (This:C1470.success)
		
		For each ($t; Split string:C1554(String:C10(This:C1470.outputStream); "\n"))
			
			If (Match regex:C1019("(?m-si)^(?!emulator)([^\\t]*)\\t(device|unauthorized)$"; $t; 1; $pos; $len))
				
				$serial:=Substring:C12($t; $pos{1}; $len{1})
				$keep:=True:C214
				
				If (Count parameters:C259>=1)
					
					$keep:=(This:C1470.versionCompare($minVers; This:C1470.getDeviceAndroidVersion($serial))<=0)
					
				End if 
				
				If ($keep)
					
					$device:=New object:C1471(\
						"udid"; $serial; \
						"name"; This:C1470.getDeviceName($serial); \
						"type"; "device"; \
						"unauthorized"; Substring:C12($t; $pos{2}; $len{2})="unauthorized")
					
					$device.status:=Choose:C955(Length:C16($device.name)=0; "offline"; "online")
					
					$devices.push($device)
					
				End if 
			End if 
		End for each 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Test if a device is connacted from its UUID
Function isDeviceConnected($serial)->$connected : Boolean
	
	This:C1470._devices(True:C214)
	
	If (This:C1470.success)
		
		$connected:=Match regex:C1019("(?m-si)"+$serial+"\\tdevice"; This:C1470.outputStream; 1)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns the Android version of a connected device or a booted emulator from its UUID
Function getDeviceAndroidVersion($serial : Text)->$version : Text
	
	This:C1470.launch(This:C1470.cmd+" -s "+$serial+" shell getprop ro.build.version.release")
	
	If (This:C1470.success)
		
		$version:=This:C1470.outputStream
		
	Else 
		
		This:C1470._pushError("Can't get Android version for the device "+$serial)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns the name of a connected device or a booted emulator from its UUID
Function getDeviceSDKVersion($serial : Text)->$version : Text
	
	This:C1470.launch(This:C1470.cmd+" -s "+$serial+" shell getprop ro.system.build.version.sdk")
	
	If (This:C1470.success)
		
		$version:=This:C1470.outputStream
		
	Else 
		
		This:C1470._pushError("Can't get Android version for the device "+$serial)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns the name of a connected device from its serial
Function getDeviceName($serial : Text)->$name : Text
	
	// https://stackoverflow.com/questions/54810404/is-there-a-way-to-get-the-device-name-using-adb-for-example-if-the-device-name
	This:C1470.launch(This:C1470.cmd+" -s "+$serial+" shell dumpsys bluetooth_manager | \\grep 'name:' | cut -c9-")
	
	If (This:C1470.success)
		
		$name:=This:C1470.outputStream
		
	Else 
		
		This:C1470._pushError("Can't get name for the device "+$serial)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a connected device or emulator properties from its serial
Function getDeviceProperties($serial : Text)->$properties : Object
	
	var $buffer; $key; $subkey; $t : Text
	var $o : Object
	var $c : Collection
	
	ARRAY LONGINT:C221($len; 0x0000)
	ARRAY LONGINT:C221($pos; 0x0000)
	
	This:C1470.launch(This:C1470.cmd+" -s "+$serial+" shell getprop")
	
	If (This:C1470.success)
		
		$properties:=New object:C1471
		
		For each ($t; Split string:C1554(String:C10(This:C1470.outputStream); "\n"))
			
			If (Match regex:C1019("(?m-si)^\\[([^\\]]*)\\]:"; $t; 1; $pos; $len))
				
				$o:=$properties
				$key:=Substring:C12($t; $pos{1}; $len{1})
				$c:=Split string:C1554($key; ".")
				
				For each ($subkey; $c)
					
					If ($o[$subkey]=Null:C1517)
						
						$o[$subkey]:=New object:C1471
						
					End if 
					
					$o:=$o[$subkey]
					
				End for each 
				
				Case of 
						
						//______________________________________________________
					: (Match regex:C1019("(?m-si)^\\[([^\\]]*)\\]:\\s*\\[\\]$"; $t; 1; $pos; $len))  // Empty
						
						$o[$key]:=Null:C1517
						$buffer:=""
						
						//______________________________________________________
					: (Match regex:C1019("(?m-si)^\\[([^\\]]*)\\]:\\s*\\[(\\d*)\\]$"; $t; 1; $pos; $len))  // Integer
						
						$o[$key]:=Num:C11(Substring:C12($t; $pos{2}; $len{2}))
						$buffer:=""
						
						//______________________________________________________
					: (Match regex:C1019("(?m-si)^\\[([^\\]]*)\\]:\\s*\\[(true|false)\\]$"; $t; 1; $pos; $len))  // Boolean
						
						$o[$key]:=(Substring:C12($t; $pos{2}; $len{2})="true")
						$buffer:=""
						
						//______________________________________________________
					: (Match regex:C1019("(?m-si)^\\[([^\\]]*)\\]:\\s*\\[([^\\]]*)\\]$"; $t; 1; $pos; $len))  // Text (could be a ollection)
						
						$c:=Split string:C1554(Substring:C12($t; $pos{2}; $len{2}); ",")
						$o[$key]:=Choose:C955($c.length>1; $c; Substring:C12($t; $pos{2}; $len{2}))
						$buffer:=""
						
						//______________________________________________________
					Else 
						
						$buffer:=$buffer+(","*Num:C11(Length:C16($buffer)>0))+$t
						
						//______________________________________________________
				End case 
				
			Else 
				
				$buffer:=$buffer+(","*Num:C11(Length:C16($buffer)>0))+$t
				
			End if 
			
			If ($buffer#"")
				
				Case of 
						
						//______________________________________________________
					: (Match regex:C1019("(?m-si)^\\[([^\\]]*)\\]:\\s*\\[\\]$"; $buffer; 1; $pos; $len))  // Empty
						
						$o[$key]:=Null:C1517
						$buffer:=""
						
						//______________________________________________________
					: (Match regex:C1019("(?m-si)^\\[([^\\]]*)\\]:\\s*\\[(\\d*)\\]$"; $buffer; 1; $pos; $len))  // Integer
						
						$o[$key]:=Num:C11(Substring:C12($buffer; $pos{2}; $len{2}))
						$buffer:=""
						
						//______________________________________________________
					: (Match regex:C1019("(?m-si)^\\[([^\\]]*)\\]:\\s*\\[(true|false)\\]$"; $buffer; 1; $pos; $len))  // Boolean
						
						$o[$key]:=(Substring:C12($buffer; $pos{2}; $len{2})="true")
						$buffer:=""
						
						//______________________________________________________
					: (Match regex:C1019("(?m-si)^\\[([^\\]]*)\\]:\\s*\\[([^\\]]*)\\]$"; $buffer; 1; $pos; $len))  // Text (could be a ollection)
						
						$c:=Split string:C1554(Substring:C12($buffer; $pos{2}; $len{2}); ",")
						$o[$key]:=Choose:C955($c.length>1; $c; Substring:C12($buffer; $pos{2}; $len{2}))
						$buffer:=""
						
						//______________________________________________________
					Else 
						
						// Go ahead
						
						//______________________________________________________
				End case 
			End if 
			
		End for each 
		
	Else 
		
		This:C1470._pushError("Failed to obtain device properties "+$serial)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Test if an app is installed on a connected device
Function isAppInstalled($package : Text; $serial : Text)->$installed : Boolean
	
	$installed:=This:C1470.userPackageList($serial).indexOf($package)>=0
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a collection of package names for a connected device
Function packageList($serial : Text)->$packages : Collection
	
	$packages:=This:C1470._packageList($serial)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a collection of 3rd party package names for a connected device
Function userPackageList($serial : Text)->$packages : Collection
	
	$packages:=This:C1470._packageList($serial; "-3")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Install an APK on a connected device giving its path or File object
Function installApp($apk; $serial : Text; $test : Boolean)->$this : cs:C1710.adb
	
	var $file : 4D:C1709.File
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($apk)=Is object:K8:27)  // File object
			
			$file:=$apk
			This:C1470.success:=$file.exists
			
			//______________________________________________________
		: (Value type:C1509($apk)=Is text:K8:3)  // Path (#TO_DO : Pathname)
			
			This:C1470.success:=Match regex:C1019(Choose:C955(Is Windows:C1573; "(?m-si)^[[:alpha:]]:/.*\\.apk$"; "(?m-si)^/.*\\.apk$"); $apk; 1)
			
			If (This:C1470.success)
				
				$file:=File:C1566($apk)
				This:C1470.success:=$file.exists
				
			End if 
			
			//______________________________________________________
		Else 
			
			TRACE:C157
			
			//______________________________________________________
	End case 
	
	If (This:C1470.success)
		
		// -r: Reinstall an existing app, keeping its data.
		// -t: Allow test APKs to be installed.
		
		If (Count parameters:C259>=1)
			
			// -s <serial number>
			This:C1470.launch(This:C1470.cmd+" -s "+$serial+" install -r "+Choose:C955($test; "-t "; "")+This:C1470.quoted($file.path))
			
		Else 
			
			// - directs command to the only connected USB device...
			This:C1470.launch(This:C1470.cmd+" -d install -r "+Choose:C955($test; "-t "; "")+This:C1470.quoted($file.path))
			
		End if 
		
	Else 
		
		If (Value type:C1509($apk)=Is object:K8:27)
			
			This:C1470._pushError("Not a valid file: "+$file.path)
			
		Else 
			
			This:C1470._pushError("Not a valid pathname: "+$apk)
			
		End if 
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Uninstalling app from a connected device
Function uninstallApp($bundleIdentifier : Text; $serial : Text)
	
	$bundleIdentifier:=Replace string:C233($bundleIdentifier; "-"; "_")
	
	If (This:C1470.userPackageList($serial).indexOf($bundleIdentifier)>=0)
		
		This:C1470.launch(This:C1470.cmd+" -s "+$serial+" uninstall "+Lowercase:C14($bundleIdentifier))
		
		If (Not:C34(This:C1470.success))
			
			This:C1470.launch(This:C1470.cmd+" -s "+$serial+" shell pm uninstall "+Lowercase:C14($bundleIdentifier))
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function launchApp($bundleIdentifier : Text)->$this : cs:C1710.adb
	
	//monkey -p com.package.name -v 1
	This:C1470.resultInErrorStream:=True:C214
	This:C1470.launch(This:C1470.cmd+" shell monkey -p "+Lowercase:C14($bundleIdentifier)+" -v 1")
	This:C1470.resultInErrorStream:=False:C215
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// list info on one package
Function getAppProperties($appName : Text; $serial : Text)
	
	This:C1470.launch(This:C1470.cmd+" -s "+$serial+" shell dump "+This:C1470._packageName($appName))
	
	//#TO_DO
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Wait until the emulator is started
Function waitForBoot($avdName : Text)->$result : Object
	
	$result:=New object:C1471(\
		"serial"; ""; \
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	// To check the timeout
	var $startTime : Integer
	$startTime:=Milliseconds:C459
	
	Repeat 
		
		$result:=This:C1470.getSerial($avdName)
		
		If (Length:C16($result.serial)=0)
			
			IDLE:C311
			DELAY PROCESS:C323(Current process:C322; 120)
			
			$result:=This:C1470.getSerial($avdName)
			
		End if 
		
	Until (($result.success=True:C214) & ($result.serial#""))\
		 | ($result.errors.length>0)\
		 | (Milliseconds:C459-$startTime>This:C1470.bootTimeOut)
	
	If (Length:C16($result.serial)=0)
		
		// Timeout
		$result.errors.push("(timeout reached when starting the emulator)")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Search a booted avd by name
Function getSerial($avdName : Text)->$result : Object
	
	var $devices; $device : Object
	
	$result:=New object:C1471(\
		"serial"; ""; \
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$devices:=This:C1470.listBootedDevices()
	
	If ($devices.success)
		
		$device:=This:C1470.findSerial($devices.bootedDevices; $avdName)
		
		If ($device.success)
			
			$result.serial:=$device.serial
			$result.success:=True:C214
			
		Else 
			
			$result.errors:=$device.errors  // This can be empty, therefore no error, just not found
			
		End if 
		
	Else 
		
		$result.errors:=$devices.errors
		
	End if 
	
Function listBootedDevices  // List booted devices
	var $0 : Object
	
	$0:=New object:C1471(\
		"bootedDevices"; New collection:C1472; \
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	This:C1470.launch(This:C1470.cmd+" devices")
	
	If (Position:C15("daemon started successfully"; String:C10(This:C1470.errorStream))>0)  // adb was not ready, restart command
		
		If (Not:C34(This:C1470._adbStartRetried))
			
			This:C1470._adbStartRetried:=True:C214
			
			$0:=This:C1470.listBootedDevices()
			
		Else 
			
			$0.success:=False:C215
			$0.errors.push(This:C1470.errorStream)
			
		End if 
		
	Else   // No issue with adb started status
		
		$0.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
		
		If ($0.success)
			
			$0.bootedDevices:=Split string:C1554(String:C10(This:C1470.outputStream); "\n")
			$0.bootedDevices.shift().pop()  // removing first and last entries
			
		Else 
			
			$0.errors.push("(failed to get adb device list)")
			
		End if 
	End if 
	
Function findSerial
	var $0 : Object
	var $1 : Collection  // booted devices list
	var $2 : Text  // searched avd name
	var $emulatorLine; $serial : Text
	var $Obj_avdName : Object
	
	$0:=New object:C1471(\
		"serial"; ""; \
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	For each ($emulatorLine; $1) Until ($0.serial#"")
		
		If (Position:C15("\tdevice"; $emulatorLine)>0)
			
			$serial:=Substring:C12($emulatorLine; 1; (Position:C15("\tdevice"; $emulatorLine)-1))
			
		Else 
			
			$serial:=Substring:C12($emulatorLine; 1; (Position:C15("\toffline"; $emulatorLine)-1))
			
		End if 
		
		// Get associated avd name
		$Obj_avdName:=This:C1470.getAvdName($serial)
		
		If ($Obj_avdName.success)
			
			If ($Obj_avdName.avdName=$2)
				
				// found avd name, means that tested serial is correct
				$0.serial:=$serial
				$0.success:=True:C214
				
				// Else : not the associated serial
			End if 
			
		Else 
			// getAvdName failed
			$0.errors.combine($Obj_avdName.errors)
		End if 
		
	End for each 
	
Function getAvdName  // #TO_DO : NOT THE SAME AS getDeviceName() -> MOVE TO avd
	var $0 : Object
	var $1 : Text  // serial
	var $avdName_Col : Collection
	
	$0:=New object:C1471(\
		"avdName"; ""; \
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	This:C1470.launch(This:C1470.cmd+" -s \""+$1+"\" emu avd name")
	
	If ((This:C1470.outputStream#Null:C1517) & (String:C10(This:C1470.outputStream)#""))
		
		$avdName_Col:=Split string:C1554(String:C10(This:C1470.outputStream); "\n")
		
		If ($avdName_Col.length>1)
			// First line is the avd name
			// Warning : on Windows, it is avd name + "\r"
			$0.avdName:=Replace string:C233($avdName_Col[0]; "\r"; "")
			$0.success:=True:C214
			
		Else 
			// can't find avd name
			$0.errors.push("(can't get avd name for this emulator)")
		End if 
		
		// Else : serial not found
	End if 
	
Function forceInstallApp
	var $0 : Object
	var $1 : Text  // emulator serial
	var $2 : Text  // package name (app name)
	var $3 : 4D:C1709.File  // apk
	var $Obj_uninstallAppIfInstalled; $Obj_install : Object
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$Obj_uninstallAppIfInstalled:=This:C1470.uninstallAppIfInstalled($1; $2)
	
	If ($Obj_uninstallAppIfInstalled.success)
		
		$Obj_install:=This:C1470.waitInstallApp($1; $3)
		
		If ($Obj_install.success)
			$0.success:=True:C214
		Else 
			$0.errors:=$Obj_install.errors
		End if 
		
	Else 
		$0.errors:=$Obj_uninstallAppIfInstalled.errors
	End if 
	
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function waitStartApp
	var $0 : Object
	var $1 : Text  // emulator serial
	var $2 : Text  // package name (app name)
	var $3 : Text  // activity name (com.qmobile.qmobileui.activity.loginactivity.LoginActivity)
	var $startTime; $stepTime : Integer
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	// Time elapsed
	$startTime:=Milliseconds:C459
	
	Repeat 
		
		IDLE:C311
		DELAY PROCESS:C323(Current process:C322; 120)
		
		This:C1470.launch(This:C1470.cmd+" -s \""+$1+"\" shell am start -n \""+$2+"/"+$3+"\"")
		
		$0.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
		
		$stepTime:=Milliseconds:C459-$startTime
		
	Until ($0.success=True:C214)\
		 | ($stepTime>This:C1470.appStartTimeOut)
	
	If ($stepTime>This:C1470.appStartTimeOut)  // Timeout
		
		$0.errors.push("(timeout reached when starting the app)")
		
		// Else : all ok 
	End if 
	
Function uninstallAppIfInstalled($package : Text; $serial : Text)
	
	
	var $0 : Object
	var $1 : Text  // emulator serial
	var $2 : Text  // package name (app name)
	var $Obj_isInstalled; $Obj_uninstall : Object
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$Obj_isInstalled:=This:C1470.isAppAlreadyInstalled($1; $2)
	
	If ($Obj_isInstalled.success)
		
		If ($Obj_isInstalled.isInstalled)
			
			$Obj_uninstall:=This:C1470.waitUninstallApp($1; $2)
			
			If ($Obj_uninstall.success)
				
				$0.success:=True:C214
				
			Else 
				
				$0.errors:=$Obj_uninstall.errors
				
			End if 
			
		Else 
			// App not installed
			$0.success:=True:C214
		End if 
		
	Else 
		$0.errors:=$Obj_isInstalled.errors
	End if 
	
Function waitForDevicePackageList
	var $0 : Object
	var $1 : Text  // emulator serial
	var $startTime; $stepTime : Integer
	
	$0:=New object:C1471(\
		"packageList"; ""; \
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	// Time elapsed
	$startTime:=Milliseconds:C459
	
	Repeat 
		
		IDLE:C311
		DELAY PROCESS:C323(Current process:C322; 120)
		
		This:C1470.launch(This:C1470.cmd+" -s \""+$1+"\" shell pm list packages")
		
		$0.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
		
		$0.packageList:=This:C1470.outputStream
		
		$stepTime:=Milliseconds:C459-$startTime
		
	Until (($0.success=True:C214) & ($0.packageList#""))\
		 | ($stepTime>This:C1470.packageListTimeOut)
	
	If ($stepTime>This:C1470.packageListTimeOut)  // Timeout
		
		$0.errors.push("(timeout reached when getting package list)")
		
		// Else : all ok 
	End if 
	
Function isAppAlreadyInstalled
	var $0 : Object
	var $1 : Text  // emulator serial
	var $2 : Text  // package name (app name)
	var $Obj_packageList : Object
	
	$0:=New object:C1471(\
		"isInstalled"; False:C215; \
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$Obj_packageList:=This:C1470.waitForDevicePackageList($1)
	
	If ($Obj_packageList.success)
		
		$0.success:=True:C214
		$0.isInstalled:=(Position:C15($2; $Obj_packageList.packageList)>0)
		
	Else 
		$0.errors:=$Obj_packageList.errors
	End if 
	
Function waitUninstallApp
	var $0 : Object
	var $1 : Text  // emulator serial
	var $2 : Text  // package name (app name)
	var $startTime; $stepTime : Integer
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	// Time elapsed
	$startTime:=Milliseconds:C459
	
	Repeat 
		
		This:C1470.launch(This:C1470.cmd+" -s \""+$1+"\" uninstall \""+$2+"\"")
		$0.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
		
		If (Not:C34($0.success))
			
			IDLE:C311
			DELAY PROCESS:C323(Current process:C322; 120)
			
			$stepTime:=Milliseconds:C459-$startTime
			
		End if 
		
	Until ($0.success=True:C214)\
		 | ($stepTime>This:C1470.timeOut)
	
	If ($stepTime>This:C1470.timeOut)  // Timeout
		
		$0.errors.push("(timeout reached when uninstalling the app)")
		
		// Else : all ok 
	End if 
	
Function waitInstallApp
	var $0 : Object
	var $1 : Text  // emulator serial
	var $2 : 4D:C1709.File  // apk
	var $startTime; $stepTime : Integer
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	// Time elapsed
	$startTime:=Milliseconds:C459
	
	Repeat 
		
		IDLE:C311
		DELAY PROCESS:C323(Current process:C322; 120)
		
		This:C1470.launch(This:C1470.cmd+" -s \""+$1+"\" install -t \""+$2.path+"\"")
		
		$0.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
		
		$stepTime:=Milliseconds:C459-$startTime
		
	Until ($0.success=True:C214)\
		 | ($stepTime>This:C1470.timeOut)
	
	If ($stepTime>This:C1470.timeOut)  // Timeout
		
		$0.errors.push("(timeout reached when installing the app)")
		
		// Else : all ok 
	End if 
	
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// [PRIVATE] Returns the current version of the tool
Function _version($cmd : Text)->$version : Text
	
	This:C1470.launch($cmd; "version")
	
	ARRAY LONGINT:C221($pos; 0x0000)
	ARRAY LONGINT:C221($len; 0x0000)
	
	If (Match regex:C1019("(?m-si)Version\\s(\\d+\\.\\d+\\.\\d+)"; This:C1470.outputStream; 1; $pos; $len))
		
		$version:=Substring:C12(This:C1470.outputStream; $pos{1}; $len{1})
		
	End if 
	
	//________________________________________________________________________________
	// [PRIVATE] - Package name formatting
Function _packageName($appName : Text)->$pakageName : Text
	
	$pakageName:=Lowercase:C14($appName)
	
	ARRAY LONGINT:C221($len; 0x0000)
	ARRAY LONGINT:C221($pos; 0x0000)
	
	While (Match regex:C1019("(?m-si)([^[:alnum:]\\._])"; $pakageName; 1; $pos; $len))
		
		$pakageName:=Replace string:C233($pakageName; Substring:C12($pakageName; $pos{1}; $len{1}); "_")
		
	End while 
	
	//________________________________________________________________________________
	// [PRIVATE] - Run shell pm list packages
Function _packageList($serial : Text; $options)->$packages : Collection
	
	var $t : Text
	var $spendTime : Integer
	
	This:C1470.countTimeInit()
	
	Repeat 
		
		If (Count parameters:C259=1)
			
			This:C1470.launch(This:C1470.cmd+" -s "+$serial+" shell pm list packages")
			
		Else 
			
			This:C1470.launch(This:C1470.cmd+" -s "+$serial+" shell pm list packages "+$options)
			
		End if 
		
		This:C1470.success:=This:C1470.success & (Length:C16(This:C1470.outputStream)>0)
		$spendTime:=This:C1470.delay(Not:C34(This:C1470.success))
		
	Until (This:C1470.success)\
		 | ($spendTime>This:C1470.packageListTimeOut)
	
	$packages:=New collection:C1472
	
	If (This:C1470.success)
		
		For each ($t; Split string:C1554(This:C1470.outputStream; "\n"))
			
			$packages.push(Replace string:C233($t; "package:"; ""))
			
		End for each 
		
	Else 
		
		This:C1470._pushError("(timeout reached when getting package list)")
		
	End if 
	
	// ____________________________________________________________________________________________________________
	// [PRIVATE] - Run 'adb devices'
Function _devices($firstAttempt : Boolean)
	
	If (Count parameters:C259>=1)
		
		This:C1470._adbStartRetried:=False:C215
		
	End if 
	
	This:C1470.launch(This:C1470.cmd+" devices")
	
	If (This:C1470.success)
		
		If (Position:C15("daemon started successfully"; String:C10(This:C1470.errorStream))>0)
			
			If (Not:C34(This:C1470._adbStartRetried))
				
				// Adb was not ready, restart command
				This:C1470._adbStartRetried:=True:C214
				This:C1470._devices()
				
			Else 
				
				This:C1470._pushError(This:C1470.errorStream)
				
			End if 
			
		Else 
			
/* The content of the outputStream looks like this:
			
    List of devices attached
    ZY22BJDD3L\tdevice
    emulator-5554\tdevice
			
*/
			
		End if 
		
	Else 
		
		This:C1470._pushError("(failed to get device list)")
		
	End if 
	
/*Function killServer
var $0 : Object
	
$0:=This.launch(This.cmd; "-kill-server")
*/
	
/*Function kill
var $0 : Object
var $1 : Text  // emu name
	
$0:=This.launch(This.cmd; New collection("-s"; $1; "emu"; "kill"))
*/
	