## [s]CALABLE [v]ECTOR [g]GRAPHICS

The goal of this class is to reduce the complexity of code to create and manipulate svg images/documents.
This class will be augmented according to my needs but you are strongly encouraged to participate yourself through pull request.

## Summary

⚠️ svg extends the <a href="xml.md">`xml`</a>class

## Properties:

|Properties|Type|Description|Initial value|
|---------|:----:|------|:------:|
|**.root**|Text|The DOM tree reference in memory of the document virtual structure|**Null**|
|**.autoClose**|Boolean|Indicates whether the XML tree should be automatically closed after a call to one of the functions: `.exportPicture()`, `.exportText()`, `.picture()`, `.getText()`, `.save()` or `.preview()`|**True\*** 🚨|
|**.file**|**4D**.File|The disk file of the last `.save()` or `.load()`call|**Null**|
|**.success**|Boolean|Indicates whether a function call was successfully executed|
|**.errors**|Collection|The list of errors encoutered, if so|[ ]|
|**.latest**|Text|The DOM reference of the last element created|**Null**|
|**.graphic**|Picture|The image generated by the last call to the `.picture()` function.|**Null**|
|**.xml**|Text|The SVG tree as text generated during the last call to the `.getText()` function.|**Null**|
|**.store**|Collection|The element references memorized (see below)|[ ]|

