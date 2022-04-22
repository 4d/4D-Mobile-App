//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($url)
	
	This:C1470.onErrorCallMethod:=Formula:C1597(noError).source
	This:C1470._trials:=0
	
	If (Count parameters:C259>=1)
		
		This:C1470.reset($url)
		
	Else 
		
		This:C1470.reset()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function reset($url)
	
	If (Count parameters:C259>=1)
		
		This:C1470.setURL($url)
		
	Else 
		
		This:C1470.url:=""
		
	End if 
	
	This:C1470.status:=0
	This:C1470.keepAlive:=False:C215
	This:C1470.timeout:=120  // Default value = 120 secondes
	This:C1470.followRedirect:=True:C214
	This:C1470.AllowCompression:=True:C214
	This:C1470.AllowDisplayAuthDial:=False:C215
	This:C1470.response:=Null:C1517
	This:C1470.responseType:=0
	This:C1470.targetFile:=Null:C1517
	This:C1470.headers:=New collection:C1472
	This:C1470.errors:=New collection:C1472
	This:C1470.lastError:=""
	This:C1470.maxRedirect:=2  // Default value
	This:C1470.success:=True:C214  //This.isInternetAvailable()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function get timeout() : Integer
	
	var $value : Integer
	
	HTTP GET OPTION:C1159(HTTP timeout:K71:10; $value)
	return ($value)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function set timeout($value)
	
	// Keep the current value
	This:C1470._timeout:=This:C1470._timeout || This:C1470.timeout
	
	Case of 
			
			//______________________________________________________
		: (String:C10($value)="default")
			
			$value:=120
			
			//______________________________________________________
		: (String:C10($value)="reset")
			
			$value:=This:C1470._timeout
			
			//______________________________________________________
		Else 
			
			$value:=Num:C11($value)
			
			//______________________________________________________
	End case 
	
	HTTP SET OPTION:C1160(HTTP timeout:K71:10; $value)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// To set the display of the authentication dialog box
Function displayAuthDial($allow : Boolean)
	
	This:C1470.AllowDisplayAuthDial:=$allow
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// To set the HTTP client timeout
Function setTimeout($delay : Integer)
	
	This:C1470.timeout:=$delay
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// To set the compression mechanism intended to accelerate exchange
Function setCompression($allow : Boolean)
	
	This:C1470.AllowCompression:=$allow
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// To set the maximum number of redirections accepted
Function setMaxRedirect($allow : Integer)
	
	This:C1470.followRedirect:=($allow>0)
	This:C1470.maxRedirect:=$allow
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// To set the URL
Function setURL($url)->$this : cs:C1710.http
	
	If (Count parameters:C259>=1)
		
		This:C1470.url:=$url
		
	Else 
		
		This:C1470.url:=""
		
	End if 
	
	This:C1470._trials:=0
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// To set the response type
Function setResponseType($type : Integer; $file : 4D:C1709.File)->$this : cs:C1710.http
	
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
	// To set the headers of the requête. must be a collection of name/value pairs
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
	// Test if the server is reachable
Function ping($url : Text)->$reachable : Boolean
	
	var $onErrCallMethod; $body; $response : Text
	var $code; $len; $pos : Integer
	
	ARRAY TEXT:C222($headerNames; 0x0000)
	ARRAY TEXT:C222($headerValues; 0x0000)
	
	$onErrCallMethod:=Method called on error:C704
	CLEAR VARIABLE:C89(ERROR)
	ON ERR CALL:C155(This:C1470.onErrorCallMethod)
	
	If (Count parameters:C259>=1)
		
		This:C1470.status:=HTTP Request:C1158(HTTP OPTIONS method:K71:7; $url; $body; $response; $headerNames; $headerValues)
		
	Else 
		
		If (Match regex:C1019("(?m-si)(https?://[^/]*/)"; This:C1470.url; 1; $pos; $len))
			
			This:C1470.status:=HTTP Request:C1158(HTTP OPTIONS method:K71:7; Substring:C12(This:C1470.url; $pos; $len)+"*"; $body; $response; $headerNames; $headerValues)
			
		End if 
	End if 
	
	ON ERR CALL:C155($onErrCallMethod)
	
	This:C1470.success:=(This:C1470.status=200) & (ERROR=0)
	
	If (This:C1470.success)
		
		$reachable:=True:C214
		
	Else 
		
		This:C1470._decodeError()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the methods allowed on the server
