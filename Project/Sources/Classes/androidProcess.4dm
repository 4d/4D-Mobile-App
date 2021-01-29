/*

*/
Class extends lep

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705()
	
	// Set JAVA_HOME
	This:C1470.getJavaHome()
	
	If (This:C1470.success)
		
		This:C1470.setEnvironnementVariable("JAVA_HOME"; This:C1470.java_home)
		
	Else 
		
		//#ERROR
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the Android SDK folder object
Function androidSDKFolder()->$folder : 4D:C1709.Folder
	
	If (Is macOS:C1572)
		
		$folder:=This:C1470.homeFolder().folder("Library/Android/sdk")
		
	Else 
		
		$folder:=This:C1470.homeFolder().folder("AppData/Local/Android/Sdk")
		
	End if 
	
	If ($folder.exists)
		
		// <NOTHING MORE TO DO>
		
	Else 
		
		// #TO_DO : or find it
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the User Home folder object
Function homeFolder()->$folder : 4D:C1709.Folder
	
	$folder:=Folder:C1567(fk desktop folder:K87:19).parent  // Maybe there is a better way for all OS
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function getJavaHome()
	
	If (Is macOS:C1572)
		
		This:C1470.launch("/usr/libexec/java_home")
		
	Else 
		
		This:C1470.launch("where java")
		
	End if 
	
	If (This:C1470.success)
		
		This:C1470.java_home:=This:C1470.outputStream
		
	Else 
		
		This:C1470.errors.push("Failed to get JAVA_HOME")
		
	End if 
	
	