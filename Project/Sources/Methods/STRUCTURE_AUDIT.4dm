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
// Declarations
#DECLARE($in : cs:C1710.ExposedStructure)

If (False:C215)
	C_OBJECT:C1216(STRUCTURE_AUDIT; $1)
End if 

var $storeCache; $isTableUnsynchronized; $isUnsynchronized; $updateCurrentCatalog : Boolean
var $cache; $current; $item; $linkedField; $linkedItem : Object
var $relatedField; $relatedItem; $structure; $tableCatalog : Object
var $cachedCatalog; $currentCatalog; $linkedCatalog; $relatedCatalog; $unsynchronizedFields; $unsynchronizedTables : Collection
var $cacheFile : 4D:C1709.File
var $o : cs:C1710.ob
var $str : cs:C1710.str
var $table : cs:C1710.table
var $field : cs:C1710.field

$currentCatalog:=$in.catalog

// ----------------------------------------------------
// Initialisations

//FIXME: Must return a result and beeing independant of the UI

If (PROJECT.$dialog=Null:C1517)
	
	Logger.warning("📍 Create $dialog (STRUCTURE_AUDIT)")
	PROJECT.$dialog:=New object:C1471
	
End if 

logger.info("STRUCTURE_AUDIT")

$str:=cs:C1710.str.new()

// ----------------------------------------------------
// Compare to cached catalog (the last valid)
$cacheFile:=PROJECT.getCatalogFile()

