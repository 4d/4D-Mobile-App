Class extends androidProcess

/*
   lep ━ androidProcess ━┳━ adb  
                         ┣━ androidEmulator 
                         ┣━ androidProjectGenerator 
                         ┣━ avd 
                         ┣━ gradlew  
                         ┗━ sdkmanager                                
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
	
	This:C1470.timeOut:=30000  // 30 seconds
	This:C1470.packageListTimeOut:=240000  // 4 minutes
	This:C1470.bootTimeOut:=240000
	This:C1470.appStartTimeOut:=240000
	
	This:C1470.adbStartRetried:=False:C215
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a collection of attached devices ID (connected and authorized devices or booted simulators)
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
		
		$minVers:=String:C10(This:C1470.minimumVersion)
		
	End if 
	
	$devices:=New collection:C1472
	
	This:C1470._devices(True:C214)
	
	If (This:C1470.success)
		
		For each ($t; Split string:C1554(String:C10(This:C1470.outputStream); "\n"))
			
			If (Match regex:C1019("(?m-si)^((?:emulator-\\d*)|[A-Z0-9]*)\\tdevice$"; $t; 1; $pos; $len))
				
				$serial:=Substring:C12($t; $pos{1}; $len{1})
				$keep:=True:C214
				
				If (Count parameters:C259>=1)
					
					$keep:=(This:C1470.versionCompare($minVers; This:C1470.getAndroidVersion($serial))<=0)
					
				End if 
				
				If ($keep)
					
					$devices.push($serial)
					
				End if 
			End if 
		End for each 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// List of connected devices
	// if 'androidDeploymentTarget' is passed, keeps only devices where the version of Android is higher or equal
Function connected($androidDeploymentTarget : Text)->$devices : Collection
	
	var $minVers; $serial; $t : Text
	var $keep : Boolean
	var $device : Object
	
	ARRAY LONGINT:C221($len; 0x0000)
	ARRAY LONGINT:C221($pos; 0x0000)
	
	If (Count parameters:C259>=1)
		
		$minVers:=$androidDeploymentTarget
		
	Else 
		
		$minVers:=String:C10(This:C1470.minimumVersion)
		
	End if 
	
	$devices:=New collection:C1472
	
	This:C1470._devices(True:C214)
	
	If (This:C1470.success)
		
		For each ($t; Split string:C1554(String:C10(This:C1470.outputStream); "\n"))
			
			If (Match regex:C1019("(?m-si)^([^\\t]*)\\t(device|unauthorized)$"; $t; 1; $pos; $len))
				
				$serial:=Substring:C12($t; $pos{1}; $len{1})
				$keep:=True:C214
				
				If (Count parameters:C259>=1)
					
					$keep:=(This:C1470.versionCompare($minVers; This:C1470.getAndroidVersion($serial))<=0)
					
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
	// Test if a device is connacted from its UUID
Function isDeviceConnected($serial)->$connected : Boolean
	
	This:C1470._devices(True:C214)
	
	If (This:C1470.success)
		
		$connected:=Match regex:C1019("(?m-si)"+$serial+"\\tdevice"; This:C1470.outputStream; 1)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the name of a connected device or a booted emulator from its UUID
Function getAndroidVersion($serial : Text)->$version : Text
	
	This:C1470.launch(This:C1470.cmd+" -s "+$serial+" shell getprop ro.build.version.release")
	
	If (This:C1470.success)
		
		$version:=This:C1470.outputStream
		
	Else 
		
		This:C1470._pushError("Can't get Android version for the device "+$serial)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the name of a connected device or a booted emulator from its UUID
Function getSDKVersion($serial : Text)->$version : Text
	
	This:C1470.launch(This:C1470.cmd+" -s "+$serial+" shell getprop ro.system.build.version.sdk")
	
	If (This:C1470.success)
		
		$version:=This:C1470.outputStream
		
	Else 
		
		This:C1470._pushError("Can't get Android version for the device "+$serial)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the name of a connected device from its serial
Function getDeviceName($serial : Text)->$name : Text
	
	// https://stackoverflow.com/questions/54810404/is-there-a-way-to-get-the-device-name-using-adb-for-example-if-the-device-name
	This:C1470.launch(This:C1470.cmd+" -s "+$serial+" shell dumpsys bluetooth_manager | \\grep 'name:' | cut -c9-")
	
	If (This:C1470.success)
		
		$name:=This:C1470.outputStream
		
	Else 
		
		This:C1470._pushError("Can't get name for the device "+$serial)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a connected device or emulator properties from its serial
Function getProp($serial : Text)->$properties : Object
	
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
	// Test if an app is installed on a connected device
Function isAppInstalled($appName : Text; $serial : Text)->$installed : Boolean
	
	var $c : Collection
	
	$c:=This:C1470.userPackageList($serial)
	
	If (This:C1470.success)
		
		$installed:=($c.indexOf(This:C1470._packageName($appName))#-1)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a collection of package names for a connected device
Function packageList($serial : Text)->$packages : Collection
	
	$packages:=This:C1470._packageList($serial)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a collection of third party package names for a connected device
Function userPackageList($serial : Text)->$packages : Collection
	
	$packages:=This:C1470._packageList($serial; "-3")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Install an APK on a connected device giving its path or File object
Function installApp($apk; $serial : Text)
	
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
		
		If (Count parameters:C259>=1)
			
			// -s <serial number>
			This:C1470.launch(This:C1470.cmd+" -s "+$serial+" install "+This:C1470.quoted($file.path))
			
		Else 
			
			// - directs command to the only connected USB device...
			This:C1470.launch(This:C1470.cmd+" -d install "+This:C1470.quoted($file.path))
			
		End if 
		
	Else 
		
		If (Value type:C1509($apk)=Is object:K8:27)
			
			This:C1470._pushError("Not a valid file: "+$file.path)
			
		Else 
			
			This:C1470._pushError("Not a valid file: "+$apk)
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Uninstalling app from connected device
Function uninstallApp($appName : Text; $serial : Text)
	
	This:C1470.launch(This:C1470.cmd+" -s "+$serial+" uninstall "+This:C1470._packageName($appName))
	
	If (Not:C34(This:C1470.success))
		
		This:C1470.launch(This:C1470.cmd+" -s "+$serial+" shell pm uninstall --user 0 "+This:C1470._packageName($appName))
		
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
	
	var $start; $step : Integer
	var $success : Boolean
	var $t : Text
	
	$start:=Milliseconds:C459
	
	Repeat 
		
		If (Count parameters:C259=1)
			
			This:C1470.launch(This:C1470.cmd+" -s \""+$serial+"\" shell pm list packages")
			
			
		Else 
			
			This:C1470.launch(This:C1470.cmd+" -s \""+$serial+"\" shell pm list packages "+$options)
			
		End if 
		
		$success:=This:C1470.success & (Length:C16(This:C1470.outputStream)>0)
		
		If (Not:C34($success))
			
			IDLE:C311
			DELAY PROCESS:C323(Current process:C322; 60)
			IDLE:C311
			
		End if 
		
	Until ($success)\
		 | ((Milliseconds:C459-$start)>This:C1470.packageListTimeOut)
	
	If ($success)
		
		$packages:=New collection:C1472
		
		For each ($t; Split string:C1554(This:C1470.outputStream; "\n"))
			
			$packages.push(Replace string:C233($t; "package:"; ""))
			
		End for each 
		
	Else 
		
		This:C1470._pushError("Timeout when getting package list")
		
	End if 
	
	// ____________________________________________________________________________________________________________
	// [PRIVATE] - Run 'adb devices'
Function _devices($firstAttempt : Boolean)
	
	If (Count parameters:C259>=1)
		
		This:C1470.adbStartRetried:=False:C215
		
	End if 
	
	This:C1470.launch(This:C1470.cmd+" devices")
	
	If (This:C1470.success)
		
		If (Position:C15("daemon started successfully"; String:C10(This:C1470.errorStream))>0)
			
			If (Not:C34(This:C1470.adbStartRetried))
				
				// Adb was not ready, restart command
				This:C1470.adbStartRetried:=True:C214
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
		
		This:C1470._pushError("Failed to get device list")
		
	End if 
	
	
	
	
/*=========================================================================== 
	
USED for Android build  
	
===========================================================================*/
	
