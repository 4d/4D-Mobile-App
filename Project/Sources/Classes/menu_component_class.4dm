

Function fillMenu($menu : Object)
	$menu.append("Inject component in 4D app"; "injectComponentToCurrentApp").method("menu_component")
	$menu.append("Inject the builded component in 4D app"; "injectComponentBuildToCurrentApp").method("menu_component")
	$menu.append("Build and inject the component in 4D app"; "buildAndInjectComponentToCurrentApp").method("menu_component")
	$menu.append("Get iOS SDK from 4D app"; "getAppiOSSDK").method("menu_component")
	$menu.append("Get iOS SDK from TC"; "getTCiOSSDK").method("menu_component")
	$menu.line()
	$menu.append("Show configuration file"; "openConf").method("menu_component")
	$menu.append("Show current features"; "showFeatures").method("menu_component")
	$menu.append("Re-load features file"; "reloadFeatureFile").method("menu_component")
	$menu.line()
	$menu.append("Find resources"; "findLocalizedResources").method("menu_component")
	$menu.line()
	$menu.append("Git rebase"; "gitRebase").method("menu_component")
	$menu.append("Git status"; "gitStatus").method("menu_component")
	$menu.append("Git open modified"; "gitOpenModified").method("menu_component")
	
	// MARK:-
Function injectComponentToCurrentApp
	// sometime you want to debug other 4d database mobile app
	// and want to use TRACE or debug
	// so replace into current 4d app the 4d mobile app by this one to debug
	
	var $app : 4D:C1709.Folder
	$app:=Folder:C1567(Application file:C491; fk platform path:K87:2)
	
	ASSERT:C1129(Is macOS:C1572)  // remove this if you implement components paths
	var $appComponent : 4D:C1709.Folder
	$appComponent:=$app.folder("Contents/Resources/Internal User Components/4D Mobile App.4dbase/")
	
	If ($appComponent.exists)
		$appComponent.delete(Delete with contents:K24:24)
	End if 
	
	var $result : 4D:C1709.Folder
	$result:=Folder:C1567(fk database folder:K87:14).copyTo($appComponent.parent; "4D Mobile App.4dbase")
	
	If (Shift down:C543)
		RESTART 4D:C1292
	Else 
		SHOW ON DISK:C922($result.platformPath)
	End if 
	
Function injectComponentBuildToCurrentApp()
	
	var $app : 4D:C1709.Folder
	$app:=Folder:C1567(Application file:C491; fk platform path:K87:2)
	
	ASSERT:C1129(Is macOS:C1572)  // remove this if you implement components paths
	var $appComponent : 4D:C1709.Folder
	$appComponent:=$app.folder("Contents/Resources/Internal User Components/4D Mobile App.4dbase/")
	
	If ($appComponent.exists)
		$appComponent.delete(Delete with contents:K24:24)
	End if 
	
	var $result : 4D:C1709.Folder
	$result:=Folder:C1567(Folder:C1567(fk database folder:K87:14).platformPath; fk platform path:K87:2).parent.folder("Build/Components").folder("4D Mobile App.4dbase").copyTo($appComponent.parent; "4D Mobile App.4dbase")
	
	If (Shift down:C543)
		RESTART 4D:C1292
	Else 
		SHOW ON DISK:C922($result.platformPath)
	End if 
	
Function buildAndInjectComponentToCurrentApp()
	var $result; $options : Object
	
	$options:=New object:C1471("components"; New collection:C1472)
	
	
	// include dependencies?
	var $makeFile : 4D:C1709.File
	$makeFile:=Folder:C1567(fk database folder:K87:14).file("make.json")
	If ($makeFile.exists)
		
		var $app : 4D:C1709.Folder
		$app:=Folder:C1567(Application file:C491; fk platform path:K87:2)
		ASSERT:C1129(Is macOS:C1572)  // remove this if you implement components paths
		
		var $components; $paths : Collection
		$components:=JSON Parse:C1218($makeFile.getText()).components
		var $componentName : Text
		For each ($componentName; $components)
			
			$paths:=$app.folder("Contents/Components").folders().combine(\
				$app.folder("Contents/Resources/Internal Components").folders()).combine(\
				$app.folder("Contents/Resources/Internal User Components").folders()).filter(Formula:C1597($1.value.name=$componentName))
			If ($paths.length>0)
				$options.components.push($paths[0].file($componentName+".4DZ"))
			End if 
			
		End for each 
	End if 
	
	$componentName:="4D Mobile App"  // Folder(fk database folder).name?
	$result:=Compile project:C1760(Folder:C1567(fk database folder:K87:14).folder("Project").file($componentName+".4DProject"); $options)
	
	If ($result.success)
		
		var $appComponent : 4D:C1709.Folder
		$appComponent:=$app.folder("Contents/Resources/Internal User Components/"+$componentName+".4dbase/")
		
		If ($appComponent.file($componentName+".4DZ").exists)
			$appComponent.file($componentName+".4DZ").delete()
		End if 
		
		$result:=ZIP Create archive:C1640(Folder:C1567(fk database folder:K87:14).folder("Project"); $appComponent.file($componentName+".4DZ"))
		// TODO: copy other things like resources
		
		If ($result.success)
			If (Shift down:C543)
				RESTART 4D:C1292
			Else 
				SHOW ON DISK:C922($appComponent.file($componentName+".4DZ").platformPath)
			End if 
		End if 
		
	End if 
	
	ALERT:C41(JSON Stringify:C1217($result))
	
