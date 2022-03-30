Class extends form

// === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705(Formula:C1597(editor_CALLBACK).source)
	
	This:C1470.context:=editor_Panel_init(This:C1470.name)
	
	If (OB Is empty:C1297(This:C1470.context))
		
		This:C1470.isSubform:=True:C214
		
		This:C1470.init()
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
		This:C1470.source:=cs:C1710.sources.new()
		
		This:C1470.serverTesting:=False:C215
		This:C1470.dataGenerating:=False:C215
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Design definition
Function init()
	
	This:C1470.toBeInitialized:=False:C215
	
	// Help URL
	This:C1470.help:=Get localized string:C991("help_source")
	
	This:C1470.button("local")
	This:C1470.button("server")
	
	This:C1470.button("serverStatus")
	This:C1470.serverStatus.success:=False:C215
	
	var $group : cs:C1710.group
	$group:=This:C1470.group("testServer")
	This:C1470.stepper("serverInTest").addToGroup($group)
	This:C1470.formObject("serverInTestLabel").addToGroup($group)
	
	This:C1470.button("generate")
	This:C1470.button("doNotExportImages")
	This:C1470.button("doNotGenerate")
	
	$group:=This:C1470.group("dataInGeneration")
	This:C1470.stepper("dataGeneration").addToGroup($group)
	This:C1470.formObject("dataGenerationLabel").addToGroup($group)
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Initializations at loading
Function onLoad()
	
	This:C1470.local.bestSize()
	This:C1470.server.bestSize()
	This:C1470.testServer.distributeLeftToRight()
	
	This:C1470.doNotExportImages.bestSize()
	This:C1470.doNotGenerate.bestSize()
	This:C1470.dataInGeneration.distributeLeftToRight()
	
	This:C1470.generate.disable()
	
	This:C1470.dataGenerationLabel.setTitle(Replace string:C233(Get localized string:C991("dataSetGeneration"); "\n\n"; "\r"))
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Update of the user interface
Function update()
	
	var $remote : Boolean
	$remote:=This:C1470.isRemote()
	
	This:C1470.local.setValue(Not:C34($remote))
	This:C1470.server.setValue($remote)
	
	If (This:C1470.serverTesting)
		
		This:C1470.serverInTest.start()
		This:C1470.testServer.show()
		
		This:C1470.serverStatus.hide()
		
		This:C1470.generate.disable()
		
	Else 
		
		This:C1470.serverInTest.stop()
		This:C1470.testServer.hide()
		
		If (This:C1470.serverStatus.success)  // Data are online
			
			This:C1470.serverStatus.setPicture("#images/light_on.png")\
				.horizontalMargin(0)\
				.setTitle(Choose:C955($remote; "serverIsOnline"; "theWebServerIsRunning"))\
				.removeHelpTip()
			
		Else 
			
			This:C1470.serverStatus.setPicture("#images/light_off.png")\
				.horizontalMargin(50)\
				.setHelpTip(String:C10(This:C1470.serverStatus.message))
			
			If (Length:C16(This:C1470.serverStatus.title())>0)
				
				This:C1470.serverStatus.setTitle("theServerIsNotReady")
				
			End if 
		End if 
		
		If (Bool:C1537(Form:C1466.dataSource.doNotGenerateDataAtEachBuild))
			
			This:C1470.generate.setHelpTip("clickToGenerateADataset")\
				.enable()
			
		Else 
			
			This:C1470.generate.removeHelpTip\
				.disable()
			
		End if 
	End if 
	
	//MARK:-TOOLS
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Returns True if datasource is server
Function isRemote()->$remote : Boolean
	
	$remote:=(String:C10(Form:C1466.dataSource.source)="server")
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Returns True if datasource is server
Function isLocal()->$local : Boolean
	
	$local:=(String:C10(Form:C1466.dataSource.source)="local")
	
	// === === === === === === === === === === === === === === === === === === === === ===
	///
Function doGenerate()
	
	var $keyPathname : Text
	
	If (Not:C34(This:C1470.dataGenerating))  // No reentry
		
		This:C1470.dataGenerating:=True:C214
		
		If (This:C1470.isRemote())
			
			//===============================================================
			//#RUSTINE: ne devrait plus être nécessaire
			If (Test path name:C476($keyPathname)#Is a document:K24:1)
				
				LOG_EVENT(New object:C1471(\
					"message"; String:C10(Form:C1466.dataSource.keyPath)+" ->"+$keyPathname))
				
				$keyPathname:=Convert path POSIX to system:C1107(Form:C1466.dataSource.keyPath)
				
			End if 
			
			//===============================================================
			
		Else 
			
			// Default location
			$keyPathname:=EDITOR.path.key().platformPath
			
		End if 
		
		If (Feature.with("cancelableDatasetGeneration"))
			
			EDITOR.doGenerate($keyPathname)
			This:C1470.refresh()
			
		Else 
			
			CALL WORKER:C1389(EDITOR.worker; "dataSet"; New object:C1471(\
				"caller"; EDITOR.window; \
				"action"; "create"; \
				"eraseIfExists"; True:C214; \
				"project"; PROJECT; \
				"digest"; True:C214; \
				"accordingToTarget"; Feature.with("androidDataSet"); \
				"coreDataSet"; Not:C34(Feature.with("androidDataSet")); \
				"key"; $keyPathname; \
				"dataSet"; True:C214))
			
			SET TIMER:C645(-1)
			
		End if 
		
		
	Else   // A generation is already in works
		
		This:C1470.refresh()
		
	End if 
	
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function testServer()