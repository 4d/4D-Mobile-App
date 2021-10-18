//%attributes = {"invisible":true,"preemptive":"capable"}
// Manager model with some possible "action"
// - tableCollection &amp; fieldCollection: to transform object models to collection
// - tableNames &amp; fieldNames: get only names
// - pictureFields: fieldNames but for only picture?
// - fields: flatten fields on key path
#DECLARE($Obj_in : Object)->$Obj_out : Object

// ----------------------------------------------------
// Declarations
var $Boo_4dType; $Boo_found : Boolean
var $Lon_attributs; $Lon_field; $Lon_field2; $Lon_fieldID; $Lon_parameters; $Lon_relatedTableID : Integer
var $Lon_relationField; $Lon_table; $Lon_table2; $Lon_tableID; $Lon_type : Integer
var $Ptr_field : Pointer
var $Dom_attribute; $Dom_elements; $Dom_entity; $Dom_model; $Dom_node; $Dom_userInfo : Text
var $File_; $t; $tt; $Txt_buffer; $Txt_field; $Txt_fieldName : Text
var $Txt_fieldNumber; $Txt_inverseName; $Txt_relationName; $Txt_tableName; $Txt_tableNumber; $Txt_value : Text
var $o; $Obj_buffer; $Obj_dataModel; $Obj_field; $Obj_in : Object
var $Obj_out; $Obj_path; $Obj_relationTable; $Obj_table : Object
var $relatedField : Variant
var $Col_fields; $Col_tables; $actions : Collection

ARRAY TEXT:C222($tTxt_fields; 0)
ARRAY TEXT:C222($tTxt_relationFields; 0)
ARRAY TEXT:C222($tTxt_tables; 0)

If (False:C215)
	C_OBJECT:C1216(dataModel; $0)
	C_OBJECT:C1216(dataModel; $1)
End if 

// ----------------------------------------------------
// Initialisations

