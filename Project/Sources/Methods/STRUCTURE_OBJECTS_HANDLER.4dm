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
C_BOOLEAN:C305($b)
C_LONGINT:C283($bottom;$column;$height;$i;$indx;$l)
C_LONGINT:C283($left;$Lon_button;$Lon_number;$Lon_published;$Lon_targetBottom;$Lon_targetTop)
C_LONGINT:C283($Lon_unpublished;$Lon_vOffset;$right;$row;$top;$width)
C_LONGINT:C283($Win_hdl)
C_POINTER:C301($Ptr_;$Ptr_me;$Ptr_published)
C_TEXT:C284($t;$Txt_fieldNumber)
C_OBJECT:C1216($context;$e;$form;$menu;$o;$Obj_dataModel)
C_OBJECT:C1216($Obj_related)
C_COLLECTION:C1488($c;$Col_published)

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606

$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)

$form:=STRUCTURE_Handler(New object:C1471(\
"action";"init"))

$context:=$form.form

// ----------------------------------------------------
Case of 
		
		//==================================================
	: ($e.objectName=$form.allow)
		
		project.save()
		
		//==================================================
	: ($e.objectName=$form.allowHelp)
		
		OPEN URL:C673(Get localized string:C991("doc_incremental");*)
		
		//==================================================
	: ($e.objectName=$form.tableList)
		
		LISTBOX GET CELL POSITION:C971(*;$e.objectName;$column;$row)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Selection Change:K2:29)
				
				editor_ui_LISTBOX($e.objectName)
				
				If ($row=0)
					
					OB REMOVE:C1226($context;"currentTable")
					
				Else 
					
					// Keep the current selected table
					$c:=editor_Catalog
					$context.currentTable:=$c[$c.indices("name=:1";(ui.pointer($form.tables))->{$row})[0]]
					
				End if 
				
				// Update field list
				structure_FIELD_LIST($form)
				
				//______________________________________________________
			: ($e.code=On Clicked:K2:4)
				
				If (Right click:C712)
					
					If ($row=0)
						
						OB REMOVE:C1226($context;"currentTable")
						
					Else 
						
						LISTBOX SELECT ROW:C912(*;$e.objectName;$row;lk replace selection:K53:1)
						
						$c:=editor_Catalog
						$o:=$c[$c.indices("name=:1";(ui.pointer($form.tables))->{$row})[0]]
						
						If (Not:C34(ob_equal($o;$context.currentTable)))
							
							// Update the current selected table
							$context.currentTable:=$o
							
							// Update field list
							structure_FIELD_LIST($form)
							
						End if 
						
						$Ptr_published:=ui.pointer($form.published)
						$Lon_unpublished:=Count in array:C907($Ptr_published->;0)
						
						$menu:=cs:C1710.menu.new()
						
						If ($Lon_unpublished>0)
							
							$menu.append("publishAll";"publishAll")
							
						End if 
						
						If ($Lon_unpublished#Size of array:C274($Ptr_published->))
							
							$menu.append("unpublishAll";"unpublishAll")
							
						End if 
						
						$menu.popup()
						
						If ($menu.selected)
							
							Case of 
									
									//………………………………………………………………………………………
								: ($menu.choice="publishAll")\
									 | ($menu.choice="unpublishAll")
									
									//#MARK_TODO - management of relatedDataClass
									
									$b:=($menu.choice="publishAll")
									
									For ($i;1;Size of array:C274($Ptr_published->);1)
										
										$Ptr_published->{$i}:=Num:C11($b)
										
									End for 
									
									STRUCTURE_UPDATE($form)
									
									//………………………………………………………………………………………
								Else 
									
									ASSERT:C1129(False:C215;"Unknown menu action ("+$menu.choice+")")
									
									//………………………………………………………………………………………
							End case 
						End if 
					End if 
				End if 
				
				//______________________________________________________
			: ($e.code=On Mouse Enter:K2:33)
				
				ui.tips.instantly(100)
				
				//______________________________________________________
			: ($e.code=On Mouse Move:K2:35)
				
				$context.setHelpTip($e.objectName;$form)
				
				//______________________________________________________
			: ($e.code=On Mouse Leave:K2:34)
				
				ui.tips.default()
				
				//______________________________________________________
			: ($e.code=On Getting Focus:K2:7)
				
				$context.focus:=$form.tables
				
				If (LISTBOX Get number of rows:C915(*;$e.objectName)>0)
					
					LISTBOX GET CELL POSITION:C971(*;$e.objectName;$l;$row)
					
					If ($row=0)
						
						LISTBOX SELECT ROW:C912(*;$e.objectName;1;lk replace selection:K53:1)
						
					End if 
				End if 
				
				OBJECT SET RGB COLORS:C628(*;$e.objectName;Foreground color:K23:1;ui.highlightColor;ui.highlightColor)
				
				structure_FIELD_LIST($form)
				
				ui_MOVE($form.search;$e.objectName;Align right:K42:4;30)
				ui_MOVE($form.action;$e.objectName;Align right:K42:4;0)
				
				OBJECT SET VISIBLE:C603(*;$form.tables+".filter";False:C215)
				OBJECT SET VISIBLE:C603(*;$form.search;True:C214)
				OBJECT SET VISIBLE:C603(*;$form.action;True:C214)
				//]
				
				$Ptr_:=ui.pointer($form.search)
				$Ptr_->value:=String:C10($context.tableFilter)
				$Ptr_->:=$Ptr_->// Touch
				
				STRUCTURE_Handler(New object:C1471(\
					"action";"fieldFilter";\
					"showIfNotEmpty";True:C214))
				
				//______________________________________________________
			: ($e.code=On Losing Focus:K2:8)
				
				STRUCTURE_Handler(New object:C1471(\
					"action";"tableFilter"))
				
				OBJECT SET VISIBLE:C603(*;$form.tableFilter;True:C214)
				OBJECT SET RGB COLORS:C628(*;$e.objectName;Foreground color:K23:1;0x00FFFFFF;0x00FFFFFF)
				SET TIMER:C645(-1)// Restore visual selection
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($e.objectName=$form.tableFilter)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Clicked:K2:4)
				
				// Get the content type
				If (ST Get content type:C1286(*;$e.objectName;ST Start highlight:K78:13;ST End highlight:K78:14)=ST User type:K78:12)// This is a user link
					
					$menu:=cs:C1710.menu.new()
					
					If (Length:C16(String:C10($context.tableFilter))>0)
						
						$menu.append(Get localized string:C991("structName")+" : ("+$context.tableFilter+")";"name").mark()
						
					Else 
						
						$menu.append("structName";"name").disable()
						
					End if 
					
					$menu.append("onlyPublishedTables";"published").mark(Bool:C1537($context.tableFilterPublished))
					
					$menu.popup()
					
					Case of 
							
							//………………………………………………………………………………………
						: (Not:C34($menu.selected))
							
							// Nothing selected
							
							//………………………………………………………………………………………
						: ($menu.choice="name")// Remove name filter
							
							$context.tableFilter:=""
							
							STRUCTURE_Handler(New object:C1471(\
								"action";"tableList"))
							
							//………………………………………………………………………………………
						: ($menu.choice="published")// Add-remove published filter
							
							$context.tableFilterPublished:=Not:C34(Bool:C1537($context.tableFilterPublished))
							
							STRUCTURE_Handler(New object:C1471(\
								"action";"tableList"))
							
							//………………………………………………………………………………………
						Else 
							
							ASSERT:C1129(False:C215;"Unknown menu action ("+$menu.choice+")")
							
							//………………………………………………………………………………………
					End case 
					
					STRUCTURE_Handler(New object:C1471(\
						"action";"tableFilter"))
					
				End if 
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($e.objectName=$form.fieldList)
		
		LISTBOX GET CELL POSITION:C971(*;$e.objectName;$column;$row)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Selection Change:K2:29)\
				 | ($e.code=On Clicked:K2:4)
				
				editor_ui_LISTBOX($e.objectName)
				
				If ($row=0)
					
					OB REMOVE:C1226($context;"fieldName")
					
				Else 
					
					// Keep the current field name
					$context.fieldName:=(ui.pointer($form.fields))->{$row}
					
					If ($e.code=On Clicked:K2:4)
						
						If (Right click:C712)
							
							//#MARK_TODO - CONTEXTUAL MENU PUBLISH/UNPBLISH {ALL}
							
						Else 
							
							If ($row>0)
								
								If ($column=3)// & (Bool(featuresFlags._101637))
									
									If (Not:C34(editor_Locked))
										
										//#MARK_TO_OPTIMIZE
										$o:=structure(New object:C1471(\
											"action";"relatedCatalog";\
											"table";String:C10($context.currentTable.name);\
											"relatedEntity";$context.fieldName))
										
										If ($o.success)// Open field picker
											
											$Obj_dataModel:=Form:C1466.dataModel[String:C10($context.currentTable.tableNumber)][$o.relatedEntity]
											
											For each ($Obj_related;$o.fields)
												
												$Obj_related.published:=($Obj_dataModel[String:C10($Obj_related.fieldNumber)]#Null:C1517)
												$Obj_related.icon:=UI.fieldIcons[$Obj_related.fieldType]
												
											End for each 
											
											$Win_hdl:=Open form window:C675("RELATED";Sheet form window:K39:12;*)
											DIALOG:C40("RELATED";$o)
											
											If ($o.success)// Dialog was validated
												
												// If at least one related field is published
												If ($o.fields.extract("published").indexOf(True:C214)#-1)
													
													$Obj_dataModel:=Form:C1466.dataModel[String:C10($context.currentTable.tableNumber)]
													
													If ($Obj_dataModel=Null:C1517)\
														 | OB Is empty:C1297($Obj_dataModel)
														
														$Obj_dataModel:=STRUCTURE_Handler(New object:C1471(\
															"action";"addTable"))
														
													End if 
													
													$Col_published:=New collection:C1472
													
													For each ($Obj_related;$o.fields)
														
														$Lon_number:=$Lon_number+1
														$Txt_fieldNumber:=String:C10($Obj_related.fieldNumber)
														
														If ($Obj_related.published)
															
															$Col_published.push($Obj_related)
															
															If ($Obj_dataModel[$context.fieldName]=Null:C1517)
																
																// Create the relation
																$Obj_dataModel[$context.fieldName]:=New object:C1471(\
																	"relatedDataClass";$o.relatedDataClass;\
																	"relatedTableNumber";$o.relatedTableNumber;\
																	"inverseName";$o.inverseName)
																
															End if 
															
															If ($Obj_dataModel[$context.fieldName][$Txt_fieldNumber]=Null:C1517)
																
																// Create the field
																$Obj_dataModel[$context.fieldName][$Txt_fieldNumber]:=New object:C1471(\
																	"name";$Obj_related.name;\
																	"label";formatString("label";$Obj_related.name);\
																	"shortLabel";formatString("label";$Obj_related.name);\
																	"type";$Obj_related.type;\
																	"relatedTableNumber";$Obj_related.relatedTableNumber;\
																	"fieldType";$Obj_related.fieldType)
																
															End if 
															
														Else 
															
															// Remove the field
															If ($Obj_dataModel[$context.fieldName]#Null:C1517)
																
																If ($Obj_dataModel[$context.fieldName][$Txt_fieldNumber]#Null:C1517)
																	
																	OB REMOVE:C1226($Obj_dataModel[$context.fieldName];$Txt_fieldNumber)
																	
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
												
												($form.publishedPtr)->{$row}:=$Lon_published
												
											End if 
											
										Else 
											
											If (Macintosh command down:C546 | Shift down:C543)
												
												//
												
											Else 
												
												// Invert published status
												($form.publishedPtr)->{$row}:=1-($form.publishedPtr)->{$row}
												
											End if 
										End if 
										
										STRUCTURE_UPDATE($form)
										
									End if 
								End if 
							End if 
						End if 
					End if 
				End if 
				
				//______________________________________________________
			: ($e.code=On Data Change:K2:15)
				
				LISTBOX GET CELL POSITION:C971(*;$e.objectName;$column;$row)
				
				If ($column=1)
					
					// Keep current
					$context.fieldName:=(ui.pointer($form.fields))->{$row}
					
					// Three-state checkbox
					If ($Ptr_me->{$row}=2)
						
						$Ptr_me->{$row}:=0
						
					End if 
					
					If (Macintosh command down:C546)// Apply the value to all items
						
						For ($i;1;LISTBOX Get number of rows:C915(*;$e.objectName);1)
							
							$Ptr_me->{$i}:=$Ptr_me->{$row}
							
						End for 
					End if 
					
					//#MARK_TODO - use CALL FORM to avoid three-state display
					STRUCTURE_UPDATE($form)
					
					If ($Ptr_me->{$row}=0)
						
						project.updateActions()
						
					End if 
				End if 
				
				//______________________________________________________
			: ($e.code=On Mouse Enter:K2:33)
				
				ui.tips.instantly(100)
				
				//______________________________________________________
			: ($e.code=On Mouse Move:K2:35)
				
				$context.setHelpTip($e.objectName;$form)
				
				//______________________________________________________
			: ($e.code=On Mouse Leave:K2:34)
				
				OBJECT SET HELP TIP:C1181(*;$e.objectName;"")
				ui.tips.default()
				
				//______________________________________________________
			: ($e.code=On Getting Focus:K2:7)
				
				$context.focus:=$form.fields
				
				LISTBOX GET CELL POSITION:C971(*;$e.objectName;$l;$row)
				
				If ($row=0)
					
					If (LISTBOX Get number of rows:C915(*;$e.objectName)>0)
						
						LISTBOX SELECT ROW:C912(*;$e.objectName;1;lk replace selection:K53:1)
						
					End if 
				End if 
				
				OBJECT SET RGB COLORS:C628(*;$e.objectName;Foreground color:K23:1;ui.highlightColor;ui.highlightColor)
				
				// Move search & action [
				ui_MOVE($form.search;$e.objectName;Align right:K42:4;30)
				ui_MOVE($form.action;$e.objectName;Align right:K42:4;0)
				
				OBJECT SET VISIBLE:C603(*;$form.fields+".filter";False:C215)
				OBJECT SET VISIBLE:C603(*;$form.search;True:C214)
				OBJECT SET VISIBLE:C603(*;$form.action;True:C214)
				//]
				
				$Ptr_:=ui.pointer($form.search)
				$Ptr_->value:=String:C10($context.fieldFilter)
				$Ptr_->:=$Ptr_->// Touch
				
				//______________________________________________________
			: ($e.code=On Losing Focus:K2:8)
				
				STRUCTURE_Handler(New object:C1471(\
					"action";"fieldFilter"))
				
				OBJECT SET VISIBLE:C603(*;$form.fields+".filter";True:C214)
				OBJECT SET RGB COLORS:C628(*;$e.objectName;Foreground color:K23:1;0x00FFFFFF;0x00FFFFFF)
				SET TIMER:C645(-1)// Restore visual selection
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($e.objectName=$form.fieldFilter)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Clicked:K2:4)
				
				// Get the content type
				If (ST Get content type:C1286(*;$e.objectName;ST Start highlight:K78:13;ST End highlight:K78:14)=ST User type:K78:12)// This is a user link
					
					$menu:=cs:C1710.menu.new()
					
					If (Length:C16(String:C10($context.fieldFilter))>0)
						
						$menu.append(Get localized string:C991("structName")+" : ("+$context.fieldFilter+")";"name").mark()
						
					Else 
						
						$menu.append("structName";"name").disable()
						
					End if 
					
					$menu.append("onlyPublishedFields";"published").mark(Bool:C1537($context.fieldFilterPublished))
					
					$menu.popup()
					
					Case of 
							
							//………………………………………………………………………………………
						: (Not:C34($menu.selected))
							
							// Nothing selected
							
							//………………………………………………………………………………………
						: ($menu.choice="name")// Remove name filter
							
							$context.fieldFilter:=""
							
							structure_FIELD_LIST($form)
							
							//………………………………………………………………………………………
						: ($menu.choice="published")// Add-remove published filter
							
							$context.fieldFilterPublished:=Not:C34(Bool:C1537($context.fieldFilterPublished))
							
							structure_FIELD_LIST($form)
							
							//………………………………………………………………………………………
						Else 
							
							ASSERT:C1129(False:C215;"Unknown menu action ("+$menu.choice+")")
							
							//………………………………………………………………………………………
					End case 
					
					STRUCTURE_Handler(New object:C1471(\
						"action";"fieldFilter"))
					
				End if 
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($e.objectName=$form.search)
		
		Case of 
				
				//______________________________________________________
			: ($e.code<0)// <SUBFORM EVENTS>
				
				Case of 
						
						//…………………………………………………………………………………………………
					: ($e.code=-1)
						
						// Filter the vue by name
						If (Not:C34(OB Is empty:C1297($Ptr_me->)))
							
							If ($context.focus=$form.tables)
								
								$context.tableFilter:=$Ptr_me->value
								
								STRUCTURE_Handler(New object:C1471(\
									"action";"tableList"))
								
								STRUCTURE_Handler(New object:C1471(\
									"action";"tableFilter"))
								
							Else // Fields
								
								$context.fieldFilter:=$Ptr_me->value
								
								structure_FIELD_LIST($form)
								
								If (Length:C16(String:C10($context.fieldFilter))>0)
									
									// Create a styled text with a User Link
									$t:=Get localized string:C991("filteredBy")+Char:C90(Space:K15:42)+"<span style=\"-d4-ref-user:'filter'\">"+Get localized string:C991("structName")+"</span>"
									
									ST SET TEXT:C1115(*;$form.fieldFilter;$t;ST Start text:K78:15;ST End text:K78:16)
									
								Else 
									
									ST SET TEXT:C1115(*;$form.fieldFilter;"";ST Start text:K78:15;ST End text:K78:16)
									
								End if 
							End if 
						End if 
						
						//…………………………………………………………………………………………………
					Else 
						
						ASSERT:C1129(False:C215;"Unknown call from subform ("+$e.description+")")
						
						//…………………………………………………………………………………………………
				End case 
				
				//______________________________________________________
			: ($e.code=On Getting Focus:K2:7)
				
				OBJECT SET VISIBLE:C603(*;Choose:C955($context.focus=$form.tables;$form.tableFilter;$form.fieldFilter);False:C215)
				
				//______________________________________________________
			: ($e.code=On Losing Focus:K2:8)
				
				OBJECT SET VISIBLE:C603(*;Choose:C955($context.focus=$form.tables;$form.tableFilter;$form.fieldFilter);True:C214)
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($e.objectName=$form.action)
		
		STRUCTURE_ACTION($form)
		
		//==================================================
	: ($e.objectName="space.shortcut")
		
		If (Not:C34(editor_Locked))
			
			// Check/uncheck the selection
			If (OBJECT Get name:C1087(Object with focus:K67:3)=$form.fieldList)
				
				// Check the selection
				$Ptr_me:=ui.pointer($form.fieldList)
				$row:=Find in array:C230($Ptr_me->;True:C214)
				
				If ($row>0)
					
					// Get the value of the first selected item
					$Ptr_published:=ui.pointer($form.published)
					$b:=Bool:C1537($Ptr_published->{$row})
					
					// Apply to all selected items
					
					Repeat 
						
						$indx:=Find in array:C230($Ptr_me->;True:C214;$indx+1)
						
						If ($indx>0)
							
							$Ptr_published->{$indx}:=Num:C11(Not:C34($b))
							
						End if 
					Until ($indx=-1)
				End if 
			End if 
			
			STRUCTURE_UPDATE($form)
			
		End if 
		
		//==================================================
	: ($e.objectName="search.shortcut")
		
		EXECUTE METHOD IN SUBFORM:C1085("search";"Search_HANDLER";*;New object:C1471(\
			"action";"search"))
		
		//==================================================
	: ($e.objectName="splitter")// **********************************************
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Clicked:K2:4)
				
				// Determine the offset
				OBJECT GET COORDINATES:C663(*;$e.objectName;$left;$top;$right;$bottom)
				OBJECT GET COORDINATES:C663(*;"_viewport";$l;$Lon_targetTop;$l;$Lon_targetBottom)
				
				$Lon_vOffset:=$bottom-$Lon_targetBottom
				
				If (($Lon_targetBottom+$Lon_vOffset-$Lon_targetTop)<=200)
					
					// < Minimum height
					CLEAR VARIABLE:C89($Lon_vOffset)
					
					OBJECT GET SUBFORM CONTAINER SIZE:C1148($width;$height)
					$bottom:=$height-10
					OBJECT SET COORDINATES:C1248(*;"splitter";0;$bottom;$width;$bottom+1)
					
				Else 
					
					// Hide the bottom line
					OBJECT SET VISIBLE:C603(*;"bottom.line";False:C215)
					
					CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"resizePanel";New object:C1471(\
						"panel";Current form name:C1298;\
						"offset";$Lon_vOffset))
					
				End if 
				
				//______________________________________________________
			: ($e.code=On Mouse Leave:K2:34)
				
				GET MOUSE:C468($l;$l;$Lon_button)
				
				If ($Lon_button#1)
					
					OBJECT GET SUBFORM CONTAINER SIZE:C1148($width;$height)
					$bottom:=$height-10
					OBJECT SET COORDINATES:C1248(*;"splitter";0;$bottom;$width;$bottom+1)
					
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
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown object: \""+$e.objectName+"\"")
		
		//==================================================
End case 