Class extends form

Class constructor()
	
	var $t : Text
	
	Super:C1705(Formula:C1597(editor_CALLBACK).source)
	
	This:C1470.colorScheme:=""
	
	// Mark: Associated worker
	This:C1470.worker:="4D Mobile ("+String:C10(This:C1470.window)+")"
	
	This:C1470.design()
	
	// Mark:Embedded classes
	For each ($t; New collection:C1472(\
		"str"; \
		"path"; \
		"tips"; \
		"svg"))
		
		This:C1470._instantiate($t)
		
	End for each 
	
	// Load preferences
	This:C1470.preferences:=cs:C1710.preferences.new().user("4D Mobile App.preferences")
	
	This:C1470.updateColorScheme()
	This:C1470.preload()
	
	This:C1470.pendingTasks:=New collection:C1472
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function get unsynchronizedTables()->$sesult : Collection
	
	$sesult:=Form:C1466.$dialog.unsynchronizedTables
	
	//MARK:-
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Definition of the editor pages and panels used
Function design()
	
	var $o : Object
	
	This:C1470.pages:=New object:C1471
	This:C1470.currentPage:=""
	
	// MARK:GENERAL
	This:C1470.pages.general:=New object:C1471(\
		"panels"; New collection:C1472)
	
	$o:=This:C1470.pages.general
	
	$o.panels.push(New object:C1471(\
		"title"; Get localized string:C991("targetOs"); \
		"form"; "TARGET"))
	
	$o.panels.push(New object:C1471(\
		"title"; Get localized string:C991("organization"); \
		"form"; "ORGANIZATION"))
	
	$o.panels.push(New object:C1471(\
		"title"; Get localized string:C991("product"); \
		"form"; "PRODUCT"))
	
	$o.panels.push(New object:C1471(\
		"title"; Get localized string:C991("developer"); \
		"form"; "DEVELOPER"))
	
	// MARK:STRUCTURE
	This:C1470.pages.structure:=New object:C1471(\
		"panels"; New collection:C1472)
	
	$o:=This:C1470.pages.structure
	
	$o.panels.push(New object:C1471(\
		"title"; Get localized string:C991("publishedStructure"); \
		"form"; "STRUCTURE"; \
		"noTitle"; True:C214))
	
	$o.action:=New object:C1471(\
		"title"; "syncDataModel"; \
		"show"; False:C215; \
		"formula"; Formula:C1597(UI.postMessage(New object:C1471(\
		"action"; "show"; \
		"type"; "confirm"; \
		"title"; "updateTheProject"; \
		"additional"; "aBackupWillBeCreatedIntoTheProjectFolder"; \
		"ok"; "update"; \
		"okFormula"; Formula:C1597(UI.callMeBack("syncDataModel")))))\
		)
	
	// MARK:PROPERTIES
	This:C1470.pages.properties:=New object:C1471(\
		"panels"; New collection:C1472)
	
	$o:=This:C1470.pages.properties
	
	$o.panels.push(New object:C1471(\
		"title"; Get localized string:C991("tablesProperties"); \
		"form"; "TABLES"))
	
	$o.panels.push(New object:C1471(\
		"title"; Get localized string:C991("fieldsProperties"); \
		"form"; "FIELDS"; \
		"noTitle"; True:C214))
	
	// MARK:MAIN
	This:C1470.pages.main:=New object:C1471(\
		"panels"; New collection:C1472)
	
	$o:=This:C1470.pages.main
	
	$o.panels.push(New object:C1471(\
		"title"; Get localized string:C991("mainMenu"); \
		"form"; "MAIN"; \
		"noTitle"; True:C214))
	
	// MARK:VIEWS
	This:C1470.pages.views:=New object:C1471(\
		"panels"; New collection:C1472)
	
	$o:=This:C1470.pages.views
	
	$o.panels.push(New object:C1471(\
		"title"; Get localized string:C991("forms"); \
		"form"; "VIEWS"; \
		"noTitle"; True:C214))
	
	$o.action:=New object:C1471(\
		"title"; ".Repair the project"; \
		"show"; False:C215; \
		"formula"; Formula:C1597(UI.postMessage(New object:C1471(\
		"action"; "show"; \
		"type"; "confirm"; \
		"title"; "updateTheProject"; \
		"additional"; "aBackupWillBeCreatedIntoTheProjectFolder"; \
		"ok"; "update"; \
		"okFormula"; Formula:C1597(UI.callMeBack("syncDataModel")))))\
		)
	
	// MARK:DEPLOYMENT
	This:C1470.pages.deployment:=New object:C1471(\
		"panels"; New collection:C1472)
	
	$o:=This:C1470.pages.deployment
	
	$o.panels.push(New object:C1471(\
		"title"; Get localized string:C991("server"); \
		"form"; "SERVER"))
	
	$o.panels.push(New object:C1471(\
		"title"; Get localized string:C991("features"); \
		"form"; "FEATURES"))
	
	If (False:C215)
		
		$o.panels.push(New object:C1471(\
			"title"; "UI FOR DEMO PURPOSE"; \
			"form"; "UI"))
		
	End if 
	
	// MARK:DATA
	This:C1470.pages.data:=New object:C1471(\
		"panels"; New collection:C1472)
	
	$o:=This:C1470.pages.data
	
	$o.panels.push(New object:C1471(\
		"title"; Get localized string:C991("source"); \
		"form"; "SOURCE"; \
		"help"; True:C214))
	
	$o.panels.push(New object:C1471(\
		"title"; Get localized string:C991("properties"); \
		"form"; "DATA"; \
		"help"; True:C214))
	
	// MARK:ACTIONS
	This:C1470.pages.actions:=New object:C1471(\
		"panels"; New collection:C1472)
	
	$o:=This:C1470.pages.actions
	
	$o.panels.push(New object:C1471(\
		"form"; "ACTIONS"; \
		"noTitle"; True:C214))
	
	$o.panels.push(New object:C1471(\
		"title"; Get localized string:C991("page_action_params"); \
		"form"; "ACTIONS_PARAMS"; \
		"noTitle"; True:C214))
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Design definition
Function init()
	
	var $group : cs:C1710.group
	
	This:C1470.toBeInitialized:=False:C215
	
	This:C1470.subform("ribbon")
	This:C1470.subform("description")
	This:C1470.subform("project")
	This:C1470.subform("footer")
	
	$group:=This:C1470.group("taskUI")
	This:C1470.thermometer("taskIndicator").addToGroup($group)
	This:C1470.formObject("taskDescription").addToGroup($group)
	
	This:C1470.subform("browser")
	
	$group:=This:C1470.group("messageGroup")
	This:C1470.subform("message").addToGroup($group)
	This:C1470.button("messageButton").addToGroup($group)
	This:C1470.formObject("messageBack").addToGroup($group)
	
	// Create the context, id any
	If (Form:C1466.$dialog=Null:C1517)
		
		Logger.info("📍 Create Form.$dialog (EDITOR)")
		Form:C1466.$dialog:=New object:C1471
		
	End if 
	
	If (Form:C1466.$dialog[This:C1470.currentForm]=Null:C1517)
		
		Logger.info("🚧 Create "+This:C1470.currentForm+"'s context (class "+Current method name:C684+")")
		Form:C1466.$dialog[This:C1470.currentForm]:=New object:C1471
		
	End if 
	
	This:C1470.context:=Form:C1466.$dialog[This:C1470.currentForm]
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	This:C1470.init()
	
	This:C1470.project.setScrollbars(0; 2)
	This:C1470.taskIndicator.barber().start()
	This:C1470.message.setValue(New object:C1471)
	
	// DEV items
	OBJECT SET VISIBLE:C603(*; "debug.@"; Bool:C1537(Component.isMatrix))
	
	// Launch the worker
	This:C1470.callWorker(Formula:C1597(COMPILER_COMPONENT).source)
	
	This:C1470.tips.default()
	
	This:C1470.goToPage("general")
	This:C1470.project.focus()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Pre-loading of constant resources
