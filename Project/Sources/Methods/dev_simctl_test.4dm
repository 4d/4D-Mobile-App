//%attributes = {}
var $device : Object
var $availableDevices; $iPads; $iPhones : Collection
var $simctl : cs:C1710.simctl
var $folder : 4D:C1709.Folder

$simctl:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget)

//$availableDevices:=$simctl.availableDevices()

If ($simctl.bootedDevices().query("name = :1"; "iPhone 12 Pro Max").pop()=Null:C1517)
	
	$simctl.bootDevice("iPhone 12 Pro Max")
	
End if 

//$folder:=$simctl.deviceFolder("iPhone 12 Pro Max")

$device:=$simctl.device("iPhone 12 Pro Max")

//$folder:=$simctl.deviceFolder($device.udid; True)

If (Asserted:C1132($simctl.isDeviceBooted($device.udid); "Device is not booted"))
	
	$simctl.killAllDevices()
	
	ASSERT:C1129($simctl.bootedDevices().length=0; "Some devices was not killed")
	
	$simctl.bootDevice($device.udid; True:C214)
	
	$simctl.launchApp("com.myCompany.My-App-9"; $device.udid)
	
	DELAY PROCESS:C323(Current process:C322; 60*2)
	
	$simctl.terminateApp("com.myCompany.My-App-9"; $device.udid)
	
	
	DELAY PROCESS:C323(Current process:C322; 60*2)
	
	$simctl.quitSimulatorApp()
	
End if 

//$device:=$simctl.defaultDevice()

//$iPhones:=$simctl.deviceTypes("iPhone")
//$iPads:=$simctl.deviceTypes("iPad")