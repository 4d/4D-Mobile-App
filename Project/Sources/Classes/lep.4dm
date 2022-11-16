/* #DEPENDENCIES [
   {"file":"/RESOURCES/scripts/sudo-askpass"},
   {"xliff":"lep.xlf"}
]
*/

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705()
	
	This:C1470.home:=cs:C1710.path.new().userHome()
	
	This:C1470.reset()
	
	//MARK:- 📌 COMPUTED ATTRIBUTES
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// The time spend in millisecondes since the last countTimeInit() call
Function get timeSpent() : Integer
	
	return Milliseconds:C459-This:C1470.startTime
	
	//MARK:- 📌 FUNCTIONS
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Restores the initial values of the class
Function reset() : cs:C1710.lep
	
	This:C1470.success:=True:C214
	This:C1470.errors:=New collection:C1472
	This:C1470.lastError:=""
	This:C1470.command:=Null:C1517
	This:C1470.inputStream:=Null:C1517
	This:C1470.outputStream:=Null:C1517
	This:C1470.errorStream:=""
	This:C1470.pid:=0
	
	This:C1470.resultInErrorStream:=False:C215  // Allows, if True, to reroutes stderr message to stdout
	This:C1470.debug:=Not:C34(Is compiled mode:C492)
	
	This:C1470.setCharSet()
	This:C1470.setOutputType()
	This:C1470.setEnvironnementVariable()
	
	This:C1470.countTimeInit()
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Initialization of the counting of the time spent
Function countTimeInit()
	
	This:C1470.startTime:=Milliseconds:C459
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Pause current process if the condition is true, in any case returns the time spent. 
Function delay($condition : Boolean; $delay : Integer) : Integer
	
	If ($condition)
		
		IDLE:C311
		DELAY PROCESS:C323(Current process:C322; $delay=0 ? 60 : $delay)
		
	End if 
	
	return This:C1470.timeSpent
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setCharSet($charset : Text) : cs:C1710.lep
	
	This:C1470.charSet:=$charset="" ? "UTF-8" : $charset
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setOutputType($outputType : Integer) : cs:C1710.lep
	
	This:C1470.outputType:=$outputType=0 ? Is text:K8:3 : $outputType
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setEnvironnementVariable($variables; $value : Text) : cs:C1710.lep
	
	var $v : Variant
	var $o : Object
	
	This:C1470.success:=True:C214
	
	Case of 
			
			//……………………………………………………………………
		: (Count parameters:C259=0)  // Reset to default
			
			This:C1470.environmentVariables:=New object:C1471(\
				"_4D_OPTION_CURRENT_DIRECTORY"; ""; \
				"_4D_OPTION_HIDE_CONSOLE"; "true"; \
				"_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "true"\
				)
			
			//______________________________________________________
		: (Value type:C1509($variables)=Is text:K8:3)
			
			If (Count parameters:C259>=2)
				
				This:C1470.environmentVariables[This:C1470._shortcut($variables)]:=$value
				
			Else 
				
				// Reset
				If (This:C1470._shortcut($variables)="_4D_OPTION_CURRENT_DIRECTORY")
					
					// Empty string
					This:C1470.environmentVariables[This:C1470._shortcut($variables)]:=""
					
				Else 
					
					// False is default
					This:C1470.environmentVariables[This:C1470._shortcut($variables)]:="false"
					
				End if 
			End if 
			
			//______________________________________________________
		: (Value type:C1509($variables)=Is object:K8:27)
			
			For each ($o; OB Entries:C1720($variables))
				
				If ($o.key#Null:C1517)
					
					This:C1470.environmentVariables[This:C1470._shortcut($o.key)]:=String:C10($o.value)
					
				Else 
					
					This:C1470._pushError("Missig key properties")
					
				End if 
			End for each 
			
			//______________________________________________________
		: (Value type:C1509($variables)=Is collection:K8:32)
			
			For each ($v; $variables)
				
				If (Value type:C1509($v)=Is object:K8:27)
					
					$o:=OB Entries:C1720($v).pop()
					
					If ($o.key#Null:C1517)
						
						This:C1470.environmentVariables[This:C1470._shortcut($o.key)]:=String:C10($o.value)
						
					Else 
						
						This:C1470._pushError("Missig key properties")
						
					End if 
					
				Else 
					
					This:C1470._pushError("Waiting for a collection of objects")
					
				End if 
			End for each 
			
			//______________________________________________________
		Else 
			
			This:C1470._pushError("Waiting for a parameter Text, Object or Collection")
			
			//______________________________________________________
	End case 
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Execute the external process in asynchronous mode then restore the default synchronous mode
Function launchAsync($command; $arguments : Variant) : cs:C1710.lep
	
	This:C1470.asynchronous()
	
	If (Count parameters:C259>=2)
		
		This:C1470.launch($command; $arguments)
		
	Else 
		
		This:C1470.launch($command)
		
	End if 
	
	This:C1470.synchronous()
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function launch($command; $arguments : Variant) : cs:C1710.lep
	
	var $inputStream; $outputStream : Blob
	var $errorStream; $response; $t : Text
	var $len; $pid; $pos : Integer
	
	This:C1470.outputStream:=Null:C1517
	This:C1470.errorStream:=""
	This:C1470.pid:=0
	
	If (Value type:C1509($command)=Is object:K8:27)  // File script
		
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
		End case 
	End if 
	
	If (Count parameters:C259>=2)
		
		//This.command:=This.command+" "+This.escape($arguments)
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($arguments)=Is text:K8:3)
				
				This:C1470.command:=This:C1470.command+" "+$arguments
				
				//______________________________________________________
			: (Value type:C1509($arguments)=Is collection:K8:32)
				
				This:C1470.command:=This:C1470.command+$arguments.join(" ")
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "$2 must be a text or a collection")
				
				//______________________________________________________
		End case 
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
			
			CONVERT FROM TEXT:C1011(This:C1470.inputStream; This:C1470.charSet; $inputStream)
			
			//……………………………………………………………………
		: (Value type:C1509(This:C1470.inputStream)=Is boolean:K8:9)
			
			CONVERT FROM TEXT:C1011(Choose:C955(This:C1470.inputStream; "true"; "false"); This:C1470.charSet; $inputStream)
			
			//……………………………………………………………………
		: (Value type:C1509(This:C1470.inputStream)=Is longint:K8:6)\
			 | (Value type:C1509(This:C1470)=Is integer:K8:5)\
			 | (Value type:C1509(This:C1470.inputStream)=Is integer 64 bits:K8:25)\
			 | (Value type:C1509(This:C1470.inputStream)=Is real:K8:4)
			
			CONVERT FROM TEXT:C1011(String:C10(This:C1470.inputStream; "&xml"); This:C1470.charSet; $inputStream)
			
			//……………………………………………………………………
		Else 
			
			$inputStream:=This:C1470.inputStream  // Blob
			
			//……………………………………………………………………
	End case 
	
	LAUNCH EXTERNAL PROCESS:C811(This:C1470.command; $inputStream; $outputStream; $errorStream; $pid)
	
	This:C1470.success:=Bool:C1537(OK)
	
	If (This:C1470.resultInErrorStream)
		
		$response:=$errorStream
		CLEAR VARIABLE:C89($errorStream)
		
	Else 
		
		If (BLOB size:C605($outputStream)>0)  // Else OK is reset to 0
			
			$response:=Convert to text:C1012($outputStream; This:C1470.charSet)
			
		End if 
	End if 
	
	$response:=This:C1470._cleanupStream($response)
	
	If (This:C1470.success & (Length:C16($response)>0))  // (Length($errorStream)=0)
		
		If (Not:C34(This:C1470.resultInErrorStream))
			
			// ⚠️ Some commands return the error in the output stream
			
			If (Position:C15("ERROR"; $response; *)=1)\
				 | (Position:C15("FAILED"; $response; *)=1)\
				 | (Position:C15("Failure"; $response; *)=1)
				
				$errorStream:=$response
				This:C1470.success:=False:C215
				
			End if 
		End if 
		
	Else 
		
		This:C1470.errorStream:=This:C1470._cleanupStream($errorStream)
		This:C1470._pushError(This:C1470.errorStream)
		
	End if 
	
	If (This:C1470.success)
		
		This:C1470.pid:=$pid
		
		Case of 
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is text:K8:3)
				
				This:C1470.outputStream:=$response
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is object:K8:27)
				
				If (Length:C16($response)>0)
					
					This:C1470.success:=(Match regex:C1019("(?si-m)^(?:\\{.*\\})|(?:^\\[.*\\])$"; $response; 1))
					
				End if 
				
				If (This:C1470.success)
					
					This:C1470.outputStream:=JSON Parse:C1218($response)
					
				Else 
					
					This:C1470.errorStream:=$response
					
				End if 
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is collection:K8:32)
				
				This:C1470.outputStream:=Split string:C1554($response; "\n")
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is boolean:K8:9)
				
				This:C1470.outputStream:=($response="true")
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is longint:K8:6)\
				 | (This:C1470.outputType=Is integer:K8:5)\
				 | (This:C1470.outputType=Is integer 64 bits:K8:25)\
				 | (This:C1470.outputType=Is real:K8:4)
				
				This:C1470.outputStream:=Num:C11($response)
				
				//……………………………………………………………………
			Else 
				
				This:C1470.outputStream:=$outputStream  // Blob
				
				//……………………………………………………………………
		End case 
		
	Else 
		
		This:C1470.pid:=0
		This:C1470.outputStream:=$response
		This:C1470.errorStream:=This:C1470._cleanupStream($errorStream)
		This:C1470._pushError(This:C1470.errorStream)
		
	End if 
	
	If (This:C1470.debug)
		
		This:C1470._log()
		
	End if 
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Execute the external process in synchronous mode
	// ⚠️ Must be call before .launch()
