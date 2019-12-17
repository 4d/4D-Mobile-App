//%attributes = {"invisible":true}
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($Lon_bottom;$Lon_left;$Lon_right;$Lon_sBottom;$Lon_sLeft;$Lon_sRight)
C_LONGINT:C283($Lon_sTop;$Lon_top)
C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(window ;$0)
	C_TEXT:C284(window ;$1)
	C_OBJECT:C1216(window ;$2)
End if 

If (This:C1470[""]=Null:C1517)
	
	$o:=New object:C1471(\
		"";"window";\
		"reference";Current form window:C827;\
		"process";Null:C1517;\
		"title";Null:C1517;\
		"type";Null:C1517;\
		"frontmost";Null:C1517;\
		"next";Null:C1517;\
		"coordinates";Null:C1517;\
		"screen";Null:C1517;\
		"get";Formula:C1597(window );\
		"isFrontmost";Formula:C1597(Frontmost window:C447=This:C1470.reference);\
		"getType";Formula:C1597(Window kind:C445(This:C1470.reference));\
		"getTitle";Formula:C1597(Get window title:C450(This:C1470.reference));\
		"getNext";Formula:C1597(Next window:C448(This:C1470.reference));\
		"getCoordinates";Formula:C1597(window ("coordinates"));\
		"setTitle";Formula:C1597(SET WINDOW TITLE:C213($1;This:C1470.reference))\
		)
	
	$o.process:=Window process:C446($o.reference)
	$o.title:=$o.getTitle()
	$o.type:=$o.getType()
	$o.frontmost:=$o.isFrontmost()
	$o.next:=$o.getNext()
	$o.getCoordinates()
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($1="coordinates")
			
			GET WINDOW RECT:C443($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$o.reference)
			
			$o.coordinates:=New object:C1471(\
				"left";$Lon_left;\
				"top";$Lon_top;\
				"right";$Lon_right;\
				"bottom";$Lon_bottom;\
				"width";$Lon_right-$Lon_left;\
				"height";$Lon_bottom-$Lon_top)
			
			$o.screen:=New object:C1471(\
				"number";0)
			
			Repeat 
				
				$o.screen.number:=$o.screen.number+1
				
				SCREEN COORDINATES:C438($Lon_sLeft;$Lon_sTop;$Lon_sRight;$Lon_sBottom;$o.screen.number)
				
				$o.screen.left:=$Lon_sLeft
				$o.screen.right:=$Lon_sRight
				$o.screen.width:=$Lon_sRight-$Lon_sLeft
				$o.screen.height:=$Lon_sBottom-$Lon_sTop
				
			Until (($o.screen.left<=$Lon_right)\
				 | ($o.screen.number=Count screens:C437))
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
End if 

$0:=$o