
Class extends xml

Class constructor($variableOrFile)
	
	If (Count parameters:C259>=1)
		
		Super:C1705($variableOrFile)
		
	Else 
		
		Super:C1705()
		
		// Create an empty canvas
		This:C1470.new()
		
	End if 
	
	This:C1470.latest:=Null:C1517
	This:C1470.picture:=Null:C1517
	This:C1470.store:=New collection:C1472
	
	//———————————————————————————————————————————————————————————
	// Create a default SVG structure
Function new($attributes : Object)->$this : cs:C1710.svg
	
	var $node; $t : Text
	
	This:C1470.close()  // Release memory
	
	$node:=DOM Create XML Ref:C861("svg"; "http://www.w3.org/2000/svg")
	This:C1470.success:=Bool:C1537(OK)
	
	If (This:C1470.success)
		
		This:C1470.root:=$node
		
		DOM SET XML ATTRIBUTE:C866($node; \
			"xmlns:xlink"; "http://www.w3.org/1999/xlink")
		
		DOM SET XML DECLARATION:C859($node; "UTF-8"; True:C214)
		XML SET OPTIONS:C1090($node; XML indentation:K45:34; Choose:C955(Is compiled mode:C492; XML no indentation:K45:36; XML with indentation:K45:35))
		
		$node:=DOM Create XML element:C865(This:C1470.root; "def")
		This:C1470.success:=Bool:C1537(OK)
		
		If (This:C1470.success)
			
			// Default values
			DOM SET XML ATTRIBUTE:C866(This:C1470.root; \
				"viewport-fill"; "none"; \
				"fill"; "none"; \
				"stroke"; "black"; \
				"font-family"; "'lucida grande','segoe UI',sans-serif"; \
				"font-size"; 12; \
				"text-rendering"; "geometricPrecision"; \
				"shape-rendering"; "crispEdges"; \
				"preserveAspectRatio"; "none")
			
		End if 
	End if 
	
	This:C1470.success:=Bool:C1537(OK) & (This:C1470.root#Null:C1517)
	
	If (This:C1470.success)
		
		If (Count parameters:C259>=1)
			
			If ($attributes#Null:C1517)
				
				For each ($t; $attributes)
					
					Case of 
							
							//_______________________
						: ($t="keepReference")
							
							This:C1470.autoClose:=Bool:C1537($attributes[$t])
							
							//_______________________
						Else 
							
							DOM SET XML ATTRIBUTE:C866(This:C1470.root; \
								$t; $attributes[$t])
							
							//______________________
					End case 
				End for each 
				
			Else 
				
				// <NOTHING MORE TO DO>
				
			End if 
			
		Else 
			
			// <NOTHING MORE TO DO>
			
		End if 
		
	Else 
		
		This:C1470.errors.push("Failed to create SVG structure.")
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Create a group
Function group($id : Text; $addTo : Variant)->$this : cs:C1710.svg
	
	var $parent : Text
	
	If (Count parameters:C259>=2)
		
		$parent:=This:C1470._addTo($addTo)
		
		This:C1470.latest:=Super:C1706.create($parent; "g")
		Super:C1706.setAttribute(This:C1470.latest; "id"; $id)
		This:C1470.push()
		
	Else 
		
		If (This:C1470._isReference($id))
			
			// Witjout id
			This:C1470.latest:=Super:C1706.create(This:C1470._addTo($id); "g")
			
		Else 
			
			This:C1470.latest:=Super:C1706.create(This:C1470._addTo(); "g")
			Super:C1706.setAttribute(This:C1470.latest; "id"; $id)
			This:C1470.push()
			
		End if 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Adds item to parent item
Function addTo($parent : Variant)->$this : cs:C1710.svg
	
	var $node; $target : Text
	
	If (Count parameters:C259>=1)
		
		$target:=This:C1470._addTo($parent)
		
	Else 
		
		$target:=This:C1470._addTo()
		
	End if 
	
	$node:=This:C1470.latest
	
	This:C1470.latest:=Super:C1706.copy($node; $target)
	This:C1470.remove($node)
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Keep the dom reference for future use
Function push($name : Text)->$this : cs:C1710.svg
	
	var $id : Text
	
	If (Count parameters:C259>=1)
		
		This:C1470.success:=(This:C1470.store.query("id=:1"; $name).pop()=Null:C1517)
		
		If (This:C1470.success)
			
			This:C1470.store.push(New object:C1471(\
				"id"; $name; \
				"dom"; This:C1470.latest))
			
		Else 
			
			This:C1470.errors.push("The element \""+$name+"\" already exists")
			
		End if 
		
	Else 
		
		// Use id if any
		$id:=String:C10(This:C1470.getAttribute(This:C1470.latest; "id"))
		
		If (Length:C16($id)>0)
			
			This:C1470.store.push(New object:C1471(\
				"id"; $id; \
				"dom"; This:C1470.latest))
			
		Else 
			
			This:C1470.store.push(New object:C1471(\
				"id"; Generate UUID:C1066; \
				"dom"; This:C1470.latest))
			
		End if 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Retrieve a stored dom reference
Function fetch($name : Text)->$dom : Text
	
	var $o : Object
	
	If (Count parameters:C259>=1)
		
		$o:=This:C1470.store.query("id = :1"; $name).pop()
		
	Else 
		
		// Lastest
		$o:=New object:C1471(\
			"dom"; This:C1470.latest)
		
	End if 
	
	This:C1470.success:=($o#Null:C1517)
	
	If (This:C1470.success)
		
		$dom:=$o.dom
		
	Else 
		
		This:C1470.errors.push("The element \""+$name+"\" doesn't exists")
		
	End if 
	
	
/*================================================================
                       BASICS ELEMENTS
================================================================*/
	
	//———————————————————————————————————————————————————————————
Function rect($height : Real; $WidthOrNode : Variant; $addTo : Variant)->$this : cs:C1710.svg
	
	var $parent : Text
	var $width : Integer
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		$width:=$height  // Square by default
		
		If (Count parameters:C259>=1)
			
			If (Value type:C1509($WidthOrNode)=Is real:K8:4)
				
				$width:=$WidthOrNode
				
				If (Count parameters:C259>=3)
					
					$parent:=This:C1470._addTo($addTo)
					
				Else 
					
					$parent:=This:C1470._addTo()
					
				End if 
				
			Else 
				
				$parent:=This:C1470._addTo($WidthOrNode)
				
			End if 
		End if 
		
		This:C1470.latest:=Super:C1706.create($parent; "rect"; New object:C1471(\
			"width"; $height; \
			"height"; $width))
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function square($side : Real; $addTo : Variant)->$this : cs:C1710.svg
	
	var $parent : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (Count parameters:C259>=2)
			
			$parent:=This:C1470._addTo($addTo)
			
		Else 
			
			$parent:=This:C1470._addTo()
			
		End if 
		
		This:C1470.latest:=Super:C1706.create($parent; "rect"; New object:C1471(\
			"width"; $side; \
			"height"; $side))
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function circle($radius : Real; $cx : Real; $cy : Real; $addTo : Variant)->$this : cs:C1710.svg
	
	var $parent : Text
	var $x; $y : Real
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (Count parameters:C259>=4)
			
			$parent:=This:C1470._addTo($addTo)
			
		Else 
			
			$parent:=This:C1470._addTo()
			
		End if 
		
		If (Count parameters:C259>=2)
			
			$x:=$cx
			
			If (Count parameters:C259>=3)
				
				$y:=$cy
				
			Else 
				
				$y:=$x
				
			End if 
		End if 
		
		This:C1470.latest:=Super:C1706.create($parent; "circle"; New object:C1471(\
			"cx"; $x; \
			"cy"; $y; \
			"r"; $radius))
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function ellipse($radiusX : Real; $radiusY : Real; $cx : Real; $cy : Real; $addTo : Variant)->$this : cs:C1710.svg
	
	var $parent : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 3))
		
		If (Count parameters:C259=5)
			
			$parent:=This:C1470._addTo($addTo)
			
		Else 
			
			$parent:=This:C1470._addTo()
			
		End if 
		
		This:C1470.latest:=Super:C1706.create($parent; "ellipse"; New object:C1471(\
			"cx"; $cx; \
			"cy"; Choose:C955(Count parameters:C259>=4; $cy; $cx); \
			"rx"; $radiusX; \
			"ry"; $radiusY))
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function embedPicture($picture : Picture; $addTo : Variant)->$this : cs:C1710.svg
	
	var $parent; $t : Text
	var $height; $width : Integer
	var $x : Blob
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (Count parameters:C259>=2)
			
			$parent:=This:C1470._target($addTo)
			
		Else 
			
			$parent:=This:C1470._target()
			
		End if 
		
		This:C1470.success:=(Picture size:C356($picture)>0)
		
		If (This:C1470.success)
			
			// Encode in base64
			PICTURE TO BLOB:C692($picture; $x; ".png")
			This:C1470.success:=Bool:C1537(OK)
			
			If (This:C1470.success)
				
				BASE64 ENCODE:C895($x; $t)
				CLEAR VARIABLE:C89($x)
				
				// Put the encoded image
				PICTURE PROPERTIES:C457($picture; $width; $height)
				
				This:C1470.latest:=Super:C1706.create($parent; "image"; New object:C1471(\
					"xlink:href"; "data:;base64,"+$t; \
					"x"; 0; \
					"y"; 0; \
					"width"; $width; \
					"height"; $height))
				
			End if 
			
		Else 
			
			This:C1470.errors.push("Given picture is empty")
			
		End if 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function line($x1 : Real; $y1 : Real; $x2 : Real; $y2 : Real; $addTo : Variant)->$this : cs:C1710.svg
	
	var $parent : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 4))
		
		If (Count parameters:C259=5)
			
			$parent:=This:C1470._addTo($addTo)
			
		Else 
			
			$parent:=This:C1470._addTo()
			
		End if 
		
		This:C1470.latest:=Super:C1706.create($parent; "line"; New object:C1471(\
			"x1"; $x1; \
			"y1"; $y1; \
			"x2"; $x2; \
			"y2"; $y2))
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function image($file : 4D:C1709.File; $addTo : Variant)->$this : cs:C1710.svg
	
	var $parent; $t : Text
	var $p : Picture
	var $height; $width : Integer
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (Count parameters:C259>=2)
			
			$parent:=This:C1470._target($addTo)
			
		Else 
			
			$parent:=This:C1470._target()
			
		End if 
		
		This:C1470.success:=Bool:C1537($file.exists)
		
		If (This:C1470.success)
			
			$t:=$file.platformPath
			READ PICTURE FILE:C678($t; $p)
			This:C1470.success:=Bool:C1537(OK)
			
			If (This:C1470.success)
				
				PICTURE PROPERTIES:C457($p; $width; $height)
				CLEAR VARIABLE:C89($p)
				
				This:C1470.success:=Bool:C1537(OK)
				
				If (This:C1470.success)
					
					$t:="file:/"+"/"\
						+Choose:C955(Is Windows:C1573; "/"; "")\
						+Replace string:C233($file.path; " "; "%20")
					
					This:C1470.latest:=Super:C1706.create($parent; "image"; New object:C1471(\
						"xlink:href"; $t; \
						"x"; 0; \
						"y"; 0; \
						"width"; $width; \
						"height"; $height))
					
				End if 
			End if 
			
			If (Not:C34(This:C1470.success))
				
				This:C1470.errors.push("Failed to create image \""+String:C10($file.path)+"\"")
				
			End if 
			
		Else 
			
			This:C1470.errors.push("File not found \""+String:C10($file.path)+"\"")
			
		End if 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function textArea($text : Text; $addTo : Variant)->$this : cs:C1710.svg
	
	var $node; $parent; $substring; $t : Text
	var $indx : Integer
	
	If (Count parameters:C259>=2)
		
		$parent:=This:C1470._target($addTo)
		
	Else 
		
		$parent:=This:C1470._target()
		
	End if 
	
	This:C1470.latest:=Super:C1706.create($parent; "textArea"; New object:C1471(\
		"x"; 0; \
		"y"; 0; \
		"width"; "auto"; \
		"height"; "auto"))
	
	If (This:C1470.success)\
		 & (Length:C16($text)>0)
		
		$t:=Replace string:C233(String:C10($text); "\r\n"; "\r")
		
		Repeat 
			
			$indx:=Position:C15("\r"; $t)
			
			If ($indx=0)
				
				$indx:=Position:C15("\n"; $t)
				
			End if 
			
			If ($indx>0)
				
				$substring:=Substring:C12($t; 1; $indx-1)
				
				If (Length:C16($substring)>0)
					
					$node:=DOM Append XML child node:C1080(This:C1470.latest; XML DATA:K45:12; $substring)
					
				End if 
				
				$node:=DOM Append XML child node:C1080(This:C1470.latest; XML ELEMENT:K45:20; "tbreak")
				
				$t:=Delete string:C232($t; 1; Length:C16($substring)+1)
				
			Else 
				
				If (Length:C16($t)>0)
					
					$node:=DOM Append XML child node:C1080(This:C1470.latest; XML DATA:K45:12; $t)
					
				End if 
			End if 
		Until ($indx=0)\
			 | (OK=0)
		
		This:C1470.success:=Bool:C1537(OK)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————/
	// ⚠️ Overrides the method of the inherited class
