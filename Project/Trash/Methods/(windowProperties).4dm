//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : windowProperties
  // ID[1AF1AC299496490C8E1BBF55DBF3EB41]
  // Created 29-1-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Return properties of a window
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_LONGINT:C283($1)

C_LONGINT:C283($Lon_bottom;$Lon_left;$Lon_parameters;$Lon_right;$Lon_top;$Lon_window)
C_OBJECT:C1216($Obj_properties)

If (False:C215)
	C_OBJECT:C1216(windowProperties ;$0)
	C_LONGINT:C283(windowProperties ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Lon_window:=$1
		
	Else 
		
		$Lon_window:=Current form window:C827
		
	End if 
	
	$Obj_properties:=New object:C1471(\
		"reference";0;\
		"process";0;\
		"type";0;\
		"title";"";\
		"left";0;\
		"top";0;\
		"right";0;\
		"bottom";0;\
		"width";0;\
		"height";0;\
		"frontmost";0;\
		"nextWindow";0;\
		"screen";New object:C1471(\
		"number";0;\
		"left";0;\
		"right";0;\
		"width";0;\
		"height";0))
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Obj_properties.reference:=$Lon_window

$Obj_properties.process:=Window process:C446($Lon_window)

$Obj_properties.type:=Window kind:C445($Lon_window)
$Obj_properties.title:=Get window title:C450($Lon_window)

GET WINDOW RECT:C443($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Lon_window)

$Obj_properties.left:=$Lon_left
$Obj_properties.top:=$Lon_top
$Obj_properties.right:=$Lon_right
$Obj_properties.bottom:=$Lon_bottom

$Obj_properties.width:=$Lon_right-$Lon_left
$Obj_properties.height:=$Lon_bottom-$Lon_top

$Obj_properties.frontmost:=(Frontmost window:C447=$Lon_window)
$Obj_properties.nextWindow:=Next window:C448($Lon_window)

Repeat 
	
	$Obj_properties.screen.number:=$Obj_properties.screen.number+1
	
	SCREEN COORDINATES:C438($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Obj_properties.screen.number)
	
	$Obj_properties.screen.left:=$Lon_left
	$Obj_properties.screen.right:=$Lon_right
	$Obj_properties.screen.width:=$Lon_right-$Lon_left
	$Obj_properties.screen.height:=$Lon_bottom-$Lon_top
	
Until (($Obj_properties.left<=$Lon_right)\
 | ($Obj_properties.screen.number=Count screens:C437))

  // ----------------------------------------------------
  // Return
$0:=$Obj_properties

  // ----------------------------------------------------
  // End