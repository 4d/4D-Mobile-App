//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : STRUCTURE_AUDIT
// ID[5CEB938EFFBB4CB9A0436B50327B0EAD]
// Created 18-1-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Check the structure of the tables and fields used in the data model
// Against the latest valid version of the catalog.
// ----------------------------------------------------
//
// EXECUTION SPACE IS THE FORM EDITOR
//
// ----------------------------------------------------
// Declarations
#DECLARE($currentCatalog : Collection)

If (False:C215)
	C_COLLECTION:C1488(STRUCTURE_AUDIT; $1)
End if 

var $isTableUnsynchronized; $isUnsynchronized : Boolean
var $cache; $current; $field; $item; $linkedField; $linkedItem; $o; $relatedField; $relatedItem; $structure : Object
var $table; $tableCatalog : Object
var $cachedCatalog; $linkedCatalog; $relatedCatalog; $unsynchronizedFields; $unsynchronizedTableFields : Collection
var $cacheFile : 4D:C1709.File
var $str : cs:C1710.str

// ----------------------------------------------------
// Initialisations
If (PROJECT.$dialog=Null:C1517)
	
	PROJECT.$dialog:=New object:C1471
	
End if 

$str:=cs:C1710.str.new()

// ----------------------------------------------------
// Compare to cached catalog (the last valid)
$cacheFile:=PROJECT._folder.file("catalog.json")

