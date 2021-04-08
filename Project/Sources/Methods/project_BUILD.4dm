//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : project_BUILD
// ID[7568C2BF25664764BE3D8F3E0B9EAEB0]
// Created 4-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// common initializations and confirmations
// ----------------------------------------------------
// Declarations
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(project_BUILD; $1)
End if 

var $t; $tt : Text
var $b; $success : Boolean
var $l; $window : Integer
var $o; $Obj_cancel; $Obj_ok; $in; $project : Object
var $c : Collection

var $file : 4D:C1709.File

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	$in:=$1
	
	ob_MERGE($in; project_Defaults)
	
	$project:=$in.project
	$window:=Current form window:C827
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Asserted:C1132($project#Null:C1517))
	
	If (project_Check_param($in).success)
		
		var $path : cs:C1710.path
		$path:=cs:C1710.path.new()
		
		$project.organization.identifier:=$project.organization.id+"."+cs:C1710.str.new($project.product.name).uperCamelCase()
		$project.product.bundleIdentifier:=formatString("bundleApp"; $project.organization.id+"."+$project.product.name)
		
		$in.appFolder:=$path.products().folder($project.product.name)
		
		If ($in.path=Null:C1517)
			
			If (FEATURE.with("android"))
				
				If ($in.appFolder.exists)
					
					//#ASCENDING_COMPATIBILITY
					$c:=$in.appFolder.folders()
					
					If ($c.query("name=iOS").pop()#Null:C1517)\
						 | ($c.query("name=Android").pop()#Null:C1517)
						
						// <NOTHING MORE TO DO>
						
					Else 
						
						$o:=$in.appFolder.moveTo(Folder:C1567(Temporary folder:C486; fk platform path:K87:2); Generate UUID:C1066)
						$in.appFolder.create()
						
						If ($o.folder(".gradle").exists)
							
							// Move to Android subfolder
							$success:=$o.moveTo($in.appFolder; "Android").exists
							
						Else 
							
							// Move to iOS subfolder
							$success:=$o.moveTo($in.appFolder; "iOS").exists
							
						End if 
					End if 
				End if 
				
				// According to the target
				$in.appFolder:=$in.appFolder.folder(Choose:C955($project._buildTarget="iOS"; "iOS"; "Android"))
				
			End if 
			
			$in.path:=$in.appFolder.platformPath
			
		Else 
			
			Folder:C1567($in.path; fk platform path:K87:2).create()
			
		End if 
		
		$success:=Not:C34($in.create)
		
		If (Not:C34($success))
			
			If ($project._buildTarget="iOS")
				
				If ($in.appFolder.folder("Sources").exists)
					
					// Check if the project was modified by another application
					// Compare to the signature of the sources folder
					$file:=$path.userCache().file($project._name)
					
					If (FEATURE.with("android"))
						
						If ($file.exists)
							
							// #ASCENDING_COMPATIBILITY
							$file:=$file.rename($project._name+".ios.fingerprint")
							
						Else 
							
							$file:=$path.userCache().file($project._name+".ios.fingerprint")
							
						End if 
					End if 
					
					If ($file.exists)
						
						$success:=(cs:C1710.tools.new().folderDigest($in.appFolder.folder("Sources"))=$file.getText())
						
					End if 
					
				Else 
					
					$success:=True:C214
					
				End if 
				
			Else 
				
				$file:=$path.userCache().file($project._name+".android.fingerprint")
				
				//#MARK_TODO
				$success:=True:C214
				
			End if 
		End if 
		
		If ($success)
			
			// Must also close and delete folders if no change and want to recreate.
			// Xcode (New object(\"path";$Obj_in.path))
			
		Else 
			
			// Product folder already exist. user MUST CONFIRM
			$o:=New object:C1471(\
				"action"; "show"; \
				"type"; "confirm"; \
				"title"; "theProductFolderAlreadyExist"; \
				"additional"; "allContentWillBeReplaced"; \
				"CALLBACK"; "editor_MESSAGE_CALLBACK"; \
				"build"; $in)
			
			$o:=await_MESSAGE($o; "productFolderAlreadyExist")
			
		End if 
		
		If ($success)
			
			// Verify the structure
			$c:=New collection:C1472
			
			For each ($t; $project.dataModel)
				
				$c.push($project.dataModel[$t][""].name)
				
				For each ($tt; $project.dataModel[$t])
					
					If (Length:C16($tt)>0)
						
						If ($project.dataModel[$t][$tt].relatedDataClass#Null:C1517)
							
							$c.push($project.dataModel[$t][$tt].relatedDataClass)
							
						End if 
					End if 
				End for each 
			End for each 
			
			If ($project.dataSource.source="local")
				
				// Check host-database structure
				If (Not:C34(_o_structure(New object:C1471(\
					"action"; "verify"; \
					"tables"; $c)).success))
					
					$success:=(Bool:C1537($project.allowStructureAdjustments))\
						 | (Bool:C1537($project.$_allowStructureAdjustments))
					
					If ($success)
						
						$success:=_o_structure(New object:C1471(\
							"action"; "create"; \
							"tables"; $c)).success
						
						If (Not:C34($success))
							
							//#MARK_TODO - DISPLAY ERROR
							
						End if 
						
					Else 
						
						$o:=New object:C1471(\
							"action"; "show"; \
							"type"; "confirm"; \
							"title"; "someStructuralAdjustmentsAreNeeded"; \
							"additional"; cs:C1710.tools.new().localized("doYouAllow4dToModifyStructure"); \
							"ok"; "allow"; \
							"option"; New object:C1471("title"; "rememberMyChoice"; "value"; False:C215); \
							"CALLBACK"; "editor_MESSAGE_CALLBACK")
						
						$o:=await_MESSAGE($o; "someStructuralAdjustmentsAreNeeded")
						
					End if 
				End if 
				
				If ($success)
					
					// Local web server is mandatory only if data are embedded
					For each ($t; $project.dataModel) Until ($b)
						
						$b:=Bool:C1537($project.dataModel[$t][""].embedded)
						
					End for each 
					
					$success:=Not:C34($b)
					
					If (Not:C34($success))
						
						$success:=WEB Is server running:C1313 | Bool:C1537($in.ignoreServer)
						
						If (Not:C34($success))
							
							$Obj_ok:=New object:C1471(\
								"action"; "build_startWebServer"; \
								"build"; $in)
							
							$Obj_cancel:=New object:C1471(\
								"action"; "build_ignoreServer"; \
								"build"; $in)
							
							// Web server must running to test data synchronization
							$o:=New object:C1471(\
								"action"; "show"; \
								"type"; "confirm"; \
								"title"; "theWebServerIsNotStarted"; \
								"additional"; "DoYouWantToStartTheWebServer"; \
								"cancel"; "notNow"; \
								"CALLBACK"; "editor_MESSAGE_CALLBACK"; \
								"build"; $in)
							
							$o:=await_MESSAGE($o; "theWebServerIsNotStarted")
							
						End if 
					End if 
				End if 
				
			Else 
				
				// Check server-database structure, if any
				$o:=Rest(New object:C1471(\
					"action"; "tables"; \
					"handler"; "mobileapp"; \
					"url"; String:C10($project.server.urls.production); \
					"headers"; New object:C1471(\
					"X-MobileApp"; "1"; \
					"Authorization"; "Bearer "+COMPONENT_Pathname("key").getText())))
				
				$success:=$o.success
				
				If ($o.success)
					
					$o:=$o.response
					
					$success:=($o.dataClasses.extract("name").indexOf(String:C10(SHARED.deletedRecordsTable.name))#-1)
					
					If ($success)
						
						For each ($t; $c) While ($success)
							
							$l:=$o.dataClasses.extract("name").indexOf($t)
							
							$success:=($l#-1)
							
							If ($success)
								
								$success:=($o.dataClasses[$l].attributes.extract("name").indexOf(String:C10(SHARED.stampField.name))#-1)
								
							End if 
						End for each 
					End if 
					
					If (Not:C34($success))
						
						// SERVER STRUCTURE IS NOT OK. Confirm if data embed, Alert else
						For each ($t; $project.dataModel) Until ($b)
							
							//#ACI0100704
							$b:=Not:C34(Bool:C1537($project.dataModel[$t][""].embedded))
							
						End for each 
						
						$success:=Not:C34($b)
						
						If (Not:C34($success))
							
							$success:=(Bool:C1537($project.$_ignoreServerStructureAdjustement))
							OB REMOVE:C1226($project; "$_ignoreServerStructureAdjustement")
							
						End if 
						
						If (Not:C34($success))
							
							If (True:C214)
								
								POST_MESSAGE(New object:C1471(\
									"target"; $window; \
									"action"; "show"; \
									"type"; "confirm"; \
									"title"; "theStructureOfTheProductionServerIsNotOptimizedForThisProject"; \
									"additional"; "youMustUpdateTheStructureOfTheProductionServer"; \
									"help"; Formula:C1597(OPEN URL:C673(Get localized string:C991("doc_structureAdjustment"); *)); \
									"cancelFormula"; Formula:C1597(CALL FORM:C1391($window; "editor_CALLBACK"; "build_stop")); \
									"ok"; Get localized string:C991("continue"); \
									"okFormula"; Formula:C1597(CALL FORM:C1391($window; "editor_CALLBACK"; "ignoreServerStructureAdjustement"))))
								
							Else 
								
								$o:=New object:C1471(\
									"target"; $window; \
									"action"; "show"; \
									"type"; "confirm"; \
									"title"; "theStructureOfTheProductionServerIsNotOptimizedForThisProject"; \
									"additional"; "youMustUpdateTheStructureOfTheProductionServer"; \
									"help"; Formula:C1597(OPEN URL:C673(Get localized string:C991("doc_structureAdjustment"); *)); \
									"cancelFormula"; Formula:C1597(This:C1470.choice:="cancel"); \
									"ok"; Get localized string:C991("continue"); \
									"okFormula"; Formula:C1597(This:C1470.choice:="ignore"))
								
								WAIT_MESSAGE($o)
								
							End if 
						End if 
					End if 
					
				Else 
					
					// SERVER NOT REACHABLE - Ignore if no data embed, Confirm else
					For each ($t; $project.dataModel) Until ($b)
						
						//#ACI0100704
						$b:=Not:C34(Bool:C1537($project.dataModel[$t][""].embedded))
						
					End for each 
					
					$success:=Not:C34($b)
					
					If (Not:C34($success))
						
						POST_MESSAGE(New object:C1471(\
							"target"; $window; \
							"action"; "show"; \
							"type"; "alert"; \
							"title"; "theProductionServerIsNotAvailable"; \
							"additional"; _o_SERVER_Handler(New object:C1471(\
							"action"; "localization"; \
							"code"; $o.httpError)).message))
						
					End if 
				End if 
			End if 
		End if 
		
		If ($success)
			
			If (Bool:C1537($in.archive))
				
				$success:=Bool:C1537($in.manualInstallation)
				
				If (Not:C34($success))
					
					If (Not:C34(Bool:C1537($in.configurator)))
						
						// Verify that Apple Configurator 2 application is installed
						$in.configurator:=device(New object:C1471("action"; "appPath")).success
						
					End if 
					
					$success:=Bool:C1537($in.configurator)
					
					If ($success)
						
						// Verify that at least one device is plugged
						$success:=device(New object:C1471("action"; "plugged")).success
						
						If (Not:C34($success))
							
							// Ask for a device
							$Obj_ok:=New object:C1471(\
								"action"; "build_deviceOnline"; \
								"build"; $in)
							
							$Obj_cancel:=New object:C1471(\
								"action"; "build_manualInstallation"; \
								"build"; $in)
							
							POST_MESSAGE(New object:C1471(\
								"target"; $window; \
								"action"; "show"; \
								"type"; "confirm"; \
								"title"; Get localized string:C991("noDeviceFound"); \
								"additional"; Get localized string:C991("makeSureThatADeviceIsConnected"); \
								"ok"; Get localized string:C991("continue"); \
								"okAction"; JSON Stringify:C1217($Obj_ok); \
								"cancel"; Get localized string:C991("manualInstallation"); \
								"cancelAction"; JSON Stringify:C1217($Obj_cancel)))
							
						End if 
						
					Else 
						
						// Ask for installation
						$Obj_ok:=New object:C1471(\
							"action"; "build_waitingForConfigurator"; \
							"build"; $in)
						
						$Obj_cancel:=New object:C1471(\
							"action"; "build_manualInstallation"; \
							"build"; $in)
						
						$t:=device(New object:C1471("action"; "appName")).value
						
						POST_MESSAGE(New object:C1471(\
							"target"; $window; \
							"action"; "show"; \
							"type"; "confirm"; \
							"title"; New collection:C1472("appIsNotInstalled"; $t); \
							"additional"; New collection:C1472("wouldYouLikeToInstallNow"; $t); \
							"okAction"; JSON Stringify:C1217($Obj_ok); \
							"cancel"; Get localized string:C991("manualInstallation"); \
							"cancelAction"; JSON Stringify:C1217($Obj_cancel)))
						
					End if 
				End if 
			End if 
		End if 
		
		If ($success)
			
			If ($in.$buildType)
				
				
				
			Else 
				
				// A "If" statement should never omit "Else" 
				
			End if 
			
			
			CALL WORKER:C1389("4D Mobile ("+String:C10($in.caller)+")"; "mobile_Project"; $in)
			
		End if 
	End if 
	
	OB REMOVE:C1226(Form:C1466; "build")
	
End if 

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End