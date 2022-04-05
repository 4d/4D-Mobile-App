Class extends form

// === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705(Formula:C1597(editor_CALLBACK).source)
	
	This:C1470.context:=editor_Panel_init(This:C1470.name)
	
	If (OB Is empty:C1297(This:C1470.context))
		
		This:C1470.isSubform:=True:C214
		
		This:C1470.init()
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
	End if 
	
	This:C1470.numbereFormat:="### ### ### ### ###"
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Design definition
Function init()
	
	var $group : cs:C1710.group
	
	This:C1470.toBeInitialized:=False:C215
	
	// Help URL
	This:C1470.help:=Get localized string:C991("help_properties")
	
	// Table list
	$group:=This:C1470.group("tableGroup")
	This:C1470.listbox("list"; "01_tables").addToGroup($group)
	This:C1470.formObject("listBorder").addToGroup($group)
	This:C1470.formObject("dataSizeLabel").addToGroup($group)
	This:C1470.formObject("tableLabel").addToGroup($group)
	
	// Properties
	$group:=This:C1470.group("properties")
	
	// Filter input assistance
	This:C1470.picture("queryWidget").addToGroup($group)
	
	// Filter box
	This:C1470.input("filter"; "02_filter").addToGroup($group)
	This:C1470.formObject("filterLabel").addToGroup($group)
	This:C1470.formObject("filterBorder").addToGroup($group)
	
	// Options
	This:C1470.button("embedded").bestSize().addToGroup($group)
	This:C1470.button("method").bestSize().addToGroup($group)
	This:C1470.button("validate").bestSize().addToGroup($group)
	This:C1470.button("enter").addToGroup($group)
	This:C1470.input("result").addToGroup($group)
	
	This:C1470.subform("noDataModel")
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function handleEvents($e : Object)
	
	If ($e.objectName=Null:C1517)  // <== FORM METHOD
		
		$e:=panel_Common(On Load:K2:1; On Timer:K2:25)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Load:K2:1)
				
				This:C1470.onLoad()
				
				//______________________________________________________
			: ($e.code=On Timer:K2:25)
				
				This:C1470.update()
				
				//______________________________________________________
		End case 
		
	Else   // <== WIDGETS METHOD
		
		Case of 
				
				//==============================================
			: (This:C1470.filter.catch())
				
				This:C1470.doFilter($e)
				
				//==============================================
			: (This:C1470.list.catch())
				
				This:C1470.doList($e)
				
				//==============================================
			: (This:C1470.method.catch($e; On Clicked:K2:4))
				
				EDITOR.editAuthenticationMethod()
				
				//==============================================
			: (This:C1470.validate.catch($e; On Clicked:K2:4))\
				 | (This:C1470.enter.catch($e; On Clicked:K2:4))
				
				This:C1470.list.focus()
				
				This:C1470.doValidateFilter()
				
				//==============================================
			: (This:C1470.embedded.catch($e; On Clicked:K2:4))
				
				var $table : cs:C1710.table
				$table:=This:C1470.current
				
				If (Bool:C1537($table.embedded))
					
					Form:C1466.dataModel[String:C10($table.tableNumber)][""].embedded:=True:C214
					
				Else 
					
					OB REMOVE:C1226(Form:C1466.dataModel[String:C10($table.tableNumber)][""]; "embedded")
					
				End if 
				
				PROJECT.save()
				This:C1470.update()
				
				//==============================================
			: (This:C1470.queryWidget.catch($e; On Clicked:K2:4))
				
				This:C1470.doQueryWidget()
				
				//________________________________________
		End case 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Initializations at loading
