  // ----------------------------------------------------
  // Object method : RIBBON.201 - (4D Mobile App)
  // ID[6815D0201FC24AF6A6763A5CFDD4B233]
  // Created #31-1-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_bottom;$Lon_formEvent;$Lon_left;$Lon_right;$Lon_top)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Mnu_choice;$Mnu_pop;$Txt_me)
C_OBJECT:C1216($Obj_device;$Obj_result;$Obj_simulator)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Mouse Enter:K2:33)
		
		RIBBON (Num:C11(OBJECT Get name:C1087(Object current:K67:2)))
		
		  //______________________________________________________
	: ($Lon_formEvent=On Mouse Leave:K2:34)
		
		RIBBON (Num:C11(OBJECT Get name:C1087(Object current:K67:2)))
		
		  //______________________________________________________
	: ($Lon_formEvent=On Clicked:K2:4)
		
		If (Form:C1466.devices.length>0)
			
			$Mnu_pop:=Create menu:C408
			
			For each ($Obj_device;Form:C1466.devices)
				
				APPEND MENU ITEM:C411($Mnu_pop;$Obj_device.name;*)
				SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;$Obj_device.udid)
				SET MENU ITEM PROPERTY:C973($Mnu_pop;-1;"name";$Obj_device.name)
				
				If ($Obj_device.udid=String:C10(Form:C1466.CurrentDeviceUDID))
					
					SET MENU ITEM MARK:C208($Mnu_pop;-1;Char:C90(18))
					
				End if 
			End for each 
			
			  // #TEMPO [
			If (Macintosh option down:C545)
				
				If (Not:C34(Is compiled mode:C492))  // This action could be added if there is no simulator
					
					APPEND MENU ITEM:C411($Mnu_pop;"-")
					
					APPEND MENU ITEM:C411($Mnu_pop;".Show devices window")  //#MARK_LOCALIZE
					SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"_showDevicesWindow")
					
				End if 
			End if 
			  //]
			
			OBJECT GET COORDINATES:C663(*;$Txt_me;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
			
			$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_pop;"";$Lon_left;$Lon_bottom)
			RELEASE MENU:C978($Mnu_pop)
			
			Case of 
					
					  //______________________________________________________
				: (Length:C16($Mnu_choice)=0)
					
					  // Nothing selected
					
					  //______________________________________________________
				: (Match regex:C1019("(?mi-s)^(?:[[:alnum:]]*-)*[[:alnum:]]*$";$Mnu_choice;1))
					
					If ($Mnu_choice#String:C10(Form:C1466.CurrentDeviceUDID))
						
						  // Kill booted Simulator if any…
						If (simulator (New object:C1471(\
							"action";"kill")).success)
							
							  // …Set default simulator
							$Obj_simulator:=plist (New object:C1471(\
								"action";"write";\
								"domain";env_userPathname ("preferences";"com.apple.iphonesimulator.plist").path;\
								"key";"CurrentDeviceUDID";\
								"value";$Mnu_choice))
							
							Form:C1466.CurrentDeviceUDID:=$Mnu_choice
							
							For each ($Obj_device;Form:C1466.devices)
								
								If ($Obj_device.udid=Form:C1466.CurrentDeviceUDID)
									
									OBJECT SET TITLE:C194(*;"201";$Obj_device.name)
									
								End if 
							End for each 
						End if 
					End if 
					
					  //______________________________________________________
				: ($Mnu_choice="_showDevicesWindow")
					
					$Obj_result:=Xcode (New object:C1471(\
						"action";"showDevicesWindow"))
					
					  //______________________________________________________
				Else 
					
					ASSERT:C1129(False:C215;"Unknown menu action ("+$Mnu_choice+")")
					
					  //______________________________________________________
			End case 
			
		Else 
			
			POST_FORM_MESSAGE (New object:C1471(\
				"target";Current form window:C827;\
				"action";"show";\
				"type";"alert";\
				"title";"noDevices";\
				"additional";""))
			
		End if 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 