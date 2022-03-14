//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705()
	
	This:C1470.home:=Folder:C1567(Split string:C1554(Folder:C1567(fk desktop folder:K87:19).path; "/").resize(3).join("/"))
	
	This:C1470.reset()
	
	//MARK:- 📌 COMPUTED ATTRIBUTES
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// The time spend in millisecondes since the last countTimeInit() call
Function get timeSpent()->$duration : Integer
	
	$duration:=Milliseconds:C459-This:C1470.startTime
	
	//MARK:- 📌 FUNCTIONS
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Restores the initial values of the class
Function reset()->$this : cs:C1710.lep
	
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
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Initialization of the counting of the time spent
Function countTimeInit()
	
	This:C1470.startTime:=Milliseconds:C459
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Pause current process if the condition is true, in any case returns the time spent. 
Function delay($condition : Boolean; $delay : Integer)->$duration : Integer
	
	If ($condition)
		
		IDLE:C311
		DELAY PROCESS:C323(Current process:C322; $delay=0 ? 60 : $delay)
		
	End if 
	
	$duration:=This:C1470.timeSpent
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setCharSet($charset : Text)->$this : cs:C1710.lep
	
	This:C1470.charSet:=$charset="" ? "UTF-8" : $charset
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setOutputType($outputType : Integer)->$this : cs:C1710.lep
	
	This:C1470.outputType:=$outputType=0 ? Is text:K8:3 : $outputType
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setEnvironnementVariable($variables; $value : Text)->$this : cs:C1710.lep
	
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
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Execute the external process in asynchronous mode then restore the default synchronous mode
Function launchAsync($command; $arguments : Variant)->$this : cs:C1710.lep
	
	This:C1470.asynchronous()
	
	If (Count parameters:C259>=2)
		
		$this:=This:C1470.launch($command; $arguments)
		
	Else 
		
		$this:=This:C1470.launch($command)
		
	End if 
	
	This:C1470.synchronous()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function launch($command; $arguments : Variant)->$this : cs:C1710.lep
	
	var $inputStream; $outputStream : Blob
	var $errorStream; $t : Text
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
		
		$t:=$errorStream
		CLEAR VARIABLE:C89($errorStream)
		
	Else 
		
		If (BLOB size:C605($outputStream)>0)  // Else OK is reset to 0
			
			$t:=Convert to text:C1012($outputStream; This:C1470.charSet)
			
		Else 
			
			CLEAR VARIABLE:C89($t)
			
		End if 
	End if 
	
	$t:=This:C1470._cleanupStream($t)
	
	If (Length:C16($errorStream)=0)
		
		If (Not:C34(This:C1470.resultInErrorStream))
			
			// ⚠️ Some commands return the error in the output stream
			
			If (Position:C15("ERROR"; $t; *)=1)\
				 | (Position:C15("FAILED"; $t; *)=1)\
				 | (Position:C15("Failure"; $t; *)=1)
				
				$errorStream:=$t
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
				
				This:C1470.outputStream:=$t
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is object:K8:27)
				
				If (Length:C16($t)>0)
					
					This:C1470.success:=(Match regex:C1019("(?si-m)^(?:\\{.*\\})|(?:^\\[.*\\])$"; $t; 1))
					
				End if 
				
				If (This:C1470.success)
					
					This:C1470.outputStream:=JSON Parse:C1218($t)
					
				Else 
					
					This:C1470.errorStream:=$t
					
				End if 
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is collection:K8:32)
				
				This:C1470.outputStream:=Split string:C1554($t; "\n")
				
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
				
				This:C1470.outputStream:=$outputStream  // Blob
				
				//……………………………………………………………………
		End case 
		
	Else 
		
		This:C1470.pid:=0
		This:C1470.outputStream:=$t
		This:C1470.errorStream:=This:C1470._cleanupStream($errorStream)
		This:C1470._pushError(This:C1470.errorStream)
		
	End if 
	
	If (This:C1470.debug)
		
		This:C1470._log()
		
	End if 
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Execute the external process in synchronous mode
	// ⚠️ Must be call before .launch()
Function synchronous($mode : Boolean)->$this : cs:C1710.lep
	
	This:C1470.setEnvironnementVariable("asynchronous"; (Count parameters:C259>=1) ? ($mode ? "true" : "false") : "true")
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Execute the external process in asynchronous mode
	// ⚠️ Must be call before .launch()
