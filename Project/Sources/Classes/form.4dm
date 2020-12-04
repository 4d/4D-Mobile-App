Class constructor($method : Text)
	
	This:C1470.name:=Current form name:C1298
	This:C1470.window:=Current form window:C827
	This:C1470.callback:=Null:C1517
	
	This:C1470.focused:=Null:C1517
	This:C1470.current:=Null:C1517
	
	If (Count parameters:C259>=1)
		
		This:C1470.setCallBack($method)
		
	End if 
	
	//______________________________________________________
	// Defines the name of the callback method
Function setCallBack($method : Text)
	
	This:C1470.callback:=$method
	
	//______________________________________________________
	// Generates a CALL FORM using the current form
	// .call()
	// .call( param : Collection )
	// .call( param1, param2, …, paramN )
Function call
	
	C_VARIANT:C1683(${1})
	
	var $t : Text
	var $i : Integer
	var $c : Collection
	
	If (Length:C16(String:C10(This:C1470.callback))#0)
		
		If (Count parameters:C259=0)
			
			CALL FORM:C1391(This:C1470.window; This:C1470.callback)
			
		Else 
			
			$t:="<!--#4DCODE CALL FORM:C1391("+String:C10(This:C1470.window)+"; \""+This:C1470.callback+"\""
			
			If (Value type:C1509($1)=Is collection:K8:32)
				
				$c:=$1
				
				For ($i; 0; $c.length-1; 1)
					
					$t:=$t+"; $1["+String:C10($i)+"]"
					
				End for 
				
			Else 
				
				$c:=New collection:C1472
				
				For ($i; 1; Count parameters:C259; 1)
					
					$c.push(${$i})
					
					$t:=$t+"; $1["+String:C10($i-1)+"]"
					
				End for 
			End if 
			
			$t:=$t+")-->"
			
			PROCESS 4D TAGS:C816($t; $t; $c)
			
		End if 
		
	Else 
		
		ASSERT:C1129(False:C215; "Callback method is not defined.")
		
	End if 
	
	//______________________________________________________