//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : Rest
// ID[D5FB3A273A2843E891119B6D8CABB97C]
// Created 27-6-2017 by Eric Marchand
// ----------------------------------------------------
// Description:
// Get rest info
// ----------------------------------------------------
// #THREAD-SAFE
// ----------------------------------------------------
// Declarations
#DECLARE($in : Object)->$out : Object

If (False:C215)
	C_OBJECT:C1216(Rest; $0)
	C_OBJECT:C1216(Rest; $1)
End if 

var $query; $queryValue : Text
var $caller; $i; $port; $timeout : Integer
var $x : Blob
var $in; $out; $requestResult; $webServerInfos : Object
var $requestResultAsBlob : Blob
var $requestResultAsText : Text
var $error : cs:C1710.error

ARRAY TEXT:C222($headerNames; 0)
ARRAY TEXT:C222($headerValues; 0)
ARRAY TEXT:C222($properties; 0)

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	$out:=New object:C1471(\
		"success"; False:C215)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($in.action=Null:C1517)
		
		ASSERT:C1129(False:C215)
		
		// MARK:- devurl
	: ($in.action="devurl")
		
		$webServerInfos:=WEB Get server info:C1531
		
/*
WARNING: "localhost" may not find the server if the computer is connected to a network.
127.0.0.1, on the other hand, will connect directly without going out to the network.
*/
		
		Case of 
				
				//________________________________________
			: (Bool:C1537($webServerInfos.security.HTTPEnabled))  // Priority for http
				
				$out.url:="http://127.0.0.1:"+String:C10($webServerInfos.options.webPortID)
				
				//________________________________________
			: (Bool:C1537($webServerInfos.security.HTTPSEnabled))  // Only https, use it
				
				$out.url:="https://127.0.0.1:"+String:C10($webServerInfos.options.webHTTPSPortID)
				
				//________________________________________
			Else 
				
				$out.url:="http://127.0.0.1:"+String:C10($webServerInfos.options.webPortID)
				
				//________________________________________
		End case 
		
		If ($in.handler=Null:C1517)
			
			$in.handler:="mobileapp"
			
		End if 
		
		$out.url:=$out.url+"/"+$in.handler+"/"
		$out.success:=True:C214
		
		// MARK:- url
	: ($in.action="url")
		
		If (Length:C16(String:C10($in.url))=0)
			
			$out:=Rest(New object:C1471(\
				"action"; "devurl"; "handler"; $in.handler))
			
		Else 
			
			// Add missing / if necessary
			$out.url:=$in.url
			
			If (Substring:C12($out.url; Length:C16($out.url))#"/")
				
				$out.url:=$out.url+"/"
				
			End if 
			
			// Add missing handler if needed
			If ($in.handler=Null:C1517)
				
				$in.handler:="mobileapp"
				
			End if 
			
			If (Not:C34(Match regex:C1019($in.handler+"/$"; $out.url; 1)))
				
				$out.url:=$out.url+$in.handler+"/"
				
			End if 
			
			$out.success:=True:C214
			
/*
WARNING: "localhost" may not find the server if the computer is connected to a network.
127.0.0.1, on the other hand, will connect directly without going out to the network.
*/
			
			$out.url:=Replace string:C233($out.url; "localhost"; "127.0.0.1")
			
		End if 
		
		// MARK:- request
	: ($in.action="request")
		
		$in.action:="url"
		$out:=Rest($in)  // Get & format url, devurl if not in param
		
		If ($out.success)
			
			If ($in.method=Null:C1517)
				
				$in.method:=HTTP GET method:K71:1
				
			End if 
			
			If ($in.path=Null:C1517)
				
				$in.path:=""
				
			End if 
			
			If ($in.contentObject=Null:C1517)
				
				If ($in.content=Null:C1517)
					
					$in.content:=""
					
				End if 
				
			Else 
				
				$in.content:=JSON Stringify:C1217($in.contentObject)
				
			End if 
			
			$out.url:=$out.url+$in.path
			
			// Manage query parameters
			If ($in.query#Null:C1517)
				
				OB GET PROPERTY NAMES:C1232($in.query; $properties)  //;$tLon_types)
				
				For ($i; 1; Size of array:C274($properties); 1)
					
					$queryValue:=$in.query[$properties{$i}]
					
					If ($i#1)
						
						$query:=$query+"&"
						
					End if 
					
					If (Bool:C1537($in.queryEncode))
						
						// Encode value
						If ((Position:C15("\""; $queryValue)>0)\
							 & (Position:C15("'"; $queryValue)=0))
							
							$query:=$query+$properties{$i}+"='"+str_URLEncode($queryValue)+"'"  // Use ' if filter contains = and no '
							
						Else 
							
							$query:=$query+$properties{$i}+"=\""+str_URLEncode($queryValue)+"\""
							
						End if 
						
					Else 
						
						$query:=$query+$properties{$i}+"=\""+$queryValue+"\""
						
					End if 
				End for 
				
				$out.url:=Choose:C955(Position:C15("?"; $out.url)>0; $out.url+"&"+$query; $out.url+"?"+$query)
				
			End if 
			
			// Manage headers
			If ($in.headers=Null:C1517)
				
				$in.headers:=New object:C1471(\
					)
				
			End if 
			
			OB GET PROPERTY NAMES:C1232($in.headers; $headerNames)
			ARRAY TEXT:C222($headerValues; Size of array:C274($headerNames))
			
			For ($i; 1; Size of array:C274($headerNames); 1)
				
				$headerValues{$i}:=OB Get:C1224($in.headers; $headerNames{$i})
				
			End for 
			
			HTTP GET OPTION:C1159(HTTP timeout:K71:10; $timeout)
			
			If (Num:C11($in.timeout)#0)
				
				HTTP SET OPTION:C1160(HTTP timeout:K71:10; $in.timeout)
				
			End if 
			
/* START TRAPPING ERRORS */$error:=cs:C1710.error.new("capture")
			
			Case of 
					
					//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
				: (Num:C11($in.reponseType)=Is BLOB:K8:12)
					
					$out.code:=HTTP Request:C1158($in.method; $out.url; ($in.content); $requestResultAsBlob; $headerNames; $headerValues)
					
					//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
				: (Num:C11($in.reponseType)=Is text:K8:3)
					
					$out.code:=HTTP Request:C1158($in.method; $out.url; ($in.content); $requestResultAsText; $headerNames; $headerValues)
					
					//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
				Else 
					
					$out.code:=HTTP Request:C1158($in.method; $out.url; ($in.content); $requestResult; $headerNames; $headerValues)
					
					//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			End case 
			
/* STOP TRAPPING ERRORS */$error.release()
			
			HTTP SET OPTION:C1160(HTTP timeout:K71:10; $timeout)
			
			Case of 
					
					//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
				: (Num:C11($in.reponseType)=Is BLOB:K8:12)
					
					$out.response:=$requestResultAsBlob
					
					//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
				: (Num:C11($in.reponseType)=Is text:K8:3)
					
					$out.response:=$requestResultAsText
					
					//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
				Else 
					
					$out.response:=$requestResult
					
					//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			End case 
			
			If ($error.lastError()#Null:C1517)
				
				$out.httpError:=$error.lastError().error
				$out.errors:=$error.errors()
				
			End if 
			
			If ($requestResult=Null:C1517)
				
				$out.success:=Choose:C955($out.httpError=Null:C1517; $out.code<300; False:C215)
				
			Else 
				
				If (Value type:C1509($requestResult.success)=Is boolean:K8:9)
					
					$out.success:=$requestResult.success
					
				End if 
				
				If ($requestResult.__ERROR#Null:C1517)
					
					$out.success:=False:C215
					$out.errors:=$requestResult.__ERROR
					
				End if 
				
				If ($requestResult.__ERRORS#Null:C1517)
					
					$out.success:=False:C215
					$out.errors:=$requestResult.__ERRORS
					
				End if 
			End if 
			
			$out.headers:=New object:C1471
			
			For ($i; 1; Size of array:C274($headerNames); 1)
				
				$out.headers[$headerNames{$i}]:=$headerValues{$i}
				
			End for 
		End if 
		
		// MARK:- status
	: ($in.action="status")
		
		$in.action:="request"
		$in.path:=""
		
		If ($in.caller#Null:C1517)
			
			$caller:=$in.caller
			OB REMOVE:C1226($in; "caller")
			
		End if 
		
		$out:=Rest($in)
		
		If ($caller#0)
			
			CALL FORM:C1391($caller; "editor_CALLBACK"; "checkingServerResponse"; $out)
			
		End if 
		
		// MARK:- info
	: ($in.action="info")
		
		$in.action:="request"
		$in.path:="$info"
		$out:=Rest($in)
		
		// MARK:- progressinfo
	: ($in.action="progressinfo")
		
		$in.action:="request"
		$in.path:="$info/ProgressInfo"
		$out:=Rest($in)
		
		// MARK:- sessioninfo
	: ($in.action="sessioninfo")
		
		$in.action:="request"
		$in.path:="$info/sessioninfo"
		$out:=Rest($in)
		
		// MARK:- entitySet
	: ($in.action="entitySet")
		
		$in.action:="request"
		$in.path:="$info/entityset"
		$out:=Rest($in)
		
		// MARK:- catalog
	: ($in.action="catalog")
		
		$in.action:="request"
		$in.path:="$catalog"
		$out:=Rest($in)
		
		// MARK:- tables
	: ($in.action="tables")
		
		$in.action:="request"
		$in.path:="$catalog/$all"
		$out:=Rest($in)
		
		// MARK:- table
	: ($in.action="table")
		
		If ($in.table=Null:C1517)
			
			$out.errors:=New collection:C1472("Missing parameters table")
			$out.success:=False:C215
			
		Else 
			
			$in.action:="request"
			$in.path:="$catalog/"+$in.table
			$out:=Rest($in)
			
		End if 
		
		// MARK:- records
	: ($in.action="records")
		
		If ($in.table=Null:C1517)
			
			$out.errors:=New collection:C1472("Missing parameters table")
			$out.success:=False:C215
			
		Else 
			
			$in.action:="request"
			$in.path:=$in.table
			
			If ($in.id#Null:C1517)
				
				$in.path:=$in.path+"("+$in.id+")"
				
			End if 
			
			// Special case for fields
			If (Value type:C1509($in.fields)=Is text:K8:3)
				
				// Support all text mode
				$in.fields:=Split string:C1554($in.fields; ",")
				
			End if 
			
			If (Value type:C1509($in.fields)=Is collection:K8:32)
				
				If (Bool:C1537($in.fieldsAsPath))
					
					$in.path:=$in.path+"/"+$in.fields.join(",")
					
				Else 
					
					If ($in.query=Null:C1517)
						
						$in.query:=New object:C1471(\
							)
						
					End if 
					
					$in.query["$attributes"]:=$in.fields.join(",")
					
				End if 
			End if 
			
			$out:=Rest($in)
			
		End if 
		
		// MARK:- authenticate
	: ($in.action="authenticate")
		
		$in.action:="request"
		$in.path:="authenticate"
		$out:=Rest($in)
		
		// MARK:- verify
	: ($in.action="verify")
		
		$in.action:="request"
		$in.path:="$verify"
		$out:=Rest($in)
		
		// MARK:- image
	: ($in.action="image")
		
		// XXX parameters checking: url, target
		
		// Get image using http request
		
		/// Compute headers
		If ($in.headers=Null:C1517)
			
			$in.headers:=New object:C1471
			
		End if 
		
		OB GET PROPERTY NAMES:C1232($in.headers; $headerNames)
		ARRAY TEXT:C222($headerValues; Size of array:C274($headerNames))
		
		For ($i; 1; Size of array:C274($headerNames); 1)
			
			$headerValues{$i}:=OB Get:C1224($in.headers; $headerNames{$i})
			
		End for 
		
		/// Do the request
		
/* START TRAPPING ERRORS */$error:=cs:C1710.error.new("capture")
		$out.code:=HTTP Request:C1158(HTTP GET method:K71:1; $in.url; ""; $x; $headerNames; $headerValues)
/* STOP TRAPPING ERRORS */$error.release()
		
		/// Check result
		If ($error.lastError()=Null:C1517)
			
			// Write to file
			$port:=BLOB size:C605($x)
			
			If ($port>0)
				
				$out.contentSize:=$port
				
				CREATE FOLDER:C475($in.target; *)
				
				BLOB TO DOCUMENT:C526($in.target; $x)
				
			Else 
				
				$out.warnings:=New collection:C1472("Picture file empty")
				
			End if 
			
		Else 
			
			$out.httpError:=Num:C11($error.lastError().error)
			
/* START HIDING ERRORS */$error:=cs:C1710.error.new("hide")
			
			$out.response:=BLOB to text:C555($x; UTF8 text without length:K22:17)
			
			If (Length:C16(String:C10($out.response))>0)
				
				$out.response:=JSON Parse:C1218($out.response)
				
				If ($out.response.__ERROR#Null:C1517)
					
					$out.errors:=$out.response.__ERROR
					
				End if 
			End if 
/* STOP HIDING ERRORS */$error.release()
			
		End if 
		
		/// Output headers
		$out.headers:=New object:C1471
		
		For ($i; 1; Size of array:C274($headerNames); 1)
			
			$out.headers[$headerNames{$i}]:=$headerValues{$i}
			
		End for 
		
		// Result
		$out.success:=Choose:C955($out.httpError=Null:C1517; $out.code<300; False:C215)
		
		//________________________________________
		
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$in.action+"\"")
		
		//________________________________________
End case 