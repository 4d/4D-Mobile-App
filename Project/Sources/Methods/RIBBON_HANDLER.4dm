//%attributes = {"invisible":true}
// ----------------------------------------------------
// Form method : RIBBON - (4D Mobile App)
// ID[8B32DFD842F7463C9AE0CFD578EAC514]
// Created 30-1-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $lastDevice : Text
var $isDeviceSelected; $isDevToolAvailable; $isProjectOK; $withTeamID; $isSdkAvailable : Boolean
var $currentPage : Integer
var $constraints; $device; $e; $form; $o; $page; $plist : Object

// ----------------------------------------------------
// Initialisations
If (True:C214)
	
	$form:=New object:C1471(\
		"pages"; New collection:C1472; \
		"switch"; cs:C1710.button.new("switch.button"); \
		"build"; cs:C1710.button.new("151"); \
		"simulator"; cs:C1710.button.new("201"); \
		"project"; cs:C1710.button.new("152"); \
		"install"; cs:C1710.button.new("153")\
		)
	
	$form.pages.push(New object:C1471(\
		"name"; "general"; \
		"button"; "101"))
	
	$form.pages.push(New object:C1471(\
		"name"; "structure"; \
		"button"; "102"))
	
	$form.pages.push(New object:C1471(\
		"name"; "properties"; \
		"button"; "103"))
	
	$form.pages.push(New object:C1471(\
		"name"; "main"; \
		"button"; "104"))
	
	$form.pages.push(New object:C1471(\
		"name"; "views"; \
		"button"; "105"))
	
	$form.pages.push(New object:C1471(\
		"name"; "deployment"; \
		"button"; "106"))
	
	$form.pages.push(New object:C1471(\
		"name"; "data"; \
		"button"; "107"))
	
	$form.pages.push(New object:C1471(\
		"name"; "actions"; \
		"button"; "108"))
	
	$form.sectionButtons:=cs:C1710.group.new("101,102,107,108,103,104,105,106")
	
	$form.buildButtons:=cs:C1710.group.new("201,151,152,153")
	
	$constraints:=New object:C1471(\
		"start"; 16/* left margin */; \
		"minWidth"; 110/* minimum button width */; \
		"spacing"; 7/* button spacing */)
	
	$e:=FORM Event:C1606
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		$form.build.disable()
		$form.install.disable()
		$form.simulator.disable()
		
		$form.sectionButtons.distributeLeftToRight($constraints)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Unload:K2:2)
		
		//
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		If (Form:C1466.initialized=Null:C1517)
			
			Form:C1466.initialized:=New collection:C1472(1)
			Form:C1466.pages:=$form.pages
			
		End if 
		
		// * ADAPT BUTTONS WIDTH
		$form.buildButtons.distributeLeftToRight($constraints)
		
		// * BUILD & INSTALL BUTTON ACTIVATION
		Case of 
				
				//______________________________________________________
			: (Bool:C1537(UI.android)) & (Bool:C1537(UI.ios))
				
				If (UI.xCode#Null:C1517)
					
					$isDevToolAvailable:=Bool:C1537(UI.xCode.ready)
					
				End if 
				
				If (Not:C34($isDevToolAvailable))
					
					If (UI.studio#Null:C1517)
						
						$isDevToolAvailable:=Bool:C1537(UI.studio.ready)
						
					End if 
				End if 
				
				$isDeviceSelected:=(UI.currentDevice#Null:C1517)
				$isSdkAvailable:=cs:C1710.path.new().cacheSdkAndroidUnzipped().exists
				
				//______________________________________________________
			: (Bool:C1537(UI.ios))
				
				If (UI.xCode#Null:C1517)
					
					$isDevToolAvailable:=Bool:C1537(UI.xCode.ready)
					
				End if 
				
				If (UI.currentDevice#Null:C1517)
					
					$isDeviceSelected:=UI.devices.apple.copy().combine(UI.devices.plugged.apple).query("udid = :1"; UI.currentDevice).pop()#Null:C1517
					
				End if 
				
				$isSdkAvailable:=True:C214
				
				//______________________________________________________
			: (Bool:C1537(UI.android))
				
				If (UI.studio#Null:C1517)
					
					$isDevToolAvailable:=Bool:C1537(UI.studio.ready)
					
				End if 
				
				If (UI.currentDevice#Null:C1517)
					
					$isDeviceSelected:=UI.devices.android.copy().combine(UI.devices.plugged.android).query("udid = :1"; UI.currentDevice).pop()#Null:C1517
					
				End if 
				
				$isSdkAvailable:=cs:C1710.path.new().cacheSdkAndroidUnzipped().exists
				
				//______________________________________________________
		End case 
		
		If (Is macOS:C1572)
			
			// True if only android | teamID OK
			$withTeamID:=Choose:C955(Bool:C1537(UI.ios); Bool:C1537(UI.teamId); True:C214)
			
		Else 
			
			// No teamID so always true ;-)
			$withTeamID:=True:C214
			
		End if 
		
		If (UI.projectAudit#Null:C1517)
			
			$isProjectOK:=Bool:C1537(UI.projectAudit.success)
			
		End if 
		
		If (Not:C34($isDevToolAvailable & $isProjectOK & $isDeviceSelected & $withTeamID & $isSdkAvailable))  //#DEBUG LOG
			
			Logger.warning("project: "+Choose:C955($isProjectOK; "ok"; "NOT READY")\
				+" - devTools: "+Choose:C955($isDevToolAvailable; "ready"; "NOT READY")\
				+" - device: "+Choose:C955($isDeviceSelected; "ok"; "NO DEVICE SELECTED")\
				+" - teamID: "+Choose:C955($withTeamID; "ok"; "NO TEAM SELECTED")\
				+" - sdk: "+Choose:C955($isSdkAvailable; "ok"; "NO SDK"))
			
		End if 
		
		$form.build.enable($isDevToolAvailable & $isProjectOK & $isDeviceSelected & $isSdkAvailable)
		$form.install.enable($isDevToolAvailable & $isProjectOK & $withTeamID & $isDeviceSelected)
		
		// * UPDATE background toolbar color
		If (UI.darkScheme)
			
			OBJECT SET RGB COLORS:C628(*; "toolbar.background"; "#0D3648"; "#0D3648")
			
		Else 
			
			OBJECT SET RGB COLORS:C628(*; "toolbar.background"; "#1BA1E5"; "#1BA1E5")
			
		End if 
		
		//______________________________________________________
	: ($e.code=On Page Change:K2:54)
		
		$currentPage:=FORM Get current page:C276(*)
		
		If (Form:C1466.initialized.indexOf($currentPage)=-1)
			
			Form:C1466.initialized.push($currentPage)
			
			Case of 
					
					//………………………………………………………………………………………
				: ($currentPage=1)
					
					$form.sectionButtons.distributeLeftToRight($constraints)
					
					//………………………………………………………………………………………
				: ($currentPage=2)
					
					// <NOTHING MORE TO DO>
					
					//………………………………………………………………………………………
			End case 
		End if 
		
		SET TIMER:C645(-1)  // *UPDATE UI
		
		//______________________________________________________
	: ($e.code=On Bound Variable Change:K2:52)
		
		// * SET THE SWITCH BUTTON PICTURE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		$form.switch.setPicture("#images/toolbar/"+Choose:C955(Form:C1466.state="open"; "reduce"; "expand")+".png")
		
		// * UPDATE THE SECTION BUTTONS
		For each ($page; $form.pages)
			
			OBJECT SET VALUE:C1742($page.button; Num:C11($page.name=UI.currentPage))
			
		End for each 
		
		$form.simulator.foregroundColor:="dimgray"
		
		If (UI.devices#Null:C1517) & (UI.ios#Null:C1517) & (UI.android#Null:C1517)
			
			// * UPDATE DEVICE BUTTON
			$form.simulator.enable(UI.taskNotInProgress("getDevices"))
			
			Case of   //#DEBUG LOG
					
					//______________________________________________________
				: (Is Windows:C1573)
					
					If (UI.devices.android.length=0)
						
						Logger.warning("NO ANDROID SIMULATOR AVAILABLE")
						
					End if 
					
					//______________________________________________________
				: (UI.ios) & Not:C34(UI.android) & (UI.devices.apple.length=0)
					
					Logger.warning("NO IOS SIMULATOR AVAILABLE")
					
					//______________________________________________________
				: (UI.ios) & (UI.android)
					
					If (UI.devices.apple.length=0)\
						 & (UI.devices.android.length=0)
						
						Logger.warning("NO SIMULATOR AVAILABLE")
						
					Else 
						
						If (UI.devices.apple.length=0)
							
							Logger.warning("NO IOS SIMULATOR AVAILABLE")
							
						Else 
							
							If (UI.devices.android.length=0)
								
								Logger.warning("NO ANDROID SIMULATOR AVAILABLE")
								
							End if 
						End if 
					End if 
					
					//______________________________________________________
				: (UI.android) & (UI.devices.android.length=0)
					
					Logger.warning("NO ANDROID SIMULATOR AVAILABLE")
					
					//______________________________________________________
			End case 
			
			Case of   // * GET THE LAST SIMULATOR USED, IF KNOWN
					
					//______________________________________________________
				: (UI.ios & UI.android)
					
					$lastDevice:=String:C10(UI.preferences.get("lastDevice"))
					
					//______________________________________________________
				: (UI.ios)
					
					$lastDevice:=String:C10(UI.preferences.get("lastIosDevice"))
					
					//______________________________________________________
				: (UI.android)
					
					$lastDevice:=String:C10(UI.preferences.get("lastAndroidDevice"))
					
					//______________________________________________________
			End case 
			
			If (Length:C16($lastDevice)=0)  // * GET A DEFAULT IOS DEVICE
				
				
				If (Is macOS:C1572)\
					 & (UI.ios)\
					 & (UI.devices.apple.length>0)
					
					$lastDevice:=String:C10(cs:C1710.simctl.new(SHARED.iosDeploymentTarget).defaultDevice().udid)
					
				End if 
			End if 
			
			If (Length:C16($lastDevice)=0)  // * GET A DEFAULT ANDROID DEVICE
				
				If (UI.devices.android.length>0)
					
					// Select the first one
					$lastDevice:=UI.devices.android[0].udid
					
				End if 
			End if 
			
			If (Length:C16($lastDevice)>0)
				
				If (UI.devices.apple#Null:C1517)\
					 & (UI.devices.plugged.apple#Null:C1517)
					
					PROJECT._device:=UI.devices.apple.copy().combine(UI.devices.plugged.apple).query("udid = :1"; $lastDevice).pop()
					
				End if 
				
				If (PROJECT._device#Null:C1517)
					
					If (UI.ios)
						
						$form.simulator.title:=PROJECT._device.name
						UI.currentDevice:=$lastDevice
						PROJECT._buildTarget:="ios"
						PROJECT._simulator:=PROJECT._device.udid
						
					Else 
						
						$form.simulator.title:="select"
						$form.simulator.foregroundColor:=UI.errorRGB
						OB REMOVE:C1226(PROJECT; "_buildTarget")
						OB REMOVE:C1226(PROJECT; "_simulator")
						
					End if 
					
				Else 
					
					If (UI.devices.android#Null:C1517)\
						 & (UI.devices.plugged.android#Null:C1517)
						
						PROJECT._device:=UI.devices.android.copy().combine(UI.devices.plugged.android).query("udid = :1"; $lastDevice).pop()
						
					End if 
					
					If (PROJECT._device#Null:C1517)
						
						If (UI.android)
							
							$form.simulator.title:=PROJECT._device.name
							UI.currentDevice:=$lastDevice
							PROJECT._buildTarget:="android"
							PROJECT._simulator:=PROJECT._device.udid
							
						Else 
							
							$form.simulator.title:="select"
							$form.simulator.foregroundColor:=UI.errorRGB
							OB REMOVE:C1226(PROJECT; "_buildTarget")
							OB REMOVE:C1226(PROJECT; "_simulator")
							
						End if 
						
					Else 
						
						$form.simulator.title:="unknown"
						OB REMOVE:C1226(PROJECT; "_buildTarget")
						OB REMOVE:C1226(PROJECT; "_simulator")
						
					End if 
				End if 
				
			Else 
				
				$form.simulator.setTitle("unknown")
				OB REMOVE:C1226(PROJECT; "_buildTarget")
				OB REMOVE:C1226(PROJECT; "_simulator")
				OB REMOVE:C1226(PROJECT; "_device")
				
			End if 
			
			SET TIMER:C645(-1)  // *UPDATE UI
			
		Else 
			
			$form.simulator.disable()
			Logger.warning("Simulators button is disabled because EDITOR.devices is not yet available")
			
		End if 
		
		SET TIMER:C645(-1)  // *UPDATE UI
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 