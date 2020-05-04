C_OBJECT:C1216($event)

$event:=FORM Event:C1606

Case of 
		
		  //______________________________________________________
	: ($event.code=On Load:K2:1)
		
		  //Form.button1:=cs.button.new("Button1").setShortcut("l").highlightShortcut()
		  //Form.button2:=cs.button.new("Button2")
		  //Form.button3:=cs.button.new("Check Box").highlightShortcut()
		  //Form.button4:=cs.button.new("Check Box1").setShortcut("c").highlightShortcut()
		  //Form.static1:=cs.static.new("Rectangle1")
		  //Form.static2:=cs.static.new("Rectangle2")
		  //Form.static3:=cs.static.new("Rectangle3")
		  //Form.static4:=cs.static.new("Rectangle4")
		  //Form.static5:=cs.static.new("Rectangle5")
		  //Form.static6:=cs.static.new("Rectangle6")
		  //Form.group1:=cs.group.new("Text8,Button4,Button5")
		
		Form:C1466.button1:=object ("Button1").setShortcut("l").highlightShortcut()
		Form:C1466.button2:=object ("Button2")
		Form:C1466.button3:=object ("Check Box").highlightShortcut()
		Form:C1466.button4:=object ("Check Box1").setShortcut("c").highlightShortcut()
		
		Form:C1466.static1:=object ("Rectangle1")
		Form:C1466.static2:=object ("Rectangle2")
		Form:C1466.static3:=object ("Rectangle3")
		Form:C1466.static4:=object ("Rectangle4")
		Form:C1466.static5:=object ("Rectangle5")
		Form:C1466.static6:=object ("Rectangle6")
		
		Form:C1466.group1:=object ("Text8,Button4,Button5")
		
		  // If uncommented, must generate an assert
		  //Form.Input:=cs.widget.new("objectThatDoesNotExist") 
		
		Form:C1466.testThis:="Hello"
		Form:C1466.test:=cs:C1710.input.new("Form.testThis")
		
		  //______________________________________________________
	: (False:C215)
		
		  //______________________________________________________
	Else 
		
		  // A "Case of" statement should never omit "Else"
		  //______________________________________________________
End case 