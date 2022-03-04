Class extends form

Class constructor()
	
	var $t : Text
	
	Super:C1705(Formula:C1597(editor_CALLBACK).source)
	
	This:C1470.setWorker("4D Mobile ("+String:C10(This:C1470.window)+")")
	
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
	
	//MARK:-[COMPUTED]
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function get unsynchronizedTables()->$sesult : Collection
	
	$sesult:=Form:C1466.$dialog.unsynchronizedTables
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Definition of the editor pages and panels used
Function design()
	
	var $o : Object
	
	
	var $window : Integer
	$window:=This:C1470.window
	
	This:C1470.pages:=New object:C1471
	This:C1470.currentPage:=""
	
	If (True:C214)  // GENERAL
		
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
		
	End if 
	
	If (True:C214)  // STRUCTURE
		
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
			"formula"; Formula:C1597(POST_MESSAGE(New object:C1471(\
			"target"; $window; \
			"action"; "show"; \
			"type"; "confirm"; \
			"title"; "updateTheProject"; \
			"additional"; "aBackupWillBeCreatedIntoTheProjectFolder"; \
			"ok"; "update"; \
			"okFormula"; Formula:C1597(CALL FORM:C1391($window; Formula:C1597(editor_CALLBACK).source; "syncDataModel")))))\
			)
		
	End if 
	
	If (True:C214)  // PROPERTIES
		
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
		
	End if 
	
	If (True:C214)  // MAIN
		
		This:C1470.pages.main:=New object:C1471(\
			"panels"; New collection:C1472)
		
		$o:=This:C1470.pages.main
		
		$o.panels.push(New object:C1471(\
			"title"; Get localized string:C991("mainMenu"); \
			"form"; "MAIN"; \
			"noTitle"; True:C214))
		
	End if 
	
	If (True:C214)  // VIEWS
		
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
			"formula"; Formula:C1597(POST_MESSAGE(New object:C1471(\
			"target"; $window; \
			"action"; "show"; \
			"type"; "confirm"; \
			"title"; "updateTheProject"; \
			"additional"; "aBackupWillBeCreatedIntoTheProjectFolder"; \
			"ok"; "update"; \
			"okFormula"; Formula:C1597(CALL FORM:C1391($window; Formula:C1597(editor_CALLBACK).source; "syncDataModel")))))\
			)
		
	End if 
	
	If (True:C214)  // DEPLOYMENT
		
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
	End if 
	
	If (True:C214)  // DATA
		
		This:C1470.pages.data:=New object:C1471(\
			"panels"; New collection:C1472)
		
		$o:=This:C1470.pages.data
		
		If (FEATURE.with(8858)) & False:C215
			
			$o.panels.push(New object:C1471(\
				"title"; Get localized string:C991("source"); \
				"form"; "SOURCE1"; \
				"help"; True:C214))
			
		Else 
			
			$o.panels.push(New object:C1471(\
				"title"; Get localized string:C991("source"); \
				"form"; "SOURCE"; \
				"help"; True:C214))
			
		End if 
		
		$o.panels.push(New object:C1471(\
			"title"; Get localized string:C991("properties"); \
			"form"; "DATA"; \
			"help"; True:C214))
		
	End if 
	
	If (True:C214)  // ACTIONS
		
		This:C1470.pages.actions:=New object:C1471(\
			"panels"; New collection:C1472)
		
		$o:=This:C1470.pages.actions
		
		$o.panels.push(New object:C1471(\
			"form"; "ACTIONS"; \
			"noTitle"; True:C214))  //;"noSeparator"; True))
		
		$o.panels.push(New object:C1471(\
			"title"; Get localized string:C991("page_action_params"); \
			"form"; "ACTIONS_PARAMS"; \
			"noTitle"; True:C214))
		
	End if 
	
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
		
		RECORD.info("📍 CREATE $dialog (PROJECT_EDITOR)")
		Form:C1466.$dialog:=New object:C1471
		
	End if 
	
	If (Form:C1466.$dialog[This:C1470.name]=Null:C1517)
		
		RECORD.info("Create context for: "+This:C1470.name)
		Form:C1466.$dialog[This:C1470.name]:=New object:C1471
		
	End if 
	
	This:C1470.context:=Form:C1466.$dialog[This:C1470.name]
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	This:C1470.init()
	
	This:C1470.project.setScrollbars(0; 2)
	This:C1470.taskIndicator.barber().start()
	This:C1470.message.setValue(New object:C1471)
	
	// DEV items
	OBJECT SET VISIBLE:C603(*; "debug.@"; Bool:C1537(DATABASE.isMatrix))
	
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
	
	var $icon : Picture
	var $file : 4D:C1709.File
	
	This:C1470.colorScheme:=FORM Get color scheme:C1761
	This:C1470.isDark:=(FORM Get color scheme:C1761="dark")
	
	This:C1470.fieldIcons:=New collection:C1472
	
	If (This:C1470.darkScheme)
		
		// * PRE-LOADING ICONS FOR FIELD TYPES
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
		
		This:C1470.selectedColor:=0x0003A9F4
		This:C1470.alternateSelectedColor:="cornflowerblue"  //"cadetblue"
		This:C1470.backgroundSelectedColor:=Highlight text background color:K23:5
		This:C1470.backgroundUnselectedColor:=Highlight text background color:K23:5
		
		This:C1470.selectedFillColor:="darkgray"
		This:C1470.unselectedFillColor:="black"
		
		This:C1470.errorColor:=0x00E61C70
		This:C1470.errorRGB:="rgb(230,28,112)"
		
		This:C1470.warningColor:=0x00FF4500
		This:C1470.warningRGB:="orangered"
		
	Else 
		
		// * PRE-LOADING ICONS FOR FIELD TYPES
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
		
		This:C1470.selectedColor:=0x0003A9F4
		This:C1470.alternateSelectedColor:=0x00F4F4F6
		This:C1470.backgroundSelectedColor:=0x00E7F8FF
		This:C1470.backgroundUnselectedColor:=0x00C9C9C9
		
		This:C1470.selectedFillColor:="gray"
		This:C1470.unselectedFillColor:="white"
		
		This:C1470.errorColor:=0x00FF0000
		This:C1470.errorRGB:="red"
		
		This:C1470.warningColor:=0x00F19135
		This:C1470.warningRGB:="darkorange"
		
	End if 
	
	// COLORS
	This:C1470.colors:=New object:C1471
	
	var $color : cs:C1710.color
	var $key : Text
	
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
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function goToPage($page : Text)
	
	var $o : Object
	
	If (Count parameters:C259>=1)
		
		$o:=This:C1470.pages[$page]
		
	End if 
	
	This:C1470.firstPage()  // Should be obsolete as opening/creating wizards are used
	
	This:C1470.hidePicker()
	This:C1470.hideBrowser()
	
	// Hide footer
	androidLimitations(False:C215; "")
	
	Case of 
			
			//_______________________________________________
		: (Form:C1466.status.dataModel=Null:C1517)
			
			//_______________________________________________
		: ($page="structure")
			
			$o.action.show:=Not:C34(Bool:C1537(Form:C1466.status.dataModel))
			
			//_______________________________________________
		: ($page="views")
			
			$o.action.show:=Not:C34(Bool:C1537(Form:C1466.status.project))
			
			//_______________________________________________
	End case 
	
	If ($o#Null:C1517)
		
		This:C1470.currentPage:=$page
		This:C1470.setHeader()
		
		Form:C1466.$page:=$o
		
		This:C1470.callChild(This:C1470.project; Formula:C1597(panel_INIT).source; $o; PROJECT)
		
		This:C1470.updateHeader($o)
		
		This:C1470.refresh()  // Update geometry
		
		This:C1470.project.focus()
		
	End if 
	
	
	//MARK:-TASKS
	//=== === === === === === === === === === === === === === === === === === === === ===
Function addTask($task : Text)
	
	If (This:C1470.pendingTasks.query("name = :1"; $task).pop()=Null:C1517)
		
		RECORD.info("START: "+$task)
		
		This:C1470.pendingTasks.push(New object:C1471(\
			"name"; $task))
		
	End if 
	
	This:C1470.showTask()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function removeTask($task : Text)
	
	var $indx : Integer
	
	$indx:=This:C1470.pendingTasks.extract("name").indexOf($task)
	
	If ($indx#-1)
		
		RECORD.info("END: "+$task)
		
		This:C1470.pendingTasks.remove($indx)
		
	End if 
	
	This:C1470.showTask()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Display the task indicator, if applicable
Function showTask()
	
	If (FEATURE.with("taskIndicator"))  // 🚧
		
		If (This:C1470.countTasks()>0)
			
			This:C1470.currentTask:=This:C1470.str.localize(This:C1470.pendingTasks[0].name)
			This:C1470.taskUI.show(This:C1470.message.isHidden())
			
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
	
	This:C1470.callMeBack("pickerHide")
	
	RECORD.info("hidePicker()")
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function hideBrowser()
	
	This:C1470.callMeBack("hideBrowser")
	
	RECORD.info("hideBrowser()")
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function updateRibbon()
	
	This:C1470.callMeBack("updateRibbon")
	
	RECORD.info("updateRibbon()")
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function refreshViews()
	
	This:C1470.callMeBack("refreshViews")
	
	RECORD.info("refreshViews()")
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function setHeader()
	
	This:C1470.description.setValue(This:C1470.currentPage)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function updateHeader($data : Object)
	
	This:C1470.callChild(This:C1470.description; Formula:C1597(editor_UPDATE_HEADER).source; $data)
	
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
			
			BUILD(New object:C1471(\
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
				
				BUILD(New object:C1471(\
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
		return ($icon)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function checkDevTools()
	
	This:C1470.addTask("checkDevTools")
	This:C1470.callWorker(Formula:C1597(editor_CHECK_INSTALLATION).source; New object:C1471(\
		"caller"; This:C1470.window; \
		"xCode"; This:C1470.xCode; \
		"studio"; This:C1470.studio; \
		"android"; PROJECT.$android; \
		"ios"; PROJECT.$ios\
		))
	
	//===================================================================================
Function checkProject()
	
	// Launch of the update of the exposed catalog
	This:C1470.addTask("checkProject")
	This:C1470.callWorker(Formula:C1597(editor_UPDATE_EXPOSED_CATALOG).source; This:C1470.window; This:C1470.callback)
	
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
	
	var $ƒ : 4D:C1709.Function
	
	var $worker : Text
	var $window : Integer
	$worker:=This:C1470.worker
	$window:=This:C1470.window
	
	$ƒ:=Formula:C1597(CALL WORKER:C1389($worker; Formula:C1597(dataSet).source; New object:C1471(\
		"caller"; $window; \
		"action"; "create"; \
		"eraseIfExists"; True:C214; \
		"project"; PROJECT; \
		"digest"; True:C214; \
		"accordingToTarget"; FEATURE.with("androidDataSet"); \
		"coreDataSet"; Not:C34(FEATURE.with("androidDataSet")); \
		"key"; $keyPathname; \
		"dataSet"; True:C214)))
	
	POST_MESSAGE(New object:C1471(\
		"target"; $window; \
		"action"; "show"; \
		"type"; "cancelableProgress"; \
		"title"; "dataGeneration"; \
		"additional"; "datagenerationPreparations"; \
		"autostart"; $ƒ; \
		"stopFormula"; Formula:C1597(EDITOR.doStopDataGeneration()); \
		"cancelMessage"; "doYouWantToCancelTheDataGenerationProcess"\
		))
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function doStopDataGeneration()
	
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
		
		POST_MESSAGE(New object:C1471(\
			"target"; This:C1470.window; \
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
			
			POST_MESSAGE($content)
			
		Else 
			
			POST_MESSAGE(New object:C1471(\
				"target"; This:C1470.window; \
				"action"; "show"; \
				"type"; "cancelableProgress"; \
				"title"; String:C10($content)\
				))
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function doAlert($content; $additional : Text)
	
	If (Count parameters:C259>=2)
		
		POST_MESSAGE(New object:C1471(\
			"target"; This:C1470.window; \
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
			
			POST_MESSAGE($content)
			
		Else 
			
			POST_MESSAGE(New object:C1471(\
				"target"; This:C1470.window; \
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