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
var $offset : Integer
var $coordinates; $data; $display; $e : Object
var $widget : cs:C1710.widgetMessage

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606
$widget:=Form:C1466.$dialog.EDITOR[$e.objectName]

// ----------------------------------------------------
Case of 
		
		//=============================================================================
	: ($e.objectName="browser")
		
		If ($e.code=-1)  // Hide
			
			CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "hideBrowser")
			
			$widget:=Self:C308->
			
			If ($widget.form#Null:C1517)
				
				Case of 
						
						//______________________________________________________
					: ($widget.selector="form-list")\
						 | ($widget.selector="form-detail")  // Forms
						
						$widget.action:="forms"
						$widget.selector:=Replace string:C233($widget.selector; "form-"; "")
						CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "setForm"; $widget)
						
						//______________________________________________________
					: ($widget.selector="form-formatter")
						
						//
						
						//______________________________________________________
					: ($widget.selector="form-login")
						
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
				
				$data:=$widget.getValue()
				$display:=$data.ƒ
				
				Case of 
						
						//…………………………………………………………………………………………………
					: ($e.code=-2)\
						 | ($e.code=-1)  // Close
						
						//$widget.hide()
						OBJECT SET VISIBLE:C603(*; "message@"; False:C215)
						
						$display.restore($data)
						
						// Restore original size
						$widget.setDimension($display.width; $display.height)
						
						//…………………………………………………………………………………………………
					: ($e.code=-8858)  // Resize
						
						$coordinates:=$widget.getCoordinates()
						$coordinates.bottom:=$coordinates.bottom+$display.offset
						
						// Limit to the window's height
						$offset:=$widget.getParent().dimensions.height-$coordinates.bottom-20
						
						If ($offset<0)
							
							$coordinates.bottom:=$coordinates.bottom+$offset
							$display.background.coordinates.bottom:=$display.background.coordinates.bottom+$offset
							$display.additional.coordinates.bottom:=$display.additional.coordinates.bottom+$offset
							$display.offset:=$display.offset+$offset
							$display.scrollbar:=True:C214
							
						Else 
							
							$display.scrollbar:=False:C215
							
						End if 
						
						$widget.setCoordinates($coordinates)
						$display.update($data)
						
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
