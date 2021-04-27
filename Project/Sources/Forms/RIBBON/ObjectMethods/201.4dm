// ----------------------------------------------------
// Object method : RIBBON.201 - (Simulator button)
// ID[6815D0201FC24AF6A6763A5CFDD4B233]
// Created 31-1-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $bottom; $left; $right; $top : Integer
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
			
			var $pref : cs:C1710.preferences
			$pref:=cs:C1710.preferences.new().user("4D Mobile App.preferences")
			
			var $current : Text
			$current:=String:C10($pref.get("simulator"))
			
			var $tab : Text
			$tab:="       "
			
			If (Is macOS:C1572)
				
				$menu.append("iOS").icon("images/os/iOS-24.png").disable()
				
				If (Form:C1466.status.xCode)
					
					If (Form:C1466.devices.connected.apple.length>0)
						
						//$menu.line()
						
						For each ($device; Form:C1466.devices.connected.apple)
							
							$menu.append($tab+$device.name; $device.udid)\
								.mark($device.udid=$current)
							
						End for each 
						
						$menu.line()
						
					End if 
					
					If (Form:C1466.devices.apple.length>0)
						
						For each ($device; Form:C1466.devices.apple)
							
							$menu.append($tab+$device.name; $device.udid)\
								.mark(($device.udid=$current) & PROJECT.$ios)
							
						End for each 
					End if 
					
					$menu.line()
					
					$menu.append($tab+Get localized string:C991("openTheXcodeSimulatorsManager"); "XcodeDeviceManager")
					
				Else 
					
					$menu.append($tab+Replace string:C233(Get localized string:C991("checkTheInstallationOf"); "{app}"; "Xcode"); "checkXcodeInstallation")
					
				End if 
				
				$menu.line()
				
				$menu.append("Android").icon("images/os/android-24.png").disable()
				
				If (Form:C1466.status.studio)
					
					If (Form:C1466.devices.android.length>0)
						
						For each ($device; Form:C1466.devices.android.orderBy("name"))
							
							$menu.append($tab+$device.name; $device.udid)\
								.mark(($device.udid=$current) & PROJECT.$android).enable(Not:C34($device.missingSystemImage))
							
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
				
				If (Form:C1466.status.studio)
					
					If (Form:C1466.devices.android.length>0)
						
						For each ($device; Form:C1466.devices.android)
							
							$menu.append($device.name; $device.udid)\
								.mark($device.udid=String:C10(Form:C1466.currentDevice))
							
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
			
			If (Form:C1466.devices.length>0)
				
				For each ($device; Form:C1466.devices)
					
					$menu.append($device.name; $device.udid)\
						.mark($device.udid=String:C10(Form:C1466.currentDevice))
					
				End for each 
				
				If (Macintosh option down:C545 & Not:C34(Is compiled mode:C492))
					
					$menu.line().append(Get localized string:C991("openTheAvdManager"); "avdManager")
					
				End if 
				
			Else 
				
				POST_MESSAGE(New object:C1471(\
					"target"; Current form window:C827; \
					"action"; "show"; \
					"type"; "alert"; \
					"title"; "noDevices"))
				
			End if 
		End if 
		
		OBJECT GET COORDINATES:C663(*; $e.objectName; $left; $top; $right; $bottom)
		$menu.popup($left; $bottom)
		
		Case of 
				
				//______________________________________________________
			: (Not:C34($menu.selected))
				
				// Nothing selected
				$current:=""
				
				//______________________________________________________
			: ($menu.choice="checkAndroidInstallation")\
				 | ($menu.choice="checkXcodeInstallation")
				
				If ($menu.choice="checkAndroidInstallation")
					
					Form:C1466.editor.$studio.canceled:=False:C215
					
				Else 
					
					Form:C1466.editor.$xCode.canceled:=False:C215
					
				End if 
				
				// Launch checking the development environment
				CALL WORKER:C1389(Form:C1466.editor.$worker; "editor_CHECK_INSTALLATION"; New object:C1471(\
					"caller"; Form:C1466.editor.$mainWindow; "project"; PROJECT))
				
				//______________________________________________________
			: ($menu.choice="XcodeDeviceManager")
				
				cs:C1710.Xcode.new().showDevicesWindow()
				
				//______________________________________________________
			: ($menu.choice="createAVD")
				
				var $success : Boolean
				var $default : Object
				var $progress : cs:C1710.progress
				var $sdk : cs:C1710.sdkmanager
				var $package : 4D:C1709.Folder
				
				$default:=JSON Parse:C1218(File:C1566("/RESOURCES/android.json").getText()).device
				
				If ($default#Null:C1517)
					
					// * CHECK IF THE SYSTEM IMAGE IS AVAILABLE
					$sdk:=cs:C1710.sdkmanager.new()
					
					$package:=$sdk.exe.parent.parent.parent.folder(Split string:C1554($default.image; ";").join("/"))
					
					$success:=$package.exists
					
					If (Not:C34($success))
						
						// * DOWNLOAD SYTEM IMAGE
						$progress:=cs:C1710.progress.new("creatingADefaultDevice")\
							.setMessage("downloadInProgress")\
							.bringToFront()
						
						$success:=$sdk.install($default.image)
						
					End if 
					
					If ($success)
						
						cs:C1710.avd.new().createAvd($default)
						
						// * UPDATE DEVICE LIST
						CALL WORKER:C1389(Form:C1466.editor.$worker; "editor_GET_DEVICES"; New object:C1471(\
							"caller"; Form:C1466.editor.$mainWindow; "project"; PROJECT))
						
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
				
				$device:=Form:C1466.devices.apple.query("udid = :1"; $menu.choice).pop()
				
				// Set default simulator
				Form:C1466.currentDevice:=$menu.choice
				OBJECT SET TITLE:C194(*; "201"; $device.name)
				
				// #TO_OPTMIZE : deport to worker
				
				// Kill all booted devices, if any, & fix default
				var $simctl : cs:C1710.simctl
				$simctl:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget)
				//$simctl.shutdownAllDevices()
				$simctl.setDefaultDevice($menu.choice)
				
				PROJECT.$ios:=True:C214
				PROJECT._simulator:=$device.udid
				PROJECT.setTarget(True:C214; "ios")
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)[[:xdigit:]]{8}-[[:xdigit:]]{16}"; $menu.choice; 1))  // iOS Connected Device
				
				Form:C1466.editor.$xCode.canceled:=False:C215
				
				$device:=Form:C1466.devices.connected.apple.query("udid = :1"; $menu.choice).pop()
				
				// Set default simulator
				Form:C1466.currentDevice:=$menu.choice
				OBJECT SET TITLE:C194(*; "201"; $device.name)
				
				PROJECT.$ios:=True:C214
				PROJECT._simulator:=$device.udid
				PROJECT.setTarget(True:C214; "ios")
				
				//______________________________________________________
			: (FEATURE.with("android"))  // 🚧
				
				Form:C1466.editor.$studio.canceled:=False:C215
				
				$device:=Form:C1466.devices.android.query("udid = :1"; $menu.choice).pop()
				
				Form:C1466.currentDevice:=$menu.choice
				OBJECT SET TITLE:C194(*; "201"; $device.name)
				
				PROJECT.$android:=True:C214
				PROJECT._simulator:=$device.udid
				PROJECT.setTarget(True:C214; "android")
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(Not:C34(DATABASE.isMatrix))
				
				//______________________________________________________
		End case 
		
		var $pref : cs:C1710.preferences
		$pref:=cs:C1710.preferences.new().user("4D Mobile App.preferences")
		
		If (Length:C16($current)>0)\
			 & ($current#String:C10(Form:C1466.currentDevice))  // Keep
			
			$pref.set("simulator"; Form:C1466.currentDevice)
			
			// Adapt button width
			SET TIMER:C645(-1)
			
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 