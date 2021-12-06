Class extends form

// === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705("editor_CALLBACK")
	
	This:C1470.context:=editor_Panel_init(This:C1470.name)
	
	If (OB Is empty:C1297(This:C1470.context))
		
		This:C1470.isSubform:=True:C214
		
		This:C1470.init()
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
	End if 
	
	This:C1470.cancelableDatasetGeneration:=FEATURE.with("cancelableDatasetGeneration")
	
	This:C1470.localized:=New collection:C1472
	This:C1470.localized.push(Get localized string:C991("theFilteredDataWillBeLoadedIntoTheApplicationWhenConnecting"))
	
	// Mark: TO LOCALISE
	This:C1470.localized.push("."+This:C1470.localized[0]+" depending on user information which you define in the Mobile App Authentication method.")
	
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
	
	If (Not:C34(This:C1470.cancelableDatasetGeneration))
		
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
		//This.validate.hide()
		This:C1470.method.hide()
		This:C1470.embedded.show()
		
		OB REMOVE:C1226(This:C1470.current; "user")
		
		If (This:C1470.cancelableDatasetGeneration)
			
			This:C1470.result.setValue("").setColors(EDITOR.selectedFillColor)
			
		End if 
		
		This:C1470.displayFilter(This:C1470.current)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function displayFilter($current : Object)
	
	var $filter : Object
	
	$filter:=$current.filter
	
	If (Length:C16(String:C10($filter.string))>0)
		
		This:C1470.current.filterIcon:=EDITOR.filterIcon
		
		If (Bool:C1537($filter.validated))
			
			If (Bool:C1537($filter.parameters))
				
				// Can't embed data
				This:C1470.embedded.hide()
				
				// Allow to edit the 'On Mobile App Authentification' method
				This:C1470.method.show()
				
				// Populate user icon
				$current.filterIcon:=EDITOR.userIcon
				
				If (This:C1470.cancelableDatasetGeneration)
					
					// Mark: TO LOCALISE
					This:C1470.result.setValue("."+Get localized string:C991("theFilteredDataWillBeLoadedIntoTheApplicationWhenConnecting")+" depending on user information which you define in the Mobile App Authentication method.")
					
				End if 
				
			Else 
				
				If (This:C1470.cancelableDatasetGeneration)
					
					If (Bool:C1537($current.embedded))
						
						This:C1470.result.setValue(Get localized string:C991("theFilteredDataWillBeIntegratedIntoTheApplication")+" ("+String:C10($current.count)+"/"+String:C10($current.total)+")")
						
					Else 
						
						This:C1470.result.setValue(Get localized string:C991("theFilteredDataWillBeLoadedIntoTheApplicationWhenConnecting")+" ("+String:C10($current.count)+"/"+String:C10($current.total)+")")
						
					End if 
				End if 
			End if 
			
		Else 
			
			//This.validate.show()
			This:C1470.filter.setColors(EDITOR.errorColor)
			
			If (This:C1470.cancelableDatasetGeneration)
				
				This:C1470.result.setColors(EDITOR.errorColor)
				
			End if 
			
			If (Length:C16(String:C10($filter.error))>0)
				
				If (This:C1470.cancelableDatasetGeneration)
					
					This:C1470.result.setValue(Get localized string:C991("error:")+$filter.error)
					
				Else 
					
					OBJECT SET HELP TIP:C1181(*; This:C1470.filter.name; Get localized string:C991("error:")+$filter.error)
					
				End if 
				
			Else 
				
				If (This:C1470.cancelableDatasetGeneration)
					
					This:C1470.result.setValue(Get localized string:C991("notValidatedFilter"))
					
				Else 
					
					OBJECT SET HELP TIP:C1181(*; This:C1470.filter.name; Get localized string:C991("notValidatedFilter"))
					
				End if 
			End if 
		End if 
		
	Else 
		
		$current.filterIcon:=Null:C1517
		
		If (This:C1470.cancelableDatasetGeneration)
			
			If (Bool:C1537($current.embedded))
				
				This:C1470.result.setValue(Get localized string:C991("allDataWillBeIntegratedIntoTheApplication")+" ("+String:C10($current.total)+")")
				
			Else 
				
				This:C1470.result.setValue(Get localized string:C991("allDataWillBeLoadedIntoTheApplicationWhenConnecting")+" ("+String:C10($current.total)+")")
				
			End if 
		End if 
	End if 