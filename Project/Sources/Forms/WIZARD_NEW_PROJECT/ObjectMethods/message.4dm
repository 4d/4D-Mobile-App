var $offset : Integer
var $coordinates; $data; $display; $e : Object
var $widget : cs:C1710.widgetMessage

$e:=FORM Event:C1606
$widget:=Form:C1466._message

Case of 
		
		//______________________________________________________
	: ($e.code<0)  // <SUBFORM EVENTS>
		
		$data:=$widget.getValue()
		$display:=$data.ƒ
		
		Case of 
				
				//…………………………………………………………………………………………………
			: ($e.code=-2)\
				 | ($e.code=-1)  // Close
				
				If ($data.accept)
					
					ACCEPT:C269
					
				Else 
					
					GOTO OBJECT:C206(*; "newProject")
					
				End if 
				
				OBJECT SET VISIBLE:C603(*; "message@"; False:C215)
				
				$display.restore($data)
				
				// Restore original size
				$widget.setDimension($display.width; $display.height)
				
				//…………………………………………………………………………………………………
			: ($e.code=-8858)  // Resize
				
				$coordinates:=$widget.getCoordinates()
				$coordinates.bottom:=$coordinates.bottom+$display.offset
				
				// Limit to the window's height
				$offset:=$widget.getParentDimensions().height-$coordinates.bottom-20
				
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
