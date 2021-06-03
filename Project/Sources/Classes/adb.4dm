/*
[A]ndroid [D]ebug [B]ridge is a versatile command-line tool that lets you 
communicate with a device. The adb command facilitates a variety of device 
actions, such as installing and debugging apps, and it provides access to a Unix 
shell that you can use to run a variety of commands on a device

*/

Class extends androidProcess

Class constructor
	
	Super:C1705()
	
	This:C1470.exe:=This:C1470._exe()
	This:C1470.cmd:=This:C1470.exe.path
	
	If (Is Windows:C1573)
		
		This:C1470.cmd:=This:C1470.cmd+".exe"
		
	End if 
	
	This:C1470.adbStartRetried:=False:C215
	This:C1470.timeOut:=30000  // 30 seconds
	This:C1470.packageListTimeOut:=240000  // 4 minutes
	This:C1470.bootTimeOut:=240000
	This:C1470.appStartTimeOut:=240000
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _exe()->$file : 4D:C1709.File
	
	$file:=This:C1470.androidSDKFolder().file("platform-tools/adb")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a collection of booted emulators & plugged devices
Function bootedDevices()->$devices : Collection
	
	$devices:=New collection:C1472
	
	This:C1470.launch(This:C1470.cmd+" devices")
	
	If (This:C1470.success)
		
		var $start : Integer
		$start:=1
		
		ARRAY LONGINT:C221($pos; 0)
		ARRAY LONGINT:C221($len; 0)
		
/*
List of devices attached
ZY22BJDD3Ldevice
emulator-5554device
*/
		
		While (Match regex:C1019("(?m-si)((?:emulator-\\d*)|[A-Z0-9]*)\\tdevice"; This:C1470.outputStream; $start; $pos; $len))
			
			$devices.push(Substring:C12(This:C1470.outputStream; $pos{1}; $len{1}))
			
			$start:=$pos{0}+$len{0}
			
		End while 
		
	Else 
		
		This:C1470.errors.push("Failed to get device list")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// List of plugged devices
Function plugged($iosDeploymentTarget : Text)->$plugged : Collection
	
	$plugged:=New collection:C1472
	
	This:C1470.launch(This:C1470.cmd+" devices")
	
	If (This:C1470.success)
		
		If (Position:C15("daemon started successfully"; String:C10(This:C1470.errorStream))>0)  // Adb was not ready, restart command
			
			If (Not:C34(This:C1470.adbStartRetried))
				
				This:C1470.adbStartRetried:=True:C214
				
				$plugged:=This:C1470.plugged()
				
			Else 
				
				This:C1470.success:=False:C215
				This:C1470.errors.push(This:C1470.errorStream)
				
			End if 
			
		Else   // No issue with adb started status
			
			var $serial; $t : Text
			ARRAY LONGINT:C221($len; 0x0000)
			ARRAY LONGINT:C221($pos; 0x0000)
			
			For each ($t; Split string:C1554(String:C10(This:C1470.outputStream); "\n"))
				
				If (Match regex:C1019("(?m-si)^([^\\t]*)\tdevice$"; $t; 1; $pos; $len))
					
					$serial:=Substring:C12($t; $pos{1}; $len{1})
					
					$plugged.push(New object:C1471(\
						"udid"; $serial; \
						"name"; This:C1470.getDeviceName($serial)))
					
				End if 
				
			End for each 
		End if 
		
	Else 
		
		This:C1470.errors.push("Failed to get adb device list")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the name of a plugged device from its serial
	// #TO_DO : Test if it's OK for emulators
Function getDeviceName($serial : Text)->$name : Text
	
	// https://stackoverflow.com/questions/54810404/is-there-a-way-to-get-the-device-name-using-adb-for-example-if-the-device-name
	This:C1470.launch(This:C1470.cmd+" -s "+$serial+" shell dumpsys bluetooth_manager | \\grep 'name:' | cut -c9-")
	
	If (This:C1470.success)
		
		$name:=This:C1470.outputStream
		
	Else 
		
		This:C1470.errors.push("Can't get name for the device "+$serial)
		
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
	
Function getAvdName  // #TO_DO : TEST IF WE CAN USE getDeviceName() ELSE MOVE TO avd
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
	
/*=========================================================================== 
	
UNUSED AT THIS TIME
	
===========================================================================*/
	
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
	