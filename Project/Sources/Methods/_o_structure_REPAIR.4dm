//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : structure_REPAIR
// ID[56E1D9BCC2274EB9A67DBE09D54B6636]
// Created 18-1-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
//
// EXECUTION SPACE IS THE FORM EDITOR
//
// ----------------------------------------------------
// Declarations
var $publishedCount; $relatedCount; $tableIndex; $Win_current : Integer
var $cache; $currentField; $datastore; $field; $item; $linkedItem; $relatedField; $relatedItem; $tableModel : Object
var $unsynchronizedTableFields : Collection
var $file : 4D:C1709.File
var $backup : 4D:C1709.Folder

// ----------------------------------------------------
// Initialisations
$datastore:=catalog("datastore").datastore

// ----------------------------------------------------
// Make a Backup of the project & catalog
$file:=PROJECT._folder.file("project.4dmobileapp")

$backup:=PROJECT._folder.folder(Replace string:C233(Get localized string:C991("replacedFiles"); "{stamp}"; _o_str_date("stamp")))
$backup.create()

$file.copyTo($backup)
$file:=$file.parent.file("catalog.json").copyTo($backup)

$tableIndex:=0

For each ($unsynchronizedTableFields; PROJECT.$dialog.unsynchronizedTableFields)
	
	If ($unsynchronizedTableFields#Null:C1517)
		
		If ($unsynchronizedTableFields.length=0)  // ❌ THE TABLE DOESN'T EXIST ANYMORE
			
			OB REMOVE:C1226(PROJECT.dataModel; String:C10($tableIndex))
			
		Else 
			
			// Check the fields
			$tableModel:=PROJECT.dataModel[String:C10($tableIndex)]
			$publishedCount:=0
			
			For each ($item; PROJECT.fields($tableModel))
				
				$currentField:=$tableModel[$item.key]
				
				Case of 
						
						//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
					: (PROJECT.isField($item.key))
						
						$field:=$unsynchronizedTableFields.query("fieldNumber = :1"; Num:C11($item.key)).pop()
						
						Case of 
								
								//======================================
							: ($field=Null:C1517)  // 😇 We can go dancing
								
								$publishedCount:=$publishedCount+1
								
								//======================================
							: ($field.missing)  // ❌ THE FIELD DOESN'T EXIST ANYMORE
								
								OB REMOVE:C1226($tableModel; $item.key)
								
								//======================================
							: ($field.typeMismatch)  // ❓ if the new type is compatible
								
								Case of 
										
										//……………………………………………………………………………………………………
									: (PROJECT.isString($field.fieldType))\
										 & (PROJECT.isString($field.current.fieldType))  // 🆗
										
										$currentField.fieldType:=$field.current.fieldType
										$publishedCount:=$publishedCount+1
										
										//……………………………………………………………………………………………………
									: (PROJECT.isNumeric($field.fieldType))\
										 & (PROJECT.isNumeric($field.current.fieldType))  // 🆗
										
										$currentField.fieldType:=$field.current.fieldType
										$publishedCount:=$publishedCount+1
										
										//……………………………………………………………………………………………………
									Else   // ❌ INCOMPATIBLE TYPE
										
										OB REMOVE:C1226($tableModel; $item.key)
										
										//……………………………………………………………………………………………………
								End case 
								
								//======================================
							: ($field.nameMismatch)  // 🆗 update the name
								
								$currentField.name:=$field.current.name
								$publishedCount:=$publishedCount+1
								
								//======================================
							Else 
								
								ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
								
								//======================================
						End case 
						
						//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
					: (PROJECT.isRelationToOne($item.value))
						
						$field:=$unsynchronizedTableFields.query("name = :1"; $item.key).pop()
						
						If ($field.missing)  // ❌ THE RELATION DOESN'T EXIST ANYMORE
							
							OB REMOVE:C1226($tableModel; $item.key)
							
						Else 
							
							$relatedCount:=0
							
							//For each ($relatedItem; PROJECT.fields($currentField[$item.key]))
							
							For each ($relatedItem; OB Entries:C1720($item.value).query("value.name != null"))
								
								$relatedField:=$relatedItem.value
								
								Case of 
										
										//======================================
									: (PROJECT.isField($relatedItem.key))
										
										$field:=$unsynchronizedTableFields.query("fieldNumber = :1"; Num:C11($relatedItem.key)).pop()
										
										Case of 
												
												//……………………………………………………………………………………………………
											: ($field=Null:C1517)  // 😇 A last one for the road
												
												$relatedCount:=$relatedCount+1
												
												//……………………………………………………………………………………………………
											: ($field.missing)  // ❌ THE FIELD DOESN'T EXIST ANYMORE
												
												OB REMOVE:C1226($currentField[$item.key]; $relatedItem.key)
												
												//……………………………………………………………………………………………………
											: ($field.typeMismatch)  // ❓ if the new type is compatible
												
												Case of 
														
														//------------------------------------
													: (PROJECT.isString($field.fieldType))\
														 & (PROJECT.isString($field.current.fieldType))  // 🆗
														
														$currentField[$item.key][$relatedItem.key].fieldType:=$field.current.fieldType
														$relatedCount:=$relatedCount+1
														
														//------------------------------------
													: (PROJECT.isNumeric($field.fieldType))\
														 & (PROJECT.isNumeric($field.current.fieldType))  // 🆗
														
														$currentField[$item.key][$relatedItem.key].fieldType:=$field.current.fieldType
														$relatedCount:=$relatedCount+1
														
														//------------------------------------
													Else   // ❌ INCOMPATIBLE TYPE
														
														OB REMOVE:C1226($currentField[$item.key]; $relatedItem.key)
														
														//------------------------------------
												End case 
												
												//……………………………………………………………………………………………………
											: ($field.nameMismatch)  // 🆗 update the name
												
												$currentField[$item.key][$relatedItem.key].name:=$field.current.name
												$relatedCount:=$relatedCount+1
												
												//……………………………………………………………………………………………………
											Else 
												
												ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
												
												//……………………………………………………………………………………………………
										End case 
										
										//======================================
									: (PROJECT.isRelationToMany($relatedField))
										
										$field:=$unsynchronizedTableFields.query("name = :1"; $relatedField.name).pop()
										
										Case of 
												
												//……………………………………………………………………………………………………
											: ($field=Null:C1517)  // 😇 Boss, it's for me
												
												$relatedCount:=$relatedCount+1
												
												//……………………………………………………………………………………………………
											: ($field.missing)  // ❌ THE RELATION DOESN'T EXIST ANYMORE
												
												OB REMOVE:C1226($currentField; $relatedItem.key)
												
												//……………………………………………………………………………………………………
											Else 
												
												ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
												
												//……………………………………………………………………………………………………
										End case 
										
										//======================================
									: (PROJECT.isRelationToOne($relatedField))
										
										For each ($linkedItem; PROJECT.storageFields($relatedField))
											
											$field:=$unsynchronizedTableFields.query("fieldNumber = :1"; Num:C11($linkedItem.key)).pop()
											
											Case of 
													
													//……………………………………………………………………………………………………
												: ($field=Null:C1517)  // 😇 We're going to end up completely drunk
													
													$relatedCount:=$relatedCount+1
													
													//……………………………………………………………………………………………………
												: ($field.missing)  // ❌ THE RELATION DOESN'T EXIST ANYMORE
													
													OB REMOVE:C1226($currentField; $linkedItem.key)
													
													//……………………………………………………………………………………………………
												Else 
													
													ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
													
													//……………………………………………………………………………………………………
											End case 
											
										End for each 
										
										//======================================
									: (PROJECT.isComputedAttribute($relatedField))
										
										$field:=$unsynchronizedTableFields.query("name = :1"; $relatedField.name).pop()
										
										Case of 
												
												//……………………………………………………………………………………………………
											: ($field=Null:C1517)  // 😇 A last one for the road
												
												$relatedCount:=$relatedCount+1
												
												//……………………………………………………………………………………………………
											: ($field.missing)  // ❌ THE FIELD DOESN'T EXIST ANYMORE
												
												//OB REMOVE($currentField[$item.key]; $relatedItem.key)
												OB REMOVE:C1226($item.value; $relatedItem.key)
												
												//……………………………………………………………………………………………………
											: ($field.typeMismatch)  // ❓ if the new type is compatible
												
												Case of 
														
														//------------------------------------
													: (PROJECT.isString($field.fieldType))\
														 & (PROJECT.isString($field.current.fieldType))  // 🆗
														
														$currentField[$item.key][$relatedItem.key].fieldType:=$field.current.fieldType
														$relatedCount:=$relatedCount+1
														
														//------------------------------------
													: (PROJECT.isNumeric($field.fieldType))\
														 & (PROJECT.isNumeric($field.current.fieldType))  // 🆗
														
														$currentField[$item.key][$relatedItem.key].fieldType:=$field.current.fieldType
														$relatedCount:=$relatedCount+1
														
														//------------------------------------
													Else   // ❌ INCOMPATIBLE TYPE
														
														//OB REMOVE($currentField[$item.key]; $relatedItem.key)
														OB REMOVE:C1226($item.value; $relatedItem.key)
														
														//------------------------------------
												End case 
												
												//……………………………………………………………………………………………………
											: ($field.nameMismatch)  // 🆗 update the name
												
												$currentField[$item.key][$relatedItem.key].name:=$field.current.name
												$relatedCount:=$relatedCount+1
												
												//……………………………………………………………………………………………………
											Else 
												
												ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
												
												//……………………………………………………………………………………………………
										End case 
										
										
										
										//======================================
								End case 
							End for each 
							
							If ($relatedCount=0)  // ❌ NO MORE PUBLISHED FIELDS FROM THE RELATED TABLE
								
								OB REMOVE:C1226($tableModel; $item.key)
								
							Else 
								
								$publishedCount:=$publishedCount+1
								
							End if 
						End if 
						
						//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
					: (PROJECT.isRelationToMany($item.value))  // 1 -> N relation
						
						If ($datastore[$tableModel[$item.key].relatedEntities]=Null:C1517)  // ❌ REMOVE THE MISSING TABLE
							
							OB REMOVE:C1226($tableModel; String:C10($item.key))
							
						Else 
							
							$publishedCount:=$publishedCount+1
							
						End if 
						
						//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
					: (PROJECT.isComputedAttribute($item.value))  // 1 -> N relation
						
						$field:=$unsynchronizedTableFields.query("name = :1"; $item.key).pop()
						
						Case of 
								
								//======================================
							: ($field=Null:C1517)  // 😇 We can go dancing
								
								$publishedCount:=$publishedCount+1
								
								//======================================
							: ($field.missing)\
								 | ($field.nameMismatch)  // ❌ THE FIELD DOESN'T EXIST ANYMORE
								
								OB REMOVE:C1226($tableModel; $item.key)
								
								//======================================
							: ($field.typeMismatch)  // ❓ if the new type is compatible
								
								Case of 
										
										//……………………………………………………………………………………………………
									: (PROJECT.isString($field.fieldType))\
										 & (PROJECT.isString($field.current.fieldType))  // 🆗
										
										$currentField.fieldType:=$field.current.fieldType
										$publishedCount:=$publishedCount+1
										
										//……………………………………………………………………………………………………
									: (PROJECT.isNumeric($field.fieldType))\
										 & (PROJECT.isNumeric($field.current.fieldType))  // 🆗
										
										$currentField.fieldType:=$field.current.fieldType
										$publishedCount:=$publishedCount+1
										
										//……………………………………………………………………………………………………
									Else   // ❌ INCOMPATIBLE TYPE
										
										OB REMOVE:C1226($tableModel; $item.key)
										
										//……………………………………………………………………………………………………
								End case 
								
								//======================================
							Else 
								
								ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
								
								//======================================
						End case 
						
						//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
					Else 
						
						ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
						
						//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
				End case 
			End for each 
			
			If ($publishedCount=0)  // ❌ NO MORE FIELDS PUBLISHED FOR THIS TABLE
				
				OB REMOVE:C1226(PROJECT.dataModel; String:C10($tableIndex))
				
			End if 
		End if 
	End if 
	
	$tableIndex:=$tableIndex+1
	
End for each 

If (OB Is empty:C1297(PROJECT.dataModel))
	
	OB REMOVE:C1226(PROJECT; "dataModel")
	
End if 

// Update status & cache
OB REMOVE:C1226(PROJECT.$dialog; "unsynchronizedTableFields")
OB REMOVE:C1226(PROJECT.$project.structure; "unsynchronized")

$file:=PROJECT._folder.file("catalog.json")

If ($file.exists)
	
	$cache:=JSON Parse:C1218($file.getText())
	cs:C1710.ob.new($cache).createPath("structure")
	
Else 
	
	$cache:=cs:C1710.ob.new().createPath("structure").content
	
End if 

Form:C1466.$catalog:=_o_structure(New object:C1471("action"; "catalog")).value

$cache.structure.definition:=Form:C1466.$catalog
$cache.structure.digest:=Generate digest:C1147(JSON Stringify:C1217(Form:C1466.$catalog); SHA1 digest:K66:2)

$file.setText(JSON Stringify:C1217($cache; *))

// Refresh UI
STRUCTURE_Handler(New object:C1471(\
"action"; "update"))

_o_project_REPAIR(PROJECT)

// Save project
PROJECT.save()

// Update UI
EDITOR.updateRibbon()
EDITOR.refreshViews()
EDITOR.hidePicker()
EDITOR.updateHeader(New object:C1471("show"; False:C215))
EDITOR.callChild("project"; "PROJECT_ON_ACTIVATE")