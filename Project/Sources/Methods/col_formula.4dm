//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : col_formula
// Created 27-7-2018 by Eric Marchand
// ----------------------------------------------------
// Description:
// Use formula on each element.
// To be use with `.map` or other collection member functions.
// ----------------------------------------------------
// Declarations
var $1 : Object
var $2 : Variant

// ----------------------------------------------------

If (Value type:C1509($2)=Is text:K8:3)
	
	EXECUTE FORMULA:C63($2)
	
Else 
	
	ASSERT:C1129(OB Instance of:C1731($2; 4D:C1709.Function))
	
	$2.call(Null:C1517; $1)
	
End if 