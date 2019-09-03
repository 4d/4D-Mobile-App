//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : FIELDS_Handler
  // ID[BF3981E8AF72452DB0171AEDA52AF625]
  // Created 26-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($i;$l;$Lon_fieldNumber;$Lon_formEvent)
C_PICTURE:C286($p)
C_POINTER:C301($r)
C_TEXT:C284($t)
C_OBJECT:C1216($o;$Obj_context;$Obj_dataModel;$Obj_form;$Obj_in;$Obj_out)
C_OBJECT:C1216($oo)
C_COLLECTION:C1488($Col_buffer)

If (False:C215)
	C_OBJECT:C1216(FIELDS_Handler ;$0)
	C_OBJECT:C1216(FIELDS_Handler ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations

  // NO PARAMETERS REQUIRED

  // Optional parameters
If (Count parameters:C259>=1)
	
	$Obj_in:=$1
	
End if 

$Obj_form:=New object:C1471(\
"window";Current form window:C827;\
"$";editor_INIT ;\
"form";ui.form("editor_CALLBACK").get();\
"fieldList";ui.listbox("01_fields");\
"ids";"IDs";\
"names";"fields";\
"icons";"icons";\
"labels";"labels";\
"shortLabels";"shortLabels";\
"formats";"formats";\
"titles";"titles";\
"formatLabel";ui.static("format.label");\
"iconGrid";"iconGrid";\
"tabSelector";ui.widget("tab.selector");\
"selectorFields";ui.button("tab.fields");\
"selectorRelations";ui.button("tab.relations");\
"selectors";ui.static("tab.@");\
"empty";ui.static("empty")\
)

$Obj_context:=$Obj_form.$

If (OB Is empty:C1297($Obj_context))\
 | (Shift down:C543 & (Structure file:C489=Structure file:C489(*)))  // First load
	
	  // Constraints definition
	ob_createPath ($Obj_context;"constraints.rules";Is collection:K8:32)
	
	  // Display fields by default
	$Obj_context.selector:=0
	
	  // Define form member methods
	$Obj_context.refresh:=Formula:C1597(SET TIMER:C645(-1))
	$Obj_context.update:=Formula:C1597(FIELDS_Handler (New object:C1471(\
		"action";"update")))
	$Obj_context.setTab:=Formula:C1597(FIELDS_Handler (New object:C1471(\
		"action";"setTab")))
	$Obj_context.setHelpTip:=Formula:C1597(FIELDS_TIPS (New object:C1471(\
		"target";$1;\
		"form";$2)))
	$Obj_context.showPicker:=Formula:C1597(CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"pickerShow";$1))
	$Obj_context.field:=Formula:C1597(FIELDS_Handler (New object:C1471(\
		"action";"field";\
		"row";$1)))
	
End if 

$Obj_context.tableNumber:=Num:C11(Form:C1466.$dialog.TABLES.currentTableNumber)

  // ----------------------------------------------------
