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

C_LONGINT:C283($i;$l)
C_TEXT:C284($t;$Txt_arguments;$Txt_command;$Txt_error;$Txt_input;$Txt_metaCharacters)
C_TEXT:C284($Txt_output)
C_OBJECT:C1216($o;$oo)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(lep ;$0)
	C_TEXT:C284(lep ;$1)
	C_OBJECT:C1216(lep ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470._is=Null:C1517)  // Constructor
	
	If (Count parameters:C259>=1)
		
		$t:=String:C10($1)
		
	End if 
	
	$o:=New object:C1471(\
		"_is";"lep";\
		"reset";Formula:C1597(lep ("reset"));\
		"setEnvironnementVariable";Formula:C1597(lep ("setEnvironnementVariable";New object:C1471("variables";$1)));\
		"launch";Formula:C1597(lep ("launch";New object:C1471("file";$1;"arguments";$2)))\
		)
	
	$o.reset()
	
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
			$o.pid:=Null:C1517
			
			$o.environmentVariables:=New object:C1471(\
				"_4D_OPTION_CURRENT_DIRECTORY";"";\
				"_4D_OPTION_HIDE_CONSOLE";"true";\
				"_4D_OPTION_BLOCKING_EXTERNAL_PROCESS";"true"\
				)
			
			  //______________________________________________________
		: ($1="launch")
			
			$o.outputStream:=Null:C1517
			$o.command:=""
			
			If (Value type:C1509($2.file)=Is object:K8:27)
				
				$Txt_command:=$2.file.path
				
			Else 
				
				  // Path must be POSIX
				$Txt_command:=String:C10($2.file)
				
			End if 
			
			If ($2.arguments#Null:C1517)
				
				$Txt_arguments:=String:C10($2.arguments)
				
			End if 
			
			If (Is macOS:C1572)
				
				$Txt_metaCharacters:="\\!\"#$%&'()=~|<>?;*`[] "
				
				For ($i;1;Length:C16($Txt_metaCharacters);1)
					
					$t:=$Txt_metaCharacters[[$i]]
					$l:=1
					
					Repeat 
						
						$l:=Position:C15($t;$Txt_command;$l)
						
						If ($l>0)
							
							If ($Txt_command[[$l+1]]#"-")
								
								$o.command:=$o.command+Substring:C12($Txt_command;1;$l-1)+"\\"+$t
								$Txt_command:=Delete string:C232($Txt_command;1;$l)
								$l:=1
								
							Else 
								
								$l:=$l+1
								
							End if 
						End if 
					Until ($l=0)
					
					$Txt_arguments:=Replace string:C233($Txt_arguments;$t;"\\"+$t;*)
					
				End for 
				
				$o.command:=$o.command+$Txt_command
				
			Else 
				
				$o.command:=$Txt_command
				
			End if 
			
			If (Length:C16($Txt_arguments)>0)
				
				$o.command:=$o.command+" "+$Txt_arguments
				
			End if 
			
			For each ($t;$o.environmentVariables)
				
				SET ENVIRONMENT VARIABLE:C812($t;String:C10($o.environmentVariables[$t]))
				
			End for each 
			
			LAUNCH EXTERNAL PROCESS:C811($o.command;$Txt_input;$Txt_output;$Txt_error)
			
			$o.success:=Bool:C1537(OK)
			
			If ($o.success)
				
				$o.outputStream:=$Txt_output
				
			Else 
				
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