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
#DECLARE($data : Object)

If (False:C215)
	C_OBJECT:C1216(project_BUILD; $1)
End if 

var $tableID; $target; $tt : Text
var $b; $success : Boolean
var $manual; $message; $messageCancel; $messageOK; $o; $project : Object
var $rest : Object
var $folders; $publishedTableNames : Collection
var $file : 4D:C1709.File
var $folder : 4D:C1709.Folder
var $adb : cs:C1710.adb
var $catalog : cs:C1710.catalog
var $cfgutil : cs:C1710.cfgutil

ASSERT:C1129($data#Null:C1517; "Missing paramater")

ob_MERGE($data; project_Defaults)

$project:=$data.project

// ----------------------------------------------------
If (Asserted:C1132($project#Null:C1517))
	
	If (project_Check_param($data).success)
		
		$project.organization.identifier:=$project.organization.id+"."+cs:C1710.str.new($project.product.name).uperCamelCase()
		$project.product.bundleIdentifier:=PROJECT.formatBundleAppName($project.organization.id+"."+$project.product.name)
		$data.appFolder:=UI.path.products().folder($project.product.name)
		
		$data.realDevice:=(String:C10($project._device.type)="device")
		
		$target:=$project._buildTarget || $data.target/*_buildTarget is constantly resty because in project... better to have it from caller*/
		
		If ($data.path=Null:C1517)
			
			If ($data.appFolder.exists)
				
				//mark:ASCENDING_COMPATIBILITY
				$folders:=$data.appFolder.folders()
				
				If ($folders.query("name=iOS").pop()#Null:C1517)\
					 | ($folders.query("name=Android").pop()#Null:C1517)
					
					// <NOTHING MORE TO DO>
					
				Else 
					
					$folder:=$data.appFolder.moveTo(Folder:C1567(Temporary folder:C486; fk platform path:K87:2); Generate UUID:C1066)
					$data.appFolder.create()
					
					If ($folder.folder(".gradle").exists)
						
						// Move to Android subfolder
						$success:=$folder.moveTo($data.appFolder; "Android").exists
						
					Else 
						
						// Move to iOS subfolder
						$success:=$folder.moveTo($data.appFolder; "iOS").exists
						
					End if 
				End if 
			End if 
			
			// According to the target
			$data.appFolder:=$data.appFolder.folder($target="iOS" ? "iOS" : "Android")
			$data.path:=$data.appFolder.platformPath
			
		Else 
			
			Folder:C1567($data.path; fk platform path:K87:2).create()
			
		End if 
		
		$success:=Not:C34($data.create)
		
		If (Not:C34($success))
			
			If ($target="iOS")
				
				If ($data.appFolder.folder("Sources").exists)
					
					// Check if the project was modified by another application
					// Compare to the signature of the sources folder
					$file:=UI.path.userCache().file($project._name)
					
					If ($file.exists)
						
						// mark:ASCENDING_COMPATIBILITY
						$file:=$file.rename($project._name+".ios.fingerprint")
						
					Else 
						
						$file:=UI.path.userCache().file($project._name+".ios.fingerprint")
						
					End if 
					
					$success:=Not:C34($file.exists)
					
					If (Not:C34($success))
						
						$success:=(cs:C1710.tools.new().folderDigest($data.appFolder.folder("Sources"))=$file.getText())
						
					End if 
					
				Else 
					
					$success:=True:C214
					
				End if 
				
			Else 
				
				$file:=UI.path.userCache().file($project._name+".android.fingerprint")
				
				//todo:?
				$success:=True:C214
				
			End if 
		End if 
		
		If ($success)
			
			// Must also close and delete folders if no change and want to recreate.
			// Xcode (New object(\"path";$Obj_in.path))
			
		Else 
			
			Logger.info("⚠️"+Current method name:C684+" productFolderAlreadyExist")
			
			// mark: Product folder already exist. user MUST CONFIRM
			$message:=New object:C1471(\
				"action"; "show"; \
				"type"; "confirm"; \
				"title"; "theProductFolderAlreadyExist"; \
				"additional"; "allContentWillBeReplaced"; \
				"CALLBACK"; Formula:C1597(editor_MESSAGE_CALLBACK).source; \
				"build"; $data)
			
			$message:=await_MESSAGE($message; "productFolderAlreadyExist")
			
		End if 
		
		If ($success)
			
			// MARK:-VERIFY THE STRUCTURE
			$publishedTableNames:=New collection:C1472
			
			For each ($tableID; $project.dataModel)
				
				$publishedTableNames.push($project.dataModel[$tableID][""].name)
				
				For each ($tt; $project.dataModel[$tableID])
					
					If (Length:C16($tt)=0)
						
						continue
						
					End if 
					
					If ($project.dataModel[$tableID][$tt].relatedDataClass#Null:C1517)
						
						$publishedTableNames.push($project.dataModel[$tableID][$tt].relatedDataClass)
						
					End if 
				End for each 
			End for each 
			
			If ($project.dataSource.source="local")
				
				$catalog:=cs:C1710.catalog.new()
				
				$success:=$catalog.verifyStructureAdjustments($publishedTableNames)
				
				If (Not:C34($success))
					
					$success:=(Bool:C1537($project.allowStructureAdjustments))\
						 | (Bool:C1537($project.$_allowStructureAdjustments))
					
					If ($success)
						
						$success:=$catalog.doStructureAdjustments($publishedTableNames)
						
						If (Not:C34($success))
							
							//TODO:DISPLAY ERROR
							
						End if 
						
					Else 
						
						Logger.info("⚠️"+Current method name:C684+" someStructuralAdjustmentsAreNeeded")
						
						$message:=New object:C1471(\
							"action"; "show"; \
							"type"; "confirm"; \
							"title"; "someStructuralAdjustmentsAreNeeded"; \
							"additional"; cs:C1710.tools.new().localized("doYouAllow4dToModifyStructure"); \
							"ok"; "allow"; \
							"option"; New object:C1471("title"; "rememberMyChoice"; "value"; False:C215); \
							"CALLBACK"; Formula:C1597(editor_MESSAGE_CALLBACK).source)
						
						$message:=await_MESSAGE($message; "someStructuralAdjustmentsAreNeeded")
						
					End if 
				End if 
				
				If ($success)
					
					// Local web server is mandatory only if data are embedded
					For each ($tableID; $project.dataModel) Until ($b)
						
						$b:=Bool:C1537($project.dataModel[$tableID][""].embedded)
						
					End for each 
					
					$success:=Not:C34($b)
					
					If (Not:C34($success))
						
						$success:=WEB Is server running:C1313 | Bool:C1537($data.ignoreServer)
						
						If (Not:C34($success))
							
							Logger.info("⚠️"+Current method name:C684+" theWebServerIsNotStarted")
							
							$messageOK:=New object:C1471(\
								"action"; "build_startWebServer"; \
								"build"; $data)
							
							//$messageCancel:=New object(\
																"action"; "build_ignoreServer"; \
																"build"; $data)
							
							// Web server must running to test data synchronization
							$message:=New object:C1471(\
								"action"; "show"; \
								"type"; "confirm"; \
								"title"; "theWebServerIsNotStarted"; \
								"additional"; "DoYouWantToStartTheWebServer"; \
								"cancel"; "notNow"; \
								"CALLBACK"; Formula:C1597(editor_MESSAGE_CALLBACK).source; \
								"build"; $data)
							
							$message:=await_MESSAGE($message; "theWebServerIsNotStarted")
							
						End if 
					End if 
				End if 
				
			Else 
				
				// Check server-database structure, if any
				$rest:=Rest(New object:C1471(\
					"action"; "tables"; \
					"handler"; "mobileapp"; \
					"url"; String:C10($project.server.urls.production); \
					"headers"; New object:C1471(\
					"X-MobileApp"; "1"; \
					"Authorization"; "Bearer "+cs:C1710.path.new().key().getText())))
				
				$success:=$rest.success
				
				If ($success)
					
					$rest:=$rest.response
					
					$success:=$rest.dataClasses.query("name = :1"; SHARED.deletedRecordsTable.name).pop()#Null:C1517
					
					If ($success) && ($folders#Null:C1517)
						
						For each ($folder; $folders) While ($success)
							
							$o:=$rest.dataClasses.query("name = :1"; $folder.name).pop()
							$success:=$o#Null:C1517
							
							If ($success)
								
								$success:=$o.attributes.query("name = :1"; SHARED.stampField.name).pop()#Null:C1517
								
							End if 
						End for each 
					End if 
					
					If (Not:C34($success))
						
						// SERVER STRUCTURE IS NOT OK. Confirm if data embed, Alert else
						For each ($tableID; $project.dataModel) Until ($b)
							
							$b:=Not:C34(Bool:C1537($project.dataModel[$tableID][""].embedded))
							
						End for each 
						
						$success:=Not:C34($b)
						
						If (Not:C34($success))
							
							$success:=(Bool:C1537($project.$_ignoreServerStructureAdjustement))
							OB REMOVE:C1226($project; "$_ignoreServerStructureAdjustement")
							
						End if 
						
						If (Not:C34($success))
							
							UI.postMessage(New object:C1471(\
								"action"; "show"; \
								"type"; "confirm"; \
								"title"; "theStructureOfTheProductionServerIsNotOptimizedForThisProject"; \
								"additional"; "youMustUpdateTheStructureOfTheProductionServer"; \
								"help"; Formula:C1597(OPEN URL:C673(Get localized string:C991("doc_structureAdjustment"); *)); \
								"cancelFormula"; Formula:C1597(CALL FORM:C1391(UI.window; Formula:C1597(editor_CALLBACK).source; "build_stop")); \
								"ok"; "continue"; \
								"okFormula"; Formula:C1597(CALL FORM:C1391(UI.window; Formula:C1597(editor_CALLBACK).source; "ignoreServerStructureAdjustement"))\
								))
							
						End if 
					End if 
					
				Else 
					
					// SERVER NOT REACHABLE - Ignore if no data embed, Confirm else
					For each ($tableID; $project.dataModel) Until ($b)
						
						$b:=Not:C34(Bool:C1537($project.dataModel[$tableID][""].embedded))
						
					End for each 
					
					$success:=Not:C34($b)
					
					If (Not:C34($success))
						
						UI.postMessage(New object:C1471(\
							"action"; "show"; \
							"type"; "alert"; \
							"title"; "theProductionServerIsNotAvailable"; \
							"additional"; Localize_server_response($rest.httpError)\
							))
						
					End if 
				End if 
			End if 
		End if 
		
		If ($success)
			
			If (Bool:C1537($data.archive))\
				 | $data.realDevice
				
				Case of 
						
						//______________________________________________________
					: (Bool:C1537($data.manualInstallation))
						
						$success:=True:C214
						
						//______________________________________________________
					: ($target="iOS")
						
						$cfgutil:=cs:C1710.cfgutil.new()
						
						If (Not:C34(Bool:C1537($data.configurator)))
							
							// Verify that Apple Configurator 2 application is installed
							$data.configurator:=$cfgutil.success
							
						End if 
						
						$success:=Bool:C1537($data.configurator)
						
						If ($success)
							
							// Verify that at least one device is plugged
							$success:=($cfgutil.plugged(True:C214).length>0)
							
							If (Not:C34($success))
								
								$data:=cs:C1710.project.new($data).cleaned()
								$manual:=OB Copy:C1225($data)
								$manual.manualInstallation:=True:C214
								
								UI.postMessage(New object:C1471(\
									"action"; "show"; \
									"type"; "confirm"; \
									"title"; "noDeviceFound"; \
									"additional"; "makeSureThatADeviceIsConnected"; \
									"ok"; "continue"; \
									"okFormula"; Formula:C1597(UI.callMe(Formula:C1597(BUILD).source; $data)); \
									"cancel"; "manualInstallation"; \
									"cancelFormula"; Formula:C1597(UI.callMe(Formula:C1597(BUILD).source; $manual))\
									))
								
							End if 
							
						Else 
							
							$data:=cs:C1710.project.new($data).cleaned()
							
							// Ask for installation
							$messageOK:=New object:C1471(\
								"action"; "build_waitingForConfigurator"; \
								"build"; $data)
							
							$messageCancel:=New object:C1471(\
								"action"; "build_manualInstallation"; \
								"build"; $data)
							
							UI.postMessage(New object:C1471(\
								"action"; "show"; \
								"type"; "confirm"; \
								"title"; New collection:C1472("appIsNotInstalled"; $cfgutil.appName); \
								"additional"; New collection:C1472("wouldYouLikeToInstallNow"; $cfgutil.appName); \
								"okAction"; JSON Stringify:C1217($messageOK); \
								"cancel"; "manualInstallation"; \
								"cancelAction"; JSON Stringify:C1217($messageCancel)\
								))
							
						End if 
						
						//______________________________________________________
					: ($target="android")
						
						$adb:=cs:C1710.adb.new()
						
						// Verify that the device is plugged
						$success:=$adb.isDeviceConnected($project._device.udid)
						
						If (Not:C34($success))
							
							$data:=cs:C1710.project.new($data).cleaned()
							$manual:=OB Copy:C1225($data)
							$manual.manualInstallation:=True:C214
							
							UI.postMessage(New object:C1471(\
								"action"; "show"; \
								"type"; "confirm"; \
								"title"; "noDeviceFound"; \
								"additional"; "makeSureThatADeviceIsConnected"; \
								"ok"; "continue"; \
								"okFormula"; Formula:C1597(UI.callMe(Formula:C1597(BUILD).source; $data)); \
								"cancel"; "manualInstallation"; \
								"cancelFormula"; Formula:C1597(UI.callMe(Formula:C1597(BUILD).source; $manual))\
								))
							
						End if 
						
						//______________________________________________________
				End case 
			End if 
		End if 
		
		If ($success)
			
			Logger.info(Current method name:C684+": CALL WORKER(mobile_Project)")
			
			If (Feature.with("buildWith4DAction"))
				mobile_Project_web_post($data)
			Else 
				CALL WORKER:C1389(UI.worker; Formula:C1597(mobile_Project).source; $data)
			End if 
			
		End if 
		
	Else 
		
		Logger.error("❌"+Current method name:C684+" project_Check_param failed")
		
	End if 
	
	OB REMOVE:C1226(UI; "build")
	
Else 
	
	Logger.error("❌"+Current method name:C684+" Project is empty")
	
End if 