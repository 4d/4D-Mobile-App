Class constructor
	var $o : Object
	
	This:C1470.pages:=New object:C1471
	
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
	
	If (FEATURE.with("newViewUI"))
		
		$o.panels.push(New object:C1471(\
			"title"; Get localized string:C991("forms"); \
			"form"; "VIEWS"; \
			"noTitle"; True:C214))
		
	Else 
		
		$o.panels.push(New object:C1471(\
			"title"; Get localized string:C991("forms"); \
			"form"; "_o_VIEWS"; \
			"noTitle"; True:C214))
		
	End if 
	
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
	
	If (FEATURE.with("pushNotification"))
		
		$o.panels.push(New object:C1471(\
			"title"; Get localized string:C991("server"); \
			"form"; "SERVER"))
		
		$o.panels.push(New object:C1471(\
			"title"; Get localized string:C991("features"); \
			"form"; "FEATURES"))
		
	Else 
		
		$o.panels.push(New object:C1471(\
			"title"; Get localized string:C991("server"); \
			"form"; "_o_SERVER"))
		
	End if 
	
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
	
	//_____________________________________________________________________
	This:C1470.currentPage:=""
	
	//===================================================================================
Function gotoPage
	var $1 : Text
	
	var $page : Text
	var $o : Object
	
	If (Count parameters:C259>=1)
		
		$page:=$1
		
	End if 
	
	FORM GOTO PAGE:C247(1)
	
	// Hide picker if any
	CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "pickerHide")
	
	// Hide broswer if any
	CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "hideBrowser")
	
	$o:=This:C1470.pages[$page]
	
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
		
		Form:C1466.currentPage:=$page
		
		(OBJECT Get pointer:C1124(Object named:K67:5; "description"))->:=Form:C1466.currentPage
		
		Form:C1466.$page:=$o
		
		EXECUTE METHOD IN SUBFORM:C1085("PROJECT"; "panel_INIT"; *; $o)
		
		SET TIMER:C645(-1)  // Set geometry
		
		EXECUTE METHOD IN SUBFORM:C1085("description"; "editor_description"; *; $o)
		
	End if 
	