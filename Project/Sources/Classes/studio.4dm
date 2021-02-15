/*

Manage the Android Studio installation

*/
Class extends lep

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
		This:C1470._getJava()
		This:C1470._getKotlinc()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Return by default the default path,
	// If not exist one of the path found by spotlight(on macOS). The last version.
Function path($useDefaultPath : Boolean)
	
	var $default : Boolean
	
	If (Count parameters:C259>=1)
		
		$default:=$useDefaultPath
		
	End if 
	
	This:C1470.defaultPath()
	
	If (This:C1470.exe=Null:C1517) & Not:C34($default)
		
		This:C1470.lastPath()
		
		If (This:C1470.success)
			
			// Verify the tools
			
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
		
		$exe:=File:C1566("C:\\Program Files\\Android\\Android Studio\\bin\\studio64.exe"; fk platform path:K87:2)
		
	End if 
	
	This:C1470.success:=$exe.exists
	
	If (This:C1470.success)
		
		This:C1470.exe:=$exe
		
	Else 
		
		This:C1470.exe:=Null:C1517
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Try to find an Android Studio not in default path
Function lastPath
	
	var $pathname; $t; $version : Text
	var $c : Collection
	
	$c:=This:C1470.paths()
	
	If (This:C1470.success)
		
		This:C1470.success:=False:C215
		
		For each ($pathname; $c)
			
			If (This:C1470.macOS)
				
				// Bundle
				$version:=This:C1470.getVersion(Folder:C1567($pathname))
				
			Else 
				
				$version:=This:C1470.getVersion(File:C1566($pathname; fk platform path:K87:2))
				
			End if 
			
			If (This:C1470.versionCompare($version; $t)>=0)  // Equal or higher
				
				$t:=$version
				This:C1470.version:=$version
				
				If (This:C1470.macOS)
					
					// Bundle
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
		
		$isDefault:=(This:C1470.exe.path=File:C1566("C:\\Program Files\\Android\\Android Studio\\bin\\studio64.exe"; fk platform path:K87:2).path)
		
	End if 
	
	//====================================================================
	// Get all installed Android Studio applications using Spotlight (on macOS)
Function paths()->$instances : Collection
	
	var $t : Text
	var $instances : Collection
	var $file : 4D:C1709.File
	
	If (This:C1470.macOS)
		
		This:C1470.launch("mdfind \"kMDItemCFBundleIdentifier == 'com.google.android.studio'\"")
		
		If (This:C1470.success)
			
			$instances:=Split string:C1554(This:C1470.outputStream; "\n"; sk ignore empty strings:K86:1)
			
		End if 
		
	Else 
		
		$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file("Uninstall.txt")
		$file.delete()
		
		This:C1470.launch("reg export HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall "+$file.platformPath)
		
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
			
			This:C1470.lastError:="No Android Studio installed"
			
		End if 
	End if 
	
	//====================================================================
