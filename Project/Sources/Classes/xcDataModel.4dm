Class constructor($project : Object)
	This:C1470.dataModel:=OB Copy:C1225($project.dataModel)
	This:C1470.actions:=$project.actions
	
Function run($path : Text; $options : Object)->$out : Object
	$out:=New object:C1471()
	If ($options.definition=Null:C1517)
		$options.definition:=New object:C1471  // cache
	End if 
	
	var $result; $table; $tableInfo : Object
	var $Txt_table : Text
	var $index : Integer
	var $Dom_model; $Dom_node; $Dom_elements : Text
	
	If (This:C1470.dataModel#Null:C1517)
		
		$Dom_model:=DOM Create XML Ref:C861("model")
		
		// Create XML document
		XML SET OPTIONS:C1090($Dom_model; XML indentation:K45:34; XML with indentation:K45:35)
		
		DOM SET XML ATTRIBUTE:C866($Dom_model; \
			"type"; "com.apple.IDECoreDataModeler.DataModel"; \
			"documentVersion"; "1.0"; \
			"lastSavedToolsVersion"; "14903"; \
			"systemVersion"; "18G87"; \
			"minimumToolsVersion"; "Automatic"; \
			"sourceLanguage"; "Swift"; \
			"userDefinedModelVersionIdentifier"; "")
		
		// Create elements nodes
		$Dom_elements:=DOM Create XML element:C865($Dom_model; "elements")
		
		$index:=0
		For each ($Txt_table; This:C1470.dataModel)
			$table:=This:C1470.dataModel[$Txt_table]
			$tableInfo:=$table[""]
			
			$Dom_node:=DOM Create XML element:C865($Dom_elements; "element"; \
				"name"; $Txt_tableName; \
				"positionX"; 200*$index; \
				"positionY"; 100; \
				"width"; 150; \
				"height"; 45+(15*OB Keys:C1719($table).length))
			
			$index:=$index+1
		End for each 
		
		If (Bool:C1537(FEATURE._234))
			
			// Parent abtract Record entity in model, with common private fields
			var $Txt_tableName : Text
			$Txt_tableName:="Record"
			
			ARRAY TEXT:C222($tTxt_entityAttributes; 4)
			$tTxt_entityAttributes{1}:="name"
			$tTxt_entityAttributes{2}:="representedClassName"
			$tTxt_entityAttributes{3}:="syncable"
			$tTxt_entityAttributes{4}:="codeGenerationType"
			
			ARRAY TEXT:C222($tTxt_entityValues; 4)
			$tTxt_entityValues{1}:=$Txt_tableName
			$tTxt_entityValues{2}:=$Txt_tableName
			$tTxt_entityValues{3}:="YES"
			$tTxt_entityValues{4}:="class"
			
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
		
		// Add missing relations
		If (Bool:C1537($options.relationship))
			
			$result:=This:C1470._relations($options)
			ob_error_combine($out; $result)
			
		End if 
		
		// Add missing primary keys
		$result:=This:C1470._primaryKeys()
		ob_error_combine($out; $result)
		
		// Create entities nodes
		For each ($Txt_table; This:C1470.dataModel)
			$table:=This:C1470.dataModel[$Txt_table]
			$result:=This:C1470.createEntity($options; $Dom_model; Num:C11($Txt_table); $table)
			ob_error_combine($out; $result)
		End for each 
		
		// Then write XML result to file
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
		
		$out.success:=Bool:C1537(OK)
		$out.path:=$File_
		
		DOM CLOSE XML:C722($Dom_model)  // Modify the system variable OK!
		
	Else 
		
		ASSERT:C1129(dev_Matrix; "No data model passed to xcDataModel")
		RECORD.warning("dataModel is null to generate xcDataModel (core data ios)")
		
	End if 
	
	// create Entity node
	// $Dom_model: parent node
	// $table table data
Function createEntity($options : Object; $Dom_model : Text; $Lon_tableID : Integer; $table : Object)->$out : Object
	var $result : Object  // result of external function call
	
	var $tableInfo : Object
	$tableInfo:=$table[""]
	
	var $Txt_tableName : Text
	$Txt_tableName:=formatString("table-name"; $tableInfo.name)
	
	ARRAY TEXT:C222($tTxt_entityAttributes; 4)
	$tTxt_entityAttributes{1}:="name"
	$tTxt_entityAttributes{2}:="representedClassName"
	$tTxt_entityAttributes{3}:="syncable"
	$tTxt_entityAttributes{4}:="codeGenerationType"
	
	ARRAY TEXT:C222($tTxt_entityValues; 4)
	$tTxt_entityValues{1}:=$Txt_tableName
	$tTxt_entityValues{2}:=$Txt_tableName
	$tTxt_entityValues{3}:="YES"
	$tTxt_entityValues{4}:="class"
	
	var $Dom_userInfo; $Dom_entity; $Dom_userInfo; $Dom_node; $Dom_attribute; $Dom_userInfo : Text
	$Dom_entity:=DOM Create XML element arrays:C1097($Dom_model; "entity"; $tTxt_entityAttributes; $tTxt_entityValues)
	
	If (Bool:C1537(FEATURE._234))
		
		DOM SET XML ATTRIBUTE:C866($Dom_entity; \
			"parentEntity"; "Record")
		
	End if 
	
	$Dom_userInfo:=DOM Create XML element:C865($Dom_entity; "userInfo")
	
	// If table name has been formatted for core data, add the key mapping key
	If (Not:C34(str_equal($Txt_tableName; $tableInfo.name)))
		
		$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
			"key"; "keyMapping"; \
			"value"; $tableInfo.name)
		
	End if 
	
	// If table must not be sync by it self, add info about it
	If (Length:C16(String:C10($tableInfo.slave))>0)
		
		// Only accessible via relations
		$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
			"key"; "slave"; \
			"value"; String:C10($tableInfo.slave))
		
	End if 
	
	// Has or not the global stamp fields
	$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
		"key"; "globalStamp"; \
		"value"; Choose:C955(Bool:C1537(_o_structure(New object:C1471(\
		"action"; "hasField"; \
		"table"; $tableInfo.name; \
		"field"; SHARED.stampField.name)).value); "YES"; "NO"))
	
	// Add primary key info and add fetch index
	If ($tableInfo.primaryKey#Null:C1517)
		
		$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
			"key"; "primaryKey"; \
			"value"; String:C10($tableInfo.primaryKey))
		
		If (Length:C16(String:C10($tableInfo.primaryKey))>0)
			
			var $Dom_fetchIndex; $Dom_fetchIndexElement : Text
			
			$Dom_fetchIndex:=DOM Create XML element:C865($Dom_entity; "fetchIndex"; "name"; "byPrimaryKey")
			$Dom_fetchIndexElement:=DOM Create XML element:C865($Dom_fetchIndex; "fetchIndexElement"; \
				"property"; formatString("field-name"; String:C10($tableInfo.primaryKey)); "type"; "binary"; "order"; "ascending")
			
			C_TEXT:C284($Dom_uniquenessConstraints; $Dom_uniquenessConstraint; $Dom_constraint)
			$Dom_uniquenessConstraints:=DOM Create XML element:C865($Dom_entity; "uniquenessConstraints")
			$Dom_uniquenessConstraint:=DOM Create XML element:C865($Dom_uniquenessConstraints; "uniquenessConstraint")
			$Dom_constraint:=DOM Create XML element:C865($Dom_uniquenessConstraint; "constraint"; "value"; formatString("field-name"; String:C10($tableInfo.primaryKey)))
			
		End if 
	End if 
	
	// Add fetch index for sort action too
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
	
	// Add information about data filter, only if validated
	If ($tableInfo.filter#Null:C1517)
		
		If (Bool:C1537($tableInfo.filter.validated))  // Is filter is validated?
			
			$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
				"key"; "filter"; \
				"value"; String:C10($tableInfo.filter.string))
			
		Else 
			
			ob_warning_add($out; "Filter '"+String:C10($tableInfo.filter.string)+"' of table '"+$Txt_tableName+"' not validated")
			RECORD.warning("Filter '"+String:C10($tableInfo.filter.string)+"' of table '"+$Txt_tableName+"' not validated")
			
		End if 
	End if 
	
	var $Txt_field; $Txt_originalFieldName; $Txt_fieldName : Text
	
	For each ($Txt_field; $table)
		
		Case of 
				
				//………………………………………………………………………………………………………………………
			: (Length:C16($Txt_field)=0)  // Properties
				
				// <NOTHING MORE TO DO>
				
				//………………………………………………………………………………………………………………………
			: (PROJECT.isField($Txt_field) | PROJECT.isComputedAttribute($table[$Txt_field]))
				
				var $Lon_type : Integer
				var $Boo_4dType : Boolean
				
				If (Value type:C1509($table[$Txt_field])=Is object:K8:27)
					
					$Txt_originalFieldName:=String:C10($table[$Txt_field].name)
					$Lon_type:=$table[$Txt_field].fieldType
					
				Else 
					
					var $Lon_fieldID : Integer
					ASSERT:C1129(dev_Matrix; "Please avoid to have missing info in dataModel and rely and Field, fiel name method")
					$Lon_fieldID:=Num:C11($Txt_field)
					var $Ptr_field : Pointer
					$Ptr_field:=Field:C253($Lon_tableID; $Lon_fieldID)
					$Txt_originalFieldName:=Field name:C257($Ptr_field)
					$Lon_type:=Type:C295($Ptr_field->)
					$Boo_4dType:=True:C214
					
				End if 
				
				If (Length:C16($Txt_originalFieldName)>0)
					
					$Txt_fieldName:=formatString("field-name"; $Txt_originalFieldName)
					
					$Dom_attribute:=DOM Create XML element:C865($Dom_entity; "attribute")  // XXX merge with next instruction
					
					DOM SET XML ATTRIBUTE:C866($Dom_attribute; \
						"name"; $Txt_fieldName; \
						"optional"; "YES"; \
						"indexed"; "NO"; \
						"syncable"; "YES")
					
					$Dom_userInfo:=DOM Create XML element:C865($Dom_attribute; "userInfo")
					
					If (Not:C34(str_equal($Txt_fieldName; $Txt_originalFieldName)))
						
						$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
							"key"; "keyMapping"; \
							"value"; $Txt_originalFieldName)
						
					End if 
					
					// add xml attribut for type
					This:C1470._field($Dom_attribute; $Dom_userInfo; $Lon_type)
					
				End if 
				
				//……………………………………………………………………………………………………………
			: (Value type:C1509($table[$Txt_field])#Is object:K8:27)
				
				// <NOTHING MORE TO DO>
				
				//………………………………………………………………………………………………………………………
			: (PROJECT.isRelation($table[$Txt_field]))
				
				var $Txt_relationName : Text
				$Txt_relationName:=$Txt_field
				
				If (Bool:C1537($options.relationship))  // core data relation ship table
					
					var $Txt_formattedRelationName; $Txt_inverseName : Text
					$Txt_formattedRelationName:=formatString("field-name"; $Txt_relationName)
					
					$Txt_inverseName:=String:C10($table[$Txt_relationName].inverseName)
					
					If (Length:C16($Txt_inverseName)=0)
						
						If (dev_Matrix)
							
							ASSERT:C1129(False:C215; "Missing inverseName")
							
						End if 
						
						$result:=_o_structure(New object:C1471(\
							"action"; "inverseRelationName"; \
							"table"; $table.name; \
							"definition"; $options.definition; \
							"relation"; $Txt_relationName))
						
						If ($result.success)
							
							$Txt_inverseName:=$result.value
							$options.definition:=$result.definition  // cache purpose
							$out.definition:=$result.definition
							
						End if 
					End if 
					
					// relation mode
					If (PROJECT.isRelationToMany($table[$Txt_relationName]))  // to N
						
						// we must have {type:TABLENAMESelection,relatedDataClass:TABLENAME}
						
						$Dom_attribute:=DOM Create XML element:C865($Dom_entity; "relationship"; \
							"name"; $Txt_formattedRelationName; \
							"destinationEntity"; formatString("table-name"; $table[$Txt_relationName].relatedDataClass); \
							"inverseEntity"; formatString("table-name"; $table[$Txt_relationName].relatedDataClass); \
							"inverseName"; formatString("field-name"; $Txt_inverseName); \
							"toMany"; "YES"; \
							"optional"; "YES"; \
							"syncable"; "YES"; \
							"deletionRule"; "Nullify")
						
					Else   // to 1
						
						$Dom_attribute:=DOM Create XML element:C865($Dom_entity; "relationship"; \
							"name"; $Txt_formattedRelationName; \
							"destinationEntity"; formatString("table-name"; $table[$Txt_relationName].relatedDataClass); \
							"inverseEntity"; formatString("table-name"; $table[$Txt_relationName].relatedDataClass); \
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
					
					If (Not:C34(str_equal($Txt_formattedRelationName; $Txt_relationName)))
						
						$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
							"key"; "keyMapping"; \
							"value"; $Txt_relationName)
						
					End if 
					
					If (Length:C16(String:C10($table[$Txt_relationName].format))>0)
						
						$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
							"key"; "format"; \
							"value"; String:C10($table[$Txt_relationName].format))
						
					End if 
					
					// Get all fields to put in expand userInfo
					var $Col_fields : Collection
					$Col_fields:=New collection:C1472()
					
					var $Txt_buffer; $keyRelation : Text
					For each ($keyRelation; $table[$Txt_relationName])
						
						If (Value type:C1509($table[$Txt_relationName][$keyRelation])=Is object:K8:27)  // field if
							
							$Txt_buffer:=$table[$Txt_relationName][$keyRelation].name
							If (Length:C16($Txt_buffer)>0)
								$Col_fields.push($Txt_buffer)
							End if 
							// Else  // not a field
							
						End if 
					End for each 
					
					// Without forgot the primaryKey
					var $primaryKey : Text
					$primaryKey:=This:C1470.dataModel[String:C10($table[$Txt_relationName].relatedTableNumber)][""].primaryKey
					
					If (Length:C16($primaryKey)>0)
						
						If ($Col_fields.indexOf($primaryKey)<0)
							
							$Col_fields.push($primaryKey)
							
						End if 
					End if 
					
					If ($Col_fields.length>0)
						
						$Dom_node:=DOM Create XML element:C865($Dom_userInfo; "entry"; \
							"key"; "expand"; \
							"value"; $Col_fields.join(","))
						
					End if 
					
					//__________________________________
				Else   // mode with one attribute core data for all related fields or flat mode
					ASSERT:C1129(dev_Matrix; "Using relation=true is now mandatory when generating core data model")
				End if 
				
				//__________________________________
				
				//……………………………………………………………………………………………………………
			: ($table[$Txt_field].relatedEntities#Null:C1517)  // XXX do not edit here without care
				
				ASSERT:C1129(False:C215; "Must not be here if relatedDataClass correctly filled")
				
				//………………………………………………………………………………………………………………………
			Else 
				
				// simple attribute
				
				//………………………………………………………………………………………………………………………
		End case 
		
		
	End for each   // end fields
	
	
	// MARK: - relation
Function _relation($table : Object; $options : Object)->$out : Object
	$out:=New object:C1471()
	var $Txt_field : Text
	var $Obj_field; $Obj_relationTable; $Obj_relationTableInfo; $tableInfo : Object
	
	$tableInfo:=$table[""]
	
	For each ($Txt_field; $table)
		
		Case of 
				//………………………………………………………………………………………………………………………
			: (Length:C16($Txt_field)=0)
				// skip : table metadata
				
				//………………………………………………………………………………………………………………………
			: (Match regex:C1019("(?m-si)^\\d+$"; $Txt_field; 1; *))
				// ignore field
				
				//………………………………………………………………………………………………………………………
			: ((Value type:C1509($table[$Txt_field])=Is object:K8:27))
				
				$Obj_field:=$table[$Txt_field]
				
				var $Boo_found : Boolean
				var $Txt_relationName : Text
				$Txt_relationName:=$Txt_field  // CLEAN maybe remove var
				
				If ($Obj_field.relatedEntities#Null:C1517)  // To remove if relatedEntities deleted and relatedDataClass already filled #109019
					
					$Obj_field.relatedDataClass:=$table[$Txt_relationName].relatedEntities
					ASSERT:C1129(dev_Matrix; "Code must have relatedEntities or relatedDataclass????")
					
				End if 
				
				If ($Obj_field.relatedDataClass#Null:C1517)  // Is is a link?
					
					// if this relatedDataClass in model?
					
					$Obj_relationTable:=This:C1470.getDataClass($Obj_field.relatedDataClass)
					If ($Obj_relationTable=Null:C1517)  // not found we must add a new table in model
						
						$Obj_relationTable:=New object:C1471(\
							""; New object:C1471(\
							"name"; $Obj_field.relatedDataClass))
						
						$Obj_relationTableInfo:=$Obj_relationTable[""]
						
						var $Obj_buffer : Object
						$Obj_buffer:=_o_structure(New object:C1471(\
							"action"; "tableInfo"; \
							"name"; $Obj_field.relatedDataClass))
						
						If ($Obj_buffer.success)
							
							$Obj_relationTableInfo.primaryKey:=$Obj_buffer.tableInfo.primaryKey
							$Obj_relationTableInfo.slave:=$table[""].name
							
							var $Lon_relatedTableID : Integer
							$Lon_relatedTableID:=$Obj_buffer.tableInfo.tableNumber
							
							This:C1470.dataModel[String:C10($Lon_relatedTableID)]:=$Obj_relationTable
							$out.hasBeenEdited:=True:C214
							
						Else 
							
							ob_error_add($out; "Unknown related table "+String:C10($Obj_relationTableInfo.name))
							
						End if 
					End if 
					
					// just check if we must add new fields
					var $keyRelation : Text
					For each ($keyRelation; $table[$Txt_relationName])
						If (Value type:C1509($table[$Txt_relationName][$keyRelation])=Is object:K8:27)
							
							If (($Obj_relationTable[$keyRelation])=Null:C1517)
								
								$Obj_relationTable[$keyRelation]:=$table[$Txt_relationName][$keyRelation]  // name & type
								$out.hasBeenEdited:=True:C214
								
							End if 
						End if 
					End for each 
					
					// Get inverse field
					$Obj_buffer:=_o_structure(New object:C1471(\
						"action"; "inverseRelatedFields"; \
						"table"; $tableInfo.name; \
						"relation"; $Txt_field; \
						"definition"; $options.definition))
					
					If ($Obj_buffer.success)
						
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
							
							$out.hasBeenEdited:=True:C214
							
						End for each 
					End if 
				End if 
				
				//………………………………………………………………………………………………………………………
		End case 
	End for each 
	
Function _relations($options : Object)->$out : Object
	$out:=New object:C1471()
	
	var $Txt_table : Text
	var $result : Object
	For each ($Txt_table; This:C1470.dataModel)
		$result:=This:C1470._relation(This:C1470.dataModel[$Txt_table]; $options)
		
		$out.hasBeenEdited:=Bool:C1537($out.hasBeenEdited) | Bool:C1537($result.hasBeenEdited)
		ob_error_combine($out; $result)
		
	End for each 
	
	
	// MARK: - utility
Function getDataClass($dataClassName : Text)->$dataClass : Object
	var $Txt_table : Text
	var $table : Object
	var $tableInfo : Object
	
	For each ($Txt_table; This:C1470.dataModel) Until ($dataClass#Null:C1517)
		$table:=This:C1470.dataModel[$Txt_table]
		$tableInfo:=$table[""]
		If ($tableInfo.name=$dataClassName)
			$dataClass:=$table
		End if 
	End for each 
	
Function hasField($table : Object; $name : Text)->$has : Boolean
	var $Txt_field : Text
	var $Obj_field : Object
	$has:=False:C215
	For each ($Txt_field; $table) Until ($has)
		$Obj_field:=$table[$Txt_field]
		If (String:C10($Obj_field.name)=$name)  // seems to be sometime null for some relation but not all 
			$has:=True:C214
		End if 
	End for each 
	
	
	// MARK: - primary key
	
	// Add missing primary key for table
Function _primaryKey($table : Object)->$out : Object
	var $result; $tableInfo : Object
	
	$tableInfo:=$table[""]
	$out:=New object:C1471()
	$out.hasBeenEdited:=False:C215
	
	If ($tableInfo.primaryKey#Null:C1517)
		
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
				
				$result:=_o_structure(New object:C1471(\
					"action"; "tableInfo"; \
					"name"; $tableInfo.name))
				
				$Txt_fieldName:=Choose:C955($result.success; $result.tableInfo.primaryKey; "")
				
				//………………………………………………………………………………………………………………………
		End case 
		
		If (Not:C34(This:C1470.hasField($table; $Txt_fieldName)))  // if not add missing primary key field
			
			// cs.structure.new().fieldDefinition($tableInfo.name; $Txt_fieldName) ???
			
			$result:=_o_structure(New object:C1471(\
				"action"; "createField"; \
				"table"; $tableInfo.name; \
				"field"; $Txt_fieldName))
			
			If ($result.success)
				
				$table[String:C10($result.value.id)]:=$result.value
				$out.hasBeenEdited:=True:C214
				
			Else 
				
				ob_error_combine($out; $result)
				
			End if 
		End if 
	End if 
	
	// Add missing primary keys
Function _primaryKeys()->$out : Object
	$out:=New object:C1471
	
	var $result : Object
	
	var $Txt_table : Text
	var $table : Object
	For each ($Txt_table; This:C1470.dataModel)
		$table:=This:C1470.dataModel[$Txt_table]
		
		$result:=This:C1470._primaryKey($table)
		ob_error_combine($out; $result)
		
		$out.hasBeenEdited:=Bool:C1537($out.hasBeenEdited) | Bool:C1537($result.hasBeenEdited)
		
	End for each 
	
	$out.success:=Bool:C1537($out.hasBeenEdited)
	
	// MARK: - scallar
	
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