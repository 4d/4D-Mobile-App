Class extends tools

Class constructor($useDefaultPath : Boolean)
	
	Super:C1705()
	
	This:C1470.macOS:=Is macOS:C1572
	This:C1470.window:=Is Windows:C1573
	This:C1470.exe:=Null:C1517
	
	If (Count parameters:C259>=1)
		
		This:C1470.path($useDefaultPath)
		
	Else 
		
		This:C1470.path()
		
	End if 
	
	If (This:C1470.success)
		
		This:C1470.version:=This:C1470.getVersion()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Return by default the default path,
	// If not exist one of the path found by spotlight(on macOS). The last version.
Function path($useDefaultPath : Boolean)
	
	var $found; $default : Boolean
	var $folder : 4D:C1709.Folder
	
	If (Count parameters:C259>=1)
		
		$default:=$1
		
	End if 
	
	This:C1470.defaultPath()
	
	If (This:C1470.exe=Null:C1517) & Not:C34($default)
		
		This:C1470.lastPath()
		
		If (This:C1470.success)
			
			
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Populate Application with the default path
Function defaultPath()
	
	var $exe : Object
	
	This:C1470.exe:=Null:C1517
	
	If (This:C1470.macOS)
		
		$exe:=Folder:C1567("/Applications/Android Studio.app")
		
	Else 
		
		$exe:=File:C1566("C:\\Program Files\\Android\\Android Studio\\studio.exe")
		
	End if 
	
	This:C1470.success:=$exe.exists
	
	If (This:C1470.success)
		
		This:C1470.exe:=$exe
		
	Else 
		
		This:C1470.exe:=Null:C1517
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function lastPath
	var $pathname; $t; $version : Text
	var $o : Object
	var $c : Collection
	
	$c:=This:C1470.paths()
	
	If (This:C1470.success)
		
		This:C1470.success:=False:C215
		
		For each ($pathname; $c)
			
			$version:=This:C1470.getVersion(Folder:C1567($pathname))
			
			If (This:C1470.versionCompare($version; $t)>=0)  // Equal or higher
				
				$t:=$version
				This:C1470.version:=$version
				This:C1470.exe:=Folder:C1567($pathname)
				This:C1470.success:=True:C214
				
			End if 
		End for each 
	End if 
	
	
	//====================================================================
	// Test if the current path is the default path
Function isDefaultPath()->$isDefault : Boolean
	
	If (This:C1470.macOS)
		
		$isDefault:=(This:C1470.exe.path=Folder:C1567("/Applications/Xcode.app").path)
		
	Else 
		
		$isDefault:=(This:C1470.exe.path=Folder:C1567("/Applications/Xcode.app").path)
		
	End if 
	
	//====================================================================
	// Get all installed Android Studio applications using Spotlight (on macOS)
Function paths()->$instances : Collection
	
	var $pos : Integer
	var $o : Object
	
	If (This:C1470.macOS)
		
		$o:=This:C1470.lep("mdfind \"kMDItemCFBundleIdentifier == 'com.google.android.studio'\"")
		
		This:C1470.success:=$o.success
		
		If (This:C1470.success)
			
			$instances:=Split string:C1554($o.out; "\n"; sk ignore empty strings:K86:1)
			
		Else 
			
			This:C1470.lastError:=Choose:C955(Length:C16($o.error)=0; "No Android Studio installed"; $o.error)
			
		End if 
		
	Else 
		
		This:C1470.success:=False:C215
		
	End if 
	
	//====================================================================
Function getVersion($target : 4D:C1709.Folder)->$version
	
	var $o : Object
	var $file : 4D:C1709.File
	var $directory : 4D:C1709.Folder
	
	If (Count parameters:C259>=1)
		
		$directory:=$target
		
	Else 
		
		$directory:=This:C1470.exe
		
	End if 
	
	If (This:C1470.macOS)
		
		$file:=$directory.file("Contents/Info.plist")
		This:C1470.success:=$file.exists
		
		If (This:C1470.success)
			
			$o:=This:C1470.lep("defaults read"+" '"+$file.path+"' CFBundleShortVersionString")
			
			If ($o.success)
				
				$version:=$o.out
				
			End if 
		End if 
		
	Else 
		
		This:C1470.success:=False:C215
		
	End if 
	
	//====================================================================
	// Returns True if the version of Xcode is equal or superior to the desired one
Function checkVersion($minimumVersion : Text)->$ok : Boolean
	
	If (This:C1470.macOS)
		
		$ok:=(This:C1470.versionCompare(This:C1470.version; $minimumVersion)>=0)
		
	Else 
		
		This:C1470.success:=False:C215
		
	End if 
	
Function downlod
	
	//https://developer.android.com/studio
	