$Obj_out:=New object:C1471(\
"success"; False:C215)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Obj_in.action=Null:C1517)  // Missing parameter
		
		ASSERT:C1129(False:C215; "Missing parameter \"action\"")
		
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
					OB GET PROPERTY NAMES:C1232($Obj_dataModel; $tTxt_tables)
					$Col_tables:=New collection:C1472()
					ARRAY TO COLLECTION:C1563($Col_tables; $tTxt_tables)
					
				End if 
				
				$Obj_out.tables:=New collection:C1472
				
				For each ($Txt_tableNumber; $Col_tables)
					
					If ($Obj_dataModel[$Txt_tableNumber]#Null:C1517)
						
						$Obj_table:=OB Copy:C1225($Obj_dataModel[$Txt_tableNumber])
						
						$Obj_table.tableNumber:=Num:C11($Txt_tableNumber)
						
						If (Bool:C1537($Obj_in.tag))  // for tag format name
							
							$Obj_table.originalName:=$Obj_table[""].name
							$Obj_table.name:=formatString("table-name"; $Obj_table[""].name)
							
						End if 
						
						$Obj_out.tables.push($Obj_table)
						
					Else 
						
						// ASSERT(dev_Matrix )
						
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
			
			For each ($Txt_field; $Obj_in.table)
				
				Case of 
						
						//………………………………………………………………………………………………………………………
					: (Match regex:C1019("(?m-si)^\\d+$"; $Txt_field; 1; *))
						
						$Obj_out.fields.push(New object:C1471(\
							"name"; $Obj_in.table[$Txt_field].name; \
							"id"; $Txt_field))  // TODO field.id change to fieldNumber
						
						//………………………………………………………………………………………………………………………
					: ((Value type:C1509($Obj_in.table[$Txt_field])=Is object:K8:27))
						
						If (Bool:C1537($Obj_in.relation))
							
							If ($Obj_in.table[$Txt_field].relatedEntities#Null:C1517)  // To change if relatedEntities deleted and relatedDataClass already filled #109019
								
								// redmine #110927 : want to add relation 1-N if no field specified at all by user
								// Here we detect 1-N Relation, there is no "kind" or "type" to see it at this level...
								
								If ($Obj_in.dataModel[String:C10($Obj_in.table[$Txt_field].relatedTableNumber)]#Null:C1517)  // only if destination table published
									
									$Obj_out.fields.push(New object:C1471(\
										"name"; $Txt_field; \
										"relatedDataClass"; $Obj_in.table[$Txt_field].relatedEntities; \
										"relatedTableNumber"; $Obj_in.table[$Txt_field].relatedTableNumber; \
										"fieldType"; 8859; \
										"id"; 0))  // TODO field.id change to fieldNumber
									
								End if 
							End if 
						End if 
						
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
	: ($Obj_in.action="fieldNames")  // Get field names for dump with table (model format) - CALLERS : dump
		
		$Obj_out.success:=($Obj_in.table#Null:C1517)
		
		If ($Obj_out.success)
			
			$Obj_out.fields:=New collection:C1472()
			$Obj_out.expand:=New collection:C1472()
			
			For each ($Txt_field; $Obj_in.table)
				
				Case of 
						
						//………………………………………………………………………………………………………………………
					: (Length:C16($Txt_field)=0)
						
						// <NOTHING MORE TO DO>
						
						//………………………………………………………………………………………………………………………
					: (Match regex:C1019("(?m-si)^\\d+$"; $Txt_field; 1; *))
						
						$Obj_out.fields.push($Obj_in.table[$Txt_field].name)
						
						//………………………………………………………………………………………………………………………
					: ((Value type:C1509($Obj_in.table[$Txt_field])=Is object:K8:27))
						
						$Obj_buffer:=$Obj_in.table[$Txt_field]
						
						If (PROJECT.isComputedAttribute($Obj_buffer))
							
							$Obj_out.fields.push($Txt_field)
							
						Else 
							If ($Obj_buffer.relatedEntities#Null:C1517)  // To remove if relatedEntities deleted and relatedDataClass already filled #109019
								
								$Obj_buffer.relatedDataClass:=$Obj_buffer.relatedEntities
								
							End if 
							
							If ($Obj_buffer.relatedDataClass#Null:C1517)  // Is is a link?
								
								If ($Obj_out.expand.indexOf($Txt_field)<0)
									
									$Obj_out.expand.push($Txt_field)
									
								End if 
								
								For each ($Txt_fieldNumber; $Obj_buffer)
									
									Case of 
										: (Match regex:C1019("(?m-si)^\\d+$"; $Txt_fieldNumber; 1; *))  // fieldNumber
											
											$Obj_out.fields.push($Txt_field+"."+$Obj_buffer[$Txt_fieldNumber].name)
											
										: (Value type:C1509($Obj_buffer[$Txt_fieldNumber])=Is object:K8:27)
											
											If (PROJECT.isComputedAttribute($Obj_buffer[$Txt_fieldNumber]))
												
												$Obj_out.fields.push($Txt_field+"."+$Obj_buffer[$Txt_fieldNumber].name)
												
											End if 
											
										Else 
											
											// Ignore (primary key, etc...)
											
									End case 
								End for each 
								
								// Else  Ignore
								
							End if 
						End if 
						
						//………………………………………………………………………………………………………………………
					Else 
						
						// Ignore
						
						//………………………………………………………………………………………………………………………
				End case 
			End for each 
			
			// Add primary key if needed for expanded data
			For each ($Txt_field; $Obj_out.expand)
				
				$Obj_buffer:=_o_structure(New object:C1471(\
					"action"; "tableInfo"; \
					"name"; String:C10($Obj_in.table[$Txt_field].relatedDataClass)))
				
				If ($Obj_buffer.success)
					
					$Txt_buffer:=$Txt_field+"."+$Obj_buffer.tableInfo.primaryKey
					
					If ($Obj_out.fields.indexOf($Txt_buffer)<0)
						
						$Obj_out.fields.push($Txt_buffer)
						
					End if 
					
				Else 
					
					ob_warning_add($Obj_out; "Cannot get information for related table "+String:C10($Obj_in.table[$Txt_field].relatedDataClass)+"(related by "+$Txt_field+" in "+$Obj_in.table+")")
					
				End if 
			End for each 
			
			$o:=$Obj_in.table[""]
			
			// Append the primaryKey if any
			If ((Length:C16(String:C10($o.primaryKey))>0) & \
				($Obj_out.fields.indexOf(String:C10($o.primaryKey))<0))
				
				$Obj_out.fields.push($o.primaryKey)
				
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
			
			For each ($Txt_field; $Obj_buffer)
				
				Case of 
						
						//………………………………………………………………………………………………………………………
					: (Match regex:C1019("(?m-si)^\\d+$"; $Txt_field; 1; *))
						
						If ($Obj_buffer[$Txt_field].fieldType=Is picture:K8:10)
							
							$Obj_out.fields.push($Obj_buffer[$Txt_field])
							
						End if 
						
						//………………………………………………………………………………………………………………………
					: (Value type:C1509($Obj_buffer[$Txt_field])#Is object:K8:27)
						
						//………………………………………………………………………………………………………………………
					: ($Obj_buffer[$Txt_field].relatedDataClass#Null:C1517)  // Is is a link?
						
						For each ($Txt_fieldNumber; $Obj_buffer[$Txt_field])
							
							If (Match regex:C1019("(?m-si)^\\d+$"; $Txt_fieldNumber; 1; *))  // fieldNumber
								
								If ($Obj_buffer[$Txt_field][$Txt_fieldNumber].fieldType=Is picture:K8:10)  // if image
									
									$Obj_field:=OB Copy:C1225($Obj_buffer[$Txt_field][$Txt_fieldNumber])
									$Obj_field.relatedDataClass:=$Obj_buffer[$Txt_field].relatedDataClass  // copy it only if wanted to index picture on this table
									$Obj_field.relatedField:=$Txt_field
									$Obj_out.fields.push($Obj_field)
									
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
				
				For each ($Txt_value; $Obj_dataModel[$Obj_in.tableNumber])
					
					Case of 
							
							//……………………………………………………………………………………………………………
						: (PROJECT.isField($Txt_value))  // fieldNumber
							
							$Obj_field:=OB Copy:C1225($Obj_dataModel[$Obj_in.tableNumber][$Txt_value])
							$Obj_field.path:=$Obj_field.name
							$Obj_field.id:=Num:C11($Txt_value)
							$Obj_out.fields.push($Obj_field)
							
							//……………………………………………………………………………………………………………
						: (Value type:C1509($Obj_dataModel[$Obj_in.tableNumber][$Txt_value])#Is object:K8:27)
							
							//……………………………………………………………………………………………………………
						: (PROJECT.isRelationToOne($Obj_dataModel[$Obj_in.tableNumber][$Txt_value]))  // relatedDataClass
							
							For each ($t; $Obj_dataModel[$Obj_in.tableNumber][$Txt_value])
								
								If (Match regex:C1019("(?m-si)^\\d+$"; $t; 1; *))  // fieldNumber
									
									$Obj_field:=OB Copy:C1225($Obj_dataModel[$Obj_in.tableNumber][$Txt_value][$t])
									$Obj_field.path:=$Txt_value+"."+$Obj_field.name
									$Obj_field.id:=Num:C11($t)
									$Obj_out.fields.push($Obj_field)
									
								End if 
							End for each 
							
							//……………………………………………………………………………………………………………
						: (PROJECT.isRelationToMany($Obj_dataModel[$Obj_in.tableNumber][$Txt_value]))  // relatedEntities
							
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
			
			For each ($t; $Obj_dataModel)
				
				$Obj_out.values.push($Obj_dataModel[$t][""].name)
				
				If (Bool:C1537($Obj_in.relation))
					
					For each ($tt; $Obj_dataModel[$t])
						
						If (Value type:C1509($Obj_dataModel[$t][$tt])=Is object:K8:27)
							
							If ($Obj_dataModel[$t][$tt].relatedDataClass#Null:C1517)
								
								$Obj_out.values.push($Obj_dataModel[$t][$tt].relatedDataClass)
								
							End if 
						End if 
					End for each 
				End if 
			End for each 
			
		Else 
			
			ASSERT:C1129(dev_Matrix; "No data model")  //#ERROR
			
		End if 
		
		//________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$Obj_in.action+"\"")
		
		//________________________________________
End case 

// ----------------------------------------------------
// End