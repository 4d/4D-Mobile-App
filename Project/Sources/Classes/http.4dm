//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($url)
	
	If (Count parameters:C259>=1)
		
		This:C1470.reset($url)
		
	Else 
		
		This:C1470.reset()
		
	End if 
	
	var httpError : Integer
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function reset($url)
	
	If (Count parameters:C259>=1)
		
		This:C1470.setURL($url)
		
	Else 
		
		This:C1470.url:=""
		
	End if 
	
	This:C1470.success:=True:C214
	This:C1470.keepAlive:=False:C215
	This:C1470.response:=Null:C1517
	This:C1470.responseType:=0
	This:C1470.targetFile:=Null:C1517
	This:C1470.headers:=New collection:C1472
	This:C1470.errors:=New collection:C1472
	This:C1470.lastError:=""
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setURL($url)->$this : cs:C1710.http
	
	If (Count parameters:C259>=1)
		
		This:C1470.url:=$url
		
	Else 
		
		This:C1470.url:=""
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setResponseType($type : Integer; $file : 4D:C1709.file)->$this : cs:C1710.http
	
	This:C1470.responseType:=$type
	
	If ($type=Is a document:K24:1)
		
		If (Count parameters:C259>=2)
			
			If (OB Instance of:C1731($file; 4D:C1709.File))
				
				This:C1470.targetFile:=$file
				
			Else 
				
				This:C1470._pushError("The target file must be a 4D File")
				
			End if 
		End if 
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setHeaders($headers : Collection)->$this : cs:C1710.http
	
	This:C1470.success:=False:C215
	
	If (Asserted:C1132(Count parameters:C259>=1; "Missing parameters"))
		
		If (Asserted:C1132($headers.extract("name").length=$headers.extract("value").length; "Unpaired name/value keys"))
			
			This:C1470.success:=True:C214
			This:C1470.headers:=$headers
			
		End if 
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function delete($body)->$this : cs:C1710.http
	
	If (Count parameters:C259>=1)
		
		This:C1470.request(HTTP DELETE method:K71:5; $body)
		
	Else 
		
		This:C1470.request(HTTP DELETE method:K71:5)
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function head($body)->$this : cs:C1710.http
	
	If (Count parameters:C259>=1)
		
		This:C1470.request(HTTP HEAD method:K71:3; $body)
		
	Else 
		
		This:C1470.request(HTTP HEAD method:K71:3)
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function options($body)->$this : cs:C1710.http
	
	If (Count parameters:C259>=1)
		
		This:C1470.request(HTTP OPTIONS method:K71:7; $body)
		
	Else 
		
		This:C1470.request(HTTP OPTIONS method:K71:7)
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function post($body)->$this : cs:C1710.http
	
	If (Count parameters:C259>=1)
		
		This:C1470.request(HTTP POST method:K71:2; $body)
		
	Else 
		
		This:C1470.request(HTTP POST method:K71:2)
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function put($body)->$this : cs:C1710.http
	
	If (Count parameters:C259>=1)
		
		This:C1470.request(HTTP PUT method:K71:6; $body)
		
	Else 
		
		This:C1470.request(HTTP PUT method:K71:6)
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function trace($body)->$this : cs:C1710.http
	
	If (Count parameters:C259>=1)
		
		This:C1470.request(HTTP TRACE method:K71:4; $body)
		
	Else 
		
		This:C1470.request(HTTP TRACE method:K71:4)
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function get($url; $type; $keepAlive : Boolean)->$this : cs:C1710.http
	
	C_VARIANT:C1683(${4})
	
	var $onErrCallMethod; $t : Text
	var $code; $i; $indx : Integer
	var $ptr : Pointer
	var $x : Blob
	var $p : Picture
	var $params : Object
	
	This:C1470.response:=Null:C1517
	This:C1470.success:=False:C215
	
	If (Count parameters:C259>0)
		
		$params:=New object:C1471
		
		For ($i; 1; Count parameters:C259; 1)
			
			$params[String:C10($i)]:=${$i}
			
		End for 
		
		This:C1470._computeParameters($params)
		
	End if 
	
	If (Length:C16(This:C1470.url)>0)
		
		Case of 
				
				//…………………………………………………………
			: (This:C1470.responseType=Is text:K8:3)\
				 | (This:C1470.responseType=Is object:K8:27)\
				 | (This:C1470.responseType=Is collection:K8:32)
				
				$ptr:=->$t
				
				//…………………………………………………………
			: (This:C1470.responseType=Is picture:K8:10)\
				 | (This:C1470.responseType=Is a document:K24:1)
				
				$ptr:=->$x
				
				//…………………………………………………………
			Else 
				
				$ptr:=->$t
				
				//…………………………………………………………
		End case 
		
		ARRAY TEXT:C222($headerNames; 0x0000)
		ARRAY TEXT:C222($headerValues; 0x0000)
		
		If (This:C1470.headers.length>0)
			
			COLLECTION TO ARRAY:C1562(This:C1470.headers; \
				$headerNames; "name"; \
				$headerValues; "value")
			
		End if 
		
		$onErrCallMethod:=Method called on error:C704
		httpError:=0
		ON ERR CALL:C155("HTTP ERROR HANDLER")
		
		If (This:C1470.keepAlive)
			
			// Enables the keep-alive mechanism for the server connection
			$code:=HTTP Get:C1157(This:C1470.url; $ptr->; $headerNames; $headerValues; *)
			
		Else 
			
			$code:=HTTP Get:C1157(This:C1470.url; $ptr->; $headerNames; $headerValues)
			
		End if 
		
		ON ERR CALL:C155($onErrCallMethod)
		
		This:C1470.success:=($code=200) & (httpError=0)
		
		If (This:C1470.success)
			
			ARRAY TO COLLECTION:C1563(This:C1470.headers; \
				$headerNames; "name"; \
				$headerValues; "value")
			
			This:C1470._response($t; $x)
			
		Else 
			
			If (httpError#0)
				
				This:C1470._pushError(This:C1470._errorCodeMessage(httpError))
				
			Else 
				
				This:C1470._pushError(This:C1470._statusCodeMessage($code))
				
			End if 
		End if 
		
	Else 
		
		This:C1470._pushError("THE URL IS EMPTY")
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function request($method : Text; $body)->$this : cs:C1710.http
	
	var $onErrCallMethod; $t : Text
	var $code; $indx : Integer
	var $ptr : Pointer
	var $bodyƒ; $x : Blob
	var $p : Picture
	
	This:C1470.response:=Null:C1517
	This:C1470.success:=False:C215
	
	If (Length:C16(This:C1470.url)>0)
		
		Case of 
				
				//…………………………………………………………
			: (This:C1470.responseType=Is text:K8:3)\
				 | (This:C1470.responseType=Is object:K8:27)\
				 | (This:C1470.responseType=Is collection:K8:32)
				
				$ptr:=->$t
				
				//…………………………………………………………
			: (This:C1470.responseType=Is picture:K8:10)\
				 | (This:C1470.responseType=Is a document:K24:1)
				
				$ptr:=->$x
				
				//…………………………………………………………
			Else 
				
				$ptr:=->$t
				
				//…………………………………………………………
		End case 
		
		ARRAY TEXT:C222($headerNames; 0x0000)
		ARRAY TEXT:C222($headerValues; 0x0000)
		
		If (This:C1470.headers.length>0)
			
			COLLECTION TO ARRAY:C1562(This:C1470.headers; \
				$headerNames; "name"; \
				$headerValues; "value")
			
		End if 
		
		$onErrCallMethod:=Method called on error:C704
		httpError:=0
		ON ERR CALL:C155("HTTP ERROR HANDLER")
		
		If (This:C1470.keepAlive)
			
			// Enables the keep-alive mechanism for the server connection
			$code:=HTTP Request:C1158($method; This:C1470.url; $bodyƒ; $ptr->; $headerNames; $headerValues; *)
			
		Else 
			
			$code:=HTTP Request:C1158($method; This:C1470.url; $bodyƒ; $ptr->; $headerNames; $headerValues)
			
		End if 
		
		ON ERR CALL:C155($onErrCallMethod)
		
		This:C1470.success:=($code=200) & (httpError=0)
		
		If (This:C1470.success)
			
			ARRAY TO COLLECTION:C1563(This:C1470.headers; \
				$headerNames; "name"; \
				$headerValues; "value")
			
			If ($method#HTTP HEAD method:K71:3)
				
				This:C1470._response($t; $x)
				
			End if 
			
		Else 
			
			If (httpError#0)
				
				This:C1470._pushError(This:C1470._errorCodeMessage(httpError))
				
			Else 
				
				This:C1470._pushError(This:C1470._statusCodeMessage($code))
				
			End if 
		End if 
		
	Else 
		
		This:C1470._pushError("THE URL IS EMPTY")
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function decodeDateTime($dateTime : Text)
	
	var $date : Date
	var $day; $month; $year : Integer
	var $time : Time
	
	ARRAY LONGINT:C221($pos; 0x0000)
	ARRAY LONGINT:C221($len; 0x0000)
	
	If (Match regex:C1019("(?m-si)(\\d{2})\\s([^\\s]*)\\s(\\d{4})\\s(\\d{2}(?::\\d{2}){2})"; $dateTime; 1; $pos; $len))
		
		
		$day:=Num:C11(Substring:C12($dateTime; $pos{1}; $len{1}))
		$month:=New collection:C1472(""; "jan"; "feb"; "mar"; "apr"; "may"; "jun"; "jul"; "aug"; "sep"; "oct"; "nov"; "dec").indexOf(Substring:C12($dateTime; $pos{2}; $len{2}))
		$year:=Num:C11(Substring:C12($dateTime; $pos{3}; $len{3}))
		
		$date:=Add to date:C393(!00-00-00!; $year; $month; $day)
		$time:=Time:C179(Substring:C12($dateTime; $pos{4}; $len{4}))
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function myIP()->$IP : Text
	
	var $onErrCallMethod; $t : Text
	var $code : Integer
	
	$onErrCallMethod:=Method called on error:C704
	httpError:=0
	ON ERR CALL:C155("HTTP ERROR HANDLER")
	$code:=HTTP Get:C1157("http://api.ipify.org"; $t)
	ON ERR CALL:C155($onErrCallMethod)
	
	This:C1470.success:=($code=200) & (httpError=0)
	
	If (This:C1470.success)
		
		$IP:=$t
		
	Else 
		
		If (httpError#0)
			
			This:C1470.errors.push(This:C1470._errorCodeMessage(httpError))
			
		Else 
			
			This:C1470.errors.push(This:C1470._statusCodeMessage($code))
			
		End if 
		
		This:C1470.lastError:=This:C1470.errors[This:C1470.errors.length-1]
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _response($text : Text; $blob : Blob)
	
	var $o : Object
	var $p : Picture
	
	Case of 
			
			//…………………………………………………………
		: (This:C1470.responseType=Is object:K8:27)
			
			This:C1470.response:=JSON Parse:C1218($text; Is object:K8:27)
			
			//…………………………………………………………
		: (This:C1470.responseType=Is collection:K8:32)
			
			This:C1470.response:=JSON Parse:C1218($text; Is collection:K8:32)
			
			//…………………………………………………………
		: (This:C1470.responseType=Is picture:K8:10)
			
			$o:=This:C1470.headers.query("name = 'Content-Type'").pop()
			
			If ($o#Null:C1517)
				
				BLOB TO PICTURE:C682($blob; $p; $o.value)
				
			Else 
				
				BLOB TO PICTURE:C682($blob; $p)
				
			End if 
			
			This:C1470.response:=$p
			
			//…………………………………………………………
		: (This:C1470.responseType=Is a document:K24:1)
			
			If (This:C1470.targetFile#Null:C1517)
				
				$o:=This:C1470.headers.query("name = 'Content-Type'").pop()
				
				Case of 
						
						//______________________________________________________
					: ($o=Null:C1517)
						
						This:C1470.targetFile.setContent($blob)
						
						//______________________________________________________
					: ($o.value="image@")  // #Is it necessary?
						
						CREATE FOLDER:C475(This:C1470.targetFile.platformPath; *)
						BLOB TO PICTURE:C682($blob; $p)
						WRITE PICTURE FILE:C680(This:C1470.targetFile.platformPath; $p)
						
						//______________________________________________________
					Else 
						
						This:C1470.targetFile.setContent($blob)
						
						//______________________________________________________
				End case 
				
			Else 
				
				This:C1470._pushError("Missing target file")
				
			End if 
			
			//…………………………………………………………
		Else 
			
			This:C1470.response:=$text
			
			//…………………………………………………………
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _computeParameters($params)
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)
			
			// <NOTHING MORE TO DO>
			
			//______________________________________________________
		: (Value type:C1509($params["1"])=Is text:K8:3)  // Url {type {keepAlive}} | {keepAlive}
			
			This:C1470.url:=$params["1"]
			
			Case of 
					
					//______________________________________________________
				: (Count parameters:C259=1)
					
					// <NOTHING MORE TO DO>
					
					//______________________________________________________
				: (Value type:C1509($params["2"])=Is boolean:K8:9)  // Keep-alive
					
					This:C1470.keepAlive:=$params["2"]
					
					//______________________________________________________
				: (Value type:C1509($params["2"])=Is real:K8:4)\
					 | (Value type:C1509($params["2"])=Is longint:K8:6)
					
					This:C1470.responseType:=$params["2"]
					
					If (Count parameters:C259>=3)
						
						This:C1470.keepAlive:=$params["3"]
						
					End if 
					
					//______________________________________________________
			End case 
			
			//______________________________________________________
		: (Value type:C1509($params["1"])=Is real:K8:4)\
			 | (Value type:C1509($params["1"])=Is longint:K8:6)  // type {keepAlive}
			
			This:C1470.responseType:=Num:C11($params["1"])
			
			If (Count parameters:C259>=2)
				
				This:C1470.keepAlive:=Bool:C1537($params["2"])
				
			End if 
			
			//______________________________________________________
		: (Value type:C1509($params["1"])=Is boolean:K8:9)  // Keep-alive
			
			This:C1470.keepAlive:=$params["1"]
			
			//______________________________________________________
		Else 
			
			// #ERROR
			
			//______________________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _errorCodeMessage($errorCode : Integer)->$message : Text
	
	If (This:C1470.errorMessages=Null:C1517)  // First call
		
		This:C1470.errorMessages:=New collection:C1472
		
		This:C1470.errorMessages[2]:="HTTP server not reachable"
		This:C1470.errorMessages[17]:="HTTP server not reachable (timeout?)"
		This:C1470.errorMessages[30]:="HTTP server not reachable"
		
	End if 
	
	If (Count parameters:C259>=1)
		
		If ($errorCode<This:C1470.errorMessages.length)
			
			$message:=String:C10(This:C1470.errorMessages[$errorCode])
			
		End if 
		
		If (Length:C16($message)=0)\
			 | ($message="null")
			
			$message:="HTTP error: "+String:C10($errorCode)
			
		Else 
			
			$message:=$message+" ("+String:C10($errorCode)+")"
			
		End if 
		
	Else 
		
		$message:="Unknow error code"
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _statusCodeMessage($statusCode : Integer)->$message : Text
	
	If (This:C1470.statusMessages=Null:C1517)  // First call
		
		This:C1470.statusMessages:=New collection:C1472
		
		// 1xx Informational response
		
		// 2xx Successful
		This:C1470.statusMessages[200]:="OK"
		This:C1470.statusMessages[201]:="Created"
		This:C1470.statusMessages[202]:="Accepted"
		This:C1470.statusMessages[203]:="Non-Authoritative Information"
		This:C1470.statusMessages[204]:="No Content"
		This:C1470.statusMessages[205]:="Reset Content"
		This:C1470.statusMessages[206]:="Partial Content"
		This:C1470.statusMessages[207]:="Multi-Status"
		This:C1470.statusMessages[208]:="Already Reported"
		
		This:C1470.statusMessages[226]:="IM Used"
		
		// 3xx Redirection
		
		// 4xx Client errors
		This:C1470.statusMessages[400]:="Bad Request"
		This:C1470.statusMessages[401]:="Unauthorized"
		This:C1470.statusMessages[402]:="Payment Required"
		This:C1470.statusMessages[403]:="Forbidden"
		This:C1470.statusMessages[404]:="Not Found"
		This:C1470.statusMessages[405]:="Method Not Allowed"
		This:C1470.statusMessages[406]:="Not Acceptable"
		This:C1470.statusMessages[407]:="Proxy Authentication Required"
		This:C1470.statusMessages[408]:="Request Timeout"
		This:C1470.statusMessages[409]:="Conflict"
		This:C1470.statusMessages[410]:="Gone"
		This:C1470.statusMessages[411]:="Length Required"
		This:C1470.statusMessages[412]:="Precondition Failed"
		This:C1470.statusMessages[413]:="Payload Too Large"
		This:C1470.statusMessages[414]:="URI Too Long"
		This:C1470.statusMessages[415]:="Unsupported Media Type"
		This:C1470.statusMessages[416]:="Range Not Satisfiable"
		This:C1470.statusMessages[417]:="Expectation Failed"
		This:C1470.statusMessages[418]:="I'm a teapot ;-)"
		
		This:C1470.statusMessages[421]:="Misdirected Request"
		This:C1470.statusMessages[422]:="Unprocessable Entity"
		This:C1470.statusMessages[423]:="Locked"
		This:C1470.statusMessages[424]:="Method failure"
		This:C1470.statusMessages[425]:="Unordered Collection"
		This:C1470.statusMessages[426]:="Upgrade Required"
		
		This:C1470.statusMessages[428]:="Precondition Required"
		This:C1470.statusMessages[429]:="Too Many Requests"
		
		This:C1470.statusMessages[431]:="Request Header Fields Too Large"
		
		This:C1470.statusMessages[440]:="Login Time-out"
		
		This:C1470.statusMessages[449]:="Retry With"
		This:C1470.statusMessages[450]:="Blocked by Windows Parental Controls"
		
		This:C1470.statusMessages[451]:="Unavailable For Legal Reasons"
		
		This:C1470.statusMessages[456]:="Unrecoverable Error"
		
		// 5xx Server errors
		This:C1470.statusMessages[500]:="Internal Server Error"
		This:C1470.statusMessages[501]:="Not Implemented"
		This:C1470.statusMessages[502]:="Bad Gateway"
		This:C1470.statusMessages[503]:="Service Unavailable"
		This:C1470.statusMessages[504]:="Gateway Timeout"
		This:C1470.statusMessages[505]:="HTTP Version Not Supported"
		This:C1470.statusMessages[506]:="Variant Also Negotiates"
		This:C1470.statusMessages[507]:="Insufficient Storage"
		This:C1470.statusMessages[508]:="Loop Detected"
		
		This:C1470.statusMessages[510]:="Not Extended"
		This:C1470.statusMessages[511]:="Network Authentication Required"
		
	End if 
	
	If (Count parameters:C259>=1)
		
		If ($statusCode<This:C1470.statusMessages.length)
			
			$message:=String:C10(This:C1470.statusMessages[$statusCode])
			
		End if 
		
		If (Length:C16($message)=0)\
			 | ($message="null")
			
			$message:="Unknow status code: "+String:C10($statusCode)
			
		Else 
			
			$message:=$message+" ("+String:C10($statusCode)+")"
			
		End if 
		
	Else 
		
		$message:="Unknow status code"
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _pushError($error : Text)
	
	This:C1470.success:=False:C215
	This:C1470.lastError:=Get call chain:C1662[1].name+" - "+$error
	This:C1470.errors.push(This:C1470.lastError)