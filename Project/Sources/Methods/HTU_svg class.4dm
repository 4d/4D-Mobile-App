//%attributes = {}
If (True:C214)
	
	var $svg : cs:C1710.svg
	
	// Create a new canvas
	$svg:=cs:C1710.svg.new()
	
	// Create a symbol
	$svg.square(20).color("orange").symbol("square")
	
	// Create a "background" & \e'"foreground" group & apply a translation to the last one
	$svg.layer("background"; "foreground").translate(45; 45)  // Layers are automatically created at the root level
	
	// Create a yellow square and store its reference associated with the label "original"
	// Automatically created into the last container ("foreground")
	$svg.square(20).position(2.5; 2.5).color("yellow").push("original")
	
	// Add, into the "background" layer, a blue circle without fill & with a border of 4 pixels
	$svg.circle(50).color("blue").position(130; 130).fill(False:C215).stroke(4).attachTo("background")
	
	// Clone the "original" square, colore it red, change its dimensions
	// Automatically created into the last container ("background")
	$svg.clone("original").color("red").position(10; 10).size(130; 130)
	
	If ($svg.with("foreground"))
		
		$svg.use("square").scale(2).translate(80; 80).id("use1")
		
		// Drawing a polyline
		$svg.polyline("50,375 150,375 150,325 250,325 250,375 350,375 350,250 450,250 450,375 550,375 550,175 650,175 650,375 750,375 750,100 850,100 850,375 950,375 950,25 1050,25 1050,375 1150,375").stroke(10).stroke("dimgray")
		
	End if 
	
	// Drawing a star red with a blue border 10 pixels width
	$svg.polygon().points(JSON Parse:C1218("[[350,75],[379,161],[469,161],[397,215],[423,301],[350,250],[277,301],[303,215],[231,161],[321,161]]")).fill("red").stroke("blue").stroke(10).translate(0; -40).attachTo("background")
	
	If ($svg.with("foreground"))  // Set "foreground" layer for the next operations
		
		$svg.ellipse(300; 100; 500)
		$svg.textArea("Hello\nworld").translate(3; -3).fontSize(26)
		
		If ($svg.with("original"))
			
			$svg.moveHorizontally(1)
			$svg.width(18)
			
		End if 
	End if 
	
	If ($svg.with("background"))  // Set "background" layer for the next operations
		
		// Drawing a green hexagon with a blue border 10 pixels width
		$svg.polygon()\
			.M(New collection:C1472(850; 75))\
			.L(New collection:C1472(958; 137.5))\
			.L(New collection:C1472(958; 262.5))\
			.L(New collection:C1472(850; 325))\
			.L(New collection:C1472(742; 262.6))\
			.L(New collection:C1472(742; 137.5))\
			.fill("lime").stroke("blue").stroke(10).translate(0; -40).rotate(20; 850; 160)
		
	End if 
	
	// Show the result into the SVG viewer
	// The memory is automatically freed
	$svg.preview()
	
Else 
	
	var $svg : cs:C1710.svg
	
	// Create a new canvas
	$svg:=cs:C1710.svg.new()
	
	// Create a "background" & '"foreground" group & apply a translation to the last one
	// [Layers are automatically created at the root level]
	$svg.layer("background"; "foreground").translate(45; 45)
	
	// Create a yellow square & memorize its reference as "original"
	// [The object is automatically added to the latest created/used "container" ("foreground")]
	$svg.square(20).position(2.5; 2.5).color("yellow").push("original")
	
	// Set "background" layer for the next operations
	If ($svg.with("background"))
		
		// Add, a blue circle without fill & with a border of 4 pixels
		$svg.circle(50).color("blue").position(100; 100).fill(False:C215).stroke(4)
		
		// Clone the "original" square, colore it red, change its dimensions
		$svg.clone("original").color("red").position(10; 10).size(100; 100)
		
	End if 
	
	// Show the result into the SVG viewer
	// [The memory is automatically freed]
	$svg.preview()
	
End if 