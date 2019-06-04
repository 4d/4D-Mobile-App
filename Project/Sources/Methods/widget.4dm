//%attributes = {"invisible":true}
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($Lon_bottom;$Lon_height;$Lon_left;$Lon_right;$Lon_top;$Lon_width)
C_TEXT:C284($t)
C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(widget ;$0)
	C_TEXT:C284(widget ;$1)
	C_OBJECT:C1216(widget ;$2)
End if 

If (This:C1470=Null:C1517)
	
	$t:=Choose:C955(Count parameters:C259=0;OBJECT Get name:C1087(Object current:K67:2);String:C10($1))
	
	$o:=New object:C1471(\
		"name";$t;\
		"type";OBJECT Get type:C1300(*;$t);\
		"enabled";OBJECT Get enabled:C1079(*;$t);\
		"visible";OBJECT Get visible:C1075(*;$t);\
		"left";0;\
		"top";0;\
		"right";0;\
		"bottom";0;\
		"width";0;\
		"height";0;\
		"bestWidth";0;\
		"bestHeight";0;\
		"window";New object:C1471;\
		"action";OBJECT Get action:C1457(*;$t);\
		"setCordinates";Formula:C1597(OBJECT SET COORDINATES:C1248(*;This:C1470.name;$2.left;$2.top;$2.right;$2.bottom))\
		)
	
	  // Local coordinates
	OBJECT GET COORDINATES:C663(*;$o.name;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
	
	$o.left:=$Lon_left
	$o.top:=$Lon_top
	$o.right:=$Lon_right
	$o.bottom:=$Lon_bottom
	
	$o.width:=$Lon_right-$Lon_left
	$o.height:=$Lon_bottom-$Lon_top
	
	  // Window coordinates
	$o.window:=New object:C1471
	
	CONVERT COORDINATES:C1365($Lon_left;$Lon_top;XY Current form:K27:5;XY Current window:K27:6)
	$o.window.left:=$Lon_left
	$o.window.top:=$Lon_top
	
	CONVERT COORDINATES:C1365($Lon_right;$Lon_bottom;XY Current form:K27:5;XY Current window:K27:6)
	$o.window.right:=$Lon_right
	$o.window.bottom:=$Lon_bottom
	
	  //…
	
	OBJECT GET BEST SIZE:C717(*;$o.name;$Lon_width;$Lon_height)
	$o.bestWidth:=$Lon_width
	$o.bestHeight:=$Lon_height
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($1="xxx")
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
End if 

$0:=$o