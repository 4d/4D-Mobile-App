var $e : Object

$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Bound Variable Change:K2:52)
		
		OBJECT SET VISIBLE:C603(*; "android"; False:C215)
		
		If (Length:C16(String:C10(Form:C1466.message))=0)
			
			// Reset
			OBJECT SET RGB COLORS:C628(*; "background"; 0x001BA1E5; 0x001BA1E5)
			
		Else 
			
			Case of 
					
					//______________________________________________________
				: (Form:C1466.type=Null:C1517)\
					 | (String:C10(Form:C1466.type)="message")
					
					OBJECT SET RGB COLORS:C628(*; "background"; 0x001BA1E5; 0x001BA1E5)
					
					//______________________________________________________
				: (Form:C1466.type="error")
					
					OBJECT SET RGB COLORS:C628(*; "background"; "red"; "red")
					
					//______________________________________________________
				: (Form:C1466.type="android")
					
					OBJECT SET RGB COLORS:C628(*; "background"; 0x004FBB61; 0x004FBB61)
					OBJECT SET VISIBLE:C603(*; "android"; True:C214)
					
					//______________________________________________________
			End case 
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 