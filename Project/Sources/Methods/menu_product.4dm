//%attributes = {"invisible":true}
var $choice; $pathname : Text
var $o; $folder : Object
var $product : 4D:C1709.Folder

$choice:=Get selected menu item parameter:C1005

PROJECT._buildTarget="ios"

Case of 
		
		//______________________________________________________
	: (Length:C16($choice)=0)
		
		// NOTHING MORE TO DO
		
		//______________________________________________________
	: ($choice="buildAndRun")
		
		UI.runBuild(New object:C1471(\
			"project"; PROJECT; \
			"create"; True:C214; \
			"build"; True:C214; \
			"run"; True:C214; \
			"target"; PROJECT._buildTarget; \
			"verbose"; True:C214))
		
		//______________________________________________________
	: (Position:C15("create"; $choice)=1)
		
		PROJECT._buildTarget:=Substring:C12($choice; Length:C16("create")+1)
		UI.runBuild(New object:C1471(\
			"project"; PROJECT; \
			"create"; True:C214; \
			"build"; False:C215; \
			"run"; False:C215; \
			"target"; PROJECT._buildTarget; \
			"verbose"; True:C214))
		
		//______________________________________________________
	: ($choice="build")
		
		UI.runBuild(New object:C1471(\
			"project"; PROJECT; \
			"create"; False:C215; \
			"build"; True:C214; \
			"run"; True:C214; \
			"target"; PROJECT._buildTarget; \
			"verbose"; True:C214))
		
		//______________________________________________________
	: ($choice="run")
		
		UI.runBuild(New object:C1471(\
			"project"; PROJECT; \
			"create"; False:C215; \
			"build"; False:C215; \
			"run"; True:C214; \
			"target"; PROJECT._buildTarget; \
			"verbose"; True:C214))
		
		//______________________________________________________
	: ($choice="reveal")
		
		SHOW ON DISK:C922(cs:C1710.path.new().products().folder(PROJECT.product.name).platformPath)
		
		//______________________________________________________
	: ($choice="replaceSDK")
		
		$product:=cs:C1710.path.new().products().folder(PROJECT.product.name)
		
		$product.folder("Carthage").delete(Delete with contents:K24:24)
		
		sdk(New object:C1471(\
			"action"; "install"; \
			"file"; cs:C1710.path.new().sdk().platformPath+"ios.zip"; \
			"target"; $product.platformPath))
		
		SHOW ON DISK:C922($product.folder("Carthage").platformPath)
		
		//______________________________________________________
	: ($choice="xcdatamodel")
		
		$folder:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).folder(Generate UUID:C1066).folder("Structures.xcdatamodeld")
		
		cs:C1710.xcDataModel.new(PROJECT).run(\
			/*path*/$folder.platformPath; \
			/*options*/New object:C1471(\
			"flat"; False:C215; \
			"relationship"; True:C214))
		
		SHOW ON DISK:C922($folder.folder("Structures.xcdatamodel").platformPath)
		
		//______________________________________________________
	: ($choice="dataSet")
		
		dataSet(New object:C1471(\
			"action"; "erase"; \
			"project"; PROJECT))
		
		If (Not:C34(WEB Get server info:C1531.started))
			
			WEB Server:C1674(Web server host database:K73:31).start()
			
		End if 
		
		$o:=dataSet(New object:C1471(\
			"action"; "create"; \
			"project"; PROJECT; \
			"verbose"; True:C214; \
			"digest"; True:C214; \
			"dataSet"; True:C214; \
			"key"; cs:C1710.path.new().key().platformPath; \
			"caller"; Current form window:C827; \
			"method"; Formula:C1597(editor_CALLBACK).source; \
			"message"; "endOfDatasetGeneration"))
		
		SHOW ON DISK:C922($o.path)
		
		If (Not:C34($o.success))
			
			ALERT:C41(JSON Stringify:C1217($o))
			
		End if 
		
		//______________________________________________________
	: ($choice="coreDataSet")
		
		$pathname:=Temporary folder:C486+Folder separator:K24:12+Generate UUID:C1066+Folder separator:K24:12
		
		$o:=cs:C1710.xcDataModel.new(PROJECT).run(\
			/*path*/$pathname+"Sources"+Folder separator:K24:12+"Structures.xcdatamodeld"; \
			/*options*/New object:C1471(\
			"flat"; False:C215; \
			"relationship"; True:C214))
		
		If (Not:C34(WEB Get server info:C1531.started))
			
			WEB Server:C1674(Web server host database:K73:31).start()
			
		End if 
		
		$o:=dataSet(New object:C1471(\
			"action"; "create"; \
			"project"; PROJECT; \
			"verbose"; True:C214; \
			"digest"; True:C214; \
			"dataSet"; True:C214; \
			"path"; $pathname; \
			"key"; cs:C1710.path.new().key().platformPath; \
			"caller"; Current form window:C827; \
			"method"; Formula:C1597(editor_CALLBACK).source; \
			"message"; "endOfDatasetGeneration"))
		
		$o:=dataSet(New object:C1471(\
			"action"; "coreData"; \
			"verbose"; True:C214; \
			"removeAsset"; True:C214; \
			"caller"; Current form window:C827; \
			"method"; Formula:C1597(editor_CALLBACK).source; \
			"message"; "endOfDatasetGeneration"; \
			"path"; $pathname))
		
		SHOW ON DISK:C922($pathname)
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown menu action ("+$choice+")")
		
		//______________________________________________________
End case 