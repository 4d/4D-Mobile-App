Class extends form

// === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705("editor_CALLBACK")
	
	This:C1470.context:=editor_Panel_init(This:C1470.name)
	
	If (OB Is empty:C1297(This:C1470.context)) | True:C214
		
		This:C1470.isSubform:=True:C214
		
		This:C1470.init()
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	This:C1470.toBeInitialized:=False:C215
	
	//table list
	This:C1470.listbox("01_tables"; "list")
	
	//properties
	var $group : cs:C1710.group
	$group:=This:C1470.group("properties")
	This:C1470.formObject("02_filter.label.options").addToGroup($group)
	This:C1470.picture("query.options"; "queryWidget").addToGroup($group)
	This:C1470.input("02_filter.options"; "filter").addToGroup($group)
	This:C1470.formObject("02_filter.border.options").addToGroup($group)
	This:C1470.button("embedded.options"; "embedded").bestSize().addToGroup($group)
	This:C1470.button("validate.options"; "validate").bestSize().addToGroup($group)
	This:C1470.button("enter.options"; "enter").addToGroup($group)
	This:C1470.button("authenticationMethod.options"; "method").bestSize().addToGroup($group)
	This:C1470.input("result").addToGroup($group)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	If (Not:C34(FEATURE.with("cancelableDatasetGeneration")))
		
		This:C1470.method.setCoordinates(486; 104; 486+330; 104+22)
		
	End if 
	
	This:C1470.list.setScrollbars(False:C215; 2)
	
	If (This:C1470.tables=Null:C1517)\
		 | (Num:C11((This:C1470.tables.length))=0)
		
		This:C1470.tables:=PROJECT.publishedTables()
		
		//For each ($table; This.tables)
		//PROJECT.checkQueryFilter($table)
		//End for each 
		
	End if 
	
	This:C1470.update()
	
	This:C1470.list.focus()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function update()
	
	androidLimitations(False:C215; "")
	
	If (This:C1470.current=Null:C1517)
		
		This:C1470.properties.hide()
		
	Else 
		
		This:C1470.properties.show()
		This:C1470.queryWidget.show(This:C1470.filter.isFocused())
		This:C1470.filter.setColors(Foreground color:K23:1)
		This:C1470.method.hide()
		This:C1470.embedded.show()
		
		OB REMOVE:C1226(This:C1470.current; "user")
		
		This:C1470.result.setValue("").setColors(EDITOR.selectedFillColor).show(FEATURE.with("cancelableDatasetGeneration"))
		
		This:C1470.displayFilter(This:C1470.current)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
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
					
					$Comment:=EDITOR.str.setText("allDataEmbedded").localized()
					
				Else 
					
					$Comment:=EDITOR.str.setText("allDataLoaded").localized()
					
				End if 
				
			Else 
				
				If ($table.total=0)
					
					If (Bool:C1537($table.embedded))
						
						$Comment:=EDITOR.str.setText("noEntityToEmbed").localized()
						
					Else 
						
						$Comment:=EDITOR.str.setText("noEntityToLoad").localized()
						
					End if 
					
				Else 
					
					If ($table.total>100000)
						
						If (Bool:C1537($table.embedded))
							
							$Comment:=EDITOR.str.setText("largeNumberOfEntitiesToEmbed").localized()
							
						Else 
							
							$Comment:=EDITOR.str.setText("largeNumberOfEntitiesToLoad").localized()
							
						End if 
						
					Else 
						
						If (Bool:C1537($table.embedded))
							
							$Comment:=EDITOR.str.setText("entitiesToEmbed").localized(String:C10($table.total; "### ###"))
							
						Else 
							
							$Comment:=EDITOR.str.setText("entitiesToLoad").localized(String:C10($table.total; "### ###"))
							
						End if 
					End if 
				End if 
			End if 
			
			//______________________________________________________
		: (Length:C16(String:C10($filter.error))>0)  // With errors
			
			This:C1470.filter.setColors(EDITOR.errorColor)
			This:C1470.result.setColors(EDITOR.errorColor)
			
			$Comment:=EDITOR.str.setText("error:").localized()+$filter.error
			
			//______________________________________________________
		: (Not:C34(Bool:C1537($filter.validated)))  // Not validated
			
			This:C1470.filter.setColors(EDITOR.errorColor)
			This:C1470.result.setColors(EDITOR.errorColor)
			
			$Comment:=EDITOR.str.setText("notValidatedFilter").localized()
			
			//______________________________________________________
		Else 
			
			$filter.parameters:=(Match regex:C1019("(?m-si)(?:=|==|===|IS|!=|#|!==|IS NOT|>|<|>=|<=|%)\\s*:"; $filter.string; 1))
			
			If (Bool:C1537($filter.parameters))
				
				$table.filterIcon:=EDITOR.userIcon
				
				This:C1470.embedded.hide()
				This:C1470.method.show()
				
				$Comment:=EDITOR.str.setText("dataFilteringByUser").localized()
				
			Else 
				
				If ($table.count=Null:C1517)
					
					If (Bool:C1537($table.embedded))
						
						$Comment:=EDITOR.str.setText("dataEmbedded").localized()
						
					Else 
						
						$Comment:=EDITOR.str.setText("dataLoaded").localized()
						
					End if 
					
				Else 
					
					If ($table.count=0)
						
						If (Bool:C1537($table.embedded))
							
							$Comment:=EDITOR.str.setText("noEntityToEmbed").localized()
							
						Else 
							
							$Comment:=EDITOR.str.setText("noEntityToLoad").localized()
							
						End if 
						
					Else 
						
						If (Bool:C1537($table.embedded))
							
							If ($table.count>100000)
								
								$Comment:=EDITOR.str.setText("largeNumberOfEntitiesToEmbed").localized()
								
							Else 
								
								$Comment:=EDITOR.str.setText("entitiesEmbeddedUponConnection").localized(String:C10($table.count; "### ###"); String:C10($table.total; "### ### ### ### ###"))
								
							End if 
							
						Else 
							
							If ($table.count>100000)
								
								$Comment:=EDITOR.str.setText("largeNumberOfEntitiesToLoad").localized()
								
							Else 
								
								$Comment:=EDITOR.str.setText("entitiesLoadedUponConnection").localized(String:C10($table.count; "### ###"); String:C10($table.total; "### ### ### ### ###"))
								
							End if 
						End if 
					End if 
				End if 
			End if 
			
			//______________________________________________________
	End case 
	
	This:C1470.result.setValue($Comment)
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Table list meta info expression
Function metaInfo($current : Object)->$meta
	
	// Default values
	$meta:=New object:C1471(\
		"stroke"; Choose:C955(EDITOR.isDark; "white"; "black"); \
		"fontWeight"; "normal"; \
		"cell"; New object:C1471(\
		"table_names"; New object:C1471))
	
	If (Bool:C1537(This:C1470.embedded))
		
		$meta.cell.table_names.fontWeight:="bold"
		
	End if 
	
	If (This:C1470.filter#Null:C1517)
		
		If (Length:C16(String:C10(This:C1470.filter.string))>0)
			
			If (Not:C34(Bool:C1537(This:C1470.filter.validated)))
				
				$meta.cell.table_names.stroke:=EDITOR.errorRGB
				
			End if 
		End if 
	End if 
	
	