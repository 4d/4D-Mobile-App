//C_LONGINT($bottom; $left; $right; $top)
//C_OBJECT($widget; $window)

//// Get widget definition
//$widget:=widget

//// Open a form window & get its coordinates
//$window:=window(String(Open form window("UI"; Pop up form window+0x8000))).getCoordinates()

//// Calculate the desired coordinates
//$left:=$widget.windowCoordinates.right
//$top:=$widget.windowCoordinates.bottom-($widget.coordinates.height/2)-($window.coordinates.height/2)

//CONVERT COORDINATES($left; $top; XY Current window; XY Screen)

//$right:=$left+$window.coordinates.width
//$bottom:=$bottom+$window.coordinates.height

//// Set the position of the form window
//$window.setRect($left; $top; $right; $bottom)

//DIALOG("UI")

//$window.close()