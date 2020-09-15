Class extends widget

Class constructor
	
	C_TEXT:C284($1)
	C_VARIANT:C1683($2)
	
	If (Count parameters:C259>=2)
		
		Super:C1705($1; $2)
		
	Else 
		
		Super:C1705($1)
		
	End if 
	
	//========================================================
Function asynchronous
	var $0 : Object
	
	This:C1470.indicatorType(Asynchronous progress bar:K42:36)
	
	$0:=This:C1470
	
	//========================================================
Function isAsynchronous
	var $0 : Boolean
	
	var $type : Integer
	
	$type:=This:C1470.getIndicatorType()
	
	$0:=($type=Asynchronous progress bar:K42:36) | ($type=Barber shop:K42:35)
	
	//========================================================
Function barber
	var $0 : Object
	
	This:C1470.indicatorType(Barber shop:K42:35)
	
	$0:=This:C1470
	
	//========================================================
Function isBarber
	var $0 : Boolean
	
	$0:=(This:C1470.getIndicatorType=Barber shop:K42:35)
	
	//========================================================
Function progress
	var $0 : Object
	
	This:C1470.indicatorType(Progress bar:K42:34)
	
	$0:=This:C1470
	
	//========================================================
Function isProgress
	var $0 : Boolean
	
	$0:=(This:C1470.getIndicatorType=Progress bar:K42:34)
	
	//========================================================
Function indicatorType
	var $0 : Object
	var $1 : Integer
	
	OBJECT SET INDICATOR TYPE:C1246(*; This:C1470.name; $1)
	This:C1470.indicatorType:=$1
	
	$0:=This:C1470
	
	//========================================================
Function getIndicatorType
	var $0 : Integer
	
	$0:=OBJECT Get indicator type:C1247(*; This:C1470.name)
	
	//========================================================
Function start
	
	If (Asserted:C1132(This:C1470.isAsynchronous()))
		
		This:C1470.setValue(1)
		
	End if 
	
	//========================================================
Function stop
	
	If (Asserted:C1132(This:C1470.isAsynchronous()))
		
		This:C1470.setValue(0)
		
	End if 