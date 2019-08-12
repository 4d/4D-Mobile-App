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

  // setDimensions (width {; height {; unit }}) allow to define dimensions
  // 'height' is the number of units for the height
  // 'width' is the number of units for the width. If omited the height value will be used (Pass Null to avoid this behavior).
  // The optional parameter 'unit' will be used if passed.
  // If the method is called before the creation of an object in the canvas,
  // The target is canvas itself, otherwise the target is the last created object.
  //$svg:=svg ("keepReference;solid:gold").setDimensions(300)

  // setFill ( color {;opacity }) allow to define fill
  // 'color' is a CSS color string
  // 'opacity' is a number from 0 to 100
  // Pass Null into the parameter 'color' if you just want set the opacity.
  // If the method is called before the creation of an object in the canvas,
  // The target is canvas itself, otherwise the target is the last created object.
$svg:=svg ("keepReference;solid:gold").setDimensions(400).setFill(Null:C1517;25)

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
		
		  // Or use svg member methods if available
		  // You can always add non managed attributes with the member method setAttribute() or setAttributes()
		If (Shift down:C543)
			
			$svg.rect(230;10;100;20)\
				.setStroke("green")\
				.setFill("orangered";50)\
				.setAttributes(New object:C1471(\
				"stroke-width";2;\
				"stroke-dasharray";"2,2"))
			
		Else 
			
			$svg.rect(230;10;100;20)\
				.setStroke(New object:C1471("color";"green";"width";2;"dasharray";"2,2";"opacity";80))\
				.setFill("orangered";50)
			
		End if 
		
		  // Create a group with id "test" & keep its reference
		$t:=$svg.group("test").latest
		
		  // Create a rounded square into the group
		$svg.roundedRect(0;0;New object:C1471("target";$t))\
			.setDimensions(50)\
			.setFill("yellow")\
			.setStroke("blue")\
			.setPosition(20;40)
		
		  // My first text
		If (Shift down:C543)
			
			  // Use default font & set size to 18 pt
			$svg.textArea("Hello World")\
				.setPosition(120;100)\
				.setFont(Null:C1517;18)\
				.setFill("dimgray")
			
		Else 
			
			  // Use default font but set text attributes by passing an object
			$svg.textArea("Hello World ")\
				.setFont(New object:C1471("color";"dimgray";"style";Bold:K14:2+Italic:K14:3;"size";24))\
				.setPosition(120;100)
			
		End if 
		
		ASSERT:C1129($t=$svg.findById("test"))
		ASSERT:C1129($svg.findByPath("svg/rect").length=3)
		ASSERT:C1129(Value type:C1509($svg.findByPath("svg/g/rect"))=Is text:K8:3)
		
		  //______________________________________________________
	: (True:C214)
		
		$o:=New object:C1471(\
			"viewport-fill";"lavender";\
			"viewport-fill-opacity";1;\
			"viewBox";"0 0 1000 500")
		
		$svg.setAttributes($o)
		
		$svg.setDimensions(1000;500;"px")
		
		$svg.rect(10;10;100;20;New object:C1471(\
			"stroke";"blue"))
		
		$svg.rect(10;40;100;20;New object:C1471(\
			"stroke";"red";\
			"fill";"yellow";\
			"rx";5))
		
		  //______________________________________________________
	: (True:C214)
		
		  // Create a rect
		$svg.rect(10;10;100;20)
		
		  //______________________________________________________
End case 

  // getPicture() & getText() return the SVG picture or the XML code as text
  // The optional boolean parameter allow to keep the svgObject's reference into memory then reuse later
  // Otherwise, the reference and the memory are automatically purged
$p:=$svg.getPicture(True:C214)
$t:=$svg.getText(True:C214)

$svg.saveText(Folder:C1567(fk desktop folder:K87:19).file("test svg.xml");True:C214)
$svg.savePicture(Folder:C1567(fk desktop folder:K87:19).file("test svg.png";True:C214))

  // showInViewer() call the command SVGTool_SHOW_IN_VIEWER if the component 4D SVG is available
$svg.showInViewer()

  // close() release the XML tree from the memory
  // If the image and/or XML were created before, they are still available.
$svg.close()