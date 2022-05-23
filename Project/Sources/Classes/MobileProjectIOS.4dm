Class extends MobileProject

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($project : Object)
	Super:C1705($project)
	
	// Copy project (to not modify original project data)
	Case of 
		: (Count parameters:C259>=1)
			This:C1470.project:=This:C1470._cleanCopyProject($project)
		: (Bool:C1537(This:C1470.debug))  // If dev use last build to test and test again
			This:C1470.project:=ob_parseFile(This:C1470.logFolder.file("lastBuild.ios.4dmobile")).value
		Else 
			ASSERT:C1129(False:C215; "Missing project parameters when building iOS app")
	End case 
	
	// Compute product name (used for files and scheme/target)
	Case of 
		: (Value type:C1509(This:C1470.project.name)=Is text:K8:3)
			This:C1470.productName:=This:C1470.project.name
		: (This:C1470.project._folder#Null:C1517)
			This:C1470.productName:=This:C1470.project._folder.name
		: (Value type:C1509($project.$project.product)=Is text:K8:3)
			This:C1470.productName:=$project.$project.product
		: ((Value type:C1509($project.$project.project)=Is text:K8:3) && (Folder:C1567($project.$project.project; fk platform path:K87:2).exists))
			This:C1470.productName:=Folder:C1567($project.$project.project; fk platform path:K87:2).name
		: (Value type:C1509(This:C1470.product.name)=Is text:K8:3)
			This:C1470.productName:=This:C1470.product.name
		Else 
			This:C1470.productName:="debug"
	End case 
	
	If ((This:C1470.project._folder=Null:C1517) && (Folder:C1567($project.$project.project; fk platform path:K87:2).exists))
		This:C1470.project._folder:=Folder:C1567($project.$project.project; fk platform path:K87:2)
	End if 
	
	// Keep the last used project
	This:C1470.logFolder.file("lastBuild.ios.4dmobile").setText(JSON Stringify:C1217(This:C1470.project; *))
	
	// Some utilities (mainly fake singleton)
	This:C1470.simctl:=cs:C1710.simctl.new()  // ASK: SHARED.iosDeploymentTarget ?
	This:C1470.cfgutil:=cs:C1710.cfgutil.new()
	
	// MARK:-[STEPS]
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Creating the project
Function create()->$result : Object
	
	Logger.info(Current method name:C684)
	
	$result:=New object:C1471(\
		"path"; This:C1470.input.path; \
		"success"; True:C214; \
		"errors"; New collection:C1472)
	
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
	$result.tags:=This:C1470._createTags()
	
	// Create the app manifest
	$result.manifest:=This:C1470._createManifest(This:C1470.project)
	
	// Target folder
	var $destinationFolder : 4D:C1709.Folder
	$destinationFolder:=Folder:C1567(This:C1470.input.path; fk platform path:K87:2)
	$destinationFolder.create()
	
	// Cache the last build in generated project
	This:C1470.input.appFolder:=Null:C1517  // Cyclic
	ob_writeToFile(This:C1470._cleanCopyProject(This:C1470.input); $destinationFolder.file("project.4dmobile"); True:C214)
	
	//===============================================================
	This:C1470.postStep("decompressionOfTheSdk")
	
	$result.sdk:=sdk(New object:C1471(\
		"action"; "install"; \
		"file"; This:C1470.paths.sdk().platformPath+"ios.zip"; \
		"target"; This:C1470.input.path))
	
	If (Not:C34($result.sdk.success))
		
		This:C1470.success:=False:C215
		$result.success:=False:C215
		
		// Failed to unzip sdk
		This:C1470.postError("failedDecompressTheSdk")
		This:C1470.logError("Failed to unzip sdk")
		return   // Guard stop
		
	End if 
	
	//===============================================================
	This:C1470.postStep("workspaceCreation")
	This:C1470._generateTemplates($result; $result.tags)
	
	If (Not:C34($result.success))
		
		return   // Guard stop: no need to do dump if failed to create the app
		
	End if 
	
	This:C1470._manageDataSet($result)
	This:C1470._generateCapabilities($result)
	This:C1470._devFeatures($result)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Building the App
Function build()->$result : Object
	
	Logger.info(Current method name:C684)
	
	$result:=New object:C1471
	$result.success:=False:C215
	
	var $Obj_result_build : Object
	
	If (This:C1470.input.realDevice)
		
		$Obj_result_build:=This:C1470._archive($result)  // Real device need ipa
		
	Else 
		
		$Obj_result_build:=This:C1470._build($result)
		
	End if 
	
	If ($Obj_result_build.app=Null:C1517)
		
		var $pathname : 4D:C1709.Folder
		$pathname:=Folder:C1567(This:C1470.input.path; fk platform path:K87:2).folder("build/Build/Products/Debug-iphonesimulator/"+This:C1470._schemeName+".app")
		
		If ($pathname.exists)
			
			$Obj_result_build.app:=$pathname.path
			
		End if 
	End if 
	
	$result.success:=$Obj_result_build.success
	This:C1470.build:=$Obj_result_build
	
	If (Not:C34($result.success))
		This:C1470.postError(ob_error_string($result))
		This:C1470.logError("Build or Archive Failed")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Running the application on a simulator or a connected device
Function run()->$result : Object
	
	Logger.info(Current method name:C684)
	
	$result:=New object:C1471
	
	If (This:C1470.input.realDevice)
		
		This:C1470.install($result)
		
	Else 
		
		This:C1470._runSimulator($result)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Running the application on a simulator
Function _runSimulator($out : Object)
	var $in; $simctl; $project : Object
	$in:=This:C1470.input
	$simctl:=This:C1470.simctl  // CLEAN: Maybe init only here
	$project:=This:C1470.project
	
	$in.product:=This:C1470.build.app
	
	If ($in.product=Null:C1517)
		ASSERT:C1129(dev_Matrix; "product to install not found")
		This:C1470.logError("product to install not found")
		return 
	End if 
	
	This:C1470.postStep("launchingTheSimulator")
	This:C1470.logInfo("Launching the Simulator")
	
	$out.device:=$simctl.device($in.project._simulator)
	
	If ($out.device=Null:C1517)
		
		This:C1470.postError("failedToOpenSimulator")
		This:C1470.logError("device not found")
		return   // guard
	End if 
	
	// boot if not booted
	If (Not:C34($simctl.isDeviceBooted($out.device.udid)))
		
		$simctl.bootDevice($out.device.udid; True:C214)
		$simctl.bringSimulatorAppToFront()
		
		DELAY PROCESS:C323(Current process:C322; 60*5)
		LAUNCH EXTERNAL PROCESS:C811("osascript -e 'tell app \"4D\" to activate'")
		
	End if 
	
	If (Not:C34($simctl.isDeviceBooted($out.device.udid)))
		This:C1470.postError("failedToOpenSimulator")
		This:C1470.logError("device not booted")
		return   //guard
	End if 
	
	$simctl.bringSimulatorAppToFront()
	
	This:C1470.postStep("installingTheApplication")
	
	If ($simctl.isAppInstalled($project.product.bundleIdentifier; $out.device.udid))
		
		This:C1470.logInfo("Uninstall the App")
		
		// Quit App
		$simctl.terminateApp($project.product.bundleIdentifier; $out.device.udid)
		
		// Better user impression because the simulator display the installation
		DELAY PROCESS:C323(Current process:C322; 10)
		
		// Uninstall App
		$simctl.uninstallApp($project.product.bundleIdentifier; $out.device.udid)
		
	End if 
	
	This:C1470.logInfo("Install the App")
	
	// Install App
	$simctl.installApp($in.product; $out.device.udid)
	
	If (Not:C34($simctl.success))
		
		// Redmine #102346: RETRY, if any
		If (Position:C15("MIInstallerErrorDomain, code=35"; $simctl.lastError)>0)
			
			$simctl.installApp($in.product; $out.device.udid)
			
		End if 
	End if 
	
	If (Not:C34($simctl.success))
		This:C1470.postError($simctl.lastError)
		This:C1470.logError("Failed to install the App ("+$simctl.lastError+")")
		return   // guard
	End if 
	
	// Launch App
	This:C1470.postStep("launchingTheApplication")
	This:C1470.logInfo("Launching the App")
	
	$simctl.launchApp($project.product.bundleIdentifier; $out.device.udid)
	
	If ($simctl.success)
		
		$simctl.bringSimulatorAppToFront()
		
	Else 
		
		This:C1470.postError($simctl.lastError)
		This:C1470.logInfo("Failed to launch the App ("+$simctl.lastError+")")
		
	End if 
	
Function get _schemeName()->$scheme : Text
	$scheme:=This:C1470.productName  // see usage as tag ___PRODUCT___ in template
	
Function get _archiveName()->$archive : Text
	$archive:=This:C1470.productName
	
Function _archive($out : Object)->$Obj_result_build : Object
	This:C1470.postStep("projectArchive")
	This:C1470.logInfo("Archiving project")
	
	var $in : Object
	$in:=This:C1470.input
	
	var $archivePath : 4D:C1709.Folder
	$archivePath:=Folder:C1567($in.path; fk platform path:K87:2).folder("archive").folder(This:C1470._archiveName+".xcarchive")
	
	$Obj_result_build:=Xcode(New object:C1471(\
		"action"; "build"; \
		"scheme"; This:C1470._schemeName; \
		"destination"; $in.path; \
		"sdk"; "iphoneos"; \
		"verbose"; This:C1470.debug; \
		"configuration"; "Release"; \
		"archive"; True:C214; \
		"allowProvisioningUpdates"; True:C214; \
		"allowProvisioningDeviceRegistration"; True:C214; \
		"archivePath"; $archivePath.path))
	
	This:C1470.logFolder.file("lastArchive.xlog").setText(String:C10($Obj_result_build.out))
	
	ob_error_combine($out; $Obj_result_build)
	
	If ($Obj_result_build.success)
		
		// And export
		This:C1470.postStep("projectArchiveExport")
		This:C1470.logInfo("Exporting project archive")
		
		$Obj_result_build:=Xcode(New object:C1471(\
			"action"; "build"; \
			"verbose"; This:C1470.debug; \
			"exportArchive"; True:C214; \
			"teamID"; String:C10($in.project.organization.teamId); \
			"stripSwiftSymbols"; Bool:C1537(SHARED.swift.Export.stripSwiftSymbols); \
			"exportMethod"; String:C10(SHARED.swift.Export.method); \
			"exportPath"; Folder:C1567($in.path; fk platform path:K87:2).folder("archive").path; \
			"archivePath"; $archivePath.path))
		
		This:C1470.logFolder.file("lastExportArchive.xlog").setText(String:C10($Obj_result_build.out))
		
		ob_error_combine($out; $Obj_result_build)
		
	Else 
		
		// Failed to archive
		// $ui.alert("failedToArchive")
		
	End if 
	
Function _build($out : Object)->$Obj_result_build : Object
	var $in : Object
	$in:=This:C1470.input
	
	// MARK: Build application
	This:C1470.postStep("projectBuild")
	This:C1470.logInfo("Building project")
	
	$Obj_result_build:=Xcode(New object:C1471(\
		"action"; "build"; \
		"scheme"; This:C1470._schemeName; \
		"destination"; $in.path; \
		"sdk"; $in.sdk; \
		"verbose"; This:C1470.debug; \
		"test"; Bool:C1537($in.test); \
		"target"; Convert path system to POSIX:C1106($in.path+"build"+Folder separator:K24:12)))
	
	ob_error_combine($out; $Obj_result_build)
	
	This:C1470.logFolder.file("lastBuild.xlog").setText(String:C10($Obj_result_build.out))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Installing the IPA on a connected device
Function install()
	
	// MARK:-[PRIVATE]
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
	// [PRIVATE] - copy and clean Project
Function _cleanCopyProject($projectInput : Object)->$project : Object
	$project:=OB Copy:C1225($projectInput.project)
	
	// * CLEANING INNER $OBJECTS
	var $o : Object
	For each ($o; OB Entries:C1720($project).query("key=:1"; "$@"))
		
		OB REMOVE:C1226($project; $o.key)
		
	End for each 
	
	If (False:C215)
		
		This:C1470._tmpRemoveAlias($project)
		
	End if 
	
Function _tmpRemoveAlias($project : Object/*in place*/)->$removedEntries : Collection
	
	$removedEntries:=New collection:C1472
	
	// remove from data model
	var $tableNumber; $fieldKey : Text
	var $field : Variant
	For each ($tableNumber; $project.dataModel || New object:C1471)
		For each ($fieldKey; $project.dataModel[$tableNumber])
			$field:=$project.dataModel[$tableNumber][$fieldKey]
			If ((Value type:C1509($field)=Is object:K8:27) && (String:C10($field.kind)="alias"))
				OB REMOVE:C1226($project.dataModel[$tableNumber]; $fieldKey)
				$removedEntries.push(New object:C1471("tableNumber"; $tableNumber; "fieldName"; $fieldKey))  // fieldName because alias
			End if 
		End for each 
	End for each 
	
	// remove now from form
	var $removedEntry : Object
	var $formType : Text
	var $index : Integer
	For each ($removedEntry; $removedEntries)
		For each ($formType; New collection:C1472("detail"; "list"))
			If ($project[$formType][$removedEntry.tableNumber]#Null:C1517)
				If (Value type:C1509($project[$formType][$removedEntry.tableNumber].fields)=Is collection:K8:32)
					For ($index; 0; $project[$formType][$removedEntry.tableNumber].fields.length-1; 1)
						If (($project[$formType][$removedEntry.tableNumber].fields[$index]#Null:C1517)\
							 && (String:C10($project[$formType][$removedEntry.tableNumber].fields[$index].name)=$removedEntry.fieldName))
							$project[$formType][$removedEntry.tableNumber].fields[$index]:=Null:C1517
						End if 
					End for 
				End if 
			End if 
		End for each 
	End for each 
	
	// MARK:-[PRIVATES]
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Create tags object for template
Function _createTags()->$tags : Object
	
	$tags:=OB Copy:C1225(SHARED.tags)  // Common project tags
	
	$tags.product:=This:C1470.productName  //tag ___PRODUCT___
	$tags.packageName:=$tags.product
	
	// Project file tags
	$tags.bundleIdentifier:=This:C1470.project.product.bundleIdentifier
	$tags.company:=This:C1470.project.organization.name
	
	If (Length:C16(This:C1470.project.organization.teamId)>0)
		
		$tags.teamId:=This:C1470.project.organization.teamId
		
	End if 
	
	// • Info plist
	$tags.displayName:=This:C1470.project.product.name
	$tags.version:=This:C1470.project.product.version
	$tags.build:=This:C1470.fullVersion($tags.version)
	
	$tags.prodUrl:=This:C1470.project.server.urls.production
	
	If (Length:C16($tags.prodUrl)>0)
		
		$tags.prodUrl:=Replace string:C233($tags.prodUrl; "localhost"; "127.0.0.1")
		
		If (Not:C34(Match regex:C1019("(?i-ms)http[s]?://"; $tags.prodUrl; 1)))
			
			// Default to http
			$tags.prodUrl:="http://"+$tags.prodUrl
			
		End if 
	End if 
	
	var $httpServer
	$httpServer:=WEB Get server info:C1531
	$tags.serverHTTPSPort:=String:C10($httpServer.options.webHTTPSPortID)
	$tags.serverPort:=String:C10($httpServer.options.webPortID)
	
	Case of 
			
			//________________________________________
		: (Bool:C1537($httpServer.security.HTTPEnabled))  // Priority for http
			
			$tags.serverScheme:="http"
			
			//________________________________________
		: (Bool:C1537($httpServer.security.HTTPSEnabled))  // Only https, use it
			
			$tags.serverScheme:="https"
			
			//________________________________________
		Else 
			
			$tags.serverScheme:=""  // Default: let mobile app defined default?
			
			//________________________________________
	End case 
	
	$tags.serverUrls:=$httpServer.options.webIPAddressToListen.join(","; ck ignore null or empty:K85:5)
	
	$tags.serverAuthenticationEmail:=Choose:C955(Bool:C1537(This:C1470.project.server.authentication.email); "true"; "false")  // plist bool format
	$tags.serverAuthenticationReloadData:=Choose:C955(Bool:C1537(This:C1470.project.server.authentication.reloadData); "true"; "false")  // plist bool format
	
	// • Source files tags
	$tags.copyright:=This:C1470.project.product.copyright
	$tags.fullname:=This:C1470.project.developer.name
	$tags.date:=String:C10(Current date:C33; Date RFC 1123:K1:11; Current time:C178)
	
	// • Scripts
	$tags.xCodeVersion:=This:C1470.project.$project.xCode.version
	
	// • Navigation tags
	$tags.navigationTitle:=This:C1470.project.main.navigationTitle
	$tags.navigationType:=This:C1470.project.main.navigationType
	$tags.navigationTransition:=This:C1470.project.ui.navigationTransition
	
	// • Launchscreen
	$tags.launchScreenBackgroundColor:=SHARED.infoPlist.storyboard.backgroundColor  // FR #93800: take from project configuration
	
	// • Setting
	$tags.hasAction:=Choose:C955(Bool:C1537(mobile_actions("hasAction"; This:C1470.input).value); "true"; "false")  // plist bool format
	
	// • SDK
	$tags.sdkVersion:=String:C10(This:C1470.sdk.version)
	
	
Function _generateTemplates($out : Object; $tags : Object)
	var $template; $in; $project : Object
	$in:=This:C1470.input
	$project:=This:C1470.project
	// ASSERT($project._folder#Null) // to optimize
	
	var $Dir_template : 4D:C1709.Folder
	$Dir_template:=This:C1470.paths.templates().folder($in.template)
	If (Asserted:C1132($Dir_template.file("manifest.json").exists))
		
		$template:=ob_parseFile($Dir_template.file("manifest.json")).value
		
	End if 
	
	ASSERT:C1129($template.assets.path#Null:C1517)
	ASSERT:C1129($template.sdk.version#Null:C1517)
	
	If ($Dir_template.folder("ios").exists)  // or manifest design path of all sources of templates for ios target
		$template.source:=$Dir_template.folder("ios").platformPath
	Else 
		$template.source:=$Dir_template.platformPath
	End if 
	$template.assets.target:=$in.path+Convert path POSIX to system:C1107($template.assets.path)+Folder separator:K24:12+$template.assets.name+Folder separator:K24:12
	If ($project._folder#Null:C1517)
		$template.assets.source:=This:C1470.project._folder.folder($template.assets.name).platformPath
	End if 
	If ($template.assets.source=Null:C1517 || Not:C34(Folder:C1567($template.assets.source; fk platform path:K87:2).exists))
		// expected path for mobile project file
		$template.assets.source:=This:C1470.paths.projects().folder(This:C1470.productName).folder($template.assets.name).platformPath
	End if 
	
	$out.rootTemplate:=$template
	
	
	// I need a map, string -> format to be able to support folder name different from manifest name
	$out.formatters:=formatters(New object:C1471("action"; "getByName")).formatters
	$out.inputControls:=mobile_actions("getByName").inputControls
	
	// Duplicate the template {
	$out.template:=cs:C1710.MainTemplate.new(New object:C1471(\
		"template"; $template; \
		"path"; $in.path; \
		"tags"; $tags; \
		"formatters"; $out.formatters; \
		"inputControls"; $out.inputControls; \
		"project"; This:C1470.project)).run()
	
	ob_error_combine($out; $out.template)
	
	$out.projfile:=$out.template.projfile
	ob_removeProperty($out.template; "projfile")  // redundant information
	
	// Add some asset fix (could optimize by merging fix)
	var $fixes : Object
	$fixes:=cs:C1710.Storyboards.new(Folder:C1567($in.path+"Sources"+Folder separator:K24:12+"Forms"; fk platform path:K87:2))
	$out.colorAssetFix:=$fixes.colorAssetFix($out.template.theme)
	ob_error_combine($out; $out.colorAssetFix)
	
	$out.imageAssetFix:=$fixes.imageAssetFix()
	ob_error_combine($out; $out.imageAssetFix)
	
	// Set writable target directory with all its subfolders and files
	//doc_UNLOCK_DIRECTORY(New object("path"; $in.path)) // ASK: move elsewhere
	
	//  MARK: Structure & Data
	
	// Create catalog and data files {
Function _manageDataSet($out : Object)
	var $in; $project; $tags; $template : Object
	$in:=This:C1470.input
	$project:=This:C1470.project
	$tags:=$out.tags
	$template:=$out.rootTemplate
	
	If ($in.structureAdjustments=Null:C1517)
		
		$in.structureAdjustments:=Bool:C1537($in.test)  // default value for test
		
	End if 
	
	If (Bool:C1537($in.structureAdjustments))
		
		$out.structureAdjustments:=_o_structure(New object:C1471(\
			"action"; "create"; \
			"tables"; dataModel(New object:C1471(\
			"action"; "tableNames"; \
			"dataModel"; $project.dataModel; \
			"relation"; True:C214)).values))
		
	End if 
	
	If (Feature.with("buildWithCmd"))
		
		If (Feature.with("xcDataModelClass"))
			$out.coreData:=cs:C1710.xcDataModel.new($project).run(\
				/*path*/$in.path+"Sources"+Folder separator:K24:12+"Structures.xcdatamodeld"; \
				/*options*/New object:C1471("flat"; False:C215; "relationship"; True:C214))
		Else 
			$out.coreData:=xcDataModel(New object:C1471(\
				"action"; "xcdatamodel"; \
				"dataModel"; $project.dataModel; \
				"actions"; $project.actions; \
				"flat"; False:C215; \
				"relationship"; True:C214; \
				"path"; $in.path+"Sources"+Folder separator:K24:12+"Structures.xcdatamodeld"))
		End if 
		
		ob_error_combine($out; $out.coreData)
		
	End if 
	
	If (Feature.with("buildWithCmd"))
		If (Bool:C1537($in.noData))  // for the moment deactivate data dump,
			return   // maybe the key must be passed to dump from a remote server source later
		End if 
	End if 
	
	$out.dump:=dataSet(New object:C1471(\
		"action"; "check"; \
		"digest"; True:C214; \
		"coreDataSet"; Feature.with("androidDataSet"); \
		"project"; $project))
	ob_error_combine($out; $out.dump)
	
	If (Bool:C1537($out.dump.exists))
		
		If (Not:C34($out.dump.valid) | Not:C34(Bool:C1537($project.dataSource.doNotGenerateDataAtEachBuild)))
			
			$out.dump:=dataSet(New object:C1471(\
				"action"; "erase"; \
				"project"; $project))
			
		End if 
	End if 
	
	$out.dump:=dataSet(New object:C1471(\
		"action"; "check"; \
		"digest"; False:C215; \
		"project"; $project))
	
	If (Not:C34(Bool:C1537($out.dump.exists)))
		
		If (String:C10($in.dataSource.source)="server")
			
			// <NOTHING MORE TO DO>
			
		Else 
			var $keyPath : 4D:C1709.File
			var $pathname : Text
			
			$keyPath:=This:C1470.paths.key()
			
			$pathname:=$keyPath.platformPath
			
			If (Not:C34($keyPath.exists))
				
				$out.keyPing:=Rest(New object:C1471(\
					"action"; "status"; \
					"handler"; "mobileapp"))
				$out.keyPing.file:=New object:C1471(\
					"path"; $pathname; \
					"exists"; $keyPath.exists)
				
				If (Not:C34($out.keyPing.file.exists))
					
					ob_error_add($out; "Local server key file do not exists and cannot be created")
					
				End if 
			End if 
		End if 
		
		$out.dump:=dataSet(New object:C1471(\
			"action"; "create"; \
			"project"; This:C1470.project; \
			"digest"; True:C214; \
			"dataSet"; True:C214; \
			"key"; $pathname; \
			"caller"; $in.caller; \
			"verbose"; This:C1470.verbose; \
			"keepUI"; True:C214; \
			"method"; "editor_CALLBACK"; \
			"message"; "endOfDatasetGeneration"))
		
		ob_error_combine($out; $out.dump)
		
	End if 
	
	// Then copy
	$out.dumpCopy:=dataSet(New object:C1471(\
		"action"; "copy"; \
		"project"; $project; \
		"target"; $in.path))
	ob_error_combine($out; $out.dumpCopy)
	//}
	
	If (Feature.disabled("buildWithCmd"))
		
		If (Feature.with("xcDataModelClass"))
			$out.coreData:=cs:C1710.xcDataModel.new($project).run(\
				/*path*/$in.path+"Sources"+Folder separator:K24:12+"Structures.xcdatamodeld"; \
				/*options*/New object:C1471("flat"; False:C215; "relationship"; True:C214))
		Else 
			$out.coreData:=xcDataModel(New object:C1471(\
				"action"; "xcdatamodel"; \
				"dataModel"; $project.dataModel; \
				"actions"; $project.actions; \
				"flat"; False:C215; \
				"relationship"; True:C214; \
				"path"; $in.path+"Sources"+Folder separator:K24:12+"Structures.xcdatamodeld"))
		End if 
		
		ob_error_combine($out; $out.coreData)
		
	End if 
	
	If (Not:C34(Bool:C1537($project.dataSource.doNotGenerateDataAtEachBuild)))
		
		This:C1470.postStep("dataSetGeneration")
		
	End if 
	
	var $destinationFolder : 4D:C1709.Folder
	$destinationFolder:=Folder:C1567(This:C1470.input.path; fk platform path:K87:2)
	If ($destinationFolder.folder("Resources/Assets.xcassets/Data").exists)  // If there JSON data (maybe use asset("action";"path"))
		
		$out.coreDataSet:=dataSet(New object:C1471(\
			"action"; "coreData"; \
			"removeAsset"; True:C214; \
			"path"; $in.path))
		
		ob_error_combine($out; $out.coreDataSet)
		
		If (Bool:C1537($out.coreDataSet.success))
			
			dataSet(New object:C1471(\
				"action"; "coreDataAddToProject"; \
				"uuid"; $template.uuid; \
				"tags"; $tags; \
				"path"; $in.path))
			
		End if 
		
	Else 
		
		dataSet(New object:C1471(\
			"action"; "coreDataAddToProject"; \
			"uuid"; $template.uuid; \
			"tags"; $tags; \
			"path"; $in.path))
		
	End if 
	
Function _generateCapabilities($out : Object; $appFolder : 4D:C1709.Folder)
	var $project; $in; $tags : Object
	$project:=This:C1470.project
	$tags:=$out.tags
	$in:=This:C1470.input
	
	$out.actionAssets:=mobile_actions("assets"; New object:C1471(\
		"project"; $project; \
		"inputControls"; $out.inputControls; \
		"target"; $in.path))
	ob_error_combine($out; $out.actionAssets)
	
	$out.actionCapabilities:=mobile_actions("capabilities"; New object:C1471(\
		"project"; $project; \
		"inputControls"; $out.inputControls; \
		"target"; $in.path))
	
	$out.computedCapabilities:=New object:C1471(\
		"capabilities"; New object:C1471())
	
	// #133381 : add always location & camera capabilities
	// because Apple warn about it, because of code in SDK (QMobileUI mainly)
	// (OR we need to split the SDK and have some injection if the feature is used, or inject code or not in final app)
	$out.computedCapabilities.capabilities.location:=True:C214
	$out.computedCapabilities.capabilities.camera:=True:C214
	
	If (Bool:C1537($project.server.pushNotification))
		
		$out.computedCapabilities.capabilities.pushNotification:=True:C214
		
		If (Length:C16(String:C10($project.server.pushCertificate))>0)
			
			var $certificateFile : Object
			$certificateFile:=cs:C1710.doc.new($project.server.pushCertificate).target
			
			If ($certificateFile.exists)
				
				$certificateFile.copyTo(This:C1470._getAppDataFolder(); fk overwrite:K87:5)
				
			Else 
				
				ob_warning_add($out; "Certificate file "+String:C10($project.server.pushCertificate)+" is missing")
				
			End if 
		End if 
	End if 
	
	If (Bool:C1537($project.deepLinking.enabled))
		
		If (Length:C16(String:C10($project.deepLinking.urlScheme))>0)
			
			var $urlScheme : Text
			$urlScheme:=String:C10($project.deepLinking.urlScheme)
			$urlScheme:=Replace string:C233($urlScheme; "://"; "")
			$out.computedCapabilities.capabilities.urlSchemes:=New collection:C1472($urlScheme)
			
		End if 
		
		If (Length:C16(String:C10($project.deepLinking.associatedDomain))>0)
			
			var $associatedDomain : Text
			$associatedDomain:=String:C10($project.deepLinking.associatedDomain)
			$associatedDomain:=Replace string:C233($associatedDomain; "https://"; "")
			$associatedDomain:=Replace string:C233($associatedDomain; "http://"; "")
			
			If (($associatedDomain[[Length:C16($associatedDomain)]])="/")  // Strip last /
				
				$associatedDomain:=Substring:C12($associatedDomain; 1; Length:C16($associatedDomain)-1)
				
			End if 
			
			$out.computedCapabilities.capabilities.associatedDomain:=$associatedDomain
			
		End if 
	End if 
	
	var $isSearchable : Object
	$isSearchable:=ob findPropertyValues($project; "searchableWithBarcode")
	
	If ($isSearchable.success)
		
		If ($isSearchable.value.reduce("col_formula"; False:C215; Formula:C1597($1.accumulator:=$1.accumulator | $1.value)))
			
			// XXX could check that we have positive value? $isSearchable
			$out.computedCapabilities.capabilities.camera:=True:C214
			
		End if 
	End if 
	
	// Manage app capabilities
	$out.capabilities:=capabilities(\
		New object:C1471("action"; "inject"; "target"; $in.path; "tags"; $tags; \
		"value"; New object:C1471(\
		"common"; SHARED; \
		"project"; $project; \
		"action"; $out.actionCapabilities; \
		"computed"; $out.computedCapabilities; \
		"templates"; $out.template)))
	ob_error_combine($out; $out.capabilities)
	
	// Internal feature to help to dev iOS project
Function _devFeatures($out : Object)
	
	If (Feature.with("generateForDev"))  // In feature until fix project launch with xcode
		
		Xcode(New object:C1471(\
			"action"; "workspace-addsources"; \
			"path"; This:C1470.input.path))
	End if 
	//}
	
	// Backup into git {
	If (Feature.with("gitCommit"))
		
		git(New object:C1471(\
			"action"; "config core.autocrlf"; \
			"path"; This:C1470.input.path))
		
		$out.git:=git(New object:C1471(\
			"action"; "init"; \
			"path"; This:C1470.input.path))
		
		If ($out.git.success)
			
			$out.git:=git(New object:C1471(\
				"action"; "add -A"; \
				"path"; This:C1470.input.path))
			
			$out.git:=git(New object:C1471(\
				"action"; "commit -m initial"; \
				"path"; This:C1470.input.path))
			
		End if 
	End if 
	//}
	