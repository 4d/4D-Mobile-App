//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : STRUCTURE_CALLBACK
  // ID[5CEB938EFFBB4CB9A0436B50327B0EAD]
  // Created 18-1-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Check the structure for the tables and fields used in the data model by
  // comparing to the last valid version of the catalog.
  // ----------------------------------------------------
  //
  // EXECUTION SPACE IS THE FORM EDITOR
  //
  // ----------------------------------------------------
  // Declarations
C_COLLECTION:C1488($1)

C_BOOLEAN:C305($Boo__unsynchronized;$Boo_unsynchronizedField;$Boo_unsynchronizedTable)
C_LONGINT:C283($l)
C_TEXT:C284($t;$tt;$Txt_table)
C_OBJECT:C1216($file;$ƒ;$o;$Obj_cache;$Obj_dataModel;$Obj_project)
C_OBJECT:C1216($Obj_structure;$Obj_tableCurrent;$Obj_tableModel;$str)
C_COLLECTION:C1488($c;$cc;$Col_cachedCatalog;$Col_currentCatalog;$Col_unsynchronizedFields;$Col_unsynchronizedTableFields)

If (False:C215)
	C_COLLECTION:C1488(STRUCTURE_CALLBACK ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=1;"Missing parameter"))
	
	  // Required parameters
	$Col_currentCatalog:=$1  // Current catalog
	
	  // Default values
	
	  // Optional parameters
	  // <NONE>
	
	  // First run
	$o:=Form:C1466
	$o:=ob_createPath ($o;"structure")
	
	$Obj_project:=(ui.pointer("project"))->
	ASSERT:C1129($Obj_project#Null:C1517)
	
	$Obj_project:=ob_createPath ($Obj_project;"$dialog")
	
	$ƒ:=Storage:C1525.ƒ
	
	$str:=str ()
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // Compare to cached catalog (the last valid)
$file:=File:C1566($Obj_project.$project.root+"catalog.json";fk platform path:K87:2)

If ($file.exists)
	
	$Obj_cache:=JSON Parse:C1218($file.getText())
	
	$Col_cachedCatalog:=$Obj_cache.structure.definition
	
	  // Has the structure been modified ?
	If (Not:C34($Col_cachedCatalog.equal($Col_currentCatalog)))\
		 | (Bool:C1537(featuresFlags._8858))
		
		$Col_unsynchronizedTableFields:=New collection:C1472
		
		  // Verify the compliance of the data model with the current catalog
		$Obj_dataModel:=$Obj_project.dataModel
		
		If ($Obj_dataModel#Null:C1517)
			
			  // For each TABLE published
			For each ($Txt_table;$Obj_dataModel)
				
				$Obj_tableModel:=$Obj_dataModel[$Txt_table]
				
				  // Reset unsynchronized table flag
				CLEAR VARIABLE:C89($Boo_unsynchronizedTable)
				
				  // Create unsynchronized fields collection
				$Col_unsynchronizedFields:=New collection:C1472
				
				  // Check that the table is defined in the current catalog
				$c:=$Col_currentCatalog.query("tableNumber = :1";Num:C11($Txt_table))
				
				$Boo_unsynchronizedTable:=($c.length=0)  // True if the table doesn't exist anymore
				
				If (Not:C34($Boo_unsynchronizedTable))
					
					$Obj_tableCurrent:=$c[0]
					
					  // Check TABLE NAME & PRIMARY KEY
					$Boo_unsynchronizedTable:=($Obj_tableCurrent.name#$Obj_tableModel.name)\
						 | ($Obj_tableCurrent.primaryKey#$Obj_tableModel.primaryKey)
					
					If (Not:C34($Boo_unsynchronizedTable))
						
						For each ($t;$Obj_tableModel)
							
							If ($ƒ.isField($t))
								
								  // FIELD
								
								$o:=$Obj_tableModel[$t]
								$c:=$Obj_tableCurrent.field.query("fieldNumber = :1";Num:C11($t))
								
								$Boo_unsynchronizedField:=_or (\
									Formula:C1597($c.length=0);\
									Formula:C1597($o.name#$c[0].name);\
									Formula:C1597($o.fieldType#$c[0].fieldType)\
									)
								
								If ($Boo_unsynchronizedField)
									
									  // THE FIELD IS NO LONGER AVAILABLE
									  // OR IF THE NAME HAS BEEN CHANGED (diacritical)
									
									$Boo_unsynchronizedTable:=True:C214
									
									  // Append definition of faulty field
									$Col_unsynchronizedFields.push($o)
									
								End if 
								
							Else 
								
								If (Value type:C1509($Obj_tableModel[$t])=Is object:K8:27)
									
									  // RELATION
									
									$o:=$Obj_tableModel[$t]
									$c:=$Obj_tableCurrent.field.query("name = :1";$t)
									
									Case of 
											
											  //________________________________________
										: ($ƒ.isRelationToOne($o))  // N -> 1 relation
											
											$Boo_unsynchronizedField:=_or (\
												Formula:C1597($c.length=0);\
												Formula:C1597(Not:C34($str.setText($t).equal($c[0].name)))\
												)
											
											If ($Boo_unsynchronizedField)
												
												  // THE FIELD IS NO LONGER AVAILABLE
												  // OR IF THE NAME HAS BEEN CHANGED (diacritical)
												
												$Boo_unsynchronizedTable:=True:C214
												
												  // Append with an empty collection
												If ($Col_unsynchronizedFields.query("name= :1";$t).length=0)
													
													$Col_unsynchronizedFields.push(New object:C1471(\
														"name";$t;"fields";New collection:C1472))
													
												End if 
												
											Else 
												
												  // Check related table catalog
												$c:=$Col_currentCatalog.query("tableNumber = :1";$o.relatedTableNumber)
												
												If ($c.length=1)
													
													  // Check related data class catalog
													For each ($tt;$o)
														
														If ($ƒ.isField($tt))
															
															$l:=$c[0].field.extract("id").indexOf(Num:C11($tt))
															
															$Boo_unsynchronizedField:=_or (\
																Formula:C1597($l=-1);\
																Formula:C1597($o[$tt].name#$c[0].field[$l].name);\
																Formula:C1597($o[$tt].fieldType#$c[0].field[$l].fieldType)\
																)
															
															If ($Boo_unsynchronizedField)
																
																  // TRUE IF THE FIELD IS NO LONGER AVAILABLE
																  // OR IF THE NAME (non diacritical) OR TYPE HAS BEEN CHANGED
																
																$Boo_unsynchronizedTable:=True:C214
																
																$cc:=$Col_unsynchronizedFields.query("name= :1";$t)
																
																If ($cc.length=0)
																	
																	$Col_unsynchronizedFields.push(New object:C1471(\
																		"name";$t;"fields";New collection:C1472(Num:C11($tt))))
																	
																Else 
																	
																	$cc[0].fields.push(Num:C11($tt))
																	
																End if 
															End if 
															
														Else 
															
															  // NOT YET MANAGED
															
														End if 
													End for each 
													
												Else 
													
													  // THE RELATED DATA CLASS IS MISSING
													
													$Boo_unsynchronizedField:=True:C214
													$Boo_unsynchronizedTable:=True:C214
													
													  // Append with an empty collection
													If ($Col_unsynchronizedFields.query("name= :1";$t).length=0)
														
														$Col_unsynchronizedFields.push(New object:C1471(\
															$t;New collection:C1472))
														
													End if 
													
													  // Mark the related data class as missing
													  // #BUG - si le lien a été renommé
													$Col_unsynchronizedTableFields[$o.relatedTableNumber]:=New collection:C1472
													
												End if 
											End if 
											
											  //________________________________________
										: ($ƒ.isRelationToMany($o))  // 1 -> N relation
											
											If (_or (\
												Formula:C1597($c.length=0);\
												Formula:C1597(Not:C34($str.setText($t).equal($c[0].name)))))
												
												  // THE FIELD IS NO LONGER AVAILABLE
												  // OR IF THE NAME HAS BEEN CHANGED (diacritical)
												
												$Boo_unsynchronizedTable:=True:C214
												
												  // Append definition of faulty relation
												If ($Col_unsynchronizedFields.indexOf($t)=-1)
													
													$Col_unsynchronizedFields.push(New object:C1471(\
														$t;$o))
													
												End if 
											End if 
											
											  //________________________________________
									End case 
								End if 
							End if 
						End for each 
					End if 
				End if 
				
				If ($Boo_unsynchronizedTable)
					
					$Boo__unsynchronized:=True:C214
					
					  // THE FIELD COLLECTION IS EMPTY IF THE TABLE IS MISSING
					$Col_unsynchronizedTableFields[Num:C11($Txt_table)]:=$Col_unsynchronizedFields
					
				End if 
			End for each 
		End if 
		
		If ($Boo__unsynchronized)
			
			  // Display alert only one time
			If (Not:C34(editor_Locked ))
				
				POST_FORM_MESSAGE (New object:C1471(\
					"target";Current form window:C827;\
					"action";"show";\
					"type";"confirm";\
					"title";"theDatabaseStructureWasModified";\
					"additional";"theDataModelIsNoMoreValidAndMustBeUpdated";\
					"cancel";"reviewing";\
					"cancelAction";"page_structure";\
					"ok";"update";\
					"okFormula";Formula:C1597(CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"syncDataModel"))))
				
			End if 
			
		Else 
			
			  // Keep the current structure
			Form:C1466.$catalog:=$Col_currentCatalog
			
			  // The changes has no influence on the data model -> Update the cache
			$Obj_structure:=Choose:C955($Obj_cache.structure=Null:C1517;New object:C1471;$Obj_cache.structure)
			
			$Obj_structure.definition:=$Col_currentCatalog
			$Obj_structure.digest:=Generate digest:C1147(JSON Stringify:C1217($Col_currentCatalog);SHA1 digest:K66:2)
			
			$Obj_cache.structure:=$Obj_structure
			$file.setText(JSON Stringify:C1217($Obj_cache;*))
			
		End if 
		
		  // Keep state
		$Obj_project.$dialog.unsynchronizedTableFields:=$Col_unsynchronizedTableFields
		
	Else 
		
		  // Reset
		$Obj_project.$dialog.unsynchronizedTableFields:=New collection:C1472
		
	End if 
	
Else 
	
	  // Create the cache
	If ($Col_currentCatalog#Null:C1517)
		
		$Obj_cache:=New object:C1471(\
			"structure";New object:C1471(\
			"definition";$Col_currentCatalog;\
			"digest";Generate digest:C1147(JSON Stringify:C1217($Col_currentCatalog);SHA1 digest:K66:2)\
			))
		
		$file.setText(JSON Stringify:C1217($Obj_cache;*))
		
	End if 
End if 

If (Not:C34($Boo__unsynchronized))\
 | (Form:C1466.$catalog=Null:C1517)
	
	  // Keep the current catalog
	Form:C1466.$catalog:=$Col_currentCatalog
	
End if 

  // Store the status
Form:C1466.structure.unsynchronized:=$Boo__unsynchronized

If (Form:C1466.status=Null:C1517)
	
	Form:C1466.status:=New object:C1471(\
		"dataModel";Not:C34($Boo__unsynchronized))
	
Else 
	
	Form:C1466.status.dataModel:=Not:C34($Boo__unsynchronized)
	
End if 

  //If (False)  // SEMBLE NE PAS ETRE COHERENT
  //  //#106068 - [BUG] Delete table when published
  //Form.$catalog:=$Col_currentCatalog
  //End if 

  // Refresh UI
STRUCTURE_Handler (New object:C1471(\
"action";"update";\
"project";$Obj_project))

  // Save project
CALL FORM:C1391(Current form window:C827;"project_SAVE")

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End