//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : STRUCTURE_Handler
// ID[FC936489078D4808B8FE68189681B7FF]
// Created 25-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($index; $Lon_formEvent; $Lon_parameters; $published)
C_TEXT:C284($t)
C_OBJECT:C1216($o; $context; $fieldModel; $field; $form; $IN)
C_OBJECT:C1216($Obj_out)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(STRUCTURE_Handler; $0)
	C_OBJECT:C1216(STRUCTURE_Handler; $1)
End if 

// ----------------------------------------------------
// Initialisations

// Optional parameters
If (Count parameters:C259>=1)
	
	$IN:=$1
	
End if 

$form:=New object:C1471(\
"window"; Current form window:C827; \
"callback"; Formula:C1597(editor_CALLBACK).source; \
"form"; _o_editor_Panel_init; \
"tableList"; "01_tables"; \
"tables"; "tables"; \
"tableFilter"; "tables.filter"; \
"fieldList"; "02_fields"; \
"fields"; "fields"; \
"fieldFilter"; "fields.filter"; \
"published"; "published"; \
"publishedPtr"; OBJECT Get pointer:C1124(Object named:K67:5; "published"); \
"icons"; "icons"; \
"search"; "search"; \
"action"; "action"; \
"allow"; "allowStructureAjustment"; \
"allowHelp"; "allowStructureAjustment.help")

$context:=$form.form

If (OB Is empty:C1297($context))
	
	// Define locales functions
	$context.setHelpTip:=Formula:C1597(STRUCTURE_TIPS(New object:C1471("target"; $1; "form"; $2)))
	
End if 

var $class : cs:C1710.STRUCTURE
$class:=cs:C1710.STRUCTURE.new($form)

// ----------------------------------------------------
Case of 
		
		//=========================================================
	: ($IN=Null:C1517)  // Form method
		
		$Lon_formEvent:=_o_panel_Form_common(On Load:K2:1; On Timer:K2:25)
		
		Case of 
				
				//______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				If (Form:C1466.dataModel=Null:C1517)
					
					Form:C1466.dataModel:=New object:C1471
					
				End if 
				
				If (Bool:C1537(Form:C1466.allowStructureAdjustments))
					
					OBJECT SET VISIBLE:C603(*; $form.allow+"@"; False:C215)
					OBJECT MOVE:C664(*; $form.tableList+"@"; 0; 0; 0; 20)
					OBJECT MOVE:C664(*; $form.fieldList+"@"; 0; 0; 0; 20)
					
				End if 
				
				// This trick remove the horizontal gap
				OBJECT SET SCROLLBAR:C843(*; $form.fieldList; 0; 2)
				OBJECT SET SCROLLBAR:C843(*; $form.tableList; 0; 2)
				
				// Constraints definition
				$context.constraints:=New object:C1471
				
				$class.tableList()
				
				If (Num:C11(PROJECT.getCatalog().length)>=500)
					
					Logger.warning("Table number: "+String:C10(PROJECT.getCatalog().length))
					
				End if 
				
				// Initialize the search widget
				_o_widget("search").setValue(New object:C1471(\
					"placeholder"; Get localized string:C991("search")))
				
				// Position search filters based on the language of the label
				_o_widget($form.tableFilter).moveHorizontally(_o_widget($form.tableList+".label").bestSize().coordinates.right+10)
				_o_widget($form.fieldFilter).moveHorizontally(_o_widget($form.fieldList+".label").bestSize().coordinates.right+10)
				
				// Align checkbox & help according to the translation
				_o_widget($form.allowHelp).moveHorizontally(_o_widget($form.allow).bestSize().coordinates.right+5)
				
				UI.updateHeader(New object:C1471(\
					"show"; Not:C34(Bool:C1537(Form:C1466.$project.structure.dataModel))))
				
				//______________________________________________________
			: ($Lon_formEvent=On Timer:K2:25)
				
				_editor_ui_LISTBOX($form.tableList)
				_editor_ui_LISTBOX($form.fieldList)
				
				//______________________________________________________
		End case 
		
		//=========================================================
	: ($IN.action=Null:C1517)
		
		ASSERT:C1129(False:C215; "Missing parameter \"action\"")
		
		//=========================================================
	: ($IN.action="init")
		
		// Return the form objects definition
		$0:=$form
		
		//=========================================================
	: ($IN.action="tableList")
		
		$class.tableList()
		
		//=========================================================
	: ($IN.action="fieldList")
		
		$o:=PROJECT.getCatalog().query("name = :1"; String:C10($context.currentTable.name)).pop()
		
		If ($o=Null:C1517)
			
			OB REMOVE:C1226($context; "currentTable")
			
		Else 
			
			$context.currentTable:=$o
			
		End if 
		
		$class.fieldList()
		
		//=========================================================
	: ($IN.action="addTable")
		
		PROJECT.addTable($context.currentTable)
		
		// Highlight the table name
		$index:=Find in array:C230((OBJECT Get pointer:C1124(Object named:K67:5; $form.tableList))->; True:C214)
		LISTBOX SET ROW FONT STYLE:C1268(*; $form.tableList; $index; Bold:K14:2)
		
		//=========================================================
	: ($IN.action="geometry")
		
		Case of 
				
				//______________________________________________________
			: ($IN.target="STRUCTURE")  // Vertical resizing
				
				//OBJECT GET SUBFORM CONTAINER SIZE($Lon_width;$Lon_height)
				//$Lon_bottom:=$Lon_height-10
				//OBJECT GET COORDINATES(*;$Obj_form.tableList;$Lon_left;$Lon_top;$Lon_right;$Lon_)
				//OBJECT SET COORDINATES(*;$Obj_form.tableList;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
				//OBJECT SET COORDINATES(*;$Obj_form.tableList+".border";$Lon_left-1;$Lon_top-1;$Lon_right+1;$Lon_bottom+1)
				//OBJECT GET COORDINATES(*;$Obj_form.fieldList;$Lon_left;$Lon_top;$Lon_right;$Lon_)
				//OBJECT SET COORDINATES(*;$Obj_form.fieldList;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
				//OBJECT SET COORDINATES(*;$Obj_form.fieldList+".border";$Lon_left-1;$Lon_top-1;$Lon_right+1;$Lon_bottom+1)
				//OBJECT GET COORDINATES(*;"_viewport";$Lon_left;$Lon_top;$Lon_right;$Lon_)
				//OBJECT SET COORDINATES(*;"_viewport";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Unknown target: \""+$IN.target+"\"")
				
				//______________________________________________________
		End case 
		
		//=========================================================
	: ($IN.action="onLosingFocus")
		
		OBJECT SET VISIBLE:C603(*; $form.search; False:C215)
		OBJECT SET VISIBLE:C603(*; $form.action; False:C215)
		
		//=========================================================
	: ($IN.action="update")
		
		// Update ribbon
		UI.updateRibbon()
		
		// Update structure dependencies, if any
		UI.callMeBack("tableList")
		UI.callMeBack("fieldList")
		UI.callMeBack("tableProperties")
		//EDITOR.callMeBack("mainMenu")
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$IN.action+"\"")
		
		//=========================================================
End case 