Function preload()
	
	// FIELD TYPE NAMES
	This:C1470.typeNames:=New collection:C1472
	This:C1470.typeNames[Is alpha field:K8:1]:=Get localized string:C991("alpha")
	This:C1470.typeNames[Is integer:K8:5]:=Get localized string:C991("integer")
	This:C1470.typeNames[Is longint:K8:6]:=Get localized string:C991("longInteger")
	This:C1470.typeNames[Is integer 64 bits:K8:25]:=Get localized string:C991("integer64Bits")
	This:C1470.typeNames[Is real:K8:4]:=Get localized string:C991("real")
	This:C1470.typeNames[_o_Is float:K8:26]:=Get localized string:C991("float")
	This:C1470.typeNames[Is boolean:K8:9]:=Get localized string:C991("boolean")
	This:C1470.typeNames[Is time:K8:8]:=Get localized string:C991("time")
	This:C1470.typeNames[Is date:K8:7]:=Get localized string:C991("date")
	This:C1470.typeNames[Is text:K8:3]:=Get localized string:C991("text")
	This:C1470.typeNames[Is picture:K8:10]:=Get localized string:C991("picture")
	
	This:C1470.noIcon:=File:C1566("/RESOURCES/images/noIcon.svg").platformPath
	This:C1470.errorIcon:=File:C1566("/RESOURCES/images/errorIcon.svg").platformPath
	
	This:C1470.alert:="🚫"
	This:C1470.warning:="❗"
	
	This:C1470.toOne:="⑴"
	This:C1470.toMany:="⒩"
	
	OBSOLETE
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// [Warning] Executed every time the editor is activated to adapt UI to the color scheme
Function updateColorScheme()
	
	var $key : Text
	var $icon : Picture
	var $update : Boolean
	var $file : 4D:C1709.File
	
	This:C1470.selectedColor:=Highlight menu background color:K23:7
	This:C1470.alternateSelectedColor:=Disable highlight item color:K23:9
	
	If (This:C1470.darkScheme)
		
		$update:=This:C1470.colorScheme#"dark"
		
		If ($update)
			
			Logger.info("Update colorScheme to dark")
			
			This:C1470.colorScheme:="dark"
			
			// * PRE-LOADING ICONS FOR FIELD TYPES
			This:C1470.fieldIcons:=New collection:C1472
			
			For each ($file; Folder:C1567("/RESOURCES/images/dark/fieldsIcons").files(Ignore invisible:K24:16))
				
				READ PICTURE FILE:C678($file.platformPath; $icon)
				This:C1470.fieldIcons[Num:C11(Replace string:C233($file.name; "field_"; ""))]:=$icon
				
			End for each 
			
			READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/dark/user.png").platformPath; $icon)
			This:C1470.userIcon:=$icon
			
			READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/dark/filter.png").platformPath; $icon)
			This:C1470.filterIcon:=$icon
			
			// * DEFINE COLORS
			This:C1470.strokeColor:=0x00083C56
			This:C1470.highlightColor:=Background color:K23:2
			This:C1470.highlightColorNoFocus:=Background color:K23:2
			
			This:C1470.backgroundSelectedColor:=Highlight text background color:K23:5
			This:C1470.backgroundUnselectedColor:=Highlight text background color:K23:5
			
			This:C1470.selectedFillColor:="darkgray"
			This:C1470.unselectedFillColor:="black"
			
			This:C1470.commentColor:="white"
			
			This:C1470.errorColor:=0x00E61C70
			This:C1470.errorRGB:="rgb(230,28,112)"
			
			This:C1470.warningColor:=0x00FF4500
			This:C1470.warningRGB:="orangered"
			
		End if 
		
	Else 
		
		$update:=This:C1470.colorScheme#"light"
		
		If ($update)
			
			Logger.info("Update colorScheme to light")
			
			This:C1470.colorScheme:="light"
			
			// * PRE-LOADING ICONS FOR FIELD TYPES
			This:C1470.fieldIcons:=New collection:C1472
			
			For each ($file; Folder:C1567("/RESOURCES/images/light/fieldsIcons").files(Ignore invisible:K24:16))
				
				READ PICTURE FILE:C678($file.platformPath; $icon)
				This:C1470.fieldIcons[Num:C11(Replace string:C233($file.name; "field_"; ""))]:=$icon
				
			End for each 
			
			READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/light/user.png").platformPath; $icon)
			This:C1470.userIcon:=$icon
			
			READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/light/filter.png").platformPath; $icon)
			This:C1470.filterIcon:=$icon
			
			// * DEFINE COLORS
			This:C1470.strokeColor:=0x001AA1E5
			This:C1470.highlightColor:=0x00FFFFFF
			This:C1470.highlightColorNoFocus:=0x00FFFFFF
			
			This:C1470.backgroundSelectedColor:=0x00E7F8FF
			This:C1470.backgroundUnselectedColor:=0x00C9C9C9
			
			This:C1470.selectedFillColor:="gray"
			This:C1470.unselectedFillColor:="white"
			
			This:C1470.commentColor:="rgb(128,128,128)"
			
			This:C1470.errorColor:=0x00FF0000
			This:C1470.errorRGB:="red"
			
			This:C1470.warningColor:=0x00F19135
			This:C1470.warningRGB:="darkorange"
			
		End if 
	End if 
	
	If ($update)
		
		// * COLORS
		This:C1470.colors:=New object:C1471
		
		For each ($key; New collection:C1472(\
			"strokeColor"; \
			"highlightColor"; \
			"highlightColorNoFocus"; \
			"selectedColor"; \
			"alternateSelectedColor"; \
			"backgroundSelectedColor"; \
			"backgroundUnselectedColor"; \
			"errorColor"; \
			"warningColor"))
			
			This:C1470.colors[$key]:=cs:C1710.color.new(This:C1470[$key])
			
		End for each 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function goToPage($page : Text)
	
	var $description : Object
	
	logger.info(Current method name:C684+" ("+$page+")")
	
	If (Count parameters:C259>=1)
		
		$description:=This:C1470.pages[$page]
		
	End if 
	
	This:C1470.firstPage()  // Should be obsolete as opening/creating wizards are used
	
	This:C1470.hidePicker()
	This:C1470.hideBrowser()
	
	// Hide footer
	androidLimitations(False:C215; "")
	
	If ($description#Null:C1517)
		
		Case of 
				
				//_______________________________________________
			: (Form:C1466.status.dataModel=Null:C1517)
				
				//_______________________________________________
			: ($page="structure")
				
				$description.action.show:=Not:C34(Bool:C1537(Form:C1466.status.dataModel))
				
				//_______________________________________________
			: ($page="views")
				
				$description.action.show:=Not:C34(Bool:C1537(Form:C1466.status.project))
				
				//_______________________________________________
		End case 
		
		This:C1470.currentPage:=$page
		This:C1470.setHeader()
		
		Form:C1466.$page:=$description
		
		This:C1470.callChild(This:C1470.project; Formula:C1597(panel_INIT).source; $description; PROJECT)
		
		This:C1470.updateHeader($description)
		This:C1470.refresh()  // Update geometry
		This:C1470.project.focus()
		
	End if 
	
	If (Is Windows:C1573)
		
		//FIXME:Force redrawing of the window
		This:C1470.redraw()
		
	End if 
	
	//MARK:-TASKS
	//=== === === === === === === === === === === === === === === === === === === === ===
Function addTask($task : Text)
	
	If (This:C1470.pendingTasks.query("name = :1"; $task).pop()=Null:C1517)
		
		Logger.info("START: "+$task)
		
		This:C1470.pendingTasks.push(New object:C1471(\
			"name"; $task))
		
	End if 
	
	This:C1470.showTask()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function removeTask($task : Text)
	
	var $indx : Integer
	
	$indx:=This:C1470.pendingTasks.extract("name").indexOf($task)
	
	If ($indx#-1)
		
		Logger.info("END: "+$task)
		
		This:C1470.pendingTasks.remove($indx)
		
	End if 
	
	This:C1470.showTask()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Display the task indicator, if applicable
Function showTask()
	
	If (Feature.with("taskIndicator"))  // 🚧
		
		If (This:C1470.countTasks()>0)
			
			This:C1470.currentTask:=This:C1470.str.localize(This:C1470.pendingTasks[0].name)
			This:C1470.taskUI.show(This:C1470.message.hidden)
			
		Else 
			
			This:C1470.currentTask:=""
			This:C1470.taskIndicator.hide()
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Returns the number of tasks in the stack (include current running task)
Function countTasks() : Integer
	
	return (This:C1470.pendingTasks.length)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Returns True if a task is running or into the stack
Function taskInProgress($taskID : Text) : Boolean
	
	return (This:C1470.pendingTasks.query("name = :1"; $taskID).length>0)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Returns True if a task isn't running or into the stack
Function taskNotInProgress($taskID) : Boolean
	
	return (This:C1470.pendingTasks.query("name = :1"; $taskID).length=0)
	
	//MARK:-UI
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Refresh displayed panels
Function refreshPanels()
	
	This:C1470.callChild(This:C1470.project; Formula:C1597(PROJECT_ON_ACTIVATE).source)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function hidePicker()
	
	//Logger.info("hidePicker()")
	This:C1470.callMeBack("pickerHide")
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function hideBrowser()
	
	//Logger.info("hideBrowser()")
	This:C1470.callMeBack("hideBrowser")
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function updateRibbon()
	
	This:C1470.callMeBack("updateRibbon")
	
	Logger.info("updateRibbon()")
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function refreshViews()
	
	This:C1470.callMeBack("refreshViews")
	
	Logger.info("refreshViews()")
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function setHeader()
	
	This:C1470.description.setValue(This:C1470.currentPage)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function updateHeader($data : Object)
	
	If (This:C1470.currentForm=UI.currentForm)
		
		This:C1470.callChild(This:C1470.description; Formula:C1597(editor_UPDATE_HEADER).source; $data)
		
	Else 
		
		This:C1470.callMeBack("description"; $data)
		
	End if 
	
	//MARK:-Widget methods
	//=== === === === === === === === === === === === === === === === === === === === ===
Function messageContainer($e : Object)
	
	var $offset : Integer
	var $coordinates; $data; $display : Object
	
	Case of 
			
			//______________________________________________________
		: ($e.code<0)  // <SUBFORM EVENTS>
			
			var $data; $display : Object
			
			$data:=This:C1470.message.getValue()
			$display:=$data.ƒ
			
			Case of 
					
					//…………………………………………………………………………………………………
				: ($e.code=-2)\
					 | ($e.code=-1)  // Close
					
					This:C1470.messageGroup.hide()
					
					$display.restore($data)
					
					// Restore original size
					This:C1470.message.setDimensions($display.width; $display.height)
					
					//…………………………………………………………………………………………………
				: ($e.code=-8858)  // Resize
					
					var $offset : Integer
					var $coordinates; $display : Object
					
					$coordinates:=This:C1470.message.getCoordinates()
					$coordinates.bottom:=$coordinates.bottom+$display.offset
					
					// Limit to the window's height
					$offset:=This:C1470.message.getParentDimensions().height-$coordinates.bottom-20
					
					If ($offset<0)
						
						$coordinates.bottom:=$coordinates.bottom+$offset
						$display.background.coordinates.bottom:=$display.background.coordinates.bottom+$offset
						$display.additional.coordinates.bottom:=$display.additional.coordinates.bottom+$offset
						$display.offset:=$display.offset+$offset
						$display.scrollbar:=True:C214
						
					Else 
						
						$display.scrollbar:=False:C215
						
					End if 
					
					This:C1470.message.setCoordinates($coordinates)
					$display.update($data)
					
					//…………………………………………………………………………………………………
			End case 
			
			//______________________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function ribbonContainer($e : Object)
	
	var $offset : Integer
	var $button; $me : Object
	
	$e.code:=Abs:C99($e.code)
	$me:=This:C1470.ribbon.getValue()
	
	Case of 
			
			//…………………………………………………………………………………………………
		: ($e.code=1)  // Hide/show toolbar
			
			// Height offset opened/closed
			$offset:=Choose:C955($me.state="open"; -100; 100)
			This:C1470.ribbon.resizeVertically($offset)
			This:C1470.description.moveAndResizeVertically($offset)
			This:C1470.project.moveAndResizeVertically($offset)
			This:C1470.browser.moveAndResizeVertically($offset)
			
			// Keep the status
			$me.state:=Choose:C955($me.state="open"; "close"; "open")
			This:C1470.ribbon.setValue($me)
			
			//…………………………………………………………………………………………………
		: ($e.code=151)  // Build & Run
			
			PROJECT.save()
			
			This:C1470.hideBrowser()
			This:C1470.hidePicker()
			
			This:C1470.runBuild(New object:C1471(\
				"caller"; This:C1470.window; \
				"project"; PROJECT; \
				"create"; True:C214; \
				"build"; Not:C34(Shift down:C543); \
				"run"; Not:C34(Shift down:C543); \
				"verbose"; Bool:C1537(Form:C1466.verbose)))
			
			//…………………………………………………………………………………………………
		: ($e.code=153)  // Install
			
			If (Not:C34(Bool:C1537(This:C1470.build)))
				
				PROJECT.save()
				
				This:C1470.hideBrowser()
				This:C1470.hidePicker()
				
				This:C1470.runBuild(New object:C1471(\
					"caller"; This:C1470.window; \
					"project"; PROJECT; \
					"create"; Not:C34(Shift down:C543); \
					"build"; Not:C34(Shift down:C543); \
					"archive"; True:C214; \
					"verbose"; Bool:C1537(Form:C1466.verbose)))
				
			End if 
			
			//…………………………………………………………………………………………………
		: ($e.code>100)  // Section menu
			
			$button:=This:C1470.context.ribbon.pages.query("button = :1"; String:C10($e.code)).pop()
			
			This:C1470.goToPage($button.name)
			
			$me.page:=$button.name
			This:C1470.ribbon.setValue($me)
			
			//…………………………………………………………………………………………………
		Else 
			
			ASSERT:C1129(False:C215; "Unknown call from subform ("+String:C10($e.code)+")")
			
			//…………………………………………………………………………………………………
	End case 
	
	//MARK:-TOOLS
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Tests if the project is locked
Function isLocked() : Boolean
	
	If (This:C1470.structure#Null:C1517)
		
		return Bool:C1537(This:C1470.structure.unsynchronized)
		
	Else 
		
		return Bool:C1537(This:C1470.$project.structure.unsynchronized)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Tests if the project is not locked and
Function isNotLocked() : Boolean
	
	return Not:C34(This:C1470.isLocked())
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function getIcon($relativePath : Text) : Picture
	
	var $icon : Picture
	var $file : 4D:C1709.File
	var $svg : cs:C1710.svg
	
	If (Length:C16($relativePath)=0)
		
		$file:=File:C1566(This:C1470.noIcon; fk platform path:K87:2)
		
	Else 
		
		$file:=cs:C1710.path.new().icon($relativePath)
		
		If (Not:C34($file.exists))
			
			$file:=File:C1566(This:C1470.errorIcon; fk platform path:K87:2)
			
		End if 
	End if 
	
	If ($file.exists)
		
		If (This:C1470.darkScheme) && ($file.extension=".svg")
			
			$svg:=This:C1470.svg.load($file)
			
			If ($svg.success)
				
				$svg.styleSheet(File:C1566("/RESOURCES/css/icon_dark.css"))
				$icon:=$svg.picture()
				
			Else 
				
				READ PICTURE FILE:C678($file.platformPath; $icon)
				
			End if 
			
		Else 
			
			READ PICTURE FILE:C678($file.platformPath; $icon)
			
		End if 
		
		CREATE THUMBNAIL:C679($icon; $icon; 24; 24; Scaled to fit:K6:2)
		return $icon
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function runBuild($data : Object)
/*
Display the message immediately to be more responsive
The real build process (project_BUILD) will autostart at the message is posted
*/
	
	This:C1470.build:=True:C214
	
	Logger.info("🏁  Start build")
	
	If ($data.project._buildTarget=Null:C1517)
		
		$data.project._buildTarget:=$data.target || PROJECT._buildTarget  // temporary fix
		
	End if 
	
	$data.caller:=$data.caller || Current form window:C827
	
	This:C1470.postMessage(New object:C1471(\
		"action"; "show"; \
		"type"; "progress"; \
		"title"; Get localized string:C991("product")+" - "+PROJECT.product.name+" ["+(PROJECT._buildTarget="android" ? "Android" : "iOS")+"]"; \
		"additional"; "preparations"; \
		"autostart"; Formula:C1597(CALL FORM:C1391(Current form window:C827; Formula:C1597(project_BUILD).source; $data))))
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Displays the message dialog box
Function postMessage($message : Object)
	
	This:C1470.callMe(Formula:C1597(DO_MESSAGE).source; $message)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function checkDevTools()
	
	This:C1470.addTask("checkDevTools")
	This:C1470.callWorker(Formula:C1597(editor_CHECK_INSTALLATION).source; New object:C1471(\
		"caller"; This:C1470.window; \
		"method"; Formula:C1597(editor_CALLBACK).source; \
		"message"; "checkDevTools"; \
		"xCode"; This:C1470.xCode; \
		"studio"; This:C1470.studio; \
		"android"; PROJECT.$android; \
		"ios"; PROJECT.$ios\
		))
	
	//===================================================================================
Function checkProject()
	
	// Launch of the update of the exposed catalog
	This:C1470.addTask("checkProject")
	This:C1470.callWorker(Formula:C1597(editor_UPDATE_EXPOSED_CATALOG).source; New object:C1471(\
		"caller"; This:C1470.window; \
		"method"; This:C1470.callback; \
		"message"; "checkProject"))
	
	// Launch of the project audit
	This:C1470.callMeBack("projectAudit")
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function getDevices()
	
	This:C1470.addTask("getDevices")
	This:C1470.callWorker(Formula:C1597(editor_GET_DEVICES).source; New object:C1471(\
		"caller"; This:C1470.window; \
		"xCode"; This:C1470.xCode; \
		"studio"; This:C1470.studio\
		))
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function getDevice($udid : Text)->$device : Object
	
	$device:=This:C1470.devices.apple.query("udid = :1"; $udid).pop()
	
	If ($device=Null:C1517)
		
		$device:=This:C1470.devices.plugged.apple.query("udid = :1"; $udid).pop()
		
	End if 
	
	If ($device=Null:C1517)
		
		$device:=This:C1470.devices.android.query("udid = :1"; $udid).pop()
		
	End if 
	
	If ($device=Null:C1517)
		
		$device:=This:C1470.devices.plugged.android.query("udid = :1"; $udid).pop()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function doGenerate($keyPathname : Text)
	
	var $worker : Text
	var $ƒ : Object
	var $window : Integer
	
	// Make a copy for the Formula
	$window:=Current form window:C827
	$worker:=This:C1470.worker
	
	$ƒ:=Formula:C1597(CALL WORKER:C1389($worker; "dataSet"; New object:C1471(\
		"action"; "create"; \
		"eraseIfExists"; True:C214; \
		"project"; PROJECT; \
		"digest"; True:C214; \
		"accordingToTarget"; Feature.with("androidDataSet"); \
		"coreDataSet"; Feature.disabled("androidDataSet"); \
		"key"; $keyPathname; \
		"dataSet"; True:C214; \
		"caller"; $window; \
		"method"; Formula:C1597(editor_CALLBACK).source; \
		"message"; "endOfDatasetGeneration")))
	
	This:C1470.postMessage(New object:C1471(\
		"action"; "show"; \
		"type"; "cancelableProgress"; \
		"title"; "dataGeneration"; \
		"additional"; "datagenerationPreparations"; \
		"autostart"; $ƒ; \
		"stopFormula"; Formula:C1597(UI.doStopDataGeneration()); \
		"cancelMessage"; "doYouWantToCancelTheDataGenerationProcess"\
		))
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function doStopDataGeneration()
	
	Logger.warning("Data generation cancelled")
	
	Use (Storage:C1525)
		
		If (Storage:C1525.flags=Null:C1517)
			
			Storage:C1525.flags:=New shared object:C1526
			
		End if 
		
		Use (Storage:C1525.flags)
			
			Storage:C1525.flags.stopGeneration:=True:C214
			
		End use 
	End use 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function doCancelableProgress($content; $additional : Text)
	
	If (Count parameters:C259>=2)
		
		This:C1470.postMessage(New object:C1471(\
			"action"; "show"; \
			"type"; "cancelableProgress"; \
			"title"; String:C10($content); \
			"additional"; $additional; \
			"cancelMessage"; "doYouWantToCancelTheDataGenerationProcess"\
			))
		
	Else 
		
		If (Value type:C1509($content)=Is object:K8:27)
			
			$content.target:=This:C1470.window
			$content.action:="show"
			$content.type:="cancelableProgress"
			
			This:C1470.postMessage($content)
			
		Else 
			
			This:C1470.postMessage(New object:C1471(\
				"action"; "show"; \
				"type"; "cancelableProgress"; \
				"title"; String:C10($content)\
				))
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function doAlert($content; $additional : Text)
	
	If (Count parameters:C259>=2)
		
		This:C1470.postMessage(New object:C1471(\
			"action"; "show"; \
			"type"; "alert"; \
			"title"; String:C10($content); \
			"additional"; $additional\
			))
		
	Else 
		
		If (Value type:C1509($content)=Is object:K8:27)
			
			$content.target:=This:C1470.window
			$content.action:="show"
			$content.type:="alert"
			
			This:C1470.postMessage($content)
			
		Else 
			
			This:C1470.postMessage(New object:C1471(\
				"action"; "show"; \
				"type"; "alert"; \
				"title"; String:C10($content)\
				))
			
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function editAuthenticationMethod()
	
	var $t : Text
	var $o : 4D:C1709.File
	
	ARRAY TEXT:C222($ar; 0x0000)
	
	METHOD GET PATHS:C1163(Path database method:K72:2; $ar; *)
	$ar{0}:=METHOD Get path:C1164(Path database method:K72:2; "onMobileAppAuthentication")
	
	// Create method if not exist
	If (Find in array:C230($ar; $ar{0})=-1)
		
		If (Command name:C538(1)="Somme")
			
			// FR language
			$o:=File:C1566("/RESOURCES/fr.lproj/onMobileAppAuthentication.4dm")
			
		Else 
			
			$o:=File:C1566(Get localized document path:C1105("onMobileAppAuthentication.4dm"); fk platform path:K87:2)
			
		End if 
		
		If ($o.exists)
			
			$t:=$o.getText()
			METHOD SET CODE:C1194($ar{0}; $t; *)
			
		End if 
	End if 
	
	// Open method
	METHOD OPEN PATH:C1213($ar{0}; *)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function sendMessageToPanel($panel : Text; $selector : Text; $data : Object)
	
	var $subform : Text
	var $value
	
	$subform:=panel_Find($panel)
	
	If (Length:C16($subform)>0)
		
		$value:=OBJECT Get value:C1743($subform).$dialog[$panel]
		
		// FIXME: remove constraints test after all panels use a form class 
		If (Value type:C1509($value)=Is object:K8:27) && (($value.isPannel#Null:C1517) || ($value.constraints#Null:C1517))
			
			This:C1470.callChild($subform; Formula:C1597(project_PROCESS_MESSAGES).source; $selector; $data)
			
		Else 
			
			Logger.error("panel "+$panel+" receive a bad message ("+$selector+")")
			
		End if 
		
	Else 
		
		//Logger.info("panel "+$panel+" not displayed, message \""+$selector+"\" is ignored")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function getDBFile($target : Text) : 4D:C1709.File
	
	Case of 
			
			//______________________________________________________
		: ($target="android")
			
			return (PROJECT._folder.file("project.dataSet/android/static.db"))
			
			//______________________________________________________
		: ($target="ios")
			
			return (PROJECT._folder.file("project.dataSet/Resources/Structures.sqlite"))
			
			//______________________________________________________
		: (PROJECT.allTargets())
			
			// Use android because still relevant on Windows
			return (PROJECT._folder.file("project.dataSet/android/static.db"))
			
			//______________________________________________________
		: (PROJECT.iOS())
			
			return (PROJECT._folder.file("project.dataSet/Resources/Structures.sqlite"))
			
			//______________________________________________________
		: (PROJECT.android())
			
			return (PROJECT._folder.file("project.dataSet/android/static.db"))
			
			//______________________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function deleteDBFiles()
	
	var $file : 4D:C1709.File
	
	$file:=This:C1470.getDBFile("ios")
	
	If ($file.exists)
		
		$file.delete()
		
	End if 
	
	$file:=This:C1470.getDBFile("android")
	
	If ($file.exists)
		
		$file.delete()
		
	End if 
	