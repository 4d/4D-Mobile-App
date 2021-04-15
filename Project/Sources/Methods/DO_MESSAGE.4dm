//%attributes = {"invisible":true,"preemptive":"incapable"}
// ----------------------------------------------------
// Project method : DO_MESSAGE
// ID[D57C4FF31B0C49C98965D4645A31B3B1]
// Created 3-7-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Management of the message widget in the context of the current window
// ----------------------------------------------------
// Declarations
#DECLARE($message : Object)

var $action; $key : Text
var $data; $display : Object
var $widget : cs:C1710.widgetMessage

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	Case of 
			//______________________________________________________
		: (Current form name:C1298="EDITOR")
			
			$widget:=Form:C1466.$dialog.EDITOR.message
			
			//______________________________________________________
		: (Current form name:C1298="WIZARD_NEW_PROJECT")
			
			$widget:=Form:C1466._message
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "Unmanaged parent form")
			
			//______________________________________________________
	End case 
	
	$data:=$widget.getValue()
	$display:=$data.ƒ
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If $widget.isVisible()\
 & (New collection:C1472("alert"; "confirm").indexOf(String:C10($data.type))#-1)
	
	// A message is already displayed: wait
	CALL FORM:C1391(Current form window:C827; "DO_MESSAGE"; $message)
	
Else 
	
	$action:=String:C10($message.action)
	
	Case of 
			
			//______________________________________________________
		: ($action="show")
			
			$data:=New object:C1471
			
			For each ($key; $message)
				
				$data[$key]:=$message[$key]
				
			End for each 
			
			$widget.setValue($data)
			
			//$widget.show()
			OBJECT SET VISIBLE:C603(*; "message@"; Not:C34(OB Is empty:C1297($data)))
			
			//______________________________________________________
		: ($action="hide")\
			 | ($action="close")
			
			// Don't dismiss an alert or confirmation
			If (New collection:C1472("alert"; "confirm").indexOf(String:C10($data.type))=-1)
				
				//$widget.hide()
				OBJECT SET VISIBLE:C603(*; "message@"; False:C215)
				
				$display.restore($data)
				
				// Restore original size
				$widget.setDimension($display.width; $display.height)
				
			End if 
			
			//______________________________________________________
		: ($action="reset")
			
			$data.title:=""
			$data.additional:=""
			$widget.setValue($data)
			
			//________________________________________
		Else   // Update
			
			For each ($key; $message)
				
				$data[$key]:=$message[$key]
				
			End for each 
			
			$widget.setValue($data)
			
			//______________________________________________________
	End case 
End if 