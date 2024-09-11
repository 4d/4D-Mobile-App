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
	
	var $studio : cs:C1710.studio
	$studio:=cs:C1710.studio.new()
	
	If ($studio.success)
		
		If (Bool:C1537($studio.javaHome.exists))
			
			This:C1470.setEnvironnementVariable("JAVA_HOME"; $studio.javaHome.path)
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a collection of attached devices ID (connected and authorized devices or booted simulators)
	// if 'androidDeploymentTarget' is passed, keeps only devices where the version of Android is higher or equal
Function availableDevices($androidDeploymentTarget : Text)->$devices : Collection
	
	var $minVers; $emulatorSerial; $t : Text
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
				
				$emulatorSerial:=Substring:C12($t; $pos{1}; $len{1})
				$keep:=True:C214
				
				If (Count parameters:C259>=1)
					
					$keep:=(This:C1470.versionCompare($minVers; This:C1470.getDeviceAndroidVersion($emulatorSerial))<=0)
					
				End if 
				
				If ($keep)
					
					$devices.push($emulatorSerial)
					
				End if 
			End if 
		End for each 
	End if 
	
Function execute($command : Text)
	If ((Is Windows:C1573) && (Position:C15(" "; This:C1470.cmd)=0))  // do not support path with space yet (need to escape correctly things with cmd.exe start)
		This:C1470.launch("bat"; This:C1470.cmd+" "+$command)
	Else 
		This:C1470.launch(This:C1470.cmd+" "+$command)
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// wait-for-device
Function waiForDevice()->$pluggedDevice : Boolean
	
	Repeat 
		
		This:C1470.execute("wait-for-device devices")
		
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
	
	var $minVers; $emulatorSerial; $t : Text
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
				
				$emulatorSerial:=Substring:C12($t; $pos{1}; $len{1})
				$keep:=True:C214
				
				If (Count parameters:C259>=1)
					
					$keep:=(This:C1470.versionCompare($minVers; This:C1470.getDeviceAndroidVersion($emulatorSerial))<=0)
					
				End if 
				
				If ($keep)
					
					$device:=New object:C1471(\
						"udid"; $emulatorSerial; \
						"name"; This:C1470.getDeviceName($emulatorSerial); \
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
Function isDeviceConnected($emulatorSerial)->$connected : Boolean
	
	This:C1470._devices(True:C214)
	
	If (This:C1470.success)
		
		$connected:=Match regex:C1019("(?m-si)"+$emulatorSerial+"\\tdevice"; This:C1470.outputStream; 1)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns the Android version of a connected device or a booted emulator from its UUID
Function getDeviceAndroidVersion($emulatorSerial : Text)->$version : Text
	
	This:C1470.execute("-s "+$emulatorSerial+" shell getprop ro.build.version.release")
	
	If (This:C1470.success)
		
		$version:=This:C1470.outputStream
		
	Else 
		
		This:C1470._pushError("Can't get Android version for the device "+$emulatorSerial)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns the name of a connected device or a booted emulator from its UUID
Function getDeviceSDKVersion($emulatorSerial : Text)->$version : Text
	
	This:C1470.execute("-s "+$emulatorSerial+" shell getprop ro.system.build.version.sdk")
	
	If (This:C1470.success)
		
		$version:=This:C1470.outputStream
		
	Else 
		
		This:C1470._pushError("Can't get Android version for the device "+$emulatorSerial)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns the name of a connected device from its serial
Function getDeviceName($emulatorSerial : Text)->$name : Text
	
	// https://stackoverflow.com/questions/54810404/is-there-a-way-to-get-the-device-name-using-adb-for-example-if-the-device-name
	This:C1470.execute("-s "+$emulatorSerial+" shell dumpsys bluetooth_manager | \\grep 'name:' | cut -c9-")
	
	If (This:C1470.success)
		
		$name:=This:C1470.outputStream
		
	Else 
		
		This:C1470._pushError("Can't get name for the device "+$emulatorSerial)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a connected device or emulator properties from its serial
Function getDeviceProperties($emulatorSerial : Text)->$properties : Object
	
	var $buffer; $key; $subkey; $t : Text
	var $o : Object
	var $c : Collection
	
	ARRAY LONGINT:C221($len; 0x0000)
	ARRAY LONGINT:C221($pos; 0x0000)
	
	This:C1470.execute("-s "+$emulatorSerial+" shell getprop")
	
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
		
		This:C1470._pushError("Failed to obtain device properties "+$emulatorSerial)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Test if an app is installed on a connected device
Function isAppInstalled($emulatorSerial : Text; $package : Text)->$installed : Boolean
	
	$installed:=This:C1470.userPackageList($emulatorSerial).indexOf($package)>=0
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a collection of package names for a connected device
Function packageList($emulatorSerial : Text)->$packages : Collection
	
	$packages:=This:C1470._packageList($emulatorSerial)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a collection of 3rd party package names for a connected device
Function userPackageList($emulatorSerial : Text)->$packages : Collection
	
	$packages:=This:C1470._packageList($emulatorSerial; "-3")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Install an APK on a connected device giving its path or File object
Function installApp($emulatorSerial : Text; $apk : Variant; $test : Boolean)->$this : cs:C1710.adb
	
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
			This:C1470.execute("-s "+$emulatorSerial+" install -r "+Choose:C955($test; "-t "; "")+This:C1470.quoted($file.path))
			
		Else 
			
			// - directs command to the only connected USB device...
			This:C1470.execute("-d install -r "+Choose:C955($test; "-t "; "")+This:C1470.quoted($file.path))
			
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
Function uninstallApp($emulatorSerial : Text; $bundleIdentifier : Text)
	
	$bundleIdentifier:=Replace string:C233($bundleIdentifier; "-"; "_")
	
	If (This:C1470.userPackageList($emulatorSerial).indexOf($bundleIdentifier)>=0)
		
		This:C1470.execute("-s "+$emulatorSerial+" uninstall "+Lowercase:C14($bundleIdentifier))
		
		If (Not:C34(This:C1470.success))
			
			This:C1470.execute("-s "+$emulatorSerial+" shell pm uninstall "+Lowercase:C14($bundleIdentifier))
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function launchApp($bundleIdentifier : Text)->$this : cs:C1710.adb
	
	$bundleIdentifier:=Replace string:C233($bundleIdentifier; "-"; "_")
	
	//monkey -p com.package.name -v 1
	This:C1470.resultInErrorStream:=True:C214
	This:C1470.execute("shell monkey -p "+Lowercase:C14($bundleIdentifier)+" -v 1")
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// list info on one package
Function getAppProperties($emulatorSerial : Text; $appName : Text)
	
	This:C1470.execute("-s "+$emulatorSerial+" shell dump "+This:C1470._packageName($appName))
	
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
	
Function listBootedDevices()->$result : Object  // List booted devices
	
	$result:=New object:C1471(\
		"bootedDevices"; New collection:C1472; \
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	This:C1470.execute("devices")
	
	If (Position:C15("daemon started successfully"; String:C10(This:C1470.errorStream))>0)  // adb was not ready, restart command
		
		If (Not:C34(This:C1470._adbStartRetried))
			
			This:C1470._adbStartRetried:=True:C214
			
			$result:=This:C1470.listBootedDevices()
			
		Else 
			
			$result.success:=False:C215
			$result.errors.push(This:C1470.errorStream)
			
		End if 
		
	Else   // No issue with adb started status
		
		$result.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
		
		If ($result.success)
			
			$result.bootedDevices:=Split string:C1554(String:C10(This:C1470.outputStream); "\n")
			$result.bootedDevices.shift().pop()  // removing first and last entries
			
		Else 
			
			$result.errors.push("(failed to get adb device list)")
			
		End if 
	End if 
	
Function findSerial($bootedDevicesList : Collection; $searchedAvdName : Text)->$result : Object
	var $emulatorLine; $emulatorSerial : Text
	var $Obj_avdName : Object
	
	$result:=New object:C1471(\
		"serial"; ""; \
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	For each ($emulatorLine; $bootedDevicesList) Until ($result.serial#"")
		
		If (Position:C15("\tdevice"; $emulatorLine)>0)
			
			$emulatorSerial:=Substring:C12($emulatorLine; 1; (Position:C15("\tdevice"; $emulatorLine)-1))
			
		Else 
			
			$emulatorSerial:=Substring:C12($emulatorLine; 1; (Position:C15("\toffline"; $emulatorLine)-1))
			
		End if 
		
		// Get associated avd name
		$Obj_avdName:=This:C1470.getAvdName($emulatorSerial)
		
		If ($Obj_avdName.success)
			
			If ($Obj_avdName.avdName=$searchedAvdName)
				
				// found avd name, means that tested serial is correct
				$result.serial:=$emulatorSerial
				$result.success:=True:C214
				
				// Else : not the associated serial
			End if 
			
		Else 
			// getAvdName failed
			$result.errors.combine($Obj_avdName.errors)
		End if 
		
	End for each 
	
Function getAvdName($emulatorSerial : Text)->$result : Object  // #TO_DO : NOT THE SAME AS getDeviceName() -> MOVE TO avd
	var $avdName_Col : Collection
	
	$result:=New object:C1471(\
		"avdName"; ""; \
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	This:C1470.execute("-s \""+$emulatorSerial+"\" emu avd name")
	
	If ((This:C1470.outputStream#Null:C1517) & (String:C10(This:C1470.outputStream)#""))
		
		$avdName_Col:=Split string:C1554(String:C10(This:C1470.outputStream); "\n")
		
		If ($avdName_Col.length>1)
			// First line is the avd name
			// Warning : on Windows, it is avd name + "\r"
			$result.avdName:=Replace string:C233($avdName_Col[0]; "\r"; "")
			$result.success:=True:C214
			
		Else 
			// can't find avd name
			$result.errors.push("(can't get avd name for this emulator)")
		End if 
		
		// Else : serial not found
	End if 
	
Function forceInstallApp($emulatorSerial : Text; $packageName : Text/* app name */; $apk : 4D:C1709.File)->$result : Object
	var $Obj_uninstallAppIfInstalled; $Obj_install : Object
	
	$result:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$Obj_uninstallAppIfInstalled:=This:C1470.uninstallAppIfInstalled($emulatorSerial; $packageName)
	
	If ($Obj_uninstallAppIfInstalled.success)
		
		$Obj_install:=This:C1470.waitInstallApp($emulatorSerial; $apk)
		
		If ($Obj_install.success)
			$result.success:=True:C214
		Else 
			$result.errors:=$Obj_install.errors
		End if 
		
	Else 
		$result.errors:=$Obj_uninstallAppIfInstalled.errors
	End if 
	
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function waitStartApp($emulatorSerial : Text; $packageName : Text/* app name */; $activityName : Text/* com.qmobile.qmobileui.activity.loginactivity.LoginActivity */)->$result : Object
	var $startTime; $stepTime : Integer
	
	$result:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	// Time elapsed
	$startTime:=Milliseconds:C459
	
	Repeat 
		
		IDLE:C311
		DELAY PROCESS:C323(Current process:C322; 120)
		
		This:C1470.execute("-s \""+$emulatorSerial+"\" shell am start -n \""+$packageName+"/"+$activityName+"\"")
		
		$result.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
		
		$stepTime:=Milliseconds:C459-$startTime
		
	Until ($result.success=True:C214)\
		 | ($stepTime>This:C1470.appStartTimeOut)
	
	If ($stepTime>This:C1470.appStartTimeOut)  // Timeout
		
		$result.errors.push("(timeout reached when starting the app)")
		
		// Else : all ok 
	End if 
	
Function uninstallAppIfInstalled($emulatorSerial : Text; $package : Text)->$result : Object
	
	
	
	var $Obj_isInstalled; $Obj_uninstall : Object
	
	$result:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$Obj_isInstalled:=This:C1470.isAppAlreadyInstalled($emulatorSerial; $package)
	
	If ($Obj_isInstalled.success)
		
		If ($Obj_isInstalled.isInstalled)
			
			$Obj_uninstall:=This:C1470.waitUninstallApp($emulatorSerial; $package)
			
			If ($Obj_uninstall.success)
				
				$result.success:=True:C214
				
			Else 
				
				$result.errors:=$Obj_uninstall.errors
				
			End if 
			
		Else 
			// App not installed
			$result.success:=True:C214
		End if 
		
	Else 
		$result.errors:=$Obj_isInstalled.errors
	End if 
	
Function waitForDevicePackageList($emulatorSerial : Text)->$result : Object
	var $startTime; $stepTime : Integer
	
	$result:=New object:C1471(\
		"packageList"; ""; \
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	// Time elapsed
	$startTime:=Milliseconds:C459
	
	Repeat 
		
		IDLE:C311
		DELAY PROCESS:C323(Current process:C322; 120)
		
		This:C1470.execute("-s \""+$emulatorSerial+"\" shell pm list packages")
		
		$result.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
		
		$result.packageList:=This:C1470.outputStream
		
		$stepTime:=Milliseconds:C459-$startTime
		
	Until (($result.success=True:C214) & ($result.packageList#""))\
		 | ($stepTime>This:C1470.packageListTimeOut)
	
	If ($stepTime>This:C1470.packageListTimeOut)  // Timeout
		
		$result.errors.push("(timeout reached when getting package list)")
		
		// Else : all ok 
	End if 
	
Function isAppAlreadyInstalled($emulatorSerial : Text; $packageName : Text/* app name */)->$result : Object
	var $Obj_packageList : Object
	
	$result:=New object:C1471(\
		"isInstalled"; False:C215; \
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$Obj_packageList:=This:C1470.waitForDevicePackageList($emulatorSerial)
	
	If ($Obj_packageList.success)
		
		$result.success:=True:C214
		$result.isInstalled:=(Position:C15($packageName; $Obj_packageList.packageList)>0)
		
	Else 
		$result.errors:=$Obj_packageList.errors
	End if 
	
Function waitUninstallApp($emulatorSerial : Text; $packageName : Text/* app name */)->$result : Object
	var $startTime; $stepTime : Integer
	
	$result:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	// Time elapsed
	$startTime:=Milliseconds:C459
	
	Repeat 
		
		This:C1470.execute("-s \""+$emulatorSerial+"\" uninstall \""+$packageName+"\"")
		$result.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
		
		If (Not:C34($result.success))
			
			IDLE:C311
			DELAY PROCESS:C323(Current process:C322; 120)
			
			$stepTime:=Milliseconds:C459-$startTime
			
		End if 
		
	Until ($result.success=True:C214)\
		 | ($stepTime>This:C1470.timeOut)
	
	If ($stepTime>This:C1470.timeOut)  // Timeout
		
		$result.errors.push("(timeout reached when uninstalling the app)")
		
		// Else : all ok 
	End if 
	
Function waitInstallApp($emulatorSerial : Text; $apk : 4D:C1709.File)->$result : Object
	var $startTime; $stepTime : Integer
	
	$result:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	// Time elapsed
	$startTime:=Milliseconds:C459
	
	Repeat 
		
		IDLE:C311
		DELAY PROCESS:C323(Current process:C322; 120)
		
		This:C1470.execute("-s \""+$emulatorSerial+"\" install -t \""+$apk.path+"\"")
		
		$result.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
		
		$stepTime:=Milliseconds:C459-$startTime
		
	Until ($result.success=True:C214)\
		 | ($stepTime>This:C1470.timeOut)
	
	If ($stepTime>This:C1470.timeOut)  // Timeout
		
		$result.errors.push("(timeout reached when installing the app)")
		
		// Else : all ok 
	End if 
	
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// [PRIVATE] Returns the current version of the tool
Function _version($cmd : Text)->$version : Text
	
	This:C1470.execute("version")
	
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
Function _packageList($emulatorSerial : Text; $options)->$packages : Collection
	
	var $t : Text
	var $spendTime : Integer
	
	This:C1470.countTimeInit()
	
	Repeat 
		
		If (Count parameters:C259=1)
			
			This:C1470.execute("-s "+$emulatorSerial+" shell pm list packages")
			
		Else 
			
			This:C1470.execute("-s "+$emulatorSerial+" shell pm list packages "+$options)
			
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
	
	This:C1470.execute("devices")
	
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
	
Function killServer
	This:C1470.execute("kill-server")
	
/*Function kill($emulatorSerial : Text; $apk : 4D:C1709.File) -> $result : Object
var $emulatorSerial : Text  // emu name
	
$result:=This.launch(This.cmd; New collection("-s"; $emulatorSerial; "emu"; "kill"))
*/
	