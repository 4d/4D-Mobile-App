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
	
	
Function homeFolder
	var $0 : 4D:C1709.Folder
	
	$0:=Folder:C1567(fk desktop folder:K87:19).parent  // Maybe there is a better way for all OS
	
	
Function setJavaHome
	var $0 : Object
	
	If (This:C1470.getEnvironnementVariable("JAVA_HOME")=Null:C1517)
		
	Else 
		// JAVA_HOME already set
	End if 
	
	If (Is macOS:C1572)
		
		This:C1470.launch("/usr/libexec/java_home")
		
	Else 
		
		This:C1470.launch("echo %JAVA_HOME%")
		
	End if 
	
	$0:=New object:C1471
	$0.errors:=New collection:C1472("Failed to get JAVA_HOME")
	$0.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
/*
If (($lep.errorStream#Null) & (String($lep.errorStream)#""))
	
$isOnError:=True
	
// Failed to generate files
	POST_MESSAGE(New object(\
		"type"; "alert"; \
		"target"; $input.caller; \
		"additional"; "Failed to get JAVA_HOME"))
	
Else 
	
$lep.setEnvironnementVariable("JAVA_HOME"; $lep.outputStream)
	
End if 
*/