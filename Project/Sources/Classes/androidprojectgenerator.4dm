Class extends androidProcess

Class constructor($java : 4D:C1709.File; $kotlinc : 4D:C1709.File)
	
	Super:C1705()
	
	This:C1470.androidprojectgeneratorCmd:="\""+$java.path+"\" -jar androidprojectgenerator.jar"
	This:C1470.kotlinc:=$kotlinc.path
	This:C1470.chmodCmd:="chmod"
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function generate
	var $0 : Object
	var $1 : 4D:C1709.File  // project editor json
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	This:C1470.path:=cs:C1710.path.new()
	
	If ((This:C1470.path.androidProjectFilesToCopy().exists)\
		 & (This:C1470.path.androidProjectTemplateFiles().exists)\
		 & (This:C1470.path.androidForms().exists))
		
		If (This:C1470.path.scripts().exists)
			
			This:C1470.setDirectory(This:C1470.path.scripts())
			
			This:C1470.launch(This:C1470.androidprojectgeneratorCmd\
				+" --project-editor \""+$1.path\
				+"\" --files-to-copy \""+This:C1470.path.androidProjectFilesToCopy().path\
				+"\" --template-files \""+This:C1470.path.androidProjectTemplateFiles().path\
				+"\" --template-forms \""+This:C1470.path.androidForms().path\
				+"\" --host-db \""+This:C1470.path.host().path\
				+"\"")
			
			$0.success:=(This:C1470.errorStream=Null:C1517)
			
			If (Not:C34($0.success))
				
				$0.errors.push("Failed to generate files")
				
				// Else : all ok
			End if 
			
		Else 
			
			$0.errors.push("Missing scripts directory")
			
		End if 
		
	Else 
		
		$0.errors.push("Missing directories for project templating")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
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
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
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
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function copyResources
	var $0 : Object
	var $1 : Text  // Project path
	var $2 : 4D:C1709.File  // 4D Mobile Project
	var $androidAssets; $currentFolder : 4D:C1709.Folder
	var $currentFile; $copyDest : 4D:C1709.File
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$androidAssets:=$2.folder("Android")
	
	If ($androidAssets.exists)
		
		$0.success:=True:C214
		
		For each ($currentFolder; $androidAssets.folders())
			
			For each ($currentFile; $currentFolder.files())
				
				If ($currentFolder.name="main")  // playstore image
					
					$copyDest:=$currentFile.copyTo(Folder:C1567($1+"app/src/main"); fk overwrite:K87:5)
					
				Else 
					
					$copyDest:=$currentFile.copyTo(Folder:C1567($1+"app/src/main/res/"+$currentFolder.name); fk overwrite:K87:5)
					
				End if 
				
				If (Not:C34($copyDest.exists))
					// Copy failed
					$0.success:=False:C215
					$0.errors.push("Could not copy file to destination: "+$copyDest.path)
					
					//Else : all ok
				End if 
				
			End for each 
			
		End for each 
		
	Else 
		// Missing Android folder
		$0.errors.push("Missing source file for copy: "+$androidAssets.path)
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
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
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function unzipSdk
	var $0 : Object
	var $cacheSdkAndroid : 4D:C1709.File
	var $archive : 4D:C1709.ZipArchive
	var $unzipDest : 4D:C1709.Folder
	
	$0:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	$cacheSdkAndroid:=This:C1470.path.cacheSdkAndroid()
	
	If ($cacheSdkAndroid.exists)
		
		$0.success:=True:C214
		
		$archive:=ZIP Read archive:C1637($cacheSdkAndroid)
		
		$unzipDest:=$archive.root.copyTo($cacheSdkAndroid.parent; fk overwrite:K87:5)
		
		If (Not:C34($unzipDest.exists))
			
			$0.success:=False:C215
			$0.errors.push("Could not unzip to destination: "+$unzipDest.path)
			
			// Else : all ok
		End if 
		
	Else 
		// Missing sdk archive
		$0.errors.push("Missing 4D Mobile SDK archive: "+$cacheSdkAndroid.path)
	End if 