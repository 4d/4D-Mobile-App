//%attributes = {"invisible":true}
var $choice; $pathname : Text
var $o : Object
var $product : 4D:C1709.Folder

$choice:=Get selected menu item parameter:C1005

Case of 
		
		//______________________________________________________
	: (Length:C16($choice)=0)
		
		// NOTHING MORE TO DO
		
		//______________________________________________________
	: ($choice="buildAndRun")
		
		project_BUILD(New object:C1471(\
			"caller"; Current form window:C827; \
			"project"; PROJECT; \
			"create"; True:C214; \
			"build"; True:C214; \
			"run"; True:C214; \
			"verbose"; True:C214))
		
		//______________________________________________________
	: ($choice="create")
		
		project_BUILD(New object:C1471(\
			"caller"; Current form window:C827; \
			"project"; PROJECT; \
			"create"; True:C214; \
			"build"; False:C215; \
			"run"; False:C215; \
			"verbose"; True:C214))
		
		//______________________________________________________
	: ($choice="build")
		
		project_BUILD(New object:C1471(\
			"caller"; Current form window:C827; \
			"project"; PROJECT; \
			"create"; False:C215; \
			"build"; True:C214; \
			"run"; True:C214; \
			"verbose"; True:C214))
		
		//______________________________________________________
	: ($choice="run")
		
		project_BUILD(New object:C1471(\
			"caller"; Current form window:C827; \
			"project"; PROJECT; \
			"create"; False:C215; \
			"build"; False:C215; \
			"run"; True:C214; \
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
		
		$pathname:=Temporary folder:C486+Folder separator:K24:12+Generate UUID:C1066+Folder separator:K24:12
		
		dataModel(New object:C1471(\
			"action"; "xcdatamodel"; \
			"dataModel"; PROJECT.dataModel; \
			"actions"; PROJECT.actions; \
			"flat"; False:C215; \
			"relationship"; True:C214; \
			"path"; $pathname+"Structures.xcdatamodeld"))
		
		SHOW ON DISK:C922($pathname)
		
		//______________________________________________________
	: ($choice="dataSet")
		
		dataSet(New object:C1471(\
			"action"; "erase"; \
			"project"; PROJECT))
		
		If (Not:C34(WEB Is server running:C1313))
			
			WEB START SERVER:C617
			
		End if 
		
		$o:=dataSet(New object:C1471(\
			"action"; "create"; \
			"project"; PROJECT; \
			"digest"; True:C214; \
			"dataSet"; True:C214; \
			"key"; cs:C1710.path.new().key().platformPath; \
			"caller"; Current form window:C827; \
			"verbose"; True:C214))
		
		SHOW ON DISK:C922($o.path)
		
		If (Not:C34($o.success))
			
			ALERT:C41(JSON Stringify:C1217($o))
			
		End if 
		
		//______________________________________________________
	: ($choice="coreDataSet")
		
		$pathname:=Temporary folder:C486+Folder separator:K24:12+Generate UUID:C1066+Folder separator:K24:12
		
		$o:=dataModel(New object:C1471(\
			"action"; "xcdatamodel"; \
			"dataModel"; PROJECT.dataModel; \
			"actions"; PROJECT.actions; \
			"flat"; False:C215; \
			"relationship"; True:C214; \
			"path"; $pathname+"Sources"+Folder separator:K24:12+"Structures.xcdatamodeld"))
		
		If (Not:C34(WEB Is server running:C1313))
			
			WEB START SERVER:C617
			
		End if 
		
		$o:=dataSet(New object:C1471(\
			"action"; "create"; \
			"project"; PROJECT; \
			"digest"; True:C214; \
			"dataSet"; True:C214; \
			"path"; $pathname; \
			"key"; cs:C1710.path.new().key().platformPath; \
			"caller"; Current form window:C827; \
			"verbose"; True:C214))
		
		$o:=dataSet(New object:C1471(\
			"action"; "coreData"; \
			"removeAsset"; True:C214; \
			"caller"; Current form window:C827; \
			"verbose"; True:C214; \
			"path"; $pathname))
		
		SHOW ON DISK:C922($pathname)
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown menu action ("+$choice+")")
		
		//______________________________________________________
End case 