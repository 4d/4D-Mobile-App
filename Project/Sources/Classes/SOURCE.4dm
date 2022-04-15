Class extends panel

// === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705(Formula:C1597(editor_CALLBACK).source)
	
	This:C1470.context:=Super:C1706.init()
	
	If (OB Is empty:C1297(This:C1470.context))
		
		This:C1470.init()
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
		This:C1470.source:=cs:C1710.DataSource.new()
		
		This:C1470._dataSource:=PROJECT.dataSource
		
		This:C1470.dataLink:=Formula:C1597(panel("DATA"))
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get remote() : Boolean
	
	return (This:C1470._dataSource.source="server")
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Design definition
Function init()
	
	This:C1470.toBeInitialized:=False:C215
	
	// Help URL
	This:C1470.help:=Get localized string:C991("help_source")
	
	// Data source radio buttons
	This:C1470.button("local")
	This:C1470.button("server")
	
	This:C1470.button("dataSourceStatus")
	
	This:C1470.dataSourceStatus.data:=New object:C1471(\
		"success"; False:C215)
	
	var $group : cs:C1710.group
	$group:=This:C1470.group("testServer")
	This:C1470.stepper("serverInTest").addToGroup($group)
	This:C1470.formObject("serverInTestLabel").addToGroup($group)
	
	// Option checkboxes
	This:C1470.button("doNotExportImages")
	This:C1470.button("doNotGenerate")
	
	If (Feature.with("androidDataSet"))
		
		$group:=This:C1470.group("_generation")
		This:C1470.button("generate").addToGroup($group)
		This:C1470.formObject("lastGeneration").addToGroup($group)
		
	Else 
		
		This:C1470.button("generate")
		
		$group:=This:C1470.group("dataInGeneration")
		This:C1470.stepper("dataGeneration").addToGroup($group)
		This:C1470.formObject("dataGenerationLabel").addToGroup($group)
		
		This:C1470.group("_generation").addMember(This:C1470.generate)
		This:C1470._generation.addMember($group)
		
	End if 
	
	This:C1470.testServer.isRunning:=False:C215  // A flag to know if the test server is running
	This:C1470.generate.isRunning:=False:C215  // A flag to indicate if a data generation is in progress and prevent re-entry
	
	// === === === === === === === === === === === === === === === === === === === === ==
	/// Events handler
