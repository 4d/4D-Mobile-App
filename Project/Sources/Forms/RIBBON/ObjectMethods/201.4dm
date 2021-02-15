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
			$tab:="   "
			
			If (Is macOS:C1572)
				
				If (Form:C1466.status.xCode)
					
					$menu.append("iosSimulators").icon("images/os/iOS.png").disable()
					
					If (Form:C1466.devices.apple.length>0)
						
						For each ($device; Form:C1466.devices.apple)
							
							$menu.append($tab+$device.name; $device.udid)\
								.mark($device.udid=$current)
							
						End for each 
					End if 
					
					$menu.line()
					
				End if 
				
				$menu.append($tab+Get localized string:C991("openTheXcodeSimulatorsManager"); "XcodeDeviceManager").enable((Form:C1466.status.xCode))
				
				$menu.line()
				
				$menu.append("androidSimulators").icon("images/os/android.png").disable()
				
				If (Form:C1466.status.studio)
					
					If (Form:C1466.devices.android.length>0)
						
						For each ($device; Form:C1466.devices.android)
							
							$menu.append($tab+$device.name; $device.udid)\
								.mark($device.udid=$current).enable(Not:C34($device.missingSystemImage))
							
						End for each 
						
						$menu.line()
						
					End if 
				End if 
				
				$menu.append($tab+Get localized string:C991("openTheAvdManager"); "avdManager").enable((Form:C1466.status.studio))
				
			Else 
				
				If (Form:C1466.devices.android.length>0)
					
					For each ($device; Form:C1466.devices.android)
						
						$menu.append($device.name; $device.udid)\
							.mark($device.udid=String:C10(Form:C1466.currentDevice))
						
					End for each 
					
					$menu.line()
					
				End if 
				
				$menu.append(Get localized string:C991("openTheAvdManager"); "avdManager")
				
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
				
				//______________________________________________________
			: ($menu.choice="XcodeDeviceManager")
				
				cs:C1710.Xcode.new().showDevicesWindow()
				
				//______________________________________________________
			: ($menu.choice="avdManager")
				
				cs:C1710.studio.new().open()
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)[[:xdigit:]]{8}-(?:[[:xdigit:]]{4}-){3}[[:xdigit:]]{12}"; $menu.choice; 1))
				
				$device:=Form:C1466.devices.apple.query("udid = :1"; $menu.choice).pop()
				
				// Set default simulator
				Form:C1466.currentDevice:=$menu.choice
				OBJECT SET TITLE:C194(*; "201"; $device.name)
				
				// #TO_OPTMIZE : deport to worker
				
				// Kill all booted devices, if any, & fix default
				var $simctl : cs:C1710.simctl
				$simctl:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget)
				$simctl.shutdownAllDevices()
				$simctl.setDefaultDevice($menu.choice)
				
				PROJECT.$ios:=True:C214
				PROJECT.setTarget(True:C214)
				
				//______________________________________________________
			: (FEATURE.with("android"))  // 🚧
				
				$device:=Form:C1466.devices.android.query("udid = :1"; $menu.choice).pop()
				
				Form:C1466.currentDevice:=$menu.choice
				OBJECT SET TITLE:C194(*; "201"; $device.name)
				
				PROJECT.$android:=True:C214
				PROJECT.setTarget(True:C214)
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(Not:C34(DATABASE.isMatrix))
				
				//______________________________________________________
		End case 
		
		var $pref : cs:C1710.preferences
		$pref:=cs:C1710.preferences.new().user("4D Mobile App.preferences")
		
		If ($current#String:C10(Form:C1466.currentDevice))  // Keep
			
			$pref.set("simulator"; Form:C1466.currentDevice)
			
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 