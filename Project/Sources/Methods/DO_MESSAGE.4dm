//%attributes = {"invisible":true,"preemptive":"incapable"}
// ----------------------------------------------------
// Project method : DO_MESSAGE
// ID[D57C4FF31B0C49C98965D4645A31B3B1]
// Created 3-7-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(DO_MESSAGE; $1)
End if 

var $key : Text
var $in; $message; $o : Object

// ----------------------------------------------------
// Declarations

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	$in:=$1
	
	// Optional parameters
	// <NONE>
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
$message:=OBJECT Get value:C1743("message")

If (OBJECT Get visible:C1075(*; "message"))\
 & (New collection:C1472("alert"; "confirm").indexOf(String:C10($message.type))#-1)
	
	// A message is already displayed: wait
	CALL FORM:C1391(Current form window:C827; "DO_MESSAGE"; $in)
	
Else 
	
	If (String:C10($in.action)="reset")
		
		OBJECT SET VALUE:C1742("message"; New object:C1471)
		
	Else 
		
		Case of 
				
				//______________________________________________________
			: ($in.action=Null:C1517)
				
				// NOTHING MORE TO DO
				
				//______________________________________________________
			: ($in.action="show")
				
				// Get help tips status
				$o:=UI.tips
				
				$message:=ob_createPath($message; "tips")
				$message.tips:=$o
				
				$o.disable()
				
				OBJECT SET VISIBLE:C603(*; "message@"; True:C214)
				
				//______________________________________________________
			: ($in.action="hide")
				
				// Don't dismiss an alert or confirmation
				If (New collection:C1472("alert"; "confirm").indexOf(String:C10($message.type))#-1)
					
					OBJECT SET VISIBLE:C603(*; "message@"; False:C215)
					
					If ($message.tips.enabled)
						
						// Restore help tips status
						$o:=UI.tips
						$o.enable()
						$o.setDuration($message.tips.delay)
						
					End if 
				End if 
				
				//______________________________________________________
			: ($in.action="reset")
				
				$in:=New object:C1471
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Unknown entry point: \""+$in.action+"\"")
				
				//______________________________________________________
		End case 
		
		If ($message=Null:C1517)
			
			$message:=New object:C1471
			
		End if 
		
		For each ($key; $in)
			
			$message[$key]:=$in[$key]
			
		End for each 
		
		OBJECT SET VALUE:C1742("message"; $message)
		
	End if 
End if 

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End