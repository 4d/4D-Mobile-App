Class extends MobileProject

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($project : Object)
	Super:C1705($project)
	
	// Copy project (to not modify original project data)
	
	If (Count parameters:C259>=1)
		This:C1470.project:=This:C1470._cleanCopyProject($project)
		This:C1470.productName:=This:C1470.project._folder.name
	Else 
		If (This:C1470.debug)  // use last build to test and test again
			This:C1470.project:=ob_parseFile(This:C1470.logFolder.file("lastBuild.ios.4dmobile")).value
			This:C1470.productName:="debug"
		End if 
	End if 
	
	// Keep the last used project
	This:C1470.logFolder.file("lastBuild.ios.4dmobile").setText(JSON Stringify:C1217(This:C1470.project; *))
	
	// Some utilities (mainly fake singleton)
	This:C1470.simctl:=cs:C1710.simctl.new()  // ASK: SHARED.iosDeploymentTarget ?
	This:C1470.cfgutil:=cs:C1710.cfgutil.new()
	
	// MARK:- steps
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Creating the project
Function create()->$result : Object
	
	$result:=New object:C1471(\
		"path"; This:C1470.input.path; \
		"success"; False:C215; \
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
	This:C1470._createTags()
	
	// Create the app manifest
	This:C1470._createManifest()
	
	// Target folder
	var $destinationFolder : 4D:C1709.Folder
	$destinationFolder:=Folder:C1567(This:C1470.input.path; fk platform path:K87:2)
	$destinationFolder.create()
	
	//===============================================================
	This:C1470.postStep("decompressionOfTheSdk")
	
	// Cache the last build in generated project
	ob_writeToFile(This:C1470.input; $destinationFolder.file("project.4dmobile"); True:C214)
	
	// SDK
	$result.sdk:=sdk(New object:C1471(\
		"action"; "install"; \
		"file"; This:C1470.paths.sdk().platformPath+"ios.zip"; \
		"target"; This:C1470.input.path))
	
	If (Not:C34($result.sdk.success))
		This:C1470.success:=False:C215
		return   // guard stop
	End if 
	
	
	
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Building the App
Function build()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Runing the App on a simulator
Function run()->$result : Object
	
	var $o : Object
	
	If (This:C1470.input.realDevice)
		
		$result:=This:C1470.install()
		
		
	End if 
	
	
Function _archive()
/*
$ui.step("projectArchive")
$log.information("Archiving project")
	
		$Obj_result_build:=Xcode(New object(\
				"action"; "build"; \
				"scheme"; $productName; \
				"destination"; $in.path; \
				"sdk"; "iphoneos"; \
				"verbose"; $isDebug; \
				"configuration"; "Release"; \
				"archive"; True; \
				"allowProvisioningUpdates"; True; \
				"allowProvisioningDeviceRegistration"; True; \
				"archivePath"; Convert path system to POSIX($in.path+"archive"+Folder separator+$productName+".xcarchive")))
	
$cacheFolder.file("lastArchive.xlog").setText(String($Obj_result_build.out))
	
ob_error_combine($out; $Obj_result_build)
	
If ($Obj_result_build.success)
	
// And export
$ui.step("projectArchiveExport")
$log.information("Exporting project archive")
	
		$Obj_result_build:=Xcode(New object(\
				"action"; "build"; \
				"verbose"; $isDebug; \
				"exportArchive"; True; \
				"teamID"; String($in.project.organization.teamId); \
				"stripSwiftSymbols"; Bool(SHARED.swift.Export.stripSwiftSymbols); \
				"exportMethod"; String(SHARED.swift.Export.method); \
				"exportPath"; Convert path system to POSIX($in.path+"archive"+Folder separator); \
				"archivePath"; Convert path system to POSIX($in.path+"archive"+Folder separator+$productName+".xcarchive")))
	
$path.userCache().file("lastExportArchive.xlog").setText(String($Obj_result_build.out))
	
ob_error_combine($out; $Obj_result_build)
	
Else 
	
// Failed to archive
$ui.alert("failedToArchive")
	
End if 
*/
	
Function doBuild
/*
// MARK: Build application
$ui.step("projectBuild")
$log.information("Building project")
	
If ($in.realDevice)
	
		$Obj_result_build:=Xcode(New object(\
				"action"; "build"; \
				"scheme"; $productName; \
				"destination"; $in.path; \
				"sdk"; "iphoneos"; \
				"verbose"; $isDebug; \
				"configuration"; "Release"; \
				"archive"; True; \
				"allowProvisioningUpdates"; True; \
				"allowProvisioningDeviceRegistration"; True; \
				"archivePath"; Convert path system to POSIX($in.path+"archive"+Folder separator+$productName+".xcarchive")))
	
$cacheFolder.file("lastArchive.xlog").setText(String($Obj_result_build.out))
	
ob_error_combine($out; $Obj_result_build)
	
If ($Obj_result_build.success)
	
// And export
$ui.step("projectArchiveExport")
$log.information("Exporting project archive")
	
		$Obj_result_build:=Xcode(New object(\
				"action"; "build"; \
				"verbose"; $isDebug; \
				"exportArchive"; True; \
				"teamID"; String($in.project.organization.teamId); \
				"stripSwiftSymbols"; Bool(SHARED.swift.Export.stripSwiftSymbols); \
				"exportMethod"; String(SHARED.swift.Export.method); \
				"exportPath"; Convert path system to POSIX($in.path+"archive"+Folder separator); \
				"archivePath"; Convert path system to POSIX($in.path+"archive"+Folder separator+$productName+".xcarchive")))
	
$path.userCache().file("lastExportArchive.xlog").setText(String($Obj_result_build.out))
	
ob_error_combine($out; $Obj_result_build)
	
Else 
	
// Failed to archive
$ui.alert("failedToArchive")
	
End if 
	
Else 
	
		$Obj_result_build:=Xcode(New object(\
				"action"; "build"; \
				"scheme"; $productName; \
				"destination"; $in.path; \
				"sdk"; $in.sdk; \
				"verbose"; $isDebug; \
				"test"; Bool($in.test); \
				"target"; Convert path system to POSIX($in.path+"build"+Folder separator)))
	
End if 
	
ob_error_combine($out; $Obj_result_build)
	
$cacheFolder.file("lastBuild.xlog").setText(String($Obj_result_build.out))
*/
	
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Installing the IPA on a connected device
Function install()
	
	// MARK:- private
	
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
	
	This:C1470.tags:=OB Copy:C1225(SHARED.tags)  // Common project tags
	
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
	
	
Function _generateTemplates()
	// ----------------------------------------------------
	// MARK: TEMPLATE
	// ----------------------------------------------------
/*$ui.step("workspaceCreation")
	
// I need a map, string -> format to be able to support folder name different from manifest name
$out.formatters:=formatters(New object("action"; "getByName")).formatters
$out.inputControls:=mobile_actions("getByName").inputControls
	
// Duplicate the template {
		$out.template:=cs.MainTemplate.new(New object(\
				"template"; $template; \
				"path"; $in.path; \
				"tags"; $tags; \
				"formatters"; $out.formatters; \
				"inputControls"; $out.inputControls; \
				"project"; $project)).run()
	
ob_error_combine($out; $out.template)
	
$out.projfile:=$out.template.projfile
ob_removeProperty($out.template; "projfile")  // redundant information
	
// Add some asset fix (could optimize by merging fix)
$fixes:=cs.Storyboards.new(Folder($in.path+"Sources"+Folder separator+"Forms"; fk platform path))
$out.colorAssetFix:=$fixes.colorAssetFix($out.template.theme)
ob_error_combine($out; $out.colorAssetFix)
	
$out.imageAssetFix:=$fixes.imageAssetFix()
ob_error_combine($out; $out.imageAssetFix)*/
	
	// Set writable target directory with all its subfolders and files
	//doc_UNLOCK_DIRECTORY(New object("path"; $in.path)) // ASK: move elsewhere
	
Function _manageDataSet
	// ----------------------------------------------------
	//  MARK: STRUCTURE & DATA
	// ----------------------------------------------------
	
	// Create catalog and data files {
/*If ($in.structureAdjustments=Null)
	
$in.structureAdjustments:=Bool($in.test)  // default value for test
	
End if 
	
If (Bool($in.structureAdjustments))
	
		$out.structureAdjustments:=_o_structure(New object(\
				"action"; "create"; \
				"tables"; dataModel(New object(\
				"action"; "tableNames"; \
				"dataModel"; $project.dataModel; \
				"relation"; True)).values))
	
End if 
	
		$out.dump:=dataSet(New object(\
				"action"; "check"; \
				"digest"; True; \
				"project"; $project))
ob_error_combine($out; $out.dump)
	
If (Bool($out.dump.exists))
	
If (Not($out.dump.valid) | Not(Bool($project.dataSource.doNotGenerateDataAtEachBuild)))
	
		$out.dump:=dataSet(New object(\
				"action"; "erase"; \
				"project"; $project))
	
End if 
End if 
	
		$out.dump:=dataSet(New object(\
				"action"; "check"; \
				"digest"; False; \
				"project"; $project))
	
If (Not(Bool($out.dump.exists)))
	
If (String($in.dataSource.source)="server")
	
// <NOTHING MORE TO DO>
	
Else 
	
$pathname:=$path.key().platformPath
	
If (Test path name($pathname)#Is a document)
	
		$out.keyPing:=Rest(New object(\
				"action"; "status"; \
				"handler"; "mobileapp"))
		$out.keyPing.file:=New object(\
				"path"; $pathname; \
				"exists"; (Test path name($pathname)=Is a document))
	
If (Not($out.keyPing.file.exists))
	
ob_error_add($out; "Local server key file do not exists and cannot be created")
	
End if 
End if 
End if 
	
		$out.dump:=dataSet(New object(\
				"action"; "create"; \
				"project"; $project; \
				"digest"; True; \
				"dataSet"; True; \
				"key"; $pathname; \
				"caller"; $in.caller; \
				"verbose"; $verbose; \
				"keepUI"; True))
	
ob_error_combine($out; $out.dump)
	
End if 
	
// Then copy
		$out.dumpCopy:=dataSet(New object(\
				"action"; "copy"; \
				"project"; $project; \
				"target"; $in.path))
ob_error_combine($out; $out.dumpCopy)
//}
	
If (FEATURE.with("xcDataModelClass"))
		$out.coreData:=cs.xcDataModel.new($project).run(\
				/*path*/$in.path+"Sources"+Folder separator+"Structures.xcdatamodeld"; \
				/*options*/New object("flat"; False; "relationship"; True))
