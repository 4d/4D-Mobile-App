  // ----------------------------------------------------
  // Form method : RIBBON - (4D Mobile App)
  // ID[8B32DFD842F7463C9AE0CFD578EAC514]
  // Created #30-1-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_device;$Lon_formEvent;$Lon_page)
C_TEXT:C284($File_plist)
C_OBJECT:C1216($Obj_form;$Obj_page;$Obj_widget;$Obj_simulator)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event:C388

$Obj_form:=New object:C1471(\
"pages";New collection:C1472;\
"build";"151";\
"simulator";"201";\
"project";"152";\
"install";"153";\
"start";16;\
"minWidth";110;\
"gap";7)

$Obj_form.pages.push(New object:C1471(\
"name";"general";\
"button";"101"))
$Obj_form.pages.push(New object:C1471(\
"name";"structure";\
"button";"102"))
$Obj_form.pages.push(New object:C1471(\
"name";"properties";\
"button";"103"))
$Obj_form.pages.push(New object:C1471(\
"name";"main";\
"button";"104"))
$Obj_form.pages.push(New object:C1471(\
"name";"views";\
"button";"105"))
$Obj_form.pages.push(New object:C1471(\
"name";"deployment";\
"button";"106"))

  //If (Bool(featuresFlags._100174))

$Obj_form.pages.push(New object:C1471(\
"name";"data";\
"button";"107"))

  //End if 

If (Bool:C1537(featuresFlags._103505))
	
	$Obj_form.pages.push(New object:C1471(\
		"name";"actions";\
		"button";"108"))
	
