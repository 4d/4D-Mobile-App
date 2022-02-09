Class extends FormTemplate

Class constructor($input : Object)
	Super:C1705($input)
	ASSERT:C1129(This:C1470.template.type="navigation")
	
Function storyboard()->$result : Object
	$result:=cs:C1710.NavigationStoryboard.new()
	
Function doRun()->$Obj_out : Object
	$Obj_out:=Super:C1706.doRun()  // copy files
	
	var $Obj_template : Object
	$Obj_template:=This:C1470.template
	
	// Get navigation tables or other items as tag
	If (FEATURE.with("actionsInTabBar"))
		This:C1470._actionsInTabBarProcess()
	Else 
		This:C1470.input.tags.navigationTables:=dataModel(New object:C1471(\
			"action"; "tableCollection"; \
			"dataModel"; This:C1470.input.project.dataModel; \
			"tag"; True:C214; \
			"tables"; This:C1470.input.project.main.order)).tables
	End if 
	
	This:C1470._computeNavigationRowHeight()
	
	var $Obj_result : Object
	$Obj_result:=This:C1470._createIconAssets()
	ob_error_combine($Obj_out; $Obj_result)
	
	// Tag to transmit to other templating processing
	$Obj_out.tags:=New object:C1471(\
		"navigationTables"; This:C1470.input.tags.navigationTables)
	
	// Modify storyboards with navigation tables
	$Obj_out.storyboard:=This:C1470.storyboard().run(This:C1470.template; Folder:C1567(This:C1470.input.path; fk platform path:K87:2); This:C1470.input.tags)
	
	If (Not:C34($Obj_out.storyboard.success))
		
		$Obj_out.success:=False:C215
		ob_error_combine($Obj_out; $Obj_out.storyboard; "Storyboard for navigation template failed")
		
	End if 
	
	$0:=$Obj_out
	
	
	// MARK: - items
Function _actionsInTabBarProcess()
	This:C1470.input.tags.navigationTables:=New collection:C1472
	
	If (This:C1470.input.project.dataModel=Null:C1517)
		This:C1470.errors:=New collection:C1472("Missing `dataModel` property")
		return   // guard
	End if 
	
	var $dataModel; $table : Object
	$dataModel:=This:C1470.input.project.dataModel
	
	var $Col_tables : Collection
	If (Value type:C1509(This:C1470.input.project.main.order)=Is collection:K8:32)
		
		$Col_tables:=This:C1470.input.project.main.order
		
	Else 
		
		// all table in model
		OB GET PROPERTY NAMES:C1232($dataModel; $tTxt_tables)
		$Col_tables:=New collection:C1472()
		ARRAY TO COLLECTION:C1563($Col_tables; $tTxt_tables)
		
	End if 
	
	This:C1470.input.tags.navigationTables:=New collection:C1472
	
	var $navigationItem : Variant
	For each ($navigationItem; $Col_tables)
		
		Case of 
			: (Value type:C1509($navigationItem)=Is text:K8:3)
				
				If ($dataModel[$navigationItem]#Null:C1517)
					
					$table:=OB Copy:C1225($dataModel[$navigationItem])  // to not alter caller
					$table.tableNumber:=Num:C11($navigationItem)
					
					$table.originalName:=$table[""].name
					$table.name:=formatString("table-name"; $table[""].name)
					
					This:C1470.input.tags.navigationTables.push($table)
					
				Else 
					
					// ASSERT(dev_Matrix ) // missing table in model?
					
				End if 
				
			: (Value type:C1509($navigationItem)=Is object:K8:27)
				
				$table:=OB Copy:C1225($navigationItem)  // to not alter caller
				$table[""]:=$table  // to simulate meta data behaviour or table (but must be clean)
				
				// TODO:actionsInTabBar: create items for actions, maybe format according
				This:C1470.input.tags.navigationTables.push($table)
				
		End case 
		
	End for each 
	
	// TODO:actionsInTabBar: create storyboards for each action item
	var $o : Object
	For each ($table; This:C1470.input.tags.navigationTables)
		If ($table.actions#Null:C1517)  //TODO:test:actionsInTabBar:  or any criteria to see if action instead of table
			
			$o:=New object:C1471()
			$o.tags:=New object:C1471("table"; $table)
			$table.tableActions:=$table.actions  // tag ___TABLE_ACTIONS___ (or do a new tag system with only ACTIONS)
			$o:=TemplateInstanceFactory($o).run()  // <================================== RECURSIVE
			// XXX errors?
			
		End if 
	End for each 
	
	
	// Compute table row height, not very responsive. Check if possible with storyboard
Function _computeNavigationRowHeight()
	var $numberOfTabBarItems : Integer
	$numberOfTabBarItems:=This:C1470.input.tags.navigationTables.length
	
	Case of 
			
			//……………………………………………………………………………………
		: ($numberOfTabBarItems>10)
			
			This:C1470.input.tags.navigationRowHeight:="-1"  // https://developer.apple.com/documentation/uikit/uitableviewautomaticdimension
			
			//……………………………………………………………………………………
		: ($numberOfTabBarItems<3)
			
			This:C1470.input.tags.navigationRowHeight:="300"
			
			//……………………………………………………………………………………
		: ($numberOfTabBarItems<4)
			
			This:C1470.input.tags.navigationRowHeight:="200"
			
			//……………………………………………………………………………………
		Else 
			
			This:C1470.input.tags.navigationRowHeight:=String:C10(100+(100/$numberOfTabBarItems))
			
			//……………………………………………………………………………………
	End case 
	
Function _createIconAssets()->$Obj_out : Object
	$Obj_out:=New object:C1471()
	
	// need asset?
	var $Boo_withIcons : Boolean
	$Boo_withIcons:=Bool:C1537(This:C1470.template.assets.mandatory)\
		 | (This:C1470.input.tags.navigationTables.query("icon != ''").length>0)
	
	var $Obj_table; $Obj_metaData : Object
	For each ($Obj_table; This:C1470.input.tags.navigationTables)
		
		If ($Boo_withIcons)
			
			$Obj_table.labelAlignment:="left"
			Case of 
				: (Length:C16(String:C10($Obj_table.originalName))>0)
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
		
		var $Path_root; $Path_hostRoot : Object
		If (FEATURE.with("actionsInTabBar"))
			$Path_root:=This:C1470.path.new().fieldIcons()
			$Path_hostRoot:=This:C1470.path.new().hostIcons()
		Else 
			$Path_root:=_o_COMPONENT_Pathname("fieldIcons")
			$Path_hostRoot:=_o_COMPONENT_Pathname("host_fieldIcons")
		End if 
		
		For each ($Obj_table; This:C1470.input.tags.navigationTables)
			
			$Obj_metaData:=$Obj_table[""]
			// TODO:actionsInTabBar: maybe info not in a subMetadata node here
			
			
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
				
				var $Path_icon : Object
				If (Position:C15("/"; $Obj_metaData.icon)=1)
					
					// User icon
					$Path_icon:=$Path_hostRoot.file(Substring:C12($Obj_metaData.icon; 2))
					
				Else 
					
					$Path_icon:=$Path_root.file($Obj_metaData.icon)
					
				End if 
				
				var $o : Object
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
	