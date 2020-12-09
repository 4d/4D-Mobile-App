Class extends lep

Class constructor
	
	Super:C1705()
	
	
	
Function androidSDKFolder
	var $0 : 4D:C1709.Folder
	
	If (Is macOS:C1572)
		
		$0:=This:C1470.homeFolder().folder("Library/Android/sdk")
		
	Else 
		
		$0:=This:C1470.homeFolder().folder("Library/Android/sdk")
		
	End if 
	
	// or find it
	
	
Function kotlincFile
	var $0 : 4D:C1709.File
	
	$0:=File:C1566("/usr/local/bin/kotlinc")
	
	
Function homeFolder
	var $0 : 4D:C1709.Folder
	
	$0:=Folder:C1567(fk desktop folder:K87:19).parent  // Maybe there is a better way for all OS
	
	
Function getJavaHome
	var $0 : Object
	
	If (Is macOS:C1572)
		This:C1470.launch("/usr/libexec/java_home")
	Else 
		This:C1470.launch("echo %JAVA_HOME%")
	End if 
	
	$0:=New object:C1471(\
		"java_home"; ""; \
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$0.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
	
	If ($0.success)
		$0.java_home:=This:C1470.outputStream
	Else 
		$0.errors.push("Failed to get JAVA_HOME")
	End if 
	