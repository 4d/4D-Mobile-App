//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : FIELDS_class
  // ID[169D04BC94A44B409EE3153800F18E34]
  // Created 4-9-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($i)
C_TEXT:C284($t)
C_OBJECT:C1216($ƒ;$o;$Obj_form;$Obj_result;$Obj_widget;$oo)
C_OBJECT:C1216($str)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(FIELDS_class ;$0)
	C_TEXT:C284(FIELDS_class ;$1)
	C_OBJECT:C1216(FIELDS_class ;$2)
End if 

  // ----------------------------------------------------
$Obj_form:=New object:C1471(\
"_is";"FIELDS_class";\
"window";Current form window:C827;\
"$";editor_INIT ;\
"form";ui.form("editor_CALLBACK").get();\
"fieldList";ui.listbox("01_fields");\
"ids";ui.widget("IDs");\
"names";ui.widget("fields");\
"icons";ui.widget("icons");\
"labels";ui.widget("labels");\
"shortLabels";ui.widget("shortLabels");\
"formats";ui.widget("formats");\
"titles";ui.widget("titles");\
"formatLabel";ui.static("format.label");\
"picker";ui.widget("iconGrid");\
"tabSelector";ui.widget("tab.selector");\
"selectorFields";ui.button("tab.fields");\
"selectorRelations";ui.button("tab.relations");\
"selectors";ui.static("tab.@");\
"empty";ui.static("empty");\
"resources";ui.button("resources")\
)

$ƒ:=$Obj_form.$

If (This:C1470=Null:C1517)  // Constructor
	
	If (OB Is empty:C1297($ƒ))\
		 | (Shift down:C543 & (Structure file:C489=Structure file:C489(*)))  // First load
		
		  // Constraints definition
		ob_createPath ($ƒ;"constraints.rules";Is collection:K8:32)
		
		  // Display fields by default
		$ƒ.selector:=0
		
		  // Define form member methods
		$ƒ.refresh:=Formula:C1597(SET TIMER:C645(-1))
		
		$ƒ.update:=Formula:C1597(FIELDS_class ("update"))
		
		$ƒ.setTab:=Formula:C1597(FIELDS_class ("setTab"))
		
		$ƒ.setHelpTip:=Formula:C1597(FIELDS_class ("tips"))
		
		$ƒ.showPicker:=Formula:C1597(CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"pickerShow";$1))
		
		$ƒ.field:=Formula:C1597(FIELDS_class ("field";New object:C1471(\
			"row";$1)))
		
	End if 
	
