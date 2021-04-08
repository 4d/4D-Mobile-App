//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_OBJECTS_HANDLER
// ID[52D7D7A0793F480ABC65C764E08F0C31]
// Created 17-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $bottom; $height; $left; $right; $top; $width : Integer
var $e; $o : Object

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606

// ----------------------------------------------------
Case of 
		
		//=============================================================================
	: ($e.objectName="browser")
		
		If ($e.code=-1)  // Hide
			
			CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "hideBrowser")
			
			$o:=Self:C308->
			
			If ($o.form#Null:C1517)
				
				Case of 
						
						//______________________________________________________
					: ($o.selector="form-list")\
						 | ($o.selector="form-detail")  // Forms
						
						$o.action:="forms"
						$o.selector:=Replace string:C233($o.selector; "form-"; "")
						CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "setForm"; $o)
						
						//______________________________________________________
					: ($o.selector="form-formatter")
						
						//
						
						//______________________________________________________
					: ($o.selector="form-login")
						
						//
						
						//______________________________________________________
					Else 
						
						// A "Case of" statement should never omit "Else"
						
						//______________________________________________________
				End case 
			End if 
		End if 
		
		//=============================================================================
	: ($e.objectName="message")
		
		Case of 
				
				//______________________________________________________
			: ($e.code<0)  // <SUBFORM EVENTS>
				
				$o:=Self:C308->
				
				Case of 
						
						//…………………………………………………………………………………………………
					: ($e.code=-2)\
						 | ($e.code=-1)  // Close
						
						If ($o.tips.enabled)
							
							// Restore help tips status
							$o.tips.enable()
							$o.tips.setDuration($o.tips.delay)
							
						End if 
						
						//Self->:=New object
						
						OBJECT SET VISIBLE:C603(*; "message@"; False:C215)
						
						OBJECT GET COORDINATES:C663(*; $e.objectName; $left; $top; $right; $bottom)
						OBJECT SET COORDINATES:C1248(*; $e.objectName; $left; $top; $right; $top+410)
						
						//…………………………………………………………………………………………………
					Else 
						
						// Resizing
						OBJECT GET COORDINATES:C663(*; $e.objectName; $left; $top; $right; $bottom)
						
						$bottom:=$top+Abs:C99($e.code)
						
						// Limit to the window's height
						OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
						
						If ($bottom>($height-20))
							
							$bottom:=$height-20
							$o.ƒ.geometry.scrollbar:=True:C214
							
						Else 
							
							$o.ƒ.geometry.scrollbar:=False:C215
							
						End if 
						
						$o.ƒ.updateGeometry:=True:C214
						Self:C308->:=$o  // Touch
						
						OBJECT SET COORDINATES:C1248(*; $e.objectName; $left; $top; $right; $bottom)
						
						//…………………………………………………………………………………………………
				End case 
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//=============================================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown object: \""+$e.objectName+"\"")
		
		//=============================================================================
End case 

// ----------------------------------------------------
// End