Function onLoad()
	
	This:C1470.list.setScrollbars(False:C215; 2)
	
	// Get/update the table list
	This:C1470.tableList()
	
	If (This:C1470.tables.length>0)
		
		This:C1470.tableGroup.show()
		This:C1470.noDataModel.hide()
		
	Else 
		
		This:C1470.lastIndex:=0
		
		This:C1470.tableGroup.hide()
		This:C1470.noDataModel.show()
		
	End if 
	
	// Init the query widget
	var $t : Text
	If (EDITOR.darkScheme)
		
		$t:=File:C1566("/RESOURCES/queryWidget_dark.svg").getText()
		
	Else 
		
		$t:=File:C1566("/RESOURCES/queryWidget.svg").getText()
		
	End if 
	
	PROCESS 4D TAGS:C816($t; $t; \
		EDITOR.selectedFillColor; \
		Get localized string:C991("fields"); \
		Get localized string:C991("comparators"); \
		Get localized string:C991("operators"); \
		"🢓")
	
	This:C1470.queryWidget.setValue(cs:C1710.svg.new($t).picture())
	
	If (PROJECT.iOS() & PROJECT.android())
		
		This:C1470.dataSizeLabel.title:=This:C1470.dataSizeLabel.title+" (iOS / Android)"
		
	End if 
	
	This:C1470.update()
	
	This:C1470.list.focus()
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Update of the user interface
Function update()
	
	androidLimitations(False:C215; "")
	
	This:C1470.properties.enable(Not:C34(PROJECT.isLocked()))
	
	// Select the last used table or the first one if none
	This:C1470.list.doSafeSelect(Choose:C955(Num:C11(This:C1470.lastIndex)=0; 1; Num:C11(This:C1470.lastIndex)))
	
	If (PROJECT.iOS())
		
		This:C1470.sqlite:=Null:C1517
		This:C1470.callWorker(Formula:C1597(getSQLite).source; New object:C1471(\
			"caller"; This:C1470.window; \
			"project"; PROJECT))
		
	End if 
	
	If (PROJECT.android())
		
		This:C1470.datasetAndroid:=Null:C1517
		This:C1470.callWorker(Formula:C1597(getAndroidDataset).source; New object:C1471(\
			"caller"; This:C1470.window; \
			"project"; PROJECT))
		
	End if 
	
	If (This:C1470.current=Null:C1517)
		
		This:C1470.properties.hide()
		
	Else 
		
		This:C1470.properties.show()
		This:C1470.method.hide()
		This:C1470.queryWidget.show(This:C1470.filter.isFocused())
		This:C1470.filter.setColors(Foreground color:K23:1)
		
		OB REMOVE:C1226(This:C1470.current; "user")
		
		This:C1470.result.setValue("").setColors(EDITOR.selectedFillColor).show()
		
		This:C1470.displayFilter(This:C1470.current)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Get/update the list of published tables
