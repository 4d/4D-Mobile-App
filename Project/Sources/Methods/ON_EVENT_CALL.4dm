//%attributes = {"invisible":true}
If (KEYCODE=202)
	
	FILTER EVENT:C321  // Don't let 4D will also get this event
	
	EXECUTE METHOD:C1007("QUICK_OPEN")
	
End if 