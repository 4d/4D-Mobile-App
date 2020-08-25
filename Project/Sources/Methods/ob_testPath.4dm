//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : ob_testPath
// ID[0891820C25E74BAFB812771534BE392B]
// Created 15-6-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Checks if the path exists and return True if so,
// even if not contain any values (not same result as comparison to Null)
// ----------------------------------------------------
// Declarations
var $0 : Boolean
var $1 : Object
var $2 : Text
var ${3} : Text

var $i; $param : Integer
var $schemPtr : Pointer
var $o; $Obj_in; $schem; $sub : Object

If (False:C215)
	C_BOOLEAN:C305(ob_testPath; $0)
	C_OBJECT:C1216(ob_testPath; $1)
	C_TEXT:C284(ob_testPath; $2)
	C_TEXT:C284(ob_testPath; ${3})
End if 

// ----------------------------------------------------
// Initialisations
$param:=Count parameters:C259

If (Asserted:C1132($param>=2; "Missing parameter"))
	
	// Required parameters
	$Obj_in:=$1
	
	// Optional parameters
	If ($param>=3)
		
		// <NONE>
		
	End if 
	
	$o:=New object:C1471
	$schem:=$o
	$schemPtr:=->$schem
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
For ($i; 2; $param; 1)
	
	$schemPtr->type:="object"
	$schemPtr->required:=New collection:C1472
	$schemPtr->required[0]:=${$i}
	
	If ($i<$param)
		
		$sub:=New object:C1471
		
		$schemPtr->properties:=New object:C1471
		$schemPtr->properties[${$i}]:=$sub
		
		$o:=$sub
		
		$schemPtr:=->$o
		
	End if 
End for 

// ----------------------------------------------------
// Return
$0:=JSON Validate:C1456($1; $schem).success

// ----------------------------------------------------
// End
