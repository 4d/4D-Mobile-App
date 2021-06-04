Class extends lep

/*
   lep ━ androidProcess ━┳━ adb  
                         ┣━ androidEmulator 
                         ┣━ androidProjectGenerator 
                         ┣━ avd 
                         ┣━ gradlew  
                         ┗━ sdkmanager                                
*/

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705()
	
	This:C1470.minimumVersion:=10
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the Android SDK folder object
Function androidSDKFolder()->$folder : 4D:C1709.Folder
	
	If (Is macOS:C1572)
		
		$folder:=This:C1470.home.folder("Library/Android/sdk")
		
	Else 
		
		$folder:=This:C1470.home.folder("AppData/Local/Android/Sdk")
		
	End if 
	
	If ($folder.exists)
		
		// <NOTHING MORE TO DO>
		
	Else 
		
		// #TO_DO : or find it
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
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
	End if 
	