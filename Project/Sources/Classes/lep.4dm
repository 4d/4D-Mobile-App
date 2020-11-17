//Class extends tools

Class constructor
	
	//Super()
	
	This:C1470.reset()
	
	//====================================================================
Function launch($command; $arguments)->$this : cs:C1710.lep
	
	var $input; $output : Blob
	var $error; $t : Text
	var $len; $pid; $pos : Integer
	
	
	If (Value type:C1509($command)=Is object:K8:27)
		
		This:C1470.command:=This:C1470.escape($command.path)
		
	Else 
		
		// Path must be POSIX
		This:C1470.command:=String:C10($command)
		
		Case of 
				
				//______________________________________________________
			: (This:C1470.command="shell")
				
				This:C1470.command:="/bin/sh"
				
				//______________________________________________________
			: (This:C1470.command="bat")
				
				This:C1470.command:="cmd.exe /C start /B"
				
				//______________________________________________________
			Else 
				
				// A "Case of" statement should never omit "Else"
				//______________________________________________________
		End case 
	End if 
	
	If (Count parameters:C259>=2)
		
		This:C1470.command:=This:C1470.command+" "+This:C1470.escape($arguments)
		
	End if 
	
	For each ($t; This:C1470.environmentVariables)
		
		SET ENVIRONMENT VARIABLE:C812($t; String:C10(This:C1470.environmentVariables[$t]))
		
	End for each 
	
	Case of 
			
			//……………………………………………………………………
		: (This:C1470.inputStream=Null:C1517)
			
			// <NOTHING MORE TO DO>
			
			//……………………………………………………………………
		: (Value type:C1509(This:C1470.inputStream)=Is text:K8:3)\
			 | (Value type:C1509(This:C1470.inputStream)=Is alpha field:K8:1)
			
			CONVERT FROM TEXT:C1011(This:C1470.inputStream; This:C1470.charSet; $input)
			
			//……………………………………………………………………
		: (Value type:C1509(This:C1470.inputStream)=Is boolean:K8:9)
			
			CONVERT FROM TEXT:C1011(Choose:C955(This:C1470.inputStream; "true"; "false"); This:C1470.charSet; $input)
			
			//……………………………………………………………………
		: (Value type:C1509(This:C1470.inputStream)=Is longint:K8:6)\
			 | (Value type:C1509(This:C1470)=Is integer:K8:5)\
			 | (Value type:C1509(This:C1470.inputStream)=Is integer 64 bits:K8:25)\
			 | (Value type:C1509(This:C1470.inputStream)=Is real:K8:4)
			
			CONVERT FROM TEXT:C1011(String:C10(This:C1470.inputStream; "&xml"); This:C1470.charSet; $input)
			
			//……………………………………………………………………
		Else 
			
			$output:=This:C1470.inputStream  // Blob
			
			//……………………………………………………………………
	End case 
	
	LAUNCH EXTERNAL PROCESS:C811(This:C1470.command; $input; $output; $error; $pid)
	
	$t:=Convert to text:C1012($output; This:C1470.charSet)
	
	If (Length:C16($error)=0)
		
		// ⚠️ Some commands return the error in the output stream
		If (Position:C15("ERROR:"; $t)>0)
			
			$error:=$t
			
		End if 
	End if 
	
	This:C1470.success:=Bool:C1537(OK) & (Length:C16($error)=0)
	
	If (This:C1470.success)
		
		This:C1470.pid:=$pid
		
		// Remove the last line feed, if any
		If ($t[[Length:C16($t)]]="\n")
			
			$t:=Substring:C12($t; 1; Length:C16($t)-1)
			
		End if 
		
		Case of 
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is text:K8:3)
				
				This:C1470.outputStream:=$t
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is object:K8:27)
				
				If (Length:C16($t)>0)
					
					This:C1470.success:=(Match regex:C1019("(?ms-i)^(?:\\{.*\\})|(?:^\\[.*\\])$"; $t; 1))
					
				End if 
				
				If (This:C1470.success)
					
					This:C1470.outputStream:=JSON Parse:C1218($t)
					
				Else 
					
					This:C1470.errorStream:=$t
					
				End if 
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is boolean:K8:9)
				
				This:C1470.outputStream:=($t="true")
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is longint:K8:6)\
				 | (This:C1470.outputType=Is integer:K8:5)\
				 | (This:C1470.outputType=Is integer 64 bits:K8:25)\
				 | (This:C1470.outputType=Is real:K8:4)
				
				This:C1470.outputStream:=Num:C11($t)
				
				//……………………………………………………………………
			Else 
				
				This:C1470.outputStream:=$output  // Blob
				
				//……………………………………………………………………
		End case 
		
	Else 
		
		This:C1470.pid:=0
		This:C1470.outputStream:=Null:C1517
		This:C1470.errorStream:=$error
		This:C1470.errors.push($error)
		
	End if 
	
	$this:=This:C1470
	
	//====================================================================
