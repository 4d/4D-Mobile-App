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

C_LONGINT:C283($l; $Lon_column; $Lon_row; $Lon_x; $Lon_y)
C_TEXT:C284($Txt_tips)
C_OBJECT:C1216($o; $Obj_dataModel; $Obj_field; $form; $Obj_table; $str)
C_COLLECTION:C1488($c; $Col_catalog; $Col_desynchronized)

If (False:C215)
	C_OBJECT:C1216(STRUCTURE_TIPS; $1)
End if 

If (False:C215)
End if 

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	ASSERT:C1129($1.target#Null:C1517)
	ASSERT:C1129($1.form#Null:C1517)
	
	$form:=$1.form
	
	// Get the list box column and row to know what cell the user hovers
	GET MOUSE:C468($Lon_x; $Lon_y; $l)
	LISTBOX GET CELL POSITION:C971(*; $1.target; $Lon_x; $Lon_y; $Lon_column; $Lon_row)
	
	$str:=_o_str()  // init class
	
	$Col_catalog:=This:C1470.catalog()
	
	//ASSERT(Not(Shift down))
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If ($Lon_row>0)  // & ($Lon_row<=Size of array((OBJECT Get pointer(Object named;"tables"))->))
	
	If ($1.target=$form.tableList)
		
		$c:=$Col_catalog.query("name=:1"; (OBJECT Get pointer:C1124(Object named:K67:5; "tables"))->{$Lon_row})
		
	Else 
		
		// Get current table
		$c:=$Col_catalog.query("name=:1"; $form.form.currentTable.name)
		
	End if 
	
	If ($c.length>0)
		
		$Obj_table:=$c[0]
		
		$Col_desynchronized:=Form:C1466.$dialog.unsynchronizedTableFields
		
		If ($Col_desynchronized.length>$Obj_table.tableNumber)
			
			// Restrict to the table
			$Col_desynchronized:=$Col_desynchronized[$Obj_table.tableNumber]
			
			If ($Col_desynchronized=Null:C1517)
				
				// TABLE IS OK
				
			Else 
				
				If ($Col_desynchronized.length=0)  // Not found into the current catalog
					
					$Txt_tips:=UI.alert+$str.setText("theTableIsNoLongerAvailable").localized($Obj_table.name)  //
					
				Else 
					
					Case of 
							
							//______________________________________________________
						: ($1.target=$form.tableList)  // TABLE LIST
							
							If ($Col_desynchronized.length=1)
								
								$o:=$Col_desynchronized[0]
								
								If ($o.fields#Null:C1517)
									
									Case of 
											
											//_______________________________________
										: ($o.fields.length=0)
											
											$Txt_tips:=UI.alert+$str.setText("theRelationIsNoLongerAvailable").localized($o.name)
											
											//_______________________________________
										: ($o.fields.length=1)
											
											$Txt_tips:=UI.alert+$str.setText("theRelatedFieldIsMissingOrHasBeenModified").localized($o.fields[0].name)
											
											//_______________________________________
										Else 
											
											$Txt_tips:=UI.alert+$str.setText("theRelatedFieldsAreMissingOrWasModified").localized($o.fields.extract("name").join("\", \""))
											
											//_______________________________________
									End case 
									
								Else 
									
									Case of 
											
											//______________________________________________________
										: ($o.relatedEntities#Null:C1517)
											
											$Txt_tips:=UI.alert+$str.setText("theRelationIsNoLongerAvailable").localized($o.name)
											
											//______________________________________________________
										: ($o.relatedTableNumber#Null:C1517)
											
											$Txt_tips:=UI.alert+$str.setText("theN1RelationIsNoMoreAvailable").localized($o.name)
											
											//______________________________________________________
										Else 
											
											$Txt_tips:=UI.alert+$str.setText("theFieldIsMissingOrWasModified").localized($o.name)
											
											//______________________________________________________
									End case 
								End if 
								
							Else 
								
								$Txt_tips:=UI.alert+$str.setText("someFieldsOrRelationsAreNoLongerAvailableOrWasModified").localized($Col_desynchronized.extract("name").join("\", \""))
								
							End if 
							
							//______________________________________________________
						: ($1.target=$form.fieldList)  // FIELD LIST
							
							// Get the desynchronized item
							$o:=$Col_desynchronized.query("name = :1"; (UI.pointer($form.fields))->{$Lon_row}).pop()
							
							Case of 
									
									//………………………………………………………………………………………………………………
								: ($o.relatedEntities#Null:C1517)  // 1 -> N relation
									
									If ($o.missing)
										
										If ($o.missingRelatedDataclass)
											
											$Txt_tips:=UI.alert+$str.setText("theRelatedTableIsNoLongerAvailable").localized($o.relatedEntities)
											
										Else 
											
											$Txt_tips:=UI.alert+$str.setText("the1NRelationIsNoMoreAvailable").localized($o.name)
											
										End if 
									End if 
									
									//………………………………………………………………………………………………………………
								: ($o.relatedDataClass#Null:C1517)  // N -> 1 relation
									
									If ($o.missing)
										
										If ($o.missingRelatedDataclass)
											
											$Txt_tips:=UI.alert+$str.setText("theRelatedTableIsNoLongerAvailable").localized($o.relatedDataClass)
											
										Else 
											
											$Txt_tips:=UI.alert+$str.setText("theN1RelationIsNoMoreAvailable").localized($o.name)
											
										End if 
										
									Else 
										
										// Missing fields
										If ($o.unsynchronizedFields.length=1)
											
											$Txt_tips:=UI.alert+$str.setText("theRelatedFieldIsMissingOrHasBeenModified").localized($o.unsynchronizedFields[0].name)
											
										Else 
											
											$Txt_tips:=UI.alert+$str.setText("theRelatedFieldsAreMissingOrWasModified").localized($o.unsynchronizedFields.extract("name").join("\", \""))
											
										End if 
									End if 
									
									//………………………………………………………………………………………………………………
								: (Bool:C1537($o.missing))
									
									$Txt_tips:=UI.alert+$str.setText("theFieldIsMissing").localized()
									
									//………………………………………………………………………………………………………………
								: (Bool:C1537($o.nameMismatch))
									
									$Txt_tips:=UI.alert+$str.setText("theFieldWasRenamed").localized($o.current.name)
									
									//………………………………………………………………………………………………………………
								: (Bool:C1537($o.typeMismatch))
									
									$Txt_tips:=UI.alert+$str.setText("theFieldTypeWasModified").localized()
									
									//………………………………………………………………………………………………………………
								Else 
									
									$Txt_tips:=UI.alert+$str.setText("theFieldIsMissingOrWasModified").localized($o)
									
									//………………………………………………………………………………………………………………
							End case 
							
							//______________________________________________________
					End case 
				End if 
			End if 
			
		Else 
			
			// TABLE IS OK
			
		End if 
		
		If (Length:C16($Txt_tips)=0)
			
			// NO ERROR - DISPLAY USEFUL INFORMATIONS IF ANY
			
			$Obj_dataModel:=Form:C1466.dataModel
			
			Case of 
					
					//______________________________________________________
				: ($1.target=$form.tableList)
					
					//
					
					//______________________________________________________
				: ($1.target=$form.fieldList)
					
					$l:=$Obj_table.field.extract("name").indexOf((UI.pointer($form.fields))->{$Lon_row})
					
					If ($l#-1)
						
						$Obj_field:=$Obj_table.field[$l]
						
						Case of 
								
								//…………………………………………………………………………………………………
							: ($Obj_field.type=-1)  // N -> 1 relation
								
								// Related dataclass name
								$Txt_tips:=$str.setText("nTo1Relation").localized($Obj_field.relatedDataClass)
								
								If ($Obj_field.relatedDataClass=$Obj_table.name)  // Recursive link
									
									// Recursive link
									$Txt_tips:=$Txt_tips+" ("+Get localized string:C991("recursive")+")"
									
								End if 
								
								$Txt_tips:=$Txt_tips+"\r- "+Choose:C955($Lon_column=1; \
									$str.setText("youCanEnableDisableThePublishOfAllRelatedFieldsByClickingHere").localized(Choose:C955($form.publishedPtr->{$Lon_row}#0; "disable"; "enable")); \
									Get localized string:C991("clickHereToSelectThePublishedFields"))
								
								//…………………………………………………………………………………………………
							: ($Obj_field.type=-2)  // 1 -> N relation
								
								If ($Obj_dataModel[String:C10($Obj_field.relatedTableNumber)]=Null:C1517)
									
									If (Bool:C1537((UI.pointer($form.published))->{$Lon_row}))
										
										// Error
										$Txt_tips:=UI.alert+$str.setText("theLinkedTableIsNotPublished").localized($Obj_field.relatedDataClass)
										
									Else 
										
										$Txt_tips:=$str.setText("1toNRelation").localized($Obj_field.relatedDataClass)
										
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
									$Txt_tips:=$str.setText("1toNRelation").localized($Obj_field.relatedDataClass)
									
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
		
	Else 
		
		// TABLE NOT IN CATALOG
		$Txt_tips:=UI.alert+$str.setText("theTableIsNoLongerAvailable").localized((OBJECT Get pointer:C1124(Object named:K67:5; "tables"))->{$Lon_row})
		
	End if 
	
Else 
	
	// NO ITEM HOVERED
	
End if 

If (Position:C15("\r"; $Txt_tips)=0)
	
	$Txt_tips:=$str.setText($Txt_tips).wordWrap(60)
	
End if 

OBJECT SET HELP TIP:C1181(*; $1.target; $Txt_tips)

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End