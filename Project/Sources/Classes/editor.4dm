/*===============================================
EDITOR Class
===============================================*/
Class extends form

Class constructor
	
	Super:C1705("editor_CALLBACK")
	
	This:C1470.setWorker("4D Mobile ("+String:C10(This:C1470.window)+")")
	
	This:C1470.pagesDefinition()
	
	// Load preferences
	This:C1470.preferences:=cs:C1710.preferences.new().user("4D Mobile App.preferences")
	
	This:C1470.updateColorScheme()
	This:C1470.init()
	
	This:C1470.pendingTasks:=New collection:C1472
	
	//===================================================================================
Function pagesDefinition()
	var $o : Object
	
	This:C1470.pages:=New object:C1471
	This:C1470.currentPage:=""
	
	//_____________________________________________________________________
	This:C1470.pages.general:=New object:C1471(\
		"panels"; New collection:C1472)
	
	$o:=This:C1470.pages.general
	
	$o.panels.push(New object:C1471(\
		"title"; Get localized string:C991("organization"); \
		"form"; "ORGANIZATION"))
	
	$o.panels.push(New object:C1471(\
		"title"; Get localized string:C991("product"); \
		"form"; "PRODUCT"))
	
	$o.panels.push(New object:C1471(\
		"title"; Get localized string:C991("developer"); \
		"form"; "DEVELOPER"))
	
	//_____________________________________________________________________
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
		"target"; Current form window:C827; \
		"action"; "show"; \
		"type"; "confirm"; \
		"title"; "updateTheProject"; \
		"additional"; "aBackupWillBeCreatedIntoTheProjectFolder"; \
		"ok"; "update"; \
		"okFormula"; Formula:C1597(CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "syncDataModel")))))\
		)
	
	//_____________________________________________________________________
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
	
	//_____________________________________________________________________
	This:C1470.pages.main:=New object:C1471(\
		"panels"; New collection:C1472)
	
	$o:=This:C1470.pages.main
	
	$o.panels.push(New object:C1471(\
		"title"; Get localized string:C991("mainMenu"); \
		"form"; "MAIN"; \
		"noTitle"; True:C214))
	
	//_____________________________________________________________________
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
		"target"; Current form window:C827; \
		"action"; "show"; \
		"type"; "confirm"; \
		"title"; "updateTheProject"; \
		"additional"; "aBackupWillBeCreatedIntoTheProjectFolder"; \
		"ok"; "update"; \
		"okFormula"; Formula:C1597(CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "syncDataModel")))))\
		)
	
	//_____________________________________________________________________
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
	
	//_____________________________________________________________________
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
	
	//_____________________________________________________________________
	This:C1470.pages.actions:=New object:C1471(\
		"panels"; New collection:C1472)
	
	$o:=This:C1470.pages.actions
	
	$o.panels.push(New object:C1471(\
		"form"; "ACTIONS"; \
		"noTitle"; True:C214))
	
	$o.panels.push(New object:C1471(\
		"title"; Get localized string:C991("page_action_params"); \
		"form"; "ACTIONS_PARAMS"))
	
	//===================================================================================
Function widgetsDefinition()
	
	This:C1470.ribbon:=cs:C1710.subform.new("ribbon")
	This:C1470.description:=cs:C1710.subform.new("description")
	This:C1470.project:=cs:C1710.subform.new("project")
	This:C1470.footer:=cs:C1710.subform.new("footer")
	This:C1470.taskIndicator:=cs:C1710.thermometer.new("tasks").barber().start()
	
	This:C1470.browser:=cs:C1710.subform.new("browser")
	
	This:C1470.message:=cs:C1710.subform.new("message")
	This:C1470.messageObjects:=cs:C1710.group.new("message,message.button,message.back")
	
	//===================================================================================
	// [Warning] Executed every time the editor is activated to adapt UI to the color scheme
