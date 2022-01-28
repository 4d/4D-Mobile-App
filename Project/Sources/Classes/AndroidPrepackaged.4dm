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
	
Function generate
	var $0 : Object
	var $1 : Object  // project definition
	
	$0:=New object:C1471(\
		"success"; True:C214; \
		"outputStream"; ""; \
		"errorStream"; "")
	
	If (Not:C34(This:C1470.isOnError))
		
		var $projFile; $dbFile : 4D:C1709.File
		var $assetsDir : 4D:C1709.Folder
		
		This:C1470.project:=OB Copy:C1225($1)
		
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
			
			$0.success:=Not:C34($hasError | $hasException)
			$0.outputStream:=This:C1470.outputStream
			$0.errorStream:=This:C1470.errorStream
			
			// Log outputs
			This:C1470.logFolder.file("lastPrepackage.android.out.log").setText(String:C10(This:C1470.outputStream))
			This:C1470.logFolder.file("lastPrepackage.android.err.log").setText(String:C10(This:C1470.errorStream))
			
			If (Not:C34($0.success))
				
				$0.errors:=New collection:C1472
				$0.errors.push("Failed to generate files")
				$0.errors.push(This:C1470.errorStream)
				
			Else 
				
				If (Not:C34($dbFile.exists))
					
					$0.errors:=New collection:C1472
					$0.errors.push("Failed to generate prepackaged database "+$dbFile.path)
					
					// Else : all ok 
				End if 
			End if 
			
		Else 
			
			$0.errors:=New collection:C1472
			$0.errors.push("Missing scripts directory")
			
		End if 
		
	Else 
		// An error occurred during class init (This.studio.java or This.studio.javaHome was null)
		$0.success:=False:C215
		$0.errors:=New collection:C1472
		$0.errors.push("Cannot generated Android database because java is missing")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//