Class extends FormTemplate

Class constructor
	C_OBJECT:C1216($1)
	Super:C1705($1)
	ASSERT:C1129(This:C1470.template.type="navigation")
	
Function doRun
	C_OBJECT:C1216($0; $Obj_out)
	$Obj_out:=Super:C1706.doRun()  // copy files
	
	C_OBJECT:C1216($Obj_template)
	$Obj_template:=This:C1470.template
	
	// Get navigation tables as tag
	This:C1470.input.tags.navigationTables:=dataModel(New object:C1471(\
		"action"; "tableCollection"; \
		"dataModel"; This:C1470.input.project.dataModel; \
		"tag"; True:C214; \
		"tables"; This:C1470.input.project.main.order)).tables
	
	// Compute table row height, not very responsive. Check if possible with storyboard
	C_LONGINT:C283($i)
	$i:=This:C1470.input.tags.navigationTables.length
	
	Case of 
			
			//……………………………………………………………………………………
		: ($i>10)
			
			This:C1470.input.tags.navigationRowHeight:="-1"  // https://developer.apple.com/documentation/uikit/uitableviewautomaticdimension
			
			//……………………………………………………………………………………
		: ($i<3)
			
			This:C1470.input.tags.navigationRowHeight:="300"
			
			//……………………………………………………………………………………
		: ($i<4)
			
			This:C1470.input.tags.navigationRowHeight:="200"
			
			//……………………………………………………………………………………
		Else 
			
			This:C1470.input.tags.navigationRowHeight:=String:C10(100+(100/$i))
			
			//……………………………………………………………………………………
	End case 
	
	C_OBJECT:C1216($Obj_result)
	$Obj_result:=This:C1470.createIconAssets()
	ob_error_combine($Obj_out; $Obj_result)
	
	$Obj_out.tags:=New object:C1471(\
		"navigationTables"; This:C1470.input.tags.navigationTables)  // Tag to transmit
	
	// Modify storyboards with navigation tables
	$Obj_out.storyboard:=This:C1470.storyboard().run(This:C1470.template; Folder:C1567(This:C1470.input.path; fk platform path:K87:2); This:C1470.input.tags)
	
	If (Not:C34($Obj_out.storyboard.success))
		
		$Obj_out.success:=False:C215
		
		ob_error_combine($Obj_out; $Obj_out.storyboard; "Storyboard for navigation template failed")
		
	End if 
	
	$0:=$Obj_out
	
Function createIconAssets
	C_OBJECT:C1216($Obj_out; $0)
	$Obj_out:=New object:C1471()
	
	// need asset?
	C_BOOLEAN:C305($Boo_withIcons)
	$Boo_withIcons:=Bool:C1537(This:C1470.template.assets.mandatory)\
		 | (This:C1470.input.tags.navigationTables.query("icon != ''").length>0)
	
	C_OBJECT:C1216($Obj_table)
	For each ($Obj_table; This:C1470.input.tags.navigationTables)
		
		If ($Boo_withIcons)
			
			$Obj_table.labelAlignment:="left"
			Case of 
				: (Length:C16(String:C10($Obj_table.originalName)>0))
					$Obj_table.navigationIcon:="Main"+$Obj_table.originalName
				: ($Obj_table[""]#Null:C1517)
					$Obj_table.navigationIcon:="Main"+$Obj_table[""].name
				Else 
					$Obj_table.navigationIcon:="Main"+$Obj_table.name
			End case 
			
		Else 
			
			$Obj_table.labelAlignment:="center"
			$Obj_table.navigationIcon:=""
			
		End if 
	End for each 
	
	If ($Boo_withIcons)
		
		$Obj_out.assets:=New collection:C1472  // result of asset operations
		
		C_OBJECT:C1216($Path_root; $Path_hostRoot)
		$Path_root:=COMPONENT_Pathname("fieldIcons")
		$Path_hostRoot:=COMPONENT_Pathname("host_fieldIcons")
		
		C_OBJECT:C1216($Obj_table)
		For each ($Obj_table; This:C1470.input.tags.navigationTables)
			
			C_OBJECT:C1216($Obj_metaData)
			$Obj_metaData:=$Obj_table[""]
			
			If (Length:C16(String:C10($Obj_metaData.icon))=0)  // no icon defined
				
				If ($Obj_metaData.shortLabel#Null:C1517)
					
					// Generate asset using first table letter
					var $file : 4D:C1709.File
					$file:=File:C1566("/RESOURCES/Images/missingIcon.svg")
					
					var $svg : cs:C1710.svg
					$svg:=cs:C1710.svg.new($file)
					
					If (Asserted:C1132($svg.success; "Failed to parse: "+$file.path))
						
						var $t : Text
						$t:=Choose:C955(Bool:C1537(This:C1470.template.shortLabel); $Obj_metaData.shortLabel; $Obj_metaData.label)
						
						If (Length:C16($t)>0)
							
							// Take first letter
							$t:=Uppercase:C13($t[[1]])
							
						Else 
							
							//%W-533.1
							$t:=Uppercase:C13($Obj_metaData.name[[1]])  // 4D table names are not empty
							//%W+533.1
							
						End if 
						
						$svg.setValue($t; $svg.findByXPath("/svg/textArea"))
						
						$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(This:C1470.input.project.product.bundleIdentifier+".svg")
						$file.delete()
						
						$svg.exportText($file)
						
						$o:=asset(New object:C1471(\
							"action"; "create"; \
							"type"; "imageset"; \
							"tags"; New object:C1471("name"; "Main"+$Obj_metaData.name); \
							"source"; $file.platformPath; \
							"target"; This:C1470.template.parent.assets.target+This:C1470.template.assets.target+Folder separator:K24:12; \
							"format"; This:C1470.template.assets.format; \
							"size"; This:C1470.template.assets.size\
							))
						
						$Obj_out.assets.push($o)
						ob_error_combine($Obj_out; $o)
						
					End if 
				End if 
				
			Else 
				
				C_OBJECT:C1216($Path_icon)
				If (Position:C15("/"; $Obj_metaData.icon)=1)
					
					// User icon
					$Path_icon:=$Path_hostRoot.file(Substring:C12($Obj_metaData.icon; 2))
					
				Else 
					
					$Path_icon:=$Path_root.file($Obj_metaData.icon)
					
				End if 
				
				C_OBJECT:C1216($o)
				$o:=asset(New object:C1471(\
					"action"; "create"; \
					"type"; "imageset"; \
					"tags"; New object:C1471("name"; "Main"+$Obj_metaData.name); \
					"source"; $Path_icon.platformPath; \
					"target"; This:C1470.template.parent.assets.target+This:C1470.template.assets.target+Folder separator:K24:12; \
					"format"; This:C1470.template.assets.format; \
					"size"; This:C1470.template.assets.size))
				
				$Obj_out.assets.push($o)
				ob_error_combine($Obj_out; $o)
				
			End if 
			
		End for each 
		
	End if 
	
	$0:=$Obj_out
	
Function storyboard
	C_OBJECT:C1216($0)
	$0:=cs:C1710.NavigationStoryboard.new()