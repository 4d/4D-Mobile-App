Class extends panel

Class constructor
	
	Super:C1705(Formula:C1597(editor_CALLBACK).source)
	
	This:C1470.context:=Super:C1706.init()
	
	If (OB Is empty:C1297(This:C1470.context))
		
		This:C1470.init()
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
	End if 
	
	This:C1470.path:=cs:C1710.path.new()
	
	This:C1470.typesWithoutPlaceholder:=New collection:C1472("bool")
	This:C1470.customInputControls:=New collection:C1472("push"; "segmented"; "popover"; "sheet"; "picker")
	This:C1470.typesAllowingCustomInputControls:=New collection:C1472("string"; "bool"; "number")
	This:C1470.customInputControlsWithoutPlaceholder:=New collection:C1472("/segmented"; "/picker")
	
	This:C1470.globalScope:=Get localized string:C991("scope_3")
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Design definition
Function init()
	
	var $group : cs:C1710.group
	
	This:C1470.toBeInitialized:=False:C215
	
	This:C1470.formObject("noSelection")
	This:C1470.formObject("noAction")
	This:C1470.formObject("noTable")
	This:C1470.formObject("noParameters")
	This:C1470.formObject("title")
	
	$group:=This:C1470.group("parameterGroup")
	This:C1470.listbox("parameters"; "01_Parameters").addToGroup($group)
	This:C1470.parameters.uri:="com.4d.private.4dmobile.parameter"
	This:C1470.formObject("parametersBorder"; "01_Parameters.border").addToGroup($group)
	This:C1470.button("add").addToGroup($group)
	This:C1470.button("remove").addToGroup($group)
	
	$group:=This:C1470.group("paramNameGroup")
	This:C1470.input("paramName"; "02_name").addToGroup($group)
	This:C1470.formObject("paramNameBorder"; "02_name.border").addToGroup($group)
	This:C1470.formObject("paramNameLabel"; "02_name.label").addToGroup($group)
	
	This:C1470.button("mandatory"; "02_mandatory")
	
	$group:=This:C1470.group("labelGroup")
	This:C1470.input("label"; "03_label").addToGroup($group)
	This:C1470.formObject("labelBorder"; "03_label.border").addToGroup($group)
	This:C1470.formObject("labelLabel"; "03_label.label").addToGroup($group)
	
	$group:=This:C1470.group("shortGroup")
	This:C1470.input("short"; "04_shortLabel").addToGroup($group)
	This:C1470.formObject("shortBorder"; "04_shortLabel.border").addToGroup($group)
	This:C1470.formObject("shortLabel"; "04_shortLabel.label").addToGroup($group)
	
	$group:=This:C1470.group("formatGroup")
	This:C1470.input("format"; "05_type").addToGroup($group)
	This:C1470.formObject("formatBorder"; "05_type.border").addToGroup($group)
	This:C1470.formObject("formatLabel"; "05_type.label").addToGroup($group)
	This:C1470.button("formatPopup"; "05_type.popup").addToGroup($group)
	This:C1470.formObject("formatPopupBorder"; "05_type.popup.border").addToGroup($group)
	This:C1470.button("revealFormat").addToGroup($group)
	
	$group:=This:C1470.group("sortOrderGroup")
	This:C1470.input("sortOrder"; "03_sortOrder").addToGroup($group)
	This:C1470.formObject("sortOrderBorder"; "03_sortOrder.border").addToGroup($group)
	This:C1470.formObject("sortOrderLabel"; "03_sortOrder.label").addToGroup($group)
	This:C1470.button("sortOrderPopup"; "03_sortOrder.popup").addToGroup($group)
	This:C1470.formObject("sortOrderPopupBorder"; "03_sortOrder.popup.border").addToGroup($group)
	
	$group:=This:C1470.group("placeholderGroup")
	This:C1470.input("placeholder"; "06_placeholder").addToGroup($group)
	This:C1470.formObject("placeholderBorder"; "06_placeholder.border").addToGroup($group)
	This:C1470.formObject("placeholderLabel"; "06_placeholder.label").addToGroup($group)
	
	$group:=This:C1470.group("defaultValueGroup")
	This:C1470.input("defaultValue"; "07_default").addToGroup($group)
	This:C1470.formObject("defaultValueBorder"; "07_default.border").addToGroup($group)
	This:C1470.formObject("defaultValueLabel"; "07_default.label").addToGroup($group)
	
	$group:=This:C1470.group("minGroup")
	This:C1470.input("min"; "09_min").addToGroup($group)
	This:C1470.formObject("minBorder"; "09_min.border").addToGroup($group)
	This:C1470.formObject("minLabel"; "09_min.label").addToGroup($group)
	
	$group:=This:C1470.group("maxGroup")
	This:C1470.input("max"; "10_max").addToGroup($group)
	This:C1470.formObject("maxBorder"; "10_max.border").addToGroup($group)
	This:C1470.formObject("maxLabel"; "10_max.label").addToGroup($group)
	
	This:C1470.input("field")
	This:C1470.input("description"; "01_description")
	
	This:C1470.formObject("dropCursor")
	
	//#128195 - [MOBILE] Custom input controls
	$group:=This:C1470.group("dataSourceGroup")
	This:C1470.input("dataSource"; "07_dataSource").addToGroup($group)
	This:C1470.formObject("dataSourceBorder"; "07_dataSource.border").addToGroup($group)
	This:C1470.formObject("dataSourceLabel"; "07_dataSource.label").addToGroup($group)
	This:C1470.button("dataSourcePopup"; "07_dataSource.popup").addToGroup($group)
	This:C1470.formObject("dataSourcePopupBorder"; "07_dataSource.popup.border").addToGroup($group)
	This:C1470.button("revealDatasource").addToGroup($group)
	
	This:C1470.group("number"; \
		This:C1470.minGroup; \
		This:C1470.maxGroup)
	
	This:C1470.group("properties"; \
		This:C1470.paramNameGroup; \
		This:C1470.mandatory; \
		This:C1470.labelGroup; \
		This:C1470.shortGroup; \
		This:C1470.formatGroup; \
		This:C1470.placeholderGroup; \
		This:C1470.defaultValueGroup; \
		This:C1470.number; \
		This:C1470.sortOrderGroup; \
		This:C1470.dataSourceGroup)
	
	This:C1470.group("withSelection"; \
		This:C1470.parameterGroup; \
		This:C1470.properties)
	
	// The group of widgets that do not require any specific code
	// but trigger a project save if the data is modified
	This:C1470.group("linked"; \
		This:C1470.paramName; \
		This:C1470.label; \
		This:C1470.short; \
		This:C1470.placeholder; \
		This:C1470.defaultValue; \
		This:C1470.description)
	
	This:C1470.subform("predicting").setEvents(New object:C1471(\
		"validate"; -1; \
		"show"; -2; \
		"hide"; -3))
	
	$group:=This:C1470.group("sortMenu")
	This:C1470.button("namePopup").addToGroup($group)
	This:C1470.formObject("namePopupBorder").addToGroup($group)
	
	//=== === === === === === === === === === === === === === === === === === === === ==
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
			: (This:C1470.parameters.catch())
				
				Case of 
						
						//_____________________________________
					: ($e.code=On Getting Focus:K2:7)
						
						This:C1470.parameters.foregroundColor:=Foreground color:K23:1
						This:C1470.parametersBorder.foregroundColor:=UI.selectedColor
						
						//_____________________________________
					: ($e.code=On Losing Focus:K2:8)
						
						This:C1470.parameters.foregroundColor:=Foreground color:K23:1
						This:C1470.parametersBorder.foregroundColor:=UI.backgroundUnselectedColor
						
						//_____________________________________
					: ($e.code=On Selection Change:K2:29)
						
						This:C1470.$current:=This:C1470.current
						
						// Update UI
						This:C1470.refresh()
						//_____________________________________
					: ($e.code=On Mouse Move:K2:35)
						
						SET CURSOR:C469
						
						//_____________________________________
					: (UI.isLocked())\
						 | (Num:C11($e.row)=0)
						
						// <NOTHING MORE TO DO>
						
						//_____________________________________
					: ($e.code=On Mouse Leave:K2:34)
						
						This:C1470.dropCursor.hide()
						
						//_____________________________________
				End case 
				
				//==============================================
			: (This:C1470.add.catch($e; New collection:C1472(On Clicked:K2:4; On Alternative Click:K2:36)))
				
				If ($e.code=On Clicked:K2:4)
					
					This:C1470.addParameter(This:C1470.add)
					
				Else 
					
					This:C1470.addParameterMenuManager(This:C1470.add)
					
				End if 
				
				//==============================================
			: (This:C1470.remove.catch($e; On Clicked:K2:4))
				
				This:C1470.removeParameter()
				
				//==============================================
			: (This:C1470.mandatory.catch($e; On Clicked:K2:4))
				
				This:C1470.mandatoryManager()
				
				//==============================================
			: (This:C1470.formatPopup.catch($e; On Clicked:K2:4))
				
				This:C1470.formatMenuManager()
				
				//==============================================
			: (This:C1470.dataSourcePopup.catch($e; On Clicked:K2:4))
				
				This:C1470.dataSourceMenuManager()
				
				//==============================================
			: (This:C1470.sortOrderPopup.catch($e; On Clicked:K2:4))
				
				This:C1470.sortOrderMenuManager()
				
				//==============================================
			: (This:C1470.min.catch($e; On Data Change:K2:15))
				
				This:C1470.ruleManager("min")
				
				//==============================================
			: (This:C1470.max.catch($e; On Data Change:K2:15))
				
				This:C1470.ruleManager("max")
				
				//==============================================
			: (This:C1470.defaultValue.catch($e; On After Edit:K2:43))
				
				If (Length:C16(Get edited text:C655)=0)
					
					OB REMOVE:C1226(This:C1470.current; "default")
					
				End if 
				
				//==============================================
			: (This:C1470.defaultValue.catch($e; On Data Change:K2:15))
				
				This:C1470.defaultValueManager()
				
				//==================================================
			: (This:C1470.format.catch())
				
				Case of 
						
						//_______________________________
					: ($e.code=On Mouse Enter:K2:33)
						
						UI.tips.instantly()
						
						//_______________________________
					: ($e.code=On Mouse Move:K2:35)
						
						This:C1470.setHelpTip()
						
						//_______________________________
					: ($e.code=On Mouse Leave:K2:34)
						
						UI.tips.restore()
						
						//________________________________________
				End case 
				
				//==================================================
			: (This:C1470.paramName.catch())
				
				This:C1470.nameManager($e)
				
				//==================================================
			: (This:C1470.namePopup.catch($e; On Clicked:K2:4))
				
				This:C1470.addParameterMenuManager(This:C1470.namePopup; True:C214)
				
				//==================================================
			: (This:C1470.revealFormat.catch($e; On Clicked:K2:4))
				
				This:C1470.showFormatOnDisk()
				
				//==================================================
			: (This:C1470.revealDatasource.catch($e; On Clicked:K2:4))
				
				SHOW ON DISK:C922(This:C1470.sourceFolder(Delete string:C232(This:C1470.current.source; 1; 1); True:C214).platformPath)
				
				//==================================================
			: ($e.code=On Data Change:K2:15)\
				 & (This:C1470.linked.belongsTo($e.objectName))  // Linked widgets
				
				PROJECT.save()
				
				This:C1470.update()
				
				//==============================================
		End case 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	// This trick remove the horizontal gap
	This:C1470.parameters.setScrollbars(0; 2).updateDefinition()
	
	This:C1470.dropCursor.foregroundColor:=Highlight menu background color:K23:7
	
	// Set the initial display
	If (This:C1470.action#Null:C1517)
		
		This:C1470.add.enable()
		
	Else 
		
		This:C1470.noSelection.show()
		This:C1470.noTable.hide()
		This:C1470.withSelection.hide()
		This:C1470.noParameters.hide()
		
	End if 
	
	This:C1470.dropCursor.foregroundColor:=Highlight menu background color:K23:7
	
	This:C1470.predicting.setWidth(This:C1470.paramNameBorder.dimensions.width)\
		.setCoordinates(This:C1470.paramNameBorder.coordinates.left; This:C1470.paramNameBorder.coordinates.bottom-1)
	
	This:C1470.predicting.setValue(New object:C1471(\
		"withValue"; True:C214))
	
	This:C1470.formatLabel.setTitle("inputControl")
	
	// Add the events that we cannot select in the form properties 😇
	This:C1470.appendEvents(New collection:C1472(On Alternative Click:K2:36; On Before Keystroke:K2:6; On After Keystroke:K2:26; -1; -2; -3))
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Internal drop for params
Function parameterListManager() : Integer
	
	var $allow : Integer
	var $e; $me; $o : Object
	
	$e:=FORM Event:C1606
	$e.row:=Drop position:C608
	
	Case of 
			
			//______________________________________________________
		: (UI.isLocked())
			
			return -1  // Reject drop
			
			//______________________________________________________
		: ($e.code=On Begin Drag Over:K2:44)
			
			This:C1470.beginDrag(This:C1470.parameters.uri; New object:C1471(\
				"src"; This:C1470.index))
			
			//______________________________________________________
		: ($e.code=On Drag Over:K2:13)
			
			$allow:=-1  // Reject drop
			
			$o:=This:C1470.getPasteboard(This:C1470.parameters.uri)
			
			If ($o#Null:C1517)
				
				$me:=This:C1470.parameters
				
				If ($e.row=-1)  // After the last line
					
					If ($o.src#$me.rowsNumber)  // Not if the source was the last line
						
						$o:=$me.rowCoordinates($me.rowsNumber)
						$o.top:=$o.bottom
						$o.right:=$me.coordinates.right
						$allow:=0  // Allow drop
						
					End if 
					
				Else 
					
					If ($o.src#$e.row)\
						 & ($e.row#($o.src+1))  // Not the same or the next one
						
						$o:=$me.rowCoordinates($e.row)
						$o.bottom:=$o.top
						$o.right:=$me.coordinates.right
						$allow:=0  // Allow drop
						
					End if 
				End if 
			End if 
			
			If ($allow=-1)
				
				SET CURSOR:C469(9019)
				This:C1470.dropCursor.hide()
				
			Else 
				
				This:C1470.dropCursor.setCoordinates($o.left; $o.top; $o.right; $o.bottom)
				This:C1470.dropCursor.show()
				
			End if 
			
			return $allow
			
			//______________________________________________________
		: ($e.code=On Drop:K2:12)
			
			$o:=This:C1470.getPasteboard(This:C1470.parameters.uri)
			
			If ($o#Null:C1517)
				
				$o.tgt:=Drop position:C608
				
				If ($o.src#$o.tgt)
					
					If ($o.tgt=-1)  // After the last line
						
						This:C1470.action.parameters.push(This:C1470.current)
						This:C1470.action.parameters.remove($o.src-1)
						
					Else 
						
						This:C1470.action.parameters.insert($o.tgt-1; This:C1470.current)
						
						If ($o.tgt<$o.src)
							
							This:C1470.action.parameters.remove($o.src)
							
						Else 
							
							This:C1470.action.parameters.remove($o.src-1)
							
						End if 
					End if 
					
					PROJECT.save()
					
				End if 
				
				This:C1470.dropCursor.hide()
				This:C1470.parameters.touch()
				
			End if 
			
			//______________________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// predicting container method
Function predictingManager($e : Object)
	
	var $height : Integer
	var $content; $e : Object
	var $me : cs:C1710.subform
	
	$e:=$e || FORM Event:C1606
	
	If ($e.code<0)
		
		$me:=This:C1470.predicting
		$content:=$me.getValue()
		
		Case of 
				
				//_________________________
			: ($e.code=$me.events.validate)
				
				This:C1470.updateParamater($content.choice.value)
				This:C1470.postKeyDown(Tab:K15:37)
				This:C1470.refresh()
				
				//_________________________
			: ($e.code=$me.events.show)
				
				$me.show()
				
				$height:=$content.ƒ.bestSize()
				
				If (($me.coordinates.top+$height)>This:C1470.height)
					
					$height:=This:C1470.height-$me.coordinates.top
					
				End if 
				
				$me.height:=$height
				
				//_________________________
			: ($e.code=$me.events.hide)
				
				$me.hide()
				
				//_________________________
		End case 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function saveContext($current : Object)
	
	This:C1470.$current:=Count parameters:C259>=1 ? $current : This:C1470.current
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function restoreContext()
	
	var $index : Integer
	
	// * Select last used action (or the first one) if any
	
	If (This:C1470.action#Null:C1517)\
		 && (This:C1470.action.parameters#Null:C1517)
		
		Case of 
				
				//_______________________________________
			: (OB Keys:C1719(This:C1470).indexOf("$current")=-1)
				
				// First display
				
				//_______________________________________
			Else 
				
				If (This:C1470.current#Null:C1517)
					
					$index:=This:C1470.action.parameters.indexOf(This:C1470.current)
					
				Else 
					
					If (This:C1470.$current#Null:C1517)
						
						$index:=This:C1470.action.parameters.indexOf(This:C1470.$current)
						
					End if 
				End if 
				
				//_______________________________________
		End case 
		
		This:C1470.parameters.select($index+1)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Update UI
Function update()
	
	var $t : Text
	var $isCustom; $isLinked; $withDataSource; $withDefault : Boolean
	var $action; $current : Object
	var $rgx : cs:C1710.regex
	
	This:C1470.noSelection.hide()
	This:C1470.noTable.hide()
	This:C1470.withSelection.hide()
	This:C1470.noParameters.hide()
	This:C1470.noAction.hide()
	This:C1470.title.hide()
	This:C1470.field.hide()
	This:C1470.predicting.hide()
	
	If (This:C1470.namePopup.visible)
		
		This:C1470.sortMenu.hide()
		
		// Restore position
		This:C1470.paramName.moveAndResizeHorizontally(-33; 5)
		
	End if 
	
	This:C1470.paramName.enable()
	
	If (Form:C1466.actions=Null:C1517)\
		 | (Num:C11(Form:C1466.actions.length)=0)  // No actions
		
		This:C1470.goToPage(1)
		This:C1470.noAction.show()
		
	Else 
		
		$action:=This:C1470.action
		$current:=This:C1470.current
		
		var $preset; $scope : Text
		$preset:=String:C10($action.preset)
		$scope:=String:C10($action.scope)
		
		If ($action=Null:C1517)  // No action selected
			
			This:C1470.goToPage(1)
			This:C1470.noSelection.show()
			
		Else 
			
			This:C1470.restoreContext()
			
			Case of 
					
					//______________________________________________________
				: ($preset="delete")
					
					This:C1470.goToPage(1)
					This:C1470.noParameters.show()
					
					//______________________________________________________
				: ($preset="share")
					
					If (Feature.with("sharedActionWithDescription"))  //🚧
						
						This:C1470.goToPage(2)
						This:C1470.title.setTitle("description").show()
						
					Else 
						
						This:C1470.goToPage(1)
						This:C1470.noParameters.show()
						
					End if 
					
					//______________________________________________________
				: ($preset="openURL")
					
					This:C1470.goToPage(2)
					This:C1470.title.setTitle("urlToOpenWithThisAction").show()
					This:C1470.description.setPlaceholder("urlPlaceholder")
					
					// The 4D mobile developer shall not be allowed to enter an URL (no host, no scheme). If so, the url shall be turned in red.
					This:C1470.description.foregroundColor:=(Length:C16(String:C10($action.description))>0) && Match regex:C1019("(?m-si)^/(?:[[:alnum:]_]*)(?:/[[:alnum:]_]*)*(?:\\.[[:alpha:]]{3,})?(?:#[[:alnum:]]*)?$"; String:C10($action.description); 1)\
						 ? Foreground color:K23:1\
						 : UI.errorColor
					
					//______________________________________________________
				: ($preset="sort")
					
					This:C1470.goToPage(1)
					This:C1470.title.setTitle(\
						UI.str.localize("sortCriteria"; New object:C1471(\
						"action"; $action.shortLabel; \
						"table"; Table name:C256($action.tableNumber)))).show()
					
					This:C1470.withSelection.show()
					
					This:C1470.add.enable()
					This:C1470.properties.hide()
					
					If ($current=Null:C1517)
						
						This:C1470.remove.disable()
						
					Else 
						
						This:C1470.remove.enable()
						
						This:C1470.paramNameGroup.show()
						This:C1470.sortOrderGroup.show()
						This:C1470.field.show()  // Linked to a field
						
						This:C1470.paramName.disable()  // The name isn't editable
						This:C1470.sortMenu.show()
						
						//We must backup the original position to not resize at each update
						This:C1470.paramName.moveAndResizeHorizontally(33; -5)
						
					End if 
					
					//______________________________________________________
				: ($scope=This:C1470.globalScope)
					
					This:C1470.goToPage(1)
					
					If (Feature.with("openURLActionsInTabBar"))
						
						This:C1470.title.setTitle(\
							UI.str.localize("actionParametersNoTable"; New object:C1471("action"; $action.shortLabel))).show()
						
						This:C1470.withSelection.show()
						This:C1470.add.setNoPopupMenu().enable()
						This:C1470.remove.enable($current#Null:C1517)
						
						If ($current=Null:C1517)
							
							// No parameter
							This:C1470.properties.hide()
							
						Else 
							
							This:C1470.updateParameters(True:C214)
							
						End if 
						
					Else 
						
						// Not managed
						This:C1470.title.setTitle("UNAVAILABLE").show()
						This:C1470.properties.hide()
						This:C1470.remove.disable()
						This:C1470.add.disable()
						
					End if 
					
					//______________________________________________________
				Else 
					
					This:C1470.goToPage(1)
					
					var $global : Boolean
					
					If ($action.tableNumber=Null:C1517)
						
						// No table defined
						This:C1470.noTable.show()
						This:C1470.properties.hide()
						This:C1470.remove.disable()
						This:C1470.add.disable()
						
					Else 
						
						This:C1470.title.setTitle(\
							UI.str.localize("actionParameters"; New object:C1471(\
							"action"; $action.shortLabel; \
							"table"; Table name:C256(Num:C11($action.tableNumber))))).show()
						
						This:C1470.withSelection.show()
						This:C1470.add.setSeparatePopupMenu().enable()
						This:C1470.remove.enable($current#Null:C1517)
						
						If ($current=Null:C1517)
							
							// No parameter
							This:C1470.properties.hide()
							
						Else 
							
							This:C1470.updateParameters()
							
						End if 
						
					End if 
					//______________________________________________________
			End case 
		End if 
		
		This:C1470.restoreContext()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function updateParameters($global : Boolean)
	
	var $t : Text
	var $isCustom; $isLinked; $withDataSource; $withDefault : Boolean
	var $action; $current : Object
	var $rgx : cs:C1710.regex
	
	$action:=This:C1470.action
	$current:=This:C1470.current
	
	If ($action.parameters.length>0)
		
		This:C1470.properties.show()
		This:C1470.sortOrderGroup.hide()
		This:C1470.dataSourceGroup.hide()
		
		If (Not:C34($global))
			
			$isLinked:=PROJECT.isFieldAttribute($current.name; Table name:C256($action.tableNumber))
			
		End if 
		
		If ($isLinked)
			
			This:C1470.field.show()
			This:C1470.field.setValue(UI.str.localize("thisParameterIsLinkedToTheField"; $current.name))
			
		Else 
			
			This:C1470.field.hide()
			
		End if 
		
		This:C1470.number.show(String:C10($current.type)="number")
		This:C1470.mandatory.setValue(This:C1470.mandatoryValue())
		This:C1470.min.setValue(String:C10(This:C1470.ruleValue("min")))
		This:C1470.max.setValue(String:C10(This:C1470.ruleValue("max")))
		
		If (Position:C15("/"; String:C10($current.format))=1)
			
			$withDataSource:=This:C1470._withDataSource(Delete string:C232($current.format; 1; 1))
			
		End if 
		
		If ($withDataSource)
			
			This:C1470.dataSourceGroup.show()
			This:C1470.revealDatasource.show(String:C10($current.source)="/@")
			This:C1470.placeholderGroup.show(This:C1470.customInputControlsWithoutPlaceholder.indexOf($current.format)=-1)
			This:C1470.defaultValueGroup.hide()
			
		Else 
			
			This:C1470.revealDatasource.hide()
			This:C1470.placeholderGroup.show(This:C1470.typesWithoutPlaceholder.indexOf($current.type)=-1)
			
			If ((String:C10($current.type)#"image"))
				
				$withDefault:=Choose:C955(String:C10($action.preset)#"edit"; True:C214; Not:C34($isLinked))
				
			End if 
			
			If ($withDefault)
				
				This:C1470.defaultValueGroup.show()
				This:C1470.defaultValue.setValue(String:C10($current.default))
				
				Case of 
						
						//…………………………………………………………………………………………………………………………………………
					: ($current.type="number")
						
						Case of 
								
								//________________________________________
							: (String:C10($current.format)="integer")
								
								This:C1470.defaultValue.setFilter(Is integer:K8:5)
								
								//________________________________________
							: (String:C10($current.format)="spellOut")
								
								This:C1470.defaultValue.setFilter(Is integer:K8:5)
								
								//________________________________________
							Else 
								
								This:C1470.defaultValue.setFilter(Is real:K8:4)
								
								//________________________________________
						End case 
						
						//…………………………………………………………………………………………………………………………………………
					: ($current.type="date")
						
						// Should accept "today", "yesterday", "tomorrow"
						GET SYSTEM FORMAT:C994(Date separator:K60:10; $t)
						This:C1470.defaultValue.setFilter("&\"0-9;"+$t+";-;/;"+UI.str.setText("todayyesterdaytomorrow").distinctLetters(";")+"\"")
						
						$t:=String:C10(This:C1470.defaultValue.getValue())
						
						If (Position:C15($t; "todayyesterdaytomorrow")=0)
							
							$rgx:=cs:C1710.regex.new($t; "(?m-si)^(\\d{2})!(\\d{2})!(\\d{4})$")
							
							If ($rgx.match())
								
								This:C1470.defaultValue.setValue(String:C10(Add to date:C393(!00-00-00!; Num:C11($rgx.matches[3].data); Num:C11($rgx.matches[2].data); Num:C11($rgx.matches[1].data))))
								
							End if 
						End if 
						
						//…………………………………………………………………………………………………………………………………………
					: ($current.type="time")
						
						This:C1470.defaultValue.setFilter(Is time:K8:8)
						
						//…………………………………………………………………………………………………………………………………………
					: ($current.type="string")
						
						This:C1470.defaultValue.setFilter(Is text:K8:3)
						
						//…………………………………………………………………………………………………………………………………………
					: ($current.type="bool")
						
						If (String:C10($current.format)="check")
							
							If ($current.default#Null:C1517)
								
								If (Value type:C1509($current.default)=Is boolean:K8:9)
									
									This:C1470.defaultValue.setValue(Choose:C955($current.default; "checked"; "unchecked"))
									
								End if 
							End if 
							
							// Should accept "checked", "unchecked", 0 or 1
							This:C1470.defaultValue.setFilter("&\"0;1;"+cs:C1710.str.new("unchecked").distinctLetters(";")+"\"")
							
						Else 
							
							If ($current.default#Null:C1517)
								
								If (Value type:C1509($current.default)=Is boolean:K8:9)
									
									This:C1470.defaultValue.setValue(Choose:C955($current.default; "true"; "false"))
									
								End if 
							End if 
							
							// Should accept "true", "false", 0 or 1
							This:C1470.defaultValue.setFilter("&\"0;1;"+cs:C1710.str.new("truefalse").distinctLetters(";")+"\"")
							
						End if 
						
						//…………………………………………………………………………………………………………………………………………
				End case 
				
			Else 
				
				This:C1470.defaultValueGroup.hide()
				
			End if 
		End if 
		
		If (Feature.with("inputControlArchive"))  //🚧
			
			$t:=String:C10($current.format)
			$isCustom:=(Position:C15("/"; $t)=1)
			
			If ($isCustom)\
				 && (This:C1470.customInputControls.indexOf(Delete string:C232($t; 1; 1))=-1)
				
				This:C1470.revealFormat.show()
				
				// Check availability
				This:C1470.format.foregroundColor:=This:C1470.checkFormat(Delete string:C232($t; 1; 1)) ? Foreground color:K23:1 : UI.errorColor
				
			Else 
				
				This:C1470.revealFormat.hide()
				
			End if 
			
		Else 
			
			$t:=String:C10($current.format)
			This:C1470.revealFormat.show((Position:C15("/"; $t)=1) & (This:C1470.customInputControls.indexOf(Delete string:C232($t; 1; 1))=-1))
			
		End if 
		
	Else 
		
		This:C1470.properties.hide()
		This:C1470.remove.disable()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// "format": "descending or "ascending"
Function sortOrderValue() : Text
	
	return Get localized string:C991(This:C1470.current.format)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Format choice
Function sortOrderMenuManager()
	
	var $menu : cs:C1710.menu
	
	$menu:=cs:C1710.menu.new("no-localization")\
		.append(":xliff:ascending"; "ascending"; String:C10(This:C1470.current.format)="ascending")\
		.append(":xliff:descending"; "descending"; String:C10(This:C1470.current.format)="descending")
	
	If ($menu.popup(This:C1470.sortOrderBorder).selected)
		
		This:C1470.current.format:=$menu.choice
		
		PROJECT.save()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function minValue() : Text
	
	return String:C10(This:C1470.ruleValue("min"))
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function maxValue() : Text
	
	return String:C10(This:C1470.ruleValue("max"))
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function mandatoryValue()->$value : Boolean
	
	If (This:C1470.current#Null:C1517)
		
		If (This:C1470.current.rules#Null:C1517)
			
			$value:=(This:C1470.current.rules.countValues("mandatory")>0)
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function ruleValue($type : Text) : Variant
	
	If (This:C1470.current.rules#Null:C1517)
		
		var $c : Collection
		$c:=This:C1470.current.rules.extract($type)
		
		If ($c.length>0)
			
			return String:C10($c[0])
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function formatValue() : Text
	
	var $current : Object
	var $file : 4D:C1709.File
	
	$current:=This:C1470.current
	
	Case of 
			
			//________________________________________
		: (Length:C16(String:C10($current.format))=0)
			
			// Take type
			return Get localized string:C991($current.type="string" ? "text" : String:C10($current.type))
			
			//________________________________________
		: (PROJECT.isCustomResource($current.format))  // Host custom action parameter format
			
			$file:=This:C1470.path.hostInputControls().file(Delete string:C232($current.format; 1; 1)+"/manifest.json")
			
			If ($file.exists)
				
				return JSON Parse:C1218($file.getText()).name
				
			Else 
				
				// Source folder name
				return Delete string:C232($current.format; 1; 1)
				
			End if 
			
			//________________________________________
		Else 
			
			// Prefer format
			return Get localized string:C991($current.format#$current.type ? "f_"+String:C10($current.format) : String:C10($current.type))
			
			//________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function dataSourceValue() : Text
	
	var $value : Text
	
	$value:=Delete string:C232(This:C1470.current.source; 1; 1)
	
	If (This:C1470.sourceFolder($value; True:C214).exists)
		
		This:C1470.dataSource.foregroundColor:=Foreground color:K23:1
		
	Else 
		
		This:C1470.dataSource.foregroundColor:=UI.errorRGB
		
	End if 
	
	return $value
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Returns the source folder of a host resource
Function sourceFolder($name : Text; $control : Boolean) : Object
	
	var $item; $manifest : Object
	var $file : 4D:C1709.File
	var $folder : 4D:C1709.Folder
	
	$folder:=This:C1470.path.hostInputControls()
	
	If (Feature.with("inputControlArchive"))  //🚧
		
		If (Not:C34($folder.exists))
			
			return 
			
		End if 
		
		For each ($item; $folder.folders().combine($folder.files().query("extension = :1"; SHARED.archiveExtension)))
			
			$folder:=This:C1470._source($item)
			
			If ($folder=Null:C1517)
				
				continue  // Not a valid formatter
				
			End if 
			
			$file:=$folder.file("manifest.json")
			
			If (Not:C34($file.exists))
				
				continue  // Not a valid formatter
				
			End if 
			
			$manifest:=JSON Parse:C1218($file.getText())
			
			If ($manifest.name#$name)
				
				continue  // Not the one we're looking for
				
			End if 
			
			If ($control)
				
				If (Delete string:C232(This:C1470.current.format; 1; 1)=($manifest.format#Null:C1517 ? $manifest.format : "push"))
					
					return $folder
					
				End if 
				
			Else 
				
				return $folder
				
			End if 
		End for each 
		
	Else 
		
		var $source : 4D:C1709.Folder
		
		$source:=Folder:C1567("❓")
		
		If (Not:C34($folder.exists))
			
			return $source
			
		End if 
		
		var $found : Boolean
		
		For each ($folder; $folder.folders()) Until ($found)
			
			$file:=$folder.files().query("fullName=:1"; "manifest.json").pop()
			
			If ($file#Null:C1517)
				
				$manifest:=JSON Parse:C1218($file.getText())
				$found:=($manifest.name=$name)
				
				If (Count parameters:C259>=2)
					
					If ($control)
						
						$found:=$found & (Delete string:C232(This:C1470.current.format; 1; 1)=Choose:C955($manifest.format#Null:C1517; $manifest.format; "push"))
						
					End if 
				End if 
				
				If ($found)
					
					$source:=$folder
					
				End if 
			End if 
		End for each 
		
		return $source
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Add a user parameter except for sort when adding is not possible
Function addParameter($target : Object)
	
	If (String:C10(This:C1470.action.preset)="sort")
		
		This:C1470.addParameterMenuManager($target)
		
	Else 
		
		This:C1470.newParameter()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Add a user parameter
Function newParameter()
	
	var $parameter : Object
	
	$parameter:=New object:C1471(\
		"name"; Get localized string:C991("newParameter"); \
		"label"; Get localized string:C991("addParameter"); \
		"shortLabel"; Get localized string:C991("addParameter"); \
		"type"; "string")
	
	This:C1470._addParameter($parameter)
	This:C1470.paramName.focus()
	This:C1470.paramName.highlight()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Add a field linked parameter
Function addParameterMenuManager($target : Object; $update : Boolean)
	
	var $t : Text
	var $isSortAction : Boolean
	var $i : Integer
	var $parameter : Object
	var $c; $fields : Collection
	var $field : cs:C1710.field
	var $menu : cs:C1710.menu
	
	$isSortAction:=String:C10(This:C1470.action.preset)="sort"
	$menu:=cs:C1710.menu.new("no-localization")
	
	If (Not:C34($isSortAction))
		
		$menu.append(":xliff:addParameter"; "new")
		
	End if 
	
	If (This:C1470.action.tableNumber=Null:C1517)
		
		return   // No table affected to action
		
	End if 
	
	$fields:=This:C1470._getParameterFields(Form:C1466.dataModel[String:C10(This:C1470.action.tableNumber)]; String:C10(This:C1470.action.preset))
	
	If (This:C1470.action.parameters#Null:C1517)
		
		// Remove the fields already present
		$c:=New collection:C1472
		
		For each ($field; $fields)
			
			If (This:C1470.action.parameters.query("name = :1"; $field.name).pop()#Null:C1517)
				
				$c.push($i)
				
			End if 
			
			$i+=1
			
		End for each 
		
		For each ($i; $c.reverse())
			
			$fields.remove($i)
			
		End for each 
		
	End if 
	
	If ($fields.length>0)
		
		$fields:=$fields.orderBy("name")
		
		$menu.line()
		
		For each ($field; $fields)
			
			$t:=$field.name#Null:C1517 ? $field.name : $t
			$menu.append($t; $t)
			
		End for each 
	End if 
	
	$menu.popup($target)
	
	Case of 
			
			//______________________________________________________
		: (Not:C34($menu.selected))
			
			// <NOTHING MORE TO DO>
			
			//______________________________________________________
		: ($menu.choice="new")  // Add a user parameter
			
			This:C1470.newParameter()
			
			//______________________________________________________
		: ($update)  // Change linked field
			
			$field:=$fields.query("name = :1"; $menu.choice).pop()
			This:C1470.updateParamater($field.name)
			
			//______________________________________________________
		Else   // Add a field
			
			$field:=$fields.query("name = :1"; $menu.choice).pop()
			
			If ($isSortAction)
				
				$parameter:=New object:C1471(\
					"fieldNumber"; $field.fieldNumber; \
					"name"; $field.name; \
					"type"; PROJECT.fieldType2type($field.fieldType); \
					"path"; $field.path)
				
			Else 
				
				$parameter:=New object:C1471(\
					"fieldNumber"; $field.fieldNumber; \
					"name"; $field.name; \
					"label"; $field.label; \
					"shortLabel"; $field.shortLabel; \
					"type"; PROJECT.fieldType2type($field.fieldType); \
					"defaultField"; PROJECT._actionDefaultField($field))
				
				If (Bool:C1537($field.mandatory))
					
					$parameter.rules:=New collection:C1472("mandatory")
					
				End if 
			End if 
			
			Case of 
					
					//……………………………………………………………………
				: ($isSortAction)
					
					$parameter.format:="ascending"
					
					//……………………………………………………………………
				: ($parameter.type="date")
					
					$parameter.format:="mediumDate"
					
					//……………………………………………………………………
				: ($parameter.type="time")
					
					$parameter.format:="hour"
					
					//……………………………………………………………………
			End case 
			
			This:C1470._addParameter($parameter)
			
			//______________________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Remove action button
Function removeParameter()
	
	var $index : Integer
	
	$index:=This:C1470.action.parameters.indexOf(This:C1470.current)
	This:C1470.action.parameters.remove($index)
	PROJECT.save()
	
	This:C1470.parameters.focus()
	This:C1470.parameters.doSafeSelect($index+1)  // Collection index to listbox index
	This:C1470.current:=Null:C1517
	This:C1470.saveContext(This:C1470.current)
	This:C1470.refresh()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Mandatory checkbox
Function mandatoryManager()
	
	var $index : Integer
	var $current : Object
	
	$current:=This:C1470.current
	
	If (Bool:C1537(This:C1470.mandatory.getValue()))  // Checked
		
		$current.rules:=$current.rules || New collection:C1472
		
		If ($current.rules.indexOf("mandatory")=-1)
			
			$current.rules.push("mandatory")
			
		End if 
		
	Else 
		
		If ($current.rules#Null:C1517)
			
			$index:=$current.rules.indexOf("mandatory")
			
			If ($index#-1)
				
				$current.rules.remove($index)
				
			End if 
			
			If ($current.rules.length=0)
				
				OB REMOVE:C1226($current; "rules")
				
			End if 
		End if 
	End if 
	
	PROJECT.save()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Format list
Function getFormats() : Object
	
	var $format; $type : Text
	var $index : Integer
	var $formats; $item; $manifest : Object
	var $target; $types : Collection
	var $file : 4D:C1709.File
	var $folder : 4D:C1709.Folder
	
	$formats:=JSON Parse:C1218(File:C1566("/RESOURCES/actionParameters.json").getText()).formats
	
	// Add user formatters if any
	$folder:=This:C1470.path.hostInputControls()
	
	If (Not:C34($folder.exists))
		
		return $formats  // No user formatter
		
	End if 
	
	$types:=New collection:C1472(\
		"text"; \
		"real"; \
		"integer"; \
		"boolean"; \
		"picture")
	
	If (Feature.with("inputControlArchive"))  //🚧
		
		$target:=Value type:C1509(PROJECT.info.target)=Is collection:K8:32 ? PROJECT.info.target : New collection:C1472(PROJECT.info.target)
		
		For each ($item; $folder.folders().combine($folder.files().query("extension = :1"; SHARED.archiveExtension)))
			
			$folder:=This:C1470._source($item)
			
			If ($folder=Null:C1517)
				
				continue  // Not a valid formatter
				
			End if 
			
			$file:=$folder.file("manifest.json")
			
			If (Not:C34($file.exists))
				
				continue  // Not a valid formatter
				
			End if 
			
			$manifest:=JSON Parse:C1218($file.getText())
			
			If ($manifest.choiceList#Null:C1517)
				
				continue  // We do not want choice list formatter, only custom one without data source.
				
			End if 
			
			If ($manifest.name=Null:C1517)\
				 || ($manifest.inject=Null:C1517)\
				 || ($manifest.type=Null:C1517)\
				 || ($manifest.capabilities=Null:C1517)
				
				continue  // The manifest.json shall contain the name, inject, type and capabilities attributes.
				
			Else 
				
				If ($manifest.target#Null:C1517)
					
					// Transform the target into a collection, if necessary
					$manifest.target:=(Value type:C1509($manifest.target)=Is collection:K8:32) ? $manifest.target : New collection:C1472(String:C10($manifest.target))
					
				Else 
					
					This:C1470._createTarget($manifest; $folder)  // The manifest.json shall contain the target attributes
					
				End if 
				
				If (($manifest.target.length=2) & ($target.length=2))\
					 || (($target.length=1) & ($manifest.target.indexOf($target[0])#-1))
					
					// I'm being nice to you and making a collection if not.
					$manifest.type:=Value type:C1509($manifest.type)=Is text:K8:3 ? New collection:C1472($manifest.type) : $manifest.type
					
					// Add to each type, the compatible formatter
					For each ($type; $manifest.type)
						
						$index:=$types.indexOf($type)
						
						If ($index>=0)
							
							$type:=Choose:C955($index; \
								"string"; \
								"number"; \
								"number"; \
								"bool"; \
								"image")
							
						End if 
						
						If ($formats[$type]=Null:C1517)
							
							continue  // IGNORE
							
						End if 
						
						$format:="/"+$manifest.name
						
						If ($formats[$type].indexOf($format)<0)
							
							$formats[$type].push($format)
							
						End if 
					End for each 
				End if 
			End if 
		End for each 
		
	Else 
		
		For each ($folder; $folder.folders())
			
			$file:=$folder.file("manifest.json")
			
			If (Not:C34($file.exists))
				
				continue  // Not a valid formatter
				
			End if 
			
			$manifest:=JSON Parse:C1218($file.getText())
			
			If ($manifest.choiceList#Null:C1517)
				
				continue  // We do not want choice list formatter, only custom one without data source.
				
			End if 
			
			// I'm being nice to you and making a collection if not.
			$manifest.type:=Value type:C1509($manifest.type)=Is text:K8:3 ? New collection:C1472($manifest.type) : $manifest.type
			
			If (Value type:C1509($manifest.type)#Is collection:K8:32)
				
				continue  // Not a valid formatter
				
			End if 
			
			// Add to each type, the compatible formatter
			For each ($type; $manifest.type)
				
				$index:=$types.indexOf($type)
				
				If ($index>=0)
					
					$type:=Choose:C955($index; \
						"string"; \
						"number"; \
						"number"; \
						"bool"; \
						"image")
					
				End if 
				
				If ($formats[$type]=Null:C1517)
					
					continue  // IGNORE
					
				End if 
				
				If ($formats[$type].indexOf("/"+$manifest.name)<0)
					
					$formats[$type].push("/"+$manifest.name)
					
				End if 
			End for each 
		End for each 
	End if 
	
	return $formats
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function checkFormat($name : Text) : Boolean
	
	var $manifest : Object
	var $target : Collection
	var $file : 4D:C1709.File
	var $folder : 4D:C1709.Folder
	
	$folder:=This:C1470.sourceFolder($name)
	
	If ($folder#Null:C1517)
		
		$file:=$folder.file("manifest.json")
		
		If ($file.exists)
			
			$manifest:=JSON Parse:C1218($file.getText())
			
			If ($manifest.target#Null:C1517)
				
				// Transform the target into a collection, if necessary
				$manifest.target:=(Value type:C1509($manifest.target)=Is collection:K8:32) ? $manifest.target : New collection:C1472(String:C10($manifest.target))
				
			Else 
				
				This:C1470._createTarget($manifest; $folder)  // The manifest.json shall contain the target attributes
				
			End if 
			
			$target:=Value type:C1509(PROJECT.info.target)=Is collection:K8:32 ? PROJECT.info.target : New collection:C1472(PROJECT.info.target)
			
			If (($manifest.target.length=2) & ($target.length=2))\
				 || (($target.length=1) & ($manifest.target.indexOf($target[0])#-1))
				
				return True:C214
				
			End if 
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Show current format on disk
Function showFormatOnDisk
	
	If (Feature.with("inputControlArchive"))  //🚧
		
		var $format : Text
		var $item : Object
		var $file : 4D:C1709.File
		var $folder : 4D:C1709.Folder
		
		$format:=Delete string:C232(This:C1470.current.format; 1; 1)
		$folder:=This:C1470.path.hostInputControls()
		
		For each ($item; $folder.folders().combine($folder.files().query("extension = :1"; SHARED.archiveExtension)))
			
			$folder:=This:C1470._source($item)
			$file:=$folder.file("manifest.json")
			
			If ($file.exists)
				
				If (JSON Parse:C1218($file.getText()).name=$format)
					
					SHOW ON DISK:C922($item.platformPath)
					break
					
				End if 
			End if 
		End for each 
		
	Else 
		
		SHOW ON DISK:C922(This:C1470.sourceFolder(Delete string:C232(This:C1470.current.format; 1; 1)).platformPath)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Format choice
Function formatMenuManager()
	
	var $currentFormat; $label; $newType; $type : Text
	var $hasCustom : Boolean
	var $index : Integer
	var $format : Variant
	var $current; $formats; $subMenu : Object
	var $menu : cs:C1710.menu
	
	$current:=This:C1470.current
	$currentFormat:=String:C10($current.format)
	
	$formats:=This:C1470.getFormats()
	$menu:=cs:C1710.menu.new("no-localization")
	
	If ((This:C1470.action.tableNumber#Null:C1517) && PROJECT.isFieldAttribute($current.name; Table name:C256(This:C1470.action.tableNumber)))
		
		$menu.append(":xliff:byDefault"; "null"; $current.format=Null:C1517).line()
		
		$type:=Choose:C955($current.type="text"; "string"; $current.type)
		
		For each ($format; $formats[$type])
			
			$hasCustom:=This:C1470._appendFormat(New object:C1471(\
				"menu"; $menu; \
				"type"; $type; \
				"format"; $format; \
				"custom"; $hasCustom; \
				"currentFormat"; $currentFormat))
			
		End for each 
		
		This:C1470._actionFormatterChoiceList($menu; $type)
		
	Else 
		
		For each ($type; $formats)
			
			If ($formats[$type].length>0)
				
				// Map string to text
				$label:=$type="string" ? "text" : $type
				
				$subMenu:=cs:C1710.menu.new("no-localization")\
					.append(":xliff:default"; $label; $currentFormat=$label).setData("type"; $label)\
					.line()
				
				$hasCustom:=False:C215  // To have a line by type
				
				For each ($format; $formats[$type])
					
					$hasCustom:=This:C1470._appendFormat(New object:C1471(\
						"menu"; $subMenu; \
						"type"; $type; \
						"format"; $format; \
						"custom"; $hasCustom; \
						"currentFormat"; $currentFormat))
					
				End for each 
				
				This:C1470._actionFormatterChoiceList($subMenu; $type)
				
				$menu.append(":xliff:"+$label; $subMenu)
				
			Else 
				
				$menu.append(":xliff:f_"+$type; $type; $currentFormat=$type)
				
			End if 
		End for each 
	End if 
	
	// Position according to the box
	If ($menu.popup(This:C1470.formatBorder; $current.type).selected)
		
		This:C1470.format.foregroundColor:=Foreground color:K23:1
		
		Case of 
				
				//________________________________________
			: ($menu.choice="null")
				
				OB REMOVE:C1226($current; "format")
				OB REMOVE:C1226($current; "source")
				OB REMOVE:C1226($current; "choiceList")
				
				//________________________________________
			: (Position:C15("/"; $menu.choice)=1)
				
				$current.format:=$menu.getData("format"; $menu.choice)
				$current.type:=$menu.getData("type"; $menu.choice)
				
				If (Not:C34(This:C1470._withDataSource(Delete string:C232($menu.choice; 1; 1))))
					
					OB REMOVE:C1226($current; "source")
					
				End if 
				
				//________________________________________
			Else 
				
				$current.format:=$menu.choice
				
				$newType:=$menu.getData("type"; $menu.choice)
				
				If ($newType=Null:C1517)
					
					If ($current.defaultField=Null:C1517)  // User parameter
						
						For each ($type; $formats) Until ($index#-1)
							
							$index:=$formats[$type].indexOf($current.format)
							
							If ($index#-1)
								
								$newType:=Choose:C955($type="string"; "text"; $type)
								
							End if 
						End for each 
						
						If ($index=-1)
							
							$newType:=$current.format
							
						End if 
					End if 
				End if 
				
				If ($current.type#$newType)  // The type is changed
					
					$current.type:=$newType  //Choose($newType="text"; "string"; $newType)
					
					If ($current.format=$current.type)
						
						OB REMOVE:C1226($current; "format")
						
					End if 
					
					OB REMOVE:C1226($current; "default")
					OB REMOVE:C1226($current; "source")
					OB REMOVE:C1226($current; "choiceList")
					
					If (This:C1470.defaultValue.focused)
						
						This:C1470.goTo(This:C1470.parameters.name)
						
					End if 
				End if 
				
				//________________________________________
		End case 
		
		PROJECT.save()
		
		This:C1470.update()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Data source choice
Function dataSourceMenuManager()
	
	var $current; $manifest; $o : Object
	var $parameter; $tab : Text
	var $controls; $subset : Collection
	var $file : 4D:C1709.File
	var $control; $folder : 4D:C1709.Folder
	var $menu : cs:C1710.menu
	
	$tab:="    "
	$current:=This:C1470.current
	$menu:=cs:C1710.menu.new("no-localization")
	
	// Search for custom input controls
	$folder:=This:C1470.path.hostInputControls()
	
	If (Not:C34($folder.exists))
		
		return 
		
	End if 
	
	$controls:=New collection:C1472
	
	For each ($control; $folder.folders())
		
		$file:=$control.files().query("fullName=:1"; "manifest.json").pop()
		
		If ($file=Null:C1517)
			
			continue
			
		End if 
		
		$manifest:=JSON Parse:C1218($file.getText())
		
		If ($manifest.choiceList#Null:C1517)
			
			$controls.push(New object:C1471(\
				"dynamic"; (Value type:C1509($manifest.choiceList)=Is object:K8:27) && ($manifest.choiceList.dataSource#Null:C1517); \
				"name"; $manifest.name; \
				"source"; $manifest.name; \
				"format"; Choose:C955($manifest.format#Null:C1517; $manifest.format; "push"); \
				"choiceList"; $manifest.choiceList\
				))
			
		End if 
	End for each 
	
	// Create a subset with the selected input control format of the current parameter
	$controls:=$controls.query("format = :1"; Delete string:C232($current.format; 1; 1))
	
	// Add static choice lists, if any
	$subset:=$controls.query("dynamic = :1"; False:C215)
	
	If ($subset.length>0)
		
		$menu.append(":xliff:choiceList").disable()
		
		For each ($o; $subset)
			
			$parameter:="/"+$o.source
			$menu.append($tab+$o.name; $parameter; String:C10($current.source)=$parameter)\
				.setData("choiceList"; $o.choiceList)\
				.setData("source"; "/"+$o.name)
			
		End for each 
		
		If (Feature.with("listEditor"))  //🚧
			
			// Allow to create a custom input control
			$menu.append(":xliff:newChoiceList"; "newChoiceList")
			
		End if 
		
		$menu.line()
		
	End if 
	
	// Add the lists of data sources for this data class, if any.
	$subset:=$controls.query("choiceList.dataSource.dataClass != null")
	
	If ($subset.length>0)
		
		$menu.append(":xliff:fromDataclass").disable()
		
		For each ($o; $subset)
			
			$parameter:="/"+$o.source
			$menu.append($tab+$o.name; $parameter; String:C10($current.source)=$parameter)\
				.setData("choiceList"; $o.choiceList)\
				.setData("source"; "/"+$o.name)
			
		End for each 
		
		If (Feature.with("listEditor"))  //🚧
			
			// Allow to create a custom input control
			$menu.append(":xliff:newDatasource"; "newDataSource")
			
		End if 
		
		$menu.line()
		
	End if 
	
	// Position according to the box
	If ($menu.popup(This:C1470.dataSourceBorder).selected)
		
		Case of 
				
				//______________________________________________________
			: ($menu.choice="newChoiceList")
				
				This:C1470._newUserControl(True:C214)
				
				//______________________________________________________
			: ($menu.choice="newDataSource")
				
				This:C1470._newUserControl(False:C215)
				
			: (Feature.with("listEditor")) & Macintosh option down:C545
				
				This:C1470.editList()
				
				//______________________________________________________
			Else 
				
				$current.source:=$menu.getData("source"; $menu.choice)
				
				PROJECT.save()
				
				This:C1470.update()
				
				//______________________________________________________
		End case 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function editList()
	
/*
												$form:=New object(\
																								"static"; $static; \
																								"host"; This.path.hostInputControls(True))
	
$form.folder:=This.path.hostInputControls()
$manifest:=$form.folder.file("manifest.json")
*/
	
	//===============================================================
Function ruleManager($name : Text)
	
	var $value : Variant
	var $rule : Object
	
	$value:=This:C1470[$name].getValue()
	
	If (Length:C16($value)>0)
		
		$value:=Num:C11($value)
		
		If (This:C1470.current.rules#Null:C1517)
			
			$rule:=This:C1470.current.rules.query($name+" != null").pop()
			
			If ($rule=Null:C1517)
				
				This:C1470.current.rules.push(New object:C1471($name; $value))
				
			Else 
				
				$rule[$name]:=$value
				
			End if 
			
		Else 
			
			If (This:C1470.current.rules=Null:C1517)
				
				This:C1470.current.rules:=New collection:C1472
				
			End if 
			
			This:C1470.current.rules.push(New object:C1471($name; $value))
			
		End if 
		
	Else 
		
		If (This:C1470.current.rules#Null:C1517)
			
			$rule:=This:C1470.current.rules.query($name+" != null").pop()
			
			If ($rule#Null:C1517)
				
				This:C1470.current.rules.remove(This:C1470.current.rules.indexOf($rule))
				
			End if 
			
			If (This:C1470.current.rules.length=0)
				
				OB REMOVE:C1226(This:C1470.current; "rules")
				
			End if 
		End if 
	End if 
	
	PROJECT.save()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function defaultValueManager()
	
	var $value : Text
	var $date : Date
	var $inError; $toRemove : Boolean
	var $current : Object
	
	$value:=This:C1470.defaultValue.getValue()
	
	$current:=This:C1470.current
	
	If (Length:C16(String:C10($value))>0)
		
		Case of 
				
				//______________________________________________________
			: ($current.type="number")
				
				$current.default:=Num:C11($value)
				
				//______________________________________________________
			: ($current.type="date")
				
				If (Match regex:C1019("(?m-si)^(?:today|tomorrow|yesterday)$"; $value; 1))
					
					$current.default:=$value
					
				Else 
					
					If (Match regex:C1019("(?m-si)^\\d+/\\d+/\\d+$"; $value; 1))
						
						// Use internal REST date format
						$date:=Date:C102($value)
						$current.default:=String:C10(Day of:C23($date); "00!")+String:C10(Month of:C24($date); "00!")+String:C10(Year of:C25($date); "0000")
						
					Else 
						
						$inError:=True:C214
						
					End if 
				End if 
				
				//______________________________________________________
			: ($current.type="bool")
				
				If (String:C10($current.format)="check")
					
					If (Match regex:C1019("(?m-is)^(?:checked|unchecked)$"; $value; 1))
						
						$current.default:=Bool:C1537($value="checked")
						
					Else 
						
						If (Match regex:C1019("(?m-is)^(?:0|1)$"; String:C10(Num:C11($value)); 1))
							
							$current.default:=Num:C11($value)
							
						Else 
							
							$inError:=True:C214
							
						End if 
					End if 
					
				Else 
					
					If (Match regex:C1019("(?m-is)^(?:true|false)$"; $value; 1))
						
						$current.default:=Bool:C1537($value="true")
						
					Else 
						
						If (Match regex:C1019("(?m-is)^(?:0|1)$"; String:C10(Num:C11($value)); 1))
							
							$current.default:=Num:C11($value)
							
						Else 
							
							$inError:=True:C214
							
						End if 
					End if 
				End if 
				
				//______________________________________________________
			: ($current.type="time")
				
				$current.default:=String:C10(Time:C179($value); HH MM:K7:2)
				
				//______________________________________________________
			Else 
				
				$current.default:=$value
				
				//______________________________________________________
		End case 
		
	Else 
		
		$toRemove:=True:C214
		
	End if 
	
	If ($inError)
		
		$toRemove:=True:C214
		This:C1470.defaultValue.focus()
		
	End if 
	
	If ($toRemove)
		
		OB REMOVE:C1226($current; "default")
		
	End if 
	
	PROJECT.save()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function nameManager($e : Object)
	
	Case of 
			
		: (String:C10(panel.action.scope)=This:C1470.globalScope)
			
			If ($e.code=On Before Keystroke:K2:6)
				
				$charCode:=Character code:C91(Keystroke:C390)
				
				If ($charCode=ReturnKey:K12:27)  // Validate
					
					FILTER KEYSTROKE:C389("")
					This:C1470.current.name:=Get edited text:C655
					This:C1470.postKeyDown(Tab:K15:37)
					This:C1470.update()
					
				End if 
			End if 
			
			//______________________________________________________
		: ($e.code=On Before Keystroke:K2:6)  // Filtering
			
			var $editedText; $value : Text
			var $charCode; $indx : Integer
			
			// Store the current value
			This:C1470.paramName.oldValue:=This:C1470.paramName.oldValue ? This:C1470.paramName.oldValue : This:C1470.paramName.getValue()
			
			$charCode:=Character code:C91(Keystroke:C390)
			$editedText:=Replace string:C233(Get edited text:C655; Char:C90(At sign:K15:46); "")
			$editedText:=Replace string:C233($editedText; Char:C90(ReturnKey:K12:27); "")
			$indx:=New collection:C1472(ReturnKey:K12:27; Escape:K15:39; Up arrow key:K12:18; Down arrow key:K12:19; Right arrow key:K12:17; Left arrow key:K12:16).indexOf($charCode)
			
			If ($indx>=0)
				
				Case of 
						
						//_________________________
					: (This:C1470.predicting.hidden)
						
						FILTER KEYSTROKE:C389("")
						This:C1470.current.name:=$editedText
						
						If ($indx=0)  // Return key
							
							This:C1470.postKeyDown(Tab:K15:37)
							
						End if 
						
						//_________________________
					: ($indx=0)  // Return key
						
						This:C1470.callChild(This:C1470.predicting; "PREDICTING_FILTER"; $charCode)
						$value:=String:C10(This:C1470.predicting.getValue().choice.value)
						
						If (Length:C16($value)>0)
							
							This:C1470.updateParamater($value)
							
						Else 
							
							This:C1470.updateParamater($editedText)
							
						End if 
						
						This:C1470.postKeyDown(Tab:K15:37)
						This:C1470.update()
						
						//_________________________
					: ($indx=1)  // Escape
						
						This:C1470.predicting.hide()
						
						//_________________________
					: ($indx>=4)  // Left, right
						
						This:C1470.current.name:=$editedText
						
						//_________________________
					Else   // Arrow keys
						
						This:C1470.current.name:=$editedText
						This:C1470.callChild(This:C1470.predicting; Formula:C1597(PREDICTING_FILTER).source; $charCode)
						This:C1470.paramName.highlightLastToEnd()
						
						//_________________________
				End case 
			End if 
			
			//______________________________________________________
		: ($e.code=On After Keystroke:K2:26)  // Update predicting
			
			var $key : Text
			var $o; $table : Object
			var $c : Collection
			
			$table:=Form:C1466.dataModel[String:C10(This:C1470.action.tableNumber)]
			
			$o:=This:C1470.predicting.getValue()
			$o.search:=Get edited text:C655
			$o.values:=New collection:C1472
			
			For each ($key; $table)
				
				If (Length:C16($key)=0)
					
					continue
					
				End if 
				
				var $field : cs:C1710.field
				$field:=$table[$key]
				
				If ($field.kind="storage")\
					 | ($field.kind="calculated")\
					 | (($field.kind="alias") && ($field.fieldType#Is object:K8:27) && ($field.fieldType#Is collection:K8:32))
					
					If ($field.fieldType#Is object:K8:27)
						
						If ($field.kind="storage")
							
							If (This:C1470.action.parameters.query("name = :1"; $field.name).pop()=Null:C1517)\
								 | ($field.name=This:C1470.current.name)
								
								$o.values.push($field.name)
								
							End if 
							
						Else 
							
							If (Not:C34(Bool:C1537($field.readOnly)))
								
								If (This:C1470.action.parameters.query("name = :1"; $key).pop()=Null:C1517)\
									 | ($key=This:C1470.current.name)
									
									$o.values.push($key)
									
								End if 
							End if 
						End if 
					End if 
				End if 
			End for each 
			
			This:C1470.predicting.setValue($o)
			
			//______________________________________________________
		: ($e.code=On Losing Focus:K2:8)
			
			This:C1470.predicting.hide()
			
			If (This:C1470.current#Null:C1517)
				
				$value:=This:C1470.paramName.getValue()
				
				If (Length:C16($value)=0)
					
					// Restore previous value
					This:C1470.updateParamater(This:C1470.paramName.oldValue)
					
					BEEP:C151
					This:C1470.paramName.focus()
					
				End if 
			End if 
			
			OB REMOVE:C1226(This:C1470.paramName; "oldValue")
			
			//______________________________________________________
		: ($e.code=On Data Change:K2:15)
			
			$value:=This:C1470.paramName.getValue()
			
			If (Length:C16($value)>0)
				
				This:C1470.updateParamater($value)
				
			End if 
			
			//______________________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function updateParamater($name : Text)
	
	var $identifier; $key : Text
	var $success : Boolean
	var $parameter; $tableModel : Object
	var $field : cs:C1710.field
	
	$parameter:=This:C1470.current
	
	If (This:C1470.action.tableNumber#Null:C1517)
		
		$tableModel:=Form:C1466.dataModel[String:C10(This:C1470.action.tableNumber)]
		
		For each ($key; $tableModel) Until ($success)
			
			If (Length:C16($key)=0)
				
				continue
				
			End if 
			
			$field:=$tableModel[$key]
			
			If ($field.fieldType#Null:C1517) && ($field.fieldType#Is object:K8:27)
				
				$identifier:=($field.name#Null:C1517 ? $field.name : $key)
				
				$success:=($identifier=$name)
				
				If ($success)
					
					$parameter.name:=$identifier
					$parameter.label:=$field.label
					$parameter.shortLabel:=$field.shortLabel
					$parameter.type:=PROJECT.fieldType2type($field.fieldType)
					
					If ($field.path#Null:C1517)
						
						$parameter.path:=$field.path
						
					Else 
						
						OB REMOVE:C1226($parameter; "path")
						
					End if 
					
					If (Num:C11($key)#0)
						
						$parameter.fieldNumber:=Num:C11($key)
						
					Else 
						
						OB REMOVE:C1226($parameter; "fieldNumber")
						
					End if 
					
					This:C1470.field.setValue(UI.str.localize("thisParameterIsLinkedToTheField"; $name))
					
				End if 
			End if 
		End for each 
	End if 
	If ($success)  // Linked to a field
		
		$parameter.defaultField:=PROJECT._actionDefaultField($parameter)
		
	Else 
		
		// Keep the user's entry & Delete the properties related to the field
		$parameter.name:=$name
		OB REMOVE:C1226($parameter; "fieldNumber")
		OB REMOVE:C1226($parameter; "path")
		OB REMOVE:C1226($parameter; "defaultField")
		
		This:C1470.field.setValue("")
		
	End if 
	
	This:C1470.paramName.setValue($parameter.name)
	
	PROJECT.save()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Set help tip
Function setHelpTip()
	
	var $currentValue : Text
	$currentValue:=String:C10(This:C1470.current.format)
	
	Case of 
			
			//________________________________________
		: (Length:C16($currentValue)=0)
			
			This:C1470.format.setHelpTip("")
			
			//________________________________________
		: (PROJECT.isCustomResource($currentValue))
			
			This:C1470.format.setHelpTip(This:C1470.formatToolTip($currentValue))
			
			//________________________________________
		Else 
			
			This:C1470.format.setHelpTip("")
			
			//________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Format tool tip
Function formatToolTip($format : Text)->$tip : Text
	
	var $o : Object
	var $file : 4D:C1709.File
	var $formatter : cs:C1710.formatter
	
	$formatter:=cs:C1710.formatter.new($format)
	
	If ($formatter.host)
		
		$file:=UI.path.hostInputControls().folder(Delete string:C232($format; 1; 1)).file("manifest.json")
		
		If ($file.exists)
			
			$o:=JSON Parse:C1218($file.getText())
			
			Case of 
					//______________________________________________________
				: ($o.choiceList#Null:C1517)
					
					$tip:=UI.str.jsonSimplify(JSON Stringify:C1217($o.choiceList; *))
					
					//______________________________________________________
				: ($o.homepage#Null:C1517)
					
					$tip:=String:C10($o.homepage)
					
					//______________________________________________________
			End case 
		End if 
		
	Else 
		
		// TODO: Edit resources.json to add "tips" to formatters in fieldBindingTypes
		
		//If (SHARED.resources.formattersByName=Null)
		//SHARED.resources.formattersByName:=New object
		//var $bind
		//For each ($bind; SHARED.resources.fieldBindingTypes.reduce(Formula(col_formula).source; New collection(); Formula($1.accumulator.combine(Choose($1.value=Null; New collection(); $1.value)))))
		//SHARED.resources.formattersByName[$bind.name]:=$bind
		//End for each
		//End if
		//$tips:=String(SHARED.resources.formattersByName[This.name].tips)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// <Background Color Expression> ******************** VERY SIMILAR TO ACTIONS.backgroundColor() ********************
Function backgroundColor($current : Object)->$color
	
	var $v  // could be an integer or a text
	var $isFocused : Boolean
	
	$color:="transparent"
	
	If (Num:C11(This:C1470.index)#0)
		
		$isFocused:=(OBJECT Get name:C1087(Object with focus:K67:3)=This:C1470.parameters.name)
		
		If (ob_equal(This:C1470.current; $current))  // Selected row
			
			$color:=Choose:C955($isFocused; UI.backgroundSelectedColor; UI.alternateSelectedColor)
			
		Else 
			
			$v:=Choose:C955($isFocused; UI.highlightColor; UI.highlightColorNoFocus)
			$color:=Choose:C955($isFocused; $v; "transparent")
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// <Meta info expression>
Function metaInfo($current : Object)->$result
	
	$result:=New object:C1471(\
		"stroke"; Choose:C955(UI.darkScheme; "white"; "black"); \
		"fontWeight"; "normal"; \
		"cell"; New object:C1471(\
		"names"; New object:C1471))
	
	$result.cell.names.stroke:=Choose:C955(UI.darkScheme; "white"; "black")
	
	//MARK:-
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Returns the root folder of a custom input control, even if it is an archive
Function _source($item : Object) : 4D:C1709.Folder
	
	var $folder : 4D:C1709.Folder
	
	If ($item.isFile)  // Archive
		
		$folder:=ZIP Read archive:C1637($item).root
		
		If ($folder.file("manifest.json").exists)
			
			return $folder
			
		End if 
		
		If ($folder.files().length=0)\
			 & ($folder.folders().length>0)
			
			return $folder.folders().query("name != '__MACOSX'").pop()
			
		End if 
		
	Else 
		
		return $item
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Create the "target" property according to the folders found
Function _createTarget($manifest : Object; $item : 4D:C1709.Folder)
	
	var $android; $ios : Boolean
	
	$manifest.target:=New collection:C1472
	
	$android:=($item.folders().query("name = android").pop()#Null:C1517)
	$ios:=($item.folders().query("name = ios").pop()#Null:C1517)
	
	Case of 
			
			//_______________________________________
		: ($android & $ios)
			
			$manifest.target.push("ios")
			$manifest.target.push("android")
			
			//_______________________________________
		: ($android)
			
			$manifest.target.push("android")
			
			//_______________________________________
		: ($ios)
			
			$manifest.target.push("ios")
			
			//_______________________________________
		Else 
			
			//invalid
			
			//_______________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function _getParameterFields($table : cs:C1710.table; $preset : Text) : Collection
	
	var $t : Text
	var $fields : Collection
	var $field : cs:C1710.field
	
	$fields:=New collection:C1472
	
	For each ($t; $table)
		
		If (Length:C16($t)=0)
			
			continue
			
		End if 
		
		$field:=OB Copy:C1225($table[$t])
		
		If ($field.kind="storage")
			
			$field.fieldNumber:=Num:C11($t)
			
		Else 
			
			$field.name:=$field.name=Null:C1517 ? $t : $field.name
			
		End if 
		
/* Allow
• Storage field
• Read-only computed field, only for a sort action.
• Scalar aliases (not pointing to an object field)
*/
		
		If ($field.kind="storage")\
			 || ($field.kind="alias")\
			 || (($field.kind="calculated") & (($preset="sort") || (Not:C34(Bool:C1537(ds:C1482[$table[""].name][$field.name].readOnly)))))
			
			If (($preset#"sort") || PROJECT.isSortable($field))
				
				If (This:C1470._isActionCompatibleField($field; $table[""].name))
					
					$fields.push($field)
					
				End if 
			End if 
		End if 
	End for each 
	
	return $fields
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function _isActionCompatibleField($field : cs:C1710.field; $table) : Boolean
	
	var $target : Object
	
	Case of 
			
			//______________________________________________________
		: ($field.kind="storage")\
			 | ($field.kind="calculated")
			
			return $field.fieldType#Is object:K8:27
			
			//______________________________________________________
		: ($field.kind="alias")
			
			If ($field.fieldType=Is collection:K8:32)
				
				return   // NOT SELECTION
				
			End if 
			
			// Get the targeted field
			$target:=PROJECT.getAliasTarget($table; $field)
			
			// Scalar alias not corresponding to an object field
			return ($target.fieldType#Null:C1517) && ($target.fieldType#Is object:K8:27)
			
			//______________________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function _withDataSource($format : Text)->$with : Boolean
	
	var $manifest : Object
	var $file : 4D:C1709.File
	
	$with:=This:C1470.customInputControls.indexOf($format)>=0
	
	If (Not:C34($with))
		
		$file:=This:C1470.path.hostInputControls().file($format+"/manifest.json")
		
		If ($file.exists)
			
			$manifest:=JSON Parse:C1218($file.getText())
			$with:=$manifest.choiceList#Null:C1517
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function _addParameter($parameter : Object)
	
	var $label : Text
	var $index : Integer
	var $o : Object
	
	If (This:C1470.action.parameters=Null:C1517)
		
		This:C1470.action.parameters:=New collection:C1472
		
	Else 
		
		$label:=$parameter.name
		
		If (This:C1470.action.parameters.query("name=:1"; $label).length=0)
			
			// <NOTHING MORE TO DO>
			
		Else 
			
			Repeat 
				
				$index:=$index+1
				
				$o:=This:C1470.action.parameters.query("name=:1"; $label+String:C10($index)).pop()
				
				If ($o=Null:C1517)
					
					$parameter.name:=$label+String:C10($index)
					
				End if 
			Until ($o=Null:C1517)
		End if 
	End if 
	
	This:C1470.action.parameters.push($parameter)
	PROJECT.save()
	
	This:C1470.parameters.focus()
	This:C1470.saveContext($parameter)
	This:C1470.parameters.reveal(This:C1470.parameters.rowsNumber+Num:C11(This:C1470.parameters.rowsNumber=0))
	This:C1470.refresh()
	
Function _newUserControl($static : Boolean)
	
	var $current; $data; $form; $o : Object
	var $c : Collection
	
	$current:=This:C1470.current
	
	$data:=New object:C1471(\
		"$comment"; "Map database values to some display values using choiceList")
	
	Case of 
			
			//______________________________________________________
		: (($current.type="bool")\
			 | ($current.type="boolean"))
			
			$data.$doc:=Get localized string:C991("creatingDataFormatterIntegerToString")
			
			//________________________________________
		: (($current.type="number")\
			 | ($current.type="integer")\
			 | ($current.type="real"))
			
			$data.$doc:=Get localized string:C991("creatingDataFormatterIntegerToString")
			
			//________________________________________
		: (($current.type="string")\
			 | ($current.type="text"))
			
			$data.$doc:=Get localized string:C991("creatingDataFormatterText")
			
			//______________________________________________________
	End case 
	
	$data.name:=""
	$data.type:=$current.type
	$data.binding:=False:C215
	$data.format:=Delete string:C232($current.format; 1; 1)
	
	$form:=New object:C1471(\
		"static"; $static; \
		"host"; This:C1470.path.hostInputControls(True:C214))
	
	// Fixme:🚧 for the development stage
	If (Component.isMatrix)
		
		$form.window:=Open form window:C675("LISTE_EDITOR"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
		
	Else 
		
		$form.window:=Open form window:C675("LISTE_EDITOR"; Movable form dialog box:K39:8; Horizontally centered:K39:1; Vertically centered:K39:4)
		
	End if 
	
	$data.dial:=$form
	DIALOG:C40("LISTE_EDITOR"; $data)
	
	If (Bool:C1537(OK))
		
		OB REMOVE:C1226($data; "dial")
		
		// Create the source folder
		$form.folder.create()
		
		// Create the manifest
		If ($data.$.static)
			
			$data.choiceList:=New object:C1471
			
			For each ($o; $data.$.choiceList)
				
				$data.choiceList[$o.key]:=$o.value
				
			End for each 
			
			If ($data.binding)
				
				// Delete unused images
				$c:=cs:C1710.ob.new($data.choiceList).toCollection()
				
				For each ($o; $form.folder.folder("images").files())
					
					If ($c.indexOf($o.fullName)=-1)
						
						$o.delete()
						
					End if 
				End for each 
				
			Else 
				
				OB REMOVE:C1226($data; "binding")
				$form.folder.folder("images").delete(Delete with contents:K24:24)
				
			End if 
			
		Else 
			
			OB REMOVE:C1226($data; "binding")
			$form.folder.folder("images").delete(Delete with contents:K24:24)
			
		End if 
		
		// Select the created input control
		This:C1470.current.source:="/"+$form.folder.name
		
		// Save
		OB REMOVE:C1226($data; "$")
		cs:C1710.ob.new($data).save($form.folder.file("manifest.json"))
		
	Else 
		
		// Fixme:🚧 for the development stage
		If (Database.isComponent)  // Test purpose
			
			$form.folder.delete(Delete with contents:K24:24)
			
		End if 
	End if 
	
	CLOSE WINDOW:C154($form.window)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function _appendFormat($data : Object)->$custom : Boolean
	
	var $format : Variant
	
	$format:=$data.format
	
	If ((Value type:C1509($format)=Is object:K8:27)\
		 || (PROJECT.isCustomResource($format)))
		
		If (Not:C34($data.custom))
			
			$data.menu.line()  // Separate custom by a line
			$data.custom:=True:C214
			
		End if 
		
		If (Value type:C1509($format)=Is object:K8:27)
			
			$data.menu.append($format.name; ("/"+$format.name); ($data.currentFormat=("/"+$format.name)))\
				.setStyle(Italic:K14:3)
			
		Else   // text
			
			$data.menu.append(Delete string:C232($format; 1; 1); $format; $data.currentFormat=$format)\
				.setStyle(Italic:K14:3)
			
		End if 
		
	Else 
		
		$data.menu.append(":xliff:f_"+$format; $format; $data.currentFormat=$format)
		
	End if 
	
	$data.menu\
		.setData("type"; $data.type)\
		.setData("format"; $format)
	
	$custom:=$data.custom
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function _actionFormatterChoiceList($menu : cs:C1710.menu; $type : Text)
	
	var $control; $parameter : Text
	var $selected : Boolean
	
	If (This:C1470.typesAllowingCustomInputControls.indexOf($type)>=0)
		
		$menu.line()
		
		$menu.append("selectionControls").disable()
		
		For each ($control; This:C1470.customInputControls)
			
			$parameter:="/"+$control+"/"+$type
			$selected:=$parameter=(String:C10(This:C1470.current.format)+"/"+This:C1470.current.type)
			
			$menu.append($control; $parameter; $selected)\
				.setData("type"; $type)\
				.setData("format"; "/"+$control)
			
		End for each 
	End if 
	