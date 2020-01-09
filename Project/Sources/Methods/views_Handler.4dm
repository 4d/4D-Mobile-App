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
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($i;$eventCode;$Lon_hScroll;$Lon_offset)
C_TEXT:C284($t;$Txt_form;$Txt_newForm;$Txt_table)
C_OBJECT:C1216($o;$context;$Obj_dataModel;$form;$Obj_in;$Obj_out)
C_OBJECT:C1216($Obj_target;$oo)
C_COLLECTION:C1488($c;$Col_assigned)

ARRAY TEXT:C222($tTxt_tables;0)

If (False:C215)
	C_OBJECT:C1216(VIEWS_Handler ;$0)
	C_OBJECT:C1216(VIEWS_Handler ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If (Count parameters:C259>=1)
		
		$Obj_in:=$1
		
	End if 
	
	$form:=New object:C1471(\
		"$";editor_INIT ;\
		"form";ui.form("editor_CALLBACK").get();\
		"tableWidget";ui.picture("tables");\
		"tableNext";ui.static("next@");\
		"tablePrevious";ui.static("previous@");\
		"tableButtonNext";ui.button("next");\
		"tableButtonPrevious";ui.button("previous");\
		"tablist";ui.button("tab.list");\
		"tabdetail";ui.button("tab.detail");\
		"tabSelector";ui.widget("tab.selector");\
		"noPublishedTable";ui.widget("noPublishedTable");\
		"fieldList";ui.listbox("01_fields");\
		"fieldGroup";ui.static("01_fields@");\
		"preview";ui.picture("preview");\
		"previewGroup";ui.static("preview@");\
		"fields";ui.widget("fields");\
		"ids";ui.widget("field_ids");\
		"icons";ui.widget("icons");\
		"names";ui.widget("names");\
		"selectorList";ui.button("tab.list");\
		"selectorDetail";ui.button("tab.detail");\
		"selectors";ui.static("tab.@");\
		"resources";ui.button("resources");\
		"drag";Formula:C1597(tmpl_On_drag_over );\
		"drop";Formula:C1597(tmpl_ON_DROP );\
		"cancel";Formula:C1597(tmpl_REMOVE );\
		"tips";Formula:C1597(tmpl_TIPS );\
		"scrollBar";ui.thermometer("preview.scrollBar"))
	
	$context:=$form.$
	
	If (OB Is empty:C1297($context))  // First load
		
		$c:=New collection:C1472
		
		$c.push(New object:C1471(\
			"formula";Formula:C1597(VIEWS_Handler (New object:C1471("action";\
			"geometry")))))
		
		If (featuresFlags.with("newViewUI"))
			
/*
			
#TO_DO - allow collection for object
			
						$c.push(New object(\
								"object";new collection("preview";"preview.label";"preview.back";"Preview.border");\
								"reference";"viewport.preview";\
								"type";"horizontal alignment";\
								"value";"center"))					
			
*/
			
			$c.push(New object:C1471(\
				"object";"preview";\
				"reference";"viewport.preview";\
				"type";"horizontal alignment";\
				"value";"center"))
			
			$c.push(New object:C1471(\
				"object";"preview.label";\
				"reference";"viewport.preview";\
				"type";"horizontal alignment";\
				"value";"center"))
			
			$c.push(New object:C1471(\
				"object";"preview.back";\
				"reference";"viewport.preview";\
				"type";"horizontal alignment";\
				"value";"center"))
			
			$c.push(New object:C1471(\
				"object";"Preview.border";\
				"reference";"viewport.preview";\
				"type";"horizontal alignment";\
				"value";"center"))
			
			$c.push(New object:C1471(\
				"object";"preview.scrollBar";\
				"reference";"preview";\
				"type";"margin-left";\
				"value";20))
			
		End if 
		
		$context:=ob .set($context).createPath("constraints.rules";Is collection:K8:32;$c).contents
		
		  // Define form member methods
		
		  // Selected table ID as string, empty if none
		$context.tableNum:=Formula:C1597(String:C10(This:C1470.tableNumber))
		
		  // The form type according to the selected tab
		$context.typeForm:=Formula:C1597(Choose:C955(Num:C11(This:C1470.selector)=2;"detail";"list"))
		
		  // Update selected tab
		$context.setTab:=Formula:C1597(VIEWS_Handler (New object:C1471(\
			"action";"setTab")))
		
		  // Update geometry
		$context.setGeometry:=Formula:C1597(VIEWS_Handler (New object:C1471(\
			"action";"geometry")))
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$eventCode:=panel_Form_common (On Load:K2:1;On Timer:K2:25)
		
		$Obj_dataModel:=Form:C1466.dataModel
		
		Case of 
				
				  //______________________________________________________
			: ($eventCode=On Load:K2:1)
				
				$context.scroll:=450
				
				  // This trick remove the horizontal gap
				$form.fieldList.setScrollbar(0;2)
				
				  // Place the tabs according to the localization
				$Lon_offset:=$form.tablist.bestSize(Align left:K42:2).coordinates.right+10
				$form.tabdetail.bestSize(Align left:K42:2).setCoordinates($Lon_offset)
				
				  // Place the download button
				$form.resources.setTitle(str ("downloadMoreResources").localized("templates"))
				$form.resources.bestSize(Align right:K42:4)
				
				$context.setTab()
				
				  // Create, if any, & update the list & detail model [
				$o:=ob_createPath (Form:C1466;"list")
				$o:=ob_createPath (Form:C1466;"detail")
				
				If ($Obj_dataModel#Null:C1517)
					
					For each ($Txt_table;$Obj_dataModel)
						
						Form:C1466.list:=ob_createPath (Form:C1466.list;$Txt_table)
						Form:C1466.detail:=ob_createPath (Form:C1466.detail;$Txt_table)
						
					End for each 
				End if 
				  //]
				
				If (($Obj_dataModel=Null:C1517) | OB Is empty:C1297($Obj_dataModel))
					
					  // No published table
					$form.noPublishedTable.show()
					
					$form.fieldGroup.hide()
					$form.previewGroup.hide()
					
					OB REMOVE:C1226($context;"tableID")
					
				Else 
					
					$form.noPublishedTable.hide()
					
					  // Select the first table if any
					OB GET PROPERTY NAMES:C1232($Obj_dataModel;$tTxt_tables)
					
					If (Length:C16($context.tableNum())=0)\
						 | (Find in array:C230($tTxt_tables;$context.tableNum())=-1)
						
						If (Size of array:C274($tTxt_tables)>0)
							
							  // Select
							$context.tableNumber:=$tTxt_tables{1}
							
						Else 
							
							  // No more published table
							OB REMOVE:C1226($context;"tableID")
							
						End if 
					End if 
				End if 
				
				  // List/detail selector [
				$context.selector:=Num:C11($context.selector)+Num:C11(Num:C11($context.selector)=0)
				($form.tablist.pointer())->:=Num:C11($context.selector=1)
				($form.tabdetail.pointer())->:=Num:C11($context.selector=2)
				  //]
				
				  // Draw the table list
				($form.tableWidget.pointer())->:=tables_Widget ($Obj_dataModel;New object:C1471(\
					"tableNumber";$context.tableNum()))
				
				views_UPDATE ("list")
				views_UPDATE ("detail")
				
				  // Update geometry
				$context.setGeometry()
				
				  //$Obj_context.actions:=_w_actions ("getList";$Obj_context).actions
				
				  //______________________________________________________
			: ($eventCode=On Timer:K2:25)
				
				SET TIMER:C645(0)
				
				$Txt_form:=$context.typeForm()
				
				If ($Obj_dataModel=Null:C1517) | OB Is empty:C1297($Obj_dataModel)
					
					  // No published table
					$form.noPublishedTable.show()
					
					$form.fieldGroup.hide()
					$form.previewGroup.hide()
					
				Else 
					
					$form.noPublishedTable.hide()
					
				End if 
				
				  // Draw the table list
				($form.tableWidget.pointer())->:=tables_Widget ($Obj_dataModel;New object:C1471(\
					"tableNumber";$context.tableNum()))
				
				Case of 
						
						  //………………………………………………………………………………………………………………………………………
					: (Bool:C1537($context.draw))
						
						$form.fieldGroup.setVisible(Length:C16($context.tableNum())>0)
						$form.previewGroup.setVisible(Length:C16($context.tableNum())>0)
						
						  // Uppdate preview
						views_preview ("draw";$form)
						
						  //(ui.pointer($Obj_form.actionDrop))->:=_w_actions ("preview";$Obj_context).pict
						
						OB REMOVE:C1226($context;"draw")
						
						  //………………………………………………………………………………………………………………………………………
					Else 
						
						  //$Obj_form.fieldGroup.hide()
						  //$Obj_form.previewGroup.hide()
						  //CLEAR VARIABLE(($Obj_form.preview.pointer())->)
						
						If (Length:C16($context.tableNum())>0)\
							 & ($Obj_dataModel[$context.tableNum()]#Null:C1517)
							
							$t:=String:C10(Form:C1466[$Txt_form][$context.tableNum()].form)
							
							If (Length:C16($t)>0)
								
								If (Position:C15("/";$t)=1)
									
									  // Host database resources
									$o:=COMPONENT_Pathname ("host_"+$Txt_form+"Forms").folder(Delete string:C232($t;1;1))
									
								Else 
									
									$o:=COMPONENT_Pathname ($Txt_form+"Forms").folder($t)
									
								End if 
							End if 
							
							If (Bool:C1537($o.exists))
								
								  // Update lists
								$context.update:=True:C214
								
								  // Redraw
								$context.draw:=True:C214
								$form.form.refresh()
								
							Else 
								
								If (Bool:C1537(Form:C1466.$dialog.picker))
									
									If (Length:C16($t)>0)
										
										  // Hide the template picker
										$form.form.call("pickerHide")
										
										  // Redraw
										$context.draw:=True:C214
										$form.form.refresh()
										
									End if 
									
								Else 
									
									If (Not:C34(($Obj_dataModel=Null:C1517) | OB Is empty:C1297($Obj_dataModel)))
										
										  // Update lists
										$context.update:=True:C214
										
										  // Display the template picker
										$form.fieldGroup.hide()
										$form.previewGroup.hide()
										
										views_LAYOUT_PICKER ($Txt_form)
										
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
			
			OB REMOVE:C1226($context;"update")
			
			$o:=views_fieldList ($context.tableNum())
			
			If ($o.success)
				
				COLLECTION TO ARRAY:C1562($o.fields;($form.fields.pointer())->)
				COLLECTION TO ARRAY:C1562($o.fields.extract("id");($form.ids.pointer())->)
				COLLECTION TO ARRAY:C1562($o.fields.extract("path");($form.names.pointer())->)
				
				$c:=New collection:C1472
				
				For each ($i;$o.fields.extract("fieldType"))
					
					$c.push(ui.fieldIcons[$i])
					
				End for each 
				
				COLLECTION TO ARRAY:C1562($c;($form.icons.pointer())->)
				
				  // Highlight errors
				For ($i;1;Size of array:C274(($form.fields.pointer())->);1)
					
					$o:=($form.fields.pointer())->{$i}
					
					If ($o.fieldType=8859)  // 1-N
						
						If ($Obj_dataModel[String:C10($o.relatedTableNumber)]=Null:C1517)
							
							LISTBOX SET ROW COLOR:C1270(*;$form.fieldList.name;$i;ui.errorColor;lk font color:K53:24)
							
						End if 
					End if 
				End for 
				
				$form.fieldGroup.show()
				$form.previewGroup.show()
				
				$form.fieldList.focus()
				
			Else 
				
				$form.fields.clear()
				$form.ids.clear()
				$form.names.clear()
				$form.icons.clear()
				
			End if 
		End if 
		
		$form.scrollBar.setVisible(($context.typeForm()="detail") & ($form.preview.visible()))
		
		If (Bool:C1537($context.picker))
			
			  // Display the template picker
			views_LAYOUT_PICKER ($Txt_form)
			
		End if 
		
		OB REMOVE:C1226($context;"picker")
		
		  //=========================================================
	: ($Obj_in.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215;"Missing parameter \"action\"")
		
		  //=========================================================
	: ($Obj_in.action="init")  // Return the form objects definition
		
		$Obj_out:=$form
		
		  //=========================================================
	: ($Obj_in.action="scroll-table")
		
		$o:=$form.tableWidget.update()
		
		If (String:C10($Obj_in.direction)="next")
			
			$Lon_hScroll:=$o.scroll.horizontal+$o.coordinates.width
			
		Else 
			
			$Lon_hScroll:=$o.scroll.horizontal-$o.coordinates.width
			$Lon_hScroll:=Choose:C955($Lon_hScroll<0;0;$o.scroll.horizontal)
			
		End if 
		
		$form.tableWidget.setScrollPosition($Lon_hScroll;Null:C1517)
		
		$context.setGeometry()
		
		  //=========================================================
	: ($Obj_in.action="geometry")
		
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
	: ($Obj_in.action="forms")  // Call back from widget
		
		$form.fieldGroup.show()
		$form.previewGroup.show()
		
		If ($Obj_in.item>0)\
			 & ($Obj_in.item<=$Obj_in.pathnames.length)
			
			$Txt_table:=$context.tableNum()
			
			If ($Obj_in.pathnames[$Obj_in.item-1]#Null:C1517)
				
				  // The selected form
				$Txt_newForm:=$Obj_in.pathnames[$Obj_in.item-1]
				
				  // The current table form
				$t:=String:C10(Form:C1466[$Obj_in.selector][$Txt_table].form)
				
				If ($Txt_newForm#$t)
					
					$Obj_target:=Form:C1466[$Obj_in.selector][$context.tableNumber]
					
					$Obj_in.target:=OB Copy:C1225($Obj_target)
					OB REMOVE:C1226($Obj_in.target;"form")
					
					If (Length:C16($t)#0)
						
						  // Save a snapshot of the current form definition
						Case of 
								
								  //______________________________________________________
							: ($context[$Txt_table]=Null:C1517)
								
								$context[$Txt_table]:=New object:C1471(\
									$Obj_in.selector;New object:C1471($t;\
									$Obj_in.target))
								
								  //______________________________________________________
							: ($context[$Txt_table][$Obj_in.selector]=Null:C1517)
								
								$context[$Txt_table][$Obj_in.selector]:=New object:C1471(\
									$t;$Obj_in.target)
								
								  //______________________________________________________
							Else 
								
								$context[$Txt_table][$Obj_in.selector][$t]:=$Obj_in.target
								
								  //______________________________________________________
						End case 
					End if 
					
					  // Update project & save [
					$Obj_target.form:=$Txt_newForm
					
					OB REMOVE:C1226($context;"manifest")
					
					project.save()
					  //]
					
					If (ob_testPath (Form:C1466.$project;"status";"project"))
						
						If (Not:C34(Form:C1466.$project.status.project))
							
							  // Launch project verifications
							$form.form.call("projectAudit")
							
						End if 
					End if 
					
					If ($context[$Txt_table][$Obj_in.selector][$Txt_newForm]=Null:C1517)
						
						If ($Obj_target.fields=Null:C1517)
							
							$Obj_target.fields:=New collection:C1472
							
						End if 
						
						  // Create a new binding
						$Col_assigned:=$Obj_target.fields.copy()
						
						If ($context[$Txt_table]#Null:C1517)
							
							If ($context[$Txt_table][$Obj_in.selector]#Null:C1517)
								
								  // Enrich with the fields already used during the session
								For each ($Txt_form;$context[$Txt_table][$Obj_in.selector])
									
									For each ($o;$context[$Txt_table][$Obj_in.selector][$Txt_form].fields.filter("col_notNull"))
										
										If ($Col_assigned.extract("name").indexOf($o.name)=-1)
											
											$Col_assigned.push($o)
											
										End if 
									End for each 
								End for each 
							End if 
						End if 
						
					Else 
						
						  // Reuse the last snapshot
						$Col_assigned:=$context[$Txt_table][$Obj_in.selector][$Txt_newForm].fields
						
						  // Enrich the last snapshot with the fields already used during the session
						For each ($Txt_form;$context[$Txt_table][$Obj_in.selector])
							
							If ($Txt_form#$Txt_newForm)
								
								For each ($o;$context[$Txt_table][$Obj_in.selector][$Txt_form].fields.filter("col_notNull"))
									
									If ($Col_assigned.extract("name").indexOf($o.name)=-1)
										
										$Col_assigned.push($o)
										
									End if 
								End for each 
							End if 
						End for each 
					End if 
					
					$Obj_in.form:=$Txt_newForm
					$Obj_in.tableNumber:=$Txt_table
					
					tmpl_REORDER ($Obj_in)
					
				End if 
				
			Else 
				
				  // Show browser
				$o:=New object:C1471("url";"https://developer.4d.com/4d-for-ios/docs/en/custom-"+Choose:C955($context.typeForm()="list";"listform";"detailform")+"-templates.html")
				$form.form.call(New collection:C1472("showBrowser";$o))
				
			End if 
		End if 
		
		  // Redraw
		$context.draw:=True:C214
		$form.form.refresh()
		
		  //=========================================================
	: ($Obj_in.action="show")
		
		  // Restore preview and field list…
		$form.fieldGroup.show()
		$form.previewGroup.show()
		
		  // …and redraw
		$context.draw:=True:C214
		$form.form.refresh()
		
		  //=========================================================
	: ($Obj_in.action="pickerHide")  // Call back from widget
		
		If (Form:C1466[$Obj_in.selector][$context.tableNum()].form=Null:C1517)
			
			$form.fieldGroup.hide()
			$form.previewGroup.hide()
			
		Else 
			
			$form.fieldGroup.show()
			$form.previewGroup.show()
			
		End if 
		
		  //=========================================================
	: ($Obj_in.action="setTab")  // UI for tabs
		
		OBJECT SET FONT STYLE:C166(*;$form.selectors.name;Plain:K14:1)
		
		$t:="tab."+$context.typeForm()
		OBJECT SET FONT STYLE:C166(*;$t;Bold:K14:2)
		
		$t:=Replace string:C233($t;".";"")
		$o:=$form[$t].getCoordinates().coordinates
		$oo:=$form.tabSelector.getCoordinates()
		$oo.setCoordinates($o.left;$oo.coordinates.top;$o.right;$oo.coordinates.bottom)
		
		  //=========================================================
	: ($Obj_in.action="selectTab")
		
		$context.selector:=1+Num:C11($Obj_in.tab="detail")
		
		$context.setTab()
		
		If ($Obj_in.table#Null:C1517)
			
			If (Length:C16($context.tableNum())>0)
				
				  // Restore current selected background
				SVG SET ATTRIBUTE:C1055(*;$form.tableWidget.name;$context.tableNumber;\
					"fill";ui.unselectedFillColor)
				
			End if 
			
			$context.tableNumber:=$Obj_in.table
			
			  // Select the item
			SVG SET ATTRIBUTE:C1055(*;$form.tableWidget.name;$context.tableNumber;\
				"fill";ui.selectedColorFill)
			
			$context.update:=True:C214
			$context.picker:=(String:C10(Form:C1466[$context.typeForm()][$context.tableNumber].form)="")
			
		End if 
		
		  // Redraw
		$context.draw:=True:C214
		$form.form.refresh()
		
		  //=========================================================
	: ($Obj_in.action="refreshViews")
		
		If (Length:C16($context.tableNum())>0)\
			 & (Form:C1466.dataModel[$context.tableNum()]#Null:C1517)
			
			  // Redraw
			$context.draw:=True:C214
			
			$form.form.refresh()
			
		End if 
		
		  //=========================================================
	: ($Obj_in.action="updateForms")
		
		views_UPDATE ("list")
		views_UPDATE ("detail")
		
		  //=========================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_in.action+"\"")
		
		  //=========================================================
End case 

  // ----------------------------------------------------
  // Return
If ($Obj_out#Null:C1517)
	
	$0:=$Obj_out
	
End if 

  // ----------------------------------------------------
  // End