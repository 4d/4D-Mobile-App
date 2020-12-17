Class constructor
	
	var $1 : Object
	
	This:C1470.input:=$1
	
	
Function main
	var $0 : Object
	var $Obj_result : Object
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	// For debugging
	This:C1470.input.build:=True:C214
	This:C1470.input.run:=True:C214
	
	$Obj_result:=This:C1470.create()
	
	If ($Obj_result.success)
		
		If (Bool:C1537(This:C1470.input.build))
			
			$Obj_result:=This:C1470.build()
			
			If ($Obj_result.success)
				
				If (Bool:C1537(This:C1470.input.run))
					
					$Obj_result:=This:C1470.run()
					
					If ($Obj_result.success)
						// Nothing to do
						$0.success:=True:C214
					Else 
						// Error occurred while running project
					End if 
					
				Else 
					// No run requested
					$0.success:=True:C214
				End if 
				
			Else 
				// Error occurred while building project
			End if 
			
		Else 
			// No build requested
			$0.success:=True:C214
		End if 
		
	Else 
		// Error occurred while creating project
	End if 
	
	$0.errors:=$Obj_result.errors
	
	POST_MESSAGE(New object:C1471(\
		"type"; "alert"; \
		"target"; This:C1470.input.caller; \
		"additional"; "Procedure complete"))
	
	SHOW ON DISK:C922(This:C1470.input.path)
	
	
	
Function create
	ASSERT:C1129(False:C215; "must be overriden")
	
	
Function build
	ASSERT:C1129(False:C215; "must be overriden")
	
	
Function run
	ASSERT:C1129(False:C215; "must be overriden")
	
	
Function postStep
	var $1 : Text
	
	POST_MESSAGE(New object:C1471(\
		"target"; This:C1470.input.caller; \
		"additional"; $1))
	
	
Function postError
	var $1 : Text
	
	POST_MESSAGE(New object:C1471(\
		"type"; "alert"; \
		"target"; This:C1470.input.caller; \
		"additional"; $1))