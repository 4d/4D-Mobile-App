Class extends FormTemplate

Class constructor
	C_OBJECT:C1216($1)
	Super:C1705($1)
	ASSERT:C1129(This:C1470.template.type="navigation")
	
Function secondPass
	C_OBJECT:C1216($0)
	C_OBJECT:C1216($Obj_out)
	$Obj_out:=New object:C1471()
	
	C_OBJECT:C1216($Obj_in; $Obj_template)
	$Obj_in:=This:C1470.input
	$Obj_template:=This:C1470.template
	
	// Get navigation tables as tag
	$Obj_in.tags.navigationTables:=dataModel(New object:C1471(\
		"action"; "tableCollection"; \
		"dataModel"; $Obj_in.project.dataModel; \
		"tag"; True:C214; \
		"tables"; $Obj_in.project.main.order)).tables
	
	// Compute table row height, not very responsive. Check if possible with storyboard
	C_LONGINT:C283($i)
	$i:=$Obj_in.tags.navigationTables.length
	
	Case of 
			
			//……………………………………………………………………………………
		: ($i>10)
			
			$Obj_in.tags.navigationRowHeight:="-1"  // https://developer.apple.com/documentation/uikit/uitableviewautomaticdimension
			
			//……………………………………………………………………………………
		: ($i<3)
			
			$Obj_in.tags.navigationRowHeight:="300"
			
			//……………………………………………………………………………………
		: ($i<4)
			
			$Obj_in.tags.navigationRowHeight:="200"
			
			//……………………………………………………………………………………
		Else 
			
			$Obj_in.tags.navigationRowHeight:=String:C10(100+(100/$i))
			
			//……………………………………………………………………………………
	End case 
	
	// need asset?
	C_BOOLEAN:C305($Boo_withIcons)
	$Boo_withIcons:=Bool:C1537($Obj_template.assets.mandatory)\
		 | ($Obj_in.tags.navigationTables.query("icon != ''").length>0)
	
	C_OBJECT:C1216($Obj_table)
	For each ($Obj_table; $Obj_in.tags.navigationTables)
		
		If ($Boo_withIcons)
			
			$Obj_table.labelAlignment:="left"
			$Obj_table.navigationIcon:="Main"+$Obj_table.name
			
		Else 
			
			$Obj_table.labelAlignment:="center"
			$Obj_table.navigationIcon:=""
			
		End if 
	End for each 
	
	// Modify storyboards with navigation tables
	$Obj_out.storyboard:=storyboard(New object:C1471(\
		"action"; "navigation"; \
		"template"; $Obj_template; \
		"target"; $Obj_in.path; \
		"tags"; $Obj_in.tags\
		))
	
	If (Not:C34($Obj_out.storyboard.success))
		
		$Obj_out.success:=False:C215
		
		ob_error_combine($Obj_out; $Obj_out.storyboard; "Storyboard for navigation template failed")
		
	End if 
	
	If ($Boo_withIcons)
		
		C_OBJECT:C1216($Path_root; $Path_hostRoot)
		$Path_root:=COMPONENT_Pathname("fieldIcons")
		$Path_hostRoot:=COMPONENT_Pathname("host_fieldIcons")
		
		// If avigation need asset, create it
		$Obj_out.assets:=New collection:C1472  // result of asset operations
		
		For each ($Obj_table; $Obj_in.tags.navigationTables)
			
			If (Length:C16(String:C10($Obj_table[""].icon))=0)  // no icon defined
				
				If ($Obj_table[""].shortLabel#Null:C1517)
					
					// Generate asset using first table letter
					C_OBJECT:C1216($file)
					$file:=Folder:C1567(fk resources folder:K87:11).folder("images").file("missingIcon.svg")
					
					If (Asserted:C1132($file.exists; "Missing ressources: "+$file.path))
						
						C_TEXT:C284($Svg_root; $t)
						$Svg_root:=DOM Parse XML source:C719($file.platformPath)
						
						If (Asserted:C1132(OK=1; "Failed to parse: "+$file.path))
							
							$t:=Choose:C955(Bool:C1537($Obj_template.shortLabel); $Obj_table[""].shortLabel; $Obj_table[""].label)
							
							If (Length:C16($t)>0)
								
								// Take first letter
								$t:=Uppercase:C13($t[[1]])
								
							Else 
								
								//%W-533.1
								$t:=Uppercase:C13($Obj_table[""].name[[1]])  // 4D table names are not empty
								//%W+533.1
								
							End if 
							
							DOM SET XML ELEMENT VALUE:C868($Svg_root; "/svg/textArea"; $t)
							
							$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file($Obj_in.project.product.bundleIdentifier+".svg")
							$file.delete()
							
							DOM EXPORT TO FILE:C862($Svg_root; $file.platformPath)
							
							DOM CLOSE XML:C722($Svg_root)
							
							$o:=asset(New object:C1471(\
								"action"; "create"; \
								"type"; "imageset"; \
								"tags"; New object:C1471("name"; "Main"+$Obj_table[""].name); \
								"source"; $file.platformPath; \
								"target"; $Obj_template.parent.assets.target+$Obj_template.assets.target+Folder separator:K24:12; \
								"format"; $Obj_template.assets.format; \
								"size"; $Obj_template.assets.size\
								))
							
							$Obj_out.assets.push($o)
							ob_error_combine($Obj_out; $o)
							
						End if 
					End if 
				End if 
				
			Else 
				
				C_OBJECT:C1216($Path_icon)
				If (Position:C15("/"; $Obj_table[""].icon)=1)
					
					// User icon
					$Path_icon:=$Path_hostRoot.file(Substring:C12($Obj_table[""].icon; 2))
					
				Else 
					
					$Path_icon:=$Path_root.file($Obj_table[""].icon)
					
				End if 
				
				C_OBJECT:C1216($o)
				$o:=asset(New object:C1471(\
					"action"; "create"; \
					"type"; "imageset"; \
					"tags"; New object:C1471("name"; "Main"+$Obj_table[""].name); \
					"source"; $Path_icon.platformPath; \
					"target"; $Obj_template.parent.assets.target+$Obj_template.assets.target+Folder separator:K24:12; \
					"format"; $Obj_template.assets.format; \
					"size"; $Obj_template.assets.size))
				
				$Obj_out.assets.push($o)
				ob_error_combine($Obj_out; $o)
				
			End if 
			
		End for each 
	End if 
	
	$Obj_out.tags:=New object:C1471(\
		"navigationTables"; $Obj_in.tags.navigationTables)  // Tag to transmit
	
	$0:=$Obj_out