Function synchronous($mode : Boolean) : cs:C1710.lep
	
	This:C1470.setEnvironnementVariable("asynchronous"; (Count parameters:C259>=1) ? ($mode ? "true" : "false") : "true")
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Execute the external process in asynchronous mode
	// ⚠️ Must be call before .launch()
Function asynchronous($mode : Boolean) : cs:C1710.lep
	
	This:C1470.setEnvironnementVariable("asynchronous"; (Count parameters:C259>=1) ? ($mode ? "false" : "true") : "false")
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setDirectory($folder : 4D:C1709.Folder) : cs:C1710.lep
	
	This:C1470.environmentVariables["_4D_OPTION_CURRENT_DIRECTORY"]:=Count parameters:C259>=1 ? $folder.platformPath : ""
	This:C1470.success:=True:C214
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function showConsole() : cs:C1710.lep
	
	This:C1470.environmentVariables["_4D_OPTION_HIDE_CONSOLE"]:="false"
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function hideConsole() : cs:C1710.lep
	
	This:C1470.environmentVariables["_4D_OPTION_HIDE_CONSOLE"]:="true"
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns an object containing all the environment variables
Function getEnvironnementVariables() : Object
	
	var $t : Text
	var $variables : Object
	var $c : Collection
	
	This:C1470.launch(Choose:C955(Is macOS:C1572; "/usr/bin/env"; "set"))
	
	If (This:C1470.success)
		
		$variables:=New object:C1471
		
		For each ($t; Split string:C1554(This:C1470.outputStream; "\n"; sk ignore empty strings:K86:1))
			
			$c:=Split string:C1554($t; "=")
			
			If ($c.length=2)
				
				$variables[$c[0]]:=$c[1]
				
			End if 
		End for each 
		
		// Add the currents variables
		For each ($t; This:C1470.environmentVariables)
			
			If ($variables[$t]=Null:C1517)
				
				$variables[$t]:=This:C1470.environmentVariables[$t]
				
			End if 
		End for each 
	End if 
	
	return $variables
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the content of an environment variable from its name
Function getEnvironnementVariable($name : Text; $isDiacritic : Boolean) : Text
	
	var $o : Object
	
	This:C1470.success:=Count parameters:C259>=1
	
	If (This:C1470.success)
		
		$isDiacritic:=Count parameters:C259>=2 ? $isDiacritic : True:C214
		
		$name:=This:C1470._shortcut($name)
		
		If ($isDiacritic)
			
			If (This:C1470.environmentVariables[$name]#Null:C1517)
				
				return This:C1470.environmentVariables[$name]
				
			Else 
				
				$o:=This:C1470.getEnvironnementVariables()
				This:C1470.success:=$o[$name]#Null:C1517
				
				If (This:C1470.success)
					
					return $o[$name]
					
				Else 
					
					This:C1470.errors.push("Variable \""+$name+"\" not found")
					
				End if 
			End if 
			
		Else 
			
			$o:=OB Entries:C1720(This:C1470.environmentVariables).query("key = :1"; $name).pop()
			
			If ($o=Null:C1517)
				
				$o:=OB Entries:C1720(This:C1470.getEnvironnementVariables()).query("key = :1"; $name).pop()
				
			End if 
			
			return String:C10($o.value)
			
		End if 
		
	Else 
		
		This:C1470.errors.push("Missing variable name parameter")
		
	End if 
	
	//MARK:- 🛠 Tools
	//====================================================================
	// Runs a sudo command line and displays a password prompt if necessary
	// Needs file "/RESOURCES/scripts/sudo-askpass"
Function sudo($cmd : Text; $title : Text; $message : Text) : Boolean
	
	var $script : 4D:C1709.File
	
/*
	
Normally, if sudo requires a password, it will read it from the current terminal.
	
If the -A (askpass) option is specified, a (possibly graphical) helper program
is executed to read the user's password and output the password to the standard output.
	
If the SUDO_ASKPASS environment variable is set, it specifies the path to the helper program.
	
https://apple.stackexchange.com/questions/23494/what-option-should-i-give-the-sudo-command-to-have-the-password-asked-through-a
	
*/
	
	$script:=Folder:C1567(Folder:C1567("/RESOURCES/scripts").platformPath; fk platform path:K87:2).file("sudo-askpass")
	
	If ($script.exists)
		
		If (Length:C16($title)>0)
			
			SET ENVIRONMENT VARIABLE:C812("SUDO_ASKPASS_TITLE"; $title)
			
		End if 
		
		If (Length:C16($message)=0)
			
			$message:=Get localized string:C991("enterYourPasswordToAllowThis")
			$message+="Enter your password to allow this."
			
		End if 
		
		SET ENVIRONMENT VARIABLE:C812("SUDO_ASKPASS_MESSAGE"; $message)
		SET ENVIRONMENT VARIABLE:C812("SUDO_ASKPASS"; $script.path)
		
		If (Position:C15("sudo -A "; $cmd)#1)
			
			$cmd:="sudo -A "+$cmd
			
		End if 
		
		This:C1470.lastError:=""
		
		This:C1470.launch($cmd)
		
	Else 
		
		This:C1470._pushError("File not found: \""+$script.path+"\"")
		
	End if 
	
	return (This:C1470.success)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//escape special caracters for lep commands
Function escape($text : Text)->$escaped : Text
	
	var $t : Text
	
	$escaped:=$text
	
	For each ($t; Split string:C1554("\\!\"#$%&'()=~|<>?;*`[] "; ""))
		
		$escaped:=Replace string:C233($escaped; $t; "\\"+$t; *)
		
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Enclose, if necessary, the string in single quotation marks
Function singleQuoted($string : Text) : Text
	
	return Match regex:C1019("^'.*'$"; $string; 1) ? $string : "'"+$string+"'"
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the string between quotes
Function quoted($string : Text) : Text
	
	return Match regex:C1019("^\".*\"$"; $string; 1) ? $string : "\""+$string+"\""
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the string between spaces
Function betweenSpaces($string : Text) : Text
	
	return This:C1470.endsWithSpace(This:C1470.startsWithSpace($string))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function startsWithSpace($string : Text) : Text
	
	return ($string[[1]]#" ") ? " "+$string : $string
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function endsWithSpace($string : Text) : Text
	
	return ($string[[Length:C16($string)]]#" ") ? $string+" " : $string
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Compare two string version
	// -  0 if the version and the reference are equal
	// -  1 if the version is higher than the reference
	// - -1 if the version is lower than the reference
Function versionCompare($current : Text; $reference : Text; $separator : Text) : Integer
	
	var $sep : Text
	var $i : Integer
	var $c1; $c2 : Collection
	
	$sep:=Length:C16($separator)=0 ? "." : $sep  // Default is dot
	
	$c1:=Split string:C1554($current; $sep)
	$c2:=Split string:C1554($reference; $sep)
	
	Case of 
			
			//______________________________________________________
		: ($c1.length>$c2.length)
			
			$c2.resize($c1.length; "0")
			
			//______________________________________________________
		: ($c2.length>$c1.length)
			
			$c1.resize($c2.length; "0")
			
			//______________________________________________________
	End case 
	
	For ($i; 0; $c2.length-1; 1)
		
		Case of 
				
				//______________________________________________________
			: (Num:C11($c1[$i])>Num:C11($c2[$i]))
				
				return 1
				
				//______________________________________________________
			: (Num:C11($c1[$i])<Num:C11($c2[$i]))
				
				return -1
				
				//______________________________________________________
			Else 
				
				// Go on
				
				//______________________________________________________
		End case 
	End for 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Set write accesses to a file or a directory with all its subfolders and files
Function makeWritable($cible : 4D:C1709.Document) : cs:C1710.lep
	
	If (Bool:C1537($cible.exists))
		
		If (Is macOS:C1572)
			
/*
chmod [-fv] [-R [-H | -L | -P]] mode file ...
chmod [-fv] [-R [-H | -L | -P]] [-a | +a | =a] ACE file ...
chmod [-fhv] [-R [-H | -L | -P]] [-E] file ...
chmod [-fhv] [-R [-H | -L | -P]] [-C] file ...
chmod [-fhv] [-R [-H | -L | -P]] [-N] file ...
			
The generic options are as follows:
-f      Do not display a diagnostic message if chmod could not modify the
mode for file.
-H      If the -R option is specified, symbolic links on the command line
are followed.  (Symbolic links encountered in the tree traversal
are not followed by default.)
-h      If the file is a symbolic link, change the mode of the link
itself rather than the file that the link points to.
-L      If the -R option is specified, all symbolic links are followed.
-P      If the -R option is specified, no symbolic links are followed.
This is the default.
-R      Change the modes of the file hierarchies rooted in the files
instead of just the files themselves.
-v      Cause chmod to be verbose, showing filenames as the mode is modi-
fied.  If the -v flag is specified more than once, the old and
new modes of the file will also be printed, in both octal and
symbolic notation.
The -H, -L and -P options are ignored unless the -R option is specified.
In addition, these options override each other and the command's actions
are determined by the last one specified.
*/
			
			
			If ($cible.isFolder)
				
				This:C1470.launch("chmod -R u+rwX "+This:C1470.singleQuoted($cible.path))
				
			Else 
				
				This:C1470.launch("chmod u+rwX "+This:C1470.singleQuoted($cible.path))
				
			End if 
			
		Else 
			
/*
ATTRIB [+R | -R] [+A | -A ] [+S | -S] [+H | -H] [+I | -I]
       [drive:][path][filename] [/S [/D] [/L]]
			
  +   Sets an attribute.
  -   Clears an attribute.
  R   Read-only file attribute.
  A   Archive file attribute.
  S   System file attribute.
  H   Hidden file attribute.
  I   Not content indexed file attribute.
      Spécifie un ou plusieurs fichiers à traiter par attrib.
  /S  Processes matching files in the current folder and all subfolders.
  /D  Process folders as well.
  /L  Work on the attributes of the Symbolic Link versus the target of the Symbolic Link
*/
			
			If ($cible.isFolder)
				
				This:C1470.setEnvironnementVariable("directory"; $cible.platformPath)
				This:C1470.launch("attrib.exe -R /D /S")
				
			Else 
				
				This:C1470.launch("attrib.exe -R "+This:C1470.singleQuoted($cible.path))
				
			End if 
			
			
		End if 
		
	Else 
		
		This:C1470._pushError("Invalid pathname: "+String:C10($cible.path))
		
	End if 
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//Set write accesses to a directory with all its sub-folders and files
Function unlockDirectory($cible : 4D:C1709.Folder) : cs:C1710.lep
	
	If (Not:C34($cible.exists))
		
		This:C1470._pushError("Folder not found: "+String:C10($cible.path))
		return This:C1470
		
	End if 
	
	If (Not:C34($cible.isFolder))
		
		This:C1470._pushError($cible.path+" is not a directory!")
		return This:C1470
		
	End if 
	
	This:C1470.setEnvironnementVariable("directory"; $cible.platformPath)
	
	return Is Windows:C1573 ? \
		This:C1470.launch("attrib.exe -R /D /S") : \
		This:C1470.launch("chmod -R u+rwX "+This:C1470.singleQuoted($cible.path))
	
	
	//MARK:- 📌 PRIVATES
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Remove unnecessary carriage returns and line breaks from the error/output stream
Function _cleanupStream($textToCleanUp : Text) : Text
	
	var $cleaned : Text
	var $stop : Boolean
	
	$cleaned:=$textToCleanUp
	
	If (Length:C16($cleaned)>0)
		
		$cleaned:=Replace string:C233($cleaned; "\r\n"; "\n")
		
		// Remove the 1st line feeds, if any
		Repeat 
			
			If (Length:C16($cleaned)>0)
				
				If ($cleaned[[1]]="\n")
					
					$cleaned:=Substring:C12($cleaned; 2)
					
				Else 
					
					$stop:=True:C214
					
				End if 
				
			Else 
				
				$stop:=True:C214
				
			End if 
			
		Until ($stop)
		
		If (Length:C16($cleaned)>0)
			
			// Remove the last line feed, if any
			$stop:=False:C215
			
			Repeat 
				
				If (Length:C16($cleaned)>0)
					
					If ($cleaned[[Length:C16($cleaned)]]="\n")
						
						$cleaned:=Substring:C12($cleaned; 1; Length:C16($cleaned)-1)
						
					Else 
						
						$stop:=True:C214
						
					End if 
					
				Else 
					
					$stop:=True:C214
					
				End if 
				
			Until ($stop)
		End if 
	End if 
	
	return $cleaned
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _shortcut($string : Text) : Text
	
	Case of   // Shortcuts
			
			//…………………………………………………………………………………………
		: ($string="directory")\
			 | ($string="currentDirectory")
			
			return "_4D_OPTION_CURRENT_DIRECTORY"
			
			//…………………………………………………………………………………………
		: ($string="asynchronous")\
			 | ($string="non-blocking")
			
			return "_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"
			
			//…………………………………………………………………………………………
		: ($string="console")\
			 | ($string="hideConsole")
			
			return "_4D_OPTION_HIDE_CONSOLE"
			
			//…………………………………………………………………………………………
		Else 
			
			return $string
			
			//…………………………………………………………………………………………
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _pushError($message : Text)
	
	This:C1470.success:=False:C215
	
	var $c : Collection
	$c:=Get call chain:C1662
	
	var $current; $o : Object
	
	For each ($o; $c) While ($current=Null:C1517)
		
		If (Position:C15("lep."; $o.name)#1)
			
			$current:=$o
			
		End if 
	End for each 
	
	If ($current#Null:C1517)
		
		If (Length:C16($message)>0)
			
			This:C1470.lastError:=$current.name+" - "+$message
			
		Else 
			
			// Unknown error
			This:C1470.lastError:=$current.name+" - Unknown error at line "+String:C10($current.line)
			
		End if 
		
	Else 
		
		If ($c.length>0)
			
			If (Length:C16($message)>0)
				
				This:C1470.lastError:=$c[1].name+" - "+$message
				
			Else 
				
				// Unknown error
				This:C1470.lastError:=$c[1].name+" - Unknown error at line "+String:C10($c[1].line)
				
			End if 
			
		Else 
			
			This:C1470.lastError:="Unknown but annoying error"
			
		End if 
	End if 
	
	This:C1470.errors.push(This:C1470.lastError)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _log()
	
	var $current; $o : Object
	var $c; $log : Collection
	
	$log:=New collection:C1472
	
	$c:=Get call chain:C1662
	
	For each ($o; $c) While ($current=Null:C1517)
		
		If (Position:C15("lep."; $o.name)#1)
			
			$current:=$o
			break
			
		End if 
	End for each 
	
	If ($current#Null:C1517)
		
		$log.push($current.name+("()"*Num:C11(Position:C15("."; $current.name)>0)))
		$log.push("\r\rCMD:")
		
	Else 
		
		$log.push("CMD:")
		
	End if 
	
	$log.push(This:C1470.command)
	$log.push("\r\rSTATUS:")
	$log.push(Choose:C955(This:C1470.success; "success"; "failed"))
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ((Value type:C1509(This:C1470.outputStream)=Is object:K8:27)\
			 | (Value type:C1509(This:C1470.outputStream)=Is collection:K8:32))
			
			$log.push("\r\rOUTPUT:")
			$log.push(JSON Stringify:C1217(This:C1470.outputStream))
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Value type:C1509(This:C1470.outputStream)=Is boolean:K8:9)
			
			$log.push("\r\rOUTPUT:")
			$log.push(Choose:C955(This:C1470.outputStream; "true"; "false"))
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ((Value type:C1509(This:C1470.outputStream)=Is longint:K8:6)\
			 | (Value type:C1509(This:C1470.outputStream)=Is integer:K8:5)\
			 | (Value type:C1509(This:C1470.outputStream)=Is integer 64 bits:K8:25)\
			 | (Value type:C1509(This:C1470.outputStream)=Is real:K8:4))
			
			$log.push("\r\rOUTPUT:")
			$log.push(String:C10(This:C1470.outputStream))
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Else 
			
			If (Length:C16(String:C10(This:C1470.outputStream))>0)
				
				$log.push("\r\rOUTPUT:")
				$log.push(String:C10(This:C1470.outputStream))
				
			End if 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	If (Length:C16(String:C10(This:C1470.errorStream))>0)
		
		$log.push("\r\rERROR:")
		$log.push(String:C10(This:C1470.errorStream))
		
	End if 
	
	LOG EVENT:C667(Into 4D debug message:K38:5; $log.join(" "); Error message:K38:3)