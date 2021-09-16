//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : mobile_Project
// ID[11266537E65642B19D01235BDDCA03AB]
// Created 22-6-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Modified by Vincent de Lachaux (04/08/17)
// Make thread-safe
// ----------------------------------------------------
// Description:
// Manage creation, build and test run of a (iOS) project
// ----------------------------------------------------
// Declarations
#DECLARE($in : Object)->$out : Object

If (False:C215)
	C_OBJECT:C1216(mobile_Project_iOS; $0)
	C_OBJECT:C1216(mobile_Project_iOS; $1)
End if 

var $associatedDomain; $pathname; $productName; $t; $tt; $urlScheme : Text
var $isDebug; $success; $verbose : Boolean
var $start : Integer
var $appManifest; $Dir_template; $fixes; $isSearchable; $log; $Obj_result_build; $Obj_result_device; $project : Object
var $server; $tags; $template; $ui : Object
var $certificateFile : 4D:C1709.File
var $appFolder; $cacheFolder; $destinationFolder : 4D:C1709.Folder
var $debugLog : cs:C1710.debugLog
var $path : cs:C1710.path
var $simctl : cs:C1710.simctl

// NO PARAMETERS REQUIRED
$isDebug:=DATABASE.isInterpreted
$cacheFolder:=cs:C1710.path.new().userCache()

$out:=New object:C1471(\
"success"; True:C214)

