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
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BLOB:C604($Blb_buffer)
C_LONGINT:C283($Lon_i;$Lon_parameters;$Lon_port;$Lon_timeout;$Win_caller)
C_TEXT:C284($Txt_onError;$Txt_query;$Txt_queryValue)
C_OBJECT:C1216($Obj_param;$Obj_requestResult;$Obj_result;$Obj_server)

ARRAY TEXT:C222($tTxt_headerNames;0)
ARRAY TEXT:C222($tTxt_headerValues;0)
ARRAY TEXT:C222($tTxt_names;0)

If (False:C215)
	C_OBJECT:C1216(Rest ;$0)
	C_OBJECT:C1216(Rest ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Obj_param:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_result:=New object:C1471(\
		"success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Obj_param.action=Null:C1517)
		
		ASSERT:C1129(False:C215)
		
		  //______________________________________________________
	: ($Obj_param.action="devurl")
		
		$Obj_server:=WEB Get server info:C1531
		
		Case of 
				
				  //________________________________________
			: (Bool:C1537($Obj_server.security.HTTPEnabled))  // Priority for http
				
				$Obj_result.url:="http://localhost:"+String:C10($Obj_server.options.webPortID)
				
				  //________________________________________
			: (Bool:C1537($Obj_server.security.HTTPSEnabled))  // Only https, use it
				
				$Obj_result.url:="https://localhost:"+String:C10($Obj_server.options.webHTTPSPortID)
				
				  //________________________________________
			Else 
				
				WEB GET OPTION:C1209(Web Port ID:K73:14;$Lon_port)
				$Obj_result.url:="http://localhost:"+String:C10($Lon_port)
				
				  //________________________________________
		End case 
		
		  //#TURN_AROUND - In some cases, using "localhost" we get the error -30 "Server unreachable"
		$Obj_result.url:=Replace string:C233($Obj_result.url;"localhost";"127.0.0.1")
		
		If ($Obj_param.handler=Null:C1517)
			
			  //$Obj_param.handler:=Choose(Bool(featuresFlags._102457);"mobileapp";"rest")
			$Obj_param.handler:="mobileapp"
			
		End if 
		
		$Obj_result.url:=$Obj_result.url+"/"+$Obj_param.handler+"/"
		$Obj_result.success:=True:C214
		
		  //______________________________________________________
	: ($Obj_param.action="url")
		
		If (Length:C16(String:C10($Obj_param.url))=0)
			
			$Obj_result:=Rest (New object:C1471(\
				"action";"devurl";"handler";$Obj_param.handler))
			
		Else 
			
			  // Add missing / if necessary
			$Obj_result.url:=$Obj_param.url
			If (Substring:C12($Obj_result.url;Length:C16($Obj_result.url))#"/")
				$Obj_result.url:=$Obj_result.url+"/"
			End if 
			
			  // Add missing handler if needed
			If ($Obj_param.handler=Null:C1517)
				
				  //$Obj_param.handler:=Choose(Bool(featuresFlags._102457);"mobileapp";"rest")
				$Obj_param.handler:="mobileapp"
				
			End if 
			
			If (Position:C15($Obj_param.handler+"/";$Obj_result.url)#(Length:C16($Obj_result.url)-Length:C16($Obj_param.handler)))
				
				$Obj_result.url:=$Obj_result.url+$Obj_param.handler+"/"
				
			End if 
			
			$Obj_result.success:=True:C214
			
		End if 
		
		  //#TURN_AROUND - In some cases, using "localhost" we get the error -30 "Server unreachable"
		$Obj_result.url:=Replace string:C233($Obj_result.url;"localhost";"127.0.0.1")
		
		  //______________________________________________________
	: ($Obj_param.action="request")
		
		$Obj_param.action:="url"
		$Obj_result:=Rest ($Obj_param)  //Get & format url, devurl if not in param
		
		If ($Obj_result.success)
			
			If ($Obj_param.method=Null:C1517)
				
				$Obj_param.method:=HTTP GET method:K71:1
				
			End if 
			
			If ($Obj_param.path=Null:C1517)
				
				$Obj_param.path:=""
				
			End if 
			
			If ($Obj_param.contentObject=Null:C1517)
				
				If ($Obj_param.content=Null:C1517)
					
					$Obj_param.content:=""
					
				End if 
				
			Else 
				
				$Obj_param.content:=JSON Stringify:C1217($Obj_param.contentObject)
				
			End if 
			
			$Obj_result.url:=$Obj_result.url+$Obj_param.path
			
			  //If $Obj_param.query"null"
			  //  ?dsf-
			  //End if
			
			  // Manage query parameters
			If ($Obj_param.query#Null:C1517)
				
				OB GET PROPERTY NAMES:C1232($Obj_param.query;$tTxt_names)  //;$tLon_types)
				
				For ($Lon_i;1;Size of array:C274($tTxt_names);1)
					
					  //$queryValue:=OB Get($Obj_param.query;$tTxt_names{$Lon_i})
					$Txt_queryValue:=$Obj_param.query[$tTxt_names{$Lon_i}]
					
					If ($Lon_i#1)
						
						$Txt_query:=$Txt_query+"&"
						
					End if 
					
					If (Bool:C1537($Obj_param.queryEncode))
						
						  // Encode value
						If ((Position:C15("\"";$Txt_queryValue)>0) & (Position:C15("'";$Txt_queryValue)=0))
							$Txt_query:=$Txt_query+$tTxt_names{$Lon_i}+"='"+str_URLEncode ($Txt_queryValue)+"'"  // use ' if filter contains = and no '
						Else 
							$Txt_query:=$Txt_query+$tTxt_names{$Lon_i}+"=\""+str_URLEncode ($Txt_queryValue)+"\""
						End if 
						
					Else 
						
						$Txt_query:=$Txt_query+$tTxt_names{$Lon_i}+"=\""+$Txt_queryValue+"\""
						
					End if 
				End for 
				
				$Obj_result.url:=Choose:C955(Position:C15("?";$Obj_result.url)>0;$Obj_result.url+"&"+$Txt_query;$Obj_result.url+"?"+$Txt_query)
				
			End if 
			
			  // Manage headers
			If ($Obj_param.headers=Null:C1517)
				
				$Obj_param.headers:=New object:C1471()
				
			End if 
			
			OB GET PROPERTY NAMES:C1232($Obj_param.headers;$tTxt_headerNames)
			ARRAY TEXT:C222($tTxt_headerValues;Size of array:C274($tTxt_headerNames))
			
			For ($Lon_i;1;Size of array:C274($tTxt_headerNames);1)
				
				$tTxt_headerValues{$Lon_i}:=OB Get:C1224($Obj_param.headers;$tTxt_headerNames{$Lon_i})
				
			End for 
			
			If (Num:C11($Obj_param.timeout)#0)
				
				HTTP GET OPTION:C1159(HTTP timeout:K71:10;$Lon_timeout)
				HTTP SET OPTION:C1160(HTTP timeout:K71:10;$Obj_param.timeout)
				
			End if 
			
			$Txt_onError:=Method called on error:C704
			http_ERROR:=0
			ON ERR CALL:C155("http_NO_ERROR")  //========== [
			
			  //#TURN_AROUND - HTTP Request doesn't allow an expression for content (a BLOB couldn't be passed as a value but only by a reference) {
			  //$Obj_result.code:=HTTP Request($Obj_param.method;$Obj_result.url;$Obj_param.content;$Obj_requestResult;$tTxt_headerNames;$tTxt_headerValues)
			  //C_TEXT($Txt_buffer)
			  //$Txt_buffer:=$Obj_param.content
			  //$Obj_result.code:=HTTP Request($Obj_param.method;$Obj_result.url;$Txt_buffer;$Obj_requestResult;$tTxt_headerNames;$tTxt_headerValues)
			$Obj_result.code:=HTTP Request:C1158($Obj_param.method;$Obj_result.url;($Obj_param.content);$Obj_requestResult;$tTxt_headerNames;$tTxt_headerValues)
			  //}
			
			ON ERR CALL:C155($Txt_onError)  //============= ]
			
			If ($Lon_timeout#0)
				
				HTTP SET OPTION:C1160(HTTP timeout:K71:10;$Lon_timeout)
				
			End if 
			
			$Obj_result.response:=$Obj_requestResult
			
			If (http_ERROR#0)
				
				$Obj_result.httpError:=http_ERROR
				
			End if 
			
			If ($Obj_requestResult=Null:C1517)
				
				$Obj_result.success:=Choose:C955($Obj_result.httpError=Null:C1517;$Obj_result.code<300;False:C215)
				
			Else 
				
				If (Value type:C1509($Obj_requestResult.success)=Is boolean:K8:9)
					
					$Obj_result.success:=$Obj_requestResult.success
					
				End if 
				
				If ($Obj_requestResult.__ERROR#Null:C1517)
					
					$Obj_result.success:=False:C215
					$Obj_result.errors:=$Obj_requestResult.__ERROR
					
				End if 
				
				If ($Obj_requestResult.__ERRORS#Null:C1517)
					
					$Obj_result.success:=False:C215
					$Obj_result.errors:=$Obj_requestResult.__ERRORS
					
				End if 
			End if 
			
			$Obj_result.headers:=New object:C1471
			
			For ($Lon_i;1;Size of array:C274($tTxt_headerNames);1)
				
				$Obj_result.headers[$tTxt_headerNames{$Lon_i}]:=$tTxt_headerValues{$Lon_i}
				
			End for 
		End if 
		
		  //______________________________________________________
	: ($Obj_param.action="status")
		
		$Obj_param.action:="request"
		$Obj_param.path:=""
		
		If ($Obj_param.caller#Null:C1517)
			
			$Win_caller:=$Obj_param.caller
			OB REMOVE:C1226($Obj_param;"caller")
			
		End if 
		
		$Obj_result:=Rest ($Obj_param)
		
		If ($Win_caller#0)
			
			CALL FORM:C1391($Win_caller;"editor_CALLBACK";"testServer";$Obj_result)
			
		End if 
		
		  //______________________________________________________
	: ($Obj_param.action="info")
		
		$Obj_param.action:="request"
		$Obj_param.path:="$info"
		$Obj_result:=Rest ($Obj_param)
		
		  //______________________________________________________
	: ($Obj_param.action="progressinfo")
		
		$Obj_param.action:="request"
		$Obj_param.path:="$info/ProgressInfo"
		$Obj_result:=Rest ($Obj_param)
		
		  //______________________________________________________
	: ($Obj_param.action="sessioninfo")
		
		$Obj_param.action:="request"
		$Obj_param.path:="$info/sessioninfo"
		$Obj_result:=Rest ($Obj_param)
		
		  //______________________________________________________
	: ($Obj_param.action="entitySet")
		
		$Obj_param.action:="request"
		$Obj_param.path:="$info/entityset"
		$Obj_result:=Rest ($Obj_param)
		
		  //______________________________________________________
	: ($Obj_param.action="catalog")
		
		$Obj_param.action:="request"
		$Obj_param.path:="$catalog"
		$Obj_result:=Rest ($Obj_param)
		
		  //______________________________________________________
	: ($Obj_param.action="tables")
		
		$Obj_param.action:="request"
		$Obj_param.path:="$catalog/$all"
		$Obj_result:=Rest ($Obj_param)
		
		  //______________________________________________________
	: ($Obj_param.action="table")
		
		If ($Obj_param.table=Null:C1517)
			
			$Obj_result.errors:=New collection:C1472("Missing parameters table")
			$Obj_result.success:=False:C215
			
		Else 
			
			$Obj_param.action:="request"
			$Obj_param.path:="$catalog/"+$Obj_param.table
			$Obj_result:=Rest ($Obj_param)
			
		End if 
		
		  //______________________________________________________
	: ($Obj_param.action="records")
		
		If ($Obj_param.table=Null:C1517)
			
			$Obj_result.errors:=New collection:C1472("Missing parameters table")
			$Obj_result.success:=False:C215
			
		Else 
			
			$Obj_param.action:="request"
			$Obj_param.path:=$Obj_param.table
			
			If ($Obj_param.id#Null:C1517)
				
				$Obj_param.path:=$Obj_param.path+"("+$Obj_param.id+")"
				
			End if 
			
			  // special case for fields
			If (Value type:C1509($Obj_param.fields)=Is text:K8:3)
				  // support all text mode
				$Obj_param.fields:=Split string:C1554($Obj_param.fields;",")
			End if 
			
			If (Value type:C1509($Obj_param.fields)=Is collection:K8:32)
				
				If (Bool:C1537($Obj_param.fieldsAsPath))
					
					$Obj_param.path:=$Obj_param.path+"/"+$Obj_param.fields.join(",")
					
				Else 
					
					If ($Obj_param.query=Null:C1517)
						$Obj_param.query:=New object:C1471()
					End if 
					
					$Obj_param.query["$attributes"]:=$Obj_param.fields.join(",")
					
				End if 
			End if 
			
			$Obj_result:=Rest ($Obj_param)
			
		End if 
		
		  //______________________________________________________
	: ($Obj_param.action="authenticate")
		
		$Obj_param.action:="request"
		$Obj_param.path:="authenticate"
		$Obj_result:=Rest ($Obj_param)
		
		  //______________________________________________________
	: ($Obj_param.action="verify")
		
		$Obj_param.action:="request"
		$Obj_param.path:="$verify"
		$Obj_result:=Rest ($Obj_param)
		
		  //______________________________________________________
	: ($Obj_param.action="image")
		
		  // XXX parameters checking: url, target
		
		  // Get image using http request
		
		  /// Compute headers
		If ($Obj_param.headers=Null:C1517)
			$Obj_param.headers:=New object:C1471()
		End if 
		OB GET PROPERTY NAMES:C1232($Obj_param.headers;$tTxt_headerNames)
		ARRAY TEXT:C222($tTxt_headerValues;Size of array:C274($tTxt_headerNames))
		
		For ($Lon_i;1;Size of array:C274($tTxt_headerNames);1)
			
			$tTxt_headerValues{$Lon_i}:=OB Get:C1224($Obj_param.headers;$tTxt_headerNames{$Lon_i})
			
		End for 
		
		  /// Do the request
		$Txt_onError:=Method called on error:C704
		http_ERROR:=0
		ON ERR CALL:C155("http_NO_ERROR")  //========== [
		
		$Obj_result.code:=HTTP Request:C1158(HTTP GET method:K71:1;$Obj_param.url;"";$Blb_buffer;$tTxt_headerNames;$tTxt_headerValues)
		
		ON ERR CALL:C155($Txt_onError)  //============= ]
		
		  /// Check result
		If (http_ERROR=0)
			
			  // Write to file
			$Lon_port:=BLOB size:C605($Blb_buffer)
			
			If ($Lon_port>0)
				
				$Obj_result.contentSize:=$Lon_port
				
				CREATE FOLDER:C475($Obj_param.target;*)
				
				BLOB TO DOCUMENT:C526($Obj_param.target;$Blb_buffer)
				
			Else 
				
				$Obj_result.warnings:=New collection:C1472("Picture file empty")
				
			End if 
			
		Else 
			
			$Obj_result.httpError:=http_ERROR
			
			ob_Lon_Error:=0
			ON ERR CALL:C155("ob_noError")  //========== [
			
			$Obj_result.response:=BLOB to text:C555($Blb_buffer;UTF8 text without length:K22:17)
			
			If (Length:C16(String:C10($Obj_result.response))>0)
				
				$Obj_result.response:=JSON Parse:C1218($Obj_result.response)
				
				If ($Obj_result.response.__ERROR#Null:C1517)
					
					$Obj_result.errors:=$Obj_result.response.__ERROR
					
				End if 
			End if 
			
			ON ERR CALL:C155($Txt_onError)  //============= ]
			
		End if 
		
		  /// Output headers
		$Obj_result.headers:=New object:C1471
		
		For ($Lon_i;1;Size of array:C274($tTxt_headerNames);1)
			
			$Obj_result.headers[$tTxt_headerNames{$Lon_i}]:=$tTxt_headerValues{$Lon_i}
			
		End for 
		
		  // Result
		$Obj_result.success:=Choose:C955($Obj_result.httpError=Null:C1517;$Obj_result.code<300;False:C215)
		
		  //________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_param.action+"\"")
		
		  //________________________________________
End case 

$0:=$Obj_result