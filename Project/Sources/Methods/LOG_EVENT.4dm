//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : LOG_EVENT
// ID[96B758353E7C46B2AC1896B15D9C0058]
// Created 14-9-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
#DECLARE($in : Object)

If (False:C215)
	C_OBJECT:C1216(LOG_EVENT; $1)
End if 

var $header : Text
var $importance : Integer

ASSERT:C1129(Count parameters:C259>=1; "Missing parameter")

$header:=$in.header || "["+Folder:C1567(fk database folder:K87:14).name+"] "
$importance:=$in.importance || Warning message:K38:2

LOG EVENT:C667(Into 4D debug message:K38:5; $header+$in.message; $importance)

If (Feature.with("vdl"))
	
	Case of 
			
			//______________________________________________________
		: ($importance=Information message:K38:1)
			
			Logger.info($in.message)
			
			//______________________________________________________
		: ($importance=Warning message:K38:2)
			
			Logger.warning($in.message)
			
			//______________________________________________________
		: ($importance=Error message:K38:3)
			
			Logger.error($in.message)
			
			//______________________________________________________
	End case 
End if 