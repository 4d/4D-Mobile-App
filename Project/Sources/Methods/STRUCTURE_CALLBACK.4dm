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

C_BOOLEAN:C305($Boo__unsynchronized;$Boo_unsynchronizedTable)
C_TEXT:C284($t;$tt;$Txt_table)
C_OBJECT:C1216($catalog;$file;$ƒ;$o;$Obj_cache;$Obj_dataModel)
C_OBJECT:C1216($Obj_project;$Obj_structure;$Obj_tableCurrent;$Obj_tableModel;$oo;$str)
C_COLLECTION:C1488($cc;$Col_cachedCatalog;$Col_currentCatalog;$Col_unsynchronizedFields;$Col_unsynchronizedTableFields)

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
		If ($Obj_project.dataModel#Null:C1517)
			
			$Obj_dataModel:=OB Copy:C1225($Obj_project.dataModel)
			
		End if 
		
		If ($Obj_dataModel#Null:C1517)
			
			  // For each TABLE published
			For each ($Txt_table;$Obj_dataModel)
				
				$Obj_tableModel:=$Obj_dataModel[$Txt_table]
				
				  // Reset unsynchronized table flag
				CLEAR VARIABLE:C89($Boo_unsynchronizedTable)
				
				  // Create unsynchronized fields collection
				$Col_unsynchronizedFields:=New collection:C1472
				
				$Obj_tableCurrent:=$Col_currentCatalog.query("tableNumber = :1";Num:C11($Txt_table)).pop()
				
				If ($Obj_tableCurrent=Null:C1517)
					
					  // THE TABLE IS NO LONGER AVAILABLE
					$Boo_unsynchronizedTable:=True:C214
					
				Else 
					
					  // Check TABLE NAME & PRIMARY KEY
					If (featuresFlags.with("newDataModel"))
						
						$Boo_unsynchronizedTable:=($Obj_tableCurrent.name#$Obj_tableModel[""].name)\
							 | (String:C10($Obj_tableCurrent.primaryKey)#$Obj_tableModel[""].primaryKey)
						
					Else 
						
						$Boo_unsynchronizedTable:=($Obj_tableCurrent.name#$Obj_tableModel.name)\
							 | (String:C10($Obj_tableCurrent.primaryKey)#$Obj_tableModel.primaryKey)
						
					End if 
					
					If (Not:C34($Boo_unsynchronizedTable))
						
						For each ($t;$Obj_tableModel)
							
							If ($ƒ.isField($t))
								
								$o:=$Obj_tableModel[$t]
								$o.current:=$Obj_tableCurrent.field.query("fieldNumber = :1";Num:C11($t)).pop()
								$o.missing:=$o.current=Null:C1517
								$o.nameMismatch:=$o.name#String:C10($o.current.name)
								
								If (Value type:C1509($o.type)=Is text:K8:3)
									
									  // Compare to value Type
									$o.typeMismatch:=$o.type#$o.current.valueType
									
								Else 
									
									$o.typeMismatch:=$o.fieldType#$o.current.fieldType
									
								End if 
								
								If ($o.missing | $o.nameMismatch | $o.typeMismatch)
									
									  // THE FIELD IS NO LONGER AVAILABLE
									  // OR THE NAME/TYPE HAS BEEN CHANGED
									
									$Boo_unsynchronizedTable:=True:C214
									
									  // Append faulty field
									$Col_unsynchronizedFields.push($o)
									
								End if 
								
							Else 
								
								If (Value type:C1509($Obj_tableModel[$t])=Is object:K8:27)
									
									  // RELATION
									
									$o:=$Obj_tableModel[$t]
									$o.current:=$Obj_tableCurrent.field.query("name = :1";$t).pop()
									
									Case of 
											
											  //________________________________________
										: ($ƒ.isRelationToOne($o))  // N -> 1 relation
											
											$o.missing:=$o.current=Null:C1517
											
											If ($o.missing)
												
												  // Check the related dataclass availability
												$o.missingRelatedDataclass:=$Col_currentCatalog.query("tableNumber = :1";Num:C11($o.relatedTableNumber)).pop()=Null:C1517
												
											Else 
												
												  // Diacritical equality of the name
												$o.nameMismatch:=Not:C34($str.setText($t).equal($o.current.name))
												
											End if 
											
											If ($o.missing | Bool:C1537($o.nameMismatch))
												
												  // THE RELATION IS NO LONGER AVAILABLE
												  // OR THE NAME HAS BEEN CHANGED
												
												$Boo_unsynchronizedTable:=True:C214
												
												  // Append faulty relation
												If ($Col_unsynchronizedFields.query("name= :1";$t).length=0)
													
													$o.name:=$t
													
													$Col_unsynchronizedFields.push($o)
													
												End if 
												
											Else 
												
												  // Check related table catalog
												$cc:=$Col_currentCatalog.query("tableNumber = :1";$o.relatedTableNumber).pop().field
												
												  // Check related data class catalog
												For each ($tt;$o)
													
													If ($ƒ.isField($tt))
														
														$oo:=$o[$tt]
														$oo.current:=$cc.query("fieldNumber = :1";Num:C11($tt)).pop()
														$oo.missing:=$oo.current=Null:C1517
														$oo.nameMismatch:=$oo.name#String:C10($oo.current.name)
														$oo.typeMismatch:=$oo.type#Num:C11($oo.current.type)
														
														If ($oo.missing | $oo.nameMismatch | $oo.typeMismatch)
															
															  // TRUE IF THE RELATED FIELD IS NO LONGER AVAILABLE
															  // OR IF THE NAME (non diacritical) OR TYPE HAS BEEN CHANGED
															
															$Boo_unsynchronizedTable:=True:C214
															
															If ($o.unsynchronizedFields=Null:C1517)
																
																$o.unsynchronizedFields:=New collection:C1472($oo)
																
															Else 
																
																$o.unsynchronizedFields.push($oo)
																
															End if 
															
															If ($Col_unsynchronizedFields.query("name= :1";$t).length=0)
																
																$o.name:=$t
																
																$Col_unsynchronizedFields.push($o)
																
															End if 
														End if 
														
													Else 
														
														  // NOT YET MANAGED
														
													End if 
												End for each 
											End if 
											
											  //________________________________________
										: ($ƒ.isRelationToMany($o))  // 1 -> N relation
											
											$o.current:=$Obj_tableCurrent.field.query("name = :1";$t).pop()
											
											$o.missing:=$o.current=Null:C1517
											
											If ($o.missing)
												
												  // Check the related dataclass availability
												$o.missingRelatedDataclass:=$Col_currentCatalog.query("tableNumber = :1";Num:C11($o.relatedTableNumber)).pop()=Null:C1517
												
											Else 
												
												  // Diacritical equality of the name
												$o.nameMismatch:=Not:C34($str.setText($t).equal($o.current.name))
												
											End if 
											
											If ($o.missing | Bool:C1537($o.nameMismatch))
												
												  // THE RELATION IS NO LONGER AVAILABLE
												  // OR IF THE NAME HAS BEEN CHANGED
												
												$Boo_unsynchronizedTable:=True:C214
												
												  // Append faulty relation
												If ($Col_unsynchronizedFields.query("name= :1";$t).length=0)
													
													$o.name:=$t
													
													$Col_unsynchronizedFields.push($o)
													
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
			
			  // Keep the current catalog
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
  // End if

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