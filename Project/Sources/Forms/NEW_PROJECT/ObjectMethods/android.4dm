var $e : Object

$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Clicked:K2:4)\
		 & (Not:C34(Form:C1466.$android))
		
		Form:C1466.$ios:=Is macOS:C1572 & False:C215
		Form:C1466.$android:=Is Windows:C1573
		
		//______________________________________________________
	: ($e.code=On Mouse Enter:K2:33)
		
		// Highlights
		OBJECT SET RGB COLORS:C628(*; $e.objectName; UI.selectedColor)
		
		//______________________________________________________
	: ($e.code=On Mouse Leave:K2:34)
		
		// Restore
		OBJECT SET RGB COLORS:C628(*; $e.objectName; Foreground color:K23:1)
		
		//______________________________________________________
End case 