Function allow($url : Text)->$allowed : Collection
	
	var $onErrCallMethod; $body; $response : Text
	var $code; $len; $pos : Integer
	var $headers : Collection
	var $o : Object
	
	ARRAY TEXT:C222($headerNames; 0x0000)
	ARRAY TEXT:C222($headerValues; 0x0000)
	
	$onErrCallMethod:=Method called on error:C704
	CLEAR VARIABLE:C89(ERROR)
	ON ERR CALL:C155(This:C1470.onErrorCallMethod)
	
	If (Count parameters:C259>=1)
		
		This:C1470.status:=HTTP Request:C1158(HTTP OPTIONS method:K71:7; $url; $body; $response; $headerNames; $headerValues)
		
	Else 
		
		If (Match regex:C1019("(?m-si)(https?://[^/]*/)"; This:C1470.url; 1; $pos; $len))
			
			This:C1470.status:=HTTP Request:C1158(HTTP OPTIONS method:K71:7; Substring:C12(This:C1470.url; $pos; $len)+"*"; $body; $response; $headerNames; $headerValues)
			
		End if 
	End if 
	
	ON ERR CALL:C155($onErrCallMethod)
	
	This:C1470.success:=(This:C1470.status=200) & (ERROR=0)
	
	If (This:C1470.success)
		
		$headers:=New collection:C1472
		ARRAY TO COLLECTION:C1563($headers; \
			$headerNames; "name"; \
			$headerValues; "value")
		
		$o:=$headers.query("name = 'Allow'").pop()
		
		If ($o#Null:C1517)
			
			$allowed:=Split string:C1554($o.value; ",")
			
		End if 
		
	Else 
		
		This:C1470._decodeError()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// DELETE method
Function delete($body)->$this : cs:C1710.http
	
	If (Count parameters:C259>=1)
		
		This:C1470.request(HTTP DELETE method:K71:5; $body)
		
	Else 
		
		This:C1470.request(HTTP DELETE method:K71:5)
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// HEAD method
Function head($body)->$this : cs:C1710.http
	
	If (Count parameters:C259>=1)
		
		This:C1470.request(HTTP HEAD method:K71:3; $body)
		
	Else 
		
		This:C1470.request(HTTP HEAD method:K71:3)
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// OPTIONS method
Function options($body)->$this : cs:C1710.http
	
	If (Count parameters:C259>=1)
		
		This:C1470.request(HTTP OPTIONS method:K71:7; $body)
		
	Else 
		
		This:C1470.request(HTTP OPTIONS method:K71:7)
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// POST method
Function post($body)->$this : cs:C1710.http
	
	If (Count parameters:C259>=1)
		
		This:C1470.request(HTTP POST method:K71:2; $body)
		
	Else 
		
		This:C1470.request(HTTP POST method:K71:2)
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// PUT method
Function put($body)->$this : cs:C1710.http
	
	If (Count parameters:C259>=1)
		
		This:C1470.request(HTTP PUT method:K71:6; $body)
		
	Else 
		
		This:C1470.request(HTTP PUT method:K71:6)
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// TRACE method
Function trace($body)->$this : cs:C1710.http
	
	If (Count parameters:C259>=1)
		
		This:C1470.request(HTTP TRACE method:K71:4; $body)
		
	Else 
		
		This:C1470.request(HTTP TRACE method:K71:4)
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// GET method
Function get()->$this : cs:C1710.http
	
	C_VARIANT:C1683(${1})
	
	var $onErrCallMethod; $t : Text
	var $i; $indx : Integer
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
		
		This:C1470._setOptions()
		
		$onErrCallMethod:=Method called on error:C704
		CLEAR VARIABLE:C89(ERROR)
		ON ERR CALL:C155(This:C1470.onErrorCallMethod)
		
		If (This:C1470.keepAlive)
			
			// Enables the keep-alive mechanism for the server connection
			This:C1470.status:=HTTP Get:C1157(This:C1470.url; $ptr->; $headerNames; $headerValues; *)
			
		Else 
			
			This:C1470.status:=HTTP Get:C1157(This:C1470.url; $ptr->; $headerNames; $headerValues)
			
		End if 
		
		ON ERR CALL:C155($onErrCallMethod)
		
		This:C1470.success:=(This:C1470.status=200) & (ERROR=0)
		
		Case of 
				
				//______________________________________________________
			: (This:C1470.success)
				
				ARRAY TO COLLECTION:C1563(This:C1470.headers; \
					$headerNames; "name"; \
					$headerValues; "value")
				
				This:C1470._response($t; $x)
				
				//______________________________________________________
			: (This:C1470.status=302) & (This:C1470._trials<3)  // Redirection
				
				$indx:=Find in array:C230($headerNames; "location")
				
				If ($indx>0)
					
					// Get the redirected url & retry
					This:C1470.url:=$headerValues{$indx}
					
					This:C1470._trials:=This:C1470._trials+1
					This:C1470.get()
					
				End if 
				
				//______________________________________________________
			Else 
				
				This:C1470._decodeError()
				
				//______________________________________________________
		End case 
		
	Else 
		
		This:C1470._pushError("THE URL IS EMPTY")
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function request($method : Text; $body)->$this : cs:C1710.http
	
	var $onErrCallMethod; $t : Text
	var $indx : Integer
	var $ptr : Pointer
	var $x : Blob
	var $bodyƒ : Variant
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
		
		If (Count parameters:C259>=2)
			
			$bodyƒ:=$body
			
		Else 
			
			$bodyƒ:=""
			
		End if 
		
		This:C1470._setOptions()
		
		$onErrCallMethod:=Method called on error:C704
		CLEAR VARIABLE:C89(ERROR)
		ON ERR CALL:C155(This:C1470.onErrorCallMethod)
		
		If (This:C1470.keepAlive)
			
			// Enables the keep-alive mechanism for the server connection
			This:C1470.status:=HTTP Request:C1158($method; This:C1470.url; $bodyƒ; $ptr->; $headerNames; $headerValues; *)
			
		Else 
			
			This:C1470.status:=HTTP Request:C1158($method; This:C1470.url; $bodyƒ; $ptr->; $headerNames; $headerValues)
			
		End if 
		
		ON ERR CALL:C155($onErrCallMethod)
		
		This:C1470.success:=(This:C1470.status=200) & (ERROR=0)
		
		If (This:C1470.success)
			
			ARRAY TO COLLECTION:C1563(This:C1470.headers; \
				$headerNames; "name"; \
				$headerValues; "value")
			
			If ($method#HTTP HEAD method:K71:3)
				
				This:C1470._response($t; $x)
				
			End if 
			
		Else 
			
			This:C1470._decodeError()
			
		End if 
		
	Else 
		
		This:C1470._pushError("THE URL IS EMPTY")
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Test if a newer version of a resource is available
Function newerRelease($ETag : Text; $lastModified : Text)->$newer : Boolean
	
	// Keep current headers
	var $headers : Collection
	$headers:=This:C1470.headers.copy()
	
	This:C1470.timeout:=30
	This:C1470.request(HTTP HEAD method:K71:3)
	This:C1470.timeout:="reset"
	
	If (This:C1470.success)
		
		// The ETag HTTP response header is an identifier for a specific version of a
		// Resource. It lets caches be more efficient and save bandwidth, as a web server
		// Does not need to resend a full response if the content has not changed.
		
		var $o : Object
		$o:=This:C1470.headers.query("name = 'ETag'").pop()
		
		If ($o#Null:C1517)
			
			$newer:=(String:C10($o.value)#$ETag)
			
		End if 
		
		If (Not:C34($newer))\
			 & (Count parameters:C259>=2)  // ⚠️ Don't pass the second parameter to ignore the fallback
			
			// The Last-Modified response HTTP header contains the date and time at which the
			// Origin server believes the resource was last modified. It is used as a validator
			// To determine if a resource received or stored is the same.
			// Less accurate than an ETag header, it is a fallback mechanism.
			
			$o:=This:C1470.headers.query("name = 'Last-Modified'").pop()
			
			If ($o#Null:C1517)
				
				var $server; $local : Object
				$server:=This:C1470.decodeDateTime(String:C10($o.value))
				$local:=This:C1470.decodeDateTime($lastModified)
				
				$newer:=($server.date>$local.date) | (($server.date=$local.date) & ($server.time>$local.time))
				
			End if 
		End if 
	End if 
	
	// Keep response headers & restore prious ones
	This:C1470.responseHeaders:=This:C1470.headers.copy()
	This:C1470.headers:=$headers
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Convert a date-time string (<day-name>, <day> <month> <year> <hour>:<minute>:<second> GMT) as object
Function decodeDateTime($dateTimeString : Text)->$dateTime : Object
	
	ARRAY LONGINT:C221($pos; 0x0000)
	ARRAY LONGINT:C221($len; 0x0000)
	
	$dateTime:=New object:C1471(\
		"date"; !00-00-00!; \
		"time"; ?00:00:00?)
	
	If (Match regex:C1019("(?m-si)(\\d{2})\\s([^\\s]*)\\s(\\d{4})\\s(\\d{2}(?::\\d{2}){2})"; $dateTimeString; 1; $pos; $len))
		
		$dateTime.date:=Add to date:C393(!00-00-00!; \
			Num:C11(Substring:C12($dateTimeString; $pos{3}; $len{3})); \
			New collection:C1472(""; "jan"; "feb"; "mar"; "apr"; "may"; "jun"; "jul"; "aug"; "sep"; "oct"; "nov"; "dec").indexOf(Substring:C12($dateTimeString; $pos{2}; $len{2})); \
			Num:C11(Substring:C12($dateTimeString; $pos{1}; $len{1})))
		
		$dateTime.time:=Time:C179(Substring:C12($dateTimeString; $pos{4}; $len{4}))
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if internet access is available
Function isInternetAvailable()->$available : Boolean
	
	$available:=(Length:C16(This:C1470.myIP())>0)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns public IP
Function myIP()->$IP : Text
	
	var $onErrCallMethod; $t : Text
	var $code : Integer
	
	$onErrCallMethod:=Method called on error:C704
	CLEAR VARIABLE:C89(ERROR)
	ON ERR CALL:C155(This:C1470.onErrorCallMethod)
	This:C1470.status:=HTTP Get:C1157("http://api.ipify.org"; $t)
	ON ERR CALL:C155($onErrCallMethod)
	
	This:C1470.success:=(This:C1470.status=200) & (ERROR=0)
	
	If (This:C1470.success)
		
		$IP:=$t
		
	Else 
		
		This:C1470._decodeError()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Converts a string IP address into its integer equivalent
Function ipToInteger($IP : Text)->$result : Integer
	
	var $t : Text
	
	$result:=0
	
	For each ($t; Split string:C1554($IP; "."))
		
		$result:=$result << 8+Num:C11($t)
		
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _setOptions()
	
	HTTP SET OPTION:C1160(HTTP follow redirect:K71:11; Num:C11(This:C1470.followRedirect))
	HTTP SET OPTION:C1160(HTTP max redirect:K71:12; Num:C11(This:C1470.maxRedirect))
	HTTP SET OPTION:C1160(HTTP compression:K71:15; Num:C11(This:C1470.AllowCompression))
	HTTP SET OPTION:C1160(HTTP timeout:K71:10; Num:C11(This:C1470.timeout))
	HTTP SET OPTION:C1160(HTTP display auth dial:K71:13; Num:C11(This:C1470.AllowDisplayAuthDial))
	
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
	
	var $errorMessages : Collection
	$errorMessages:=New collection:C1472
	
	$errorMessages[2]:="HTTP server not reachable"
	$errorMessages[17]:="HTTP server not reachable (timeout?)"
	$errorMessages[30]:="HTTP server not reachable"
	
	
	If (Count parameters:C259>=1)
		
		If ($errorCode>=0)\
			 & ($errorCode<$errorMessages.length)
			
			$message:=String:C10($errorMessages[$errorCode])
			
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
	
	var $statusMessages : Collection
	$statusMessages:=New collection:C1472
	
	// 1xx Informational response
	
	// 2xx Successful
	$statusMessages[200]:="OK"
	$statusMessages[201]:="Created"
	$statusMessages[202]:="Accepted"
	$statusMessages[203]:="Non-Authoritative Information"
	$statusMessages[204]:="No Content"
	$statusMessages[205]:="Reset Content"
	$statusMessages[206]:="Partial Content"
	$statusMessages[207]:="Multi-Status"
	$statusMessages[208]:="Already Reported"
	
	$statusMessages[226]:="IM Used"
	
	// 3xx Redirection
	$statusMessages[302]:="Too many redirections"
	
	// 4xx Client errors
	$statusMessages[400]:="Bad Request"
	$statusMessages[401]:="Unauthorized"
	$statusMessages[402]:="Payment Required"
	$statusMessages[403]:="Forbidden"
	$statusMessages[404]:="Not Found"
	$statusMessages[405]:="Method Not Allowed"
	$statusMessages[406]:="Not Acceptable"
	$statusMessages[407]:="Proxy Authentication Required"
	$statusMessages[408]:="Request Timeout"
	$statusMessages[409]:="Conflict"
	$statusMessages[410]:="Gone"
	$statusMessages[411]:="Length Required"
	$statusMessages[412]:="Precondition Failed"
	$statusMessages[413]:="Payload Too Large"
	$statusMessages[414]:="URI Too Long"
	$statusMessages[415]:="Unsupported Media Type"
	$statusMessages[416]:="Range Not Satisfiable"
	$statusMessages[417]:="Expectation Failed"
	$statusMessages[418]:="I'm a teapot ;-)"
	
	$statusMessages[421]:="Misdirected Request"
	$statusMessages[422]:="Unprocessable Entity"
	$statusMessages[423]:="Locked"
	$statusMessages[424]:="Method failure"
	$statusMessages[425]:="Unordered Collection"
	$statusMessages[426]:="Upgrade Required"
	
	$statusMessages[428]:="Precondition Required"
	$statusMessages[429]:="Too Many Requests"
	
	$statusMessages[431]:="Request Header Fields Too Large"
	
	$statusMessages[440]:="Login Time-out"
	
	$statusMessages[449]:="Retry With"
	$statusMessages[450]:="Blocked by Windows Parental Controls"
	
	$statusMessages[451]:="Unavailable For Legal Reasons"
	
	$statusMessages[456]:="Unrecoverable Error"
	
	// 5xx Server errors
	$statusMessages[500]:="Internal Server Error"
	$statusMessages[501]:="Not Implemented"
	$statusMessages[502]:="Bad Gateway"
	$statusMessages[503]:="Service Unavailable"
	$statusMessages[504]:="Gateway Timeout"
	$statusMessages[505]:="HTTP Version Not Supported"
	$statusMessages[506]:="Variant Also Negotiates"
	$statusMessages[507]:="Insufficient Storage"
	$statusMessages[508]:="Loop Detected"
	
	$statusMessages[510]:="Not Extended"
	$statusMessages[511]:="Network Authentication Required"
	
	If (Count parameters:C259>=1)
		
		If ($statusCode<$statusMessages.length)
			
			$message:=String:C10($statusMessages[$statusCode])
			
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
Function _decodeError()
	
	If (ERROR#0)
		
		This:C1470._pushError(This:C1470._errorCodeMessage(ERROR))
		
	Else 
		
		This:C1470._pushError(This:C1470._statusCodeMessage(This:C1470.status))
		
	End if 
	
	This:C1470.lastError:=This:C1470.errors[This:C1470.errors.length-1]
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _pushError($error : Text)
	var $c : Collection
	
	$c:=Get call chain:C1662
	
	This:C1470.success:=False:C215
	This:C1470.lastError:=Choose:C955($c.length>3; $c[2].name; $c[1].name)+"() - "+$error
	This:C1470.errors.push(This:C1470.lastError)