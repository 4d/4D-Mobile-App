//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : panel_Objects
// ID[B68517EA8DD94B4FB2C87ECF876A1F2F]
// Created 10-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Returns a collection of the panels of the current form
// ----------------------------------------------------
// Declarations
var $0 : Collection

If (False:C215)
	C_COLLECTION:C1488(panels; $0)
End if 

var $index : Integer
var $panels : Collection

// NO PARAMETERS REQUIRED

// ----------------------------------------------------
ARRAY TEXT:C222($widgets; 0x0000)
FORM GET OBJECTS:C898($widgets)

$panels:=New collection:C1472

Repeat 
	
	$index:=Find in array:C230($widgets; "panel.@"; $index+1)
	
	If ($index>0)
		
		$panels.push($widgets{$index})
		
	End if 
Until ($index=-1)

// ----------------------------------------------------
// Return
$0:=$panels

// ----------------------------------------------------
// End