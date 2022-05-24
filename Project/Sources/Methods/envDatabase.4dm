//%attributes = {"invisible":true,"preemptive":"incapable"}
/*
Non-thread-safe commands to be called in a cooperative process
*/
#DECLARE($signal : Object)

If (False:C215)
	C_OBJECT:C1216(envDatabase; $1)
End if 

var $userParam : Text
var $c : Collection

Use ($signal)
	
	$signal.isProject:=Bool:C1537(Get database parameter:C643(Is host database a project:K37:99))
	$signal.isBinary:=Not:C34($signal.isProject)
	
	$c:=New collection:C1472
	ARRAY TEXT:C222($textArray; 0x0000)
	COMPONENT LIST:C1001($textArray)
	ARRAY TO COLLECTION:C1563($c; $textArray)
	$signal.components:=$c.copy(ck shared:K85:29; $signal)
	
	$c:=New collection:C1472
	ARRAY LONGINT:C221($IntegerArray; 0x0000)
	PLUGIN LIST:C847($IntegerArray; $textArray)
	ARRAY TO COLLECTION:C1563($c; $textArray)
	$signal.plugins:=$c.copy(ck shared:K85:29; $signal)
	
	$IntegerArray{0}:=Get database parameter:C643(User param value:K37:94; $userParam)
	
	If (Length:C16($userParam)>0)
		
		// Decode special entities
		$userParam:=Replace string:C233($userParam; "&amp;"; "&")
		$userParam:=Replace string:C233($userParam; "&lt;"; "<")
		$userParam:=Replace string:C233($userParam; "&gt;"; ">")
		$userParam:=Replace string:C233($userParam; "&apos;"; "'")
		$userParam:=Replace string:C233($userParam; "&quot;"; "\"")
		
		Case of 
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\{.*\\}$"; $userParam; 1))  // Json object
				
				$signal.parameters:=JSON Parse:C1218($userParam).copy(ck shared:K85:29; $signal)
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\[.*\\]$"; $userParam; 1))  // Json array
				
				$signal.parameters:=JSON Parse:C1218($userParam).copy(ck shared:K85:29; $signal)
				
				//______________________________________________________
			Else 
				
				$signal.parameters:=$userParam
				
				//______________________________________________________
		End case 
	End if 
End use 

$signal.trigger()