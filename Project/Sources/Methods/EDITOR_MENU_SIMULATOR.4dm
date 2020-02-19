//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : EDITOR_MENU_SIMULATOR
  // ID[DB185EEA63C84B94B8B4A49475714BE9]
  // Created 6-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Mnu_choice;$Mnu_pop;$Txt_UDID)
C_OBJECT:C1216($o;$Obj_device;$Obj_simulator;$Path_plist)

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Mnu_pop:=Create menu:C408

  // Get the default simulator [
$Path_plist:=env_userPathname ("preferences";"com.apple.iphonesimulator.plist")

If ($Path_plist.exists)
	
	$Obj_simulator:=plist (New object:C1471(\
		"action";"object";\
		"domain";$Path_plist.path))
	
	If ($Obj_simulator.success)
		
		$Txt_UDID:=$Obj_simulator.value.CurrentDeviceUDID
		
	End if 
End if 
  //]

  // Device list
$o:=simulator (New object:C1471(\
"action";"devices";\
"minimumVersion";SHARED.iosDeploymentTarget;\
"filter";"available"))

If ($o.success)
	
	If ($o.devices.length>0)
		
		For each ($Obj_device;$o.devices)
			
			If ($Obj_device.state="Booted")
				
				$Obj_device.name:=$Obj_device.name+Get localized string:C991("booted")
				
			End if 
			
			APPEND MENU ITEM:C411($Mnu_pop;$Obj_device.name;*)
			
			SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;$Obj_device.udid)
			
			If ($Obj_device.udid=$Txt_UDID)
				
				SET MENU ITEM MARK:C208($Mnu_pop;-1;Char:C90(18))
				
			End if 
		End for each 
		
		If (Macintosh option down:C545)
			
			If (Not:C34(Is compiled mode:C492))  // This action could be added if there is no simulator
				
				APPEND MENU ITEM:C411($Mnu_pop;"-")
				
				APPEND MENU ITEM:C411($Mnu_pop;".Show devices window")
				SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"_showDevicesWindow")
				
			End if 
		End if 
		
		$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_pop)
		RELEASE MENU:C978($Mnu_pop)
		
	Else 
		
		POST_FORM_MESSAGE (New object:C1471(\
			"target";Current form window:C827;\
			"action";"show";\
			"type";"alert";\
			"title";"noDevices";\
			"additional";""))
		
	End if 
End if 

Case of 
		
		  //______________________________________________________
	: (Length:C16($Mnu_choice)=0)
		
		  // Nothing selected
		
		  //______________________________________________________
	: (Match regex:C1019("(?mi-s)^(?:[[:alnum:]]*-)*[[:alnum:]]*$";$Mnu_choice;1))
		
		If ($Mnu_choice#$Txt_UDID)
			
			  // Kill booted Simulator if any
			simulator (New object:C1471(\
				"action";"kill"))
			
			  // Set default simulator
			If ($Obj_simulator.success)
				
				$Obj_simulator:=plist (New object:C1471(\
					"action";"write";\
					"domain";$Path_plist.path;\
					"key";"CurrentDeviceUDID";\
					"value";$Mnu_choice))
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($Mnu_choice="_showDevicesWindow")
		
		$o:=Xcode (New object:C1471(\
			"action";"showDevicesWindow"))
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown menu action ("+$Mnu_choice+")")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End