Function waitForBoot
	var $0 : Object
	var $1 : Text  // avd name
	var $startTime; $stepTime : Integer
	
	$0:=New object:C1471(\
		"serial"; ""; \
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	// Time elapsed
	$startTime:=Milliseconds:C459
	
	Repeat 
		
		IDLE:C311
		DELAY PROCESS:C323(Current process:C322; 120)
		
		$0:=This:C1470.getSerial($1)
		
		$stepTime:=Milliseconds:C459-$startTime
		
	Until (($0.success=True:C214) & ($0.serial#""))\
		 | ($0.errors.length>0)\
		 | ($stepTime>This:C1470.bootTimeOut)
	
	If ($stepTime>This:C1470.bootTimeOut)  // Timeout
		
		$0.errors.push("Timeout when booting emulator")
		
		// Else : all ok 
	End if 
	
Function getSerial
	var $0 : Object
	var $1 : Text  // searched avd name
	var $Obj_bootedDevices; $Obj_serial : Object
	
	$0:=New object:C1471(\
		"serial"; ""; \
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$Obj_bootedDevices:=This:C1470.listBootedDevices()
	
	If ($Obj_bootedDevices.success)
		
		$Obj_serial:=This:C1470.findSerial($Obj_bootedDevices.bootedDevices; $1)
		
		If ($Obj_serial.success)
			
			$0.serial:=$Obj_serial.serial
			$0.success:=True:C214
			
		Else 
			$0.errors:=$Obj_serial.errors  // This can be empty, therefore no error, just not found
		End if 
		
	Else 
		$0.errors:=$Obj_bootedDevices.errors
	End if 
	
Function listBootedDevices  // List booted devices
	var $0 : Object
	
	$0:=New object:C1471(\
		"bootedDevices"; New collection:C1472; \
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	This:C1470.launch(This:C1470.cmd+" devices")
	
	If (Position:C15("daemon started successfully"; String:C10(This:C1470.errorStream))>0)  // adb was not ready, restart command
		
		If (Not:C34(This:C1470.adbStartRetried))
			
			This:C1470.adbStartRetried:=True:C214
			
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
			
			$0.errors.push("Failed to get adb device list")
			
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
			$0.errors.push("Can't get avd name for this emulator")
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
		
		$0.errors.push("Timeout when starting the app")
		
		// Else : all ok 
	End if 
	
Function uninstallAppIfInstalled
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
		
		$0.errors.push("Timeout when getting package list")
		
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
		
		IDLE:C311
		DELAY PROCESS:C323(Current process:C322; 120)
		
		This:C1470.launch(This:C1470.cmd+" -s \""+$1+"\" uninstall \""+$2+"\"")
		
		$0.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
		
		$stepTime:=Milliseconds:C459-$startTime
		
	Until ($0.success=True:C214)\
		 | ($stepTime>This:C1470.timeOut)
	
	If ($stepTime>This:C1470.timeOut)  // Timeout
		
		$0.errors.push("Timeout when uninstalling the app")
		
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
		
		$0.errors.push("Timeout when installing the app")
		
		// Else : all ok 
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
	