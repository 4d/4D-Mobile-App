//%attributes = {}
var $device; $o : Object
var $availableDevices; $iPads; $iPhones : Collection
var $folder : 4D:C1709.Folder
var $simctl : cs:C1710.simctl

COMPILER_COMPONENT

$simctl:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget)

Case of 
		
		//______________________________________________________
	: (True:C214)
		
		$device:=$simctl.defaultDevice()
		$simctl.setDefaultDevice("none")
		$o:=$simctl.defaultDevice()
		$simctl.setDefaultDevice($device.udid; True:C214)
		$o:=$simctl.defaultDevice()
		
		
		
		
		//______________________________________________________
	: (True:C214)
		
		var $cfgutil : cs:C1710.cfgutil
		$cfgutil:=cs:C1710.cfgutil.new()
		
		var $pluggedDevices : Collection
		$pluggedDevices:=$cfgutil.plugged()
		
		var $pluggedDevices : Collection
		$pluggedDevices:=$simctl.plugged()
		
		//______________________________________________________
	: (True:C214)
		
		//$device:=$simctl.defaultDevice()
		var $plist : cs:C1710.plist
		$plist:=cs:C1710.plist.new(File:C1566("/Users/vdl/Desktop/DEV/com.apple.iphonesimulator.plist"))
		
		//______________________________________________________
	: (True:C214)
		
		$simctl.bootDevice("iPhone 12 Pro Max")
		
		If (Shift down:C543)
			
			$simctl.openUrl("https://4D.com")
			
		Else 
			
			$simctl.openUrlScheme("maps://?s=Apple+Park")
			
		End if 
		
		//______________________________________________________
	: (True:C214)
		
		If ($simctl.bootedDevices().query("name = :1"; "iPhone 12 Pro Max").pop()=Null:C1517)
			
			$simctl.bootDevice("iPhone 12 Pro Max")
			
		End if 
		
		$device:=$simctl.device("iPhone 12 Pro Max")
		
		If (Asserted:C1132($simctl.isDeviceBooted($device.udid); "Device is not booted"))
			
			$simctl.shutdownAllDevices()
			
			ASSERT:C1129($simctl.bootedDevices().length=0; "Some devices was not killed")
			
			$simctl.bootDevice($device.udid; True:C214)
			
			$simctl.launchApp("com.myCompany.My-App-9")
			
			DELAY PROCESS:C323(Current process:C322; 60*2)
			
			$simctl.terminateApp("com.myCompany.My-App-9")
			
			DELAY PROCESS:C323(Current process:C322; 60*2)
			
			$simctl.quitSimulatorApp()
			
		End if 
		
		//______________________________________________________
	: (True:C214)
		
		$availableDevices:=$simctl.availableDevices()
		
		//______________________________________________________
	: (True:C214)
		
		// Shutdown, if any,  "iPhone 12 Pro Max" device and waits it's shutdown
		$simctl.shutdownDevice("iPhone 12 Pro Max"; True:C214)
		
		// Boot "iPhone 12 Pro Max" device and waits it's booted
		$simctl.bootDevice("iPhone 12 Pro Max"; True:C214)
		
		//______________________________________________________
	: (True:C214)
		
		// Quit simulator App after shutdown all booted devices
		$simctl.quitSimulatorApp(True:C214)
		
		// Boot the default device
		// (launch the Simulator App if any)
		$simctl.bootDevice()
		
		//______________________________________________________
	: (True:C214)
		
		$folder:=$simctl.deviceFolder("iPhone 12 Pro Max")
		$device:=$simctl.device("iPhone 12 Pro Max")
		ASSERT:C1129($simctl.deviceFolder($device.udid; True:C214).path=$folder.path)
		
		//______________________________________________________
	: (True:C214)
		
		$iPhones:=$simctl.deviceTypes("iPhone")
		$iPads:=$simctl.deviceTypes("iPad")
		
		//______________________________________________________
End case 