//%attributes = {"invisible":true}
/*
***STRUCTURE_CALLBACK*** ( catalog )
 -> catalog (Collection)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : STRUCTURE_CALLBACK
  // Database: 4D Mobile App
  // ID[5CEB938EFFBB4CB9A0436B50327B0EAD]
  // Created #18-1-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Check structure for missing table or fields used in the data model
  // ----------------------------------------------------
  //
  // EXECUTION SPACE IS THE FORM EDITOR
  //
  // ----------------------------------------------------
  // Declarations
C_COLLECTION:C1488($1)

C_BOOLEAN:C305($Boo_unsynchronized;$Boo_unsynchronizedField;$Boo_unsynchronizedTable)
C_LONGINT:C283($Lon_fieldIndx;$Lon_fieldNumber;$Lon_indx;$Lon_parameters;$Lon_relatedTableIndx;$Lon_tableIndx)
C_LONGINT:C283($Lon_tableNumber;$Win_current)
C_TEXT:C284($File_cache;$t;$Txt_digest;$Txt_tableNumber)
C_OBJECT:C1216($ƒ;$o;$Obj_cache;$Obj_dataModel;$Obj_project;$Obj_relatedDataClass)
C_OBJECT:C1216($Obj_structure;$Obj_tableModel;$oo)
C_COLLECTION:C1488($c;$Col_catalog;$Col_unsynchronizedFields;$Col_unsynchronizedTableFields)

If (False:C215)
	C_COLLECTION:C1488(STRUCTURE_CALLBACK ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Col_catalog:=$1
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Win_current:=Current form window:C827
	
	  // First run
	$o:=Form:C1466
	$o:=ob_createPath ($o;"structure")
	
	$Obj_project:=(ui.pointer("project"))->
	ASSERT:C1129($Obj_project#Null:C1517)
	
	$Obj_project:=ob_createPath ($Obj_project;"$dialog")
	
	$ƒ:=Storage:C1525.ƒ
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // Compare to last valid version
$File_cache:=$Obj_project.$project.root+"catalog.json"

$Txt_digest:=Generate digest:C1147(JSON Stringify:C1217($Col_catalog);SHA1 digest:K66:2)

If (Test path name:C476($File_cache)=Is a document:K24:1)
	
	$Obj_cache:=JSON Parse:C1218(Document to text:C1236($File_cache))
	
	  // Has the structure been modified ?
	If ($Txt_digest#String:C10($Obj_cache.structure.digest)) | (Bool:C1537(featuresFlags._8858))
		
		$Col_unsynchronizedTableFields:=New collection:C1472
		
		  // Verify the datamodel
		$Obj_dataModel:=$Obj_project.dataModel
		
		If ($Obj_dataModel#Null:C1517)
			
			For each ($Txt_tableNumber;$Obj_dataModel)
				
				$Obj_tableModel:=$Obj_dataModel[$Txt_tableNumber]
				
				  //If ($Obj_tableModel=Null)
				
				  // NOTHING MORE TO DO - The table is not used in the project
				
				  //Else 
				
				  // Reset unsynchronized table flag
				CLEAR VARIABLE:C89($Boo_unsynchronizedTable)
				
				  // Create unsynchronized fields collection
				$Col_unsynchronizedFields:=New collection:C1472
				
				  // Check that the table is defined in the structure
				$Lon_tableNumber:=Num:C11($Txt_tableNumber)
				
				$Lon_tableIndx:=$Col_catalog.extract("tableNumber").indexOf($Lon_tableNumber)
				$Boo_unsynchronizedTable:=($Lon_tableIndx=-1)  // True if the table doesn't exist anymore
				
				If (Not:C34($Boo_unsynchronizedTable))
					
					  // Check table name & primary key
					$Boo_unsynchronizedTable:=(\
						($Col_catalog[$Lon_tableIndx].name#$Obj_tableModel.name)\
						 | (String:C10($Col_catalog[$Lon_tableIndx].primaryKey)#$Obj_tableModel.primaryKey)\
						)
					
					If (Not:C34($Boo_unsynchronizedTable))
						
						  // Check the fields
						For each ($t;$Obj_tableModel)
							
							  // Reset unsynchronized field flag
							CLEAR VARIABLE:C89($Boo_unsynchronizedField)
							
							$Lon_fieldNumber:=Num:C11($t)
							
							Case of 
									
									  //______________________________________________________
								: ($ƒ.isField($t))
									
									$oo:=$Obj_tableModel[$t]
									
									If (Bool:C1537(featuresFlags.withNewFieldProperties))
										
										$c:=$Col_catalog[$Lon_tableIndx].field.query("fieldNumber = :1";$Lon_fieldNumber)
										$Boo_unsynchronized:=$c.length=0  // True if field doesn't exist anymore
										
									Else 
										
										$Lon_fieldIndx:=$Col_catalog[$Lon_tableIndx].field.extract("id").indexOf($Lon_fieldNumber)
										$Boo_unsynchronizedField:=($Lon_fieldIndx=-1)  // True if field doesn't exist anymore
										
									End if 
									
									If (Not:C34($Boo_unsynchronizedField))
										
										  // Check field name & type
										If (Bool:C1537(featuresFlags.withNewFieldProperties))
											
											$Boo_unsynchronizedField:=_or (\
												New formula:C1597($oo.name#$c[0].name);\
												New formula:C1597($oo.fieldType#$c[0].fieldType))
											
										Else 
											
											$Boo_unsynchronizedField:=(\
												($oo.name#$Col_catalog[$Lon_tableIndx].field[$Lon_fieldIndx].name)\
												 | ($oo.type#$Col_catalog[$Lon_tableIndx].field[$Lon_fieldIndx].type)\
												)
											
										End if 
									End if 
									
									If ($Boo_unsynchronizedField)
										
										$Boo_unsynchronizedTable:=True:C214
										$Col_unsynchronizedFields.push($Lon_fieldNumber)
										
									End if 
									
									  //______________________________________________________
								: ((Value type:C1509($Obj_tableModel[$t])#Is object:K8:27))
									
									  // <NOTHING MORE TO DO>
									
									  //______________________________________________________
								: ($ƒ.isRelatedDataClass($Obj_tableModel[$t]))  // N -> 1 relation
									
									$c:=$Col_catalog[$Lon_tableIndx].field.extract("name")
									$Lon_indx:=$c.indexOf($t)
									$Boo_unsynchronizedField:=($Lon_indx=-1)  // True if relation was deleted or renamed
									
									If (Not:C34($Boo_unsynchronizedField))
										
										  // Perform a diacritical comparison
										$Boo_unsynchronizedField:=Not:C34(str_equal ($t;$c[$Lon_indx]))
										
									End if 
									
									If (Not:C34($Boo_unsynchronizedField))
										
										$oo:=$Obj_tableModel[$t]
										$Lon_relatedTableIndx:=$Col_catalog.extract("tableNumber").indexOf($oo.relatedTableNumber)
										
										If ($Lon_relatedTableIndx#-1)
											
											$Obj_relatedDataClass:=$Col_catalog[$Lon_relatedTableIndx]
											
											For each ($t;$oo)
												
												Case of 
														
														  //…………………………………………………………………………………………
													: ($ƒ.isField($t))
														
														$Lon_fieldIndx:=$Obj_relatedDataClass.field.extract("id").indexOf(Num:C11($t))
														$Boo_unsynchronizedField:=($Lon_fieldIndx=-1)  // True if field doesn't exist anymore
														
														If (Not:C34($Boo_unsynchronizedField))
															
															  // Check field name & type
															If (Bool:C1537(featuresFlags.withNewFieldProperties))
																
																$Boo_unsynchronizedField:=_or (\
																	New formula:C1597($oo[$t].name#$Obj_relatedDataClass.field[$Lon_fieldIndx].name);\
																	New formula:C1597($oo[$t].fieldType#$Obj_relatedDataClass.field[$Lon_fieldIndx].fieldType))
																
															Else 
																
																$Boo_unsynchronizedField:=(\
																	($oo[$t].name#$Obj_relatedDataClass.field[$Lon_fieldIndx].name)\
																	 | ($oo[$t].type#$Obj_relatedDataClass.field[$Lon_fieldIndx].type)\
																	)
																
															End if 
														End if 
														
														If ($Boo_unsynchronizedField)
															
															$Boo_unsynchronizedTable:=True:C214
															
															$Lon_indx:=$Col_unsynchronizedFields.indexOf($t)
															
															If ($Lon_indx=-1)
																
																$Col_unsynchronizedFields.push(New object:C1471($t;New collection:C1472))
																$Lon_indx:=$Col_unsynchronizedFields.length-1
																
															End if 
															
															$Col_unsynchronizedFields[$Lon_indx][$t].push(Num:C11($t))
															
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
											
										Else 
											
											  // The related data class is not published anymore
											$Boo_unsynchronizedField:=True:C214
											$Boo_unsynchronizedTable:=True:C214
											
											  // Append an empty collection
											If ($Col_unsynchronizedFields.indexOf($t)=-1)
												
												$Col_unsynchronizedFields.push(New object:C1471(\
													$t;New collection:C1472))
												
											End if 
											
											  // Mark the related data class as missing
											  // #BUG - si le lien a été renommé
											$Col_unsynchronizedTableFields[$oo.relatedTableNumber]:=New collection:C1472
											
										End if 
										
									Else 
										
										$Boo_unsynchronizedTable:=True:C214
										
										  // Append an empty collection
										If ($Col_unsynchronizedFields.indexOf($t)=-1)
											
											$Col_unsynchronizedFields.push(New object:C1471($t;New collection:C1472))
											
										End if 
									End if 
									
									  //______________________________________________________
							End case 
						End for each 
					End if 
				End if 
				
				If ($Boo_unsynchronizedTable)
					
					$Boo_unsynchronized:=True:C214
					$Col_unsynchronizedTableFields[$Lon_tableNumber]:=$Col_unsynchronizedFields  // Empty collection if the table is no more available
					
				End if 
				  //End if 
			End for each 
		End if 
		
		If ($Boo_unsynchronized)
			
			  // Display alert only one time
			If (Not:C34(editor_Locked ))
				
				POST_FORM_MESSAGE (New object:C1471(\
					"target";$Win_current;\
					"action";"show";\
					"type";"confirm";\
					"title";"theDatabaseStructureWasModified";\
					"additional";"theDataModelIsNoMoreValidAndMustBeUpdated";\
					"cancel";"reviewing";\
					"cancelAction";"page_structure";\
					"ok";"update";\
					"okFormula";New formula:C1597(CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"syncDataModel"))))
				
			End if 
			
		Else 
			
			  // Keep the current structure
			Form:C1466.$catalog:=$Col_catalog
			
			  // The changes has no influence on the data model -> Update the cache
			$Obj_structure:=Choose:C955($Obj_cache.structure=Null:C1517;New object:C1471;$Obj_cache.structure)
			
			$Obj_structure.definition:=$Col_catalog
			$Obj_structure.digest:=$Txt_digest
			
			$Obj_cache.structure:=$Obj_structure
			TEXT TO DOCUMENT:C1237($File_cache;JSON Stringify:C1217($Obj_cache;*))
			
		End if 
		
		  // Keep state
		$Obj_project.$dialog.unsynchronizedTableFields:=$Col_unsynchronizedTableFields
		
	Else 
		
		  // Reset
		$Obj_project.$dialog.unsynchronizedTableFields:=New collection:C1472
		
	End if 
	
Else 
	
	  // Create the cache
	If ($Col_catalog#Null:C1517)
		
		$Obj_structure:=New object:C1471
		
		$Obj_cache:=New object:C1471(\
			"structure";$Obj_structure)
		
		$Obj_structure.definition:=$Col_catalog
		$Obj_structure.digest:=$Txt_digest
		
		TEXT TO DOCUMENT:C1237($File_cache;JSON Stringify:C1217($Obj_cache;*))
		
	End if 
End if 

  // Keep the current structure
If (Not:C34($Boo_unsynchronized))\
 | (Form:C1466.$catalog=Null:C1517)
	
	Form:C1466.$catalog:=$Col_catalog
	
End if 

  // Store the status
Form:C1466.structure.unsynchronized:=$Boo_unsynchronized

If (Form:C1466.status=Null:C1517)
	
	Form:C1466.status:=New object:C1471(\
		"dataModel";Not:C34($Boo_unsynchronized))
	
Else 
	
	Form:C1466.status.dataModel:=Not:C34($Boo_unsynchronized)
	
End if 

  //#106068 - [BUG] Delete table when published
Form:C1466.$catalog:=$Col_catalog

  // Refresh UI
STRUCTURE_Handler (New object:C1471(\
"action";"update";\
"project";$Obj_project))

  // Save project
CALL FORM:C1391($Win_current;"project_SAVE")

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End