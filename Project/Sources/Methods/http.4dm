//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : http
  // ID[9EE0577F54784D44B7CECB3BB7BA6749]
  // Created 11-12-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_BLOB:C604($x)
C_BOOLEAN:C305($b)
C_LONGINT:C283($i;$l;$Lon_code)
C_PICTURE:C286($p)
C_POINTER:C301($ptr)
C_TEXT:C284($t;$Txt_onErrCallMethod)
C_OBJECT:C1216($o)
C_COLLECTION:C1488($c)

ARRAY TEXT:C222($tTxt_HeaderNames;0)
ARRAY TEXT:C222($tTxt_HeaderValues;0)

If (False:C215)
	C_OBJECT:C1216(http ;$0)
	C_TEXT:C284(http ;$1)
	C_OBJECT:C1216(http ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	If (Count parameters:C259>=1)
		
		$t:=String:C10($1)
		
	End if 
	
	$o:=New object:C1471(\
		"";New object:C1471("url";$t;"type";Is text:K8:3;"keep-alive";False:C215);\
		"success";False:C215;\
		"response";Null:C1517;\
		"errors";New collection:C1472;\
		"get";Formula:C1597(http ("get";New object:C1471("type";$1;"keep-alive";Bool:C1537($2);"more";$3)));\
		"url";Formula:C1597(http ("url";New object:C1471("url";$1)));\
		"errorCodeMessage";Formula:C1597(http ("errorCodeMessage";New object:C1471("code";Num:C11($1))).message);\
		"myIP";Formula:C1597(http ("myIP").ip);\
		"statusCodeMessage";Formula:C1597(http ("statusCodeMessage";New object:C1471("code";Num:C11($1))).message);\
		"type";Formula:C1597(http ("type";New object:C1471("type";$1)))\
		)
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="url")
			
			$o[""].url:=String:C10($2.url)
			
			  //______________________________________________________
		: ($1="type")
			
			$o[""].type:=Num:C11($2.type)
			
			  //______________________________________________________
		: ($1="get")
			
			$o.response:=Null:C1517
			$o.headers:=New collection:C1472
			$o.success:=False:C215
			
			If (Length:C16($o[""].url)>0)
				
				If ($2.type#Null:C1517)
					
					$o[""].type:=Num:C11($2.type)
					
				End if 
				
				Case of 
						
						  //…………………………………………………………
					: ($o[""].type=Is text:K8:3)\
						 | ($o[""].type=Is object:K8:27)\
						 | ($o[""].type=Is collection:K8:32)
						
						$ptr:=->$t
						
						  //…………………………………………………………
					: ($o[""].type=Is picture:K8:10)\
						 | ($o[""].type=Is a document:K24:1)
						
						$ptr:=->$x
						
						  //…………………………………………………………
					Else 
						
						$ptr:=->$t
						
						  //…………………………………………………………
				End case 
				
				If ($2["keep-alive"]#Null:C1517)
					
					$b:=Bool:C1537($2["keep-alive"])
					
				Else 
					
					  // get object
					$b:=Bool:C1537($o[""]["keep-alive"])
					
				End if 
				
				$o.response:=Null:C1517
				$o.errors:=New collection:C1472
				
				  //========================================== [
				$Txt_onErrCallMethod:=Method called on error:C704
				httpError:=0
				ON ERR CALL:C155("HTTP ERROR HANDLER")
				
				If ($b)
					
					  // Enables the keep-alive mechanism for the server connection
					$Lon_code:=HTTP Get:C1157($o[""].url;$ptr->;$tTxt_HeaderNames;$tTxt_HeaderValues;*)
					
				Else 
					
					$Lon_code:=HTTP Get:C1157($o[""].url;$ptr->;$tTxt_HeaderNames;$tTxt_HeaderValues)
					
				End if 
				
				$o.success:=($Lon_code=200) & (httpError=0)
				
				If ($o.success)
					
					Case of 
							
							  //…………………………………………………………
						: ($o[""].type=Is object:K8:27)
							
							$o.response:=JSON Parse:C1218($t;Is object:K8:27)
							
							  //…………………………………………………………
						: ($o[""].type=Is collection:K8:32)
							
							$o.response:=JSON Parse:C1218($t;Is collection:K8:32)
							
							  //…………………………………………………………
						: ($o[""].type=Is picture:K8:10)
							
							$l:=Find in array:C230($tTxt_HeaderNames;"Content-Type")
							
							If ($l>0)
								
								BLOB TO PICTURE:C682($x;$p;$tTxt_HeaderValues{$l})
								
							Else 
								
								BLOB TO PICTURE:C682($x;$p)
								
							End if 
							
							$o.response:=$p
							
							  //…………………………………………………………
						: ($o[""].type=Is a document:K24:1)
							
							If (Bool:C1537($2.more.isFile))
								
								$l:=Find in array:C230($tTxt_HeaderNames;"Content-Type")
								
								Case of 
										
										  //______________________________________________________
									: ($l=-1)
										
										$2.more.setContent($x)
										
										  //______________________________________________________
									: ($tTxt_HeaderValues{$l}="image@")  // #Is it necessary?
										
										CREATE FOLDER:C475($2.more.platformPath;*)
										
										  //BLOB TO PICTURE($x;$p;$tTxt_HeaderValues{$l})
										BLOB TO PICTURE:C682($x;$p)
										WRITE PICTURE FILE:C680($2.more.platformPath;$p)
										
										  //______________________________________________________
									Else 
										
										$2.more.setContent($x)
										
										  //______________________________________________________
								End case 
								
								  //$2.more.setContent($x)
								
							Else 
								
								$o.success:=False:C215
								$o.errors:="Missing target document"
								
							End if 
							
							  //…………………………………………………………
						Else 
							
							$o.response:=$t
							
							  //…………………………………………………………
					End case 
					
				Else 
					
					If (httpError#0)
						
						$o.errors.push($o.errorCodeMessage(httpError))
						
					Else 
						
						$o.errors.push($o.statusCodeMessage($Lon_code))
						
					End if 
				End if 
				
				ON ERR CALL:C155($Txt_onErrCallMethod)
				
				  //========================================== ]
				
				For ($i;1;Size of array:C274($tTxt_HeaderNames);1)
					
					$o.headers.push(New object:C1471(\
						"name";$tTxt_HeaderNames{$i};\
						"value";$tTxt_HeaderValues{$i}))
					
				End for 
				
			Else 
				
				$o.success:=False:C215
				$o.errors:="The URL is empty"
				
			End if 
			
			  //______________________________________________________
		: ($1="myIP")
			
			$o:=New object:C1471(\
				"success";False:C215)
			
			$Txt_onErrCallMethod:=Method called on error:C704
			httpError:=0
			ON ERR CALL:C155("HTTP ERROR HANDLER")
			$Lon_code:=HTTP Get:C1157("http://api.ipify.org";$t)
			ON ERR CALL:C155($Txt_onErrCallMethod)
			
			$o.success:=($Lon_code=200) & (httpError=0)
			
			If ($o.success)
				
				$o.ip:=$t
				
			Else 
				
				$o.errors:=New collection:C1472
				
				If (httpError#0)
					
					$o.errors.push(This:C1470.errorCodeMessage(httpError))
					
				Else 
					
					$o.errors.push(This:C1470.statusCodeMessage($Lon_code))
					
				End if 
			End if 
			
			  //______________________________________________________
		: ($1="errorCodeMessage")
			
			$c:=New collection:C1472
			
			$c[2]:="HTTP server not reachable"
			$c[17]:="HTTP server not reachable (timeout?)"
			$c[30]:="HTTP server not reachable"
			
			If ($c[$2.code]#Null:C1517)
				
				$o:=New object:C1471(\
					"message";$c[$2.code])
				
			Else 
				
				$o:=New object:C1471(\
					"message";"HTTP error: "+String:C10($c[$2.code]))
				
			End if 
			
			$o.message:=$o.message+"\r("+$o[""].url+")"
			
			  //______________________________________________________
		: ($1="statusCodeMessage")
			
			$c:=New collection:C1472
			
			  // 1xx Informational response
			
			  // 2xx Success
			$c[200]:="OK"
			$c[201]:="Created"
			$c[202]:="Accepted"
			$c[203]:="Non-Authoritative Information"
			$c[204]:="No Content"
			$c[205]:="Reset Content"
			$c[206]:="Partial Content"
			$c[207]:="Multi-Status"
			$c[208]:="Already Reported"
			$c[226]:="IM Used"
			
			  // 3xx Redirection
			
			  // 4xx Client errors
			$c[400]:="Bad Request"
			$c[401]:="Unauthorized"
			$c[402]:="Payment Required"
			$c[403]:="Forbidden"
			$c[404]:="Not Found"
			$c[406]:="Not Acceptable"
			$c[407]:="Proxy Authentication Required"
			$c[408]:="Request Timeout"
			$c[409]:="Conflict"
			$c[410]:="Gone"
			$c[411]:="Length Required"
			$c[412]:="Precondition Failed"
			$c[413]:="Payload Too Large"
			$c[414]:="URI Too Long"
			$c[415]:="Unsupported Media Type"
			$c[416]:="Range Not Satisfiable"
			$c[417]:="Expectation Failed"
			$c[418]:="I'm a teapot ;-)"
			$c[421]:="Misdirected Request"
			$c[422]:="Unprocessable Entity"
			$c[423]:="Locked"
			$c[424]:="Method failure"
			$c[425]:="Unordered Collection"
			$c[426]:="Upgrade Required"
			$c[428]:="Precondition Required"
			$c[429]:="Too Many Requests"
			$c[431]:="Request Header Fields Too Large"
			$c[440]:="Login Time-out"
			$c[449]:="Retry With"
			$c[450]:="Blocked by Windows Parental Controls"
			
			$c[451]:="Unavailable For Legal Reasons"
			
			$c[456]:="Unrecoverable Error"
			
			  // 5xx Server errors
			$c[500]:="Internal Server Error"
			$c[501]:="Not Implemented"
			$c[502]:="Bad Gateway"
			$c[503]:="Service Unavailable"
			$c[504]:="Gateway Timeout"
			$c[505]:="HTTP Version Not Supported"
			$c[506]:="Variant Also Negotiates"
			$c[507]:="Insufficient Storag"
			$c[508]:="Loop Detected"
			$c[510]:="Not Extended"
			$c[511]:="Network Authentication Required"
			
			If ($c[$2.code]#Null:C1517)
				
				$o:=New object:C1471(\
					"message";$c[$2.code])
				
			Else 
				
				$o:=New object:C1471(\
					"message";"Unknow status code: "+String:C10($c[$2.code]))
				
			End if 
			
			$o.message:=$o.message+"\r("+$o[""].url+")"
			
			  //______________________________________________________
			
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End