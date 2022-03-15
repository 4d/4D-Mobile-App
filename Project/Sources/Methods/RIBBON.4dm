//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : RIBBON
// ID[C18FAF21205D45159B317262630D79D2]
// Created 30-1-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Main method of toolbar management
// ----------------------------------------------------
// Declarations
var $1 : Integer

var $bottom; $button; $left; $right; $top : Integer
var $e : Object

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606

// Optional parameters
If (Count parameters:C259>=1)
	
	$button:=$1
	
Else 
	
	$button:=Num:C11($e.objectName)
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($e.code=On Mouse Enter:K2:33)
		
		If ($button<100)  // Tabs
			
			If (Form:C1466.tab=$e.objectName)
				
				// Highlights
				OBJECT SET RGB COLORS:C628(*; $e.objectName; EDITOR.selectedColor)
				
			Else 
				
				OBJECT SET RGB COLORS:C628(*; $e.objectName; Foreground color:K23:1)
				
			End if 
			
		Else 
			
			If (OBJECT Get enabled:C1079(*; $e.objectName))
				
				// Highlights
				OBJECT SET RGB COLORS:C628(*; $e.objectName; EDITOR.selectedColor)
				
				Case of 
						
						//__________________________________
					: ($e.objectName="151")  // Build & run
						
						OBJECT SET HELP TIP:C1181(*; $e.objectName; Get localized string:C991("bRunTip"))
						
						//__________________________________
					: ($e.objectName="153")  // Install
						
						OBJECT SET HELP TIP:C1181(*; $e.objectName; Get localized string:C991("bInstallTip"))
						
						//__________________________________
				End case 
				
			Else 
				
				Case of 
						
						//__________________________________
					: ($e.objectName="151")  // Build & run
						
						Case of 
								
								//…………………………………………………………………………………
							: (Not:C34(Bool:C1537(Form:C1466.status.project)))
								
								OBJECT SET HELP TIP:C1181(*; $e.objectName; Get localized string:C991("someResourcesAreMissingOrInvalid"))
								
								//…………………………………………………………………………………
							: (Not:C34(Bool:C1537(Form:C1466.status.xCode)))
								
								If (Is macOS:C1572)
									
									//#MARK_TODO: Il faut soit l'environnement xCode soit l'environnement Android
									OBJECT SET HELP TIP:C1181(*; $e.objectName; Get localized string:C991("youNeedXcodeToPerformThisOperation"))
									
								Else 
									
									//#MARK_LOCALIZE
									OBJECT SET HELP TIP:C1181(*; $e.objectName; ".Android's development environment is not ready.")
									
								End if 
								
								//…………………………………………………………………………………
							: (Not:C34(Bool:C1537(Form:C1466.status.dataModel)))
								
								OBJECT SET HELP TIP:C1181(*; $e.objectName; Get localized string:C991("youMustPublishAtLeastOneFieldToPerformThisOperation"))
								
								//…………………………………………………………………………………
						End case 
						
						//__________________________________
					: ($e.objectName="153")  // Install
						
						Case of 
								
								//…………………………………………………………………………………
							: (Not:C34(Bool:C1537(Form:C1466.status.xCode)))
								
								If (Is macOS:C1572)
									
									//#MARK_TODO: Il faut soit l'environnement xCode soit l'environnement Android
									OBJECT SET HELP TIP:C1181(*; $e.objectName; Get localized string:C991("youNeedXcodeToPerformThisOperation"))
									
								Else 
									
									//#MARK_LOCALIZE
									OBJECT SET HELP TIP:C1181(*; $e.objectName; ".Android's development environment is not ready.")
									
								End if 
								
								//…………………………………………………………………………………
							: (Not:C34(Bool:C1537(Form:C1466.status.dataModel)))
								
								OBJECT SET HELP TIP:C1181(*; $e.objectName; Get localized string:C991("youMustPublishAtLeastOneFieldToPerformThisOperation"))
								
								//…………………………………………………………………………………
							: (Not:C34(Bool:C1537(Form:C1466.status.teamId)))
								
								OBJECT SET HELP TIP:C1181(*; $e.objectName; Get localized string:C991("defineYourTeamIdToPerformThisOperation"))
								
								//…………………………………………………………………………………
						End case 
						
						//__________________________________
				End case 
			End if 
		End if 
		
		//______________________________________________________
	: ($e.code=On Mouse Leave:K2:34)
		
		If ($button<100)  // Tabs
			
			If (Form:C1466.tab=$e.objectName)
				
				OBJECT SET RGB COLORS:C628(*; $e.objectName; Foreground color:K23:1)
				
			Else 
				
				// Inverts
				OBJECT SET RGB COLORS:C628(*; $e.objectName; 0x00FFFFFF)
				
			End if 
			
		Else 
			
			OBJECT SET RGB COLORS:C628(*; $e.objectName; Foreground color:K23:1)
			
		End if 
		
		//______________________________________________________
	: ($e.code=On Clicked:K2:4)
		
		Case of 
				
				//……………………………………………………………………………………………………………………
			: ($button=8858)  // Switch
				
				CALL SUBFORM CONTAINER:C1086(-1)
				
				//……………………………………………………………………………………………………………………
			: ($button<100)  // Tabs
				
				// Move the tab background
				OBJECT GET COORDINATES:C663(*; $e.objectName; $left; $top; $right; $bottom)
				OBJECT SET COORDINATES:C1248(*; "tab"; $left; $top; $right; $bottom+1)
				
				// Deselects the previous tab
				OBJECT SET RGB COLORS:C628(*; Form:C1466.tab; 0x00FFFFFF)
				
				// Selects the current tab
				OBJECT SET RGB COLORS:C628(*; $e.objectName; EDITOR.selectedColor)
				
				If (Form:C1466.tab=$e.objectName)
					
					// Switching
					CALL SUBFORM CONTAINER:C1086(-1)
					
				Else 
					
					Form:C1466.tab:=$e.objectName
					
					If (Form:C1466.state#"open")
						
						// Open
						CALL SUBFORM CONTAINER:C1086(-1)
						
					End if 
				End if 
				
				// Display the tab page
				FORM GOTO PAGE:C247($button; *)
				
				If ($button=1)
					
					CALL FORM:C1391(Current form window:C827; Formula:C1597(editor_CALLBACK).source; "refresh")
					
				End if 
				
				//……………………………………………………………………………………………………………………
			Else 
				
				If ($button=153)  // Install
					
					androidLimitations(False:C215; "")
					
					var $device : Object
					var $target
					
					$target:=Null:C1517
					
					Case of 
							
							//______________________________________________________
						: (EDITOR.currentDevice=Null:C1517)
							
							// <NOTHING MORE TO DO>
							
							//______________________________________________________
						: (Is Windows:C1573)
							
							$device:=EDITOR.devices.plugged.android.query("udid = :1"; EDITOR.currentDevice).pop()
							$target:=Choose:C955($device#Null:C1517; "android"; Null:C1517)
							
							//______________________________________________________
						: (Is macOS:C1572)
							
							$device:=EDITOR.devices.plugged.apple.query("udid = :1"; EDITOR.currentDevice).pop()
							$target:=Choose:C955($device#Null:C1517; "ios"; Null:C1517)
							
							If ($target=Null:C1517)
								
								$device:=EDITOR.devices.plugged.android.query("udid = :1"; EDITOR.currentDevice).pop()
								$target:=Choose:C955($device#Null:C1517; "android"; Null:C1517)
								
							End if 
							
							//______________________________________________________
					End case 
					
					If ($target=Null:C1517)
						
						POST_MESSAGE(New object:C1471(\
							"target"; EDITOR.window; \
							"action"; "show"; \
							"type"; "alert"; \
							"title"; ".You must first select a connected device"))
						
					Else 
						
						PROJECT._device:=$device
						
						PROJECT._simulator:=$device.udid
						PROJECT._buildTarget:=$target
						
						// Pass to the parent
						CALL SUBFORM CONTAINER:C1086(-$button)
						
					End if 
					
				Else 
					
					// Pass to the parent
					CALL SUBFORM CONTAINER:C1086(-$button)
					
				End if 
				
				//……………………………………………………………………………………………………………………
		End case 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 