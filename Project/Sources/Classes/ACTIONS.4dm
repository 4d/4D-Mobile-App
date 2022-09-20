Class extends panel

Class constructor
	
	Super:C1705(Formula:C1597(editor_CALLBACK).source)
	
	This:C1470.context:=Super:C1706.init()
	
	If (OB Is empty:C1297(This:C1470.context))
		
		This:C1470.init()
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Design definition
Function init()
	
	var $group : cs:C1710.group
	
	This:C1470.toBeInitialized:=False:C215
	
	This:C1470.subform("noDataModel")
	
	This:C1470.listbox("actions")
	This:C1470.formObject("actionsBorder"; "actions.border")
	
	This:C1470.button("add")
	This:C1470.button("remove")
	
	$group:=This:C1470.group("databaseMethodGroup")
	This:C1470.button("databaseMethod").addToGroup($group)
	This:C1470.formObject("databaseMethodLabel"; "databaseMethod.label").addToGroup($group)
	
	This:C1470.widget("iconPicker")
	This:C1470.formObject("dropCursor")
	
	// Link to the ACTIONS_PARAMS panel
	This:C1470.parametersLink:=Formula:C1597(panel("ACTIONS_PARAMS"))
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Events handler
Function handleEvents($e : Object)
	
	If ($e.objectName=Null:C1517)  // <== FORM METHOD
		
		$e:=Super:C1706.handleEvents(On Load:K2:1; On Timer:K2:25; On Resize:K2:27)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Load:K2:1)
				
				This:C1470.loadActions()
				This:C1470.onLoad()
				
				//______________________________________________________
			: ($e.code=On Timer:K2:25)
				
				This:C1470.update()
				
				//______________________________________________________
			: ($e.code=On Resize:K2:27)
				
				ui_SET_GEOMETRY(This:C1470.context.constraints.rules)
				
				//______________________________________________________
		End case 
		
	Else   // <== WIDGETS METHOD
		
		Case of 
				
				//==============================================
			: (This:C1470.actions.catch())
				
				Case of 
						
						//_____________________________________
					: ($e.code=On Selection Change:K2:29)
						
						This:C1470.$current:=This:C1470.current
						
						// Update parameters panel
						This:C1470.updateParameters()
						
						// Update UI
						This:C1470.refresh()
						
						//_____________________________________
					: ($e.code=On Getting Focus:K2:7)
						
						This:C1470.actions.foregroundColor:=Foreground color:K23:1
						This:C1470.actionsBorder.foregroundColor:=UI.selectedColor
						
						If (Bool:C1537(This:C1470.actions.inEdition))
							
							This:C1470.updateParameters()
							
						End if 
						
						//_____________________________________
					: ($e.code=On Losing Focus:K2:8)
						
						If (Bool:C1537(This:C1470.actions.inEdition))  // Focus is lost after editing a cell
							
							OB REMOVE:C1226(This:C1470.actions; "inEdition")
							
							If (String:C10($e.columnName)="shorts")
								
								// Update parameters panel
								This:C1470.updateParameters()
								
							End if 
							
						Else 
							
							This:C1470.actions.foregroundColor:=Foreground color:K23:1
							This:C1470.actionsBorder.foregroundColor:=UI.backgroundUnselectedColor
							
						End if 
						
						//_____________________________________
					: (UI.isLocked()) | (Num:C11($e.row)=0)
						
						// <NOTHING MORE TO DO>
						
						//_____________________________________
					: ($e.code=On Clicked:K2:4)
						
						Case of 
								
								//………………………………………………………………
							: ($e.columnName="icons")
								
								This:C1470.showIconPicker()
								
								//………………………………………………………………
						End case 
						
						//_____________________________________
					: ($e.code=On Before Data Entry:K2:39)
						
						Case of 
								
								//………………………………………………………………
							: (New collection:C1472("names"; "shorts"; "labels").indexOf($e.columnName)#-1)
								
								// Set a flag to manage On Losing Focus
								This:C1470.actions.inEdition:=True:C214
								
								//………………………………………………………………
							: ($e.columnName="tables")
								
								This:C1470.tableMenuManager()
								
								//………………………………………………………………
							: ($e.columnName="scopes")
								
								This:C1470.scopeMenuManager()
								
								//………………………………………………………………
						End case 
						
						//_____________________________________
					: ($e.code=On Double Clicked:K2:5)
						
						If (New collection:C1472("names"; "shorts"; "labels").indexOf($e.columnName)#-1)
							
							EDIT ITEM:C870(*; $e.columnName; Num:C11(This:C1470.index))
							
						End if 
						
						//_____________________________________
					: ($e.code=On Mouse Leave:K2:34)
						
						This:C1470.dropCursor.hide()
						
						//_____________________________________
					: ($e.code=On Data Change:K2:15)
						
						If (String:C10(This:C1470.current.preset)="sort")
							
							// Redmine:#129995 : The value of the short label that is displayed shall be equal
							// To the value that is available for the long label
							This:C1470.current.shortLabel:=This:C1470.current.label
							
						End if 
						
						//_____________________________________
				End case 
				
				//==============================================
			: (This:C1470.add.catch())
				
				Case of 
						
						//_____________________________
					: ($e.code=On Alternative Click:K2:36)
						
						This:C1470.addMenuManager()
						
						//_____________________________
					: ($e.code=On Clicked:K2:4)
						
						This:C1470.newAction()
						
						//_____________________________
				End case 
				
				//==============================================
			: (This:C1470.remove.catch())
				
				This:C1470.removeAction()
				
				//==============================================
			: (This:C1470.databaseMethod.catch())
				
				This:C1470.openOnMobileAppActionDatabaseMethod()
				
				//==============================================
		End case 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	// This trick remove the horizontal gap
	This:C1470.actions.setScrollbars(0; 2)
	
	// Set the initial display
	If ((Form:C1466.dataModel#Null:C1517) && Not:C34(OB Is empty:C1297(Form:C1466.dataModel)))
		
		This:C1470.actions.show().updateDefinition()
		This:C1470.noDataModel.hide()
		
		This:C1470.add.enable()
		This:C1470.databaseMethod.enable()
		
		This:C1470.dropCursor.foregroundColor:=Highlight menu background color:K23:7
		
		If ((Form:C1466.actions#Null:C1517) && (Form:C1466.actions.length>0))
			
			// Select last used action (or the first one)
			If (This:C1470.$current#Null:C1517)
				
				var $indx : Integer
				$indx:=Form:C1466.actions.indexOf(This:C1470.$current)
				This:C1470.actions.select($indx+1)
				
			Else 
				
				This:C1470.actions.select(1)
				
			End if 
			
			This:C1470.updateParameters()
			
		End if 
		
		This:C1470.actions.focus()
		
	Else 
		
		This:C1470.actions.hide()
		This:C1470.noDataModel.show()
		
		This:C1470.add.disable()
		This:C1470.databaseMethod.disable()
		
	End if 
	
	// Preload the icons
	This:C1470.callMeBack("loadActionIcons")
	
	// Give the focus to the actions listbox
	This:C1470.actions.focus()
	
	// Add the events that we cannot select in the form properties 😇
	This:C1470.appendEvents(New collection:C1472(On Alternative Click:K2:36; On Before Data Entry:K2:39; On Data Change:K2:15))
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Update UI
Function update()
	
	var $success : Boolean
	ARRAY TEXT:C222($paths; 0)
	
	This:C1470.updateParameters()
	
	This:C1470.remove.enable((Form:C1466.actions#Null:C1517) && (Form:C1466.actions.length>0))
	
	METHOD GET PATHS:C1163(Path database method:K72:2; $paths; *)
	$success:=(Find in array:C230($paths; METHOD Get path:C1164(Path database method:K72:2; "onMobileAppAction"))>0)
	This:C1470.databaseMethod.setTitle(Choose:C955($success; "edit..."; "create..."))
	This:C1470.databaseMethod.enable($success | ((Form:C1466.actions#Null:C1517) && (Form:C1466.actions.length>0)))
	
	This:C1470.databaseMethodGroup.distributeRigthToLeft(New object:C1471("spacing"; 20))
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Update parameters panel, if present
Function updateParameters($action : Object)
	
	var $o : Object
	
	$o:=This:C1470.parametersLink.call()
	
	If ($o#Null:C1517)
		
		// Use current item if not passed
		$o.action:=$action || This:C1470.current
		
		This:C1470.callMeBack("refreshParameters")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Internal drop for actions
Function actionListManager()->$allow : Integer
	
	var $uri : Text
	var $e; $me; $o : Object
	
	$uri:="com.4d.private.4dmobile.action"
	
	$e:=FORM Event:C1606
	$e.row:=Drop position:C608
	
	Case of 
			
			//______________________________________________________
		: (UI.isLocked())
			
			$allow:=-1  // Reject drop
			
			//______________________________________________________
		: ($e.code=On Begin Drag Over:K2:44)
			
			This:C1470.beginDrag($uri; New object:C1471(\
				"src"; This:C1470.index))
			
			//______________________________________________________
		: ($e.code=On Drag Over:K2:13)
			
			$allow:=-1  // Reject drop
			
			$o:=This:C1470.getPasteboard($uri)
			
			If ($o#Null:C1517)
				
				$me:=This:C1470.actions
				
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
			
			//______________________________________________________
		: ($e.code=On Drop:K2:12)
			
			$o:=This:C1470.getPasteboard($uri)
			
			If ($o#Null:C1517)
				
				$o.tgt:=Drop position:C608
				
				If ($o.src#$o.tgt)
					
					If ($o.tgt=-1)  // After the last line
						
						Form:C1466.actions.push(This:C1470.current)
						Form:C1466.actions.remove($o.src-1)
						
					Else 
						
						Form:C1466.actions.insert($o.tgt-1; This:C1470.current)
						
						If ($o.tgt<$o.src)
							
							Form:C1466.actions.remove($o.src)
							
						Else 
							
							Form:C1466.actions.remove($o.src-1)
							
						End if 
					End if 
					
					PROJECT.save()
					
				End if 
				
				This:C1470.dropCursor.hide()
				This:C1470.actions.touch()
				
			End if 
			
			//______________________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Load project actions
Function loadActions()
	
	var $icon : Picture
	var $action : Object
	var $file : 4D:C1709.File
	
	If (Form:C1466.actions#Null:C1517)
		
		// Compute icons
		For each ($action; Form:C1466.actions)
			
			$action.$icon:=UI.getIcon($action.icon)
			
		End for each 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function loadIcons()
	
	This:C1470.iconPicker.setValue(editor_LoadIcons(New object:C1471("target"; "actionIcons")))
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Return from the icons' picker
Function setIcon($data : Object)
	
	This:C1470.current.icon:=$data.pathnames[$data.item-1]
	PROJECT.save()
	
	// Update UI
	var $p : Picture
	$p:=$data.pictures[$data.item-1]
	CREATE THUMBNAIL:C679($p; $p; 24; 24; Scaled to fit:K6:2)
	This:C1470.current.$icon:=$p
	This:C1470.actions.touch()
	
	This:C1470.refresh()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function newAction($tableNumber : Integer)
	
	var $action : Object
	
	$action:=PROJECT.actionNew($tableNumber)
	
	$action.$icon:=UI.getIcon("")
	This:C1470._addAction($action)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function addMenuManager()
	
	var $t : Text
	var $action; $field; $o : Object
	var $c : Collection
	var $addMenu; $deleteMenu; $editMenu; $fieldsMenu; $menu; $newMenu; $openURLMenu; $shareMenu; $sortMenu : cs:C1710.menu
	
	// Extract datamodel to collection
	$c:=New collection:C1472
	
	For each ($t; Form:C1466.dataModel)
		
		$c.push(New object:C1471(\
			"tableID"; $t; \
			"tableName"; Form:C1466.dataModel[$t][""].name))
		
	End for each 
	
	If ($c.length>1)
		
		$newMenu:=cs:C1710.menu.new()
		$addMenu:=cs:C1710.menu.new()
		$editMenu:=cs:C1710.menu.new()
		$deleteMenu:=cs:C1710.menu.new()
		$shareMenu:=cs:C1710.menu.new()
		$sortMenu:=cs:C1710.menu.new()
		
		If (Feature.with("openURLAction"))
			
			$openURLMenu:=cs:C1710.menu.new()
			
		End if 
		
		$menu:=cs:C1710.menu.new()\
			.append(":xliff:newActionFor"; $newMenu)\
			.line()\
			.append(":xliff:addActionFor"; $addMenu)\
			.append(":xliff:editActionFor"; $editMenu)\
			.append(":xliff:deleteActionFor"; $deleteMenu)\
			.append(":xliff:shareActionFor"; $shareMenu)\
			.append(":xliff:sortActionFor"; $sortMenu)
		
		If (Feature.with("openURLAction"))
			
			$menu.append(":xliff:openURLActionFor"; $openURLMenu)
			
		End if 
		
		For each ($o; $c)
			
			$newMenu.append($o.tableName; "new_"+$o.tableID)
			$addMenu.append($o.tableName; "add_"+$o.tableID)
			$editMenu.append($o.tableName; "edit_"+$o.tableID)
			$deleteMenu.append($o.tableName; "delete_"+$o.tableID)
			$shareMenu.append($o.tableName; "share_"+$o.tableID)
			
			If (Feature.with("openURLAction"))
				
				$openURLMenu.append($o.tableName; "openURL_"+$o.tableID)
				
			End if 
			
			$fieldsMenu:=cs:C1710.menu.new()
			
			For each ($field; PROJECT.getSortableFields(Form:C1466.dataModel[$o.tableID]; True:C214))
				
				$fieldsMenu.append($field.name; "sort_"+$o.tableID+","+($field.fieldNumber#Null:C1517 ? String:C10($field.fieldNumber) : $field.name))
				
			End for each 
			
			$sortMenu.append($o.tableName; $fieldsMenu)
			
		End for each 
		
	Else 
		
		$o:=$c[0]
		
		$menu:=cs:C1710.menu.new()\
			.append(":xliff:newAction"; "new")\
			.line()\
			.append(":xliff:addAction"; "add_"+$o.tableID)\
			.append(":xliff:editAction"; "edit_"+$o.tableID)\
			.append(":xliff:deleteAction"; "delete_"+$o.tableID)\
			.append(":xliff:shareAction"; "share_"+$o.tableID)
		
		$fieldsMenu:=cs:C1710.menu.new()
		
		For each ($field; PROJECT.getSortableFields(Form:C1466.dataModel[$o.tableID]; True:C214))
			
			If ($field.kind="storage")
				
				$fieldsMenu.append($field.name; "sort_"+$o.tableID+","+($field.fieldNumber#Null:C1517 ? String:C10($field.fieldNumber) : $field.name))
				
			Else 
				
				$fieldsMenu.append($field.name; "sort_"+$o.tableID+","+$field.name)
				
			End if 
		End for each 
		
		$menu.append(":xliff:sortAction"; $fieldsMenu)
		
		If (Feature.with("openURLAction"))
			
			$menu.append(":xliff:openURLAction"; "openURL_"+$o.tableID)
			
		End if 
	End if 
	
	$menu.popup(This:C1470.add)
	
	If ($menu.selected)
		
		Case of 
				
				//______________________________________________________
			: ($menu.choice="new")
				
				This:C1470.newAction()
				
				//______________________________________________________
			: ($menu.choice="new_@")
				
				$t:=Replace string:C233($menu.choice; "new_"; "")
				This:C1470.newAction(Num:C11($t))
				
				//______________________________________________________
			Else 
				
				$t:=$menu.choice
				
				$menu.edit:=($t="edit_@")
				$menu.delete:=($t="delete_@")
				$menu.add:=($t="add_@")
				$menu.share:=($t="share_@")
				$menu.sort:=($t="sort_@")
				$menu.openURL:=($t="openURL_@")
				
				$t:=Replace string:C233($t; "edit_"; "")
				$t:=Replace string:C233($t; "delete_"; "")
				$t:=Replace string:C233($t; "add_"; "")
				$t:=Replace string:C233($t; "share_"; "")
				$t:=Replace string:C233($t; "sort_"; "")
				$t:=Replace string:C233($t; "openURL_"; "")
				
				If ($menu.sort)
					
					$c:=Split string:C1554($t; ",")
					$menu.tableID:=$c[0]
					$menu.fieldID:=$c[1]
					
				Else 
					
					$menu.tableID:=$t
					
				End if 
				
				Case of 
						
						//______________________________________________________
					: ($menu.add)
						
						$action:=PROJECT.actionAdd($menu.tableID)
						$action.$icon:=UI.getIcon("actions 2/Add.svg")
						This:C1470._addAction($action)
						
						//______________________________________________________
					: ($menu.edit)
						
						$action:=PROJECT.actionEdit($menu.tableID)
						$action.$icon:=UI.getIcon("actions/Edit.svg")
						This:C1470._addAction($action)
						
						//______________________________________________________
					: ($menu.delete)
						
						$action:=PROJECT.actionDelete($menu.tableID)
						$action.$icon:=UI.getIcon("actions/Delete.svg")
						This:C1470._addAction($action)
						
						//______________________________________________________
					: ($menu.sort)
						
						$action:=PROJECT.actionSort($menu.tableID; $menu.fieldID)
						$action.$icon:=UI.getIcon("actions/Sort.svg")
						This:C1470._addAction($action)
						
						//______________________________________________________
					: ($menu.share)
						
						$action:=PROJECT.actionShare($menu.tableID)
						$action.$icon:=UI.getIcon("actions/Send-basic.svg")
						This:C1470._addAction($action)
						
						//______________________________________________________
					: ($menu.openURL)
						
						$action:=PROJECT.actionURL($menu.tableID)
						$action.$icon:=UI.getIcon("actions/Globe.svg")
						This:C1470._addAction($action)
						
						//______________________________________________________
					Else 
						
						oops
						
						//______________________________________________________
				End case 
				
				//______________________________________________________
		End case 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Create, if any, & Open the "On Mobile Action" Database method
Function openOnMobileAppActionDatabaseMethod()
	
	var $code : Text
	var $i : Integer
	var $o : Object
	var $c : Collection
	var $file : 4D:C1709.File
	
	ARRAY TEXT:C222($methods; 0)
	
	METHOD GET PATHS:C1163(Path database method:K72:2; $methods; *)
	$methods{0}:=METHOD Get path:C1164(Path database method:K72:2; "onMobileAppAction")
	
	If (Macintosh option down:C545)\
		 & (Structure file:C489=Structure file:C489(*))
		
		If (Find in array:C230($methods; $methods{0})>0)
			
			// Delete to recreate.
			// WARNING: Generates an error if the method is open
			File:C1566("/PACKAGE/Project/Sources/DatabaseMethods/onMobileAppAction.4dm").delete()
			DELETE FROM ARRAY:C228($methods; Find in array:C230($methods; $methods{0}))
			
		End if 
	End if 
	
	// Create method if not exist
	If (Find in array:C230($methods; $methods{0})=-1)
		
		If (Command name:C538(1)="Somme")
			
			// FR language
			$file:=File:C1566("/RESOURCES/fr.lproj/onMobileAppAction.4dm")
			
		Else 
			
			$file:=File:C1566("/RESOURCES/onMobileAppAction.4dm")
			
		End if 
		
		If ($file.exists)\
			 && (Form:C1466.actions#Null:C1517)
			
			// Delete actions performed locally on the mobile
			$c:=Form:C1466.actions.query("NOT(preset IN :1)"; New collection:C1472("sort"; "openURL")).copy()
			
			If ($c.length>0)
				
				For ($i; 0; $c.length-1; 1)
					
					$o:=$c[$i]
					
					If ($o.scope="table")
						
						$o.comment:=String:C10(project.dataModel[String:C10($o.tableNumber)][""].name)+" dataclass"
						
					Else 
						
						$o.comment:=String:C10(project.dataModel[String:C10($o.tableNumber)][""].name)+" entity"
						
					End if 
				End for 
				
				PROCESS 4D TAGS:C816($file.getText(); $code; $c)
				
			End if 
		End if 
		
		METHOD SET CODE:C1194($methods{0}; $code; *)
		
	End if 
	
	// Open method
	METHOD OPEN PATH:C1213($methods{0}; *)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function removeAction()
	
	var $index : Integer
	
	$index:=PROJECT.removeAction(This:C1470.current)
	
	// Update UI
	This:C1470.actions.doSafeSelect($index+1)  // Collection index to listbox index
	This:C1470.refresh()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Display published table menu
Function tableMenuManager()
	
	var $t : Text
	var $menu : cs:C1710.menu
	
	If (This:C1470.current.scope#"global")
		
		$menu:=cs:C1710.menu.new()
		
		For each ($t; Form:C1466.dataModel)
			
			$menu.append(Form:C1466.dataModel[$t][""].name; $t; Num:C11(This:C1470.current.tableNumber)=Num:C11($t))
			
		End for each 
		
		If (This:C1470.actions.popup($menu).selected)
			
			This:C1470.current.tableNumber:=Num:C11($menu.choice)
			PROJECT.save()
			
			// Update UI
			This:C1470.refresh()
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Display scope menu
Function scopeMenuManager()
	
	var $preset; $t : Text
	var $i : Integer
	var $menu : cs:C1710.menu
	
	$preset:=String:C10(This:C1470.current.preset)
	
	$menu:=cs:C1710.menu.new()
	
	Repeat 
		
		$i+=1
		$t:=Get localized string:C991("scope_"+String:C10($i))
		
		If (Length:C16($t)>0)
			
			$menu.append(":xliff:"+$t; $t; String:C10(This:C1470.current.scope)=$t)
			
			Case of 
					
					//________________________________________
				: ($i=1)\
					 & ($preset="delete")  // Table
					
					$menu.disable()
					
					//________________________________________
				: ($i=2)\
					 & (($preset="add") | ($preset="sort"))  // Current entity
					
					$menu.disable()
					
					//________________________________________
			End case 
		End if 
	Until (Length:C16($t)=0)
	
	If (This:C1470.actions.popup($menu).selected)
		
		This:C1470.current.scope:=$menu.choice
		PROJECT.save()
		
		// Update UI
		This:C1470.refresh()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Open the icons picker
Function showIconPicker()
	
	var $coordinates; $o : Object
	
	If (This:C1470.current#Null:C1517)
		
		$o:=This:C1470.iconPicker.getValue()
		
		$o.item:=$o.pathnames.indexOf(String:C10(This:C1470.current.icon))
		$o.item+=1  // ⚠️ Widget work with array
		
		$o.row:=This:C1470.actions.row
		
		// Get current cell coordinates
		$coordinates:=This:C1470.actions.cellCoordinates()
		$o.left:=$coordinates.left
		$o.top:=34
		$o.right:=This:C1470.actionsBorder.coordinates.right
		
		$o.action:="actionIcons"
		
		If (UI.darkScheme)
			
			$o.background:="black"
			$o.backgroundStroke:="white"
			
		Else 
			
			$o.background:="white"
			$o.backgroundStroke:=UI.strokeColor
			
		End if 
		
		$o.promptColor:=0x00FFFFFF
		$o.promptBackColor:=UI.strokeColor
		
		$o.hidePromptSeparator:=True:C214
		$o.forceRedraw:=True:C214
		
		$o.prompt:=UI.str.localize("chooseAnIconForTheAction"; String:C10(This:C1470.current.name))
		
		This:C1470.callMeBack("pickerShow"; $o)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function _addAction($action : Object)
	
	This:C1470.actions.focus()
	This:C1470.actions.reveal(This:C1470.actions.rowsNumber+Num:C11(This:C1470.actions.rowsNumber=0))
	This:C1470.updateParameters($action)
	This:C1470.refresh()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Text displayed in the Tables column
Function tableLabel($data : Object) : Text
	
	return Num:C11($data.tableNumber)#0 ? Table name:C256($data.tableNumber) : Get localized string:C991("choose...")
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Text displayed in the Scope column
Function scopeLabel($data : Object) : Text
	
	return Get localized string:C991(String:C10($data.scope))
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// <Background Color Expression> ******************** VERY SIMILAR TO ACTIONS_PARAMS.backgroundColor() ********************
Function backgroundColor($current : Object) : Variant
	
	var $v  // could be an integer or a text
	var $isFocused : Boolean
	
	If (Num:C11(This:C1470.index)#0)
		
		$isFocused:=(OBJECT Get name:C1087(Object with focus:K67:3)=This:C1470.actions.name)
		
		If (FORM Event:C1606.isRowSelected)
			
			return $isFocused ? UI.backgroundSelectedColor : UI.alternateSelectedColor
			
		Else 
			
			return $isFocused ? ($isFocused ? UI.highlightColor : UI.highlightColorNoFocus) : "transparent"
			
		End if 
	End if 
	
	return "transparent"
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// <Meta info expression>
Function metaInfo($current : Object) : Object
	
	var $meta : Object
	
	// Default values
	$meta:=New object:C1471(\
		"stroke"; UI.darkScheme ? "white" : "black"; \
		"fontWeight"; "normal"; \
		"cell"; New object:C1471(\
		"tables"; New object:C1471; \
		"names"; New object:C1471; \
		"shorts"; New object:C1471))
	
	// Mark not or missing assigned table
	If (Form:C1466.dataModel[String:C10($current.tableNumber)]=Null:C1517)
		
		$meta.cell.tables.stroke:=$current.scope="global" ? "silver" : UI.errorRGB
		
	Else 
		
		// Not assigned table
		If (Num:C11($current.tableNumber)=0)
			
			$meta.cell.names.stroke:=UI.errorRGB
			
		End if 
	End if 
	
	// Mark duplicate names
	If (Form:C1466.actions.indices("name = :1"; $current.name).length>1)
		
		$meta.cell.names.stroke:=UI.errorRGB
		
	End if 
	
	// The short label value of a sort action must be greyed
	If (String:C10($current.preset)="sort")
		
		$meta.cell.shorts.stroke:="silver"
		
	End if 
	
	return $meta