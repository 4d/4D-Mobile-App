//%attributes = {}
If (True:C214)
	
	var $svg : cs:C1710.svg
	
	// Create a new canvas
	$svg:=cs:C1710.svg.new()
	
	// Create a "background" group, its address is automatically memorized
	// The object will automatically be added to the latest created "container" ("svg")
	// The reference is automatically memorized into the store
	$svg.group("background")
	
	// Create a "foreground" group and apply a translation
	// We must precise the "root" destination else the group will be included into the "background" one
	$svg.group("foreground").translate(45; 45).attachTo("root")
	
	// Create a yellow square & memorize its reference as "original"
	// The object will automatically be added to the latest created "container" ("foreground" layer)
	$svg.square(20).position(2.5; 2.5).color("yellow").push("original")
	
	// Add, into the "background" layer, a blue circle without fill & with a border of 4 pixels
	$svg.circle(50).color("blue").translate(100; 100).fill(False:C215).stroke(4).attachTo("background")
	
	// Clone the "original" square, colore it red, change its dimensions & puts it into the "background" layer
	$svg.clone("original").color("red").position(10; 10).dimensions(100; 100).attachTo("background")
	
	
	// Show the result into teh SVG viewer
	// The memory is automatically freed
	$svg.preview()
	
Else 
	
	var $root; $background; $foreground; $rect; $circle : Text
	
	// Create a new canvas
	$root:=SVG_New
	
	// Create a "background" group, 
	$background:=SVG_New_group($root)
	
	// Create a "foreground" group and apply a translation
	$foreground:=SVG_New_group($root)
	SVG_SET_TRANSFORM_TRANSLATE($foreground; 45; 45)
	
	// Create a yellow square
	$rect:=SVG_New_rect($foreground; 2.5; 2.5; 20; 20)
	SVG_SET_FILL_BRUSH($rect; "yellow")
	SVG_SET_STROKE_BRUSH($rect; "yellow")
	
	// Add, into the "background" layer, a blue circle without fill & with a border of 4 pixels
	$circle:=SVG_New_circle($background; 100; 100; 50)
	SVG_SET_FILL_BRUSH($circle; "none")
	SVG_SET_STROKE_BRUSH($circle; "blue")
	SVG_SET_STROKE_WIDTH($circle; 4)
	
	// Create a yellow square
	$rect:=SVG_New_rect($background; 10; 10; 100; 100)
	SVG_SET_FILL_BRUSH($rect; "red")
	SVG_SET_STROKE_BRUSH($rect; "red")
	
	// Show the result into teh SVG viewer
	SVGTool_SHOW_IN_VIEWER($root)
	
	// Do not forget to release the memory !
	SVG_CLEAR($root)
	
End if 




