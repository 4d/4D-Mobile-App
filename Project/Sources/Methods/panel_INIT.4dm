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
#DECLARE($definition : Object; $value : Object)

If (False:C215)
	C_OBJECT:C1216(panel_INIT; $1)
	C_OBJECT:C1216(panel_INIT; $2)
End if 

var $help; $name; $title : Text
var $bottom; $height; $i; $index; $l; $left : Integer
var $right; $top; $vOffset; $width : Integer
var $nil : Pointer
var $panel : Object

// Delete the content of all panels to avoid re-entries
For ($i; 1; panel_Count; 1)
	
	$name:="panel."+String:C10($i)
	OBJECT SET SUBFORM:C1138(*; $name; "EMPTY")
	OBJECT SET VALUE:C1742($name; New object:C1471(\
		))
	
End for 

// Hide all dynamique objects
OBJECT SET VISIBLE:C603(*; "title.@"; False:C215)
OBJECT SET VISIBLE:C603(*; "panel.@"; False:C215)
OBJECT SET VISIBLE:C603(*; "help.@"; False:C215)

ARRAY TEXT:C222($objectNames; 0x0000)

For each ($panel; $definition.panels)
	
	$index+=1
	$name:="panel."+String:C10($index)
	$title:="title.label."+String:C10($index)
	$help:="help."+String:C10($index)
	
	If (Is nil pointer:C315(OBJECT Get pointer:C1124(Object named:K67:5; $name)))  // DUPLICATE
		
		OBJECT DUPLICATE:C1111(*; "title.label.1"; $title; $nil; ""; 0; $vOffset; 0; 0)
		OBJECT DUPLICATE:C1111(*; "help.1"; $help; $nil; ""; 0; $vOffset; 0; 0)
		OBJECT DUPLICATE:C1111(*; "panel.1"; $name; $nil; "panel."+String:C10($index-1); 0; $vOffset; 0; 0)  // Bound to the previous panel
		
	Else   // REUSE
		
		OBJECT GET COORDINATES:C663(*; $title; $left; $top; $right; $bottom)
		$height:=$bottom-$top
		$top:=$vOffset+10
		$bottom:=$top+$height
		OBJECT SET COORDINATES:C1248(*; $title; $left; $top; $right; $bottom)
		
		OBJECT GET COORDINATES:C663(*; $help; $left; $top; $right; $bottom)
		$height:=$bottom-$top
		$top:=$vOffset+10
		$bottom:=$top+$height
		OBJECT SET COORDINATES:C1248(*; $help; $left; $top; $right; $bottom)
		
	End if 
	
	// Set the panel form
	OBJECT SET SUBFORM:C1138(*; $name; String:C10($panel.form))
	
	OBJECT GET COORDINATES:C663(*; $name; $left; $l; $right; $l)
	
	If (Bool:C1537($panel.noTitle))
		
		OBJECT SET VISIBLE:C603(*; $title; False:C215)
		$top:=$vOffset
		
	Else 
		
		OBJECT SET TITLE:C194(*; $title; $panel.title)
		OBJECT SET VISIBLE:C603(*; $title; True:C214)
		$top:=$vOffset+40
		
		If (Bool:C1537($panel.help))
			
			OBJECT SET VISIBLE:C603(*; $help; True:C214)
			cs:C1710.group.new(New collection:C1472($title; $help).join(",")).distributeLeftToRight(New object:C1471("spacing"; 8))
			
		End if 
	End if 
	
	// Set coordinates
	FORM GET PROPERTIES:C674(String:C10($panel.form); $width; $height)
	$bottom:=$top+$height
	OBJECT SET COORDINATES:C1248(*; $name; $left; $top; $right; $bottom)
	
	// Make visible
	OBJECT SET VISIBLE:C603(*; $name; True:C214)
	
	If ($index<$definition.panels.length)
		
		//OBJECT SET RESIZING OPTIONS(*; $name; Resize horizontal none; Resize vertical none)
		$vOffset:=$bottom
		
	Else 
		
		// Last panel
		//OBJECT SET RESIZING OPTIONS(*; $name; Resize horizontal none; Resize vertical grow)
		
	End if 
	
	// Set panel container value
	If (Count parameters:C259>=2)
		
		OBJECT SET VALUE:C1742($name; $value)
		
	End if 
	
	APPEND TO ARRAY:C911($objectNames; $name)
	
End for each 

// Define the order of entry of the panels
FORM SET ENTRY ORDER:C1468($objectNames)

// Finally place the background
OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
OBJECT SET COORDINATES:C1248(*; "_background"; 0; 0; $width; $bottom)

// Give focus to the first panel
GOTO OBJECT:C206(*; $objectNames{1})