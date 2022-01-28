Class extends androidProcess

Class constructor
	
	Super:C1705()
	
	This:C1470.studio:=cs:C1710.studio.new()
	This:C1470.path:=cs:C1710.path.new()
	This:C1470.logFolder:=This:C1470.path.userCache()
	
	If (This:C1470.studio.java#Null:C1517 && This:C1470.studio.javaHome#Null:C1517)
		
		This:C1470.isOnError:=False:C215
		
		This:C1470.androidprepackageCmd:="\""+This:C1470.studio.java.path+"\" -jar androidprojectgenerator.jar"
		
		This:C1470.init()
		
	Else 
		
		This:C1470.isOnError:=True:C214
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function init
	This:C1470.setJavaHome()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function setJavaHome
	
	This:C1470.setEnvironnementVariable(New object:C1471("JAVA_HOME"; This:C1470.studio.javaHome.path))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
	
Function generate($project : Object)->$result : Object
	
	$result:=New object:C1471(\
		"success"; True:C214; \
		"outputStream"; ""; \
		"errorStream"; "")
	
	If (This:C1470.isOnError)
		
		// An error occurred during class init (This.studio.java or This.studio.javaHome was null)
		$result.success:=False:C215
		$result.errors:=New collection:C1472("Cannot generated Android database because java is missing")
		
		return 
		
	End if 
	
	var $projFile; $dbFile : 4D:C1709.File
	var $assetsDir : 4D:C1709.Folder
	
	This:C1470.project:=OB Copy:C1225($project)
	
	// * CLEANING INNER $OBJECTS
	var $o : Object
	For each ($o; OB Entries:C1720(This:C1470.project).query("key=:1"; "$@"))
		
		OB REMOVE:C1226(This:C1470.project; $o.key)
		
	End for each 
	
	$projFile:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+"projecteditor.json")
	$projFile.setText(JSON Stringify:C1217(This:C1470.project))
	
	$assetsDir:=This:C1470.project._folder.folder("project.dataSet/Resources/Assets.xcassets")
	$dbFile:=This:C1470.path.androidDb(This:C1470.project._folder.path)
	
	If (This:C1470.path.scripts().exists)
		
		This:C1470.setDirectory(This:C1470.path.scripts())
		
		This:C1470.launch(This:C1470.androidprepackageCmd\
			+" createDatabase"\
			+" --project-editor \""+$projFile.path\
			+"\" --assets \""+$assetsDir.path\
			+"\" --db-file \""+$dbFile.path\
			+"\"")
		
		var $hasError; $hasException : Boolean
		$hasError:=Bool:C1537((Position:C15("Error"; String:C10(This:C1470.errorStream))>0))
		$hasException:=Bool:C1537((Position:C15("Exception"; String:C10(This:C1470.errorStream))>0))
		
		$result.success:=Not:C34($hasError | $hasException)
		$result.outputStream:=This:C1470.outputStream
		$result.errorStream:=This:C1470.errorStream
		
		// Log outputs
		This:C1470.logFolder.file("lastPrepackage.android.out.log").setText(String:C10(This:C1470.outputStream))
		This:C1470.logFolder.file("lastPrepackage.android.err.log").setText(String:C10(This:C1470.errorStream))
		
		If (Not:C34($result.success))
			
			$result.errors:=New collection:C1472
			$result.errors.push("Failed to generate files")
			$result.errors.push(This:C1470.errorStream)
			
		Else 
			
			If (Not:C34($dbFile.exists))
				
				$result.errors:=New collection:C1472("Failed to generate prepackaged database "+$dbFile.path)
				
				// Else : all ok 
			End if 
		End if 
		
	Else 
		
		$result.errors:=New collection:C1472("Missing scripts directory")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//