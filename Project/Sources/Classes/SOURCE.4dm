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
		
		This:C1470.serverTesting:=False:C215
		This:C1470.dataGenerating:=False:C215
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get remote() : Boolean
	
	return (PROJECT.dataSource.source="server")
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Design definition
Function init()
	
	This:C1470.toBeInitialized:=False:C215
	
	// Help URL
	This:C1470.help:=Get localized string:C991("help_source")
	
	This:C1470.button("local")
	This:C1470.button("server")
	
	This:C1470.button("server")
	This:C1470.server.data:=New object:C1471("success"; False:C215)
	
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
	
	This:C1470.formObject("lastGeneration")
	
	
	
	
	//=== === === === === === === === === === === === === === === === === === === === ==
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
		
		//Case of 
		
		////==============================================
		//: (this.ios.catch())\
			 | (this.android.catch())
		
		//Case of 
		
		////______________________________________________________
		//: (Is Windows)
		
		//// <NOTHING MORE TO DO>
		
		////______________________________________________________
		//: ($e.code=On Clicked)
		
		//If (Is macOS)\
			 & ($e.objectName=this.android.name)\
			 & Not(Form.$ios)\
			 & Not(Form.$android)
		
		//// Force iOS
		//PROJECT.setTarget(True; "ios")
		
		//Else 
		
		//PROJECT.setTarget(OBJECT Get value($e.objectName); $e.objectName)
		
		//End if 
		
		//// Update UI
		//this.displayTarget()
		//EDITOR.updateRibbon()
		
		////______________________________________________________
		//: ($e.code=On Mouse Enter)
		
		//// Highlights
		//this[$e.objectName].setColors(EDITOR.selectedColor)
		
		////______________________________________________________
		//: ($e.code=On Mouse Leave)
		
		//// Restore
		//this[$e.objectName].setColors(Foreground color)
		
		////______________________________________________________
		//End case 
		
		////________________________________________
		//End case 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Initializations at loading
Function onLoad()
	
	This:C1470.local.bestSize()
	This:C1470.server.bestSize()
	This:C1470.testServer.distributeLeftToRight()
	
	This:C1470.doNotExportImages.bestSize()
	This:C1470.doNotGenerate.bestSize()
	This:C1470.dataInGeneration.distributeLeftToRight()
	
	This:C1470.generate.bestSize().disable()
	
	This:C1470.dataGenerationLabel.setTitle(Replace string:C233(Get localized string:C991("dataSetGeneration"); "\n\n"; "\r"))
	
	This:C1470.local.setValue(Not:C34(This:C1470.remote))
	This:C1470.server.setValue(This:C1470.remote)
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Update of the user interface
Function update()
	
	If (This:C1470.serverTesting)
		
		This:C1470.serverInTest.start()
		This:C1470.testServer.show()
		This:C1470.server.hide()
		This:C1470.generate.disable()
		
	Else 
		
		This:C1470.serverInTest.stop()
		This:C1470.testServer.hide()
		
		If (This:C1470.server.data.success)  // Data are online
			
			This:C1470.server.horizontalMargin:=0
			This:C1470.server.setPicture("#images/light_on.png")\
				.setTitle(This:C1470.remote ? "serverIsOnline" : "theWebServerIsRunning")\
				.removeHelpTip()
			
		Else 
			
			This:C1470.server.horizontalMargin:=50
			This:C1470.server.setPicture("#images/light_off.png")\
				.setHelpTip(String:C10(This:C1470.server.message))
			
			If (Length:C16(This:C1470.server.title)>0)
				
				This:C1470.server.title:="theServerIsNotReady"
				
			End if 
		End if 
		
		If (Bool:C1537(Form:C1466.dataSource.doNotGenerateDataAtEachBuild))
			
			This:C1470.generate.setHelpTip("clickToGenerateADataset")\
				.enable()
			
		Else 
			
			This:C1470.generate.removeHelpTip()\
				.disable()
			
		End if 
	End if 
	
	This:C1470.updateDatasetComment()
	
	//MARK:-TOOLS
	
	// === === === === === === === === === === === === === === === === === === === === ===
	///
Function doGenerate()
	
	var $keyPathname : Text
	
	If (Not:C34(This:C1470.dataGenerating))  // No reentry
		
		This:C1470.dataGenerating:=True:C214
		
		If (This:C1470.remote)
			
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
		
		EDITOR.doGenerate($keyPathname)
		This:C1470.refresh()
		
		
	Else   // A generation is already in works
		
		This:C1470.refresh()
		
	End if 
	
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function testServer()
	
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function updateDatasetComment()
	
	var $data : Object
	$data:=panel("DATA")
	
	If (Bool:C1537(Form:C1466.dataSource.doNotGenerateDataAtEachBuild))
		
		Case of 
				
				//______________________________________________________
			: (PROJECT.allTargets()) && ($data.datasetAndroid#Null:C1517) && ($data.sqlite#Null:C1517)
				
				Case of 
						
						//______________________________________________________
					: ($data.datasetAndroid=Null:C1517) & ($data.sqlite=Null:C1517)
						
						This:C1470.lastGeneration.setTitle(".Need to regenerate the data.")
						
						//______________________________________________________
					: ($data.datasetAndroid=Null:C1517)
						
						This:C1470.lastGeneration.setTitle(".Need to regenerate the data, embedded data for Android is missing.")
						
						//______________________________________________________
					: ($data.sqlite=Null:C1517)
						
						This:C1470.lastGeneration.setTitle(".Need to regenerate the data, embedded data for iOS is missing.")
						
						//______________________________________________________
					Else 
						
						var $file : 4D:C1709.File
						$file:=PROJECT._folder.file("project.dataSet/Resources/Structures.sqlite")
						This:C1470.lastGeneration.setTitle(EDITOR.str.localize("lastGeneration"; New collection:C1472(String:C10($file.modificationDate); Time string:C180($file.modificationTime))))
						
						//______________________________________________________
				End case 
				
				//______________________________________________________
			: (PROJECT.android()) && ($data.datasetAndroid#Null:C1517) & False:C215
				
				$file:=PROJECT._folder.file("project.dataSet/android/static.db")
				This:C1470.lastGeneration.setTitle(EDITOR.str.localize("lastGeneration"; New collection:C1472(String:C10($file.modificationDate); Time string:C180($file.modificationTime))))
				
				//______________________________________________________
			: (PROJECT.iOS()) && ($data.sqlite#Null:C1517) & False:C215
				
				$file:=PROJECT._folder.file("project.dataSet/Resources/Structures.sqlite")
				This:C1470.lastGeneration.setTitle(EDITOR.str.localize("lastGeneration"; New collection:C1472(String:C10($file.modificationDate); Time string:C180($file.modificationTime))))
				
				//______________________________________________________
			Else 
				
				This:C1470.lastGeneration.setTitle(".Need to regenerate the data, the structure has changed.")
				
				//______________________________________________________
		End case 
		
		This:C1470.lastGeneration.show()
		
	Else 
		
		This:C1470.lastGeneration.hide()
		
	End if 
	
	
	
	
	
	
	