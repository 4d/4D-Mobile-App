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

C_LONGINT:C283($Lon_i;$Lon_page;$Lon_pageNumber;$Lon_parameters)
C_TEXT:C284($Mnu_main;$Txt_currentPage;$Txt_page)
C_OBJECT:C1216($Obj_geometry)

If (False:C215)
	C_TEXT:C284(editor_PAGE ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	$Txt_currentPage:=String:C10(Form:C1466.currentPage)
	
	$Lon_pageNumber:=8
	
	ARRAY TEXT:C222($tTxt_pages;$Lon_pageNumber)
	$tTxt_pages{1}:="general"
	$tTxt_pages{2}:="structure"
	$tTxt_pages{3}:="properties"
	$tTxt_pages{4}:="main"
	$tTxt_pages{5}:="views"
	$tTxt_pages{6}:="deployment"
	$tTxt_pages{7}:="data"
	$tTxt_pages{8}:="actions"
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Txt_page:=$1
		
		Case of 
				
				  //______________________________________________________
			: ($Txt_page="next")
				
				$Lon_page:=Find in array:C230($tTxt_pages;$Txt_currentPage)
				
				If ($Lon_page<$Lon_pageNumber)
					
					$Txt_page:=$tTxt_pages{$Lon_page+1}
					
				Else 
					
					  // Go to the first page
					$Txt_page:=$tTxt_pages{1}
					
				End if 
				
				  //______________________________________________________
			: ($Txt_page="previous")
				
				$Lon_page:=Find in array:C230($tTxt_pages;$Txt_currentPage)
				
				If ($Lon_page>1)
					
					$Txt_page:=$tTxt_pages{$Lon_page-1}
					
				Else 
					
					  // Go to the last page
					$Txt_page:=$tTxt_pages{$Lon_pageNumber}
					
				End if 
				
				  //______________________________________________________
		End case 
		
	Else 
		
		  // Display menu
		$Mnu_main:=Create menu:C408
		
		For ($Lon_i;1;$Lon_pageNumber;1)
			
			APPEND MENU ITEM:C411($Mnu_main;":xliff:page_"+$tTxt_pages{$Lon_i})
			SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;$tTxt_pages{$Lon_i})
			SET MENU ITEM ICON:C984($Mnu_main;-1;"#/images/toolbar/"+$tTxt_pages{$Lon_i}+".png")
			
			If ($Txt_currentPage=$tTxt_pages{$Lon_i})
				
				SET MENU ITEM MARK:C208($Mnu_main;-1;Char:C90(DC2 ASCII code:K15:19))
				
			End if 
		End for 
		
		$Txt_page:=Dynamic pop up menu:C1006($Mnu_main)
		RELEASE MENU:C978($Mnu_main)
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Length:C16($Txt_page)>0)
	
	$Obj_geometry:=New object:C1471
	
	$Obj_geometry.ui:=(OBJECT Get pointer:C1124(Object named:K67:5;"UI";"PROJECT"))->  // ->ui // TODO check with vincent
	$Obj_geometry.panels:=New collection:C1472
	
	$Lon_page:=Find in array:C230($tTxt_pages;$Txt_page)
	
	Case of 
			
			  //………………………………………………………………………………………
		: ($Lon_page=1)
			
			$Obj_geometry.panels.push(New object:C1471(\
				"title";Get localized string:C991("organization");\
				"form";"ORGANIZATION"))
			
			$Obj_geometry.panels.push(New object:C1471(\
				"title";Get localized string:C991("product");\
				"form";"PRODUCT"))
			
			$Obj_geometry.panels.push(New object:C1471(\
				"title";Get localized string:C991("developer");\
				"form";"DEVELOPER"))
			
			  //………………………………………………………………………………………
		: ($Lon_page=2)
			
			$Obj_geometry.panels.push(New object:C1471(\
				"title";Get localized string:C991("publishedStructure");\
				"form";"STRUCTURE";\
				"noTitle";True:C214))
			
			
			$Obj_geometry.action:=New object:C1471(\
				"title";"syncDataModel";\
				"show";False:C215;\
				"formula";Formula:C1597(POST_FORM_MESSAGE (New object:C1471(\
				"target";Current form window:C827;\
				"action";"show";\
				"type";"confirm";\
				"title";"updateTheProject";\
				"additional";"aBackupWillBeCreatedIntoTheProjectFolder";\
				"ok";"update";\
				"okFormula";Formula:C1597(CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"syncDataModel")))))\
				)
			
			If (Form:C1466.status.dataModel#Null:C1517)
				
				If (Bool:C1537(Form:C1466.status.dataModel))
					
					  // <NOTHING MORE TO DO>
					
				Else 
					
					$Obj_geometry.action.show:=True:C214
					
				End if 
			End if 
			
			  //………………………………………………………………………………………
		: ($Lon_page=3)
			
			$Obj_geometry.panels.push(New object:C1471(\
				"title";Get localized string:C991("tablesProperties");\
				"form";"TABLES"))
			
			$Obj_geometry.panels.push(New object:C1471(\
				"title";Get localized string:C991("fieldsProperties");\
				"form";"FIELDS";\
				"noTitle";True:C214))
			
			  //………………………………………………………………………………………
		: ($Lon_page=4)
			
			$Obj_geometry.panels.push(New object:C1471(\
				"title";Get localized string:C991("mainMenu");\
				"form";"MAIN";\
				"noTitle";True:C214))
			
			  //………………………………………………………………………………………
		: ($Lon_page=5)
			
			$Obj_geometry.panels.push(New object:C1471(\
				"title";Get localized string:C991("forms");\
				"form";"VIEWS";\
				"noTitle";True:C214))
			
			  //………………………………………………………………………………………
		: ($Lon_page=6)
			
			$Obj_geometry.panels.push(New object:C1471(\
				"title";Get localized string:C991("server");\
				"form";"SERVER"))
			
			If (False:C215)
				
				$Obj_geometry.panels.push(New object:C1471(\
					"title";"UI FOR DEMO PURPOSE";\
					"form";"UI"))
				
			End if 
			
			  //………………………………………………………………………………………
		: ($Lon_page=7)
			
			$Obj_geometry.panels.push(New object:C1471(\
				"title";Get localized string:C991("source");\
				"form";"SOURCE";\
				"help";True:C214))
			
			$Obj_geometry.panels.push(New object:C1471(\
				"title";Get localized string:C991("properties");\
				"form";"DATA";\
				"help";True:C214))
			
			  //………………………………………………………………………………………
		: ($Lon_page=8)
			
			$Obj_geometry.panels.push(New object:C1471(\
				"form";"ACTIONS";\
				"noTitle";True:C214))
			
			$Obj_geometry.panels.push(New object:C1471(\
				"title";Get localized string:C991("page_action_params");\
				"form";"ACTIONS_PARAMS"))
			
			  //………………………………………………………………………………………
		Else 
			
			$Lon_page:=-1
			
			ASSERT:C1129(False:C215;"Unknown menu action ("+$Txt_page+")")
			
			  //………………………………………………………………………………………
	End case 
	
	If ($tTxt_pages{$Lon_page}#$Txt_currentPage)
		
		  // Hide picker if any
		CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"pickerHide")
		
		If ($Lon_page>0)
			
			Form:C1466.currentPage:=$tTxt_pages{$Lon_page}
			
			(OBJECT Get pointer:C1124(Object named:K67:5;"description"))->:=Form:C1466.currentPage
			
			EXECUTE METHOD IN SUBFORM:C1085("description";"editor_description";*;$Obj_geometry)
			
		End if 
		
		Form:C1466.$page:=$Obj_geometry
		
		EXECUTE METHOD IN SUBFORM:C1085("PROJECT";"panel_INIT";*;$Obj_geometry)
		
		SET TIMER:C645(-1)  // Set geometry
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End