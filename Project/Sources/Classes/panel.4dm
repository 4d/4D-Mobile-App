Class extends form

//=== === === === === === === === === === === === === === === === === === === === ===
Class constructor($method : Text)
	
	Super:C1705($method)
	
	This:C1470.isSubform:=True:C214
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Creates if necessary the object Form.$dialog [Current form] and returns it
Function init() : Object
	
	Form:C1466.$dialog:=Form:C1466.$dialog || New object:C1471
	Form:C1466.$dialog[This:C1470.currentForm]:=Form:C1466.$dialog[This:C1470.currentForm] || New object:C1471
	
	return (Form:C1466.$dialog[This:C1470.currentForm])
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Events handler
Function handleEvents($eventCode; $eventCode2 : Integer; $eventCodeN : Integer)->$e : Object
	
	var ${2} : Integer
	var $forward : Boolean
	var $height; $i; $width : Integer
	var $c : Collection
	
	$e:=FORM Event:C1606
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			// * PLACE THE BACKGROUND & THE BOTTOM LINE
			FORM GET PROPERTIES:C674(String:C10(This:C1470.currentForm); $width; $height)
			OBJECT SET COORDINATES:C1248(*; "bottom.line"; 16; $height-1; $width-16; $height-1)
			
			// * ENTRY ORDER IS BASED UPON THE OBJECT NAMES
			ARRAY TEXT:C222($widgets; 0x0000)
			FORM GET OBJECTS:C898($widgets)
			SORT ARRAY:C229($widgets)
			
			For ($i; 1; Size of array:C274($widgets); 1)
				
				If (OBJECT Get enterable:C1067(*; $widgets{$i}))\
					 || (OBJECT Get type:C1300(*; $widgets{$i})=Object type listbox:K79:8)
					
					This:C1470.entryOrder.push($widgets{$i})
					
				End if 
			End for 
			
			This:C1470.setEntryOrder(This:C1470.entryOrder)
			
			// * ACTIVATE ESSENTIAL EVENTS TO THE FORM
			This:C1470.appendEvents(New collection:C1472(On Load:K2:1; On Unload:K2:2; On Timer:K2:25; On Activate:K2:9; On Getting Focus:K2:7; On Losing Focus:K2:8))
			
			// * POST-LOADING PROCESSING
			This:C1470.callParent(-On Load:K2:1)
			
			// * START TIMER
			This:C1470.refresh()
			
			//______________________________________________________
		: ($e.code=On Activate:K2:9)
			
			If (This:C1470.focused="")\
				 && (This:C1470.entryOrder.length>0)
				
				// Focus the first
				GOTO OBJECT:C206(*; This:C1470.entryOrder[0])
				
			End if 
			
			//______________________________________________________
		: ($e.code=On Unload:K2:2)
			
			//
			
			//______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			SET TIMER:C645(0)
			
			//______________________________________________________
	End case 
	
	If (Count parameters:C259>=1)
		
		// FIXME:Remove for 19R6+
		If (Num:C11(Application version:C493)>=1960)
			
			If (Value type:C1509($eventCode)#Is collection:K8:32)
				
				$eventCode:=Copy parameters:C1790
				
			End if 
			
			$forward:=($eventCode.indexOf($e.code)#-1)
			
		Else 
			
			If (Value type:C1509($eventCode)=Is collection:K8:32)
				
				$forward:=($eventCode.indexOf($e.code)#-1)
				
			Else 
				
				For ($i; 1; Count parameters:C259; 1)
					
					If (Num:C11(${$i})=$e.code)
						
						$forward:=True:C214
						break
						
					End if 
				End for 
			End if 
		End if 
	End if 
	
	If (Not:C34($forward))
		
		$e.code:=0
		$e.description:="Treated in panel.handleEvents()"
		
	End if 