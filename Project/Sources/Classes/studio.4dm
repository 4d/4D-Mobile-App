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
		
		This:C1470.version:=This:C1470._getVersion()
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
	// Download & install the latest command line tools
Function installLatestCommandLineTools($version)
	
	var $file : 4D:C1709.File
	var $folder : 4D:C1709.Folder
	var $http : cs:C1710.http
	
	$file:=This:C1470.sdkFolder().file(Choose:C955(Is macOS:C1572; ".downloadIntermediates"; ".temp")+"/cmdline-tools.zip")
	$http:=cs:C1710.http.new("https://dl.google.com/android/repository/commandlinetools-"+Choose:C955(Is macOS:C1572; "mac"; "win")+"-"+String:C10($version)+"_latest.zip")
	$http.setResponseType(Is a document:K24:1; $file)
	
	This:C1470.success:=False:C215
	
	$http.get()
	
	If ($http.success)
		
		$folder:=ZIP Read archive:C1637($file).root.copyTo($file.parent; fk overwrite:K87:5)
		
		If ($folder.exists)
			
			$folder.folder("cmdline-tools").rename("latest")
			$folder:=$folder.copyTo(This:C1470.sdkFolder(); fk overwrite:K87:5)
			
		End if 
		
		This:C1470.success:=($folder.exists)
		
		If (This:C1470.success)
			
			$folder:=$file.parent
			$folder.delete(fk recursive:K87:7)
			$folder.create()
			
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
	var $str : cs:C1710.str
	
	$c:=This:C1470.paths()
	
	If (This:C1470.success)
		
		$str:=cs:C1710.str.new()
		
		This:C1470.success:=False:C215
		
		For each ($pathname; $c)
			
			If (This:C1470.macOS)
				
				// Bundle
				$version:=This:C1470._getVersion(Folder:C1567($pathname))
				
			Else 
				
				$version:=This:C1470._getVersion(File:C1566($pathname; fk platform path:K87:2))
				
			End if 
			
			If ($str.setText($version).versionCompare($t)>=0)  // Equal or higher
				
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
Function _getVersion($target : 4D:C1709.Folder)->$version
	
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
	// Returns True if the version of Studio is equal or superior to the desired one
Function checkVersion($minimumVersion : Text)->$ok : Boolean
	
	$ok:=(cs:C1710.str.new(This:C1470.version).versionCompare($minimumVersion)>=0)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the SDK folder object
	// ⚠️ FAILED IF THE INSTALLATION WAS MADE BY NOT USING THE DEFAULT LOCATION
Function sdkFolder()->$folder : 4D:C1709.Folder
	
	If (Is macOS:C1572)
		
		$folder:=This:C1470.home.folder("Library/Android/sdk")
		
	Else 
		
		$folder:=This:C1470.home.folder("AppData/Local/Android/Sdk")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Open the Android Studio application
