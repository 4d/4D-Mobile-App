Class constructor($project : Object)
	This:C1470.dataModel:=OB Copy:C1225($project.dataModel)
	This:C1470.actions:=$project.actions  // to create fetch index using sort actions
	This:C1470.project:=$project
	
	If (Feature.with("alias") && Feature.with("iOSAlias"))
		This:C1470.catalog:=This:C1470.project.getCatalog()
	End if 
	
Function run($path : Text; $options : Object)->$out : Object
	$out:=New object:C1471()
	
	If ($options.definition=Null:C1517)
		$options.definition:=New object:C1471  // cache
	End if 
	
	If (This:C1470.dataModel=Null:C1517)
		
		ASSERT:C1129(dev_Matrix; "No data model passed to xcDataModel")
		RECORD.warning("dataModel is null to generate xcDataModel (core data ios)")
		return 
	End if 
	
	var $result : Object
	
	// MARK: Manage alias
	If (Feature.with("alias") && Feature.with("iOSAlias"))
		
		$result:=This:C1470._alias()
		ob_error_combine($out; $result)
		
	End if 
	
	// MARK: Add missing relations
	If (Bool:C1537($options.relationship))  // TODO if not defined True?
		
		$result:=This:C1470._relations($options)
		ob_error_combine($out; $result)
		
	End if 
	
	// MARK: Add missing primary keys
	$result:=This:C1470._primaryKeys()
	ob_error_combine($out; $result)
	
	// MARK: Create header
	var $Dom_model : Text
	$Dom_model:=This:C1470._createHeader()
	
	// MARK: Create elements nodes
	var $Dom_elements : Text
	$Dom_elements:=This:C1470._createElements($Dom_model)
	
	// MARK: (NO) add abstract entity
	If (Bool:C1537(Feature.with("coreDataAbstractEntity")))
		
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
	
	// MARK: Create entities nodes
	$result:=This:C1470._createEntities($options; $Dom_model)
	ob_error_combine($out; $result)
	
	// MARK: Then write XML result to file
	$result:=This:C1470._writeToFile($path; $Dom_model)
	$out.success:=$result.success
	$out.path:=$result.path
	
	// MARK: close dom
	DOM CLOSE XML:C722($Dom_model)
	
	// Write xml model to file
Function _writeToFile($destination : Variant; $Dom_model : Text)->$out : Object
	// manage parameters
	var $file : Object  // file or folder
	Case of 
		: (Value type:C1509($destination)=Is text:K8:3)
			$file:=Folder:C1567($destination; fk platform path:K87:2)
		: ((Value type:C1509($destination)=Is object:K8:27) && (OB Instance of:C1731($destination; 4D:C1709.File) || OB Instance of:C1731($destination; 4D:C1709.Folder)))
			$file:=$destination
		Else 
			ASSERT:C1129(False:C215; "Wrong destination file type for xml")
			$out:=New object:C1471("success"; False:C215; "errors"; New collection:C1472("Wrong destination file type for xml"))
			return 
	End case 
	
	// get "contents" file at wanted path if a folder has been provided
	Case of 
		: ($file.extension=".xcdatamodeld")
			$file:=$file.folder($file.name+".xcdatamodel").file("contents")
		: ($file.extension=".xcdatamodel")
			$file:=$file.file("contents")
	End case 
	
	// export
	$file.create()  // will create intermediate folders
	
	DOM EXPORT TO FILE:C862($Dom_model; $file.platformPath)
	
	$out:=New object:C1471("success"; OK; "path"; $file.platformPath)
	
	// MARK: - creations
	
Function _createHeader()->$Dom_model : Text
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
	
	// create Element nodes
Function _createElements($Dom_model : Text)
	var $Dom_elements; $Dom_node : Text
	$Dom_elements:=DOM Create XML element:C865($Dom_model; "elements")
	
	var $index : Integer
	$index:=0
	var $table; $tableInfo : Object
	var $tableId : Text
	For each ($tableId; This:C1470.dataModel)
		$table:=This:C1470.dataModel[$tableId]
		$tableInfo:=$table[""]
		
		$Dom_node:=DOM Create XML element:C865($Dom_elements; "element"; \
			"name"; formatString("table-name"; $tableInfo.name); \
			"positionX"; 200*$index; \
			"positionY"; 100; \
			"width"; 150; \
			"height"; 45+(15*OB Keys:C1719($table).length))
		
		$index:=$index+1
	End for each 
	
	// create Entities node
Function _createEntities($options : Object; $Dom_model : Text)->$out : Object
	$out:=New object:C1471()
	var $table; $result : Object
	var $tableId : Text
	For each ($tableId; This:C1470.dataModel)
		$table:=This:C1470.dataModel[$tableId]
		$result:=This:C1470._createEntity($options; $Dom_model; Num:C11($tableId); $table)
		ob_error_combine($out; $result)
	End for each 
	$out.success:=ob_error_has($out)
	
	// create Entity node
	// $Dom_model: parent node
	// $table table data
