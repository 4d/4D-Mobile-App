/*
This class is the parent class of all form objects classes
*/

//=== === === === === === === === === === === === === === === === === === ===
Class constructor($objectName : Text)
	
	If (Count parameters:C259>=1)
		
		This:C1470.name:=$objectName
		
	Else 
		
		// Called from the widget method
		This:C1470.name:=OBJECT Get name:C1087(Object current:K67:2)
		
	End if 
	
	This:C1470.type:=OBJECT Get type:C1300(*; This:C1470.name)
	
	If (Asserted:C1132(This:C1470.type#0; Current method name:C684+": No objects found named \""+This:C1470.name+"\""))
		
		This:C1470._updateCoordinates()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === ===
Function hide()->$this : cs:C1710.static
	
	OBJECT SET VISIBLE:C603(*; This:C1470.name; False:C215)
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === ===
Function show($state : Boolean)->$this : cs:C1710.static
	
	If (Count parameters:C259>=1)
		
		OBJECT SET VISIBLE:C603(*; This:C1470.name; $state)
		
	Else 
		
		OBJECT SET VISIBLE:C603(*; This:C1470.name; True:C214)
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === ===
Function getVisible()->$visible : Boolean
	
	$visible:=OBJECT Get visible:C1075(*; This:C1470.name)
	
	//=== === === === === === === === === === === === === === === === === === ===
Function enable($state : Boolean)->$this : cs:C1710.static
	
	If (Count parameters:C259>=1)
		
		OBJECT SET ENABLED:C1123(*; This:C1470.name; $state)
		
	Else 
		
		OBJECT SET ENABLED:C1123(*; This:C1470.name; True:C214)
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === ===
Function disable()->$this : cs:C1710.static
	
	OBJECT SET ENABLED:C1123(*; This:C1470.name; False:C215)
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === ===
Function setTitle($title : Text)->$this : cs:C1710.static
	
	var $t : Text
	
	If (Count parameters:C259>=1)
		
		$t:=Get localized string:C991($title)
		$t:=Choose:C955(Length:C16($t)>0; $t; $title)  // Revert if no localization
		
	End if 
	
	OBJECT SET TITLE:C194(*; This:C1470.name; $t)
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === ===
Function getTitle()->$title : Text
	
	$title:=OBJECT Get title:C1068(*; This:C1470.name)
	
	//=== === === === === === === === === === === === === === === === === === ===
Function fontStyle($style : Integer)->$this : cs:C1710.static
	
	If (Count parameters:C259>=1)
		
		OBJECT SET FONT STYLE:C166(*; This:C1470.name; $style)
		
	Else 
		
		OBJECT SET FONT STYLE:C166(*; This:C1470.name; Plain:K14:1)
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === ===
Function setCoordinates($left; $top : Integer; $right : Integer; $bottom : Integer)->$this : cs:C1710.static
	
	var $o : Object
	
	If (Value type:C1509($left)=Is object:K8:27)
		
		$o:=New object:C1471(\
			"left"; Num:C11($left.left); \
			"top"; Num:C11($left.top))
		
		If ($left.right#Null:C1517)
			
			$o.right:=Num:C11($left.right)
			
		End if 
		
		If ($left.bottom#Null:C1517)
			
			$o.bottom:=Num:C11($left.bottom)
			
		End if 
		
	Else 
		
		$o:=New object:C1471(\
			"left"; Num:C11($left); \
			"top"; Num:C11($top))
		
		If (Count parameters:C259>=3)
			
			$o.right:=Num:C11($right)
			$o.bottom:=Num:C11($bottom)
			
		End if 
	End if 
	
	If ($o.right#Null:C1517)
		
		OBJECT SET COORDINATES:C1248(*; This:C1470.name; $o.left; $o.top; $o.right; $o.bottom)
		
	Else 
		
		OBJECT SET COORDINATES:C1248(*; This:C1470.name; $o.left; $o.top)
		
	End if 
	
	This:C1470._updateCoordinates($o.left; $o.top; $o.right; $o.bottom)
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === ===
Function getCoordinates()->$coordinates : Object
	
	var $bottom; $left; $right; $top : Integer
	
	OBJECT GET COORDINATES:C663(*; This:C1470.name; $left; $top; $right; $bottom)
	This:C1470._updateCoordinates($left; $top; $right; $bottom)
	
	$coordinates:=This:C1470.coordinates
	
	//=== === === === === === === === === === === === === === === === === === ===
Function bestSize($alignment; $minWidth : Integer; $maxWidth : Integer)->$this : cs:C1710.static
	
	var $bottom; $height; $left; $right; $top; $width : Integer
	var $o : Object
	
	If (Count parameters:C259>=1)
		
		If (Value type:C1509($alignment)=Is object:K8:27)
			
			$o:=$alignment
			
			If ($o.alignment=Null:C1517)
				
				$o.alignment:=Align left:K42:2
				
			End if 
			
		Else 
			
			$o:=New object:C1471(\
				"alignment"; $alignment)
			
			If (Count parameters:C259>=2)
				
				$o.minWidth:=$minWidth
				
				If (Count parameters:C259>=3)
					
					$o.maxWidth:=$maxWidth
					
				End if 
			End if 
		End if 
		
	Else 
		
		$o:=New object:C1471(\
			"alignment"; Align left:K42:2)
		
	End if 
	
	OBJECT GET COORDINATES:C663(*; This:C1470.name; $left; $top; $right; $bottom)
	
	If (New collection:C1472(\
		Object type 3D button:K79:17; \
		Object type 3D checkbox:K79:27; \
		Object type 3D radio button:K79:24; \
		Object type checkbox:K79:26; \
		Object type listbox column:K79:10; \
		Object type picture button:K79:20; \
		Object type picture radio button:K79:25; \
		Object type push button:K79:16; \
		Object type radio button:K79:23; \
		Object type static picture:K79:3; \
		Object type static text:K79:2; \
		Object type listbox:K79:8).indexOf(This:C1470.type)#-1)
		
		If ($o.maxWidth#Null:C1517)
			
			OBJECT GET BEST SIZE:C717(*; This:C1470.name; $width; $height; $o.maxWidth)
			
		Else 
			
			OBJECT GET BEST SIZE:C717(*; This:C1470.name; $width; $height)
			
		End if 
		
		Case of 
				
				//______________________________
			: (This:C1470.type=Object type static text:K79:2)\
				 | (This:C1470.type=Object type checkbox:K79:26)
				
				If (Num:C11($o.alignment)=Align left:K42:2)
					
					// Add 10 pixels
					$width:=$width+10
					
				End if 
				
				//______________________________
			: (This:C1470.type=Object type push button:K79:16)
				
				// Add 10% for margins
				$width:=Round:C94($width*1.1; 0)
				
				//______________________________
			Else 
				
				// Add 10 pixels
				$width:=$width+10
				
				//______________________________
		End case 
		
		If ($o.minWidth#Null:C1517)
			
			$width:=Choose:C955($width<$o.minWidth; $o.minWidth; $width)
			
		End if 
		
		If ($o.alignment=Align right:K42:4)
			
			$left:=$right-$width
			
		Else 
			
			// Default is Align left
			$right:=$left+$width
			
		End if 
		
		OBJECT SET COORDINATES:C1248(*; This:C1470.name; $left; $top; $right; $bottom)
		
	End if 
	
	This:C1470._updateCoordinates($left; $top; $right; $bottom)
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === ===
Function moveHorizontally($offset : Integer)->$this : cs:C1710.static
	
	var $bottom; $left; $right; $top : Integer
	
	OBJECT GET COORDINATES:C663(*; This:C1470.name; $left; $top; $right; $bottom)
	
	$left:=$left+$offset
	$right:=$right+$offset
	
	This:C1470.setCoordinates(New object:C1471(\
		"left"; $left; \
		"top"; $top; \
		"right"; $right; \
		"bottom"; $bottom))
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === ===
Function moveVertically($offset : Integer)->$this : cs:C1710.static
	
	var $bottom; $left; $right; $top : Integer
	
	OBJECT GET COORDINATES:C663(*; This:C1470.name; $left; $top; $right; $bottom)
	
	$top:=$top+$offset
	$bottom:=$bottom+$offset
	
	This:C1470.setCoordinates(New object:C1471(\
		"left"; $left; \
		"top"; $top; \
		"right"; $right; \
		"bottom"; $bottom))
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === ===
Function resizeHorizontally($offset : Integer)->$this : cs:C1710.static
	
	var $bottom; $left; $right; $top : Integer
	
	OBJECT GET COORDINATES:C663(*; This:C1470.name; $left; $top; $right; $bottom)
	
	$right:=$right+$offset
	
	This:C1470.setCoordinates(New object:C1471(\
		"left"; $left; \
		"top"; $top; \
		"right"; $right; \
		"bottom"; $bottom))
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === ===
Function resizeVertically($offset : Integer)->$this : cs:C1710.static
	
	var $bottom; $left; $right; $top : Integer
	
	OBJECT GET COORDINATES:C663(*; This:C1470.name; $left; $top; $right; $bottom)
	
	$bottom:=$bottom+$offset
	
	This:C1470.setCoordinates(New object:C1471(\
		"left"; $left; \
		"top"; $top; \
		"right"; $right; \
		"bottom"; $bottom))
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === ===
Function setDimension($width : Integer; $height : Integer)->$this : cs:C1710.static
	
	var $o : Object
	
	$o:=This:C1470.getCoordinates()
	$o.right:=$o.left+$width
	
	If (Count parameters:C259>=2)
		
		$o.bottom:=$o.top+$height
		
	End if 
	
	OBJECT SET COORDINATES:C1248(*; This:C1470.name; $o.left; $o.top; $o.right; $o.bottom)
	This:C1470._updateCoordinates($o.left; $o.top; $o.right; $o.bottom)
	
	$this:=This:C1470
	
Function setColors($foreground : Variant; $background : Variant; $altBackground : Variant)->$this : cs:C1710.static
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259>=3)
			
			$foreground:=Choose:C955(Value type:C1509($foreground)=Is text:K8:3; $foreground; Num:C11($foreground))
			$background:=Choose:C955(Value type:C1509($background)=Is text:K8:3; $background; Num:C11($background))
			$altBackground:=Choose:C955(Value type:C1509($altBackground)=Is text:K8:3; $altBackground; Num:C11($altBackground))
			
			OBJECT SET RGB COLORS:C628(*; This:C1470.name; $foreground; $background; $altBackground)
			
			//______________________________________________________
		: (Count parameters:C259>=2)
			
			$foreground:=Choose:C955(Value type:C1509($foreground)=Is text:K8:3; $foreground; Num:C11($foreground))
			$background:=Choose:C955(Value type:C1509($background)=Is text:K8:3; $background; Num:C11($background))
			
			OBJECT SET RGB COLORS:C628(*; This:C1470.name; $foreground; $background)
			
			//______________________________________________________
		: (Count parameters:C259>=1)
			
			$foreground:=Choose:C955(Value type:C1509($foreground)=Is text:K8:3; $foreground; Num:C11($foreground))
			
			OBJECT SET RGB COLORS:C628(*; This:C1470.name; $foreground)
			
			//______________________________________________________
		Else 
			
			// #ERROR
			
			//______________________________________________________
	End case 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === ===
Function _updateCoordinates($left : Integer; $top : Integer; $right : Integer; $bottom : Integer)->$this : cs:C1710.static
	
	var $bottomƒ; $leftƒ; $rightƒ; $topƒ : Integer
	
	If (Count parameters:C259>=4)
		
		$leftƒ:=$left
		$topƒ:=$top
		$rightƒ:=$right
		$bottomƒ:=$bottom
		
	Else 
		
		OBJECT GET COORDINATES:C663(*; This:C1470.name; $leftƒ; $topƒ; $rightƒ; $bottomƒ)
		
	End if 
	
	This:C1470.coordinates:=New object:C1471(\
		"left"; $leftƒ; \
		"top"; $topƒ; \
		"right"; $rightƒ; \
		"bottom"; $bottomƒ)
	
	This:C1470.dimensions:=New object:C1471(\
		"width"; $rightƒ-$leftƒ; \
		"height"; $bottomƒ-$topƒ)
	
	CONVERT COORDINATES:C1365($leftƒ; $topƒ; XY Current form:K27:5; XY Current window:K27:6)
	CONVERT COORDINATES:C1365($rightƒ; $bottomƒ; XY Current form:K27:5; XY Current window:K27:6)
	
	This:C1470.windowCoordinates:=New object:C1471(\
		"left"; $leftƒ; \
		"top"; $topƒ; \
		"right"; $rightƒ; \
		"bottom"; $bottomƒ)
	
	$this:=This:C1470