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
var $coordinates; $data; $display; $e; $widget : Object

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606

// ----------------------------------------------------
Case of 
		
		//=============================================================================
	: ($e.objectName="message")
		
		Case of 
				
				//______________________________________________________
			: ($e.code<0)  // <SUBFORM EVENTS>
				
				$widget:=EDITOR.message
				$data:=$widget.getValue()
				$display:=$data.ƒ
				
				Case of 
						
						//…………………………………………………………………………………………………
					: ($e.code=-2)\
						 | ($e.code=-1)  // Close
						
						EDITOR.messageObjects.hide()
						
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