Class constructor($input : Object)
	This:C1470.input:=$input
	
	// XXX make clean with errors?
	ASSERT:C1129(Value type:C1509(This:C1470.input.path)=Is text:K8:3; "No path specified for target template")
	
	ASSERT:C1129(Value type:C1509(This:C1470.input.project)=Is object:K8:27; "No project passed to template")
	This:C1470.project:=$input.project
	If (OB Instance of:C1731(This:C1470.project.getCatalog; 4D:C1709.Function))  // only if project is a project class
		This:C1470.catalog:=This:C1470.project.getCatalog()
	Else 
		ASSERT:C1129(dev_Matrix && Not:C34(OB Instance of:C1731(This:C1470.project; cs:C1710.project)); "project is cs.project but you remove getCatalog???")
	End if 
	
	ASSERT:C1129(Value type:C1509(This:C1470.input.template)=Is object:K8:27; "No template defined")
	ASSERT:C1129(Value type:C1509(This:C1470.input.template.source)=Is text:K8:3; "Template has not source path")
	This:C1470.template:=$input.template
	
	// singleton helper
	This:C1470.path:=cs:C1710.path.new()
	
Function run()->$Obj_out : Object
	// ----------------------------------------------------
	// Manage template files according to type
	// ----------------------------------------------------
	
	// mainly copy file or skip the template to use a children one
	$Obj_out:=This:C1470.doRun()
	If ($Obj_out=Null:C1517)
		$Obj_out:=New object:C1471("success"; True:C214)
	End if 
	
	// ----------------------------------------------------
	// Inject source in project if template request it
	// ----------------------------------------------------
	
	$Obj_out.project:=This:C1470.injectSources()
	If ($Obj_out.project#Null:C1517)  // could be null if nothing to inject
		ob_error_combine($Obj_out; $Obj_out.project)
	End if 
	
	// ----------------------------------------------------
	// Install additionnal sdk defined by name
	// ----------------------------------------------------
	
	$Obj_out.sdk:=This:C1470.injectSDK()
	If ($Obj_out.sdk#Null:C1517)  // could be null if nothing to inject
		ob_error_combine($Obj_out; $Obj_out.sdk)
	End if 
	
	// ----------------------------------------------------
	// Read xcode project at destination
	// ----------------------------------------------------
	
	$Obj_out.projfile:=This:C1470.getXcodeProj()
	If (String:C10(This:C1470.input.template.type)="main")  // combine error if has been created, for the moment we know "main" template must create it (todo find a better way)
		ob_error_combine($Obj_out; $Obj_out.projfile)
	End if 
	
	// ----------------------------------------------------
	// Template has children template?
	// ----------------------------------------------------
	C_OBJECT:C1216($Obj_result)
	$Obj_result:=This:C1470.manageChildren()
	ob_deepMerge($Obj_out; $Obj_result)  // TODO test success status, is it computed later?
	
	// operation after managing children (like main template save project file)
	$Obj_result:=This:C1470.afterChildren()
	ob_deepMerge($Obj_out; $Obj_result)  // TODO test success status, is it computed later?
	
	// ----------------------------------------------------
	// transmit capabilities
	// ----------------------------------------------------
	
	If (Value type:C1509($Obj_out.template)=Is object:K8:27)
		If (This:C1470.input.template.capabilities#Null:C1517)
			$Obj_out.template.capabilities:=This:C1470.input.template.capabilities
		End if 
	End if 
	
	// ----------------------------------------------------
	// Compute status
	// ----------------------------------------------------
	
	$Obj_out.success:=Not:C34(ob_error_has($Obj_out))
	
Function getCatalogExcludePattern()->$pattern : Text
	Case of 
			
			//……………………………………………………………………………………………………………
		: (Value type:C1509(This:C1470.input.exclude)=Is text:K8:3)
			
			$pattern:=This:C1470.input.exclude
			
			//……………………………………………………………………………………………………………
		: (Value type:C1509(This:C1470.input.exclude)=Is collection:K8:32)
			
			$pattern:=JSON Stringify:C1217(This:C1470.input.exclude)
			
			//……………………………………………………………………………………………………………
		: (Bool:C1537(This:C1470.template.inject))
			
			$pattern:=JSON Stringify:C1217(SHARED.template.exclude)
			
			//……………………………………………………………………………………………………………
		Else 
			
			$pattern:="."  // ignore invisible files by default
			
			//……………………………………………………………………………………………………………
	End case 
	
	
Function copyFiles() : Object
	
	// get files to copy
	C_COLLECTION:C1488($Col_catalog)
	$Col_catalog:=_o_doc_catalog(This:C1470.template.source; This:C1470.getCatalogExcludePattern())
	
	// and finally copy with tag processing
	This:C1470.copyFilesResult:=TEMPLATE(New object:C1471(\
		"source"; This:C1470.template.source; \
		"target"; This:C1470.input.path; \
		"tags"; This:C1470.input.tags; \
		"caller"; This:C1470.input.caller; \
		"catalog"; $Col_catalog\
		))
	
	return This:C1470.copyFilesResult
	
Function doRun()->$result : Object
	$result:=This:C1470.copyFiles()
	$result.capabilities:=This:C1470.template.capabilities
	
	
Function getXcodeProj() : Object
	ASSERT:C1129(This:C1470.input.projfile#Null:C1517)  // must has been transfered and read one time by main template
	return This:C1470.input.projfile
	
Function manageChildren()->$Obj_out : Object
	$Obj_out:=New object:C1471()
	
	C_OBJECT:C1216($Obj_in; $Obj_template)
	$Obj_in:=This:C1470.input
	$Obj_template:=This:C1470.template
	If (Value type:C1509($Obj_template.children)=Is collection:K8:32)
		
		$Obj_out.children:=New collection:C1472
		
		// For each children template
		C_TEXT:C284($Txt_template)
		For each ($Txt_template; $Obj_template.children)
			
			C_OBJECT:C1216($o)
			$o:=OB Copy:C1225($Obj_in)
			
			// Read its manifest
			C_OBJECT:C1216($Path_manifest)
			$Path_manifest:=This:C1470.path.templates().folder($Txt_template).file("manifest.json")
			If ($Path_manifest.exists)
				
				$o.template:=JSON Parse:C1218($Path_manifest.getText())
				
			Else 
				
				$o.template:=New object:C1471
				
			End if 
			
			$o.template.source:=$Path_manifest.parent.platformPath
			$o.template.parent:=$Obj_template
			$o.projfile:=$Obj_in.projfile  // do not want a copy
			
			$o:=TemplateInstanceFactory($o).run()  // <================================== RECURSIVE
			
			$Obj_out.children.push($o)
			ob_error_combine($Obj_out; $o)
			
			// transmit tags created
			If (Value type:C1509($o.template.tags)=Is object:K8:27)
				
				$Obj_in.tags:=ob_deepMerge($Obj_in.tags; $o.template.tags)
				
			End if 
		End for each 
	End if 
	
	$Obj_out.success:=Not:C34(ob_error_has($Obj_out))
	
	
Function afterChildren() : Object
	return New object:C1471("success"; True:C214)
	// nothing to do at this level
	
Function injectSources($nodes : Object) : Object
	
	If (Count parameters:C259=0)
		$nodes:=This:C1470.copyFilesResult
	End if 
	
	If (Bool:C1537(This:C1470.template.inject))
		
		ASSERT:C1129($nodes#Null:C1517; "Nothing has been copyed and could be injected?")
		
		return XcodeProjInject(New object:C1471(\
			"node"; $nodes; \
			"mapping"; This:C1470.input.projfile.mapping; \
			"proj"; This:C1470.input.projfile.value; \
			"target"; This:C1470.input.path; \
			"uuid"; ob_inHierarchy(This:C1470.template; "uuid").uuid))
		
	End if 
	
	return Null:C1517
	
Function injectSDK() : Object
	If (Value type:C1509(This:C1470.template.sdk)=Is object:K8:27)
		
		If (Length:C16(String:C10(This:C1470.template.sdk.name))>0)
			
			return sdk(New object:C1471(\
				"action"; "installAdditionnalSDK"; \
				"template"; This:C1470.template; \
				"target"; This:C1470.input.path))
			
		End if 
	End if 
	
	return Null:C1517
	