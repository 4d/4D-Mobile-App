# svg

Manipulate svg as objects and make code more readable.

## Create a new SVG object

_svgObject_ [object] := ***svg*** {(_param_ [text] { ; _options_ [object] } )}

- _param_ is an optional text enumeration semicolons separated like `'keepReference;solid:lavender'`.

  1. `keepReference` indicate that the svg reference should be kept in memory after use. In this case, don't omit to [release memory] when svgObject will no more used.
  2. `solid` allow to create a canvas with a white background (transparent by default). To specify another background color you can pass the color expression to use after a colon character ie `solid:lavender`
  3.  `parse` to parse a given BLOB or Text containing an SVG structure into $2.variable
  4.  `load` to parse a document containing an SVG structure given as file object into $2
  5.  `create` to create a new SVG structure (default action if no parameter passed)
  
- _svgObject_ returned object containing the XML reference in memory and associated member methods.

***Default values:***

>`"viewport-fill"="none"`    
>`"fill"="none"`    
>`"stroke"="black"`    
>`"font-family"="'lucida grande','segoe UI',sans-serif"`    
>`"font-size"=12`    
>`"text-rendering"="geometricPrecision"`    
>`"shape-rendering"="crispEdges"`    
>`"preserveAspectRatio"="none"`

## Properties

 Properties  | Contains                                                                                       | Initial value
------------ |-------------                                                                                   |-------------
*root*       | The XML reference of the SVG tree                                                              |
*latest*     | The XML reference of the last created object using a creation member method                    | Null
*success*    | A boolean that indicates whether a member method call was successfully executed                |
*errors*     | A collection of textual descriptions of encountered errors                                     | [ ]
*autoClose*  | A boolean that indicates whether the xml tree should be closed after a call to one of the `getPicture ()`, `getText ()`, `savePicture ()`, `saveText ()`, or `save ()` member methods      | True 
*picture*    | The image generated of the last `get ("picture")` call                                         | Null
*xml*        | The XML text generated from the last `get ("xml")` call                                        | Null
*origin*     | The object pathname of a file initially loaded                                                 | Null
*file*       | The object pathname of the last `save()` call                                                  | Null


**Notes**: 

>* If a setting member method is called before the creation of an object in the canvas, the target is canvas itself, otherwise the target is the last created object. Where appropriate, the target of the method can be given (see above)
>* Remember that you can still add unmanaged attributes for the moment with the member methods setAttribute() or setAttributes() (see above)
>* Remember that you can always use DOM XML commands to manipulate the SVG tree (*root*) or object (*latest*)
>* With the exception of utility methods, all member methods return the _svgObject_ so that methods can be chained

## Member methods

### Creation
 |  
-------------      |-------------
`group()`          | Creates a group
`rect()`           | Creates a square or rectangle
`roundRect()`      | Creates a rounded square or rectangle
`image()`          | Puts a referenced image
`embedPicture()`   | Embeds a picture variable
`textArea()`       | Creates a text area


### Settings
 |  
-------------      |-------------
`setAttribute()`   | Sets one attribute
`setAttributes()`  | Sets one or more attributes
`setPosition()`    | Sets the position
`setDimensions()`  | Sets the dimensions
`setFill()`        | Sets the background color and opacity
`setStroke()`      | Sets the foreground properties
`setFont()`        | Sets the font properties
`setVisible()`     | Sets the visibility of an element
`setStyleSheet()`  | Adds a reference to an external style sheet.

### Document
 |  
-------------      |-------------
`savePicture()`    | Save the SVG structure as `picture` file (Also populates the *picture* property if success).
`saveText()`       | Save the SVG structure as `text` file (Also populates the *xml* property if success).
`save()`           | Saves the SVG into the initially loaded file or the last created file by calling `savePicture()`or `saveText()`member methods (Also populates the *picture* or *xml* property if success).
`close()`          | Releases the XML tree from the memory.


### Utilities
 |  
-------------      |-------------
`getPicture()`     | Returns the picture generated from the SVG tree (Also populates the *picture* property if success).
`getText()`        | Returns the text generated from the SVG tree (Also populates the *xml* property if success).
`findByPath()`     | Searches for one or more elements corresponding to an XPath & returns its reference or a collection if any.
`findById()`       | Searches for the element whose id attribute equals the value passed & Returns its reference, if found.
`showInViewer()`   | Display the SVG picture & tree into the SVG Viewer if the component 4D SVG is available.

## Sample code

	$svg:=svg
	
	// My first rect	$svg.rect(10;10;100;20)
	
	// Pass optional attributes if you need	`$svg.rect(120;10;100;20;New object("stroke";"blue";"fill";"white";"stroke-width";2))
	
	// Or use svg methods if available
	// You can always add unmanaged attributes with attribute() or attributes()	$svg.rect(230;10;100;20)\
		.setStroke("green")\
		.setFill("orangered";50)\
		.setAttributes(New object("stroke-width";2;"stroke-dasharray";"2,2")
	
	// Create a group with id "test" & keep its reference	$g:=$svg.group("test").latest
	
	// Create a rounded square into the group	$svg.rect(0;0;New object("target";$g;"rx";5))\
		.setDimensions(50)\
		.setFill("yellow")\
		.setStroke("red")\
		.setPosition(20;40)
	
	// My first text	$svg.textArea("Hello World").setPosition(120;100).setFont(Null;18).setFill("dimgray")
	
	// Get the image (but keep the SVG tree in memory for later use)	$p:=$svg.getPicture(True)
	
	// Save as XML file to the desktop (but keep the SVG tree in memory for later use)	$svg.saveText(Folder(fk desktop folder).file("test svg.xml");True)
	
	// Save as PNG file to the desktop (the memory is automatically released)	$svg.savePicture(Folder(fk desktop folder).file("test svg.png"))

