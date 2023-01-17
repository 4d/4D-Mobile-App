Class extends tools

Class constructor($useDefaultPath : Boolean)
	
	Super:C1705()
	
	This:C1470.success:=Is macOS:C1572
	This:C1470.semver:=cs:C1710.semver.new()
	
	If (This:C1470.success)
		
		If (Count parameters:C259>=1)
			
			This:C1470.path($useDefaultPath)
			
		Else 
			
			This:C1470.path()
			
		End if 
		
		If (This:C1470.success)
			
			This:C1470.version:=This:C1470.getVersion()
			
		End if 
		
	Else 
		
		This:C1470._pushError("Xcode is not yet available on this platform")
		
	End if 
	
	//====================================================================
Function getRequirements()
	
	var $ETag : Text
	var $run : Boolean
	var $content : Object
	var $requirement : 4D:C1709.File
	var $http : cs:C1710.http
	
	$requirement:=cs:C1710.path.new().preferences("requirements.json")
	
	If ($requirement.exists)
		
		$run:=($requirement.modificationDate<Current date:C33)
		
	Else 
		
		// Use the embedded file
		File:C1566("/RESOURCES/requirements.json").copyTo(cs:C1710.path.new().preferences())
		$run:=True:C214
		
	End if 
	
	$content:=JSON Parse:C1218($requirement.getText())
	
	If ($run)
		
		$http:=cs:C1710.http.new("https://4d-go-mobile.github.io/sdk/xcode.json").setResponseType(Is a document:K24:1; $requirement)
		
		$content:=JSON Parse:C1218($requirement.getText())
		$ETag:=String:C10($content.Etag)
		
		If (Length:C16($ETag)#0)
			
			$run:=$http.newerRelease($ETag)
			$run:=$run & ($http.status=200)
			
			If (Not:C34($run))
				
				// Fix the date of the last check
				$requirement.setText(JSON Stringify:C1217($content; *))
				
			End if 
		End if 
	End if 
	
	If ($run)
		
		$http.get()
		
		If ($http.success)
			
			$content:=JSON Parse:C1218($requirement.getText())
			$content.Etag:=String:C10($http.headers.query("name = ETag").pop().value)
			$requirement.setText(JSON Stringify:C1217($content; *))
			
			If (Structure file:C489=Structure file:C489(*))
				
				// Update the embedded file
				$requirement.copyTo(Folder:C1567(fk resources folder:K87:11); fk overwrite:K87:5)
				
			End if 
		End if 
	End if 
	
	var $versionKey : Text
	$versionKey:=Choose:C955(Application version:C493(*)[[1]]="A"; ""; Application version:C493)
	
	If ($content[$versionKey]#Null:C1517)
		
		This:C1470.requirement:=$content[$versionKey].xcode
		
	Else   // Fallback to default main version if not defined
		
		This:C1470.requirement:=$content[""].xcode
		
	End if 
	
	//====================================================================
	// Populate Application with the default path
Function defaultPath()
	
	var $folder : 4D:C1709.Folder
	
	$folder:=Folder:C1567("/Applications/Xcode.app")
	
	This:C1470.success:=$folder.exists
	
	If (This:C1470.success)
		
		This:C1470.application:=$folder
		
	End if 
	
	//====================================================================
	// Test if the current path is the default path
Function isDefaultPath()->$isDefault : Boolean
	
	$isDefault:=(This:C1470.application.path=Folder:C1567("/Applications/Xcode.app").path)
	
	//====================================================================
	// Return by default the default path,
	// If not exist the tool path,
	// If not exist one of the path found by spotlight. The last version.
Function path($useDefaultPath : Boolean)
	
	var $found; $useDefault : Boolean
	var $folder : 4D:C1709.Folder
	
	If (Count parameters:C259>=1)
		
		$useDefault:=$useDefaultPath
		
	End if 
	
	This:C1470.defaultPath()
	
	$found:=(This:C1470.success & $useDefault)
	
	If (Not:C34($found))
		
		This:C1470.toolsPath()
		
		// ⚠️ The tools are not necessarily in the XCode package
		$found:=This:C1470.success\
			 & (This:C1470.tools.parent.parent.extension=".app")\
			 & (This:C1470.tools.parent.parent.isPackage)
		
		If ($found)
			
			This:C1470.application:=This:C1470.tools.parent.parent
			
		End if 
	End if 
	
	If (Not:C34($found))
		
		This:C1470.lastPath()
		
		If (This:C1470.success)
			
			This:C1470.tools:=This:C1470.application.folder("Contents/Developer")
			
		End if 
	End if 
	
	//====================================================================
	// If more than one instance of Xcode is available,
	// select the best one according to the desired version.
Function checkRequiredVersion($version : Text)
	
	var $range : Object
	$range:=This:C1470.semver.range($version)
	
	var $instances : Collection
	$instances:=New collection:C1472
	
	var $file : 4D:C1709.File
	var $pathname; $vers : Text
	
	For each ($pathname; This:C1470.paths())
		
		$file:=Folder:C1567($pathname).file("Contents/version.plist")
		
		If ($file.exists)
			
			$vers:=String:C10($file.getAppInfo().CFBundleShortVersionString)
			
			If (Length:C16($vers)#0)
				
				If ($range.satisfiedBy($vers))
					
					$instances.push(New object:C1471(\
						"version"; $vers; \
						"pathname"; $pathname))
					
				End if 
			End if 
		End if 
	End for each 
	
	This:C1470.success:=($instances.length>0)
	
	If (This:C1470.success)
		
		// Keep the best one
		$instances:=$instances.orderBy("version desc")
		
		CLEAR VARIABLE:C89($pathname)
		
		If (This:C1470.application#Null:C1517)
			
			$pathname:=String:C10(This:C1470.application.path)
			
		End if 
		
		var $currentInstances : Collection
		$currentInstances:=$instances.filter(Formula:C1597(col_formula).source; Formula:C1597($1.result:=(($1.value.version=$instances[0].version) & (($1.value.pathname+"/")=$pathname))))
		
		If ($currentInstances.length=1)
			
			// Already a correct version with same value on current path, no need to ask
			// This could happen if you two instance of macOS installed on two partitions
			
		Else 
			
			This:C1470.setPath($instances[0].pathname; $instances[0].version)
			
		End if 
	End if 
	
	//====================================================================
	// Returns True if the version of Xcode is equal or superior to the desired one
Function checkMinimumVersion($version : Text)->$ok : Boolean
	
	$ok:=(This:C1470.versionCompare($version)>=0)
	
	//====================================================================
	// Returns True if the version of Xcode is equal or superior to the desired one
Function checkMaximumVersion($version : Text)->$ok : Boolean
	
	$ok:=(This:C1470.versionCompare($version)#1)
	
	//====================================================================
	// Sets the applicatiion
	// To the given pathname (POSIX)
	// & update the version
Function setPath($pathname : Text; $version : Text)
	
	var $folder : 4D:C1709.Folder
	
	$folder:=Folder:C1567($pathname)
	
	This:C1470.success:=$folder.exists
	
	If (This:C1470.success)
		
		This:C1470.application:=$folder
		
		If (Count parameters:C259>=1)
			
			This:C1470.version:=$version
			
		Else 
			
			This:C1470.version:=This:C1470.getVersion()
			
		End if 
	End if 
	
	//====================================================================
	// Sets the active developer directory
	// To the given pathname (POSIX)
	// To "This.application.path" pathname if ommited
Function switch($title : Text)
	
	If (Count parameters:C259>=1)
		
		This:C1470._sudoAskPass("/usr/bin/xcode-select --switch  "+This:C1470.quoted(This:C1470.application.path); $title)
		
	Else 
		
		This:C1470._sudoAskPass("/usr/bin/xcode-select --switch  "+This:C1470.quoted(This:C1470.application.path))
		
	End if 
	
	//====================================================================
	// Update the .tools property
Function toolsPath
	var $o : Object
	
	$o:=This:C1470.lep("xcode-select --print-path")
	
	This:C1470.success:=$o.success
	
	If (This:C1470.success)\
		 & (Length:C16($o.out)>0)
		
		This:C1470.tools:=Folder:C1567($o.out)
		This:C1470.success:=This:C1470.tools.exists
		
	Else 
		
		This:C1470._pushError($o.error)
		
	End if 
	
	//====================================================================
Function lastPath
	
	var $pathname; $t; $version : Text
	var $o : Object
	var $c : Collection
	
	$c:=This:C1470.paths()
	
	If (This:C1470.success)
		
		This:C1470.success:=False:C215
		
		// Get the highest version available
		For each ($pathname; $c)
			
			$version:=This:C1470.getVersion(Folder:C1567($pathname))
			
			If (Length:C16($t)=0) || (This:C1470.versionCompare($t; $version)>=0)  // Equal or higher 
				
				$t:=$version
				
				This:C1470.version:=$version
				This:C1470.application:=Folder:C1567($pathname)
				This:C1470.success:=True:C214
				
			End if 
		End for each 
	End if 
	
	//====================================================================
	// Get all installed Xcode applications using Spotlight
Function paths()->$instances : Collection
	
	var $pos : Integer
	var $o : Object
	
	$o:=This:C1470.lep("mdfind \"kMDItemCFBundleIdentifier == 'com.apple.dt.Xcode'\"")
	
	This:C1470.success:=$o.success
	
	If (This:C1470.success)
		
		$instances:=Split string:C1554($o.out; "\n"; sk ignore empty strings:K86:1)
		
		// Maybe current working path in not indexed by spotlight, so add it
		If (This:C1470.application#Null:C1517)\
			 && (This:C1470.application.exists)\
			 && ($instances.indexOf(This:C1470.application.path)<0)
			
			$instances.push(This:C1470.application.path)
			
		End if 
		
	Else 
		
		This:C1470._pushError(Choose:C955(Length:C16($o.error)=0; "No Xcode installed"; $o.error))
		
	End if 
	
	//====================================================================
Function getVersion($target : 4D:C1709.Folder) : Text
	
	var $o : Object
	var $file : 4D:C1709.File
	var $directory : 4D:C1709.Folder
	
	If (Count parameters:C259>=1)
		
		$directory:=$target
		
	Else 
		
		$directory:=This:C1470.application
		
	End if 
	
	$file:=$directory.file("Contents/Info.plist")
	
	If ($file.exists)
		
		//defaults [-currentHost | -host hostname] read [domain [key]]
		$o:=This:C1470.lep("defaults read"+" '"+$file.path+"' CFBundleShortVersionString")
		
		If ($o.success)
			
			return $o.out
			
		End if 
	End if 
	
	//====================================================================
	// Check if any First Launch tasks need to be performed.
Function checkFirstLaunchStatus()->$status : Boolean
	
	var $o : Object
	
	$o:=This:C1470.lep(This:C1470.singleQuoted(Folder:C1567(Folder:C1567("/RESOURCES/scripts").platformPath; fk platform path:K87:2).file("echoStatus").path); "xcodebuild -checkFirstLaunchStatus")
	
	If ($o.success)
		
		$status:=($o.out="0")  // Success even if there is some error logs. Only check status.
		
	End if 
	
	//====================================================================
Function setToolPath($title : Text)
	
	If (Count parameters:C259>=1)
		
		This:C1470._sudoAskPass("/usr/bin/xcode-select -s "+This:C1470.singleQuoted(This:C1470.application.path); $title)
		
	Else 
		
		This:C1470._sudoAskPass("/usr/bin/xcode-select -s "+This:C1470.singleQuoted(This:C1470.application.path))
		
	End if 
	
	If (This:C1470.success)
		
		This:C1470.toolsPath()
		
	End if 
	
	//====================================================================
Function installTools
	
	var $pid : Text
	var $o : Object
	
	$o:=This:C1470.lep("xcode-select --install")
	
	If ($o.success)  // wait for end of process
		
		// Get the pid
		$o:=This:C1470.lep("ps -A -x -c | grep "+This:C1470.singleQuoted("Install Command Line Developer Tools"))
		
		$pid:=Split string:C1554($o.out; "\t")[0]
		
		$o:=This:C1470.lep("ps "+String:C10($pid))
		
	End if 
	
	//====================================================================
Function open($target : 4D:C1709.Folder)
	
	var $o : Object
	
	If (Count parameters:C259>=1)  // Open workspace or project
		
		$o:=$target.folders().query("extension = .xcworkspace").pop()
		
		If ($o=Null:C1517)
			
			$o:=$target.folders().query("extension = .xcodeproj").pop()
			
		End if 
		
		If (Bool:C1537($o.exists))
			
			$o:=This:C1470.lep("open "+This:C1470.singleQuoted($o.path))
			
		End if 
		
	Else   // Open Xcode
		
		$o:=This:C1470.lep("open "+This:C1470.singleQuoted(This:C1470.application.path))
		
	End if 
	
	If (Bool:C1537($o.success))
		
		This:C1470.success:=True:C214
		
	Else 
		
		This:C1470._pushError(Choose:C955(Length:C16(String:C10($o.error))>0; String:C10($o.error); "Unknown error"))
		
	End if 
	
	//====================================================================
Function close($target : 4D:C1709.Folder)
	
	var $cmd : Text
	var $o : Object
	
	$cmd:="/usr/bin/osascript"
	$cmd+=" -e 'if application \"Xcode\" is running then'"
	$cmd+=" -e 'tell application \"Xcode\"'"
	
	If (Count parameters:C259>=1)  // Close workspace or project
		
		$o:=$target.folders().query("extension = .xcworkspace").pop()
		
		If ($o=Null:C1517)
			
			$o:=$target.folders().query("extension = .xcodeproj").pop()
			
		End if 
		
		If (Bool:C1537($o.exists))
			
			$cmd+=" -e 'close window \""+$o.fullname+"\"'"
			
		End if 
		
	Else 
		
		// Quit Xcode
		$cmd+=" -e 'quit'"
		
	End if 
	
	$cmd+=" -e 'end tell'"
	$cmd+=" -e 'end if'"
	
	$o:=This:C1470.lep($cmd)
	
	//====================================================================
Function reveal($path : Text)
	
	var $cmd : Text
	var $o : Object
	
	$cmd:="/usr/bin/osascript"\
		+" -e 'if application \"Xcode\" is running then'"\
		+" -e ' tell application \"Xcode\"'"\
		+" -e ' activate'"
	
	If (Count parameters:C259>=1)
		
		$cmd+=" -e '  open file \""+$path+"\"'"
		
	End if 
	
	$cmd+=" -e ' end tell'"\
		+" -e 'end if'"\
		+" -e 'delay 0.1'"\
		+" -e 'tell application \"System Events\"'"\
		+" -e ' tell process \"Xcode\"'"
	
	// Move focus to next area, the individual file
	$cmd+=" -e '  keystroke \"`\" using {command down, option down}'"\
		+" -e '  delay 0.1'"
	
	// Reveal in Project Navigator
	$cmd+=" -e '  keystroke \"j\" using {shift down, command down}'"\
		+" -e ' end tell'"\
		+" -e 'end tell'"
	
	$o:=This:C1470.lep($cmd)
	
	If ($o.success)
		
		This:C1470.success:=True:C214
		
	Else 
		
		This:C1470._pushError(Choose:C955(Length:C16(String:C10($o.error))>0; String:C10($o.error); "Unknown error"))
		
	End if 
	
	//====================================================================
	// Open xCode devices window
Function showDevicesWindow
	
	// OPEN URL("xcdevice://showDevicesWindow"; *)
	// OPEN URL("xcdevice://showSimulatorsWindow"; *) // ??? Where did you find that?
	
	LAUNCH EXTERNAL PROCESS:C811("open xcdevice://showDevicesWindow")
	
	//====================================================================
Function isCancelled()->$is : Boolean
	
	$is:=(Position:C15("User cancelled. (-128)"; This:C1470.lastError)>0)
	
	//====================================================================
Function isWrongPassword()->$is : Boolean
	
	$is:=(Position:C15("incorrect password attempts"; This:C1470.lastError)>0)
	
	//====================================================================
Function _sudoAskPass($cmd : Text; $title : Text)->$result : Object
	
/*
	
Normally, if sudo requires a password, it will read it from the current terminal.
	
If the -A (askpass) option is specified, a (possibly graphical) helper program
is executed to read the user's password and output the password to the standard output.
	
If the SUDO_ASKPASS environment variable is set, it specifies the path to the helper program.
	
https://apple.stackexchange.com/questions/23494/what-option-should-i-give-the-sudo-command-to-have-the-password-asked-through-a
	
*/
	
	var $script : 4D:C1709.File
	
	$script:=Folder:C1567(Folder:C1567("/RESOURCES/scripts").platformPath; fk platform path:K87:2).file("sudo-askpass")
	
	If (Asserted:C1132($script.exists; "File not found :"+$script.path))
		
		If (Count parameters:C259>=2)
			
			SET ENVIRONMENT VARIABLE:C812("SUDO_ASKPASS_TITLE"; $title)
			
		End if 
		
		SET ENVIRONMENT VARIABLE:C812("SUDO_ASKPASS_MESSAGE"; Get localized string:C991("enterYourPasswordToAllowThis"))
		SET ENVIRONMENT VARIABLE:C812("SUDO_ASKPASS"; $script.path)
		
		This:C1470.lastError:=""
		
		If ($cmd#"sudo -A @")
			
			$cmd:="sudo -A "+$cmd
			
		End if 
		
		$result:=This:C1470.lep($cmd)
		This:C1470.success:=$result.success
		
		If (This:C1470.success)
			
			If (Length:C16($result.error)>0)
				
				This:C1470._pushError($result.error)
				
			End if 
		End if 
		
	Else 
		
		This:C1470._pushError(Choose:C955(String:C10($result.error)=""; "sudo-askpass: Unknown error"; $result.error))
		
	End if 
	