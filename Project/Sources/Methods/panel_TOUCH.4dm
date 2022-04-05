//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : panel_TOUCH
// ID[F7BCCE684B5F4360906F800B8FF8E6A9]
// Created 11-5-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Force a On bound variable change event
// ----------------------------------------------------
// Declarations
var $indx : Integer
var $container : Object

ARRAY TEXT:C222($widgets; 0)

$container:=(OBJECT Get pointer:C1124(Object subform container:K67:4))->

FORM GET OBJECTS:C898($widgets)

Repeat 
	
	$indx:=Find in array:C230($widgets; "panel.@"; $indx+1)
	
	If ($indx>0)
		
		(OBJECT Get pointer:C1124(Object named:K67:5; $widgets{$indx}))->:=$container
		
	End if 
Until ($indx=-1)