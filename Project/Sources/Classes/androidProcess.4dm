Class extends lep

Class constructor
	
	Super:C1705()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the Android SDK folder object
Function androidSDKFolder()->$folder : 4D:C1709.Folder
	
	If (Is macOS:C1572)
		
		$folder:=This:C1470.homeFolder().folder("Library/Android/sdk")
		
	Else 
		
		$folder:=This:C1470.homeFolder().folder("AppData/Local/Android/Sdk")
		
	End if 
	
	// or find it
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the User Home folder object
Function homeFolder()->$folder : 4D:C1709.Folder
	
	$folder:=Folder:C1567(fk desktop folder:K87:19).parent  // Maybe there is a better way for all OS
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function getJavaHome()->$java : Object
	
	$java:=New object:C1471(\
		"java_home"; ""; \
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	If (Is macOS:C1572)
		
		This:C1470.launch("/usr/libexec/java_home")
		
	Else 
		
		This:C1470.launch("where java")
		
	End if 
	
	$java.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
	
	If ($java.success)
		
		$java.java_home:=This:C1470.outputStream
		
	Else 
		
		$java.errors.push("Failed to get JAVA_HOME")
		
	End if 
	
	