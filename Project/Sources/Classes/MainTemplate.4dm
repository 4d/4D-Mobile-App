Class extends Template

Class constructor
	C_OBJECT:C1216($1)
	Super:C1705($1)
	ASSERT:C1129(This:C1470.template.type="main")
	
Function updateAssets
	C_OBJECT:C1216($0; $Obj_out)
	
	$Obj_out:=New object:C1471()
	
	C_OBJECT:C1216($Obj_in; $Obj_template)
	$Obj_in:=This:C1470.input
	$Obj_template:=This:C1470.template
	
	// Update Assets
	If (String:C10($Obj_template.assets.source)#"")
		
		$Obj_out.assets:=template(New object:C1471(\
			"source"; $Obj_template.assets.source; \
			"target"; $Obj_template.assets.target; \
			"catalog"; _o_doc_catalog($Obj_template.assets.source)\
			))
		
		ob_error_combine($Obj_out; $Obj_out.assets)
		
	End if 
	
	$Obj_in.theme:=This:C1470.theme()
	
	$Obj_out.success:=Not:C34(ob_error_has($Obj_out))
	$0:=$Obj_out
	
Function theme()->$theme : Object
	$theme:=New object:C1471("success"; False:C215)
	
	var $rgb : Object
	Case of 
		: (Length:C16(String:C10(This:C1470.input.project.ui.dominantColor))>0)
			$rgb:=New object:C1471(\
				"value"; cs:C1710.color.new(This:C1470.input.project.ui.dominantColor).rgb; \
				"success"; True:C214)
			$rgb.value.space:="srgb"
			If (Num:C11($rgb.value.alpha)=0)  // useless alpha, remove it (must not occurs but)
				OB REMOVE:C1226($rgb.value; "alpha")
			End if 
		: (Length:C16(String:C10(This:C1470.template.assets.source))>0)
			$rgb:=This:C1470._o_rgb()
		Else 
			$rgb:=New object:C1471("success"; False:C215)
	End case 
	
	If ($rgb.success)
		
		$theme.BackgroundColor:=$rgb.value
		$theme.BackgroundColor.name:="BackgroundColor"
		
		$theme.BackgroundColor.asset:=asset(New object:C1471(\
			"action"; "create"; \
			"target"; This:C1470.template.assets.target+"NavigationBar"+Folder separator:K24:12; \
			"type"; "colorset"; \
			"space"; $theme.BackgroundColor.space; \
			"tags"; $theme.BackgroundColor))
		
		$rgb:=colors(New object:C1471(\
			"action"; "contrast"; \
			"color"; $theme.BackgroundColor))
		
		If ($rgb.success)
			
			$theme.ForegroundColor:=$rgb.value
			$theme.ForegroundColor.name:="ForegroundColor"
			
			$theme.ForegroundColor.asset:=asset(New object:C1471(\
				"action"; "create"; \
				"target"; This:C1470.template.assets.target+"NavigationBar"+Folder separator:K24:12; \
				"type"; "colorset"; \
				"space"; $theme.ForegroundColor.space; \
				"tags"; $theme.ForegroundColor))
			
			$theme.success:=True:C214
			
		End if 
	End if 
	
	// Temporary or by default take app icon, later could be customizable by UI, and must be managed like AppIcon
Function _o_rgb()->$rgb
	ASSERT:C1129(This:C1470.template.assets.source#""; "No assert to compute color")
	
	var $file : 4D:C1709.File
	$file:=Folder:C1567(This:C1470.template.assets.source; fk platform path:K87:2).folder("AppIcon.appiconset").file("ios-marketing1024.png")
	var $l : Integer
	$l:=SHARED.theme.colorjuicer.scale
	
	If ($l#1024)\
		 & ($l>0)
		var $Pic_file; $Pic_scaled : Picture
		READ PICTURE FILE:C678($file.platformPath; $Pic_file)
		CREATE THUMBNAIL:C679($Pic_file; $Pic_scaled; $l; $l)  // This change result of algo..., let tools scale using argument
		$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066)
		WRITE PICTURE FILE:C680($file.platformPath; $Pic_scaled; ".png")
		
	End if 
	
	$rgb:=colors(New object:C1471(\
		"action"; "juicer"; \
		"posix"; $file.path))
	
	If (($l#1024)\
		 & ($l>0))
		
		$file.delete()  // delete scaled files
		
	End if 
	
Function getXcodeProj
	C_OBJECT:C1216($0)
	
	If (This:C1470.input.projfile=Null:C1517)
		
		This:C1470.input.projfile:=XcodeProj(New object:C1471(\
			"action"; "read"; \
			"path"; This:C1470.input.path))
		
		XcodeProj(New object:C1471(\
			"action"; "mapping"; \
			"projObject"; This:C1470.input.projfile))
		
		// no return, mapping is added to projfile
		
	End if 
	
	$0:=This:C1470.input.projfile
	
	// Manage the project file for main template
Function afterChildren()->$Obj_out : Object
	var $Obj_in; $o : Object
	
	$Obj_out:=New object:C1471()
	
	$Obj_in:=This:C1470.input
	
	// Possible files near the projet file
	If (Value type:C1509($Obj_in.project.$project)=Is object:K8:27)
		
		var $name : Text
		$name:="main"  // XXX maybe later a list
		
		If (Folder:C1567(String:C10(This:C1470.input.project.$project.root)+$name; fk platform path:K87:2).exists)
			
			$o:=New object:C1471(\
				"template"; New object:C1471(\
				"name"; "project"+$name; \
				"inject"; True:C214; \
				"source"; This:C1470.input.project.$project.root+$name+Folder separator:K24:12; \
				"parent"; This:C1470.template); \
				"project"; This:C1470.input.project; \
				"path"; This:C1470.input.path; \
				"projfile"; This:C1470.input.projfile)
			
			$Obj_out["project"+$name]:=TemplateInstanceFactory($o).run()  // <================================== RECURSIVE
			
		End if 
	End if 
	
	// Inject all SDK
	If (String:C10(This:C1470.template.sdk.frameworks)#"")
		
		$Obj_out.sdk:=sdk(New object:C1471(\
			"action"; "inject"; \
			"projfile"; $Obj_in.projfile; \
			"folder"; This:C1470.template.sdk.frameworks; \
			"target"; $Obj_in.path))
		
		ob_error_combine($Obj_out; $Obj_out.sdk)
		
	End if 
	
	// Add data from formatters definition
	$Obj_out.formatters:=formatters(New object:C1471(\
		"action"; "extract"; \
		"formatters"; $Obj_in.formatters; \
		"dataModel"; $Obj_in.project.dataModel))
	
	If ($Obj_out.formatters.success)
		
		// pass the collection of formatters and generate it
		$Obj_out.formatters:=formatters(New object:C1471(\
			"action"; "generate"; \
			"formatters"; $Obj_out.formatters.formatters; \
			"tags"; $Obj_in.tags; \
			"target"; $Obj_in.path))
		
		If ($Obj_out.formatters.success)
			
			// If (Bool(featuresFlags._100990))
			// Add all files provided
			$o:=XcodeProjInject(New object:C1471(\
				"node"; $Obj_out.formatters; \
				"mapping"; This:C1470.input.projfile.mapping; \
				"proj"; This:C1470.input.projfile.value; \
				"target"; This:C1470.input.path; \
				"uuid"; This:C1470.input.template.uuid))
			
			// Else
			//  // * Formatters.strings file has been generated, add it
			//If (Length(String($Obj_out.formatters.target))>0)
			//$Obj_out.formatters:=XcodeProjInject (New object("path";$Obj_out.formatters.target;"mapping";$Obj_out.projfile.mapping;"proj";$Obj_out.projfile.value;"target";$Obj_in.path;"types";New collection();"uuid";$Obj_in.template.uuid))
			// End if
			// End if
			
		End if 
	End if 
	
	ob_error_combine($Obj_out; $Obj_out.formatters)
	
	If (Bool:C1537($Obj_in.project.server.pushNotification))
		
		$o:=New object:C1471(\
			"template"; New object:C1471(\
			"name"; "pushNotification"; \
			"inject"; True:C214; \
			"source"; cs:C1710.path.new().templates().folder("pushNotification").platformPath; \
			"parent"; This:C1470.template); \
			"project"; This:C1470.input.project; \
			"path"; This:C1470.input.path; \
			"projfile"; This:C1470.input.projfile)
		
		$Obj_out["pushNotification"]:=TemplateInstanceFactory($o).run()  // <================================== RECURSIVE
		
	End if 
	
	// label and shortlabel as localizable resource
	$Obj_out.coreDataStrings:=xloc(New object:C1471(\
		"action"; "dataModel"; \
		"dataModel"; This:C1470.input.project.dataModel; \
		"output"; Folder:C1567(This:C1470.input.path; fk platform path:K87:2).folder("Resources").file("StructuresModel.strings")))
	
	If ($Obj_out.coreDataStrings.success)
		$Obj_out.coreDataStrings:=XcodeProjInject(New object:C1471(\
			"node"; $Obj_out.coreDataStrings; \
			"mapping"; This:C1470.input.projfile.mapping; \
			"proj"; This:C1470.input.projfile.value; \
			"target"; This:C1470.input.path; \
			"uuid"; This:C1470.input.template.uuid))
	End if 
	
	ob_error_combine($Obj_out; $Obj_out.coreDataStrings)
	
	//  Save project file if has been modified
	$Obj_out.projfile:=This:C1470.getXcodeProj()
	If (Bool:C1537($Obj_out.projfile.mustSave))
		
		$Obj_out.projfile:=XcodeProj(New object:C1471(\
			"action"; "write"; \
			"object"; This:C1470.input.projfile.value; \
			"project"; This:C1470.input.tags.product; \
			"path"; This:C1470.input.projfile.path))
		
		// PRODUCT tag for PBXProject could be removed by write process
		Process_tags_on_file($Obj_out.projfile.path; $Obj_out.projfile.path; $Obj_in.tags; New collection:C1472("project.pbxproj"))
		
		If (Not:C34(Bool:C1537($Obj_out.projfile.success)))
			
			ob_error_combine($Obj_out; $Obj_out.projfile; "Failed to write project file to "+$Obj_out.projfile.path)
			
		End if 
	End if 
	
	$Obj_out.success:=Not:C34(ob_error_has($Obj_out))
	
	
Function getCatalogExcludePattern()->$pattern : Text
	$pattern:="*"  // nothing, even hidden files must be copyed for this template
	
Function doRun()->$result : Object
	$result:=Super:C1706.doRun()  // copy files
	
	This:C1470.input:=OB Copy:C1225(This:C1470.input)
	This:C1470.input.projfile:=This:C1470.getXcodeProj()
	This:C1470.input.read:=True:C214
	
	$result:=ob_deepMerge($result; This:C1470.updateAssets())
	
	This:C1470.input.formats:=mobile_actions("hostFormatList"; This:C1470.input).formats  // will cache formats for next step
	
	// Add choice lists if any to action parameters
	$result.choiceList:=mobile_actions("addChoiceList"; This:C1470.input)
	ob_error_combine($result; $result.choiceList)
	
	If (FEATURE.with("actionsInTabBar"))
		// Instead of table number, put directly name, iOS do not use table number
		$result.putTableNames:=mobile_actions("putTableNames"; This:C1470.input)
		ob_error_combine($result; $result.putTableNames)
	End if 
	
	// Inject source code or resources
	$result.injectHost:=mobile_actions("injectHost"; This:C1470.input)
	ob_error_combine($result; $result.injectHost)
	