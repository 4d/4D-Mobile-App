

Class constructor($project : Object)
	This:C1470.dataModel:=OB Copy:C1225($project.dataModel)
	This:C1470.actions:=$project.actions
	
Function run($path : Text; $options : Object)->$Obj_out : Object
	$Obj_out:=New object:C1471()
	
	var $Obj_dataModel : Object
	$Obj_dataModel:=This:C1470.dataModel
	
	If ($Obj_dataModel#Null:C1517)
		
		var $Dom_model : Text
		$Dom_model:=DOM Create XML Ref:C861("model")
		
		If (OK=1)
			
			XML SET OPTIONS:C1090($Dom_model; XML indentation:K45:34; XML with indentation:K45:35)
			
			DOM SET XML ATTRIBUTE:C866($Dom_model; \
				"type"; "com.apple.IDECoreDataModeler.DataModel"; \
				"documentVersion"; "1.0"; \
				"lastSavedToolsVersion"; "14903"; \
				"systemVersion"; "18G87"; \
				"minimumToolsVersion"; "Automatic"; \
				"sourceLanguage"; "Swift"; \
				"userDefinedModelVersionIdentifier"; "")
			
			var $Dom_elements : Text
			$Dom_elements:=DOM Create XML element:C865($Dom_model; "elements")
			
			If (OK=1)
				
				ARRAY TEXT:C222($tTxt_entityAttributes; 4)
				$tTxt_entityAttributes{1}:="name"
				$tTxt_entityAttributes{2}:="representedClassName"
				$tTxt_entityAttributes{3}:="syncable"
				$tTxt_entityAttributes{4}:="codeGenerationType"
				
				ARRAY TEXT:C222($tTxt_entityValues; 4)
				$tTxt_entityValues{1}:=""
				$tTxt_entityValues{2}:=""
				$tTxt_entityValues{3}:="YES"
				$tTxt_entityValues{4}:="class"
				
				If (Bool:C1537(FEATURE._234))
					
					// Parent abtract Record entity in model, with common private fields
					var $Txt_tableName : Text
					$Txt_tableName:="Record"
					
					$tTxt_entityValues{1}:=$Txt_tableName
					$tTxt_entityValues{2}:=$Txt_tableName
					
					var $Dom_entity : Text
					$Dom_entity:=DOM Create XML element arrays:C1097($Dom_model; "entity"; $tTxt_entityAttributes; $tTxt_entityValues)
					DOM SET XML ATTRIBUTE:C866($Dom_entity; \
						"isAbstract"; "YES")
					
					var $Dom_attribute : Text
					$Dom_attribute:=DOM Create XML element:C865($Dom_entity; "attribute")
					DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
						"name"; "qmobile__STAMP"; \
						"attributeType"; "Integer 64")
					
					$Dom_attribute:=DOM Create XML element:C865($Dom_entity; "attribute")
					DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
						"name"; "qmobile__TIMESTAMP"; \
						"attributeType"; "Date")
					
					$Dom_attribute:=DOM Create XML element:C865($Dom_entity; "attribute")
					DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
						"name"; "qmobile__KEY"; \
						"attributeType"; "String")
					
					var $Dom_node : Text
					$Dom_node:=DOM Create XML element:C865($Dom_elements; "element"; \
						"name"; $Txt_tableName; \
						"positionX"; 200; \
						"positionY"; 0; \
						"width"; 150; \
						"height"; 45+(15*3))
					
				End if 
				
				If (Bool:C1537($options.relationship))  // core data relation ship table
					
					var $Obj_buffer : Object
					$Obj_buffer:=This:C1470._relation(New object:C1471(\
						"dataModel"; $Obj_dataModel; \
						"definition"; $options.definition))
					
					If ($Obj_buffer.success)
						
						$Obj_dataModel:=$Obj_buffer.dataModel
						$Obj_out.definition:=$Obj_buffer.definition
						
					End if 
				End if   // end pre-parsing for relationship
				
				$Obj_buffer:=This:C1470._primaryKey()
				
				If ($Obj_buffer.success)
					
					$Obj_dataModel:=$Obj_buffer.dataModel
					
				End if 
				
				// For each table
				OB GET PROPERTY NAMES:C1232($Obj_dataModel; $tTxt_tables)  // #CLEAN use for each
				
				var $Lon_table; $Lon_tableID : Integer
				var $Obj_table : Object
				For ($Lon_table; 1; Size of array:C274($tTxt_tables); 1)
					
					$Lon_tableID:=Num:C11($tTxt_tables{$Lon_table})
					$Obj_table:=$Obj_dataModel[$tTxt_tables{$Lon_table}]
					
					var $Txt_buffer : Text
					$Txt_buffer:=$Obj_table[""].name
					$Txt_tableName:=formatString("table-name"; $Txt_buffer)
					
					$tTxt_entityValues{1}:=$Txt_tableName
					$tTxt_entityValues{2}:=$Txt_tableName
					
					$Dom_entity:=DOM Create XML element arrays:C1097($Dom_model; "entity"; $tTxt_entityAttributes; $tTxt_entityValues)
					
					If (Bool:C1537(FEATURE._234))
						
						DOM SET XML ATTRIBUTE:C866($Dom_entity; \
							"parentEntity"; "Record")
						
					End if 
					
					var $Dom_userInfo : Text
					$Dom_userInfo:=DOM Create XML element:C865($Dom_entity; "userInfo")
					
					If (Not:C34(str_equal($Txt_tableName; $Txt_buffer)))
						
						$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
							"key"; "keyMapping"; \
							"value"; $Txt_buffer)
						
					End if 
					
					var $o : Object
					$o:=$Obj_table[""]
					
					If (Length:C16(String:C10($o.slave))>0)
						
						// Only accessible via relations
						$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
							"key"; "slave"; \
							"value"; String:C10($o.slave))
						
					End if 
					//}
					
					// Has or not the global stamp fields
					$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
						"key"; "globalStamp"; \
						"value"; Choose:C955(Bool:C1537(_o_structure(New object:C1471(\
						"action"; "hasField"; \
						"table"; $o.name; \
						"field"; SHARED.stampField.name)).value); "YES"; "NO"))
					
					If (OK=1)
						
						C_TEXT:C284($Dom_fetchIndex; $Dom_fetchIndexElement)
						
						If ($o.primaryKey#Null:C1517)
							
							$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
								"key"; "primaryKey"; \
								"value"; String:C10($o.primaryKey))
							
							If (Length:C16(String:C10($o.primaryKey))>0)
								
								$Dom_fetchIndex:=DOM Create XML element:C865($Dom_entity; "fetchIndex"; "name"; "byPrimaryKey")
								$Dom_fetchIndexElement:=DOM Create XML element:C865($Dom_fetchIndex; "fetchIndexElement"; \
									"property"; formatString("field-name"; String:C10($o.primaryKey)); "type"; "binary"; "order"; "ascending")
								
								C_TEXT:C284($Dom_uniquenessConstraints; $Dom_uniquenessConstraint; $Dom_constraint)
								$Dom_uniquenessConstraints:=DOM Create XML element:C865($Dom_entity; "uniquenessConstraints")
								$Dom_uniquenessConstraint:=DOM Create XML element:C865($Dom_uniquenessConstraints; "uniquenessConstraint")
								$Dom_constraint:=DOM Create XML element:C865($Dom_uniquenessConstraint; "constraint"; "value"; formatString("field-name"; String:C10($o.primaryKey)))
								
							End if 
							
						End if 
						
						// Add fetch index for sort action
						// TODO extract to function
						If (This:C1470.actions#Null:C1517)
							var $action; $parameter : Object
							For each ($action; This:C1470.actions)
								If (String:C10($action.preset)="sort")
									If ($action.parameters#Null:C1517)
										If ($action.parameters.length>0)
											If (Num:C11($action.tableNumber)=$Lon_tableID)
												$Dom_fetchIndex:=DOM Create XML element:C865($Dom_entity; "fetchIndex"; "name"; formatString("field-name"; String:C10($action.name)))
												For each ($parameter; $action.parameters)
													
													$Dom_fetchIndexElement:=DOM Create XML element:C865($Dom_fetchIndex; "fetchIndexElement"; \
														"property"; formatString("field-name"; String:C10($parameter.name)); "type"; "binary"; "order"; Choose:C955(String:C10($parameter.format)="ascending"; "ascending"; "descending"))
													
												End for each 
											End if 
										End if 
									End if 
								End if 
							End for each 
						End if 
						
						// Development #113102
						If ($o.filter#Null:C1517)  // Is filter is available?
							
							If (Bool:C1537($o.filter.validated))  // Is filter is validated?
								
								$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
									"key"; "filter"; \
									"value"; String:C10($o.filter.string))
								
							Else 
								
								ob_warning_add($Obj_out; "Filter '"+String:C10($o.filter.string)+"' of table '"+$Txt_tableName+"' not validated")
								
							End if 
						End if 
						
						OB GET PROPERTY NAMES:C1232($Obj_table; $tTxt_fields)
						
						var $Lon_attributs : Integer
						$Lon_attributs:=Size of array:C274($tTxt_fields)
						
						$Dom_node:=DOM Create XML element:C865($Dom_elements; "element"; \
							"name"; $Txt_tableName; \
							"positionX"; 200*$Lon_table; \
							"positionY"; 100; \
							"width"; 150; \
							"height"; 45+(15*$Lon_attributs))
						
						var $Lon_field : Integer
						For ($Lon_field; 1; $Lon_attributs; 1)
							
							Case of 
									
									//………………………………………………………………………………………………………………………
								: (Length:C16($tTxt_fields{$Lon_field})=0)  // Properties
									
									// <NOTHING MORE TO DO>
									
									//………………………………………………………………………………………………………………………
								: (PROJECT.isField($tTxt_fields{$Lon_field}) | PROJECT.isComputedAttribute($Obj_table[$tTxt_fields{$Lon_field}]))
									
									var $Lon_type : Integer
									var $Lon_fieldID : Integer
									var $Ptr_field : Pointer
									var $Boo_4dType : Boolean
									If (Value type:C1509($Obj_table[$tTxt_fields{$Lon_field}])=Is object:K8:27)
										
										$Txt_buffer:=String:C10($Obj_table[$tTxt_fields{$Lon_field}].name)
										$Lon_type:=$Obj_table[$tTxt_fields{$Lon_field}].fieldType
										
									Else 
										
										$Lon_fieldID:=Num:C11($tTxt_fields{$Lon_field})
										$Ptr_field:=Field:C253($Lon_tableID; $Lon_fieldID)
										$Txt_buffer:=Field name:C257($Ptr_field)
										$Lon_type:=Type:C295($Ptr_field->)
										$Boo_4dType:=True:C214
										
									End if 
									
									If (Length:C16($Txt_buffer)>0)
										
										$Txt_fieldName:=formatString("field-name"; $Txt_buffer)
										
										$Dom_attribute:=DOM Create XML element:C865($Dom_entity; "attribute")  // XXX merge with next instruction
										
										DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
											"name"; $Txt_fieldName; \
											"optional"; "YES"; \
											"indexed"; "NO"; \
											"syncable"; "YES")
										
										$Dom_userInfo:=DOM Create XML element:C865($Dom_attribute; "userInfo")
										
										If (Not:C34(str_equal($Txt_fieldName; $Txt_buffer)))
											
											$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
												"key"; "keyMapping"; \
												"value"; $Txt_buffer)
											
										End if 
										
										// add xml attribut for type
										This:C1470._field($Dom_attribute; $Dom_userInfo; $Lon_type)
										
									End if 
									
									//……………………………………………………………………………………………………………
								: (Value type:C1509($Obj_table[$tTxt_fields{$Lon_field}])#Is object:K8:27)
									
									// <NOTHING MORE TO DO>
									
									//………………………………………………………………………………………………………………………
								: (PROJECT.isRelation($Obj_table[$tTxt_fields{$Lon_field}]))
									
									var $Txt_relationName : Text
									$Txt_relationName:=$tTxt_fields{$Lon_field}
									
									Case of 
											
											//__________________________________
										: (Bool:C1537($options.flat))  // mode flat: one typed core data attribute by related fields
											
											ARRAY TEXT:C222($tTxt_relationFields; 0)
											OB GET PROPERTY NAMES:C1232($Obj_table[$Txt_relationName]; $tTxt_relationFields)
											
											var $Lon_relationField : Integer
											var $relatedField : Object
											For ($Lon_relationField; 1; Size of array:C274($tTxt_relationFields); 1)
												
												$relatedField:=$Obj_table[$Txt_relationName][$tTxt_relationFields{$Lon_relationField}]
												
												Case of 
														
														//……………………………………………………
													: (PROJECT.isField($tTxt_relationFields{$Lon_relationField}) | PROJECT.isComputedAttribute($relatedField))
														
														$Dom_attribute:=DOM Create XML element:C865($Dom_entity; "attribute")
														
														If (OK=1)
															
															$Txt_buffer:=$Obj_table[$Txt_relationName][$tTxt_relationFields{$Lon_relationField}].name
															$Txt_fieldName:=formatString("field-name"; $Txt_relationName+"."+$Txt_buffer)
															
															DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
																"name"; $Txt_fieldName; \
																"optional"; "YES"; \
																"indexed"; "NO"; \
																"syncable"; "YES")
															
															$Dom_userInfo:=DOM Create XML element:C865($Dom_attribute; "userInfo")
															
															If (Not:C34(str_equal($Txt_fieldName; $Txt_relationName+"."+$Txt_buffer)))
																
																$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
																	"key"; "keyMapping"; \
																	"value"; $Txt_relationName+"."+$Txt_buffer)
																
															End if 
															
															$Lon_type:=$Obj_table[$Txt_relationName][$tTxt_relationFields{$Lon_relationField}].fieldType
															
															// CLEAN call this method with $Lon_type not converted, and do a method which support that?
															This:C1470._field($Dom_attribute; $Dom_userInfo; $Lon_type)
															
														End if 
														
														//……………………………………………………
													Else 
														
														// not a field
														
														//……………………………………………………
												End case 
											End for 
											
											//__________________________________
										: (Bool:C1537($options.relationship))  // core data relation ship table
											
											$Txt_buffer:=formatString("field-name"; $Txt_relationName)
											
											var $Txt_inverseName : Text
											$Txt_inverseName:=String:C10($Obj_table[$Txt_relationName].inverseName)
											
											If (Length:C16($Txt_inverseName)=0)
												
												If (dev_Matrix)
													
													ASSERT:C1129(False:C215; "Missing inverseName")
													
												End if 
												
												$Obj_buffer:=_o_structure(New object:C1471(\
													"action"; "inverseRelationName"; \
													"table"; $Obj_table.name; \
													"definition"; $Obj_out.definition; \
													"relation"; $Txt_relationName))
												
												If ($Obj_buffer.success)
													
													$Txt_inverseName:=$Obj_buffer.value
													$options.definition:=$Obj_buffer.definition  // cache purpose
													$Obj_out.definition:=$Obj_buffer.definition
													
												End if 
											End if 
											
											// relation mode
											If (PROJECT.isRelationToMany($Obj_table[$Txt_relationName]))  // to N
												
												// we must have {type:TABLENAMESelection,relatedDataClass:TABLENAME}
												
												$Dom_attribute:=DOM Create XML element:C865($Dom_entity; "relationship"; \
													"name"; $Txt_buffer; \
													"destinationEntity"; formatString("table-name"; $Obj_table[$Txt_relationName].relatedDataClass); \
													"inverseEntity"; formatString("table-name"; $Obj_table[$Txt_relationName].relatedDataClass); \
													"inverseName"; formatString("field-name"; $Txt_inverseName); \
													"toMany"; "YES"; \
													"optional"; "YES"; \
													"syncable"; "YES"; \
													"deletionRule"; "Nullify")
												
											Else   // to 1
												
												$Dom_attribute:=DOM Create XML element:C865($Dom_entity; "relationship"; \
													"name"; $Txt_buffer; \
													"destinationEntity"; formatString("table-name"; $Obj_table[$Txt_relationName].relatedDataClass); \
													"inverseEntity"; formatString("table-name"; $Obj_table[$Txt_relationName].relatedDataClass); \
													"inverseName"; formatString("field-name"; $Txt_inverseName); \
													"maxCount"; "1"; \
													"optional"; "YES"; \
													"syncable"; "YES"; \
													"deletionRule"; "Nullify")
												
												// XXX: inverse name?
												// XXX: if we have a relation, we must ensure that the destination table will be created with all wanted fields
												// or we must add it artificially
												
											End if 
											
											$Dom_userInfo:=DOM Create XML element:C865($Dom_attribute; "userInfo")
											
											If (Not:C34(str_equal($Txt_buffer; $Txt_relationName)))
												
												$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
													"key"; "keyMapping"; \
													"value"; $Txt_relationName)
												
											End if 
											
											If (Length:C16(String:C10($Obj_table[$Txt_relationName].format))>0)
												
												$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
													"key"; "format"; \
													"value"; String:C10($Obj_table[$Txt_relationName].format))
												
											End if 
											
											// Get all fields to put in expand userInfo
											var $Col_fields : Collection
											$Col_fields:=New collection:C1472()
											OB GET PROPERTY NAMES:C1232($Obj_table[$Txt_relationName]; $tTxt_relationFields)
											
											For ($Lon_relationField; 1; Size of array:C274($tTxt_relationFields); 1)
												
												If (Value type:C1509($Obj_table[$Txt_relationName][$tTxt_relationFields{$Lon_relationField}])=Is object:K8:27)  // field if
													
													$Txt_buffer:=$Obj_table[$Txt_relationName][$tTxt_relationFields{$Lon_relationField}].name
													If (Length:C16($Txt_buffer)>0)
														$Col_fields.push($Txt_buffer)
													End if 
													// Else  // not a field
													
												End if 
											End for 
											
											// Without forgot the primaryKey
											$Txt_buffer:=$Obj_dataModel[String:C10($Obj_table[$Txt_relationName].relatedTableNumber)][""].primaryKey
											
											If (Length:C16($Txt_buffer)>0)
												
												If ($Col_fields.indexOf($Txt_buffer)<0)
													
													$Col_fields.push($Txt_buffer)
													
												End if 
											End if 
											
											If ($Col_fields.length>0)
												
												$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
													"key"; "expand"; \
													"value"; $Col_fields.join(","))
												
											End if 
											
											//__________________________________
										Else   // mode with one attribute core data for all related fields
											
											// attribute mode
											$Dom_attribute:=DOM Create XML element:C865($Dom_entity; "attribute")
											
											If (OK=1)
												
												var $Txt_fieldName : Text
												$Txt_fieldName:=formatString("field-name"; $Txt_relationName)
												
												DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
													"name"; $Txt_fieldName; \
													"attributeType"; "Transformable"; \
													"valueTransformerName"; "NSSecureUnarchiveFromData"; \
													"optional"; "YES"; \
													"indexed"; "NO"; \
													"syncable"; "YES")
												
												$Dom_userInfo:=DOM Create XML element:C865($Dom_attribute; "userInfo")
												
												If (Not:C34(str_equal($Txt_fieldName; $Txt_relationName)))
													
													$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
														"key"; "keyMapping"; \
														"value"; $Txt_relationName)
													
												End if 
												
												$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
													"key"; "path"; \
													"value"; $Obj_table[$Txt_relationName].relatedDataClass)
												
											End if 
											
											//__________________________________
									End case 
									
									//……………………………………………………………………………………………………………
								: ($Obj_table[$tTxt_fields{$Lon_field}].relatedEntities#Null:C1517)  // XXX do not edit here without care
									
									ASSERT:C1129(False:C215; "Must not be here if relatedDataClass correctly filled")
									
									//………………………………………………………………………………………………………………………
								Else 
									
									// simple attribute
									
									//………………………………………………………………………………………………………………………
							End case 
							
							If (OK=0)
								
								$Lon_field:=MAXLONG:K35:2-1  // Break
								
							End if 
						End for   // end fields
					End if 
					
					If (OK=0)
						
						$Lon_table:=MAXLONG:K35:2-1  // Break
						
					End if 
				End for   // end tables
			End if 
			
			var $File_ : Text
			$File_:=$path
			
			var $Obj_path : Object
			$Obj_path:=Path to object:C1547($File_)
			
			Case of 
					
					//………………………………………………………………………………………………
				: ($Obj_path.extension=".xcdatamodeld")
					
					$File_:=$File_+Folder separator:K24:12+$Obj_path.name+".xcdatamodel"+Folder separator:K24:12+"contents"
					
					//………………………………………………………………………………………………
				: ($Obj_path.extension=".xcdatamodel")
					
					$File_:=$File_+Folder separator:K24:12+"contents"
					
					//………………………………………………………………………………………………
			End case 
			
			CREATE FOLDER:C475($File_; *)
			
			DOM EXPORT TO FILE:C862($Dom_model; $File_)
			
			$Obj_out.success:=Bool:C1537(OK)
			$Obj_out.path:=$File_
			
			DOM CLOSE XML:C722($Dom_model)  // Modify the system variable OK!
			
		End if 
		
	Else 
		
		RECORD.warning("$Obj_in.project.dataModel is null")
		
	End if 
	
Function _relation($Obj_in : Object)->$Obj_out : Object
	var $Obj_dataModel : Object
	$Obj_dataModel:=$Obj_in.dataModel
	
	$Obj_out:=New object:C1471()
	
	var $Txt_table : Text
	var $Obj_table : Object
	
	For each ($Obj_table; $Obj_dataModel)
		$Obj_table:=$Obj_dataModel[$Txt_table]
		
		var $Txt_field : Text
		var $Obj_field : Object
		For each ($Txt_field; $Obj_table)
			
			Case of 
					
					//………………………………………………………………………………………………………………………
				: (Match regex:C1019("(?m-si)^\\d+$"; $Txt_field; 1; *))
					
					// ignore field
					
					//………………………………………………………………………………………………………………………
				: ((Value type:C1509($Obj_table[$Txt_field])=Is object:K8:27))
					$Obj_field:=$Obj_table[$Txt_field]
					
					var $Boo_found : Boolean
					var $Txt_relationName : Text
					$Txt_relationName:=$Txt_field  // link name (or primaryKey, etc...)
					
					If ($Obj_table[$Txt_relationName].relatedEntities#Null:C1517)  // To remove if relatedEntities deleted and relatedDataClass already filled #109019
						
						$Obj_table[$Txt_relationName].relatedDataClass:=$Obj_table[$Txt_relationName].relatedEntities
						
					End if 
					
					If ($Obj_table[$Txt_relationName].relatedDataClass#Null:C1517)  // Is is a link?
						
						// if this relatedDataClass in model?
						$Boo_found:=False:C215
						
						For each ($Txt_table; $Obj_dataModel) Until ($Boo_found)
							// ASK : why not just check  $Obj_dataModel[$Obj_table[$Txt_relationName].relatedDataClass] ?
							var $Obj_relationTable : Object
							$Obj_relationTable:=$Obj_dataModel[$Txt_table]
							
							var $Obj_relationTableInfo : Object
							If ($Obj_relationTable[""]#Null:C1517)
								$Obj_relationTableInfo:=$Obj_relationTable[""]
							Else 
								$Obj_relationTableInfo:=$Obj_relationTable  // DEAD CODE?
							End if 
							
							If ($Obj_relationTableInfo.name=$Obj_table[$Txt_relationName].relatedDataClass)
								$Boo_found:=True:C214
							End if 
						End for each 
						
						OB GET PROPERTY NAMES:C1232($Obj_table[$Txt_relationName]; $tTxt_relationFields)
						
						If (Not:C34($Boo_found))  // not found we must add a new table in model
							
							$Obj_relationTable:=New object:C1471(\
								""; New object:C1471(\
								"name"; $Obj_table[$Txt_relationName].relatedDataClass))
							
							$Obj_relationTableInfo:=$Obj_relationTable[""]
							
							var $Obj_buffer : Object
							$Obj_buffer:=_o_structure(New object:C1471(\
								"action"; "tableInfo"; \
								"name"; $Obj_relationTableInfo.name))
							
							If ($Obj_buffer.success)
								
								$Obj_relationTableInfo.primaryKey:=$Obj_buffer.tableInfo.primaryKey
								$Obj_relationTableInfo.slave:=$Obj_table[""].name
								
								var $Lon_relatedTableID : Integer
								$Lon_relatedTableID:=$Obj_buffer.tableInfo.tableNumber
								// TODO ? APPEND TO ARRAY($tTxt_tables; String($Lon_relatedTableID))
								
								$Obj_dataModel[String:C10($Lon_relatedTableID)]:=$Obj_relationTable
								$Obj_out.hasBeenEdited:=True:C214
								
							Else 
								
								ob_error_add($Obj_out; "Unknown related table "+String:C10($Obj_relationTableInfo.name))
								
							End if 
						End if 
						
						// just check if we must add new fields
						var $Lon_field2 : Integer
						For ($Lon_field2; 1; Size of array:C274($tTxt_relationFields); 1)
							
							If (Value type:C1509($Obj_table[$Txt_relationName][$tTxt_relationFields{$Lon_field2}])=Is object:K8:27)
								
								If (($Obj_relationTable[$tTxt_relationFields{$Lon_field2}])=Null:C1517)
									
									$Obj_relationTable[$tTxt_relationFields{$Lon_field2}]:=$Obj_table[$Txt_relationName][$tTxt_relationFields{$Lon_field2}]  // name & type
									$Obj_out.hasBeenEdited:=True:C214
									
								End if 
							End if 
						End for 
						
						// Get inverse field
						$Obj_buffer:=_o_structure(New object:C1471(\
							"action"; "inverseRelatedFields"; \
							"table"; $Obj_table[""].name; \
							"relation"; $Txt_relationName; \
							"definition"; $Obj_in.definition))
						
						If ($Obj_buffer.success)
							
							$Obj_in.definition:=$Obj_buffer.definition  // cache purpose
							
							var $Obj_field : Object
							For each ($Obj_field; $Obj_buffer.fields)  // CLEAN must only have one
								
								// Create the inverse field
								If ($Obj_relationTable[$Obj_field.name]=Null:C1517)
									
									$Obj_relationTable[$Obj_field.name]:=New object:C1471(\
										"kind"; $Obj_field.kind; \
										"type"; $Obj_field.fieldType; \
										"inverseName"; $Txt_relationName; \
										"relatedTableNumber"; $Obj_field.relatedTableNumber; \
										"relatedDataClass"; $Obj_field.relatedDataClass)
									
								End if 
								
								$Obj_relationTable[$Obj_field.name].inverseName:=$Txt_relationName
								
								$Obj_out.hasBeenEdited:=True:C214
								
							End for each 
						End if 
					End if 
					
					//………………………………………………………………………………………………………………………
			End case 
		End for each 
	End for each 
	
	$Obj_out.dataModel:=$Obj_dataModel
	$Obj_out.success:=Bool:C1537($Obj_out.hasBeenEdited)
	
	// -
	
	// Add missing primary keys
Function _primaryKey()->$Obj_out : Object
	$Obj_out:=New object:C1471
	var $Obj_dataModel : Object
	var $Boo_found : Boolean
	
	$Obj_dataModel:=This:C1470.dataModel
	
	var $Txt_table : Text
	var $Obj_table : Object
	For each ($Obj_table; $Obj_dataModel)
		$Obj_table:=$Obj_dataModel[$Txt_table]
		
		var $tableInfo : Object
		$tableInfo:=$Obj_table[""]
		
		If ($tableInfo.primaryKey#Null:C1517)
			
			// Find if primary key is in model
			CLEAR VARIABLE:C89($Boo_found)
			
			var $Txt_fieldName : Text
			Case of 
					
					//………………………………………………………………………………………………………………………
				: (Value type:C1509($tableInfo.primaryKey)=Is object:K8:27)
					
					// Pass as object
					$Txt_fieldName:=JSON Stringify:C1217($tableInfo.primaryKey)
					
					//………………………………………………………………………………………………………………………
				: (Value type:C1509($tableInfo.primaryKey)=Is text:K8:3)
					
					$Txt_fieldName:=String:C10($tableInfo.primaryKey)
					
					//………………………………………………………………………………………………………………………
				Else 
					// SAFETY CODE if not passed...
					ASSERT:C1129(dev_Matrix; "primary key seems to not be passed with dataModel")
					
					var $Obj_buffer : Object
					$Obj_buffer:=_o_structure(New object:C1471(\
						"action"; "tableInfo"; \
						"name"; $tableInfo.name))
					
					$Txt_fieldName:=Choose:C955($Obj_buffer.success; $Obj_buffer.tableInfo.primaryKey; "")
					
					//………………………………………………………………………………………………………………………
			End case 
			
			$Boo_found:=False:C215
			
			var $Txt_field : Text
			var $Obj_field : Object
			For each ($Txt_field; $Obj_table) Until ($Boo_found)
				$Obj_field:=$Obj_table[$Txt_field]
				If ($Obj_field.name=$Txt_fieldName)
					$Boo_found:=True:C214
				End if 
			End for each 
			
			If (Not:C34($Boo_found))  // if not add missing primary key field
				
				$Obj_buffer:=_o_structure(New object:C1471(\
					"action"; "createField"; \
					"table"; $tableInfo.name; \
					"field"; $Txt_fieldName))
				
				If ($Obj_buffer.success)
					
					$Obj_field:=$Obj_buffer.value
					$Obj_table[String:C10($Obj_field.id)]:=$Obj_field
					$Obj_out.hasBeenEdited:=True:C214
					
				Else 
					
					ob_error_combine($Obj_out; $Obj_buffer)
					
				End if 
			End if 
		End if 
	End for each 
	
	$Obj_out.dataModel:=$Obj_dataModel
	$Obj_out.success:=Bool:C1537($Obj_out.hasBeenEdited)
	
	// -
	
	// Create node for core data attribute ie. scalar field
Function _field($Dom_attribute : Text; $Dom_userInfo : Text; $Lon_type : Integer)
	var $Dom_node : Text
	Case of 
			
			//________________________________________
		: ($Lon_type=Is boolean:K8:9)
			
			DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
				"attributeType"; "Boolean"; \
				"usesScalarValueType"; "YES")
			
			//________________________________________
		: ($Lon_type=Is alpha field:K8:1)\
			 | ($Lon_type=Is text:K8:3)
			
			DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
				"attributeType"; "String")
			
			//________________________________________
		: ($Lon_type=Is date:K8:7)
			
			DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
				"attributeType"; "Date")
			
			//________________________________________
		: ($Lon_type=Is picture:K8:10)
			
			DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
				"attributeType"; "Transformable")
			
			DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
				"valueTransformerName"; "NSSecureUnarchiveFromData")
			
			$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
				"key"; "image"; \
				"value"; "YES")
			
			//________________________________________
		: ($Lon_type=Is longint:K8:6)
			
			DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
				"attributeType"; "Integer 32"; \
				"usesScalarValueType"; "YES")
			
			//________________________________________
		: ($Lon_type=Is integer:K8:5)
			
			DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
				"attributeType"; "Integer 32"; \
				"usesScalarValueType"; "YES")
			
			$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
				"key"; "integer"; \
				"value"; "YES")
			
			//________________________________________
		: ($Lon_type=Is integer 64 bits:K8:25)
			
			DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
				"attributeType"; "Integer 64")
			
			//________________________________________
		: ($Lon_type=Is real:K8:4)
			
			DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
				"attributeType"; "Double"; \
				"usesScalarValueType"; "YES")
			
			//________________________________________
		: ($Lon_type=Is time:K8:8)
			
			DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
				"attributeType"; "Integer 64"; \
				"usesScalarValueType"; "YES")
			
			$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
				"key"; "duration"; \
				"value"; "YES")
			
			//________________________________________
		: ($Lon_type=Is object:K8:27)
			
			DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
				"attributeType"; "Transformable")
			
			DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
				"valueTransformerName"; "NSSecureUnarchiveFromData")
			
			//________________________________________
		: ($Lon_type=Is BLOB:K8:12)
			
			DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
				"attributeType"; "Binary")
			
			//________________________________________
		: ($Lon_type=_o_Is float:K8:26)
			
			DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
				"attributeType"; "Float"; \
				"usesScalarValueType"; "YES")
			
			//________________________________________
		Else 
			
			DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
				"attributeType"; "String")
			
	End case 