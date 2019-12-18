//%attributes = {"invisible":true}
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($bottom;$l;$left;$right;$top)
C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(window ;$0)
	C_TEXT:C284(window ;$1)
	C_OBJECT:C1216(window ;$2)
End if 

If (This:C1470[""]=Null:C1517)
	
	If (Count parameters:C259>=1)
		
		$l:=Num:C11($1)
		
	Else 
		
		$l:=Current form window:C827
		
	End if 
	
	$o:=New object:C1471(\
		"";"window";\
		"coordinates";Null:C1517;\
		"frontmost";Frontmost window:C447=$l;\
		"process";Window process:C446($l);\
		"reference";$l;\
		"title";Get window title:C450($l);\
		"type";Window kind:C445($l);\
		"screen";Null:C1517;\
		"visible";True:C214;\
		"bringToFront";Formula:C1597(window ("bringToFront"));\
		"getCoordinates";Formula:C1597(window ("getCoordinates"));\
		"hide";Formula:C1597(window ("hide"));\
		"close";Formula:C1597(window ("close"));\
		"maximize";Formula:C1597(window ("maximize"));\
		"minimize";Formula:C1597(window ("minimize"));\
		"show";Formula:C1597(window ("show"));\
		"setRect";Formula:C1597(window ("setRect";New object:C1471("left";$1;"top";$2;"right";$3;"bottom";$4)));\
		"setTitle";Formula:C1597(window ("setTitle";New object:C1471("title";$1)));\
		"next";Formula:C1597(Next window:C448(This:C1470.reference));\
		"isFrontmost";Formula:C1597(window ("isFrontmost").value)\
		)
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="bringToFront")
			
			$o.getCoordinates()
			SET WINDOW RECT:C444($o.coordinates.left;$o.coordinates.top;$o.coordinates.right;$o.coordinates.bottom;$o.reference)
			$o.show()
			
			  //______________________________________________________
		: ($1="close")
			
			CLOSE WINDOW:C154($o.reference)
			
			  //______________________________________________________
		: ($1="hide")
			
			HIDE WINDOW:C436($o.reference)
			$o.visible:=False:C215
			
			  //______________________________________________________
		: ($1="show")
			
			SHOW WINDOW:C435($o.reference)
			$o.visible:=True:C214
			
			  //______________________________________________________
		: ($1="minimize")
			
			MINIMIZE WINDOW:C454($o.reference)
			$o.getCoordinates()
			
			  //______________________________________________________
		: ($1="maximize")
			
			MAXIMIZE WINDOW:C453($o.reference)
			$o.getCoordinates()
			
			  //______________________________________________________
		: ($1="getCoordinates")
			
			GET WINDOW RECT:C443($left;$top;$right;$bottom;$o.reference)
			
			$o.coordinates:=New object:C1471(\
				"left";$left;\
				"top";$top;\
				"right";$right;\
				"bottom";$bottom;\
				"width";$right-$left;\
				"height";$bottom-$top)
			
			$o.screen:=New object:C1471(\
				"number";0)
			
			Repeat 
				
				$o.screen.number:=$o.screen.number+1
				
				SCREEN COORDINATES:C438($left;$top;$right;$bottom;$o.screen.number)
				
				$o.screen.left:=$left
				$o.screen.right:=$right
				$o.screen.width:=$right-$left
				$o.screen.height:=$bottom-$top
				
			Until (($o.coordinates.left>=$o.screen.left)\
				 & ($o.coordinates.right<=$o.screen.right))\
				 | ($o.screen.number=Count screens:C437)
			
			  //______________________________________________________
		: ($1="setRect")
			
			SET WINDOW RECT:C444(Num:C11($2.left);Num:C11($2.top);Num:C11($2.right);Num:C11($2.bottom);$o.reference;*)
			$o.getCoordinates()
			
			  //______________________________________________________
		: ($1="setTitle")
			
			$o.title:=String:C10($2.title)
			SET WINDOW TITLE:C213($o.title;$o.reference)
			
			  //______________________________________________________
		: ($1="isFrontmost")
			
			$o.frontmost:=(Frontmost window:C447=$o.reference)
			$o.value:=$o.frontmost
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
End if 

$0:=$o