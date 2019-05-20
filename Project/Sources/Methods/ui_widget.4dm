//%attributes = {"invisible":true}
/*
Object := ***ui_widget*** ( action ; params )
 -> action (Text)
 -> params (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : ui_widget
  // Database: 4D Mobile App
  // ID[0459DC4C4E404157926D1354B3EE0789]
  // Created #12-4-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($Lon_bottom;$Lon_height;$Lon_horizontal;$Lon_left;$Lon_parameters;$Lon_right)
C_LONGINT:C283($Lon_top;$Lon_type;$Lon_vertical;$Lon_width)
C_TEXT:C284($t;$Txt_action)
C_OBJECT:C1216($Obj_params)

If (False:C215)
	C_OBJECT:C1216(ui_widget ;$0)
	C_TEXT:C284(ui_widget ;$1)
	C_OBJECT:C1216(ui_widget ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_action:=$1
	
	If ($Lon_parameters>=2)
		
		$Obj_params:=$2
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: (This:C1470=Null:C1517)
		
		ASSERT:C1129(False:C215;"This method must be called from an member method")
		
		  //______________________________________________________
	: ($Txt_action="get")
		
		This:C1470.getCoordinates()
		
		$Lon_type:=OBJECT Get type:C1300(*;This:C1470.name)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_type=Object type picture input:K79:5)
				
				This:C1470.getScrollPosition()
				This:C1470.getDimensions()
				
				  //______________________________________________________
			: ($Lon_type=Object type listbox:K79:8)
				
				This:C1470.getDefinition()
				This:C1470.getCell()
				
				  //______________________________________________________
		End case 
		
		  //______________________________________________________
	: ($Txt_action="show")
		
		If (Value type:C1509(This:C1470.name)=Is collection:K8:32)  // Group
			
			For each ($t;This:C1470.name)
				
				OBJECT SET VISIBLE:C603(*;$t;True:C214)
				
			End for each 
			
		Else 
			
			OBJECT SET VISIBLE:C603(*;This:C1470.name;True:C214)
			
		End if 
		
		  //______________________________________________________
	: ($Txt_action="hide")
		
		If (Value type:C1509(This:C1470.name)=Is collection:K8:32)  // Group
			
			For each ($t;This:C1470.name)
				
				OBJECT SET VISIBLE:C603(*;$t;False:C215)
				
			End for each 
			
		Else 
			
			OBJECT SET VISIBLE:C603(*;This:C1470.name;False:C215)
			
		End if 
		
		  //______________________________________________________
	: ($Txt_action="setVisible")
		
		If (Value type:C1509(This:C1470.name)=Is collection:K8:32)  // Group
			
			For each ($t;This:C1470.name)
				
				OBJECT SET VISIBLE:C603(*;$t;Bool:C1537($Obj_params.visible))
				
			End for each 
			
		Else 
			
			OBJECT SET VISIBLE:C603(*;This:C1470.name;Bool:C1537($Obj_params.visible))
			
		End if 
		
		  //______________________________________________________
	: ($Txt_action="alignOnBestSize")
		
		OBJECT GET COORDINATES:C663(*;This:C1470.name;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		OBJECT GET BEST SIZE:C717(*;This:C1470.name;$Lon_width;$Lon_height)
		
		If (Num:C11($Obj_params.alignment)=Align right:K42:4)
			
			$Lon_left:=$Lon_right-$Lon_width
			
		Else 
			
			  // Default is Align left
			$Lon_right:=$Lon_left+$Lon_width
			
		End if 
		
		OBJECT SET COORDINATES:C1248(*;This:C1470.name;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		
		  //______________________________________________________
	: ($Txt_action="coordinates")
		
		OBJECT GET COORDINATES:C663(*;This:C1470.name;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		
		  //______________________________________________________
	: ($Txt_action="setCoordinates")
		
		OBJECT GET COORDINATES:C663(*;This:C1470.name;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		$Lon_width:=$Lon_right-$Lon_left
		$Lon_height:=$Lon_bottom-$Lon_top
		
		If ($Obj_params.left=Null:C1517)
			
			If ($Obj_params.right#Null:C1517)
				
				  // Resize horizontally
				$Lon_right:=Num:C11($Obj_params.right)
				
			End if 
			
		Else 
			
			$Lon_left:=Num:C11($Obj_params.left)
			
			If ($Obj_params.right=Null:C1517)
				
				  // Move horizontally
				$Lon_right:=$Lon_left+$Lon_width
				
			Else 
				
				$Lon_right:=Num:C11($Obj_params.right)
				
			End if 
		End if 
		
		If ($Obj_params.top=Null:C1517)
			
			If ($Obj_params.bottom#Null:C1517)
				
				  // Resize vertically
				$Lon_bottom:=Num:C11($Obj_params.bottom)
				
			End if 
			
		Else 
			
			$Lon_top:=Num:C11($Obj_params.top)
			
			If ($Obj_params.bottom=Null:C1517)
				
				  // Move vertically
				$Lon_bottom:=$Lon_top+$Lon_height
				
			End if 
		End if 
		
		OBJECT SET COORDINATES:C1248(*;This:C1470.name;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		
		  //______________________________________________________
	: ($Txt_action="scrollPosition")
		
		OBJECT GET SCROLL POSITION:C1114(*;This:C1470.name;$Lon_vertical;$Lon_horizontal)
		
		This:C1470.scroll:=New object:C1471(\
			"vertical";$Lon_vertical;\
			"horizontal";$Lon_horizontal)
		
		  //______________________________________________________
	: ($Txt_action="setScrollPosition")
		
		If ($Obj_params.vertical#Null:C1517)
			
			$Lon_vertical:=Num:C11($Obj_params.vertical)
			
		End if 
		
		If ($Obj_params.horizontal#Null:C1517)
			
			$Lon_horizontal:=Num:C11($Obj_params.horizontal)
			
		End if 
		
		OBJECT SET SCROLL POSITION:C906(*;This:C1470.name;$Lon_vertical;$Lon_horizontal;*)
		
		This:C1470.scroll:=New object:C1471(\
			"vertical";$Lon_vertical;\
			"horizontal";$Lon_horizontal)
		
		  //______________________________________________________
	: ($Txt_action="getAttribute")
		
		SVG GET ATTRIBUTE:C1056(*;This:C1470.name;$Obj_params.id;$Obj_params.attribute;$t)
		This:C1470[$Obj_params.attribute]:=$t
		
		  //______________________________________________________
	: ($Txt_action="dimensions")
		
		PICTURE PROPERTIES:C457((This:C1470.pointer())->;$Lon_width;$Lon_height)
		
		This:C1470.dimensions:=New object:C1471(\
			"width";$Lon_width;\
			"height";$Lon_height)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_action+"\"")
		
		  //______________________________________________________
End case 

If ($Txt_action="alignOnBestSize")\
 | ($Txt_action="coordinates")\
 | ($Txt_action="setCoordinates")
	
	  // Update object coordinates
	This:C1470.coordinates:=New object:C1471(\
		"left";$Lon_left;\
		"top";$Lon_top;\
		"right";$Lon_right;\
		"bottom";$Lon_bottom;\
		"width";$Lon_right-$Lon_left;\
		"height";$Lon_bottom-$Lon_top)
	
	CONVERT COORDINATES:C1365($Lon_left;$Lon_top;XY Current form:K27:5;XY Current window:K27:6)
	CONVERT COORDINATES:C1365($Lon_right;$Lon_bottom;XY Current form:K27:5;XY Current window:K27:6)
	
	This:C1470.windowCoordinates:=New object:C1471(\
		"left";$Lon_left;\
		"top";$Lon_top;\
		"right";$Lon_right;\
		"bottom";$Lon_bottom)
	
Else 
	
	  // A "If" statement should never omit "Else"
	
End if 

  // ----------------------------------------------------
  // Return
$0:=This:C1470

  // ----------------------------------------------------
  // End