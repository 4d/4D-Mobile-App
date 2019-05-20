C_LONGINT:C283($Lon_bottom;$Lon_left;$Lon_right;$Lon_top)
C_OBJECT:C1216($Obj_widget;$Obj_window)

$Obj_window:=windowProperties (Open form window:C675("UI";Pop up form window:K39:11+0x8000))

$Obj_widget:=widgetProperties 

$Lon_left:=$Obj_widget.window.right
$Lon_top:=$Obj_widget.window.bottom-($Obj_widget.height/2)-($Obj_window.height/2)

CONVERT COORDINATES:C1365($Lon_left;$Lon_top;XY Current window:K27:6;XY Screen:K27:7)

$Lon_right:=$Lon_left+$Obj_window.width
$Lon_bottom:=$Lon_bottom+$Obj_window.height

SET WINDOW RECT:C444($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Obj_window.reference)

DIALOG:C40("UI")