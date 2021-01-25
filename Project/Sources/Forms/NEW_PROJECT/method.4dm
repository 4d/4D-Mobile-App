var $e : Object

$e:=FORM Event:C1606

Case of 
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		If (Is Windows:C1573)
			
			cs:C1710.button.new("apple").hide()
			cs:C1710.button.new("android").disable()
			
		End if 
		
		//______________________________________________________
	: ($e.code=On Activate:K2:9)
		
		GOTO OBJECT:C206(*; "name")
		
		//______________________________________________________
End case 
