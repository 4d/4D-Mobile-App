//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : views_Handler
  // Database: 4D Mobile Express
  // ID[2A03E5F862194815A6AA36A409731C5C]
  // Created 26-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($i;$Lon_formEvent;$Lon_hScroll;$Lon_offset;$Lon_parameters)
C_TEXT:C284($t;$Txt_form;$Txt_newForm;$Txt_table)
C_OBJECT:C1216($o;$Obj_context;$Obj_dataModel;$Obj_form;$Obj_in;$Obj_out)
C_OBJECT:C1216($Obj_target;$oo)
C_COLLECTION:C1488($c;$Col_assigned)

ARRAY TEXT:C222($tTxt_tables;0)

If (False:C215)
	C_OBJECT:C1216(views_Handler ;$0)
	C_OBJECT:C1216(views_Handler ;$1)
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
		"drag";Formula:C1597(tmpl_On_drag_over );\
		"drop";Formula:C1597(tmpl_ON_DROP );\
		"cancel";Formula:C1597(tmpl_REMOVE );\
		"tips";Formula:C1597(tmpl_TIPS ))
	
	$Obj_context:=$Obj_form.$
	
	If (OB Is empty:C1297($Obj_context))  // First load
		
		  // Constraints definition
		ob_createPath ($Obj_context;"constraints.rules";Is collection:K8:32)
		
		$Obj_context.constraints.rules.push(New object:C1471(\
			"formula";Formula:C1597(views_Handler (New object:C1471("action";\
			"geometry")))))
		
		  // Define form member methods
		
		  // Selected table ID as string, empty if none
		$Obj_context.tableNum:=Formula:C1597(String:C10(This:C1470.tableNumber))
		
		  // The form type according to the selected tab
		$Obj_context.typeForm:=Formula:C1597(Choose:C955(Num:C11(This:C1470.selector)=2;"detail";"list"))
		
		  // Update selected tab
		$Obj_context.setTab:=Formula:C1597(views_Handler (New object:C1471(\
			"action";"setTab")))
		
		  // Update geometry
		$Obj_context.setGeometry:=Formula:C1597(views_Handler (New object:C1471(\
			"action";"geometry")))
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

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
				$Lon_offset:=$Obj_form.tablist.bestSize(Align left:K42:2).coordinates.right+10
				$Obj_form.tabdetail.bestSize(Align left:K42:2).setCoordinates($Lon_offset;Null:C1517;Null:C1517;Null:C1517)
				
				$Obj_context.setTab()
				
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
					$Obj_form.noPublishedTable.show()
					
					$Obj_form.fieldGroup.hide()
					$Obj_form.previewGroup.hide()
					
					OB REMOVE:C1226($Obj_context;"tableID")
					
				Else 
					
					$Obj_form.noPublishedTable.hide()
					
					  // Select the first table if any
					OB GET PROPERTY NAMES:C1232($Obj_dataModel;$tTxt_tables)
					
					If (Length:C16($Obj_context.tableNum())=0)\
						 | (Find in array:C230($tTxt_tables;$Obj_context.tableNum())=-1)
						
						If (Size of array:C274($tTxt_tables)>0)
							
							  // Select
							$Obj_context.tableNumber:=$tTxt_tables{1}
							
						Else 
							
							  // No more published table
							OB REMOVE:C1226($Obj_context;"tableID")
							
						End if 
					End if 
				End if 
				
				  // List/detail selector [
				$Obj_context.selector:=Num:C11($Obj_context.selector)+Num:C11(Num:C11($Obj_context.selector)=0)
				($Obj_form.tablist.pointer())->:=Num:C11($Obj_context.selector=1)
				($Obj_form.tabdetail.pointer())->:=Num:C11($Obj_context.selector=2)
				  //]
				
				  // Draw the table list
				($Obj_form.tableWidget.pointer())->:=tables_Widget ($Obj_dataModel;New object:C1471(\
					"tableNumber";$Obj_context.tableNum()))
				
				views_UPDATE ("list")
				views_UPDATE ("detail")
				
				  // Update geometry
				$Obj_context.setGeometry()
				
				  //$Obj_context.actions:=_w_actions ("getList";$Obj_context).actions
				
				  //______________________________________________________
			: ($Lon_formEvent=On Timer:K2:25)
				
				SET TIMER:C645(0)
				
				$Txt_form:=$Obj_context.typeForm()
				
				If ($Obj_dataModel=Null:C1517) | OB Is empty:C1297($Obj_dataModel)
					
					  // No published table
					$Obj_form.noPublishedTable.show()
					
					$Obj_form.fieldGroup.hide()
					$Obj_form.previewGroup.hide()
					
				Else 
					
					$Obj_form.noPublishedTable.hide()
					
				End if 
				
				  // Draw the table list
				($Obj_form.tableWidget.pointer())->:=tables_Widget ($Obj_dataModel;New object:C1471(\
					"tableNumber";$Obj_context.tableNum()))
				
				Case of 
						
						  //………………………………………………………………………………………………………………………………………
					: (Bool:C1537($Obj_context.draw))
						
						$Obj_form.fieldGroup.setVisible(Length:C16($Obj_context.tableNum())>0)
						$Obj_form.previewGroup.setVisible(Length:C16($Obj_context.tableNum())>0)
						
						  // Uppdate preview
						views_preview ("draw";$Obj_form)
						
						  //(ui.pointer($Obj_form.actionDrop))->:=_w_actions ("preview";$Obj_context).pict
						
						OB REMOVE:C1226($Obj_context;"draw")
						
						  //………………………………………………………………………………………………………………………………………
					Else 
						
						  //$Obj_form.fieldGroup.hide()
						  //$Obj_form.previewGroup.hide()
						  //CLEAR VARIABLE(($Obj_form.preview.pointer())->)
						
						If (Length:C16($Obj_context.tableNum())>0)\
							 & ($Obj_dataModel[$Obj_context.tableNum()]#Null:C1517)
							
							$t:=String:C10(Form:C1466[$Txt_form][$Obj_context.tableNum()].form)
							
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
								$Obj_context.update:=True:C214
								
								  // Redraw
								$Obj_context.draw:=True:C214
								$Obj_form.form.refresh()
								
							Else 
								
								If (Bool:C1537(Form:C1466.$dialog.picker))
									
									If (Length:C16($t)>0)
										
										  // Hide the template picker
										$Obj_form.form.call("pickerHide")
										
										  // Redraw
										$Obj_context.draw:=True:C214
										$Obj_form.form.refresh()
										
									End if 
									
								Else 
									
									If (Not:C34(($Obj_dataModel=Null:C1517) | OB Is empty:C1297($Obj_dataModel)))
										
										  // Update lists
										$Obj_context.update:=True:C214
										
										  // Display the template picker
										$Obj_form.fieldGroup.hide()
										$Obj_form.previewGroup.hide()
										
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
		
		If (Bool:C1537($Obj_context.update))
			
			OB REMOVE:C1226($Obj_context;"update")
			
			$o:=views_fieldList ($Obj_context.tableNum())
			
			If ($o.success)
				
				COLLECTION TO ARRAY:C1562($o.fields;($Obj_form.fields.pointer())->)
				COLLECTION TO ARRAY:C1562($o.fields.extract("id");($Obj_form.ids.pointer())->)
				COLLECTION TO ARRAY:C1562($o.fields.extract("path");($Obj_form.names.pointer())->)
				
				$c:=New collection:C1472
				
				For each ($i;$o.fields.extract("fieldType"))
					
					$c.push(ui.fieldIcons[$i])
					
				End for each 
				
				COLLECTION TO ARRAY:C1562($c;($Obj_form.icons.pointer())->)
				
				  // Highlight errors
				For ($i;1;Size of array:C274(($Obj_form.fields.pointer())->);1)
					
					$o:=($Obj_form.fields.pointer())->{$i}
					
					If ($o.fieldType=8859)  // 1-N
						
						If ($Obj_dataModel[String:C10($o.relatedTableNumber)]=Null:C1517)
							
							LISTBOX SET ROW COLOR:C1270(*;$Obj_form.fieldList.name;$i;ui.errorColor;lk font color:K53:24)
							
						End if 
					End if 
				End for 
				
				$Obj_form.fieldGroup.show()
				$Obj_form.previewGroup.show()
				
				$Obj_form.fieldList.focus()
				
			Else 
				
				$Obj_form.fields.clear()
				$Obj_form.ids.clear()
				$Obj_form.names.clear()
				$Obj_form.icons.clear()
				
			End if 
		End if 
		
		If (Bool:C1537($Obj_context.picker))
			
			  // Display the template picker
			views_LAYOUT_PICKER ($Txt_form)
			
		End if 
		
		OB REMOVE:C1226($Obj_context;"picker")
		
		  //=========================================================
	: ($Obj_in.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215;"Missing parameter \"action\"")
		
		  //=========================================================
	: ($Obj_in.action="init")  // Return the form objects definition
		
		$Obj_out:=$Obj_form
		
		  //=========================================================
	: ($Obj_in.action="scroll-table")
		
		$o:=$Obj_form.tableWidget.update()
		
		If (String:C10($Obj_in.direction)="next")
			
			$Lon_hScroll:=$o.scroll.horizontal+$o.coordinates.width
			
		Else 
			
			$Lon_hScroll:=$o.scroll.horizontal-$o.coordinates.width
			$Lon_hScroll:=Choose:C955($Lon_hScroll<0;0;$o.scroll.horizontal)
			
		End if 
		
		$Obj_form.tableWidget.setScrollPosition($Lon_hScroll;Null:C1517)
		
		$Obj_context.setGeometry()
		
		  //=========================================================
	: ($Obj_in.action="geometry")
		
		If (Not:C34(Is nil pointer:C315($obj_form.tableWidget.pointer())))
			
			$o:=$obj_form.tableWidget.update()
			
			If ($o.dimensions.width>$o.coordinates.width)
				
				$Obj_form.tablePrevious.setVisible($o.scroll.horizontal>0)
				$Obj_form.tableNext.setVisible(($o.scroll.horizontal+$o.coordinates.width)<$o.dimensions.width)
				
			Else 
				
				$Obj_form.tablePrevious.hide()
				$Obj_form.tableNext.hide()
				
			End if 
		End if 
		
		  //=========================================================
	: ($Obj_in.action="forms")  // Call back from widget
		
		$Obj_form.fieldGroup.show()
		$Obj_form.previewGroup.show()
		
		If ($Obj_in.item>0)\
			 & ($Obj_in.item<=$Obj_in.pathnames.length)
			
			$Txt_table:=$Obj_context.tableNum()
			
			  // The selected form
			$Txt_newForm:=$Obj_in.pathnames[$Obj_in.item-1]
			
			  // The current table form
			$t:=String:C10(Form:C1466[$Obj_in.selector][$Txt_table].form)
			
			If ($Txt_newForm#$t)
				
				$Obj_target:=Form:C1466[$Obj_in.selector][$Obj_context.tableNumber]
				
				$Obj_in.target:=OB Copy:C1225($Obj_target)
				OB REMOVE:C1226($Obj_in.target;"form")
				
				If (Length:C16($t)#0)
					
					  // Save a snapshot of the current form definition
					Case of 
							
							  //______________________________________________________
						: ($Obj_context[$Txt_table]=Null:C1517)
							
							$Obj_context[$Txt_table]:=New object:C1471(\
								$Obj_in.selector;New object:C1471($t;\
								$Obj_in.target))
							
							  //______________________________________________________
						: ($Obj_context[$Txt_table][$Obj_in.selector]=Null:C1517)
							
							$Obj_context[$Txt_table][$Obj_in.selector]:=New object:C1471(\
								$t;$Obj_in.target)
							
							  //______________________________________________________
						Else 
							
							$Obj_context[$Txt_table][$Obj_in.selector][$t]:=$Obj_in.target
							
							  //______________________________________________________
					End case 
				End if 
				
				  // Update project & save [
				$Obj_target.form:=$Txt_newForm
				
				OB REMOVE:C1226($Obj_context;"manifest")
				
				project.save()
				  //]
				
				If (ob_testPath (Form:C1466.$project;"status";"project"))
					
					If (Not:C34(Form:C1466.$project.status.project))
						
						  // Launch project verifications
						$Obj_form.form.call("projectAudit")
						
					End if 
				End if 
				
				If ($Obj_context[$Txt_table][$Obj_in.selector][$Txt_newForm]=Null:C1517)
					
					If ($Obj_target.fields=Null:C1517)
						
						$Obj_target.fields:=New collection:C1472
						
					End if 
					
					  // Create a new binding
					$Col_assigned:=$Obj_target.fields.copy()
					
					If ($Obj_context[$Txt_table]#Null:C1517)
						
						If ($Obj_context[$Txt_table][$Obj_in.selector]#Null:C1517)
							
							  // Enrich with the fields already used during the session
							For each ($Txt_form;$Obj_context[$Txt_table][$Obj_in.selector])
								
								For each ($o;$Obj_context[$Txt_table][$Obj_in.selector][$Txt_form].fields.filter("col_notNull"))
									
									If ($Col_assigned.extract("name").indexOf($o.name)=-1)
										
										$Col_assigned.push($o)
										
									End if 
								End for each 
							End for each 
						End if 
					End if 
					
				Else 
					
					  // Reuse the last snapshot
					$Col_assigned:=$Obj_context[$Txt_table][$Obj_in.selector][$Txt_newForm].fields
					
					  // Enrich the last snapshot with the fields already used during the session
					For each ($Txt_form;$Obj_context[$Txt_table][$Obj_in.selector])
						
						If ($Txt_form#$Txt_newForm)
							
							For each ($o;$Obj_context[$Txt_table][$Obj_in.selector][$Txt_form].fields.filter("col_notNull"))
								
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
		End if 
		
		  // Redraw
		$Obj_context.draw:=True:C214
		$Obj_form.form.refresh()
		
		  //=========================================================
	: ($Obj_in.action="show")
		
		  // Restore preview and field list…
		$Obj_form.fieldGroup.show()
		$Obj_form.previewGroup.show()
		
		  // …and redraw
		$Obj_context.draw:=True:C214
		$Obj_form.form.refresh()
		
		  //=========================================================
	: ($Obj_in.action="pickerHide")  // Call back from widget
		
		If (Form:C1466[$Obj_in.selector][$Obj_context.tableNum()].form=Null:C1517)
			
			$Obj_form.fieldGroup.hide()
			$Obj_form.previewGroup.hide()
			
		Else 
			
			$Obj_form.fieldGroup.show()
			$Obj_form.previewGroup.show()
			
		End if 
		
		  //=========================================================
	: ($Obj_in.action="setTab")  // UI for tabs
		
		OBJECT SET FONT STYLE:C166(*;$obj_form.selectors.name;Plain:K14:1)
		
		$t:="tab."+$Obj_context.typeForm()
		OBJECT SET FONT STYLE:C166(*;$t;Bold:K14:2)
		
		$t:=Replace string:C233($t;".";"")
		$o:=$Obj_form[$t].getCoordinates().coordinates
		$oo:=$Obj_form.tabSelector.getCoordinates()
		$oo.setCoordinates($o.left;$oo.coordinates.top;$o.right;$oo.coordinates.bottom)
		
		  //=========================================================
	: ($Obj_in.action="selectTab")
		
		$Obj_context.selector:=1+Num:C11($Obj_in.tab="detail")
		
		$Obj_context.setTab()
		
		If ($Obj_in.table#Null:C1517)
			
			If (Length:C16($Obj_context.tableNum())>0)
				
				  // Restore current selected background
				SVG SET ATTRIBUTE:C1055(*;$Obj_form.tableWidget.name;$Obj_context.tableNumber;\
					"fill";ui.unselectedFillColor)
				
			End if 
			
			$Obj_context.tableNumber:=$Obj_in.table
			
			  // Select the item
			SVG SET ATTRIBUTE:C1055(*;$Obj_form.tableWidget.name;$Obj_context.tableNumber;\
				"fill";ui.selectedColorFill)
			
			$Obj_context.update:=True:C214
			$Obj_context.picker:=(String:C10(Form:C1466[$Obj_context.typeForm()][$Obj_context.tableNumber].form)="")
			
		End if 
		
		  // Redraw
		$Obj_context.draw:=True:C214
		$Obj_form.form.refresh()
		
		  //=========================================================
	: ($Obj_in.action="refreshViews")
		
		If (Length:C16($Obj_context.tableNum())>0)\
			 & ($Obj_dataModel[$Obj_context.tableNum()]#Null:C1517)
			
			  // Redraw
			$Obj_context.draw:=True:C214
			$Obj_form.form.refresh()
			
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
$0:=$Obj_out

  // ----------------------------------------------------
  // End