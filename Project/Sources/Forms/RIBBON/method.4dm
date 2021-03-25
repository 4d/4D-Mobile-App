// ----------------------------------------------------
// Form method : RIBBON - (4D Mobile App)
// ID[8B32DFD842F7463C9AE0CFD578EAC514]
// Created 30-1-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $simulator : Text
var $isDeviceSelected; $isDevToolAvailable; $isProjectOK; $withTeamID : Boolean
var $currentPage : Integer
var $constraints; $device; $e; $form; $o; $page; $plist : Object
var $pref : cs:C1710.preferences

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
		
		If (Is macOS:C1572 & FEATURE.with("android"))  //🚧
			
			$form.install.setSeparatePopupMenu()
			
		End if 
		
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
		
		$form.buildButtons.distributeLeftToRight($constraints)
		
		If (FEATURE.with("android"))  //🚧
			
			$isProjectOK:=Bool:C1537(PROJECT.$project.status.project)
			
			Case of 
					//______________________________________________________
				: (Bool:C1537(PROJECT.$android)) & (Bool:C1537(PROJECT.$ios))
					
					$isDevToolAvailable:=Bool:C1537(Form:C1466.status.xCode) | Bool:C1537(Form:C1466.status.studio)
					$isDeviceSelected:=(Form:C1466.currentDevice#Null:C1517)
					
					//______________________________________________________
				: (Bool:C1537(PROJECT.$ios))
					
					$isDevToolAvailable:=Bool:C1537(Form:C1466.status.xCode)
					
					If (Form:C1466.currentDevice#Null:C1517)
						
						$isDeviceSelected:=Form:C1466.devices.apple.query("udid = :1"; Form:C1466.currentDevice).pop()#Null:C1517
						
					End if 
					
					//______________________________________________________
				: (Bool:C1537(PROJECT.$android))
					
					$isDevToolAvailable:=Bool:C1537(Form:C1466.status.studio)
					
					If (Form:C1466.currentDevice#Null:C1517)
						
						$isDeviceSelected:=Form:C1466.devices.android.query("udid = :1"; Form:C1466.currentDevice).pop()#Null:C1517
						
					End if 
					
					//______________________________________________________
			End case 
			
			$withTeamID:=Choose:C955(Is macOS:C1572; Bool:C1537(Form:C1466.status.teamId); True:C214)
			
			$form.build.enable($isDevToolAvailable & $isProjectOK & $isDeviceSelected)
			$form.install.enable($isDevToolAvailable & $isProjectOK & $withTeamID)
			
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
					
					$form.buildButtons.distributeLeftToRight($constraints)
					
					//………………………………………………………………………………………
			End case 
		End if 
		
		//______________________________________________________
	: ($e.code=On Bound Variable Change:K2:52)
		
		$form.switch.setPicture("#images/toolbar/"+Choose:C955(Form:C1466.state="open"; "reduce"; "expand")+".png")
		
		For each ($page; $form.pages)
			
			If (FEATURE.with("wizards"))
				
				OBJECT SET VALUE:C1742($page.button; Num:C11($page.name=Form:C1466.editor.$currentPage))
				
			Else 
				
				OBJECT SET VALUE:C1742($page.button; Num:C11($page.name=Form:C1466.page))
				
			End if 
		End for each 
		
		$form.simulator.setColors("dimgray")
		
		If (Form:C1466.devices#Null:C1517)
			
			// Update device button
			If (FEATURE.with("android"))  //🚧
				
				$form.simulator.enable((Form:C1466.devices.apple.length>0) | (Form:C1466.devices.android.length>0) | Is Windows:C1573)
				
				// Get the last simulator used, if known
				$pref:=cs:C1710.preferences.new().user("4D Mobile App.preferences")
				
				$simulator:=String:C10($pref.get("simulator"))
				
				If (Length:C16($simulator)>0)
					
					$device:=Form:C1466.devices.apple.query("udid = :1"; $simulator).pop()
					
					If ($device=Null:C1517) & (Form:C1466.devices.connected.apple#Null:C1517)
						
						$device:=Form:C1466.devices.connected.apple.query("udid = :1"; $simulator).pop()
						
					End if 
					
					If ($device#Null:C1517)
						
						If (PROJECT.$ios)
							
							$form.simulator.setTitle($device.name)
							Form:C1466.currentDevice:=$simulator
							
						Else 
							
							$form.simulator.setTitle("select").setColors(EDITOR.errorRGB)
							
						End if 
						
					Else 
						
						$device:=Form:C1466.devices.android.query("udid = :1"; $simulator).pop()
						
						If ($device#Null:C1517)
							
							If (PROJECT.$android)
								
								$form.simulator.setTitle($device.name)
								Form:C1466.currentDevice:=$simulator
								
							Else 
								
								$form.simulator.setTitle("select").setColors(EDITOR.errorRGB)
								
							End if 
							
						Else 
							
							$form.simulator.setTitle("unknown")
							
						End if 
					End if 
					
				Else 
					
					If (Is macOS:C1572)\
						 & (Bool:C1537(Form:C1466.editor.$ios))\
						 & (Form:C1466.devices.apple.length>0)
						
						// Get a default device identifier
						$simulator:=String:C10(cs:C1710.simctl.new(SHARED.iosDeploymentTarget).defaultDevice().udid)
						
						If (Length:C16($simulator)>0)
							
							$device:=Form:C1466.devices.apple.query("udid = :1"; $simulator).pop()
							$form.simulator.setTitle($device.name)
							
							If ($device#Null:C1517)
								
								Form:C1466.currentDevice:=$simulator
								
								// Keep
								$pref.set("simulator"; $device.udid)
								
								$form.simulator.setTitle($device.name)
								
							Else 
								
								$form.simulator.setTitle("unknown")
								
							End if 
							
						Else 
							
							$form.simulator.setTitle("unknown")
							
						End if 
						
					Else 
						
						$form.simulator.setTitle("unknown")
						
					End if 
				End if 
				
			Else 
				
				If (Form:C1466.devices.length>0)
					
					$form.simulator.enable()
					
					// Get the default simulator
					$plist:=ENV.preferences("com.apple.iphonesimulator.plist")
					
					If (Not:C34($plist.exists))
						
						_o_simulator(New object:C1471(\
							"action"; "fixdefault"))
						
					End if 
					
					If ($plist.exists)
						
						$plist:=plist(New object:C1471(\
							"action"; "object"; \
							"domain"; $plist.path))
						
						If ($plist.success)
							
							// Keep the current device identifier
							Form:C1466.currentDevice:=$plist.value.currentDevice
							
							// Display the current device name
							$device:=Form:C1466.devices.query("udid = :1"; Form:C1466.currentDevice).pop()
							
							If ($device=Null:C1517)
								
								_o_simulator(New object:C1471(\
									"action"; "getdefault"))
								
								$device:=Form:C1466.devices.query("udid = :1"; Form:C1466.currentDevice).pop()
								
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
			
			// Adapt button width
			SET TIMER:C645(-1)
			
		End if 
		
		If (FEATURE.with("android"))  //🚧
			
			SET TIMER:C645(-1)
			
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