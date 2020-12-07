Class constructor
	
	var $1 : Object
	
	This:C1470.input:=$1
	
	
Function main
	
	This:C1470.create()
	
	If (Bool:C1537(This:C1470.input.build))
		
		This:C1470.build()
		
		If (Bool:C1537(This:C1470.input.run))
			
			This:C1470.run()
			
		End if 
		
	End if 
	
Function create
	ASSERT:C1129(False:C215; "must be overriden")
	
	
Function build
	ASSERT:C1129(False:C215; "must be overriden")
	
	
Function run
	ASSERT:C1129(False:C215; "must be overriden")