Function copy($source : Text; $addTo : Text)->$this : cs:C1710.svg
	
	var $parent : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (Count parameters:C259>=2)
			
			$parent:=This:C1470._addTo($addTo)
			
		Else 
			
			$parent:=This:C1470._addTo()
			
		End if 
		
		This:C1470.latest:=Super:C1706.copy(This:C1470._target($source); $parent)
		
	End if 
	
	$this:=This:C1470
	
	
/*================================================================
                         ATTRIBUTES
================================================================*/
	
/*———————————————————————————————————————————————————————————*/
Function id($id : Text)->$this : cs:C1710.svg
	
	var $node : Text
	
	$node:=This:C1470._target()
	Super:C1706.setAttribute($node; "id"; $id)
	
	$this:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function dimensions
	var $0 : Object
	var $1 : Variant
	var $2 : Variant
	var $3 : Text
	
	var $node; $t : Text
	var $parameterCount : Integer
	
	$parameterCount:=Count parameters:C259
	
	$node:=This:C1470._target()
	DOM GET XML ELEMENT NAME:C730($node; $t)
	
	If ($t="textArea")
		
		Case of 
				
				//______________________________________________________
			: ($parameterCount=0)
				
				DOM SET XML ATTRIBUTE:C866($node; \
					"width"; "auto"; \
					"height"; "auto")
				
				//______________________________________________________
			: ($parameterCount>=3)
				
				DOM SET XML ATTRIBUTE:C866($node; \
					"width"; Choose:C955($1=Null:C1517; "auto"; String:C10($1; "&xml")+String:C10($3)); \
					"height"; Choose:C955($2=Null:C1517; "auto"; String:C10($2; "&xml")+String:C10($3)))
				
				//______________________________________________________
			: ($parameterCount>=2)
				
				DOM SET XML ATTRIBUTE:C866($node; \
					"width"; Choose:C955($1=Null:C1517; "auto"; String:C10($1; "&xml")); \
					"height"; Choose:C955($2=Null:C1517; "auto"; String:C10($2; "&xml")))
				
				//______________________________________________________
			: ($parameterCount>=1)
				
				DOM SET XML ATTRIBUTE:C866($node; \
					"width"; Choose:C955($1=Null:C1517; "auto"; String:C10($1; "&xml")))
				
				//______________________________________________________
		End case 
		
	Else 
		
		Case of 
				
				//______________________________________________________
			: (Count parameters:C259>=3)
				
				DOM SET XML ATTRIBUTE:C866($node; \
					"width"; String:C10($1; "&xml")+String:C10($3); \
					"height"; String:C10($2; "&xml")+String:C10($3))
				
				//______________________________________________________
			: (Count parameters:C259>=2)
				
				DOM SET XML ATTRIBUTE:C866($node; \
					"width"; String:C10($1; "&xml"); \
					"height"; String:C10($2; "&xml"))
				
				//______________________________________________________
			: (Count parameters:C259>=1)
				
				DOM SET XML ATTRIBUTE:C866($node; \
					"width"; String:C10($1; "&xml"))
				
				//______________________________________________________
		End case 
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function position
	var $0 : Object
	var $1 : Real
	var $2 : Variant
	var $3 : Text
	
	var $node : Text
	
	$node:=This:C1470._target()
	This:C1470.success:=($node#This:C1470.root)
	
	If (This:C1470.success)
		
		If (Count parameters:C259>=2)
			
			If (Value type:C1509($2)=Is text:K8:3)
				
				DOM SET XML ATTRIBUTE:C866($node; \
					"x"; String:C10(Num:C11($1); "&xml")+String:C10($2))
				
			Else 
				
				If (Count parameters:C259>2)
					
					DOM SET XML ATTRIBUTE:C866($node; \
						"x"; String:C10($1; "&xml")+String:C10($3); \
						"y"; String:C10(Num:C11($2); "&xml")+String:C10($3))
					
				Else 
					
					DOM SET XML ATTRIBUTE:C866($node; \
						"x"; $1; \
						"y"; Num:C11($2))
					
				End if 
			End if 
			
		Else 
			
			DOM SET XML ATTRIBUTE:C866($node; \
				"x"; String:C10(Num:C11($1); "&xml"))
			
		End if 
		
		This:C1470.success:=Bool:C1537(OK)
		
	Else 
		
		This:C1470.errors.push("You can't set position for the canvas!")
		
	End if 
	
	$0:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Translation
Function translate($x : Real; $y : Real; $node : Text)
	var $t; $transform : Text
	var $indx : Integer
	var $c : Collection
	
	If (Count parameters:C259>=3)
		
		$node:=This:C1470._target($node)
		
	Else 
		
		$node:=This:C1470._target()
		
	End if 
	
	$transform:="translate("+String:C10($x; "&xml")+","+String:C10($y; "&xml")+")"
	
	$t:=This:C1470.getAttribute($node; "transform")
	
	If (Length:C16($t)>0)
		
		$c:=Split string:C1554($t; " ")
		$indx:=$c.indexOf("translate(@")
		
		If ($indx#-1)
			
			$c[$indx]:=$transform
			
		Else 
			
			$c.push($transform)
			
		End if 
		
		$transform:=$c.join(" ")
		
	End if 
	
	DOM SET XML ATTRIBUTE:C866($node; "transform"; $transform)
	This:C1470.success:=Bool:C1537(OK)
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Horizontal translation
Function translateHorizontally($x : Real; $node : Text)
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._target($node)
		
	Else 
		
		$node:=This:C1470._target()
		
	End if 
	
	This:C1470.translate($x; 0; $node)
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Horizontal translation
Function translateVertically($y : Real; $node : Text)
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._target($node)
		
	Else 
		
		$node:=This:C1470._target()
		
	End if 
	
	This:C1470.translate(0; $y; $node)
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Scale
Function scale($x : Real; $target : Text)
	var $node; $t; $transform : Text
	var $indx : Integer
	var $c : Collection
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._target($target)
		
	Else 
		
		$node:=This:C1470._target()
		
	End if 
	
	//"scale(0.97)"
	$transform:="scale("+String:C10($x; "&xml")+")"
	
	$t:=This:C1470.getAttribute($node; "transform")
	
	If (Length:C16($t)>0)
		
		$c:=Split string:C1554($t; " ")
		$indx:=$c.indexOf("scale(@")
		
		If ($indx#-1)
			
			$c[$indx]:=$transform
			
		Else 
			
			$c.push($transform)
			
		End if 
		
		$transform:=$c.join(" ")
		
	End if 
	
	DOM SET XML ATTRIBUTE:C866($node; "transform"; $transform)
	This:C1470.success:=Bool:C1537(OK)
	
	C_OBJECT:C1216($0)
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function font
	var $0 : Object
	var $1 : Object
	var $2 : Variant
	
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._target($2)
		
	Else 
		
		$node:=This:C1470._target()
		
	End if 
	
	If ($1.font#Null:C1517)
		
		This:C1470.fontFamily($1.font; $node)
		
	End if 
	
	If ($1.size#Null:C1517)
		
		This:C1470.fontSize($1.size; $node)
		
	End if 
	
	If ($1.color#Null:C1517)
		
		This:C1470.fill($1.color; $node)
		
	End if 
	
	If ($1.style#Null:C1517)
		
		This:C1470.fontStyle($1.style; $node)
		
	End if 
	
	If ($1.alignment#Null:C1517)
		
		This:C1470.alignment($1.alignment; $node)
		
	End if 
	
	If ($1.rendering#Null:C1517)
		
		This:C1470.textRendering($1.rendering; $node)
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function fontFamily
	var $0 : Object
	var $1 : Text
	var $2 : Variant
	
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._target($2)
		
	Else 
		
		$node:=This:C1470._target()
		
	End if 
	
	DOM SET XML ATTRIBUTE:C866($node; \
		"font-family"; $1)
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function fontSize
	var $0 : Object
	var $1 : Integer
	var $2 : Variant
	
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._target($2)
		
	Else 
		
		$node:=This:C1470._target()
		
	End if 
	
	DOM SET XML ATTRIBUTE:C866($node; \
		"font-size"; $1)
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function fontStyle
	var $0 : Object
	var $1 : Integer
	var $2 : Variant
	
	var $node : Text
	var $style : Integer
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._target($2)
		
	Else 
		
		$node:=This:C1470._target()
		
	End if 
	
	$style:=$1
	
	If ($style=0)  // Plain
		
		DOM SET XML ATTRIBUTE:C866($node; \
			"text-decoration"; "none"; \
			"font-style"; "normal"; \
			"font-weight"; "normal")
		
	Else 
		
		If ($style>=8)  // Line-through
			
			DOM SET XML ATTRIBUTE:C866($node; \
				"text-decoration"; "line-through")
			$style:=$style-8
			
		End if 
		
		If (Bool:C1537(OK))\
			 & ($style>=4)  // Underline
			
			DOM SET XML ATTRIBUTE:C866($node; \
				"text-decoration"; "underline")
			$style:=$style-4
			
		End if 
		
		If (Bool:C1537(OK))\
			 & ($style>=2)  // Italic
			
			DOM SET XML ATTRIBUTE:C866($node; \
				"font-style"; "italic")
			$style:=$style-2
			
		End if 
		
		If (Bool:C1537(OK))\
			 & ($style=1)  // Bold
			
			DOM SET XML ATTRIBUTE:C866($node; \
				"font-weight"; "bold")
			
		End if 
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function alignment
	var $0 : Object
	var $1 : Integer
	var $2 : Variant
	
	var $node; $type : Text
	var $alignment : Integer
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._target($2)
		
	Else 
		
		$node:=This:C1470._target()
		
	End if 
	
	$alignment:=$1
	
	DOM GET XML ELEMENT NAME:C730($node; $type)
	
	Case of 
			
			//…………………………………………………………………………………………
		: ($alignment=Align center:K42:3)
			
			If ($type="textArea")
				
				DOM SET XML ATTRIBUTE:C866($node; \
					"text-align"; "center")
				
			Else 
				
				DOM SET XML ATTRIBUTE:C866($node; \
					"text-anchor"; "middle")
				
			End if 
			
			//…………………………………………………………………………………………
		: ($alignment=Align right:K42:4)
			
			If ($type="textArea")
				
				DOM SET XML ATTRIBUTE:C866($node; \
					"text-align"; "end")
				
			Else 
				
				DOM SET XML ATTRIBUTE:C866($node; \
					"text-anchor"; "end")
				
			End if 
			
			//…………………………………………………………………………………………
		: ($alignment=Align left:K42:2)\
			 | ($alignment=Align default:K42:1)
			
			If ($type="textArea")
				
				DOM SET XML ATTRIBUTE:C866($node; \
					"text-align"; "start")
				
			Else 
				
				DOM SET XML ATTRIBUTE:C866($node; \
					"text-anchor"; "start")
				
			End if 
			
			//…………………………………………………………………………………………
		: ($alignment=5)\
			 & ($type="textArea")
			
			DOM SET XML ATTRIBUTE:C866($node; \
				"text-align"; "justify")
			
			//…………………………………………………………………………………………
		Else 
			
			If ($type="textArea")
				
				DOM SET XML ATTRIBUTE:C866($node; \
					"text-align"; "inherit")
				
			Else 
				
				DOM SET XML ATTRIBUTE:C866($node; \
					"text-anchor"; "inherit")
				
			End if 
			
			//…………………………………………………………………………………………
	End case 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function textRendering
	var $0 : Object
	var $1 : Text
	var $2 : Variant
	
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._target($2)
		
	Else 
		
		$node:=This:C1470._target()
		
	End if 
	
	If (New collection:C1472("auto"; "optimizeSpeed"; "optimizeLegibility"; "geometricPrecision"; "inherit").indexOf($1)#-1)
		
		DOM SET XML ATTRIBUTE:C866($node; \
			"text-rendering"; $1)
		
	Else 
		
		This:C1470.errors.push("Unknown value ("+$1+") for text-rendering.")
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
	// ⚠️ Overrides the method of the inherited class
Function setAttribute
	var $0 : Object
	var $1 : Text
	var $2 : Variant
	var $3 : Text
	
	If (Count parameters:C259=3)
		
		Super:C1706.setAttribute($3; $1; $2)
		
	Else 
		
		Super:C1706.setAttribute(This:C1470._target(); $1; $2)
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
	// ⚠️ Overrides the method of the inherited class
Function setAttributes
	var $0 : Object
	var $1 : Variant
	var $2 : Variant
	var $3 : Text
	
	var $node; $t : Text
	var $o : Object
	var $c : Collection
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($1)=Is object:K8:27)
			
			If ($1#Null:C1517)
				
				$node:=This:C1470._target($1)
				
				$c:=OB Entries:C1720($1)
				
				For each ($t; New collection:C1472("target"; "left"; "top"; "width"; "height"; "codec"))
					
					$c:=$c.query("key != :1"; $t)
					
				End for each 
				
				Super:C1706.setAttributes($node; $c)
				
			End if 
			
			//______________________________________________________
		: (Value type:C1509($1)=Is collection:K8:32)
			
			$o:=$1.query("key=target").pop()
			
			If ($o#Null:C1517)
				
				$node:=This:C1470._target($o.value)
				
			Else 
				
				// Applies to the latest
				$node:=This:C1470._target()
				
			End if 
			
			For each ($t; New collection:C1472("target"; "left"; "top"; "width"; "height"; "codec"))
				
				$1:=$1.query("key != :1"; $t)
				
			End for each 
			
			Super:C1706.setAttributes($node; $c)
			
			//______________________________________________________
		: (Value type:C1509($1)=Is text:K8:3)
			
			If (Count parameters:C259=3)
				
				Super:C1706.setAttribute($3; $1; $2)
				
			Else 
				
				If (This:C1470._isReference($1))
					
					Super:C1706.setAttributes($1; $2)
					
				Else 
					
					Super:C1706.setAttributes(This:C1470._target(); $1; $2)
					
				End if 
			End if 
			
			//______________________________________________________
		Else 
			
			OK:=0
			
			//______________________________________________________
	End case 
	
	This:C1470.success:=Bool:C1537(OK)
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
	// ⚠️ Overrides the method of the inherited class
Function setValue
	var $0 : Object
	var $1 : Text
	var $2 : Variant
	var $3 : Boolean
	
	var $node : Text
	var $isCDATA : Boolean
	
	If (Count parameters:C259>=2)
		
		If (Count parameters:C259>=3)
			
			$isCDATA:=$3
			$node:=This:C1470._target(String:C10($2))
			
		Else 
			
			If (Value type:C1509($2)=Is text:K8:3)
				
				$node:=This:C1470._target($2)
				
			Else 
				
				$node:=This:C1470._target()
				$isCDATA:=Bool:C1537($2)
				
			End if 
		End if 
		
	Else 
		
		$node:=This:C1470._target()
		
	End if 
	
	If ($isCDATA)
		
		Super:C1706.setValue($node; $1; True:C214)
		
	Else 
		
		Super:C1706.setValue($node; $1)
		
	End if 
	
	$0:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Sets shape stroke and fill color.
Function color($color : Text; $target : Text)->$this
	var $node : Text
	
	$this:=This:C1470
	
	If (Count parameters:C259>=2)
		
		$node:=$this._target($target)
		
	Else 
		
		$node:=$this._target()
		
	End if 
	
	Super:C1706.setAttribute($node; "fill"; $color)
	Super:C1706.setAttribute($node; "stroke"; $color)
	
	//———————————————————————————————————————————————————————————/
	// Sets opacity of stroke and fill.
Function opacity($opacity : Real; $target : Text)->$this
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._target($target)
		
	Else 
		
		$node:=This:C1470._target()
		
	End if 
	
	This:C1470.fillOpacity($opacity; $node)
	This:C1470.strokeOpacity($opacity; $node)
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————/
	// Sets the fill attributes
Function fill($value; $target)->$this : cs:C1710.svg
	
	var $node : Text
	
	$this:=This:C1470
	
	If (Count parameters:C259>=2)
		
		$node:=$this._target($target)
		
	Else 
		
		$node:=$this._target()
		
	End if 
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($value)=Is text:K8:3)  // Set color
			
			If ($node=This:C1470.root)
				
				Super:C1706.setAttribute($node; "viewport-fill"; $value)
				
			Else 
				
				Super:C1706.setAttribute($node; "fill"; $value)
				
			End if 
			
			//______________________________________________________
		: (Value type:C1509($value)=Is boolean:K8:9)  // Set visibility
			
			If ($node=This:C1470.root)
				
				If ($value)
					
					If (String:C10(This:C1470.getAttribute($node; "viewport-fill"))="none")
						
						This:C1470.removeAttribute($node; "viewport-fill")
						
					End if 
					
				Else 
					
					Super:C1706.setAttribute($node; "viewport-fill"; "none")
					
				End if 
				
				
			Else 
				
				If ($value)
					
					If (String:C10(This:C1470.getAttribute($node; "fill"))="none")
						
						This:C1470.removeAttribute($node; "fill")
						
					End if 
					
				Else 
					
					Super:C1706.setAttribute($node; "fill"; "none")
					
				End if 
			End if 
			
			//______________________________________________________
		: (Value type:C1509($value)=Is object:K8:27)  // Multiple attributes
			
			If ($value.color#Null:C1517)
				
				If ($node=This:C1470.root)
					
					Super:C1706.setAttribute($node; "viewport-fill"; $value.color)
					
				Else 
					
					Super:C1706.setAttribute($node; "fill"; $value.color)
					
				End if 
			End if 
			
			If ($value.opacity#Null:C1517)
				
				If ($node=This:C1470.root)
					
					Super:C1706.setAttribute($node; "viewport-fill-opacity"; $value.opacity)
					
				Else 
					
					Super:C1706.setAttribute($node; "fill-opacity"; $value.opacity)
					
				End if 
			End if 
			
			//______________________________________________________
		Else 
			
			This:C1470.success:=False:C215
			This:C1470.errors.push(Current method name:C684+" - Bad parameter type")
			
			//______________________________________________________
	End case 
	
	//———————————————————————————————————————————————————————————/
Function fillColor($color : Text; $target)->$this : cs:C1710.svg
	
	var $node : Text
	
	$this:=This:C1470
	
	If (Count parameters:C259>=2)
		
		$node:=$this._target($target)
		
	Else 
		
		$node:=$this._target()
		
	End if 
	
	If ($node=$this.root)
		
		Super:C1706.setAttribute($node; "viewport-fill"; $color)
		
	Else 
		
		Super:C1706.setAttribute($node; "fill"; $color)
		
	End if 
	
	//———————————————————————————————————————————————————————————/
Function fillOpacity($opacity : Real; $target)->$this : cs:C1710.svg
	
	var $node : Text
	
	$this:=This:C1470
	
	If (Count parameters:C259>=2)
		
		$node:=$this._target($target)
		
	Else 
		
		$node:=$this._target()
		
	End if 
	
	If ($node=$this.root)
		
		Super:C1706.setAttribute($node; "viewport-fill-opacity"; $opacity)
		
	Else 
		
		Super:C1706.setAttribute($node; "fill-opacity"; $opacity)
		
	End if 
	
	//———————————————————————————————————————————————————————————
	// Sets the stroke attributes
Function stroke($value; $target)->$this : cs:C1710.svg
	
	var $node : Text
	
	$this:=This:C1470
	
	If (Count parameters:C259>=2)
		
		$node:=$this._target($target)
		
	Else 
		
		$node:=$this._target()
		
	End if 
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($value)=Is text:K8:3)  // Set color
			
			Super:C1706.setAttribute($node; "stroke"; $value)
			
			//______________________________________________________
		: (Value type:C1509($value)=Is boolean:K8:9)  // Set visibility
			
			If ($value)
				
				If (String:C10(This:C1470.getAttribute($node; "stroke"))="none")
					
					This:C1470.removeAttribute($node; "stroke")
					
				End if 
				
				If (Num:C11(This:C1470.getAttribute($node; "stroke-width"))=0)
					
					This:C1470.removeAttribute($node; "stroke-width")
					
				End if 
				
			Else 
				
				Super:C1706.setAttribute($node; "stroke"; "none")
				
			End if 
			
			//______________________________________________________
		: (Value type:C1509($value)=Is real:K8:4)  // Set width
			
			Super:C1706.setAttribute($node; "stroke-width"; $value)
			
			//______________________________________________________
		: (Value type:C1509($value)=Is object:K8:27)  // Multiple attributes
			
			If ($value.color#Null:C1517)
				
				Super:C1706.setAttribute($node; "stroke"; $value.color)
				
			End if 
			
			If ($value.width#Null:C1517)
				
				Super:C1706.setAttribute($node; "stroke-width"; $value.width)
				
			End if 
			
			If ($value.opacity#Null:C1517)
				
				Super:C1706.setAttribute($node; "stroke-opacity"; $value.opacity)
				
			End if 
			
			//______________________________________________________
		Else 
			
			This:C1470.success:=False:C215
			This:C1470.errors.push(Current method name:C684+" - Bad parameter type")
			
			//______________________________________________________
	End case 
	
	//———————————————————————————————————————————————————————————/
Function strokeColor($color : Text; $target)->$this : cs:C1710.svg
	
	If (Count parameters:C259>=2)
		
		Super:C1706.setAttribute(This:C1470._target($target); "stroke"; $color)
		
	Else 
		
		Super:C1706.setAttribute(This:C1470._target(); "stroke"; $color)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————/
Function strokeWidth($width : Real; $target)->$this : cs:C1710.svg
	
	If (Count parameters:C259>=2)
		
		Super:C1706.setAttribute(This:C1470._target($target); "stroke-width"; $width)
		
	Else 
		
		Super:C1706.setAttribute(This:C1470._target(); "stroke-width"; $width)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————/
Function strokeOpacity
	var $0 : Object
	var $1 : Real
	var $2 : Variant
	
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._target($2)
		
	Else 
		
		$node:=This:C1470._target()
		
	End if 
	
	Super:C1706.setAttribute($node; "stroke-opacity"; $1)
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function getPicture
	var $0 : Picture
	var $1 : Variant
	var $2 : Boolean  // Don't release memory
	
	var $p : Picture
	var $parameterCount : Integer
	
	$parameterCount:=Count parameters:C259
	
	Case of 
			
			//______________________________________________________
		: ($parameterCount>=2)
			
			SVG EXPORT TO PICTURE:C1017(This:C1470.root; $p; Num:C11($1))
			
			If (This:C1470.autoClose)\
				 & (Not:C34($2))
				
				This:C1470.close()
				
			End if 
			
			//______________________________________________________
		: ($parameterCount>=1)
			
			If (Value type:C1509($1)=Is boolean:K8:9)
				
				SVG EXPORT TO PICTURE:C1017(This:C1470.root; $p; Copy XML data source:K45:17)
				
				If (This:C1470.autoClose)\
					 & (Not:C34($1))
					
					This:C1470.close()
					
				End if 
				
			Else 
				
				SVG EXPORT TO PICTURE:C1017(This:C1470.root; $p; Num:C11($1))
				
				If (This:C1470.autoClose)
					
					This:C1470.close()
					
				End if 
			End if 
			
			//______________________________________________________
		Else 
			
			SVG EXPORT TO PICTURE:C1017(This:C1470.root; $p; Copy XML data source:K45:17)
			
			If (This:C1470.autoClose)
				
				This:C1470.close()
				
			End if 
			
			//______________________________________________________
	End case 
	
	This:C1470.success:=(Picture size:C356($p)>0)
	
	If (This:C1470.success)
		
		This:C1470.picture:=$p
		
	Else 
		
		This:C1470.picture:=Null:C1517
		This:C1470.errors.push("Failed to convert SVG structure as picture.")
		
	End if 
	
	$0:=$p
	
/*———————————————————————————————————————————————————————————*/
Function saveText
	var $1 : 4D:C1709.File
	var $2 : Boolean  // Don't release memory
	
	If (Count parameters:C259=2)
		
		Super:C1706.save($1; $2)
		
	Else 
		
		Super:C1706.save($1)
		
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function savePicture
	var $1 : 4D:C1709.File
	var $2 : Boolean  // Don't release memory
	
	var $p : Picture
	
	If (Count parameters:C259=2)
		
		$p:=This:C1470.getPicture($2)
		
	Else 
		
		$p:=This:C1470.getPicture()
		
	End if 
	
	WRITE PICTURE FILE:C680($1.platformPath; $p; $1.extension)
	
/*———————————————————————————————————————————————————————————*/
Function styleSheet
	var $1 : 4D:C1709.File
	
	var $t : Text
	
	This:C1470.success:=OB Instance of:C1731($1; 4D:C1709.File)
	
	If (This:C1470.success)
		
		This:C1470.success:=$1.exists
		
		If (This:C1470.success)
			
			$t:="xml-stylesheet href=\"file:///"+Convert path system to POSIX:C1106($1.platformPath; *)+"\" type=\"text/css\""
			$t:=DOM Append XML child node:C1080(DOM Get XML document ref:C1088(This:C1470.root); XML processing instruction:K45:9; $t)
			This:C1470.success:=Bool:C1537(OK)
			
		Else 
			
			This:C1470.errors.push("File not found: "+$1.path)
			
		End if 
		
	Else 
		
		This:C1470.errors.push("$1 must be a 4D File")
		
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function visible
	var $0 : Object
	var $1 : Boolean
	var $2 : Variant
	
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._target($2)
		This:C1470.setAttribute("visibility"; Choose:C955($1; "visible"; "hidden"); $node)
		
	Else 
		
		This:C1470.setAttribute("visibility"; Choose:C955($1; "visible"; "hidden"))
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function class  // Set the node class
	var $0 : Object
	var $1 : Text
	var $2 : Variant
	
	If (Count parameters:C259=2)
		
		Super:C1706.setAttribute($2; "class"; $1)
		
	Else 
		
		Super:C1706.setAttribute(This:C1470._target(); "class"; $1)
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function addClass  // Add a value to the node class
	var $0 : Object
	var $1 : Text
	var $2 : Text
	
	var $node; $t : Text
	
	If (Count parameters:C259=2)
		
		$node:=$2
		
	Else 
		
		$node:=This:C1470._target()
		
	End if 
	
	$t:=String:C10(This:C1470.getAttribute($node; "class"))
	
	If (Length:C16($t)>0)
		
		If (Split string:C1554($t; " ").indexOf($1)=-1)
			
			$t:=$t+" "+$1
			
		End if 
		
	Else 
		
		$t:=$1
		
	End if 
	
	Super:C1706.setAttribute($node; "class"; $t)
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function isOfClass($class : Text; $node : Text)->$isOfclass : Boolean
	var $target : Text
	
	$target:=Choose:C955(Count parameters:C259=2; $node; This:C1470._target())
	
	$isOfclass:=(Position:C15($class; String:C10(This:C1470.getAttribute($target; "class")))#0)
	
	//———————————————————————————————————————————————————————————/
	// Alias showInViewer()
Function preview
	
	This:C1470.showInViewer()
	
	//———————————————————————————————————————————————————————————/
	// Show in 4D SVG Viewer
Function showInViewer($keep : Boolean)
	
	// #TO_DO: Should test if the component is available
	EXECUTE METHOD:C1007("SVGTool_SHOW_IN_VIEWER"; *; This:C1470.root)
	
	If (Count parameters:C259>=1)
		
		If (This:C1470.autoClose)\
			 & (Not:C34($keep))
			
			This:C1470.close()
			
		End if 
		
	Else 
		
		If (This:C1470.autoClose)
			
			This:C1470.close()
			
		End if 
	End if 
	
	//———————————————————————————————————————————————————————————
	// Returns the passed text width
Function getTextWidth($string : Text; $fontAttributes : Object)->$width : Integer
	
	var $picture : Picture
	var $height : Integer
	var $o : Object
	
	If (Count parameters:C259>=2)
		
		$o:=cs:C1710.svg.new().textArea($string).font($fontAttributes)
		
	Else 
		
		// Keep the default font that should be: Times New Roman 12 pts.
		$o:=cs:C1710.svg.new().textArea($string)
		
	End if 
	
	$picture:=$o.getPicture()
	PICTURE PROPERTIES:C457($picture; $width; $height)
	
/*================================================================
                         PRIVATES
================================================================*/
	
	//———————————————————————————————————————————————————————————
Function _target($target)->$node : Text
	
	var $o : Object
	
	This:C1470.success:=True:C214
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)
			
			$node:=Choose:C955(This:C1470.latest#Null:C1517; This:C1470.latest; This:C1470.root)
			
			//______________________________________________________
		: (Value type:C1509($target)=Is undefined:K8:13)
			
			$node:=Choose:C955(This:C1470.latest#Null:C1517; This:C1470.latest; This:C1470.root)
			
			//______________________________________________________
		: (Value type:C1509($target)=Is text:K8:3)
			
			Case of 
					
					//_______________________________
				: ($target="root")
					
					$node:=This:C1470.root
					
					//_______________________________
				: ($target="latest")
					
					$node:=Choose:C955(This:C1470.latest#Null:C1517; This:C1470.latest; This:C1470.root)
					
					//_______________________________
				: ($target="parent")\
					 | ($target="append")
					
					If (This:C1470.latest=Null:C1517)
						
						$node:=This:C1470.root
						
					Else 
						
						// Get the parent
						$node:=This:C1470.parent(This:C1470.latest)
						
					End if 
					
					//_______________________________
				: (This:C1470._isReference($target))
					
					$node:=$target  // The given reference
					
					//_______________________________
				Else 
					
					// Find a memorized target
					$o:=This:C1470.store.query("id=:1"; $target).pop()
					
					If ($o#Null:C1517)
						
						$node:=$o.dom
						
					Else 
						
						This:C1470.success:=False:C215
						This:C1470.errors.push("The element \""+$target+"\" doesn't exists")
						
					End if 
					
					//_______________________________
			End case 
			
			//______________________________________________________
		: (Value type:C1509($target)=Is object:K8:27)
			
			If ($target.target#Null:C1517)
				
				$node:=String:C10($target.target)
				
			Else 
				
				This:C1470._target("latest")
				
			End if 
			
			//______________________________________________________
		Else 
			
			This:C1470.success:=False:C215
			This:C1470.errors.push("Unmanaged type")
			
			//______________________________________________________
	End case 
	
	//———————————————————————————————————————————————————————————
Function _addTo($target)->$node : Text
	
	If (Count parameters:C259>=1)
		
		$node:=This:C1470._target($target)
		
	Else 
		
		$node:=This:C1470._target()
		
	End if 
	
	If (New collection:C1472(\
		"rect"; \
		"line"; \
		"image"; \
		"circle"; \
		"ellipse").indexOf(This:C1470.getName($node))#-1)
		
		$node:=This:C1470.parent($node)
		
	End if 
	
	//———————————————————————————————————————————————————————————