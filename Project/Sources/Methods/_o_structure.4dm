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
#DECLARE($IN : Object)->$OUT : Object

If (False:C215)
	C_OBJECT:C1216(_o_structure; $0)
	C_OBJECT:C1216(_o_structure; $1)
End if 

var $fieldName; $onErrCall; $root; $t; $tableName; $xml : Text
var $found; $oneTable : Boolean
var $indx; $l; $tableNumber : Integer
var $datastore; $errors; $field; $IN; $o; $Obj_buffer; $OUT; $relatedDataClass; $table : Object
var $c; $catalog; $fields; $filtered : Collection

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	$OUT:=New object:C1471(\
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
	: ($IN.action=Null:C1517)
		
		ASSERT:C1129(False:C215)
		
		// MARK:- catalog
	: ($IN.action="catalog")  // Return the exposed datastore
		
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
		
		var $allowedTypes : Collection
		$allowedTypes:=New collection:C1472("string"; "bool"; "date"; "number"; "image")
		
		If (FEATURE.with("objectFieldManagement"))
			
			$allowedTypes.push("object")
			
		End if 
		
		$datastore:=_4D_Build Exposed Datastore:C1598
		
		$OUT.success:=($datastore#Null:C1517)
		
		If ($OUT.success)
			
			$OUT.value:=New collection:C1472
			
			$oneTable:=($IN.name#Null:C1517) | ($IN.tableNumber#Null:C1517)
			
			For each ($tableName; $datastore) Until ($found)
				
				$table:=$datastore[$tableName].getInfo()
				
				If ($tableName=SHARED.deletedRecordsTable.name)
					
					// DON'T DISPLAY DELETED RECORDS TABLE
					continue
					
				End if 
				
				If ($oneTable)
					
					$found:=($IN.name#Null:C1517) ? ($tableName=$IN.name) : ($table.tableNumber=$IN.tableNumber)
					
					$OUT.success:=$found
					
				End if 
				
				If ($OUT.success)
					
					If (Not:C34($oneTable)) | $found
						
						$OUT.value.push($table)
						
						$table.field:=New collection:C1472
						
						For each ($fieldName; $datastore[$tableName])
							
							If ($fieldName=SHARED.stampField.name)\
								 || (Position:C15("."; $fieldName)>0)
								
/*
DON'T DISPLAY STAMP FIELD
DON'T ALLOW FIELD OR RELATION NAME WITH DOT !
*/
								
								continue
								
							End if 
							
							$field:=$datastore[$tableName][$fieldName]
							
							var $inquiry : Object
							$inquiry:=$table.field.query("name = :1"; $fieldName).pop()
							
							Case of 
									
									//…………………………………………………………………………………………………
								: (($inquiry#Null:C1517) && str_equal($inquiry.name; $fieldName))
									
									// NOT ALLOW DUPLICATE NAMES !
									err_PUSH($OUT; "Name conflict for \""+$fieldName+"\""; Warning message:K38:2)
									
									//…………………………………………………………………………………………………
								: ($field.kind="storage")
									
									// Storage (or scalar) attribute, i.e. attribute storing a value, not a reference to another attribute
									If ($allowedTypes.indexOf($field.type)>=0)
										
										// #TEMPO [
										$field.id:=$field.fieldNumber
										$field.valueType:=$field.type
										$field.type:=_o_tempoFieldType($field.fieldType)
										// ]
										
										$table.field.push($field)
										
									End if 
									
									//…………………………………………………………………………………………………
								: ($field.kind="relatedEntity")
									
									// N -> 1 relation attribute (reference to an entity)
									
									If ($datastore[$field.relatedDataClass]#Null:C1517)
										
										$table.field.push(New object:C1471(\
											"name"; $fieldName; \
											"inverseName"; $field.inverseName; \
											"type"; -1; \
											"relatedDataClass"; $field.relatedDataClass; \
											"relatedTableNumber"; $datastore[$field.relatedDataClass].getInfo().tableNumber))
										
									End if 
									
									//…………………………………………………………………………………………………
								: ($field.kind="relatedEntities")
									
									// 1 -> N relation attribute (reference to an entity selection)
									
									$table.field.push(New object:C1471(\
										"name"; $fieldName; \
										"inverseName"; $field.inverseName; \
										"type"; -2; \
										"relatedDataClass"; $field.relatedDataClass; \
										"relatedTableNumber"; $datastore[$field.relatedDataClass].getInfo().tableNumber; \
										"isToMany"; True:C214))
									
									//…………………………………………………………………………………………………
								: (Not:C34(Bool:C1537($field.exposed)))
									
									// <IGNORE NOT EXPOSED ATTRIBUTES>
									
									//…………………………………………………………………………………………………
								: ($field.kind="calculated")
									
									If ($allowedTypes.indexOf($field.type)>=0)
										
										$field.valueType:=$field.type
										$field.type:=-3
										$field.computed:=True:C214
										$table.field.push($field)
										
									End if 
									
									//…………………………………………………………………………………………………
								: (Not:C34(FEATURE.with("alias")))
									
									// <NOT YET AVAILABLE>
									
									//…………………………………………………………………………………………………
								: ($field.kind="alias")
									
									Case of 
											
											//______________________________________
										: ($allowedTypes.indexOf($field.type)>=0)  // Attribute
											
											If ($allowedTypes.indexOf($field.type)>=0)
												
												$table.field.push($field)
												
											End if 
											
											//______________________________________
										: ($field.relatedDataClass#Null:C1517)  // Selection
											
											$table.field.push($field)
											
											//______________________________________
										Else 
											
											ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
											
											//______________________________________
									End case 
									
									//…………………………………………………………………………………………………
								Else 
									
									ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
									
									//…………………………………………………………………………………………………
							End case 
						End for each 
						
						If (Bool:C1537($IN.sorted))
							
							$table.field:=$table.field.orderBy("name asc")
							
						End if 
					End if 
				End if 
			End for each 
			
			If ($OUT.success)
				
				If (Bool:C1537($IN.sorted))
					
					$OUT.value:=$OUT.value.orderBy("name asc")
					
				End if 
				
			Else 
				
				OB REMOVE:C1226($OUT; "value")
				
				If ($oneTable)
					
					err_PUSH($OUT; "Table not found: "+Choose:C955($IN.name#Null:C1517; $IN.name; "#"+String:C10($IN.tableNumber)))
					
				End if 
			End if 
		End if 
		
		// MARK:- fieldDefinition
	: ($IN.action="fieldDefinition")  // Returns the field definition from the starting table number and its path
		
		ASSERT:C1129($IN.tableNumber#Null:C1517)
		ASSERT:C1129($IN.path#Null:C1517)
		
		If ($IN.catalog=Null:C1517)
			
			// Get the catalog
			$catalog:=_o_structure(New object:C1471(\
				"action"; "catalog")).value
			
		Else 
			
			$catalog:=$IN.catalog
			
		End if 
		
		$tableNumber:=$IN.tableNumber
		
		$c:=Split string:C1554($IN.path; ".")
		
		If ($c.length=1)
			
			$table:=$catalog.query("tableNumber = :1"; $tableNumber).pop()
			
			If ($table#Null:C1517)
				
				$field:=$table.field.query("name = :1"; $IN.path).pop()
				
				If ($field#Null:C1517)
					
					$OUT.success:=True:C214
					
					$OUT.path:=$IN.path
					$OUT.tableNumber:=$tableNumber
					$OUT.tableName:=Table name:C256($tableNumber)
					
					Case of 
							
							//______________________________________________________
						: ($field.type=-2)  // 1 to N relation
							
							$OUT.fieldType:=8859
							$OUT.type:=-2
							$OUT.relatedDataClass:=$field.relatedDataClass
							$OUT.relatedTableNumber:=$field.relatedTableNumber
							
							//______________________________________________________
						: ($field.type=-1)  // N to 1 relation
							
							$OUT.fieldType:=8858
							$OUT.type:=-1
							$OUT.relatedDataClass:=$field.relatedDataClass
							$OUT.relatedTableNumber:=$field.relatedTableNumber
							
							//______________________________________________________
						Else 
							
							$OUT.fieldNumber:=$field.fieldNumber
							$OUT.fieldType:=$field.fieldType
							$OUT.name:=Field name:C257($tableNumber; $field.fieldNumber)
							$OUT.type:=_o_tempoFieldType($field.fieldType)
							
							//______________________________________________________
					End case 
					
				Else 
					
					err_PUSH($OUT; "Field not found")
					
				End if 
				
			Else 
				
				err_PUSH($OUT; "Table not found #"+String:C10($tableNumber))
				
			End if 
			
		Else 
			
			$indx:=$catalog.extract("tableNumber").indexOf($tableNumber)
			
			If ($indx#-1)
				
				$fields:=$catalog[$indx].field
				
				$indx:=$fields.extract("name").indexOf($c[0])
				
				If ($indx#-1)
					
					$tableNumber:=$fields[$indx].relatedTableNumber
					
					If ($c.length>2)
						
						$field:=_o_structure(New object:C1471(\
							"action"; "fieldDefinition"; \
							"path"; $c.copy().remove(0).join("."); \
							"tableNumber"; $tableNumber; \
							"catalog"; $catalog))
						
						$OUT:=$field
						
						$OUT.path:=$IN.path
						
					Else 
						
						$indx:=$catalog.extract("tableNumber").indexOf($tableNumber)
						
						If ($indx#-1)
							
							$fields:=$catalog[$indx].field
							
							$indx:=$fields.extract("name").indexOf($c[1])
							
							If ($indx#-1)
								
								$OUT.success:=True:C214
								$field:=$fields[$indx]
								
								$OUT.path:=$IN.path
								$OUT.tableName:=Table name:C256($tableNumber)
								$OUT.tableNumber:=$tableNumber
								$OUT.fieldNumber:=$field.fieldNumber
								$OUT.name:=Field name:C257($tableNumber; $field.fieldNumber)
								$OUT.fieldType:=$field.fieldType
								
								// #TEMPO [
								$OUT.valueType:=$field.type
								$OUT.type:=_o_tempoFieldType($field.fieldType)
								//]
								
							Else 
								
								err_PUSH($OUT; "Related field not found")
								
							End if 
							
						Else 
							
							err_PUSH($OUT; "Related table not found")
							
						End if 
					End if 
					
				Else 
					
					err_PUSH($OUT; "Field not found")
					
				End if 
				
			Else 
				
				err_PUSH($OUT; "Table not found")
				
			End if 
		End if 
		
		// MARK:- relatedCatalog
	: ($IN.action="relatedCatalog")  // Return related entity catalog
		
		ASSERT:C1129($IN.table#Null:C1517)
		ASSERT:C1129($IN.relatedEntity#Null:C1517)
		
		$datastore:=_4D_Build Exposed Datastore:C1598
		
		$field:=$datastore[$IN.table][$IN.relatedEntity]
		
		Case of 
				
				//…………………………………………………………………………………………………
			: ($field=Null:C1517)
				
				// <NOTHING MORE TO DO>
				
				//…………………………………………………………………………………………………
			: ($field.kind="relatedEntity")  // N -> 1 relation
				
				$OUT.success:=True:C214
				$OUT.fields:=New collection:C1472
				$OUT.relatedEntity:=$field.name
				$OUT.relatedTableNumber:=$datastore[$field.relatedDataClass].getInfo().tableNumber
				$OUT.relatedDataClass:=$field.relatedDataClass
				$OUT.inverseName:=$field.inverseName
				
				$relatedDataClass:=$datastore[$field.relatedDataClass]
				
				For each ($fieldName; $relatedDataClass)
					
					$o:=$relatedDataClass[$fieldName]
					
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
								
								$o.type:=_o_tempoFieldType($o.fieldType)
								
								$o.relatedTableNumber:=$OUT.relatedTableNumber
								
								$OUT.fields.push($o)
								
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
			: ($field.kind="relatedEntities")  // 1 -> N relation
				
				//…………………………………………………………………………………………………
			Else 
				
				// <NOTHING MORE TO DO>
				
				//…………………………………………………………………………………………………
		End case 
		
		// MARK:- inverseRelatedFields
	: ($IN.action="inverseRelatedFields")  // on related data class, get related fields linked to current table CALLER: [dataModel]
		
		Case of 
				
				//…………………………………………………………………………………………………
			: (($IN.table=Null:C1517)\
				 | ($IN.relation=Null:C1517))
				
				ob_error_add($OUT; "table ore relation name must be defined")
				
				//…………………………………………………………………………………………………
			Else 
				
				$datastore:=_4D_Build Exposed Datastore:C1598
				$table:=$datastore[String:C10($IN.table)]
				
				If ($table#Null:C1517)
					
					$field:=$table[$IN.relation]
					
					If ($field#Null:C1517)
						
						$OUT.fields:=New collection:C1472
						
						// Get inverse name
						If (Length:C16(String:C10($field.inverseName))>0)
							$Obj_buffer:=New object:C1471("value"; $field.inverseName; "success"; True:C214)
						Else   // OBSOLETE normally
							$Obj_buffer:=_o_structure(New object:C1471(\
								"action"; "inverseRelationName"; \
								"table"; $IN.table; \
								"relation"; $IN.relation; \
								"definition"; $IN.definition))
						End if 
						
						If ($Obj_buffer.success)
							
							$OUT.definition:=$Obj_buffer.definition  // cache purpose // OBSOLETE normally
							
							// Get inverse table
							$relatedDataClass:=$datastore[$field.relatedDataClass]
							
							$o:=$relatedDataClass[$Obj_buffer.value]
							$OUT.success:=($o#Null:C1517)
							If ($OUT.success)
								
								$o.relatedTableNumber:=$table.getInfo().tableNumber
								$OUT.fields.push($o)
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
		
		// MARK:- inverseRelationName
	: ($IN.action="inverseRelationName")  //  [OBSOLETE]
		
		Case of 
				
				//…………………………………………………………………………………………………
			: (($IN.table=Null:C1517)\
				 | ($IN.relation=Null:C1517))
				
				ob_error_add($OUT; "table ore relation name must be defined")
				
				//…………………………………………………………………………………………………
			Else 
				
				// Until DS provide information about relation, use xml. redmine #103848
				
				$OUT:=Choose:C955(Value type:C1509($IN.definition)=Is object:K8:27; New object:C1471(\
					"success"; True:C214; \
					"value"; $IN.definition); \
					_o_structure(New object:C1471(\
					"action"; "definition")))
				
				If ($OUT.success)
					
					$OUT.definition:=$OUT.value
					$OUT.value:=Null:C1517
					
					If (Value type:C1509($OUT.definition.relation)=Is object:K8:27)
						
						$OUT.definition.relation:=New collection:C1472($OUT.definition.relation)
						
					End if 
					
					If (Value type:C1509($OUT.definition.relation)=Is collection:K8:32)
						
						For each ($Obj_buffer; $OUT.definition.relation) Until ($OUT.value#Null:C1517)
							
							Case of 
									
									//………………………………………………………………………………………………………………………
								: ($Obj_buffer["name_1toN"]=$IN.relation)
									
									For each ($field; $Obj_buffer.related_field)
										
										If ($field.kind="destination")
											
											If ($field.field_ref.table_ref.name=$IN.table)
												
												$OUT.value:=$Obj_buffer["name_Nto1"]
												
											End if 
										End if 
									End for each 
									
									//………………………………………………………………………………………………………………………
								: ($Obj_buffer["name_Nto1"]=$IN.relation)
									
									For each ($field; $Obj_buffer.related_field)
										
										If ($field.kind="source")
											
											If ($field.field_ref.table_ref.name=$IN.table)
												
												$OUT.value:=$Obj_buffer["name_1toN"]
												
											End if 
										End if 
									End for each 
									
									//………………………………………………………………………………………………………………………
							End case 
						End for each 
					End if 
					
					$OUT.success:=($OUT.value#Null:C1517)
					
				End if 
				
				//________________________________________
		End case 
		
		// MARK:- createField
	: ($IN.action="createField")  // CALLER: [dataModel] (add missing primary key field)
		
		$datastore:=_4D_Build Exposed Datastore:C1598
		$table:=$datastore[String:C10($IN.table)]
		
		If ($table#Null:C1517)
			
			$field:=$table[$IN.field]
			
			If ($field#Null:C1517)
				
				$OUT.success:=True:C214
				
				// Format as other fields
				
				//#REMINDER: Change id -> fieldNumber
				$OUT.value:=New object:C1471(\
					"id"; $field.fieldNumber; \
					"name"; $field.name; \
					"label"; formatString("label"; $field.name); \
					"shortLabel"; formatString("label"; $field.name); \
					"fieldType"; $field.fieldType)
				
			End if 
		End if 
		
		// MARK:- hasField
	: ($IN.action="hasField")  // Check that table contains a field CALLER: [dataModel]
		
		Case of 
				
				//…………………………………………………………………………………………………
			: (($IN.table=Null:C1517)\
				 | ($IN.field=Null:C1517))
				
				ob_error_add($OUT; "table and field name must be defined")
				
				//…………………………………………………………………………………………………
			Else 
				
				$datastore:=_4D_Build Exposed Datastore:C1598
				$table:=$datastore[String:C10($IN.table)]
				
				If ($table#Null:C1517)
					
					$field:=$table[$IN.field]
					
					$OUT.value:=$field#Null:C1517
					$OUT.success:=True:C214
					
				Else 
					
					ob_error_add($OUT; "table "+String:C10($IN.table)+" not found")
					$OUT.value:=False:C215
					$OUT.success:=False:C215
					
				End if 
				
				// ----------------------------------------
		End case 
		
		// MARK:- tableInfo
	: ($IN.action="tableInfo")  // Return table.getInfo() from table name CALLER: [dataModel]
		
		If (Asserted:C1132($IN.name#Null:C1517; "missing 'name' key"))
			
			$datastore:=_4D_Build Exposed Datastore:C1598
			
			$OUT.success:=($datastore[$IN.name]#Null:C1517)
			
			If ($OUT.success)
				
				$OUT.tableInfo:=$datastore[$IN.name].getInfo()
				
			End if 
		End if 
		
		// MARK:- tableNumber
	: ($IN.action="tableNumber")  // Return table number from table name
		
		If (Asserted:C1132($IN.name#Null:C1517; "missing 'name' key"))
			
			$datastore:=_4D_Build Exposed Datastore:C1598
			
			$OUT.success:=($datastore[$IN.name]#Null:C1517)
			
			If ($OUT.success)
				
				$OUT.tableNumber:=$datastore[$IN.name].getInfo().tableNumber
				
			End if 
		End if 
		
		// MARK:- tmplType
	: ($IN.action="tmplType")  // Type mapping for svg templates [OBSOLETE]
		
		// TODO cache this collection (COMPONENT_INIT?)
		$c:=New collection:C1472
		$c[1]:=Is boolean:K8:9
		$c[3]:=Is integer:K8:5
		$c[4]:=Is longint:K8:6
		$c[5]:=Is integer 64 bits:K8:25
		$c[6]:=Is real:K8:4
		$c[7]:=_o_Is float:K8:26
		$c[8]:=Is date:K8:7
		$c[9]:=Is time:K8:8
		$c[10]:=Is text:K8:3
		$c[12]:=Is picture:K8:10
		$c[18]:=Is BLOB:K8:12
		$c[21]:=Is object:K8:27
		
		$OUT.value:=$c[$IN.value]
		
		$OUT.success:=$OUT.value#Null:C1517
		
		// MARK:- entityType
	: ($IN.action="entityType")  // Type mapping for enttity RECURSIVE - [OBSOLETE]
		
		$o:=New object:C1471
		$o["bool"]:=1
		$o["word"]:=3
		$o["long"]:=4
		$o["long64"]:=5
		$o["number"]:=6
		$o["string"]:=10
		$o["date"]:=8
		$o["duration"]:=9
		$o["image"]:=12
		$o["blob"]:=18
		$o["object"]:=21
		
		$OUT.value:=$o[String:C10($IN.value)]
		
		$OUT.success:=$OUT.value#Null:C1517
		
		// MARK:- tables
	: ($IN.action="tables")  //  [OBSOLETE]
		
		If (Bool:C1537(FEATURE._98145))  //#MARK_TODO - CHANGE "tables" entrypoint to "catalog"
			
			// CHECK ALL CALLERS AND UNIT TEST
			
			$Obj_buffer:=OB Copy:C1225($IN)
			
			OB REMOVE:C1226($IN; "caller")
			
			$IN.action:="catalog"
			
			$OUT:=_o_structure($IN)
			
			$IN:=$Obj_buffer
			
		Else 
			
			$OUT:=_o_structure(New object:C1471(\
				"action"; "definition"))
			
			If ($OUT.success)
				
				// Keep the tables definition only
				If ($OUT.value.table#Null:C1517)
					
					$OUT.value:=$OUT.value.table
					
				Else 
					
					// No table
					$OUT.value:=New collection:C1472
					$OUT.success:=False:C215
					
				End if 
			End if 
			
			If ($OUT.success)
				
				If (Bool:C1537($IN.inRest))
					
					// -----------------------------------
					// [REST] - Remove not exposed tables
					// -----------------------------------
					$filtered:=New collection:C1472
					
					If (Value type:C1509($OUT.value)=Is collection:K8:32)
						
						For each ($table; $OUT.value)
							
							If (Not:C34(Bool:C1537($table.hide_in_REST)))
								
								$filtered.push(_o_structure(New object:C1471(\
									"action"; "tableDefinition"; \
									"value"; $table)).value)
								
								// Remove incompatible and not exposed fields
								If (Value type:C1509($table.field)=Is collection:K8:32)
									
									For each ($field; $table.field)
										
										If (_o_rest_isValidField($field))
											
											// Cleanup the properties
											$field:=_o_structure(New object:C1471(\
												"action"; "fieldDefinition"; \
												"value"; $field)).value
											
										Else 
											
											// Mark the field to remove
											$field.hidden:=True:C214
											
										End if 
									End for each 
									
									// Remove marked fields
									For each ($l; $table.field.indices("hidden = :1"; True:C214).reverse())
										
										$table.field.remove($l)
										
									End for each 
									
								Else 
									
									// Only one field
									If (_o_rest_isValidField($table.field))
										
										$table.field:=_o_structure(New object:C1471(\
											"action"; "fieldDefinition"; \
											"value"; $table.field)).value
										
									Else 
										
										// Remove the field and so the table
										$filtered.pop()
										
									End if 
								End if 
							End if 
						End for each 
						
					Else 
						
						// Only one table
						$table:=$OUT.value
						
						If (Not:C34(Bool:C1537($table.hide_in_REST)))
							
							$table:=_o_structure(New object:C1471(\
								"action"; "tableDefinition"; \
								"value"; $table)).value
							
							$filtered.push($table)
							
							// Remove incompatible and not exposed fields, if any
							If (Value type:C1509($table.field)=Is collection:K8:32)
								
								For each ($field; $table.field)
									
									If (_o_rest_isValidField($field))
										
										// Cleanup the properties
										$field:=_o_structure(New object:C1471(\
											"action"; "fieldDefinition"; \
											"value"; $field)).value
										
									Else 
										
										// Mark the field to remove
										$field.hidden:=True:C214
										
									End if 
								End for each 
								
								// Remove marked fields
								For each ($l; $table.field.indices("hidden = :1"; True:C214).reverse())
									
									$table.field.remove($l)
									
								End for each 
								
							Else 
								
								// Only one field
								If (_o_rest_isValidField($table.field))
									
									// Remove unnecessary informations
									$table.field:=_o_structure(New object:C1471(\
										"action"; "fieldDefinition"; \
										"value"; $table.field)).value
									
								Else 
									
									// Remove the field and so the table
									$filtered:=New collection:C1472
									
								End if 
							End if 
						End if 
					End if 
					
					$OUT.value:=$filtered
					
				End if 
			End if 
		End if 
		
		// MARK:- definition
	: ($IN.action="definition")  // A GARDER POUR LE MOMENT
		
		EXPORT STRUCTURE:C1311($xml)
		
/* START HIDING ERRORS */$errors:=_o_err.hide()
		$root:=DOM Parse XML variable:C720($xml)
		
		If (OK=1)
			
			$OUT:=New object:C1471(\
				"success"; True:C214; \
				"value"; _o_xml_refToObject($root))
			
			DOM CLOSE XML:C722($root)
			
			If ($OUT.success)
				
				$OUT.value:=$OUT.value.base
				
			End if 
		End if 
		
/* STOP HIDING ERRORS */$errors.show()
		
		//______________________________________________________
		//: (Not(Bool(featuresFlags._103411)))
		
		//ASSERT(False;"Not implemented: \""+$Obj_in.action+"\"")
		
		// MARK:- verify@
	: ($IN.action="verify@")
		
		Case of 
				
				//…………………………………………………………………………………………………………………
			: ($IN.action="verify")
				
				$datastore:=_4D_Build Exposed Datastore:C1598
				
				$OUT.success:=_o_structure(New object:C1471(\
					"action"; "verifyDeletedRecords"; \
					"catalog"; $datastore)).success
				
				If ($OUT.success)
					
					If (Value type:C1509($IN.tables)=Is collection:K8:32)
						
						For each ($t; $IN.tables) While ($OUT.success)
							
							$OUT.success:=_o_structure(New object:C1471(\
								"action"; "verifyStamps"; \
								"tableName"; $t; \
								"catalog"; $datastore)).success
							
						End for each 
						
					Else 
						
						$OUT.success:=_o_structure(New object:C1471(\
							"action"; "verifyStamps"; \
							"tableName"; $IN.tables; \
							"catalog"; $datastore)).success
						
					End if 
				End if 
				
				//…………………………………………………………………………………………………………………
			: ($IN.action="verifyDeletedRecords")
				
				If ($IN.catalog=Null:C1517)
					
					$IN.catalog:=_4D_Build Exposed Datastore:C1598
					
				End if 
				
				$OUT.success:=($IN.catalog[SHARED.deletedRecordsTable.name]#Null:C1517)
				
				//…………………………………………………………………………………………………………………
			: ($IN.action="verifyStamps")
				
				$OUT.success:=($IN.tableName#Null:C1517)
				ASSERT:C1129($OUT.success; "Missing tableName")
				
				If ($OUT.success)
					
					If ($IN.catalog=Null:C1517)
						
						$IN.catalog:=_4D_Build Exposed Datastore:C1598
						
					End if 
					
					$OUT.success:=($IN.catalog[$IN.tableName][SHARED.stampField.name]#Null:C1517)
					
				End if 
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Unknown entry point: \""+$IN.action+"\"")
				
				//______________________________________________________
		End case 
		
		// MARK:- create@
	: ($IN.action="create@")
		
		Case of 
				
				//…………………………………………………………………………………………………………………
			: ($IN.action="create")
				
				ASSERT:C1129($IN.tables#Null:C1517)
				
				$OUT.success:=_o_structure(New object:C1471(\
					"action"; "createDeletedRecords"; \
					"catalog"; _4D_Build Exposed Datastore:C1598)).success
				
				If ($OUT.success)
					
					For each ($t; $IN.tables) While ($OUT.success)
						
						$OUT.success:=_o_structure(New object:C1471(\
							"action"; "createStamps"; \
							"tableName"; $t)).success
						
					End for each 
				End if 
				
				//…………………………………………………………………………………………………………………
			: ($IN.action="createDeletedRecords")
				
				$onErrCall:=Method called on error:C704
				
/* START TRAPPING ERRORS */$errors:=_o_err.capture()
				
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
							
							ob_createPath($OUT; "errors"; Is collection:K8:32).errors.push($errors.lastError.stack[0].error+" ("+$t+")")
							
						End if 
					End if 
				End for each 
				
				$OUT.success:=($OUT.errors=Null:C1517)
				
/* STOP TRAPPING ERRORS */$errors.release()
				
				//…………………………………………………………………………………………………………………
			: ($IN.action="createStamps")
				
				$OUT.success:=($IN.tableName#Null:C1517)
				ASSERT:C1129($OUT.success; "Missing tableName")
				
				If ($OUT.success)
					
					If (Value type:C1509($IN.tableName)=Is collection:K8:32)
						
						$OUT.success:=True:C214
						
						For each ($t; $IN.tableName) While ($OUT.success)
							
							$OUT.success:=_o_structure(New object:C1471(\
								"action"; "addStamp"; \
								"tableName"; $t)).success
							
						End for each 
						
					Else 
						
						$OUT.success:=_o_structure(New object:C1471(\
							"action"; "addStamp"; \
							"tableName"; $IN.tableName)).success
						
					End if 
				End if 
				
				//…………………………………………………………………………………………………………………
			Else 
				
				ASSERT:C1129(False:C215; "Unknown entry point: \""+$IN.action+"\"")
				
				//______________________________________________________
		End case 
		
		// MARK:- addStamp
	: ($IN.action="addStamp")
		
		$OUT.success:=($IN.tableName#Null:C1517)
		ASSERT:C1129($OUT.success; "Missing tableName")
		
		If ($OUT.success)
			
			$onErrCall:=Method called on error:C704
			
/* START TRAPPING ERRORS */
			$errors:=_o_err.capture()
			
			$t:=String:C10($IN.tableName)
			
			DOCUMENT:="ALTER TABLE ["+$t+"] ADD TRAILING "+String:C10(SHARED.stampField.name)+" "+String:C10(SHARED.stampField.type)+";"
			
			$errors.reset()
			
			Begin SQL
				
				EXECUTE IMMEDIATE :DOCUMENT
				
			End SQL
			
			If ($errors.lastError.stack#Null:C1517)
				
				If ($errors.lastError.stack[0].code=1053)
					
					// Field name already exists
					
				Else 
					
					ob_createPath($OUT; "errors"; Is collection:K8:32).errors.push($errors.lastError.stack[0].error+" ("+$t+")")
					
				End if 
			End if 
			
			If (Bool:C1537(SHARED.stampField.indexed))
				
				DOCUMENT:="CREATE INDEX "+String:C10(SHARED.stampField.name)+"_"+cs:C1710.str.new($t).lowerCamelCase()+" ON ["+$t+"] ("+String:C10(SHARED.stampField.name)+");"
				
			End if 
			
			$errors.reset()
			
			Begin SQL
				
				EXECUTE IMMEDIATE :DOCUMENT
				
			End SQL
			
			If ($errors.lastError.stack#Null:C1517)
				
				If ($errors.lastError.stack[0].code=1155)
					
					// Index already exists
					
				Else 
					
					ob_createPath($OUT; "errors"; Is collection:K8:32).errors.push($errors.lastError.stack[0].error+" ("+$t+")")
					
				End if 
			End if 
			
			$OUT.success:=($OUT.errors=Null:C1517)
			
/* STOP TRAPPING ERRORS */
			$errors.release()
			
		End if 
		
		//________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$IN.action+"\"")
		
		//________________________________________
End case 

// ----------------------------------------------------
// Return
If (Bool:C1537($IN.caller))
	
	CALL FORM:C1391($IN.caller; "editor_CALLBACK"; "checkProject"; $OUT)
	
End if 