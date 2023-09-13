//%attributes = {}
var $device; $o : Object
var $availableDevices; $iPads; $iPhones : Collection
var $folder : 4D:C1709.Folder
var $simctl : cs:C1710.simctl
var $plist : cs:C1710.plist

COMPILER_COMPONENT

Case of 
		
		//______________________________________________________
	: (True:C214)
		
		var $pluggedDevices : Collection
		
		var $cfgutil : cs:C1710.cfgutil
		$cfgutil:=cs:C1710.cfgutil.new()
		
		If ($cfgutil.success)
			
			$pluggedDevices:=$cfgutil.plugged()
			
			If ($pluggedDevices.length>0)
				
				$device:=$pluggedDevices[0]
				
				If ($cfgutil.isDeviceConnected($device))
					
					var $ecid : Text
					$ecid:=$cfgutil.ecid($device)
					
					var $value : Text
					$value:=$cfgutil.properties("installedApps"; $device)  //""
					
					//$value:=$cfgutil.properties()  // Possible names of properties
					//$value:=$cfgutil.properties("ECID")
					//$value:=$cfgutil.properties("UDID")
					//$value:=$cfgutil.properties("deviceClass")  // IPhone
					//$value:=$cfgutil.properties("deviceType")  // IPhone13,2
					//$value:=$cfgutil.properties("name")  // IPhone Vincent
					//$value:=$cfgutil.properties("provisioningProfiles")  //""
					
				End if 
			End if 
			
			
		Else 
			
			//ALERT("Apple Configurator 2 not found")
			
			$simctl:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget)
			
			$pluggedDevices:=$simctl.plugged()
			
			If ($pluggedDevices.length>0)
				
				$device:=$pluggedDevices[0]
				
				//If ($simctl.isAppInstalled("com.myCompany.My-App-7"; $device.udid))
				
				// End if
				
				
				
			End if 
		End if 
		
		
		//$pluggedDevices:=$simctl.plugged()
		//$device:=$pluggedDevices[0]
		
		//If ($simctl.isAppInstalled("com.myCompany.My-App-7"; $device.udid))
		
		// End if
		var $devmodectl : cs:C1710.devmodectl
		$devmodectl:=cs:C1710.devmodectl.new()
		
		$pluggedDevices:=$devmodectl.list()
		
		//______________________________________________________
	: (True:C214)
		
		var $xcode : cs:C1710.Xcode
		$xcode:=cs:C1710.Xcode.new()
		
		//______________________________________________________
	: (True:C214)
		
		$plist:=cs:C1710.plist.new(File:C1566("/Users/vdl/Desktop/TO BE TRASHED/test.plist"))
		
		//______________________________________________________
	: (True:C214)
		
		//$device:=$simctl.defaultDevice()
		$plist:=cs:C1710.plist.new(File:C1566("/Users/vdl/Desktop/DEV/com.apple.iphonesimulator.plist"))
		
		$plist.set("hello"; "world")
		$plist.set("hello.world"; 10)
		$plist.set(New collection:C1472("hello"; "world"); 8858)
		
		$plist.set("level_1.level_20[]")
		$plist.set("level_1.level_21"; "A NtEW ITEM")
		
		$plist.set("level_1.level_2[0]"; "1st element")
		$plist.set("level_1.level_2[10].test"; "hello")
		$plist.set("level_1.level_2[10].test"; "world")
		$plist.set("level_1.level_2[2].test"; "hello")
		$plist.set("level_1.level_2"; "hello")
		
		//var $value
		//$value:=$plist.get("hello.world")
		
		//______________________________________________________
	: (True:C214)
		
		
		$simctl:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget)
		$device:=$simctl.defaultDevice()
		$simctl.setDefaultDevice("none")
		$o:=$simctl.defaultDevice()
		$simctl.setDefaultDevice($device.udid; True:C214)
		$o:=$simctl.defaultDevice()
		
		//______________________________________________________
	: (True:C214)
		
		$simctl:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget)
		$simctl.bootDevice("iPhone 12 Pro Max")
		
		If (Shift down:C543)
			
			$simctl.openUrl("https://4D.com")
			
		Else 
			
			$simctl.openUrlScheme("maps://?s=Apple+Park")
			
		End if 
		
		//______________________________________________________
	: (True:C214)
		
		$simctl:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget)
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
		
		$simctl:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget)
		
		// Shutdown, if any,  "iPhone 12 Pro Max" device and waits it's shutdown
		$simctl.shutdownDevice("iPhone 12 Pro Max"; True:C214)
		
		// Boot "iPhone 12 Pro Max" device and waits it's booted
		$simctl.bootDevice("iPhone 12 Pro Max"; True:C214)
		
		//______________________________________________________
	: (True:C214)
		
		$simctl:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget)
		// Quit simulator App after shutdown all booted devices
		$simctl.quitSimulatorApp(True:C214)
		
		// Boot the default device
		// (launch the Simulator App if any)
		$simctl.bootDevice()
		
		//______________________________________________________
	: (True:C214)
		
		$simctl:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget)
		$folder:=$simctl.deviceFolder("iPhone 12 Pro Max")
		$device:=$simctl.device("iPhone 12 Pro Max")
		ASSERT:C1129($simctl.deviceFolder($device.udid; True:C214).path=$folder.path)
		
		//______________________________________________________
	: (True:C214)
		
		$simctl:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget)
		$iPhones:=$simctl.deviceTypes("iPhone")
		$iPads:=$simctl.deviceTypes("iPad")
		
		//______________________________________________________
End case 