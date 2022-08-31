Case of 
		//______________________________________________________
	: (Form event code:C388=On Getting Focus:K2:7)
		
		Form:C1466.combo.expand()
		
		//______________________________________________________
	: (Form event code:C388=On Data Change:K2:15)
		
		If (Form:C1466.combo.currentValue#"")
			
			Form:C1466.combo.automaticInsertion(True:C214)
			
		Else 
			
			Form:C1466.combo.clear()  //reset
			
		End if 
		
		
		//______________________________________________________
	Else 
		
		// A "Case of" statement should never omit "Else"
		
		//______________________________________________________
End case 