// Optional parameters
If (Count parameters:C259>=1)
	
	// Cache the last build for debug purpose
	
	// Remove circular references
	var $o : Object
	$o:=OB Copy:C1225($in)
	If ($o.project.$project#Null:C1517)
		OB REMOVE:C1226($o.project.$project; "$dialog")
	End if 
	
	ob_writeToFile($o; $cacheFolder.file("lastBuild.ios.4dmobile"); True:C214)
	
Else 
	
	If ($isDebug)
		
		// IF no parameters, load from previous launched file
		If (SHARED=Null:C1517)
			
			RECORD.warning("SHARED=Null")
			RECORD.trace()
			COMPONENT_INIT
			
		End if 
		
		$in:=ob_parseFile($cacheFolder.file("lastBuild.ios.4dmobile")).value
		
	End if 
End if 

If (Asserted:C1132($in.project#Null:C1517))
	
	$project:=$in.project
	
	If ($project.$project.folder#Null:C1517)
		
		$productName:=$project.$project.folder.name
		
	Else 
		
		$productName:=$project.$project.product
		
	End if 
	
	// Cleanup
	
	For each ($t; $project)
		
		If ($t[[1]]="$")
			
			If ($t="$project")
				
				For each ($tt; $project[$t])
					
					If ($tt[[1]]="$")
						
						OB REMOVE:C1226($project[$t]; $tt)
						
					End if 
				End for each 
				
			Else 
				
				OB REMOVE:C1226($project; $t)
				
			End if 
		End if 
	End for each 
	
	PROJECT:=cs:C1710.project.new($project)
	
End if 

$verbose:=Bool:C1537($in.verbose) & Bool:C1537($in.caller)

$log:=New object:C1471(\
"information"; Choose:C955($verbose; Formula:C1597(CALL FORM:C1391($in.caller; "LOG_EVENT"; New object:C1471("message"; $1; "importance"; Information message:K38:1))); Formula:C1597(IDLE:C311)); \
"error"; Choose:C955($verbose; Formula:C1597(CALL FORM:C1391($in.caller; "LOG_EVENT"; New object:C1471("message"; $1; "importance"; Error message:K38:3))); Formula:C1597(IDLE:C311))\
)

$ui:=New object:C1471(\
"with"; ($in.caller#Null:C1517); \
"show"; Choose:C955($in.caller#Null:C1517; Formula:C1597(POST_MESSAGE(New object:C1471("target"; $in.caller; "action"; "show"; "type"; "progress"; "title"; $1))); Formula:C1597(IDLE:C311)); \
"close"; Choose:C955($in.caller#Null:C1517; Formula:C1597(POST_MESSAGE(New object:C1471("target"; $in.caller; "action"; "hide"))); Formula:C1597(IDLE:C311)); \
"step"; Choose:C955($in.caller#Null:C1517; Formula:C1597(POST_MESSAGE(New object:C1471("target"; $in.caller; "additional"; $1))); Formula:C1597(IDLE:C311)); \
"alert"; Choose:C955($in.caller#Null:C1517; Formula:C1597(POST_MESSAGE(New object:C1471("type"; "alert"; "target"; $in.caller; "additional"; $1))); Formula:C1597(IDLE:C311)))

$simctl:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget)

$path:=cs:C1710.path.new()

// ----------------------------------------------------
If ($in.create=Null:C1517)
	
	// Default create if not defined
	$in.create:=True:C214
	
End if 

$ui.show(Get localized string:C991("product")+" - "+PROJECT.product.name)

If ($in.create)
	
	$ui.step("waitingForXcode")
	
	// Must also close and delete folders if no change and want to recreate.
	Xcode(New object:C1471(\
		"action"; "safeDelete"; \
		"path"; $in.path))
	
	$log.information("Create project")
	
	// We need to reload data after login?
	If ($project.server.authentication=Null:C1517)
		
		$project.server.authentication:=New object:C1471
		
	End if 
	
	$project.server.authentication.reloadData:=False:C215
	
	// If there is filter with parameters reload data after auth
	For each ($t; $project.dataModel)
		
		If (Value type:C1509($project.dataModel[$t][""].filter)=Is object:K8:27)
			
			If (Bool:C1537($project.dataModel[$t][""].filter.parameters))
				
				$project.server.authentication.reloadData:=True:C214
				
			End if 
		End if 
	End for each 
	
	// Other criteria like there is no embedded for one table ?
	If (Not:C34($project.server.authentication.reloadData))
		
		For each ($t; $project.dataModel)
			
			If (Not:C34(Bool:C1537($project.dataModel[$t][""].embedded)))
				
				$project.server.authentication.reloadData:=True:C214
				
			End if 
		End for each 
	End if 
	
	//===============================================================
	// Create tags object for template {
	$tags:=SHARED.tags
	
	$tags.product:=$productName
	$tags.packageName:=$tags.product
	
	// Project file tags
	$tags.bundleIdentifier:=$project.product.bundleIdentifier
	$tags.company:=$project.organization.name
	
	If (Length:C16($project.organization.teamId)>0)
		
		$tags.teamId:=$project.organization.teamId
		
	End if 
	
	// Info plist tags
	$tags.displayName:=$project.product.name
	$tags.version:=$project.product.version
	$tags.build:=str_fullVersion($tags.version)
	
	$tags.prodUrl:=$project.server.urls.production
	
	If (Length:C16($tags.prodUrl)>0)
		
		$tags.prodUrl:=Replace string:C233($tags.prodUrl; "localhost"; "127.0.0.1")
		
		If (Not:C34(Match regex:C1019("(?i-ms)http[s]?://"; $tags.prodUrl; 1)))
			
			// Default to http
			$tags.prodUrl:="http://"+$tags.prodUrl
			
		End if 
	End if 
	
	$server:=WEB Get server info:C1531
	$tags.serverHTTPSPort:=String:C10($server.options.webHTTPSPortID)
	$tags.serverPort:=String:C10($server.options.webPortID)
	
	Case of 
			
			//________________________________________
		: (Bool:C1537($server.security.HTTPEnabled))  // priority for http
			
			$tags.serverScheme:="http"
			
			//________________________________________
		: (Bool:C1537($server.security.HTTPSEnabled))  // only https, use it
			
			$tags.serverScheme:="https"
			
			//________________________________________
		Else 
			
			$tags.serverScheme:=""  // default: let mobile app defined default?
			
			//________________________________________
	End case 
	
	$tags.serverUrls:=$server.options.webIPAddressToListen.join(","; ck ignore null or empty:K85:5)
	
	$tags.serverAuthenticationEmail:=Choose:C955(Bool:C1537($project.server.authentication.email); "true"; "false")  // plist bool format
	$tags.serverAuthenticationReloadData:=Choose:C955(Bool:C1537($project.server.authentication.reloadData); "true"; "false")  // plist bool format
	
	// Source files tags
	$tags.copyright:=$project.product.copyright
	$tags.fullname:=$project.developer.name
	$tags.date:=String:C10(Current date:C33; Date RFC 1123:K1:11; Current time:C178); 
	
	// Scripts
	$tags.xCodeVersion:=$project.$project.xCode.version
	
	// Navigation tags
	$tags.navigationTitle:=$project.main.navigationTitle
	$tags.navigationType:=$project.main.navigationType
	$tags.navigationTransition:=$project.ui.navigationTransition
	//}
	
	// Launchscreen
	$tags.launchScreenBackgroundColor:=SHARED.infoPlist.storyboard.backgroundColor  // FR #93800: take from project configuration
	
	// setting
	$tags.hasAction:=Choose:C955(Bool:C1537(mobile_actions("hasAction"; $in).value); "true"; "false")  // plist bool format
	
	// App manifest =================================================
	$appManifest:=New object:C1471(\
		"application"; New object:C1471("id"; $project.product.bundleIdentifier; "name"; $project.product.name); \
		"team"; New object:C1471("id"; $project.organization.teamId); \
		"info"; $project.info)
	$appManifest.id:=String:C10($appManifest.team.id)+"."+$appManifest.application.id
	
	// Deep linking
	If (Bool:C1537($project.deepLinking.enabled))
		
		If (Length:C16(String:C10($project.deepLinking.urlScheme))>0)
			
			$appManifest.urlScheme:=String:C10($project.deepLinking.urlScheme)
			$appManifest.urlScheme:=Replace string:C233($appManifest.urlScheme; "://"; "")
			
		End if 
		
		If (Length:C16(String:C10($project.deepLinking.associatedDomain))>0)
			
			$appManifest.associatedDomain:=String:C10($project.deepLinking.associatedDomain)
			
		End if 
	End if 
	
	//#ACI0100704
	$appFolder:=Folder:C1567(fk mobileApps folder:K87:18; *).folder($appManifest.id)
	
	If (Not:C34($appFolder.exists))
		
		$appFolder.create()
		
	End if 
	
	$appFolder.file("manifest.json").setText(JSON Stringify:C1217($appManifest; *))
	
	//===============================================================
	$ui.step("decompressionOfTheSdk")
	
	// Target folder
	$out.path:=$in.path
	$destinationFolder:=Folder:C1567($in.path; fk platform path:K87:2)
	$destinationFolder.create()
	
	// Cache the last build for debug purpose
	ob_writeToFile($in; $destinationFolder.file("project.4dmobile"); True:C214)
	
	$Dir_template:=$path.templates().folder($in.template)
	
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
	If ($project._folder=Null:C1517)
		$template.assets.source:=$path.projects().platformPath+$productName+Folder separator:K24:12+$template.assets.name+Folder separator:K24:12
	Else 
		$template.assets.source:=$project._folder.platformPath+Folder separator:K24:12+$template.assets.name+Folder separator:K24:12
		If (Not:C34(Test path name:C476($template.assets.source)=Is a folder:K24:2))
			$template.assets.source:=$path.projects().platformPath+$productName+Folder separator:K24:12+$template.assets.name+Folder separator:K24:12
		End if 
	End if 
	
	$out.sdk:=sdk(New object:C1471(\
		"action"; "install"; \
		"file"; $path.sdk().platformPath+"ios.zip"; \
		"target"; $in.path))
	
	$tags.sdkVersion:=String:C10($out.sdk.version)
	
	If ($out.sdk.success)
		
		// ----------------------------------------------------
		// TEMPLATE
		// ----------------------------------------------------
		$ui.step("workspaceCreation")
		
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
			"project"; $project)).run()
		
		ob_error_combine($out; $out.template)
		
		$out.projfile:=$out.template.projfile
		ob_removeProperty($out.template; "projfile")  // redundant information
		
		// Add some asset fix (could optimize by merging fix)
		$fixes:=cs:C1710.Storyboards.new(Folder:C1567($in.path+"Sources"+Folder separator:K24:12+"Forms"; fk platform path:K87:2))
		$out.colorAssetFix:=$fixes.colorAssetFix($out.template.theme)
		ob_error_combine($out; $out.colorAssetFix)
		
		$out.imageAssetFix:=$fixes.imageAssetFix()
		ob_error_combine($out; $out.imageAssetFix)
		
		// Set writable target directory with all its subfolders and files
		doc_UNLOCK_DIRECTORY(New object:C1471("path"; $in.path))
		
		// ----------------------------------------------------
		// STRUCTURE & DATA
		// ----------------------------------------------------
		
		// Create catalog and data files {
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
		
		$out.dump:=dataSet(New object:C1471(\
			"action"; "check"; \
			"digest"; True:C214; \
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
				
				$pathname:=$path.key().platformPath
				
				If (Test path name:C476($pathname)#Is a document:K24:1)
					
					$out.keyPing:=Rest(New object:C1471(\
						"action"; "status"; \
						"handler"; "mobileapp"))
					$out.keyPing.file:=New object:C1471(\
						"path"; $pathname; \
						"exists"; (Test path name:C476($pathname)=Is a document:K24:1))
					
					If (Not:C34($out.keyPing.file.exists))
						
						ob_error_add($out; "Local server key file do not exists and cannot be created")
						
					End if 
				End if 
			End if 
			
			$out.dump:=dataSet(New object:C1471(\
				"action"; "create"; \
				"project"; $project; \
				"digest"; True:C214; \
				"dataSet"; True:C214; \
				"key"; $pathname; \
				"caller"; $in.caller; \
				"verbose"; $verbose))
			
			ob_error_combine($out; $out.dump)
			
		End if 
		
		// Then copy
		$out.dumpCopy:=dataSet(New object:C1471(\
			"action"; "copy"; \
			"project"; $project; \
			"target"; $in.path))
		ob_error_combine($out; $out.dumpCopy)
		//}
		
		$out.coreData:=dataModel(New object:C1471(\
			"action"; "xcdatamodel"; \
			"dataModel"; $project.dataModel; \
			"actions"; $project.actions; \
			"flat"; False:C215; \
			"relationship"; True:C214; \
			"path"; $in.path+"Sources"+Folder separator:K24:12+"Structures.xcdatamodeld"))
		
		ob_error_combine($out; $out.coreData)
		
		If (Not:C34(Bool:C1537($project.dataSource.doNotGenerateDataAtEachBuild)))
			
			$ui.step("dataSetGeneration")
			
		End if 
		
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
		
		// ----------------------------------------------------
		// Others (maybe move to templates, main management
		// ----------------------------------------------------
		var $isdebug : Boolean
		$isdebug:=Not:C34(Is compiled mode:C492)
		
		If ($isdebug)
			
			$debugLog:=cs:C1710.debugLog.new(SHARED.debugLog)
			$debugLog.start()
			
		End if 
		
		// Generate action asset
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
		
		If (Bool:C1537($project.server.pushNotification))
			
			$out.computedCapabilities.capabilities.pushNotification:=True:C214
			
			If (Length:C16(String:C10($project.server.pushCertificate))>0)
				
				$certificateFile:=cs:C1710.doc.new($project.server.pushCertificate).target
				
				If ($certificateFile.exists)
					
					$certificateFile.copyTo($appFolder; fk overwrite:K87:5)
					
				Else 
					
					ob_warning_add($out; "Certificate file "+String:C10($project.server.pushCertificate)+" is missing")
					
				End if 
			End if 
		End if 
		
		If (Bool:C1537($project.deepLinking.enabled))
			
			If (Length:C16(String:C10($project.deepLinking.urlScheme))>0)
				
				$urlScheme:=String:C10($project.deepLinking.urlScheme)
				$urlScheme:=Replace string:C233($urlScheme; "://"; "")
				$out.computedCapabilities.capabilities.urlSchemes:=New collection:C1472($urlScheme)
				
			End if 
			
			If (Length:C16(String:C10($project.deepLinking.associatedDomain))>0)
				
				$associatedDomain:=String:C10($project.deepLinking.associatedDomain)
				$associatedDomain:=Replace string:C233($associatedDomain; "https://"; "")
				$associatedDomain:=Replace string:C233($associatedDomain; "http://"; "")
				
				If (($associatedDomain[[Length:C16($associatedDomain)]])="/")  // Strip last /
					
					$associatedDomain:=Substring:C12($associatedDomain; 1; Length:C16($associatedDomain)-1)
					
				End if 
				
				$out.computedCapabilities.capabilities.associatedDomain:=$associatedDomain
				
			End if 
		End if 
		
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
		
		If ($isdebug)
			
			$debugLog.stop()
			
		End if 
		
		// ----------------------------------------------------
		// DEV FEATURES
		// ----------------------------------------------------
		
		// Add sources if any to workspace {
		If (Bool:C1537(FEATURE._405))  // In feature until fix project launch with xcode
			
			Xcode(New object:C1471(\
				"action"; "workspace-addsources"; \
				"path"; $in.path))
			
		End if 
		//}
		
		// Backup into git {
		If (Bool:C1537(FEATURE._917))
			
			git(New object:C1471(\
				"action"; "config core.autocrlf"; \
				"path"; $in.path))
			
			$out.git:=git(New object:C1471(\
				"action"; "init"; \
				"path"; $in.path))
			
			If ($out.git.success)
				
				$out.git:=git(New object:C1471(\
					"action"; "add -A"; \
					"path"; $in.path))
				
				$out.git:=git(New object:C1471(\
					"action"; "commit -m initial"; \
					"path"; $in.path))
				
			End if 
		End if 
		//}
		
		$out.tags:=$tags
		
		$out.success:=Not:C34(ob_error_has($out))  // XXX do it only at end (and remove this code, but must be tested)
		
		If (Not:C34($out.success))
			
			$ui.alert(ob_error_string($out))
			
		End if 
		
		// End creation process
		
	Else 
		
		$out.success:=False:C215
		
		// Failed to unzip sdk
		$ui.alert("failedDecompressTheSdk")
		$log.error("Failed to unzip sdk")
		
	End if 
	
	DELAY PROCESS:C323(Current process:C322; 60*2)
	
End if 

// ----------------------------------------------------
// BUILD OR ARCHIVE & LAUNCH
// ----------------------------------------------------

If ($out.success)
	
	If (Bool:C1537($in.build))
		
		If (Bool:C1537($in.archive))
			
			// Archive
			$ui.step("projectArchive")
			$log.information("Archiving project")
			
			$Obj_result_build:=Xcode(New object:C1471(\
				"action"; "build"; \
				"scheme"; $productName; \
				"destination"; $in.path; \
				"sdk"; "iphoneos"; \
				"verbose"; $isDebug; \
				"configuration"; "Release"; \
				"archive"; True:C214; \
				"allowProvisioningUpdates"; True:C214; \
				"allowProvisioningDeviceRegistration"; True:C214; \
				"archivePath"; Convert path system to POSIX:C1106($in.path+"archive"+Folder separator:K24:12+$productName+".xcarchive")))
			
			$cacheFolder.file("lastArchive.xlog").setText(String:C10($Obj_result_build.out))
			
			ob_error_combine($out; $Obj_result_build)
			
			If ($Obj_result_build.success)
				
				// And export
				$ui.step("projectArchiveExport")
				$log.information("Exporting project archive")
				
				$Obj_result_build:=Xcode(New object:C1471(\
					"action"; "build"; \
					"verbose"; $isDebug; \
					"exportArchive"; True:C214; \
					"teamID"; String:C10($in.project.organization.teamId); \
					"stripSwiftSymbols"; Bool:C1537(SHARED.swift.Export.stripSwiftSymbols); \
					"exportMethod"; String:C10(SHARED.swift.Export.method); \
					"exportPath"; Convert path system to POSIX:C1106($in.path+"archive"+Folder separator:K24:12); \
					"archivePath"; Convert path system to POSIX:C1106($in.path+"archive"+Folder separator:K24:12+$productName+".xcarchive")))
				
				$path.userCache().file("lastExportArchive.xlog").setText(String:C10($Obj_result_build.out))
				
				ob_error_combine($out; $Obj_result_build)
				
			Else 
				
				// Failed to archive
				$ui.alert("failedToArchive")
				
			End if 
			
		Else 
			
			// Build application
			$ui.step("projectBuild")
			$log.information("Building project")
			
			$Obj_result_build:=Xcode(New object:C1471(\
				"action"; "build"; \
				"scheme"; $productName; \
				"destination"; $in.path; \
				"sdk"; $in.sdk; \
				"verbose"; $isDebug; \
				"test"; Bool:C1537($in.test); \
				"target"; Convert path system to POSIX:C1106($in.path+"build"+Folder separator:K24:12)))
			
			ob_error_combine($out; $Obj_result_build)
			
			$cacheFolder.file("lastBuild.xlog").setText(String:C10($Obj_result_build.out))
			
			// Some times Xcode method failed to get app path, maybe if already builded and nothing to do???
			If ($Obj_result_build.app=Null:C1517)
				
				$pathname:=$in.path+Convert path POSIX to system:C1107("build/Build/Products/Debug-iphonesimulator/")+$productName+".app"
				
				If (Test path name:C476($pathname)=Is a folder:K24:2)
					
					$Obj_result_build.app:=Convert path system to POSIX:C1106($pathname)
					
				End if 
			End if 
		End if 
		
		If (Not:C34($Obj_result_build.success))
			
			$ui.alert(String:C10($Obj_result_build.error))
			$log.error("Build Failed")
			
		End if 
		
	Else 
		
		$log.information("Compute data without building")
		
		// Compute data without building
		$Obj_result_build:=New object:C1471
		
		$pathname:=$in.path+Convert path POSIX to system:C1107("build/Build/Products/Debug-iphonesimulator/")+$productName+".app"
		
		If (Test path name:C476($pathname)=Is a folder:K24:2)
			
			$Obj_result_build.app:=Convert path system to POSIX:C1106($pathname)
			$Obj_result_build.success:=True:C214
			
		Else 
			
			$Obj_result_build.success:=False:C215  // No build
			
		End if 
	End if 
	
	$out.build:=$Obj_result_build
	$out.success:=$Obj_result_build.success | Not:C34(Bool:C1537($in.build))
	
	// Else
	// we failed to create project
	
End if 

If ($out.success)
	
	// Save the signature of the sources folder
	
	Case of 
			
			//______________________________________________________
		: (Bool:C1537($in.run))
			
			$in.product:=$out.build.app
			
			$ui.step("launchingTheSimulator")
			$log.information("Launching the Simulator")
			
			$out.device:=$simctl.device($in.project._simulator)
			
			If ($out.device#Null:C1517)
				
				If (Not:C34($simctl.isDeviceBooted($out.device.udid)))
					
					$simctl.bootDevice($out.device.udid; True:C214)
					$simctl.bringSimulatorAppToFront()
					
					DELAY PROCESS:C323(Current process:C322; 60*5)
					LAUNCH EXTERNAL PROCESS:C811("osascript -e 'tell app \"4D\" to activate'")
					
				End if 
				
				$simctl.bringSimulatorAppToFront()
				
				If ($simctl.isDeviceBooted($out.device.udid))
					
					$ui.step("installingTheApplication")
					
					If ($simctl.isAppInstalled($project.product.bundleIdentifier; $out.device.udid))
						
						$log.information("Uninstall the App")
						
						// Quit App
						$simctl.terminateApp($project.product.bundleIdentifier; $out.device.udid)
						
						// Better user impression because the simulator display the installation
						DELAY PROCESS:C323(Current process:C322; 10)
						
						// Uninstall App
						$simctl.uninstallApp($project.product.bundleIdentifier; $out.device.udid)
						
					End if 
					
					$log.information("Install the App")
					
					// Install App
					$simctl.installApp($in.product; $out.device.udid)
					
					If (Not:C34($simctl.success))
						
						// Redmine #102346: RETRY, if any
						If (Position:C15("MIInstallerErrorDomain, code=35"; $simctl.lastError)>0)
							
							$simctl.installApp($in.product; $out.device.udid)
							
						End if 
					End if 
					
					If ($simctl.success)
						
						// Launch App
						$ui.step("launchingTheApplication")
						$log.information("Launching the App")
						
						$simctl.launchApp($project.product.bundleIdentifier; $out.device.udid)
						
						If ($simctl.success)
							
							$simctl.bringSimulatorAppToFront()
							
						Else 
							
							$ui.alert($simctl.lastError)
							$log.information("Failed to launch the App ("+$simctl.lastError+")")
							
						End if 
						
					Else 
						
						$ui.alert($simctl.lastError)
						$log.error("Failed to install the App ("+$simctl.lastError+")")
						
					End if 
					
				Else 
					
					$ui.alert("failedToOpenSimulator")
					$log.error("device not booted")
					
				End if 
				
			Else 
				
				$ui.alert("failedToOpenSimulator")
				$log.error("device not found")
				
			End if 
			
			//______________________________________________________
		: (Bool:C1537($in.archive))
			
			// Calculate the ipa file pathname
			$pathname:=Convert path POSIX to system:C1107($Obj_result_build.archivePath)
			$pathname:=Object to path:C1548(New object:C1471(\
				"parentFolder"; Path to object:C1547($pathname).parentFolder; \
				"name"; Path to object:C1547($pathname).name; \
				"extension"; ".ipa"))
			
			If ($in.manualInstallation)
				
				// Open xCode devices window
				cs:C1710.Xcode.new().showDevicesWindow()
				
				// Show archive on disk ?
				POST_MESSAGE(New object:C1471(\
					"target"; $in.caller; \
					"type"; "confirm"; \
					"title"; "archiveCreationSuccessful"; \
					"additional"; "wouldYouLikeToRevealInFinder"; \
					"okFormula"; Formula:C1597(SHOW ON DISK:C922(String:C10($pathname)))))
				
			Else 
				
				// Install the archive on the device
				$ui.step("installingTheApplication")
				
				$out.device:=device(New object:C1471(\
					"action"; "installApp"; \
					"path"; $pathname))
				
				ob_error_combine($out; $out.device)
				
				If (Not:C34($out.device.success))
					
					$ui.alert($out.device.errors.join("\r"))
					
				End if 
			End if 
			
			//______________________________________________________
	End case 
End if 

$ui.close()

ob_writeToDocument($out; $cacheFolder.file("lastBuild.ios.json").platformPath; True:C214)

$out.param:=$in

// ----------------------------------------------------
If ($ui.with)
	
	// Send result
	CALL FORM:C1391($in.caller; "EDITOR_CALLBACK"; "build"; $out)
	
End if 