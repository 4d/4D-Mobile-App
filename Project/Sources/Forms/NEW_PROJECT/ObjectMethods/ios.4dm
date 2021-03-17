var $e : Object

$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Clicked:K2:4)\
		 & (Not:C34(Form:C1466.$android))
		
		// Force Android
		Form:C1466.$android:=True:C214
		
		//______________________________________________________
	: ($e.code=On Mouse Enter:K2:33)
		
		// Highlights
		OBJECT SET RGB COLORS:C628(*; $e.objectName; EDITOR.selectedColor)
		
		//______________________________________________________
	: ($e.code=On Mouse Leave:K2:34)
		
		// Restore
		OBJECT SET RGB COLORS:C628(*; $e.objectName; Foreground color:K23:1)
		
		//______________________________________________________
End case 