//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : views_Handler
// ID[2A03E5F862194815A6AA36A409731C5C]
// Created 26-10-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $0 : Object
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(VIEWS_Handler; $0)
	C_OBJECT:C1216(VIEWS_Handler; $1)
End if 

var $formName; $t; $tableID; $typeForm : Text
var $codeEvent; $i; $l; $offset : Integer
var $context; $datamodel; $form; $IN; $o; $o1; $OUT : Object
var $c : Collection

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

// Optional parameters
If (Count parameters:C259>=1)
	
	$IN:=$1
	
End if 

$form:=New object:C1471(\
"$"; editor_INIT; \
"form"; UI.form("editor_CALLBACK").get(); \
"tableWidget"; UI.picture("tables"); \
"tableNext"; UI.static("next@"); \
"tablePrevious"; UI.static("previous@"); \
"tableButtonNext"; UI.button("next"); \
"tableButtonPrevious"; UI.button("previous"); \
"tablist"; UI.button("tab.list"); \
"tabdetail"; UI.button("tab.detail"); \
"tabSelector"; UI.widget("tab.selector"); \
"noPublishedTable"; UI.widget("noPublishedTable"); \
"fieldList"; UI.listbox("01_fields"); \
"fieldGroup"; UI.static("01_fields@"); \
"preview"; UI.picture("preview"); \
"previewGroup"; UI.static("preview@"); \
"fields"; UI.widget("fields"); \
"ids"; UI.widget("field_ids"); \
"icons"; UI.widget("icons"); \
"names"; UI.widget("names"); \
"selectorList"; UI.button("tab.list"); \
"selectorDetail"; UI.button("tab.detail"); \
"selectors"; UI.static("tab.@"); \
"drag"; Formula:C1597(tmpl_On_drag_over); \
"drop"; Formula:C1597(tmpl_ON_DROP); \
"cancel"; Formula:C1597(tmpl_REMOVE); \
"tips"; Formula:C1597(tmpl_TIPS); \
"scrollBar"; UI.thermometer("preview.scrollBar"))

$context:=$form.$

If (OB Is empty:C1297($context))  // First load
	
	// § DEFINE UI CONSTRAINTS §
	$c:=New collection:C1472
	
	$c.push(New object:C1471(\
		"formula"; Formula:C1597(VIEWS_Handler(New object:C1471(\
		"action"; "geometry")))))
	
	If (FEATURE.with("newViewUI"))
		
		$c.push(New object:C1471(\
			"object"; New collection:C1472("preview"; "preview.label"; "preview.back"; "Preview.border"); \
			"reference"; "viewport.preview"; \
			"type"; "horizontal alignment"; \
			"value"; "center"))
		
		$c.push(New object:C1471(\
			"object"; "preview.scrollBar"; \
			"reference"; "preview"; \
			"type"; "margin-left"; \
			"value"; 20))
		
	End if 
	
	$context:=ob.set($context).createPath("constraints.rules"; Is collection:K8:32; $c).contents
	
	// § DEFINE FORM MEMBER METHODS §
	
	// Selected table ID as string, empty if none
	$context.tableNum:=Formula:C1597(String:C10(This:C1470.tableNumber))
	
	// The form type according to the selected tab
	$context.typeForm:=Formula:C1597(Choose:C955(Num:C11(This:C1470.selector)=2; "detail"; "list"))
	
	// Update selected tab
	$context.setTab:=Formula:C1597(VIEWS_Handler(New object:C1471(\
		"action"; "setTab")))
	
	// Update geometry
	$context.setGeometry:=Formula:C1597(VIEWS_Handler(New object:C1471(\
		"action"; "geometry")))
	
End if 

