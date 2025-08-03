//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : ob_error_add
  // Created 02-08-2017 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Add error to object
  // ----------------------------------------------------

#DECLARE($errorObject: Object; $message: Text)

var $parameterCount: Integer
var $messageText: Text
var $outputObject: Object

  // ----------------------------------------------------
  // Initialisations
$parameterCount:=Count parameters:C259

If (Asserted:C1132($parameterCount>=2;"Missing parameter"))
	
	$outputObject:=$errorObject
	$messageText:=$message
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($outputObject.errors=Null:C1517)
	
	$outputObject.errors:=New collection:C1472($messageText)
	
Else 
	
	$outputObject.errors.push($messageText)
	
End if 