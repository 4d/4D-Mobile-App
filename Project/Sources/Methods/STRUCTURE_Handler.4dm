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
C_OBJECT:C1216($o; $context; $dataModel; $field; $form; $IN)
C_OBJECT:C1216($Obj_out)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(STRUCTURE_Handler; $0)
	C_OBJECT:C1216(STRUCTURE_Handler; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	
	// Optional parameters
	If ($Lon_parameters>=1)
		
		$IN:=$1
		
	End if 
	
	$form:=New object:C1471(\
		"window"; Current form window:C827; \
		"callback"; "editor_CALLBACK"; \
		"form"; editor_INIT; \
		"tableList"; "01_tables"; \
		"tables"; "tables"; \
		"tableFilter"; "tables.filter"; \
		"fieldList"; "02_fields"; \
		"fields"; "fields"; \
		"fieldFilter"; "fields.filter"; \
		"published"; "published"; \
		"publishedPtr"; UI.pointer("published"); \
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
	
Else 
	
	ABORT:C156
	
End if 

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
					
				Else 
					
					OBJECT SET TITLE:C194(*; $form.allow; cs:C1710.str.new("allowToMakeTheStructureAdjustments").localized("4dProductName"))
					
				End if 
				
				// This trick remove the horizontal gap
				OBJECT SET SCROLLBAR:C843(*; $form.fieldList; 0; 2)
				OBJECT SET SCROLLBAR:C843(*; $form.tableList; 0; 2)
				
				// Constraints definition
				$context.constraints:=New object:C1471
				
				structure_TABLE_LIST($form)
				
				If (Num:C11(PROJECT.getCatalog().length)>=500)
					
					RECORD.warning("Table number: "+String:C10(PROJECT.getCatalog().length))
					
				End if 
				
				// Initialize the search widget
				widget("search").setValue(New object:C1471(\
					"placeholder"; Get localized string:C991("search")))
				
				// Position search filters based on the language of the label
				widget($form.tableFilter).moveHorizontally(widget($form.tableList+".label").bestSize().coordinates.right+10)
				widget($form.fieldFilter).moveHorizontally(widget($form.fieldList+".label").bestSize().coordinates.right+10)
				
				// Align checkbox & help according to the translation
				widget($form.allowHelp).moveHorizontally(widget($form.allow).bestSize().coordinates.right+5)
				
				//#MARK_TODO: Nous devrions trouver un moyen plus élégant!
				CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "description"; New object:C1471(\
					"show"; Not:C34(Bool:C1537(Form:C1466.$project.structure.dataModel))))
				
				//______________________________________________________
			: ($Lon_formEvent=On Timer:K2:25)
				
				editor_ui_LISTBOX($form.tableList)
				editor_ui_LISTBOX($form.fieldList)
				
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
		
		structure_TABLE_LIST($form)
		
		//=========================================================
	: ($IN.action="tableFilter")
		
		Case of 
				
				//………………………………………………………………………………………
			: (Length:C16(String:C10($context.tableFilter))=0)\
				 & (Not:C34(Bool:C1537($context.tableFilterPublished)))
				
				// NOTHING MORE TO DO
				
				//………………………………………………………………………………………
			: (Length:C16(String:C10($context.tableFilter))>0)\
				 & (Bool:C1537($context.tableFilterPublished))
				
				$t:=Get localized string:C991("filteredBy")\
					+Char:C90(Space:K15:42)\
					+"<span style=\"-d4-ref-user:'filter'\">"\
					+Get localized string:C991("structName")\
					+" ("+Get localized string:C991("published")+")"\
					+"</span>"
				
				//………………………………………………………………………………………
			: (Length:C16(String:C10($context.tableFilter))>0)
				
				$t:=Get localized string:C991("filteredBy")\
					+Char:C90(Space:K15:42)\
					+"<span style=\"-d4-ref-user:'filter'\">"\
					+Get localized string:C991("structName")\
					+"</span>"
				
				//………………………………………………………………………………………
			: (Bool:C1537($context.tableFilterPublished))
				
				$t:=Get localized string:C991("filteredBy")\
					+Char:C90(Space:K15:42)\
					+"<span style=\"-d4-ref-user:'filter'\">"\
					+Get localized string:C991("published")\
					+"</span>"
				
				//………………………………………………………………………………………
		End case 
		
		ST SET TEXT:C1115(*; $form.tableFilter; $t; ST Start text:K78:15; ST End text:K78:16)
		
		//=========================================================
	: ($IN.action="fieldList")
		
		$o:=PROJECT.getCatalog().query("name = :1"; String:C10($context.currentTable.name)).pop()
		
		If ($o=Null:C1517)
			
			OB REMOVE:C1226($context; "currentTable")
			
		Else 
			
			$context.currentTable:=$o
			
		End if 
		
		structure_FIELD_LIST($form)
		
		//=========================================================
	: ($IN.action="fieldFilter")
		
		Case of 
				
				//………………………………………………………………………………………
			: (Length:C16(String:C10($context.fieldFilter))=0)\
				 & (Not:C34(Bool:C1537($context.fieldFilterPublished)))
				
				// NOTHING MORE TO DO
				
				//………………………………………………………………………………………
			: (Length:C16(String:C10($context.fieldFilter))>0)\
				 & (Bool:C1537($context.fieldFilterPublished))
				
				$t:=Get localized string:C991("filteredBy")\
					+Char:C90(Space:K15:42)\
					+"<span style=\"-d4-ref-user:'filter'\">"\
					+Get localized string:C991("structName")\
					+" ("+Get localized string:C991("published")+")"\
					+"</span>"
				
				//………………………………………………………………………………………
			: (Length:C16(String:C10($context.fieldFilter))>0)
				
				$t:=Get localized string:C991("filteredBy")\
					+Char:C90(Space:K15:42)\
					+"<span style=\"-d4-ref-user:'filter'\">"\
					+Get localized string:C991("structName")\
					+"</span>"
				
				//………………………………………………………………………………………
			: (Bool:C1537($context.fieldFilterPublished))
				
				$t:=Get localized string:C991("filteredBy")\
					+Char:C90(Space:K15:42)\
					+"<span style=\"-d4-ref-user:'filter'\">"\
					+Get localized string:C991("published")\
					+"</span>"
				
				//………………………………………………………………………………………
		End case 
		
		ST SET TEXT:C1115(*; $form.fieldFilter; $t; ST Start text:K78:15; ST End text:K78:16)
		
		If (Bool:C1537($IN.showIfNotEmpty))
			
			OBJECT SET VISIBLE:C603(*; $form.fieldFilter; Length:C16($t)>0)
			
		End if 
		
		//=========================================================
	: ($IN.action="addTable")
		
		PROJECT.addTable($context.currentTable)
		
		// Highlight the table name
		$index:=Find in array:C230((UI.pointer($form.tableList))->; True:C214)
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
	: ($IN.action="appendField")
		
		Case of 
				
			: (False:C215)
				
				var $structure : cs:C1710.structure
				$structure:=cs:C1710.structure.new()
				
				$structure.addField($IN.table; $IN.field)
				
				//…………………………………………………………………………………………………
			: ($IN.field.type=-1)  // N -> 1 relation
				
				$dataModel:=Form:C1466.dataModel[String:C10($IN.table.tableNumber)][$IN.field.name]
				
				If ($dataModel#Null:C1517)
					
					$published:=1  // All related fields are published
					
					var $structure : cs:C1710.structure
					var $relatedCatalog : Object
					$structure:=cs:C1710.structure.new()
					$relatedCatalog:=$structure.relatedCatalog($IN.table.name; $IN.field.name; True:C214)
					
					If ($relatedCatalog.success)
						
						For each ($field; $relatedCatalog.fields)
							
							Case of 
									//______________________________________________________
								: ($field.fieldType=8859)
									
									$published:=$published+Num:C11($dataModel[String:C10($field.name)]=Null:C1517)
									
									//______________________________________________________
								: ($field.fieldType=8858)
									
									$published:=$published+Num:C11($dataModel[String:C10($field.name)]=Null:C1517)
									
									//______________________________________________________
								Else 
									
									$c:=Split string:C1554($field.path; "."; sk ignore empty strings:K86:1)
									
									If ($c.length=1)
										
										// Field
										$published:=$published+Num:C11($dataModel[String:C10($field.fieldNumber)]=Null:C1517)
										
									Else 
										
										// Link
										$published:=$published+Num:C11($dataModel[$c[0]][String:C10($field.fieldNumber)]=Null:C1517)
										
									End if 
									
									//______________________________________________________
							End case 
						End for each 
					End if 
				End if 
				
				APPEND TO ARRAY:C911(($IN.published)->; $published)
				APPEND TO ARRAY:C911(($IN.icons)->; UI.fieldIcons[8858])
				APPEND TO ARRAY:C911(($IN.fields)->; $IN.field.name)
				
				//…………………………………………………………………………………………………
			: ($IN.field.type=-2)  // 1 -> N relation
				
				//*******************************************************************************************
				$published:=Num:C11(Form:C1466.dataModel[String:C10($IN.table.tableNumber)][String:C10($IN.field.name)]#Null:C1517)
				
				//
				// C'EST FAUX SI LE LIEN A ÉTÉ RENOMMÉ
				// REGARDER DANS : Form.$dialog.unsynchronizedTableFields[String($Obj_in.table.tableNumber)]
				//
				//*******************************************************************************************
				
				APPEND TO ARRAY:C911(($IN.published)->; $published)
				APPEND TO ARRAY:C911(($IN.icons)->; UI.fieldIcons[8859])
				APPEND TO ARRAY:C911(($IN.fields)->; $IN.field.name)
				
				//…………………………………………………………………………………………………
			Else 
				
				If ($IN.field.fieldType<=UI.fieldIcons.length)
					
					$published:=Num:C11(Form:C1466.dataModel[String:C10($IN.table.tableNumber)][String:C10($IN.field.id)]#Null:C1517)
					
					APPEND TO ARRAY:C911(($IN.published)->; $published)
					APPEND TO ARRAY:C911(($IN.icons)->; UI.fieldIcons[$IN.field.fieldType])
					APPEND TO ARRAY:C911(($IN.fields)->; $IN.field.name)
					
				End if 
				
				LISTBOX SET ROW FONT STYLE:C1268(*; $form.fieldList; Size of array:C274(($IN.fields)->); Plain:K14:1)
				
				//…………………………………………………………………………………………………
		End case 
		
		//=========================================================
	: ($IN.action="update")
		
		// Update ribbon
		CALL FORM:C1391($form.window; $form.callback; "updateRibbon")
		
		// Update structure dependencies, if any
		CALL FORM:C1391($form.window; $form.callback; "tableList"; PROJECT)
		CALL FORM:C1391($form.window; $form.callback; "fieldList"; PROJECT)
		CALL FORM:C1391($form.window; $form.callback; "tableProperties"; PROJECT)
		CALL FORM:C1391($form.window; $form.callback; "mainMenu")
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$IN.action+"\"")
		
		//=========================================================
End case 