Function asynchronous($mode : Boolean)->$this : cs:C1710.lep
	
	This:C1470.setEnvironnementVariable("asynchronous"; (Count parameters:C259>=1) ? ($mode ? "false" : "true") : "false")
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setDirectory($folder : 4D:C1709.Folder)->$this : cs:C1710.lep
	
	This:C1470.environmentVariables["_4D_OPTION_CURRENT_DIRECTORY"]:=Count parameters:C259>=1 ? $folder.platformPath : ""
	This:C1470.success:=True:C214
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function showConsole()->$this : cs:C1710.lep
	
	This:C1470.environmentVariables["_4D_OPTION_HIDE_CONSOLE"]:="false"
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function hideConsole()->$this : cs:C1710.lep
	
	This:C1470.environmentVariables["_4D_OPTION_HIDE_CONSOLE"]:="true"
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns an object containing all the environment variables
Function getEnvironnementVariables()->$variables : Object
	
	var $c : Collection
	var $t : Text
	
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
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the content of an environment variable from its name
Function getEnvironnementVariable($name : Text; $nonDiacritic : Boolean)->$value : Text
	
	var $o : Object
	var $t : Text
	var $isDiacritic : Boolean
	
	This:C1470.success:=Count parameters:C259>=1
	
	If (This:C1470.success)
		
		$isDiacritic:=True:C214
		
		If (Count parameters:C259>=2)
			
			$isDiacritic:=$nonDiacritic
			
		End if 
		
		$t:=This:C1470._shortcut($name)
		
		If ($isDiacritic)
			
			If (This:C1470.environmentVariables[$t]#Null:C1517)
				
				$value:=This:C1470.environmentVariables[$t]
				
			Else 
				
				$o:=This:C1470.getEnvironnementVariables()
				This:C1470.success:=$o[$name]#Null:C1517
				
				If (This:C1470.success)
					
					$value:=$o[$name]
					
				Else 
					
					This:C1470.errors.push("Variable \""+$name+"\" not found")
					
				End if 
			End if 
			
		Else 
			
			$o:=OB Entries:C1720(This:C1470.environmentVariables).query("key = :1"; $t).pop()
			
			If ($o=Null:C1517)
				
				$o:=OB Entries:C1720(This:C1470.getEnvironnementVariables()).query("key = :1"; $t).pop()
				
			End if 
			
			If ($o#Null:C1517)
				
				$value:=$o.value
				
			End if 
		End if 
		
	Else 
		
		This:C1470.errors.push("Missing variable name parameter")
		
	End if 
	
	//MARK:- 🛠 Tools
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
Function singleQuoted($string : Text)->$quoted : Text
	
	$quoted:=Choose:C955(Match regex:C1019("^'.*'$"; $string; 1); $string; "'"+$string+"'")  // Already done // Do it
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the string between quotes
Function quoted($string : Text)->$quoted : Text
	
	If (Match regex:C1019("^\".*\"$"; $string; 1))
		
		$quoted:=$string  // Already done
		
	Else 
		
		$quoted:="\""+$string+"\""  // Do it
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Compare two string version
	// -  0 if the version and the reference are equal
	// -  1 if the version is higher than the reference
	// - -1 if the version is lower than the reference
Function versionCompare($current : Text; $reference : Text; $separator : Text)->$result : Integer
	
	var $sep : Text
	var $i : Integer
	var $c1; $c2 : Collection
	
	ASSERT:C1129(Count parameters:C259>=2)
	
	$sep:="."  // Default separator
	
	If (Count parameters:C259>=3)
		
		$sep:=$separator
		
	End if 
	
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
				
				$result:=1
				$i:=MAXLONG:K35:2-1  // Break
				
				//______________________________________________________
			: (Num:C11($c1[$i])<Num:C11($c2[$i]))
				
				$result:=-1
				$i:=MAXLONG:K35:2-1  // Break
				
				//______________________________________________________
			Else 
				
				// Go on
				
				//______________________________________________________
		End case 
	End for 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Set write accesses to a file or a directory with all its subfolders and files
Function makeWritable($cible : 4D:C1709.Document)->$this : cs:C1710.lep
	
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
	
	$this:=This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//Set write accesses to a directory with all its sub-folders and files
Function unlockDirectory($cible : 4D:C1709.Folder)->$this : cs:C1710.lep
	
	If (Bool:C1537($cible.exists))
		
		If ($cible.isFolder)
			
			This:C1470.setEnvironnementVariable("directory"; $cible.platformPath)
			
			If (Is Windows:C1573)
				
				This:C1470.launch("attrib.exe -R /D /S")
				
			Else 
				
				This:C1470.launch("chmod -R u+rwX "+This:C1470.singleQuoted($cible.path))
				
			End if 
			
		Else 
			
			This:C1470._pushError($cible.path+" is not a directory!")
			
		End if 
		
	Else 
		
		This:C1470._pushError("Invalid pathname: "+String:C10($cible.path))
		
	End if 
	
	$this:=This:C1470
	
	//MARK:- 📌 PRIVATES
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Remove unnecessary carriage returns and line breaks from the error/output stream
Function _cleanupStream($textToCleanUp : Text)->$cleaned : Text
	
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
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _shortcut($string : Text)->$variable : Text
	
	Case of   // Shortcuts
			
			//…………………………………………………………………………………………
		: ($string="directory")\
			 | ($string="currentDirectory")
			
			$variable:="_4D_OPTION_CURRENT_DIRECTORY"
			
			//…………………………………………………………………………………………
		: ($string="asynchronous")\
			 | ($string="non-blocking")
			
			$variable:="_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"
			
			//…………………………………………………………………………………………
		: ($string="console")\
			 | ($string="hideConsole")
			
			$variable:="_4D_OPTION_HIDE_CONSOLE"
			
			//…………………………………………………………………………………………
		Else 
			
			$variable:=$string
			
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