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

If (FEATURE.with("android"))  //🚧
	
	$form.buildButtons:=cs:C1710.group.new("201,151,152,153")
	
Else 
	
	$form.buildButtons:=cs:C1710.group.new("151,201,152,153")
	
End if 

$constraints:=New object:C1471(\
"start"; 16/* left margin */; \
"minWidth"; 110/* minimum button width */; \
"spacing"; 7/* button spacing */)

$e:=FORM Event:C1606

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
		
		// *ADAPT BUTTONS WIDTH
		$form.buildButtons.distributeLeftToRight($constraints)
		
		// *BUILD BUTTON ACTIVATION
		If (FEATURE.with("android"))  //🚧
			
			Case of 
					
					//______________________________________________________
				: (Bool:C1537(EDITOR.android)) & (Bool:C1537(EDITOR.ios))
					
					$isDevToolAvailable:=Bool:C1537(EDITOR.xCode.ready) | Bool:C1537(EDITOR.studio.ready)
					$isDeviceSelected:=(EDITOR.currentDevice#Null:C1517)
					$isSdkAvailable:=cs:C1710.path.new().cacheSdkAndroidUnzipped().exists
					
					//______________________________________________________
				: (Bool:C1537(EDITOR.ios))
					
					$isDevToolAvailable:=Bool:C1537(EDITOR.xCode.ready)
					
					If (EDITOR.currentDevice#Null:C1517)
						
						$isDeviceSelected:=EDITOR.devices.apple.query("udid = :1"; EDITOR.currentDevice).pop()#Null:C1517
						
					End if 
					
					$isSdkAvailable:=True:C214
					
					//______________________________________________________
				: (Bool:C1537(EDITOR.android))
					
					$isDevToolAvailable:=Bool:C1537(EDITOR.studio.ready)
					
					If (EDITOR.currentDevice#Null:C1517)
						
						$isDeviceSelected:=EDITOR.devices.android.query("udid = :1"; EDITOR.currentDevice).pop()#Null:C1517
						
					End if 
					
					$isSdkAvailable:=cs:C1710.path.new().cacheSdkAndroidUnzipped().exists
					
					//______________________________________________________
			End case 
			
			If (Is macOS:C1572)
				
				// True if only android | teamID OK
				$withTeamID:=Choose:C955(Bool:C1537(EDITOR.ios); Bool:C1537(EDITOR.teamId); True:C214)
				
			Else 
				
				// No teamID so always true ;-)
				$withTeamID:=True:C214
				
			End if 
			
			If (EDITOR.projectAudit#Null:C1517)
				
				$isProjectOK:=Bool:C1537(EDITOR.projectAudit.success)
				
			End if 
			
			If (Not:C34($isDevToolAvailable & $isProjectOK & $isDeviceSelected & $withTeamID & $isSdkAvailable))
				
				RECORD.warning("project: "+Choose:C955($isProjectOK; "ok"; "NOT READY")\
					+" - devTools: "+Choose:C955($isDevToolAvailable; "ready"; "NOT READY")\
					+" - device: "+Choose:C955($isDeviceSelected; "ok"; "NO DEVICE SELECTED")\
					+" - teamID: "+Choose:C955($withTeamID; "ok"; "NO TEAM SELECTED")\
					+" - sdk: "+Choose:C955($isSdkAvailable; "ok"; "NO SDK"))
				
			Else 
				
				RECORD.info("project: ok - devTools: ready - device: ok - teamID: ok - sdk: ok")
				
			End if 
			
			$form.build.enable($isDevToolAvailable & $isProjectOK & $isDeviceSelected & $isSdkAvailable)
			
			// *INSTALL BUTTON ACTIVATION
			If (Is Windows:C1573)
				
				$form.install.disable()
				
			Else 
				
				If (Not:C34(Bool:C1537(EDITOR.ios)))
					
					$form.install.disable()
					
				Else 
					
					$form.install.enable($isDevToolAvailable & $isProjectOK & $withTeamID & $isDeviceSelected)
					
				End if 
			End if 
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
					
					If (FEATURE.with("android"))
						
						SET TIMER:C645(-1)  // *UPDATE UI
						
					Else 
						
						$form.buildButtons.distributeLeftToRight($constraints)
						
					End if 
					
					//………………………………………………………………………………………
			End case 
		End if 
		
		SET TIMER:C645(-1)  // *UPDATE UI
		
		//______________________________________________________
	: ($e.code=On Bound Variable Change:K2:52)
		
		// Set the switch button picture
		$form.switch.setPicture("#images/toolbar/"+Choose:C955(Form:C1466.state="open"; "reduce"; "expand")+".png")
		
		// Update the section buttons
		For each ($page; $form.pages)
			
			If (FEATURE.with("wizards"))
				
				OBJECT SET VALUE:C1742($page.button; Num:C11($page.name=EDITOR.currentPage))
				
			Else 
				
				OBJECT SET VALUE:C1742($page.button; Num:C11($page.name=Form:C1466.page))
				
			End if 
		End for each 
		
		$form.simulator.setColors("dimgray")
		
		If (EDITOR.devices#Null:C1517) & (EDITOR.ios#Null:C1517) & (EDITOR.android#Null:C1517)
			
			// *UPDATE DEVICE BUTTON
			If (FEATURE.with("android"))  //🚧
				
				$form.simulator.enable(EDITOR.taskNotInProgress("getDevices"))
				
				Case of   //#DEBUG LOG
						
						//______________________________________________________
					: (Is Windows:C1573)
						
						If (EDITOR.devices.android.length=0)
							
							RECORD.warning("NO ANDROID SIMULATOR AVAILABLE")
							
						End if 
						
						//______________________________________________________
					: (EDITOR.ios) & Not:C34(EDITOR.android) & (EDITOR.devices.apple.length=0)
						
						RECORD.warning("NO iOS SIMULATOR AVAILABLE")
						
						//______________________________________________________
					: (EDITOR.ios) & (EDITOR.android)
						
						If (EDITOR.devices.apple.length=0)\
							 & (EDITOR.devices.android.length=0)
							
							RECORD.warning("NO SIMULATOR AVAILABLE")
							
						Else 
							
							If (EDITOR.devices.apple.length=0)
								
								RECORD.warning("NO iOS SIMULATOR AVAILABLE")
								
							Else 
								
								If (EDITOR.devices.android.length=0)
									
									RECORD.warning("NO ANDROID SIMULATOR AVAILABLE")
									
								End if 
							End if 
						End if 
						
						//______________________________________________________
					: (EDITOR.android) & (EDITOR.devices.android.length=0)
						
						RECORD.warning("NO ANDROID SIMULATOR AVAILABLE")
						
						//______________________________________________________
				End case 
				
				// Get the last simulator used, if known
				Case of 
						//______________________________________________________
					: (EDITOR.ios & EDITOR.android)
						
						$lastDevice:=String:C10(EDITOR.preferences.get("simulator"))
						
						//______________________________________________________
					: (EDITOR.ios)
						
						$lastDevice:=String:C10(EDITOR.preferences.get("lastIosDevice"))
						
						//______________________________________________________
					: (EDITOR.android)
						
						$lastDevice:=String:C10(EDITOR.preferences.get("lastAndroidDevice"))
						
						//______________________________________________________
				End case 
				
				If (Length:C16($lastDevice)>0)
					
					$device:=EDITOR.devices.apple.query("udid = :1"; $lastDevice).pop()
					
					If ($device=Null:C1517) & (EDITOR.devices.connected.apple#Null:C1517)
						
						$device:=EDITOR.devices.connected.apple.query("udid = :1"; $lastDevice).pop()
						
					End if 
					
					If ($device#Null:C1517)
						
						If (EDITOR.ios)
							
							$form.simulator.setTitle($device.name)
							EDITOR.currentDevice:=$lastDevice
							
							PROJECT._buildTarget:="ios"
							PROJECT._simulator:=$device.udid
							
						Else 
							
							$form.simulator.setTitle("select").setColors(EDITOR.errorRGB)
							OB REMOVE:C1226(PROJECT; "_buildTarget")
							OB REMOVE:C1226(PROJECT; "_simulator")
							
						End if 
						
					Else 
						
						$device:=EDITOR.devices.android.query("udid = :1"; $lastDevice).pop()
						
						If ($device#Null:C1517)
							
							If (EDITOR.android)
								
								$form.simulator.setTitle($device.name)
								EDITOR.currentDevice:=$lastDevice
								PROJECT._buildTarget:="android"
								PROJECT._simulator:=$device.udid
								
							Else 
								
								$form.simulator.setTitle("select").setColors(EDITOR.errorRGB)
								OB REMOVE:C1226(PROJECT; "_buildTarget")
								OB REMOVE:C1226(PROJECT; "_simulator")
								
							End if 
							
						Else 
							
							$form.simulator.setTitle("unknown")
							OB REMOVE:C1226(PROJECT; "_buildTarget")
							OB REMOVE:C1226(PROJECT; "_simulator")
							
						End if 
					End if 
					
				Else 
					
					If (Is macOS:C1572)\
						 & (EDITOR.ios)\
						 & (EDITOR.devices.apple.length>0)
						
						// Get a default device identifier
						$lastDevice:=String:C10(cs:C1710.simctl.new(SHARED.iosDeploymentTarget).defaultDevice().udid)
						
						If (Length:C16($lastDevice)>0)
							
							$device:=EDITOR.devices.apple.query("udid = :1"; $lastDevice).pop()
							$form.simulator.setTitle($device.name)
							
							If ($device#Null:C1517)
								
								EDITOR.currentDevice:=$lastDevice
								
								// Keep
								EDITOR.preferences.set("simulator"; $device.udid)
								$form.simulator.setTitle($device.name)
								
							Else 
								
								$form.simulator.setTitle("unknown")
								
							End if 
							
						Else 
							
							$form.simulator.setTitle("unknown")
							
						End if 
						
					Else 
						
						If (EDITOR.devices.android.length>0)
							
							// Select the first one
							$device:=EDITOR.devices.android[0]
							EDITOR.preferences.set("simulator"; $device.udid)
							$form.simulator.setTitle($device.name)
							SET TIMER:C645(-1)  // *UPDATE UI
							
						Else 
							
							$form.simulator.setTitle("unknown")
							
						End if 
					End if 
				End if 
				
			Else 
				
				If (EDITOR.devices.length>0)
					
					$form.simulator.enable()
					
					// Get the default simulator
					$plist:=cs:C1710.path.new().userlibrary().file("Preferences/com.apple.iphonesimulator.plist")
					
					If (Not:C34($plist.exists))
						
						_o_simulator(New object:C1471(\
							"action"; "fixdefault"))
						
					End if 
					
					If ($plist.exists)
						
						$plist:=_o_plist(New object:C1471(\
							"action"; "object"; \
							"domain"; $plist.path))
						
						If ($plist.success)
							
							// Keep the current device identifier
							EDITOR.currentDevice:=$plist.value.currentDevice
							
							// Display the current device name
							$device:=EDITOR.devices.query("udid = :1"; EDITOR.currentDevice).pop()
							
							If ($device=Null:C1517)
								
								_o_simulator(New object:C1471(\
									"action"; "getdefault"))
								
								$device:=EDITOR.devices.query("udid = :1"; EDITOR.currentDevice).pop()
								
							End if 
							
							If ($device=Null:C1517)
								
								$form.simulator.setTitle("unknown")
								
							Else 
								
								$form.simulator.setTitle($device.name)
								
							End if 
						End if 
					End if 
				End if 
			End if 
			
		Else 
			
			$form.simulator.disable()
			RECORD.warning("Simulators button is disabled because EDITOR.devices is not yet available")
			
		End if 
		
		If (FEATURE.with("android"))  //🚧
			
			SET TIMER:C645(-1)  // *UPDATE UI
			
		Else 
			
			$o:=PROJECT.$project
			$form.build.enable(Bool:C1537($o.structure.dataModel) & Bool:C1537($o.xCode.ready) & Bool:C1537($o.status.project))
			$form.install.enable(Bool:C1537($o.structure.dataModel) & Bool:C1537($o.xCode.ready) & Bool:C1537($o.status.project) & Bool:C1537($o.status.teamId))
			
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 