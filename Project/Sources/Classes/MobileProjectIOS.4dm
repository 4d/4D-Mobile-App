Class extends MobileProject

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($project : Object)
	
	Super:C1705($project)
	
	This:C1470.project:=OB Copy:C1225($project.project)
	
	// * CLEANING INNER $OBJECTS
	var $o : Object
	For each ($o; OB Entries:C1720(This:C1470.project).query("key=:1"; "$@"))
		
		OB REMOVE:C1226(This:C1470.project; $o.key)
		
	End for each 
	
	This:C1470.productName:=This:C1470.project._folder.name
	
	// Keep the last used project
	This:C1470.paths.userCache().file("lastBuild.ios.4dmobile").setText(JSON Stringify:C1217(This:C1470.project; *))
	
	This:C1470.sdk:=sdk(New object:C1471(\
		"action"; "install"; \
		"file"; This:C1470.paths.sdk().platformPath+"ios.zip"; \
		"target"; This:C1470.input.path))
	
	This:C1470.success:=This:C1470.sdk.success
	
	This:C1470.simctl:=cs:C1710.simctl.new()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Creating the project
Function create()->$result : Object
	
	$result:=New object:C1471(\
		"path"; This:C1470.input.path; \
		"sdk"; This:C1470.sdk; \
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	If (This:C1470.success)
		
		//===============================================================
		This:C1470.postStep("waitingForXcode")
		
		// * WAIT FOR XCODE - Must also close and delete folders if no change and want to recreate.
		Xcode(New object:C1471(\
			"action"; "safeDelete"; \
			"path"; This:C1470.input.path))
		
		This:C1470.logInfo("Create project")
		
		// Check if we have to reload data
		This:C1470._checkToReloadData()
		
		// Create tags object for template
		This:C1470._createTags()
		
		// Create the app manifest
		This:C1470._createManifest()
		
		//===============================================================
		This:C1470.postStep("decompressionOfTheSdk")
		
		// Target folder
		var $destinationFolder : 4D:C1709.Folder
		$destinationFolder:=Folder:C1567(This:C1470.input.path; fk platform path:K87:2)
		$destinationFolder.create()
		
		// Cache the last build for debug purpose
		ob_writeToFile(This:C1470.input; $destinationFolder.file("project.4dmobile"); True:C214)
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	Else 
		
		// <NOTHING MORE TO DO>
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Building the App
Function build()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Runing the App on a simulator
Function run()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Installing the APK on a connected device
Function install()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// [PRIVATE] - Check if we have to reload data
Function _checkToReloadData()
	
	var $key : Text
	var $authentication; $datamodel : Object
	
	If (This:C1470.project.server.authentication=Null:C1517)
		
		This:C1470.project.server.authentication:=New object:C1471
		
	End if 
	
	$authentication:=This:C1470.project.server.authentication
	$datamodel:=This:C1470.project.dataModel
	
	$authentication.reloadData:=False:C215
	
	// 1] If there is at least a filter with parameters
	For each ($key; $datamodel) Until (Not:C34($authentication.reloadData))
		
		If (Value type:C1509($datamodel[$key][""].filter)=Is object:K8:27)
			
			If (Bool:C1537($datamodel[$key][""].filter.parameters))
				
				$authentication.reloadData:=True:C214
				
			End if 
		End if 
	End for each 
	
	// 2] No embedded data for at least one table
	If (Not:C34($authentication.reloadData))
		
		For each ($key; $datamodel)
			
			If (Not:C34(Bool:C1537($datamodel[$key][""].embedded)))
				
				$authentication.reloadData:=True:C214
				
			End if 
		End for each 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// [PRIVATE] - Create the app manifest
Function _createManifest()
	
	This:C1470.manifest:=New object:C1471(\
		"application"; New object:C1471(\
		"id"; This:C1470.project.product.bundleIdentifier; \
		"name"; This:C1470.project.product.name); \
		"team"; New object:C1471(\
		"id"; This:C1470.project.organization.teamId); \
		"info"; This:C1470.project.info)
	
	This:C1470.manifest.id:=String:C10(This:C1470.manifest.team.id)+"."+This:C1470.manifest.application.id
	
	// • Deep linking
	If (Bool:C1537(This:C1470.project.deepLinking.enabled))
		
		If (Length:C16(String:C10(This:C1470.project.deepLinking.urlScheme))>0)
			
			This:C1470.manifest.urlScheme:=String:C10(This:C1470.project.deepLinking.urlScheme)
			This:C1470.manifest.urlScheme:=Replace string:C233(This:C1470.manifest.urlScheme; "://"; "")
			
		End if 
		
		If (Length:C16(String:C10(This:C1470.project.deepLinking.associatedDomain))>0)
			
			This:C1470.manifest.associatedDomain:=String:C10(This:C1470.project.deepLinking.associatedDomain)
			
		End if 
	End if 
	
	This:C1470.appFolder:=Folder:C1567(fk mobileApps folder:K87:18; *).folder(This:C1470.manifest.id)
	This:C1470.appFolder.create()
	This:C1470.appFolder.file("manifest.json").setText(JSON Stringify:C1217(This:C1470.manifest; *))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// [PRIVATE] - Create tags object for template
Function _createTags()
	
	This:C1470.tags:=SHARED.tags  // Common project tags
	
	This:C1470.tags.product:=This:C1470.productName
	This:C1470.tags.packageName:=This:C1470.tags.product
	
	// Project file tags
	This:C1470.tags.bundleIdentifier:=This:C1470.project.product.bundleIdentifier
	This:C1470.tags.company:=This:C1470.project.organization.name
	
	If (Length:C16(This:C1470.project.organization.teamId)>0)
		
		This:C1470.tags.teamId:=This:C1470.project.organization.teamId
		
	End if 
	
	// • Info plist
	This:C1470.tags.displayName:=This:C1470.project.product.name
	This:C1470.tags.version:=This:C1470.project.product.version
	This:C1470.tags.build:=This:C1470.fullVersion(This:C1470.tags.version)
	
	This:C1470.tags.prodUrl:=This:C1470.project.server.urls.production
	
	If (Length:C16(This:C1470.tags.prodUrl)>0)
		
		This:C1470.tags.prodUrl:=Replace string:C233(This:C1470.tags.prodUrl; "localhost"; "127.0.0.1")
		
		If (Not:C34(Match regex:C1019("(?i-ms)http[s]?://"; This:C1470.tags.prodUrl; 1)))
			
			// Default to http
			This:C1470.tags.prodUrl:="http://"+This:C1470.tags.prodUrl
			
		End if 
	End if 
	
	var $httpServer
	$httpServer:=WEB Get server info:C1531
	This:C1470.tags.serverHTTPSPort:=String:C10($httpServer.options.webHTTPSPortID)
	This:C1470.tags.serverPort:=String:C10($httpServer.options.webPortID)
	
	Case of 
			
			//________________________________________
		: (Bool:C1537($httpServer.security.HTTPEnabled))  // Priority for http
			
			This:C1470.tags.serverScheme:="http"
			
			//________________________________________
		: (Bool:C1537($httpServer.security.HTTPSEnabled))  // Only https, use it
			
			This:C1470.tags.serverScheme:="https"
			
			//________________________________________
		Else 
			
			This:C1470.tags.serverScheme:=""  // Default: let mobile app defined default?
			
			//________________________________________
	End case 
	
	This:C1470.tags.serverUrls:=$httpServer.options.webIPAddressToListen.join(","; ck ignore null or empty:K85:5)
	
	This:C1470.tags.serverAuthenticationEmail:=Choose:C955(Bool:C1537(This:C1470.project.server.authentication.email); "true"; "false")  // plist bool format
	This:C1470.tags.serverAuthenticationReloadData:=Choose:C955(Bool:C1537(This:C1470.project.server.authentication.reloadData); "true"; "false")  // plist bool format
	
	// • Source files tags
	This:C1470.tags.copyright:=This:C1470.project.product.copyright
	This:C1470.tags.fullname:=This:C1470.project.developer.name
	This:C1470.tags.date:=String:C10(Current date:C33; Date RFC 1123:K1:11; Current time:C178); 
	
	// • Scripts
	This:C1470.tags.xCodeVersion:=This:C1470.project.$project.xCode.version
	
	// • Navigation tags
	This:C1470.tags.navigationTitle:=This:C1470.project.main.navigationTitle
	This:C1470.tags.navigationType:=This:C1470.project.main.navigationType
	This:C1470.tags.navigationTransition:=This:C1470.project.ui.navigationTransition
	
	// • Launchscreen
	This:C1470.tags.launchScreenBackgroundColor:=SHARED.infoPlist.storyboard.backgroundColor  // FR #93800: take from project configuration
	
	// • Setting
	This:C1470.tags.hasAction:=Choose:C955(Bool:C1537(mobile_actions("hasAction"; This:C1470.input).value); "true"; "false")  // plist bool format
	
	// • SDK
	This:C1470.tags.sdkVersion:=String:C10(This:C1470.sdk.version)
	