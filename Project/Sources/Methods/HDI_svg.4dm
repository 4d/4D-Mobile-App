//%attributes = {}
C_PICTURE:C286($p)
C_TEXT:C284($t)
C_OBJECT:C1216($o;$svg)

  // "keepReference" allow to make a get() without release memory (closing the XML tree).
  // Don't omit in this case to call close() to cleanup the memory.
  //$svg:=svg ("keepReference")

  // By defaut a canvas is created with a transparent background.
  // "solid" allow to create a canvas with a white background
  // You can add the color to use after a colon character ie "solid:lavender"
  //$svg:=svg ("keepReference;solid:gold")

  // dimensions (width {; height {; unit }}) allow to define dimensions
  // 'height' is the number of units for the height
  // 'width' is the number of units for the width. If omited the height value will be used (Pass Null to avoid this behavior).
  // The optional parameter 'unit' will be used if passed.
  // If the method is called before the creation of an object in the canvas,
  // The target is canvas itself, otherwise the target is the last created object.
  //$svg:=svg ("keepReference;solid:gold").dimensions(300)

  // fill ( color {;opacity }) allow to define fill
  // 'color' is a CSS color string
  // 'opacity' is a number from 0 to 100
  // Pass Null into the parameter 'color' if you just want set the opacity.
  // If the method is called before the creation of an object in the canvas,
  // The target is canvas itself, otherwise the target is the last created object.
$svg:=svg ("keepReference;solid:gold").dimensions(400).fill(Null:C1517;25)

Case of 
		
		  //______________________________________________________
	: (True:C214)
		
		  // My first rect
		$svg.rect(10;10;100;20)
		
		  // Pass optional attributes if you want
		$svg.rect(120;10;100;20;New object:C1471(\
			"stroke";"blue";\
			"fill";"white";\
			"stroke-width";2))
		
		  // Or use svg methods…
		$svg.rect(230;10;100;20)\
			.stroke("green")\
			.fill("orangered";50)\
			.attributes(New object:C1471("stroke-width";2))
		
		  // Create a group with id "test" & keep its reference
		$t:=$svg.group("test").lastCreatedObject
		
		  // Create a rounded square into the group
		$svg.rect(0;0;New object:C1471("target";$t;"rx";5))\
			.dimensions(50)\
			.fill("yellow")\
			.stroke("red")\
			.position(20;40)
		
		  // My first text
		$svg.textArea("Hello World")\
			.position(120;100)\
			.font(Null:C1517;18)\
			.fill("dimgray")
		
		  //______________________________________________________
	: (True:C214)
		
		$o:=New object:C1471(\
			"viewport-fill";"lavender";\
			"viewport-fill-opacity";1;\
			"viewBox";"0 0 1000 500")
		
		$svg.attributes($o)
		
		$svg.dimensions(1000;500;"px")
		
		$svg.rect(10;10;100;20;New object:C1471(\
			"stroke";"blue"))
		
		$svg.rect(10;40;100;20;New object:C1471(\
			"stroke";"red";\
			"fill";"yellow";\
			"rx";5))
		
		  //______________________________________________________
	: (True:C214)
		
		  // Create a rect
		$svg.rect(10;10;100;20;New object:C1471(\
			"stroke";"blue"))
		
		  //______________________________________________________
End case 

  // Get the picture
$p:=$svg.get("picture")
$t:=$svg.get("xml")

EXECUTE METHOD:C1007("SVGTool_SHOW_IN_VIEWER";*;$svg.root)

$svg.close()