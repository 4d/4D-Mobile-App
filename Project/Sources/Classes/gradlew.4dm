Class extends androidProcess

Class constructor
	
	Super:C1705()
	
	This:C1470.cmd:="gradlew"
	
	
Function assembleDebug
	var $0 : Object
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	This:C1470.launch(This:C1470.cmd+" assembleDebug")
	
	
	If (This:C1470.errorStream=Null:C1517)
		
		If (This:C1470.ouputStream#Null:C1517)
			$0.success:=(Position:C15("BUILD SUCCESSFUL"; This:C1470.outputStream)>0)  // Rebuilding project goes here
		Else 
			// ouputStream null
		End if 
		
	Else   // errorStream not null
		
		$0.success:=((This:C1470.inputStream=Null:C1517) & (This:C1470.outputStream=Null:C1517))
		
	End if 
	
	If (Not:C34($0.success))
		$0.errors.push("Failed to build project with task \"assembleDebug\"")
	Else 
		// All ok
	End if 
	
	
	
Function createEmbeddedDatabase
	var $0 : Object
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	This:C1470.launch(This:C1470.cmd+" app:createDataBase")
	
	$0.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
	
	If (Not:C34($0.success))
		$0.errors.push("Failed to create embedded database")
	Else 
		// All ok
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