Function getAppiOSSDK
	
	// each night SDK is builded and injected to 4D
	// SDK in resource control is not the latest one (only sources are because source control are not for binary)
	// so here to test we could copy latest one from 4D app
	
	var $app : 4D:C1709.Folder
	$app:=Folder:C1567(Application file:C491; fk platform path:K87:2)
	
	var $sdk : 4D:C1709.File
	$sdk:=$app.file("Contents/Resources/Internal User Components/4D Mobile App.4dbase/Resources/sdk/ios.zip")
	
	var $component : 4D:C1709.Folder
	$component:=Folder:C1567(fk resources folder:K87:11).folder("sdk")
	
	// Do the job
	var $result : 4D:C1709.File
	$result:=$sdk.copyTo($component; fk overwrite:K87:5)
	
	SHOW ON DISK:C922($result.platformPath)
	
Function getTCiOSSDK
	// if there is new 4D app because of build failure, allow to get last one from build chain
	var $credential : 4D:C1709.File
	
	$credential:=cs:C1710.path.new().preferencesFile()
	If ($credential.exists)
		
		var $url : Text
		$url:="http://"+String:C10(JSON Parse:C1218($credential.getText()).tc)+"@srv-build:8111/repository/download/id4dmobile_4dIOSSdk_Build/.lastSuccessful/ios.zip"
		
		var $content : Blob
		var $code : Integer
		$code:=HTTP Request:C1158(HTTP GET method:K71:1; $url; ""; $content)
		If ($code=200)
			
			var $sdk : 4D:C1709.File
			$sdk:=Folder:C1567(fk resources folder:K87:11).file("sdk/ios.zip")
			
			$sdk.setContent($content)
			
		Else 
			ALERT:C41("Cannot get SDK "+String:C10($code))
		End if 
	Else 
		ALERT:C41("You must add tc with user:pass in 4d.mobile")
		SHOW ON DISK:C922(Folder:C1567(fk user preferences folder:K87:10).platformPath)
	End if 
	
	// MARK:- conf file
Function openConf
	SHOW ON DISK:C922(cs:C1710.path.new().preferencesFile().platformPath)
	
Function showFeatures
	ALERT:C41(JSON Stringify:C1217(Feature; *))
	
Function reloadFeatureFile
	Feature.loadLocal()
	
	// MARK:- local
Function findLocalizedResources
	var $data : Text
	$data:=Request:C163("Provide data"; Get text from pasteboard:C524; "Search")
	If (Length:C16($data)=0)
		return 
	End if 
	
	var $folder : 4D:C1709.Folder
	var $file : 4D:C1709.File
	For each ($folder; Folder:C1567(fk resources folder:K87:11).folders())
		If ($folder.extension=".lproj")
			For each ($file; $folder.files())
				If (($file.extension=".xlf") && (Position:C15($data; $file.getText())>0))
					OPEN URL:C673("file://"+File:C1566($file.platformPath; fk platform path:K87:2).path; "Code")
				End if 
			End for each 
		End if 
	End for each 
	
	
	// MARK:- source control
	
Function gitRebase()
	var $gitWorker : 4D:C1709.SystemWorker
	$gitWorker:=4D:C1709.SystemWorker.new("git rebase"; New object:C1471("currentDirectory"; Folder:C1567(fk database folder:K87:14)))
	
	ALERT:C41(String:C10($gitWorker.wait(10).response))
	
Function gitStatus()
	var $gitWorker : 4D:C1709.SystemWorker
	$gitWorker:=4D:C1709.SystemWorker.new("git add ."; New object:C1471("currentDirectory"; Folder:C1567(fk database folder:K87:14)))
	$gitWorker.wait(2)
	$gitWorker:=4D:C1709.SystemWorker.new("git status --porcelain"; New object:C1471("currentDirectory"; Folder:C1567(fk database folder:K87:14)))
	
	ALERT:C41(String:C10($gitWorker.wait(10).response))
	
Function gitOpenModified()
	var $gitWorker : 4D:C1709.SystemWorker
	$gitWorker:=4D:C1709.SystemWorker.new("git add ."; New object:C1471("currentDirectory"; Folder:C1567(fk database folder:K87:14)))
	$gitWorker.wait(2)
	$gitWorker:=4D:C1709.SystemWorker.new("git status --porcelain"; New object:C1471("currentDirectory"; Folder:C1567(fk database folder:K87:14)))
	
	var $lines : Collection
	$lines:=Split string:C1554(String:C10($gitWorker.wait(10).response); "\n")
	var $line : Text
	For each ($line; $lines)
		If (Position:C15("M "; $line)=1)  // modified line (we `add .` so no MM)
			$line:=Substring:C12($line; 5; Length:C16($line)-5)
			Case of 
				: (Position:C15("Sources/Methods/"; $line)>0)
					METHOD OPEN PATH:C1213(Folder:C1567($line).name)
				: (Position:C15("Sources/Classes/"; $line)>0)
					METHOD OPEN PATH:C1213("[class]/"+Folder:C1567($line).name)
				: (Position:C15("Sources/DatabaseMethods/"; $line)>0)
					METHOD OPEN PATH:C1213("[databaseMethod]/"+Folder:C1567($line).name)
				: (Position:C15("Sources/Forms/"; $line)>0)
					METHOD OPEN PATH:C1213("[projectForm]/"+Folder:C1567($line).name)
			End case 
		End if 
	End for each 
	