  // ----------------------------------------------------
  // Form method : RIBBON - (4D Mobile App)
  // ID[8B32DFD842F7463C9AE0CFD578EAC514]
  // Created #30-1-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($l)
C_OBJECT:C1216($form;$o)

  // ----------------------------------------------------
  // Initialisations
$form:=New object:C1471(\
"event";Form event:C388;\
"pages";New collection:C1472;\
"switch";ui.button("switch.button");\
"build";ui.button("151");\
"simulator";ui.button("201");\
"project";"152";\
"install";ui.button("153");\
"start";16;\
"minWidth";110;\
"gap";7)

$form.pages.push(New object:C1471(\
"name";"general";\
"button";"101"))

$form.pages.push(New object:C1471(\
"name";"structure";\
"button";"102"))

$form.pages.push(New object:C1471(\
"name";"properties";\
"button";"103"))

$form.pages.push(New object:C1471(\
"name";"main";\
"button";"104"))

$form.pages.push(New object:C1471(\
"name";"views";\
"button";"105"))

$form.pages.push(New object:C1471(\
"name";"deployment";\
"button";"106"))

$form.pages.push(New object:C1471(\
"name";"data";\
"button";"107"))

  //If (Bool(featuresFlags._103505))

$form.pages.push(New object:C1471(\
"name";"actions";\
"button";"108"))

$form.sectionButtons:=ui.group("101;102;107;108;103;104;105;106")

  //Else 

  //$form.sectionButtons:=ui.group("101;102;107;103;104;105;106")

  //End if 

$form.buildButtons:=ui.group("151;201;152;153")

  // ----------------------------------------------------

Case of 
		
		  //______________________________________________________
	: ($form.event=On Load:K2:1)
		
		$form.build.disable()
		$form.install.disable()
		$form.simulator.disable()
		
		  //OBJECT SET VISIBLE(*;"108";Bool(featuresFlags._103505))
		
		$form.sectionButtons.distributeHorizontally($form)
		
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($form.event=On Unload:K2:2)
		
		  //
		
		  //______________________________________________________
	: ($form.event=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		If (Form:C1466.initialized=Null:C1517)
			
			Form:C1466.initialized:=New collection:C1472(1)
			
			Form:C1466.pages:=$form.pages
			
		End if 
		
		  //______________________________________________________
	: ($form.event=On Page Change:K2:54)
		
		$l:=FORM Get current page:C276(*)
		
		If (Form:C1466.initialized.indexOf($l)=-1)
			
			Form:C1466.initialized.push($l)
			
			Case of 
					
					  //………………………………………………………………………………………
				: ($l=1)
					
					$form.sectionButtons.distributeHorizontally($form)
					
					  //………………………………………………………………………………………
				: ($l=2)
					
					$form.buildButtons.distributeHorizontally($form)
					
					  // Place the popup icons
					$l:=widget ("201").coordinates.right-13
					$o:=widget ("201.PopUp")
					$o.setCoordinates($l;$o.coordinates.top;$l+$o.coordinates.width;$o.coordinates.top+$o.coordinates.height)
					
					$l:=widget ("152").coordinates.right-13
					$o:=widget ("152.PopUp")
					$o.setCoordinates($l;$o.coordinates.top;$l+$o.coordinates.width;$o.coordinates.top+$o.coordinates.height)
					
					  //………………………………………………………………………………………
			End case 
		End if 
		
		  //______________________________________________________
	: ($form.event=On Bound Variable Change:K2:52)
		
		$form.switch.setFormat(";#images/toolbar/"+Choose:C955(Form:C1466.state="open";"reduce";"expand")+".png")
		
		For each ($o;$form.pages)
			
			(OBJECT Get pointer:C1124(Object named:K67:5;$o.button))->:=Num:C11($o.name=Form:C1466.page)
			
		End for each 
		
		If (Form:C1466.devices#Null:C1517)
			
			  // Update device button
			If (Form:C1466.devices.length>0)
				
				$form.simulator.enable()
				
				  // Get the default simulator
				$o:=env_userPathname ("preferences";"com.apple.iphonesimulator.plist")
				
				If (Not:C34($o.exists))
					
					simulator (New object:C1471(\
						"action";"fixdefault"))
					
				End if 
				
				If ($o.exists)
					
					$o:=plist (New object:C1471(\
						"action";"object";\
						"domain";$o.path))
					
					If ($o.success)
						
						  // Keep the current device identifier
						Form:C1466.CurrentDeviceUDID:=$o.value.CurrentDeviceUDID
						
						  // Display the current device name
						$l:=Form:C1466.devices.extract("udid").indexOf(Form:C1466.CurrentDeviceUDID)
						$form.simulator.setTitle(Choose:C955($l=-1;Get localized string:C991("unknown");Form:C1466.devices[$l].name))
						
					End if 
				End if 
			End if 
		End if 
		
		$form.build.setEnabled(Bool:C1537(Form:C1466.status.dataModel) & Bool:C1537(Form:C1466.status.xCode) & Bool:C1537(Form:C1466.status.project))
		$form.install.setEnabled(Bool:C1537(Form:C1466.status.dataModel) & Bool:C1537(Form:C1466.status.xCode) & Bool:C1537(Form:C1466.status.project) & Bool:C1537(Form:C1466.status.teamId))
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($form.event)+")")
		
		  //______________________________________________________
End case 