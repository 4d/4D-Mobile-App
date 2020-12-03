Class constructor
	
	var $build : Integer
	
	This:C1470.version:=Application version:C493($build; *)
	This:C1470.features:=New collection:C1472
	
	
Function main($feature)
	
	If (Value type:C1509($feature)=Is text:K8:3)
		
		This:C1470[$feature]:=Application version:C493(*)="A@"
		
	Else 
		
		// A "If" statement should never omit "Else" 
		
	End if 
	
	
	