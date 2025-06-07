Class extends androidProcess

/*
Usage:
sdkmanager [--uninstall] [<common args>] [--package_file=<file>] [<packages>...]
sdkmanager --update [<common args>]
sdkmanager --list [<common args>]
sdkmanager --licenses [<common args>]
sdkmanager --version

With --install (optional), installs or updates packages.
By default, the listed packages are installed or (if already installed)
updated to the latest version.
With --uninstall, uninstall the listed packages.

<package> is a sdk-style path (e.g. "build-tools;23.0.0" or
"platforms;android-23").
<package-file> is a text file where each line is a sdk-style path
of a package to install or uninstall.
Multiple --package_file arguments may be specified in combination
with explicit paths.

With --update, all installed packages are updated to the latest version.

With --list, all installed and available packages are printed out.

With --licenses, show and offer the option to accept licenses for all
available packages that have not already been accepted.

With --version, prints the current version of sdkmanager.

Common Arguments:
--sdk_root=<sdkRootPath>: Use the specified SDK root instead of the SDK
containing this tool

--channel=<channelId>: Include packages in channels up to <channelId>.
Common channels are:
0 (Stable), 1 (Beta), 2 (Dev), and 3 (Canary).

--include_obsolete: With --list, show obsolete packages in the
package listing. With --update, update obsolete
packages as well as non-obsolete.

--no_https: Force all connections to use http rather than https.

--proxy=<http | socks>: Connect via a proxy of the given type.

--proxy_host=<IP or DNS address>: IP or DNS address of the proxy to use.

--proxy_port=<port #>: Proxy port to connect to.

--verbose: Enable verbose output.

* If the env var REPO_OS_OVERRIDE is set to "windows",
"macosx", or "linux", packages will be downloaded for that OS.
*/

Class constructor
	
	Super:C1705()
	
	This:C1470.setCharSet("US-ASCII")
	
	This:C1470.root:=Is macOS:C1572 ? This:C1470.home.folder("Library/Android/sdk") : \
		This:C1470.home.file("AppData/Local/Android/sdk")
	
	This:C1470.exe:=Is macOS:C1572 ? This:C1470.root.file("tools/bin/sdkmanager") : \
		This:C1470.root.file("tools/bin/sdkmanager.bat")
	
	If (Not:C34((This:C1470.exe.exists)))
		
		This:C1470.exe:=Is macOS:C1572 ? This:C1470.root.file("cmdline-tools/latest/bin/sdkmanager") : \
			This:C1470.root.file("cmdline-tools/latest/bin/sdkmanager.bat")
		
	End if 
	
	If (This:C1470.exe.exists)
		
		This:C1470.cmd:=This:C1470.exe.path
		
	End if 
	
	If (This:C1470.success)
		
		This:C1470.version:=This:C1470.getVersion()
		
		var $studio : cs:C1710.studio
		$studio:=cs:C1710.studio.new()
		
		If ($studio.success)
			
			If (Bool:C1537($studio.javaHome.exists))
				
				This:C1470.setEnvironnementVariable("JAVA_HOME"; $studio.javaHome.path)
				
			End if 
		End if 
		
		This:C1470.success:=This:C1470.isReady()
		
		If (Not:C34(This:C1470.success))
			
			This:C1470.success:=This:C1470.acceptLicences()
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Get the current version of sdkmanager
Function getVersion() : Text
	
	This:C1470.launch(This:C1470.cmd; "--version")
	
	If (This:C1470.success)
		
		return This:C1470.outputStream
		
	Else 
		
		//#ERROR
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Update de SDKs
Function update()
	
	This:C1470.launch(This:C1470.cmd; "--update")  //--no-ui --update
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Check if all licenses have been accepted, return True if yes, False if not
Function isReady() : Boolean
	
	If (Is macOS:C1572)
		
		This:C1470.launch(This:C1470.quoted(This:C1470.cmd); "--licenses")
		
	Else 
		
		This:C1470.inputStream:="echo n | "
		This:C1470.launch(This:C1470.quoted(This:C1470.cmd); " --licenses")
		This:C1470.inputStream:=""
		
	End if 
	
	return Match regex:C1019("(?mi-s)All SDK package licenses accepted"; This:C1470.outputStream; 1)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Try to accept the licenses
Function acceptLicences() : Boolean
	
	//If (Is macOS)
	//This.launch("sh -c \"y | "+This.cmd+" --licenses\"")
	////This.launch("yes | sudo "+This.cmd+" --licenses")
	//Else 
	//This.inputStream:="cmd /c echo y | & "
	//This.launch(This.quoted(This.cmd); " --licenses")
	//This.inputStream:=""
	//End if 
	
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
	
	return This:C1470.isReady()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Install package(s)
Function install($package : Text) : Boolean
	
	This:C1470.launch(This:C1470.cmd; This:C1470.quoted($package))
	return (Position:C15("100% Unzipping"; This:C1470.outputStream)>0)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// List installed and available packages
Function installedPackages()->$packages : Collection
	
	This:C1470.launch(This:C1470.cmd; "--list --channel=0")