Class extends lep

/*
cfgutil performs various management tasks on one or more attached iOS
devices. It can be used manually and as part of automated workflows.

⚠️ Apple Configurator 2.app must be installed ?

*/

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705()
	
	This:C1470.devices:=New collection:C1472
	This:C1470.cacheDuration:=30  // Number of seconds during which the list of plugged devices is not refreshed
	This:C1470.cacheStamp:=0
	
	This:C1470.appName:="Apple Configurator 2"
	This:C1470.exe:=This:C1470._getExe(This:C1470.appName)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// List all attached devices
Function plugged($refresh : Boolean)->$devices : Collection
	
	var $ecid : Text
	var $o : Object
	
	If (This:C1470.exe.exists)
		
		If ((Milliseconds:C459-This:C1470.cacheStamp)>(This:C1470.cacheDuration*1000)) | $refresh
			
			This:C1470.devices:=New collection:C1472
			
			This:C1470.launch(This:C1470.singleQuoted(This:C1470.exe.path)+" --format JSON list")
			This:C1470.success:=Bool:C1537(OK) & Match regex:C1019("(?msi)^\\{.*\\}$"; This:C1470.outputStream; 1)
			
			If (This:C1470.success)
				
				$o:=This:C1470._manageResponse()  //JSON Parse(This.outputStream)
				
				If ($o.Devices#Null:C1517)
					
					For each ($ecid; $o.Devices)
						
						This:C1470.devices.push($o.Output[$ecid])
						
					End for each 
				End if 
			End if 
			
			This:C1470.cacheStamp:=Milliseconds:C459
			
		End if 
	End if 
	
	$devices:=This:C1470.devices
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns True if the device is attached
	// MARK: #TODO : accept text (udid, name,…)
Function isDeviceConnected($device : Object)->$connected : Boolean
	
	$connected:=This:C1470.plugged().query("ECID = :1"; String:C10($device.ECID)+String:C10($device.ecid)).pop()#Null:C1517
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns ecid of a device
	// MARK: #TODO : accept text (udid, name,…)
Function ecid($device : Object)->$ecid : Text
	
	var $udid : Text
	var $o : Object
	var $devices : Collection
	
	This:C1470.success:=This:C1470.exe.exists
	
	If (This:C1470.success)
		
		ASSERT:C1129(($device.udid#Null:C1517) | ($device.UDID#Null:C1517))
		
		$udid:=String:C10($device.udid)+String:C10($device.UDID)
		
		$devices:=This:C1470.plugged()
		
		If (This:C1470.success)
			
			For each ($o; $devices) Until (Length:C16($ecid)=0)
				
				If ($o.UDID=$udid)
					
					$ecid:=$o.ECID
					
				End if 
			End for each 
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Installs the given IPA file on the attached device
Function installApp($device : Object; $apk : 4D:C1709.File)->$this : cs:C1710.cfgutil
	
	var $cmd : Text
	
	This:C1470.success:=This:C1470.exe.exists
	
	Case of 
			
			//______________________________________________________
		: (This:C1470.success)
			
			$cmd:=This:C1470.singleQuoted(This:C1470.exe.path)\
				+" --format JSON"\
				+" -e "+String:C10($device.ECID)+String:C10($device.ecid)\
				+" install-app "+This:C1470.singleQuoted($apk.path)
			
			This:C1470.launch($cmd)
			This:C1470.success:=Bool:C1537(OK) & Match regex:C1019("(?msi)^\\{.*\\}$"; This:C1470.outputStream; 1)
			
			If (This:C1470.success)
				
				This:C1470._manageResponse()
				
			End if 
			
			//______________________________________________________
		Else 
			
			This:C1470._pushError("Not implemented without apple configurator")  // #MARK_LOCALIZE
			
			//______________________________________________________
	End case 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Removes the app with the given bundle identifier from attached device
Function uninstallApp($device : Object; $bundleIdentifier : Text)->$this : cs:C1710.cfgutil
	
	var $cmd : Text
	
	This:C1470.success:=This:C1470.exe.exists
	
	Case of 
			
			//______________________________________________________
		: (This:C1470.success)
			
			$cmd:=This:C1470.singleQuoted(This:C1470.exe.path)\
				+" --format JSON"\
				+" -e "+String:C10($device.ECID)+String:C10($device.ecid)\
				+" remove-app "+This:C1470.singleQuoted($bundleIdentifier)
			
			This:C1470.launch($cmd)
			This:C1470.success:=Bool:C1537(OK) & Match regex:C1019("(?msi)^\\{.*\\}$"; This:C1470.outputStream; 1)
			
			If (This:C1470.success)
				
				This:C1470._manageResponse()
				
			End if 
			
			//______________________________________________________
		Else 
			
			This:C1470._pushError("Not implemented without apple configurator")  // #MARK_LOCALIZE
			
			//______________________________________________________
	End case 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Fetch various properties of a device
	/// - To see the possible names of properties, don't pass the $property parameter
	/// - If device is omitted, the first detected device will be used
Function properties($property : Text; $device : Object)->$value : Text
	
/** Supported property names:
 - acceptsSupervision
 - activationState
 - appDiskUsage
 - audioDiskUsage
 - backupWillBeEncrypted
 - batteryCurrentCapacity
 - batteryIsCharging
 - bluetoothAddress
 - booksDiskUsage
 - bootedState
 - buildVersion
 - cloudBackupsAreEnabled
 - color
 - configurationProfiles
 - deviceClass
 - deviceType
 - documentsDiskUsage
 - ECID
 - enclosureColor
 - ethernetAddress
 - firmwareVersion
 - freeDiskSpace
 - hasTelephonyCapability
 - ICCID
 - ICCID2
 - IMEI
 - IMEI2
 - installedApps
 - isPaired
 - isRestorable
 - isSupervised
 - language
 - locale
 - locationID
 - logsDiskUsage
 - name
 - organizationAddress
 - organizationDepartment
 - organizationEmail
 - organizationMagic
 - organizationName
 - organizationPhone
 - otherDiskUsage
 - pairingAllowed
 - passcodeProtected
 - phoneNumber
 - phoneNumber2
 - photosDiskUsage
 - portNumber
 - provisioningProfiles
 - serialNumber
 - stationNumber
 - supportedLanguages
 - supportedLocales
 - supportedPropertyNames
 - tags
 - totalDiskCapacity
 - totalSpaceAvailable
 - UDID
 - videoDiskUsage
 - wifiAddress
*/
	
	var $cmd : Text
	
	$cmd:=This:C1470.singleQuoted(This:C1470.exe.path)\
		+" --format text"
	
	If ($device#Null:C1517)
		
		$cmd+=" --ecid "+String:C10($device.ECID)+String:C10($device.ecid)
		
	End if 
	
	$cmd+=" get-property "+Choose:C955($property=""; "supportedPropertyNames"; $property)
	
	This:C1470.launch($cmd)
	
	$value:=This:C1470.outputStream
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// [PRIVATE]
Function _getExe($bundleName : Text)->$exe : 4D:C1709.File
	
	var $bundle : 4D:C1709.Folder
	$bundle:=Folder:C1567("Applications/"+$bundleName+".app")
	
	If (Not:C34($bundle.exists))
		
		// Try with Spotlight
		This:C1470.launch("mdfind \"kMDItemCFBundleIdentifier == 'com.apple.configurator.ui'\"")
		
		If (This:C1470.success)
			
			var $c : Collection
			$c:=Split string:C1554(This:C1470.outputStream; "\n")
			
			If ($c.length>0)
				
				$bundle:=Folder:C1567("Applications/"+$c[0])
				
			End if 
		End if 
	End if 
	
	If ($bundle.exists)
		
		$exe:=$bundle.file("Contents/MacOS/cfgutil")
		This:C1470.success:=$exe.exists
		
	Else 
		
		// Last try, by watching at path
		This:C1470.launch("which cfgutil")
		
		If (This:C1470.success)\
			 & (Length:C16(This:C1470.outputStream)>0)
			
			$exe:=File:C1566(This:C1470.outputStream)
			This:C1470.success:=$exe.exists
			
		Else 
			
			This:C1470._pushError("cfgutil command not found")
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// [PRIVATE]
Function _manageResponse()->$response : Object
	
	$response:=JSON Parse:C1218(This:C1470.outputStream)
	
	Case of 
			
			//======================================
		: (String:C10($response.Type)="Error")
			
			This:C1470.success:=False:C215
			This:C1470.errors.pop()
			This:C1470._pushError($response.Message)
			
			//======================================
		: (String:C10($response.Type)="CommandOutput")
			
			This:C1470.lastError:=""
			This:C1470.errors.pop()
			
			//======================================
		Else 
			
			This:C1470.success:=False:C215
			This:C1470._pushError("Unknown output type: "+String:C10($response.Type))  // #MARK_LOCALIZE
			
			
			//======================================
	End case 
	
	