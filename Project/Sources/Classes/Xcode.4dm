Class extends tools

Class constructor
	var $1 : Boolean
	
	Super:C1705()
	
	This:C1470.success:=Is macOS:C1572
	
	If (This:C1470.success)
		
		If (Count parameters:C259>=1)
			
			This:C1470.path($1)
			
		Else 
			
			This:C1470.path()
			
		End if 
		
		If (This:C1470.success)
			
			This:C1470.version:=This:C1470.version()
			This:C1470.toolsPath()
			
		End if 
		
	Else 
		
		This:C1470.lastError:="Xcode is not available on this platform"
		This:C1470.errors.push(This:C1470.lastError)
		
	End if 
	
	//====================================================================
	// Populate Application with the default path
Function defaultPath
	
	var $folder : 4D:C1709.Directory
	
	$folder:=Folder:C1567("/Applications/Xcode.app")
	
	This:C1470.success:=$folder.exists
	
	If (This:C1470.success)
		
		This:C1470.application:=$folder
		
	End if 
	
	//====================================================================
	// Test if the current path is the default path
Function isDefaultPath
	var $0 : Boolean
	
	$0:=(This:C1470.application.path=Folder:C1567("/Applications/Xcode.app").path)
	
	//====================================================================
	// Return by default the default path,
	// If not exist the tool path,
	// If not exist one of the path found by spotlight. The last version.
Function path
	var $1 : Boolean  // Use default path
	
	var $found; $useDefaultPath : Boolean
	
	var $folder : 4D:C1709.Directory
	
	If (Count parameters:C259>=1)
		
		$useDefaultPath:=$1
		
	End if 
	
	This:C1470.defaultPath()
	
	$found:=(This:C1470.success & $useDefaultPath)
	
	If (Not:C34($found))
		
		This:C1470.toolsPath()
		
		If (This:C1470.success)
			
			$folder:=This:C1470.tools.parent.parent
			
			If (This:C1470.application.path=$folder.path)
				
				This:C1470.application:=$folder
				$found:=True:C214
				
			End if 
		End if 
	End if 
	
	If (Not:C34($found))
		
		This:C1470.lastPath()
		
	End if 
	
	//====================================================================
Function toolsPath
	var $o : Object
	
	$o:=This:C1470.lep("xcode-select --print-path")
	
	This:C1470.success:=$o.success
	
	If (This:C1470.success)
		
		This:C1470.tools:=Folder:C1567(Replace string:C233($o.out; "\n"; ""))
		This:C1470.success:=This:C1470.tools.exists
		
	Else 
		
		This:C1470.lastError:=$o.error
		This:C1470.errors.push($o.error)
		
	End if 
	
	//====================================================================
Function lastPath
	var $pathname; $t; $version : Text
	var $o : Object
	var $c : Collection
	
	$c:=This:C1470.paths()
	
	If (This:C1470.success)
		
		This:C1470.success:=False:C215
		
		For each ($pathname; $c)
			
			$version:=This:C1470.version(Folder:C1567($pathname))
			
			If (This:C1470.versionCompare($version; $t)>=0)  // Equal or higher
				
				$t:=$version
				This:C1470.version:=$version
				This:C1470.application:=Folder:C1567($pathname)
				This:C1470.success:=True:C214
				
			End if 
		End for each 
	End if 
	
	//====================================================================
	// Get all installed Xcode applications using Spotlight
Function paths
	var $0 : Collection
	
	var $pos : Integer
	var $o : Object
	
	$o:=This:C1470.lep("mdfind \"kMDItemCFBundleIdentifier == 'com.apple.dt.Xcode'\"")
	
	This:C1470.success:=$o.success
	
	If (This:C1470.success)
		
		$0:=Split string:C1554($o.out; "\n"; sk ignore empty strings:K86:1)
		
	Else 
		
		This:C1470.lastError:=Choose:C955(Length:C16($o.error)=0; "No Xcode installed"; $o.error)
		
	End if 
	
	//====================================================================
Function version
	var $0 : Text
	var $1 : 4D:C1709.Directory
	
	var $o : Object
	
	var $directory : 4D:C1709.Directory
	
	If (Count parameters:C259>=1)
		
		$directory:=$1
		
	Else 
		
		$directory:=This:C1470.application
		
	End if 
	
	$o:=This:C1470.lep("defaults read"+" '"+$directory.file("Contents/Info.plist").path+"' CFBundleShortVersionString")
	
	If ($o.success)
		
		$0:=$o.out
		
	End if 
	
	//====================================================================
	// Returns True if the version of Xcode is equal or superior to the desired one
Function checkVersion
	var $0 : Boolean
	var $1 : Text
	
	$0:=(This:C1470.versionCompare(This:C1470.version; $1)>=0)
	
	//====================================================================
	// Check if any First Launch tasks need to be performed.
