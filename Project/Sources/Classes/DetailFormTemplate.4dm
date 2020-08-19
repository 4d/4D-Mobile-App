Class extends FormTemplate

Class constructor
	C_OBJECT:C1216($1)
	Super:C1705($1)
	ASSERT:C1129(This:C1470.template.type="detailform")
	
Function doRun
	C_OBJECT:C1216($0; $Obj_out)
	$Obj_out:=New object:C1471()
	
	// NO SUPER, we do not want to copy files currently
	
	// XXX factorize with navigation template code for image?
	
	C_OBJECT:C1216($Obj_in; $Obj_template)
	$Obj_in:=This:C1470.input
	$Obj_template:=This:C1470.template
	
	$Obj_in.tags.table.detailFields:=$Obj_in.tags.table.fields
	
	// Need asset?
	C_BOOLEAN:C305($Boo_withIcons)
	$Boo_withIcons:=Bool:C1537($Obj_template.assets.mandatory)\
		 | ($Obj_in.tags.table.detailFields.query("icon != ''").length>0)
	
	// Create by field icon alignment or icon name
	C_OBJECT:C1216($Obj_field)
	For each ($Obj_field; $Obj_in.tags.table.detailFields)
		
		C_BOOLEAN:C305($Boo_withIcons)
		If ($Boo_withIcons)
			
			$Obj_field.labelAlignment:="left"
			$Obj_field.detailIcon:=$Obj_in.tags.table.name+"Detail"+$Obj_field.name
			
		Else 
			
			$Obj_field.labelAlignment:="center"
			$Obj_field.detailIcon:=""
			
		End if 
	End for each 
	
	// Create the icons
	If ($Boo_withIcons)
		
		C_OBJECT:C1216($Path_root; $Path_hostRoot)
		$Path_root:=COMPONENT_Pathname("fieldIcons")
		$Path_hostRoot:=COMPONENT_Pathname("host_fieldIcons")
		
		// If need asset, create it
		$Obj_out.assets:=New collection:C1472  // result of asset operations
		
		If (Value type:C1509($Obj_template.assets)#Is object:K8:27)
			
			$Obj_template.assets:=New object:C1471(\
				"format"; "png")  // Fill missing information for detail template only
			
		End if 
		
		If ($Obj_template.assets.target=Null:C1517)
			
			$Obj_template.assets.target:="___TABLE___/Detail"  // Default path for detail template resource
			
		End if 
		
		For each ($Obj_field; $Obj_in.tags.table.detailFields)
			
			If (Length:C16(String:C10($Obj_field.icon))=0)  // no icon defined
				
				// Generate asset using first table letter
				C_OBJECT:C1216($file)
				$file:=Folder:C1567(fk resources folder:K87:11).folder("images").file("missingIcon.svg")
				
				If (Asserted:C1132($file.exists; "Missing ressources: "+$file.path))
					
					C_TEXT:C284($Svg_root; $t)
					$Svg_root:=DOM Parse XML source:C719($file.platformPath)
					
					If (Asserted:C1132(OK=1; "Failed to parse: "+$file.path))
						
						$t:=Choose:C955(Bool:C1537($Obj_template.shortLabel); $Obj_field.shortLabel; $Obj_field.label)
						
						Case of 
								
								//……………………………………………………………………………………………………………
							: (Length:C16($t)>0)
								
								// Take first letter
								$t:=Uppercase:C13($t[[1]])
								
								//……………………………………………………………………………………………………………
							: (Length:C16($Obj_field.name)>0)
								
								//%W-533.1
								$t:=Uppercase:C13($Obj_field.name[[1]])
								//%W+533.1
								
								//……………………………………………………………………………………………………………
						End case 
						
						If (Length:C16($t)>0)  // Else no image for dummy fields
							
							DOM SET XML ELEMENT VALUE:C868($Svg_root; "/svg/textArea"; $t)
							
							$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+".svg")
							DOM EXPORT TO FILE:C862($Svg_root; $file.platformPath)
							
							DOM CLOSE XML:C722($Svg_root)
							
							$Obj_out.assets.push(asset(New object:C1471(\
								"action"; "create"; \
								"type"; "imageset"; \
								"tags"; New object:C1471("name"; $Obj_in.tags.table.name+"Detail"+$Obj_field.name); \
								"source"; $file.platformPath; \
								"target"; $Obj_template.parent.parent.assets.target+Replace string:C233(Process_tags($Obj_template.assets.target; $Obj_in.tags; New collection:C1472("filename")); "/"; Folder separator:K24:12)+Folder separator:K24:12; \
								"format"; $Obj_template.assets.format; \
								"size"; $Obj_template.assets.size)))
							
						End if 
					End if 
				End if 
				
			Else   // There is an icon defined
				
				C_OBJECT:C1216($Path_icon)
				If (Position:C15("/"; $Obj_field.icon)=1)
					
					// Custom icon
					$Path_icon:=$Path_hostRoot.file(Substring:C12($Obj_field.icon; 2))
					
				Else 
					
					// Product icon
					$Path_icon:=$Path_root.file($Obj_field.icon)
					
				End if 
				
				C_OBJECT:C1216($o)
				$o:=asset(New object:C1471(\
					"action"; "create"; \
					"type"; "imageset"; \
					"tags"; New object:C1471("name"; $Obj_in.tags.table.name+"Detail"+$Obj_field.name); \
					"source"; $Path_icon.platformPath; \
					"target"; $Obj_template.parent.parent.assets.target+Replace string:C233(Process_tags($Obj_template.assets.target; $Obj_in.tags; New collection:C1472("filename")); "/"; Folder separator:K24:12)+Folder separator:K24:12; \
					"format"; $Obj_template.assets.format; \
					"size"; $Obj_template.assets.size))
				
				$Obj_out.assets.push($o)
				ob_error_combine($Obj_out; $o)
				
			End if 
		End for each 
	End if 
	
	// Standard code to copy template (not done before tags replacement, that's why nothing is done in first case of)
	This:C1470.copyFilesResult:=template(New object:C1471(\
		"source"; $Obj_template.source; \
		"target"; $Obj_in.path; \
		"tags"; $Obj_in.tags; \
		"caller"; $Obj_in.caller; \
		"catalog"; doc_catalog($Obj_template.source; JSON Stringify:C1217(SHARED.template.exclude))))
	
	$Obj_out.template:=This:C1470.copyFilesResult
	
	$Obj_out.project:=XcodeProjInject(New object:C1471(\
		"node"; This:C1470.copyFilesResult; \
		"mapping"; $Obj_in.projfile.mapping; \
		"proj"; $Obj_in.projfile.value; \
		"target"; $Obj_in.path; \
		"uuid"; ob_inHierarchy($Obj_template; "uuid").uuid))
	
	ob_error_combine($Obj_out; $Obj_out.project)
	
	$Obj_in.projfile.mustSave:=True:C214  // project modified
	
	// Manage template elements duplication
	
	$Obj_out.storyboard:=storyboard(New object:C1471(\
		"action"; "detailform"; \
		"template"; $Obj_template; \
		"target"; $Obj_in.path; \
		"tags"; $Obj_in.tags))
	
	If (Not:C34($Obj_out.storyboard.success))  // just in case no errors is generated and success is false
		
		$Obj_out.success:=False:C215
		ob_error_combine($Obj_out; $Obj_out.storyboard; "detail form storyboard creation failed for table "+$Obj_in.tags.table.name)
		
	End if 
	$0:=$Obj_out