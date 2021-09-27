Class constructor
	
	This:C1470.handler:="mobileapp"
	This:C1470.method:=HTTP GET method:K71:1
	This:C1470.headers:=New collection:C1472(New object:C1471("X-MobileApp"; "1"))
	This:C1470.timeout:=60
	
	This:C1470.path:=""
	
	var $1 : Text
	
	If (Count parameters:C259>=1)
		
		This:C1470.setURL($1)
		
	Else 
		
		This:C1470.setURL()
		
	End if 
	
Function setURL
	
	var $1 : Text
	
	If (Count parameters:C259>=1)
		
		This:C1470.url:=$1
		
		// Add missing / if necessary
		If (Not:C34(Match regex:C1019("/$"; This:C1470.url; 1)))
			
			This:C1470.url:=This:C1470.url+"/"
			
		End if 
		
		// Add missing handler if needed
		If (Not:C34(Match regex:C1019(This:C1470.handler+"/$"; This:C1470.url; 1)))
			
			This:C1470.url:=This:C1470.url+This:C1470.handler+"/"
			
		End if 
		
	Else 
		
		// Default url to the current database
		var $o : Object
		$o:=WEB Get server info:C1531
		
/*
WARNING: "localhost" may not find the server if the computer is connected to a network.
127.0.0.1, on the other hand, will connect directly without going out to the network.
*/
		
		Case of 
				
				//________________________________________
			: (Bool:C1537($o.security.HTTPEnabled))  // Priority for http
				
				This:C1470.url:="http://127.0.0.1:"+String:C10($o.options.webPortID)+"/"+This:C1470.handler+"/"
				
				//________________________________________
			: (Bool:C1537($o.security.HTTPSEnabled))  // Only https, use it
				
				This:C1470.url:="https://127.0.0.1:"+String:C10($o.options.webHTTPSPortID)+"/"+This:C1470.handler+"/"
				
				//________________________________________
			Else 
				
				This:C1470.url:="http://127.0.0.1:"+String:C10(WEB Get server info:C1531.options.webPortID)+"/"+This:C1470.handler+"/"
				
				//________________________________________
		End case 
	End if 
	
Function status($callback : 4D:C1709.Function)->$response
	
	This:C1470.sendRequest()
	
	If (Count parameters:C259>=1)
		
		$callback.call(This:C1470.response)
		
	Else 
		
		$response:=This:C1470.response
		
	End if 
	
Function sendRequest()
	
	var $t : Text
	var $l : Integer
	var $o : Object
	var $c : Collection
	var $error : cs:C1710.error
	
	ARRAY TEXT:C222($tTxt_headerNames; 0)
	ARRAY TEXT:C222($tTxt_headerValues; 0)
	
	If (This:C1470.url=Null:C1517)
		
		This:C1470.setURL()
		
	End if 
	
	// If (This.contentObject=Null)
	// If (This.content=Null)
	// This.content:=""
	// End if
	// Else
	// This.content:=JSON Stringify(This.contentObject)
	// End if
	
	This:C1470.response:=New object:C1471(\
		"success"; False:C215)
	
	This:C1470.request:=New object:C1471(\
		"url"; This:C1470.url+This:C1470.path; \
		"headers"; This:C1470.headers)
	
	// Manage query parameters
	//#TO_DO
	
	// Manage headers
	
	For each ($o; This:C1470.request.headers)
		
		$c:=OB Entries:C1720($o)
		APPEND TO ARRAY:C911($tTxt_headerNames; $c[0].key)
		APPEND TO ARRAY:C911($tTxt_headerValues; $c[0].value)
		
	End for each 
	
	CLEAR VARIABLE:C89($o)
	
	// Set timeout
	HTTP GET OPTION:C1159(HTTP timeout:K71:10; $l)
	HTTP SET OPTION:C1160(HTTP timeout:K71:10; This:C1470.timeout)
	
/* START TRAPPING ERRORS */$error:=cs:C1710.error.new("capture")
	This:C1470.response.code:=HTTP Request:C1158(This:C1470.method; This:C1470.request.url; ""; $o; $tTxt_headerNames; $tTxt_headerValues)
/* STOP TRAPPING ERRORS */$error.release()
	
	// Restore timeout
	HTTP SET OPTION:C1160(HTTP timeout:K71:10; $l)
	
	If ($error.lastError()#Null:C1517)
		
		This:C1470.response.httpError:=$error.lastError().error
		
	End if 
	
	If ($o=Null:C1517)
		
		This:C1470.response.success:=Choose:C955(This:C1470.response.httpError=Null:C1517; This:C1470.response.code<300; False:C215)
		
	Else 
		
		This:C1470.response.success:=Bool:C1537($o.success) | Bool:C1537($o.ok)
		
		If ($o.__ERROR#Null:C1517)
			
			This:C1470.response.success:=False:C215
			This:C1470.response.errors:=$o.__ERROR
			OB REMOVE:C1226($o; "__ERROR")
			
		End if 
		
		If ($o.__ERRORS#Null:C1517)
			
			This:C1470.response.success:=False:C215
			This:C1470.response.errors:=$o.__ERRORS
			OB REMOVE:C1226($o; "__ERRORS")
			
		End if 
		
		// Keep the headers
		For each ($t; $o)
			
			This:C1470.response[$t]:=$o[$t]
			
		End for each 
	End if 
	
	This:C1470.response.headers:=New collection:C1472
	
	ARRAY TO COLLECTION:C1563(This:C1470.response.headers; $tTxt_headerNames; "name"; $tTxt_headerValues; "value")