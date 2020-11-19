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
		
		If (Form:C1466.devices.length>0)
			
			$menu:=cs:C1710.menu.new()
			
			For each ($device; Form:C1466.devices)
				
				$menu.append($device.name; $device.udid)\
					.mark($device.udid=String:C10(Form:C1466.CurrentDeviceUDID))
				
			End for each 
			
			// #TEMPO [
			If (Macintosh option down:C545)
				
				If (Not:C34(Is compiled mode:C492))  // This action could be added if there is no simulator
					
					$menu.line()\
						.append(".Show devices window"; "_showDevicesWindow")  //#MARK_LOCALIZE
					
				End if 
			End if 
			//]
			
			OBJECT GET COORDINATES:C663(*; $e.objectName; $left; $top; $right; $bottom)
			$menu.popup($left; $bottom)
			
			Case of 
					
					//______________________________________________________
				: (Not:C34($menu.selected))
					
					// Nothing selected
					
					//______________________________________________________
				: (Match regex:C1019("(?mi-s)^(?:[[:alnum:]]*-)*[[:alnum:]]*$"; $menu.choice; 1))  //simulator
					
					If ($menu.choice#String:C10(Form:C1466.CurrentDeviceUDID))
						
						$device:=Form:C1466.devices.query("udid = :1"; $menu.choice).pop()
						
						// Kill booted Simulator if any
						If (simulator(New object:C1471(\
							"action"; "kill")).success)
							
							If (plist(New object:C1471(\
								"action"; "write"; \
								"domain"; env_userPathname("preferences"; "com.apple.iphonesimulator.plist").path; \
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
				: ($menu.choice="_showDevicesWindow")
					
					cs:C1710.Xcode.new().showDevicesWindow()
					
					//______________________________________________________
				Else 
					
					ASSERT:C1129(False:C215; "Unknown menu action ("+$menu.choice+")")
					
					//______________________________________________________
			End case 
			
		Else 
			
			POST_MESSAGE(New object:C1471(\
				"target"; Current form window:C827; \
				"action"; "show"; \
				"type"; "alert"; \
				"title"; "noDevices"))
			
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 