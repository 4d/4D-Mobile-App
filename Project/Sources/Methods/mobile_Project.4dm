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

C_BOOLEAN:C305($isDebug; $Boo_OK; $Boo_verbose)
C_LONGINT:C283($Lon_parameters; $Lon_start)
C_TEXT:C284($File_; $t; $Txt_buffer)
C_OBJECT:C1216($Obj_action; $Dir_template; $Obj_cache; $Obj_dataModel; $Obj_in; $Obj_manifest; $Obj_out)
C_OBJECT:C1216($Obj_project; $Obj_result_build; $Obj_result_device; $Obj_server; $Obj_tags; $Obj_template)
C_OBJECT:C1216($Obj_parameters; $Path_manifest; $Folder_destination)

If (False:C215)
	C_OBJECT:C1216(mobile_Project; $0)
	C_OBJECT:C1216(mobile_Project; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	$isDebug:=DATABASE.isInterpreted
	
	$Obj_cache:=env_userPathname("cache")
	$Obj_cache.create()
	
	// Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
		// Add choice lists if any to action parameters
		actions("addChoiceList"; $Obj_in)
		
		If ($isDebug)
			
			// Cache the last build for debug purpose
			ob_writeToFile($Obj_in; $Obj_cache.file("lastBuild.4dmobile"); True:C214)
			
		End if 
		
	Else 
		
		If ($isDebug)
			
			// IF no parameters, load from previous launched file
			If (SHARED=Null:C1517)
				
				RECORD.warning("SHARED=Null")
				RECORD.trace()
				COMPONENT_INIT
				
			End if 
			
			$Obj_in:=ob_parseFile($Obj_cache.file("lastBuild.4dmobile")).value
			
		End if 
	End if 
	
	$Obj_out:=New object:C1471(\
		"success"; True:C214)
	
	$Boo_verbose:=Bool:C1537($Obj_in.verbose) & Bool:C1537($Obj_in.caller)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Asserted:C1132($Obj_in.project#Null:C1517))
	
	$Obj_project:=$Obj_in.project
	
	// Cleanup
	var $t; $tt : Text
	
	For each ($t; $Obj_project)
		
		If ($t[[1]]="$")
			
			If ($t="$project")
				
				For each ($tt; $Obj_project[$t])
					
					If ($tt[[1]]="$")
						
						OB REMOVE:C1226($Obj_project[$t]; $tt)
						
					End if 
				End for each 
				
			Else 
				
				OB REMOVE:C1226($Obj_project; $t)
				
			End if 
		End if 
	End for each 
	
	PROJECT:=cs:C1710.project.new($Obj_project)
	
	var $productName : Text
	
	If (PROJECT.$project.file#Null:C1517)
		
		$productName:=PROJECT.$project.file.parent.name
		
	Else 
		
		$productName:=PROJECT.$project.product
		
	End if 
End if 

If ($Obj_in.create=Null:C1517)
	
	// Default create if not defined
	$Obj_in.create:=True:C214
	
End if 

POST_MESSAGE(New object:C1471(\
"target"; $Obj_in.caller; \
"action"; "show"; \
"type"; "progress"; \
"title"; New collection:C1472("product"; " - "; $Obj_project.product.name)))

If ($Obj_in.create)
	
	POST_MESSAGE(New object:C1471(\
		"target"; $Obj_in.caller; \
		"additional"; "waitingForXcode"))
	
	// Must also close and delete folders if no change and want to recreate.
	Xcode(New object:C1471(\
		"action"; "safeDelete"; \
		"path"; $Obj_in.path))
	
	If ($Boo_verbose)
		
		CALL FORM:C1391($Obj_in.caller; "LOG_EVENT"; New object:C1471(\
			"message"; "Create project"; \
			"importance"; Information message:K38:1))
		
	End if 
	
	// We need to reload data after login?
	If ($Obj_project.server.authentication=Null:C1517)
		
		$Obj_project.server.authentication:=New object:C1471
		
	End if 
	
	$Obj_project.server.authentication.reloadData:=False:C215
	
	// If there is filter with parameters reload data after auth
	For each ($Txt_buffer; $Obj_project.dataModel)
		
		If (Value type:C1509($Obj_project.dataModel[$Txt_buffer][""].filter)=Is object:K8:27)
			
			If (Bool:C1537($Obj_project.dataModel[$Txt_buffer][""].filter.parameters))
				
				$Obj_project.server.authentication.reloadData:=True:C214
				
			End if 
		End if 
	End for each 
	
	// Other criteria like there is no embedded for one table ?
	If (Not:C34($Obj_project.server.authentication.reloadData))
		
		For each ($Txt_buffer; $Obj_project.dataModel)
			
			If (Not:C34(Bool:C1537($Obj_project.dataModel[$Txt_buffer][""].embedded)))
				
				$Obj_project.server.authentication.reloadData:=True:C214
				
			End if 
		End for each 
	End if 
	
	//===============================================================
	
	// Create tags object for template {
	$Obj_tags:=SHARED.tags
	
	$Obj_tags.product:=$productName
	$Obj_tags.packageName:=$Obj_tags.product
	
	// Project file tags
	$Obj_tags.bundleIdentifier:=$Obj_project.product.bundleIdentifier
	$Obj_tags.company:=$Obj_project.organization.name
	
	If (Length:C16($Obj_project.organization.teamId)>0)
		
		$Obj_tags.teamId:=$Obj_project.organization.teamId
		
	End if 
	
	// Info plist tags
	$Obj_tags.displayName:=$Obj_project.product.name
	$Obj_tags.version:=$Obj_project.product.version
	
	$Obj_tags.prodUrl:=$Obj_project.server.urls.production
	
	If (Length:C16($Obj_tags.prodUrl)>0)
		
		If (Not:C34(Match regex:C1019("(?i-ms)http[s]?://"; $Obj_tags.prodUrl; 1)))
			
			// Default to http
			$Obj_tags.prodUrl:="http://"+$Obj_tags.prodUrl
			
		End if 
	End if 
	
	$Obj_server:=WEB Get server info:C1531
	$Obj_tags.serverHTTPSPort:=String:C10($Obj_server.options.webHTTPSPortID)
	$Obj_tags.serverPort:=String:C10($Obj_server.options.webPortID)
	
	Case of 
			
			//________________________________________
		: (Bool:C1537($Obj_server.security.HTTPEnabled))  // priority for http
			
			$Obj_tags.serverScheme:="http"
			
			//________________________________________
		: (Bool:C1537($Obj_server.security.HTTPSEnabled))  // only https, use it
			
			$Obj_tags.serverScheme:="https"
			
			//________________________________________
		Else 
			
			$Obj_tags.serverScheme:=""  // default: let mobile app defined default?
			
			//________________________________________
	End case 
	
	$Obj_tags.serverUrls:=$Obj_server.options.webIPAddressToListen.join(","; ck ignore null or empty:K85:5)
	
	$Obj_tags.serverAuthenticationEmail:=Choose:C955(Bool:C1537($Obj_project.server.authentication.email); "true"; "false")  // plist bool format
	$Obj_tags.serverAuthenticationReloadData:=Choose:C955(Bool:C1537($Obj_project.server.authentication.reloadData); "true"; "false")  // plist bool format
	
	// Source files tags
	$Obj_tags.copyright:=$Obj_project.product.copyright
	$Obj_tags.fullname:=$Obj_project.developer.name
	$Obj_tags.date:=String:C10(Current date:C33; Date RFC 1123:K1:11; Current time:C178); 
	
	// Scripts
	$Obj_tags.xCodeVersion:=$Obj_project.$project.xCode.version
	
	// Navigation tags
	$Obj_tags.navigationTitle:=$Obj_project.main.navigationTitle
	$Obj_tags.navigationType:=$Obj_project.main.navigationType
	$Obj_tags.navigationTransition:=$Obj_project.ui.navigationTransition
	//}
	
	// Launchscreen
	$Obj_tags.launchScreenBackgroundColor:=SHARED.infoPlist.storyboard.backgroundColor  // FR #93800: take from project configuration
	
	// App manifest =================================================
	C_OBJECT:C1216($appManifest; $appFolder)
	$appManifest:=New object:C1471(\
		"application"; New object:C1471("id"; $Obj_project.product.bundleIdentifier; "name"; $Obj_project.product.name); \
		"team"; New object:C1471("id"; $Obj_project.organization.teamId); \
		"info"; $Obj_project.info)
	$appManifest.id:=String:C10($appManifest.team.id)+"."+$appManifest.application.id
	
	If (FEATURE.with(117618))
		If (Bool:C1537($Obj_project.deepLinking.enabled))
			If (Length:C16(String:C10($Obj_project.deepLinking.urlScheme))>0)
				$appManifest.urlScheme:=String:C10($Obj_project.deepLinking.urlScheme)
				$appManifest.urlScheme:=Replace string:C233($appManifest.urlScheme; "://"; "")
			End if 
			If (Length:C16(String:C10($Obj_project.deepLinking.associatedDomain))>0)
				$appManifest.associatedDomain:=String:C10($Obj_project.deepLinking.associatedDomain)
			End if 
		End if 
	End if 
	
	//#ACI0100704
	$appFolder:=Folder:C1567(fk mobileApps folder:K87:18; *).folder($appManifest.id)
	
	If (Not:C34($appFolder.exists))
		$appFolder.create()
	End if 
	$appFolder.file("manifest.json").setText(JSON Stringify:C1217($appManifest; *))
	//===============================================================
	
	POST_MESSAGE(New object:C1471(\
		"target"; $Obj_in.caller; \
		"additional"; "decompressionOfTheSdk"))
	
	// Target folder
	$Obj_out.path:=$Obj_in.path
	$Folder_destination:=Folder:C1567($Obj_in.path; fk platform path:K87:2)
	$Folder_destination.create()
	
	ob_writeToFile($Obj_in; $Folder_destination.file("project.4dmobile"); True:C214)
	
	$Dir_template:=COMPONENT_Pathname("templates").folder($Obj_in.template)
	
	If (Asserted:C1132($Dir_template.file("manifest.json").exists))
		
		$Obj_template:=ob_parseFile($Dir_template.file("manifest.json")).value
		
	End if 
	
	ASSERT:C1129($Obj_template.assets.path#Null:C1517)
	ASSERT:C1129($Obj_template.sdk.version#Null:C1517)
	
	$Obj_template.source:=$Dir_template.platformPath
	$Obj_template.assets.target:=$Obj_in.path+Convert path POSIX to system:C1107($Obj_template.assets.path)+Folder separator:K24:12+$Obj_template.assets.name+Folder separator:K24:12
	$Obj_template.assets.source:=COMPONENT_Pathname("projects").platformPath+$productName+Folder separator:K24:12+$Obj_template.assets.name+Folder separator:K24:12
	
	$Obj_out.sdk:=sdk(New object:C1471(\
		"action"; "install"; \
		"file"; COMPONENT_Pathname("sdk").platformPath+$Obj_template.sdk.version+".zip"; \
		"target"; $Obj_in.path; \
		"cache"; sdk(New object:C1471("action"; "cacheFolder")).platformPath))
	
	$Obj_tags.sdkVersion:=String:C10($Obj_out.sdk.version)
	
	If ($Obj_out.sdk.success)
		
		// ----------------------------------------------------
		// TEMPLATE
		// ----------------------------------------------------
		
		POST_MESSAGE(New object:C1471(\
			"target"; $Obj_in.caller; \
			"additional"; "workspaceCreation"))
		
		// I need a map, string -> format
		$Obj_out.formatters:=formatters(New object:C1471("action"; "getByName")).formatters
		
		// Duplicate the template {
		If (FEATURE.with("templateClass"))  // add feature flag if test not possible with new code
			$Obj_out.template:=cs:C1710.MainTemplate.new(New object:C1471(\
				"template"; $Obj_template; \
				"path"; $Obj_in.path; \
				"tags"; $Obj_tags; \
				"formatters"; $Obj_out.formatters; \
				"project"; $Obj_project)).run()
		Else 
			$Obj_out.template:=_o_templates(New object:C1471(\
				"template"; $Obj_template; \
				"path"; $Obj_in.path; \
				"tags"; $Obj_tags; \
				"formatters"; $Obj_out.formatters; \
				"project"; $Obj_project))
		End if 
		ob_error_combine($Obj_out; $Obj_out.template)
		
		$Obj_out.projfile:=$Obj_out.template.projfile
		ob_removeProperty($Obj_out.template; "projfile")  // redundant information
		
		// Add some asset fix (could optimize by merging fix)
		C_OBJECT:C1216($fixes)
		$fixes:=cs:C1710.Storyboards.new(Folder:C1567($Obj_in.path+"Sources"+Folder separator:K24:12+"Forms"; fk platform path:K87:2))
		$Obj_out.colorAssetFix:=$fixes.colorAssetFix($Obj_out.template.theme)
		ob_error_combine($Obj_out; $Obj_out.colorAssetFix)
		
		$Obj_out.imageAssetFix:=$fixes.imageAssetFix()
		ob_error_combine($Obj_out; $Obj_out.imageAssetFix)
		
		//}
		
		// Set writable target directory with all its subfolders and files
		doc_UNLOCK_DIRECTORY(New object:C1471(\
			"path"; $Obj_in.path))
		
		// ----------------------------------------------------
		// STRUCTURE & DATA
		// ----------------------------------------------------
		
		// Create catalog and data files {
		If ($Obj_in.structureAdjustments=Null:C1517)
			
			$Obj_in.structureAdjustments:=Bool:C1537($Obj_in.test)  // default value for test
			
		End if 
		
		If (Bool:C1537($Obj_in.structureAdjustments))
			
			$Obj_out.structureAdjustments:=_o_structure(New object:C1471(\
				"action"; "create"; \
				"tables"; dataModel(New object:C1471(\
				"action"; "tableNames"; \
				"dataModel"; $Obj_project.dataModel; \
				"relation"; True:C214)).values))
			
		End if 
		
		$Obj_out.dump:=dataSet(New object:C1471(\
			"action"; "check"; \
			"digest"; True:C214; \
			"project"; $Obj_project))
		ob_error_combine($Obj_out; $Obj_out.dump)
		
		If (Bool:C1537($Obj_out.dump.exists))
			
			If (Not:C34($Obj_out.dump.valid) | Not:C34(Bool:C1537($Obj_project.dataSource.doNotGenerateDataAtEachBuild)))
				
				$Obj_out.dump:=dataSet(New object:C1471(\
					"action"; "erase"; \
					"project"; $Obj_project))
				
			End if 
		End if 
		
		$Obj_out.dump:=dataSet(New object:C1471(\
			"action"; "check"; \
			"digest"; False:C215; \
			"project"; $Obj_project))
		
		If (Not:C34(Bool:C1537($Obj_out.dump.exists)))
			
			If (String:C10($Obj_in.dataSource.source)="server")
				
				//ACI0100868
				//$File_:=Choose(Length(String($Obj_in.dataSource.keyPath))>0;doc_Absolute_path ($Obj_in.dataSource.keyPath;Get 4D folder(MobileApps folder;*));Null)
				$File_:=Choose:C955(Length:C16(String:C10($Obj_in.dataSource.keyPath))>0; doc_Absolute_path($Obj_in.dataSource.keyPath); Null:C1517)
				
			Else 
				
				$File_:=COMPONENT_Pathname("key").platformPath
				
				If (Test path name:C476($File_)#Is a document:K24:1)
					
					$Obj_out.keyPing:=Rest(New object:C1471(\
						"action"; "status"; \
						"handler"; "mobileapp"))
					$Obj_out.keyPing.file:=New object:C1471(\
						"path"; $File_; \
						"exists"; (Test path name:C476($File_)=Is a document:K24:1))
					
					If (Not:C34($Obj_out.keyPing.file.exists))
						
						ob_error_add($Obj_out; "Local server key file do not exists and cannot be created")
						
					End if 
				End if 
			End if 
			
			$Obj_out.dump:=dataSet(New object:C1471(\
				"action"; "create"; \
				"project"; $Obj_project; \
				"digest"; True:C214; \
				"dataSet"; True:C214; \
				"key"; $File_; \
				"caller"; $Obj_in.caller; \
				"verbose"; $Boo_verbose))
			
			ob_error_combine($Obj_out; $Obj_out.dump)
			
		End if 
		
		// Then copy
		$Obj_out.dumpCopy:=dataSet(New object:C1471(\
			"action"; "copy"; \
			"project"; $Obj_project; \
			"target"; $Obj_in.path))
		ob_error_combine($Obj_out; $Obj_out.dumpCopy)
		//}
		
		$Obj_out.coreData:=dataModel(New object:C1471(\
			"action"; "xcdatamodel"; \
			"dataModel"; $Obj_project.dataModel; \
			"flat"; False:C215; \
			"relationship"; True:C214; \
			"path"; $Obj_in.path+"Sources"+Folder separator:K24:12+"Structures.xcdatamodeld"))
		
		ob_error_combine($Obj_out; $Obj_out.coreData)
		
		If (Not:C34(Bool:C1537($Obj_project.dataSource.doNotGenerateDataAtEachBuild)))
			
			POST_MESSAGE(New object:C1471(\
				"target"; $Obj_in.caller; \
				"additional"; "dataSetGeneration"))
			
		End if 
		
		If ($Folder_destination.folder("Resources/Assets.xcassets/Data").exists)  // If there JSON data (maybe use asset("action";"path"))
			
			$Obj_out.coreDataSet:=dataSet(New object:C1471(\
				"action"; "coreData"; \
				"removeAsset"; True:C214; \
				"path"; $Obj_in.path))
			
			ob_error_combine($Obj_out; $Obj_out.coreDataSet)
			
			If (Bool:C1537($Obj_out.coreDataSet.success))
				
				dataSet(New object:C1471(\
					"action"; "coreDataAddToProject"; \
					"uuid"; $Obj_template.uuid; \
					"tags"; $Obj_tags; \
					"path"; $Obj_in.path))
				
			End if 
			
		Else 
			
			dataSet(New object:C1471(\
				"action"; "coreDataAddToProject"; \
				"uuid"; $Obj_template.uuid; \
				"tags"; $Obj_tags; \
				"path"; $Obj_in.path))
			
		End if 
		
		// ----------------------------------------------------
		// Others (maybe move to templates, main management
		// ----------------------------------------------------
		
		C_OBJECT:C1216($debugLog)
		$debugLog:=cs:C1710.debugLog.new(SHARED.debugLog)
		
		$debugLog.start()
		
		// Generate action asset
		$Obj_out.actionAssets:=actions("assets"; New object:C1471(\
			"project"; $Obj_project; \
			"target"; $Obj_in.path))
		ob_error_combine($Obj_out; $Obj_out.actionAssets)
		
		$Obj_out.actionCapabilities:=actions("capabilities"; New object:C1471(\
			"project"; $Obj_project; \
			"target"; $Obj_in.path))
		
		$Obj_out.computedCapabilities:=New object:C1471(\
			"capabilities"; New object:C1471())
		
		If (FEATURE.with(107526))
			
			If (Bool:C1537($Obj_project.server.pushNotification))
				
				$Obj_out.computedCapabilities.capabilities.pushNotification:=True:C214
				
				If (Length:C16(String:C10($Obj_project.server.pushCertificate))>0)
					C_OBJECT:C1216($certificateFile)
					$certificateFile:=cs:C1710.doc.new($Obj_project.server.pushCertificate).target
					If ($certificateFile.exists)
						$certificateFile.copyTo($appFolder; fk overwrite:K87:5)
					Else 
						ob_warning_add($Obj_out; "Certificate file "+String:C10($Obj_project.server.pushCertificate)+" is missing")
					End if 
				End if 
			End if 
		End if 
		If (FEATURE.with(117618))
			
			If (Bool:C1537($Obj_project.deepLinking.enabled))
				If (Length:C16(String:C10($Obj_project.deepLinking.urlScheme))>0)
					C_TEXT:C284($urlScheme)
					$urlScheme:=String:C10($Obj_project.deepLinking.urlScheme)
					$urlScheme:=Replace string:C233($urlScheme; "://"; "")
					$Obj_out.computedCapabilities.capabilities.urlSchemes:=New collection:C1472($urlScheme)
				End if 
				
				If (Length:C16(String:C10($Obj_project.deepLinking.associatedDomain))>0)
					C_TEXT:C284($associatedDomain)
					$associatedDomain:=String:C10($Obj_project.deepLinking.associatedDomain)
					$associatedDomain:=Replace string:C233($associatedDomain; "https://"; "")
					$associatedDomain:=Replace string:C233($associatedDomain; "http://"; "")
					If (($associatedDomain[[Length:C16($associatedDomain)]])="/")  // strip last /
						$associatedDomain:=Substring:C12($associatedDomain; 1; Length:C16($associatedDomain)-1)
					End if 
					$Obj_out.computedCapabilities.capabilities.associatedDomains:=New collection:C1472("applinks:"+$associatedDomain; "activitycontinuation:"+$associatedDomain)
				End if 
			End if 
			
		End if 
		
		// Manage app capabilities
		$Obj_out.capabilities:=capabilities(\
			New object:C1471("action"; "inject"; "target"; $Obj_in.path; "tags"; $Obj_tags; \
			"value"; New object:C1471(\
			"common"; SHARED; \
			"project"; $Obj_project; \
			"action"; $Obj_out.actionCapabilities; \
			"computed"; $Obj_out.computedCapabilities; \
			"templates"; $Obj_out.template)))
		ob_error_combine($Obj_out; $Obj_out.capabilities)
		
		$debugLog.stop()
		
		// ----------------------------------------------------
		// DEV FEATURES
		// ----------------------------------------------------
		
		// Add sources if any to workspace {
		If (Bool:C1537(FEATURE._405))  // In feature until fix project launch with xcode
			
			Xcode(New object:C1471(\
				"action"; "workspace-addsources"; \
				"path"; $Obj_in.path))
			
		End if 
		//}
		
		// Backup into git {
		If (Bool:C1537(FEATURE._917))
			
			git(New object:C1471(\
				"action"; "config core.autocrlf"; \
				"path"; $Obj_in.path))
			
			$Obj_out.git:=git(New object:C1471(\
				"action"; "init"; \
				"path"; $Obj_in.path))
			
			//ob_error_combine ($Obj_out;$Obj_out.git) //  XXX cannot combine until there is warning not in errors
			
			If ($Obj_out.git.success)
				
				$Obj_out.git:=git(New object:C1471(\
					"action"; "add -A"; \
					"path"; $Obj_in.path))
				
				//ob_error_combine ($Obj_out;$Obj_out.git) //  XXX cannot combine until there is warning not in errors
				
				$Obj_out.git:=git(New object:C1471(\
					"action"; "commit -m initial"; \
					"path"; $Obj_in.path))
				
				//ob_error_combine ($Obj_out;$Obj_out.git) //  XXX cannot combine until there is warning not in errors
				
			End if 
		End if 
		//}
		
		$Obj_out.tags:=$Obj_tags
		
		$Obj_out.success:=Not:C34(ob_error_has($Obj_out))  // XXX do it only at end (and remove this code, but must be tested)
		
		If (Not:C34($Obj_out.success))
			
			POST_MESSAGE(New object:C1471(\
				"type"; "alert"; \
				"target"; $Obj_in.caller; \
				"additional"; ob_error_string($Obj_out)))
			
		End if 
		
		// End creation process
		
	Else 
		
		$Obj_out.success:=False:C215
		
		// Failed to unzip sdk
		POST_MESSAGE(New object:C1471(\
			"type"; "alert"; \
			"target"; $Obj_in.caller; \
			"additional"; "failedDecompressTheSdk"))
		
		If ($Boo_verbose)
			
			CALL FORM:C1391($Obj_in.caller; "LOG_EVENT"; New object:C1471(\
				"message"; "Failed to unzip sdk"; \
				"importance"; Error message:K38:3))
			
		End if 
	End if 
	
	DELAY PROCESS:C323(Current process:C322; 60*2)
	
End if 

// ----------------------------------------------------
// BUILD OR ARCHIVE & LAUNCH
// ----------------------------------------------------

If ($Obj_out.success)
	
	If (Bool:C1537($Obj_in.build))
		
		If (Bool:C1537($Obj_in.archive))
			
			// Archive
			POST_MESSAGE(New object:C1471(\
				"target"; $Obj_in.caller; \
				"additional"; "projectArchive"))
			
			If ($Boo_verbose)
				
				CALL FORM:C1391($Obj_in.caller; "LOG_EVENT"; New object:C1471(\
					"message"; "Archiving project"; \
					"importance"; Information message:K38:1))
				
			End if 
			
			$Obj_result_build:=Xcode(New object:C1471(\
				"action"; "build"; \
				"scheme"; $productName; \
				"destination"; $Obj_in.path; \
				"sdk"; "iphoneos"; \
				"verbose"; $isDebug; \
				"configuration"; "Release"; \
				"archive"; True:C214; \
				"allowProvisioningUpdates"; True:C214; \
				"allowProvisioningDeviceRegistration"; True:C214; \
				"archivePath"; Convert path system to POSIX:C1106($Obj_in.path+"archive"+Folder separator:K24:12+$productName+".xcarchive")))
			
			$Obj_cache.file("lastArchive.xlog").setText(String:C10($Obj_result_build.out); "UTF-8"; Document with LF:K24:22)
			
			ob_error_combine($Obj_out; $Obj_result_build)
			
			If ($Obj_result_build.success)
				
				// And export
				POST_MESSAGE(New object:C1471(\
					"target"; $Obj_in.caller; \
					"additional"; "projectArchiveExport"))
				
				If ($Boo_verbose)
					
					CALL FORM:C1391($Obj_in.caller; "LOG_EVENT"; New object:C1471(\
						"message"; "Exporting project archive"; \
						"importance"; Information message:K38:1))
					
				End if 
				
				$Obj_result_build:=Xcode(New object:C1471(\
					"action"; "build"; \
					"verbose"; $isDebug; \
					"exportArchive"; True:C214; \
					"teamID"; String:C10($Obj_in.project.organization.teamId); \
					"exportPath"; Convert path system to POSIX:C1106($Obj_in.path+"archive"+Folder separator:K24:12); \
					"archivePath"; Convert path system to POSIX:C1106($Obj_in.path+"archive"+Folder separator:K24:12+$productName+".xcarchive")))
				
				env_userPathname("cache"; "lastExportArchive.xlog").setText(String:C10($Obj_result_build.out); "UTF-8"; Document with LF:K24:22)
				
				ob_error_combine($Obj_out; $Obj_result_build)
				
			Else 
				
				// Failed to archive
				POST_MESSAGE(New object:C1471(\
					"type"; "alert"; \
					"target"; $Obj_in.caller; \
					"additional"; "failedToArchive"))
				
			End if 
			
		Else 
			
			// Build application
			POST_MESSAGE(New object:C1471(\
				"target"; $Obj_in.caller; \
				"additional"; "projectBuild"))
			
			If ($Boo_verbose)
				
				CALL FORM:C1391($Obj_in.caller; "LOG_EVENT"; New object:C1471(\
					"message"; "Building project"; \
					"importance"; Information message:K38:1))
				
			End if 
			
			$Obj_result_build:=Xcode(New object:C1471(\
				"action"; "build"; \
				"scheme"; $productName; \
				"destination"; $Obj_in.path; \
				"sdk"; $Obj_in.sdk; \
				"verbose"; $isDebug; \
				"test"; Bool:C1537($Obj_in.test); \
				"target"; Convert path system to POSIX:C1106($Obj_in.path+"build"+Folder separator:K24:12)))
			
			ob_error_combine($Obj_out; $Obj_result_build)
			
			$Obj_cache.file("lastBuild.xlog").setText(String:C10($Obj_result_build.out); "UTF-8"; Document with LF:K24:22)
			
			// Some times Xcode method failed to get app path, maybe if already builded and nothing to do???
			If ($Obj_result_build.app=Null:C1517)
				
				$File_:=$Obj_in.path+Convert path POSIX to system:C1107("build/Build/Products/Debug-iphonesimulator/")+$productName+".app"
				
				If (Test path name:C476($File_)=Is a folder:K24:2)
					
					$Obj_result_build.app:=Convert path system to POSIX:C1106($File_)
					
				End if 
			End if 
		End if 
		
		If ($Obj_result_build.success)
			
		Else 
			
			POST_MESSAGE(New object:C1471(\
				"type"; "alert"; \
				"target"; $Obj_in.caller; \
				"additional"; String:C10($Obj_result_build.error)))
			
			If ($Boo_verbose)
				
				CALL FORM:C1391($Obj_in.caller; "LOG_EVENT"; New object:C1471(\
					"message"; "Build Failed ("+$Obj_result_build.error+")"; \
					"importance"; Error message:K38:3))
				
			End if 
		End if 
		
	Else 
		
		If ($Boo_verbose)
			
			CALL FORM:C1391($Obj_in.caller; "LOG_EVENT"; New object:C1471(\
				"message"; "Compute data without building"; \
				"importance"; Information message:K38:1))
			
		End if 
		
		// Compute data without building
		$Obj_result_build:=New object:C1471
		
		$File_:=$Obj_in.path+Convert path POSIX to system:C1107("build/Build/Products/Debug-iphonesimulator/")+$productName+".app"
		
		If (Test path name:C476($File_)=Is a folder:K24:2)
			
			$Obj_result_build.app:=Convert path system to POSIX:C1106($File_)
			$Obj_result_build.success:=True:C214
			
		Else 
			
			$Obj_result_build.success:=False:C215  // No build
			
		End if 
	End if 
	
	$Obj_out.build:=$Obj_result_build
	$Obj_out.success:=$Obj_result_build.success | Not:C34(Bool:C1537($Obj_in.build))
	
	// Else
	// we failed to create project
	
End if 

If ($Obj_out.success)
	
	// Save the signature of the sources folder
	$Obj_cache.file($productName).setText(doc_folderDigest($Obj_in.path+"Sources"+Folder separator:K24:12))
	
	Case of 
			
			//______________________________________________________
		: (Bool:C1537($Obj_in.run))
			
			$Obj_in.product:=$Obj_out.build.app
			
			POST_MESSAGE(New object:C1471(\
				"target"; $Obj_in.caller; \
				"additional"; "launchingTheSimulator"))
			
			If ($Boo_verbose)
				
				CALL FORM:C1391($Obj_in.caller; "LOG_EVENT"; New object:C1471(\
					"message"; "Launching the Simulator"; \
					"importance"; Information message:K38:1))
				
			End if 
			
			If (simulator(New object:C1471(\
				"action"; "open"; \
				"editorToFront"; Bool:C1537($Obj_in.testing); \
				"bringToFront"; Not:C34(Bool:C1537($Obj_in.testing)))).success)
				
				// Wait for a booted simulator
				$Lon_start:=Milliseconds:C459
				
				Repeat 
					
					IDLE:C311
					DELAY PROCESS:C323(Current process:C322; 60)
					$Obj_result_device:=simulator(New object:C1471(\
						"action"; "devices"; \
						"filter"; "booted"))
					
					$Obj_out.device:=$Obj_result_device
					
					If ($Obj_result_device.success)
						
						$Boo_OK:=($Obj_result_device.devices.length>0)
						
					End if 
				Until ($Boo_OK)\
					 | (Not:C34($Obj_result_device.success))\
					 | ((Milliseconds:C459-$Lon_start)>SHARED.simulatorTimeout)
				
				If ($Boo_OK)
					
					POST_MESSAGE(New object:C1471(\
						"target"; $Obj_in.caller; \
						"additional"; "installingTheApplication"))
					
					If ($Boo_verbose)
						
						CALL FORM:C1391($Obj_in.caller; "LOG_EVENT"; New object:C1471(\
							"message"; "Uninstall the App"; \
							"importance"; Information message:K38:1))
						
					End if 
					
					// Quit app
					$Obj_out.simulator:=simulator(New object:C1471(\
						"action"; "terminate"; \
						"identifier"; $Obj_project.product.bundleIdentifier))
					
					// Better user impression because the simulator display the installation
					DELAY PROCESS:C323(Current process:C322; 10)
					
					// Uninstall app
					$Obj_out.simulator:=simulator(New object:C1471(\
						"action"; "uninstall"; \
						"identifier"; $Obj_project.product.bundleIdentifier))
					
					If ($Obj_out.simulator.success)
						
						If ($Boo_verbose)
							
							CALL FORM:C1391($Obj_in.caller; "LOG_EVENT"; New object:C1471(\
								"message"; "Install the App"; \
								"importance"; Information message:K38:1))
							
						End if 
						
						// Install app
						$Obj_out.simulator:=simulator(New object:C1471(\
							"action"; "install"; \
							"identifier"; $Obj_in.product))
						
						If (Not:C34($Obj_out.simulator.success))
							
							// redmine #102346
							If (Value type:C1509($Obj_out.simulator.errors)=Is collection:K8:32)
								
								If (Position:C15("MIInstallerErrorDomain, code=35"; String:C10($Obj_out.simulator.errors[0]))>0)
									
									$Obj_out.simulator:=simulator(New object:C1471(\
										"action"; "install"; \
										"identifier"; $Obj_in.product))
									
								End if 
							End if 
						End if 
						
						If ($Obj_out.simulator.success)
							
							POST_MESSAGE(New object:C1471(\
								"target"; $Obj_in.caller; \
								"additional"; "launchingTheApplication"))
							
							If ($Boo_verbose)
								
								CALL FORM:C1391($Obj_in.caller; "LOG_EVENT"; New object:C1471(\
									"message"; "Launching the App"; \
									"importance"; Information message:K38:1))
								
							End if 
							
							// Launch app
							$Obj_out.simulator:=simulator(New object:C1471(\
								"action"; "launch"; \
								"identifier"; $Obj_project.product.bundleIdentifier))
							
							If (Not:C34($Obj_out.simulator.success))
								
								// Failed to launch app
								POST_MESSAGE(New object:C1471(\
									"type"; "alert"; \
									"target"; $Obj_in.caller; \
									"additional"; String:C10($Obj_out.simulator.error)))
								
								If ($Boo_verbose)
									
									CALL FORM:C1391($Obj_in.caller; "LOG_EVENT"; New object:C1471(\
										"message"; "Failed to launch the App ("+$Obj_out.simulator.error+")"; \
										"importance"; Error message:K38:3))
									
								End if 
							End if 
							
						Else 
							
							// Failed to install app
							POST_MESSAGE(New object:C1471(\
								"type"; "alert"; \
								"target"; $Obj_in.caller; \
								"additional"; String:C10($Obj_out.simulator.error)))
							
							If ($Boo_verbose)
								
								CALL FORM:C1391($Obj_in.caller; "LOG_EVENT"; New object:C1471(\
									"message"; "Failed to install the App ("+$Obj_out.simulator.error+")"; \
									"importance"; Error message:K38:3))
								
							End if 
						End if 
						
					Else 
						
						// Failed to uninstall app
						POST_MESSAGE(New object:C1471(\
							"type"; "alert"; \
							"target"; $Obj_in.caller; \
							"additional"; String:C10($Obj_out.simulator.error)))
						
						If ($Boo_verbose)
							
							CALL FORM:C1391($Obj_in.caller; "LOG_EVENT"; New object:C1471(\
								"message"; "Failed to uninstall the App ("+$Obj_out.simulator.error+")"; \
								"importance"; Error message:K38:3))
							
						End if 
					End if 
					
				Else 
					
					// Failed to launch device
					POST_MESSAGE(New object:C1471(\
						"type"; "alert"; \
						"target"; $Obj_in.caller; \
						"additional"; "failedToLaunchTheSimulator"))
					
					If ($Boo_verbose)
						
						CALL FORM:C1391($Obj_in.caller; "LOG_EVENT"; New object:C1471(\
							"message"; "Failed to launch simulator"; \
							"importance"; Error message:K38:3))
						
					End if 
				End if 
				
			Else 
				
				// Failed to open simulator
				POST_MESSAGE(New object:C1471(\
					"type"; "alert"; \
					"target"; $Obj_in.caller; \
					"additional"; "failedToOpenSimulator"))
				
				If ($Boo_verbose)
					
					CALL FORM:C1391($Obj_in.caller; "LOG_EVENT"; New object:C1471(\
						"message"; "Failed to open the Simulator"; \
						"importance"; Error message:K38:3))
					
				End if 
			End if 
			
			//______________________________________________________
		: (Bool:C1537($Obj_in.archive))
			
			// Calculate the ipa file pathname
			$File_:=Convert path POSIX to system:C1107($Obj_result_build.archivePath)
			$File_:=Object to path:C1548(New object:C1471(\
				"parentFolder"; Path to object:C1547($File_).parentFolder; \
				"name"; Path to object:C1547($File_).name; \
				"extension"; ".ipa"))
			
			If ($Obj_in.manualInstallation)
				
				// Open xCode devices window
				cs:C1710.Xcode.new().showDevicesWindow()
				
				// Show archive on disk ?
				POST_MESSAGE(New object:C1471(\
					"target"; $Obj_in.caller; \
					"type"; "confirm"; \
					"title"; "archiveCreationSuccessful"; \
					"additional"; "wouldYouLikeToRevealInFinder"; \
					"okFormula"; Formula:C1597(SHOW ON DISK:C922(String:C10($File_)))))
				
			Else 
				
				// Install the archive on the device
				POST_MESSAGE(New object:C1471(\
					"target"; $Obj_in.caller; \
					"additional"; "installingTheApplication"))
				
				$Obj_out.device:=device(New object:C1471(\
					"action"; "installApp"; \
					"path"; $File_))
				
				ob_error_combine($Obj_out; $Obj_out.device)
				
				If (Not:C34($Obj_out.device.success))
					
					POST_MESSAGE(New object:C1471(\
						"type"; "alert"; \
						"target"; $Obj_in.caller; \
						"additional"; $Obj_out.device.errors.join("\r")))
					
				End if 
			End if 
			
			//______________________________________________________
	End case 
End if 

POST_MESSAGE(New object:C1471(\
"target"; $Obj_in.caller; \
"action"; "hide"))

ob_writeToDocument($Obj_out; $Obj_cache.file("lastBuild.json").platformPath; True:C214)

$Obj_out.param:=$Obj_in


// ----------------------------------------------------
If ($Obj_in.caller#Null:C1517)
	
	// Send result
	CALL FORM:C1391($Obj_in.caller; "EDITOR_CALLBACK"; "build"; $Obj_out)
	
Else 
	
	// Return result
	$0:=$Obj_out
	
End if 

// ----------------------------------------------------
// End