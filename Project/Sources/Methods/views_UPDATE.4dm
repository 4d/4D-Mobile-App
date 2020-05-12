//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : views_UPDATE
  // ID[5F4AE9BB93F742A7B1446586DE2B7825]
  // Created 1-2-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Update all form definition according to the datamodel
  // ie. remove from forms, the fields that are no more published
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)

C_BOOLEAN:C305($b)
C_LONGINT:C283($l)
C_TEXT:C284($Txt_formFamilly;$Txt_table)
C_OBJECT:C1216($o;$Obj_field;$Obj_target)
C_COLLECTION:C1488($c;$Col_catalog;$Col_fields)

If (False:C215)
	C_TEXT:C284(views_UPDATE ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations

  // ----------------------------------------------------
If (Count parameters:C259=0)
	
	views_UPDATE ("list")
	views_UPDATE ("detail")
	
Else 
	
	$Txt_formFamilly:=$1
	
	If (Form:C1466[$Txt_formFamilly]#Null:C1517)
		
		$Col_catalog:=editor_Catalog 
		
		For each ($Txt_table;Form:C1466[$Txt_formFamilly])
			
			If (Form:C1466.dataModel[$Txt_table]#Null:C1517)
				
				$Obj_target:=Form:C1466[$Txt_formFamilly][$Txt_table]
				
				If ($Obj_target.fields#Null:C1517)
					
					For each ($Obj_field;$Obj_target.fields)
						
						If ($Obj_field#Null:C1517)
							
							$c:=Split string:C1554($Obj_field.name;".")
							
							If ($c.length=1)
								
								If (Num:C11($Obj_field.id)=0)  // 1 - N relation
									
									If (Form:C1466.dataModel[$Txt_table][String:C10($Obj_field.name)]=Null:C1517)
										
										$Obj_target.fields[$Obj_target.fields.indexOf($Obj_field)]:=Null:C1517
										
									End if 
									
								Else 
									
									If (Form:C1466.dataModel[$Txt_table][String:C10($Obj_field.id)]=Null:C1517)
										
										$Obj_target.fields[$Obj_target.fields.indexOf($Obj_field)]:=Null:C1517
										
									End if 
								End if 
								
							Else 
								
								  // Get the related data class
								$l:=$Col_catalog.extract("tableNumber").indexOf(Num:C11($Txt_table))
								
								If ($l>=0)
									
									$Col_fields:=$Col_catalog[$l].field
									$l:=$Col_fields.extract("name").indexOf($c[0])
									
									If ($l>=0)
										
										$l:=$Col_catalog.extract("tableNumber").indexOf($Col_fields[$l].relatedTableNumber)
										
									End if 
									
									If ($l>=0)
										
										$Col_fields:=$Col_catalog[$l].field
										
										If (Form:C1466.dataModel[$Txt_table][$c[0]]#Null:C1517)
											
											CLEAR VARIABLE:C89($b)
											
											For each ($o;$Col_fields) Until ($b)
												
												$b:=($o.id=$Obj_field.id)
												
												If ($b)
													
													If (Form:C1466.dataModel[$Txt_table][$c[0]][String:C10($Obj_field.id)]=Null:C1517)
														
														$Obj_target.fields[$Obj_target.fields.indexOf($Obj_field)]:=Null:C1517
														
													End if 
												End if 
											End for each 
											
										Else 
											
											$Obj_target.fields[$Obj_target.fields.indexOf($Obj_field)]:=Null:C1517
											
										End if 
										
									Else 
										
										$Obj_target.fields[$Obj_target.fields.indexOf($Obj_field)]:=Null:C1517
										
									End if 
									
								Else 
									
									$Obj_target.fields[$Obj_target.fields.indexOf($Obj_field)]:=Null:C1517
									
								End if 
							End if 
						End if 
					End for each 
				End if 
				
				If ($Txt_formFamilly="list")
					
					If ($Obj_target.searchableField#Null:C1517)
						
						If (Value type:C1509($Obj_target.searchableField)=Is collection:K8:32)
							
							For each ($Obj_field;$Obj_target.searchableField)
								
								$c:=Split string:C1554($Obj_field.name;".")
								
								If ($c.length=1)
									
									If (Form:C1466.dataModel[$Txt_table][String:C10($Obj_field.id)]=Null:C1517)
										
										$Obj_target.searchableField.remove($Obj_target.searchableField.indexOf($Obj_field))
										
									End if 
									
								Else 
									
									  // Get the related data class
									$l:=$Col_catalog.extract("tableNumber").indexOf(Num:C11($Txt_table))
									
									If ($l>=0)
										
										$Col_fields:=$Col_catalog[$l].field
										$l:=$Col_fields.extract("name").indexOf($c[0])
										$l:=$Col_catalog.extract("tableNumber").indexOf($Col_fields[$l].relatedTableNumber)
										
										If ($l>=0)
											
											$Col_fields:=$Col_catalog[$l].field
											
											If (Form:C1466.dataModel[$Txt_table][$c[0]]#Null:C1517)
												
												CLEAR VARIABLE:C89($b)
												
												For each ($o;$Col_fields) Until ($b)
													
													$b:=($o.id=$Obj_field.id)
													
													If ($b)
														
														If (Form:C1466.dataModel[$Txt_table][$c[0]][String:C10($Obj_field.id)]=Null:C1517)
															
															$Obj_target.searchableField.remove($Obj_target.searchableField.indexOf($Obj_field))
															
														End if 
													End if 
												End for each 
												
											Else 
												
												$Obj_target.searchableField.remove($Obj_target.searchableField.indexOf($Obj_field))
												
											End if 
											
										Else 
											
											$Obj_target.searchableField.remove($Obj_target.searchableField.indexOf($Obj_field))
											
										End if 
										
									Else 
										
										$Obj_target.searchableField.remove($Obj_target.searchableField.indexOf($Obj_field))
										
									End if 
								End if 
							End for each 
							
							Case of 
									
									  //…………………………………………………………………………………………………
								: ($Obj_target.searchableField.length=0)
									
									OB REMOVE:C1226($Obj_target;"searchableField")
									
									  //…………………………………………………………………………………………………
								: ($Obj_target.searchableField.length=1)
									
									  // Convert to object
									$Obj_target.searchableField:=$Obj_target.searchableField[0]
									
									  //…………………………………………………………………………………………………
							End case 
							
						Else 
							
							$Obj_field:=$Obj_target.searchableField
							
							If ($Obj_field#Null:C1517)
								
								$c:=Split string:C1554($Obj_field.name;".")
								
								If ($c.length=1)
									
									If (Form:C1466.dataModel[$Txt_table][String:C10($Obj_field.id)]=Null:C1517)
										
										$Obj_target.fields[$Obj_target.fields.indexOf($Obj_field)]:=Null:C1517
										
									End if 
									
								Else 
									
									  // Get the related data class
									$l:=$Col_catalog.extract("tableNumber").indexOf(Num:C11($Txt_table))
									
									If ($l>=0)
										
										$Col_fields:=$Col_catalog[$l].field
										$l:=$Col_fields.extract("name").indexOf($c[0])
										$l:=$Col_catalog.extract("tableNumber").indexOf($Col_fields[$l].relatedTableNumber)
										
										If ($l>=0)
											
											$Col_fields:=$Col_catalog[$l].field
											
											If (Form:C1466.dataModel[$Txt_table][$c[0]]#Null:C1517)
												
												CLEAR VARIABLE:C89($b)
												
												For each ($o;$Col_fields) Until ($b)
													
													$b:=($o.id=$Obj_field.id)
													
													If ($b)
														
														If (Form:C1466.dataModel[$Txt_table][$c[0]][String:C10($Obj_field.id)]=Null:C1517)
															
															OB REMOVE:C1226($Obj_target;"searchableField")
															
														End if 
													End if 
												End for each 
												
											Else 
												
												OB REMOVE:C1226($Obj_target;"searchableField")
												
											End if 
											
										Else 
											
											OB REMOVE:C1226($Obj_target;"searchableField")
											
										End if 
										
									Else 
										
										OB REMOVE:C1226($Obj_target;"searchableField")
										
									End if 
								End if 
							End if 
						End if 
					End if 
					
					$Obj_field:=$Obj_target.sectionField
					
					If ($Obj_field#Null:C1517)
						
						$c:=Split string:C1554($Obj_field.name;".")
						
						If ($c.length=1)
							
							If (Form:C1466.dataModel[$Txt_table][String:C10($Obj_field.id)]=Null:C1517)
								
								$Obj_target.fields[$Obj_target.fields.indexOf($Obj_field)]:=Null:C1517
								
							End if 
							
						Else 
							
							  // Get the related data class
							$l:=$Col_catalog.extract("tableNumber").indexOf(Num:C11($Txt_table))
							
							If ($l>=0)
								
								$Col_fields:=$Col_catalog[$l].field
								$l:=$Col_fields.extract("name").indexOf($c[0])
								$l:=$Col_catalog.extract("tableNumber").indexOf($Col_fields[$l].relatedTableNumber)
								
								If ($l>=0)
									
									$Col_fields:=$Col_catalog[$l].field
									
									If (Form:C1466.dataModel[$Txt_table][$c[0]]#Null:C1517)
										
										CLEAR VARIABLE:C89($b)
										
										For each ($o;$Col_fields) Until ($b)
											
											$b:=($o.id=$Obj_field.id)
											
											If ($b)
												
												If (Form:C1466.dataModel[$Txt_table][$c[0]][String:C10($Obj_field.id)]=Null:C1517)
													
													OB REMOVE:C1226($Obj_target;"sectionField")
													
												End if 
											End if 
										End for each 
										
									Else 
										
										OB REMOVE:C1226($Obj_target;"sectionField")
										
									End if 
									
								Else 
									
									OB REMOVE:C1226($Obj_target;"sectionField")
									
								End if 
								
							Else 
								
								OB REMOVE:C1226($Obj_target;"sectionField")
								
							End if 
						End if 
					End if 
				End if 
			End if 
		End for each 
	End if 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End