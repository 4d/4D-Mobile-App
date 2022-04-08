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
#DECLARE($message : Object; $widget : cs:C1710.subform)

var $action; $key : Text
var $data; $ƒ : Object

//TODO: Allow a text parameter for one action only

$widget:=$widget || EDITOR.message

$data:=$widget.getValue()
$ƒ:=$data.ƒ


// ----------------------------------------------------
If $widget.isVisible()\
 & (New collection:C1472("alert"; "confirm").indexOf(String:C10($data.type))#-1)
	
	// A message is already displayed: wait
	EDITOR.callMe("DO_MESSAGE"; $message)
	
Else 
	
	$action:=String:C10($message.action)
	
	Case of 
			
			//______________________________________________________
		: ($action="show")
			
			$data:=New object:C1471
			
			For each ($key; $message)
				
				$data[$key]:=$message[$key]
				
			End for each 
			
			$data.ƒ:=$ƒ
			
			$widget.setValue($data)
			
			OBJECT SET VISIBLE:C603(*; "message@"; Not:C34(OB Is empty:C1297($data)))
			
			//______________________________________________________
		: ($action="hide")\
			 | ($action="close")
			
			// Don't dismiss an alert or confirmation
			If (New collection:C1472("alert"; "confirm").indexOf(String:C10($data.type))=-1)
				
				Case of 
						//______________________________________________________
					: (Current form name:C1298="PROJECT_EDITOR")
						
						EDITOR.messageGroup.hide()
						
						//______________________________________________________
					: (Current form name:C1298="WIZARD_NEW_PROJECT")
						
						OBJECT SET VISIBLE:C603(*; "message@"; False:C215)
						
						//______________________________________________________
				End case 
			End if 
			
			$ƒ.restore($data)
			
			// Restore original size
			$widget.setDimensions($ƒ.width; $ƒ.height)
			
			
			//______________________________________________________
		: ($action="reset")
			
			$data.title:=""
			$data.additional:=""
			$widget.setValue($data)
			
			$ƒ.restore($data)
			
			//________________________________________
		Else   // Update
			
			For each ($key; $message)
				
				$data[$key]:=$message[$key]
				
			End for each 
			
			$widget.setValue($data)
			
			//______________________________________________________
	End case 
End if 