End if 

  // ----------------------------------------------------

Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		OBJECT SET ENABLED:C1123(*;$Obj_form.build;False:C215)
		OBJECT SET ENABLED:C1123(*;$Obj_form.install;False:C215)
		OBJECT SET ENABLED:C1123(*;$Obj_form.simulator;False:C215)
		
		  //If (Bool(featuresFlags._100174))
		  //OBJECT SET VISIBLE(*;"107";True)
		
		If (Bool:C1537(featuresFlags._103505))
			
			OBJECT SET VISIBLE:C603(*;"108";True:C214)
			
			ui_TOOLBAR_ALIGN (New object:C1471(\
				"widgets";New collection:C1472("101";"102";"107";"108";"103";"104";"105";"106");\
				"start";$Obj_form.start;\
				"minWidth";$Obj_form.minWidth;\
				"gap";$Obj_form.gap))
			
		Else 
			
			ui_TOOLBAR_ALIGN (New object:C1471(\
				"widgets";New collection:C1472("101";"102";"107";"103";"104";"105";"106");\
				"start";$Obj_form.start;\
				"minWidth";$Obj_form.minWidth;\
				"gap";$Obj_form.gap))
			
		End if 
		
		  //Else 
		  //ui_TOOLBAR_ALIGN (New object(\
			"widgets";New collection("101";"102";"103";"104";"105";"106");\
			"start";$Obj_form.start;\
			"minWidth";$Obj_form.minWidth;\
			"gap";$Obj_form.gap))
		  //End if 
		
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Unload:K2:2)
		
		  //
		
		  //______________________________________________________
	: ($Lon_formEvent=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		If (Form:C1466.initialized=Null:C1517)
			
			Form:C1466.initialized:=New collection:C1472(1)
			
			Form:C1466.pages:=$Obj_form.pages
			
		End if 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Page Change:K2:54)
		
		$Lon_page:=FORM Get current page:C276(*)
		
		If (Form:C1466.initialized.indexOf($Lon_page)=-1)
			
			Form:C1466.initialized.push($Lon_page)
			
			Case of 
					
					  //………………………………………………………………………………………
				: ($Lon_page=1)
					
					  //If (Bool(featuresFlags._100174))
					
					OBJECT SET VISIBLE:C603(*;"107";True:C214)
					
					If (Bool:C1537(featuresFlags._103505))
						
						OBJECT SET VISIBLE:C603(*;"108";True:C214)
						
						ui_TOOLBAR_ALIGN (New object:C1471(\
							"widgets";New collection:C1472("101";"102";"107";"108";"103";"104";"105";"106");\
							"start";$Obj_form.start;\
							"minWidth";$Obj_form.minWidth;\
							"gap";$Obj_form.gap))
						
					Else 
						
						ui_TOOLBAR_ALIGN (New object:C1471(\
							"widgets";New collection:C1472("101";"102";"107";"103";"104";"105";"106");\
							"start";$Obj_form.start;\
							"minWidth";$Obj_form.minWidth;\
							"gap";$Obj_form.gap))
						
					End if 
					
					  //Else 
					
					  //ui_TOOLBAR_ALIGN (New object(\
						"widgets";New collection("101";"102";"103";"104";"105";"106");\
						"start";$Obj_form.start;\
						"minWidth";$Obj_form.minWidth;\
						"gap";$Obj_form.gap))
					
					  //End if 
					
					  //………………………………………………………………………………………
				: ($Lon_page=2)
					
					ui_TOOLBAR_ALIGN (New object:C1471(\
						"widgets";New collection:C1472("151";"201";"152";"153");\
						"start";$Obj_form.start;\
						"minWidth";$Obj_form.minWidth;\
						"gap";$Obj_form.gap))
					
					  // Place the popup icons
					$Obj_widget:=widgetProperties ("201.PopUp")
					$Obj_widget.left:=widgetProperties ("201").right-13
					OBJECT SET COORDINATES:C1248(*;"201.PopUp";$Obj_widget.left;$Obj_widget.top;$Obj_widget.left+$Obj_widget.width;$Obj_widget.top+$Obj_widget.height)
					
					$Obj_widget:=widgetProperties ("152.PopUp")
					$Obj_widget.left:=widgetProperties ("152").right-13
					OBJECT SET COORDINATES:C1248(*;"152.PopUp";$Obj_widget.left;$Obj_widget.top;$Obj_widget.left+$Obj_widget.width;$Obj_widget.top+$Obj_widget.height)
					
					  //………………………………………………………………………………………
			End case 
		End if 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Bound Variable Change:K2:52)
		
		OBJECT SET FORMAT:C236(*;"switch.button";";#images/toolbar/"+Choose:C955(Form:C1466.state="open";"reduce";"expand")+".png")
		
		For each ($Obj_page;$Obj_form.pages)
			
			(OBJECT Get pointer:C1124(Object named:K67:5;$Obj_page.button))->:=Num:C11($Obj_page.name=Form:C1466.page)
			
		End for each 
		
		If (Form:C1466.devices#Null:C1517)
			
			  // Update device button
			If (Form:C1466.devices.length>0)
				
				OBJECT SET ENABLED:C1123(*;$Obj_form.simulator;True:C214)
				
				  // Get the default simulator
				$File_plist:=_o_env_userPath ("preferences")+"com.apple.iphonesimulator.plist"
				
				If (Test path name:C476($File_plist)#Is a document:K24:1)
					
					simulator (New object:C1471(\
						"action";"fixdefault"))
					
				End if 
				
				If (Test path name:C476($File_plist)=Is a document:K24:1)
					
					$Obj_simulator:=plist (New object:C1471(\
						"action";"object";\
						"domain";Convert path system to POSIX:C1106($File_plist)))
					
					If ($Obj_simulator.success)
						
						  // Keep the current device identifier
						Form:C1466.CurrentDeviceUDID:=$Obj_simulator.value.CurrentDeviceUDID
						
						  // Display the current device name
						$Lon_device:=Form:C1466.devices.extract("udid").indexOf(Form:C1466.CurrentDeviceUDID)
						
						If ($Lon_device#-1)
							
							OBJECT SET TITLE:C194(*;$Obj_form.simulator;Form:C1466.devices[$Lon_device].name)
							
						Else 
							
							OBJECT SET TITLE:C194(*;$Obj_form.simulator;Get localized string:C991("unknown"))
							
						End if 
					End if 
				End if 
			End if 
		End if 
		
		
		  // ASSERT(Not(Shift down)) #ASK VDL, maybe a Trace
		
		  // Button build & run
		
		
		
		
		OBJECT SET ENABLED:C1123(*;$Obj_form.build;Bool:C1537(Form:C1466.status.dataModel) & Bool:C1537(Form:C1466.status.xCode) & Bool:C1537(Form:C1466.status.project))
		
		OBJECT SET ENABLED:C1123(*;$Obj_form.install;Bool:C1537(Form:C1466.status.dataModel) & Bool:C1537(Form:C1466.status.xCode) & Bool:C1537(Form:C1466.status.project) & Bool:C1537(Form:C1466.status.teamId))
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 