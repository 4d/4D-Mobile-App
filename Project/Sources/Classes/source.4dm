Class extends form

// === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705("editor_CALLBACK")
	
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
Function init()
	
	This:C1470.toBeInitialized:=False:C215
	
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
	
	var $group : cs:C1710.group
	$group:=This:C1470.group("dataInGeneration")
	This:C1470.stepper("dataGeneration").addToGroup($group)
	This:C1470.formObject("dataGenerationLabel").addToGroup($group)
	
	// === === === === === === === === === === === === === === === === === === === === ===
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
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function isRemote()->$remote : Boolean
	
	$remote:=(String:C10(Form:C1466.dataSource.source)="server")
	
	
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function testServer()