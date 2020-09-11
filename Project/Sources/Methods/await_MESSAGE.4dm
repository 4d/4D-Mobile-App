//%attributes = {"invisible":true}
var $0 : Object  // Signal response
var $1 : Object  // Parameters as an object
var $2 : Text  // ID {optional}

If (False:C215)
	C_OBJECT:C1216(await_MESSAGE; $0)  // Signal response
	C_OBJECT:C1216(await_MESSAGE; $1)  // Parameters as an object
	C_TEXT:C284(await_MESSAGE; $2)  // ID {optional}
End if 

If (Count parameters:C259>=2)
	
	$0:=New signal:C1641($2)
	
Else 
	
	$0:=New signal:C1641
	
End if 

Use ($0)
	
	$0.validate:=False:C215
	
End use 

var $window : Integer

If (cs:C1710.process.new().cooperative)
	
	//%T-
	$window:=Current form window:C827
	//%T+
	
End if 

// Default target is the current windows
If ($1.target=Null:C1517)
	
	$1.target:=$window
	
End if 

// Add the signal object
$1.signal:=$0

POST_MESSAGE($1)

If ($1.target#$window)
	
	$0.wait()
	
Else 
	
	// The result must be processed by the callback method, if applicable.
	
End if 