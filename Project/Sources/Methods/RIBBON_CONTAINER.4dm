//%attributes = {"invisible":true}
// ----------------------------------------------------
// Object method : EDITOR.ribbon - (4D Mobile App)
// ID[9A9D18DB5AF848868EA589C98401AEA2]
// Created 30-1-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $shiftDown : Boolean
var $bottom; $left; $offset; $right; $top : Integer
var $button; $e; $ribbon : Object

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
				
				$ribbon:=OBJECT Get value:C1743($e.objectName)
				
				$offset:=100  // Height offset opened/closed
				
				If ($ribbon.state="open")
					
					// Close
					OBJECT GET COORDINATES:C663(*; $e.objectName; $left; $top; $right; $bottom)
					OBJECT SET COORDINATES:C1248(*; $e.objectName; $left; $top; $right; $bottom-$offset)
					
					OBJECT GET COORDINATES:C663(*; "description"; $left; $top; $right; $bottom)
					OBJECT SET COORDINATES:C1248(*; "description"; $left; $top-$offset; $right; $bottom)
					
					OBJECT GET COORDINATES:C663(*; "project"; $left; $top; $right; $bottom)
					OBJECT SET COORDINATES:C1248(*; "project"; $left; $top-$offset; $right; $bottom)
					
					OBJECT GET COORDINATES:C663(*; "browser"; $left; $top; $right; $bottom)
					OBJECT SET COORDINATES:C1248(*; "browser"; $left; $top-$offset; $right; $bottom)
					
					$ribbon.state:="close"
					
				Else 
					
					// Open
					OBJECT GET COORDINATES:C663(*; $e.objectName; $left; $top; $right; $bottom)
					OBJECT SET COORDINATES:C1248(*; $e.objectName; $left; $top; $right; $bottom+$offset)
					
					OBJECT GET COORDINATES:C663(*; "description"; $left; $top; $right; $bottom)
					OBJECT SET COORDINATES:C1248(*; "description"; $left; $top+$offset; $right; $bottom)
					
					OBJECT GET COORDINATES:C663(*; "project"; $left; $top; $right; $bottom)
					OBJECT SET COORDINATES:C1248(*; "project"; $left; $top+$offset; $right; $bottom)
					
					OBJECT GET COORDINATES:C663(*; "browser"; $left; $top; $right; $bottom)
					OBJECT SET COORDINATES:C1248(*; "browser"; $left; $top+$offset; $right; $bottom)
					
					$ribbon.state:="open"
					
				End if 
				
				// Touch
				OBJECT SET VALUE:C1742($e.objectName; $ribbon)
				
				//…………………………………………………………………………………………………
			: ($e.code=151)  // Build & Run
				
				// Autosave
				PROJECT.save()
				
				BUILD(New object:C1471(\
					"caller"; Current form window:C827; \
					"project"; PROJECT; \
					"create"; True:C214; \
					"build"; Not:C34($shiftDown); \
					"run"; Not:C34($shiftDown); \
					"verbose"; Bool:C1537(Form:C1466.verbose)))
				
				//…………………………………………………………………………………………………
			: ($e.code=153)  // Install
				
				If (Not:C34(Bool:C1537(Form:C1466.build)))
					
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
				
				$ribbon:=OBJECT Get value:C1743($e.objectName)
				$button:=Form:C1466.$dialog.EDITOR.ribbon.pages.query("button = :1"; String:C10($e.code)).pop()
				$ribbon.page:=$button.name
				EDITOR.gotoPage($button.name)
				
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