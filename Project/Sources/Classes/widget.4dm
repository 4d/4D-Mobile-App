Class extends static

Class constructor
	
	C_VARIANT:C1683($1)
	
	Super:C1705($1)
	
	C_POINTER:C301($ptr)
	$ptr:=OBJECT Get pointer:C1124(Object named:K67:5;This:C1470.name)
	This:C1470.assignable:=Not:C34(Is nil pointer:C315($ptr))
	
	If (This:C1470.assignable)
		
		This:C1470.pointer:=$ptr
		
	End if 
	
/*===============================================*/
Function getValue
	
	C_VARIANT:C1683($0)
	
	If (Asserted:C1132(This:C1470.type#-1;"Does not apply to a group"))
		
		If (This:C1470.assignable)
			
			$0:=(This:C1470.pointer)->
			
		End if 
	End if 
	
/*===============================================*/
Function setValue
	
	C_OBJECT:C1216($0)
	C_VARIANT:C1683($1)
	
	If (Asserted:C1132(This:C1470.type#-1;"Does not apply to a group"))
		
		If (This:C1470.assignable)
			
			(This:C1470.pointer)->:=$1
			
		End if 
	End if 
	
	$0:=This:C1470
	
/*===============================================*/
Function clear
	
	C_OBJECT:C1216($0)
	
	If (Asserted:C1132(This:C1470.type#-1;"Does not apply to a group"))
		
		If (This:C1470.assignable)
			
			CLEAR VARIABLE:C89((This:C1470.pointer)->)
			
		End if 
	End if 
	
	$0:=This:C1470
	
/*===============================================*/
Function touch
	
	If (Asserted:C1132(This:C1470.type#-1;"Does not apply to a group"))
		
		If (This:C1470.assignable)
			
			(This:C1470.pointer)->:=(This:C1470.pointer)->
			
		End if 
	End if 
	
/*===============================================*/
Function catch
	
	C_BOOLEAN:C305($0)
	C_VARIANT:C1683($1)
	
	If (Asserted:C1132(This:C1470.type#-1;"Does not apply to a group"))
		
		If (Count parameters:C259=0)
			
			$0:=(This:C1470.name=FORM Event:C1606.objectName)
			
		Else 
			
			If (Value type:C1509($1)=Is object:K8:27)
				
				$0:=(This:C1470.name=String:C10($1.objectName))
				
			Else 
				
				$0:=(This:C1470.name=String:C10($1))
				
			End if 
		End if 
	End if 
	
/*===============================================*/
Function bestSize  // Resize the widget to its best size
	
	C_OBJECT:C1216($0;$o)
	C_LONGINT:C283($1)  // Alignement
	C_LONGINT:C283($2)  // {minWidth}
	C_LONGINT:C283($3)  // {maxidth}
	C_LONGINT:C283($left;$top;$right;$bottom;$width;$height)
	
	$o:=New object:C1471
	
	If (Count parameters:C259>=1)
		
		$o.alignment:=$1
		
		If (Count parameters:C259>=2)
			
			$o.min:=$2
			
			If (Count parameters:C259>=3)
				
				$o.max:=$3
				
			End if 
		End if 
		
	Else 
		
		$o.alignment:=Align left:K42:2
		
	End if 
	
	If (This:C1470.type=-1)  // Group
		
		  // #TO_DO
		
	Else 
		
		OBJECT GET COORDINATES:C663(*;This:C1470.name;$left;$top;$right;$bottom)
		
		If ($o.max#Null:C1517)
			
			OBJECT GET BEST SIZE:C717(*;This:C1470.name;$width;$height;$o.max)
			
		Else 
			
			OBJECT GET BEST SIZE:C717(*;This:C1470.name;$width;$height)
			
		End if 
		
		If ($o.min#Null:C1517)
			
			$width:=Choose:C955($width<$o.min;$o.min;$width)
			
		End if 
		
		If ($o.alignment=Align right:K42:4)
			
			$left:=$right-$width
			
		Else 
			
			  // Default is Align left
			$right:=$left+$width
			
		End if 
		
		OBJECT SET COORDINATES:C1248(*;This:C1470.name;$left;$top;$right;$bottom)
		
		This:C1470._updateCoordinates($left;$top;$right;$bottom)
		
	End if 
	
	$0:=This:C1470
	
/*===============================================*/
Function setTitle
	
	C_OBJECT:C1216($0)
	C_TEXT:C284($1)  // Text or resname
	C_TEXT:C284($tName;$tTitle)
	
	$tTitle:=Get localized string:C991($1)
	$tTitle:=Choose:C955(OK=1;$tTitle;$1)  // Revert if no localization
	
	If (This:C1470.type=-1)  // Group
		
		For each ($tName;This:C1470.name)
			
			OBJECT SET TITLE:C194(*;$tName;$tTitle)
			
		End for each 
		
	Else 
		
		OBJECT SET TITLE:C194(*;This:C1470.name;$tTitle)
		
	End if 
	
	$0:=This:C1470
	
/*===============================================*/
Function getTitle
	
	C_TEXT:C284($0)
	
	If (This:C1470.type#Is collection:K8:32)
		
		$0:=OBJECT Get title:C1068(*;This:C1470.name)
		
	End if 
	
/*===============================================*/
Function getScrollPosition
	
	C_VARIANT:C1683($0)
	C_LONGINT:C283($lVertical;$lHorizontal)
	
	If (Asserted:C1132(This:C1470.type#-1;"Does not apply to a group"))
		
		If (New collection:C1472(\
			Object type subform:K79:40;\
			Object type listbox:K79:8;\
			Object type picture input:K79:5;\
			Object type hierarchical list:K79:7).indexOf(This:C1470.type)#-1)
			
			OBJECT GET SCROLL POSITION:C1114(*;This:C1470.name;$lVertical;$lHorizontal)
			
			If (This:C1470.type=Object type picture input:K79:5)\
				 | (This:C1470.type=Object type listbox:K79:8)
				
				This:C1470.scroll:=New object:C1471(\
					"vertical";$lVertical;\
					"horizontal";$lHorizontal)
				
			Else 
				
				This:C1470.scroll:=$lVertical
				
			End if 
			
			$0:=This:C1470.scroll
			
		End if 
	End if 
	
/*===============================================*/
Function setScrollPosition
	
	C_OBJECT:C1216($0)
	C_LONGINT:C283($1)
	C_LONGINT:C283($2)
	
	C_LONGINT:C283($lVertical;$lHorizontal)
	
	If (Asserted:C1132(This:C1470.type#-1;"Does not apply to a group"))
		
		OBJECT GET SCROLL POSITION:C1114(*;This:C1470.name;$lVertical;$lHorizontal)
		
		$lVertical:=$1
		
		If (Count parameters:C259>=2)\
			 & ((This:C1470.type=Object type picture input:K79:5) | (This:C1470.type=Object type listbox:K79:8))
			
			$lHorizontal:=$2
			
			OBJECT SET SCROLL POSITION:C906(*;This:C1470.name;$lVertical;$lHorizontal;*)
			
			This:C1470.scroll:=New object:C1471(\
				"vertical";$lVertical;\
				"horizontal";$lHorizontal)
			
		Else 
			
			OBJECT SET SCROLL POSITION:C906(*;This:C1470.name;$lVertical;*)
			
			This:C1470.scroll:=$lVertical
			
		End if 
	End if 
	
	$0:=This:C1470
	
/*===============================================*/
Function getShortcut
	
	C_OBJECT:C1216($0)
	C_TEXT:C284($t)
	C_LONGINT:C283($l)
	
	If (Asserted:C1132(This:C1470.type#-1;"Does not apply to a group"))
		
		OBJECT GET SHORTCUT:C1186(*;This:C1470.name;$t;$l)
		
		$0:=New object:C1471(\
			"key";$t;\
			"mofifier";$l)
		
	End if 
	
/*===============================================*/
Function setShortcut
	
	C_OBJECT:C1216($0)
	C_TEXT:C284($1)
	C_LONGINT:C283($2)
	
	If (Asserted:C1132(This:C1470.type#-1;"Does not apply to a group"))
		
		If (Count parameters:C259>=2)
			
			OBJECT SET SHORTCUT:C1185(*;This:C1470.name;$1;$2)
			
		Else 
			
			OBJECT SET SHORTCUT:C1185(*;This:C1470.name;$1)
			
		End if 
	End if 
	
	$0:=This:C1470
	
/*===============================================*/
Function focus
	
	C_OBJECT:C1216($0)
	
	If (This:C1470.type=-1)  // Group
		
		  // Goto the first object of the group
		GOTO OBJECT:C206(*;This:C1470.name[0])
		
	Else 
		
		GOTO OBJECT:C206(*;This:C1470.name)
		
	End if 
	
	$0:=This:C1470
	
/*===============================================*/