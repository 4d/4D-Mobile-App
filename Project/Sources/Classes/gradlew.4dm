Class extends androidProcess

Class constructor($projectPath : Text)
	
	Super:C1705()
	
	If (Is Windows:C1573)
		This:C1470.cmd:=Folder:C1567($projectPath).file("gradlew.bat").path
	Else 
		This:C1470.cmd:="gradlew"
	End if 
	
Function execute($command : Text)
	This:C1470.launch(This:C1470.cmd+" "+$command)
	
Function stop()
	This:C1470.execute("--stop")
	
	
Function assembleDebug->$result : Object
	
	$result:=New object:C1471(\
		"success"; False:C215; \
		"outputStream"; ""; \
		"errorStream"; ""; \
		"errors"; New collection:C1472)
	
	This:C1470.execute("assembleDebug")
	
	$result.outputStream:=This:C1470.outputStream
	$result.errorStream:=This:C1470.errorStream
	
	If (Position:C15("BUILD FAILED"; This:C1470.errorStream)=0)
		
		$result.success:=True:C214
		
	Else 
		
		$result.errors.push("Failed to build project with task \"assembleDebug\"")
		$result.errors.push(This:C1470.errorStream)
		
	End if 
	
Function createEmbeddedDatabase()->$result : Object
	
	$result:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	This:C1470.execute("app:createDataBase")
	
	$result.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
	
	If (Not:C34($result.success))
		
		$result.errors.push("Failed to create embedded database")
		
		// Else : all ok
	End if 
	
Function signingReport()->$result : Object
	
	$result:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	This:C1470.execute("signingReport")
	
	var $dataPos : Integer
	$dataPos:=Position:C15("> Task :app:signingReport"; This:C1470.outputStream)
	$result.success:=($dataPos>0) && Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))  // TODO: check if it could success with error stream
	
	If (Not:C34(This:C1470.success))
		
		$result.errors.push("Failed to get signing report")
		
	Else   // parse data
		
		var $lines : Collection
		$lines:=Split string:C1554(Substring:C12(This:C1470.outputStream; $dataPos); "\n")  //TODO: check line ending on other os
		
		$lines.shift()
		var $line : Text
		For each ($line; $lines)
			$dataPos:=Position:C15(":"; $line)
			If ($dataPos>0)
				$result[Substring:C12($line; 1; $dataPos-1)]:=Substring:C12($line; $dataPos+2)
			End if 
		End for each 
	End if 
	
	
Function checkAPKExists($apkFile : 4D:C1709.File)->$result : Object
	
	$result:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	If ($apkFile.exists)
		$result.success:=True:C214
	Else 
		$result.errors.push("Missing APK file: "+$apkFile.path)
	End if 