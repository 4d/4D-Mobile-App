

Function fillMenu($menu : Object)
	$menu.append("Inject component in 4D app"; "injectComponentToCurrentApp").method("menu_component")
	$menu.append("Get iOS SDK from 4D app"; "getAppiOSSDK").method("menu_component")
	$menu.append("Get iOS SDK from TC"; "getTCiOSSDK").method("menu_component")
	$menu.line()
	$menu.append("Show configuration file"; "openConf").method("menu_component")
	$menu.append("Show current features"; "showFeatures").method("menu_component")
	$menu.append("Re-load features file"; "reloadFeatureFile").method("menu_component")
	
Function injectComponentToCurrentApp
	// sometime you want to debug other 4d database mobile app
	// and want to use TRACE or debug
	// so replace into current 4d app the 4d mobile app by this one to debug
	
	var $app : 4D:C1709.Folder
	$app:=Folder:C1567(Application file:C491; fk platform path:K87:2)
	
	var $appComponent : 4D:C1709.Folder
	$appComponent:=$app.folder("Contents/Resources/Internal User Components/4D Mobile App.4dbase/")
	
	If ($appComponent.exists)
		$appComponent.delete(Delete with contents:K24:24)
	End if 
	
	var $result : 4D:C1709.Folder
	$result:=Folder:C1567(fk database folder:K87:14).copyTo($appComponent.parent; "4D Mobile App.4dbase")
	
	SHOW ON DISK:C922($result.platformPath)
	
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
	
	$credential:=Folder:C1567(fk user preferences folder:K87:10).file("4d.mobile")
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
	
Function openConf
	SHOW ON DISK:C922(Folder:C1567(fk user preferences folder:K87:10).file("4d.mobile").platformPath)
	
Function showFeatures
	ALERT:C41(JSON Stringify:C1217(Feature; *))
	
Function reloadFeatureFile
	Feature.loadLocal()