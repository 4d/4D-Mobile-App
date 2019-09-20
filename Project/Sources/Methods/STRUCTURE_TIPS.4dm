//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : STRUCTURE_TIPS
  // ID[1ACA778192DD48D4898BC23D5CF6FAFC]
  // Created 31-1-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($l;$Lon_column;$Lon_field;$Lon_fieldNumber;$Lon_row;$Lon_tableNumber)
C_LONGINT:C283($Lon_x;$Lon_y)
C_TEXT:C284($t;$tt;$Txt_name;$Txt_tips)
C_OBJECT:C1216($o;$Obj_dataModel;$Obj_field;$Obj_form;$Obj_relatedDataClass;$Obj_table)
C_COLLECTION:C1488($c;$Col_catalog;$Col_desynchronized;$Col_fields)

If (False:C215)
	C_OBJECT:C1216(STRUCTURE_TIPS ;$1)
End if 

If (False:C215)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=1;"Missing parameter"))
	
	  // Required parameters
	ASSERT:C1129($1.target#Null:C1517)
	ASSERT:C1129($1.form#Null:C1517)
	
	$Obj_form:=$1.form
	
	  // Get the list box column and row to know what cell the user hovers
	GET MOUSE:C468($Lon_x;$Lon_y;$l)
	LISTBOX GET CELL POSITION:C971(*;$1.target;$Lon_x;$Lon_y;$Lon_column;$Lon_row)
	
	$o:=str ()  // init class
	
	C_COLLECTION:C1488($Col_unsynchronizedTableFields)
	$Col_unsynchronizedTableFields:=Form:C1466.$dialog.unsynchronizedTableFields
	ASSERT:C1129(Not:C34(Shift down:C543))
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Lon_row#0) & False:C215
	
	$Obj_table:=This:C1470.currentTable
	
	If ($Obj_table#Null:C1517)
		
		$Col_catalog:=This:C1470.catalog()
		
		  //$l:=$Col_catalog.extract("name").indexOf($Obj_table.name)
		
		$c:=$Col_catalog.query("name=:1";$Obj_table.name)
		
		  //If ($l#-1)
		
		If ($c.length>0)
			
			  //$Obj_table:=$Col_catalog[$l]
			
			$Obj_table:=$c[0]
			
			If ($Obj_table=Null:C1517)
				
				$Txt_tips:=ui.alert+Get localized string:C991("theTableIsNoLongerAvailable")
				
			Else 
				
				If (Num:C11($Obj_table.tableNumber)=0)
					
					  // NOT FOUND INTO THE CURRENT CATALOG
					$Txt_tips:=ui.alert+$o.setText("theTableNameIsNoLongerAvailable").localized($Obj_table.name)
					
				Else 
					
					$Col_desynchronized:=Form:C1466.$dialog.unsynchronizedTableFields
					
					If ($Col_desynchronized.length>$Obj_table.tableNumber)
						
						$Col_desynchronized:=$Col_desynchronized[$Obj_table.tableNumber]
						
						If ($Col_desynchronized=Null:C1517)  // Table catalog is OK
							
							  // <NOTHING MORE TO DO>
							
						Else 
							
							If ($Col_desynchronized.length=0)  // Not found into the current catalog
								
								$Txt_tips:=ui.alert+$o.setText("theTableNameIsNoLongerAvailable").localized($Obj_table.name)
								
							Else 
								
								Case of 
										
										  //______________________________________________________
									: ($1.target=$Obj_form.tableList)  // TABLE LIST
										
										If ($Col_desynchronized.length=1)
											
											If (Value type:C1509($Col_desynchronized[0])=Is object:K8:27)
												
												  // RELATED DATA CLASS
												
												  // Get the last properties !!!!
												For each ($t;$Col_desynchronized[0])
													
													  //
													
												End for each 
												
												Case of 
														
														  //______________________________________________________
													: (Value type:C1509($Col_desynchronized[0])=Is object:K8:27)  // 1 -> N relation
														
														$Txt_tips:=ui.alert+".The relation \""+$t+"\" is no more available"
														
														  //______________________________________________________
													: ($Col_desynchronized[0][$t].length=0)  // the related table is no more available
														
														$Txt_tips:=ui.alert+Get localized string:C991("theRelatedTableIsNoLongerAvailable")
														
														  //______________________________________________________
													: ($Col_desynchronized[0][$t].length=1)
														
														$Lon_tableNumber:=$Obj_table.field[$Obj_table.field.extract("name").indexOf($t)].relatedTableNumber
														$Lon_fieldNumber:=Num:C11($Col_desynchronized[0][$t][0])
														$Txt_name:=Field name:C257($Lon_tableNumber;$Lon_fieldNumber)
														$Txt_tips:=ui.alert+".The related field '"+$Txt_name+"' is missing or was modified"
														
														  //______________________________________________________
													Else 
														
														$Txt_tips:=ui.alert+Get localized string:C991("someRelatedFieldsAreNoLongerAvailableOrWasModified")
														
														  //______________________________________________________
												End case 
												
											Else 
												
												$Lon_tableNumber:=$Obj_table.tableNumber
												$Lon_fieldNumber:=Num:C11($Col_desynchronized[0])
												$Txt_name:=Field name:C257($Lon_tableNumber;$Lon_fieldNumber)
												$Txt_tips:=ui.alert+$o.setText("theFieldNameIsMissingOrWasModified").localized($Txt_name)
												
											End if 
											
										Else 
											
											For ($Lon_field;0;$Col_desynchronized.length-1;1)
												
												If (Value type:C1509($Col_desynchronized[$Lon_field])=Is object:K8:27)
													
													  // RELATED DATA CLASS
													
													For each ($tt;$Col_desynchronized[$Lon_field])
														
														  //
														
													End for each 
													
													If ($Col_desynchronized[$Lon_field][$tt].length>0)
														
														$Lon_x:=$Obj_table.field.extract("name").indexOf($tt)
														
														$l:=Num:C11($Col_desynchronized[$Lon_field][$tt][0])
														$t:=$t+Field name:C257(Num:C11($Obj_table.field[$Lon_x].relatedTableNumber);$l)+", "
														
													End if 
													
												Else 
													
													$t:=$t+Field name:C257(Num:C11($Obj_table.tableNumber);Num:C11($Col_desynchronized[$Lon_field]))+", "
													
												End if 
											End for 
											
											$Txt_tips:=ui.alert+$o.setText("someFieldsAreMissingOrWasModified").localized(Substring:C12($t;1;Length:C16($t)-2))
											
										End if 
										
										  //______________________________________________________
									: ($1.target=$Obj_form.fieldList)  // FIELD LIST
										
										
										ASSERT:C1129(Not:C34(Shift down:C543))
										$l:=$Obj_table.field.extract("name").indexOf((ui.pointer($Obj_form.fields))->{$Lon_row})
										
										If ($l#-1)
											
											$Obj_field:=$Obj_table.field[$l]
											
											$l:=$Col_catalog.extract("tableNumber").indexOf($Obj_table.tableNumber)
											$c:=$Col_catalog[$l].field
											
											Case of 
													
													  //______________________________________________________
												: ($Obj_field.type=-1)  // N -> 1 relation
													
													$l:=$Col_catalog.extract("tableNumber").indexOf($Obj_field.relatedTableNumber)
													
													If ($l=-1)  // Not found into the current catalog
														
														$Txt_tips:=ui.alert+$o.setText("theRelatedTableNameIsNoLongerAvailable").localized($Obj_field.relatedDataClass)
														
													Else 
														
														If ($o.setText($Obj_field.relatedDataClass).equal($Col_catalog[$l].name))
															
															  // Check related datamodel
															$l:=$Col_catalog.extract("name").indexOf($Obj_field.relatedDataClass)
															
															If ($l=-1)
																
																$Txt_tips:=ui.alert+$o.setText("theRelatedTableNameIsNoLongerAvailable").localized($Obj_field.relatedDataClass)
																
															Else 
																
																$Obj_dataModel:=Form:C1466.dataModel[String:C10($Obj_table.tableNumber)][$Obj_field.name]
																
																$l:=$Col_catalog.extract("tableNumber").indexOf($Obj_field.relatedTableNumber)
																$Col_fields:=$Col_catalog[$l].field
																
																If ($Obj_dataModel#Null:C1517)
																	
																	$c:=New collection:C1472
																	
																	For each ($t;$Obj_dataModel)
																		
																		Case of 
																				
																				  //…………………………………………………………………………………………
																			: (Match regex:C1019("(?m-si)^\\d+$";$t;1;*))  // fieldNumber
																				
																				If ($Col_fields.extract("id").indexOf(Num:C11($t))=-1)
																					
																					$c.push($Obj_dataModel[$t].name)
																					
																				Else 
																					
																					  //
																					
																				End if 
																				
																				  //…………………………………………………………………………………………
																			: ((Value type:C1509($Obj_relatedDataClass[$t])#Is object:K8:27))
																				
																				  // <NOTHING MORE TO DO>
																				
																				  //…………………………………………………………………………………………
																			Else 
																				
																				  // NOT YET MANAGED
																				
																				  //…………………………………………………………………………………………
																		End case 
																	End for each 
																	
																	If ($c.length>0)
																		
																		If ($c.length=1)
																			
																			$Txt_tips:=ui.alert+$o.setText("theRelatedFieldNameIsNoLongerAvailable").localized($c[0])
																			
																		Else 
																			
																			  // Include list
																			$Txt_tips:=ui.alert+$o.setText("theRelatedFieldsNamesAreNoLongerAvailable").localized($c.join(", "))
																			
																		End if 
																	End if 
																	
																Else 
																	
																	$Txt_tips:=ui.alert+$o.setText("theRelationNameIsNoLongerAvailable").localized($Obj_field.name)
																	
																End if 
															End if 
															
														Else 
															
															$Txt_tips:=ui.alert+$o.setText("theRelatedTableOldWasRenamedToNew").localized(New collection:C1472($Obj_field.relatedDataClass;$Col_catalog[$l].name))
															
														End if 
													End if 
													
													
													  //______________________________________________________
												: ($Obj_field.type=-2)  // 1 -> N relation
													
													$l:=$c.extract("name").indexOf($Obj_field.name)
													
													Case of 
															
															  //……………………………………………………………………………………………………………………
														: ($l=-1)  // Not found into the current catalog
															
															$Txt_tips:=ui.alert+$o.setText("theRelationNameIsNoLongerAvailable").localized($Obj_field.name)
															
															
													End case 
													
													
													  //______________________________________________________
												Else 
													
													$l:=$c.extract("id").indexOf($Obj_field.id)
													
													Case of 
															
															  //……………………………………………………………………………………………………………………
														: ($l=-1)  // Not found into the current catalog
															
															$Txt_tips:=ui.alert+$o.setText("theFieldNameIsNoLongerAvailable").localized($Obj_field.name)
															
															  //……………………………………………………………………………………………………………………
														: ($Obj_field.type#$c[$l].type)  // Type mismatch
															
															$Txt_tips:=ui.alert+Get localized string:C991("theFieldTypeWasModified")
															
															  //……………………………………………………………………………………………………………………
														: ($Obj_field.name#$c[$l].name)  // Name mismatch
															
															$Txt_tips:=ui.alert+$o.setText("theFieldOldWasRenamedToNew").localized($Obj_field.name;$c[$l].name)
															
															  //……………………………………………………………………………………………………………………
														Else   // Field is OK
															
															  // <NOTHING MORE TO DO>
															
															  //……………………………………………………………………………………………………………………
													End case 
													
													  //______________________________________________________
											End case 
											
										Else 
											
											  // A "If" statement should never omit "Else"
											
										End if 
										
										  //______________________________________________________
								End case 
							End if 
						End if 
						
					Else 
						
						  // TABLE CATALOG IS OK - DISPLAY USEFUL INFORMATIONS IF ANY
						
						$Obj_dataModel:=Form:C1466.dataModel
						
						Case of 
								
								  //______________________________________________________
							: ($1.target=$Obj_form.tableList)
								
								  //
								
								  //______________________________________________________
							: ($1.target=$Obj_form.fieldList)
								
								$l:=$Obj_table.field.extract("name").indexOf((ui.pointer($Obj_form.fields))->{$Lon_row})
								
								If ($l#-1)
									
									$Obj_field:=$Obj_table.field[$l]
									
									Case of 
											
											  //…………………………………………………………………………………………………
										: ($Obj_field.type=-1)  // N -> 1 relation
											
											  // Related dataclass name
											$Txt_tips:=$o.setText("nTo1Relation").localized($Obj_field.relatedDataClass)
											
											If ($Obj_field.relatedDataClass=$Obj_table.name)  // Recursive link
												
												  // Recursive link
												$Txt_tips:=$Txt_tips+" ("+Get localized string:C991("recursive")+")"
												
											End if 
											
											$Txt_tips:=$Txt_tips+"\r• "+Choose:C955($Lon_column=1;\
												$o.setText("youCanEnableDisableThePublishOfAllRelatedFieldsByClickingHere").localized(Choose:C955($Obj_form.publishedPtr->{$Lon_row}#0;"disable";"enable"));\
												Get localized string:C991("clickHereToSelectThePublishedFields"))
											
											  //…………………………………………………………………………………………………
										: ($Obj_field.type=-2)  // 1 -> N relation
											
											If ($Obj_dataModel[String:C10($Obj_field.relatedTableNumber)]=Null:C1517)
												
												If (Bool:C1537((ui.pointer($Obj_form.published))->{$Lon_row}))
													
													  // Error
													$Txt_tips:=ui.alert+$o.setText("theLinkedTableIsNotPublished").localized($Obj_field.relatedDataClass)
													
												Else 
													
													$Txt_tips:=$o.setText("1toNRelation").localized($Obj_field.relatedDataClass)
													
													If ($Obj_field.relatedDataClass=$Obj_table.name)
														
														  // Recursive link
														$Txt_tips:=$Txt_tips+" ("+Get localized string:C991("recursive")+")"
														
													Else 
														
														  // Unpublished related dataclass
														$Txt_tips:=$Txt_tips+" ("+Get localized string:C991("unpublished")+")"
														
													End if 
												End if 
												
											Else 
												
												  // Related dataclass name
												$Txt_tips:=$o.setText("1toNRelation").localized($Obj_field.relatedDataClass)
												
												If ($Obj_field.relatedDataClass=$Obj_table.name)  // Recursive link
													
													  // Recursive link
													$Txt_tips:=$Txt_tips+" ("+Get localized string:C991("recursive")+")"
													
												End if 
											End if 
											
											  //…………………………………………………………………………………………………
										Else 
											
											If ($Obj_field.name=$Obj_table.primaryKey)
												
												$Txt_tips:=Get localized string:C991("primaryKey")
												
											End if 
											
											  //…………………………………………………………………………………………………
									End case 
									
								Else 
									
									  // SHOULD NOT, BUT COULD
									
								End if 
								
								  //______________________________________________________
						End case 
					End if 
				End if 
			End if 
			
		Else 
			
			  // TABLE NOT IN CATALOG
			$Txt_tips:=ui.alert+Get localized string:C991("theTableIsNoLongerAvailable")
			
		End if 
		
	Else 
		
		  // NO TABLE SELECTED
		
	End if 
	
Else 
	
	  // NO ITEM HOVERED
	
End if 

OBJECT SET HELP TIP:C1181(*;$1.target;$Txt_tips)

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End