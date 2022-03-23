//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : panel_INIT
// ID[6C4D51233CB94D1790FD39B385FB494F]
// Created 11-5-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $1 : Object
var $2 : Object

If (False:C215)
	C_OBJECT:C1216(panel_INIT; $1)
	C_OBJECT:C1216(panel_INIT; $2)
End if 

var $help; $key; $panel; $t; $title : Text
var $bottom; $height; $index; $l; $left; $right; $top; $vOffset; $width : Integer
var $nil : Pointer
var $definition; $o : Object

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	$definition:=$1  // Definition of the panels
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
// UI
If ($definition.ui#Null:C1517)
	
	For each ($key; $definition.ui)
		
		Case of 
				
				//______________________________________________________
			: ($key="background")  // Background color
				
				OBJECT SET RGB COLORS:C628(*; "_background"; Background color none:K23:10; $definition.ui.background)
				
				//______________________________________________________
			: ($key="line")  // Lines color
				
				OBJECT SET RGB COLORS:C628(*; "title.line.1"; $definition.ui.line; Background color:K23:2)
				
				//______________________________________________________
			: ($key="labels")  // Labels color
				
				OBJECT SET RGB COLORS:C628(*; "title.label.1"; $definition.ui.labels; Background color:K23:2)
				
				//________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Unknown key: \""+$key+"\"")
				
				//______________________________________________________
		End case 
	End for each 
End if 

// Hide all dynamique objects
OBJECT SET VISIBLE:C603(*; "title.@"; False:C215)
OBJECT SET VISIBLE:C603(*; "panel.@"; False:C215)
OBJECT SET VISIBLE:C603(*; "help.@"; False:C215)

ARRAY TEXT:C222($objectNames; 0x0000)

For each ($o; $definition.panels)
	
	$index:=$index+1
	$panel:="panel."+String:C10($index)
	$title:="title.label."+String:C10($index)
	$help:="help."+String:C10($index)
	
	If (Is nil pointer:C315(OBJECT Get pointer:C1124(Object named:K67:5; $panel)))  // DUPLICATE
		
		// Title
		OBJECT DUPLICATE:C1111(*; "title.label.1"; $title; $nil; ""; 0; $vOffset; 0; 0)
		
		// Help
		OBJECT DUPLICATE:C1111(*; "help.1"; $help; $nil; ""; 0; $vOffset; 0; 0)
		
		// Panel (bound to the previous panel)
		OBJECT DUPLICATE:C1111(*; "panel.1"; $panel; $nil; "panel."+String:C10($index-1); 0; $vOffset; 0; 0)
		
	Else   // REUSE
		
		OBJECT GET COORDINATES:C663(*; $title; $left; $top; $right; $bottom)
		$height:=$bottom-$top
		
		$top:=$vOffset+10
		
		$bottom:=$top+$height
		OBJECT SET COORDINATES:C1248(*; $title; $left; $top; $right; $bottom)
		
		OBJECT GET COORDINATES:C663(*; $help; $left; $top; $right; $bottom)
		$height:=$bottom-$top
		$top:=$vOffset+10
		$top:=$vOffset+10
		$bottom:=$top+$height
		OBJECT SET COORDINATES:C1248(*; $help; $left; $top; $right; $bottom)
		
	End if 
	
	// Set the panel form…
	$t:=$o.form
	FORM GET PROPERTIES:C674($t; $width; $height)
	
	OBJECT SET SUBFORM:C1138(*; $panel; $t)
	
	OBJECT GET COORDINATES:C663(*; $panel; $left; $l; $right; $l)
	
	If (Bool:C1537($o.noTitle))
		
		OBJECT SET VISIBLE:C603(*; $title; False:C215)
		
		$top:=$vOffset
		
	Else 
		
		OBJECT SET TITLE:C194(*; $title; $o.title)
		
		OBJECT SET VISIBLE:C603(*; $title; True:C214)
		OBJECT SET VISIBLE:C603(*; $help; Bool:C1537($o.help))
		
		_o_ui_ALIGN_ON_BEST_SIZE(Align left:K42:2; $title; $help)
		
		$top:=$vOffset+40
		
	End if 
	
	// Set coordinates
	$bottom:=$top+$height
	OBJECT SET COORDINATES:C1248(*; $panel; $left; $top; $right; $bottom)
	
	// Make visible
	OBJECT SET VISIBLE:C603(*; $panel; True:C214)
	
	If ($index<$definition.panels.length)
		
		//OBJECT SET RESIZING OPTIONS(*;$Txt_panel;Resize horizontal none;Resize vertical none)
		$vOffset:=$bottom
		
	Else 
		
		// Last panel
		//OBJECT SET RESIZING OPTIONS(*;$Txt_panel;Resize horizontal none;Resize vertical grow)
		
	End if 
	
	If (Count parameters:C259>=2)
		
		OBJECT SET VALUE:C1742($panel; $2)
		
	End if 
	
	APPEND TO ARRAY:C911($objectNames; $panel)
	
End for each 

FORM SET ENTRY ORDER:C1468($objectNames)

// Finally place the background
OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
OBJECT SET COORDINATES:C1248(*; "_background"; 0; 0; $width; $bottom)

CALL FORM:C1391(Current form window:C827; Formula:C1597(project_SKIN).source; $definition)

GOTO OBJECT:C206(*; $objectNames{1})