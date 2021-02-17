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
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($isDebug; $Boo_OK; $verbose)
C_LONGINT:C283($Lon_parameters; $Lon_start)
C_TEXT:C284($pathname; $t; $Txt_buffer)
C_OBJECT:C1216($Obj_action; $Dir_template; $cacheFolder; $Obj_dataModel; $in; $Obj_manifest; $out)
C_OBJECT:C1216($project; $Obj_result_build; $Obj_result_device; $server; $tags; $template)
C_OBJECT:C1216($Obj_parameters; $Path_manifest; $Folder_destination)

If (False:C215)
	C_OBJECT:C1216(mobile_Project_iOS; $1)
	C_OBJECT:C1216(mobile_Project_iOS; $0)
End if 
// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED
$isDebug:=DATABASE.isInterpreted
$cacheFolder:=ENV.caches("com.4d.mobile/"; True:C214)

// Optional parameters
If (Count parameters:C259>=1)
	
	$in:=$1
	
	// Add choice lists if any to action parameters
	actions("addChoiceList"; $in)
	
	// Cache the last build for debug purpose
	ob_writeToFile($in; $cacheFolder.file("lastBuild.4dmobile"); True:C214)
	
Else 
	
	If ($isDebug)
		
		// IF no parameters, load from previous launched file
		If (SHARED=Null:C1517)
			
			RECORD.warning("SHARED=Null")
			RECORD.trace()
			COMPONENT_INIT
			
		End if 
		
		$in:=ob_parseFile($cacheFolder.file("lastBuild.4dmobile")).value
		
	End if 
End if 

$out:=New object:C1471(\
"success"; True:C214)

