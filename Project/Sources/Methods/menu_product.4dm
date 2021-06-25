//%attributes = {"invisible":true}
C_TEXT:C284($Mnu_choice)
C_OBJECT:C1216($Obj_project; $Obj_result)

$Mnu_choice:=Get selected menu item parameter:C1005
$Obj_project:=(OBJECT Get pointer:C1124(Object named:K67:5; "project"))->

Case of 
		
		//______________________________________________________
	: (Length:C16($Mnu_choice)=0)
		
		// NOTHING MORE TO DO
		
		//______________________________________________________
	: ($Mnu_choice="buildAndRun")
		
		project_BUILD(New object:C1471(\
			"caller"; Current form window:C827; \
			"project"; $Obj_project; \
			"create"; True:C214; \
			"build"; True:C214; \
			"run"; True:C214; \
			"verbose"; True:C214))
		
		//______________________________________________________
	: ($Mnu_choice="create")
		
		project_BUILD(New object:C1471(\
			"caller"; Current form window:C827; \
			"project"; $Obj_project; \
			"create"; True:C214; \
			"build"; False:C215; \
			"run"; False:C215; \
			"verbose"; True:C214))
		
		//______________________________________________________
	: ($Mnu_choice="build")
		
		project_BUILD(New object:C1471(\
			"caller"; Current form window:C827; \
			"project"; $Obj_project; \
			"create"; False:C215; \
			"build"; True:C214; \
			"run"; True:C214; \
			"verbose"; True:C214))
		
		//______________________________________________________
	: ($Mnu_choice="run")
		
		project_BUILD(New object:C1471(\
			"caller"; Current form window:C827; \
			"project"; $Obj_project; \
			"create"; False:C215; \
			"build"; False:C215; \
			"run"; True:C214; \
			"verbose"; True:C214))
		
		//______________________________________________________
	: ($Mnu_choice="reveal")
		
		SHOW ON DISK:C922(cs:C1710.path.new().products().folder($Obj_project.product.name).platformPath)
		
		//______________________________________________________
	: ($Mnu_choice="replaceSDK")
		
		var $product : 4D:C1709.Folder
		$product:=cs:C1710.path.new().products().folder($Obj_project.product.name)
		
		$product.folder("Carthage").delete(Delete with contents:K24:24)
		
		sdk(New object:C1471(\
			"action"; "install"; \
			"file"; cs:C1710.path.new().sdk().platformPath+"ios.zip"; \
			"target"; $product.platformPath))
		
		SHOW ON DISK:C922($product.folder("Carthage").platformPath)
		
		//______________________________________________________
	: ($Mnu_choice="xcdatamodel")
		
		C_TEXT:C284($Txt_path)
		$Txt_path:=Temporary folder:C486+Folder separator:K24:12+Generate UUID:C1066+Folder separator:K24:12
		
		dataModel(New object:C1471(\
			"action"; "xcdatamodel"; \
			"dataModel"; $Obj_project.dataModel; \
			"actions"; $Obj_project.actions; \
			"flat"; False:C215; \
			"relationship"; True:C214; \
			"path"; $Txt_path+"Structures.xcdatamodeld"))
		
		SHOW ON DISK:C922($Txt_path)
		
		//______________________________________________________
	: ($Mnu_choice="dataSet")
		
		dataSet(New object:C1471(\
			"action"; "erase"; \
			"project"; $Obj_project))
		
		If (Not:C34(WEB Is server running:C1313))
			WEB START SERVER:C617
		End if 
		
		$Obj_result:=dataSet(New object:C1471(\
			"action"; "create"; \
			"project"; $Obj_project; \
			"digest"; True:C214; \
			"dataSet"; True:C214; \
			"key"; cs:C1710.path.new().key().platformPath; \
			"caller"; Current form window:C827; \
			"verbose"; True:C214))
		
		SHOW ON DISK:C922($Obj_result.path)
		
		If (Not:C34($Obj_result.success))
			ALERT:C41(JSON Stringify:C1217($Obj_result))
		End if 
		
		//______________________________________________________
	: ($Mnu_choice="coreDataSet")
		
		C_TEXT:C284($Txt_path)
		$Txt_path:=Temporary folder:C486+Folder separator:K24:12+Generate UUID:C1066+Folder separator:K24:12
		
		$Obj_result:=dataModel(New object:C1471(\
			"action"; "xcdatamodel"; \
			"dataModel"; $Obj_project.dataModel; \
			"actions"; $Obj_project.actions; \
			"flat"; False:C215; \
			"relationship"; True:C214; \
			"path"; $Txt_path+"Sources"+Folder separator:K24:12+"Structures.xcdatamodeld"))
		
		If (Not:C34(WEB Is server running:C1313))
			
			WEB START SERVER:C617
			
		End if 
		
		$Obj_result:=dataSet(New object:C1471(\
			"action"; "create"; \
			"project"; $Obj_project; \
			"digest"; True:C214; \
			"dataSet"; True:C214; \
			"path"; $Txt_path; \
			"key"; cs:C1710.path.new().key().platformPath; \
			"caller"; Current form window:C827; \
			"verbose"; True:C214))
		
		$Obj_result:=dataSet(New object:C1471(\
			"action"; "coreData"; \
			"removeAsset"; True:C214; \
			"caller"; Current form window:C827; \
			"verbose"; True:C214; \
			"path"; $Txt_path))
		
		SHOW ON DISK:C922($Txt_path)
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown menu action ("+$Mnu_choice+")")
		
		//______________________________________________________
End case 