Function updateColorScheme()
	
	var $icon : Picture
	var $file : 4D:C1709.File
	
	This:C1470.colorScheme:=FORM Get color scheme:C1761
	This:C1470.isDark:=(FORM Get color scheme:C1761="dark")
	
	This:C1470.fieldIcons:=New collection:C1472
	
	If (This:C1470.isDark)
		
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
		
		This:C1470.selectedColor:=0x0003A9F4  //0x0001A9F4  //0x00034B6D
		This:C1470.alternateSelectedColor:=0x00C1C1FF
		This:C1470.backgroundSelectedColor:=Highlight text background color:K23:5
		This:C1470.backgroundUnselectedColor:=Highlight text background color:K23:5
		
		This:C1470.selectedFillColor:="darkgray"
		This:C1470.unselectedFillColor:="black"
		
		This:C1470.errorColor:=0x00F28585
		This:C1470.warningColor:=0x00F2B174
		
		This:C1470.errorRGB:="red"
		This:C1470.warningRGB:="orange"
		
	Else 
		
		// * PRE-LOADING ICONS FOR FIELD TYPES
		For each ($file; Folder:C1567("/RESOURCES/images/fieldsIcons").files(Ignore invisible:K24:16))
			
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
		This:C1470.warningColor:=0x00F19135
		
		This:C1470.errorRGB:="red"
		This:C1470.warningRGB:="darkorange"
		
	End if 
	
	// COLORS
	This:C1470.colors:=New object:C1471
	This:C1470.colors.strokeColor:=color("4dColor"; New object:C1471("value"; This:C1470.strokeColor))
	This:C1470.colors.highlightColor:=color("4dColor"; New object:C1471("value"; This:C1470.highlightColor))
	This:C1470.colors.highlightColorNoFocus:=color("4dColor"; New object:C1471("value"; This:C1470.highlightColorNoFocus))
	This:C1470.colors.selectedColor:=color("4dColor"; New object:C1471("value"; This:C1470.selectedColor))
	This:C1470.colors.alternateSelectedColor:=color("4dColor"; New object:C1471("value"; This:C1470.alternateSelectedColor))
	This:C1470.colors.backgroundSelectedColor:=color("4dColor"; New object:C1471("value"; This:C1470.backgroundSelectedColor))
	This:C1470.colors.backgroundUnselectedColor:=color("4dColor"; New object:C1471("value"; This:C1470.backgroundUnselectedColor))
	This:C1470.colors.errorColor:=color("4dColor"; New object:C1471("value"; This:C1470.errorColor))
	This:C1470.colors.warningColor:=color("4dColor"; New object:C1471("value"; This:C1470.warningColor))
	
	//===================================================================================
	// Pre-loading of constant resources
Function init()
	
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
	
	//===================================================================================
Function displayPage($page : Text)
	
	var $o : Object
	
	If (Count parameters:C259>=1)
		
		$o:=This:C1470.pages[$page]
		
	End if 
	
	FORM GOTO PAGE:C247(1)
	
	If (This:C1470.name="EDITOR")  // First call
		
		This:C1470.widgetsDefinition()
		
	End if 
	
	// Hide picker & browser if any
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
		
		OBJECT SET VALUE:C1742("description"; $page)
		
		Form:C1466.$page:=$o
		
		If (FEATURE.with("wizards"))
			
			This:C1470.executeInSubform("PROJECT"; "panel_INIT"; $o; PROJECT)
			
		Else 
			
			This:C1470.executeInSubform("PROJECT"; "panel_INIT"; $o)
			
		End if 
		
		SET TIMER:C645(-1)  // Set geometry
		
		This:C1470.executeInSubform("description"; "editor_description"; $o)
		
		GOTO OBJECT:C206(*; "PROJECT")
		
	End if 
	
	//===================================================================================
