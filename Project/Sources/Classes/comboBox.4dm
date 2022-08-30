Class extends input

Class constructor($name : Text; $data : Object)
	
	Super:C1705($name)
	
	If (Count parameters:C259>=2)
		
		This:C1470.data:=$data
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Display the selection list (to use in the On getting focus event)
Function open()
	
	var $o : Object
	
	$o:=This:C1470.windowCoordinates
	
	POST CLICK:C466($o.right-10; $o.top+10; Current process:C322)
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Display the selection list (to use in the On Data change event)
Function automaticInsertion($ordered : Boolean)
	
	var $value
	
	$value:=This:C1470.data.currentValue
	
	If (This:C1470.data.values.indexOf($value)=-1)
		
		This:C1470.data.values.push($value)
		
		If ($ordered)
			
		End if 
	End if 
	