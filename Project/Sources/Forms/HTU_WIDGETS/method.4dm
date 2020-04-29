C_OBJECT:C1216($event)

$event:=FORM Event:C1606

Case of 
		
		  //______________________________________________________
	: ($event.code=On Load:K2:1)
		
		Form:C1466.button1:=cs:C1710.button.new("Button1").setShortcut("l").highlightShortcut()
		Form:C1466.button2:=cs:C1710.button.new("Button2")
		Form:C1466.button3:=cs:C1710.button.new("Check Box").highlightShortcut()
		Form:C1466.button4:=cs:C1710.button.new("Check Box1").setShortcut("c").highlightShortcut()
		
		Form:C1466.static1:=cs:C1710.static.new("Rectangle1")
		Form:C1466.static2:=cs:C1710.static.new("Rectangle2")
		Form:C1466.static3:=cs:C1710.static.new("Rectangle3")
		Form:C1466.static4:=cs:C1710.static.new("Rectangle4")
		Form:C1466.static5:=cs:C1710.static.new("Rectangle5")
		Form:C1466.static6:=cs:C1710.static.new("Rectangle6")
		
		  // If uncommented, must generate an assert
		  //Form.Input:=cs.widget.new("Input") 
		
		  //______________________________________________________
	: (False:C215)
		
		  //______________________________________________________
	Else 
		
		  // A "Case of" statement should never omit "Else"
		  //______________________________________________________
End case 