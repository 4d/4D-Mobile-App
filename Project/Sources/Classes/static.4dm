Class constructor
	
	C_VARIANT:C1683($1)
	
	If (Count parameters:C259>=1)
		
		This:C1470.name:=$1
		
	Else 
		
		  // Called from the widget method
		This:C1470.name:=OBJECT Get name:C1087(Object current:K67:2)
		
	End if 
	
	If (Value type:C1509(This:C1470.name)=Is collection:K8:32)
		
		This:C1470.type:=-1  // Group
		
	Else 
		
		This:C1470.type:=OBJECT Get type:C1300(*;This:C1470.name)
		
		ASSERT:C1129(This:C1470.type#0;Current method name:C684+": The object \""+This:C1470.name+"\" doesn't exist!")
		
	End if 
	
	This:C1470.action:=OBJECT Get action:C1457(*;This:C1470.name)
	
	This:C1470._updateCoordinates()
	
/*===============================================*/
Function hide
	
	C_OBJECT:C1216($0)
	C_TEXT:C284($t)
	
	If (This:C1470.type=-1)  // Group
		
		For each ($t;This:C1470.name)
			
			OBJECT SET VISIBLE:C603(*;$t;False:C215)
			
		End for each 
		
	Else 
		
		OBJECT SET VISIBLE:C603(*;This:C1470.name;False:C215)
		
	End if 
	
	$0:=This:C1470
	
/*===============================================*/
Function show
	
	C_OBJECT:C1216($0)
	C_TEXT:C284($t)
	
	If (This:C1470.type=-1)  // Group
		
		For each ($t;This:C1470.name)
			
			OBJECT SET VISIBLE:C603(*;$t;True:C214)
			
		End for each 
		
	Else 
		
		OBJECT SET VISIBLE:C603(*;This:C1470.name;True:C214)
		
	End if 
	
	$0:=This:C1470
	
/*===============================================*/
Function setVisible
	
	C_OBJECT:C1216($0)
	C_BOOLEAN:C305($1)
	
	If ($1)
		
		This:C1470.show()
		
	Else 
		
		This:C1470.hide()
		
	End if 
	
	$0:=This:C1470
	
/*===============================================*/
Function getVisible
	
	C_BOOLEAN:C305($0)
	C_TEXT:C284($t)
	
	If (This:C1470.type=-1)
		
		$0:=True:C214
		
		For each ($t;This:C1470.name)
			
			$0:=$0 & OBJECT Get visible:C1075(*;$t)
			
		End for each 
		
	Else 
		
		$0:=OBJECT Get visible:C1075(*;This:C1470.name)
		
	End if 
	
/*===============================================*/
Function enable
	
	C_OBJECT:C1216($0)
	C_TEXT:C284($t)
	
	If (This:C1470.type=-1)  // Group
		
		For each ($t;This:C1470.name)
			
			OBJECT SET ENABLED:C1123(*;$t;True:C214)
			
		End for each 
		
	Else 
		
		OBJECT SET ENABLED:C1123(*;This:C1470.name;True:C214)
		
	End if 
	
	$0:=This:C1470
	
/*===============================================*/
Function disable
	
	C_OBJECT:C1216($0)
	C_TEXT:C284($t)
	
	If (This:C1470.type=-1)  // Group
		
		For each ($t;This:C1470.name)
			
			OBJECT SET ENABLED:C1123(*;$t;False:C215)
			
		End for each 
		
	Else 
		
		OBJECT SET ENABLED:C1123(*;This:C1470.name;False:C215)
		
	End if 
	
	$0:=This:C1470
	
/*===============================================*/
Function setEnabled
	
	C_OBJECT:C1216($0)
	C_BOOLEAN:C305($1)
	
	If ($1)
		
		This:C1470.enable()
		
	Else 
		
		This:C1470.disable()
		
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
Function setCoordinates
	
	C_OBJECT:C1216($0;$o)
	C_VARIANT:C1683($1;$2;$3;$4)
	C_LONGINT:C283($left;$top;$right;$bottom)
	
	OBJECT GET COORDINATES:C663(*;This:C1470.name;$left;$top;$right;$bottom)
	
	$o:=New object:C1471(\
		"left";$left;\
		"top";$top;\
		"right";$right;\
		"bottom";$bottom;\
		"width";$right-$left;\
		"height";$bottom-$top)
	
	If ($1#Null:C1517)
		
		$o.left:=Num:C11($1)
		
		If ($3#Null:C1517)
			
			$o.right:=Num:C11($3)
			
		Else 
			
			  // Move horizontally
			$o.right:=$o.left+$o.width
			
		End if 
		
	Else 
		
		If ($3#Null:C1517)
			
			  // Resize horizontally
			$o.right:=Num:C11($3)
			
		End if 
	End if 
	
	If ($2#Null:C1517)
		
		$o.top:=Num:C11($2)
		
		If ($4#Null:C1517)
			
			$o.bottom:=Num:C11($4)
			
		Else 
			
			  // Move vertically
			$o.bottom:=$o.top+$o.height
			
		End if 
		
	Else 
		
		If ($4#Null:C1517)
			
			  // Resize vertically
			$o.bottom:=Num:C11($4)
			
		End if 
	End if 
	
	OBJECT SET COORDINATES:C1248(*;This:C1470.name;$o.left;$o.top;$o.right;$o.bottom)
	
	This:C1470._updateCoordinates($o.left;$o.top;$o.right;$o.bottom)
	
	$0:=This:C1470
	
/*===============================================*/
Function getCoordinates
	
	C_OBJECT:C1216($0)
	C_LONGINT:C283($left;$top;$right;$bottom)
	
	If (This:C1470.type#-1)
		
		OBJECT GET COORDINATES:C663(*;This:C1470.name;$left;$top;$right;$bottom)
		
		This:C1470._updateCoordinates($left;$top;$right;$bottom)
		
		$0:=This:C1470.coordinates
		
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
		
		Case of 
				
				  //______________________________
			: (This:C1470.type=Object type static text:K79:2)\
				 | (This:C1470.type=Object type checkbox:K79:26)
				
				  // Add 10 pixels
				$width:=$width+10
				
				  //______________________________
			: (This:C1470.type=Object type push button:K79:16)
				
				  // Add 10% for margins
				$width:=Round:C94($width*1.1;0)
				
				  //______________________________
			Else 
				
				  // Add 10 pixels
				$width:=$width+10
				
				  //______________________________
		End case 
		
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
Function moveHorizontally
	
	C_OBJECT:C1216($0)
	C_LONGINT:C283($1)
	
	C_OBJECT:C1216($o)
	
	$o:=This:C1470.getCoordinates()
	This:C1470.setCoordinates($o.left+$1;Null:C1517;Null:C1517;Null:C1517)
	
	$0:=This:C1470
	
/*===============================================*/
Function moveVertically
	
	C_OBJECT:C1216($0)
	C_LONGINT:C283($1)
	C_OBJECT:C1216($o)
	
	$o:=This:C1470.getCoordinates()
	This:C1470.setCoordinates(Null:C1517;This:C1470.coordinates.top+$1;Null:C1517;Null:C1517)
	
	$0:=This:C1470
	
/*===============================================*/
Function resizeHorizontally
	
	C_OBJECT:C1216($0)
	C_LONGINT:C283($1)
	C_OBJECT:C1216($o)
	
	$o:=This:C1470.getCoordinates()
	This:C1470.setCoordinates(Null:C1517;Null:C1517;This:C1470.coordinates.right+$1;Null:C1517)
	
	$0:=This:C1470
	
/*===============================================*/
Function resizeVertically
	
	C_OBJECT:C1216($0)
	C_LONGINT:C283($1)
	C_OBJECT:C1216($o)
	
	$o:=This:C1470.getCoordinates()
	This:C1470.setCoordinates(Null:C1517;Null:C1517;Null:C1517;This:C1470.coordinates.bottom+$1)
	
	$0:=This:C1470
	
/*===============================================*/
Function setDimension
	
	C_OBJECT:C1216($0;$o)
	C_LONGINT:C283($1;$2)
	
	$o:=This:C1470.getCoordinates()
	
	If (Count parameters:C259>=2)
		
		OBJECT SET COORDINATES:C1248(*;This:C1470.name;$o.left;$o.top;$o.right+$1;$o.bottom+$2)
		
	Else 
		
		OBJECT SET COORDINATES:C1248(*;This:C1470.name;$o.left;$o.top;$o.right+$1;$o.bottom)
		
	End if 
	
	$0:=This:C1470
	
/*===============================================*/
Function _updateCoordinates
	
	C_OBJECT:C1216($0)
	C_LONGINT:C283($1;$2;$3;$4)
	C_LONGINT:C283($bottom;$left;$right;$top)
	
	If (Count parameters:C259>=4)
		
		$left:=$1
		$top:=$2
		$right:=$3
		$bottom:=$4
		
	Else 
		
		OBJECT GET COORDINATES:C663(*;This:C1470.name;$left;$top;$right;$bottom)
		
	End if 
	
	This:C1470.coordinates:=New object:C1471(\
		"left";$left;\
		"top";$top;\
		"right";$right;\
		"bottom";$bottom)
	
	This:C1470.dimensions:=New object:C1471(\
		"width";$right-$left;\
		"height";$bottom-$top)
	
	CONVERT COORDINATES:C1365($left;$top;XY Current form:K27:5;XY Current window:K27:6)
	CONVERT COORDINATES:C1365($right;$bottom;XY Current form:K27:5;XY Current window:K27:6)
	
	This:C1470.windowCoordinates:=New object:C1471(\
		"left";$left;\
		"top";$top;\
		"right";$right;\
		"bottom";$bottom)
	
	$0:=This:C1470