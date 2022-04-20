//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_ui_LISTBOX
// ID[D73060B901234F998F527281594EC7B5]
// Created 22-12-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $1 : Text
var $2 : Boolean

If (False:C215)
	C_TEXT:C284(_editor_ui_LISTBOX; $1)
	C_BOOLEAN:C305(_editor_ui_LISTBOX; $2)
End if 

var $listbox : Text
var $focused : Boolean
var $backgroundColor; $i : Integer
var $me : Pointer

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	$listbox:=$1
	
	$me:=OBJECT Get pointer:C1124(Object named:K67:5; $listbox)
	
	// Optional parameters
	If (Count parameters:C259>=2)
		
		$focused:=$2
		
	Else 
		
		$focused:=(OBJECT Get pointer:C1124(Object with focus:K67:3)=$me)
		
	End if 
	
	$backgroundColor:=Choose:C955($focused; UI.highlightColor; UI.highlightColorNoFocus)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
// WARNING: This method can't apply to a selection or collection listbox

OBJECT SET RGB COLORS:C628(*; $listbox; Foreground color:K23:1)
OBJECT SET RGB COLORS:C628(*; $listbox+".border"; Choose:C955($focused; UI.selectedColor; UI.backgroundUnselectedColor))

For ($i; 1; LISTBOX Get number of rows:C915(*; $listbox); 1)
	
	If ($me->{$i})
		
		LISTBOX SET ROW COLOR:C1270(*; $listbox; $i; Choose:C955($focused; UI.backgroundSelectedColor; UI.alternateSelectedColor); lk background color:K53:25)
		
	Else 
		
		LISTBOX SET ROW COLOR:C1270(*; $listbox; $i; $backgroundColor; lk background color:K53:25)
		
	End if 
End for 