Case of 
		
		  //=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$Lon_formEvent:=panel_Form_common (On Load:K2:1;On Timer:K2:25)
		
		$Obj_dataModel:=Form:C1466.dataModel
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				  // This trick remove the horizontal gap
				$Obj_form.fieldList.setScrollbar(0;2)
				
				  // Place the tabs according to the localization
				$l:=$Obj_form.selectorFields.bestSize(Align left:K42:2).coordinates.right+10
				$Obj_form.selectorRelations.bestSize(Align left:K42:2).setCoordinates($l;Null:C1517;Null:C1517;Null:C1517)
				
				$Obj_context.setTab()
				
				  // Preload the icons
				CALL FORM:C1391($Obj_form.window;"editor_CALLBACK";"fieldIcons")
				
				  //______________________________________________________
			: ($Lon_formEvent=On Timer:K2:25)
				
				$Obj_context.update()
				
				  //______________________________________________________
		End case 
		
		  //=========================================================
	: ($Obj_in.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215;"Missing parameter \"action\"")
		
		  //=========================================================
	: ($Obj_in.action="init")  // Return the form objects definition
		
		$Obj_out:=$Obj_form
		
		  //=========================================================
	: ($Obj_in.action="field")  // Get field definition
		
		ASSERT:C1129($Obj_in.row#Null:C1517)
		
		  //%W-533.3
		$Lon_fieldNumber:=Num:C11((ui.pointer($Obj_form.ids))->{$Obj_in.row})
		
		$Col_buffer:=Split string:C1554((ui.pointer($Obj_form.names))->{$Obj_in.row};".")
		
		If ($Col_buffer.length>1)  // RelatedDataclass
			
			$Obj_out:=Form:C1466.dataModel[String:C10($Obj_context.tableNumber)][$Col_buffer[0]][String:C10((ui.pointer($Obj_form.ids))->{$Obj_in.row})]
			
		Else 
			
			If ($Lon_fieldNumber#0)
				
				$Obj_out:=Form:C1466.dataModel[String:C10($Obj_context.tableNumber)][String:C10($Lon_fieldNumber)]
				
			Else 
				
				  // Take the name
				$Obj_out:=Form:C1466.dataModel[String:C10($Obj_context.tableNumber)][String:C10($Col_buffer[0])]
				
			End if 
		End if 
		  //%W+533.3
		
		  //=========================================================
	: ($Obj_in.action="update")  // Display published tables according to data model
		
		If (This:C1470=Null:C1517)
			
			$Obj_context.update()
			
		Else 
			
			$o:=fields_LIST (String:C10($Obj_context.tableNumber))
			
			If ($o.success)
				
				$Obj_form.empty.setTitle(Choose:C955($Obj_context.selector;"noFieldPublishedForThisTable";"noPublishedRelationForThisTable"))
				
				COLLECTION TO ARRAY:C1562($o.ids;(ui.pointer($Obj_form.ids))->)
				COLLECTION TO ARRAY:C1562($o.paths;(ui.pointer($Obj_form.names))->)
				COLLECTION TO ARRAY:C1562($o.labels;(ui.pointer($Obj_form.labels))->)
				COLLECTION TO ARRAY:C1562($o.shortLabels;(ui.pointer($Obj_form.shortLabels))->)
				COLLECTION TO ARRAY:C1562($o.icons;(ui.pointer($Obj_form.icons))->)
				COLLECTION TO ARRAY:C1562($o.formats;(ui.pointer($Obj_form.formats))->)
				COLLECTION TO ARRAY:C1562($o.formats;(ui.pointer($Obj_form.titles))->)
				
				For ($i;0;$o.ids.length-1;1)
					
					LISTBOX SET ROW COLOR:C1270(*;$Obj_form.names;$i+1;$o.nameColors[$i];lk font color:K53:24)
					LISTBOX SET ROW COLOR:C1270(*;$Obj_form.formats;$i+1;$o.formatColors[$i];lk font color:K53:24)
					
				End for 
				
				LISTBOX SORT COLUMNS:C916(*;$Obj_form.fieldList.name;2;>)
				
				$Obj_form.fieldList.setVisible(Num:C11($o.count)>0)
				
			Else 
				
				$Obj_form.empty.setTitle("selectATableToDisplayItsFields")
				
				$Obj_form.fieldList.clear()
				$Obj_form.fieldList.hide()
				
			End if 
			
			editor_Locked ($Obj_form.labels;$Obj_form.shortLabels;$Obj_form.formats;$Obj_form.titles)
			
			$Obj_context.current:=0
			$Obj_form.fieldList.deselect()
			
			editor_ui_LISTBOX ($Obj_form.fieldList.name)
			
		End if 
		
		  //=========================================================
	: ($Obj_in.action="setTab")  // UI for tabs
		
		OBJECT SET FONT STYLE:C166(*;$Obj_form.selectors.name;Plain:K14:1)
		
		$t:="selector"+Choose:C955(Num:C11($Obj_context.selector);"Fields";"Relations")
		
		OBJECT SET FONT STYLE:C166(*;$Obj_form[$t].name;Bold:K14:2)
		$o:=$Obj_form[$t].getCoordinates().coordinates
		$oo:=$Obj_form.tabSelector.getCoordinates()
		$oo.setCoordinates($o.left;$oo.coordinates.top;$o.right;$oo.coordinates.bottom)
		
		If (Num:C11($Obj_context.selector)=1)  // relations
			
			$Obj_form.formatLabel.setTitle("titles")
			OBJECT SET VISIBLE:C603(*;$Obj_form.formats;False:C215)
			OBJECT SET VISIBLE:C603(*;$Obj_form.titles;True:C214)
			
		Else 
			
			$Obj_form.formatLabel.setTitle("formatters")
			OBJECT SET VISIBLE:C603(*;$Obj_form.formats;True:C214)
			OBJECT SET VISIBLE:C603(*;$Obj_form.titles;False:C215)
			
		End if 
		
		  //=========================================================
	: ($Obj_in.action="fieldIcons")  // Call back from widget
		
		If ($Obj_in.item>0)\
			 & ($Obj_in.item<=$Obj_in.pathnames.length)
			
			  // Update data model
			FIELDS_Handler (New object:C1471("action";"field";"row";$Obj_in.row)).icon:=$Obj_in.pathnames[$Obj_in.item-1]
			
			  // Update UI
			$r:=ui.pointer($Obj_form.icons)
			
			  //%W-533.3
			If ($Obj_in.pictures[$Obj_in.item-1]#Null:C1517)
				
				$p:=$Obj_in.pictures[$Obj_in.item-1]
				CREATE THUMBNAIL:C679($p;$p;24;24;Scaled to fit:K6:2)
				
				$r->{$Obj_in.row}:=$p
				
			Else 
				
				CLEAR VARIABLE:C89($r->{$Obj_in.row})
				
			End if 
			  //%W+533.3
			
			project.save()
			
		End if 
		
		  //=========================================================
	: ($Obj_in.action="icons")  // Preload the icons
		
		$Obj_in.target:="fieldIcons"
		(ui.pointer($Obj_form.iconGrid))->:=editor_LoadIcons ($Obj_in)
		
		  //=========================================================
	: ($Obj_in.action="select")  // Set the selected field
		
		$Obj_context.currentFieldNumber:=Num:C11($Obj_in.fieldNumber)
		
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