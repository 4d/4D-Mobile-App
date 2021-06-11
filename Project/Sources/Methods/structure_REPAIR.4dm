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
var $cache; $currentTable; $datastore; $field; $item; $linkedItem; $relatedField; $relatedItem; $tableModel : Object
var $unsynchronizedTableFields : Collection
var $file : 4D:C1709.File
var $backup : 4D:C1709.Folder

// ----------------------------------------------------
// Initialisations
$datastore:=catalog("datastore").datastore

// ----------------------------------------------------
// Make a Backup of the project & catalog
$file:=PROJECT._folder.file("project.4dmobileapp")

$backup:=PROJECT._folder.folder(Replace string:C233(Get localized string:C991("replacedFiles"); "{stamp}"; str_date("stamp")))
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
				
				$currentTable:=$tableModel[$item.key]
				
				Case of 
						
						//______________________________________________________
					: (PROJECT.isField($item.key))
						
						$field:=$unsynchronizedTableFields.query("fieldNumber = :1"; Num:C11($item.key)).pop()
						
						Case of 
								
								//______________________________________________________
							: ($field=Null:C1517)  // 😇 We can go dancing
								
								$publishedCount:=$publishedCount+1
								
								//______________________________________________________
							: ($field.missing)  // ❌ THE FIELD DOESN'T EXIST ANYMORE
								
								OB REMOVE:C1226($tableModel; $item.key)
								
								//______________________________________________________
							: ($field.typeMismatch)  // ❓ if the new type is compatible
								
								Case of 
										
										//………………………………………………………………………………………………………………
									: (PROJECT.isString($field.fieldType))\
										 & (PROJECT.isString($field.current.fieldType))  // 🆗
										
										$currentTable.fieldType:=$field.current.fieldType
										$publishedCount:=$publishedCount+1
										
										//………………………………………………………………………………………………………………
									: (PROJECT.isNumeric($field.fieldType))\
										 & (PROJECT.isNumeric($field.current.fieldType))  // 🆗
										
										$currentTable.fieldType:=$field.current.fieldType
										$publishedCount:=$publishedCount+1
										
										//………………………………………………………………………………………………………………
									Else   // ❌ INCOMPATIBLE TYPE
										
										OB REMOVE:C1226($tableModel; $item.key)
										
										//………………………………………………………………………………………………………………
								End case 
								
								//______________________________________________________
							: ($field.nameMismatch)  // 🆗 update the name
								
								$currentTable.name:=$field.current.name
								$publishedCount:=$publishedCount+1
								
								//______________________________________________________
							Else 
								
								ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
								
								//______________________________________________________
								
						End case 
						
						//______________________________________________________
					: (PROJECT.isRelationToOne($item.value))
						
						$field:=$unsynchronizedTableFields.query("name = :1"; $item.key).pop()
						
						If ($field.missing)  // ❌ THE RELATION DOESN'T EXIST ANYMORE
							
							OB REMOVE:C1226($tableModel; $item.key)
							
						Else 
							
							$relatedCount:=0
							
							For each ($relatedItem; PROJECT.fields($currentTable[$item.key]))
								
								$relatedField:=$relatedItem.value
								
								Case of 
										
										//…………………………………………………………………………
									: (PROJECT.isField($relatedItem.key))
										
										$field:=$unsynchronizedTableFields.query("fieldNumber = :1"; Num:C11($relatedItem.key)).pop()
										
										Case of 
												
												//______________________________________________________
											: ($field=Null:C1517)  // 😇 A last one for the road
												
												$relatedCount:=$relatedCount+1
												
												//______________________________________________________
											: ($field.missing)  // ❌ THE FIELD DOESN'T EXIST ANYMORE
												
												OB REMOVE:C1226($currentTable[$item.key]; $relatedItem.key)
												
												//______________________________________________________
											: ($field.typeMismatch)  // ❓ if the new type is compatible
												
												Case of 
														
														//………………………………………………………………………………………………………………
													: (PROJECT.isString($field.fieldType))\
														 & (PROJECT.isString($field.current.fieldType))  // 🆗
														
														$currentTable[$item.key][$relatedItem.key].fieldType:=$field.current.fieldType
														$relatedCount:=$relatedCount+1
														
														//………………………………………………………………………………………………………………
													: (PROJECT.isNumeric($field.fieldType))\
														 & (PROJECT.isNumeric($field.current.fieldType))  // 🆗
														
														$currentTable[$item.key][$relatedItem.key].fieldType:=$field.current.fieldType
														$relatedCount:=$relatedCount+1
														
														//………………………………………………………………………………………………………………
													Else   // ❌ INCOMPATIBLE TYPE
														
														OB REMOVE:C1226($currentTable[$item.key]; $relatedItem.key)
														
														//………………………………………………………………………………………………………………
												End case 
												
												//______________________________________________________
											: ($field.nameMismatch)  // 🆗 update the name
												
												$currentTable[$item.key][$relatedItem.key].name:=$field.current.name
												$relatedCount:=$relatedCount+1
												
												//______________________________________________________
											Else 
												
												ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
												
												//______________________________________________________
												
										End case 
										
										//______________________________________________________
									: (PROJECT.isRelationToMany($relatedField))
										
										$field:=$unsynchronizedTableFields.query("name = :1"; $relatedField.name).pop()
										
										Case of 
												
												//______________________________________________________
											: ($field=Null:C1517)  // 😇 Boss, it's for me
												
												$relatedCount:=$relatedCount+1
												
												//______________________________________________________
											: ($field.missing)  // ❌ THE RELATION DOESN'T EXIST ANYMORE
												
												OB REMOVE:C1226($currentTable; $relatedItem.key)
												
												//______________________________________________________
											Else 
												
												ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
												
												//______________________________________________________
												
										End case 
										
										//______________________________________________________
									: (PROJECT.isRelationToOne($relatedField))
										
										For each ($linkedItem; PROJECT.storageFields($relatedField))
											
											$field:=$unsynchronizedTableFields.query("fieldNumber = :1"; Num:C11($linkedItem.key)).pop()
											
											Case of 
													
													//______________________________________________________
												: ($field=Null:C1517)  // 😇 We're going to end up completely drunk
													
													$relatedCount:=$relatedCount+1
													
													//______________________________________________________
												: ($field.missing)  // ❌ THE RELATION DOESN'T EXIST ANYMORE
													
													OB REMOVE:C1226($currentTable; $linkedItem.key)
													
													//______________________________________________________
												Else 
													
													ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
													
													//______________________________________________________
													
											End case 
											
										End for each 
										
										//________________________________________
								End case 
							End for each 
							
							If ($relatedCount=0)  // ❌ NO MORE PUBLISHED FIELDS FROM THE RELATED TABLE
								OB REMOVE:C1226($tableModel; $item.key)
								
							Else 
								
								$publishedCount:=$publishedCount+1
								
							End if 
						End if 
						
						//______________________________________________________
					: (PROJECT.isRelationToMany($item.value))  // 1 -> N relation
						
						If ($datastore[$tableModel[$item.key].relatedEntities]=Null:C1517)  // ❌ REMOVE THE MISSING TABLE
							OB REMOVE:C1226($tableModel; String:C10($item.key))
							
						Else 
							
							$publishedCount:=$publishedCount+1
							
						End if 
						
						//______________________________________________________
					Else 
						
						ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
						
						//______________________________________________________
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
STRUCTURE_Handler(New object:C1471("action"; "update"))

project_REPAIR(PROJECT)

// Save project
PROJECT.save()

// Update UI
EDITOR.updateRibbon()
EDITOR.refreshViews()
EDITOR.hidePicker()
EDITOR.callMeBack("description"; New object:C1471("show"; False:C215))
EDITOR.callChild("project"; "EDITOR_ON_ACTIVATE")
