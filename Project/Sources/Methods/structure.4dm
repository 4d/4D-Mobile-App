//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : structure
// ID[4D430254EBF34D71B0D7EED8A67D7A59]
// Created 27-6-2017 by Eric Marchand
// ----------------------------------------------------
// Description:
// Get database structure informations
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_find; $Boo_oneTable)
C_LONGINT:C283($l; $Lon_indx; $Lon_parameters; $Lon_tableNumber)
C_TEXT:C284($Dom_root; $t; $Txt_field; $Txt_onErrCall; $Txt_table; $Txt_xml)
C_OBJECT:C1216($errors; $o; $Obj_buffer; $Obj_catalog; $Obj_field; $Obj_in)
C_OBJECT:C1216($Obj_out; $Obj_relatedDataClass; $Obj_table; $Obj_types)
C_COLLECTION:C1488($c; $Col_catalog; $Col_fields; $Col_filtered; $Col_types)

If (False:C215)
	C_OBJECT:C1216(structure; $0)
	C_OBJECT:C1216(structure; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	// Required parameters
	$Obj_in:=$1
	
	// Optional parameters
	If ($Lon_parameters>=2)
		
		// <NONE>
		
	End if 
	
	$Obj_out:=New object:C1471(\
		"success"; False:C215)
	
	If (SHARED=Null:C1517)  // FIXME #105596
		
		If (RECORD#Null:C1517)
			RECORD.warning("SHARED=Null")
			RECORD.trace()
		End if 
		COMPONENT_INIT
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Obj_in.action=Null:C1517)
		
		ASSERT:C1129(False:C215)
		
		//______________________________________________________
	: ($Obj_in.action="catalog")  // Return the exposed datastore
		
		// -------------------------------------------------------------------------------------------
		// If 'name' or 'tableNumber is not null, the result is limited to the corresponding table
		// -------------------------------------------------------------------------------------------
		
		// Build Exposed Datastore:
		// • Only references tables with a single primary key. Tables without a primary key or with composite primary keys are not referenced.
		// • Only references tables & fields exposed with 4D Mobile services.
		// • BLOB type attributes are not managed in the datastore.
		
		// -------------------------------------------------------------------------------------------
		// ! A relation N -> 1 is not referenced if the field isn't exposed with 4D Mobile services !
		// -------------------------------------------------------------------------------------------
		
		$Obj_catalog:=_4D_Build Exposed Datastore:C1598
		
		$Obj_out.success:=($Obj_catalog#Null:C1517)
		
		If ($Obj_out.success)
			
			$Obj_out.value:=New collection:C1472
			
			$Boo_oneTable:=($Obj_in.name#Null:C1517) | ($Obj_in.tableNumber#Null:C1517)
			
			For each ($Txt_table; $Obj_catalog) Until ($Boo_find)
				
				$Obj_table:=$Obj_catalog[$Txt_table].getInfo()
				
				If ($Txt_table#SHARED.deletedRecordsTable.name)
					
					If ($Boo_oneTable)
						
						Case of 
								
								//______________________________________________________
							: ($Obj_in.name#Null:C1517)
								
								$Boo_find:=($Txt_table=$Obj_in.name)
								
								//______________________________________________________
							: ($Obj_in.tableNumber#Null:C1517)
								
								$Boo_find:=($Obj_table.tableNumber=$Obj_in.tableNumber)
								
								//______________________________________________________
						End case 
					End if 
					
					If ($Boo_oneTable)
						
						$Obj_out.success:=$Boo_find
						
					End if 
					
					If ($Obj_out.success)
						
						If (Not:C34($Boo_oneTable)) | $Boo_find
							
							$Obj_out.value.push($Obj_table)
							
							$Obj_table.field:=New collection:C1472
							
							For each ($Txt_field; $Obj_catalog[$Txt_table])
								
								If ($Txt_field#SHARED.stampField.name)
									
									$Obj_field:=$Obj_catalog[$Txt_table][$Txt_field]
									
									$l:=$Obj_table.field.extract("name").indexOf($Txt_field)
									
									If ($l>=0)
										
										If (Not:C34(str_equal($Txt_field; $Obj_table.field.extract("name")[$l])))
											
											$l:=-1
											
										End if 
									End if 
									
									Case of 
											
											//…………………………………………………………………………………………………
										: ($l#-1)
											
											// NOT ALLOW DUPLICATE NAMES !
											err_PUSH($Obj_out; "Name conflict for \""+$Txt_field+"\""; Warning message:K38:2)
											
											//…………………………………………………………………………………………………
										: (Position:C15("."; $Txt_field)>0)
											
											// NOT ALLOW FIELD OR RELATION NAME WITH DOT !
											
											//…………………………………………………………………………………………………
										: ($Obj_field.kind="storage")
											
											// storage (or scalar) attribute, i.e. attribute storing a value, not a reference to another attribute
											
											If ($Obj_field.fieldType#Is object:K8:27)\
												 & ($Obj_field.fieldType#Is BLOB:K8:12)\
												 & ($Obj_field.fieldType#Is subtable:K8:11)  // Exclude object and blob fields [AND SUBTABLE]
												
												// #TEMPO [
												$Obj_field.id:=$Obj_field.fieldNumber
												$Obj_field.valueType:=$Obj_field.type
												$Obj_field.type:=tempoFiledType($Obj_field.fieldType)
												//]
												
												$Obj_table.field.push($Obj_field)
												
											End if 
											
											//…………………………………………………………………………………………………
										: ($Obj_field.kind="relatedEntity")
											
											// N -> 1 relation attribute (reference to an entity)
											
											If ($Obj_catalog[$Obj_field.relatedDataClass]#Null:C1517)
												
												$Obj_table.field.push(New object:C1471(\
													"name"; $Txt_field; \
													"inverseName"; $Obj_field.inverseName; \
													"type"; -1; \
													"relatedDataClass"; $Obj_field.relatedDataClass; \
													"relatedTableNumber"; $Obj_catalog[$Obj_field.relatedDataClass].getInfo().tableNumber))
												
											End if 
											
											//…………………………………………………………………………………………………
										: ($Obj_field.kind="relatedEntities")
											
											// 1 -> N relation attribute (reference to an entity selection)
											
											$Obj_table.field.push(New object:C1471(\
												"name"; $Txt_field; \
												"inverseName"; $Obj_field.inverseName; \
												"type"; -2; \
												"relatedDataClass"; $Obj_field.relatedDataClass; \
												"relatedTableNumber"; $Obj_catalog[$Obj_field.relatedDataClass].getInfo().tableNumber))
											
											//…………………………………………………………………………………………………
									End case 
									
								Else 
									
									// DON'T DISPLAY STAMP FIELD
									
								End if 
							End for each 
							
							If (Bool:C1537($Obj_in.sorted))
								
								$Obj_table.field:=$Obj_table.field.orderBy("name asc")
								
							End if 
						End if 
					End if 
					
				Else 
					
					// DON'T DISPLAY DELETED RECORDS TABLE
					
				End if 
			End for each 
			
			If ($Obj_out.success)
				
				If (Bool:C1537($Obj_in.sorted))
					
					$Obj_out.value:=$Obj_out.value.orderBy("name asc")
					
				End if 
				
			Else 
				
				OB REMOVE:C1226($Obj_out; "value")
				
				If ($Boo_oneTable)
					
					err_PUSH($Obj_out; "Table not found: "+Choose:C955($Obj_in.name#Null:C1517; $Obj_in.name; "#"+String:C10($Obj_in.tableNumber)))
					
				End if 
			End if 
		End if 
		
		//______________________________________________________
	: ($Obj_in.action="fieldDefinition")  // Returns the field definition from the starting table number and its path
		
		ASSERT:C1129(($Obj_in.tableNumber#Null:C1517) | ($Obj_in.tableNamer#Null:C1517))
		ASSERT:C1129(($Obj_in.path#Null:C1517) | ($Obj_in.fieldNumber#Null:C1517))
		
		If ($Obj_in.catalog=Null:C1517)
			
			// Get the catalog
			$Col_catalog:=structure(New object:C1471(\
				"action"; "catalog")).value
			
		Else 
			
			$Col_catalog:=$Obj_in.catalog
			
		End if 
		
		$Lon_tableNumber:=$Obj_in.tableNumber
		
		$c:=Split string:C1554($Obj_in.path; ".")
		
		If ($c.length=1)
			
			$Lon_indx:=$Col_catalog.extract("tableNumber").indexOf($Lon_tableNumber)
			
			If ($Lon_indx#-1)
				
				$Col_fields:=$Col_catalog[$Lon_indx].field
				
				$Lon_indx:=$Col_fields.extract("name").indexOf($c[0])
				
				If ($Lon_indx#-1)
					
					$Obj_out.success:=True:C214
					
					$Obj_field:=$Col_fields[$Lon_indx]
					
					$Obj_out.path:=$Obj_in.path
					$Obj_out.tableNumber:=$Lon_tableNumber
					$Obj_out.tableName:=Table name:C256($Lon_tableNumber)
					
					If ($Obj_field.type=-2)  //1 to N relation
						
						$Obj_out.fieldType:=8859
						$Obj_out.type:=-2
						$Obj_out.relatedDataClass:=$Obj_field.relatedDataClass
						$Obj_out.relatedTableNumber:=$Obj_field.relatedTableNumber
						
					Else 
						
						$Obj_out.fieldNumber:=$Obj_field.fieldNumber
						$Obj_out.fieldType:=$Obj_field.fieldType
						$Obj_out.name:=Field name:C257($Lon_tableNumber; $Obj_field.fieldNumber)
						$Obj_out.type:=tempoFiledType($Obj_field.fieldType)
						
					End if 
					
				Else 
					
					err_PUSH($Obj_out; "Field not found")
					
				End if 
				
			Else 
				
				err_PUSH($Obj_out; "Table not found #"+String:C10($Lon_tableNumber))
				
			End if 
			
		Else 
			
			$Lon_indx:=$Col_catalog.extract("tableNumber").indexOf($Lon_tableNumber)
			
			If ($Lon_indx#-1)
				
				$Col_fields:=$Col_catalog[$Lon_indx].field
				
				$Lon_indx:=$Col_fields.extract("name").indexOf($c[0])
				
				If ($Lon_indx#-1)
					
					$Lon_tableNumber:=$Col_fields[$Lon_indx].relatedTableNumber
					
					If ($c.length>2)
						
						$Obj_field:=structure(New object:C1471(\
							"action"; "fieldDefinition"; \
							"path"; $c.copy().remove(0).join("."); \
							"tableNumber"; $Lon_tableNumber; \
							"catalog"; $Col_catalog))
						
						$Obj_out:=$Obj_field
						
						$Obj_out.path:=$Obj_in.path
						
					Else 
						
						$Lon_indx:=$Col_catalog.extract("tableNumber").indexOf($Lon_tableNumber)
						
						If ($Lon_indx#-1)
							
							$Col_fields:=$Col_catalog[$Lon_indx].field
							
							$Lon_indx:=$Col_fields.extract("name").indexOf($c[1])
							
							If ($Lon_indx#-1)
								
								$Obj_out.success:=True:C214
								$Obj_field:=$Col_fields[$Lon_indx]
								
								$Obj_out.path:=$Obj_in.path
								$Obj_out.tableName:=Table name:C256($Lon_tableNumber)
								$Obj_out.tableNumber:=$Lon_tableNumber
								$Obj_out.fieldNumber:=$Obj_field.fieldNumber
								$Obj_out.name:=Field name:C257($Lon_tableNumber; $Obj_field.fieldNumber)
								$Obj_out.fieldType:=$Obj_field.fieldType
								
								// #TEMPO [
								$Obj_out.valueType:=$Obj_field.type
								$Obj_out.type:=tempoFiledType($Obj_field.fieldType)
								//]
								
							Else 
								
								err_PUSH($Obj_out; "Related field not found")
								
							End if 
							
						Else 
							
							err_PUSH($Obj_out; "Related table not found")
							
						End if 
					End if 
					
				Else 
					
					err_PUSH($Obj_out; "Field not found")
					
				End if 
				
			Else 
				
				err_PUSH($Obj_out; "Table not found")
				
			End if 
		End if 
		
		//______________________________________________________
	: ($Obj_in.action="relatedCatalog")  // Return related entity catalog
		
		ASSERT:C1129($Obj_in.table#Null:C1517)
		ASSERT:C1129($Obj_in.relatedEntity#Null:C1517)
		
		$Obj_catalog:=_4D_Build Exposed Datastore:C1598
		
		$Obj_field:=$Obj_catalog[$Obj_in.table][$Obj_in.relatedEntity]
		
		Case of 
				
				//…………………………………………………………………………………………………
			: ($Obj_field=Null:C1517)
				
				// <NOTHING MORE TO DO>
				
				//…………………………………………………………………………………………………
			: ($Obj_field.kind="relatedEntity")  // N -> 1 relation
				
				$Obj_out.success:=True:C214
				$Obj_out.fields:=New collection:C1472
				$Obj_out.relatedEntity:=$Obj_field.name
				$Obj_out.relatedTableNumber:=$Obj_catalog[$Obj_field.relatedDataClass].getInfo().tableNumber
				$Obj_out.relatedDataClass:=$Obj_field.relatedDataClass
				$Obj_out.inverseName:=$Obj_field.inverseName
				
				$Obj_relatedDataClass:=$Obj_catalog[$Obj_field.relatedDataClass]
				
				For each ($Txt_field; $Obj_relatedDataClass)
					
					$o:=$Obj_relatedDataClass[$Txt_field]
					
					Case of 
							
							//___________________________________________
						: ($o.name=SHARED.stampField.name)
							
							// DON'T DISPLAY STAMP FIELD
							
							//___________________________________________
						: ($o.kind="storage")
							
							// Exclude object and blob fields [AND SUBTABLE]
							If (New collection:C1472(Is object:K8:27; Is BLOB:K8:12; Is subtable:K8:11).indexOf($o.fieldType)=-1)
								
								// #TEMPO [
								//$o.id:=$o.fieldNumber
								$o.valueType:=$o.type
								
								$o.type:=tempoFiledType($o.fieldType)
								
								$o.relatedTableNumber:=$Obj_out.relatedTableNumber
								
								$Obj_out.fields.push($o)
								
							End if 
							
							//___________________________________________
						: ($o.kind="relatedEntity")
							
							// <NOT YET  MANAGED>
							
							//…………………………………………………………………………………………………
						: ($o.kind="relatedEntities")
							
							// 1 -> N relation attribute (reference to an entity selection)
							
							// <NOT YET  MANAGED>
							
							//___________________________________________
					End case 
				End for each 
				
				//…………………………………………………………………………………………………
			: ($Obj_field.kind="relatedEntities")  // 1 -> N relation
				
				//…………………………………………………………………………………………………
			Else 
				
				// <NOTHING MORE TO DO>
				
				//…………………………………………………………………………………………………
		End case 
		
		//______________________________________________________
	: ($Obj_in.action="inverseRelatedFields")  // on related data class, get related fields linked to current table CALLER: [dataModel]
		
		Case of 
				
				//…………………………………………………………………………………………………
			: (($Obj_in.table=Null:C1517)\
				 | ($Obj_in.relation=Null:C1517))
				
				ob_error_add($Obj_out; "table ore relation name must be defined")
				
				//…………………………………………………………………………………………………
			Else 
				
				$Obj_catalog:=_4D_Build Exposed Datastore:C1598
				$Obj_table:=$Obj_catalog[String:C10($Obj_in.table)]
				
				If ($Obj_table#Null:C1517)
					
					$Obj_field:=$Obj_table[$Obj_in.relation]
					
					If ($Obj_field#Null:C1517)
						
						$Obj_out.fields:=New collection:C1472
						
						// Get inverse name
						If (Length:C16(String:C10($Obj_field.inverseName))>0)
							$Obj_buffer:=New object:C1471("value"; $Obj_field.inverseName; "success"; True:C214)
						Else   // OBSOLETE normally
							$Obj_buffer:=structure(New object:C1471(\
								"action"; "inverseRelationName"; \
								"table"; $Obj_in.table; \
								"relation"; $Obj_in.relation; \
								"definition"; $Obj_in.definition))
						End if 
						
						If ($Obj_buffer.success)
							
							$Obj_out.definition:=$Obj_buffer.definition  // cache purpose // OBSOLETE normally
							
							// Get inverse table
							$Obj_relatedDataClass:=$Obj_catalog[$Obj_field.relatedDataClass]
							
							$o:=$Obj_relatedDataClass[$Obj_buffer.value]
							$Obj_out.success:=($o#Null:C1517)
							If ($Obj_out.success)
								
								$o.relatedTableNumber:=$Obj_table.getInfo().tableNumber
								$Obj_out.fields.push($o)
							End if 
						Else 
							
							//  // FIXME #103848 TODO filter, must be the inverse of $Obj_in.field
							//For each ($Txt_field;$Obj_relatedDataClass)
							
							//If (($Obj_relatedDataClass[$Txt_field].kind="relatedEntity")\
																																
							//If ($Obj_relatedDataClass[$Txt_field].relatedDataClass=$Obj_in.table)
							
							//$Obj_out.fields.push($Obj_relatedDataClass[$Txt_field])
							//$Obj_out.success:=True
							
							//End if
							//End if
							//End for each
							
						End if 
					End if 
				End if 
				
				//…………………………………………………………………………………………………
		End case 
		
		//______________________________________________________
	: ($Obj_in.action="inverseRelationName")  //  [OBSOLETE]
		
		Case of 
				
				//…………………………………………………………………………………………………
			: (($Obj_in.table=Null:C1517)\
				 | ($Obj_in.relation=Null:C1517))
				
				ob_error_add($Obj_out; "table ore relation name must be defined")
				
				//…………………………………………………………………………………………………
			Else 
				
				// Until DS provide information about relation, use xml. redmine #103848
				
				$Obj_out:=Choose:C955(Value type:C1509($Obj_in.definition)=Is object:K8:27; New object:C1471(\
					"success"; True:C214; \
					"value"; $Obj_in.definition); \
					structure(New object:C1471(\
					"action"; "definition")))
				
				If ($Obj_out.success)
					
					$Obj_out.definition:=$Obj_out.value
					$Obj_out.value:=Null:C1517
					
					If (Value type:C1509($Obj_out.definition.relation)=Is object:K8:27)
						
						$Obj_out.definition.relation:=New collection:C1472($Obj_out.definition.relation)
						
					End if 
					
					If (Value type:C1509($Obj_out.definition.relation)=Is collection:K8:32)
						
						For each ($Obj_buffer; $Obj_out.definition.relation) Until ($Obj_out.value#Null:C1517)
							
							Case of 
									
									//………………………………………………………………………………………………………………………
								: ($Obj_buffer["name_1toN"]=$Obj_in.relation)
									
									For each ($Obj_field; $Obj_buffer.related_field)
										
										If ($Obj_field.kind="destination")
											
											If ($Obj_field.field_ref.table_ref.name=$Obj_in.table)
												
												$Obj_out.value:=$Obj_buffer["name_Nto1"]
												
											End if 
										End if 
									End for each 
									
									//………………………………………………………………………………………………………………………
								: ($Obj_buffer["name_Nto1"]=$Obj_in.relation)
									
									For each ($Obj_field; $Obj_buffer.related_field)
										
										If ($Obj_field.kind="source")
											
											If ($Obj_field.field_ref.table_ref.name=$Obj_in.table)
												
												$Obj_out.value:=$Obj_buffer["name_1toN"]
												
											End if 
										End if 
									End for each 
									
									//………………………………………………………………………………………………………………………
							End case 
						End for each 
					End if 
					
					$Obj_out.success:=($Obj_out.value#Null:C1517)
					
				End if 
				
				//________________________________________
		End case 
		
		//______________________________________________________
	: ($Obj_in.action="createField")  // CALLER: [dataModel] (add missing primary key field)
		
		$Obj_catalog:=_4D_Build Exposed Datastore:C1598
		$Obj_table:=$Obj_catalog[String:C10($Obj_in.table)]
		
		If ($Obj_table#Null:C1517)
			
			$Obj_field:=$Obj_table[$Obj_in.field]
			
			If ($Obj_field#Null:C1517)
				
				$Obj_out.success:=True:C214
				
				// Format as other fields
				
				//#REMINDER: Change id -> fieldNumber
				$Obj_out.value:=New object:C1471(\
					"id"; $Obj_field.fieldNumber; \
					"name"; $Obj_field.name; \
					"label"; formatString("label"; $Obj_field.name); \
					"shortLabel"; formatString("label"; $Obj_field.name); \
					"fieldType"; $Obj_field.fieldType)
				
			End if 
		End if 
		
		//______________________________________________________
	: ($Obj_in.action="hasField")  // Check that table contains a field CALLER: [dataModel]
		
		Case of 
				
				//…………………………………………………………………………………………………
			: (($Obj_in.table=Null:C1517)\
				 | ($Obj_in.field=Null:C1517))
				
				ob_error_add($Obj_out; "table and field name must be defined")
				
				//…………………………………………………………………………………………………
			Else 
				
				$Obj_catalog:=_4D_Build Exposed Datastore:C1598
				$Obj_table:=$Obj_catalog[String:C10($Obj_in.table)]
				
				If ($Obj_table#Null:C1517)
					
					$Obj_field:=$Obj_table[$Obj_in.field]
					
					$Obj_out.value:=$Obj_field#Null:C1517
					$Obj_out.success:=True:C214
					
				Else 
					
					ob_error_add($Obj_out; "table "+String:C10($Obj_in.table)+" not found")
					$Obj_out.value:=False:C215
					$Obj_out.success:=False:C215
					
				End if 
				
				// ----------------------------------------
		End case 
		
		//______________________________________________________
	: ($Obj_in.action="tableInfo")  // Return table.getInfo() from table name CALLER: [dataModel]
		
		If (Asserted:C1132($Obj_in.name#Null:C1517; "missing 'name' key"))
			
			$Obj_catalog:=_4D_Build Exposed Datastore:C1598
			
			$Obj_out.success:=($Obj_catalog[$Obj_in.name]#Null:C1517)
			
			If ($Obj_out.success)
				
				$Obj_out.tableInfo:=$Obj_catalog[$Obj_in.name].getInfo()
				
			End if 
		End if 
		
		//______________________________________________________
	: ($Obj_in.action="tableNumber")  // Return table number from table name
		
		If (Asserted:C1132($Obj_in.name#Null:C1517; "missing 'name' key"))
			
			$Obj_catalog:=_4D_Build Exposed Datastore:C1598
			
			$Obj_out.success:=($Obj_catalog[$Obj_in.name]#Null:C1517)
			
			If ($Obj_out.success)
				
				$Obj_out.tableNumber:=$Obj_catalog[$Obj_in.name].getInfo().tableNumber
				
			End if 
		End if 
		
		//______________________________________________________
	: ($Obj_in.action="tmplType")  // Type mapping for svg templates [OBSOLETE]
		
		// TODO cache this collection (COMPONENT_INIT?)
		$Col_types:=New collection:C1472
		$Col_types[1]:=Is boolean:K8:9
		$Col_types[3]:=Is integer:K8:5
		$Col_types[4]:=Is longint:K8:6
		$Col_types[5]:=Is integer 64 bits:K8:25
		$Col_types[6]:=Is real:K8:4
		$Col_types[7]:=_o_Is float:K8:26
		$Col_types[8]:=Is date:K8:7
		$Col_types[9]:=Is time:K8:8
		$Col_types[10]:=Is text:K8:3
		$Col_types[12]:=Is picture:K8:10
		$Col_types[18]:=Is BLOB:K8:12
		$Col_types[21]:=Is object:K8:27
		
		$Obj_out.value:=$Col_types[$Obj_in.value]
		
		$Obj_out.success:=$Obj_out.value#Null:C1517
		
		//______________________________________________________
	: ($Obj_in.action="entityType")  // Type mapping for enttity RECURSIVE - [OBSOLETE]
		
		$Obj_types:=New object:C1471
		$Obj_types["bool"]:=1
		$Obj_types["word"]:=3
		$Obj_types["long"]:=4
		$Obj_types["long64"]:=5
		$Obj_types["number"]:=6
		$Obj_types["string"]:=10
		$Obj_types["date"]:=8
		$Obj_types["duration"]:=9
		$Obj_types["image"]:=12
		$Obj_types["blob"]:=18
		$Obj_types["object"]:=21
		
		$Obj_out.value:=$Obj_types[String:C10($Obj_in.value)]
		
		$Obj_out.success:=$Obj_out.value#Null:C1517
		
		//______________________________________________________
	: ($Obj_in.action="tables")  //  [OBSOLETE]
		
		If (Bool:C1537(feature._98145))  //#MARK_TODO - CHANGE "tables" entrypoint to "catalog"
			
			// CHECK ALL CALLERS AND UNIT TEST
			
			$Obj_buffer:=OB Copy:C1225($Obj_in)
			
			OB REMOVE:C1226($Obj_in; "caller")
			
			$Obj_in.action:="catalog"
			
			$Obj_out:=structure($Obj_in)
			
			$Obj_in:=$Obj_buffer
			
		Else 
			
			$Obj_out:=structure(New object:C1471(\
				"action"; "definition"))
			
			If ($Obj_out.success)
				
				// Keep the tables definition only
				If ($Obj_out.value.table#Null:C1517)
					
					$Obj_out.value:=$Obj_out.value.table
					
				Else 
					
					// No table
					$Obj_out.value:=New collection:C1472
					$Obj_out.success:=False:C215
					
				End if 
			End if 
			
			If ($Obj_out.success)
				
				If (Bool:C1537($Obj_in.inRest))
					
					// -----------------------------------
					// [REST] - Remove not exposed tables
					// -----------------------------------
					$Col_filtered:=New collection:C1472
					
					If (Value type:C1509($Obj_out.value)=Is collection:K8:32)
						
						For each ($Obj_table; $Obj_out.value)
							
							If (Not:C34(Bool:C1537($Obj_table.hide_in_REST)))
								
								$Col_filtered.push(structure(New object:C1471(\
									"action"; "tableDefinition"; \
									"value"; $Obj_table)).value)
								
								// Remove incompatible and not exposed fields
								If (Value type:C1509($Obj_table.field)=Is collection:K8:32)
									
									For each ($Obj_field; $Obj_table.field)
										
										If (_o_rest_isValidField($Obj_field))
											
											// Cleanup the properties
											$Obj_field:=structure(New object:C1471(\
												"action"; "fieldDefinition"; \
												"value"; $Obj_field)).value
											
										Else 
											
											// Mark the field to remove
											$Obj_field.hidden:=True:C214
											
										End if 
									End for each 
									
									// Remove marked fields
									For each ($l; $Obj_table.field.indices("hidden = :1"; True:C214).reverse())
										
										$Obj_table.field.remove($l)
										
									End for each 
									
								Else 
									
									// Only one field
									If (_o_rest_isValidField($Obj_table.field))
										
										$Obj_table.field:=structure(New object:C1471(\
											"action"; "fieldDefinition"; \
											"value"; $Obj_table.field)).value
										
									Else 
										
										// Remove the field and so the table
										$Col_filtered.pop()
										
									End if 
								End if 
							End if 
						End for each 
						
					Else 
						
						// Only one table
						$Obj_table:=$Obj_out.value
						
						If (Not:C34(Bool:C1537($Obj_table.hide_in_REST)))
							
							$Obj_table:=structure(New object:C1471(\
								"action"; "tableDefinition"; \
								"value"; $Obj_table)).value
							
							$Col_filtered.push($Obj_table)
							
							// Remove incompatible and not exposed fields, if any
							If (Value type:C1509($Obj_table.field)=Is collection:K8:32)
								
								For each ($Obj_field; $Obj_table.field)
									
									If (_o_rest_isValidField($Obj_field))
										
										// Cleanup the properties
										$Obj_field:=structure(New object:C1471(\
											"action"; "fieldDefinition"; \
											"value"; $Obj_field)).value
										
									Else 
										
										// Mark the field to remove
										$Obj_field.hidden:=True:C214
										
									End if 
								End for each 
								
								// Remove marked fields
								For each ($l; $Obj_table.field.indices("hidden = :1"; True:C214).reverse())
									
									$Obj_table.field.remove($l)
									
								End for each 
								
							Else 
								
								// Only one field
								If (_o_rest_isValidField($Obj_table.field))
									
									// Remove unnecessary informations
									$Obj_table.field:=structure(New object:C1471(\
										"action"; "fieldDefinition"; \
										"value"; $Obj_table.field)).value
									
								Else 
									
									// Remove the field and so the table
									$Col_filtered:=New collection:C1472
									
								End if 
							End if 
						End if 
					End if 
					
					$Obj_out.value:=$Col_filtered
					
				End if 
			End if 
		End if 
		
		//______________________________________________________
	: ($Obj_in.action="definition")  // A GARDER POUR LE MOMENT
		
		EXPORT STRUCTURE:C1311($Txt_xml)
		
/* START HIDING ERRORS */$errors:=err.hide()
		$Dom_root:=DOM Parse XML variable:C720($Txt_xml)
		
		If (OK=1)
			
			$Obj_out:=New object:C1471(\
				"success"; True:C214; \
				"value"; xml_refToObject($Dom_root))
			
			DOM CLOSE XML:C722($Dom_root)
			
			If ($Obj_out.success)
				
				$Obj_out.value:=$Obj_out.value.base
				
			End if 
		End if 
		
/* STOP HIDING ERRORS */$errors.show()
		
		//______________________________________________________
		//: (Not(Bool(featuresFlags._103411)))
		
		//ASSERT(False;"Not implemented: \""+$Obj_in.action+"\"")
		
		//______________________________________________________
	: ($Obj_in.action="verify@")
		
		Case of 
				
				//…………………………………………………………………………………………………………………
			: ($Obj_in.action="verify")
				
				$Obj_catalog:=_4D_Build Exposed Datastore:C1598
				
				$Obj_out.success:=structure(New object:C1471(\
					"action"; "verifyDeletedRecords"; \
					"catalog"; $Obj_catalog)).success
				
				If ($Obj_out.success)
					
					If (Value type:C1509($Obj_in.tables)=Is collection:K8:32)
						
						For each ($t; $Obj_in.tables) While ($Obj_out.success)
							
							$Obj_out.success:=structure(New object:C1471(\
								"action"; "verifyStamps"; \
								"tableName"; $t; \
								"catalog"; $Obj_catalog)).success
							
						End for each 
						
					Else 
						
						$Obj_out.success:=structure(New object:C1471(\
							"action"; "verifyStamps"; \
							"tableName"; $Obj_in.tables; \
							"catalog"; $Obj_catalog)).success
						
					End if 
				End if 
				
				//…………………………………………………………………………………………………………………
			: ($Obj_in.action="verifyDeletedRecords")
				
				If ($Obj_in.catalog=Null:C1517)
					
					$Obj_in.catalog:=_4D_Build Exposed Datastore:C1598
					
				End if 
				
				$Obj_out.success:=($Obj_in.catalog[SHARED.deletedRecordsTable.name]#Null:C1517)
				
				//…………………………………………………………………………………………………………………
			: ($Obj_in.action="verifyStamps")
				
				$Obj_out.success:=($Obj_in.tableName#Null:C1517)
				ASSERT:C1129($Obj_out.success; "Missing tableName")
				
				If ($Obj_out.success)
					
					If ($Obj_in.catalog=Null:C1517)
						
						$Obj_in.catalog:=_4D_Build Exposed Datastore:C1598
						
					End if 
					
					$Obj_out.success:=($Obj_in.catalog[$Obj_in.tableName][SHARED.stampField.name]#Null:C1517)
					
				End if 
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Unknown entry point: \""+$Obj_in.action+"\"")
				
				//______________________________________________________
		End case 
		
		//______________________________________________________
	: ($Obj_in.action="create@")
		
		Case of 
				
				//…………………………………………………………………………………………………………………
			: ($Obj_in.action="create")
				
				ASSERT:C1129($Obj_in.tables#Null:C1517)
				
				$Obj_out.success:=structure(New object:C1471(\
					"action"; "createDeletedRecords"; \
					"catalog"; _4D_Build Exposed Datastore:C1598)).success
				
				If ($Obj_out.success)
					
					For each ($t; $Obj_in.tables) While ($Obj_out.success)
						
						$Obj_out.success:=structure(New object:C1471(\
							"action"; "createStamps"; \
							"tableName"; $t)).success
						
					End for each 
				End if 
				
				//…………………………………………………………………………………………………………………
			: ($Obj_in.action="createDeletedRecords")
				
				$Txt_onErrCall:=Method called on error:C704
				
/* START TRAPPING ERRORS */$errors:=err.capture()
				
				// Create table if any
				DOCUMENT:="CREATE TABLE IF NOT EXISTS "+String:C10(SHARED.deletedRecordsTable.name)+" ("
				
				For each ($o; SHARED.deletedRecordsTable.fields)
					
					DOCUMENT:=DOCUMENT+" "+String:C10($o.name)+" "+String:C10($o.type)+","
					
					If (Bool:C1537($o.primaryKey))
						
						DOCUMENT:=DOCUMENT+" PRIMARY KEY ("+String:C10($o.name)+"),"
						
					End if 
				End for each 
				
				DOCUMENT:=Delete string:C232(DOCUMENT; Length:C16(DOCUMENT); 1)
				
				DOCUMENT:=DOCUMENT+");"
				
				Begin SQL
					
					EXECUTE IMMEDIATE :DOCUMENT
					
				End SQL
				
				For each ($o; SHARED.deletedRecordsTable.fields)
					
					If (Bool:C1537($o.autoincrement))
						
						DOCUMENT:="ALTER TABLE "+String:C10(SHARED.deletedRecordsTable.name)+" MODIFY "+String:C10($o.name)+" ENABLE AUTO_INCREMENT;"
						
						Begin SQL
							
							EXECUTE IMMEDIATE :DOCUMENT
							
						End SQL
						
					End if 
				End for each 
				
				// Create the indexes if any
				For each ($o; SHARED.deletedRecordsTable.fields)
					
					If (Bool:C1537($o.indexed))
						
						DOCUMENT:="CREATE INDEX "+String:C10(SHARED.deletedRecordsTable.name)+String:C10($o.name)+" ON "+String:C10(SHARED.deletedRecordsTable.name)+" ("+String:C10($o.name)+");"
						
					End if 
					
					$errors.reset()
					
					Begin SQL
						
						EXECUTE IMMEDIATE :DOCUMENT
						
					End SQL
					
					If ($errors.lastError.stack#Null:C1517)
						
						If ($errors.lastError.stack[0].code=1155)
							
							// Index already exists
							
						Else 
							
							ob_createPath($Obj_out; "errors"; Is collection:K8:32).errors.push($errors.lastError.stack[0].error+" ("+$t+")")
							
						End if 
					End if 
				End for each 
				
				$Obj_out.success:=($Obj_out.errors=Null:C1517)
				
/* STOP TRAPPING ERRORS */$errors.release()
				
				//…………………………………………………………………………………………………………………
			: ($Obj_in.action="createStamps")
				
				$Obj_out.success:=($Obj_in.tableName#Null:C1517)
				ASSERT:C1129($Obj_out.success; "Missing tableName")
				
				If ($Obj_out.success)
					
					If (Value type:C1509($Obj_in.tableName)=Is collection:K8:32)
						
						$Obj_out.success:=True:C214
						
						For each ($t; $Obj_in.tableName) While ($Obj_out.success)
							
							$Obj_out.success:=structure(New object:C1471(\
								"action"; "addStamp"; \
								"tableName"; $t)).success
							
						End for each 
						
					Else 
						
						$Obj_out.success:=structure(New object:C1471(\
							"action"; "addStamp"; \
							"tableName"; $Obj_in.tableName)).success
						
					End if 
				End if 
				
				//…………………………………………………………………………………………………………………
			Else 
				
				ASSERT:C1129(False:C215; "Unknown entry point: \""+$Obj_in.action+"\"")
				
				//______________________________________________________
		End case 
		
		//______________________________________________________
	: ($Obj_in.action="addStamp")
		
		$Obj_out.success:=($Obj_in.tableName#Null:C1517)
		ASSERT:C1129($Obj_out.success; "Missing tableName")
		
		If ($Obj_out.success)
			
			$Txt_onErrCall:=Method called on error:C704
			
/* START TRAPPING ERRORS */$errors:=err.capture()
			
			$t:=String:C10($Obj_in.tableName)
			
			DOCUMENT:="ALTER TABLE ["+$t+"] ADD TRAILING "+String:C10(SHARED.stampField.name)+" "+String:C10(SHARED.stampField.type)+";"
			
			$errors.reset()
			
			Begin SQL
				
				EXECUTE IMMEDIATE :DOCUMENT
				
			End SQL
			
			If ($errors.lastError.stack#Null:C1517)
				
				If ($errors.lastError.stack[0].code=1053)
					
					// Field name already exists
					
				Else 
					
					ob_createPath($Obj_out; "errors"; Is collection:K8:32).errors.push($errors.lastError.stack[0].error+" ("+$t+")")
					
				End if 
			End if 
			
			If (Bool:C1537(SHARED.stampField.indexed))
				
				DOCUMENT:="CREATE INDEX "+String:C10(SHARED.stampField.name)+"_"+str($t).lowerCamelCase()+" ON ["+$t+"] ("+String:C10(SHARED.stampField.name)+");"
				
			End if 
			
			$errors.reset()
			
			Begin SQL
				
				EXECUTE IMMEDIATE :DOCUMENT
				
			End SQL
			
			If ($errors.lastError.stack#Null:C1517)
				
				If ($errors.lastError.stack[0].code=1155)
					
					// Index already exists
					
				Else 
					
					ob_createPath($Obj_out; "errors"; Is collection:K8:32).errors.push($errors.lastError.stack[0].error+" ("+$t+")")
					
				End if 
			End if 
			
			$Obj_out.success:=($Obj_out.errors=Null:C1517)
			
/* STOP TRAPPING ERRORS */$errors.release()
			
		End if 
		
		//________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$Obj_in.action+"\"")
		
		//________________________________________
End case 

// ----------------------------------------------------
// Return
If (Bool:C1537($Obj_in.caller))
	
	CALL FORM:C1391($Obj_in.caller; "editor_CALLBACK"; "structureCheckingResult"; $Obj_out)
	
Else 
	
	$0:=$Obj_out
	
End if 

// ----------------------------------------------------
// End