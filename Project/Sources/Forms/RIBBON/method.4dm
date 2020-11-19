// ----------------------------------------------------
// Form method : RIBBON - (4D Mobile App)
// ID[8B32DFD842F7463C9AE0CFD578EAC514]
// Created 30-1-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $currentPage : Integer
var $device; $e; $form; $page; $plist : Object

// ----------------------------------------------------
// Initialisations
$form:=New object:C1471(\
"pages"; New collection:C1472; \
"switch"; UI.button("switch.button"); \
"build"; UI.button("151"); \
"simulator"; UI.button("201"); \
"project"; "152"; \
"install"; UI.button("153"); \
"start"; 16; \
"minWidth"; 110; \
"gap"; 7)

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

$form.sectionButtons:=UI.group("101;102;107;108;103;104;105;106")
$form.buildButtons:=UI.group("151;201;152;153")

$e:=FORM Event:C1606

// ----------------------------------------------------

Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		$form.build.disable()
		$form.install.disable()
		$form.simulator.disable()
		
		$form.sectionButtons.distributeHorizontally($form)
		
		If (Is macOS:C1572) & FEATURE.with("android")
			
			OBJECT SET FORMAT:C236(*; $form.build.name; ";;;;;;;;;;1")
			
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
		
		//______________________________________________________
	: ($e.code=On Page Change:K2:54)
		
		$currentPage:=FORM Get current page:C276(*)
		
		If (Form:C1466.initialized.indexOf($currentPage)=-1)
			
			Form:C1466.initialized.push($currentPage)
			
			Case of 
					
					//………………………………………………………………………………………
				: ($currentPage=1)
					
					$form.sectionButtons.distributeHorizontally($form)
					
					//………………………………………………………………………………………
				: ($currentPage=2)
					
					$form.buildButtons.distributeHorizontally($form)
					
					//………………………………………………………………………………………
			End case 
		End if 
		
		//______________________________________________________
	: ($e.code=On Bound Variable Change:K2:52)
		
		$form.switch.setFormat(";#images/toolbar/"+Choose:C955(Form:C1466.state="open"; "reduce"; "expand")+".png")
		
		For each ($page; $form.pages)
			
			(OBJECT Get pointer:C1124(Object named:K67:5; $page.button))->:=Num:C11($page.name=Form:C1466.page)
			
		End for each 
		
		If (Form:C1466.devices#Null:C1517)
			
			// Update device button
			If (Form:C1466.devices.length>0)
				
				$form.simulator.enable()
				
				// Get the default simulator
				$plist:=env_userPathname("preferences"; "com.apple.iphonesimulator.plist")
				
				If (Not:C34($plist.exists))
					
					simulator(New object:C1471(\
						"action"; "fixdefault"))
					
				End if 
				
				If ($plist.exists)
					
					$plist:=plist(New object:C1471(\
						"action"; "object"; \
						"domain"; $plist.path))
					
					If ($plist.success)
						
						// Keep the current device identifier
						Form:C1466.CurrentDeviceUDID:=$plist.value.CurrentDeviceUDID
						
						// Display the current device name
						$device:=Form:C1466.devices.query("udid = :1"; Form:C1466.CurrentDeviceUDID).pop()
						
						If ($device=Null:C1517)
							
							simulator(New object:C1471(\
								"action"; "getdefault"))
							
							$device:=Form:C1466.devices.query("udid = :1"; Form:C1466.CurrentDeviceUDID).pop()
							
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
		
		$form.build.setEnabled(Bool:C1537(Form:C1466.status.dataModel) & Bool:C1537(Form:C1466.status.xCode) & Bool:C1537(Form:C1466.status.project))
		$form.install.setEnabled(Bool:C1537(Form:C1466.status.dataModel) & Bool:C1537(Form:C1466.status.xCode) & Bool:C1537(Form:C1466.status.project) & Bool:C1537(Form:C1466.status.teamId))
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 