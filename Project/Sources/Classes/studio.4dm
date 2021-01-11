Class extends tools

Class constructor($useDefaultPath : Boolean)
	
	Super:C1705()
	
	This:C1470.macOS:=Is macOS:C1572
	This:C1470.window:=Is Windows:C1573
	
	If (Count parameters:C259>=1)
		
		This:C1470.path($useDefaultPath)
		
	Else 
		
		This:C1470.path()
		
	End if 
	
	If (This:C1470.success)
		
		This:C1470.version:=This:C1470.getVersion()
		
	End if 
	
	//====================================================================
	// Populate Application with the default path
Function defaultPath()
	
	var $folder : 4D:C1709.Folder
	
	If (This:C1470.macOS)
		
		$folder:=Folder:C1567("/Applications/Android Studio.app")
		
	Else 
		
		//$folder:=Folder("/Applications/Xcode.app")
		
	End if 
	
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
	// If not exist one of the path found by spotlight. The last version.
Function path($useDefaultPath : Boolean)
	
	var $found; $useDefault : Boolean
	var $folder : 4D:C1709.Folder
	
	If (Count parameters:C259>=1)
		
		$useDefault:=$1
		
	End if 
	
	This:C1470.defaultPath()
	
	$found:=(This:C1470.success & $useDefault)
	
	If (Not:C34($found))
		
		This:C1470.lastPath()
		
		If (This:C1470.success)
			
			
			
		End if 
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
			
			$version:=This:C1470.getVersion(Folder:C1567($pathname))
			
			If (This:C1470.versionCompare($version; $t)>=0)  // Equal or higher
				
				$t:=$version
				This:C1470.version:=$version
				This:C1470.application:=Folder:C1567($pathname)
				This:C1470.success:=True:C214
				
			End if 
		End for each 
	End if 
	
	//====================================================================
	// Get all installed Android Studio applications using Spotlight
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
		
		$directory:=This:C1470.application
		
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
	