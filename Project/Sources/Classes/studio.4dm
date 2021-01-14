Class extends tools

Class constructor($useDefaultPath : Boolean)
	
	Super:C1705()
	
	This:C1470.macOS:=Is macOS:C1572
	This:C1470.window:=Is Windows:C1573
	This:C1470.exe:=Null:C1517
	This:C1470.javaHome:=Null:C1517
	This:C1470.java:=Null:C1517
	This:C1470.kotlinc:=Null:C1517
	
	If (Count parameters:C259>=1)
		
		This:C1470.path($useDefaultPath)
		
	Else 
		
		This:C1470.path()
		
	End if 
	
	If (This:C1470.success)
		
		This:C1470.version:=This:C1470.getVersion()
		This:C1470.getJava()
		This:C1470.getKotlinc()
		
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
			
			//verify the tools
			
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
		
		$exe:=File:C1566("C:\\Program Files\\Android\\Android Studio\\bin\\studio.exe"; fk platform path:K87:2)
		
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
			
			If (This:C1470.macOS)
				
				//bundle
				$version:=This:C1470.getVersion(Folder:C1567($pathname))
				
			Else 
				
				$version:=This:C1470.getVersion(File:C1566($pathname; fk platform path:K87:2))
				
			End if 
			
			If (This:C1470.versionCompare($version; $t)>=0)  // Equal or higher
				
				$t:=$version
				This:C1470.version:=$version
				If (This:C1470.macOS)
					
					//bundle
					This:C1470.exe:=Folder:C1567($pathname)
					
				Else 
					
					This:C1470.exe:=File:C1566($pathname; fk platform path:K87:2)
					
				End if 
				
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
	
	var $o : Object
	var $t : Text
	var $file : 4D:C1709.File
	
	If (This:C1470.macOS)
		
		$o:=This:C1470.lep("mdfind \"kMDItemCFBundleIdentifier == 'com.google.android.studio'\"")
		
		This:C1470.success:=$o.success
		
		If (This:C1470.success)
			
			$instances:=Split string:C1554($o.out; "\n"; sk ignore empty strings:K86:1)
			
		Else 
			
			This:C1470.lastError:=Choose:C955(Length:C16($o.error)=0; "No Android Studio installed"; $o.error)
			
		End if 
		
	Else 
		
		$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file("Uninstall.txt")
		$file.delete()
		
		$o:=This:C1470.lep("reg export HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall "+$file.platformPath)
		This:C1470.success:=$o.success
		
		If (This:C1470.success)
			
			$t:=$file.getText()
			
			ARRAY LONGINT:C221($pos; 0x0000)
			ARRAY LONGINT:C221($len; 0x0000)
			This:C1470.success:=Match regex:C1019("(?m-si)\"DisplayName\"=\"Android Studio\"\\R\"DisplayVersion\"=\"(4.1)\"(?:\\R\"[^\"]*\"=\"[^\"]*\")*\\R\"DisplayIcon\"=\"([^\"]*)\""; $t; 1; $pos; $len)
			
			If (This:C1470.success)
				
				$instances:=New collection:C1472(Replace string:C233(Substring:C12($t; $pos{2}; $len{2}); "\\\\"; "\\"))
				
			End if 
		End if 
		
		If ($instances=Null:C1517)
			
			This:C1470.lastError:=Choose:C955(Length:C16($o.error)=0; "No Android Studio installed"; $o.error)
			
		End if 
	End if 
	
	//====================================================================
Function getVersion($target : 4D:C1709.Folder)->$version
	
	var $o : Object
	var $indx : Integer
	var $drive; $extension; $name; $path; $t : Text
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
			This:C1470.success:=$o.success
			
			If (This:C1470.success)
				
				$version:=$o.out
				
			End if 
		End if 
		
	Else 
		
		$indx:=Position:C15(":"; $directory.parent.platformPath)
		$drive:=Substring:C12($directory.parent.platformPath; 1; $indx)
		$path:=Replace string:C233(Substring:C12($directory.parent.platformPath; $indx+1); "\\"; "\\\\")
		$name:=$directory.name
		$extension:=Replace string:C233($directory.extension; "."; ""; 1)
		
		$o:=This:C1470.lep("wmic datafile where \"Drive='"+$drive+"' and Path='"+$path+"' and Filename='"+$name+"' and extension='"+$extension+"'\" get name,version")
		This:C1470.success:=$o.success
		
		If (This:C1470.success)
			
			$t:=$o.out
			
			ARRAY LONGINT:C221($pos; 0x0000)
			ARRAY LONGINT:C221($len; 0x0000)
			This:C1470.success:=Match regex:C1019("(?m-si)\\s(\\d+(?:\\.\\d+)*)\\s"; $t; 1; $pos; $len)
			
		End if 
		
		If (This:C1470.success)
			
			$version:=Substring:C12($t; $pos{1}; $len{1})
			
		End if 
	End if 
	
	//====================================================================
	// Returns True if the version of Xcode is equal or superior to the desired one
Function checkVersion($minimumVersion : Text)->$ok : Boolean
	
	$ok:=(This:C1470.versionCompare(This:C1470.version; $minimumVersion)>=0)
	
Function download
	
	//https://developer.android.com/studio
	
	//====================================================================
	//
Function getJava
	
	var $javaHome; $javaCmd : Object
	
	This:C1470.javaHome:=Null:C1517
	This:C1470.java:=Null:C1517
	
	If (This:C1470.exe#Null:C1517)
		
		If (This:C1470.macOS)
			
			$javaHome:=This:C1470.exe.folder("Contents/jre/jdk/Contents/Home")
			
		Else 
			
			$javaHome:=This:C1470.exe.parent.parent.folder("jre")
			
		End if 
		
		If ($javaHome.exists)
			
			This:C1470.javaHome:=$javaHome
			
			$javaCmd:=This:C1470.javaHome.file("bin/java")
			
			If ($javaCmd.exists)
				
				This:C1470.java:=$javaCmd
				
			Else 
				
				// java command was not found
				
			End if 
			
		Else 
			
			// JAVA_HOME was not found
			
		End if 
		
	Else 
		// Android Studio was not found
	End if 
	
	//====================================================================
	//
Function getKotlinc
	
	var $kotlinc : Object
	
	This:C1470.kotlinc:=Null:C1517
	
	If (This:C1470.exe#Null:C1517)
		
		If (This:C1470.macOS)
			
			$kotlinc:=This:C1470.exe.file("Contents/plugins/Kotlin/kotlinc/bin/kotlinc")
			
		Else 
			
			$kotlinc:=This:C1470.exe.file("Contents/plugins/Kotlin/kotlinc/bin/kotlinc.bat")
			
		End if 
		
		If ($kotlinc.exists)
			
			This:C1470.kotlinc:=$kotlinc
			
		Else 
			
			// kotlinc was not found
			
		End if 
		
	Else 
		// Android Studio was not found
	End if 