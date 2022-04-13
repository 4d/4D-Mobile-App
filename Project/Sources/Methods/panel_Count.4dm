//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : panel_Count
// ID[8F15843F50E74326BFE2E6117CA0A57E]
// Created 12-5-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Returns the number of panels of the form
// ----------------------------------------------------
// Declarations
#DECLARE()->$number : Integer

If (False:C215)
	C_LONGINT:C283(panel_Count; $0)
End if 

var $indx : Integer

ARRAY TEXT:C222($widgets; 0x0000)
FORM GET OBJECTS:C898($widgets)

Repeat 
	
	$indx:=Find in array:C230($widgets; "panel.@"; $indx+1)
	$number+=Num:C11($indx>0)
	
Until ($indx=-1)