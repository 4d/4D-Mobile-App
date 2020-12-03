//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : panel_Form_common
// ID[5F674D01A17C4030B5D09AE0352A3681]
// Created 12-5-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $0 : Object
var ${1} : Integer

If (False:C215)
	C_OBJECT:C1216(panel_Form; $0)
	C_LONGINT:C283(panel_Form; ${1})
End if 

var $focused : Text
var $height; $i; $type; $width : Integer
var $e : Object
var $retainedEvents : Collection

ARRAY TEXT:C222($entryOrder; 0)

// ----------------------------------------------------
// Initialisations
$retainedEvents:=New collection:C1472

// Optional parameters
If (Count parameters:C259>=1)
	
	For ($i; 1; Count parameters:C259; 1)
		
		$retainedEvents.push(${$i})
		
	End for 
End if 

$e:=FORM Event:C1606

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		// Place the background & the bottom line {
		FORM GET PROPERTIES:C674(Current form name:C1298; $width; $height)
		
		OBJECT SET COORDINATES:C1248(*; "bottom.line"; 16; $height-1; $width-16; $height-1)
		
		// ENTRY ORDER IS BASED UPON THE OBJECT NAMES
		ARRAY TEXT:C222($widgets; 0x0000)
		FORM GET OBJECTS:C898($widgets)
		SORT ARRAY:C229($widgets)
		
		For ($i; 1; Size of array:C274($widgets); 1)
			
			$type:=OBJECT Get type:C1300(*; $widgets{$i})
			
			If (OBJECT Get enterable:C1067(*; $widgets{$i}))\
				 | ($type=Object type listbox:K79:8)
				
				APPEND TO ARRAY:C911($entryOrder; $widgets{$i})
				
			End if 
		End for 
		
		FORM SET ENTRY ORDER:C1468($entryOrder)
		
		// ACTIVATE ESSENTIAL EVENTS TO THE FORM
		ARRAY LONGINT:C221($tLon_events; 0x0000)
		APPEND TO ARRAY:C911($tLon_events; On Load:K2:1)
		APPEND TO ARRAY:C911($tLon_events; On Unload:K2:2)
		APPEND TO ARRAY:C911($tLon_events; On Timer:K2:25)
		APPEND TO ARRAY:C911($tLon_events; On Activate:K2:9)
		APPEND TO ARRAY:C911($tLon_events; On Getting Focus:K2:7)
		APPEND TO ARRAY:C911($tLon_events; On Losing Focus:K2:8)
		
		OBJECT SET EVENTS:C1239(*; ""; $tLon_events; Enable events others unchanged:K42:38)
		
		// POST-LOADING PROCESSING
		CALL SUBFORM CONTAINER:C1086(-On Load:K2:1)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Activate:K2:9)
		
		If (OBJECT Get name:C1087(Object with focus:K67:3)="")
			
			// Focus the first
			FORM GET ENTRY ORDER:C1469($entryOrder)
			
			If (Size of array:C274($entryOrder)>0)
				
				GOTO OBJECT:C206(*; $entryOrder{1})
				
			Else 
				
				GOTO OBJECT:C206(*; "")
				
			End if 
		End if 
		
		//______________________________________________________
	: ($e.code=On Getting Focus:K2:7)
		
		// Show help button if any
		$focused:=OBJECT Get name:C1087(Object with focus:K67:3)
		
		If (OBJECT Get type:C1300(*; $focused+".help")#Object type unknown:K79:1)
			
			OBJECT SET VISIBLE:C603(*; $focused+".help"; True:C214)
			
		End if 
		
		//______________________________________________________
	: ($e.code=On Losing Focus:K2:8)
		
		// Hide help button if any
		$focused:=OBJECT Get name:C1087(Object with focus:K67:3)
		
		If (OBJECT Get type:C1300(*; $focused+".help")#Object type unknown:K79:1)
			
			OBJECT SET VISIBLE:C603(*; $focused+".help"; False:C215)
			
		End if 
		
		//______________________________________________________
	: ($e.code=On Unload:K2:2)
		
		// 
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		//______________________________________________________
End case 

If ($retainedEvents.indexOf($e.code)=-1)
	
	$e.code:=0
	
End if 

// ----------------------------------------------------
// Return
$0:=$e