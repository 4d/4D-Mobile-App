C_LONGINT:C283($bottom;$left;$right;$top)
C_OBJECT:C1216($widget;$window)

  // Get widget definition
$widget:=widget 

  // Open a form window & get its coordinates
$window:=window (String:C10(Open form window:C675("UI";Pop up form window:K39:11+0x8000))).getCoordinates()

  // Calculate the desired coordinates
$left:=$widget.windowCoordinates.right
$top:=$widget.windowCoordinates.bottom-($widget.coordinates.height/2)-($window.coordinates.height/2)

CONVERT COORDINATES:C1365($left;$top;XY Current window:K27:6;XY Screen:K27:7)

$right:=$left+$window.coordinates.width
$bottom:=$bottom+$window.coordinates.height

  // Set the position of the form window
$window.setRect($left;$top;$right;$bottom)

DIALOG:C40("UI")

$window.close()