//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : STRUCTURE_OBJECTS_HANDLER
  // ID[EA07A8F4BE0F4D3CB64A774D158FC5F1]
  // Created 25-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($Boo_value)
C_LONGINT:C283($i;$l;$Lon_bottom;$Lon_button;$Lon_column;$Lon_formEvent)
C_LONGINT:C283($Lon_height;$Lon_left;$Lon_number;$Lon_published;$Lon_right;$Lon_row)
C_LONGINT:C283($Lon_targetBottom;$Lon_targetTop;$Lon_top;$Lon_unpublished;$Lon_vOffset;$Lon_width)
C_LONGINT:C283($Lon_x;$Win_hdl)
C_POINTER:C301($Ptr_;$Ptr_me;$Ptr_published)
C_TEXT:C284($Mnu_choice;$Mnu_main;$t;$Txt_fieldNumber;$Txt_me)
C_OBJECT:C1216($o;$Obj_context;$Obj_dataModel;$Obj_form;$Obj_related)
C_COLLECTION:C1488($c;$Col_published)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)

$Obj_form:=STRUCTURE_Handler (New object:C1471(\
"action";"init"))

$Obj_context:=$Obj_form.form

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($Txt_me=$Obj_form.allow)
		
		ui.saveProject()
		
		  //==================================================
	: ($Txt_me=$Obj_form.allowHelp)
		
		OPEN URL:C673(Get localized string:C991("doc_incremental");*)
		
		  //==================================================
	: ($Txt_me=$Obj_form.tableList)
		
		LISTBOX GET CELL POSITION:C971(*;$Txt_me;$Lon_column;$Lon_row)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Selection Change:K2:29)
				
				editor_ui_LISTBOX ($Txt_me)
				
				If ($Lon_row=0)
					
					OB REMOVE:C1226($Obj_context;"currentTable")
					
				Else 
					
					  // Keep the current selected table
					$c:=editor_Catalog 
					$l:=$c.extract("name").indexOf((ui.pointer($Obj_form.tables))->{$Lon_row})
					$Obj_context.currentTable:=$c[$l]
					
				End if 
				
				  // Update field list
				structure_FIELD_LIST ($Obj_form)
				
				  //______________________________________________________
			: ($Lon_formEvent=On Clicked:K2:4)
				
				If (Right click:C712)
					
					$Mnu_main:=Create menu:C408
					
					$Ptr_published:=ui.pointer($Obj_form.published)
					$Lon_unpublished:=Count in array:C907($Ptr_published->;0)
					
					If ($Lon_unpublished>0)
						
						APPEND MENU ITEM:C411($Mnu_main;":xliff:publishAll")
						SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"publishAll")
						
					End if 
					
					If ($Lon_unpublished#Size of array:C274($Ptr_published->))
						
						APPEND MENU ITEM:C411($Mnu_main;":xliff:unpublishAll")
						SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"unpublishAll")
						
					End if 
					
					$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_main)
					RELEASE MENU:C978($Mnu_main)
					
					Case of 
							
							  //………………………………………………………………………………………
						: ($Mnu_choice="publishAll")\
							 | ($Mnu_choice="unpublishAll")
							
							  //#MARK_TODO - management of relatedDataClass
							
							$Boo_value:=($Mnu_choice="publishAll")
							
							For ($i;1;Size of array:C274($Ptr_published->);1)
								
								$Ptr_published->{$i}:=Num:C11($Boo_value)
								
							End for 
							
							STRUCTURE_UPDATE ($Obj_form)
							
							  //………………………………………………………………………………………
						Else 
							
							If (Length:C16($Mnu_choice)>0)
								
								ASSERT:C1129(False:C215;"Unknown menu action ("+$Mnu_choice+")")
								
							End if 
							
							  //………………………………………………………………………………………
					End case 
				End if 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Mouse Enter:K2:33)
				
				ui.tips.enable()
				ui.tips.instantly()
				
				  //______________________________________________________
			: ($Lon_formEvent=On Mouse Move:K2:35)
				
				$Obj_context.setHelpTip($Txt_me;$Obj_form)
				
				  //______________________________________________________
			: ($Lon_formEvent=On Mouse Leave:K2:34)
				
				ui.tips.defaultDelay()
				
				  //______________________________________________________
			: ($Lon_formEvent=On Getting Focus:K2:7)
				
				$Obj_context.focus:=$Obj_form.tables
				
				If (LISTBOX Get number of rows:C915(*;$Txt_me)>0)
					
					LISTBOX GET CELL POSITION:C971(*;$Txt_me;$l;$Lon_row)
					
					If ($Lon_row=0)
						
						LISTBOX SELECT ROW:C912(*;$Txt_me;1;lk replace selection:K53:1)
						
					End if 
				End if 
				
				OBJECT SET RGB COLORS:C628(*;$Txt_me;Foreground color:K23:1;ui.highlightColor;ui.highlightColor)
				
				structure_FIELD_LIST ($Obj_form)
				
				ui_MOVE ($Obj_form.search;$Txt_me;Align right:K42:4;30)
				ui_MOVE ($Obj_form.action;$Txt_me;Align right:K42:4;0)
				
				OBJECT SET VISIBLE:C603(*;$Obj_form.tables+".filter";False:C215)
				OBJECT SET VISIBLE:C603(*;$Obj_form.search;True:C214)
				OBJECT SET VISIBLE:C603(*;$Obj_form.action;True:C214)
				  //]
				
				$Ptr_:=ui.pointer($Obj_form.search)
				$Ptr_->value:=String:C10($Obj_context.tableFilter)
				$Ptr_->:=$Ptr_->  // Touch
				
				STRUCTURE_Handler (New object:C1471(\
					"action";"fieldFilter";\
					"showIfNotEmpty";True:C214))
				
				  //______________________________________________________
			: ($Lon_formEvent=On Losing Focus:K2:8)
				
				STRUCTURE_Handler (New object:C1471(\
					"action";"tableFilter"))
				
				OBJECT SET VISIBLE:C603(*;$Obj_form.tableFilter;True:C214)
				OBJECT SET RGB COLORS:C628(*;$Txt_me;Foreground color:K23:1;0x00FFFFFF;0x00FFFFFF)
				SET TIMER:C645(-1)  // Restore visual selection
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Txt_me=$Obj_form.tableFilter)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Clicked:K2:4)
				
				  // Get the content type
				If (ST Get content type:C1286(*;$Txt_me;ST Start highlight:K78:13;ST End highlight:K78:14)=ST User type:K78:12)  // This is a user link
					
					$Mnu_main:=Create menu:C408
					
					If (Length:C16(String:C10($Obj_context.tableFilter))>0)
						
						APPEND MENU ITEM:C411($Mnu_main;Get localized string:C991("structName")+" : ("+$Obj_context.tableFilter+")";*)
						SET MENU ITEM MARK:C208($Mnu_main;-1;Char:C90(18))
						
					Else 
						
						APPEND MENU ITEM:C411($Mnu_main;":xliff:structName")
						DISABLE MENU ITEM:C150($Mnu_main;-1)
						
					End if 
					
					SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"name")
					
					APPEND MENU ITEM:C411($Mnu_main;":xliff:onlyPublishedTables")
					SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"published")
					
					If (Bool:C1537($Obj_context.tableFilterPublished))
						
						SET MENU ITEM MARK:C208($Mnu_main;-1;Char:C90(18))
						
					End if 
					
					$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_main)
					RELEASE MENU:C978($Mnu_main)
					
					Case of 
							
							  //………………………………………………………………………………………
						: (Length:C16($Mnu_choice)=0)
							
							  // Nothing selected
							
							  //………………………………………………………………………………………
						: ($Mnu_choice="name")  // Remove name filter
							
							$Obj_context.tableFilter:=""
							
							STRUCTURE_Handler (New object:C1471(\
								"action";"tableList"))
							
							  //………………………………………………………………………………………
						: ($Mnu_choice="published")  // Add-remove published filter
							
							$Obj_context.tableFilterPublished:=Not:C34(Bool:C1537($Obj_context.tableFilterPublished))
							
							STRUCTURE_Handler (New object:C1471(\
								"action";"tableList"))
							
							  //………………………………………………………………………………………
						Else 
							
							ASSERT:C1129(False:C215;"Unknown menu action ("+$Mnu_choice+")")
							
							  //………………………………………………………………………………………
					End case 
					
					STRUCTURE_Handler (New object:C1471(\
						"action";"tableFilter"))
					
				End if 
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Txt_me=$Obj_form.fieldList)
		
		LISTBOX GET CELL POSITION:C971(*;$Txt_me;$Lon_column;$Lon_row)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Selection Change:K2:29)\
				 | ($Lon_formEvent=On Clicked:K2:4)
				
				editor_ui_LISTBOX ($Txt_me)
				
				If ($Lon_row=0)
					
					OB REMOVE:C1226($Obj_context;"fieldName")
					
				Else 
					
					  // Keep the current field name
					$Obj_context.fieldName:=(ui.pointer($Obj_form.fields))->{$Lon_row}
					
					If ($Lon_formEvent=On Clicked:K2:4)
						
						If (Right click:C712)
							
							  //#MARK_TODO - CONTEXTUAL MENU PUBLISH/UNPBLISH {ALL}
							
						Else 
							
							If ($Lon_row>0)
								
								If ($Lon_column=3)  // & (Bool(featuresFlags._101637))
									
									  //#MARK_TO_OPTIMIZE
									$o:=structure (New object:C1471(\
										"action";"relatedCatalog";\
										"table";String:C10($Obj_context.currentTable.name);\
										"relatedEntity";$Obj_context.fieldName))
									
									If ($o.success)  // Open field picker
										
										$Obj_dataModel:=Form:C1466.dataModel[String:C10($Obj_context.currentTable.tableNumber)][$o.relatedEntity]
										
										For each ($Obj_related;$o.fields)
											
											$Obj_related.published:=($Obj_dataModel[String:C10($Obj_related.fieldNumber)]#Null:C1517)
											$Obj_related.icon:=UI.fieldIcons[$Obj_related.fieldType]
											
										End for each 
										
										$Win_hdl:=Open form window:C675("RELATED";Sheet form window:K39:12;*)
										DIALOG:C40("RELATED";$o)
										
										If ($o.success)  // Dialog was validated
											
											  // If at least one related field is published
											If ($o.fields.extract("published").indexOf(True:C214)#-1)
												
												$Obj_dataModel:=Form:C1466.dataModel[String:C10($Obj_context.currentTable.tableNumber)]
												
												If ($Obj_dataModel=Null:C1517)\
													 | OB Is empty:C1297($Obj_dataModel)
													
													$Obj_dataModel:=STRUCTURE_Handler (New object:C1471(\
														"action";"addTable"))
													
												End if 
												
												$Col_published:=New collection:C1472
												
												For each ($Obj_related;$o.fields)
													
													$Lon_number:=$Lon_number+1
													$Txt_fieldNumber:=String:C10($Obj_related.fieldNumber)
													
													If ($Obj_related.published)
														
														$Col_published.push($Obj_related)
														
														If ($Obj_dataModel[$Obj_context.fieldName]=Null:C1517)
															
															  // Create the relation
															$Obj_dataModel[$Obj_context.fieldName]:=New object:C1471(\
																"relatedDataClass";$o.relatedDataClass;\
																"relatedTableNumber";$o.relatedTableNumber;\
																"inverseName";$o.inverseName)
															
														End if 
														
														If ($Obj_dataModel[$Obj_context.fieldName][$Txt_fieldNumber]=Null:C1517)
															
															  // Create the field
															$Obj_dataModel[$Obj_context.fieldName][$Txt_fieldNumber]:=New object:C1471(\
																"name";$Obj_related.name;\
																"label";formatString ("label";$Obj_related.name);\
																"shortLabel";formatString ("label";$Obj_related.name);\
																"type";$Obj_related.type;\
																"relatedTableNumber";$Obj_related.relatedTableNumber;\
																"fieldType";$Obj_related.fieldType)
															
														End if 
														
													Else 
														
														  // Remove the field
														If ($Obj_dataModel[$Obj_context.fieldName]#Null:C1517)
															
															If ($Obj_dataModel[$Obj_context.fieldName][$Txt_fieldNumber]#Null:C1517)
																
																OB REMOVE:C1226($Obj_dataModel[$Obj_context.fieldName];$Txt_fieldNumber)
																
															End if 
														End if 
													End if 
												End for each 
												
												  // Checkbox value
												If ($Col_published.length>0)
													
													$Lon_published:=1
													
													If ($Col_published.length#$o.fields.length)
														
														$Lon_published:=2
														
													End if 
												End if 
											End if 
											
											($Obj_form.publishedPtr)->{$Lon_row}:=$Lon_published
											
										End if 
										
									Else 
										
										If (Macintosh command down:C546 | Shift down:C543)
											
											
											
										Else 
											
											  // Invert published status
											($Obj_form.publishedPtr)->{$Lon_row}:=1-($Obj_form.publishedPtr)->{$Lon_row}
											
										End if 
									End if 
									
									STRUCTURE_UPDATE ($Obj_form)
									
								End if 
							End if 
						End if 
					End if 
				End if 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Data Change:K2:15)
				
				LISTBOX GET CELL POSITION:C971(*;$Txt_me;$Lon_column;$Lon_row)
				
				If ($Lon_column=1)
					
					  // Keep current
					$Obj_context.fieldName:=(ui.pointer($Obj_form.fields))->{$Lon_row}
					
					  // Three-state checkbox
					If ($Ptr_me->{$Lon_row}=2)
						
						$Ptr_me->{$Lon_row}:=0
						
					End if 
					
					If (Macintosh command down:C546)
						
						  // Apply the value to all items
						For ($i;1;LISTBOX Get number of rows:C915(*;$Txt_me);1)
							
							$Ptr_me->{$i}:=$Ptr_me->{$Lon_row}
							
						End for 
					End if 
					
					  //#MARK_TODO - use CALL FORM to avoid three-state display
					STRUCTURE_UPDATE ($Obj_form)
					
				End if 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Mouse Enter:K2:33)
				
				ui.tips.enable()
				ui.tips.instantly()
				
				  //______________________________________________________
			: ($Lon_formEvent=On Mouse Move:K2:35)
				
				$Obj_context.setHelpTip($Txt_me;$Obj_form)
				
				  //______________________________________________________
			: ($Lon_formEvent=On Mouse Leave:K2:34)
				
				ui.tips.defaultDelay()
				
				  //______________________________________________________
			: ($Lon_formEvent=On Getting Focus:K2:7)
				
				$Obj_context.focus:=$Obj_form.fields
				
				LISTBOX GET CELL POSITION:C971(*;$Txt_me;$l;$Lon_row)
				
				If ($Lon_row=0)
					
					If (LISTBOX Get number of rows:C915(*;$Txt_me)>0)
						
						LISTBOX SELECT ROW:C912(*;$Txt_me;1;lk replace selection:K53:1)
						
					End if 
				End if 
				
				OBJECT SET RGB COLORS:C628(*;$Txt_me;Foreground color:K23:1;ui.highlightColor;ui.highlightColor)
				
				  // Move search & action [
				ui_MOVE ($Obj_form.search;$Txt_me;Align right:K42:4;30)
				ui_MOVE ($Obj_form.action;$Txt_me;Align right:K42:4;0)
				
				OBJECT SET VISIBLE:C603(*;$Obj_form.fields+".filter";False:C215)
				OBJECT SET VISIBLE:C603(*;$Obj_form.search;True:C214)
				OBJECT SET VISIBLE:C603(*;$Obj_form.action;True:C214)
				  //]
				
				$Ptr_:=ui.pointer($Obj_form.search)
				$Ptr_->value:=String:C10($Obj_context.fieldFilter)
				$Ptr_->:=$Ptr_->  // Touch
				
				  //______________________________________________________
			: ($Lon_formEvent=On Losing Focus:K2:8)
				
				STRUCTURE_Handler (New object:C1471(\
					"action";"fieldFilter"))
				
				OBJECT SET VISIBLE:C603(*;$Obj_form.fields+".filter";True:C214)
				OBJECT SET RGB COLORS:C628(*;$Txt_me;Foreground color:K23:1;0x00FFFFFF;0x00FFFFFF)
				SET TIMER:C645(-1)  // Restore visual selection
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Txt_me=$Obj_form.fieldFilter)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Clicked:K2:4)
				
				  // Get the content type
				If (ST Get content type:C1286(*;$Txt_me;ST Start highlight:K78:13;ST End highlight:K78:14)=ST User type:K78:12)  // This is a user link
					
					$Mnu_main:=Create menu:C408
					
					If (Length:C16(String:C10($Obj_context.fieldFilter))>0)
						
						APPEND MENU ITEM:C411($Mnu_main;Get localized string:C991("structName")+" : ("+$Obj_context.fieldFilter+")";*)
						SET MENU ITEM MARK:C208($Mnu_main;-1;Char:C90(18))
						
					Else 
						
						APPEND MENU ITEM:C411($Mnu_main;":xliff:structName")
						DISABLE MENU ITEM:C150($Mnu_main;-1)
						
					End if 
					
					SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"name")
					
					APPEND MENU ITEM:C411($Mnu_main;":xliff:onlyPublishedFields")
					SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"published")
					
					If (Bool:C1537($Obj_context.fieldFilterPublished))
						
						SET MENU ITEM MARK:C208($Mnu_main;-1;Char:C90(18))
						
					End if 
					
					$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_main)
					RELEASE MENU:C978($Mnu_main)
					
					Case of 
							
							  //………………………………………………………………………………………
						: (Length:C16($Mnu_choice)=0)
							
							  // Nothing selected
							
							  //………………………………………………………………………………………
						: ($Mnu_choice="name")  // Remove name filter
							
							$Obj_context.fieldFilter:=""
							
							structure_FIELD_LIST ($Obj_form)
							
							  //………………………………………………………………………………………
						: ($Mnu_choice="published")  // Add-remove published filter
							
							$Obj_context.fieldFilterPublished:=Not:C34(Bool:C1537($Obj_context.fieldFilterPublished))
							
							structure_FIELD_LIST ($Obj_form)
							
							  //………………………………………………………………………………………
						Else 
							
							ASSERT:C1129(False:C215;"Unknown menu action ("+$Mnu_choice+")")
							
							  //………………………………………………………………………………………
					End case 
					
					STRUCTURE_Handler (New object:C1471(\
						"action";"fieldFilter"))
					
				End if 
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Txt_me=$Obj_form.search)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent<0)  // <SUBFORM EVENTS>
				
				Case of 
						
						  //…………………………………………………………………………………………………
					: ($Lon_formEvent=-1)
						
						  // Filter the vue by name
						If (Not:C34(OB Is empty:C1297($Ptr_me->)))
							
							If ($Obj_context.focus=$Obj_form.tables)
								
								$Obj_context.tableFilter:=$Ptr_me->value
								
								STRUCTURE_Handler (New object:C1471(\
									"action";"tableList"))
								
								STRUCTURE_Handler (New object:C1471(\
									"action";"tableFilter"))
								
							Else   // Fields
								
								$Obj_context.fieldFilter:=$Ptr_me->value
								
								structure_FIELD_LIST ($Obj_form)
								
								If (Length:C16(String:C10($Obj_context.fieldFilter))>0)
									
									  // Create a styled text with a User Link
									$t:=Get localized string:C991("filteredBy")+Char:C90(Space:K15:42)+"<span style=\"-d4-ref-user:'filter'\">"+Get localized string:C991("structName")+"</span>"
									
									ST SET TEXT:C1115(*;$Obj_form.fieldFilter;$t;ST Start text:K78:15;ST End text:K78:16)
									
								Else 
									
									ST SET TEXT:C1115(*;$Obj_form.fieldFilter;"";ST Start text:K78:15;ST End text:K78:16)
									
								End if 
							End if 
						End if 
						
						  //…………………………………………………………………………………………………
					Else 
						
						ASSERT:C1129(False:C215;"Unknown call from subform ("+String:C10($Lon_formEvent)+")")
						
						  //…………………………………………………………………………………………………
				End case 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Getting Focus:K2:7)
				
				OBJECT SET VISIBLE:C603(*;Choose:C955($Obj_context.focus=$Obj_form.tables;$Obj_form.tableFilter;$Obj_form.fieldFilter);False:C215)
				
				  //______________________________________________________
			: ($Lon_formEvent=On Losing Focus:K2:8)
				
				OBJECT SET VISIBLE:C603(*;Choose:C955($Obj_context.focus=$Obj_form.tables;$Obj_form.tableFilter;$Obj_form.fieldFilter);True:C214)
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Txt_me=$Obj_form.action)
		
		STRUCTURE_ACTION ($Obj_form)
		
		  //==================================================
	: ($Txt_me="space.shortcut")
		
		If (Not:C34(editor_Locked ))
			
			  // Check/uncheck the selection
			If (OBJECT Get name:C1087(Object with focus:K67:3)=$Obj_form.fieldList)
				
				  // Check the selection
				$Ptr_me:=ui.pointer($Obj_form.fieldList)
				$Lon_row:=Find in array:C230($Ptr_me->;True:C214)
				
				If ($Lon_row>0)
					
					  // Get the value of the first selected item
					$Ptr_published:=ui.pointer($Obj_form.published)
					$Boo_value:=Bool:C1537($Ptr_published->{$Lon_row})
					
					  // Apply to all selected items
					
					Repeat 
						
						$Lon_x:=Find in array:C230($Ptr_me->;True:C214;$Lon_x+1)
						
						If ($Lon_x>0)
							
							$Ptr_published->{$Lon_x}:=Num:C11(Not:C34($Boo_value))
							
						End if 
					Until ($Lon_x=-1)
				End if 
			End if 
			
			STRUCTURE_UPDATE ($Obj_form)
			
		End if 
		
		  //==================================================
	: ($Txt_me="search.shortcut")
		
		EXECUTE METHOD IN SUBFORM:C1085("search";"Search_HANDLER";*;New object:C1471(\
			"action";"search"))
		
		  //==================================================
	: ($Txt_me="splitter")  // **********************************************
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Clicked:K2:4)
				
				  // Determine the offset
				OBJECT GET COORDINATES:C663(*;$Txt_me;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
				OBJECT GET COORDINATES:C663(*;"_viewport";$l;$Lon_targetTop;$l;$Lon_targetBottom)
				
				$Lon_vOffset:=$Lon_bottom-$Lon_targetBottom
				
				If (($Lon_targetBottom+$Lon_vOffset-$Lon_targetTop)<=200)
					
					  // < Minimum height
					CLEAR VARIABLE:C89($Lon_vOffset)
					
					OBJECT GET SUBFORM CONTAINER SIZE:C1148($Lon_width;$Lon_height)
					$Lon_bottom:=$Lon_height-10
					OBJECT SET COORDINATES:C1248(*;"splitter";0;$Lon_bottom;$Lon_width;$Lon_bottom+1)
					
				Else 
					
					  // Hide the bottom line
					OBJECT SET VISIBLE:C603(*;"bottom.line";False:C215)
					
					CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"resizePanel";New object:C1471(\
						"panel";Current form name:C1298;\
						"offset";$Lon_vOffset))
					
				End if 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Mouse Leave:K2:34)
				
				GET MOUSE:C468($l;$l;$Lon_button)
				
				If ($Lon_button#1)
					
					OBJECT GET SUBFORM CONTAINER SIZE:C1148($Lon_width;$Lon_height)
					$Lon_bottom:=$Lon_height-10
					OBJECT SET COORDINATES:C1248(*;"splitter";0;$Lon_bottom;$Lon_width;$Lon_bottom+1)
					
				End if 
				
				If ($Lon_button=0)
					
					  //  // Place and show the bottom line
					  //OBJECT GET COORDINATES(*;"bottom.line";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
					  //$Lon_top:=$Lon_top+$Lon_vOffset
					  //$Lon_bottom:=$Lon_top
					  //OBJECT SET COORDINATES(*;"bottom.line";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
					  // OBJECT SET VISIBLE(*;"bottom.line";True)
					
					  //  // Force redraw of the window
					  //$Lon_windowRef:=Current form window
					  //GET WINDOW RECT($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Lon_windowRef)
					  //SET WINDOW RECT($Lon_left;$Lon_top;$Lon_right+1;$Lon_bottom;$Lon_windowRef)
					  //SET WINDOW RECT($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Lon_windowRef)
					
				End if 
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown object: \""+$Txt_me+"\"")
		
		  //==================================================
End case 

  //If (Bool(featuresFlags._8858))
  //ui.saveProject()
  //End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End