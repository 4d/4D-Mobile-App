Class extends androidProcess

Class constructor
	
	Super:C1705()
	
	This:C1470.studio:=cs:C1710.studio.new()
	This:C1470.path:=cs:C1710.path.new()
	This:C1470.logFolder:=This:C1470.path.userCache()
	
	If ((This:C1470.studio.java#Null:C1517) && (This:C1470.studio.javaHome#Null:C1517))
		
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
	This:C1470._copyJarIfmissing()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function setJavaHome
	
	This:C1470.setEnvironnementVariable(New object:C1471("JAVA_HOME"; This:C1470.studio.javaHome.path))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function _copyJarIfmissing
	var $file : 4D:C1709.File
	$file:=Folder:C1567(fk resources folder:K87:11).folder("scripts").file("androidprojectgenerator.jar")
	
	If (Not:C34($file.exists))
		// try from 4d app (deprecated)
		If (Folder:C1567(Application file:C491; fk platform path:K87:2).file("Contents/Resources/Internal User Components/4D Mobile App.4dbase/Resources/scripts/androidprojectgenerator.jar").exists)
			
			Folder:C1567(Application file:C491; fk platform path:K87:2).file("Contents/Resources/Internal User Components/4D Mobile App.4dbase/Resources/scripts/androidprojectgenerator.jar")\
				.copyTo($file.parent)
			
		End if 
		
	End if 
	
	
	If (Not:C34($file.exists))
		
		var $url; $content : Text
		$url:="https://github.com/4d/android-ProjectGenerator/releases/latest/download/androidprojectgenerator.jar"
		
		var $data : Blob
		var $code : Integer
		$code:=HTTP Request:C1158(HTTP GET method:K71:1; $url; $content; $data)
		
		If (($code>=200) && ($code<300))
			
			$file.setContent($data)
			
		End if 
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
	
Function generate($project : Object; $mobileProj : 4D:C1709.Folder)->$result : Object
	
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
	
	var $projFile; $dbFile; $catalogfile : 4D:C1709.File
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
	$catalogfile:=$mobileProj.file("catalog.json")
	
	If (Not:C34(This:C1470.path.scripts().exists))
		
		$result.errors:=New collection:C1472("Missing scripts directory")
		return 
		
	End if 
	
	If (Not:C34($catalogFile.exists))
		
		$result.errors:=New collection:C1472("Missing catalog.json file")
		return 
		
	End if 
	
	This:C1470.setDirectory(This:C1470.path.scripts())
	
	This:C1470.launch(This:C1470.androidprepackageCmd\
		+" createDatabase"\
		+" --project-editor \""+$projFile.path\
		+"\" --assets \""+$assetsDir.path\
		+"\" --db-file \""+$dbFile.path\
		+"\" --catalog \""+$catalogfile.path\
		+"\"")
	
	var $exceptionPos; $errorPos : Integer
	
	$exceptionPos:=Position:C15("Exception"; String:C10(This:C1470.errorStream))
	$errorPos:=Position:C15("Error"; String:C10(This:C1470.errorStream))
	
	If ($exceptionPos>0)
		// Removes illegal capsule access warnings
		This:C1470.errorStream:=Substring:C12(This:C1470.errorStream; $exceptionPos)
	End if 
	
	$result.success:=Not:C34(($exceptionPos>0) | ($errorPos>0))
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
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//