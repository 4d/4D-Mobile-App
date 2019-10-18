//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : lep
  // ID[B93E680CFFB7499989181BA9AF8D0B8B]
  // Created 15-10-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_BLOB:C604($Blb_input;$Blb_output)
C_BOOLEAN:C305($b)
C_LONGINT:C283($i;$l;$len;$Lon_pid;$pos)
C_TEXT:C284($pattern;$t;$text;$Txt_arguments;$Txt_command;$Txt_error)
C_TEXT:C284($Txt_metaCharacters)
C_OBJECT:C1216($o;$oo)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(lep ;$0)
	C_TEXT:C284(lep ;$1)
	C_OBJECT:C1216(lep ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470.$_is=Null:C1517)  // Constructor
	
	$o:=New object:C1471(\
		"$_is";"lep";\
		"launch";Formula:C1597(lep ("launch";New object:C1471("file";$1;"arguments";$2)));\
		"reset";Formula:C1597(lep ("reset"));\
		"setCharSet";Formula:C1597(lep ("setCharSet";New object:C1471("charSet";$1)));\
		"setEnvironnementVariable";Formula:C1597(lep ("setEnvironnementVariable";New object:C1471("variables";$1)));\
		"setOutputType";Formula:C1597(lep ("setOutputType";New object:C1471("type";Num:C11($1))));\
		"$escape";Formula:C1597(lep ("$escape";New object:C1471("in";$1)).value)\
		)
	
	$o.reset()
	
	If (Count parameters:C259>=1)
		
		For each ($t;Split string:C1554(String:C10($1);","))
			
			$c:=Split string:C1554($t;":")
			
			Case of 
					
					  //……………………………………………………………………
				: ($c.length<2)
					
					$o.success:=False:C215
					$o.errors.push("Missing value for the named parameter "+$c[0])
					
					  //……………………………………………………………………
				: ($c[0]="charset")
					
					$o.charSet:=$c[1]
					
					  //……………………………………………………………………
				: ($c[0]="output")
					
					$o.outputType:=Choose:C955($c[1]="blob";Is BLOB:K8:12;\
						Choose:C955($c[1]="object";Is object:K8:27;\
						Choose:C955($c[1]="numeric";Is real:K8:4;\
						Choose:C955($c[1]="boolean";Is boolean:K8:9;Is text:K8:3))))
					
					  //……………………………………………………………………
				: ($c[0]="directory")
					
					$o.environmentVariables["_4D_OPTION_CURRENT_DIRECTORY"]:=$c[1]
					
					  //……………………………………………………………………
				: ($c[0]="blocking")
					
					$o.environmentVariables["_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"]:=Choose:C955($c[1]="true";"true";"false")
					
					  //……………………………………………………………………
				: ($c[0]="console")
					
					$o.environmentVariables["_4D_OPTION_HIDE_CONSOLE"]:=Choose:C955($c[1]="true";"true";"false")
					
					  //……………………………………………………………………
				Else 
					
					$o.success:=False:C215
					$o.errors.push("Unknown named parameter: "+$c[0])
					
					  //……………………………………………………………………
			End case 
		End for each 
	End if 
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="reset")
			
			$o.success:=True:C214
			$o.errors:=New collection:C1472
			$o.command:=Null:C1517
			$o.inputStream:=Null:C1517
			$o.outputStream:=Null:C1517
			$o.errorStream:=Null:C1517
			$o.pid:=0
			
			$o.outputType:=Is text:K8:3
			$o.charSet:="UTF-8"
			
			$o.environmentVariables:=New object:C1471(\
				"_4D_OPTION_CURRENT_DIRECTORY";"";\
				"_4D_OPTION_HIDE_CONSOLE";"true";\
				"_4D_OPTION_BLOCKING_EXTERNAL_PROCESS";"true"\
				)
			
			  //______________________________________________________
		: ($1="setCharSet")
			
			$o.charSet:=Choose:C955($2.charset=Null:C1517;"UTF-8";String:C10($2.charset))
			
			  //______________________________________________________
		: ($1="setOutputType")
			
			$o.outputType:=$2.type
			
			  //______________________________________________________
		: ($1="launch")
			
			$o.outputStream:=Null:C1517
			$o.command:=""
			
			If (Value type:C1509($2.file)=Is object:K8:27)
				
				$Txt_command:=$2.file.path
				
			Else 
				
				  // Path must be POSIX
				$Txt_command:=String:C10($2.file)
				
				Case of 
						
						  //______________________________________________________
					: ($Txt_command="shell")
						
						$Txt_command:="/bin/sh"
						
						  //______________________________________________________
					: ($Txt_command="bat")
						
						$Txt_command:="cmd.exe /C start /B"
						
						  //______________________________________________________
					Else 
						
						  // A "Case of" statement should never omit "Else"
						
						  //______________________________________________________
				End case 
			End if 
			
			$o.command:=$o.$escape($Txt_command)
			
			If (Length:C16(String:C10($2.arguments))>0)
				
				$o.command:=$o.command+" "+$o.$escape(String:C10($2.arguments))
				
			End if 
			
			For each ($t;$o.environmentVariables)
				
				SET ENVIRONMENT VARIABLE:C812($t;String:C10($o.environmentVariables[$t]))
				
			End for each 
			
			Case of 
					
					  //……………………………………………………………………
				: ($o.inputStream=Null:C1517)
					
					  // <NOTHING MORE TO DO>
					
					  //……………………………………………………………………
				: (Value type:C1509($o.inputStream)=Is text:K8:3)\
					 | (Value type:C1509($o.inputStream)=Is alpha field:K8:1)
					
					CONVERT FROM TEXT:C1011($o.inputStream;$o.charSet;$Blb_input)
					
					  //……………………………………………………………………
				: (Value type:C1509($o.inputStream)=Is boolean:K8:9)
					
					CONVERT FROM TEXT:C1011(Choose:C955($o.inputStream;"true";"false");$o.charSet;$Blb_input)
					
					  //……………………………………………………………………
				: (Value type:C1509($o.inputStream)=Is longint:K8:6)\
					 | (Value type:C1509($o.inputStream)=Is integer:K8:5)\
					 | (Value type:C1509($o.inputStream)=Is integer 64 bits:K8:25)\
					 | (Value type:C1509($o.inputStream)=Is real:K8:4)
					
					CONVERT FROM TEXT:C1011(String:C10($o.inputStream;"&xml");$o.charSet;$Blb_input)
					
					  //……………………………………………………………………
				Else 
					
					$Blb_output:=$o.inputStream  // Blob
					
					  //……………………………………………………………………
			End case 
			
			LAUNCH EXTERNAL PROCESS:C811($o.command;$Blb_input;$Blb_output;$Txt_error;$Lon_pid)
			
			$o.success:=Bool:C1537(OK)
			
			If ($o.success)
				
				$o.pid:=$Lon_pid
				
				Case of 
						
						  //……………………………………………………………………
					: ($o.outputType=Is text:K8:3)
						
						$o.outputStream:=Convert to text:C1012($Blb_output;$o.charSet)
						
						  //……………………………………………………………………
					: ($o.outputType=Is object:K8:27)
						
						$o.outputStream:=JSON Parse:C1218(Convert to text:C1012($Blb_output;$o.charSet))
						
						  //……………………………………………………………………
					: ($o.outputType=Is boolean:K8:9)
						
						$o.outputStream:=(Convert to text:C1012($Blb_output;$o.charSet)="true")
						
						  //……………………………………………………………………
					: ($o.outputType=Is longint:K8:6)\
						 | ($o.outputType=Is integer:K8:5)\
						 | ($o.outputType=Is integer 64 bits:K8:25)\
						 | ($o.outputType=Is real:K8:4)
						
						$o.outputStream:=Num:C11(Convert to text:C1012($Blb_output;$o.charSet))
						
						  //……………………………………………………………………
					Else 
						
						$o.outputStream:=$Blb_output  // Blob
						
						  //……………………………………………………………………
				End case 
				
			Else 
				
				$o.pid:=0
				$o.errorStream:=$Txt_error
				$o.errors.push($Txt_error)
				
			End if 
			
			  //______________________________________________________
		: ($1="setEnvironnementVariable")
			
			Case of 
					
					  //……………………………………………………………………
				: ($2.variables=Null:C1517)
					
					$o.reset()
					
					  //______________________________________________________
				: (Value type:C1509($2.variables)=Is object:K8:27)
					
					$c:=New collection:C1472
					
					For each ($t;$2.variables)
						
						$c.push(New object:C1471(\
							"key";$t;\
							"value";$2.variables[$t]))
						
					End for each 
					
					$o.environmentVariables[$c[0].key]:=$2.variables[$c[0].key]
					
					  //______________________________________________________
				: (Value type:C1509($2.variables)=Is collection:K8:32)
					
					For each ($oo;$2.variables)
						
						$o.setEnvironnementVariable($oo)
						
					End for each 
					
					  //______________________________________________________
				Else 
					
					$o.success:=False:C215
					$o.errors.push("setEnvironnementVariable() method is waiting for a parameter object or collection")
					
					  //______________________________________________________
			End case 
			
			  //______________________________________________________
		: ($1="$escape")
			
			$o:=New object:C1471(\
				"value";$2.in)
			
			If (Length:C16($2.in)=0)\
				 | ($2.in="'@'")\
				 | ($2.in="\"@\"")
				
				  // <EMPTY OR QUOTED>
				
			Else 
				
				If (Is macOS:C1572)
					
					  // Metacharacters to escape
					$c:=Split string:C1554("\"#%&'=~<>;`]!";"")\
						.push("\\\\")\
						.push("\\|")\
						.push("\\$")\
						.push("\\(")\
						.push("\\)")\
						.push("\\[")\
						.push("\\?")\
						.push("\\*")\
						.push("\\s")
					
					$pattern:="(?mi-s)(?:^'.*'$)|(?<!-.)({char})(?!(?:[-|]|grep))"
					
					For each ($t;$c)
						
						$text:=$2.in
						$o.value:=""
						
						Repeat 
							
							$b:=Match regex:C1019(Replace string:C233($pattern;"{char}";$t);$text;1;$pos;$len)
							
							If ($b)
								
								If ($len#0)
									
									$o.value:=$o.value+Substring:C12($text;1;$pos-1)+"\\"+Substring:C12($text;$pos;1)
									$text:=Substring:C12($text;$pos+$len)
									
								Else 
									
									$o.value:=$o.value+Substring:C12($text;1;$pos-1)+Substring:C12($text;$pos;1)
									$text:=Substring:C12($text;$pos+1)
									
								End if 
							End if 
						Until (Not:C34($b))
						
						$o.value:=$o.value+$text
						
					End for each 
					
				Else 
					
					  //#TO_TEST
					
					$Txt_metaCharacters:="&|<>()%^\" "
					
					$text:=$2.in
					
					For ($i;1;Length:C16($Txt_metaCharacters);1)
						
						$t:=Substring:C12($Txt_metaCharacters;$i;1)
						
						If ((Position:C15($t;$text)#0))
							
							If ($text[[Length:C16($text)]]="\\")
								
								$o.value:="\""+$text+"\\\""
								
							Else 
								
								  // Quote
								$o.value:="\""+$text+"\""
								
							End if 
							
							$i:=MAXLONG:K35:2
							
						End if 
					End for 
				End if 
			End if 
			
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