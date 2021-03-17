Class constructor
	
	var $1 : Object
	
	This:C1470.input:=$1
	This:C1470.path:=cs:C1710.path.new()
	
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
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
	
Function dataSet()->$dump : Object
	// code copyed from iOS to dump with REST
	
	var $project : Object
	$project:=This:C1470.input.project  // to check
	
	
	// Erase if needed (data has changed, or must be generated at each build)
	$dump:=dataSet(New object:C1471(\
		"action"; "check"; \
		"digest"; True:C214; \
		"project"; $project))
	
	If (Bool:C1537($dump.exists))
		
		If (Not:C34($dump.valid) | Not:C34(Bool:C1537($project.dataSource.doNotGenerateDataAtEachBuild)))
			
			$dump:=dataSet(New object:C1471(\
				"action"; "erase"; \
				"project"; $project))
			
		End if 
	End if 
	
	// recheck to see if dump is here (but we do not check digest)
	$dump:=dataSet(New object:C1471(\
		"action"; "check"; \
		"digest"; False:C215; \
		"project"; $project))
	
	// we will make a dump, but for local dump we need a key, ping the server to ensure the key is created?
	var $pathname : Text
	If (Not:C34(Bool:C1537(This:C1470.dump.exists)))
		
		If (String:C10(This:C1470.input.dataSource.source)="server")
			
			// <NOTHING MORE TO DO>
			
		Else 
			// if local
			
			$pathname:=This:C1470.path.key().platformPath
			If (Not:C34(This:C1470.path.key().exists))
				
				This:C1470.keyPing:=Rest(New object:C1471(\
					"action"; "status"; \
					"handler"; "mobileapp"))
				This:C1470.keyPing.file:=New object:C1471(\
					"path"; $pathname; \
					"exists"; This:C1470.path.key().exists)
				
				If (Not:C34(This:C1470.keyPing.file.exists))
					
					// TODO manage error
					// ob_error_add($out; "Local server key file do not exists and cannot be created")
					
				End if 
			End if 
		End if 
		
		$dump:=dataSet(New object:C1471(\
			"action"; "create"; \
			"project"; $project; \
			"digest"; True:C214; \
			"dataSet"; True:C214; \
			"key"; $pathname; \
			"caller"; This:C1470.input.caller; \
			"verbose"; This:C1470.input.verbose))
		
	End if 
	
	
	
	
	