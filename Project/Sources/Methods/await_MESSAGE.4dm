//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : await_MESSAGE
// ID[9B5983900B4F4E13A2A5AD80D245E814]
// Created 10-9-2020 by Vincent de Lachaux
// ----------------------------------------------------
// #THREAD-SAFE
// ----------------------------------------------------
// Description:
// Management of the message widget in a target window
// ----------------------------------------------------
// Declarations
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
If ($message.target=Null:C1517)
	
	$message.target:=$winRef
	
End if 

If (Count parameters:C259>=2)
	
	$response:=New signal:C1641($id)
	
Else 
	
	$response:=New signal:C1641
	
End if 

Use ($response)
	
	$response.validate:=False:C215
	
End use 

// Add the signal object
$message.signal:=$response

EDITOR.postMessage($message)

If ($message.target#$winRef)
	
	$response.wait()
	
Else 
	
	// The result must be processed by the callback method, if applicable.
	
End if 