Function reset()->$this : cs:C1710.lep
	
	This:C1470.success:=True:C214
	This:C1470.errors:=New collection:C1472
	This:C1470.command:=Null:C1517
	This:C1470.inputStream:=Null:C1517
	This:C1470.outputStream:=Null:C1517
	This:C1470.errorStream:=Null:C1517
	This:C1470.pid:=0
	
	This:C1470.setCharSet()
	This:C1470.setOutputType()
	This:C1470.setEnvironnementVariable()
	
	$this:=This:C1470
	
	//====================================================================
Function setCharSet($charset : Text)->$this : cs:C1710.lep
	
	If (Count parameters:C259>=1)
		
		This:C1470.charSet:=$charset
		
	Else 
		
		// Reset
		This:C1470.charSet:="UTF-8"
		
	End if 
	
	$this:=This:C1470
	
	//====================================================================
Function setOutputType($outputType : Integer)->$this : cs:C1710.lep
	
	If (Count parameters:C259>=1)
		
		This:C1470.outputType:=$outputType
		
	Else 
		
		// Reset
		This:C1470.outputType:=Is text:K8:3
		
	End if 
	
	$this:=This:C1470
	
	//====================================================================
Function setEnvironnementVariable($variables; $value : Text)->$this : cs:C1710.lep
	
	var $o : Object
	
	Case of 
			
			//……………………………………………………………………
		: (Count parameters:C259=0)
			
			This:C1470.environmentVariables:=New object:C1471(\
				"_4D_OPTION_CURRENT_DIRECTORY"; ""; \
				"_4D_OPTION_HIDE_CONSOLE"; "true"; \
				"_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "true"\
				)
			
			//______________________________________________________
		: (Value type:C1509($variables)=Is text:K8:3)
			
			If (Count parameters:C259>=2)
				
				This:C1470.environmentVariables[$variables]:=$value
				
			Else 
				
				// Reset
				This:C1470.environmentVariables[$variables]:=""
				
			End if 
			
			//______________________________________________________
		: (Value type:C1509($variables)=Is object:K8:27)
			
			For each ($o; OB Entries:C1720($variables))
				
				This:C1470.environmentVariables[$o.key]:=$o.value
				
			End for each 
			
			//______________________________________________________
		: (Value type:C1509($variables)=Is collection:K8:32)
			
			For each ($o; $variables)
				
				This:C1470.environmentVariables[$o.key]:=$o.value
				
			End for each 
			
			//______________________________________________________
		Else 
			
			This:C1470._pushError("Waiting for a parameter object or collection")
			
			//______________________________________________________
	End case 
	
	$this:=This:C1470
	
	//====================================================================
Function escape($text : Text)->$escaped : Text
	
	var $t : Text
	
	$escaped:=$text
	
	For each ($t; Split string:C1554("\\!\"#$%&'()=~|<>?;*`[] "; ""))
		
		$escaped:=Replace string:C233($escaped; $t; "\\"+$t; *)
		
	End for each 
	
	//====================================================================
Function _pushError($desription : Text)
	
	This:C1470.success:=False:C215
	This:C1470.errors.push(Get call chain:C1662[1].name+" - "+$desription)