Function getVersion($target : 4D:C1709.Folder)->$version
	
	var $drive; $extension; $name; $path; $t : Text
	var $indx : Integer
	var $file : 4D:C1709.File
	var $targetƒ : 4D:C1709.Folder
	
	If (Count parameters:C259>=1)
		
		$targetƒ:=$target
		
	Else 
		
		// Use current
		$targetƒ:=This:C1470.exe
		
	End if 
	
	If (This:C1470.macOS)
		
		$file:=$targetƒ.file("Contents/Info.plist")
		This:C1470.success:=$file.exists
		
		If (This:C1470.success)
			
			This:C1470.launch("defaults read"+" '"+$file.path+"' CFBundleShortVersionString")
			
			If (This:C1470.success)
				
				$version:=This:C1470.outputStream
				
			End if 
			
		End if 
		
	Else 
		
		$indx:=Position:C15(":"; $targetƒ.parent.platformPath)
		$drive:=Substring:C12($targetƒ.parent.platformPath; 1; $indx)
		$path:=Replace string:C233(Substring:C12($targetƒ.parent.platformPath; $indx+1); "\\"; "\\\\")
		$name:=$targetƒ.name
		$extension:=Replace string:C233($targetƒ.extension; "."; ""; 1)
		
		
		This:C1470.launch("wmic datafile where \"Drive='"+$drive+"' and Path='"+$path+"' and Filename='"+$name+"' and extension='"+$extension+"'\" get name,version")
		
		If (This:C1470.success)
			
			$t:=This:C1470.outputStream
			
			ARRAY LONGINT:C221($pos; 0x0000)
			ARRAY LONGINT:C221($len; 0x0000)
			This:C1470.success:=Match regex:C1019("(?m-si)\\s(\\d+(?:\\.\\d+)*)\\s"; $t; 1; $pos; $len)
			
		End if 
		
		If (This:C1470.success)
			
			$t:=Substring:C12($t; $pos{1}; $len{1})
			
			// Remove unecessary ".0"
			var $c : Collection
			$c:=Split string:C1554($t; ".")
			
			While ($c[$c.length-1]="0")
				
				$c.remove($c.length-1)
				
			End while 
			
			$version:=$c.join(".")
			
		End if 
	End if 
	
	//====================================================================
	// Returns True if the version of Xcode is equal or superior to the desired one
Function checkVersion($minimumVersion : Text)->$ok : Boolean
	
	$ok:=(This:C1470.versionCompare(This:C1470.version; $minimumVersion)>=0)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the User Home folder object
Function homeFolder()->$folder : 4D:C1709.Folder
	
	$folder:=Folder:C1567(fk desktop folder:K87:19).parent  // Maybe there is a better way for all OS
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the SDK folder object
	// ⚠️ FAILED IF THE INSTALLATION WAS MADE BY NOT USING THE DEFAULT LOCATION
Function sdkFolder()->$folder : 4D:C1709.Folder
	
	If (Is macOS:C1572)
		
		$folder:=This:C1470.homeFolder().folder("Library/Android/sdk")
		
	Else 
		
		$folder:=This:C1470.homeFolder().folder("AppData/Local/Android/Sdk")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Open the Android Studio application
Function open()
	
	If (Count parameters:C259>=1)  // Open project
		
		
		//#TO_DO
		
		
	Else   // Open Studio
		
		If (Is macOS:C1572)
			
			This:C1470.launch("open "+This:C1470.singleQuoted(This:C1470.exe.path))
			
		Else 
			
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "false")
			This:C1470.launch(This:C1470.exe.path)
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Populate the javaHome & java properties according to the platform
Function _getJava()
	
	var $javaHome : 4D:C1709.Folder
	var $javaCmd : 4D:C1709.File
	
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
			
			If (This:C1470.macOS)
				
				$javaCmd:=This:C1470.javaHome.file("bin/java")
				
			Else 
				
				$javaCmd:=This:C1470.javaHome.file("bin/java.exe")
				
			End if 
			
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
	
	This:C1470.success:=(This:C1470.java#Null:C1517)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Populate the kotlink property according to the platform
Function _getKotlinc()
	
	var $kotlinc : 4D:C1709.File
	
	This:C1470.kotlinc:=Null:C1517
	
	If (This:C1470.exe#Null:C1517)
		
		If (This:C1470.macOS)
			
			$kotlinc:=This:C1470.exe.file("Contents/plugins/Kotlin/kotlinc/bin/kotlinc")
			
		Else 
			
			$kotlinc:=This:C1470.exe.parent.parent.file("plugins/Kotlin/kotlinc/bin/kotlinc.bat")
			
		End if 
		
		If ($kotlinc.exists)
			
			This:C1470.kotlinc:=$kotlinc
			
		Else 
			
			// kotlinc was not found
			
		End if 
		
	Else 
		
		// Android Studio was not found
		
	End if 
	
	This:C1470.success:=(This:C1470.kotlinc#Null:C1517)