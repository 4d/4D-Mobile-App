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
C_TEXT:C284($1)

C_LONGINT:C283($count;$i;$indx;$w)
C_TEXT:C284($Txt_page)
C_OBJECT:C1216($menu;$o)

If (False:C215)
	C_TEXT:C284(editor_PAGE ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations

  // NO PARAMETERS REQUIRED

$count:=8

ARRAY TEXT:C222($tTxt_pages;$count)
$tTxt_pages{1}:="general"
$tTxt_pages{2}:="structure"
$tTxt_pages{3}:="properties"
$tTxt_pages{4}:="main"
$tTxt_pages{5}:="views"
$tTxt_pages{6}:="deployment"
$tTxt_pages{7}:="data"
$tTxt_pages{8}:="actions"

$tTxt_pages{0}:=String:C10(Form:C1466.currentPage)

$w:=Current form window:C827

  // Optional parameters
If (Count parameters:C259>=1)
	
	$Txt_page:=$1
	
	Case of 
			
			  //______________________________________________________
		: ($Txt_page="next")
			
			$indx:=Find in array:C230($tTxt_pages;$tTxt_pages{0})
			
			If ($indx<$count)
				
				$Txt_page:=$tTxt_pages{$indx+1}
				
			Else 
				
				  // Go to the first page
				$Txt_page:=$tTxt_pages{1}
				
			End if 
			
			  //______________________________________________________
		: ($Txt_page="previous")
			
			$indx:=Find in array:C230($tTxt_pages;$tTxt_pages{0})
			
			If ($indx>1)
				
				$Txt_page:=$tTxt_pages{$indx-1}
				
			Else 
				
				  // Go to the last page
				$Txt_page:=$tTxt_pages{$count}
				
			End if 
			
			  //______________________________________________________
	End case 
	
Else 
	
	  // Display menu
	$menu:=cs:C1710.menu.new()
	
	For ($i;1;$count;1)
		
		$menu.append("page_"+$tTxt_pages{$i};$tTxt_pages{$i})\
			.icon("#/images/toolbar/"+$tTxt_pages{$i}+".png")\
			.mark($tTxt_pages{0}=$tTxt_pages{$i})
		
	End for 
	
	$menu.popup()
	
	If ($menu.selected)
		
		$Txt_page:=$menu.choice
		
	End if 
End if 

  // ----------------------------------------------------
If (Length:C16($Txt_page)>0)
	
	$o:=New object:C1471
	
	$o.ui:=(OBJECT Get pointer:C1124(Object named:K67:5;"UI";"PROJECT"))->  // ->ui // TODO check with vincent
	$o.panels:=New collection:C1472
	
	$indx:=Find in array:C230($tTxt_pages;$Txt_page)
	
	Case of 
			
			  //………………………………………………………………………………………
		: ($indx=1)
			
			$o.panels.push(New object:C1471(\
				"title";Get localized string:C991("organization");\
				"form";"ORGANIZATION"))
			
			$o.panels.push(New object:C1471(\
				"title";Get localized string:C991("product");\
				"form";"PRODUCT"))
			
			$o.panels.push(New object:C1471(\
				"title";Get localized string:C991("developer");\
				"form";"DEVELOPER"))
			
			  //………………………………………………………………………………………
		: ($indx=2)
			
			$o.panels.push(New object:C1471(\
				"title";Get localized string:C991("publishedStructure");\
				"form";"STRUCTURE";\
				"noTitle";True:C214))
			
			$o.action:=New object:C1471(\
				"title";"syncDataModel";\
				"show";False:C215;\
				"formula";Formula:C1597(POST_FORM_MESSAGE (New object:C1471(\
				"target";$w;\
				"action";"show";\
				"type";"confirm";\
				"title";"updateTheProject";\
				"additional";"aBackupWillBeCreatedIntoTheProjectFolder";\
				"ok";"update";\
				"okFormula";Formula:C1597(CALL FORM:C1391($w;"editor_CALLBACK";"syncDataModel")))))\
				)
			
			If (Form:C1466.status.dataModel#Null:C1517)
				
				If (Bool:C1537(Form:C1466.status.dataModel))
					
					  // <NOTHING MORE TO DO>
					
				Else 
					
					$o.action.show:=True:C214
					
				End if 
			End if 
			
			  //………………………………………………………………………………………
		: ($indx=3)
			
			$o.panels.push(New object:C1471(\
				"title";Get localized string:C991("tablesProperties");\
				"form";"TABLES"))
			
			$o.panels.push(New object:C1471(\
				"title";Get localized string:C991("fieldsProperties");\
				"form";"FIELDS";\
				"noTitle";True:C214))
			
			  //………………………………………………………………………………………
		: ($indx=4)
			
			$o.panels.push(New object:C1471(\
				"title";Get localized string:C991("mainMenu");\
				"form";"MAIN";\
				"noTitle";True:C214))
			
			  //………………………………………………………………………………………
		: ($indx=5)
			
			If (feature.with("newViewUI"))
				
				$o.panels.push(New object:C1471(\
					"title";Get localized string:C991("forms");\
					"form";"VIEWS";\
					"noTitle";True:C214))
				
			Else 
				
				$o.panels.push(New object:C1471(\
					"title";Get localized string:C991("forms");\
					"form";"_o_VIEWS";\
					"noTitle";True:C214))
				
			End if 
			
			$o.action:=New object:C1471(\
				"title";".Repair the project";\
				"show";False:C215;\
				"formula";Formula:C1597(POST_FORM_MESSAGE (New object:C1471(\
				"target";$w;\
				"action";"show";\
				"type";"confirm";\
				"title";"updateTheProject";\
				"additional";"aBackupWillBeCreatedIntoTheProjectFolder";\
				"ok";"update";\
				"okFormula";Formula:C1597(CALL FORM:C1391($w;"editor_CALLBACK";"syncDataModel")))))\
				)
			
			If (Form:C1466.status.dataModel#Null:C1517)
				
				If (Bool:C1537(Form:C1466.status.project))
					
					  // <NOTHING MORE TO DO>
					
				Else 
					
					$o.action.show:=True:C214
					
				End if 
			End if 
			
			  //………………………………………………………………………………………
		: ($indx=6)
			
			If (feature.with("pushNotification"))
				
				$o.panels.push(New object:C1471(\
					"title";Get localized string:C991("server");\
					"form";"SERVER"))
				
				$o.panels.push(New object:C1471(\
					"title";Get localized string:C991("features");\
					"form";"FEATURES"))
				
			Else 
				
				$o.panels.push(New object:C1471(\
					"title";Get localized string:C991("server");\
					"form";"_o_SERVER"))
				
			End if 
			
			If (False:C215)
				$o.panels.push(New object:C1471(\
					"title";"UI FOR DEMO PURPOSE";\
					"form";"UI"))
			End if 
			
			  //………………………………………………………………………………………
		: ($indx=7)
			
			$o.panels.push(New object:C1471(\
				"title";Get localized string:C991("source");\
				"form";"SOURCE";\
				"help";True:C214))
			
			$o.panels.push(New object:C1471(\
				"title";Get localized string:C991("properties");\
				"form";"DATA";\
				"help";True:C214))
			
			  //………………………………………………………………………………………
		: ($indx=8)
			
			$o.panels.push(New object:C1471(\
				"form";"ACTIONS";\
				"noTitle";True:C214))
			
			$o.panels.push(New object:C1471(\
				"title";Get localized string:C991("page_action_params");\
				"form";"ACTIONS_PARAMS"))
			
			  //………………………………………………………………………………………
		Else 
			
			$indx:=-1
			
			ASSERT:C1129(False:C215;"Unknown menu action ("+$Txt_page+")")
			
			  //………………………………………………………………………………………
	End case 
	
	FORM GOTO PAGE:C247(1)
	
	If ($tTxt_pages{$indx}#$tTxt_pages{0})  // | (Count parameters=2)
		
		  // Hide picker if any
		CALL FORM:C1391($w;"editor_CALLBACK";"pickerHide")
		
		  // Hide broswer if any
		CALL FORM:C1391($w;"editor_CALLBACK";"hideBrowser")
		
		If ($indx>0)
			
			Form:C1466.currentPage:=$tTxt_pages{$indx}
			
			(OBJECT Get pointer:C1124(Object named:K67:5;"description"))->:=Form:C1466.currentPage
			
		End if 
		
		Form:C1466.$page:=$o
		
		EXECUTE METHOD IN SUBFORM:C1085("PROJECT";"panel_INIT";*;$o)
		
		SET TIMER:C645(-1)  // Set geometry
		
	End if 
	
	EXECUTE METHOD IN SUBFORM:C1085("description";"editor_description";*;$o)
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End