//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : STRUCTURE_TIPS
  // Database: 4D Mobile App
  // ID[1ACA778192DD48D4898BC23D5CF6FAFC]
  // Created #31-1-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($l;$Lon_field;$Lon_fieldNumber;$Lon_parameters;$Lon_row;$Lon_tableNumber)
C_LONGINT:C283($Lon_x;$Lon_y)
C_TEXT:C284($t;$Txt_;$Txt_name;$Txt_tips)
C_OBJECT:C1216($Obj_dataModel;$Obj_field;$Obj_in;$Obj_relatedDataClass;$Obj_table)
C_COLLECTION:C1488($c;$Col_catalog;$Col_desynchronized;$Col_fields)

If (False:C215)
	C_OBJECT:C1216(STRUCTURE_TIPS ;$1)
End if 

If (False:C215)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	ASSERT:C1129($Obj_in.target#Null:C1517)
	ASSERT:C1129($Obj_in.target#Null:C1517)
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Form:C1466.$dialog.unsynchronizedTableFields#Null:C1517)
	
	GET MOUSE:C468($Lon_x;$Lon_y;$l)
	
	  // Get the list box column and row to know what cell the user hovers
	LISTBOX GET CELL POSITION:C971(*;$Obj_in.target;$Lon_x;$Lon_y;$l;$Lon_row)
	
	If ($Lon_row=0)
		
		  // No item hovered
		
	Else 
		
		  // ASSERT(Not(Shift down)) #ASK VDL, maybe a Trace
		
		$Col_catalog:=editor_Catalog 
		
		$l:=Find in array:C230((ui.pointer($Obj_in.form.tableList))->;True:C214)
		
		If ($l#-1)
			
			$t:=(ui.pointer($Obj_in.form.tables))->{$l}  // Table name
			$l:=$Col_catalog.extract("name").indexOf($t)
			
			If ($l#-1)
				
				$Obj_table:=$Col_catalog[$l]
				
				If ($Obj_table=Null:C1517)
					
					$Txt_tips:=ui.alert+Get localized string:C991("theTableIsNoLongerAvailable")
					
				Else 
					
					If (Num:C11($Obj_table.tableNumber)=0)
						
						  // NOT FOUND INTO THE CURRENT CATALOG
						$Txt_tips:=ui.alert+str_localized (New collection:C1472("theTableNameIsNoLongerAvailable";$Obj_table.name))
						
					Else 
						
						$Col_desynchronized:=Form:C1466.$dialog.unsynchronizedTableFields
						
						If ($Col_desynchronized.length>$Obj_table.tableNumber)
							
							$Col_desynchronized:=$Col_desynchronized[$Obj_table.tableNumber]
							
							If ($Col_desynchronized=Null:C1517)  // Table catalog is OK
								
								  // <NOTHING MORE TO DO>
								
							Else 
								
								If ($Col_desynchronized.length=0)  // Not found into the current catalog
									
									$Txt_tips:=ui.alert+str_localized (New collection:C1472("theTableNameIsNoLongerAvailable";$Obj_table.name))
									
								Else 
									
									  //======================================================================
									  //                                 TABLE LIST
									  //======================================================================
									
									If ($Obj_in.target=$Obj_in.form.tableList)
										
										If ($Col_desynchronized.length=1)
											
											If (Value type:C1509($Col_desynchronized[0])=Is object:K8:27)
												
												  // RELATED DATA CLASS
												
												  // Get the last properties !!!!
												For each ($t;$Col_desynchronized[0])
													
													  //
													
												End for each 
												
												Case of 
														
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
												$Txt_tips:=ui.alert+str_localized (New collection:C1472("theFieldNameIsMissingOrWasModified";$Txt_name))
												
											End if 
											
										Else 
											
											For ($Lon_field;0;$Col_desynchronized.length-1;1)
												
												If (Value type:C1509($Col_desynchronized[$Lon_field])=Is object:K8:27)
													
													  // RELATED DATA CLASS
													
													For each ($Txt_;$Col_desynchronized[$Lon_field])
														
														  //
														
													End for each 
													
													If ($Col_desynchronized[$Lon_field][$Txt_].length>0)
														
														$Lon_x:=$Obj_table.field.extract("name").indexOf($Txt_)
														
														$l:=Num:C11($Col_desynchronized[$Lon_field][$Txt_][0])
														$t:=$t+Field name:C257(Num:C11($Obj_table.field[$Lon_x].relatedTableNumber);$l)+", "
														
													End if 
													
												Else 
													
													$t:=$t+Field name:C257(Num:C11($Obj_table.tableNumber);Num:C11($Col_desynchronized[$Lon_field]))+", "
													
												End if 
											End for 
											
											$Txt_tips:=ui.alert+str_localized (New collection:C1472("someFieldsAreMissingOrWasModified";Substring:C12($t;1;Length:C16($t)-2)))
											
										End if 
									End if 
									
									  //======================================================================
									  //                               FIELD LIST
									  //======================================================================
									
									If ($Obj_in.target=$Obj_in.form.fieldList)
										
										$l:=$Obj_table.field.extract("name").indexOf((ui.pointer($Obj_in.form.fields))->{$Lon_row})
										$Obj_field:=$Obj_table.field[$l]
										
										$l:=$Col_catalog.extract("tableNumber").indexOf($Obj_table.tableNumber)
										$c:=$Col_catalog[$l].field
										
										Case of 
												
												  //______________________________________________________
											: ($Obj_field.type=-1)  // N -> 1 relation
												
												$l:=$Col_catalog.extract("tableNumber").indexOf($Obj_field.relatedTableNumber)
												
												If ($l=-1)  // Not found into the current catalog
													
													$Txt_tips:=ui.alert+str_localized (New collection:C1472("theRelatedTableNameIsNoLongerAvailable";$Obj_field.relatedDataClass))
													
												Else 
													
													If (str_equal ($Obj_field.relatedDataClass;$Col_catalog[$l].name))
														
														  // Check related datamodel
														$l:=$Col_catalog.extract("name").indexOf($Obj_field.relatedDataClass)
														
														If ($l=-1)
															
															$Txt_tips:=ui.alert+str_localized (New collection:C1472("theRelatedTableNameIsNoLongerAvailable";$Obj_field.relatedDataClass))
															
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
																		
																		$Txt_tips:=ui.alert+str_localized (New collection:C1472("theRelatedFieldNameIsNoLongerAvailable";$c[0]))
																		
																	Else 
																		
																		  // Include list
																		$Txt_tips:=ui.alert+str_localized (New collection:C1472("theRelatedFieldsNamesAreNoLongerAvailable";$c.join(", ")))
																		
																	End if 
																End if 
																
															Else 
																
																$Txt_tips:=ui.alert+str_localized (New collection:C1472("theRelationNameIsNoLongerAvailable";$Obj_field.name))
																
															End if 
														End if 
														
													Else 
														
														$Txt_tips:=ui.alert+str_localized (New collection:C1472("theRelatedTableOldWasRenamedToNew";$Obj_field.relatedDataClass;$Col_catalog[$l].name))
														
													End if 
												End if 
												
												  //______________________________________________________
											Else 
												
												$l:=$c.extract("id").indexOf($Obj_field.id)
												
												Case of 
														
														  //……………………………………………………………………………………………………………………
													: ($l=-1)  // Not found into the current catalog
														
														$Txt_tips:=ui.alert+str_localized (New collection:C1472("theFieldNameIsNoLongerAvailable";$Obj_field.name))
														
														  //……………………………………………………………………………………………………………………
													: ($Obj_field.type#$c[$l].type)  // Type mismatch
														
														$Txt_tips:=ui.alert+Get localized string:C991("theFieldTypeWasModified")
														
														  //……………………………………………………………………………………………………………………
													: ($Obj_field.name#$c[$l].name)  // Name mismatch
														
														$Txt_tips:=ui.alert+str_localized (New collection:C1472("theFieldOldWasRenamedToNew";$Obj_field.name;$c[$l].name))
														
														  //……………………………………………………………………………………………………………………
													Else   // Field is OK
														
														  // <NOTHING MORE TO DO>
														
														  //……………………………………………………………………………………………………………………
												End case 
												
												  //______________________________________________________
										End case 
									End if 
								End if 
							End if 
							
						Else   // Table catalog is OK
							
							  // <NOTHING MORE TO DO>
							
						End if 
					End if 
				End if 
			End if 
		End if 
	End if 
End if 

OBJECT SET HELP TIP:C1181(*;$Obj_in.target;$Txt_tips)

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End