Class extends panel

// === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705(Formula:C1597(editor_CALLBACK).source)
	
	This:C1470.context:=Super:C1706.init()
	
	If (OB Is empty:C1297(This:C1470.context))
		
		This:C1470.init()
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
	End if 
	
	This:C1470.numbereFormat:="### ### ### ### ###"
	
	This:C1470.datasetAndroid:=Null:C1517
	This:C1470.sqlite:=Null:C1517
	
	This:C1470.sourceLink:=Formula:C1597(panel("SOURCE"))
	
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
	
	This:C1470.formObject("dumpSize")
	
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
	/// Events handler
Function handleEvents($e : Object)
	
	If ($e.objectName=Null:C1517)  // <== FORM METHOD
		
		$e:=Super:C1706.handleEvents(On Load:K2:1; On Timer:K2:25)
		
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
				
				This:C1470.filterManager($e)
				
				//==============================================
			: (This:C1470.list.catch())
				
				This:C1470.tableListManager($e)
				
				//==============================================
			: (This:C1470.method.catch($e; On Clicked:K2:4))
				
				UI.editDatabaseMethod("onMobileAppAuthentication")
				
				//==============================================
			: (This:C1470.validate.catch($e; On Clicked:K2:4))\
				 | (This:C1470.enter.catch($e; On Clicked:K2:4))
				
				This:C1470.list.focus()
				
				This:C1470.validateFilterManager()
				
				//==============================================
			: (This:C1470.embedded.catch($e; On Clicked:K2:4))
				
				var $table : cs:C1710.table
				$table:=This:C1470.current
				
				If (Bool:C1537($table.embedded))
					
					Form:C1466.dataModel[String:C10($table.tableNumber)][""].embedded:=True:C214
					
				Else 
					
					OB REMOVE:C1226(Form:C1466.dataModel[String:C10($table.tableNumber)][""]; "embedded")
					
				End if 
				
				If (Feature.with("androidDataSet"))
					
					This:C1470.datasetAndroid:=Null:C1517
					This:C1470.sqlite:=Null:C1517
					This:C1470.callMeBack("updateSourcePanel")
					
				End if 
				
				PROJECT.save()
				This:C1470.update()
				
				//==============================================
			: (This:C1470.queryWidget.catch($e; On Clicked:K2:4))
				
				This:C1470.queryWidgetManager()
				
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
	If (UI.darkScheme)
		
		$t:=File:C1566("/RESOURCES/queryWidget_dark.svg").getText()
		
	Else 
		
		$t:=File:C1566("/RESOURCES/queryWidget.svg").getText()
		
	End if 
	
	PROCESS 4D TAGS:C816($t; $t; \
		UI.selectedFillColor; \
		Get localized string:C991("fields"); \
		Get localized string:C991("comparators"); \
		Get localized string:C991("operators"); \
		"🢓")
	
	This:C1470.queryWidget.setValue(cs:C1710.svg.new($t).picture())
	
	If (Feature.with("androidDataSet")) && Is macOS:C1572 && (PROJECT.allTargets())
		
		This:C1470.dataSizeLabel.title:=This:C1470.dataSizeLabel.title+" (iOS / Android)"
		This:C1470.dumpSize.horizontalAlignment:=Align center:K42:3
		
	End if 
	
	This:C1470.update()
	
	This:C1470.list.focus()
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Update of the user interface
Function update()
	
	Logger.info("DATA update()")
	
	This:C1470.properties.enable(UI.isNotLocked())
	
	// Select the last used table or the first one if none
	This:C1470.list.doSafeSelect(Num:C11(This:C1470.lastIndex)=0 ? 1 : Num:C11(This:C1470.lastIndex))
	
	var $o : Object
	
	$o:=New object:C1471(\
		"project"; PROJECT; \
		"caller"; This:C1470.window; \
		"method"; Formula:C1597(editor_CALLBACK).source; \
		"message"; "getSQLiteResponse")
	
	If (PROJECT.iOS())
		
		$o.target:="ios"
		This:C1470.callWorker(Formula:C1597(getSQLite).source; $o)
		
	End if 
	
	If (PROJECT.android())
		
		$o.target:="android"
		This:C1470.callWorker(Formula:C1597(getSQLite).source; $o)
		
	End if 
	
	If (This:C1470.current=Null:C1517)
		
		This:C1470.properties.hide()
		
	Else 
		
		This:C1470.properties.show()
		This:C1470.method.hide()
		This:C1470.queryWidget.show(This:C1470.filter.isFocused())
		This:C1470.filter.foregroundColor:=Foreground color:K23:1
		
		OB REMOVE:C1226(This:C1470.current; "user")
		
		This:C1470.result.setValue("").show()
		This:C1470.result.foregroundColor:=UI.selectedFillColor
		
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
	
	var $sqlID : Text
	var $size : Integer
	var $table : Object
	var $file : 4D:C1709.File
	
	Logger.info("DATA updateTableListWithDataSizes()")
	
	For each ($table; This:C1470.tables)
		
		If (Length:C16(String:C10($table.filter.string))>0)
			
			$table.filterIcon:=Choose:C955(Bool:C1537($table.filter.parameters); UI.userIcon; UI.filterIcon)
			
		End if 
		
		If (Bool:C1537($table.embedded))\
			 & (Not:C34(Bool:C1537($table.filter.parameters)))
			
			If (Feature.with("androidDataSet"))
				
				If (Is macOS:C1572)
					
					Case of 
							
							//______________________________________________________
						: (PROJECT.allTargets())
							
							$table.dumpSize:=This:C1470.dumpTableSize($table.name; "ios")+" / "+This:C1470.dumpTableSize($table.name; "android")
							
							//______________________________________________________
						: (PROJECT.iOS())
							
							$table.dumpSize:=This:C1470.dumpTableSize($table.name; "ios")
							
							//______________________________________________________
						: (PROJECT.android())
							
							$table.dumpSize:=This:C1470.dumpTableSize($table.name; "android")
							
							//______________________________________________________
					End case 
					
				Else 
					
					$table.dumpSize:=This:C1470.dumpTableSize($table.name; "android")
					
				End if 
				
			Else 
				
				If (This:C1470.sqlite#Null:C1517)
					
					$table.dumpSize:=This:C1470.dumpTableSize($table.name)
					
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
			
		Else 
			
			OB REMOVE:C1226($table; "dumpSize")
			
		End if 
	End for each 
	
	// Redraw
	This:C1470.list.touch()
	
	// Update source panel comments
	This:C1470.callMeBack("updateSourcePanel")
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function dumpTableSize($tableName : Text; $target : Text) : Text
	
	var $size : Integer
	var $file : 4D:C1709.File
	
	$target:=$target || "ios"
	
	If ($target="ios")
		
		If (This:C1470.sqlite=Null:C1517)\
			 || (This:C1470.sqlite.tables=Null:C1517)\
			 || (This:C1470.sqlite.tables["Z"+Uppercase:C13($tableName)]=Null:C1517)
			
			return ("#NA")
			
		End if 
		
		$size:=Num:C11(This:C1470.sqlite.tables["Z"+Uppercase:C13($tableName)])
		
	Else 
		
		//MARK:-ACI0103230
		$tableName:=This:C1470._formatTableNameAndroid($tableName)
		//MARK:-
		
		If (This:C1470.datasetAndroid=Null:C1517)\
			 || (This:C1470.datasetAndroid.tables=Null:C1517)\
			 || (This:C1470.datasetAndroid.tables[$tableName]=Null:C1517)
			
			return ("#NA")
			
		End if 
		
		$size:=Num:C11(This:C1470.datasetAndroid.tables[$tableName])
		
	End if 
	
	If ($size>4096)
		
		// Add pictures size if any
		$file:=PROJECT._folder.file("project.dataSet/Resources/Assets.xcassets/Pictures/"+$tableName+"/manifest.json")
		
		If ($file.exists)
			
			$size:=$size+Num:C11(JSON Parse:C1218($file.getText()).contentSize)
			
		End if 
	End if 
	
	return (doc_bytesToString($size))
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function _formatTableNameAndroid($tableName : Text) : Text
	
	var $regex : cs:C1710.regex
	var $str : cs:C1710.str
	
	// Remove spaces
	$tableName:=Replace string:C233($tableName; " "; "")
	
	// First letter in uppercase
	$tableName[[1]]:=Uppercase:C13($tableName[[1]])
	
	// Replace accented characters with non-accented characters
	$str:=cs:C1710.str.new($tableName)
	$tableName:=$str.unaccented()
	
	// Replace special characters with underscores
	$regex:=cs:C1710.regex.new($tableName; "[^a-zA-Z0-9._]")
	$tableName:=$regex.substitute("_")
	
	// Prefix names beginning with an underscore
	$tableName:=$tableName[[1]]="_" ? "Q"+$tableName : $tableName
	
	//FIXME:Seems to be useless - Manage reserved words for Kotin or Java
	If (New collection:C1472("as"; \
		"break"; \
		"class"; \
		"continue"; \
		"do"; \
		"else"; \
		"false"; \
		"for"; \
		"fun"; \
		"if"; \
		"in"; \
		"is"; \
		"null"; \
		"object"; \
		"package"; \
		"return"; \
		"super"; \
		"this"; \
		"throw"; \
		"true"; \
		"try"; \
		"typealias"; \
		"typeof"; \
		"val"; \
		"var"; \
		"when"; \
		"while"; \
		"by"; \
		"catch"; \
		"constructor"; \
		"delegate"; \
		"dynamic"; \
		"field"; \
		"file"; \
		"finally"; \
		"get"; \
		"import"; \
		"init"; \
		"param"; \
		"property"; \
		"receiver"; \
		"set"; \
		"setparam"; \
		"where"; \
		"actual"; \
		"abstract"; \
		"annotation"; \
		"companion"; \
		"const"; \
		"crossinline"; \
		"data"; \
		"enum"; \
		"expect"; \
		"external"; \
		"final"; \
		"infix"; \
		"inline"; \
		"inner"; \
		"internal"; \
		"lateinit"; \
		"noinline"; \
		"open"; \
		"operator"; \
		"out"; \
		"override"; \
		"private"; \
		"protected"; \
		"public"; \
		"reified"; \
		"sealed"; \
		"suspend"; \
		"tailrec"; \
		"vararg"; \
		"field"; \
		"it").indexOf($tableName)#-1)
		
		$tableName:="QMobile_"+$tableName
		
	End if 
	
	return $tableName
	
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
					
					$Comment:=UI.str.localize("allDataEmbedded")
					
				Else 
					
					$Comment:=UI.str.localize("allDataLoaded")
					
				End if 
				
			Else 
				
				If ($table.total=0)
					
					If (Bool:C1537($table.embedded))
						
						$Comment:=UI.str.localize("noEntityToEmbed")
						
					Else 
						
						$Comment:=UI.str.localize("noEntityToLoad")
						
					End if 
					
				Else 
					
					If ($table.total>100000)
						
						This:C1470.result.foregroundColor:=UI.warningColor
						
						If (Bool:C1537($table.embedded))
							
							$Comment:=UI.str.localize("largeNumberOfEntitiesToEmbed")
							
						Else 
							
							$Comment:=UI.str.localize("largeNumberOfEntitiesToLoad")
							
						End if 
						
					Else 
						
						If (Bool:C1537($table.embedded))
							
							$Comment:=UI.str.localize("entitiesToEmbed"; String:C10($table.total; This:C1470.numbereFormat))
							
						Else 
							
							$Comment:=UI.str.localize("entitiesToLoad"; String:C10($table.total; This:C1470.numbereFormat))
							
						End if 
					End if 
				End if 
			End if 
			
			//______________________________________________________
		: (Length:C16(String:C10($filter.error))>0)  // With errors
			
			This:C1470.filter.foregroundColor:=UI.errorColor
			This:C1470.result.foregroundColor:=UI.errorColor
			
			$Comment:=UI.str.localize("error:")+$filter.error
			
			//______________________________________________________
		: (Not:C34(Bool:C1537($filter.validated)))  // Not validated
			
			This:C1470.filter.foregroundColor:=UI.errorColor
			This:C1470.result.foregroundColor:=UI.errorColor
			
			$Comment:=UI.str.localize("notValidatedFilter")
			
			//______________________________________________________
		Else 
			
			$filter.parameters:=(Match regex:C1019("(?m-si)(?:=|==|===|IS|!=|#|!==|IS NOT|>|<|>=|<=|%)\\s*:"; $filter.string; 1))
			
			If (Bool:C1537($filter.parameters))
				
				$table.filterIcon:=UI.userIcon
				
				This:C1470.embedded.hide()
				This:C1470.method.show()
				
				$Comment:=UI.str.localize("dataFilteringByUser")
				
			Else 
				
				If ($table.count=Null:C1517)
					
					If (Bool:C1537($table.embedded))
						
						$Comment:=UI.str.localize("dataEmbedded")
						
					Else 
						
						$Comment:=UI.str.localize("dataLoaded")
						
					End if 
					
				Else 
					
					If ($table.count=0)
						
						If (Bool:C1537($table.embedded))
							
							$Comment:=UI.str.localize("noEntityToEmbed")
							
						Else 
							
							$Comment:=UI.str.localize("noEntityToLoad")
							
						End if 
						
					Else 
						
						If (Bool:C1537($table.embedded))
							
							If ($table.count>100000)
								
								This:C1470.result.foregroundColor:=UI.warningColor
								$Comment:=UI.str.localize("largeNumberOfEntitiesToEmbed")
								
							Else 
								
								$Comment:=UI.str.localize("entitiesEmbeddedUponConnection"; New collection:C1472(String:C10($table.count; This:C1470.numbereFormat); String:C10($table.total; This:C1470.numbereFormat)))
								
							End if 
							
						Else 
							
							If ($table.count>100000)
								
								This:C1470.result.foregroundColor:=UI.warningColor
								$Comment:=UI.str.localize("largeNumberOfEntitiesToLoad")
								
							Else 
								
								$Comment:=UI.str.localize("entitiesLoadedUponConnection"; New collection:C1472(String:C10($table.count; This:C1470.numbereFormat); String:C10($table.total; This:C1470.numbereFormat)))
								
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
Function tableListManager($e : Object)
	
	$e:=$e || FORM Event:C1606
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Getting Focus:K2:7)
			
			This:C1470.list.foregroundColor:=Foreground color:K23:1
			This:C1470.listBorder.foregroundColor:=UI.selectedColor
			
			//______________________________________________________
		: ($e.code=On Losing Focus:K2:8)
			
			This:C1470.list.foregroundColor:=Foreground color:K23:1
			This:C1470.listBorder.foregroundColor:=UI.backgroundUnselectedColor
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
		: (UI.isLocked())
			
			// <NOTHING MORE TO DO>
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Filter input script
Function filterManager($e : Object)
	
	var $t : Text
	var $meta; $table : Object
	
	$e:=$e || FORM Event:C1606
	$table:=This:C1470.current
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Getting Focus:K2:7)
			
			This:C1470.filterBorder.foregroundColor:=UI.selectedColor
			
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
			
			This:C1470.filterBorder.foregroundColor:=UI.backgroundUnselectedColor
			
			This:C1470.refresh()
			
			//______________________________________________________
		: (UI.isLocked())
			
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
Function validateFilterManager()
	
	If (PROJECT.dataSource.source="server")
		
		PROJECT.checkRestQueryFilter(This:C1470.current)
		
	Else 
		
		PROJECT.checkLocalQueryFilter(This:C1470.current)
		
	End if 
	
	PROJECT.save()
	
	This:C1470.refresh()
	
	PROJECT.audit(New object:C1471(\
		"target"; New collection:C1472("filters")))
	
	UI.updateRibbon()
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Filter input assistance widget script
Function queryWidgetManager()
	
	var $ID : Text
	var $withInsertion : Boolean
	var $catalog; $field; $highligh; $table : Object
	var $menu : cs:C1710.menu
	var $str : cs:C1710.str
	
	$ID:=This:C1470.queryWidget.findByCoordinates()
	
	$table:=This:C1470.current
	
	$menu:=cs:C1710.menu.new()
	
	If (Length:C16($ID)#0)
		
		Case of 
				
				//……………………………………………………………………………………………………………………………
			: ($ID="fields")
				
				$catalog:=catalog("fields"; New object:C1471(\
					"tableName"; $table.name))
				
				If ($catalog.success)
					
					For each ($field; $catalog.fields.orderBy("path"))
						
						If (Position:C15(" "; $field.path)>0)
							
							$menu.append($field.path; "'"+$field.path+"'")
							
						Else 
							
							$menu.append($field.path; $field.path)
							
						End if 
						
						If (UI.darkScheme)
							
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
			
			$str:=UI.str.setText(String:C10($table.filter.string)).insert($menu.choice; $highligh.start; $highligh.end)
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
			
			$color:=Choose:C955($selected; UI.backgroundSelectedColor; UI.alternateSelectedColor)
			
		Else 
			
			var $backgroundColor
			$backgroundColor:=Choose:C955($selected; UI.highlightColor; UI.highlightColorNoFocus)
			$color:=Choose:C955($selected; $backgroundColor; "transparent")
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Table list meta info expression
Function metaInfo($current : Object)->$meta
	
	// Default values
	$meta:=New object:C1471(\
		"stroke"; Choose:C955(UI.darkScheme; "white"; "black"); \
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
				
				$meta.cell.table_names.stroke:=UI.errorRGB
				
			End if 
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Returns the number of tables with embedded data
Function embeddedDataCount() : Integer
	
	return (This:C1470.tables.query("embedded = true").length)
	