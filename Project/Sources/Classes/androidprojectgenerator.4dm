Class extends androidProcess

Class constructor($java : 4D:C1709.File; $kotlinc : 4D:C1709.File)
	
	Super:C1705()
	
	This:C1470.androidprojectgeneratorCmd:="\""+$java.path+"\" -jar androidprojectgenerator.jar"
	This:C1470.kotlinc:=$kotlinc.path
	This:C1470.chmodCmd:="chmod"
	
	
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
		
		// Else : all ok
	End if 
	
	
Function buildEmbeddedDataLib
	var $0 : Object
	var $1 : Text  // Project path
	var $2 : Text  // package name (app name)
	var $staticDataInitializerFile; $targetFile : 4D:C1709.File
	var $libFolder : 4D:C1709.Folder
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$staticDataInitializerFile:=File:C1566($1+"buildSrc/src/main/java/"+$2+".android.build/database/StaticDataInitializer.kt")
	
	If ($staticDataInitializerFile.exists)
		
		$libFolder:=Folder:C1567($1+"buildSrc/libs")
		$libFolder.create()
		
		$targetFile:=$libFolder.file("prepopulation.jar")
		
		This:C1470.launch("\""+This:C1470.kotlinc+"\""\
			+" -verbose \""+$staticDataInitializerFile.path+"\""\
			+" -d \""+$targetFile.path+"\"")
		
		$0.success:=$targetFile.exists
		
	Else 
		
		$0.errors.push("Missing file : "+$staticDataInitializerFile.path)
		
	End if 
	
	If (Not:C34($0.success))
		
		$0.errors.push("Failed to build embedded data library")
		
		// Else : all ok
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
	
	
	
Function copyResources
	var $0 : Object
	var $1 : Text  // Project path
	var $2 : 4D:C1709.File  // 4D Mobile Project
	var $androidAssets; $currentFolder : 4D:C1709.Folder
	var $currentFile; $copyDest : 4D:C1709.File
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$androidAssets:=$2.parent.folder("android")
	
	$0.success:=True:C214
	
	If ($androidAssets.exists)
		
		For each ($currentFolder; $androidAssets.folders())
			
			For each ($currentFile; $currentFolder.files())
				
				$copyDest:=$currentFile.copyTo(Folder:C1567($1+"app/src/main/res/"+$currentFolder.name); fk overwrite:K87:5)
				
				If (Not:C34($copyDest.exists))
					// Copy failed
					$0.success:=False:C215
					$0.errors.push("Could not copy file to destination: "+$copyDest.path)
					
					//Else : all ok
				End if 
				
			End for each 
			
		End for each 
		
	Else 
		// Missing file
		
		// TODO : UNCOMMENT WHEN ANDROID RESOURCES IMPLEMENTED
		// $0.success:=False
		// $0.errors.push("Missing source file for copy: "+$androidAssets.path)
	End if 
	
	
	
Function chmod
	var $0 : Object
	var $1 : Text  // Project path
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	This:C1470.launch(This:C1470.chmodCmd+" +x "+This:C1470.singleQuoted($1+"gradlew")+" "+This:C1470.singleQuoted(This:C1470.kotlinc))
	
	$0.success:=Not:C34((This:C1470.errorStream#Null:C1517) & (String:C10(This:C1470.errorStream)#""))
	
	If (Not:C34($0.success))
		
		$0.errors.push("Failed chmod command")
		
		// Else : all ok
	End if 