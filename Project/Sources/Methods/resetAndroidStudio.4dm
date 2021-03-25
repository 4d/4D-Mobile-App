//%attributes = {}
var $cmd; $path : Text
var $file : 4D:C1709.File
var $folder; $home; $library : 4D:C1709.Folder

If (Is macOS:C1572)
	
	// *QUIT APPLICATION
	$cmd:="/usr/bin/osascript"
	$cmd:=$cmd+" -e 'if application \"Android Studio\" is running then'"
	$cmd:=$cmd+" -e 'tell application \"Android Studio\"'"
	$cmd:=$cmd+" -e ' activate'"
	$cmd:=$cmd+" -e 'quit'"
	$cmd:=$cmd+" -e 'end tell'"
	$cmd:=$cmd+" -e 'end if'"
	
	LAUNCH EXTERNAL PROCESS:C811($cmd)
	
	$home:=Folder:C1567(fk desktop folder:K87:19).parent
	$library:=$home.folder("Library")
	
	// *REMOVE RELATED FOLDERS
	For each ($path; New collection:C1472(\
		"Application Support/Google/AndroidStudio*"; \
		"Saved Application State/com.google.android.studio.savedState"; \
		"Saved Application State/net.java.openjdk.cmd.savedState"; \
		"Logs/Google/AndroidStudio*"; \
		"Android"))
		
		If ($path="@*")  // Depends on version
			
			For each ($folder; $library.folder(Split string:C1554($path; "/").remove(-1).join("/")).folders().query("name = AndroidStudio@"))
				
				$folder.delete(fk recursive:K87:7)
				
			End for each 
			
		Else 
			
			$folder:=$library.folder($path)
			
			If ($folder.exists)
				
				$folder.delete(fk recursive:K87:7)
				
			End if 
		End if 
	End for each 
	
	$folder:=$home.folder(".android")
	
	If ($folder.exists)
		
		$folder.delete(fk recursive:K87:7)
		
	End if 
	
	// *REMOVE RELATED FILES
	$file:=$library.file("Preferences/com.google.android.studio.plist")
	
	If ($file.exists)
		
		$file.delete()
		
	End if 
	
	For each ($file; Folder:C1567("/Library/Logs/DiagnosticReports").files().query("name = studio_@ & extension = .diag"))
		
		$file.delete()
		
	End for each 
	
	// *REMOVE APPLICATION
	$folder:=Folder:C1567("/Applications/Android Studio.app")
	
	If ($folder.exists)
		
		$folder.delete(fk recursive:K87:7)
		
	End if 
	
Else 
	
	// #MARK_TODO : If you have the time, do not hesitate...
	
End if 