Function addTask($task : Text)
	
	If (This:C1470.pendingTasks.query("name = :1"; $task).pop()=Null:C1517)
		
		RECORD.info("START: "+$task)
		
		This:C1470.pendingTasks.push(New object:C1471(\
			"name"; $task))
		
	End if 
	
	If (Num:C11(Application version:C493)>1900)
		
		This:C1470.taskIndicator.show()
		
		var $t : Text
		$t:=Get localized string:C991($task)
		This:C1470.currentTask:=Choose:C955(Length:C16($t)>0; $t; $task)
		
	End if 
	
	//===================================================================================
Function removeTask($task : Text)
	
	var $indx : Integer
	
	$indx:=This:C1470.pendingTasks.extract("name").indexOf($task)
	
	If ($indx#-1)
		
		RECORD.info("END: "+$task)
		
		This:C1470.pendingTasks.remove($indx)
		
	End if 
	
	If (Num:C11(Application version:C493)>1900)
		
		If (This:C1470.pendingTasks.length>0)
			
			This:C1470.taskIndicator.show()
			
		Else 
			
			This:C1470.taskIndicator.hide()
			This:C1470.currentTask:=""
			
		End if 
	End if 
	
	//===================================================================================
Function countTasks()->$number : Integer
	
	$number:=This:C1470.pendingTasks.length
	
	//===================================================================================
Function taskInProgress($taskID : Text)->$response : Boolean
	
	$response:=(This:C1470.pendingTasks.extract("name").indexOf($taskID)#-1)
	
	//===================================================================================
Function taskNotInProgress($taskID : Text)->$response : Boolean
	
	$response:=(This:C1470.pendingTasks.extract("name").indexOf($taskID)=-1)
	
	//===================================================================================
Function hidePicker()
	
	This:C1470.post("pickerHide")
	
	RECORD.info("hidePicker()")
	
	//===================================================================================
Function hideBrowser()
	
	This:C1470.post("hideBrowser")
	
	RECORD.info("hideBrowser()")
	
	//===================================================================================
Function updateRibbon()
	
	This:C1470.post("updateRibbon")
	
	RECORD.info("updateRibbon()")
	
	//===================================================================================
Function refreshViews()
	
	This:C1470.post("refreshViews")
	
	RECORD.info("refreshViews()")
	
	//===================================================================================
Function checkDevTools()
	
	var $o : Object
	
	$o:=New object:C1471
	$o.caller:=This:C1470.window
	$o.xCode:=This:C1470.xCode
	$o.studio:=This:C1470.studio
	$o.android:=PROJECT.$android
	$o.ios:=PROJECT.$ios
	
	This:C1470.addTask("checkDevTools")
	
	CALL WORKER:C1389(This:C1470.worker; "editor_CHECK_INSTALLATION"; $o)
	
	//===================================================================================
Function checkProject()
	
	var $o : Object
	
	// Launch checking the structure
	$o:=New object:C1471
	$o.caller:=This:C1470.window
	$o.action:="catalog"
	
	This:C1470.addTask("checkProject")
	
	CALL WORKER:C1389(This:C1470.worker; "_o_structure"; $o)
	
	// Launch project verifications
	This:C1470.call("projectAudit")
	
	//===================================================================================
Function getDevices()
	
	var $o : Object
	
	$o:=New object:C1471
	$o.caller:=This:C1470.window
	$o.xCode:=This:C1470.xCode
	$o.studio:=This:C1470.studio
	
	This:C1470.addTask("getDevices")
	
	CALL WORKER:C1389(This:C1470.worker; "editor_GET_DEVICES"; $o)
	
	//===================================================================================
Function setHeader()
	
	This:C1470.description.setValue(This:C1470.currentPage)
	
	//===================================================================================
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
	
	//===================================================================================
Function downloadSDK($server : Text; $target : Text; $silent : Boolean)
	
	This:C1470.addTask("downloadSDK")
	
	If (Count parameters:C259>=3)
		
		CALL WORKER:C1389(1; "downloadSDK"; $server; "android"; $silent; This:C1470.window)
		
	Else 
		
		CALL WORKER:C1389(1; "downloadSDK"; $server; "android"; False:C215; This:C1470.window)
		
	End if 
	