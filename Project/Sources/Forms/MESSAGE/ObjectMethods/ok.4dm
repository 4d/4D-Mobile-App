If (Form:C1466.signal#Null:C1517)
	
	Use (Form:C1466.signal)
		
		Form:C1466.signal.validate:=True:C214
		
	End use 
	
	Form:C1466.signal.trigger()
	
Else 
	
	If (Form:C1466.okFormula#Null:C1517)
		
		Form:C1466.okFormula.call()
		
	Else 
		
		// #OLD MECHANISM
		If (Form:C1466.okAction#Null:C1517)
			
			If (Form:C1466.option#Null:C1517)
				
				EXECUTE METHOD:C1007("EDITOR_RESUME"; *; String:C10(Form:C1466.okAction); Form:C1466.option)
				
			Else 
				
				EXECUTE METHOD:C1007("EDITOR_RESUME"; *; String:C10(Form:C1466.okAction))
				
			End if 
		End if 
	End if 
End if 

CALL SUBFORM CONTAINER:C1086(-1)