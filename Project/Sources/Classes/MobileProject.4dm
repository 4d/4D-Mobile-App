Class constructor
	
	var $1 : Object
	
	This:C1470.input:=$1
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function main()->$result : Object
	
	var $o : Object
	
	$result:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	// For debugging
	This:C1470.input.build:=True:C214
	This:C1470.input.run:=True:C214
	
	$o:=This:C1470.create()
	
	If ($o.success)
		
		If (Bool:C1537(This:C1470.input.build))
			
			$o:=This:C1470.build()
			
			If ($o.success)
				
				If (Bool:C1537(This:C1470.input.run))
					
					$o:=This:C1470.run()
					
					If ($o.success)
						
						// Nothing to do
						$result.success:=True:C214
						
					Else 
						
						// Error occurred while running project
						
					End if 
					
				Else 
					
					// No run requested
					$result.success:=True:C214
					
				End if 
				
			Else 
				
				// Error occurred while building project
				
			End if 
			
		Else 
			
			// No build requested
			$result.success:=True:C214
			
		End if 
		
	Else 
		
		// Error occurred while creating project
		
	End if 
	
	$result.errors:=$o.errors
	
	POST_MESSAGE(New object:C1471("target"; This:C1470.input.caller; "action"; "hide"))
	
	If (DATABASE.isMatrix)
		
		SHOW ON DISK:C922(This:C1470.input.path)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function create
	
	ASSERT:C1129(False:C215; "must be overriden")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function build
	
	ASSERT:C1129(False:C215; "must be overriden")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function run
	
	ASSERT:C1129(False:C215; "must be overriden")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function postStep($message : Text)
	
	POST_MESSAGE(New object:C1471(\
		"target"; This:C1470.input.caller; \
		"additional"; $message))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function postError($message : Text)
	
	POST_MESSAGE(New object:C1471(\
		"type"; "alert"; \
		"target"; This:C1470.input.caller; \
		"additional"; $message))