// ----------------------------------------------------
Case of 
		
		//=========================================================
	: ($IN=Null:C1517)  // Form method
		
		$codeEvent:=_o_panel_Form_common(On Load:K2:1; On Timer:K2:25)
		
		$datamodel:=Form:C1466.dataModel
		
		Case of 
				
				//______________________________________________________
			: ($codeEvent=On Load:K2:1)
				
				$context.scroll:=450
				
				// This trick remove the horizontal gap
				$form.fieldList.setScrollbar(0; 2)
				
				// Place the tabs according to the localization
				$offset:=$form.tablist.bestSize(Align left:K42:2).coordinates.right+10
				$form.tabdetail.bestSize(Align left:K42:2).setCoordinates($offset)
				
				$context.setTab()
				
				// Create, if any, & update the list & detail model [
				$o:=ob_createPath(Form:C1466; "list")
				$o:=ob_createPath(Form:C1466; "detail")
				
				If ($datamodel#Null:C1517)
					
					For each ($tableID; $datamodel)
						
						Form:C1466.list:=ob_createPath(Form:C1466.list; $tableID)
						Form:C1466.detail:=ob_createPath(Form:C1466.detail; $tableID)
						
					End for each 
				End if 
				//]
				
				If (($datamodel=Null:C1517) | OB Is empty:C1297($datamodel))
					
					// No published table
					$form.noPublishedTable.show()
					
					$form.fieldGroup.hide()
					$form.previewGroup.hide()
					
					OB REMOVE:C1226($context; "tableID")
					
				Else 
					
					$form.noPublishedTable.hide()
					
					// Select the first table if any
					ARRAY TEXT:C222($_tables; 0x0000)
					OB GET PROPERTY NAMES:C1232($datamodel; $_tables)
					
					If (Length:C16($context.tableNum())=0)\
						 | (Find in array:C230($_tables; $context.tableNum())=-1)
						
						If (Size of array:C274($_tables)>0)
							
							// Select
							$context.tableNumber:=$_tables{1}
							
						Else 
							
							// No more published table
							OB REMOVE:C1226($context; "tableID")
							
						End if 
					End if 
				End if 
				
				// List/detail selector
				$context.selector:=Num:C11($context.selector)+Num:C11(Num:C11($context.selector)=0)
				($form.tablist.pointer())->:=Num:C11($context.selector=1)
				($form.tabdetail.pointer())->:=Num:C11($context.selector=2)
				
				// Draw the table list
				($form.tableWidget.pointer())->:=tables_Widget($datamodel; New object:C1471(\
					"tableNumber"; $context.tableNum()))
				
				PROJECT.updateFormDefinitions()
				
				// Update geometry
				$context.setGeometry()
				
				If (FEATURE.with("withWidgetActions"))
					
					//$context.actions:=_w_actions ("getList";$context).actions
					
				End if 
				
				If (FEATURE.with("newViewUI"))
					
					OB REMOVE:C1226($context; "scrollPosition")
					$context.scroll:=0
					
				End if 
				
				//______________________________________________________
			: ($codeEvent=On Timer:K2:25)
				
				SET TIMER:C645(0)
				$typeForm:=$context.typeForm()
				
				If ($datamodel=Null:C1517) | OB Is empty:C1297($datamodel)
					
					// No published table
					$form.noPublishedTable.show()
					
					$form.fieldGroup.hide()
					$form.previewGroup.hide()
					
				Else 
					
					$form.noPublishedTable.hide()
					
				End if 
				
				// Draw the table list
				($form.tableWidget.pointer())->:=tables_Widget($datamodel; New object:C1471(\
					"tableNumber"; $context.tableNum()))
				
				Case of 
						
						//………………………………………………………………………………………………………………………………………
					: (Bool:C1537($context.draw))
						
						$form.fieldGroup.setVisible(Length:C16($context.tableNum())>0)
						$form.previewGroup.setVisible(Length:C16($context.tableNum())>0)
						
						// Uppdate preview
						VIEWS_DRAW_FORM($form)
						
						If (FEATURE.with("withWidgetActions"))
							
							//(ui.pointer($form.actionDrop))->:=_w_actions ("preview";$context).pict
							
						End if 
						
						OB REMOVE:C1226($context; "draw")
						
						//………………………………………………………………………………………………………………………………………
					Else 
						
						If (Length:C16($context.tableNum())>0)\
							 & ($datamodel[$context.tableNum()]#Null:C1517)
							
							$formName:=String:C10(Form:C1466[$typeForm][$context.tableNum()].form)
							$formName:=$formName*Num:C11($formName#"null")  // Reject null value
							
							If (Length:C16($formName)>0)
								
								$o:=tmpl_form($formName; $typeForm)
								
							End if 
							
							If (Bool:C1537($o.exists))
								
								// Update lists
								$context.update:=True:C214
								
								// Redraw
								$context.draw:=True:C214
								$form.form.refresh()
								
							Else 
								
								If (Bool:C1537(Form:C1466.$dialog.picker))
									
									If (Length:C16($formName)>0)
										
										// Hide the template picker
										$form.form.call("pickerHide")
										
										// Redraw
										$context.draw:=True:C214
										$form.form.refresh()
										
									End if 
									
								Else 
									
									If (Not:C34(($datamodel=Null:C1517) | OB Is empty:C1297($datamodel)))
										
										// Update lists
										$context.update:=True:C214
										
										// Display the template picker
										$form.fieldGroup.hide()
										$form.previewGroup.hide()
										
										views_LAYOUT_PICKER($typeForm)
										
									End if 
								End if 
							End if 
							
						Else 
							
							// NOTHING MORE TO DO
							
						End if 
						
						//………………………………………………………………………………………………………………………………………
				End case 
				
				//______________________________________________________
		End case 
		
		If (Bool:C1537($context.update))
			
			OB REMOVE:C1226($context; "update")
			
			If (DATABASE.isMatrix)  //& False
				
				$o:=cs:C1710.VIEWS.new().fieldList($context.tableNum())
				
			Else 
				
				$o:=views_fieldList($context.tableNum())
				
			End if 
			
			If ($o.success)
				
				COLLECTION TO ARRAY:C1562($o.fields; ($form.fields.pointer())->)
				COLLECTION TO ARRAY:C1562($o.fields.extract("id"); ($form.ids.pointer())->)
				COLLECTION TO ARRAY:C1562($o.fields.extract("path"); ($form.names.pointer())->)
				
				ASSERT:C1129($o.fields.length=Size of array:C274(($form.ids.pointer())->))
				ASSERT:C1129($o.fields.length=Size of array:C274(($form.names.pointer())->))
				
				$c:=New collection:C1472
				
				For each ($i; $o.fields.extract("fieldType"))
					
					$c.push(UI.fieldIcons[$i])
					
				End for each 
				
				COLLECTION TO ARRAY:C1562($c; ($form.icons.pointer())->)
				
				var $structure : cs:C1710.structure
				$structure:=cs:C1710.structure.new()
				
				// Highlight errors
				For ($i; 1; Size of array:C274(($form.fields.pointer())->); 1)
					
					LISTBOX SET ROW COLOR:C1270(*; $form.fieldList.name; $i; lk inherited:K53:26; lk font color:K53:24)
					
					$o:=($form.fields.pointer())->{$i}
					
					If ($o.fieldType=8858)\
						 | ($o.fieldType=8859)  // relation
						
						If (Not:C34(Bool:C1537($o.$added)))
							
							If ($o.fieldType=8859)
								
								If ($datamodel[String:C10($structure.tableNumber())]=Null:C1517)
									
									LISTBOX SET ROW COLOR:C1270(*; $form.fieldList.name; $i; UI.errorColor; lk font color:K53:24)
									
								End if 
								
							Else 
								
								If ($datamodel[String:C10($o.relatedTableNumber)]=Null:C1517)
									
									LISTBOX SET ROW COLOR:C1270(*; $form.fieldList.name; $i; UI.errorColor; lk font color:K53:24)
									
								End if 
								
							End if 
							
						End if 
					End if 
				End for 
				
				$form.fieldGroup.show()
				$form.previewGroup.show()
				$form.scrollBar.hide()
				
				$form.fieldList.focus()
				
			Else 
				
				$form.fields.clear()
				$form.ids.clear()
				$form.names.clear()
				$form.icons.clear()
				
			End if 
		End if 
		
		$form.scrollBar.setVisible(($context.typeForm()="detail") & ($form.preview.visible()) & (Num:C11($context.previewHeight)>460))
		
		If (Bool:C1537($context.picker))
			
			// Display the template picker
			views_LAYOUT_PICKER($typeForm)
			
		End if 
		
		OB REMOVE:C1226($context; "picker")
		
		//=========================================================
	: ($IN.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215; "Missing parameter \"action\"")
		
		//=========================================================
	: ($IN.action="init")  // Return the form objects definition
		
		$OUT:=$form
		
		//=========================================================
	: ($IN.action="scroll-table")
		
		$o:=$form.tableWidget.update()
		
		If (String:C10($IN.direction)="next")
			
			$l:=$o.scroll.horizontal+$o.coordinates.width
			
		Else 
			
			$l:=$o.scroll.horizontal-$o.coordinates.width
			$l:=Choose:C955($l<0; 0; $o.scroll.horizontal)
			
		End if 
		
		$form.tableWidget.setScrollPosition(Null:C1517; $l)
		
		$context.setGeometry()
		
		//=========================================================
	: ($IN.action="geometry")
		
		If (Not:C34(Is nil pointer:C315($form.tableWidget.pointer())))
			
			$o:=$form.tableWidget.update()
			
			If ($o.dimensions.width>$o.coordinates.width)
				
				$form.tablePrevious.setVisible($o.scroll.horizontal>0)
				$form.tableNext.setVisible(($o.scroll.horizontal+$o.coordinates.width)<$o.dimensions.width)
				
			Else 
				
				$form.tablePrevious.hide()
				$form.tableNext.hide()
				
			End if 
		End if 
		
		//=========================================================
	: ($IN.action="forms")  // Call back from widget
		
		// quand la class VIEWS sera complète il n'y aura plus besoin de $form
		// et cet appel pourra être directement fait depuis project_MESSAGES ?
		cs:C1710.VIEWS.new().setTemplate($IN; $form)
		
		//=========================================================
	: ($IN.action="show")
		
		// Restore preview and field list…
		$form.fieldGroup.show()
		$form.previewGroup.show()
		$form.scrollBar.hide()
		
		// …and redraw
		$context.draw:=True:C214
		$form.form.refresh()
		
		//=========================================================
	: ($IN.action="pickerHide")  // Call back from widget
		
		If (Form:C1466[$IN.selector][$context.tableNum()].form=Null:C1517)
			
			$form.fieldGroup.hide()
			$form.previewGroup.hide()
			
		Else 
			
			$form.fieldGroup.show()
			$form.previewGroup.show()
			$form.scrollBar.hide()
			
		End if 
		
		//=========================================================
	: ($IN.action="setTab")  // UI for tabs
		
		OBJECT SET FONT STYLE:C166(*; $form.selectors.name; Plain:K14:1)
		
		$t:="tab."+$context.typeForm()
		OBJECT SET FONT STYLE:C166(*; $t; Bold:K14:2)
		
		$t:=Replace string:C233($t; "."; "")
		$o:=$form[$t].getCoordinates().coordinates
		$o1:=$form.tabSelector.getCoordinates()
		$o1.setCoordinates($o.left; $o1.coordinates.top; $o.right; $o1.coordinates.bottom)
		
		//=========================================================
	: ($IN.action="selectTab")
		
		$context.selector:=1+Num:C11($IN.tab="detail")
		
		$context.setTab()
		
		If ($IN.table#Null:C1517)
			
			If (Length:C16($context.tableNum())>0)
				
				// Restore current selected background
				SVG SET ATTRIBUTE:C1055(*; $form.tableWidget.name; $context.tableNumber; \
					"fill"; UI.unselectedFillColor)
				
			End if 
			
			$context.tableNumber:=$IN.table
			
			// Select the item
			SVG SET ATTRIBUTE:C1055(*; $form.tableWidget.name; $context.tableNumber; \
				"fill"; UI.selectedColorFill)
			
			$context.update:=True:C214
			$context.picker:=(String:C10(Form:C1466[$context.typeForm()][$context.tableNumber].form)="")
			
		End if 
		
		// Redraw
		$context.draw:=True:C214
		$form.form.refresh()
		
		//=========================================================
	: ($IN.action="refreshViews")
		
		If (Length:C16($context.tableNum())>0)\
			 & (Form:C1466.dataModel[$context.tableNum()]#Null:C1517)
			
			// Redraw
			$context.draw:=True:C214
			
			$form.form.refresh()
			
		End if 
		
		//=========================================================
	: ($IN.action="updateForms")
		
		PROJECT.updateFormDefinitions()
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$IN.action+"\"")
		
		//=========================================================
End case 

// ----------------------------------------------------
// Return
If ($OUT#Null:C1517)
	
	$0:=$OUT
	
End if 

// ----------------------------------------------------
// End