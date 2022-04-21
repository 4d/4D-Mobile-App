Class extends FormTemplate

Class constructor
	C_OBJECT:C1216($1)
	Super:C1705($1)
	ASSERT:C1129(This:C1470.template.type="detailform")
	
Function doRun
	C_OBJECT:C1216($0; $Obj_out)
	$Obj_out:=New object:C1471()
	
	// modify tags (CHECK why we cannot use fields?)
	//This.input.tags.table.detailFields:=This.input.tags.table.fields
	
	// Create the icons
	$Obj_out:=This:C1470.createIconAssets()
	
	This:C1470.template.inject:=True:C214
	
	C_OBJECT:C1216($Obj_result)
	$Obj_result:=Super:C1706.doRun()  // copy files: done after modyfing tags in creteIcoAssets and by settings detailsFields
	ob_error_combine($Obj_out; $Obj_result)
	
	$Obj_out.template:=This:C1470.copyFilesResult
	
	//$Obj_out.project:=This.injectSources()
	//ob_error_combine($Obj_out; $Obj_out.project)
	
	This:C1470.input.projfile.mustSave:=True:C214  // project modified
	
	// Manage template elements duplication
	
	$Obj_out.storyboard:=This:C1470.storyboard().run(This:C1470.template; Folder:C1567(This:C1470.input.path; fk platform path:K87:2); This:C1470.input.tags)
	
	If (Not:C34($Obj_out.storyboard.success))  // just in case no errors is generated and success is false
		
		$Obj_out.success:=False:C215
		ob_error_combine($Obj_out; $Obj_out.storyboard; "detail form storyboard creation failed for table "+This:C1470.input.tags.table.name)
		
	End if 
	
	$0:=$Obj_out
	
Function storyboard()->$result : Object
	$result:=cs:C1710.DetailFormStoryboard.new()
	
Function createIconAssets()->$Obj_out : Object
	$Obj_out:=New object:C1471()
	
	C_BOOLEAN:C305($Boo_withIcons)
	$Boo_withIcons:=Bool:C1537(This:C1470.template.assets.mandatory)\
		 | (This:C1470.input.tags.table.fields.query("icon != ''").length>0)
	
	
	// Create by field icon alignment or icon name
	var $Obj_field : Object
	For each ($Obj_field; This:C1470.input.tags.table.fields)
		
		If ($Boo_withIcons)
			
			$Obj_field.labelAlignment:="left"
			$Obj_field.detailIcon:=This:C1470.input.tags.table.name+"Detail"+$Obj_field.nameIcon
			
		Else 
			
			$Obj_field.labelAlignment:="center"
			$Obj_field.detailIcon:=""
			
		End if 
	End for each 
	
	If ($Boo_withIcons)
		
		var $file; $Path_root; $Path_hostRoot : Object
		$Path_root:=This:C1470.path.fieldIcons()
		$Path_hostRoot:=This:C1470.path.hostIcons()
		
		// If need asset, create it
		$Obj_out.assets:=New collection:C1472  // result of asset operations
		
		If (Value type:C1509(This:C1470.template.assets)#Is object:K8:27)
			
			This:C1470.template.assets:=New object:C1471("format"; "png")  // Fill missing information for detail template only
			
		End if 
		
		If (This:C1470.template.assets.target=Null:C1517)
			
			This:C1470.template.assets.target:="___TABLE___/Detail"  // Default path for detail template resource
			
		End if 
		
		C_OBJECT:C1216($Obj_metaData)
		For each ($Obj_metaData; This:C1470.input.tags.table.fields)
			
			If (Length:C16(String:C10($Obj_metaData.icon))=0)  // no icon defined
				
				// Generate asset using first table letter
				$file:=Folder:C1567(fk resources folder:K87:11).folder("images").file("missingIcon.svg")
				
				If (Asserted:C1132($file.exists; "Missing ressources: "+$file.path))
					
					C_TEXT:C284($Svg_root; $t)
					$Svg_root:=DOM Parse XML source:C719($file.platformPath)
					
					If (Asserted:C1132(OK=1; "Failed to parse: "+$file.path))
						
						$t:=Choose:C955(Bool:C1537(This:C1470.template.shortLabel); $Obj_metaData.shortLabel; $Obj_metaData.label)
						
						Case of 
								
								//……………………………………………………………………………………………………………
							: (Length:C16($t)>0)
								
								// Take first letter
								$t:=Uppercase:C13($t[[1]])
								
								//……………………………………………………………………………………………………………
							: (Length:C16($Obj_metaData.nameIcon)>0)
								
								//%W-533.1
								$t:=Uppercase:C13($Obj_metaData.nameIcon[[1]])
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
								"tags"; New object:C1471("name"; This:C1470.input.tags.table.name+"Detail"+$Obj_metaData.nameIcon); \
								"source"; $file.platformPath; \
								"target"; This:C1470.template.parent.parent.assets.target+Replace string:C233(Process_tags(This:C1470.template.assets.target; This:C1470.input.tags; New collection:C1472("filename")); "/"; Folder separator:K24:12)+Folder separator:K24:12; \
								"format"; This:C1470.template.assets.format; \
								"size"; This:C1470.template.assets.size)))
							
						End if 
					End if 
				End if 
				
			Else   // There is an icon defined
				
				var $Path_icon : 4D:C1709.File
				If (Position:C15("/"; $Obj_metaData.icon)=1)
					
					// Custom icon
					$Path_icon:=$Path_hostRoot.file(Substring:C12($Obj_metaData.icon; 2))
					
				Else 
					
					// Product icon
					$Path_icon:=$Path_root.file($Obj_metaData.icon)
					
				End if 
				
				var $assetResult : Object
				$assetResult:=asset(New object:C1471(\
					"action"; "create"; \
					"type"; "imageset"; \
					"tags"; New object:C1471("name"; This:C1470.input.tags.table.name+"Detail"+$Obj_metaData.nameIcon); \
					"source"; $Path_icon.platformPath; \
					"target"; This:C1470.template.parent.parent.assets.target+Replace string:C233(Process_tags(This:C1470.template.assets.target; This:C1470.input.tags; New collection:C1472("filename")); "/"; Folder separator:K24:12)+Folder separator:K24:12; \
					"format"; This:C1470.template.assets.format; \
					"size"; This:C1470.template.assets.size))
				
				$Obj_out.assets.push($assetResult)
				ob_error_combine($Obj_out; $assetResult)
				
			End if 
		End for each 
		
	End if 