If ($cacheFile.exists)
	
	$cache:=JSON Parse:C1218($cacheFile.getText())
	$cachedCatalog:=$cache.structure.definition
	
	// Was the structure changed?
	If ($cachedCatalog#Null:C1517)\
		 && Not:C34($cachedCatalog.equal($currentCatalog))
		
		$unsynchronizedTables:=New collection:C1472
		
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
					
					If ($table.value[""].name#Null:C1517)
						
						// Check TABLE NAME & PRIMARY KEY
						$isTableUnsynchronized:=($tableCatalog.name#$table.value[""].name)\
							 || (String:C10($tableCatalog.primaryKey)#String:C10($table.value[""].primaryKey))
						
						If (Not:C34($isTableUnsynchronized))
							
							For each ($item; PROJECT.fields($table.value))
								
								Case of 
										
										//______________________________________________________
									: ($item.value.kind="storage")
										
										$field:=$table.value[$item.key]
										$field.current:=$tableCatalog.field.query("fieldNumber = :1 & kind = storage"; Num:C11($item.key)).pop()
										$field.fieldNumber:=Num:C11($item.key)
										$field.missing:=$field.current=Null:C1517
										
										If (Not:C34($field.missing))
											
											$field.nameMismatch:=Not:C34($str.setText($field.name).equal($field.current.name))
											$field.typeMismatch:=$field.fieldType#$field.current.fieldType
											
										End if 
										
										If ($field.missing\
											 || Bool:C1537($field.nameMismatch)\
											 || Bool:C1537($field.typeMismatch))
											
											$isTableUnsynchronized:=True:C214
											
											Case of 
													
													//______________________________________________________
												: ($field.missing)
													
													$field.tableTips:=$str.localize("theFieldNameIsMissing"; $field.name)
													$field.fieldTips:=$str.localize("theFieldIsMissing")
													
													//______________________________________________________
												: ($field.nameMismatch)
													
													$field.tableTips:=$str.localize("theFieldNameWasRenamed"; New object:C1471(\
														"old"; $field.name; \
														"new"; $field.current.name))
													$field.fieldTips:=$str.localize("theFieldWasRenamed"; $field.current.name)
													
													//______________________________________________________
												: (Bool:C1537($field.typeMismatch))
													
													$field.tableTips:=$str.localize("theFieldNameTypeWasModified"; $field.name)
													$field.fieldTips:=$str.localize("theFieldTypeWasModified")
													
													//______________________________________________________
											End case 
											
											// Append faulty field
											$unsynchronizedFields.push($field)
											
										End if 
										
										//______________________________________________________
									: ($item.value.kind="calculated")\
										 | ($item.value.kind="alias")
										
										$field:=$table.value[$item.key]
										$field.name:=$item.key
										$field.current:=$tableCatalog.field.query("name = :1 & kind = :2"; $item.key; $item.value.kind).pop()
										$field.missing:=$field.current=Null:C1517
										
										If (Not:C34($field.missing))
											
											$field.nameMismatch:=Not:C34($str.setText($item.key).equal($field.current.name))
											$field.typeMismatch:=$field.fieldType#$field.current.fieldType
											
										End if 
										
										If ($field.missing\
											 || Bool:C1537($field.nameMismatch)\
											 || Bool:C1537($field.typeMismatch))
											
											$isTableUnsynchronized:=True:C214
											
											Case of 
													
													//______________________________________________________
												: ($field.missing)
													
													$field.tableTips:=$str.localize("theFieldNameIsMissing"; $item.key)
													$field.fieldTips:=$str.localize("theFieldIsMissing")
													
													//______________________________________________________
												: ($field.nameMismatch)
													
													$field.tableTips:=$str.localize("theFieldNameWasRenamed"; New object:C1471(\
														"old"; $item.key; \
														"new"; $field.current.name))
													$field.fieldTips:=$str.localize("theFieldWasRenamed"; $field.current.name)
													
													//______________________________________________________
												: (Bool:C1537($field.typeMismatch))
													
													$field.tableTips:=$str.localize("theFieldNameTypeWasModified"; $item.key)
													$field.fieldTips:=$str.localize("theFieldTypeWasModified")
													
													//______________________________________________________
											End case 
											
											// Append faulty field
											$unsynchronizedFields.push($field)
											
										End if 
										
										//______________________________________________________
									: ($item.value.kind="relatedEntities")
										
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
										
										If ($field.missing\
											 || Bool:C1537($field.nameMismatch)\
											 || Bool:C1537($field.missingRelatedDataclass))
											
											Case of 
													
													//______________________________________________________
												: (Bool:C1537($field.missingRelatedDataclass))
													
													$field.tableTips:=$str.localize("theRelatedTableIsNoLongerAvailable"; $field.relatedEntities)
													$field.fieldTips:=$field.tableTips
													
													//______________________________________________________
												: ($field.missing)
													
													$field.tableTips:=$str.localize("theRelatedFieldIsMissingOrHasBeenModified"; $item.key)
													$field.fieldTips:=$field.tableTips
													
													//______________________________________________________
												: ($field.nameMismatch)
													
													$field.tableTips:=$str.localize("theFieldNameWasRenamed"; New object:C1471(\
														"old"; $item.key; \
														"new"; $field.current.name))
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
									: ($item.value.kind="relatedEntity")
										
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
													
													$field.tableTips:=$str.localize("theRelatedTableIsNoLongerAvailable"; $field.relatedDataClass)
													$field.fieldTips:=$field.tableTips
													
													//______________________________________________________
												: ($field.missing)
													
													$field.tableTips:=$str.localize("theRelationIsNoLongerAvailable"; $item.key)
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
													: ($relatedField.kind="storage")
														
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
																	
																	$relatedField.tableTips:=$str.localize("theFieldNameIsMissing"; $relatedField.name)
																	$relatedField.fieldTips:=$relatedField.tableTips
																	
																	//______________________________________________________
																: ($relatedField.nameMismatch)
																	
																	$relatedField.tableTips:=$str.localize("theFieldNameWasRenamed"; New object:C1471(\
																		"old"; $relatedField.name; \
																		"new"; $relatedField.current.name))
																	$relatedField.fieldTips:=$relatedField.tableTips
																	
																	//______________________________________________________
																: (Bool:C1537($relatedField.typeMismatch))
																	
																	$relatedField.tableTips:=$str.localize("theFieldNameTypeWasModified")
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
													: ($relatedField.kind="relatedEntities")
														
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
																	
																	$relatedField.tableTips:=$str.localize("the1NRelationIsNoMoreAvailable"; $relatedField.name)
																	$relatedField.fieldTips:=$relatedField.tableTips
																	
																	//______________________________________________________
																: ($relatedField.nameMismatch)
																	
																	$relatedField.tableTips:=$str.localize("theFieldNameWasRenamed"; New object:C1471(\
																		"old"; $relatedItem.key; \
																		"new"; String:C10($relatedField.name)))
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
													: ($relatedField.kind="relatedEntity")
														
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
																		
																		$linkedField.tableTips:=$str.localize("theFieldNameIsMissing"; $linkedField.name)
																		$linkedField.fieldTips:=$linkedField.tableTips
																		
																		//______________________________________________________
																	: ($linkedField.nameMismatch)
																		
																		$linkedField.tableTips:=$str.localize("theFieldNameWasRenamed"; New object:C1471(\
																			"old"; $linkedField.name; \
																			"new"; $linkedField.current.name))
																		$linkedField.fieldTips:=$linkedField.tableTips
																		
																		//______________________________________________________
																	: (Bool:C1537($linkedField.typeMismatch))
																		
																		$linkedField.tableTips:=$str.localize("theFieldNameTypeWasModified")
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
																	
																	$relatedField.tableTips:=$str.localize("theFieldNameIsMissing"; $relatedField.name)
																	$relatedField.fieldTips:=$relatedField.tableTips
																	
																	//______________________________________________________
																: ($relatedField.nameMismatch)
																	
																	$relatedField.tableTips:=$str.localize("theFieldNameWasRenamed"; New object:C1471(\
																		"old"; $relatedItem.key; \
																		"new"; $relatedField.current.name))
																	$relatedField.fieldTips:=$relatedField.tableTips
																	
																	//______________________________________________________
																: (Bool:C1537($relatedField.typeMismatch))
																	
																	$relatedField.tableTips:=$str.localize("theFieldNameTypeWasModified")
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
														
														oops
														
														//______________________________________________________
												End case 
											End for each 
										End if 
										
										$field.current:=$current
										
										//______________________________________________________
									Else 
										
										oops
										
										//______________________________________________________
								End case 
							End for each 
						End if 
					End if 
				End if 
				
				If ($isTableUnsynchronized)
					
					$isUnsynchronized:=True:C214
					
					// THE FIELD COLLECTION IS EMPTY IF THE TABLE IS MISSING
					$unsynchronizedTables[Num:C11($table.key)]:=$unsynchronizedFields
					
				End if 
			End for each 
		End if 
		
		If ($isUnsynchronized)
			
			// Display alert only one time
			If (UI.isNotLocked())
				
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
			
			// The changes has no influence on the data model -> Update the cache
			logger.info("STRUCTURE_AUDIT: Update the cache (no-impact changes)")
			$structure:=$cache.structure=Null:C1517 ? New object:C1471 : $cache.structure
			$structure.definition:=$currentCatalog
			$structure.digest:=Generate digest:C1147(JSON Stringify:C1217($currentCatalog); SHA1 digest:K66:2)
			$cache.structure:=$structure
			$cacheFile.setText(JSON Stringify:C1217($cache; *))
			
			$updateCurrentCatalog:=True:C214
			
		End if 
		
		// Keep state
		Form:C1466.$dialog.unsynchronizedTables:=$unsynchronizedTables
		
	Else 
		
		// Reset
		Form:C1466.$dialog.unsynchronizedTables:=New collection:C1472
		
		// Update the cache
		logger.info("STRUCTURE_AUDIT: Update the cache")
		$storeCache:=True:C214
		$updateCurrentCatalog:=True:C214
		
	End if 
	
Else 
	
	// Create the cache
	logger.info("STRUCTURE_AUDIT: Create the cache")
	$storeCache:=True:C214
	$updateCurrentCatalog:=True:C214
	
End if 

If ($storeCache\
 & ($currentCatalog#Null:C1517))
	
	$cache:=New object:C1471(\
		"structure"; New object:C1471(\
		"definition"; $currentCatalog; \
		"digest"; Generate digest:C1147(JSON Stringify:C1217($currentCatalog); SHA1 digest:K66:2)))
	
	$cacheFile.setText(JSON Stringify:C1217($cache; *))
	
End if 

If ($updateCurrentCatalog)\
 && ((Not:C34($isUnsynchronized)) | (Form:C1466.$catalog=Null:C1517))
	
	// Keep the current catalog
	Form:C1466.$catalog:=$currentCatalog
	
End if 

// Save project
PROJECT.save()

// Store the status
$o:=cs:C1710.ob.new(Form:C1466)
$o.createPath("structure").structure.unsynchronized:=$isUnsynchronized
$o.createPath("status").structure.dataModel:=Not:C34($isUnsynchronized)

UI.callMeBack("description"; New object:C1471(\
"show"; $isUnsynchronized))

// Refresh UI
STRUCTURE_Handler(New object:C1471(\
"action"; "update"; \
"project"; PROJECT))