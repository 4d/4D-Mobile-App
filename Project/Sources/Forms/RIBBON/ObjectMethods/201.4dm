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
			
			var $tab : Text
			$tab:="   "
			
			If (Is macOS:C1572)
				
				If (Form:C1466.status.xCode)
					
					$menu.append("iOS").disable()
					
					If (Form:C1466.devices.apple.length>0)
						
						For each ($device; Form:C1466.devices.apple)
							
							$menu.append($tab+$device.name; $device.udid)\
								.mark($device.udid=String:C10(Form:C1466.CurrentDeviceUDID))
							
						End for each 
					End if 
					
					$menu.line()
					
				End if 
				
				$menu.append($tab+Get localized string:C991("openTheXcodeSimulatorsManager"); "XcodeDeviceManager").enable((Form:C1466.status.xCode))
				
				If (Form:C1466.status.studio)
					
					$menu.line()
					
					$menu.append("Android").disable()
					
					If (Form:C1466.devices.android.length>0)
						
						For each ($device; Form:C1466.devices.android)
							
							$menu.append($tab+$device.name; $device.udid)\
								.mark($device.udid=String:C10(Form:C1466.CurrentDeviceUDID))
							
						End for each 
						
						$menu.line()
						
					End if 
				End if 
				
				$menu.append($tab+Get localized string:C991("openTheAvdManager"); "avdManager").enable((Form:C1466.status.studio))
				
			Else 
				
				If (Form:C1466.devices.android.length>0)
					
					For each ($device; Form:C1466.devices.android)
						
						$menu.append($device.name; $device.udid)\
							.mark($device.udid=String:C10(Form:C1466.CurrentDeviceUDID))
						
					End for each 
					
					$menu.line()
					
				End if 
				
				$menu.append(Get localized string:C991("openTheAvdManager"); "avdManager")
				
			End if 
			
		Else 
			
			If (Form:C1466.devices.length>0)
				
				For each ($device; Form:C1466.devices)
					
					$menu.append($device.name; $device.udid)\
						.mark($device.udid=String:C10(Form:C1466.CurrentDeviceUDID))
					
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
				
				POST_MESSAGE(New object:C1471(\
					"target"; Current form window:C827; \
					"action"; "show"; \
					"type"; "alert"; \
					"title"; "We are going tout doux 🤣"))
				
				//______________________________________________________
			: (Match regex:C1019("(?mi-s)^(?:[[:alnum:]]*-)*[[:alnum:]]*$"; $menu.choice; 1))  // iOS
				
				If ($menu.choice#String:C10(Form:C1466.CurrentDeviceUDID))
					
					If (FEATURE.with("android"))  // 🚧
						
						$device:=Form:C1466.devices.apple.query("udid = :1"; $menu.choice).pop()
						
					Else 
						
						// Old
						$device:=Form:C1466.devices.query("udid = :1"; $menu.choice).pop()
						
					End if 
					
					// Kill booted Simulator if any
					If (simulator(New object:C1471(\
						"action"; "kill")).success)
						
						If (plist(New object:C1471(\
							"action"; "write"; \
							"domain"; ENV.preferences("com.apple.iphonesimulator.plist").path; \
							"key"; "CurrentDeviceUDID"; \
							"value"; $menu.choice)).success)
							
							// Set default simulator
							Form:C1466.CurrentDeviceUDID:=$menu.choice
							
							// Set button title
							OBJECT SET TITLE:C194(*; "201"; $device.name)
							
						Else 
							
							POST_MESSAGE(New object:C1471(\
								"target"; Current form window:C827; \
								"action"; "show"; \
								"type"; "alert"; \
								"title"; ".Failed to set the default simulator to: \""+$device.name+"\""; \
								"additional"; ""))
							
						End if 
					End if 
				End if 
				
				//______________________________________________________
			Else 
				
				If (FEATURE.with("android"))  // 🚧
					
					$device:=Form:C1466.devices.android.query("udid = :1"; $menu.choice).pop()
					
					// Set default simulator
					Form:C1466.CurrentDeviceUDID:=$menu.choice
					
					// Set button title
					OBJECT SET TITLE:C194(*; "201"; $device.name)
					
				End if 
				
				//______________________________________________________
		End case 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 