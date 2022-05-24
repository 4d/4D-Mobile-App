//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : await_MESSAGE
// ID[9B5983900B4F4E13A2A5AD80D245E814]
// Created 10-9-2020 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Management of the message widget in a target window
// ----------------------------------------------------
#DECLARE($message : Object; $id : Text)->$response : Object

If (False:C215)
	C_OBJECT:C1216(await_MESSAGE; $1)
	C_TEXT:C284(await_MESSAGE; $2)
	C_OBJECT:C1216(await_MESSAGE; $0)
End if 

var $name : Text
var $mode; $state; $winRef : Integer
var $time : Time

PROCESS PROPERTIES:C336(Current process:C322; $name; $state; $time; $mode)

If (Not:C34(($mode ?? 1)))  // Cooperative
	
	//%T-
	$winRef:=Current form window:C827
	//%T+
	
End if 

// Default target is the current windows
$message.target:=$message.target || $winRef

$response:=Length:C16($id)>0 ? New signal:C1641($id) : New signal:C1641

Use ($response)
	
	$response.validate:=False:C215
	
End use 

// Add the signal object
$message.signal:=$response

If ($message.target#$winRef)
	
	CALL FORM:C1391($message.target; "DO_MESSAGE"; $message)
	$response.wait()
	
Else 
	
	CALL FORM:C1391($message.target; "DO_MESSAGE"; $message)
	
End if 