Function open($target : 4D:C1709.Folder)
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "false")
	
	If (Count parameters:C259>=1)  // Open project
		
		If (Is macOS:C1572)
			
			This:C1470.launchAsync("open -a "+This:C1470.singleQuoted(This:C1470.exe.path)+" "+This:C1470.singleQuoted($target.path))
			
		Else 
			
			This:C1470.launchAsync(This:C1470.quoted(This:C1470.exe.path)+" "+This:C1470.quoted($target.path))
			
		End if 
		
	Else   // Open Studio
		
		If (Is macOS:C1572)
			
			This:C1470.launchAsync("open "+This:C1470.singleQuoted(This:C1470.exe.path))
			
		Else 
			
			This:C1470.launchAsync(This:C1470.exe.path)
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Install x86 Emulator Accelerator (HAXM ,installer)
Function installHAXM()
	
	var $file : 4D:C1709.File
	var $folder : 4D:C1709.Folder
	var $http : cs:C1710.http
	
	$file:=This:C1470.sdkFolder().file(Choose:C955(Is macOS:C1572; ".downloadIntermediates"; ".temp")+"/haxm.zip")
	
	$http:=cs:C1710.http.new("https://dl.google.com/android/repository/extras/intel/haxm-"+Choose:C955(Is macOS:C1572; "macosx"; "windows")+"_v7_6_5.zip")
	
	$http.setResponseType(Is a document:K24:1; $file)
	
	This:C1470.success:=False:C215
	
	$http.get()
	
	If ($http.success)
		
		$folder:=ZIP Read archive:C1637($file).root.copyTo($file.parent; fk overwrite:K87:5)
		
		If ($folder.exists)
			
			This:C1470.sdkFolder().folder("extras/intel").create()
			$folder:=$folder.copyTo(This:C1470.sdkFolder().folder("extras/intel"); "Hardware_Accelerated_Execution_Manager"; fk overwrite:K87:5)
			
		End if 
		
		This:C1470.success:=($folder.exists)
		
		If (This:C1470.success)
			
			If (Is macOS:C1572)
				
				This:C1470.launch("chmod +x "+This:C1470.singleQuoted($folder.file("HAXM installation").path))
				This:C1470.launchAsync(This:C1470.singleQuoted($folder.file("HAXM installation").path))
				
			Else 
				
				OPEN URL:C673($folder.file("haxm-7.6.5-setup.exe").platformPath)
				
			End if 
			
			If (This:C1470.success)
				
				$folder:=This:C1470.sdkFolder().folder(Choose:C955(Is macOS:C1572; ".downloadIntermediates"; ".temp"))
				$folder.delete(fk recursive:K87:7)
				$folder.create()
				
			End if 
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Try to accept the SDK licenses
Function acceptLicences()->$ready : Boolean
	
	var $o : Object
	var $file : 4D:C1709.File
	
	For each ($o; JSON Parse:C1218(File:C1566("/RESOURCES/android.json").getText()).licences)
		
		If (Is macOS:C1572)
			
			// ~/Users/{user}/Library/Android/sdk/licenses/
			$file:=File:C1566(This:C1470.home.path+"Library/Android/sdk/licenses/"+$o.file)
			
		Else 
			
			// ~/Users/{user}/AppData/Local/Android/sdk/licenses/
			$file:=File:C1566(This:C1470.home.path+"AppData/Local/Android/sdk/licenses/"+$o.file)
			
		End if 
		
		$file.setText("\n"+$o.value)
		
	End for each 
	
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
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Uninstall Android Studio and all associated files and folders (try to virginize the machine)
Function uninstall()
	
	var $cmd; $path; $t : Text
	var $c : Collection
	var $file : 4D:C1709.File
	var $folder; $userLibrary : 4D:C1709.Folder
	
	If (Is macOS:C1572)
		
		// *QUIT APPLICATION
		$cmd:="/usr/bin/osascript"\
			+" -e 'if application \"Android Studio\" is running then'"\
			+" -e ' tell application \"Android Studio\"'"\
			+" -e '  activate'"\
			+" -e '  quit'"\
			+" -e ' end tell'"\
			+" -e 'end if'"
		
		This:C1470.launch($cmd)
		
		$userLibrary:=This:C1470.home.folder("Library")
		
		// *REMOVE RELATED FOLDERS
		For each ($path; New collection:C1472(\
			"Application Support/Google/AndroidStudio*"; \
			"Saved Application State/com.google.android.studio.savedState"; \
			"Saved Application State/net.java.openjdk.cmd.savedState"; \
			"Logs/Google/AndroidStudio*"; \
			"Android"))
			
			If ($path="@*")  // Depends on version
				
				$c:=Split string:C1554($path; "/")
				
				// Keep the lats item
				$t:=Replace string:C233($c[$c.length-1]; "*"; "@")
				
				For each ($folder; $userLibrary.folder($c.remove(-1).join("/")).folders().query("name = :1"; $t))
					
					$folder.delete(fk recursive:K87:7)
					
				End for each 
				
			Else 
				
				$folder:=$userLibrary.folder($path)
				
				If ($folder.exists)
					
					$folder.delete(fk recursive:K87:7)
					
				End if 
			End if 
		End for each 
		
		For each ($path; New collection:C1472(\
			".android"; \
			".gradle"))
			
			$folder:=This:C1470.home.folder($path)
			
			If ($folder.exists)
				
				$folder.delete(fk recursive:K87:7)
				
			End if 
		End for each 
		
		// *REMOVE RELATED FILES
		$folder:=$userLibrary.folder("Preferences")
		
		For each ($path; New collection:C1472("com.google.android.studio.plist"; \
			"com.android.Emulator.plist"))
			
			$file:=$folder.file($path)
			
			If ($file.exists)
				
				$file.delete()
				
			End if 
		End for each 
		
		For each ($file; Folder:C1567("/Library/Logs/DiagnosticReports").files().query("name = studio_@ & extension = .diag"))
			
			$file.delete()
			
		End for each 
		
		// *REMOVE APPLICATION
		$folder:=Folder:C1567("/Applications/Android Studio.app")
		
		If ($folder.exists)
			
			$folder.delete(fk recursive:K87:7)
			
		End if 
		
	Else 
		
		// #MARK_TODO
		ASSERT:C1129(False:C215; "If you have the time, do not hesitate...")
		
	End if 
	