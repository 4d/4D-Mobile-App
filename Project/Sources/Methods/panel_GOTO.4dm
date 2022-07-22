//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : panel_GOTO
// ID[74102A95AA7E491B932F5FA1A1F9FB75]
// Created 12-5-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Selects a panel
// ----------------------------------------------------
// Declarations
var $1 : Integer

If (False:C215)
	C_LONGINT:C283(panel_GOTO; $1)
End if 

var $isOpened : Boolean
var $count; $cursor; $panel : Integer
var $ptr : Pointer

// NO PARAMETERS REQUIRED

// Optional parameters
If (Count parameters:C259>=1)
	
	$panel:=$1  // Next open panel if not passed
	
End if 

$count:=panel_Count
$cursor:=$panel

// ----------------------------------------------------

Repeat 
	
	$cursor:=$cursor+1
	
	If ($cursor<=$count)
		
		// Is the panel opened?
		$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; "title.button."+String:C10($cursor))
		
		If (Not:C34(Is nil pointer:C315($ptr)))
			
			$isOpened:=($ptr->=1)
			
			If ($isOpened)
				
				GOTO OBJECT:C206(*; "panel."+String:C10($cursor))
				EXECUTE METHOD IN SUBFORM:C1085("panel."+String:C10($cursor); Formula:C1597(panel_SET_FOCUS))
				
			End if 
		End if 
		
	Else 
		
		// Restart at the first
		$cursor:=0
		
	End if 
Until ($isOpened)\
 | ($cursor=$panel)