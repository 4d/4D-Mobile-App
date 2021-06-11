var $e; $message : Object

$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code<0)  // <SUBFORM EVENTS>
		
		$message:=OBJECT Get value:C1743(OBJECT Get name:C1087(Object current:K67:2))
		
		Case of 
				
				//…………………………………………………………………………………………………
			: ($e.code=-2)\
				 | ($e.code=-1)  // Close
				
				If ($message.accept)
					
					ACCEPT:C269
					
				Else 
					
					GOTO OBJECT:C206(*; "newProject")
					
				End if 
				
				//OBJECT SET VISIBLE(*; "message@"; False)
				EDITOR.messageObjects.hide()
				
				//…………………………………………………………………………………………………
		End case 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 