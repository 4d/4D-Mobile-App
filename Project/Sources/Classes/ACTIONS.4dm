Class extends form

Class constructor
	
	Super:C1705("editor_CALLBACK")
	
	This:C1470.context:=editor_Panel_init(This:C1470.name)
	
	If (OB Is empty:C1297(This:C1470.context))
		
		This:C1470.isSubform:=True:C214
		
		This:C1470.init()
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function init()
	
	This:C1470.toBeInitialized:=False:C215
	
	// Widgets definition
	This:C1470.noPublishedTable:=cs:C1710.widget.new("noPublishedTable")
	This:C1470.actions:=cs:C1710.listbox.new("actions").updateDefinition()
	This:C1470.actionsBorder:=cs:C1710.static.new("actions.border")
	
	This:C1470.add:=cs:C1710.button.new("actions.add")
	This:C1470.remove:=cs:C1710.button.new("actions.remove")
	
	This:C1470.databaseMethod:=cs:C1710.button.new("actionMethod")
	This:C1470.databaseMethodLabel:=cs:C1710.static.new("actionMethod.label")
	This:C1470.databaseMethodGroup:=cs:C1710.group.new(This:C1470.databaseMethod; This:C1470.databaseMethodLabel)
	
	This:C1470.iconPicker:=cs:C1710.widget.new("iconGrid")
	This:C1470.dropCursor:=cs:C1710.static.new("dropCursor")
	
	// Link to the ACTIONS_PARAMS panel
	This:C1470.parametersLink:=Formula:C1597(panel("ACTIONS_PARAMS"))
	
	Folder:C1567(fk desktop folder:K87:19).file("DEV/listbox.json").setText(JSON Stringify:C1217(This:C1470.actions; *))
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Load project actions
Function load()
	
	var $icon : Picture
	var $action : Object
	var $file : 4D:C1709.File
	
	If (Form:C1466.actions#Null:C1517)
		
		// Compute icons
		
		For each ($action; Form:C1466.actions)
			
			If (Length:C16(String:C10($action.icon))=0)
				
				READ PICTURE FILE:C678(EDITOR.noIcon; $icon)
				
			Else 
				
				$file:=EDITOR.path.icon(String:C10($action.icon))
				
				If ($file.exists)
					
					READ PICTURE FILE:C678($file.platformPath; $icon)
					
				Else 
					
					READ PICTURE FILE:C678(EDITOR.errorIcon; $icon)
					
				End if 
			End if 
			
			CREATE THUMBNAIL:C679($icon; $icon; 24; 24; Scaled to fit:K6:2)
			$action.$icon:=$icon
			
		End for each 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function loadIcons()
	
	This:C1470.iconPicker.setValue(editor_LoadIcons(New object:C1471("target"; "actionIcons")))
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Update UI
Function update()
	
	var $success : Boolean
	ARRAY TEXT:C222($methods; 0)
	
	This:C1470.updateParameters()
	
	This:C1470.remove.enable(Num:C11(This:C1470.index)#0)
	
	METHOD GET PATHS:C1163(Path database method:K72:2; $methods; *)
	$success:=(Find in array:C230($methods; METHOD Get path:C1164(Path database method:K72:2; "onMobileAppAction"))>0)
	This:C1470.databaseMethod.setTitle(Choose:C955($success; "edit..."; "create..."))
	This:C1470.databaseMethod.enable($success | _and(Formula:C1597(Form:C1466.actions#Null:C1517); Formula:C1597(Form:C1466.actions.length>0)))
	
	This:C1470.databaseMethodGroup.distributeRigthToLeft(New object:C1471("spacing"; 20))
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Update parameters panel, if present
Function updateParameters($action : Object)
	
	var $o : Object
	
	$o:=This:C1470.parametersLink()
	
	If ($o#Null:C1517)
		
		If (Count parameters:C259=0)
			
			// Use current
			$o.action:=This:C1470.current
			
		Else 
			
			$o.action:=$action
			
		End if 
		
		This:C1470.callMeBack("refreshParameters")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function doNewAction()
	
	var $t : Text
	var $i; $index : Integer
	var $icon : Picture
	var $action : Object
	var $c : Collection
	
	READ PICTURE FILE:C678(EDITOR.noIcon; $icon)
	CREATE THUMBNAIL:C679($icon; $icon; 24; 24; Scaled to fit:K6:2)
	
	$t:="action_"+String:C10($index)
	
	If (Form:C1466.actions#Null:C1517)
		
		// Generate a unique name
		$index:=Form:C1466.actions.count()+1
		
		Repeat 
			
			$c:=Form:C1466.actions.query("name=:1"; $t)
			
			If ($c.length>0)
				
				$index:=$index+1
				$t:="action_"+String:C10($index)
				
			End if 
		Until ($c.length=0)
	End if 
	
	$action:=New object:C1471(\
		"name"; $t; \
		"scope"; "table"; \
		"shortLabel"; $t; \
		"label"; $t; \
		"$icon"; $icon)
	
	// Auto define the target table if only one is published
	For each ($t; Form:C1466.dataModel) While ($i<2)
		
		$i:=$i+1
		
	End for each 
	
	If ($i=1)
		
		$action.tableNumber:=Num:C11($t)
		
	End if 
	
	This:C1470._addAction($action)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function doAddMenu()
	
	var $t : Text
	var $icon : Picture
	var $i : Integer
	var $action; $field; $parameter; $table : Object
	var $c; $fields : Collection
	var $addMenu; $deleteMenu; $editMenu; $menu; $shareMenu : cs:C1710.menu
	
	$menu:=cs:C1710.menu.new().append(":xliff:newAction"; "new").line()
	
	$addMenu:=cs:C1710.menu.new()
	$menu.append(":xliff:addActionFor"; $addMenu)
	
	$editMenu:=cs:C1710.menu.new()
	$menu.append(":xliff:editActionFor"; $editMenu)
	
	$deleteMenu:=cs:C1710.menu.new()
	$menu.append(":xliff:deleteActionFor"; $deleteMenu)
	
	$shareMenu:=cs:C1710.menu.new()
	$menu.append(":xliff:shareActionFor"; $shareMenu)
	
	For each ($t; Form:C1466.dataModel)
		
		$addMenu.append(Form:C1466.dataModel[$t][""].name; "add_"+$t)
		$editMenu.append(Form:C1466.dataModel[$t][""].name; "edit_"+$t)
		$deleteMenu.append(Form:C1466.dataModel[$t][""].name; "delete_"+$t)
		$shareMenu.append(Form:C1466.dataModel[$t][""].name; "share_"+$t)
		
	End for each 
	
	$menu.popup(This:C1470.add)
	
	If ($menu.selected)
		
		Case of 
				
				//______________________________________________________
			: ($menu.choice="new")
				
				This:C1470.doNewAction()
				
				//______________________________________________________
			Else 
				
				$t:=$menu.choice
				
				$menu.edit:=($t="edit_@")
				$menu.delete:=($t="delete_@")
				$menu.add:=($t="add_@")
				$menu.share:=($t="share_@")
				
				$t:=Replace string:C233($t; "edit_"; "")
				$t:=Replace string:C233($t; "delete_"; "")
				$t:=Replace string:C233($t; "add_"; "")
				$t:=Replace string:C233($t; "share_"; "")
				
				$menu.table:=$t
				$menu.tableNumber:=Num:C11($t)
				
				Case of 
						
						//……………………………………………………………………
					: ($menu.edit)
						
						$menu.preset:="edition"
						$menu.prefix:="edit"
						$menu.icon:="actions/Edit.svg"
						$menu.scope:="currentRecord"
						$menu.label:=Get localized string:C991("edit...")
						READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/tableIcons/actions/Edit.svg").platformPath; $icon)
						
						//……………………………………………………………………
					: ($menu.add)
						
						$menu.preset:="adding"
						$menu.prefix:="add"
						$menu.icon:="actions 2/Add.svg"
						$menu.scope:="table"
						$menu.label:=Get localized string:C991("add...")
						READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/tableIcons/actions 2/Add.svg").platformPath; $icon)
						
						//……………………………………………………………………
					: ($menu.delete)
						
						$menu.preset:="suppression"
						$menu.prefix:="delete"
						$menu.icon:="actions/Delete.svg"
						$menu.scope:="currentRecord"
						$menu.label:=Get localized string:C991("remove")
						READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/tableIcons/actions/Delete.svg").platformPath; $icon)
						
						//……………………………………………………………………
					: ($menu.share)
						
						$menu.preset:="share"
						$menu.prefix:="share"
						$menu.icon:="actions/Send-basic.svg"
						$menu.scope:="currentRecord"
						$menu.label:=Get localized string:C991("share...")
						READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/tableIcons/actions/Send-basic.svg").platformPath; $icon)
						$menu.description:=""
						
						//……………………………………………………………………
				End case 
				
				CREATE THUMBNAIL:C679($icon; $icon; 24; 24; Scaled to fit:K6:2)
				
				$table:=Form:C1466.dataModel[$menu.table]
				
				// Generate a unique name
				$t:=cs:C1710.str.new(formatString("label"; $table[""].name)).uperCamelCase()
				
				$menu.name:=$menu.prefix+$t
				
				If (Form:C1466.actions#Null:C1517)
					
					Repeat 
						
						$c:=Form:C1466.actions.query("name=:1"; $menu.name)
						
						If ($c.length>0)
							
							$i:=$i+1+Num:C11($i=0)
							$menu.name:=$menu.prefix+$t+String:C10($i)
							
						End if 
					Until ($c.length=0)
				End if 
				
				$action:=New object:C1471(\
					"preset"; $menu.preset; \
					"icon"; $menu.icon; \
					"$icon"; $icon; \
					"tableNumber"; $menu.tableNumber; \
					"scope"; $menu.scope; \
					"name"; $menu.name; \
					"shortLabel"; $menu.label; \
					"label"; $menu.label)
				
				Case of 
						
						//______________________________________________________
					: ($menu.delete)
						
						$action.style:="destructive"
						
						//______________________________________________________
					: ($menu.share)
						
						$action.description:=$menu.description
						
						//______________________________________________________
					Else 
						
						$action.parameters:=New collection:C1472
						
						$fields:=catalog("fields"; New object:C1471("tableName"; $table[""].name)).fields
						
						For each ($t; $table)
							
							Case of 
									
									//……………………………………………………………………
								: (Length:C16($t)=0)
									
									// <NOTHING MORE TO DO>
									
									//……………………………………………………………………
								: (PROJECT.isField($t))
									
									If ($table[$t].name#$table[""].primaryKey)  // DO NOT ADD A PRIMARY KEY
										
										$field:=$fields.query("name = :1"; $table[$t].name).pop()
										
										$parameter:=New object:C1471(\
											"fieldNumber"; $field.fieldNumber; \
											"name"; cs:C1710.str.new($table[$t].name).lowerCamelCase(); \
											"label"; $table[$t].label; \
											"shortLabel"; $table[$t].shortLabel; \
											"type"; Choose:C955($field.fieldType=Is time:K8:8; "time"; $field.valueType))
										
										If ($menu.edit)
											
											$parameter.defaultField:=formatString("field-name"; $table[$t].name)
											
										End if 
										
										If ($parameter#Null:C1517)
											
											If (Bool:C1537($field.mandatory))
												
												$parameter.rules:=New collection:C1472("mandatory")
												
											End if 
											
											// Preset formats
											Case of 
													
													//................................
												: ($field.fieldType=Is integer:K8:5)\
													 | ($field.fieldType=Is longint:K8:6)\
													 | ($field.fieldType=Is integer 64 bits:K8:25)
													
													$parameter.format:="integer"
													
													//................................
												: ($parameter.type="date")
													
													$parameter.format:="shortDate"
													
													//................................
											End case 
											
											$action.parameters.push($parameter)
											
										End if 
									End if 
									
									//……………………………………………………………………
								: (Value type:C1509($table[$t])#Is object:K8:27)
									
									// <NOTHING MORE TO DO>
									
									//……………………………………………………………………
								: (PROJECT.isRelation($table[$t]))
									
									//
									
									//……………………………………………………………………
							End case 
						End for each 
						
						//______________________________________________________
				End case 
				
				//______________________________________________________
		End case 
		
		This:C1470._addAction($action)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function doRemoveAction()
	
	var $index : Integer
	
	This:C1470.removeFocus()
	
	$index:=Form:C1466.actions.indexOf(This:C1470.current)
	
	If ($index#-1)
		
		Form:C1466.actions.remove($index; 1)
		PROJECT.save()
		
		If (Num:C11(This:C1470.index)>This:C1470.actions.rowsNumber())
			
			This:C1470.actions.unselect()
			
			This:C1470.index:=0
			This:C1470.current:=Null:C1517
			
		Else 
			
			This:C1470.actions.select(Num:C11(This:C1470.index))
			
		End if 
		
		This:C1470.updateParameters()
		
	End if 
	
	This:C1470.refresh()
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Display published table menu
Function doTableMenu()
	
	var $t : Text
	var $menu : cs:C1710.menu
	
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
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Display scope menu
Function doScopeMenu()
	
	var $t : Text
	var $i : Integer
	var $menu : cs:C1710.menu
	
	$menu:=cs:C1710.menu.new()
	
	Repeat 
		
		$i:=$i+1
		$t:=Get localized string:C991("scope_"+String:C10($i))
		
		If (Length:C16($t)>0)  // #ACI0100966
			
			$menu.append(":xliff:"+$t; $t; String:C10(This:C1470.current.scope)=$t)
			
			Case of 
					
					//________________________________________
				: ($i=1)\
					 & (String:C10(This:C1470.current.preset)="suppression")  // Table
					
					$menu.disable()
					
					//________________________________________
				: ($i=2)\
					 & (String:C10(This:C1470.current.preset)="adding")  // Current entity
					
					$menu.disable()
					
					//________________________________________
			End case 
		End if 
	Until (Length:C16($t)=0)  // #ACI0100966
	
	If (This:C1470.actions.popup($menu).selected)
		
		This:C1470.current.scope:=$menu.choice
		PROJECT.save()
		
		// Update UI
		This:C1470.refresh()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Initialization of the internal D&D for actions
Function doBeginDrag()
	
	var $x : Blob
	var $o : Object
	
	$o:=New object:C1471(\
		"src"; This:C1470.index)
	
	// Put into the container
	VARIABLE TO BLOB:C532($o; $x)
	APPEND DATA TO PASTEBOARD:C403("com.4d.private.4dmobile.action"; $x)
	SET BLOB SIZE:C606($x; 0)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Internal drop for actions
Function doOnDrop()
	
	var $x : Blob
	var $o : Object
	
	// Get the pastboard
	GET PASTEBOARD DATA:C401("com.4d.private.4dmobile.action"; $x)
	
	If (Bool:C1537(OK))
		
		BLOB TO VARIABLE:C533($x; $o)
		SET BLOB SIZE:C606($x; 0)
		
		$o.tgt:=Drop position:C608
		
	End if 
	
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
	End if 
	
	This:C1470.dropCursor.hide()
	
	This:C1470.actions.touch()
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Open the icons picker
Function doShowIconPicker()
	
	var $o : Object
	$o:=This:C1470.iconPicker.getValue()
	
	$o.item:=$o.pathnames.indexOf(String:C10(This:C1470.current.icon))
	$o.item:=$o.item+1  // Widget work with array
	
	$o.row:=This:C1470.actions.row
	
	$o.left:=This:C1470.actions.cellBox.right
	$o.top:=34
	
	$o.action:="actionIcons"
	
	$o.background:=0x00FFFFFF
	$o.backgroundStroke:=EDITOR.strokeColor
	$o.promptColor:=0x00FFFFFF
	$o.promptBackColor:=EDITOR.strokeColor
	$o.hidePromptSeparator:=True:C214
	$o.forceRedraw:=True:C214
	$o.prompt:=EDITOR.str.setText("chooseAnIconForTheAction").localized(String:C10(This:C1470.current.name))
	
	This:C1470.callMeBack("pickerShow"; $o)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function _addAction($action : Object)
	
	If ($action#Null:C1517)  // An action was created
		
		// Ensure the action collection exists
		If (Form:C1466.actions=Null:C1517)
			
			Form:C1466.actions:=New collection:C1472
			
		End if 
		
		Form:C1466.actions.push($action)
		PROJECT.save()
		
		// Update UI
		This:C1470.actions.focus()
		This:C1470.actions.reveal(This:C1470.actions.rowsNumber()+Num:C11(This:C1470.actions.rowsNumber()=0))
		
		This:C1470.updateParameters($action)
		
		// Warning edit stop code execution -> must be delegate
		//EDIT ITEM(*;$Obj_form.name;Form.actions.length)
		
		This:C1470.refresh()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Create, if any, & Open the "On Mobile Action" Database method
Function doOpenDatabaseMethod()
	
	var $code : Text
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
		
		If ($file.exists)
			
			PROCESS 4D TAGS:C816($file.getText(); $code; Form:C1466.actions.extract("name"); Form:C1466.actions.extract("label"))
			METHOD SET CODE:C1194($methods{0}; $code; *)
			
		End if 
		
	End if 
	
	// Open method
	METHOD OPEN PATH:C1213($methods{0}; *)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Text displayed in the Tables column
Function tableLabel($data : Object)->$label : Text
	
	If (Num:C11($data.tableNumber)#0)
		
		$label:=Table name:C256($data.tableNumber)
		
	Else 
		
		// Invite
		$label:=Get localized string:C991("choose...")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Text displayed in the Scope column
Function scopeLabel($data : Object)->$label : Text
	
	$label:=Get localized string:C991(String:C10($data.scope))
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// <Background Color Expression>
Function backgroundColor($current : Object)->$color
	
	var $v  // could be an integer or a text
	var $isFocused : Boolean
	
	$color:="transparent"
	
	If (Num:C11(This:C1470.index)#0)
		
		$isFocused:=(OBJECT Get name:C1087(Object with focus:K67:3)=This:C1470.actions.name)
		
		If (ob_equal(This:C1470.current; $current))  // Selected row
			
			$color:=Choose:C955($isFocused; EDITOR.backgroundSelectedColor; EDITOR.alternateSelectedColor)
			
		Else 
			
			$v:=Choose:C955($isFocused; EDITOR.highlightColor; EDITOR.highlightColorNoFocus)
			$color:=Choose:C955($isFocused; $v; "transparent")
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// <Meta info expression>
Function metaInfo($current : Object)->$result
	
	// Default values
	$result:=New object:C1471(\
		"stroke"; Choose:C955(EDITOR.isDark; "white"; "black"); \
		"fontWeight"; "normal"; \
		"cell"; New object:C1471(\
		"tables"; New object:C1471; \
		"names"; New object:C1471))
	
	// Mark not or missing assigned table
	If (Form:C1466.dataModel[String:C10($current.tableNumber)]=Null:C1517)
		
		// Not published table
		$result.cell.tables.stroke:=EDITOR.errorRGB
		
	Else 
		
		// Not assigned table
		$result.cell.tables.stroke:=Choose:C955(Num:C11($current.tableNumber)=0; EDITOR.errorRGB; Choose:C955(EDITOR.isDark; "white"; "black"))
		
	End if 
	
	// Mark duplicate names
	$result.cell.names.stroke:=Choose:C955(Form:C1466.actions.indices("name = :1"; $current.name).length>1; EDITOR.errorRGB; Choose:C955(EDITOR.isDark; "white"; "black"))