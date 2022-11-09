Class constructor($method : Text; $length : Integer; $sdk : 4D:C1709.ZipFile; $fileManifest : 4D:C1709.File; $title : Text; $caller : Object)
	
	This:C1470.method:=$method || "GET"
	This:C1470.length:=Num:C11($length)
	This:C1470.target:=$sdk
	This:C1470.manifest:=$fileManifest
	This:C1470.withUI:=Length:C16($title)>0
	This:C1470.caller:=$caller
	
	If (This:C1470.withUI)
		
		This:C1470.progress:=cs:C1710.progress.new("downloadInProgress")\
			.setMessage($title)\
			.setProgress("barber")
		
	End if 
	
	This:C1470.received:=0
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onHeaders($request : 4D:C1709.HTTPRequest; $e : Object)
	
	//
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onData($request : 4D:C1709.HTTPRequest; $e : Object)
	
	If (Not:C34(Bool:C1537($request.terminated)))
		
		// The download is in progress
		This:C1470.received+=Num:C11($e.data.size)
		
		If (This:C1470.withUI)
			
			If (This:C1470.received>0)
				
				This:C1470.progress.setProgress(This:C1470.received/This:C1470.length)
				
			Else 
				
				This:C1470.progress.setProgress("undefined")
				
			End if 
		End if 
		
	Else 
		
		//
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onResponse($request : 4D:C1709.HTTPRequest; $e : Object)
	
	//
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onError($request : 4D:C1709.HTTPRequest; $e : Object)
	
	// TODO:Error management
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onTerminate($request : 4D:C1709.HTTPRequest; $e : Object)
	
	var $key : Text
	var $headers; $manifest : Object
	var $folder : 4D:C1709.Folder
	var $error : cs:C1710.error
	
	If (Num:C11($request.response.status)=200)
		
		// Extract all files
		Logger.info("Unzipping: "+This:C1470.target.path)
		
		If (This:C1470.withUI)
			
			This:C1470.progress.setMessage("unzipping").setProgress("undefined")
			
		End if 
		
		$folder:=This:C1470.target.parent.folder("sdk")
		
		If ($folder.exists)
			
			$folder.delete(Delete with contents:K24:24)
			
		End if 
		
		This:C1470.target.setContent($request.response.body)
		
		$error:=cs:C1710.error.new("hide")
		$folder:=ZIP Read archive:C1637(This:C1470.target).root.copyTo($folder.parent)
		$error.show()
		
		If ($error.noError())
			
			// Cleanup
			If ($folder.folder("__MACOSX").exists)
				
				$folder.folder("__MACOSX").delete(Delete with contents:K24:24)
				
			End if 
			
			$manifest:=New object:C1471(\
				"url"; $request.url; \
				"version"; "unknown"; \
				"build"; 0)
			
			If ($folder.file("sdkVersion").exists)
				
				$manifest.version:=Replace string:C233($folder.file("sdkVersion").getText(); "\n"; "")
				
			End if 
			
			$headers:=$request.response.headers
			
			For each ($key; $headers)
				
				$manifest[$key]:=$headers[$key]
				
				If ($key="x-amz-meta-build")
					
					$manifest.build:=$headers[$key]
					
				End if 
			End for each 
			
			This:C1470.manifest.setText(JSON Stringify:C1217($manifest; *))
			
			Logger.info("The 4D Mobile "+String:C10($manifest["x-amz-meta-platform"])+" SDK was updated to version "+$manifest.version)
			
		Else 
			
			// TODO:Error management
			Logger.error("Failed to unarchive "+This:C1470.target.path)
			
		End if 
		
		If (This:C1470.withUI)
			
			This:C1470.progress.close()
			
			CALL FORM:C1391(This:C1470.caller.window; This:C1470.caller.method; This:C1470.caller.message)
			
		End if 
		
	Else 
		
		// TODO:Error management
		Logger.error($request.url+": "+$request.errors.extract("message").join("\r"))
		
	End if 