Function handleEvents($e : Object)
	
	If ($e.objectName=Null:C1517)  // <== FORM METHOD
		
		$e:=Super:C1706.handleEvents(On Load:K2:1; On Timer:K2:25)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Load:K2:1)
				
				This:C1470.onLoad()
				
				//______________________________________________________
			: ($e.code=On Timer:K2:25)
				
				This:C1470.update()
				
				//______________________________________________________
		End case 
		
	Else   // <== WIDGETS METHOD
		
		Case of 
				
				//==============================================
			: (This:C1470.local.catch($e; On Clicked:K2:4))
				
				This:C1470._dataSource.source:="local"
				PROJECT.save()
				
				This:C1470.checkingDatasourceConfiguration()
				
				//==============================================
			: (This:C1470.server.catch($e; On Clicked:K2:4))
				
				This:C1470._dataSource.source:="server"
				PROJECT.save()
				
				This:C1470.checkingDatasourceConfiguration()
				
				//==============================================
			: (This:C1470.dataSourceStatus.catch($e; On Clicked:K2:4))
				
				var $data : Object
				
				$data:=This:C1470.dataSourceStatus.data
				
				If ($data.action#Null:C1517)
					
					This:C1470[$data.action]()
					
				End if 
				
				//==============================================
			: (This:C1470.doNotExportImages.catch($e; On Clicked:K2:4))
				
				This:C1470._dataSource.doNotExportImages:=This:C1470.doNotExportImages.getValue()
				PROJECT.save()
				
				This:C1470.update()
				
				//==============================================
			: (This:C1470.doNotGenerate.catch($e; On Clicked:K2:4))
				
				This:C1470._dataSource.doNotGenerateDataAtEachBuild:=This:C1470.doNotGenerate.getValue()
				PROJECT.save()
				
				This:C1470.update()
				
				//==============================================
			: (This:C1470.generate.catch($e; On Clicked:K2:4))
				
				This:C1470.doGenerate()
				
				//==============================================
		End case 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Initializations at loading
Function onLoad()
	
	This:C1470.local.bestSize().setValue(Not:C34(This:C1470.remote))
	This:C1470.server.bestSize().setValue(This:C1470.remote)
	This:C1470.testServer.distributeLeftToRight()
	
	This:C1470.doNotExportImages.bestSize().setValue(This:C1470._dataSource.doNotExportImages)
	This:C1470.doNotGenerate.bestSize().setValue(This:C1470._dataSource.doNotGenerateDataAtEachBuild)
	
	This:C1470._generation.distributeLeftToRight()
	
	If (Feature.with("androidDataSet"))
		
		This:C1470.lastGeneration.hide()
		This:C1470.generate.disable()
		
	Else 
		
		This:C1470.generate.bestSize().disable()
		This:C1470.dataGenerationLabel.setTitle(Replace string:C233(Get localized string:C991("dataSetGeneration"); "\n\n"; "\r"))
		This:C1470.dataInGeneration.distributeLeftToRight()
		
	End if 
	
	This:C1470.checkingDatasourceConfiguration()
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Update of the user interface
Function update()
	
	If (This:C1470.testServer.isRunning)
		
		This:C1470.dataSourceStatus.hide()
		
		This:C1470.serverInTest.start()
		This:C1470.testServer.show()
		
		This:C1470.generate.disable()
		
	Else 
		
		If (This:C1470._dataSource.doNotGenerateDataAtEachBuild)
			
			This:C1470.generate.setHelpTip("clickToGenerateADataset")
			
		Else 
			
			This:C1470.generate.removeHelpTip()
			
		End if 
		
		This:C1470.dataSourceStatus.show()
		
		This:C1470.serverInTest.stop()
		This:C1470.testServer.hide()
		
		var $data : Object
		$data:=This:C1470.dataSourceStatus.data
		
		If ($data.success)  // Data are online
			
			This:C1470.dataSourceStatus.horizontalMargin:=0
			This:C1470.dataSourceStatus.title:=This:C1470.remote ? "serverIsOnline" : "theWebServerIsRunning"
			This:C1470.dataSourceStatus.setPicture("#images/light_on.png")
			
			This:C1470.doNotGenerate.enable()
			This:C1470.generate.enable(This:C1470._dataSource.doNotGenerateDataAtEachBuild)
			
		Else 
			
			This:C1470.dataSourceStatus.horizontalMargin:=50
			This:C1470.dataSourceStatus.title:=$data.title ? $data.title : "theServerIsNotReady"
			This:C1470.dataSourceStatus.setPicture(Num:C11($data.type)=0 ? "#images/light_off.png" : "0")
			
			This:C1470.generate.disable()
			
		End if 
		
		This:C1470.dataSourceStatus.setStyle(Num:C11($data.type))
		This:C1470.dataSourceStatus.setHelpTip(String:C10($data.message))
		This:C1470.dataSourceStatus.bestSize(New object:C1471("maxWidth"; 390))
		
		This:C1470.updateDatasetComment()
		
	End if 
	
	// MARK:-
	// === === === === === === === === === === === === === === === === === === === === ===
Function checkingDatasourceConfiguration()
	
	var $success : Boolean
	var $pos; $len; $port : Integer
	var $keypath; $url : Text
	var $c : Collection
	var $webServer : 4D:C1709.WebServer
	var $file : 4D:C1709.File
	
	$webServer:=WEB Server:C1674(Web server host database:K73:31)
	
	If (This:C1470.remote)
		
		// Check the address of the production server
		$url:=String:C10(PROJECT.server.urls.production)
		
		If (Length:C16($url)>0)
			
			// Check if there is a port conflict with the database web server,
			// in case the server is on the same machine
			$success:=Not:C34($webServer.isRunning)
			
			If (Not:C34($success))
				
				$success:=(Position:C15("127.0.0.1"; $url)=0)\
					 & (Position:C15("localhost"; $url)=0)
				
				If (Not:C34($success))
					
					$c:=Split string:C1554($url; ":")
					$port:=$c.length=2 ? Num:C11($c[1]) : 80  // 80 is the default port
					$success:=($port#$webServer.HTTPPort) & ($port#$webServer.HTTPSPort)
					
				End if 
			End if 
			
			If ($success)
				
				$keypath:=String:C10(This:C1470._dataSource.keyPath)
				
				If (Length:C16($keypath)>0)
					
					//%W-533.1
					If ($keypath[[1]]="/")\
						 && (Position:C15("/Volumes/"; $keypath; *)=0)\
						 && (Position:C15("/Users/"; $keypath; *)=0)
						
						// Relative path
						$file:=Folder:C1567(Folder:C1567(fk database folder:K87:14; *).platformPath; fk platform path:K87:2)\
							.file(Substring:C12($keypath; 2))
						
					Else 
						
						$file:=File:C1566($keypath)
						
					End if 
					//%W+533.1
					
					If ($file.exists)
						
						If (Not:C34(This:C1470.testServer.isRunning))  // Test server
							
							This:C1470.testServer.isRunning:=True:C214
							
							This:C1470.callWorker(Formula:C1597(Rest).source; New object:C1471(\
								"caller"; EDITOR.window; \
								"action"; "status"; \
								"handler"; "mobileapp"; \
								"timeout"; 60; \
								"url"; $url; \
								"headers"; New object:C1471("X-MobileApp"; "1"; \
								"Authorization"; "Bearer "+$file.getText())))
							
						End if 
						
					Else 
						
						// Generate the key
						var $o : Object
						$o:=Rest(New object:C1471(\
							"action"; "request"; \
							"handler"; "mobileapp"; \
							"url"; $url))
						
						This:C1470.dataSourceStatus.data:=New object:C1471(\
							"success"; False:C215; \
							"title"; "locateTheKey"; \
							"message"; Get localized string:C991("theKeyFileIsNotAvailable")+"\r"+Get localized string:C991("clickHereToFindTheKeyFile"); \
							"action"; "localizeKeyFile"; \
							"type"; 9)
						
					End if 
					
				Else 
					
					This:C1470.callWorker(Formula:C1597(Rest).source; New object:C1471(\
						"caller"; EDITOR.window; \
						"action"; "status"; \
						"handler"; "mobileapp"; \
						"timeout"; 60; \
						"url"; $url; \
						"headers"; New object:C1471("X-MobileApp"; "1")))
					
					This:C1470.dataSourceStatus.data:=New object:C1471(\
						"success"; False:C215; \
						"title"; "theServerIsNotReady"; \
						"message"; "checkThatThe4dServerIsStartedAndThatTheWebServerIsRunning"; \
						"type"; 0)
					
				End if 
				
			Else 
				
				This:C1470.dataSourceStatus.data:=New object:C1471(\
					"success"; False:C215; \
					"title"; "theServerIsNotReady"; \
					"message"; "theLocalWebServerIsStarted"; \
					"type"; 0)
				
				EDITOR.postMessage(New object:C1471(\
					"action"; "show"; \
					"type"; "confirm"; \
					"title"; EDITOR.alert+" "+Get localized string:C991("theLocalWebServerIsStarted"); \
					"additional"; "youNeedToShutDownTheLocalWebServer"; \
					"okAction"; "stopWebServer"; \
					"ok"; "stopTheLocalServer"))
				
			End if 
			
		Else 
			
			This:C1470.dataSourceStatus.data:=New object:C1471(\
				"success"; False:C215; \
				"title"; "setTheServerUrl"; \
				"message"; Get localized string:C991("theProductionUrlIsNotPopulated")+"\r"+Get localized string:C991("clickToFillItIn"); \
				"action"; "goToProductionURL"; \
				"type"; 9)
			
		End if 
		
	Else 
		
		If ($webServer.isRunning)
			
			This:C1470.dataSourceStatus.data:=New object:C1471(\
				"success"; True:C214)
			
		Else 
			
			This:C1470.dataSourceStatus.data:=New object:C1471(\
				"success"; False:C215; \
				"title"; "startWebServer"; \
				"message"; Get localized string:C991("theWebServerIsNotStarted")+"\r"+Get localized string:C991("clickToStartIt"); \
				"action"; "startWebServer"; \
				"type"; 9)
			
		End if 
	End if 
	
	This:C1470.update()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function checkingServerResponse($data : Object)
	
	var $t : Text
	var $result : Object
	
	This:C1470.testServer.isRunning:=False:C215
	
	If (This:C1470.remote)
		
		$result:=$data.response ? $data.response : $data
		
		If ($data.success)\
			 && (Bool:C1537($data.response.ok))
			
			$result.type:=0
			$result.success:=True:C214
			
		Else 
			
			If ($result.errors#Null:C1517)
				
				$t:=Value type:C1509($result.errors[0])=Is object:K8:27 ? String:C10($result.errors[0].message) : String:C10($result.errors[0])
				
			Else 
				
				$t:=Value type:C1509($result.__ERRORS[0])=Is object:K8:27 ? String:C10($result.__ERRORS[0].message) : String:C10($result.__ERRORS[0])
				
			End if 
			
			If ($t="The request is unauthorized")\
				 || ($t="This request is forbidden")
				
				$result.title:=Get localized string:C991("locateTheKey")
				$result.type:=9
				$result.action:="localizeKeyFile"
				
			Else 
				
				$result.title:=Get localized string:C991("theServerIsNotReady")
				$result.type:=0
				
			End if 
			
			If ($result.__ERRORS#Null:C1517)
				
				// Oops - Keep the first error message for the tips
				$result.title:=Localize_server_response($t)
				
			Else 
				
				If ($result.response=Null:C1517)\
					 & (Num:C11($result.code)=0)
					
					$result.code:=30  // Default is not reachable
					
				End if 
				
				// Use error code
				$result.title:=Localize_server_response(Num:C11($result.code))
				
			End if 
		End if 
		
		This:C1470.dataSourceStatus.data:=$result
		
		This:C1470.update()
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function goToProductionURL()
	
	This:C1470.callMeBack("goToPage"; New object:C1471(\
		"page"; "deployment"; \
		"panel"; "SERVER"; \
		"object"; "02_prodURL"))
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function startWebServer()
	
	var $status : Object
	var $webServer : 4D:C1709.WebServer
	var $error : cs:C1710.error
	
	$webServer:=WEB Server:C1674(Web server host database:K73:31)
	
	If ($webServer.isRunning)
		
		// Already started
		$status:=New object:C1471(\
			"success"; True:C214)
		
	Else 
		
		$error:=cs:C1710.error.new("capture")
		$status:=$webServer.start()
		$error.release()
		
	End if 
	
	If ($status.success)
		
		This:C1470.checkingDatasourceConfiguration()
		
	Else 
		
		EDITOR.postMessage(New object:C1471(\
			"action"; "show"; \
			"type"; "alert"; \
			"title"; "theServerIsNotReady"; \
			"additional"; $status.errors[0].message))
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function stoptWebServer()
	
	WEB Server:C1674(Web server host database:K73:31).stop()
	
	This:C1470.checkingDatasourceConfiguration()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function localizeKeyFile()
	
	var $t : Text
	
	$t:=Select document:C905(Get 4D folder:C485(MobileApps folder:K5:47; *); SHARED.keyExtension; Get localized string:C991("selectTheKeyFile"); Use sheet window:K24:11+Package open:K24:8)
	
	If (Bool:C1537(OK))
		
		This:C1470._dataSource.keyPath:=cs:C1710.doc.new(DOCUMENT).relativePath
		PROJECT.save()
		
		This:C1470.checkingDatasourceConfiguration()
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function doGenerate()
	
	var $keyPathname : Text
	
	If (Not:C34(This:C1470.generate.isRunning))
		
		This:C1470.generate.isRunning:=True:C214
		
		Logger.info("🏁  START DATA GENERATION")
		
		If (This:C1470.remote)
			
			// ***************************************************************
			// #RUSTINE: ne devrait plus être nécessaire
			If (Test path name:C476($keyPathname)#Is a document:K24:1)
				
				LOG_EVENT(New object:C1471(\
					"message"; String:C10(Form:C1466.dataSource.keyPath)+" ->"+$keyPathname))
				
				$keyPathname:=Convert path POSIX to system:C1107(Form:C1466.dataSource.keyPath)
				
			End if 
			// ***************************************************************
			
		Else 
			
			// Default location
			$keyPathname:=EDITOR.path.key().platformPath
			
		End if 
		
		EDITOR.doGenerate($keyPathname)
		
	Else 
		
		// Data generation is already underway
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function endOfDatasetGeneration($data : Object)
	
	Logger.info("SOURCE endOfDatasetGeneration()")
	
	This:C1470.generate.isRunning:=False:C215
	
	If ($data.data#Null:C1517)
		
		If ($data.data.success)
			
			// Update the data panel
			This:C1470.dataLink.call().update()
			
		Else 
			
			If ($data.data.errors#Null:C1517)
				
				EDITOR.postMessage(New object:C1471(\
					"action"; "show"; \
					"type"; "alert"; \
					"additional"; $data.data.errors.join("\n")))
				
			End if 
		End if 
		
	Else 
		
		Logger.error("SOURCE endOfDatasetGeneration: Null data received")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function updateDatasetComment()
	
	var $file : 4D:C1709.File
	var $data : cs:C1710.DATA
	
	This:C1470.lastGeneration.hide()
	
	If (Not:C34(This:C1470.testServer.isRunning))
		
		$data:=This:C1470.dataLink.call()
		
		If ($data=Null:C1517)
			
			Logger.warning("SOURCE updateDatasetComment() delayed")
			
		Else 
			
			Logger.info("SOURCE updateDatasetComment()")
			
			If (This:C1470._dataSource.doNotGenerateDataAtEachBuild)
				
				If ($data.embeddedDataCount()=0)
					
					This:C1470.doNotGenerate.disable()
					This:C1470.generate.disable()
					This:C1470.lastGeneration.hide()
					
				Else 
					
					Case of 
							
							//______________________________________________________
						: ($data.tables.query("dumpSize = :1"; "#NA").length=$data.tables.length)\
							 | ($data.tables.query("dumpSize = :1"; "#NA / #NA").length=$data.tables.length)
							
							This:C1470.lastGeneration.title:="dataMustBeGenerated"
							This:C1470.lastGeneration.foregroundColor:=EDITOR.errorColor
							
							//______________________________________________________
						: ($data.tables.query("dumpSize = :1"; "#NA").length>0)
							
							This:C1470.lastGeneration.title:="dataMustBeRegeneratedTheStructureHasBeenModified"
							This:C1470.lastGeneration.foregroundColor:=EDITOR.warningColor
							
							//______________________________________________________
						: ($data.tables.query("dumpSize = :1"; "#NA / #NA").length>0)
							
							This:C1470.lastGeneration.title:="dataMustBeRegeneratedTheStructureHasBeenModified"
							This:C1470.lastGeneration.foregroundColor:=EDITOR.warningColor
							
							//______________________________________________________
						: ($data.tables.query("dumpSize = :1"; "@/ #NA").length>0)
							
							This:C1470.lastGeneration.title:=EDITOR.str.localize("dataMustBeRegeneratedBuiltInDataForTargetIsMissing"; "Android")
							This:C1470.lastGeneration.foregroundColor:=EDITOR.warningColor
							
							//______________________________________________________
						: ($data.tables.query("dumpSize = :1"; "#NA /@").length>0)
							
							This:C1470.lastGeneration.title:=EDITOR.str.localize("dataMustBeRegeneratedBuiltInDataForTargetIsMissing"; "iOS")
							This:C1470.lastGeneration.foregroundColor:=EDITOR.warningColor
							
							//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
						Else 
							
							$file:=EDITOR.getDBFile()
							
							If ($file.exists)
								
								This:C1470.lastGeneration.title:=EDITOR.str.localize("lastGeneration"; New collection:C1472($file.modificationDate; Time string:C180($file.modificationTime)))
								This:C1470.lastGeneration.foregroundColor:=EDITOR.commentColor
								
							Else 
								
								This:C1470.lastGeneration.title:="dataMustBeGenerated"
								This:C1470.lastGeneration.foregroundColor:=EDITOR.errorColor
								
							End if 
							
							//______________________________________________________
					End case 
					
					This:C1470.lastGeneration.show().bestSize(New object:C1471("maxWidth"; (This:C1470.width-35)-This:C1470.lastGeneration.coordinates.left))
					
				End if 
			End if 
		End if 
	End if 
	