If ($cacheFile.exists)
	
	$cache:=JSON Parse:C1218($cacheFile.getText())
	$cachedCatalog:=$cache.structure.definition
	
	// Was the structure changed?
	If (Not:C34($cachedCatalog.equal($currentCatalog)))  // | (Bool(FEATURE._8858))
		
		$unsynchronizedTableFields:=New collection:C1472
		
		// Verify the compliance of the data model with the current catalog
		If (PROJECT.dataModel#Null:C1517)
			
			For each ($table; PROJECT.tables(OB Copy:C1225(PROJECT.dataModel)).copy())
				
				// Reset unsynchronized table flag
				CLEAR VARIABLE:C89($isTableUnsynchronized)
				
				// Create unsynchronized fields collection
				$unsynchronizedFields:=New collection:C1472
				
				$tableCatalog:=$currentCatalog.query("tableNumber = :1"; Num:C11($table.key)).pop()
				
				If ($tableCatalog=Null:C1517)
					
					// THE TABLE IS NO LONGER AVAILABLE
					$isTableUnsynchronized:=True:C214
					
				Else 
					
					If ($table.value[""].name#Null:C1517)  // *** *** *** *** *** *** *** *** WIP *** *** *** *** *** *** *** *** 
						
						// Check TABLE NAME & PRIMARY KEY
						$isTableUnsynchronized:=($tableCatalog.name#$table.value[""].name)\
							 | (String:C10($tableCatalog.primaryKey)#$table.value[""].primaryKey)
						
						If (Not:C34($isTableUnsynchronized))
							
							For each ($item; PROJECT.fields($table.value))
								
								Case of 
										
										//______________________________________________________
									: (PROJECT.isField($item.key))
										
										$field:=$table.value[$item.key]
										$field.current:=$tableCatalog.field.query("fieldNumber = :1 & kind = storage"; Num:C11($item.key)).pop()
										$field.fieldNumber:=Num:C11($item.key)
										$field.missing:=$field.current=Null:C1517
										$field.nameMismatch:=Not:C34($str.setText($field.name).equal($field.current.name))
										
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
													
													$field.tableTips:=$str.setText("theFieldNameTypeWasModified").localized($field.name)
													$field.fieldTips:=$str.setText("theFieldTypeWasModified").localized()
													
													//______________________________________________________
											End case 
											
											// Append faulty field
											$unsynchronizedFields.push($field)
											
										End if 
										
										//______________________________________________________
									: (PROJECT.isRelationToOne($item.value))
										
										$field:=$table.value[$item.key]
										$current:=$tableCatalog.field.query("name === :1"; $item.key).pop()
										$field.missing:=$current=Null:C1517
										
										If ($field.missing)
											
											// Check the related dataclass availability
											$field.missingRelatedDataclass:=$currentCatalog.query("tableNumber = :1"; Num:C11($field.relatedTableNumber)).pop()=Null:C1517
											
										Else 
											
											// Diacritical equality of the name
											$field.nameMismatch:=Not:C34($str.setText($item.key).equal($current.name))
											
										End if 
										
										If ($field.missing | Bool:C1537($field.missingRelatedDataclass))
											
											// THE RELATED DATA CLASS IS NO LONGER AVAILABLE
											// OR THE RELATION NAME HAS BEEN CHANGED
											
											$isTableUnsynchronized:=True:C214
											
											Case of 
													
													//______________________________________________________
												: (Bool:C1537($field.missingRelatedDataclass))
													
													$field.tableTips:=$str.setText("theRelatedTableIsNoLongerAvailable").localized($field.relatedDataClass)
													$field.fieldTips:=$field.tableTips
													
													//______________________________________________________
												: ($field.missing)
													
													$field.tableTips:=$str.setText("theRelationIsNoLongerAvailable").localized($item.key)
													$field.fieldTips:=$field.tableTips
													
													//______________________________________________________
											End case 
											
											// Append faulty relation
											If ($unsynchronizedFields.query("name= :1"; $item.key).length=0)
												
												$field.name:=$item.key
												$unsynchronizedFields.push($field)
												
											End if 
											
										Else 
											
											// Check related table catalog
											$relatedCatalog:=$currentCatalog.query("tableNumber = :1"; $field.relatedTableNumber).pop().field
											
											For each ($relatedItem; PROJECT.fields($field))
												
												$relatedField:=$relatedItem.value
												
												Case of 
														
														//______________________________________________________
													: (PROJECT.isField($relatedItem.key))
														
														$relatedField.parent:=$item.key
														$relatedField.current:=$relatedCatalog.query("fieldNumber = :1"; Num:C11($relatedItem.key)).pop()
														$relatedField.fieldNumber:=Num:C11($relatedItem.key)
														$relatedField.missing:=$relatedField.current=Null:C1517
														$relatedField.nameMismatch:=Not:C34($str.setText($relatedField.name).equal($relatedField.current.name))
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
																	
																	$relatedField.tableTips:=$str.setText("theFieldNameTypeWasModified").localized()
																	$relatedField.fieldTips:=$relatedField.tableTips
																	
																	//______________________________________________________
															End case 
															
															$isTableUnsynchronized:=True:C214
															cs:C1710.ob.new($field).createPath("unsynchronizedFields"; Is collection:K8:32).unsynchronizedFields.push($relatedField)
															
															If ($unsynchronizedFields.query("fieldTips= :1"; $relatedField.fieldTips).length=0)
																
																$unsynchronizedFields.push($relatedField)
																
															End if 
														End if 
														
														//______________________________________________________
													: (PROJECT.isRelationToMany($relatedField))
														
														$relatedField.parent:=$item.key
														$relatedField.current:=$relatedCatalog.query("name === :1"; $relatedItem.key).pop()
														$relatedField.missing:=$relatedField.current=Null:C1517
														$relatedField.nameMismatch:=Not:C34($str.setText($relatedField.name).equal($relatedItem.key))
														
														If ($relatedField.missing | $relatedField.nameMismatch)
															
															// TRUE IF THE RELATION WAS DELETED
															// OR IF THE NAME (diacritical) HAS BEEN CHANGED
															
															Case of 
																	
																	//______________________________________________________
																: ($relatedField.missing)
																	
																	$relatedField.tableTips:=$str.setText("the1NRelationIsNoMoreAvailable").localized($relatedField.name)
																	$relatedField.fieldTips:=$relatedField.tableTips
																	
																	//______________________________________________________
																: ($relatedField.nameMismatch)
																	
																	$relatedField.tableTips:=$str.setText("theFieldNameWasRenamed").localized(New collection:C1472($relatedItem.key; $relatedField.name))
																	$relatedField.fieldTips:=$relatedField.tableTips
																	
																	//______________________________________________________
															End case 
															
															$isTableUnsynchronized:=True:C214
															cs:C1710.ob.new($field).createPath("unsynchronizedFields"; Is collection:K8:32).unsynchronizedFields.push($relatedField)
															
															If ($unsynchronizedFields.query("fieldTips= :1"; $relatedField.fieldTips).length=0)
																
																$unsynchronizedFields.push($relatedField)
																
															End if 
														End if 
														
														//______________________________________________________
													: (PROJECT.isRelationToOne($relatedField))
														
														$linkedCatalog:=$currentCatalog.query("tableNumber = :1"; $relatedField.relatedTableNumber).pop().field
														
														For each ($linkedItem; PROJECT.storageFields($relatedField))
															
															$linkedField:=$linkedItem.value
															$linkedField.fieldNumber:=Num:C11($linkedItem.key)
															$linkedField.current:=$linkedCatalog.query("fieldNumber = :1"; Num:C11($linkedItem.key)).pop()
															
															$linkedField.missing:=$linkedField.current=Null:C1517
															$linkedField.nameMismatch:=Not:C34($str.setText($linkedField.name).equal($linkedField.current.name))
															
															If (Not:C34($linkedField.missing))
																
																If (Value type:C1509($linkedField.type)=Is text:K8:3)
																	
																	// Compare to value Type
																	$linkedField.typeMismatch:=$linkedField.type#$linkedField.current.valueType
																	
																Else 
																	
																	$linkedField.typeMismatch:=$linkedField.fieldType#$linkedField.current.fieldType
																	
																End if 
															End if 
															
															If ($linkedField.missing | $linkedField.nameMismatch | Bool:C1537($linkedField.typeMismatch))
																
																// THE FIELD IS NO LONGER AVAILABLE
																// OR THE NAME/TYPE HAS BEEN CHANGED
																
																$isTableUnsynchronized:=True:C214
																
																Case of 
																		
																		//______________________________________________________
																	: ($linkedField.missing)
																		
																		$linkedField.tableTips:=$str.setText("theFieldNameIsMissing").localized($linkedField.name)
																		$linkedField.fieldTips:=$linkedField.tableTips
																		
																		//______________________________________________________
																	: ($linkedField.nameMismatch)
																		
																		$linkedField.tableTips:=$str.setText("theFieldNameWasRenamed").localized(New collection:C1472($linkedField.name; $linkedField.current.name))
																		$linkedField.fieldTips:=$linkedField.tableTips
																		
																		//______________________________________________________
																	: (Bool:C1537($linkedField.typeMismatch))
																		
																		$linkedField.tableTips:=$str.setText("theFieldNameTypeWasModified").localized()
																		$linkedField.fieldTips:=$linkedField.tableTips
																		
																		//______________________________________________________
																End case 
																
																$isTableUnsynchronized:=True:C214
																cs:C1710.ob.new($field).createPath("unsynchronizedFields"; Is collection:K8:32).unsynchronizedFields.push($linkedField)
																
																If ($unsynchronizedFields.query("fieldTips= :1"; $linkedField.fieldTips).length=0)
																	
																	$linkedField.name:=$item.key
																	$unsynchronizedFields.push($linkedField)
																	
																End if 
															End if 
														End for each 
														
														//______________________________________________________
													: (PROJECT.isComputedAttribute($relatedField))
														
														$relatedField.parent:=$item.key
														$relatedField.current:=$relatedCatalog.query("name = :1"; $relatedItem.key).pop()
														$relatedField.missing:=$relatedField.current=Null:C1517
														$relatedField.nameMismatch:=Not:C34($str.setText($relatedField.name).equal($relatedField.current.name))
														$relatedField.typeMismatch:=$relatedField.fieldType#Num:C11($relatedField.current.fieldType)
														
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
																	
																	$relatedField.tableTips:=$str.setText("theFieldNameTypeWasModified").localized()
																	$relatedField.fieldTips:=$relatedField.tableTips
																	
																	//______________________________________________________
															End case 
															
															$isTableUnsynchronized:=True:C214
															cs:C1710.ob.new($field).createPath("unsynchronizedFields"; Is collection:K8:32).unsynchronizedFields.push($relatedField)
															
															If ($unsynchronizedFields.query("fieldTips= :1"; $relatedField.fieldTips).length=0)
																
																$unsynchronizedFields.push($relatedField)
																
															End if 
														End if 
														
														//______________________________________________________
													: (PROJECT.isAlias($relatedField))
														
														// Todo: MANAGE ALIAS
														
														//______________________________________________________
													Else 
														
														ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
														
														//______________________________________________________
												End case 
											End for each 
										End if 
										
										$field.current:=$current
										
										//______________________________________________________
									: (PROJECT.isRelationToMany($item.value))
										
										$field:=$table.value[$item.key]
										$field.current:=$tableCatalog.field.query("name === :1"; $item.key).pop()
										$field.missing:=$field.current=Null:C1517
										
										If ($field.missing)
											
											// Check the related dataclass availability
											$field.missingRelatedDataclass:=$currentCatalog.query("tableNumber = :1"; Num:C11($field.relatedTableNumber)).pop()=Null:C1517
											
										Else 
											
											// Diacritical equality of the name
											$field.nameMismatch:=Not:C34($str.setText($item.key).equal($field.current.name))
											
										End if 
										
										If ($field.missing | Bool:C1537($field.nameMismatch) | Bool:C1537($field.missingRelatedDataclass))
											
											// THE RELATION IS NO LONGER AVAILABLE
											// OR IF THE NAME HAS BEEN CHANGED
											
											Case of 
													
													//______________________________________________________
												: (Bool:C1537($field.missingRelatedDataclass))
													
													$field.tableTips:=$str.setText("theRelatedTableIsNoLongerAvailable").localized($field.relatedEntities)
													$field.fieldTips:=$field.tableTips
													
													//______________________________________________________
												: ($field.missing)
													
													$field.tableTips:=$str.setText("theRelatedFieldIsMissingOrHasBeenModified").localized($item.key)
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
									: (PROJECT.isComputedAttribute($item.value))
										
										$field:=$table.value[$item.key]
										$field.current:=$tableCatalog.field.query("name = :1"; $item.key).pop()
										$field.missing:=$field.current=Null:C1517
										$field.nameMismatch:=Not:C34($str.setText($field.name).equal($field.current.name))
										
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
											// OR THE TYPE HAS BEEN CHANGED
											
											$isTableUnsynchronized:=True:C214
											
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
													
													$field.tableTips:=$str.setText("theFieldNameTypeWasModified").localized($field.name)
													$field.fieldTips:=$str.setText("theFieldTypeWasModified").localized()
													
													//______________________________________________________
											End case 
											
											// Append faulty field
											$unsynchronizedFields.push($field)
											
										End if 
										
										//______________________________________________________
									: (PROJECT.isAlias($item.value))
										
										// Todo: MANAGE ALIAS
										
										//$field:=$table.value[$item.key]
										//$field.current:=$tableCatalog.field.query("name = :1"; $item.key).pop()
										//$field_2:=Formula from string("ds:C1482[\""+$table.value[""].name+"\"]."+$item.value.path).call()
										//$field.missing:=$field.current=Null
										
										//______________________________________________________
									Else 
										
										//ASSERT(Not(DATABASE.isMatrix); "😰 I wonder why I'm here")
										
										//______________________________________________________
								End case 
							End for each 
						End if 
					End if 
				End if 
				
				If ($isTableUnsynchronized)
					
					$isUnsynchronized:=True:C214
					
					// THE FIELD COLLECTION IS EMPTY IF THE TABLE IS MISSING
					$unsynchronizedTableFields[Num:C11($table.key)]:=$unsynchronizedFields
					
				End if 
			End for each 
		End if 
		
		If ($isUnsynchronized)
			
			// Display alert only one time
			If (PROJECT.isNotLocked())
				
				POST_MESSAGE(New object:C1471(\
					"target"; Current form window:C827; \
					"action"; "show"; \
					"type"; "confirm"; \
					"title"; "theDatabaseStructureWasModified"; \
					"additional"; "theDataModelIsNoMoreValidAndMustBeUpdated"; \
					"cancel"; "reviewing"; \
					"cancelAction"; "page_structure"; \
					"ok"; "update"; \
					"okFormula"; Formula:C1597(CALL FORM:C1391(Current form window:C827; Formula:C1597(editor_CALLBACK).source; "syncDataModel"))))
				
			End if 
			
		Else 
			
			// Keep the current catalog
			Form:C1466.$catalog:=$currentCatalog
			
			// The changes has no influence on the data model -> Update the cache
			$structure:=Choose:C955($cache.structure=Null:C1517; New object:C1471; $cache.structure)
			$structure.definition:=$currentCatalog
			$structure.digest:=Generate digest:C1147(JSON Stringify:C1217($currentCatalog); SHA1 digest:K66:2)
			$cache.structure:=$structure
			$cacheFile.setText(JSON Stringify:C1217($cache; *))
			
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
		
		$cacheFile.setText(JSON Stringify:C1217($cache; *))
		
	End if 
End if 

If (Not:C34($isUnsynchronized))\
 | (Form:C1466.$catalog=Null:C1517)
	
	// Keep the current catalog
	Form:C1466.$catalog:=$currentCatalog
	
End if 

// Store the status
$o:=cs:C1710.ob.new(Form:C1466)
$o.createPath("structure").structure.unsynchronized:=$isUnsynchronized
$o.createPath("status").structure.dataModel:=Not:C34($isUnsynchronized)

EDITOR.updateHeader(New object:C1471(\
"show"; $isUnsynchronized))

// Refresh UI
STRUCTURE_Handler(New object:C1471(\
"action"; "update"; \
"project"; PROJECT))

// Save project
PROJECT.save()