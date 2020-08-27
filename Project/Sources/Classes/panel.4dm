Class constructor
	
	This:C1470.formName:=Current form name:C1298
	
	If (Form:C1466.$panels=Null:C1517)
		
		Form:C1466.$panels:=New object:C1471(\
			This:C1470.formName; New object:C1471)
		
	Else 
		
		If (Form:C1466.$panels[This:C1470.formName]=Null:C1517)
			
			Form:C1466.$panels[This:C1470.formName]:=New object:C1471
			
		End if 
	End if 
	
	This:C1470.def:=Form:C1466.$panels[This:C1470.formName]
	
	If (OB Is empty:C1297(This:C1470.def))\
		 | (Shift down:C543 & Not:C34(Is compiled mode:C492))
		
		This:C1470.def:=cs:C1710[This:C1470.formName].new()
		
	End if 
	
	This:C1470.event:=FORM Event:C1606
	
	//============================================================================
Function refresh
	
	SET TIMER:C645(-1)
	
	//============================================================================
Function common
	var $0 : Object
	var ${1} : Integer
	
	var $focused : Text
	var $height; $i; $type; $width : Integer
	var $e : Object
	var $retainedEvents : Collection
	
	$e:=This:C1470.event
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			// Place the background & the bottom line {
			FORM GET PROPERTIES:C674(String:C10(This:C1470.formName); $width; $height)
			
			OBJECT SET COORDINATES:C1248(*; "bottom.line"; 16; $height-1; $width-16; $height-1)
			
			// ENTRY ORDER IS BASED UPON THE OBJECT NAMES
			ARRAY TEXT:C222($widgets; 0x0000)
			FORM GET OBJECTS:C898($widgets)
			SORT ARRAY:C229($widgets)
			
			This:C1470.entyOrder:=New collection:C1472
			
			For ($i; 1; Size of array:C274($widgets); 1)
				
				$type:=OBJECT Get type:C1300(*; $widgets{$i})
				
				If (OBJECT Get enterable:C1067(*; $widgets{$i}))\
					 | ($type=Object type listbox:K79:8)
					
					This:C1470.entyOrder.push($widgets{$i})
					
				End if 
			End for 
			
			ARRAY TEXT:C222($entryOrder; 0x0000)
			COLLECTION TO ARRAY:C1562(This:C1470.entyOrder; $entryOrder)
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
				If (This:C1470.entyOrder.length>0)
					
					GOTO OBJECT:C206(*; This:C1470.entyOrder[0])
					
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
	
	$0:=OB Copy:C1225($e)
	
	If (Count parameters:C259>=1)
		
		$retainedEvents:=New collection:C1472
		
		For ($i; 1; Count parameters:C259; 1)
			
			$retainedEvents.push(${$i})
			
		End for 
		
		If ($retainedEvents.indexOf($e.code)=-1)
			
			$0.code:=0
			
		End if 
	End if 