Function checkFirstLaunchStatus
	var $0 : Boolean
	
	var $o : Object
	
	$o:=This:C1470.lep(This:C1470.singleQuoted(Folder:C1567(Folder:C1567("/RESOURCES/scripts").platformPath; fk platform path:K87:2).file("echoStatus").path); "xcodebuild -checkFirstLaunchStatus")
	
	If ($o.success)
		
		$0:=($o.out="0")  // Success even if there is some error logs. Only check status.
		
	End if 
	
	//====================================================================
Function setToolPath
	var $o : Object
	
	SET ENVIRONMENT VARIABLE:C812("SUDO_ASKPASS_TITLE"; str.setText("4dMobileWantsToMakeChanges").localized("4dProductName"))
	SET ENVIRONMENT VARIABLE:C812("SUDO_ASKPASS_MESSAGE"; Get localized string:C991("enterYourPasswordToAllowThis"))
	SET ENVIRONMENT VARIABLE:C812("SUDO_ASKPASS"; Folder:C1567(Folder:C1567("/RESOURCES/scripts").platformPath; fk platform path:K87:2).file("sudo-askpass").path)
	
	$o:=This:C1470.lep("sudo -A /usr/bin/xcode-select -s "+This:C1470.singleQuoted(This:C1470.application.path))
	
	If ($o.success)
		
		If (Length:C16($o.error)>0)
			
			This:C1470.lastError:=$o.error
			This:C1470.errors.push(This:C1470.lastError)
			
			This:C1470.success:=False:C215
			
		Else 
			
			This:C1470.toolsPath()
			
		End if 
	End if 
	
	//====================================================================
Function open
	var $1 : 4D:C1709.Directory
	
	var $o : Object
	
	If (Count parameters:C259>=1)  // Open workspace or project
		
		$o:=$1.folders().query("extension = .xcworkspace").pop()
		
		If ($o=Null:C1517)
			
			$o:=$1.folders().query("extension = .xcodeproj").pop()
			
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
		
		This:C1470.success:=False:C215
		This:C1470.lastError:=Choose:C955(Length:C16(String:C10($o.error))>0; String:C10($o.error); "Unknown error")
		This:C1470.errors.push(This:C1470.lastError)
		
	End if 
	
	//====================================================================
Function close
	var $1 : 4D:C1709.Directory
	
	var $cmd : Text
	var $o : Object
	
	$cmd:="/usr/bin/osascript"
	$cmd:=$cmd+" -e 'if application \"Xcode\" is running then'"
	$cmd:=$cmd+" -e 'tell application \"Xcode\"'"
	
	If (Count parameters:C259>=1)  // Close workspace or project
		
		$o:=$1.folders().query("extension = .xcworkspace").pop()
		
		If ($o=Null:C1517)
			
			$o:=$1.folders().query("extension = .xcodeproj").pop()
			
		End if 
		
		If (Bool:C1537($o.exists))
			
			$cmd:=$cmd+" -e 'close window \""+$o.fullname+"\"'"
			
		End if 
		
	Else 
		
		// Quit Xcode
		$cmd:=$cmd+" -e 'quit'"
		
	End if 
	
	$cmd:=$cmd+" -e 'end tell'"
	$cmd:=$cmd+" -e 'end if'"
	
	$o:=This:C1470.lep($cmd)
	
	//====================================================================
Function reveal
	var $1 : Text
	
	var $cmd : Text
	var $o : Object
	
	$cmd:="/usr/bin/osascript"\
		+" -e 'if application \"Xcode\" is running then'"\
		+" -e ' tell application \"Xcode\"'"\
		+" -e ' activate'"
	
	If (Count parameters:C259>=1)
		
		$cmd:=$cmd+" -e '  open file \""+$1+"\"'"
		
	End if 
	
	$cmd:=$cmd+" -e ' end tell'"\
		+" -e 'end if'"\
		+" -e 'delay 0.1'"\
		+" -e 'tell application \"System Events\"'"\
		+" -e ' tell process \"Xcode\"'"
	
	// Move focus to next area, the individual file
	$cmd:=$cmd+" -e '  keystroke \"`\" using {command down, option down}'"\
		+" -e '  delay 0.1'"
	
	// Reveal in Project Navigator
	$cmd:=$cmd+" -e '  keystroke \"j\" using {shift down, command down}'"\
		+" -e ' end tell'"\
		+" -e 'end tell'"
	
	$o:=This:C1470.lep($cmd)
	
	If ($o.success)
		
		This:C1470.success:=True:C214
		
	Else 
		
		This:C1470.success:=False:C215
		This:C1470.lastError:=Choose:C955(Length:C16(String:C10($o.error))>0; String:C10($o.error); "Unknown error")
		This:C1470.errors.push(This:C1470.lastError)
		
	End if 
	
	//====================================================================
	// Open xCode devices window
Function showDevicesWindow
	
	OPEN URL:C673("xcdevice://showDevicesWindow"; *)