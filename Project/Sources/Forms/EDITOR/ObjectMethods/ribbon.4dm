// ----------------------------------------------------
// Object method : EDITOR.ribbon - (4D Mobile App)
// ID[9A9D18DB5AF848868EA589C98401AEA2]
// Created 30-1-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_BOOLEAN:C305($Boo_shiftDown)
C_LONGINT:C283($Lon_bottom; $Lon_formEvent; $Lon_index; $Lon_left; $Lon_offset; $Lon_right)
C_LONGINT:C283($Lon_top)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Txt_me)
C_OBJECT:C1216($o)

// ----------------------------------------------------
// Initialisations
$Lon_formEvent:=Form event code:C388
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)
$Boo_shiftDown:=Shift down:C543

// ----------------------------------------------------
Case of 
		
		//________________________________________
	: ($Lon_formEvent<0)  // <SUBFORM EVENTS>
		
		$Lon_formEvent:=Abs:C99($Lon_formEvent)
		
		Case of 
				
				//…………………………………………………………………………………………………
			: ($Lon_formEvent=1)  // Sections
				
				$Lon_offset:=100
				
				If ($Ptr_me->state="open")
					
					// Close
					OBJECT GET COORDINATES:C663(*; $Txt_me; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
					OBJECT SET COORDINATES:C1248(*; $Txt_me; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom-$Lon_offset)
					OBJECT GET COORDINATES:C663(*; "description"; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
					OBJECT SET COORDINATES:C1248(*; "description"; $Lon_left; $Lon_top-$Lon_offset; $Lon_right; $Lon_bottom)
					OBJECT GET COORDINATES:C663(*; "project"; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
					OBJECT SET COORDINATES:C1248(*; "project"; $Lon_left; $Lon_top-$Lon_offset; $Lon_right; $Lon_bottom)
					OBJECT GET COORDINATES:C663(*; "browser"; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
					OBJECT SET COORDINATES:C1248(*; "browser"; $Lon_left; $Lon_top-$Lon_offset; $Lon_right; $Lon_bottom)
					
					$Ptr_me->state:="close"
					
				Else 
					
					// Open
					OBJECT GET COORDINATES:C663(*; $Txt_me; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
					OBJECT SET COORDINATES:C1248(*; $Txt_me; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom+$Lon_offset)
					OBJECT GET COORDINATES:C663(*; "description"; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
					OBJECT SET COORDINATES:C1248(*; "description"; $Lon_left; $Lon_top+$Lon_offset; $Lon_right; $Lon_bottom)
					OBJECT GET COORDINATES:C663(*; "project"; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
					OBJECT SET COORDINATES:C1248(*; "project"; $Lon_left; $Lon_top+$Lon_offset; $Lon_right; $Lon_bottom)
					OBJECT GET COORDINATES:C663(*; "browser"; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
					OBJECT SET COORDINATES:C1248(*; "browser"; $Lon_left; $Lon_top+$Lon_offset; $Lon_right; $Lon_bottom)
					
					$Ptr_me->state:="open"
					
				End if 
				
				// Touch
				$Ptr_me->:=$Ptr_me->
				
				//…………………………………………………………………………………………………
			: ($Lon_formEvent=151)  // Build & Run
				
				
				Case of 
						
						//______________________________________________________
					: (Bool:C1537(Form:C1466.dataSetGeneration))  // A dataset generation is in progress
						
						POST_MESSAGE(New object:C1471(\
							"target"; Current form window:C827; \
							"action"; "show"; \
							"type"; "alert"; \
							"title"; "itIsNotPossibleToBuildTheProject"; \
							"additional"; "generationOfTheDatasetIsInProgress"))
						
						//______________________________________________________
					: (Bool:C1537(Form:C1466.build))
						
						// The build is already underway
						
						//______________________________________________________
					Else 
						
						Form:C1466.build:=True:C214  // Stop reentrance
						
						// Autosave
						project_SAVE
						
						$o:=(OBJECT Get pointer:C1124(Object named:K67:5; "project"))->
						
						BUILD(New object:C1471(\
							"caller"; Current form window:C827; \
							"project"; $o; \
							"create"; True:C214; \
							"build"; Not:C34($Boo_shiftDown); \
							"run"; Not:C34($Boo_shiftDown); \
							"verbose"; Bool:C1537(Form:C1466.verbose)))
						
						//______________________________________________________
				End case 
				
				//…………………………………………………………………………………………………
			: ($Lon_formEvent=152)  // Project
				
				// Get button coordinates
				EXECUTE METHOD IN SUBFORM:C1085("ribbon"; "widget"; $o; "152")
				editor_MENU_ACTIONS(New object:C1471(\
					"x"; $o.windowCoordinates.left; \
					"y"; $o.windowCoordinates.top+$o.coordinates.height))
				
				//…………………………………………………………………………………………………
			: ($Lon_formEvent=153)  // Install
				
				If (Not:C34(Bool:C1537(Form:C1466.build)))
					
					Form:C1466.build:=True:C214
					
					// Autosave
					project_SAVE
					
					BUILD(New object:C1471(\
						"caller"; Current form window:C827; \
						"project"; (OBJECT Get pointer:C1124(Object named:K67:5; "project"))->; \
						"create"; Not:C34($Boo_shiftDown); \
						"build"; Not:C34($Boo_shiftDown); \
						"archive"; True:C214; \
						"verbose"; Bool:C1537(Form:C1466.verbose)))
					
				End if 
				
				//…………………………………………………………………………………………………
			: ($Lon_formEvent>100)  // Section menu
				
				$Lon_index:=Form:C1466.$dialog.EDITOR.ribbon.pages.extract("button").indexOf(String:C10($Lon_formEvent))
				$Ptr_me->page:=Form:C1466.$dialog.EDITOR.ribbon.pages[$Lon_index].name
				
				//editor_PAGE($Ptr_me->page)
				Form:C1466.$dialog.EDITOR.pages.gotoPage($Ptr_me->page)
				
				//…………………………………………………………………………………………………
			Else 
				
				ASSERT:C1129(False:C215; "Unknown call from subform ("+String:C10($Lon_formEvent)+")")
				
				//…………………………………………………………………………………………………
		End case 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		//______________________________________________________
End case 