//%attributes = {"invisible":true}
If (KEYCODE=202)
	
	var $name : Text
	var $mode : Boolean
	var $origin; $state; $time; $uid : Integer
	
	PROCESS PROPERTIES:C336(Frontmost process:C327(*); $name; $state; $time; $mode; $uid; $origin)
	
	If ($origin=-2)  // Only for the design process
		
		FILTER EVENT:C321  // Do not let 4D process this event
		
		EXECUTE METHOD:C1007("QUICK_OPEN")  // Show the UI
		
	End if 
End if 