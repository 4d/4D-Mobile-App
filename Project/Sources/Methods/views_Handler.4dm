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

C_LONGINT:C283($eventCode;$i;$l;$offset)
C_TEXT:C284($t;$tFormName;$tNewForm;$tTable;$tTypeForm)
C_OBJECT:C1216($context;$form;$o;$o1;$oDataModel;$oIN)
C_OBJECT:C1216($oOUT;$oTarget;$pathForm)
C_COLLECTION:C1488($c)

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
		
		$oIN:=$1
		
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
		
		  // § DEFINE UI CONSTRAINTS §
		$c:=New collection:C1472
		
		$c.push(New object:C1471(\
			"formula";Formula:C1597(VIEWS_Handler (New object:C1471(\
			"action";"geometry")))))
		
		If (featuresFlags.with("newViewUI"))
			
			$c.push(New object:C1471(\
				"object";New collection:C1472("preview";"preview.label";"preview.back";"Preview.border");\
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
		
		  // § DEFINE FORM MEMBER METHODS §
		
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
	: ($oIN=Null:C1517)  // Form method
		
		$eventCode:=panel_Form_common (On Load:K2:1;On Timer:K2:25)
		
		$oDataModel:=Form:C1466.dataModel
		
		Case of 
				
				  //______________________________________________________
			: ($eventCode=On Load:K2:1)
				
				$context.scroll:=450
				
				  // This trick remove the horizontal gap
				$form.fieldList.setScrollbar(0;2)
				
				  // Place the tabs according to the localization
				$offset:=$form.tablist.bestSize(Align left:K42:2).coordinates.right+10
				$form.tabdetail.bestSize(Align left:K42:2).setCoordinates($offset)
				
				If (featuresFlags.with("resourcesBrowser"))
					$form.resources.hide()
				Else 
					
					  // Place the download button
					$form.resources.setTitle(str ("downloadMoreResources").localized("templates"))
					$form.resources.bestSize(Align right:K42:4)
					
				End if 
				
				$context.setTab()
				
				  // Create, if any, & update the list & detail model [
				$o:=ob_createPath (Form:C1466;"list")
				$o:=ob_createPath (Form:C1466;"detail")
				
				If ($oDataModel#Null:C1517)
					
					For each ($tTable;$oDataModel)
						
						Form:C1466.list:=ob_createPath (Form:C1466.list;$tTable)
						Form:C1466.detail:=ob_createPath (Form:C1466.detail;$tTable)
						
					End for each 
				End if 
				  //]
				
				If (($oDataModel=Null:C1517) | OB Is empty:C1297($oDataModel))
					
					  // No published table
					$form.noPublishedTable.show()
					
					$form.fieldGroup.hide()
					$form.previewGroup.hide()
					
					OB REMOVE:C1226($context;"tableID")
					
				Else 
					
					$form.noPublishedTable.hide()
					
					  // Select the first table if any
					OB GET PROPERTY NAMES:C1232($oDataModel;$tTxt_tables)
					
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
				($form.tableWidget.pointer())->:=tables_Widget ($oDataModel;New object:C1471(\
					"tableNumber";$context.tableNum()))
				
				views_UPDATE ("list")
				views_UPDATE ("detail")
				
				  // Update geometry
				$context.setGeometry()
				
				If (featuresFlags.with("withWidgetActions"))
					
					  //$context.actions:=_w_actions ("getList";$context).actions
					
				End if 
				
				  //______________________________________________________
			: ($eventCode=On Timer:K2:25)
				
				SET TIMER:C645(0)
				
				$tTypeForm:=$context.typeForm()
				
				If ($oDataModel=Null:C1517) | OB Is empty:C1297($oDataModel)
					
					  // No published table
					$form.noPublishedTable.show()
					
					$form.fieldGroup.hide()
					$form.previewGroup.hide()
					
				Else 
					
					$form.noPublishedTable.hide()
					
				End if 
				
				  // Draw the table list
				($form.tableWidget.pointer())->:=tables_Widget ($oDataModel;New object:C1471(\
					"tableNumber";$context.tableNum()))
				
				Case of 
						
						  //………………………………………………………………………………………………………………………………………
					: (Bool:C1537($context.draw))
						
						$form.fieldGroup.setVisible(Length:C16($context.tableNum())>0)
						$form.previewGroup.setVisible(Length:C16($context.tableNum())>0)
						
						  // Uppdate preview
						views_preview ("draw";$form)
						
						If (featuresFlags.with("withWidgetActions"))
							
							  //(ui.pointer($form.actionDrop))->:=_w_actions ("preview";$context).pict
							
						End if 
						
						OB REMOVE:C1226($context;"draw")
						
						  //………………………………………………………………………………………………………………………………………
					Else 
						
						If (Length:C16($context.tableNum())>0)\
							 & ($oDataModel[$context.tableNum()]#Null:C1517)
							
							$tFormName:=String:C10(Form:C1466[$tTypeForm][$context.tableNum()].form)
							$tFormName:=$tFormName*Num:C11($tFormName#"null")  // Reject null value
							
							If (Length:C16($tFormName)>0)
								
								$pathForm:=tmpl_form ($tFormName;$tTypeForm)
								
							End if 
							
							If (Bool:C1537($pathForm.exists))
								
								  // Update lists
								$context.update:=True:C214
								
								  // Redraw
								$context.draw:=True:C214
								$form.form.refresh()
								
							Else 
								
								If (Bool:C1537(Form:C1466.$dialog.picker))
									
									If (Length:C16($tFormName)>0)
										
										  // Hide the template picker
										$form.form.call("pickerHide")
										
										  // Redraw
										$context.draw:=True:C214
										$form.form.refresh()
										
									End if 
									
								Else 
									
									If (Not:C34(($oDataModel=Null:C1517) | OB Is empty:C1297($oDataModel)))
										
										  // Update lists
										$context.update:=True:C214
										
										  // Display the template picker
										$form.fieldGroup.hide()
										$form.previewGroup.hide()
										
										views_LAYOUT_PICKER ($tTypeForm)
										
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
						
						If ($oDataModel[String:C10($o.relatedTableNumber)]=Null:C1517)
							
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
			views_LAYOUT_PICKER ($tTypeForm)
			
		End if 
		
		OB REMOVE:C1226($context;"picker")
		
		  //=========================================================
	: ($oIN.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215;"Missing parameter \"action\"")
		
		  //=========================================================
	: ($oIN.action="init")  // Return the form objects definition
		
		$oOUT:=$form
		
		  //=========================================================
	: ($oIN.action="scroll-table")
		
		$o:=$form.tableWidget.update()
		
		If (String:C10($oIN.direction)="next")
			
			$l:=$o.scroll.horizontal+$o.coordinates.width
			
		Else 
			
			$l:=$o.scroll.horizontal-$o.coordinates.width
			$l:=Choose:C955($l<0;0;$o.scroll.horizontal)
			
		End if 
		
		$form.tableWidget.setScrollPosition($l;Null:C1517)
		
		$context.setGeometry()
		
		  //=========================================================
	: ($oIN.action="geometry")
		
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
	: ($oIN.action="forms")  // Call back from widget
		
		$form.fieldGroup.show()
		$form.previewGroup.show()
		
		If ($oIN.item>0)\
			 & ($oIN.item<=$oIN.pathnames.length)
			
			$tTable:=$context.tableNum()
			
			If ($oIN.pathnames[$oIN.item-1]#Null:C1517)
				
				  // The selected form
				$tNewForm:=$oIN.pathnames[$oIN.item-1]
				
				  // The current table form
				$t:=String:C10(Form:C1466[$oIN.selector][$tTable].form)
				
				If ($tNewForm#$t)
					
					$oTarget:=Form:C1466[$oIN.selector][$context.tableNumber]
					
					$oIN.target:=OB Copy:C1225($oTarget)
					OB REMOVE:C1226($oIN.target;"form")
					
					If (Length:C16($t)#0)
						
						  // Save a snapshot of the current form definition
						Case of 
								
								  //______________________________________________________
							: ($context[$tTable]=Null:C1517)
								
								$context[$tTable]:=New object:C1471(\
									$oIN.selector;New object:C1471($t;\
									$oIN.target))
								
								  //______________________________________________________
							: ($context[$tTable][$oIN.selector]=Null:C1517)
								
								$context[$tTable][$oIN.selector]:=New object:C1471(\
									$t;$oIN.target)
								
								  //______________________________________________________
							Else 
								
								$context[$tTable][$oIN.selector][$t]:=$oIN.target
								
								  //______________________________________________________
						End case 
					End if 
					
					  // Update project & save [
					$oTarget.form:=$tNewForm
					
					OB REMOVE:C1226($context;"manifest")
					
					project.save()
					  //]
					
					If (ob_testPath (Form:C1466.$project;"status";"project"))
						
						If (Not:C34(Form:C1466.$project.status.project))
							
							  // Launch project verifications
							$form.form.call("projectAudit")
							
						End if 
					End if 
					
					If ($context[$tTable][$oIN.selector][$tNewForm]=Null:C1517)
						
						If ($oTarget.fields=Null:C1517)
							
							$oTarget.fields:=New collection:C1472
							
						End if 
						
						  // Create a new binding
						$c:=$oTarget.fields.copy()
						
						If ($context[$tTable]#Null:C1517)
							
							If ($context[$tTable][$oIN.selector]#Null:C1517)
								
								  // Enrich with the fields already used during the session
								For each ($tTypeForm;$context[$tTable][$oIN.selector])
									
									For each ($o;$context[$tTable][$oIN.selector][$tTypeForm].fields.filter("col_notNull"))
										
										If ($c.extract("name").indexOf($o.name)=-1)
											
											$c.push($o)
											
										End if 
									End for each 
								End for each 
							End if 
						End if 
						
					Else 
						
						  // Reuse the last snapshot
						$c:=$context[$tTable][$oIN.selector][$tNewForm].fields
						
						  // Enrich the last snapshot with the fields already used during the session
						For each ($tTypeForm;$context[$tTable][$oIN.selector])
							
							If ($tTypeForm#$tNewForm)
								
								For each ($o;$context[$tTable][$oIN.selector][$tTypeForm].fields.filter("col_notNull"))
									
									If ($c.extract("name").indexOf($o.name)=-1)
										
										$c.push($o)
										
									End if 
								End for each 
							End if 
						End for each 
					End if 
					
					$oIN.form:=$tNewForm
					$oIN.tableNumber:=$tTable
					
					tmpl_REORDER ($oIN)
					
				End if 
				
				  // Redraw
				$context.draw:=True:C214
				$form.form.refresh()
				
			Else 
				
				  // Show browser
				$o:=New object:C1471(\
					"url";Get localized string:C991("res_"+$context.typeForm()+"Forms"))
				
				$form.form.call(New collection:C1472("initBrowser";$o))
				
			End if 
		End if 
		
		  //=========================================================
	: ($oIN.action="show")
		
		  // Restore preview and field list…
		$form.fieldGroup.show()
		$form.previewGroup.show()
		
		  // …and redraw
		$context.draw:=True:C214
		$form.form.refresh()
		
		  //=========================================================
	: ($oIN.action="pickerHide")  // Call back from widget
		
		If (Form:C1466[$oIN.selector][$context.tableNum()].form=Null:C1517)
			
			$form.fieldGroup.hide()
			$form.previewGroup.hide()
			
		Else 
			
			$form.fieldGroup.show()
			$form.previewGroup.show()
			
		End if 
		
		  //=========================================================
	: ($oIN.action="setTab")  // UI for tabs
		
		OBJECT SET FONT STYLE:C166(*;$form.selectors.name;Plain:K14:1)
		
		$t:="tab."+$context.typeForm()
		OBJECT SET FONT STYLE:C166(*;$t;Bold:K14:2)
		
		$t:=Replace string:C233($t;".";"")
		$o:=$form[$t].getCoordinates().coordinates
		$o1:=$form.tabSelector.getCoordinates()
		$o1.setCoordinates($o.left;$o1.coordinates.top;$o.right;$o1.coordinates.bottom)
		
		  //=========================================================
	: ($oIN.action="selectTab")
		
		$context.selector:=1+Num:C11($oIN.tab="detail")
		
		$context.setTab()
		
		If ($oIN.table#Null:C1517)
			
			If (Length:C16($context.tableNum())>0)
				
				  // Restore current selected background
				SVG SET ATTRIBUTE:C1055(*;$form.tableWidget.name;$context.tableNumber;\
					"fill";ui.unselectedFillColor)
				
			End if 
			
			$context.tableNumber:=$oIN.table
			
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
	: ($oIN.action="refreshViews")
		
		If (Length:C16($context.tableNum())>0)\
			 & (Form:C1466.dataModel[$context.tableNum()]#Null:C1517)
			
			  // Redraw
			$context.draw:=True:C214
			
			$form.form.refresh()
			
		End if 
		
		  //=========================================================
	: ($oIN.action="updateForms")
		
		views_UPDATE ("list")
		views_UPDATE ("detail")
		
		  //=========================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$oIN.action+"\"")
		
		  //=========================================================
End case 

  // ----------------------------------------------------
  // Return
If ($oOUT#Null:C1517)
	
	$0:=$oOUT
	
End if 

  // ----------------------------------------------------
  // End