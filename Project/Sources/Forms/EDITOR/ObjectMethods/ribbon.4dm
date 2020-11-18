// ----------------------------------------------------
// Object method : EDITOR.ribbon - (4D Mobile App)
// ID[9A9D18DB5AF848868EA589C98401AEA2]
// Created 30-1-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $me : Text
var $run; $shiftDown : Boolean
var $bottom; $index; $left; $offset; $right; $top : Integer
var $ptr : Pointer
var $e; $o : Object
var $menu : cs:C1710.menu

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606
$shiftDown:=Shift down:C543

// ----------------------------------------------------
Case of 
		
		//________________________________________
	: ($e.code<0)  // <SUBFORM EVENTS>
		
		$e.code:=Abs:C99($e.code)
		
		Case of 
				
				//…………………………………………………………………………………………………
			: ($e.code=1)  // Hide/show toolbar
				
				$me:=OBJECT Get name:C1087(Object current:K67:2)
				$o:=OBJECT Get value:C1743($me)
				
				$offset:=100  // Height offset opened/closed
				
				If ($o.state="open")
					
					// Close
					OBJECT GET COORDINATES:C663(*; $me; $left; $top; $right; $bottom)
					OBJECT SET COORDINATES:C1248(*; $me; $left; $top; $right; $bottom-$offset)
					OBJECT GET COORDINATES:C663(*; "description"; $left; $top; $right; $bottom)
					OBJECT SET COORDINATES:C1248(*; "description"; $left; $top-$offset; $right; $bottom)
					OBJECT GET COORDINATES:C663(*; "project"; $left; $top; $right; $bottom)
					OBJECT SET COORDINATES:C1248(*; "project"; $left; $top-$offset; $right; $bottom)
					OBJECT GET COORDINATES:C663(*; "browser"; $left; $top; $right; $bottom)
					OBJECT SET COORDINATES:C1248(*; "browser"; $left; $top-$offset; $right; $bottom)
					
					$o.state:="close"
					
				Else 
					
					// Open
					OBJECT GET COORDINATES:C663(*; $me; $left; $top; $right; $bottom)
					OBJECT SET COORDINATES:C1248(*; $me; $left; $top; $right; $bottom+$offset)
					OBJECT GET COORDINATES:C663(*; "description"; $left; $top; $right; $bottom)
					OBJECT SET COORDINATES:C1248(*; "description"; $left; $top+$offset; $right; $bottom)
					OBJECT GET COORDINATES:C663(*; "project"; $left; $top; $right; $bottom)
					OBJECT SET COORDINATES:C1248(*; "project"; $left; $top+$offset; $right; $bottom)
					OBJECT GET COORDINATES:C663(*; "browser"; $left; $top; $right; $bottom)
					OBJECT SET COORDINATES:C1248(*; "browser"; $left; $top+$offset; $right; $bottom)
					
					$o.state:="open"
					
				End if 
				
				// Touch
				OBJECT SET VALUE:C1742($me; $o)
				
				//…………………………………………………………………………………………………
			: ($e.code=151)  // Build & Run
				
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
						
						// Autosave
						PROJECT.save()
						
						If (FEATURE.with("android"))
							
							$run:=Is Windows:C1573
							
							If ($run)
								
								PROJECT.buildTarget:="android"
								
							Else 
								
								$menu:=cs:C1710.menu.new()
								$menu.append(".Build for iOS"; "ios").enable(Bool:C1537(PROJECT.$project.xCode.ready))  //#MARK_LOCALIZE
								$menu.append(".Build for Android"; "android").enable(True:C214)  //#MARK_TODO
								$menu.popup()
								
								If ($menu.selected)
									
									PROJECT.buildTarget:=$menu.choice
									$run:=True:C214
									
								End if 
							End if 
							
						Else 
							
							// <NOTHING MORE TO DO>
							$run:=True:C214
							
						End if 
						
						If ($run)
							
							Form:C1466.build:=True:C214  // Stop reentrance
							
							BUILD(New object:C1471(\
								"caller"; Current form window:C827; \
								"project"; PROJECT; \
								"create"; True:C214; \
								"build"; Not:C34($shiftDown); \
								"run"; Not:C34($shiftDown); \
								"verbose"; Bool:C1537(Form:C1466.verbose)))
							
						End if 
						
						//______________________________________________________
				End case 
				
				//…………………………………………………………………………………………………
			: ($e.code=152)  // Project
				
				// Get button coordinates
				EXECUTE METHOD IN SUBFORM:C1085("ribbon"; "widget"; $o; "152")
				editor_MENU_ACTIONS(New object:C1471(\
					"x"; $o.windowCoordinates.left; \
					"y"; $o.windowCoordinates.top+$o.coordinates.height))
				
				//…………………………………………………………………………………………………
			: ($e.code=153)  // Install
				
				If (Not:C34(Bool:C1537(Form:C1466.build)))
					
					Form:C1466.build:=True:C214
					
					// Autosave
					PROJECT.save()
					
					BUILD(New object:C1471(\
						"caller"; Current form window:C827; \
						"project"; (OBJECT Get pointer:C1124(Object named:K67:5; "project"))->; \
						"create"; Not:C34($shiftDown); \
						"build"; Not:C34($shiftDown); \
						"archive"; True:C214; \
						"verbose"; Bool:C1537(Form:C1466.verbose)))
					
				End if 
				
				//…………………………………………………………………………………………………
			: ($e.code>100)  // Section menu
				
				$index:=Form:C1466.$dialog.EDITOR.ribbon.pages.extract("button").indexOf(String:C10($e.code))
				$o:=OBJECT Get value:C1743(OBJECT Get name:C1087(Object current:K67:2))
				$o.page:=Form:C1466.$dialog.EDITOR.ribbon.pages[$index].name
				Form:C1466.$dialog.EDITOR.pages.gotoPage($o.page)
				
				//…………………………………………………………………………………………………
			Else 
				
				ASSERT:C1129(False:C215; "Unknown call from subform ("+String:C10($e.code)+")")
				
				//…………………………………………………………………………………………………
		End case 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 