\* 🚨 If `.autoClose` is set to **False** (or if you don't call a function that automatically closes the structure), once you no longer need the structure, remember to call the function `.close()` in order to free up the memory.


> 📌 With the exception of functions that return a specific result (getter function), each call returns the original `cs.svg` object, and you can include one call after another.

### Basic elements

> 📌 When a element creation function is called without passing the `attachTo` parameter, the object is included to the last created structure that can be used to add an object. If the `attachTo` parameter is passed, it can be: a DOM reference, an id, the name of a reference stored with the `.push()` function or a reserved name (`"root"`, `"latest"` or `"parent"`).

|Function|Action|
|--------|------|   
|.**rect** ( height : `Real` {; width : `Real` } {; attachTo} ) → `cs.svg` | Creates a rectangle<br>Rounded rectangles can be obtained using `.rx()` & `.ry()`
|.**circle** ( radius : `Real` {; cx : `Real` {; cy : `Real`}} {; attachTo } ) → `cs.svg` | Creates a circle based on a center point and a radius.
|.**ellipse** ( radiusX : `Real`; radiusY : `Real`; cx : `Real`; cy : `Real` {; attachTo } ) → `cs.svg` | Creates an ellipse based on a center point and two radii  
|.**line** ( x1 : `Real`; y1 : `Real`; x2 : `Real`; y2 : `Real` {; attachTo } ) → `cs.svg` | Creates a line segment that starts at one point (`x1`,`y1`) and ends at another (`x2`,`y2`) 
|.**polyline** ( points : `Text` \| `Collection` {; attachTo } ) → `cs.svg` | Creates a set of connected straight line segments. Typically, `polyline` elements define open shapes.
|.**polygon** ( points : `Text` \| `Collection` {; attachTo } ) → `cs.svg` | Creates a closed shape consisting of a set of connected straight line segments.
|.**text** ( text : `Text` {; attachTo } ) → `cs.svg` | Creates a graphics element consisting of text.
|.**textArea** ( text : `Text` {; attachTo } ) → `cs.svg` | Creates a `textArea` element that allows simplistic wrapping of a text content within a given region.\*
|.**image** ( picture : `Picture` \| `4D.File` {; attachTo } ) → `cs.svg` | Creates an image element.<br>Can refer to an image file or a picture type variable (embedded picture)

\* The `textArea` elements are well rendered by 4D widgets but may not be supported by some browsers.

### Setting functions

> 📌 If a setting function is called, without passing the `applyTo` parameter, before the creation of an object in the canvas, the target is canvas itself, otherwise the target is the last created object. If the `applyTo` parameter is passed, it can be: a DOM reference, an id, the name of a reference stored with the `.push()` function or a reserved name (`"root"`, `"latest"`, `"parent"`).    

> 📌 Remember that you can still add unmanaged attributes with the functions `.setAttribute()` or `.setAttributes()`     

> 📌 Remember that you can always use DOM XML commands to manipulate the SVG tree `.root`, object `.latest` or reference retrieved with the `.fetch()` function.

|Function|Action|
|--------|------|
|.**id** ( id : `Text` {; applyTo } ) → `cs.svg` | Assigns a unique name to an element (standard XML attribute)
|.**x** ( x : `Real` {; applyTo } ) → `cs.svg` | Sets the x
|.**y** ( y : `Real` {; applyTo } ) → `cs.svg` | Sets the y
|.**width** ( width : `Real` {; applyTo } ) → `cs.svg` | Sets the width
|.**height** ( height : `Real` {; applyTo } ) → `cs.svg` | Sets the height
|.**translate** (tx : `Real` {; ty : `Real`} {; applyTo } ) →` cs.svg` | Specifies a translation by `tx` and `ty`. If the `ty` value is not provided, it is assumed to be zero
|.**scale** ( sx : `Real` {; sy : `Real` } {; applyTo } ) → `cs.svg` | Specifies a scaling operation by `sx` and `sy`. If the value `sy` is not provided, it is assumed to be equal to `sx`
|.**rotate** ( angle : `Integer` {; cx : `Real` ; cy : `Real`} {; applyTo } ) → `cs.svg` | Specifies a rotation of the `angle` value in degrees of a given point ;<br> • If the optional parameters `cx` and `cy` are not supplied, the rotation is performed with respect to the origin of the current user coordinate system.<br> • If the optional parameters `cx` and `cy` are supplied, the rotation is performed with respect to the point (`cx`,`cy`).
|.**fillColor** ( color : `Text` {; applyTo } ) → `cs.svg` | Sets the fill color
|.**fillOpacity** ( opacity : `Real` {; applyTo } ) → `cs.svg` | Sets the fill opacity
|.**strokeColor** ( color : `Text` {; applyTo } ) → `cs.svg` | Sets the stroke color
|.**strokeWidth** ( width : `Real` {; applyTo } ) → `cs.svg` | Sets the stroke width
|.**strokeOpacity** ( opacity : `Real` {; applyTo } ) → `cs.svg` | Sets the stroke opacity
|.**fontFamily** ( fonts : `Text` {; applyTo } ) → `cs.svg` | Sets the font family
|.**fontSize** ( size : `Integer` {; applyTo } ) → `cs.svg` | Sets the font size
|.**fontStyle** ( style : `Integer` {; applyTo } ) → `cs.svg` | Sets teh font style
|.**alignment** ( alignment : `Integer` {; applyTo } ) → `cs.svg` | Sets the text alignment
|.**textRendering** ( rendering : `Text` {; applyTo } ) → `cs.svg` | Fix the text rendering
|.**visible** ( visible : `Boolean` {;applyTo } ) → `cs.svg` | Sets object visibility
|.**class** ( class : `Text` {; applyTo } ) → `cs.svg` | Sets the node class
|.**style** ( style : `Text` {; applyTo } ) → `cs.svg` | Assigns an embedded style
|.**preserveAspectRatio** ( value : `Text` {; applyTo} ) → `cs.svg` | Sets the attribute "preserveAspectRatio"
|.**r** ( r : `Real` {; applyTo } ) → `cs.svg` | Sets the radius of a circle
|.**rx** ( rx : `Real` {; applyTo } ) → `cs.svg` | Sets the rx of a rect or an ellipse
|.**ry** ( ry : `Real` {; applyTo } ) → `cs.svg` | Sets the ry of an ellipse
|.**cx** ( cx : `Real` {; applyTo } ) → `cs.svg` | Sets the cx of a circle or ellipse
|.**cy** ( cy : `Real` {; applyTo } ) → `cs.svg` | Sets the cy of a rect or an ellipse
|.**points** ( points : `Text` \| `Collection` {; applyTo } ) → `cs.svg` | Sets the "points" property of a polyline/polygon
|.**M** ( points : `Text` \| `Collection` {; applyTo } ) → `cs.svg` | Absolute moveTo
|.**L** ( points : `Text` \| `Collection` {; applyTo } ) → `cs.svg` | Absolute lineTo
|.**setAttribute** ( name : `Text`; value : `Variant` {; applyTo } ) → `cs.svg` | Sets one attribute
|.**setAttributes** ( attributes : `Text` \| `Collection` \| `Object`; value : `Variant` {; applyTo})  → `cs.svg` | Defines multiple attributes


### Document & structure functions

|Function|Action|
|--------|------|
|.**load** ( source : `4D.File` \| `Text` \| `Blob` {; validate : `Boolean` {; schema : `Text` }} ) → `cs.svg` | Loads a SVG tree from a file or a variable (TEXT or BLOB)
|.**picture** ( { exportType : `Integer`} {; keepStructure : `Boolean` } ) → `Picture`  | Returns the picture described by the SVG structure & populates the `.graphic` property if success.
|.**content** ( { keepStructure : `Boolean` } ) → `Text`  | Returns the SVG tree as text & populates the `.xml` property if success.
|.**exportPicture** ( file : `4D.file` {; keepStructure : `Boolean`} ) → `cs.svg` | Saves the SVG tree as a picture file.
|.**exportText** ( file : `4D.file` {; keepStructure : `Boolean`} ) → `cs.svg` | Writes the content of the SVG tree into a disk file.
|.**newCanvas** ( { attributes : `Object` } ) → `cs.svg` | Close the current tree if any & create a new svg default structure.
|.**close** () → `cs.svg` | Frees the memory taken up by the SVG tree \*
|.**save** ( { keepStructure : `Boolean` } ) → `cs.svg` | Saves the content of the SVG tree into the initially loaded file or the last created file by calling `exportText()`
|.**group** ( { id : `Text` {; attachTo }} ) → `cs.svg` | Defines a `g` element who is a container element for grouping together related graphics elements.
|.**symbol** ( name : `Text` {; applyTo } ) → `cs.svg` | To define a symbol
|.**use** ( symbol : `Text` {; attachTo } ) → `cs.svg` | To place an occurence of a symbol
|.**styleSheet** ( file : `4D.File` ) → `cs.svg` | Attach a style sheet
|.**viewbox** ( left : `Real`; top : `Real` ; width : `Real` ; height : `Real` {; attachTo } ) → `cs.svg` | Sets the `viewBox` attribute of an SVG viewport.

\* After the execution,`.root`is null but `.graphic` & `.xml` are always available

### Shortcuts & utilities functions
 
|Function|Action|
|--------|------| 
|.**square** ( side : `Real` {; attachTo } ) → `cs.svg` | To draw a square
|.**color** ( color : `Text` {; applyTo } ) → `cs.svg` | Defines the color of both the line and the fill (`stroke` & `fill` attributes)
|.**opacity** ( opacity : `Real` {; applyTo } ) → `cs.svg` | Sets stroke and fill opacity
|.**fill** ( value `Text` \| `Boolean` \| `Object` {; applyTo } ) → `cs.svg` |  To define the painting of the inside of a shape (`fill` attributes)
|.**stroke** ( value `Text` \| `Boolean` \| `Real` \| `Object` {; applyTo } ) → `cs.svg` | To define the painting of the outline of a shape (`stroke` attribute)
|.**font** ( attributes : `Object` {; applyTo } ) → `cs.svg` | Sets the font attributes
|.**size** ( { width : `Real`; height : `Real` {; unit : `Text` }} ) → `cs.svg` | Sets the dimensions
|.**position** ( x : `Real` {; y : `Real` }{; unit : `Text` } ) → `cs.svg` | Sets the position
|.**moveHorizontally** ( x : `Real` {; applyTo } ) → `cs.svg` | Moves horizontally
|.**moveVertically** ( y : `Real` {; applyTo } ) → `cs.svg` | Moves vertically
|.**radius** ( radius : `Integer` {; applyTo} ) → `cs.svg` | Fix the radius of a circle or a rounded rectangle
|.**plot** ( points : `Text` \| `Collection` {; applyTo} ) → `cs.svg` | Populate the "points" property of a polyline, polygon or the "data" proprety of a path
|.**show** ( { applyTo } ) → `cs.svg` | Make visible
|.**hide** ( { applyTo } ) → `cs.svg` | Make invisible
|.**setValue** ( value : `Text` {; applyTo }{; CDATA : `Boolean` } ) → `cs.svg` | Sets the element value
|.**setText** ( text : `Text` {; applyTo } )| To set the text value of a `text` or a `textArea`
|.**attachTo** ( parent : `Text` ) → `cs.svg` | Adds item to parent item
|.**clone** ( source : `Text` {; attachTo} ) → `cs.svg` |To create a copy of a svg object
|.**addClass** ( class : `Text` {; applyTo} ) → `cs.svg` | Add a value to the node class
|.**removeClass** ( class : `Text` {; applyTo} ) → `cs.svg` | Remove a value to the node class
|.**isOfClass** ( class : `Text` {; applyTo } ) → `isOfclass` : Boolean | Tests if the node belongs to a class
|.**layer** ( name : `Text` ) → `cs.svg` | Creates one or more group at the root of the SVG structure
|.**push** ( name : `Text` ) → `cs.svg` | Keeps the dom reference into the store associated with the given name
|.**fetch** ( name : `Text` ) → dom : `Text` | Retrieve a stored dom reference associated with the given name
|.**with** ( name : `Text` ) → `Boolean` | Defines an element for the next operations
|.**preview** ( { keepStructure : `Boolean` } ) | Display the SVG image & tree into the SVG Viewer if the component 4D SVG is available.


## 🔸 cs.svg.new()
The class constructor `cs.svg.new()` can be called without parameters to create a default svg structure with these attributes:
>`"viewport-fill"="none"`    
>`"fill"="none"`    
>`"stroke"="black"`    
>`"font-family"="'lucida grande','segoe UI',sans-serif"`    
>`"font-size"=12`    
>`"text-rendering"="geometricPrecision"`    
>`"shape-rendering"="crispEdges"`    
>`"preserveAspectRatio"="none"`

The class constructor also accepts an optional parameter, so you can create a svg structure by passing a 4D.File, a Blob variable or a Text variable.
>`cs.svg.new(4D.file)` Loads & parses the file content    
>`cs.svg.new(Blob)` Parses the blob variable content     
>`cs.svg.new(Text)` Parses the text variable content




