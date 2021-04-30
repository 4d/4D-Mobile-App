//%attributes = {"invisible":true}
// ----------------------------------------------------
// Object method : RIBBON.201 - (Simulator button)
// ID[6815D0201FC24AF6A6763A5CFDD4B233]
// Created 31-1-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $bottom; $left; $right; $top : Integer
var $lastDevice; $tab : Text
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
		
		$menu:=cs:C1710.menu.new()
		
		If (FEATURE.with("android"))  // 🚧
			
			$lastDevice:=EDITOR.preferences.get("simulator")
			$tab:="       "
			
			If (Is macOS:C1572)
				
				$menu.append("iOS").icon("images/os/iOS-24.png").disable()
				
				If (EDITOR.xCode.ready)
					
					If (EDITOR.devices.connected.apple.length>0)
						
						For each ($device; EDITOR.devices.connected.apple)
							
							$menu.append($tab+$device.name; $device.udid)\
								.mark($device.udid=$lastDevice)
							
						End for each 
						
						$menu.line()
						
					End if 
					
					If (EDITOR.devices.apple.length>0)
						
						For each ($device; EDITOR.devices.apple)
							
							$menu.append($tab+$device.name; $device.udid)\
								.mark(($device.udid=$lastDevice) & PROJECT.$ios)
							
						End for each 
					End if 
					
					$menu.line()
					
					$menu.append($tab+Get localized string:C991("openTheXcodeSimulatorsManager"); "XcodeDeviceManager")
					
				Else 
					
					$menu.append($tab+Replace string:C233(Get localized string:C991("checkTheInstallationOf"); "{app}"; "Xcode"); "checkXcodeInstallation")
					
				End if 
				
				$menu.line()
				
				$menu.append("Android").icon("images/os/android-24.png").disable()
				
				If (EDITOR.studio.ready)
					
					If (EDITOR.devices.android.length>0)
						
						For each ($device; EDITOR.devices.android.orderBy("name"))
							
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
				
				If (EDITOR.studio.ready)
					
					If (EDITOR.devices.android.length>0)
						
						For each ($device; EDITOR.devices.android)
							
							$menu.append($device.name; $device.udid)\
								.mark($device.udid=String:C10(EDITOR.currentDevice))
							
						End for each 
						
						$menu.line()
						
					Else 
						
						$menu.append("createASimulator"; "createAVD").line()
						
					End if 
					
					$menu.append("openTheAvdManager"; "avdManager")
					
				Else 
					
					$menu.append($tab+Replace string:C233(Get localized string:C991("checkTheInstallationOf"); "{app}"; "Android Studio"); "checkAndroidInstallation")
					
				End if 
			End if 
			
		Else 
			
			If (EDITOR.devices.length>0)
				
				For each ($device; EDITOR.devices)
					
					$menu.append($device.name; $device.udid)\
						.mark($device.udid=String:C10(EDITOR.currentDevice))
					
				End for each 
				
				If (Macintosh option down:C545 & Not:C34(Is compiled mode:C492))
					
					$menu.line().append(Get localized string:C991("openTheAvdManager"); "avdManager")
					
				End if 
			End if 
		End if 
		
		OBJECT GET COORDINATES:C663(*; $e.objectName; $left; $top; $right; $bottom)
		$menu.popup($left; $bottom)
		
		Case of 
				
				//______________________________________________________
			: (Not:C34($menu.selected))
				
				// Nothing selected
				$lastDevice:=""
				
				//______________________________________________________
			: ($menu.choice="checkAndroidInstallation")\
				 | ($menu.choice="checkXcodeInstallation")
				
				If ($menu.choice="checkAndroidInstallation")
					
					EDITOR.studio.canceled:=False:C215
					
				Else 
					
					EDITOR.xCode.canceled:=False:C215
					
				End if 
				
				// Launch checking the development environment
				EDITOR.checkDevTools()
				
				//______________________________________________________
			: ($menu.choice="XcodeDeviceManager")
				
				cs:C1710.Xcode.new().showDevicesWindow()
				
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
						
					End if 
					
					If ($success)
						
						cs:C1710.avd.new().createAvd($defaultAvd)
						
						// * UPDATE DEVICE LIST
						EDITOR.getDevices()
						
					End if 
					
					If ($progress#Null:C1517)
						
						$progress.close()
						
					End if 
					
				Else 
					
					RECORD.error("missing default avd definition")
					
				End if 
				
				//______________________________________________________
			: ($menu.choice="avdManager")
				
				// https://android.stackexchange.com/questions/182920/launch-avd-manager-from-command-line
				// There is no way to launch AVD manager from cmdline (It is deprecated)
				// So we opens the Abdroid Studio Application
				
				cs:C1710.studio.new().open()
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)[[:xdigit:]]{8}-(?:[[:xdigit:]]{4}-){3}[[:xdigit:]]{12}"; $menu.choice; 1))  // iOS Simulator
				
				$device:=EDITOR.devices.apple.query("udid = :1"; $menu.choice).pop()
				
				// Set default simulator
				EDITOR.currentDevice:=$menu.choice
				OBJECT SET TITLE:C194(*; "201"; $device.name)
				
				EDITOR.preferences.set("lastIosDevice"; $menu.choice)
				
				// #TO_OPTMIZE : deport to worker
				
				// Kill all booted devices, if any, & fix default
				var $simctl : cs:C1710.simctl
				$simctl:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget)
				//$simctl.shutdownAllDevices()
				$simctl.setDefaultDevice($menu.choice)
				
				PROJECT.$ios:=True:C214  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++
				EDITOR.ios:=True:C214
				PROJECT._simulator:=$device.udid
				PROJECT.setTarget(True:C214; "ios")
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)[[:xdigit:]]{8}-[[:xdigit:]]{16}"; $menu.choice; 1))  // iOS Connected Device
				
				$device:=EDITOR.devices.connected.apple.query("udid = :1"; $menu.choice).pop()
				
				// Set default simulator
				EDITOR.currentDevice:=$menu.choice
				OBJECT SET TITLE:C194(*; "201"; $device.name)
				
				EDITOR.preferences.set("lastIosConnected"; $menu.choice)
				
				PROJECT.$ios:=True:C214  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++
				EDITOR.ios:=True:C214
				PROJECT._simulator:=$device.udid
				PROJECT.setTarget(True:C214; "ios")
				
				//______________________________________________________
			: (FEATURE.with("android"))  // 🚧
				
				$device:=EDITOR.devices.android.query("udid = :1"; $menu.choice).pop()
				
				EDITOR.currentDevice:=$menu.choice
				OBJECT SET TITLE:C194(*; "201"; $device.name)
				
				EDITOR.preferences.set("lastAndroidDevice"; $menu.choice)
				
				PROJECT.$android:=True:C214  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++
				EDITOR.android:=True:C214
				PROJECT._simulator:=$device.udid
				PROJECT.setTarget(True:C214; "android")
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(Not:C34(DATABASE.isMatrix))
				
				//______________________________________________________
		End case 
		
		If (Length:C16($lastDevice)>0)\
			 & ($lastDevice#String:C10(EDITOR.currentDevice))  // Keep
			
			EDITOR.preferences.set("simulator"; EDITOR.currentDevice)
			
			// Adapt button width
			SET TIMER:C645(-1)
			
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 