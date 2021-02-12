/*

*/
Class extends lep

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705()
	
	// Set JAVA_HOME
	//This.getJavaHome()
	
	//If (This.success)
	
	//This.setEnvironnementVariable("JAVA_HOME"; This.java_home)
	
	//Else 
	
	////#ERROR
	
	//End if 
	
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
		
		If (This:C1470.success)
			
			This:C1470.java_home:=This:C1470.outputStream
			
		Else 
			
			This:C1470.errors.push("Failed to get JAVA_HOME")
			
		End if 
		
	Else 
		
		This:C1470.launch("echo %JAVA_HOME%")
		
		If (This:C1470.success)
			
			This:C1470.java_home:=This:C1470.outputStream
			
		Else 
			
			This:C1470.errors.push("Failed to get JAVA_HOME")
			
		End if 
		
		//This.java_home:="'C:\\Program Files (x86)\\Common Files\\Oracle\\Java\\javapath'"
		
	End if 
	
	