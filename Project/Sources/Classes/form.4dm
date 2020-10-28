Class constructor($method : Text)
	
	This:C1470.name:=Current form name:C1298
	This:C1470.window:=Current form window:C827
	This:C1470.focused:=Null:C1517
	This:C1470.current:=Null:C1517
	This:C1470.callback:=""
	
	If (Count parameters:C259>=1)
		
		This:C1470.setCallBack($method)
		
	End if 
	
	//______________________________________________________
Function setCallBack($method : Text)
	
	This:C1470.callback:=$method
	
	//______________________________________________________
Function call($params : Variant)
	
	var $t : Text
	var $i : Integer
	
	If (Length:C16(This:C1470.callback)#0)
		
		If (Count parameters:C259=0)
			
			CALL FORM:C1391(This:C1470.window; This:C1470.callback)
			
		Else 
			
			If (Value type:C1509($params)=Is collection:K8:32)
				
				$t:="CALL FORM:C1391(This:C1470.window; This:C1470.callback"
				
				For ($i; 0; $params.length-1; 1)
					
					$t:=$t+"; $params["+String:C10($i)+"]"
					
				End for 
				
				$t:=$t+")"
				
				Formula from string:C1601($t).call()
				
			Else 
				
				CALL FORM:C1391(This:C1470.window; This:C1470.callback; $params)
				
			End if 
		End if 
		
	Else 
		
		ASSERT:C1129(False:C215; "Callback method is not defined.")
		
	End if 
	
	//______________________________________________________