//%attributes = {"invisible":true}
// ----------------------------------------------------
// Object method : RIBBON.201 - (Simulator button)
// ID[6815D0201FC24AF6A6763A5CFDD4B233]
// Created 31-1-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $bottom; $left; $right; $top : Integer
var $lastDevice; $selectedDevice; $tab : Text
var $device; $e : Object
var $menu : cs:C1710.menu

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($e.code=On Mouse Enter:K2:33)
		
		RIBBON(Num:C11($e.objectName))
		
		//______________________________________________________
	: ($e.code=On Mouse Leave:K2:34)
		
		RIBBON(Num:C11($e.objectName))
		
		//______________________________________________________
	: ($e.code=On Clicked:K2:4)
		
		$menu:=cs:C1710.menu.new("no-localization")
		
		$lastDevice:=UI.preferences.get("lastDevice")
		$tab:="       "
		
		If (Is macOS:C1572)
			
			$menu.append("iOS").icon("images/os/iOS-24.png").disable()
			
			If (UI.xCode.ready)
				
				If (UI.devices.plugged.apple.length>0)
					
					For each ($device; UI.devices.plugged.apple)
						
						$menu.append($tab+$device.name; $device.udid)\
							.mark($device.udid=$lastDevice)
						
					End for each 
					
					$menu.line()
					
				End if 
				
				If (UI.devices.apple.length>0)
					
					For each ($device; UI.devices.apple)
						
						$menu.append($tab+$device.name; $device.udid)\
							.mark(($device.udid=$lastDevice) & PROJECT.$ios)
						
					End for each 
				End if 
				
				$menu.line()
				
				$menu.append($tab+Get localized string:C991("openTheXcodeSimulatorsManager"); "XcodeDeviceManager")
				$menu.append($tab+Get localized string:C991("downloadIOSPlatform"); "downloadIOSPlatform")
				
			Else 
				
				$menu.append($tab+Replace string:C233(Get localized string:C991("checkTheInstallationOf"); "{app}"; "Xcode"); "checkXcodeInstallation")
				
			End if 
			
			$menu.line()
			
			$menu.append("Android").icon("images/os/android-24.png").disable()
			
			If (UI.studio.ready)
				
				If (UI.devices.plugged.android.length>0)
					
					For each ($device; UI.devices.plugged.android)
						
						$menu.append($tab+$device.name; $device.udid)\
							.mark($device.udid=$lastDevice)
						
					End for each 
					
					$menu.line()
					
				End if 
				
				If (UI.devices.android.length>0)
					
					For each ($device; UI.devices.android.orderBy("name"))
						
						$menu.append($tab+$device.name; $device.udid)\
							.mark(($device.udid=$lastDevice) & PROJECT.$android).enable(Not:C34($device.missingSystemImage))
						
					End for each 
					
					$menu.line()
					
				Else 
					
					$menu.append($tab+Get localized string:C991("createASimulator"); "createAVD").line()
					
				End if 
				
				$menu.append($tab+Get localized string:C991("openTheAvdManager"); "avdManager")
				
			Else 
				
				$menu.append($tab+Replace string:C233(Get localized string:C991("checkTheInstallationOf"); "{app}"; "Android Studio"); "checkAndroidInstallation")
				
			End if 
			
		Else 
			
			If (UI.studio.ready)
				
				If (UI.devices.plugged.android.length>0)
					
					For each ($device; UI.devices.plugged.android)
						
						$menu.append($device.name; $device.udid)\
							.mark($device.udid=$lastDevice).enable(Not:C34(Bool:C1537($device.unauthorized)))
						
					End for each 
					
					$menu.line()
					
				End if 
				
				If (UI.devices.android.length>0)
					
					For each ($device; UI.devices.android)
						
						$menu.append($device.name; $device.udid)\
							.mark($device.udid=String:C10(UI.currentDevice))
						
					End for each 
					
					$menu.line()
					
				Else 
					
					$menu.append(":xliff:createASimulator"; "createAVD").line()
					
				End if 
				
				$menu.append(":xliff:openTheAvdManager"; "avdManager")
				
			Else 
				
				$menu.append($tab+Replace string:C233(Get localized string:C991("checkTheInstallationOf"); "{app}"; "Android Studio"); "checkAndroidInstallation")
				
			End if 
		End if 
		
		If (UI.xCode.ready) | (UI.studio.ready)
			
			$menu.line().append(":xliff:updatingTheListOfDevices"; "updateTheDeviceList")
			
		End if 
		
		OBJECT GET COORDINATES:C663(*; $e.objectName; $left; $top; $right; $bottom)
		$menu.popup($left; $bottom)
		
		Case of 
				
				//______________________________________________________
			: (Not:C34($menu.selected))
				
				// Nothing selected
				//
				
				//______________________________________________________
			: ($menu.choice="updateTheDeviceList")
				
				UI.getDevices()
				UI.updateRibbon()
				
				//______________________________________________________
			: ($menu.choice="checkAndroidInstallation")\
				 | ($menu.choice="checkXcodeInstallation")
				
				If ($menu.choice="checkAndroidInstallation")
					
					UI.studio.canceled:=False:C215
					
				Else 
					
					UI.xCode.canceled:=False:C215
					UI.xCode.alreadyNotified:=False:C215
					
				End if 
				
				// Launch checking the development environment
				UI.checkDevTools(True:C214)
				
				//______________________________________________________
			: ($menu.choice="XcodeDeviceManager")
				
				cs:C1710.Xcode.new().showDevicesWindow()
				
				//______________________________________________________
			: ($menu.choice="downloadIOSPlatform")
				
				// TODO: launch asynchronously (to not block), and maybe show message from command that download % of it
				var $resultDl : Object
				$resultDl:=(Shift down:C543) ? cs:C1710.Xcode.new().downloadAllPlatform() : cs:C1710.Xcode.new().downloadIOSPlatform()
				
				ALERT:C41(String:C10($resultDl.out)+String:C10($resultDl.error))
				
				//______________________________________________________
			: ($menu.choice="createAVD")
				
				var $success : Boolean
				var $defaultAvd : Object
				var $progress : cs:C1710.progress
				var $sdk : cs:C1710.sdkmanager
				var $package : 4D:C1709.Folder
				
				$defaultAvd:=JSON Parse:C1218(File:C1566("/RESOURCES/android.json").getText()).device
				
				If ($defaultAvd#Null:C1517)
					
					// * CHECK IF THE SYSTEM IMAGE IS AVAILABLE
					$sdk:=cs:C1710.sdkmanager.new()
					$package:=$sdk.exe.parent.parent.parent.folder(Split string:C1554($defaultAvd.image; ";").join("/"))
					$success:=$package.exists
					
					If (Not:C34($success))
						
						// * DOWNLOAD SYTEM IMAGE
						$progress:=cs:C1710.progress.new("creatingADefaultDevice")\
							.setMessage("downloadInProgress")\
							.bringToFront()
						
						$success:=$sdk.install($defaultAvd.image)
						
						$progress.close()
						
					End if 
					
					If ($success)
						
						var $avd : cs:C1710.avd
						$avd:=cs:C1710.avd.new().createAvd($defaultAvd.name; $defaultAvd.image; $defaultAvd.definition)
						
						If ($avd.success)
							
							// * UPDATE DEVICE LIST
							UI.getDevices()
							
							UI.currentDevice:=$defaultAvd.name
							
						Else 
							
							Logger.error("Failed to create default simulator")
							
						End if 
						
					Else 
						
						Logger.error("Failed to install default sdk image")
						
					End if 
					
				Else 
					
					Logger.error("Missing default avd definition")
					
				End if 
				
				//______________________________________________________
			: ($menu.choice="avdManager")
				
				// https://android.stackexchange.com/questions/182920/launch-avd-manager-from-command-line
				// There is no way to launch AVD manager from cmdline (It is deprecated)
				// So we opens the Abdroid Studio Application
				
				cs:C1710.studio.new().open()
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)[[:xdigit:]]{8}-(?:[[:xdigit:]]{4}-){3}[[:xdigit:]]{12}"; $menu.choice; 1))  // iOS Simulator
				
				$device:=UI.devices.apple.query("udid = :1"; $menu.choice).pop()
				
				$selectedDevice:=$menu.choice
				UI.preferences.set("lastIosDevice"; $selectedDevice)  // Last iOS device
				
				// #TO_OPTMIZE : deport to worker
				
				// Kill all booted devices, if any, & fix default
				var $simctl : cs:C1710.simctl
				$simctl:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget)
				//$simctl.shutdownAllDevices()
				$simctl.setDefaultDevice($menu.choice)
				
				PROJECT.$ios:=True:C214  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++
				
				UI.ios:=True:C214
				PROJECT._device:=$device
				PROJECT._simulator:=$device.udid
				UI.setTarget("ios"; True:C214)
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)[[:xdigit:]]{8}-[[:xdigit:]]{16}"; $menu.choice; 1))  // iOS plugged Device
				
				$device:=UI.devices.plugged.apple.query("udid = :1"; $menu.choice).pop()
				
				$selectedDevice:=$menu.choice
				UI.preferences.set("lastIosDevice"; $selectedDevice)  // Last iOS plugged device
				
				PROJECT.$ios:=True:C214  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++
				
				UI.ios:=True:C214
				PROJECT._device:=$device
				PROJECT._simulator:=$device.udid
				UI.setTarget("ios"; True:C214)
				
				//______________________________________________________
			Else 
				
				$device:=UI.devices.android.query("udid = :1"; $menu.choice).pop()
				
				If ($device=Null:C1517)
					
					$device:=UI.devices.plugged.android.query("udid = :1"; $menu.choice).pop()
					
				End if 
				
				$selectedDevice:=$menu.choice
				UI.preferences.set("lastAndroidDevice"; $selectedDevice)  // Last Android device
				
				PROJECT.$android:=True:C214  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++
				
				UI.android:=True:C214
				PROJECT._device:=$device
				PROJECT._simulator:=$device.udid
				UI.setTarget("android"; True:C214)
				
				//______________________________________________________
		End case 
		
		If (Length:C16($selectedDevice)>0) & ($selectedDevice#String:C10(UI.currentDevice))
			
			// Set
			UI.currentDevice:=$selectedDevice
			
			// Update UI
			OBJECT SET TITLE:C194(*; "201"; $device.name)
			SET TIMER:C645(-1)  // Adapt button width
			
			UI.preferences.set("lastDevice"; UI.currentDevice)  // Last used device
			
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 