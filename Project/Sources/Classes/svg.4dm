
/*═══════════════*/
Class extends xml
/*═══════════════*/

Class constructor
	var $1 : Variant
	
	If (Count parameters:C259>0)
		
		Super:C1705($1)
		
	Else 
		
		Super:C1705()
		
		// Create an empty canvas
		This:C1470.new()
		
	End if 
	
	This:C1470.latest:=Null:C1517
	This:C1470.picture:=Null:C1517
	This:C1470.store:=New collection:C1472
	
/*———————————————————————————————————————————————————————————*/
Function push  // Keep dom reference for futur
	var $0 : Object
	var $1 : Text
	
	If (Count parameters:C259>=1)
		
		This:C1470.success:=(This:C1470.store.query("id=:1"; $1).pop()=Null:C1517)
		
		If (This:C1470.success)
			
			This:C1470.store.push(New object:C1471(\
				"id"; $1; \
				"dom"; This:C1470.latest))
			
		Else 
			
			This:C1470.errors.push("The element \""+$1+"\" already exists")
			
		End if 
		
	Else 
		
		This:C1470.store.push(New object:C1471(\
			"id"; Generate UUID:C1066; \
			"dom"; This:C1470.latest))
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function fetch  // Retrieve a stored dom reference
	var $0 : Text
	var $1 : Text
	
	var $o : Object
	
	If (Count parameters:C259>=1)
		
		$o:=This:C1470.store.query("id=:1"; $1).pop()
		
	Else 
		
		// Lastest
		$o:=New object:C1471(\
			"dom"; This:C1470.latest)
		
	End if 
	
	This:C1470.success:=($o#Null:C1517)
	
	If (This:C1470.success)
		
		$0:=$o.dom
		
	Else 
		
		This:C1470.errors.push("The element \""+$1+"\" doesn't exists")
		
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function new  // Create a default SVG structure
	var $0 : Object
	var $1 : Object
	
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
			
			If ($1#Null:C1517)
				
				For each ($t; $1)
					
					Case of 
							
							//_______________________
						: ($t="keepReference")
							
							This:C1470.autoClose:=Bool:C1537($1[$t])
							
							//_______________________
						Else 
							
							DOM SET XML ATTRIBUTE:C866(This:C1470.root; \
								$t; $1[$t])
							
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
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function id
	var $0 : Object
	var $1 : Text
	
	var $node : Text
	
	$node:=This:C1470.__target()
	
	DOM SET XML ATTRIBUTE:C866($node; \
		"id"; $1)
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function preview  // Alias showInViewer()
	
	This:C1470.showInViewer()
	
/*———————————————————————————————————————————————————————————*/
Function showInViewer  // Show in 4D SVG Viewer
	var $0 : Object
	
	//#TO_DO: Should test if the component is available
	EXECUTE METHOD:C1007("SVGTool_SHOW_IN_VIEWER"; *; This:C1470.root)
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function rect
	var $0 : Object
	var $1 : Integer
	var $2 : Variant
	var $3 : Variant
	
	var $node : Text
	var $height; $vWidth : Integer
	
	$height:=$1
	$vWidth:=$1  // Square (default)
	
	If (Count parameters:C259>=1)
		
		If (Value type:C1509($2)=Is real:K8:4)
			
			$vWidth:=$2
			
			If (Count parameters:C259>=2)
				
				$node:=This:C1470.__target($3)
				
			Else 
				
				$node:=This:C1470.latest
				
			End if 
			
		Else 
			
			$node:=This:C1470.__target($3)
			
		End if 
	End if 
	
	This:C1470.latest:=DOM Create XML element:C865($node; "rect"; \
		"width"; $height; \
		"height"; $vWidth)
	
	This:C1470.success:=Bool:C1537(OK)
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function square
	var $0 : Object
	var $1 : Variant
	var $2 : Variant
	
	This:C1470.rect($1; Null:C1517; $2)
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function group
	var $0 : Object
	var $1 : Variant
	
	var $node : Text
	
	If (Count parameters:C259>=1)
		
		$node:=This:C1470.__target($1)
		
	Else 
		
		$node:=This:C1470.__target()
		
	End if 
	
	If (This:C1470.success)
		
		This:C1470.latest:=DOM Create XML element:C865($node; "g")
		This:C1470.success:=Bool:C1537(OK)
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function position
	var $0 : Object
	var $1 : Integer
	var $2 : Variant
	var $3 : Text
	
	var $node : Text
	
	$node:=This:C1470.__target()
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
	
/*———————————————————————————————————————————————————————————*/
Function dimensions
	var $0 : Object
	var $1 : Variant
	var $2 : Variant
	var $3 : Text
	
	var $node; $t : Text
	var $parameterCount : Integer
	
	$parameterCount:=Count parameters:C259
	
	$node:=This:C1470.__target()
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
Function font
	var $0 : Object
	var $1 : Object
	var $2 : Variant
	
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470.__target($2)
		
	Else 
		
		$node:=This:C1470.__target()
		
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
		
		$node:=This:C1470.__target($2)
		
	Else 
		
		$node:=This:C1470.__target()
		
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
		
		$node:=This:C1470.__target($2)
		
	Else 
		
		$node:=This:C1470.__target()
		
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
		
		$node:=This:C1470.__target($2)
		
	Else 
		
		$node:=This:C1470.__target()
		
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
		
		$node:=This:C1470.__target($2)
		
	Else 
		
		$node:=This:C1470.__target()
		
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
		
		$node:=This:C1470.__target($2)
		
	Else 
		
		$node:=This:C1470.__target()
		
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
		
		Super:C1706.setAttribute(This:C1470.__target(); $1; $2)
		
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
				
				$node:=This:C1470.__target($1)
				
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
				
				$node:=This:C1470.__target($o.value)
				
			Else 
				
				// Applies to the latest
				$node:=This:C1470.latest
				
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
				
				Super:C1706.setAttribute(This:C1470.latest; $1; $2)
				
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
			$node:=This:C1470.__target(String:C10($2))
			
		Else 
			
			If (Value type:C1509($2)=Is text:K8:3)
				
				$node:=This:C1470.__target($2)
				
			Else 
				
				$node:=This:C1470.__target()
				$isCDATA:=Bool:C1537($2)
				
			End if 
		End if 
		
	Else 
		
		$node:=This:C1470.__target()
		
	End if 
	
	If ($isCDATA)
		
		Super:C1706.setValue($node; $1; True:C214)
		
	Else 
		
		Super:C1706.setValue($node; $1)
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function fill
	var $0 : Object
	var $1 : Text
	var $2 : Variant
	
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470.__target($2)
		
	Else 
		
		$node:=This:C1470.__target()
		
	End if 
	
	If ($node=This:C1470.root)
		
		DOM SET XML ATTRIBUTE:C866($node; \
			"viewport-fill"; $1)
		
	Else 
		
		DOM SET XML ATTRIBUTE:C866($node; \
			"fill"; $1)
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function fillOpacity
	var $0 : Object
	var $1 : Real
	var $2 : Variant
	
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470.__target($2)
		
	Else 
		
		$node:=This:C1470.__target()
		
	End if 
	
	If ($node=This:C1470.root)
		
		DOM SET XML ATTRIBUTE:C866($node; \
			"viewport-fill-opacity"; $1)
		
	Else 
		
		DOM SET XML ATTRIBUTE:C866($node; \
			"fill-opacity"; $1)
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function stroke
	var $0 : Object
	var $1 : Text
	var $2 : Variant
	
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470.__target($2)
		
	Else 
		
		$node:=This:C1470.__target()
		
	End if 
	
	DOM SET XML ATTRIBUTE:C866($node; \
		"stroke"; $1)
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function strokeOpacity
	var $0 : Object
	var $1 : Real
	var $2 : Variant
	
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470.__target($2)
		
	Else 
		
		$node:=This:C1470.__target()
		
	End if 
	
	DOM SET XML ATTRIBUTE:C866($node; \
		"stroke-opacity"; $1)
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function embedPicture
	var $0 : Object
	var $1 : Picture
	var $2 : Variant
	
	var $node; $t : Text
	var $height; $width : Integer
	var $x : Blob
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470.__target($2)
		
	Else 
		
		$node:=This:C1470.__target()
		
	End if 
	
	This:C1470.success:=(Picture size:C356($1)>0)
	
	If (This:C1470.success)
		
		// Encode in base64
		PICTURE TO BLOB:C692($1; $x; ".png")
		This:C1470.success:=Bool:C1537(OK)
		
		If (This:C1470.success)
			
			BASE64 ENCODE:C895($x; $t)
			CLEAR VARIABLE:C89($x)
			
			// Put the encoded image
			PICTURE PROPERTIES:C457($1; $width; $height)
			
			This:C1470.latest:=DOM Create XML element:C865($node; "image"; \
				"xlink:href"; "data:;base64,"+$t; \
				"x"; 0; \
				"y"; 0; \
				"width"; $width; \
				"height"; $height)
			
			This:C1470.success:=Bool:C1537(OK)
			
		End if 
		
	Else 
		
		This:C1470.errors.push("Given picture is empty")
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function image
	var $0 : Object
	var $1 : Object
	var $2 : Variant
	
	var $node; $t : Text
	var $p : Picture
	var $height; $width : Integer
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470.__target($2)
		
	Else 
		
		$node:=This:C1470.__target()
		
	End if 
	
	This:C1470.success:=Bool:C1537($1.exists)
	
	If (This:C1470.success)
		
		$t:=$1.platformPath
		READ PICTURE FILE:C678($t; $p)
		This:C1470.success:=Bool:C1537(OK)
		
		If (This:C1470.success)
			
			PICTURE PROPERTIES:C457($p; $width; $height)
			CLEAR VARIABLE:C89($p)
			
			This:C1470.success:=Bool:C1537(OK)
			
			If (This:C1470.success)
				
				$t:="file:/"+"/"\
					+Choose:C955(Is Windows:C1573; "/"; "")\
					+Replace string:C233($1.path; " "; "%20")
				
				This:C1470.latest:=DOM Create XML element:C865($node; "image"; \
					"xlink:href"; $t; \
					"x"; 0; \
					"y"; 0; \
					"width"; $width; \
					"height"; $height)
				
				This:C1470.success:=Bool:C1537(OK)
				
			End if 
		End if 
		
		If (Not:C34(This:C1470.success))
			
			This:C1470.errors.push("Failed to create image \""+String:C10($1.path)+"\"")
			
		End if 
		
	Else 
		
		This:C1470.errors.push("File not found \""+String:C10($1.path)+"\"")
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function textArea
	var $0 : Object
	var $1 : Text
	var $2 : Variant
	
	var $node; $t; $tt : Text
	var $i : Integer
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470.__target($2)
		
	Else 
		
		$node:=This:C1470.__target()
		
	End if 
	
	This:C1470.latest:=DOM Create XML element:C865($node; "textArea"; \
		"x"; 0; \
		"y"; 0; \
		"width"; "auto"; \
		"height"; "auto")
	
	If (Bool:C1537(OK))\
		 & (Length:C16($1)>0)
		
		$t:=Replace string:C233(String:C10($1); "\r\n"; "\r")
		
		Repeat 
			
			$i:=Position:C15("\r"; $t)
			
			If ($i=0)
				
				$i:=Position:C15("\n"; $t)
				
			End if 
			
			If ($i>0)
				
				$tt:=Substring:C12($t; 1; $i-1)
				
				If (Length:C16($tt)>0)
					
					$node:=DOM Append XML child node:C1080(This:C1470.latest; XML DATA:K45:12; $tt)
					
				End if 
				
				$node:=DOM Append XML child node:C1080(This:C1470.latest; XML ELEMENT:K45:20; "tbreak")
				
				$t:=Delete string:C232($t; 1; Length:C16($tt)+1)
				
			Else 
				
				If (Length:C16($t)>0)
					
					$node:=DOM Append XML child node:C1080(This:C1470.latest; XML DATA:K45:12; $t)
					
				End if 
			End if 
		Until ($i=0)\
			 | (OK=0)
		
	End if 
	
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
		
		$node:=This:C1470.__target($2)
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
		
		Super:C1706.setAttribute(This:C1470.__target(); "class"; $1)
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function addClass  // Add a value to the node class 
	var $1 : Text
	var $2 : Text
	
	var $node; $t : Text
	
	If (Count parameters:C259=2)
		
		$node:=$2
		
	Else 
		
		$node:=This:C1470.__target()
		
	End if 
	
	$t:=String:C10(Super:C1706.getAttribute($node; "class"))
	
	If (Length:C16($t)>0)
		
		$t:=$t+" "+$1
		
	Else 
		
		$t:=$1
		
	End if 
	
	Super:C1706.setAttribute($node; "class"; $t)
	
/*——————————————————————————
PRIVATE
——————————————————————————*/
Function __target
	var $0 : Text
	var $1 : Variant
	
	var $o : Object
	
	This:C1470.success:=True:C214
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)
			
			$0:=Choose:C955(This:C1470.latest#Null:C1517; This:C1470.latest; This:C1470.root)
			
			//______________________________________________________
		: (Value type:C1509($1)=Is undefined:K8:13)
			
			$0:=Choose:C955(This:C1470.latest#Null:C1517; This:C1470.latest; This:C1470.root)
			
			//______________________________________________________
		: (Value type:C1509($1)=Is text:K8:3)
			
			Case of 
					
					//_______________________________
				: ($1="root")
					
					$0:=This:C1470.root
					
					//_______________________________
				: ($1="latest")
					
					$0:=Choose:C955(This:C1470.latest#Null:C1517; This:C1470.latest; This:C1470.root)
					
					//_______________________________
				: ($1="parent")\
					 | ($1="append")
					
					If (This:C1470.latest=Null:C1517)
						
						$0:=This:C1470.root
						
					Else 
						
						// Get the parent
						$0:=This:C1470.parent(This:C1470.latest)
						
					End if 
					
					//_______________________________
				: (This:C1470.__isReference($1))
					
					$0:=$1  // The given reference
					
					//_______________________________
				Else 
					
					// Find a memorized target
					$o:=This:C1470.store.query("id=:1"; $1).pop()
					
					If ($o#Null:C1517)
						
						$0:=$o.dom
						
					Else 
						
						This:C1470.success:=False:C215
						This:C1470.errors.push("The element \""+$1+"\" doesn't exists")
						
					End if 
					
					//_______________________________
			End case 
			
			//______________________________________________________
		: (Value type:C1509($1)=Is object:K8:27)
			
			If ($1.target#Null:C1517)
				
				$0:=String:C10($1.target)
				
			Else 
				
				This:C1470.__target("latest")
				
			End if 
			
			//______________________________________________________
		Else 
			
			This:C1470.success:=False:C215
			This:C1470.errors.push("Unmanaged type")
			
			//______________________________________________________
	End case 