If (Asserted:C1132($in.project#Null:C1517))
	
	$project:=$in.project
	
	If ($project.$project.folder#Null:C1517)
		
		var $productName : Text
		$productName:=$project.$project.folder.name
		
	Else 
		
		$productName:=$project.$project.product
		
	End if 
	
	// Cleanup
	var $t; $tt : Text
	
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

var $log : Object
$log:=Choose:C955($verbose; Formula:C1597(CALL FORM:C1391($in.caller; "LOG_EVENT"; New object:C1471("message"; $1; "importance"; $2))); Formula:C1597(IDLE:C311))

var $ui : Object
$ui:=New object:C1471(\
"withUI"; ($in.caller#Null:C1517); \
"show"; Choose:C955($in.caller#Null:C1517; Formula:C1597(POST_MESSAGE(New object:C1471("target"; $in.caller; "action"; "show"; "type"; "progress"; "title"; $1))); Formula:C1597(IDLE:C311)); \
"close"; Choose:C955($in.caller#Null:C1517; Formula:C1597(POST_MESSAGE(New object:C1471("target"; $in.caller; "action"; "hide"))); Formula:C1597(IDLE:C311)); \
"step"; Choose:C955($in.caller#Null:C1517; Formula:C1597(POST_MESSAGE(New object:C1471("target"; $in.caller; "additional"; $1))); Formula:C1597(IDLE:C311)); \
"alert"; Choose:C955($in.caller#Null:C1517; Formula:C1597(POST_MESSAGE(New object:C1471("type"; "alert"; "target"; $in.caller; "additional"; $1))); Formula:C1597(IDLE:C311)))

var $simctl : cs:C1710.simctl
$simctl:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget)

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
	
	$log.call(Null:C1517; "Create project"; Information message:K38:1)
	
	// We need to reload data after login?
	If ($project.server.authentication=Null:C1517)
		
		$project.server.authentication:=New object:C1471
		
	End if 
	
	$project.server.authentication.reloadData:=False:C215
	
	// If there is filter with parameters reload data after auth
	For each ($Txt_buffer; $project.dataModel)
		
		If (Value type:C1509($project.dataModel[$Txt_buffer][""].filter)=Is object:K8:27)
			
			If (Bool:C1537($project.dataModel[$Txt_buffer][""].filter.parameters))
				
				$project.server.authentication.reloadData:=True:C214
				
			End if 
		End if 
	End for each 
	
	// Other criteria like there is no embedded for one table ?
	If (Not:C34($project.server.authentication.reloadData))
		
		For each ($Txt_buffer; $project.dataModel)
			
			If (Not:C34(Bool:C1537($project.dataModel[$Txt_buffer][""].embedded)))
				
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
	$tags.hasAction:=Choose:C955(Bool:C1537(actions("hasAction"; $in).value); "true"; "false")  // plist bool format
	
	// App manifest =================================================
	C_OBJECT:C1216($appManifest)
	$appManifest:=New object:C1471(\
		"application"; New object:C1471("id"; $project.product.bundleIdentifier; "name"; $project.product.name); \
		"team"; New object:C1471("id"; $project.organization.teamId); \
		"info"; $project.info)
	$appManifest.id:=String:C10($appManifest.team.id)+"."+$appManifest.application.id
	
	If (FEATURE.with(117618))
		
		If (Bool:C1537($project.deepLinking.enabled))
			
			If (Length:C16(String:C10($project.deepLinking.urlScheme))>0)
				
				$appManifest.urlScheme:=String:C10($project.deepLinking.urlScheme)
				$appManifest.urlScheme:=Replace string:C233($appManifest.urlScheme; "://"; "")
				
			End if 
			
			If (Length:C16(String:C10($project.deepLinking.associatedDomain))>0)
				
				$appManifest.associatedDomain:=String:C10($project.deepLinking.associatedDomain)
				
			End if 
		End if 
	End if 
	
	//#ACI0100704
	var $appFolder : 4D:C1709.Folder
	$appFolder:=Folder:C1567(fk mobileApps folder:K87:18; *).folder($appManifest.id)
	
	If (Not:C34($appFolder.exists))
		
		$appFolder.create()
		
	End if 
	
	$appFolder.file("manifest.json").setText(JSON Stringify:C1217($appManifest; *))
	
	//===============================================================
	$ui.step("decompressionOfTheSdk")
	
	// Target folder
	$out.path:=$in.path
	$Folder_destination:=Folder:C1567($in.path; fk platform path:K87:2)
	$Folder_destination.create()
	
	ob_writeToFile($in; $Folder_destination.file("project.4dmobile"); True:C214)
	
	$Dir_template:=COMPONENT_Pathname("templates").folder($in.template)
	
	If (Asserted:C1132($Dir_template.file("manifest.json").exists))
		
		$template:=ob_parseFile($Dir_template.file("manifest.json")).value
		
	End if 
	
	ASSERT:C1129($template.assets.path#Null:C1517)
	ASSERT:C1129($template.sdk.version#Null:C1517)
	
	$template.source:=$Dir_template.platformPath
	$template.assets.target:=$in.path+Convert path POSIX to system:C1107($template.assets.path)+Folder separator:K24:12+$template.assets.name+Folder separator:K24:12
	$template.assets.source:=COMPONENT_Pathname("projects").platformPath+$productName+Folder separator:K24:12+$template.assets.name+Folder separator:K24:12
	
	$out.sdk:=sdk(New object:C1471(\
		"action"; "install"; \
		"file"; COMPONENT_Pathname("sdk").platformPath+$template.sdk.version+".zip"; \
		"target"; $in.path; \
		"cache"; sdk(New object:C1471("action"; "cacheFolder")).platformPath))
	
	$tags.sdkVersion:=String:C10($out.sdk.version)
	
	If ($out.sdk.success)
		
		// ----------------------------------------------------
		// TEMPLATE
		// ----------------------------------------------------
		$ui.step("workspaceCreation")
		
		// I need a map, string -> format
		$out.formatters:=formatters(New object:C1471("action"; "getByName")).formatters
		
		// Duplicate the template {
		If (FEATURE.with("templateClass"))  // Add feature flag if test not possible with new code
			
			$out.template:=cs:C1710.MainTemplate.new(New object:C1471(\
				"template"; $template; \
				"path"; $in.path; \
				"tags"; $tags; \
				"formatters"; $out.formatters; \
				"project"; $project)).run()
			
		Else 
			
			$out.template:=_o_templates(New object:C1471(\
				"template"; $template; \
				"path"; $in.path; \
				"tags"; $tags; \
				"formatters"; $out.formatters; \
				"project"; $project))
			
		End if 
		
		ob_error_combine($out; $out.template)
		
		$out.projfile:=$out.template.projfile
		ob_removeProperty($out.template; "projfile")  // redundant information
		
		// Add some asset fix (could optimize by merging fix)
		C_OBJECT:C1216($fixes)
		$fixes:=cs:C1710.Storyboards.new(Folder:C1567($in.path+"Sources"+Folder separator:K24:12+"Forms"; fk platform path:K87:2))
		$out.colorAssetFix:=$fixes.colorAssetFix($out.template.theme)
		ob_error_combine($out; $out.colorAssetFix)
		
		$out.imageAssetFix:=$fixes.imageAssetFix()
		ob_error_combine($out; $out.imageAssetFix)
		
		//}
		
		// Set writable target directory with all its subfolders and files
		doc_UNLOCK_DIRECTORY(New object:C1471(\
			"path"; $in.path))
		
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
				
				//ACI0100868
				//$File_:=Choose(Length(String($Obj_in.dataSource.keyPath))>0;doc_Absolute_path ($Obj_in.dataSource.keyPath;Get 4D folder(MobileApps folder;*));Null)
				$pathname:=Choose:C955(Length:C16(String:C10($in.dataSource.keyPath))>0; doc_Absolute_path($in.dataSource.keyPath); Null:C1517)
				
			Else 
				
				$pathname:=COMPONENT_Pathname("key").platformPath
				
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
			"flat"; False:C215; \
			"relationship"; True:C214; \
			"path"; $in.path+"Sources"+Folder separator:K24:12+"Structures.xcdatamodeld"))
		
		ob_error_combine($out; $out.coreData)
		
		If (Not:C34(Bool:C1537($project.dataSource.doNotGenerateDataAtEachBuild)))
			
			$ui.step("dataSetGeneration")
			
		End if 
		
		If ($Folder_destination.folder("Resources/Assets.xcassets/Data").exists)  // If there JSON data (maybe use asset("action";"path"))
			
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
		
		var $debugLog : cs:C1710.debugLog
		$debugLog:=cs:C1710.debugLog.new(SHARED.debugLog)
		
		$debugLog.start()
		
		// Generate action asset
		$out.actionAssets:=actions("assets"; New object:C1471(\
			"project"; $project; \
			"target"; $in.path))
		ob_error_combine($out; $out.actionAssets)
		
		$out.actionCapabilities:=actions("capabilities"; New object:C1471(\
			"project"; $project; \
			"target"; $in.path))
		
		$out.computedCapabilities:=New object:C1471(\
			"capabilities"; New object:C1471())
		
		If (Bool:C1537($project.server.pushNotification))
			
			$out.computedCapabilities.capabilities.pushNotification:=True:C214
			
			If (Length:C16(String:C10($project.server.pushCertificate))>0)
				
				var $certificateFile : cs:C1710.doc
				$certificateFile:=cs:C1710.doc.new($project.server.pushCertificate).target
				
				If ($certificateFile.exists)
					
					$certificateFile.copyTo($appFolder; fk overwrite:K87:5)
					
				Else 
					
					ob_warning_add($out; "Certificate file "+String:C10($project.server.pushCertificate)+" is missing")
					
				End if 
			End if 
		End if 
		
		If (FEATURE.with(117618))
			
			If (Bool:C1537($project.deepLinking.enabled))
				
				If (Length:C16(String:C10($project.deepLinking.urlScheme))>0)
					
					C_TEXT:C284($urlScheme)
					$urlScheme:=String:C10($project.deepLinking.urlScheme)
					$urlScheme:=Replace string:C233($urlScheme; "://"; "")
					$out.computedCapabilities.capabilities.urlSchemes:=New collection:C1472($urlScheme)
					
				End if 
				
				If (Length:C16(String:C10($project.deepLinking.associatedDomain))>0)
					
					C_TEXT:C284($associatedDomain)
					$associatedDomain:=String:C10($project.deepLinking.associatedDomain)
					$associatedDomain:=Replace string:C233($associatedDomain; "https://"; "")
					$associatedDomain:=Replace string:C233($associatedDomain; "http://"; "")
					
					If (($associatedDomain[[Length:C16($associatedDomain)]])="/")  // Strip last /
						
						$associatedDomain:=Substring:C12($associatedDomain; 1; Length:C16($associatedDomain)-1)
						
					End if 
					
					$out.computedCapabilities.capabilities.associatedDomain:=$associatedDomain
					
				End if 
			End if 
			
		End if 
		
		C_OBJECT:C1216($isSearchable)
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
		
		$debugLog.stop()
		
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
			
			//ob_error_combine ($Obj_out;$Obj_out.git) //  XXX cannot combine until there is warning not in errors
			
			If ($out.git.success)
				
				$out.git:=git(New object:C1471(\
					"action"; "add -A"; \
					"path"; $in.path))
				
				//ob_error_combine ($Obj_out;$Obj_out.git) //  XXX cannot combine until there is warning not in errors
				
				$out.git:=git(New object:C1471(\
					"action"; "commit -m initial"; \
					"path"; $in.path))
				
				//ob_error_combine ($Obj_out;$Obj_out.git) //  XXX cannot combine until there is warning not in errors
				
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
		$log.call(Null:C1517; "Failed to unzip sdk"; Error message:K38:3)
		
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
			$log.call(Null:C1517; "Archiving project"; Information message:K38:1)
			
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
			
			$cacheFolder.file("lastArchive.xlog").setText(String:C10($Obj_result_build.out); "UTF-8"; Document with LF:K24:22)
			
			ob_error_combine($out; $Obj_result_build)
			
			If ($Obj_result_build.success)
				
				// And export
				$ui.step("projectArchiveExport")
				$log.call(Null:C1517; "Exporting project archive"; Information message:K38:1)
				
				$Obj_result_build:=Xcode(New object:C1471(\
					"action"; "build"; \
					"verbose"; $isDebug; \
					"exportArchive"; True:C214; \
					"teamID"; String:C10($in.project.organization.teamId); \
					"exportPath"; Convert path system to POSIX:C1106($in.path+"archive"+Folder separator:K24:12); \
					"archivePath"; Convert path system to POSIX:C1106($in.path+"archive"+Folder separator:K24:12+$productName+".xcarchive")))
				
				ENV.caches("lastExportArchive.xlog").setText(String:C10($Obj_result_build.out); "UTF-8"; Document with LF:K24:22)
				
				ob_error_combine($out; $Obj_result_build)
				
			Else 
				
				// Failed to archive
				$ui.alert("failedToArchive")
				
			End if 
			
		Else 
			
			// Build application
			$ui.step("projectBuild")
			$log.call(Null:C1517; "Building project"; Information message:K38:1)
			
			$Obj_result_build:=Xcode(New object:C1471(\
				"action"; "build"; \
				"scheme"; $productName; \
				"destination"; $in.path; \
				"sdk"; $in.sdk; \
				"verbose"; $isDebug; \
				"test"; Bool:C1537($in.test); \
				"target"; Convert path system to POSIX:C1106($in.path+"build"+Folder separator:K24:12)))
			
			ob_error_combine($out; $Obj_result_build)
			
			$cacheFolder.file("lastBuild.xlog").setText(String:C10($Obj_result_build.out); "UTF-8"; Document with LF:K24:22)
			
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
			$log.call(Null:C1517; "Build Failed ("+$Obj_result_build.error+")"; Error message:K38:3)
			
		End if 
		
	Else 
		
		$log.call(Null:C1517; "Compute data without building"; Information message:K38:1)
		
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
	$cacheFolder.file($productName).setText(doc_folderDigest($in.path+"Sources"+Folder separator:K24:12))
	
	Case of 
			
			//______________________________________________________
		: (Bool:C1537($in.run))
			
			$in.product:=$out.build.app
			
			$ui.step("launchingTheSimulator")
			$log.call(Null:C1517; "Launching the Simulator"; Information message:K38:1)
			
			If (FEATURE.with("withSimulatorClass"))
				
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
							
							$log.call(Null:C1517; "Uninstall the App"; Information message:K38:1)
							
							// Quit App
							$simctl.terminateApp($project.product.bundleIdentifier; $out.device.udid)
							
							// Better user impression because the simulator display the installation
							DELAY PROCESS:C323(Current process:C322; 10)
							
							// Uninstall App
							$simctl.uninstallApp($project.product.bundleIdentifier; $out.device.udid)
							
						End if 
						
						$log.call(Null:C1517; "Install the App"; Information message:K38:1)
						
						// Install App
						$simctl.installApp($in.product; $out.device.udid)
						
						If (Not:C34($simctl.success))
							
							// Redmine #102346: RETRY, if any
							If (Position:C15("MIInstallerErrorDomain, code=35"; $simctl.lastError)>0)
								
								$simctl.installApp($in.product; $out.device.udid)
								
							End if 
						End if 
						
						If ($simctl.success)
							
							$ui.step("launchingTheApplication")
							$log.call(Null:C1517; "Launching the App"; Information message:K38:1)
							
							// Launch App
							$simctl.launchApp($project.product.bundleIdentifier; $out.device.udid)
							
							If ($simctl.success)
								
								$simctl.bringSimulatorAppToFront()
								
							Else 
								
								// Failed to launch App
								$ui.alert($simctl.lastError)
								$log.call(Null:C1517; "Failed to launch the App ("+$simctl.lastError+")"; Information message:K38:1)
								
							End if 
							
						Else 
							
							// Failed to install App
							$ui.alert($simctl.lastError)
							$log.call(Null:C1517; "Failed to install the App ("+$simctl.lastError+")"; Error message:K38:3)
							
						End if 
						
					Else 
						
						// Failed to open simulator
						$ui.alert("failedToOpenSimulator")
						$log.call(Null:C1517; "device not booted"; Error message:K38:3)
						
					End if 
					
				Else 
					
					// Failed to open simulator
					$ui.alert("failedToOpenSimulator")
					$log.call(Null:C1517; "device not found"; Error message:K38:3)
					
				End if 
				
			Else 
				
				If (_o_simulator(New object:C1471(\
					"action"; "open"; \
					"editorToFront"; Bool:C1537($in.testing); \
					"bringToFront"; Not:C34(Bool:C1537($in.testing)))).success)
					// Wait for a booted simulator
					$Lon_start:=Milliseconds:C459
					Repeat 
						IDLE:C311
						DELAY PROCESS:C323(Current process:C322; 60)
						$Obj_result_device:=_o_simulator(New object:C1471(\
							"action"; "devices"; \
							"filter"; "booted"))
						$out.device:=$Obj_result_device
						If ($Obj_result_device.success)
							$Boo_OK:=($Obj_result_device.devices.length>0)
						End if 
					Until ($Boo_OK)\
						 | (Not:C34($Obj_result_device.success))\
						 | ((Milliseconds:C459-$Lon_start)>SHARED.simulatorTimeout)
					If ($Boo_OK)
						POST_MESSAGE(New object:C1471(\
							"target"; $in.caller; \
							"additional"; "installingTheApplication"))
						If ($verbose)
							CALL FORM:C1391($in.caller; "LOG_EVENT"; New object:C1471(\
								"message"; "Uninstall the App"; \
								"importance"; Information message:K38:1))
						End if 
						// Quit app
						$out.simulator:=_o_simulator(New object:C1471(\
							"action"; "terminate"; \
							"identifier"; $project.product.bundleIdentifier))
						// Better user impression because the simulator display the installation
						DELAY PROCESS:C323(Current process:C322; 10)
						// Uninstall app
						$out.simulator:=_o_simulator(New object:C1471(\
							"action"; "uninstall"; \
							"identifier"; $project.product.bundleIdentifier))
						If ($out.simulator.success)
							If ($verbose)
								CALL FORM:C1391($in.caller; "LOG_EVENT"; New object:C1471(\
									"message"; "Install the App"; \
									"importance"; Information message:K38:1))
							End if 
							// Install app
							$out.simulator:=_o_simulator(New object:C1471(\
								"action"; "install"; \
								"identifier"; $in.product))
							If (Not:C34($out.simulator.success))
								// redmine #102346
								If (Value type:C1509($out.simulator.errors)=Is collection:K8:32)
									If (Position:C15("MIInstallerErrorDomain, code=35"; String:C10($out.simulator.errors[0]))>0)
										$out.simulator:=_o_simulator(New object:C1471(\
											"action"; "install"; \
											"identifier"; $in.product))
									End if 
								End if 
							End if 
							If ($out.simulator.success)
								POST_MESSAGE(New object:C1471(\
									"target"; $in.caller; \
									"additional"; "launchingTheApplication"))
								If ($verbose)
									CALL FORM:C1391($in.caller; "LOG_EVENT"; New object:C1471(\
										"message"; "Launching the App"; \
										"importance"; Information message:K38:1))
								End if 
								// Launch app
								$out.simulator:=_o_simulator(New object:C1471(\
									"action"; "launch"; \
									"identifier"; $project.product.bundleIdentifier))
								If (Not:C34($out.simulator.success))
									// Failed to launch app
									POST_MESSAGE(New object:C1471(\
										"type"; "alert"; \
										"target"; $in.caller; \
										"additional"; String:C10($out.simulator.error)))
									If ($verbose)
										CALL FORM:C1391($in.caller; "LOG_EVENT"; New object:C1471(\
											"message"; "Failed to launch the App ("+$out.simulator.error+")"; \
											"importance"; Error message:K38:3))
									End if 
								End if 
							Else 
								// Failed to install app
								POST_MESSAGE(New object:C1471(\
									"type"; "alert"; \
									"target"; $in.caller; \
									"additional"; String:C10($out.simulator.error)))
								If ($verbose)
									CALL FORM:C1391($in.caller; "LOG_EVENT"; New object:C1471(\
										"message"; "Failed to install the App ("+$out.simulator.error+")"; \
										"importance"; Error message:K38:3))
								End if 
							End if 
						Else 
							// Failed to uninstall app
							POST_MESSAGE(New object:C1471(\
								"type"; "alert"; \
								"target"; $in.caller; \
								"additional"; String:C10($out.simulator.error)))
							If ($verbose)
								CALL FORM:C1391($in.caller; "LOG_EVENT"; New object:C1471(\
									"message"; "Failed to uninstall the App ("+$out.simulator.error+")"; \
									"importance"; Error message:K38:3))
							End if 
						End if 
					Else 
						// Failed to launch device
						POST_MESSAGE(New object:C1471(\
							"type"; "alert"; \
							"target"; $in.caller; \
							"additional"; "failedToLaunchTheSimulator"))
						If ($verbose)
							CALL FORM:C1391($in.caller; "LOG_EVENT"; New object:C1471(\
								"message"; "Failed to launch simulator"; \
								"importance"; Error message:K38:3))
						End if 
					End if 
				Else 
					// Failed to open simulator
					POST_MESSAGE(New object:C1471(\
						"type"; "alert"; \
						"target"; $in.caller; \
						"additional"; "failedToOpenSimulator"))
					If ($verbose)
						CALL FORM:C1391($in.caller; "LOG_EVENT"; New object:C1471(\
							"message"; "Failed to open the Simulator"; \
							"importance"; Error message:K38:3))
					End if 
				End if 
				
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

ob_writeToDocument($out; $cacheFolder.file("lastBuild.json").platformPath; True:C214)

$out.param:=$in

// ----------------------------------------------------
If ($ui.withUI)
	
	// Send result
	CALL FORM:C1391($in.caller; "EDITOR_CALLBACK"; "build"; $out)
	
Else 
	
	// Return result
	$0:=$out
	
End if 

// ----------------------------------------------------
// End