Else 
		$out.coreData:=xcDataModel(New object(\
				"action"; "xcdatamodel"; \
				"dataModel"; $project.dataModel; \
				"actions"; $project.actions; \
				"flat"; False; \
				"relationship"; True; \
				"path"; $in.path+"Sources"+Folder separator+"Structures.xcdatamodeld"))
End if 
	
ob_error_combine($out; $out.coreData)
	
If (Not(Bool($project.dataSource.doNotGenerateDataAtEachBuild)))
	
$ui.step("dataSetGeneration")
	
End if 
	
If ($destinationFolder.folder("Resources/Assets.xcassets/Data").exists)  // If there JSON data (maybe use asset("action";"path"))
	
		$out.coreDataSet:=dataSet(New object(\
				"action"; "coreData"; \
				"removeAsset"; True; \
				"path"; $in.path))
	
ob_error_combine($out; $out.coreDataSet)
	
If (Bool($out.coreDataSet.success))
	
		dataSet(New object(\
				"action"; "coreDataAddToProject"; \
				"uuid"; $template.uuid; \
				"tags"; $tags; \
				"path"; $in.path))
	
End if 
	
Else 
	
		dataSet(New object(\
				"action"; "coreDataAddToProject"; \
				"uuid"; $template.uuid; \
				"tags"; $tags; \
				"path"; $in.path))
	