Function _createEntity($options : Object; $Dom_model : Text; $tableID : Integer; $table : Object)->$out : Object
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
	
	var $Dom_userInfo; $Dom_entity; $Dom_node; $Dom_attribute : Text
	$Dom_entity:=DOM Create XML element arrays:C1097($Dom_model; "entity"; $tTxt_entityAttributes; $tTxt_entityValues)
	
	If (Bool:C1537(Feature.with("coreDataAbstractEntity")))
		
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
		"value"; Choose:C955(This:C1470._hasGlobalStamp($tableInfo.name); "YES"; "NO"))
	
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
						If (Num:C11($action.tableNumber)=$tableID)
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
					If ((Length:C16($Txt_originalFieldName)=0) && PROJECT.isComputedAttribute($table[$Txt_field]))
						$Txt_originalFieldName:=$Txt_field
					End if 
					$Lon_type:=$table[$Txt_field].fieldType
					
				Else 
					
					var $Lon_fieldID : Integer
					ASSERT:C1129(dev_Matrix; "Please avoid to have missing info in dataModel and rely and Field, field name method")
					$Lon_fieldID:=Num:C11($Txt_field)
					var $Ptr_field : Pointer
					$Ptr_field:=Field:C253($tableID; $Lon_fieldID)
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
					If ((Length:C16($Txt_inverseName)=0) && PROJECT.isAlias($table[$Txt_field]))
						
						$Txt_inverseName:=String:C10($table[$table[$Txt_field].path].inverseName)
					End if 
					
					If (Length:C16($Txt_inverseName)=0)
						
						ASSERT:C1129(dev_Matrix; "Missing inverseName")
						
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
						
						$Obj_relationTable:=This:C1470._createTable($Obj_field.relatedDataClass)
						$Obj_relationTableInfo:=$Obj_relationTable[""]
						
						If ($Obj_relationTableInfo.primaryKey#Null:C1517)  // one criteria to know if ok
							$Obj_relationTableInfo.slave:=$table[""].name
							
							This:C1470.dataModel[String:C10($Obj_relationTableInfo.tableNumber)]:=$Obj_relationTable
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
					var $Obj_buffer : Object
					$Obj_buffer:=This:C1470._inverseRelatedFields($tableInfo.name; $Txt_field; $options.definition)
					
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
	
	// MARK: - alias
	
Function _manageAlias($alias : Object; $table : Object)->$out : Object
	$out:=New object:C1471()
	If (Length:C16(String:C10($alias.path))=0)
		ASSERT:C1129(False:C215; "No path on alias. Issue in data model")
		return 
	End if 
	
	var $paths : Collection
	var $destination; $sourceDataClass; $result : Object
	var $path : Text
	
	
	$paths:=Split string:C1554(String:C10($alias.path); ".")
	$sourceDataClass:=$table
	Repeat 
		$path:=$paths.shift()
		$destination:=This:C1470._fieldForKey($sourceDataClass; $path)
		
		If ($destination=Null:C1517)
			
			$result:=This:C1470._createField($sourceDataClass[""].name; $path)
			
			If ($result.success)
				$destination:=$result.value
				Case of 
					: ($result.value.id#Null:C1517)  // final field
						$sourceDataClass[String:C10($result.value.id)]:=$result.value
						$out.hasBeenEdited:=True:C214
					: ($result.value.name#Null:C1517)  // final field
						$sourceDataClass[String:C10($result.value.name)]:=$result.value
						$out.hasBeenEdited:=True:C214
						
						// TODO: if alias in alias, recursive work
						If (String:C10($result.value.kind)="alias")  // isAlias ?
							// TODO: table or dst table?
							This:C1470._manageAlias($result.value; $sourceDataClass)
						End if 
					Else 
						ASSERT:C1129(False:C215; "Field destination of alias "+$path+" in "+$sourceDataClass[""].name+" is not publishable: "+JSON Stringify:C1217($result))
				End case 
			Else 
				ASSERT:C1129(False:C215; "Field destination of alias "+$path+" in "+$sourceDataClass[""].name+" is not published")
			End if 
		End if 
		
		If ($destination.relatedDataClass#Null:C1517)
			var $sourceDataClassName : Text
			$sourceDataClassName:=$sourceDataClass[""].name  // old one
			
			$sourceDataClass:=This:C1470.getDataClass($destination.relatedDataClass)
			If ($sourceDataClass=Null:C1517)
				$sourceDataClass:=This:C1470._createTable($destination.relatedDataClass)
				If ($sourceDataClass[""].primaryKey#Null:C1517)  // one criteria to known if ok
					$sourceDataClass[""].slave:=$sourceDataClassName
					
					This:C1470.dataModel[String:C10($sourceDataClass[""].tableNumber)]:=$sourceDataClass
					$out.hasBeenEdited:=True:C214
				Else 
					ob_error_add($out; "Missing table "+String:C10($destination.relatedDataClass)+" in catalog")
					ASSERT:C1129(dev_Matrix; "Missing table "+String:C10($destination.relatedDataClass)+" in catalog")
				End if 
			End if 
			
		Else 
			
			// normal field or alias
			
		End if 
	Until ($paths.length=0)
	
Function _aliasInTable($table : Object)->$out : Object
	var $result : Object
	$out:=New object:C1471()
	
	var $fieldKey : Text
	For each ($fieldKey; $table)
		If (String:C10($table[$fieldKey].kind)="alias")  // isAlias ?
			$result:=This:C1470._manageAlias($table[$fieldKey]; $table)
			ob_error_combine($out; $result)
			$out.hasBeenEdited:=Bool:C1537($out.hasBeenEdited) | Bool:C1537($result.hasBeenEdited)
		End if 
	End for each 
	
Function _alias()->$out : Object
	$out:=New object:C1471()
	var $result : Object
	var $tableID : Text
	For each ($tableID; This:C1470.dataModel)
		$result:=This:C1470._aliasInTable(This:C1470.dataModel[$tableID])
		ob_error_combine($out; $result)
		$out.hasBeenEdited:=Bool:C1537($out.hasBeenEdited) | Bool:C1537($result.hasBeenEdited)
	End for each 
	
	
	// MARK: - utility from data model
	
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
	
	// (used only in alias now)s
Function _fieldForKey($table : Object; $key : Text)->$dst : Object
	$dst:=$table[$key]
	If ($dst=Null:C1517)
		var $fieldKey : Text
		For each ($fieldKey; $table) Until ($dst#Null:C1517)
			//If (Match regex("(?m-si)^\\d+$"; $fieldKey; 1; *))
			If (String:C10($table[$fieldKey].name)=$key)
				$dst:=$table[$fieldKey]
			End if 
			//End if
		End for each 
	End if 
	
	// MARK: - utility from full catalog
	
Function _tableFromCatalog($tableName : Text)->$table : Object
	If (This:C1470.catalog#Null:C1517)
		$table:=This:C1470.catalog.query("name = :1"; $tableName).pop()
	End if 
	
Function _createTable($tableName : Text)->$table : Object
	$table:=New object:C1471(\
		""; New object:C1471(\
		"name"; $tableName))
	
	var $tableInfo : Object
	If (Bool:C1537(Feature.with("iOSAlias")))
		$tableInfo:=This:C1470._tableFromCatalog($tableName)
	Else 
		$tableInfo:=_o_structure(New object:C1471(\
			"action"; "tableInfo"; \
			"name"; $tableName)).tableInfo
	End if 
	
	If ($tableInfo#Null:C1517)
		$table[""]:=$tableInfo
	End if 
	
Function _createField($tableName : Text; $fieldName : Text)->$result : Object
	If (Bool:C1537(Feature.with("iOSAlias")))
		$result:=New object:C1471("success"; False:C215)
		var $table : Object
		$table:=This:C1470._tableFromCatalog($tableName)
		If ($table#Null:C1517)
			$result.value:=$table.fields.query("name = :1"; $fieldName).pop()
			$result.success:=$result.value#Null:C1517
		End if 
	Else 
		$result:=_o_structure(New object:C1471("action"; "createField"; "table"; $tableName; "field"; $fieldName))
		// cs.ExposedStructure.new().fieldDefinition($tableInfo.name; $Txt_fieldName) ???
	End if 
	
Function _hasGlobalStamp($tableName : Text)->$has : Boolean
	If (Bool:C1537(Feature.with("iOSAlias")))
		$has:=False:C215
		var $table : Object
		$table:=This:C1470._tableFromCatalog($tableName)
		If ($table#Null:C1517)
			$has:=$table.fields.query("name = :1"; SHARED.stampField.name).length>0
		End if 
	Else 
		// XXX this look at ds, we do not want, must be removed if catalog is ok
		$has:=Bool:C1537(_o_structure(New object:C1471(\
			"action"; "hasField"; \
			"table"; $tableName; \
			"field"; SHARED.stampField.name)).value)
	End if 
	
Function _inverseRelatedFields($tableName : Text; $relationKey : Text; $cache : Object)->$result : Object
	If (Bool:C1537(Feature.with("iOSAlias")))
		
		$result:=_o_structure(New object:C1471(\
			"action"; "inverseRelatedFields"; \
			"table"; $tableName; \
			"relation"; $relationKey; \
			"definition"; $cache))
		// TODO: remove  _o_structure  inverseRelatedFields
	Else 
		$result:=_o_structure(New object:C1471(\
			"action"; "inverseRelatedFields"; \
			"table"; $tableName; \
			"relation"; $relationKey; \
			"definition"; $cache))
	End if 
	
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
			
			$result:=This:C1470._createField($tableInfo.name; $Txt_fieldName)
			
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