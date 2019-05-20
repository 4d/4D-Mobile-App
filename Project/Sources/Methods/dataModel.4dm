//%attributes = {"invisible":true,"preemptive":"capable"}
/*
out := ***dataModel*** ( in )
 -> in (Object)
 <- out (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : dataModel
  // Database: 4D Mobile Express
  // ID[66DCDF904F5B4EBAB7B0CD7FE481ED86]
  // Created #17-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_4dType;$Boo_found)
C_LONGINT:C283($Lon_attributs;$Lon_field;$Lon_field2;$Lon_fieldID;$Lon_parameters;$Lon_relatedTableID)
C_LONGINT:C283($Lon_relationField;$Lon_table;$Lon_table2;$Lon_tableID;$Lon_type)
C_POINTER:C301($Ptr_field)
C_TEXT:C284($Dom_attribute;$Dom_elements;$Dom_entity;$Dom_model;$Dom_node;$Dom_userInfo)
C_TEXT:C284($File_;$t;$tt;$Txt_buffer;$Txt_field;$Txt_fieldName)
C_TEXT:C284($Txt_fieldNumber;$Txt_inverseName;$Txt_relationName;$Txt_tableName;$Txt_tableNumber;$Txt_value)
C_OBJECT:C1216($ƒ;$Obj_buffer;$Obj_dataModel;$Obj_field;$Obj_in;$Obj_out)
C_OBJECT:C1216($Obj_path;$Obj_relationTable;$Obj_table)
C_COLLECTION:C1488($Col_fields;$Col_tables)

ARRAY TEXT:C222($tTxt_fields;0)
ARRAY TEXT:C222($tTxt_relationFields;0)
ARRAY TEXT:C222($tTxt_tables;0)

If (False:C215)
	C_OBJECT:C1216(dataModel ;$0)
	C_OBJECT:C1216(dataModel ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
	End if 
	
	$ƒ:=Storage:C1525.ƒ
	
	$Obj_out:=New object:C1471(\
		"success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Obj_in.action=Null:C1517)  // Missing parameter
		
		ASSERT:C1129(False:C215;"Missing parameter \"action\"")
		
		  //______________________________________________________
	: ($Obj_in.action="xcdatamodel")  // Dump the data mode as xcdatamodel - CALLERS: editor_MENU_ACTIONS, mobile_Project
		
		If (Asserted:C1132($Obj_in.path#Null:C1517;"Missing the tag \"path\""))
			
			$Obj_dataModel:=OB Copy:C1225($Obj_in.dataModel)
			
			$Dom_model:=DOM Create XML Ref:C861("model")
			
			If (OK=1)
				
				XML SET OPTIONS:C1090($Dom_model;XML indentation:K45:34;XML with indentation:K45:35)
				
				DOM SET XML ATTRIBUTE:C866($Dom_model;\
					"type";"com.apple.IDECoreDataModeler.DataModel";\
					"documentVersion";"1.0";\
					"lastSavedToolsVersion";"14460.32";\
					"systemVersion";"18C54";\
					"minimumToolsVersion";"Automatic";\
					"sourceLanguage";"Swift";\
					"userDefinedModelVersionIdentifier";"")
				
				$Dom_elements:=DOM Create XML element:C865($Dom_model;"elements")
				
				If (OK=1)
					
					ARRAY TEXT:C222($tTxt_entityAttributes;4)
					$tTxt_entityAttributes{1}:="name"
					$tTxt_entityAttributes{2}:="representedClassName"
					$tTxt_entityAttributes{3}:="syncable"
					$tTxt_entityAttributes{4}:="codeGenerationType"
					
					ARRAY TEXT:C222($tTxt_entityValues;4)
					$tTxt_entityValues{1}:=""
					$tTxt_entityValues{2}:=""
					$tTxt_entityValues{3}:="YES"
					$tTxt_entityValues{4}:="class"
					
					If (Bool:C1537(featuresFlags._234))
						
						  // Parent abtract Record entity in model, with common private fields
						$Txt_tableName:="Record"
						
						$tTxt_entityValues{1}:=$Txt_tableName
						$tTxt_entityValues{2}:=$Txt_tableName
						
						$Dom_entity:=DOM Create XML element arrays:C1097($Dom_model;"entity";$tTxt_entityAttributes;$tTxt_entityValues)
						DOM SET XML ATTRIBUTE:C866($Dom_entity;\
							"isAbstract";"YES")
						
						$Dom_attribute:=DOM Create XML element:C865($Dom_entity;"attribute")
						DOM SET XML ATTRIBUTE:C866($Dom_attribute;\
							"name";"qmobile__STAMP";\
							"attributeType";"Integer 64")
						
						$Dom_attribute:=DOM Create XML element:C865($Dom_entity;"attribute")
						DOM SET XML ATTRIBUTE:C866($Dom_attribute;\
							"name";"qmobile__TIMESTAMP";\
							"attributeType";"Date")
						
						$Dom_attribute:=DOM Create XML element:C865($Dom_entity;"attribute")
						DOM SET XML ATTRIBUTE:C866($Dom_attribute;\
							"name";"qmobile__KEY";\
							"attributeType";"String")
						
						$Dom_node:=DOM Create XML element:C865($Dom_elements;"element";\
							"name";$Txt_tableName;\
							"positionX";200;\
							"positionY";0;\
							"width";150;\
							"height";45+(15*3))
						
					End if 
					
					If (Bool:C1537($Obj_in.relationship))  // core data relation ship table
						
						$Obj_buffer:=dataModel (New object:C1471(\
							"action";"xcdatamodel_relation";\
							"dataModel";$Obj_dataModel;\
							"definition";$Obj_in.definition))
						
						If ($Obj_buffer.success)
							
							$Obj_dataModel:=$Obj_buffer.dataModel
							$Obj_out.definition:=$Obj_buffer.definition
							
						End if 
					End if   // end pre-parsing for relationship
					
					$Obj_buffer:=dataModel (New object:C1471(\
						"action";"xcdatamodel_primaryKey";\
						"dataModel";$Obj_dataModel))
					
					If ($Obj_buffer.success)
						
						$Obj_dataModel:=$Obj_buffer.dataModel
						
					End if 
					
					  // For each table
					OB GET PROPERTY NAMES:C1232($Obj_dataModel;$tTxt_tables)  // #CLEAN use for each
					
					For ($Lon_table;1;Size of array:C274($tTxt_tables);1)
						
						$Lon_tableID:=Num:C11($tTxt_tables{$Lon_table})
						$Obj_table:=$Obj_dataModel[$tTxt_tables{$Lon_table}]
						
						$Txt_buffer:=$Obj_table.name  // Table name($Lon_tableID)
						$Txt_tableName:=formatString ("table-name";$Txt_buffer)
						
						$tTxt_entityValues{1}:=$Txt_tableName
						$tTxt_entityValues{2}:=$Txt_tableName
						
						$Dom_entity:=DOM Create XML element arrays:C1097($Dom_model;"entity";$tTxt_entityAttributes;$tTxt_entityValues)
						
						If (Bool:C1537(featuresFlags._234))
							
							DOM SET XML ATTRIBUTE:C866($Dom_entity;\
								"parentEntity";"Record")
							
						End if 
						
						$Dom_userInfo:=DOM Create XML element:C865($Dom_entity;"userInfo")
						
						If (Not:C34(str_equal ($Txt_tableName;$Txt_buffer)))
							
							$Dom_node:=DOM Create XML element:C865($Dom_userInfo;"entry";\
								"key";"keyMapping";\
								"value";$Txt_buffer)
							
						End if 
						
						If (Bool:C1537(featuresFlags._103411))
							
							If (Length:C16(String:C10($Obj_table.slave))>0)
								
								  // Only accessible via relations
								$Dom_node:=DOM Create XML element:C865($Dom_userInfo;"entry";\
									"key";"slave";\
									"value";String:C10($Obj_table.slave))
								
							End if 
							
							  // Has or not the global stamp fields
							$Dom_node:=DOM Create XML element:C865($Dom_userInfo;"entry";\
								"key";"globalStamp";\
								"value";Choose:C955(Bool:C1537(structure (New object:C1471("action";"hasField";\
								"table";$Obj_table.name;"field";commonValues.stampField.name)).value);"YES";"NO"))
							
						End if 
						
						If (OK=1)
							
							If ($Obj_table.primaryKey#Null:C1517)
								
								$Dom_node:=DOM Create XML element:C865($Dom_userInfo;"entry";\
									"key";"primaryKey";\
									"value";String:C10($Obj_table.primaryKey))
								
							End if 
							
							  //If (Bool(featuresFlags._100174))
							
							If ($Obj_table.filter#Null:C1517)  // Is filter is available?
								
								If (Bool:C1537($Obj_table.filter.validated))  // Is filter is validated?
									
									$Dom_node:=DOM Create XML element:C865($Dom_userInfo;"entry";\
										"key";"filter";\
										"value";String:C10($Obj_table.filter.string))
									
								Else 
									
									ob_warning_add ($Obj_out;"Filter '"+String:C10($Obj_table.filter.string)+"' of table '"+$Txt_tableName+"' not validated")
									
								End if 
							End if 
							  //End if 
							
							OB GET PROPERTY NAMES:C1232($Obj_table;$tTxt_fields)
							
							$Lon_attributs:=Size of array:C274($tTxt_fields)
							
							$Dom_node:=DOM Create XML element:C865($Dom_elements;"element";\
								"name";$Txt_tableName;\
								"positionX";200*$Lon_table;\
								"positionY";100;\
								"width";150;\
								"height";45+(15*$Lon_attributs))
							
							For ($Lon_field;1;$Lon_attributs;1)
								
								Case of 
										
										  //………………………………………………………………………………………………………………………
									: ($ƒ.isField($tTxt_fields{$Lon_field}))  // field if
										
										If (Value type:C1509($Obj_table[$tTxt_fields{$Lon_field}])=Is object:K8:27)
											
											$Txt_buffer:=String:C10($Obj_table[$tTxt_fields{$Lon_field}].name)
											
											If (Bool:C1537(featuresFlags.withNewFieldProperties))
												
												$Lon_type:=$Obj_table[$tTxt_fields{$Lon_field}].fieldType
												
											Else 
												
												$Lon_type:=$Obj_table[$tTxt_fields{$Lon_field}].type
												$Boo_4dType:=False:C215
												
											End if 
											
										Else 
											
											$Lon_fieldID:=Num:C11($tTxt_fields{$Lon_field})
											$Ptr_field:=Field:C253($Lon_tableID;$Lon_fieldID)
											$Txt_buffer:=Field name:C257($Ptr_field)
											$Lon_type:=Type:C295($Ptr_field->)
											$Boo_4dType:=True:C214
											
										End if 
										
										If (Length:C16($Txt_buffer)>0)
											
											$Txt_fieldName:=formatString ("field-name";$Txt_buffer)
											
											$Dom_attribute:=DOM Create XML element:C865($Dom_entity;"attribute")  // XXX merge with next instruction
											
											DOM SET XML ATTRIBUTE:C866($Dom_attribute;\
												"name";$Txt_fieldName;\
												"optional";"YES";\
												"indexed";"NO";\
												"syncable";"YES")
											
											$Dom_userInfo:=DOM Create XML element:C865($Dom_attribute;"userInfo")
											
											If (Not:C34(str_equal ($Txt_fieldName;$Txt_buffer)))
												
												$Dom_node:=DOM Create XML element:C865($Dom_userInfo;"entry";\
													"key";"keyMapping";\
													"value";$Txt_buffer)
												
											End if 
											
											  // add xml attribut for type
											dataModel (New object:C1471(\
												"action";"xcdatamodel_field";\
												"type";$Lon_type;\
												"fieldType";$Lon_type;\
												"4d";$Ptr_field#Null:C1517;\
												"dom";$Dom_attribute;\
												"domUserInfo";$Dom_userInfo))
											
										End if 
										  //……………………………………………………………………………………………………………
									: (Value type:C1509($Obj_table[$tTxt_fields{$Lon_field}])#Is object:K8:27)
										
										  // <NOTHING MORE TO DO>
										
										  //………………………………………………………………………………………………………………………
									: ($ƒ.isRelatedDataClass($Obj_table[$tTxt_fields{$Lon_field}]))
										
										$Txt_relationName:=$tTxt_fields{$Lon_field}
										
										Case of 
												
												  //__________________________________
											: (Bool:C1537($Obj_in.flat))  // mode flat: one typed core data attribute by related fields
												
												OB GET PROPERTY NAMES:C1232($Obj_table[$Txt_relationName];$tTxt_relationFields)
												
												For ($Lon_relationField;1;Size of array:C274($tTxt_relationFields);1)
													
													Case of 
															
															  //……………………………………………………
														: ($ƒ.isField($tTxt_relationFields{$Lon_relationField}))
															
															$Dom_attribute:=DOM Create XML element:C865($Dom_entity;"attribute")
															
															If (OK=1)
																
																$Txt_buffer:=$Obj_table[$Txt_relationName][$tTxt_relationFields{$Lon_relationField}].name
																$Txt_fieldName:=formatString ("field-name";$Txt_relationName+"."+$Txt_buffer)
																
																DOM SET XML ATTRIBUTE:C866($Dom_attribute;\
																	"name";$Txt_fieldName;\
																	"optional";"YES";\
																	"indexed";"NO";\
																	"syncable";"YES")
																
																$Dom_userInfo:=DOM Create XML element:C865($Dom_attribute;"userInfo")
																
																If (Not:C34(str_equal ($Txt_fieldName;$Txt_relationName+"."+$Txt_buffer)))
																	
																	$Dom_node:=DOM Create XML element:C865($Dom_userInfo;"entry";\
																		"key";"keyMapping";\
																		"value";$Txt_relationName+"."+$Txt_buffer)
																	
																End if 
																
																If (Bool:C1537(featuresFlags.withNewFieldProperties))
																	
																	$Lon_type:=$Obj_table[$Txt_relationName][$tTxt_relationFields{$Lon_relationField}].fieldType
																	
																Else 
																	
																	$Lon_type:=$Obj_table[$Txt_relationName][$tTxt_relationFields{$Lon_relationField}].type
																	
																End if 
																
																  // CLEAN call this method with $Lon_type not converted, and do a method which support that?
																dataModel (New object:C1471(\
																	"action";"xcdatamodel_field";\
																	"type";$Lon_type;\
																	"4d";$Boo_4dType;\
																	"dom";$Dom_attribute;\
																	"domUserInfo";$Dom_userInfo))
																
															End if 
															
															  //……………………………………………………
														Else 
															
															  // not a field
															
															  //……………………………………………………
													End case 
												End for 
												
												  //__________________________________
											: (Bool:C1537($Obj_in.relationship))  // core data relation ship table
												
												$Txt_buffer:=formatString ("field-name";$Txt_relationName)
												
												$Txt_inverseName:=String:C10($Obj_table[$Txt_relationName].inverseName)
												
												If (Length:C16($Txt_inverseName)=0)
													
													If (featuresFlags.withNewFieldProperties) & dev_Matrix 
														
														ASSERT:C1129(False:C215;"Missing inverseName")
														
													End if 
													
													$Obj_buffer:=structure (New object:C1471(\
														"action";"inverseRelationName";\
														"table";$Obj_table.name;\
														"definition";$Obj_out.definition;\
														"relation";$Txt_relationName))
													
													If ($Obj_buffer.success)
														
														$Txt_inverseName:=$Obj_buffer.value
														$Obj_in.definition:=$Obj_buffer.definition  // cache purpose
														$Obj_out.definition:=$Obj_buffer.definition
														
													End if 
												End if 
												
												  // relation mode
												If (String:C10($Obj_table[$Txt_relationName].kind)="relatedEntities")  // to N
													
													  // we must have {type:TABLENAMESelection,relatedDataClass:TABLENAME}
													
													$Dom_attribute:=DOM Create XML element:C865($Dom_entity;"relationship";\
														"name";$Txt_buffer;\
														"destinationEntity";formatString ("table-name";$Obj_table[$Txt_relationName].relatedDataClass);\
														"inverseEntity";formatString ("table-name";$Obj_table[$Txt_relationName].relatedDataClass);\
														"inverseName";formatString ("field-name";$Txt_inverseName);\
														"toMany";"YES";\
														"optional";"YES";\
														"syncable";"YES";\
														"deletionRule";"Nullify")
													
												Else   // to 1
													
													$Dom_attribute:=DOM Create XML element:C865($Dom_entity;"relationship";\
														"name";$Txt_buffer;\
														"destinationEntity";formatString ("table-name";$Obj_table[$Txt_relationName].relatedDataClass);\
														"inverseEntity";formatString ("table-name";$Obj_table[$Txt_relationName].relatedDataClass);\
														"inverseName";formatString ("field-name";$Txt_inverseName);\
														"maxCount";"1";\
														"optional";"YES";\
														"syncable";"YES";\
														"deletionRule";"Nullify")
													
													  // XXX: inverse name?
													  // XXX: if we have a relation, we must ensure that the destination table will be created with all wanted fields
													  // or we must add it artificially
													
												End if 
												
												$Dom_userInfo:=DOM Create XML element:C865($Dom_attribute;"userInfo")
												
												If (Not:C34(str_equal ($Txt_buffer;$Txt_relationName)))
													
													$Dom_node:=DOM Create XML element:C865($Dom_userInfo;"entry";\
														"key";"keyMapping";\
														"value";$Txt_relationName)
													
												End if 
												
												  // Get all fields to put in expand userInfo
												$Col_fields:=New collection:C1472()
												OB GET PROPERTY NAMES:C1232($Obj_table[$Txt_relationName];$tTxt_relationFields)
												
												For ($Lon_relationField;1;Size of array:C274($tTxt_relationFields);1)
													
													If (Match regex:C1019("(?m-si)^\\d+$";$tTxt_relationFields{$Lon_relationField};1;*))  // field if
														
														$Txt_buffer:=$Obj_table[$Txt_relationName][$tTxt_relationFields{$Lon_relationField}].name
														$Col_fields.push($Txt_buffer)
														
														  // Else  // not a field
														
													End if 
												End for 
												
												  ///         without forgot the primaryKey
												$Txt_buffer:=$Obj_dataModel[String:C10($Obj_table[$Txt_relationName].relatedTableNumber)].primaryKey
												
												If ($Col_fields.indexOf($Txt_buffer)<0)
													
													$Col_fields.push($Txt_buffer)
													
												End if 
												
												If ($Col_fields.length>0)
													
													$Dom_node:=DOM Create XML element:C865($Dom_userInfo;"entry";\
														"key";"expand";\
														"value";$Col_fields.join(","))
													
												End if 
												
												  //__________________________________
											Else   // mode with one attribute core data for all related fields
												
												  // attribute mode
												$Dom_attribute:=DOM Create XML element:C865($Dom_entity;"attribute")
												
												If (OK=1)
													
													$Txt_fieldName:=formatString ("field-name";$Txt_relationName)
													
													DOM SET XML ATTRIBUTE:C866($Dom_attribute;\
														"name";$Txt_fieldName;\
														"attributeType";"Transformable";\
														"optional";"YES";\
														"indexed";"NO";\
														"syncable";"YES")
													
													$Dom_userInfo:=DOM Create XML element:C865($Dom_attribute;"userInfo")
													
													If (Not:C34(str_equal ($Txt_fieldName;$Txt_relationName)))
														
														$Dom_node:=DOM Create XML element:C865($Dom_userInfo;"entry";\
															"key";"keyMapping";\
															"value";$Txt_relationName)
														
													End if 
													
													$Dom_node:=DOM Create XML element:C865($Dom_userInfo;"entry";\
														"key";"path";\
														"value";$Obj_table[$Txt_relationName].relatedDataClass)
													
												End if 
												
												  //__________________________________
										End case 
										
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
				
				$File_:=$Obj_in.path
				
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
				
				CREATE FOLDER:C475($File_;*)
				
				DOM EXPORT TO FILE:C862($Dom_model;$File_)
				
				$Obj_out.success:=Bool:C1537(OK)
				$Obj_out.path:=$File_
				
				DOM CLOSE XML:C722($Dom_model)  // Modify the system variable OK!
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="xcdatamodel_relation")  // RECURSIVE CALL
		
		$Obj_dataModel:=$Obj_in.dataModel
		
		OB GET PROPERTY NAMES:C1232($Obj_dataModel;$tTxt_tables)  // #CLEAN: use for each on object
		
		For ($Lon_table;1;Size of array:C274($tTxt_tables);1)
			
			$Obj_table:=$Obj_dataModel[$tTxt_tables{$Lon_table}]
			OB GET PROPERTY NAMES:C1232($Obj_table;$tTxt_fields)
			
			For ($Lon_field;1;Size of array:C274($tTxt_fields);1)
				
				Case of 
						
						  //………………………………………………………………………………………………………………………
					: (Match regex:C1019("(?m-si)^\\d+$";$tTxt_fields{$Lon_field};1;*))
						
						  // field if ignore
						
						  //………………………………………………………………………………………………………………………
					: ((Value type:C1509($Obj_table[$tTxt_fields{$Lon_field}])=Is object:K8:27))
						
						$Txt_relationName:=$tTxt_fields{$Lon_field}  // link name (or primaryKey, etc...)
						
						If ($Obj_table[$Txt_relationName].relatedDataClass#Null:C1517)  // Is is a link?
							
							  // if this relatedDataClass in model?
							$Boo_found:=False:C215
							
							For ($Lon_table2;1;Size of array:C274($tTxt_tables);1)
								
								$Obj_relationTable:=$Obj_dataModel[$tTxt_tables{$Lon_table2}]
								
								If ($Obj_relationTable.name=$Obj_table[$Txt_relationName].relatedDataClass)
									
									$Boo_found:=True:C214
									$Lon_table2:=MAXLONG:K35:2-1  // Break
									
								End if 
							End for 
							
							OB GET PROPERTY NAMES:C1232($Obj_table[$Txt_relationName];$tTxt_relationFields)
							
							If (Not:C34($Boo_found))  // not found we must add a new table in model
								
								$Obj_relationTable:=New object:C1471(\
									"name";$Obj_table[$Txt_relationName].relatedDataClass\
									)
								
								$Obj_buffer:=structure (New object:C1471(\
									"action";"tableInfo";\
									"name";$Obj_relationTable.name))
								
								If ($Obj_buffer.success)
									
									$Obj_relationTable.primaryKey:=$Obj_buffer.tableInfo.primaryKey
									$Obj_relationTable.slave:=$Obj_table.name
									
									$Lon_relatedTableID:=$Obj_buffer.tableInfo.tableNumber
									APPEND TO ARRAY:C911($tTxt_tables;String:C10($Lon_relatedTableID))
									
									$Obj_dataModel[String:C10($Lon_relatedTableID)]:=$Obj_relationTable
									$Obj_out.hasBeenEdited:=True:C214
									
								Else 
									
									ob_error_add ($Obj_out;"Unknown related table "+String:C10($Obj_relationTable.name))
									
								End if 
							End if 
							
							  // just check if we must add new fields
							For ($Lon_field2;1;Size of array:C274($tTxt_relationFields);1)
								
								If (Match regex:C1019("(?m-si)^\\d+$";$tTxt_relationFields{$Lon_field2};1;*))
									
									If (($Obj_relationTable[$tTxt_relationFields{$Lon_field2}])=Null:C1517)
										
										$Obj_relationTable[$tTxt_relationFields{$Lon_field2}]:=$Obj_table[$Txt_relationName][$tTxt_relationFields{$Lon_field2}]  // name & type
										$Obj_out.hasBeenEdited:=True:C214
										
									End if 
								End if 
							End for 
							
							  // Get inverse field
							$Obj_buffer:=structure (New object:C1471(\
								"action";"inverseRelatedFields";\
								"table";$Obj_table.name;\
								"relation";$Txt_relationName;\
								"definition";$Obj_in.definition))
							
							If ($Obj_buffer.success)
								
								$Obj_in.definition:=$Obj_buffer.definition  // cache purpose
								
								For each ($Obj_field;$Obj_buffer.fields)  // CLEAN must only have one
									
									  // Create the inverse field
									If ($Obj_relationTable[$Obj_field.name]=Null:C1517)
										
										If (Bool:C1537(featuresFlags.withNewFieldProperties))
											
											$Obj_relationTable[$Obj_field.name]:=New object:C1471(\
												"kind";$Obj_field.kind;\
												"type";$Obj_field.fieldType;\
												"inverseName";$Txt_relationName;\
												"relatedDataClass";$Obj_field.relatedDataClass)
											
										Else 
											
											$Obj_relationTable[$Obj_field.name]:=New object:C1471(\
												"kind";$Obj_field.kind;\
												"type";$Obj_field.type;\
												"inverseName";$Txt_relationName;\
												"relatedDataClass";$Obj_field.relatedDataClass)
											
										End if 
										
									End if 
									
									$Obj_relationTable[$Obj_field.name].inverseName:=$Txt_relationName
									
									$Obj_out.hasBeenEdited:=True:C214
									
								End for each 
							End if 
						End if 
						
						  //………………………………………………………………………………………………………………………
				End case 
			End for 
		End for 
		
		$Obj_out.dataModel:=$Obj_dataModel
		$Obj_out.success:=Bool:C1537($Obj_out.hasBeenEdited)
		
		  //______________________________________________________
	: ($Obj_in.action="xcdatamodel_primaryKey")  // Add always primary key field in table model - RECURSIVE CALL
		
		$Obj_dataModel:=$Obj_in.dataModel
		
		OB GET PROPERTY NAMES:C1232($Obj_dataModel;$tTxt_tables)  // CLEAN: use for each on object
		
		For ($Lon_table;1;Size of array:C274($tTxt_tables);1)  // CLEAN use for each
			
			$Obj_table:=$Obj_dataModel[$tTxt_tables{$Lon_table}]
			OB GET PROPERTY NAMES:C1232($Obj_table;$tTxt_fields)
			
			If ($Obj_table.primaryKey#Null:C1517)
				
				  // Find if primary key is in model
				CLEAR VARIABLE:C89($Boo_found)
				
				Case of 
						
						  //………………………………………………………………………………………………………………………
					: (Value type:C1509($Obj_table.primaryKey)=Is object:K8:27)
						
						  // Pass as object
						$Txt_fieldName:=JSON Stringify:C1217($Obj_table.primaryKey)
						
						  //………………………………………………………………………………………………………………………
					: (Value type:C1509($Obj_table.primaryKey)=Is text:K8:3)
						
						$Txt_fieldName:=String:C10($Obj_table.primaryKey)
						
						  //………………………………………………………………………………………………………………………
					Else 
						
						$Obj_buffer:=structure (New object:C1471(\
							"action";"tableInfo";\
							"name";$Obj_table.name))
						
						$Txt_fieldName:=Choose:C955($Obj_buffer.success;$Obj_buffer.tableInfo.primaryKey;"")
						
						  //………………………………………………………………………………………………………………………
				End case 
				
				For ($Lon_field;1;Size of array:C274($tTxt_fields);1)
					
					If (Match regex:C1019("(?m-si)^\\d+$";$tTxt_fields{$Lon_field};1;*))
						
						$Obj_field:=$Obj_table[$tTxt_fields{$Lon_field}]
						
						If ($Obj_field.name=$Txt_fieldName)
							
							$Boo_found:=True:C214
							$Lon_field:=MAXLONG:K35:2-1
							
						End if 
					End if 
				End for 
				
				If (Not:C34($Boo_found))  // if not add missing primary key field
					
					$Obj_buffer:=structure (New object:C1471(\
						"action";"createField";\
						"table";$Obj_table.name;\
						"field";$Txt_fieldName))
					
					If ($Obj_buffer.success)
						
						$Obj_field:=$Obj_buffer.value
						$Obj_table[String:C10($Obj_field.id)]:=$Obj_field
						$Obj_out.hasBeenEdited:=True:C214
						
					Else 
						
						ob_error_combine ($Obj_out;$Obj_buffer)
						
					End if 
				End if 
			End if 
		End for 
		
		$Obj_out.dataModel:=$Obj_dataModel
		$Obj_out.success:=Bool:C1537($Obj_out.hasBeenEdited)
		
		  //______________________________________________________
	: ($Obj_in.action="xcdatamodel_field")  // RECURSIVE CALL
		
		$Dom_attribute:=$Obj_in.dom
		$Dom_userInfo:=$Obj_in.domUserInfo
		
		If (Bool:C1537(featuresFlags.withNewFieldProperties))
			
			  // Already in 4d type comparable
			$Lon_type:=$Obj_in.fieldType
			
		Else 
			
			$Lon_type:=$Obj_in.type
			
			If (Not:C34(Bool:C1537($Obj_in["4d"]))\
				 & ($Lon_type>0))
				
				$Obj_buffer:=structure (New object:C1471(\
					"action";"tmplType";\
					"value";$Lon_type))
				
				If ($Obj_buffer.success)
					
					$Lon_type:=$Obj_buffer.value
					
				End if 
			End if 
		End if 
		
		Case of 
				
				  //________________________________________
			: ($Lon_type=Is boolean:K8:9)
				
				DOM SET XML ATTRIBUTE:C866($Dom_attribute;\
					"attributeType";"Boolean";\
					"usesScalarValueType";"YES")
				
				  //________________________________________
			: ($Lon_type=Is alpha field:K8:1)\
				 | ($Lon_type=Is text:K8:3)
				
				DOM SET XML ATTRIBUTE:C866($Dom_attribute;\
					"attributeType";"String")
				
				  //________________________________________
			: ($Lon_type=Is date:K8:7)
				
				DOM SET XML ATTRIBUTE:C866($Dom_attribute;\
					"attributeType";"Date")
				
				  //________________________________________
			: ($Lon_type=Is picture:K8:10)
				
				DOM SET XML ATTRIBUTE:C866($Dom_attribute;\
					"attributeType";"Transformable")
				
				$Dom_node:=DOM Create XML element:C865($Dom_userInfo;"entry";\
					"key";"image";\
					"value";"YES")
				
				  //________________________________________
			: ($Lon_type=Is longint:K8:6)
				
				DOM SET XML ATTRIBUTE:C866($Dom_attribute;\
					"attributeType";"Integer 32";\
					"usesScalarValueType";"YES")
				
				  //________________________________________
			: ($Lon_type=Is integer:K8:5)
				
				DOM SET XML ATTRIBUTE:C866($Dom_attribute;\
					"attributeType";"Integer 32";\
					"usesScalarValueType";"YES")
				
				$Dom_node:=DOM Create XML element:C865($Dom_userInfo;"entry";\
					"key";"integer";\
					"value";"YES")
				
				  //________________________________________
			: ($Lon_type=Is integer 64 bits:K8:25)
				
				DOM SET XML ATTRIBUTE:C866($Dom_attribute;\
					"attributeType";"Integer 64")
				
				  //________________________________________
			: ($Lon_type=Is real:K8:4)
				
				DOM SET XML ATTRIBUTE:C866($Dom_attribute;\
					"attributeType";"Double";\
					"usesScalarValueType";"YES")
				
				  //________________________________________
			: ($Lon_type=Is time:K8:8)
				
				DOM SET XML ATTRIBUTE:C866($Dom_attribute;\
					"attributeType";"Integer 64";\
					"usesScalarValueType";"YES")
				
				$Dom_node:=DOM Create XML element:C865($Dom_userInfo;"entry";\
					"key";"duration";\
					"value";"YES")
				
				  //________________________________________
			: ($Lon_type=Is object:K8:27)
				
				DOM SET XML ATTRIBUTE:C866($Dom_attribute;\
					"attributeType";"Transformable")
				
				  //________________________________________
			: ($Lon_type=Is BLOB:K8:12)
				
				DOM SET XML ATTRIBUTE:C866($Dom_attribute;\
					"attributeType";"Binary")
				
				  //________________________________________
			: ($Lon_type=Is float:K8:26)
				
				DOM SET XML ATTRIBUTE:C866($Dom_attribute;\
					"attributeType";"Float";\
					"usesScalarValueType";"YES")
				
				  //________________________________________
			Else 
				
				DOM SET XML ATTRIBUTE:C866($Dom_attribute;\
					"attributeType";"String")
				
				ob_warning_add ($Obj_out;"Unknown type "+String:C10($Lon_type))
				
				  //________________________________________
		End case 
		
		$Obj_out.success:=True:C214
		
		  //______________________________________________________
	: ($Obj_in.action="tableCollection")  // Get table as collection - CALLERS : templates
		
		Case of 
				
				  //………………………………………………………………………………………………………………………
			: ($Obj_in.dataModel=Null:C1517)
				
				$Obj_out.errors:=New collection:C1472("Missing `dataModel` property")
				
				  //………………………………………………………………………………………………………………………
			Else 
				
				$Obj_dataModel:=$Obj_in.dataModel
				
				If (Value type:C1509($Obj_in.tables)=Is collection:K8:32)
					
					$Col_tables:=$Obj_in.tables
					
				Else 
					
					  // all table in model
					OB GET PROPERTY NAMES:C1232($Obj_dataModel;$tTxt_tables)
					$Col_tables:=New collection:C1472()
					ARRAY TO COLLECTION:C1563($Col_tables;$tTxt_tables)
					
				End if 
				
				$Obj_out.tables:=New collection:C1472
				
				For each ($Txt_tableNumber;$Col_tables)
					
					If ($Obj_dataModel[$Txt_tableNumber]#Null:C1517)
						
						$Obj_table:=OB Copy:C1225($Obj_dataModel[$Txt_tableNumber])
						
						$Obj_table.tableNumber:=Num:C11($Txt_tableNumber)
						
						If (Bool:C1537($Obj_in.tag))  // for tag format name
							
							$Obj_table.originalName:=$Obj_table.name
							$Obj_table.name:=formatString ("table-name";$Obj_table.name)
							
						End if 
						
						$Obj_out.tables.push($Obj_table)
						
					Else 
						
						  //ASSERT(dev_Matrix )
						
					End if 
				End for each 
				
				$Obj_out.success:=True:C214
				
				  //………………………………………………………………………………………………………………………
		End case 
		
		  //______________________________________________________
	: ($Obj_in.action="fieldCollection")  // get field name and if, format in list and detail userChoice - CALLERS : templates
		
		$Obj_out.success:=($Obj_in.table#Null:C1517)
		
		If ($Obj_out.success)
			
			$Obj_out.fields:=New collection:C1472()
			
			For each ($Txt_field;$Obj_in.table)
				
				Case of 
						
						  //………………………………………………………………………………………………………………………
					: (Match regex:C1019("(?m-si)^\\d+$";$Txt_field;1;*))
						
						$Obj_out.fields.push(New object:C1471(\
							"name";$Obj_in.table[$Txt_field].name;\
							"id";$Txt_field))  // TODO field.id change to fieldNumber
						
						  // add relation?
						
						  //………………………………………………………………………………………………………………………
					Else 
						
						  // Ignore
						
						  //………………………………………………………………………………………………………………………
				End case 
			End for each 
			
		Else 
			
			$Obj_out.errors:=New collection:C1472("Missing table property")
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="fieldNames")  // get field names for dump with table (model format) - CALLERS : dump
		
		$Obj_out.success:=($Obj_in.table#Null:C1517)
		
		If ($Obj_out.success)
			
			$Obj_out.fields:=New collection:C1472()
			$Obj_out.expand:=New collection:C1472()
			
			For each ($Txt_field;$Obj_in.table)
				
				Case of 
						
						  //………………………………………………………………………………………………………………………
					: (Match regex:C1019("(?m-si)^\\d+$";$Txt_field;1;*))
						
						$Obj_out.fields.push($Obj_in.table[$Txt_field].name)
						
						  //………………………………………………………………………………………………………………………
					: ((Value type:C1509($Obj_in.table[$Txt_field])=Is object:K8:27))
						
						$Obj_buffer:=$Obj_in.table[$Txt_field]
						
						If ($Obj_buffer.relatedDataClass#Null:C1517)  // Is is a link?
							
							If ($Obj_out.expand.indexOf($Txt_field)<0)
								
								$Obj_out.expand.push($Txt_field)
								
							End if 
							
							For each ($Txt_fieldNumber;$Obj_buffer)
								
								If (Match regex:C1019("(?m-si)^\\d+$";$Txt_fieldNumber;1;*))  // fieldNumber
									
									$Obj_out.fields.push($Txt_field+"."+$Obj_buffer[$Txt_fieldNumber].name)
									
								Else 
									
									  // Ignore (primary key, etc...)
									
								End if 
							End for each 
							
							  // Else  Ignore
							
						End if 
						
						  //………………………………………………………………………………………………………………………
					Else 
						
						  // Ignore
						
						  //………………………………………………………………………………………………………………………
				End case 
			End for each 
			
			  // Add primary key if needed for expanded data
			For each ($Txt_field;$Obj_out.expand)
				
				$Obj_buffer:=structure (New object:C1471(\
					"action";"tableInfo";\
					"name";String:C10($Obj_in.table[$Txt_field].relatedDataClass)))
				
				If ($Obj_buffer.success)
					
					$Txt_buffer:=$Txt_field+"."+$Obj_buffer.tableInfo.primaryKey
					
					If ($Obj_out.fields.indexOf($Txt_buffer)<0)
						
						$Obj_out.fields.push($Txt_buffer)
						
					End if 
					
				Else 
					
					ob_warning_add ($Obj_out;"Cannot get information for related table "+String:C10($Obj_in.table[$Txt_field].relatedDataClass)+"(related by "+$Txt_field+" in "+$Obj_in.table+")")
					
				End if 
			End for each 
			
			If ((Length:C16(String:C10($Obj_in.table.primaryKey))>0) & \
				($Obj_out.fields.indexOf(String:C10($Obj_in.table.primaryKey))<0))
				
				$Obj_out.fields.push($Obj_in.table.primaryKey)
				
			End if 
			
		Else 
			
			$Obj_out.errors:=New collection:C1472("Missing table property")
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="pictureFields")  // get field names for dump with table (model format) - CALLERS : dump
		
		$Obj_out.success:=($Obj_in.table#Null:C1517)
		
		If ($Obj_out.success)
			
			$Obj_out.fields:=New collection:C1472()
			$Obj_buffer:=$Obj_in.table
			
			For each ($Txt_field;$Obj_buffer)
				
				Case of 
						
						  //………………………………………………………………………………………………………………………
					: (Match regex:C1019("(?m-si)^\\d+$";$Txt_field;1;*))
						
						If (Bool:C1537(featuresFlags.withNewFieldProperties))
							
							If ($Obj_buffer[$Txt_field].fieldType=Is picture:K8:10)
								
								$Obj_out.fields.push($Obj_buffer[$Txt_field])
								
							End if 
							
						Else 
							
							If ($Obj_buffer[$Txt_field].type=Choose:C955(Bool:C1537(featuresFlags.withNewFieldProperties);3;12))  // if image
								
								$Obj_out.fields.push($Obj_buffer[$Txt_field])
								
							End if 
						End if 
						
						  //………………………………………………………………………………………………………………………
					: (Value type:C1509($Obj_buffer[$Txt_field])#Is object:K8:27)
						
						  //………………………………………………………………………………………………………………………
					: ($Obj_buffer[$Txt_field].relatedDataClass#Null:C1517)  // Is is a link?
						
						For each ($Txt_fieldNumber;$Obj_buffer[$Txt_field])
							
							If (Match regex:C1019("(?m-si)^\\d+$";$Txt_fieldNumber;1;*))  // fieldNumber
								
								If (Bool:C1537(featuresFlags.withNewFieldProperties))
									
									If ($Obj_buffer[$Txt_field][$Txt_fieldNumber].fieldType=Is picture:K8:10)  // if image
										
										$Obj_field:=OB Copy:C1225($Obj_buffer[$Txt_field][$Txt_fieldNumber])
										$Obj_field.relatedDataClass:=$Obj_buffer[$Txt_field].relatedDataClass  // copy it only if wanted to index picture on this table
										$Obj_field.relatedField:=$Txt_field
										$Obj_out.fields.push($Obj_field)
										
									End if 
									
								Else 
									
									If ($Obj_buffer[$Txt_field][$Txt_fieldNumber].type=Choose:C955(Bool:C1537(featuresFlags.withNewFieldProperties);3;12))  // if image
										
										$Obj_field:=OB Copy:C1225($Obj_buffer[$Txt_field][$Txt_fieldNumber])
										$Obj_field.relatedDataClass:=$Obj_buffer[$Txt_field].relatedDataClass  // copy it only if wanted to index picture on this table
										$Obj_field.relatedField:=$Txt_field
										$Obj_out.fields.push($Obj_field)
										
									End if 
								End if 
								
							Else 
								
								  // Ignore (primary key, etc...)
								
							End if 
						End for each 
						
						  //………………………………………………………………………………………………………………………
				End case 
			End for each 
			
		Else 
			
			$Obj_out.errors:=New collection:C1472("Missing table property")
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="fields")  // Return a readonly flat table field list - CALLERS : views_Handler
		
		$Obj_dataModel:=$Obj_in.dataModel
		
		$Obj_out.success:=($Obj_dataModel#Null:C1517)
		
		If ($Obj_out.success)
			
			$Obj_out.success:=($Obj_dataModel[$Obj_in.tableNumber]#Null:C1517)
			
			If ($Obj_out.success)
				
				$Obj_out.fields:=New collection:C1472
				
				For each ($Txt_value;$Obj_dataModel[$Obj_in.tableNumber])
					
					Case of 
							
							  //……………………………………………………………………………………………………………
							  //: (Match regex("(?m-si)^\\d+$";$Txt_value;1;*))  // fieldNumber
						: ($ƒ.isField($Txt_value))
							
							$Obj_field:=OB Copy:C1225($Obj_dataModel[$Obj_in.tableNumber][$Txt_value])
							$Obj_field.path:=$Obj_field.name
							$Obj_field.id:=Num:C11($Txt_value)
							$Obj_out.fields.push($Obj_field)
							
							  //……………………………………………………………………………………………………………
						: (Value type:C1509($Obj_dataModel[$Obj_in.tableNumber][$Txt_value])#Is object:K8:27)
							
							  //……………………………………………………………………………………………………………
							  //: ($Obj_dataModel[$Obj_in.tableNumber][$Txt_value].relatedDataClass#Null)  // relatedDataClass
						: ($ƒ.isRelatedDataClass($Obj_dataModel[$Obj_in.tableNumber][$Txt_value]))
							
							For each ($t;$Obj_dataModel[$Obj_in.tableNumber][$Txt_value])
								
								If (Match regex:C1019("(?m-si)^\\d+$";$t;1;*))  // fieldNumber
									
									$Obj_field:=OB Copy:C1225($Obj_dataModel[$Obj_in.tableNumber][$Txt_value][$t])
									$Obj_field.path:=$Txt_value+"."+$Obj_field.name
									$Obj_field.id:=Num:C11($t)
									$Obj_out.fields.push($Obj_field)
									
								End if 
							End for each 
							
							  //……………………………………………………………………………………………………………
					End case 
				End for each 
			End if 
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="tableNames")  // CALLERS : mobile_Project
		
		$Obj_dataModel:=$Obj_in.dataModel
		
		$Obj_out.success:=($Obj_dataModel#Null:C1517)
		
		If ($Obj_out.success)
			
			$Obj_out.values:=New collection:C1472
			
			For each ($t;$Obj_dataModel)
				
				$Obj_out.values.push($Obj_dataModel[$t].name)
				
				If (Bool:C1537($Obj_in.relation))
					
					For each ($tt;$Obj_dataModel[$t])
						
						If (Value type:C1509($Obj_dataModel[$t][$tt])=Is object:K8:27)
							
							If ($Obj_dataModel[$t][$tt].relatedDataClass#Null:C1517)
								
								$Obj_out.values.push($Obj_dataModel[$t][$tt].relatedDataClass)
								
							End if 
						End if 
					End for each 
				End if 
			End for each 
			
		Else 
			
			ASSERT:C1129(dev_Matrix ;"No data model")  //#ERROR
			
		End if 
		
		  //________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_in.action+"\"")
		
		  //________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End