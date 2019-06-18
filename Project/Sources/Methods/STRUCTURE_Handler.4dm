//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : STRUCTURE_Handler
  // Database: 4D Mobile Express
  // ID[FC936489078D4808B8FE68189681B7FF]
  // Created #25-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($l;$Lon_formEvent;$Lon_parameters;$Lon_published;$Lon_shift)
C_TEXT:C284($t)
C_OBJECT:C1216($o;$Obj_context;$Obj_dataModel;$Obj_field;$Obj_form;$Obj_in)
C_OBJECT:C1216($Obj_out;$Obj_table)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(STRUCTURE_Handler ;$0)
	C_OBJECT:C1216(STRUCTURE_Handler ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
	End if 
	
	$Obj_form:=New object:C1471(\
		"window";Current form window:C827;\
		"callback";"editor_CALLBACK";\
		"form";editor_INIT ;\
		"tableList";"01_tables";\
		"tables";"tables";\
		"tableFilter";"tables.filter";\
		"fieldList";"02_fields";\
		"fields";"fields";\
		"fieldFilter";"fields.filter";\
		"published";"published";\
		"publishedPtr";ui.pointer("published");\
		"icons";"icons";\
		"search";"search";\
		"action";"action";\
		"allow";"allowStructureAjustment";\
		"allowHelp";"allowStructureAjustment.help")
	
	$Obj_context:=$Obj_form.form
	
	If (OB Is empty:C1297($Obj_context))
		
		  // Define locales functions
		$Obj_context.catalog:=Formula:C1597(editor_Catalog )
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$Lon_formEvent:=panel_Form_common (On Load:K2:1;On Timer:K2:25)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				If (Form:C1466.dataModel=Null:C1517)
					
					Form:C1466.dataModel:=New object:C1471
					
				End if 
				
				If (Bool:C1537(Form:C1466.allowStructureAdjustments))
					
					OBJECT SET VISIBLE:C603(*;$Obj_form.allow+"@";False:C215)
					OBJECT MOVE:C664(*;$Obj_form.tableList+"@";0;0;0;20)
					OBJECT MOVE:C664(*;$Obj_form.fieldList+"@";0;0;0;20)
					
				Else 
					
					OBJECT SET TITLE:C194(*;$Obj_form.allow;str_localized (New collection:C1472("allowToMakeTheStructureAdjustments";"4dProductName")))
					
				End if 
				
				  // This trick remove the horizontal gap
				OBJECT SET SCROLLBAR:C843(*;$Obj_form.fieldList;0;2)
				OBJECT SET SCROLLBAR:C843(*;$Obj_form.tableList;0;2)
				
				  // Constraints definition
				$Obj_context.constraints:=New object:C1471
				
				If (Num:C11($Obj_context.catalog().length)<=100)  // #TO_TEST with a fat structure
					
					structure_TABLE_LIST ($Obj_form)
					
				End if 
				
				  // Initialize the search widget
				widget ("search").setValue(New object:C1471(\
					"placeholder";Get localized string:C991("search")))
				
				  // Position search filters based on the language of the label
				widget ($Obj_form.tableFilter).moveHorizontally(widget ($Obj_form.tableList+".label").bestSize().coordinates.right+10)
				widget ($Obj_form.fieldFilter).moveHorizontally(widget ($Obj_form.fieldList+".label").bestSize().coordinates.right+10)
				
				  // Align checkbox & help according to the translation
				widget ($Obj_form.allowHelp).moveHorizontally(widget ($Obj_form.allow).bestSize().coordinates.right+5)
				
				  //______________________________________________________
			: ($Lon_formEvent=On Timer:K2:25)
				
				editor_ui_LISTBOX ($Obj_form.tableList)
				editor_ui_LISTBOX ($Obj_form.fieldList)
				
				  //______________________________________________________
		End case 
		
		  //=========================================================
	: ($Obj_in.action=Null:C1517)
		
		ASSERT:C1129(False:C215;"Missing parameter \"action\"")
		
		  //=========================================================
	: ($Obj_in.action="init")
		
		  // Return the form objects definition
		$Obj_out:=$Obj_form
		
		  //=========================================================
	: ($Obj_in.action="tableList")
		
		structure_TABLE_LIST ($Obj_form)
		
		  //=========================================================
	: ($Obj_in.action="tableFilter")
		
		Case of 
				
				  //………………………………………………………………………………………
			: (Length:C16(String:C10($Obj_context.tableFilter))=0)\
				 & (Not:C34(Bool:C1537($Obj_context.tableFilterPublished)))
				
				  // NOTHING MORE TO DO
				
				  //………………………………………………………………………………………
			: (Length:C16(String:C10($Obj_context.tableFilter))>0)\
				 & (Bool:C1537($Obj_context.tableFilterPublished))
				
				$t:=Get localized string:C991("filteredBy")\
					+Char:C90(Space:K15:42)\
					+"<span style=\"-d4-ref-user:'filter'\">"\
					+Get localized string:C991("structName")\
					+" ("+Get localized string:C991("published")+")"\
					+"</span>"
				
				  //………………………………………………………………………………………
			: (Length:C16(String:C10($Obj_context.tableFilter))>0)
				
				$t:=Get localized string:C991("filteredBy")\
					+Char:C90(Space:K15:42)\
					+"<span style=\"-d4-ref-user:'filter'\">"\
					+Get localized string:C991("structName")\
					+"</span>"
				
				  //………………………………………………………………………………………
			: (Bool:C1537($Obj_context.tableFilterPublished))
				
				$t:=Get localized string:C991("filteredBy")\
					+Char:C90(Space:K15:42)\
					+"<span style=\"-d4-ref-user:'filter'\">"\
					+Get localized string:C991("published")\
					+"</span>"
				
				  //………………………………………………………………………………………
		End case 
		
		ST SET TEXT:C1115(*;$Obj_form.tableFilter;$t;ST Start text:K78:15;ST End text:K78:16)
		
		  //=========================================================
	: ($Obj_in.action="fieldList")
		
		$c:=$Obj_context.catalog().query("name = :1";String:C10($Obj_context.currentTable.name))
		
		If ($c.length=1)
			
			$Obj_context.currentTable:=$c[0]
			
		Else 
			
			OB REMOVE:C1226($Obj_context;"currentTable")
			
		End if 
		
		structure_FIELD_LIST ($Obj_form)
		
		  //=========================================================
	: ($Obj_in.action="fieldFilter")
		
		Case of 
				
				  //………………………………………………………………………………………
			: (Length:C16(String:C10($Obj_context.fieldFilter))=0)\
				 & (Not:C34(Bool:C1537($Obj_context.fieldFilterPublished)))
				
				  // NOTHING MORE TO DO
				
				  //………………………………………………………………………………………
			: (Length:C16(String:C10($Obj_context.fieldFilter))>0)\
				 & (Bool:C1537($Obj_context.fieldFilterPublished))
				
				$t:=Get localized string:C991("filteredBy")\
					+Char:C90(Space:K15:42)\
					+"<span style=\"-d4-ref-user:'filter'\">"\
					+Get localized string:C991("structName")\
					+" ("+Get localized string:C991("published")+")"\
					+"</span>"
				
				  //………………………………………………………………………………………
			: (Length:C16(String:C10($Obj_context.fieldFilter))>0)
				
				$t:=Get localized string:C991("filteredBy")\
					+Char:C90(Space:K15:42)\
					+"<span style=\"-d4-ref-user:'filter'\">"\
					+Get localized string:C991("structName")\
					+"</span>"
				
				  //………………………………………………………………………………………
			: (Bool:C1537($Obj_context.fieldFilterPublished))
				
				$t:=Get localized string:C991("filteredBy")\
					+Char:C90(Space:K15:42)\
					+"<span style=\"-d4-ref-user:'filter'\">"\
					+Get localized string:C991("published")\
					+"</span>"
				
				  //………………………………………………………………………………………
		End case 
		
		ST SET TEXT:C1115(*;$Obj_form.fieldFilter;$t;ST Start text:K78:15;ST End text:K78:16)
		
		If (Bool:C1537($Obj_in.showIfNotEmpty))
			
			OBJECT SET VISIBLE:C603(*;$Obj_form.fieldFilter;Length:C16($t)>0)
			
		End if 
		
		  //=========================================================
	: ($Obj_in.action="addTable")
		
		$Obj_table:=$Obj_context.currentTable
		
		$c:=$Obj_context.catalog().query("tableNumber = :1";$Obj_table.tableNumber)
		
		$Obj_out:=New object:C1471(\
			"name";$c[0].name;\
			"label";formatString ("label";$c[0].name);\
			"shortLabel";formatString ("label";$c[0].name);\
			"primaryKey";String:C10($c[0].primaryKey);\
			"embedded";True:C214)
		
		  // Update main menu
		main_Handler (New object:C1471(\
			"action";"push";\
			"tableNumber";String:C10($Obj_table.tableNumber)))
		
		  // Highlight the table name
		$l:=Find in array:C230((ui.pointer($Obj_form.tableList))->;True:C214)
		LISTBOX SET ROW FONT STYLE:C1268(*;$Obj_form.tableList;$l;Bold:K14:2)
		
		ob_createPath (Form:C1466;"dataModel").dataModel[String:C10($Obj_table.tableNumber)]:=$Obj_out
		
		  //=========================================================
	: ($Obj_in.action="geometry")
		
		Case of 
				
				  //______________________________________________________
			: ($Obj_in.target="STRUCTURE")  // Vertical resizing
				
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
				
				ASSERT:C1129(False:C215;"Unknown target: \""+$Obj_in.target+"\"")
				
				  //______________________________________________________
		End case 
		
		  //=========================================================
	: ($Obj_in.action="onLosingFocus")
		
		OBJECT SET VISIBLE:C603(*;$Obj_form.search;False:C215)
		OBJECT SET VISIBLE:C603(*;$Obj_form.action;False:C215)
		
		  //=========================================================
	: ($Obj_in.action="appendField")
		
		Case of 
				
				  //…………………………………………………………………………………………………
			: ($Obj_in.field.type=-1)  // N -> 1 relation
				
				$Obj_dataModel:=Form:C1466.dataModel[String:C10($Obj_in.table.tableNumber)][$Obj_in.field.name]
				
				If ($Obj_dataModel#Null:C1517)
					
					$Lon_published:=1  // All related fields are published
					
					  //#MARK_TO_OPTIMIZE
					$o:=structure (New object:C1471(\
						"action";"relatedCatalog";\
						"table";$Obj_in.table.name;\
						"relatedEntity";$Obj_in.field.name))
					
					If ($o.success)
						
						For each ($Obj_field;$o.fields)
							
							If ($Obj_dataModel[String:C10($Obj_field.fieldNumber)]=Null:C1517)
								
								$Lon_published:=$Lon_published+1  // Mixed
								
							End if 
						End for each 
					End if 
				End if 
				
				APPEND TO ARRAY:C911(($Obj_in.published)->;$Lon_published)
				
				If (Bool:C1537(featuresFlags.withNewFieldProperties))
					
					APPEND TO ARRAY:C911(($Obj_in.icons)->;UI.fieldIcons[8858])
					
				Else 
					
					APPEND TO ARRAY:C911(($Obj_in.icons)->;ui.typeIcons[8858])
					
				End if 
				
				APPEND TO ARRAY:C911(($Obj_in.fields)->;$Obj_in.field.name)
				
				LISTBOX SET ROW FONT STYLE:C1268(*;$Obj_form.fieldList;Size of array:C274(($Obj_in.fields)->);Underline:K14:4)
				
				  //…………………………………………………………………………………………………
			Else 
				
				If ($Obj_in.field.type<=ui.typeIcons.length)
					
					$Lon_published:=Num:C11(Form:C1466.dataModel[String:C10($Obj_in.table.tableNumber)][String:C10($Obj_in.field.id)]#Null:C1517)
					
					APPEND TO ARRAY:C911(($Obj_in.published)->;$Lon_published)
					
					If (Bool:C1537(featuresFlags.withNewFieldProperties))
						
						APPEND TO ARRAY:C911(($Obj_in.icons)->;UI.fieldIcons[$Obj_in.field.fieldType])
						
					Else 
						
						APPEND TO ARRAY:C911(($Obj_in.icons)->;ui.typeIcons[$Obj_in.field.type])
						
					End if 
					
					APPEND TO ARRAY:C911(($Obj_in.fields)->;$Obj_in.field.name)
					
				End if 
				
				LISTBOX SET ROW FONT STYLE:C1268(*;$Obj_form.fieldList;Size of array:C274(($Obj_in.fields)->);Plain:K14:1)
				
				  //…………………………………………………………………………………………………
		End case 
		
		  //=========================================================
	: ($Obj_in.action="update")
		
		  // Update ribbon
		CALL FORM:C1391($Obj_form.window;$Obj_form.callback;"updateRibbon")
		
		  // Update structure dependencies, if any
		CALL FORM:C1391($Obj_form.window;$Obj_form.callback;"tableList";$Obj_in.project)
		CALL FORM:C1391($Obj_form.window;$Obj_form.callback;"fieldList";$Obj_in.project)
		CALL FORM:C1391($Obj_form.window;$Obj_form.callback;"tableProperties";$Obj_in.project)
		CALL FORM:C1391($Obj_form.window;$Obj_form.callback;"mainMenu")
		
		  //=========================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_in.action+"\"")
		
		  //=========================================================
End case 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End