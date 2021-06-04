If (Not:C34(Is compiled mode:C492))  // Dev mode only
	
	// Check the availability of the component
	ARRAY TEXT:C222($components; 0x0000)
	COMPONENT LIST:C1001($components)
	
	If (Find in array:C230($components; "4DPop Design")>0)
		
		// Install the event capture method
		ON EVENT CALL:C190("ON_EVENT_CALL"; "$ON_EVENT_CALL")
		
	End if 
End if 