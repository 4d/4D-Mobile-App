//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : POST_MESSAGE
// ID[9EA6C0AFDD1E426C86CA28F644F30845]
// Created 3-7-2017 by Vincent de Lachaux
// ----------------------------------------------------
// #THREAD-SAFE
// ----------------------------------------------------
// Description:
// Management of the message widget in a target window
// ----------------------------------------------------
// Declarations
#DECLARE($message : Object)

// ----------------------------------------------------
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	If (Asserted:C1132(Num:C11(String:C10($message.target))#0; "Missing target window"))
		
		CALL FORM:C1391($message.target; "DO_MESSAGE"; $message)
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 