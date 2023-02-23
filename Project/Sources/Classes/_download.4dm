Class constructor($data : Object)
	
	This:C1470.data:=$data
	
	This:C1470.method:=$data.method || "GET"
	
	If (This:C1470.withUI)
		
		This:C1470.progress:=cs:C1710.progress.new("downloadInProgress")\
			.setMessage(This:C1470.data.title)\
			.setProgress("barber")
		
	End if 
	
	This:C1470.received:=0
	This:C1470.errors:=New collection:C1472
	
	var Logger : cs:C1710.logger  // General journal
	Logger:=Logger || cs:C1710.logger.new()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function get withUI() : Boolean
	
	return This:C1470.data.caller#Null:C1517
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onHeaders($request : 4D:C1709.HTTPRequest; $e : Object)
	
	If (Num:C11(This:C1470.data.length)=0)
		
		This:C1470.data.length:=Num:C11($request.response.headers["Content-Length"] || $request.response.headers["content-length"])
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onData($request : 4D:C1709.HTTPRequest; $e : Object)
	
	If (This:C1470.withUI)\
		 && (Not:C34(Bool:C1537($request.terminated)))  // Reception is in progress
		
		This:C1470.received+=Num:C11($e.data.size)
		
		If (This:C1470.received>0)\
			 && (This:C1470.data.length>0)
			
			This:C1470.progress.setProgress(This:C1470.received/This:C1470.data.length)
			
		Else 
			
			This:C1470.progress.setProgress("barber")
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onResponse($request : 4D:C1709.HTTPRequest; $e : Object)
	
	//
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onError($request : 4D:C1709.HTTPRequest; $e : Object)
	
	// TODO:Error management
	
	If (This:C1470.withUI)
		
		This:C1470.progress.close()
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onTerminate($request : 4D:C1709.HTTPRequest; $e : Object)
	
	If (Num:C11($request.response.status)=200)
		
		// Terminate according to the "what" value.
		This:C1470[This:C1470.data.what]($request; $e)
		
	Else 
		
		Logger.error($request.url+": "+$request.errors.extract("message").join("\r"))
		
		// TODO:Error management
		
		If (This:C1470.withUI)
			
			This:C1470.progress.close()
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function SDK($request : 4D:C1709.HTTPRequest; $e : Object)
	
	var $key : Text
	var $headers; $manifest : Object
	var $folder : 4D:C1709.Folder
	var $error : cs:C1710.error
	
	// Extract all files
	Logger.info("Unzipping: "+This:C1470.data.sdk.path)
	
	If (This:C1470.withUI)
		
		This:C1470.progress.setMessage("unzipping").setProgress("undefined")
		
	End if 
	
	$folder:=This:C1470.data.sdk.parent.folder("sdk")
	
	If ($folder.exists)
		
		$folder.delete(Delete with contents:K24:24)
		
	End if 
	
	This:C1470.data.sdk.setContent($request.response.body)
	
	$error:=cs:C1710.error.new("hide")
	$folder:=ZIP Read archive:C1637(This:C1470.data.sdk).root.copyTo($folder.parent)
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
		
		This:C1470.data.manifest.setText(JSON Stringify:C1217($manifest; *))
		
		Logger.info("The 4D Mobile "+String:C10($manifest["x-amz-meta-platform"])+" SDK was updated to version "+$manifest.version)
		
		This:C1470.data.sdk.delete()
		
	Else 
		
		Logger.error("Failed to unarchive "+This:C1470.data.sdk.path)
		
		// TODO:Error management
		
	End if 
	
	If (This:C1470.withUI)
		
		This:C1470.progress.close()
		
		CALL FORM:C1391(This:C1470.data.caller.window; This:C1470.data.caller.method; This:C1470.data.caller.message)
		
	End if 