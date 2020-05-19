C_LONGINT:C283($l)
C_OBJECT:C1216($e;$o)
C_COLLECTION:C1488($c)

$e:=FORM Event:C1606

If (Bool:C1537(Form:C1466.trace))\
 & (FORM Get current page:C276=1)\
 & (String:C10($e.objectName)#"trace")
	
	Form:C1466.trace:=False:C215
	TRACE:C157
	
End if 

Case of 
		
		  //———————————————————————————————————————————————
	: ($e.code=On Load:K2:1)
		
		Form:C1466.pages:=New collection:C1472.resize(4)  // 3 pages + page 0
		
		  //______________________________________________________
	: ($e.code=On Page Change:K2:54)
		
		  // <NOTHING MORE TO DO>
		
		  //______________________________________________________
	: (Form:C1466.clickMe.catch($e))
		
		  // <THE WIDGET CALLBACK METHOD HAS BEEN EXECUTED DURING .catch()>
		
		  //Note: You can change on the fly the code executed :-)
		Form:C1466.clickMe.setCallback(Formula:C1597(ALERT:C41("Hello World")))
		
		  //______________________________________________________
	: (Form:C1466.alignRight.catch($e))
		
		ALERT:C41("You have clicked on "+$e.objectName)
		
		  //______________________________________________________
	: (Split string:C1554("execute.reset.trace.next.previous";".").indexOf($e.objectName)#-1)
		
		  // Ignore
		
		  //______________________________________________________
	: (FORM Get current page:C276>1)
		
		  // Ignore
		
		  //______________________________________________________
	Else 
		
		ALERT:C41("Event \""+$e.description+"\" activated unnecessarily for \""+$e.objectName+"\"")
		
		  //______________________________________________________
End case 

$l:=FORM Get current page:C276

If (Form:C1466.pages[$l]=Null:C1517)
	
	Form:C1466.pages[$l]:=True:C214
	
	Case of 
			
			  //______________________________________________________
		: ($l=1)
			
			Form:C1466.alignRight:=cs:C1710.button.new("Button2")
			
			Form:C1466.login:=cs:C1710.button.new("Check Box")\
				.highlightShortcut()\
				.disable()
			
			Form:C1466.close:=cs:C1710.button.new("Check Box1")\
				.setShortcut("c";Command key mask:K16:1)\
				.highlightShortcut()
			
			Form:C1466.blackRect:=cs:C1710.static.new("Rectangle2")
			Form:C1466.greenRect:=cs:C1710.static.new("Rectangle4")
			Form:C1466.blueRect:=cs:C1710.static.new("Rectangle6")
			Form:C1466.redRect:=cs:C1710.static.new("Rectangle3")
			Form:C1466.yellowRect:=cs:C1710.static.new("Rectangle1")
			Form:C1466.grapRect:=cs:C1710.static.new("Rectangle5")
			
			$c:=New collection:C1472
			$c.push(cs:C1710.static.new("Text8").setTitle("CommonMenuFile"))  // Set title with a resname
			$c.push(cs:C1710.button.new("Button4").setTitle("Hello"))  // Set title with a string
			$c.push(cs:C1710.button.new("Button5").disable())
			Form:C1466.group1:=cs:C1710.group.new($c)
			
			  // If uncommented, must generate an assert
			  // Form.Input:=cs.widget.new("objectThatDoesNotExist")
			
			cs:C1710.group.new("execute,reset").distributeHorizontally()
			
			Form:C1466.clickMe:=cs:C1710.button.new("Button1")\
				.setShortcut("m";Command key mask:K16:1)\
				.highlightShortcut()\
				.disable()\
				.setHelpTip("Click on \"Execute\" to activate me")\
				.setCallback(Formula:C1597(ALERT:C41("You have clicked on me."+"\rMy name is: "+This:C1470.name+"\rMy title is: "+This:C1470.getTitle()+"\r\rNow, click again to see...")))
			
			  //=========================================
			  //  Keep coordinates for the reset button
			  //=========================================
			Form:C1466.clickMe.origin:=Form:C1466.clickMe.coordinates
			Form:C1466.alignRight.origin:=Form:C1466.alignRight.coordinates
			Form:C1466.login.origin:=Form:C1466.login.coordinates
			Form:C1466.close.origin:=Form:C1466.close.coordinates
			Form:C1466.yellowRect.origin:=Form:C1466.yellowRect.coordinates
			Form:C1466.blackRect.origin:=Form:C1466.blackRect.coordinates
			Form:C1466.redRect.origin:=Form:C1466.redRect.coordinates
			Form:C1466.greenRect.origin:=Form:C1466.greenRect.coordinates
			Form:C1466.grapRect.origin:=Form:C1466.grapRect.coordinates
			Form:C1466.blueRect.origin:=Form:C1466.blueRect.coordinates
			
			For each ($o;Form:C1466.group1.members)
				
				$o.origin:=$o.coordinates
				
			End for each 
			
			  //______________________________________________________
		: ($l=2)
			
			Form:C1466.nonAssignable:="Hello"
			Form:C1466.testDatasource:=cs:C1710.input.new("Input";Formula:C1597(Form:C1466.nonAssignable))
			Form:C1466.value:=cs:C1710.input.new("Input1")
			Form:C1466.getValue:=cs:C1710.button.new("Button3").disable()
			
			  //______________________________________________________
		: ($l=3)
			
			Form:C1466.input:="Hello world"
			
			  //______________________________________________________
		Else 
			
			Form:C1466.pages[$l]:=Null:C1517
			
			  //______________________________________________________
	End case 
	
Else 
	
	  // A "If" statement should never omit "Else"
	
End if 