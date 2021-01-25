Form:C1466.accept:=False:C215

If (Form:C1466.signal#Null:C1517)
	
	Form:C1466.signal.trigger()
	
	If (Form:C1466.signal.description#Null:C1517)
		
		If (Form:C1466.CALLBACK#Null:C1517)
			
			EXECUTE METHOD:C1007(Form:C1466.CALLBACK; *; Form:C1466)
			
		End if 
	End if 
	
Else 
	
	If (Form:C1466.cancelFormula#Null:C1517)
		
		Form:C1466.cancelFormula.call()
		
	Else 
		
		// #OLD MECHANISM
		If (Form:C1466.cancelAction#Null:C1517)
			
			EXECUTE METHOD:C1007("EDITOR_RESUME"; *; Form:C1466.cancelAction)
			
		End if 
	End if 
End if 

CALL SUBFORM CONTAINER:C1086(-2)