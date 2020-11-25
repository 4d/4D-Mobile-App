//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : STRUCTURE_CALLBACK
// ID[5CEB938EFFBB4CB9A0436B50327B0EAD]
// Created 18-1-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Check the structure for the tables and fields used in the data model by
// Comparing to the last valid version of the catalog.
// ----------------------------------------------------
// 
// EXECUTION SPACE IS THE FORM EDITOR
// 
// ----------------------------------------------------
// Declarations

#DECLARE ($currentCatalog : Collection)

var $tableID; $key : Text
var $isTableUnsynchronized; $isUnsynchronized : Boolean
var $cache; $current; $dataModel; $item; $file; $field; $relatedField; $structure; $related; $tableCatalog; $tableModel : Object
var $cachedCatalog; $currentCatalog; $relatedCatalog; $unsynchronizedFields; $unsynchronizedTableFields : Collection
var $str : cs:C1710.str

// ----------------------------------------------------
// Initialisations

PROJECT.$dialog:=_nul(PROJECT.$dialog; Is object:K8:27)

$str:=cs:C1710.str.new()

// ----------------------------------------------------
// Compare to cached catalog (the last valid)
$file:=PROJECT.$project.file.parent.file("catalog.json")

If ($file.exists)
	
	$cache:=JSON Parse:C1218($file.getText())
	$cachedCatalog:=$cache.structure.definition
	
	// Was the structure changed?
	If (Not:C34($cachedCatalog.equal($currentCatalog)))\
		 | (Bool:C1537(FEATURE._8858))
		
		$unsynchronizedTableFields:=New collection:C1472
		
		// Verify the compliance of the data model with the current catalog
		If (PROJECT.dataModel#Null:C1517)
			
			$dataModel:=OB Copy:C1225(PROJECT.dataModel)
			
		End if 
		
		If ($dataModel#Null:C1517)
			
			// For each TABLE published
			For each ($tableID; $dataModel)
				
				$tableModel:=$dataModel[$tableID]
				
				// Reset unsynchronized table flag
				CLEAR VARIABLE:C89($isTableUnsynchronized)
				
				// Create unsynchronized fields collection
				$unsynchronizedFields:=New collection:C1472
				
				$tableCatalog:=$currentCatalog.query("tableNumber = :1"; Num:C11($tableID)).pop()
				
				If ($tableCatalog=Null:C1517)
					
					// THE TABLE IS NO LONGER AVAILABLE
					$isTableUnsynchronized:=True:C214
					
				Else 
					
					// Check TABLE NAME & PRIMARY KEY
					$isTableUnsynchronized:=($tableCatalog.name#$tableModel[""].name)\
						 | (String:C10($tableCatalog.primaryKey)#$tableModel[""].primaryKey)
					
					If (Not:C34($isTableUnsynchronized))
						
						For each ($item; PROJECT.fields($tableModel))
							
							Case of 
									
									//______________________________________________________
								: (PROJECT.isField($item.key))
									
									$field:=$tableModel[$item.key]
									$field.current:=$tableCatalog.field.query("fieldNumber = :1"; Num:C11($item.key)).pop()
									$field.fieldNumber:=Num:C11($item.key)
									$field.missing:=$field.current=Null:C1517
									$field.nameMismatch:=$field.name#String:C10($field.current.name)
									
									If (Not:C34($field.missing))
										
										If (Value type:C1509($field.type)=Is text:K8:3)
											
											// Compare to value Type
											$field.typeMismatch:=$field.type#$field.current.valueType
											
										Else 
											
											$field.typeMismatch:=$field.fieldType#$field.current.fieldType
											
										End if 
									End if 
									
									If ($field.missing | $field.nameMismatch | Bool:C1537($field.typeMismatch))
										
										// THE FIELD IS NO LONGER AVAILABLE
										// OR THE NAME/TYPE HAS BEEN CHANGED
										
										$isTableUnsynchronized:=True:C214
										
										// #WIP better tips
										Case of 
												
												//______________________________________________________
											: ($field.missing)
												
												$field.tableTips:=$str.setText("theFieldNameIsMissing").localized($field.name)
												$field.fieldTips:=$str.setText("theFieldIsMissing").localized()
												
												//______________________________________________________
											: ($field.nameMismatch)
												
												$field.tableTips:=$str.setText("theFieldNameWasRenamed").localized(New collection:C1472($field.name; $field.current.name))
												$field.fieldTips:=$str.setText("theFieldWasRenamed").localized($field.current.name)
												
												//______________________________________________________
											: (Bool:C1537($field.typeMismatch))
												
												$field.tableTips:=$str.setText("theFieldTypeWasModified").localized()
												$field.fieldTips:=$str.setText("theFieldTypeWasModified").localized()
												
												//______________________________________________________
										End case 
										
										// Append faulty field
										$unsynchronizedFields.push($field)
										
									End if 
									
									//______________________________________________________
								: (PROJECT.isRelationToOne($item.value))  // N -> 1 relation
									
									$field:=$tableModel[$item.key]
									$current:=$tableCatalog.field.query("name = :1"; $item.key).pop()
									$field.missing:=$current=Null:C1517
									
									If ($field.missing)
										
										// Check the related dataclass availability
										$field.missingRelatedDataclass:=$currentCatalog.query("tableNumber = :1"; Num:C11($field.relatedTableNumber)).pop()=Null:C1517
										
									Else 
										
										// Diacritical equality of the name
										$field.nameMismatch:=Not:C34($str.setText($item.key).equal($current.name))
										
									End if 
									
									If ($field.missing | Bool:C1537($field.nameMismatch))
										
										// THE RELATION IS NO LONGER AVAILABLE
										// OR THE NAME HAS BEEN CHANGED
										
										$isTableUnsynchronized:=True:C214
										
										// Append faulty relation
										If ($unsynchronizedFields.query("name= :1"; $item.key).length=0)
											
											$field.name:=$item.key
											$unsynchronizedFields.push($field)
											
										End if 
										
									Else 
										
										// Check related table catalog
										$relatedCatalog:=$currentCatalog.query("tableNumber = :1"; $field.relatedTableNumber).pop().field
										
										// Check related data class catalog
										For each ($key; $field)
											
											Case of 
													
													//______________________________________________________
												: (PROJECT.isField($key))
													
													$relatedField:=$field[$key]
													$relatedField.current:=$relatedCatalog.query("fieldNumber = :1"; Num:C11($key)).pop()
													$relatedField.missing:=$relatedField.current=Null:C1517
													$relatedField.nameMismatch:=$relatedField.name#String:C10($relatedField.current.name)
													$relatedField.typeMismatch:=$relatedField.type#Num:C11($relatedField.current.type)
													
													If ($relatedField.missing | $relatedField.nameMismatch | $relatedField.typeMismatch)
														
														// TRUE IF THE RELATED FIELD IS NO LONGER AVAILABLE
														// OR IF THE NAME (non diacritical) OR TYPE HAS BEEN CHANGED
														
														Case of 
																
																//______________________________________________________
															: ($relatedField.missing)
																
																$relatedField.tableTips:=$str.setText("theFieldNameIsMissing").localized($relatedField.name)
																$relatedField.fieldTips:=$relatedField.tableTips
																
																//______________________________________________________
															: ($relatedField.nameMismatch)
																
																$relatedField.tableTips:=$str.setText("theFieldNameWasRenamed").localized(New collection:C1472($relatedField.name; $relatedField.current.name))
																$relatedField.fieldTips:=$relatedField.tableTips
																
																//______________________________________________________
															: (Bool:C1537($relatedField.typeMismatch))
																
																$relatedField.tableTips:=$str.setText("theFieldTypeWasModified").localized()
																$relatedField.fieldTips:=$relatedField.tableTips
																
																//______________________________________________________
														End case 
														
														$isTableUnsynchronized:=True:C214
														$field.unsynchronizedFields:=_nul($field.unsynchronizedFields; Is collection:K8:32).push($relatedField)
														
														If ($unsynchronizedFields.query("fieldTips= :1"; $relatedField.fieldTips).length=0)
															
															$relatedField.name:=$item.key
															$unsynchronizedFields.push($relatedField)
															
														End if 
													End if 
													
													//______________________________________________________
												: (PROJECT.isRelationToOne($field[$key]))  // N -> 1 relation
													
													For each ($related; PROJECT.storageFields($field[$key]))
														
														$relatedField:=$related.value
														$relatedField.current:=$relatedCatalog.query("fieldNumber = :1"; Num:C11($related.key)).pop()
														$relatedField.missing:=$relatedField.current=Null:C1517
														$relatedField.nameMismatch:=$relatedField.name#String:C10($relatedField.current.name)
														$relatedField.typeMismatch:=$relatedField.type#Num:C11($relatedField.current.type)
														
														If ($relatedField.missing | $relatedField.nameMismatch | $relatedField.typeMismatch)
															
															// TRUE IF THE RELATED FIELD IS NO LONGER AVAILABLE
															// OR IF THE NAME (non diacritical) OR TYPE HAS BEEN CHANGED
															
															Case of 
																	
																	//______________________________________________________
																: ($relatedField.missing)
																	
																	$relatedField.tableTips:=$str.setText("theFieldNameIsMissing").localized($relatedField.name)
																	$relatedField.fieldTips:=$relatedField.tableTips
																	
																	//______________________________________________________
																: ($relatedField.nameMismatch)
																	
																	$relatedField.tableTips:=$str.setText("theFieldNameWasRenamed").localized(New collection:C1472($relatedField.name; $relatedField.current.name))
																	$relatedField.fieldTips:=$relatedField.tableTips
																	
																	//______________________________________________________
																: (Bool:C1537($relatedField.typeMismatch))
																	
																	$relatedField.tableTips:=$str.setText("theFieldTypeWasModified").localized()
																	$relatedField.fieldTips:=$relatedField.tableTips
																	
																	//______________________________________________________
															End case 
															
															$isTableUnsynchronized:=True:C214
															$relatedField.name:=$item.key
															$field.unsynchronizedFields:=_nul($field.unsynchronizedFields; Is collection:K8:32).push($relatedField)
															
															// Append faulty relation
															If ($unsynchronizedFields.query("tableTips= :1"; $relatedField.tableTips).length=0)
																
																$unsynchronizedFields.push($relatedField)
																
															End if 
														End if 
													End for each 
													
													//______________________________________________________
												: (PROJECT.isRelationToMany($field[$key]))  // 1 -> N relation
													
													// NOT YET MANAGED
													
													//______________________________________________________
												Else 
													
													ASSERT:C1129(False:C215; "😰 I wonder why I'm here")
													
													//______________________________________________________
											End case 
										End for each 
									End if 
									
									$field.current:=$current
									
									//______________________________________________________
								: (PROJECT.isRelationToMany($item.value))  // 1 -> N relation
									
									$field:=$tableModel[$item.key]
									$field.current:=$tableCatalog.field.query("name = :1"; $item.key).pop()
									$field.missing:=$field.current=Null:C1517
									
									If ($field.missing)
										
										// Check the related dataclass availability
										$field.missingRelatedDataclass:=$currentCatalog.query("tableNumber = :1"; Num:C11($field.relatedTableNumber)).pop()=Null:C1517
										
									Else 
										
										// Diacritical equality of the name
										$field.nameMismatch:=Not:C34($str.setText($item.key).equal($field.current.name))
										
									End if 
									
									If ($field.missing | Bool:C1537($field.nameMismatch))
										
										// THE RELATION IS NO LONGER AVAILABLE
										// OR IF THE NAME HAS BEEN CHANGED
										
										Case of 
												
												//______________________________________________________
											: (Bool:C1537($field.missingRelatedDataclass))
												
												$field.tableTips:=$str.setText("theRelatedTableIsNoLongerAvailable").localized($field.relatedEntities)
												$field.fieldTips:=$field.tableTips
												
												//______________________________________________________
											: ($field.missing)
												
												$field.tableTips:=$str.setText("theFieldNameIsMissing").localized($item.key)
												$field.fieldTips:=$field.tableTips
												
												//______________________________________________________
											: ($field.nameMismatch)
												
												$field.tableTips:=$str.setText("theFieldNameWasRenamed").localized(New collection:C1472($field.name; $field.current.name))
												$field.fieldTips:=$field.tableTips
												
												//______________________________________________________
										End case 
										
										$isTableUnsynchronized:=True:C214
										
										// Append faulty relation
										If ($unsynchronizedFields.query("name= :1"; $item.key).length=0)
											
											$field.name:=$item.key
											$unsynchronizedFields.push($field)
											
										End if 
									End if 
									
									//______________________________________________________
								Else 
									
									ASSERT:C1129(False:C215; "😰 I wonder why I'm here")
									
									//______________________________________________________
							End case 
						End for each 
					End if 
				End if 
				
				If ($isTableUnsynchronized)
					
					$isUnsynchronized:=True:C214
					
					// THE FIELD COLLECTION IS EMPTY IF THE TABLE IS MISSING
					$unsynchronizedTableFields[Num:C11($tableID)]:=$unsynchronizedFields
					
				End if 
			End for each 
		End if 
		
		If ($isUnsynchronized)
			
			// Display alert only one time
			If (Not:C34(editor_Locked))
				
				POST_MESSAGE(New object:C1471(\
					"target"; Current form window:C827; \
					"action"; "show"; \
					"type"; "confirm"; \
					"title"; "theDatabaseStructureWasModified"; \
					"additional"; "theDataModelIsNoMoreValidAndMustBeUpdated"; \
					"cancel"; "reviewing"; \
					"cancelAction"; "page_structure"; \
					"ok"; "update"; \
					"okFormula"; Formula:C1597(CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "syncDataModel"))))
				
			End if 
			
		Else 
			
			// Keep the current catalog
			Form:C1466.$catalog:=$currentCatalog
			
			// The changes has no influence on the data model -> Update the cache
			$structure:=Choose:C955($cache.structure=Null:C1517; New object:C1471; $cache.structure)
			$structure.definition:=$currentCatalog
			$structure.digest:=Generate digest:C1147(JSON Stringify:C1217($currentCatalog); SHA1 digest:K66:2)
			$cache.structure:=$structure
			$file.setText(JSON Stringify:C1217($cache; *))
			
		End if 
		
		// Keep state
		PROJECT.$dialog.unsynchronizedTableFields:=$unsynchronizedTableFields
		
	Else 
		
		// Reset
		PROJECT.$dialog.unsynchronizedTableFields:=New collection:C1472
		
	End if 
	
Else 
	
	// Create the cache
	If ($currentCatalog#Null:C1517)
		
		$cache:=New object:C1471(\
			"structure"; New object:C1471(\
			"definition"; $currentCatalog; \
			"digest"; Generate digest:C1147(JSON Stringify:C1217($currentCatalog); SHA1 digest:K66:2)))
		
		$file.setText(JSON Stringify:C1217($cache; *))
		
	End if 
End if 

If (Not:C34($isUnsynchronized))\
 | (Form:C1466.$catalog=Null:C1517)
	
	// Keep the current catalog
	Form:C1466.$catalog:=$currentCatalog
	
End if 

// Store the status
Form:C1466.structure:=_nul(Form:C1466.structure; Is object:K8:27)
Form:C1466.structure.unsynchronized:=$isUnsynchronized

Form:C1466.status:=_nul(Form:C1466.status; Is object:K8:27)
Form:C1466.status.dataModel:=Not:C34($isUnsynchronized)

CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "description"; New object:C1471(\
"show"; $isUnsynchronized))

// Refresh UI
STRUCTURE_Handler(New object:C1471(\
"action"; "update"; \
"project"; PROJECT))

// Save project
PROJECT.save()