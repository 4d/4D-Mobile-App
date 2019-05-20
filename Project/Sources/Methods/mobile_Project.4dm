//%attributes = {"invisible":true,"preemptive":"capable"}
/*
out := ***mobile_Project*** ( in )
 -> in (Object)
 <- out (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : mobile_Project
  // Database: 4D Mobile Express
  // ID[11266537E65642B19D01235BDDCA03AB]
  // Created #22-6-2017 by Vincent de Lachaux
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

C_BOOLEAN:C305($Boo_dev;$Boo_OK;$Boo_verbose)
C_LONGINT:C283($Lon_parameters;$Lon_start)
C_TEXT:C284($File_;$Txt_buffer)
C_OBJECT:C1216($o;$Obj_cache;$Obj_in;$Obj_out;$Obj_project;$Obj_result_build)
C_OBJECT:C1216($Obj_result_device;$Obj_server;$Obj_tags;$Obj_template)

If (False:C215)
	C_OBJECT:C1216(mobile_Project ;$0)
	C_OBJECT:C1216(mobile_Project ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	$Boo_dev:=Not:C34(Is compiled mode:C492)
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
		If (Asserted:C1132($Obj_in.project#Null:C1517))
			
			$Obj_project:=$Obj_in.project
			
		End if 
	End if 
	  //}
	
	$Obj_out:=New object:C1471(\
		"success";True:C214)
	
	$Boo_verbose:=Bool:C1537($Obj_in.verbose) & Bool:C1537($Obj_in.caller)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Obj_cache:=env_userPathname ("cache")
$Obj_cache.create()

If ($Boo_dev)
	
	  // Cache the last build for debug purpose
	ob_writeToDocument ($Obj_in;$Obj_cache.file("lastBuild.4dmobile").platformPath;True:C214)
	
End if 

If ($Obj_in.create=Null:C1517)
	
	  // Default create if not defined
	$Obj_in.create:=True:C214
	
End if 

POST_FORM_MESSAGE (New object:C1471(\
"target";$Obj_in.caller;\
"action";"show";\
"type";"progress";\
"title";New collection:C1472("product";" - ";$Obj_project.product.name)))

If ($Obj_in.create)
	
	POST_FORM_MESSAGE (New object:C1471(\
		"target";$Obj_in.caller;\
		"additional";"waitingForXcode"))
	
	  // Must also close and delete folders if no change and want to recreate.
	Xcode (New object:C1471(\
		"action";"safeDelete";\
		"path";$Obj_in.path))
	
	If ($Boo_verbose)
		
		CALL FORM:C1391($Obj_in.caller;"LOG_EVENT";New object:C1471(\
			"message";"Create project";\
			"importance";Information message:K38:1))
		
	End if 
	
	  //If (commonValues=Null)  // I think this is unnecessary
	  //COMPONENT_INIT
	  //End if
	
	  // We need to reload data after login?
	If ($Obj_project.server.authentication=Null:C1517)
		
		$Obj_project.server.authentication:=New object:C1471(\
			)
		
	End if 
	
	$Obj_project.server.authentication.reloadData:=False:C215
	
	  //If (Bool(featuresFlags._100174))
	
	  // If there is filter with parameters reload data after auth
	For each ($Txt_buffer;$Obj_project.dataModel)
		
		If (Value type:C1509($Obj_project.dataModel[$Txt_buffer].filter)=Is object:K8:27)
			
			If (Bool:C1537($Obj_project.dataModel[$Txt_buffer].filter.parameters))
				
				$Obj_project.server.authentication.reloadData:=True:C214
				
			End if 
		End if 
	End for each 
	
	  // other criteria like there is no embedded for one table ?
	If (Not:C34($Obj_project.server.authentication.reloadData))
		
		For each ($Txt_buffer;$Obj_project.dataModel)
			
			If (Not:C34(Bool:C1537($Obj_project.dataModel[$Txt_buffer].embedded)))
				
				$Obj_project.server.authentication.reloadData:=True:C214
				
			End if 
		End for each 
	End if 
	  //End if 
	
	  //===============================================================
	
	  // Create tags object for template {
	$Obj_tags:=commonValues.tags
	
	  //$Obj_tags:=New object
	  //$Obj_tags.componentBuild:=COMPONENT_Infos("componentBuild")
	  //$Obj_tags.ideVersion:=COMPONENT_Infos("ideVersion")
	  //$Obj_tags.ideBuildVersion:=COMPONENT_Infos ("ideBuildVersion")
	
	$Obj_tags.product:=$Obj_project.$project.product
	$Obj_tags.packageName:=$Obj_tags.product
	
	  // Project file tags
	$Obj_tags.bundleIdentifier:=$Obj_project.product.bundleIdentifier
	$Obj_tags.company:=$Obj_project.organization.name
	
	  //$Obj_tags.iosDeploymentTarget:=commonValues.iosDeploymentTarget
	  //$Obj_tags.swiftVersion:=commonValues.swift.Version
	  //$Obj_tags.swiftFlagsDebug:=commonValues.swift.Flags.Debug
	  //$Obj_tags.swiftFlagsRelease:=commonValues.swift.Flags.Release
	  //$Obj_tags.swiftOptimizationLevelDebug:=commonValues.swift.OptimizationLevel.Debug
	  //$Obj_tags.swiftOptimizationLevelRelease:=commonValues.swift.OptimizationLevel.Release
	  //$Obj_tags.swiftCompilationModeDebug:=commonValues.swift.CompilationMode.Debug
	  //$Obj_tags.swiftCompilationModeRelease:=commonValues.swift.CompilationMode.Release
	  //$Obj_tags.onDemandResources:=Choose(commonValues.onDemandResources;"YES";"NO")  // old plist format in project file
	  //$Obj_tags.bitcode:=Choose(commonValues.bitcode;"YES";"NO")  // old plist format in project file
	  //$Obj_tags.targetedDeviceFamily:=commonValues.targetedDeviceFamily
	
	If (Length:C16($Obj_project.organization.teamId)>0)
		
		$Obj_tags.teamId:=$Obj_project.organization.teamId
		
	End if 
	
	  // Info plist tags
	$Obj_tags.displayName:=$Obj_project.product.name
	$Obj_tags.version:=$Obj_project.product.version
	
	  //$Obj_tags.build:=commonValues.build
	  //$Obj_tags.developmentRegion:=commonValues.developmentRegion
	  //$Obj_tags.storyboardLaunchScreen:=commonValues.storyboard.LaunchScreen
	  //$Obj_tags.storyboardMain:=commonValues.storyboard.Main
	  //$Obj_tags.urlScheme:=commonValues.urlScheme
	  // 4D Server {
	  //$Obj_tags.testUrl:=$Obj_project.server.urls.test
	  //If (Not(Match regex("(?i-ms)http[s]?://";$Obj_tags.testUrl;1)))
	  //  // Default to http
	  //$Obj_tags.testUrl:="http://"+$Obj_tags.testUrl
	  // End if
	
	$Obj_tags.prodUrl:=$Obj_project.server.urls.production
	
	If (Length:C16($Obj_tags.prodUrl)>0)
		
		If (Not:C34(Match regex:C1019("(?i-ms)http[s]?://";$Obj_tags.prodUrl;1)))
			
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
	
	$Obj_tags.serverUrls:=$Obj_server.options.webIPAddressToListen.join(",";ck ignore null or empty:K85:5)
	
	$Obj_tags.serverAuthenticationEmail:=Choose:C955(Bool:C1537($Obj_project.server.authentication.email);"true";"false")  // plist bool format
	$Obj_tags.serverAuthenticationReloadData:=Choose:C955(Bool:C1537($Obj_project.server.authentication.reloadData);"true";"false")  // plist bool format
	
	  // Source files tags
	$Obj_tags.copyright:=$Obj_project.product.copyright
	$Obj_tags.fullname:=$Obj_project.developer.name
	$Obj_tags.date:=String:C10(Current date:C33;Date RFC 1123:K1:11;Current time:C178);
	
	  // Scripts
	$Obj_tags.xCodeVersion:=$Obj_project.$project.xCode.version
	
	  // Navigation tags
	$Obj_tags.navigationTitle:=$Obj_project.main.navigationTitle
	$Obj_tags.navigationType:=$Obj_project.main.navigationType
	$Obj_tags.navigationTransition:=$Obj_project.ui.navigationTransition
	  //}
	
	  // Launchscreen
	  //$Obj_tags.launchScreenBackgroundColor:=commonValues.storyboard.backgroundColor  // FR #93800: take from project configuration
	$Obj_tags.launchScreenBackgroundColor:=commonValues.infoPlist.storyboard.backgroundColor  // FR #93800: take from project configuration
	
	  //===============================================================
	
	POST_FORM_MESSAGE (New object:C1471(\
		"target";$Obj_in.caller;\
		"additional";"decompressionOfTheSdk"))
	
	  // Target folder
	$Obj_out.path:=$Obj_in.path
	CREATE FOLDER:C475($Obj_in.path;*)
	
	$o:=COMPONENT_Pathname ("templates").folder($Obj_in.template)
	
	If (Asserted:C1132($o.file("manifest.json").exists))
		
		$Obj_template:=JSON Parse:C1218($o.file("manifest.json").getText())
		
	End if 
	
	ASSERT:C1129($Obj_template.assets.path#Null:C1517)
	ASSERT:C1129($Obj_template.sdk.version#Null:C1517)
	
	$Obj_template.source:=$o.platformPath
	
	$Obj_template.assets.target:=$Obj_in.path+Convert path POSIX to system:C1107($Obj_template.assets.path)+Folder separator:K24:12+$Obj_template.assets.name+Folder separator:K24:12
	$Obj_template.assets.source:=_o_Pathname ("projects")+$Obj_project.$project.product+Folder separator:K24:12+$Obj_template.assets.name+Folder separator:K24:12
	
	  //#ACI0098572 [
	  //$Obj_out.sdk:=sdk (New object(//"action";"install";//"file";Pathname ("sdk")+$Obj_template.sdk.version+".zip";//"target";$Obj_in.path;// "cache";env_userPath ("cacheSdk")))
	  //$Obj_out.sdk:=sdk (New object(\
				//"action";"install";\
				//"file";Pathname ("sdk")+$Obj_template.sdk.version+".zip";\
				//"target";$Obj_in.path;\
				//"cache";Convert path POSIX to system(env_System_path ("caches";True)+"com.4d.mobile/sdk/")))
	
	$Obj_out.sdk:=sdk (New object:C1471(\
		"action";"install";\
		"file";_o_Pathname ("sdk")+$Obj_template.sdk.version+".zip";\
		"target";$Obj_in.path;\
		"cache";Folder:C1567("/Library/Caches/com.4d.mobile/sdk").platformPath))
	  //]
	
	$Obj_tags.sdkVersion:=String:C10($Obj_out.sdk.version)
	
	If ($Obj_out.sdk.success)
		
		  // ----------------------------------------------------
		  // TEMPLATE
		  // ----------------------------------------------------
		
		POST_FORM_MESSAGE (New object:C1471(\
			"target";$Obj_in.caller;\
			"additional";"workspaceCreation"))
		
		  // I need a map, string -> format
		$Obj_out.formatters:=formatters (New object:C1471("action";"getByName")).formatters
		
		  // Duplicate the template {
		$Obj_out.template:=templates (New object:C1471(\
			"template";$Obj_template;\
			"path";$Obj_in.path;\
			"tags";$Obj_tags;\
			"formatters";$Obj_out.formatters;\
			"project";$Obj_project))
		ob_error_combine ($Obj_out;$Obj_out.template)
		
		$Obj_out.projfile:=$Obj_out.template.projfile
		ob_removeProperty ($Obj_out.template;"projfile")  // redundant information
		
		  // Add some asset fix (could optimize by merging fix)
		$Obj_out.colorAssetFix:=storyboard (New object:C1471(\
			"action";"colorAssetFix";\
			"path";$Obj_in.path+"Sources"+Folder separator:K24:12+"Forms";\
			"theme";$Obj_out.template.theme))
		ob_error_combine ($Obj_out;$Obj_out.colorAssetFix)
		
		$Obj_out.imageAssetFix:=storyboard (New object:C1471(\
			"action";"imageAssetFix";\
			"path";$Obj_in.path+"Sources"+Folder separator:K24:12+"Forms"))
		ob_error_combine ($Obj_out;$Obj_out.imageAssetFix)
		
		  //}
		
		  // Set writable target directory with all its subfolders and files
		doc_UNLOCK_DIRECTORY (New object:C1471(\
			"path";$Obj_in.path))
		
		  // ----------------------------------------------------
		  // STRUCTURE & DATA
		  // ----------------------------------------------------
		
		  // Create catalog and data files {
		If ($Obj_in.structureAdjustments=Null:C1517)
			
			$Obj_in.structureAdjustments:=Bool:C1537($Obj_in.test)  // default value for test
			
		End if 
		
		If (Bool:C1537($Obj_in.structureAdjustments))
			
			$Obj_out.structureAdjustments:=structure (New object:C1471(\
				"action";"create";\
				"tables";dataModel (New object:C1471(\
				"action";"tableNames";\
				"dataModel";$Obj_project.dataModel;\
				"relation";True:C214)).values))
			
		End if 
		
		$Obj_out.dump:=dataSet (New object:C1471(\
			"action";"check";\
			"digest";True:C214;\
			"project";$Obj_project))
		ob_error_combine ($Obj_out;$Obj_out.dump)
		
		If (Bool:C1537($Obj_out.dump.exists))
			
			If (Not:C34($Obj_out.dump.valid) | Not:C34(Bool:C1537($Obj_project.dataSource.doNotGenerateDataAtEachBuild)))
				
				$Obj_out.dump:=dataSet (New object:C1471(\
					"action";"erase";\
					"project";$Obj_project))
				
			End if 
		End if 
		
		$Obj_out.dump:=dataSet (New object:C1471(\
			"action";"check";\
			"digest";False:C215;\
			"project";$Obj_project))
		
		If (Not:C34(Bool:C1537($Obj_out.dump.exists)))
			
			  //If (Bool(featuresFlags._102457))
			
			If (String:C10($Obj_in.dataSource.source)="server")
				
				$File_:=Choose:C955(Length:C16(String:C10($Obj_in.dataSource.keyPath))>0;doc_Absolute_path (Convert path POSIX to system:C1107($Obj_in.dataSource.keyPath));Null:C1517)
				
			Else 
				
				$File_:=_o_Pathname ("key")
				
				If (Test path name:C476($File_)#Is a document:K24:1)
					
					$Obj_out.keyPing:=Rest (New object:C1471(\
						"action";"status";\
						"handler";"mobileapp"))
					$Obj_out.keyPing.file:=New object:C1471(\
						"path";$File_;\
						"exists";(Test path name:C476($File_)=Is a document:K24:1))
					
					If (Not:C34($Obj_out.keyPing.file.exists))
						
						ob_error_add ($Obj_out;"Local server key file do not exists and cannot be created")
						
					End if 
				End if 
			End if 
			
			  //Else 
			  //$File_:=Null
			  //End if 
			
			  // Generate if not exist
			  //$Obj_out.dump:=dataSet (New object(\
								//"action";"create";\
								//"project";$Obj_project;\
								//"digest";True;\
								//"dataSet";Bool(featuresFlags._101725);\
								//"key";$File_;\
								//"caller";$Obj_in.caller;\
								//"verbose";$Boo_verbose;\
								//"picture";Not(Bool(featuresFlags._97117))))
			$Obj_out.dump:=dataSet (New object:C1471(\
				"action";"create";\
				"project";$Obj_project;\
				"digest";True:C214;\
				"dataSet";True:C214;\
				"key";$File_;\
				"caller";$Obj_in.caller;\
				"verbose";$Boo_verbose;\
				"picture";Not:C34(Bool:C1537(featuresFlags._97117))))
			
			  //_97117 deactive picture dump for QA purpose
			
			ob_error_combine ($Obj_out;$Obj_out.dump)
			
		End if 
		
		  // Then copy
		$Obj_out.dumpCopy:=dataSet (New object:C1471(\
			"action";"copy";\
			"project";$Obj_project;\
			"target";$Obj_in.path))
		ob_error_combine ($Obj_out;$Obj_out.dumpCopy)
		  //}
		
		  //If (Not(featuresFlags._102457))
		  //TEMPO_1 ($Obj_in.path)  //#TEMPO_FIX
		  //End if 
		
		  // Update core data model
		$Obj_out.coreData:=dataModel (New object:C1471(\
			"action";"xcdatamodel";\
			"dataModel";$Obj_project.dataModel;\
			"flat";False:C215;\
			"relationship";Bool:C1537(featuresFlags._103850);\
			"path";$Obj_in.path+"Sources"+Folder separator:K24:12+"Structures.xcdatamodeld"))
		ob_error_combine ($Obj_out;$Obj_out.coreData)
		
		
		  // ----------------------------------------------------
		  // Others (maybe move to templates, main management
		  // ----------------------------------------------------
		
		  // Generate action asset
		If (Bool:C1537(featuresFlags._103505))
			
			$Obj_out.actionAssets:=actions ("assets";New object:C1471("project";$Obj_project;"target";$Obj_in.path))
			ob_error_combine ($Obj_out;$Obj_out.actionAssets)
			
		End if 
		
		If (Bool:C1537(featuresFlags._103505))
			
			$Obj_out.actionAssets:=actions ("assets";New object:C1471("project";$Obj_project;"target";$Obj_in.path))
			ob_error_combine ($Obj_out;$Obj_out.actionAssets)
			
		End if 
		
		  // Manage app capabilities
		If (Bool:C1537(featuresFlags._105413))
			
			$Obj_out.capabilities:=capabilities (\
				New object:C1471("action";"inject";"target";$Obj_in.path;"tags";$Obj_tags;\
				"value";New object:C1471("common";commonValues;"project";$Obj_project;"templates";$Obj_out.template)))
			ob_error_combine ($Obj_out;$Obj_out.capabilities)
			
		End if 
		
		  // ----------------------------------------------------
		  // DEV FEATURES
		  // ----------------------------------------------------
		
		  // Add sources if any to workspace {
		If (Bool:C1537(featuresFlags._405))  // In feature until fix project launch with xcode
			
			Xcode (New object:C1471(\
				"action";"workspace-addsources";\
				"path";$Obj_in.path))
			
		End if 
		  //}
		
		  // Backup into git {
		If (Bool:C1537(featuresFlags._917))
			
			git (New object:C1471(\
				"action";"config core.autocrlf";\
				"path";$Obj_in.path))
			
			$Obj_out.git:=git (New object:C1471(\
				"action";"init";\
				"path";$Obj_in.path))
			
			  //ob_error_combine ($Obj_out;$Obj_out.git) //  XXX cannot combine until there is warning not in errors
			
			If ($Obj_out.git.success)
				
				$Obj_out.git:=git (New object:C1471(\
					"action";"add -A";\
					"path";$Obj_in.path))
				
				  //ob_error_combine ($Obj_out;$Obj_out.git) //  XXX cannot combine until there is warning not in errors
				
				$Obj_out.git:=git (New object:C1471(\
					"action";"commit -m initial";\
					"path";$Obj_in.path))
				
				  //ob_error_combine ($Obj_out;$Obj_out.git) //  XXX cannot combine until there is warning not in errors
				
			End if 
		End if 
		  //}
		
		$Obj_out.tags:=$Obj_tags
		
		$Obj_out.success:=Not:C34(ob_error_has ($Obj_out))  // XXX do it only at end (and remove this code, but must be tested)
		
		If (Not:C34($Obj_out.success))
			
			POST_FORM_MESSAGE (New object:C1471(\
				"type";"alert";\
				"target";$Obj_in.caller;\
				"additional";ob_error_string ($Obj_out)))
			
		End if 
		
		  // End creation process
		
	Else 
		
		$Obj_out.success:=False:C215
		
		  // Failed to unzip sdk
		POST_FORM_MESSAGE (New object:C1471(\
			"type";"alert";\
			"target";$Obj_in.caller;\
			"additional";".Failed to unzip sdk"))  //#MARK_LOCALIZE
		
		If ($Boo_verbose)
			
			CALL FORM:C1391($Obj_in.caller;"LOG_EVENT";New object:C1471(\
				"message";"Failed to unzip sdk";\
				"importance";Error message:K38:3))
			
		End if 
	End if 
	
	DELAY PROCESS:C323(Current process:C322;60*2)
	
End if 

  // ----------------------------------------------------
  // BUILD OR ARCHIVE & LAUNCH
  // ----------------------------------------------------

If ($Obj_out.success)
	
	If (Bool:C1537($Obj_in.build))
		
		If (Bool:C1537($Obj_in.archive))
			
			  // Archive
			POST_FORM_MESSAGE (New object:C1471(\
				"target";$Obj_in.caller;\
				"additional";"projectArchive"))
			
			If ($Boo_verbose)
				
				CALL FORM:C1391($Obj_in.caller;"LOG_EVENT";New object:C1471(\
					"message";"Archiving project";\
					"importance";Information message:K38:1))
				
			End if 
			
			$Obj_result_build:=Xcode (New object:C1471(\
				"action";"build";\
				"scheme";$Obj_project.$project.product;\
				"destination";$Obj_in.path;\
				"sdk";"iphoneos";\
				"verbose";$Boo_dev;\
				"configuration";"Release";\
				"archive";True:C214;\
				"allowProvisioningUpdates";True:C214;\
				"allowProvisioningDeviceRegistration";True:C214;\
				"archivePath";Convert path system to POSIX:C1106($Obj_in.path+"archive"+Folder separator:K24:12+$Obj_project.$project.product+".xcarchive")))
			
			$Obj_cache.file("lastArchive.xlog").setText(String:C10($Obj_result_build.out))
			
			ob_error_combine ($Obj_out;$Obj_result_build)
			
			If ($Obj_result_build.success)
				
				  // And export
				POST_FORM_MESSAGE (New object:C1471(\
					"target";$Obj_in.caller;\
					"additional";"projectArchiveExport"))
				
				If ($Boo_verbose)
					
					CALL FORM:C1391($Obj_in.caller;"LOG_EVENT";New object:C1471(\
						"message";"Exporting project archive";\
						"importance";Information message:K38:1))
					
				End if 
				
				$Obj_result_build:=Xcode (New object:C1471(\
					"action";"build";\
					"verbose";$Boo_dev;\
					"exportArchive";True:C214;\
					"teamID";String:C10($Obj_in.project.organization.teamId);\
					"exportPath";Convert path system to POSIX:C1106($Obj_in.path+"archive"+Folder separator:K24:12);\
					"archivePath";Convert path system to POSIX:C1106($Obj_in.path+"archive"+Folder separator:K24:12+$Obj_project.$project.product+".xcarchive")))
				
				$File_:=_o_env_userPath ("cache")+"lastExportArchive.xlog"
				TEXT TO DOCUMENT:C1237($File_;String:C10($Obj_result_build.out))
				
				ob_error_combine ($Obj_out;$Obj_result_build)
				
			Else 
				
				  // Failed to archive
				POST_FORM_MESSAGE (New object:C1471(\
					"type";"alert";\
					"target";$Obj_in.caller;\
					"additional";".Failed to archive"))  //#MARK_LOCALIZE
				
			End if 
			
		Else 
			
			  // Build application
			POST_FORM_MESSAGE (New object:C1471(\
				"target";$Obj_in.caller;\
				"additional";"projectBuild"))
			
			If ($Boo_verbose)
				
				CALL FORM:C1391($Obj_in.caller;"LOG_EVENT";New object:C1471(\
					"message";"Building project";\
					"importance";Information message:K38:1))
				
			End if 
			
			$Obj_result_build:=Xcode (New object:C1471(\
				"action";"build";\
				"scheme";$Obj_project.$project.product;\
				"destination";$Obj_in.path;\
				"sdk";$Obj_in.sdk;\
				"verbose";$Boo_dev;\
				"test";Bool:C1537($Obj_in.test);\
				"target";Convert path system to POSIX:C1106($Obj_in.path+"build"+Folder separator:K24:12)))
			
			ob_error_combine ($Obj_out;$Obj_result_build)
			
			$Obj_cache.file("lastBuild.xlog").setText(String:C10($Obj_result_build.out))
			
			  // Some times Xcode method failed to get app path, maybe if already builded and nothing to do???
			If ($Obj_result_build.app=Null:C1517)
				
				$File_:=$Obj_in.path+Convert path POSIX to system:C1107("build/Build/Products/Debug-iphonesimulator/")+$Obj_project.$project.product+".app"
				
				If (Test path name:C476($File_)=Is a folder:K24:2)
					
					$Obj_result_build.app:=Convert path system to POSIX:C1106($File_)
					
				End if 
			End if 
			
		End if 
		
		If ($Obj_result_build.success)
			
		Else 
			
			POST_FORM_MESSAGE (New object:C1471(\
				"type";"alert";\
				"target";$Obj_in.caller;\
				"additional";String:C10($Obj_result_build.error)))
			
			If ($Boo_verbose)
				
				CALL FORM:C1391($Obj_in.caller;"LOG_EVENT";New object:C1471(\
					"message";"Build Failed ("+$Obj_result_build.error+")";\
					"importance";Error message:K38:3))
				
			End if 
		End if 
		
	Else 
		
		If ($Boo_verbose)
			
			CALL FORM:C1391($Obj_in.caller;"LOG_EVENT";New object:C1471(\
				"message";"Compute data without building";\
				"importance";Information message:K38:1))
			
		End if 
		
		  // Compute data without building
		$Obj_result_build:=New object:C1471
		
		$File_:=$Obj_in.path+Convert path POSIX to system:C1107("build/Build/Products/Debug-iphonesimulator/")+$Obj_project.$project.product+".app"
		
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
	$Obj_cache.file($Obj_project.$project.product).setText(doc_folderDigest ($Obj_in.path+"Sources"+Folder separator:K24:12))
	
	Case of 
			
			  //______________________________________________________
		: (Bool:C1537($Obj_in.run))
			
			$Obj_in.product:=$Obj_out.build.app
			
			POST_FORM_MESSAGE (New object:C1471(\
				"target";$Obj_in.caller;\
				"additional";"launchingTheSimulator"))
			
			If ($Boo_verbose)
				
				CALL FORM:C1391($Obj_in.caller;"LOG_EVENT";New object:C1471(\
					"message";"Launching the Simulator";\
					"importance";Information message:K38:1))
				
			End if 
			
			If (simulator (New object:C1471(\
				"action";"open";\
				"editorToFront";Bool:C1537($Obj_in.testing);\
				"bringToFront";Not:C34(Bool:C1537($Obj_in.testing)))).success)
				
				  // Wait for a booted simulator
				$Lon_start:=Milliseconds:C459
				
				Repeat 
					
					IDLE:C311
					DELAY PROCESS:C323(Current process:C322;60)
					$Obj_result_device:=simulator (New object:C1471(\
						"action";"devices";\
						"filter";"booted"))
					
					$Obj_out.device:=$Obj_result_device
					
					If ($Obj_result_device.success)
						
						$Boo_OK:=($Obj_result_device.devices.length>0)
						
					End if 
				Until ($Boo_OK)\
					 | (Not:C34($Obj_result_device.success))\
					 | ((Milliseconds:C459-$Lon_start)>commonValues.simulatorTimeout)
				
				If ($Boo_OK)
					
					POST_FORM_MESSAGE (New object:C1471(\
						"target";$Obj_in.caller;\
						"additional";"installingTheApplication"))
					
					If ($Boo_verbose)
						
						CALL FORM:C1391($Obj_in.caller;"LOG_EVENT";New object:C1471(\
							"message";"Uninstall the App";\
							"importance";Information message:K38:1))
						
					End if 
					
					  // Quit app
					$Obj_out.simulator:=simulator (New object:C1471(\
						"action";"terminate";\
						"identifier";$Obj_project.product.bundleIdentifier))
					
					  // Better user impression because the simulator display the installation
					DELAY PROCESS:C323(Current process:C322;10)
					
					  // Uninstall app
					$Obj_out.simulator:=simulator (New object:C1471(\
						"action";"uninstall";\
						"identifier";$Obj_project.product.bundleIdentifier))
					
					If ($Obj_out.simulator.success)
						
						If ($Boo_verbose)
							
							CALL FORM:C1391($Obj_in.caller;"LOG_EVENT";New object:C1471(\
								"message";"Install the App";\
								"importance";Information message:K38:1))
							
						End if 
						
						  // Install app
						$Obj_out.simulator:=simulator (New object:C1471(\
							"action";"install";\
							"identifier";$Obj_in.product))
						
						If (Not:C34($Obj_out.simulator.success))
							
							  // redmine #102346
							If (Value type:C1509($Obj_out.simulator.errors)=Is collection:K8:32)
								
								If (Position:C15("MIInstallerErrorDomain, code=35";String:C10($Obj_out.simulator.errors[0]))>0)
									
									$Obj_out.simulator:=simulator (New object:C1471(\
										"action";"install";\
										"identifier";$Obj_in.product))
									
								End if 
							End if 
						End if 
						
						If ($Obj_out.simulator.success)
							
							POST_FORM_MESSAGE (New object:C1471(\
								"target";$Obj_in.caller;\
								"additional";"launchingTheApplication"))
							
							If ($Boo_verbose)
								
								CALL FORM:C1391($Obj_in.caller;"LOG_EVENT";New object:C1471(\
									"message";"Launching the App";\
									"importance";Information message:K38:1))
								
							End if 
							
							  // Launch app
							$Obj_out.simulator:=simulator (New object:C1471(\
								"action";"launch";\
								"identifier";$Obj_project.product.bundleIdentifier))
							
							If (Not:C34($Obj_out.simulator.success))
								
								  // Failed to launch app
								POST_FORM_MESSAGE (New object:C1471(\
									"type";"alert";\
									"target";$Obj_in.caller;\
									"additional";String:C10($Obj_out.simulator.error)))
								
								If ($Boo_verbose)
									
									CALL FORM:C1391($Obj_in.caller;"LOG_EVENT";New object:C1471(\
										"message";"Failed to launch the App ("+$Obj_out.simulator.error+")";\
										"importance";Error message:K38:3))
									
								End if 
							End if 
							
						Else 
							
							  // Failed to install app
							POST_FORM_MESSAGE (New object:C1471(\
								"type";"alert";\
								"target";$Obj_in.caller;\
								"additional";String:C10($Obj_out.simulator.error)))
							
							If ($Boo_verbose)
								
								CALL FORM:C1391($Obj_in.caller;"LOG_EVENT";New object:C1471(\
									"message";"Failed to install the App ("+$Obj_out.simulator.error+")";\
									"importance";Error message:K38:3))
								
							End if 
						End if 
						
					Else 
						
						  // Failed to uninstall app
						POST_FORM_MESSAGE (New object:C1471(\
							"type";"alert";\
							"target";$Obj_in.caller;\
							"additional";String:C10($Obj_out.simulator.error)))
						
						If ($Boo_verbose)
							
							CALL FORM:C1391($Obj_in.caller;"LOG_EVENT";New object:C1471(\
								"message";"Failed to uninstall the App ("+$Obj_out.simulator.error+")";\
								"importance";Error message:K38:3))
							
						End if 
					End if 
					
				Else 
					
					  // Failed to launch device
					POST_FORM_MESSAGE (New object:C1471(\
						"type";"alert";\
						"target";$Obj_in.caller;\
						"additional";".Failed to launch device"))  //#MARK_LOCALIZE
					
					If ($Boo_verbose)
						
						CALL FORM:C1391($Obj_in.caller;"LOG_EVENT";New object:C1471(\
							"message";"Failed to launch device";\
							"importance";Error message:K38:3))
						
					End if 
				End if 
				
			Else 
				
				  // Failed to open simulator
				POST_FORM_MESSAGE (New object:C1471(\
					"type";"alert";\
					"target";$Obj_in.caller;\
					"additional";".Failed to open Simulator"))  //#MARK_LOCALIZE
				
				If ($Boo_verbose)
					
					CALL FORM:C1391($Obj_in.caller;"LOG_EVENT";New object:C1471(\
						"message";"Failed to open the Simulator";\
						"importance";Error message:K38:3))
					
				End if 
			End if 
			
			  //______________________________________________________
		: (Bool:C1537($Obj_in.archive))
			
			  // Calculate the ipa file pathname
			$File_:=Convert path POSIX to system:C1107($Obj_result_build.archivePath)
			$File_:=Object to path:C1548(New object:C1471(\
				"parentFolder";Path to object:C1547($File_).parentFolder;\
				"name";Path to object:C1547($File_).name;\
				"extension";".ipa"))
			
			If ($Obj_in.manualInstallation)
				
				  // Open xCode devices window
				Xcode (New object:C1471(\
					"action";"showDevicesWindow"))
				
				  // Show archive on disk ?
				POST_FORM_MESSAGE (New object:C1471(\
					"target";$Obj_in.caller;\
					"type";"confirm";\
					"title";"archiveCreationSuccessful";\
					"additional";"wouldYouLikeToRevealInFinder";\
					"okFormula";New formula:C1597(SHOW ON DISK:C922(String:C10($File_)))))
				
			Else 
				
				  // Install the archive on the device
				POST_FORM_MESSAGE (New object:C1471(\
					"target";$Obj_in.caller;\
					"additional";"installingTheApplication"))
				
				$Obj_out.device:=device (New object:C1471(\
					"action";"installApp";\
					"path";$File_))
				
				ob_error_combine ($Obj_out;$Obj_out.device)
				
				If (Not:C34($Obj_out.device.success))
					
					POST_FORM_MESSAGE (New object:C1471(\
						"type";"alert";\
						"target";$Obj_in.caller;\
						"additional";$Obj_out.device.errors.join("\r")))
					
				End if 
			End if 
			
			  //______________________________________________________
	End case 
End if 

POST_FORM_MESSAGE (New object:C1471(\
"target";$Obj_in.caller;\
"action";"hide"))

ob_writeToDocument ($Obj_out;$Obj_cache.file("lastBuild.json").platformPath;True:C214)

$Obj_out.param:=$Obj_in

  // ----------------------------------------------------
If ($Obj_in.caller#Null:C1517)
	
	  // Send result
	CALL FORM:C1391($Obj_in.caller;"EDITOR_CALLBACK";"build";$Obj_out)
	
Else 
	
	  // Return result
	$0:=$Obj_out
	
End if 

  // ----------------------------------------------------
  // End