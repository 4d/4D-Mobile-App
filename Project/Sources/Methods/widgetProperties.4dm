//%attributes = {"invisible":true}
/*
properties := ***widgetProperties*** ( widget )
 -> widget (Text)
 <- properties (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : widgetProperties
  // Database: 4D Mobile App
  // ID[AE04BD087CA14D98BB21CC5F411883EF]
  // Created #25-5-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Return properties of a widget
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_bottom;$Lon_height;$Lon_left;$Lon_parameters;$Lon_right;$Lon_top)
C_LONGINT:C283($Lon_width)
C_TEXT:C284($Txt_widget)
C_OBJECT:C1216($Obj_properties)

If (False:C215)
	C_OBJECT:C1216(widgetProperties ;$0)
	C_TEXT:C284(widgetProperties ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Txt_widget:=$1
		
	Else 
		
		$Txt_widget:=OBJECT Get name:C1087(Object current:K67:2)
		
	End if 
	
	$Obj_properties:=New object:C1471(\
		"name";"";\
		"type";0;\
		"enabled";True:C214;\
		"visible";True:C214;\
		"left";0;\
		"top";0;\
		"right";0;\
		"bottom";0;\
		"width";0;\
		"height";0;\
		"window";New object:C1471(\
		"left";0;\
		"top";0;\
		"right";0;\
		"bottom";0))
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Obj_properties.name:=$Txt_widget

$Obj_properties.type:=OBJECT Get type:C1300(*;$Txt_widget)

$Obj_properties.enabled:=OBJECT Get enabled:C1079(*;$Txt_widget)
$Obj_properties.visible:=OBJECT Get visible:C1075(*;$Txt_widget)

  // Local coordinates
OBJECT GET COORDINATES:C663(*;$Txt_widget;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)

$Obj_properties.left:=$Lon_left
$Obj_properties.top:=$Lon_top
$Obj_properties.right:=$Lon_right
$Obj_properties.bottom:=$Lon_bottom

$Obj_properties.width:=$Lon_right-$Lon_left
$Obj_properties.height:=$Lon_bottom-$Lon_top

  // Window coordinates
$Obj_properties.window:=New object:C1471

CONVERT COORDINATES:C1365($Lon_left;$Lon_top;XY Current form:K27:5;XY Current window:K27:6)
$Obj_properties.window.left:=$Lon_left
$Obj_properties.window.top:=$Lon_top

CONVERT COORDINATES:C1365($Lon_right;$Lon_bottom;XY Current form:K27:5;XY Current window:K27:6)
$Obj_properties.window.right:=$Lon_right
$Obj_properties.window.bottom:=$Lon_bottom

  //…

OBJECT GET BEST SIZE:C717(*;$Txt_widget;$Lon_width;$Lon_height)
$Obj_properties.bestWidth:=$Lon_width
$Obj_properties.bestHeight:=$Lon_height

$Obj_properties.action:=OBJECT Get action:C1457(*;$Txt_widget)

  // ----------------------------------------------------
  // Return
$0:=$Obj_properties

  // ----------------------------------------------------
  // End