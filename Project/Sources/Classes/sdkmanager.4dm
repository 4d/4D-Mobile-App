Class extends lep

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
	
	This:C1470.exe:=Choose:C955(Is macOS:C1572; \
		This:C1470.home.file("Library/Android/sdk/tools/bin/sdkmanager"); \
		This:C1470.home.file("AppData/Local/Android/sdk/tools/bin/sdkmanager.bat"))
	
	This:C1470.success:=This:C1470.exe.exists
	
	If (This:C1470.success)
		
		This:C1470.cmd:=This:C1470.exe.path
		
		This:C1470.success:=This:C1470.isReady()
		
		If (Not:C34(This:C1470.success))
			
			This:C1470.success:=This:C1470.acceptLicences()
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Check if all licenses have been accepted, return True if yes, False if not
Function isReady()->$ready : Boolean
	
	This:C1470.launch(This:C1470.cmd; "--licenses")
	
	$ready:=Match regex:C1019("(?mi-s)All SDK package licenses accepted"; This:C1470.outputStream; 1)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Try to accept the licenses
Function acceptLicences()->$ready : Boolean
	
	This:C1470.launch("sh -c \"y | "+This:C1470.cmd+" --licenses\"")
	
	$ready:=This:C1470.isReady()