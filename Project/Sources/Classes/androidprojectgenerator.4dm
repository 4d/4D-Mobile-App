Class extends androidProcess

Class constructor
	
	Super:C1705()
	
	If (Is macOS:C1572)
		This:C1470.androidprojectgeneratorCmd:="androidprojectgenerator"
		This:C1470.kotlincCmd:="/usr/local/bin/kotlinc"
		This:C1470.chmodCmd:="chmod"
	Else 
		This:C1470.androidprojectgeneratorCmd:="java -jar androidprojectgenerator.jar"
		This:C1470.kotlincCmd:="C:/Users/Test/kotlinc/bin/kotlinc.bat"
	End if 
	
	
	
Function generate
	var $0 : Object
	var $1 : 4D:C1709.File  // project editor json
	var $2 : 4D:C1709.Folder  // files to copy
	var $3 : 4D:C1709.Folder  // template files
	var $4 : 4D:C1709.Folder  // template forms
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	This:C1470.setDirectory(path.scripts())
	
	This:C1470.launch(This:C1470.androidprojectgeneratorCmd\
		+" --project-editor \""+$1.path\
		+"\" --files-to-copy \""+$2.path\
		+"\" --template-files \""+$3.path\
		+"\" --template-forms \""+$4.path\
		+"\"")
	
	$0.success:=(This:C1470.errorStream=Null:C1517)
	
	If (Not:C34($0.success))
		$0.errors.push("Failed to generate files")
	Else 
		// All ok
	End if 
	
	
Function buildEmbeddedDataLib
	var $0 : Object
	var $1 : Text  // Project path
	var $2 : Text  // package name (app name)
	var $staticDataInitializerFile; $targetFile : 4D:C1709.File
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$staticDataInitializerFile:=File:C1566($1+"buildSrc/src/main/java/"+$2+".android.build/database/StaticDataInitializer.kt")
	
	If ($staticDataInitializerFile.exists)
		
		$targetFile:=File:C1566($1+"buildSrc/libs/prepopulation.jar")
		
		This:C1470.launch(This:C1470.kotlincCmd\
			+" -verbose \""+$staticDataInitializerFile.path+"\""\
			+" -d \""+$targetFile.path+"\"")
		
		$0.success:=$targetFile.exists
		
	Else 
		
		$0.errors.push("Missing file : "+$staticDataInitializerFile.path)
		
	End if 
	
	If (Not:C34($0.success))
		$0.errors.push("Failed to build embedded data library")
	Else 
		// All ok
	End if 
	
	
Function copyEmbeddedDataLib
	var $0 : Object
	var $1 : Text  // Project path
	var $copySrc; $copyDest : 4D:C1709.File
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$copySrc:=File:C1566($1+"buildSrc/libs/prepopulation.jar")
	
	If ($copySrc.exists)
		
		$copyDest:=$copySrc.copyTo(Folder:C1567($1+"app/libs"); fk overwrite:K87:5)
		
		If ($copyDest.exists)
			
			$0.success:=True:C214
			
		Else 
			// Copy failed
			$0.errors.push("Could not copy file to destination: "+$copyDest.path)
		End if 
		
	Else 
		// Missing file
		$0.errors.push("Missing source file for copy: "+$copySrc.path)
	End if 
	
	
Function chmodGradlew
	var $0 : Object
	var $1 : Text  // Project path
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	This:C1470.launch(This:C1470.chmodCmd+" +x "+This:C1470.singleQuoted($1+"gradlew"))
	
	$0.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
	
	If (Not:C34($0.success))
		$0.errors.push("Failed chmod command")
	Else 
		// All ok
	End if 