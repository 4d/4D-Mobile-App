// ----------------------------------------------------
// Object method : RIBBON.201 - (4D Mobile App)
// ID[6815D0201FC24AF6A6763A5CFDD4B233]
// Created 31-1-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($bottom; $left; $right; $top)
C_OBJECT:C1216($e; $menu; $o)

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($e.code=On Mouse Enter:K2:33)
		
		RIBBON(Num:C11(OBJECT Get name:C1087(Object current:K67:2)))
		
		//______________________________________________________
	: ($e.code=On Mouse Leave:K2:34)
		
		RIBBON(Num:C11(OBJECT Get name:C1087(Object current:K67:2)))
		
		//______________________________________________________
	: ($e.code=On Clicked:K2:4)
		
		If (Form:C1466.devices.length>0)
			
			$menu:=cs:C1710.menu.new()
			
			For each ($o; Form:C1466.devices)
				
				$menu.append($o.name; $o.udid)\
					.property("name"; $o.name)\
					.mark($o.udid=String:C10(Form:C1466.CurrentDeviceUDID))
				
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
				: (Match regex:C1019("(?mi-s)^(?:[[:alnum:]]*-)*[[:alnum:]]*$"; $menu.choice; 1))
					
					If ($menu.choice#String:C10(Form:C1466.CurrentDeviceUDID))
						
						// Kill booted Simulator if any…
						If (simulator(New object:C1471(\
							"action"; "kill")).success)
							
							// …Set default simulator
							$o:=plist(New object:C1471(\
								"action"; "write"; \
								"domain"; env_userPathname("preferences"; "com.apple.iphonesimulator.plist").path; \
								"key"; "CurrentDeviceUDID"; \
								"value"; $menu.choice))
							
							Form:C1466.CurrentDeviceUDID:=$menu.choice
							
							For each ($o; Form:C1466.devices)
								
								If ($o.udid=Form:C1466.CurrentDeviceUDID)
									
									OBJECT SET TITLE:C194(*; "201"; $o.name)
									
								End if 
							End for each 
						End if 
					End if 
					
					//______________________________________________________
				: ($menu.choice="_showDevicesWindow")
					
					$o:=Xcode(New object:C1471(\
						"action"; "showDevicesWindow"))
					
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
				"title"; "noDevices"; \
				"additional"; ""))
			
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 