End if */
	
Function _generateCapabilities
/*
		$out.actionAssets:=mobile_actions("assets"; New object(\
				"project"; $project; \
				"inputControls"; $out.inputControls; \
				"target"; $in.path))
ob_error_combine($out; $out.actionAssets)
	
		$out.actionCapabilities:=mobile_actions("capabilities"; New object(\
				"project"; $project; \
				"inputControls"; $out.inputControls; \
				"target"; $in.path))
	
		$out.computedCapabilities:=New object(\
				"capabilities"; New object())
	
// #133381 : add always location & camera capabilities
// because Apple warn about it, because of code in SDK (QMobileUI mainly)
// (OR we need to split the SDK and have some injection if the feature is used, or inject code or not in final app)
$out.computedCapabilities.capabilities.location:=True
$out.computedCapabilities.capabilities.camera:=True
	
If (Bool($project.server.pushNotification))
	
$out.computedCapabilities.capabilities.pushNotification:=True
	
If (Length(String($project.server.pushCertificate))>0)
	
$certificateFile:=cs.doc.new($project.server.pushCertificate).target
	
If ($certificateFile.exists)
	
$certificateFile.copyTo($appFolder; fk overwrite)
	
Else 
	
ob_warning_add($out; "Certificate file "+String($project.server.pushCertificate)+" is missing")
	
End if 
End if 
End if 
	
If (Bool($project.deepLinking.enabled))
	
If (Length(String($project.deepLinking.urlScheme))>0)
	
$urlScheme:=String($project.deepLinking.urlScheme)
$urlScheme:=Replace string($urlScheme; "://"; "")
$out.computedCapabilities.capabilities.urlSchemes:=New collection($urlScheme)
	
End if 
	
If (Length(String($project.deepLinking.associatedDomain))>0)
	
$associatedDomain:=String($project.deepLinking.associatedDomain)
$associatedDomain:=Replace string($associatedDomain; "https://"; "")
$associatedDomain:=Replace string($associatedDomain; "http://"; "")
	
If (($associatedDomain[[Length($associatedDomain)]])="/")  // Strip last /
	
$associatedDomain:=Substring($associatedDomain; 1; Length($associatedDomain)-1)
	
End if 
	
$out.computedCapabilities.capabilities.associatedDomain:=$associatedDomain
	
End if 
End if 
	
$isSearchable:=ob findPropertyValues($project; "searchableWithBarcode")
	
If ($isSearchable.success)
	
If ($isSearchable.value.reduce("col_formula"; False; Formula($1.accumulator:=$1.accumulator | $1.value)))
	
// XXX could check that we have positive value? $isSearchable
$out.computedCapabilities.capabilities.camera:=True
	
End if 
End if 
	
// Manage app capabilities
		$out.capabilities:=capabilities(\
				New object("action"; "inject"; "target"; $in.path; "tags"; $tags; \
				"value"; New object(\
				"common"; SHARED; \
				"project"; $project; \
				"action"; $out.actionCapabilities; \
				"computed"; $out.computedCapabilities; \
				"templates"; $out.template)))
ob_error_combine($out; $out.capabilities)*/
	
Function _devFeatures
/*If (Bool(FEATURE._405))  // In feature until fix project launch with xcode
	
		Xcode(New object(\
				"action"; "workspace-addsources"; \
				"path"; $in.path))
	
End if 
//}
	
// Backup into git {
If (Bool(FEATURE._917))
	
		git(New object(\
				"action"; "config core.autocrlf"; \
				"path"; $in.path))
	
		$out.git:=git(New object(\
				"action"; "init"; \
				"path"; $in.path))
	
If ($out.git.success)
	
		$out.git:=git(New object(\
				"action"; "add -A"; \
				"path"; $in.path))
	
		$out.git:=git(New object(\
				"action"; "commit -m initial"; \
				"path"; $in.path))
	
End if 
End if 
//}
	
$out.tags:=$tags
	
$out.success:=Not(ob_error_has($out))  // XXX do it only at end (and remove this code, but must be tested)
	
If (Not($out.success))
	
$ui.alert(ob_error_string($out))
	
End if 
	
// End creation process
	
Else 
	
$out.success:=False
	
// Failed to unzip sdk
$ui.alert("failedDecompressTheSdk")
$log.error("Failed to unzip sdk")
	
End if 
	
DELAY PROCESS(Current process; 60*2)
	
End if */