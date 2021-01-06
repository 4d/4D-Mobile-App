//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_PAGE
// ID[10A295EFED4E44DDAE6170E333B30E68]
// Created 16-11-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $1 : Text

If (False:C215)
	C_TEXT:C284(editor_PAGE; $1)
End if 

var $page : Text
var $count; $i; $index; $w : Integer
var $menu; $o : Object

// NO PARAMETERS REQUIRED

$count:=8

ARRAY TEXT:C222($sections; $count)
$sections{1}:="general"
$sections{2}:="structure"
$sections{3}:="properties"
$sections{4}:="main"
$sections{5}:="views"
$sections{6}:="deployment"
$sections{7}:="data"
$sections{8}:="actions"

$sections{0}:=String:C10(Form:C1466.currentPage)

$w:=Current form window:C827

// Optional parameters
If (Count parameters:C259>=1)
	
	$page:=$1
	
	Case of 
			
			//______________________________________________________
		: ($page="next")
			
			$index:=Find in array:C230($sections; $sections{0})
			
			If ($index<$count)
				
				$page:=$sections{$index+1}
				
			Else 
				
				// Go to the first page
				$page:=$sections{1}
				
			End if 
			
			//______________________________________________________
		: ($page="previous")
			
			$index:=Find in array:C230($sections; $sections{0})
			
			If ($index>1)
				
				$page:=$sections{$index-1}
				
			Else 
				
				// Go to the last page
				$page:=$sections{$count}
				
			End if 
			
			//______________________________________________________
	End case 
	
Else 
	
	// Display menu
	$menu:=cs:C1710.menu.new()
	
	For ($i; 1; $count; 1)
		
		$menu.append("page_"+$sections{$i}; $sections{$i})\
			.icon("#/images/toolbar/"+$sections{$i}+".png")\
			.mark($sections{0}=$sections{$i})
		
	End for 
	
	$menu.popup()
	
	If ($menu.selected)
		
		$page:=$menu.choice
		
	End if 
End if 

// ----------------------------------------------------
If (Length:C16($page)>0)
	
	$o:=New object:C1471
	
	$o.ui:=(OBJECT Get pointer:C1124(Object named:K67:5; "UI"; "PROJECT"))->  // ->ui // TODO check with vincent
	$o.panels:=New collection:C1472
	
	$index:=Find in array:C230($sections; $page)
	
	Case of 
			
			//………………………………………………………………………………………
		: ($index=1)
			
			$o.panels.push(New object:C1471(\
				"title"; Get localized string:C991("organization"); \
				"form"; "ORGANIZATION"))
			
			$o.panels.push(New object:C1471(\
				"title"; Get localized string:C991("product"); \
				"form"; "PRODUCT"))
			
			$o.panels.push(New object:C1471(\
				"title"; Get localized string:C991("developer"); \
				"form"; "DEVELOPER"))
			
			//………………………………………………………………………………………
		: ($index=2)
			
			$o.panels.push(New object:C1471(\
				"title"; Get localized string:C991("publishedStructure"); \
				"form"; "STRUCTURE"; \
				"noTitle"; True:C214))
			
			$o.action:=New object:C1471(\
				"title"; "syncDataModel"; \
				"show"; False:C215; \
				"formula"; Formula:C1597(POST_MESSAGE(New object:C1471(\
				"target"; $w; \
				"action"; "show"; \
				"type"; "confirm"; \
				"title"; "updateTheProject"; \
				"additional"; "aBackupWillBeCreatedIntoTheProjectFolder"; \
				"ok"; "update"; \
				"okFormula"; Formula:C1597(CALL FORM:C1391($w; "editor_CALLBACK"; "syncDataModel")))))\
				)
			
			If (Form:C1466.status.dataModel#Null:C1517)
				
				If (Bool:C1537(Form:C1466.status.dataModel))
					
					// <NOTHING MORE TO DO>
					
				Else 
					
					$o.action.show:=True:C214
					
				End if 
			End if 
			
			//………………………………………………………………………………………
		: ($index=3)
			
			$o.panels.push(New object:C1471(\
				"title"; Get localized string:C991("tablesProperties"); \
				"form"; "TABLES"))
			
			$o.panels.push(New object:C1471(\
				"title"; Get localized string:C991("fieldsProperties"); \
				"form"; "FIELDS"; \
				"noTitle"; True:C214))
			
			//………………………………………………………………………………………
		: ($index=4)
			
			$o.panels.push(New object:C1471(\
				"title"; Get localized string:C991("mainMenu"); \
				"form"; "MAIN"; \
				"noTitle"; True:C214))
			
			//………………………………………………………………………………………
		: ($index=5)
			
			$o.panels.push(New object:C1471(\
				"title"; Get localized string:C991("forms"); \
				"form"; "VIEWS"; \
				"noTitle"; True:C214))
			
			$o.action:=New object:C1471(\
				"title"; ".Repair the project"; \
				"show"; False:C215; \
				"formula"; Formula:C1597(POST_MESSAGE(New object:C1471(\
				"target"; $w; \
				"action"; "show"; \
				"type"; "confirm"; \
				"title"; "updateTheProject"; \
				"additional"; "aBackupWillBeCreatedIntoTheProjectFolder"; \
				"ok"; "update"; \
				"okFormula"; Formula:C1597(CALL FORM:C1391($w; "editor_CALLBACK"; "syncDataModel")))))\
				)
			
			If (Form:C1466.status.dataModel#Null:C1517)
				
				If (Bool:C1537(Form:C1466.status.project))
					
					// <NOTHING MORE TO DO>
					
				Else 
					
					$o.action.show:=True:C214
					
				End if 
			End if 
			
			//………………………………………………………………………………………
		: ($index=6)
			
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
			
			//………………………………………………………………………………………
		: ($index=7)
			
			$o.panels.push(New object:C1471(\
				"title"; Get localized string:C991("source"); \
				"form"; "SOURCE"; \
				"help"; True:C214))
			
			$o.panels.push(New object:C1471(\
				"title"; Get localized string:C991("properties"); \
				"form"; "DATA"; \
				"help"; True:C214))
			
			//………………………………………………………………………………………
		: ($index=8)
			
			$o.panels.push(New object:C1471(\
				"form"; "ACTIONS"; \
				"noTitle"; True:C214))
			
			$o.panels.push(New object:C1471(\
				"title"; Get localized string:C991("page_action_params"); \
				"form"; "ACTIONS_PARAMS"))
			
			//………………………………………………………………………………………
		Else 
			
			$index:=-1
			
			ASSERT:C1129(False:C215; "Unknown menu action ("+$page+")")
			
			//………………………………………………………………………………………
	End case 
	
	FORM GOTO PAGE:C247(1)
	
	// Hide picker if any
	CALL FORM:C1391($w; "editor_CALLBACK"; "pickerHide")
	
	// Hide broswer if any
	CALL FORM:C1391($w; "editor_CALLBACK"; "hideBrowser")
	
	If ($index>0)
		
		Form:C1466.currentPage:=$sections{$index}
		
		(OBJECT Get pointer:C1124(Object named:K67:5; "description"))->:=Form:C1466.currentPage
		
	End if 
	
	Form:C1466.$page:=$o
	
	EXECUTE METHOD IN SUBFORM:C1085("PROJECT"; "panel_INIT"; *; $o)
	
	SET TIMER:C645(-1)  // Set geometry
	
	EXECUTE METHOD IN SUBFORM:C1085("description"; "editor_description"; *; $o)
	
End if 

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End