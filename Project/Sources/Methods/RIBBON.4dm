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
								
								OBJECT SET HELP TIP:C1181(*; $e.objectName; Get localized string:C991("defineYourYourTeamIdToPerformThisOperation"))
								
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
			
			OBJECT SET RGB COLORS:C628(*; $e.objectName; 0x00696969)
			
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
				OBJECT SET COORDINATES:C1248(*; "tab"; $left; $top; $right; $bottom)
				
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
				
				If ($button=2)
					
					// * UPDATE DEVICE LIST
					CALL WORKER:C1389(Form:C1466.editor.$worker; "editor_GET_DEVICES"; New object:C1471(\
						"caller"; Form:C1466.editor.$mainWindow; "project"; PROJECT))
					
				End if 
				
				// Display the tab page
				FORM GOTO PAGE:C247($button; *)
				
				//……………………………………………………………………………………………………………………
			Else 
				
				// Pass to the parent
				CALL SUBFORM CONTAINER:C1086(-$button)
				
				//……………………………………………………………………………………………………………………
		End case 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 