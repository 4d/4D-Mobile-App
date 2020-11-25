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
C_LONGINT:C283($tableIndex; $relatedCount; $publishedCount; $Win_current)
C_TEXT:C284($key; $tt)
C_OBJECT:C1216($catalog; $field; $cache; $datastore)
C_OBJECT:C1216($relatedField; $tableModel; $oo)
C_COLLECTION:C1488($unsynchronizedTableFields; $unsynchronizedFields)

var $file : 4D:C1709.File
var $backup : 4D:C1709.Folder

// ----------------------------------------------------
// Initialisations
$datastore:=catalog("datastore").datastore

// ----------------------------------------------------
// Make a Backup of the project & catalog
$file:=PROJECT.$project.file  // Project.4dmobileapp

$backup:=PROJECT.$project.file.parent.folder(Replace string:C233(Get localized string:C991("replacedFiles"); "{stamp}"; str_date("stamp")))
$backup.create()

$file.copyTo($backup)
$file:=$file.parent.file("catalog.json").copyTo($backup)

For each ($unsynchronizedTableFields; PROJECT.$dialog.unsynchronizedTableFields)
	
	If ($unsynchronizedTableFields#Null:C1517)
		
		If ($unsynchronizedTableFields.length=0)
			
			// ❌ THE TABLE DOESN'T EXIST ANYMORE
			OB REMOVE:C1226(PROJECT.dataModel; String:C10($tableIndex))
			
		Else 
			
			// Check the fields
			$tableModel:=PROJECT.dataModel[String:C10($tableIndex)]
			$publishedCount:=0
			
			//For each ($key; $tableModel)
			//Case of 
			////______________________________________________________
			//: (Length($key)=0)
			//// TABLE PROPERTIES
			////______________________________________________________
			//: (PROJECT.isField($key))
			////$field:=$unsynchronizedTableFields.query("fieldNumber = :1"; Num($key)).pop()
			////If ($field=Null)  // NOT unsynchronized
			////$publishedCount:=$publishedCount+1
			////Else 
			////Case of 
			//////______________________________________________________
			////: ($field.missing)
			////OB REMOVE($tableModel; String($key))
			//////______________________________________________________
			////: ($field.typeMismatch)
			////// Detect compatible types
			////Case of 
			//////……………………………………………………………………………………………………………………………………………………………………………
			////: (($field.fieldType=Is alpha field) & ($field.current.fieldType=Is text)) | (($field.fieldType=Is text) & ($field.current.fieldType=Is alpha field))  // String
			////$tableModel[$key].fieldType:=$field.current.fieldType
			////$publishedCount:=$publishedCount+1
			//////……………………………………………………………………………………………………………………………………………………………………………
			////: (($field.current.fieldType=Is integer) | ($field.current.fieldType=Is longint) | ($field.current.fieldType=Is integer 64 bits) | ($field.current.fieldType=Is real) | ($field.current.fieldType=_o_Is float)) & (($field.fieldType=Is integer) | ($field.fieldType=Is longint) | ($field.fieldType=Is integer 64 bits) | ($field.fieldType=Is real) | ($field.fieldType=_o_Is float))  // Numeric
			////$tableModel[$key].fieldType:=$field.current.fieldType
			////$publishedCount:=$publishedCount+1
			//////……………………………………………………………………………………………………………………………………………………………………………
			////Else 
			////OB REMOVE($tableModel; String($key))
			//////……………………………………………………………………………………………………………………………………………………………………………
			////End case 
			//////______________________________________________________
			////Else 
			////// Only name was modified: ACCEPT
			////$tableModel[$key].name:=$field.current.name
			////$publishedCount:=$publishedCount+1
			//////______________________________________________________
			////End case 
			////End if 
			////______________________________________________________
			//: ((Value type($tableModel[$key])#Is object))
			//// <NOTHING MORE TO DO>
			////______________________________________________________
			//: (PROJECT.isRelationToOne($tableModel[$key]))  // N -> 1 relation
			//If ($datastore[$tableModel[$key].relatedDataClass]=Null)
			//// THE RELATED TABLE DOESN'T EXIST ANYMORE
			//OB REMOVE($tableModel; String($key))
			//Else 
			//$relatedCount:=0
			//For each ($tt; $tableModel[$key])
			//Case of 
			////…………………………………………………………………………
			//: (PROJECT.isField($tt))
			//$relatedField:=$tableModel[$key][$tt]
			//$unsynchronizedFields:=$unsynchronizedTableFields.extract("fields")
			//If ($unsynchronizedFields.length>0)
			//If ($unsynchronizedFields[0].query("relatedTableNumber = :1 & name = :2"; $relatedField.relatedTableNumber; $relatedField.name).length=1)
			//OB REMOVE($tableModel[$key]; $tt)
			//Else 
			//$relatedCount:=$relatedCount+1
			//End if 
			//Else 
			//$relatedCount:=$relatedCount+1
			//End if 
			////…………………………………………………………………………
			//: ((Value type($tableModel[$key])#Is object))
			//// <NOTHING MORE TO DO>
			////…………………………………………………………………………
			//Else 
			//// NOT YET MANAGED
			////…………………………………………………………………………
			//End case 
			//End for each 
			//If ($relatedCount=0)
			//// NO MORE PUBLISHED FIELDS FROM THE RELATED TABLE
			//OB REMOVE($tableModel; $key)
			//Else 
			//$publishedCount:=$publishedCount+1
			//End if 
			//End if 
			////______________________________________________________
			//: (PROJECT.isRelationToMany($tableModel[$key]))  // 1 -> N relation
			////If ($datastore[$tableModel[$key].relatedEntities]=Null)
			////// THE RELATED TABLE DOESN'T EXIST ANYMORE
			////OB REMOVE($tableModel; String($key))
			////Else 
			////$publishedCount:=$publishedCount+1
			////End if 
			////________________________________________
			//End case 
			//End for each
			
			var $item : Object
			For each ($item; PROJECT.fields($tableModel))
				
				Case of 
						
						//______________________________________________________
					: (PROJECT.isField($item.key))
						
						$field:=$unsynchronizedTableFields.query("fieldNumber = :1"; Num:C11($item.key)).pop()
						
						If ($field=Null:C1517)  // 😇 NOT unsynchronized
							
							$publishedCount:=$publishedCount+1
							
						Else 
							
							Case of 
									
									//______________________________________________________
								: ($field.missing)
									
									// ❌ REMOVE THE MISSING FIELD
									OB REMOVE:C1226($tableModel; String:C10($item.key))
									
									//______________________________________________________
								: ($field.typeMismatch)  // Search if the new type is compatible
									
									Case of 
											
											//………………………………………………………………………………………………………………
										: (PROJECT.isString($field.fieldType))\
											 & (PROJECT.isString($field.current.fieldType))
											
											$tableModel[$item.key].fieldType:=$field.current.fieldType
											$publishedCount:=$publishedCount+1
											
											//………………………………………………………………………………………………………………
										: (PROJECT.isNumeric($field.fieldType))\
											 & (PROJECT.isNumeric($field.current.fieldType))
											
											$tableModel[$item.key].fieldType:=$field.current.fieldType
											$publishedCount:=$publishedCount+1
											
											//………………………………………………………………………………………………………………
										Else 
											
											// ❌ REMOVE THE NON TYPE COMPATIBLE FIELD
											OB REMOVE:C1226($tableModel; String:C10($item.key))
											
											//………………………………………………………………………………………………………………
									End case 
									
									//______________________________________________________
								: ($field.nameMismatch)  // Only the name has been changed
									
									$tableModel[$item.key].name:=$field.current.name
									$publishedCount:=$publishedCount+1
									
									//______________________________________________________
								Else 
									
									ASSERT:C1129(False:C215; "😰 I wonder why I'm here")
									
									//______________________________________________________
							End case 
						End if 
						
						//______________________________________________________
					: (PROJECT.isRelationToOne($item.value))  // N -> 1 relation
						
						If ($datastore[$tableModel[$item.key].relatedDataClass]=Null:C1517)
							
							// ❌ THE RELATED TABLE DOESN'T EXIST ANYMORE
							OB REMOVE:C1226($tableModel; String:C10($item.key))
							
						Else 
							
							$relatedCount:=0
							
							For each ($tt; $tableModel[$item.key])
								
								Case of 
										
										//…………………………………………………………………………
									: (PROJECT.isField($tt))
										
										$relatedField:=$tableModel[$item.key][$tt]
										
										$unsynchronizedFields:=$unsynchronizedTableFields.extract("fields")
										
										If ($unsynchronizedFields.length>0)
											
											If ($unsynchronizedFields[0].query("relatedTableNumber = :1 & name = :2"; $relatedField.relatedTableNumber; $relatedField.name).length=1)
												
												OB REMOVE:C1226($tableModel[$item.key]; $tt)
												
											Else 
												
												$relatedCount:=$relatedCount+1
												
											End if 
											
										Else 
											
											$relatedCount:=$relatedCount+1
											
										End if 
										
										//…………………………………………………………………………
									: ((Value type:C1509($tableModel[$item.key])#Is object:K8:27))
										
										// <NOTHING MORE TO DO>
										
										//…………………………………………………………………………
									Else 
										
										// NOT YET MANAGED
										
										//…………………………………………………………………………
								End case 
							End for each 
							
							If ($relatedCount=0)
								
								// ❌ NO MORE PUBLISHED FIELDS FROM THE RELATED TABLE
								OB REMOVE:C1226($tableModel; $item.key)
								
							Else 
								
								$publishedCount:=$publishedCount+1
								
							End if 
						End if 
						
						//______________________________________________________
					: (PROJECT.isRelationToMany($item.value))  // 1 -> N relation
						
						If ($datastore[$tableModel[$item.key].relatedEntities]=Null:C1517)
							
							// ❌ REMOVE THE MISSING TABLE
							OB REMOVE:C1226($tableModel; String:C10($item.key))
							
						Else 
							
							$publishedCount:=$publishedCount+1
							
						End if 
						
						//______________________________________________________
					Else 
						
						ASSERT:C1129(False:C215; "😰 I wonder why I'm here")
						
						//______________________________________________________
				End case 
			End for each 
			
			If ($publishedCount=0)
				
				// ❌ NO MORE FIELDS PUBLISHED FOR THIS TABLE
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

$file:=PROJECT.$project.file.parent.file("catalog.json")

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
STRUCTURE_Handler(New object:C1471("action"; "update"; "project"; PROJECT))

project_REPAIR(PROJECT)

// Save project
PROJECT.save()

// Update UI
$Win_current:=Current form window:C827
CALL FORM:C1391($Win_current; "editor_CALLBACK"; "updateRibbon")
CALL FORM:C1391($Win_current; "editor_CALLBACK"; "refreshViews")
CALL FORM:C1391($Win_current; "editor_CALLBACK"; "pickerHide")
CALL FORM:C1391($Win_current; "editor_CALLBACK"; "description"; New object:C1471("show"; False:C215))
