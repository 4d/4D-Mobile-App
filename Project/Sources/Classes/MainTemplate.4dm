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
			"catalog"; doc_catalog($Obj_template.assets.source)\
			))
		
		ob_error_combine($Obj_out; $Obj_out.assets)
		
		// Temporary or by default take app icon, later could be customizable by UI, and must be managed like AppIcon
		$Obj_out.theme:=New object:C1471("success"; False:C215)
		
		C_OBJECT:C1216($file)
		$file:=Folder:C1567($Obj_template.assets.source; fk platform path:K87:2).folder("AppIcon.appiconset").file("ios-marketing1024.png")
		C_LONGINT:C283($l)
		$l:=SHARED.theme.colorjuicer.scale
		
		If ($l#1024)\
			 & ($l>0)
			C_PICTURE:C286($Pic_file)
			C_PICTURE:C286($Pic_scaled)
			READ PICTURE FILE:C678($file.platformPath; $Pic_file)
			CREATE THUMBNAIL:C679($Pic_file; $Pic_scaled; $l; $l)  // This change result of algo..., let tools scale using argument
			$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066)
			WRITE PICTURE FILE:C680($file.platformPath; $Pic_scaled; ".png")
			
		End if 
		
		C_OBJECT:C1216($Obj_color)
		$Obj_color:=colors(New object:C1471(\
			"action"; "juicer"; \
			"posix"; $file.path))
		
		If ($Obj_color.success)
			
			$Obj_out.theme.BackgroundColor:=$Obj_color.value
			$Obj_out.theme.BackgroundColor.name:="BackgroundColor"
			
			$Obj_out.theme.BackgroundColor.asset:=asset(New object:C1471(\
				"action"; "create"; \
				"target"; $Obj_template.assets.target+"NavigationBar"+Folder separator:K24:12; \
				"type"; "colorset"; \
				"space"; $Obj_out.theme.BackgroundColor.space; \
				"tags"; $Obj_out.theme.BackgroundColor))
			
			$Obj_color:=colors(New object:C1471(\
				"action"; "contrast"; \
				"color"; $Obj_out.theme.BackgroundColor))
			
			If ($Obj_color.success)
				
				$Obj_out.theme.ForegroundColor:=$Obj_color.value
				$Obj_out.theme.ForegroundColor.name:="ForegroundColor"
				
				$Obj_out.theme.ForegroundColor.asset:=asset(New object:C1471(\
					"action"; "create"; \
					"target"; $Obj_template.assets.target+"NavigationBar"+Folder separator:K24:12; \
					"type"; "colorset"; \
					"space"; $Obj_out.theme.ForegroundColor.space; \
					"tags"; $Obj_out.theme.ForegroundColor))
				
				$Obj_out.theme.success:=True:C214
				
			End if 
		End if 
		
		If (($l#1024)\
			 & ($l>0))
			
			$file.delete()  // delete scaled files
			
		End if 
		
		$Obj_in.theme:=$Obj_out.theme  // to pass to children
		
	End if 
	
	$Obj_out.success:=Not:C34(ob_error_has($Obj_out))
	$0:=$Obj_out
	
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
Function afterChildren
	C_OBJECT:C1216($0; $Obj_out)
	$Obj_out:=New object:C1471()
	
	C_OBJECT:C1216($Obj_in; $Obj_template)
	$Obj_in:=This:C1470.input
	$Obj_template:=This:C1470.template
	
	// Possible files near the projet file
	If (Value type:C1509($Obj_in.project.$project)=Is object:K8:27)
		
		C_TEXT:C284($t)
		$t:="main"  // XXX maybe later a list
		
		If (Test path name:C476(String:C10($Obj_in.project.$project.root)+$t)=Is a folder:K24:2)
			C_OBJECT:C1216($o)
			$o:=New object:C1471(\
				"template"; New object:C1471(\
				"name"; "project"+$t; \
				"inject"; True:C214; \
				"source"; This:C1470.input.project.$project.root+$t+Folder separator:K24:12; \
				"parent"; $Obj_template); \
				"project"; This:C1470.input.project; \
				"path"; This:C1470.input.path; \
				"projfile"; This:C1470.input.projfile)
			
			$Obj_out["project"+$t]:=TemplateInstanceFactory($o).run()  // <================================== RECURSIVE
			
		End if 
	End if 
	
	// Inject all SDK
	If (String:C10($Obj_template.sdk.frameworks)#"")
		
		$Obj_out.sdk:=sdk(New object:C1471(\
			"action"; "inject"; \
			"projfile"; $Obj_in.projfile; \
			"folder"; $Obj_template.sdk.frameworks; \
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
	
	If (feature.with(107526))
		
		If (Bool:C1537($Obj_in.project.server.pushNotification))
			
			$o:=New object:C1471(\
				"template"; New object:C1471(\
				"name"; "pushNotification"; \
				"inject"; True:C214; \
				"source"; COMPONENT_Pathname("templates").folder("pushNotification").platformPath; \
				"parent"; $Obj_template); \
				"project"; This:C1470.input.project; \
				"path"; This:C1470.input.path; \
				"projfile"; This:C1470.input.projfile)
			
			$Obj_out["pushNotification"]:=TemplateInstanceFactory($o).run()  // <================================== RECURSIVE
			
		End if 
	End if 
	
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
	$0:=$Obj_out
	
	
Function getCatalogExcludePattern
	C_TEXT:C284($0)
	$0:="*"  // nothing, even hidden files must be copyed for this template
	
Function doRun
	C_OBJECT:C1216($0)
	$0:=Super:C1706.doRun()  // copy files
	$0:=ob_deepMerge($0; This:C1470.updateAssets())
	