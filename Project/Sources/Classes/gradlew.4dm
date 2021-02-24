Class extends androidProcess

Class constructor($projectPath : Text)
	
	Super:C1705()
	
	If (Is macOS:C1572)
		This:C1470.cmd:="gradlew"
	Else 
		This:C1470.cmd:=Folder:C1567($projectPath).file("gradlew.bat").path
	End if 
	
	
Function assembleDebug
	var $0 : Object
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	This:C1470.launch(This:C1470.cmd+" assembleDebug")
	
	$0.success:=True:C214
	
	// Commenting below as errorStream and outputStream are not null in both failure and success
/*If (This.errorStream=Null)
	
$0.success:=(This.outputStream#Null)
	
Else   // errorStream not null
	
$0.success:=((This.inputStream=Null) & (This.outputStream=Null))
	
End if 
	
If (Not($0.success))
	
$0.errors.push("Failed to build project with task \"assembleDebug\"")
	
// Else : all ok
End if */
	
	
	
Function createEmbeddedDatabase
	var $0 : Object
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	This:C1470.launch(This:C1470.cmd+" app:createDataBase")
	
	$0.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
	
	If (Not:C34($0.success))
		
		$0.errors.push("Failed to create embedded database")
		
		// Else : all ok
	End if 
	
	
Function checkAPKExists
	var $0 : Object
	var $1 : 4D:C1709.File  // apk
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	If ($1.exists)
		$0.success:=True:C214
	Else 
		$0.errors.push("Missing APK file: "+$1.path)
	End if 