Function tableList()
	
	var $table : Object
	var $c : Collection
	
	$c:=PROJECT.publishedTables()
	
	If (This:C1470.tables=Null:C1517)
		
		This:C1470.tables:=$c
		
	Else 
		
		// Update the table list if any
		If ($c.length>0)
			
			For each ($table; $c)
				
				If (This:C1470.tables.query("tableNumber = :1"; Num:C11($table.tableNumber)).pop()=Null:C1517)
					
					// Add the table
					This:C1470.tables.push($table)
					
				End if 
			End for each 
			
			For each ($table; This:C1470.tables)
				
				If ($c.query("tableNumber = :1"; Num:C11($table.tableNumber)).pop()=Null:C1517)
					
					// Mark to remove
					$table.toRemove:=True:C214
					
				End if 
			End for each 
			
			This:C1470.tables:=This:C1470.tables.query("toRemove = null")
			
		Else 
			
			This:C1470.tables:=$c
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function updateTableListWithDataSizes()
	
	var $sqlID; $tableName : Text
	var $size : Integer
	var $table : Object
	var $file : 4D:C1709.File
	
	For each ($table; This:C1470.tables)
		
		If (Length:C16(String:C10($table.filter.string))>0)
			
			$table.filterIcon:=Choose:C955(Bool:C1537($table.filter.parameters); EDITOR.userIcon; EDITOR.filterIcon)
			
		End if 
		
		If (Bool:C1537($table.embedded))\
			 & (Not:C34(Bool:C1537($table.filter.parameters)))
			
			If (Feature.with("androidDataSet"))
				
				$tableName:=formatString("table-name"; $table.name)
				
				Case of 
						
						//______________________________________________________
					: (PROJECT.allTargets())
						
						$table.dumpSize:=This:C1470.iosDumpTableSize($tableName)+" / "+This:C1470.androidDumpTableSize($tableName)
						
						//______________________________________________________
					: (PROJECT.iOS())
						
						$table.dumpSize:=This:C1470.iosDumpTableSize($tableName)
						
						//______________________________________________________
					: (PROJECT.android())
						
						$table.dumpSize:=This:C1470.androidDumpTableSize($tableName)
						
						//______________________________________________________
				End case 
				
			Else 
				
				If (This:C1470.sqlite#Null:C1517)
					
					$table.dumpSize:=This:C1470.iosDumpTableSize($tableName)
					
				Else 
					
					$file:=PROJECT._folder.file("project.dataSet/Resources/Assets.xcassets/Data/"+$table.name+".dataset/"+$table.name+".data.json")
					
					If ($file.exists)
						
						// Get document size
						$size:=$file.size
						
						// Add pictures size if any
						$file:=PROJECT._folder.file("Resources/Assets.xcassets/Pictures/"+$table.name+"/manifest.json")
						
						If ($file.exists)
							
							$size:=$size+JSON Parse:C1218($file.getText()).contentSize
							
						End if 
						
						$table.dumpSize:=doc_bytesToString($size)
						
					Else 
						
						$table.dumpSize:=Get localized string:C991("notAvailable")
						
					End if 
				End if 
			End if 
		End if 
	End for each 
	
	// Redraw
	This:C1470.list.touch()
	
	//panel("SOURCE").updateDataSet()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function androidDumpTableSize($tableName) : Text
	
	var $size : Integer
	var $file : 4D:C1709.File
	
	If (This:C1470.datasetAndroid=Null:C1517)\
		 || (This:C1470.datasetAndroid.tables=Null:C1517)\
		 || (This:C1470.datasetAndroid.tables[$tableName]=Null:C1517)
		
		return ("#NA")
		
	End if 
	
	$size:=Num:C11(This:C1470.datasetAndroid.tables[$tableName])  // Size of the data dump
	
	If ($size>4096)
		
		// Add pictures size if any
		$file:=PROJECT._folder.file("project.dataSet/Resources/Assets.xcassets/Pictures/"+$tableName+"/manifest.json")
		
		If ($file.exists)
			
			$size:=$size+Num:C11(JSON Parse:C1218($file.getText()).contentSize)
			
		End if 
	End if 
	
	return (doc_bytesToString($size))
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function iosDumpTableSize($tableName) : Text
	
	var $size : Integer
	var $file : 4D:C1709.File
	
	If (This:C1470.sqlite=Null:C1517)\
		 || (This:C1470.sqlite.tables=Null:C1517)\
		 || (This:C1470.sqlite.tables["Z"+Uppercase:C13($tableName)]=Null:C1517)
		
		return ("#NA")
		
	End if 
	
	$size:=Num:C11(This:C1470.sqlite.tables["Z"+Uppercase:C13($tableName)])  // Size of the data dump
	
	If ($size>4096)
		
		// Add pictures size if any
		$file:=PROJECT._folder.file("project.dataSet/Resources/Assets.xcassets/Pictures/"+$tableName+"/manifest.json")
		
		If ($file.exists)
			
			$size:=$size+Num:C11(JSON Parse:C1218($file.getText()).contentSize)
			
		End if 
	End if 
	
	return (doc_bytesToString($size))
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Display filter status
Function displayFilter($table : Object)
	
	var $Comment : Text
	var $filter; $rest : Object
	
	$filter:=$table.filter
	
	Case of 
			
			//______________________________________________________
		: (Length:C16(String:C10($filter.string))=0)  // No filter
			
			$table.filterIcon:=Null:C1517
			
			If ($table.total=Null:C1517)
				
				If (PROJECT.dataSource.source="server")
					
					$rest:=Rest(New object:C1471(\
						"action"; "records"; \
						"table"; $table.name; \
						"url"; This:C1470.server.urls.production; \
						"handler"; "mobileapp"))
					
					If ($rest.success)
						
						If ($rest.__COUNT#Null:C1517)
							
							$table.total:=Num:C11($rest.__COUNT)
							
						End if 
					End if 
					
				Else 
					
					$table.total:=ds:C1482[$table.name].all().length
					
				End if 
			End if 
			
			If ($table.total=Null:C1517)
				
				If (Bool:C1537($table.embedded))
					
					$Comment:=EDITOR.str.localize("allDataEmbedded")
					
				Else 
					
					$Comment:=EDITOR.str.localize("allDataLoaded")
					
				End if 
				
			Else 
				
				If ($table.total=0)
					
					If (Bool:C1537($table.embedded))
						
						$Comment:=EDITOR.str.localize("noEntityToEmbed")
						
					Else 
						
						$Comment:=EDITOR.str.localize("noEntityToLoad")
						
					End if 
					
				Else 
					
					If ($table.total>100000)
						
						This:C1470.result.setColors(EDITOR.warningColor)
						
						If (Bool:C1537($table.embedded))
							
							$Comment:=EDITOR.str.localize("largeNumberOfEntitiesToEmbed")
							
						Else 
							
							$Comment:=EDITOR.str.localize("largeNumberOfEntitiesToLoad")
							
						End if 
						
					Else 
						
						If (Bool:C1537($table.embedded))
							
							$Comment:=EDITOR.str.localize("entitiesToEmbed"; String:C10($table.total; This:C1470.numbereFormat))
							
						Else 
							
							$Comment:=EDITOR.str.localize("entitiesToLoad"; String:C10($table.total; This:C1470.numbereFormat))
							
						End if 
					End if 
				End if 
			End if 
			
			//______________________________________________________
		: (Length:C16(String:C10($filter.error))>0)  // With errors
			
			This:C1470.filter.setColors(EDITOR.errorColor)
			This:C1470.result.setColors(EDITOR.errorColor)
			
			$Comment:=EDITOR.str.localize("error:")+$filter.error
			
			//______________________________________________________
		: (Not:C34(Bool:C1537($filter.validated)))  // Not validated
			
			This:C1470.filter.setColors(EDITOR.errorColor)
			This:C1470.result.setColors(EDITOR.errorColor)
			
			$Comment:=EDITOR.str.localize("notValidatedFilter")
			
			//______________________________________________________
		Else 
			
			$filter.parameters:=(Match regex:C1019("(?m-si)(?:=|==|===|IS|!=|#|!==|IS NOT|>|<|>=|<=|%)\\s*:"; $filter.string; 1))
			
			If (Bool:C1537($filter.parameters))
				
				$table.filterIcon:=EDITOR.userIcon
				
				This:C1470.embedded.hide()
				This:C1470.method.show()
				
				$Comment:=EDITOR.str.localize("dataFilteringByUser")
				
			Else 
				
				If ($table.count=Null:C1517)
					
					If (Bool:C1537($table.embedded))
						
						$Comment:=EDITOR.str.localize("dataEmbedded")
						
					Else 
						
						$Comment:=EDITOR.str.localize("dataLoaded")
						
					End if 
					
				Else 
					
					If ($table.count=0)
						
						If (Bool:C1537($table.embedded))
							
							$Comment:=EDITOR.str.localize("noEntityToEmbed")
							
						Else 
							
							$Comment:=EDITOR.str.localize("noEntityToLoad")
							
						End if 
						
					Else 
						
						If (Bool:C1537($table.embedded))
							
							If ($table.count>100000)
								
								This:C1470.result.setColors(EDITOR.warningColor)
								$Comment:=EDITOR.str.localize("largeNumberOfEntitiesToEmbed")
								
							Else 
								
								$Comment:=EDITOR.str.localize("entitiesEmbeddedUponConnection"; New collection:C1472(String:C10($table.count; This:C1470.numbereFormat); String:C10($table.total; This:C1470.numbereFormat)))
								
							End if 
							
						Else 
							
							If ($table.count>100000)
								
								This:C1470.result.setColors(EDITOR.warningColor)
								$Comment:=EDITOR.str.localize("largeNumberOfEntitiesToLoad")
								
							Else 
								
								$Comment:=EDITOR.str.localize("entitiesLoadedUponConnection"; New collection:C1472(String:C10($table.count; This:C1470.numbereFormat); String:C10($table.total; This:C1470.numbereFormat)))
								
							End if 
						End if 
					End if 
				End if 
			End if 
			
			//______________________________________________________
	End case 
	
	This:C1470.result.setValue($Comment)
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Table list script
Function doList($e : Object)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Getting Focus:K2:7)
			
			This:C1470.list.setColors(Foreground color:K23:1)
			This:C1470.listBorder.setColors(EDITOR.selectedColor)
			
			//______________________________________________________
		: ($e.code=On Losing Focus:K2:8)
			
			This:C1470.list.setColors(Foreground color:K23:1)
			This:C1470.listBorder.setColors(EDITOR.backgroundUnselectedColor)
			This:C1470.tables:=This:C1470.tables
			
			//______________________________________________________
		: ($e.code=On Selection Change:K2:29)
			
			This:C1470.lastIndex:=This:C1470.index
			This:C1470.current:=Choose:C955(This:C1470.index=0; Null:C1517; This:C1470.tables[This:C1470.index-Num:C11(This:C1470.index>0)])
			
			This:C1470.refresh()
			
			//______________________________________________________
		: ($e.code=On Mouse Enter:K2:33)
			
			// _o_UI.tips.enable()
			// _o_UI.tips.instantly()
			
			//______________________________________________________
		: ($e.code=On Mouse Move:K2:35)
			
			// Set tips
			
			//______________________________________________________
		: ($e.code=On Mouse Leave:K2:34)
			
			// _o_UI.tips.defaultDelay()
			
			//______________________________________________________
		: (PROJECT.isLocked())
			
			// <NOTHING MORE TO DO>
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Filter input script
Function doFilter($e : Object)
	
	var $t : Text
	var $meta; $table : Object
	
	$table:=This:C1470.current
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Getting Focus:K2:7)
			
			This:C1470.filterBorder.setColors(EDITOR.selectedColor)
			
			If ($table.filter=Null:C1517)
				
				$table.filter:=New object:C1471(\
					"string"; "")
				
				$table.validated:=False:C215
				
			End if 
			
			// Keep current filter definition
			This:C1470.currentFilter:=OB Copy:C1225($table.filter)
			
			This:C1470.refresh()
			
			//______________________________________________________
		: ($e.code=On Losing Focus:K2:8)
			
			This:C1470.filterBorder.setColors(EDITOR.backgroundUnselectedColor)
			
			This:C1470.refresh()
			
			//______________________________________________________
		: (PROJECT.isLocked())
			
			// <NOTHING MORE TO DO>
			
			//______________________________________________________
		: ($e.code=On Data Change:K2:15)
			
			This:C1470.refresh()
			
			//______________________________________________________
		: ($e.code=On After Edit:K2:43)
			
			$t:=Get edited text:C655
			
			$meta:=Form:C1466.dataModel[String:C10($table.tableNumber)][""]
			
			If (Value type:C1509($meta.filter)#Is object:K8:27)
				
				$meta.filter:=New object:C1471
				
			End if 
			
			If (Length:C16($t)>0)
				
				$meta.filter.string:=$t
				
				If ($t#This:C1470.currentFilter.string)
					
					$meta.filter.validated:=False:C215
					$meta.filter.parameters:=False:C215
					OB REMOVE:C1226($meta.filter; "error")
					
				Else 
					
					$meta.filter.validated:=This:C1470.currentFilter.validated
					$meta.filter.parameters:=This:C1470.currentFilter.parameters
					
					If (This:C1470.currentFilter.error#Null:C1517)
						
						$meta.filter.error:=This:C1470.currentFilter.error
						$meta.filter.errors:=This:C1470.currentFilter.errors
						
					Else 
						
						OB REMOVE:C1226($meta.filter; "error")
						
					End if 
				End if 
				
				$table.filter:=$meta.filter
				
			Else 
				
				$table.filter.string:=""
				OB REMOVE:C1226($meta; "filter")
				
			End if 
			
			PROJECT.save()
			
			This:C1470.refresh()
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Validate button script
Function doValidateFilter()
	
	If (PROJECT.dataSource.source="server")
		
		PROJECT.checkRestQueryFilter(This:C1470.current)
		
	Else 
		
		PROJECT.checkLocalQueryFilter(This:C1470.current)
		
	End if 
	
	PROJECT.save()
	
	This:C1470.refresh()
	
	PROJECT.audit(New object:C1471(\
		"target"; New collection:C1472("filters")))
	
	EDITOR.updateRibbon()
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Filter input assistance widget script
Function doQueryWidget()
	
	var $ID : Text
	var $withInsertion : Boolean
	var $catalog; $field; $highligh; $table : Object
	var $menu : cs:C1710.menu
	var $str : cs:C1710.str
	
	$ID:=SVG Find element ID by coordinates:C1054(*; This:C1470.queryWidget.name; MOUSEX; MOUSEY)
	$table:=This:C1470.current
	
	$menu:=cs:C1710.menu.new()
	
	If (Length:C16($ID)#0)
		
		Case of 
				
				//……………………………………………………………………………………………………………………………
			: ($ID="fields")
				
				$catalog:=catalog("fields"; New object:C1471(\
					"tableName"; $table.name))
				
				If ($catalog.success)
					
					For each ($field; $catalog.fields)
						
						If (Position:C15(" "; $field.path)>0)
							
							$menu.append($field.path; "'"+$field.path+"'")
							
						Else 
							
							$menu.append($field.path; $field.path)
							
						End if 
						
						If (EDITOR.darkScheme)
							
							$menu.icon("Images/dark/fieldsIcons/field_"+String:C10($field.typeLegacy; "00")+".png")
							
						Else 
							
							$menu.icon("Images/light/fieldsIcons/field_"+String:C10($field.typeLegacy; "00")+".png")
							
						End if 
					End for each 
				End if 
				
				//……………………………………………………………………………………………………………………………
			: ($ID="comparator")
				
				$menu.append(":xliff:equalTo"; "= ")
				$menu.append(":xliff:notEqualTo"; "!= ")
				$menu.line()
				
				$menu.append("IS"; "=== ")
				$menu.append("IS NOT"; "!== ")
				$menu.line()
				
				$menu.append(":xliff:lessThan"; "< ")
				$menu.append(":xliff:greaterThan"; "> ")
				$menu.line()
				
				$menu.append(":xliff:lessThanOrEqualTo"; "<= ")
				$menu.append(":xliff:greaterThanOrEqualTo"; ">= ")
				$menu.line()
				
				$menu.append(":xliff:containsKeyword"; "% ")
				
				//……………………………………………………………………………………………………………………………
			: ($ID="operator")
				
				$menu.append("AND"; "& ")
				$menu.append("OR"; "| ")
				$menu.line()
				
				$menu.append("NOT"; "NOT({sel})")
				$menu.line()
				
				$menu.append("(…)"; "NOT(({sel}))")
				
				//……………………………………………………………………………………………………………………………
		End case 
		
		$menu.popup()
		
		If ($menu.selected)
			
			$highligh:=This:C1470.filter.highlighted()
			$withInsertion:=(Position:C15("{sel}"; $menu.choice)>0)
			
			If ($withInsertion)
				
				$menu.choice:=Replace string:C233($menu.choice; "{sel}"; $highligh.selection)
				
			End if 
			
			If ($highligh.noSelection)\
				 & ($highligh.start#1)
				
				//%W-533.2
				If (String:C10($table.filter.string)[[$highligh.start-1]]#" ")\
					 & (String:C10($table.filter.string)[[$highligh.start-1]]#"(")
					
					$table.filter.string:=$table.filter.string+" "
					$highligh.start:=$highligh.start+1
					$highligh.end:=$highligh.end+1
					
				End if 
				//%W+533.2
			End if 
			
			$table.filter.validated:=False:C215
			
			$str:=EDITOR.str.setText(String:C10($table.filter.string)).insert($menu.choice; $highligh.start; $highligh.end)
			$table.filter.string:=$str.value
			
			Form:C1466.dataModel[String:C10($table.tableNumber)][""].filter:=$table.filter
			
			If ($withInsertion)\
				 & ($highligh.withSelection)
				
				// Put the carret into
				//$str.begin:=$str.end-1
				$str.end:=$str.end-1
				
			End if 
			
			This:C1470.filter.highlight($str.end; $str.end)
			
			This:C1470.filter.focus()
			
			PROJECT.save()
			This:C1470.refresh()
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Table list background color expression
Function backgoundColor($current : Object)->$color
	
	If (This:C1470.current=Null:C1517)
		
		$color:="transparent"
		
	Else 
		
		var $selected : Boolean
		$selected:=This:C1470.list.isFocused()
		
		If (This:C1470.current.name=$current.name)
			
			$color:=Choose:C955($selected; EDITOR.backgroundSelectedColor; EDITOR.alternateSelectedColor)
			
		Else 
			
			var $backgroundColor
			$backgroundColor:=Choose:C955($selected; EDITOR.highlightColor; EDITOR.highlightColorNoFocus)
			$color:=Choose:C955($selected; $backgroundColor; "transparent")
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Table list meta info expression
Function metaInfo($current : Object)->$meta
	
	// Default values
	$meta:=New object:C1471(\
		"stroke"; Choose:C955(EDITOR.darkScheme; "white"; "black"); \
		"fontWeight"; "normal"; \
		"cell"; New object:C1471(\
		"table_names"; New object:C1471))
	
	If (Bool:C1537($current.embedded))\
		 & Not:C34(Bool:C1537($current.filter.parameters))
		
		$meta.cell.table_names.fontWeight:="bold"
		
	End if 
	
	If ($current.filter#Null:C1517)
		
		If (Length:C16(String:C10($current.filter.string))>0)
			
			If (Not:C34(Bool:C1537($current.filter.validated)))
				
				$meta.cell.table_names.stroke:=EDITOR.errorRGB
				
			End if 
		End if 
	End if 