Else 
	
	$ƒ:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($1="tips")
			
			$Obj_widget:=$Obj_form.fieldList.update()
			
			$str:=str ()  // init class
			
			  // ----------------------------------------------------
			If ($Obj_widget.row#0)
				
				$Obj_widget.getDefinition()
				
				  //ASSERT(Not(Shift down))
				
				Case of 
						
						  //………………………………………………………………………………
					: (Length:C16(Get edited text:C655)#0)  // Edition mode
						
						Case of 
								
								  //……………………………………………………………………………………………
							: ($Obj_widget.column=$Obj_widget.columns[$Obj_form.titles.name].number)
								
								$t:=$str.setText("youCanInsertFieldNamesSurroundedByTheCharacter").localized()
								
								  //……………………………………………………………………………………………
							Else 
								
								  //
								
								  //……………………………………………………………………………………………
						End case 
						
						  //………………………………………………………………………………
					: ($Obj_widget.row=0)  // Nothing
						
						  //………………………………………………………………………………
					: ($Obj_widget.column=$Obj_widget.columns[$Obj_form.icons.name].number)
						
						$t:=$str.setText("clickToSet").localized()
						
						  //………………………………………………………………………………
					: ($Obj_widget.column=$Obj_widget.columns[$Obj_form.shortLabels.name].number)
						
						$t:=$str.setText("doubleClickToEdit").localized()+"\r - "+$str.setText("shouldBe10CharOrLess").localized()
						
						  //………………………………………………………………………………
					: ($Obj_widget.column=$Obj_widget.columns[$Obj_form.labels.name].number)
						
						$t:=$str.setText("doubleClickToEdit").localized()+"\r - "+$str.setText("shouldBe25CharOrLess").localized()
						
						  //………………………………………………………………………………
					: ($Obj_widget.column=$Obj_widget.columns[$Obj_form.titles.name].number)
						
						$t:=$str.setText("doubleClickToEdit").localized()
						
						  //………………………………………………………………………………
				End case 
				
			Else 
				
				  // NO ITEM HOVERED
				
			End if 
			
			OBJECT SET HELP TIP:C1181(*;$Obj_form.fieldList.name;$t)
			
			  //______________________________________________________
		: ($1="field")
			
			ASSERT:C1129($2.row#Null:C1517)
			
			  //%W-533.3
			$c:=Split string:C1554((ui.pointer($Obj_form.names.name))->{$2.row};".")
			
			If ($c.length>1)  // RelatedDataclass
				
				$Obj_form:=Form:C1466.dataModel[String:C10($ƒ.tableNumber)][$c[0]][String:C10(($Obj_form.ids.pointer())->{$2.row})]
				
			Else 
				
				$t:=($Obj_form.ids.pointer())->{$2.row}  // Field number
				
				If (Num:C11($t)#0)
					
					$Obj_form:=Form:C1466.dataModel[String:C10($ƒ.tableNumber)][$t]
					
				Else 
					
					  // Take the name
					$Obj_form:=Form:C1466.dataModel[String:C10($ƒ.tableNumber)][String:C10($c[0])]
					
				End if 
			End if 
			  //%W+533.3
			
			  //______________________________________________________
		: ($1="update")
			
			$Obj_result:=fields_LIST (String:C10($ƒ.tableNumber))
			
			If ($Obj_result.success)
				
				$Obj_form.empty.setTitle(Choose:C955($ƒ.selector;"noFieldPublishedForThisTable";"noPublishedRelationForThisTable"))
				
				COLLECTION TO ARRAY:C1562($Obj_result.ids;($Obj_form.ids.pointer())->)
				COLLECTION TO ARRAY:C1562($Obj_result.paths;($Obj_form.names.pointer())->)
				COLLECTION TO ARRAY:C1562($Obj_result.labels;($Obj_form.labels.pointer())->)
				COLLECTION TO ARRAY:C1562($Obj_result.shortLabels;($Obj_form.shortLabels.pointer())->)
				COLLECTION TO ARRAY:C1562($Obj_result.icons;($Obj_form.icons.pointer())->)
				COLLECTION TO ARRAY:C1562($Obj_result.formats;($Obj_form.formats.pointer())->)
				COLLECTION TO ARRAY:C1562($Obj_result.formats;($Obj_form.titles.pointer())->)
				
				For ($i;0;$Obj_result.count-1;1)
					
					LISTBOX SET ROW COLOR:C1270(*;$Obj_form.names.name;$i+1;$Obj_result.nameColors[$i];lk font color:K53:24)
					LISTBOX SET ROW COLOR:C1270(*;$Obj_form.formats.name;$i+1;$Obj_result.formatColors[$i];lk font color:K53:24)
					
				End for 
				
				LISTBOX SORT COLUMNS:C916(*;$Obj_form.fieldList.name;2;>)
				
				$Obj_form.fieldList.setVisible(Num:C11($Obj_result.count)>0)
				
			Else 
				
				$Obj_form.empty.setTitle("selectATableToDisplayItsFields")
				
				$Obj_form.fieldList.clear()
				$Obj_form.fieldList.hide()
				
			End if 
			
			editor_Locked ($Obj_form.labels.name;$Obj_form.shortLabels.name;$Obj_form.formats.name;$Obj_form.titles.name)
			
			$ƒ.current:=0
			$Obj_form.fieldList.deselect()
			
			editor_ui_LISTBOX ($Obj_form.fieldList.name)
			
			  //______________________________________________________
		: ($1="setTab")
			
			OBJECT SET FONT STYLE:C166(*;$Obj_form.selectors.name;Plain:K14:1)
			
			$t:="selector"+Choose:C955(Num:C11($ƒ.selector);"Fields";"Relations")
			
			OBJECT SET FONT STYLE:C166(*;$Obj_form[$t].name;Bold:K14:2)
			$o:=$Obj_form[$t].getCoordinates().coordinates
			$oo:=$Obj_form.tabSelector.getCoordinates()
			$oo.setCoordinates($o.left;$oo.coordinates.top;$o.right;$oo.coordinates.bottom)
			
			If (Num:C11($ƒ.selector)=1)  // Relations
				
				$Obj_form.formatLabel.setTitle("titles")
				$Obj_form.formats.hide()
				$Obj_form.titles.show()
				$Obj_form.resources.hide()
				
			Else 
				
				$Obj_form.formatLabel.setTitle("formatters")
				$Obj_form.formats.show()
				$Obj_form.titles.hide()
				$Obj_form.resources.show()
				
			End if 
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
	
	  // End if
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_form

  // ----------------------------------------------------
  // End