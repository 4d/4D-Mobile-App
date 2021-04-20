//====================================================================
Class extends tools

//====================================================================
Class constructor($method : Text)
	
	Super:C1705()
	
	This:C1470.name:=Current form name:C1298
	This:C1470.window:=Current form window:C827
	This:C1470.callback:=Null:C1517
	
	This:C1470.focused:=Null:C1517
	This:C1470.current:=Null:C1517
	
	If (Count parameters:C259>=1)
		
		This:C1470.setCallBack($method)
		
	End if 
	
	//====================================================================
	// Defines the name of the callback method
Function setCallBack($method : Text)
	
	This:C1470.callback:=$method
	
	//====================================================================
	// Start a timer to update the user interface
	// Default delay is ASAP
Function refresh($delay : Integer)
	
	If (Count parameters:C259>=1)
		
		SET TIMER:C645($delay)
		
	Else 
		
		SET TIMER:C645(-1)
		
	End if 
	
	//====================================================================
	// Generates a CALL FORM using the current form
	// .call()
	// .call( param : Collection )
	// .call( param1, param2, …, paramN )
Function call
	
	C_VARIANT:C1683(${1})
	
	var $code : Text
	var $i : Integer
	var $parameters : Collection
	
	If (Length:C16(String:C10(This:C1470.callback))#0)
		
		If (Count parameters:C259=0)
			
			CALL FORM:C1391(This:C1470.window; This:C1470.callback)
			
		Else 
			
			$code:="<!--#4DCODE CALL FORM:C1391("+String:C10(This:C1470.window)+"; \""+This:C1470.callback+"\""
			
			If (Value type:C1509($1)=Is collection:K8:32)
				
				$parameters:=$1
				
				For ($i; 0; $parameters.length-1; 1)
					
					$code:=$code+"; $1["+String:C10($i)+"]"
					
				End for 
				
			Else 
				
				$parameters:=New collection:C1472
				
				For ($i; 1; Count parameters:C259; 1)
					
					$parameters.push(${$i})
					
					$code:=$code+"; $1["+String:C10($i-1)+"]"
					
				End for 
			End if 
			
			$code:=$code+")-->"
			
			PROCESS 4D TAGS:C816($code; $code; $parameters)
			
		End if 
		
	Else 
		
		ASSERT:C1129(False:C215; "Callback method is not defined.")
		
	End if 
	