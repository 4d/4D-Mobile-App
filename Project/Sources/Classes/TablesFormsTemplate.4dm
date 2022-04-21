Class extends Template

Class constructor($input : Object)
	Super:C1705($input)
	ASSERT:C1129(This:C1470.template.type="tablesForms")
	
Function doRun()->$Obj_out : Object
	
	var $Obj_dataModel; $Obj_field; $Obj_tableModel; $Obj_table; $Obj_userChoice; $Obj_tableList; $item : Object
	var $Obj_in; $Obj_template : Object
	$Obj_out:=New object:C1471()
	
	$Obj_in:=This:C1470.input
	$Obj_template:=This:C1470.template
	
	// Manage root templates for all tables forms according to user choice
	// Get the user choice information
	$Obj_userChoice:=$Obj_in.project[String:C10($Obj_template.userChoiceTag)]  // list or detail from project
	
	// For each on tags here, maybe on data view instead?
	$Obj_out.tables:=New collection:C1472
	
	$Obj_out.success:=True:C214
	
	$Obj_dataModel:=$Obj_in.project.dataModel
	
	// Create table form for each table in data model
	var $Txt_tableNumber : Text
	For each ($Txt_tableNumber; $Obj_dataModel)
		
		// Get dataModel information
		$Obj_tableModel:=$Obj_dataModel[$Txt_tableNumber]
		$Obj_tableModel[""].tableNumber:=$Txt_tableNumber
		
		// Get userChoice for one table
		$Obj_tableList:=$Obj_userChoice[$Txt_tableNumber]
		
		If ($Obj_tableList=Null:C1517)  // No user choice, create it
			
			$Obj_tableList:=New object:C1471
			
		End if 
		
		// No fields defined by user in form, take all
		If ($Obj_tableList.fields=Null:C1517)
			
			$Obj_tableList.fields:=dataModel(New object:C1471(\
				"action"; "fieldCollection"; \
				"dataModel"; $Obj_dataModel; \
				"relation"; ($Obj_template.userChoiceTag="detail"); \
				"table"; $Obj_tableModel)).fields
			
		End if 
		
		// Get template path
		var $t : Text
		$t:=Choose:C955(Length:C16(String:C10($Obj_tableList.form))>0; String:C10($Obj_tableList.form); $Obj_template.default)  // Use default if not defined
		
		var $pathForm; $folder; $file : Object
		If ($t[[1]]="/")  // custom form
			
			//$pathForm:=_o_tmpl_form($t; String($Obj_template.userChoiceTag))
			$pathForm:=cs:C1710.tmpl.new().getSources($t; String:C10($Obj_template.userChoiceTag))
			
			If (Bool:C1537($pathForm.exists))
				
				If (Path to object:C1547($t).extension=SHARED.archiveExtension)  // Archive
					
					// Extract
					$folder:=$pathForm.copyTo(Folder:C1567(Temporary folder:C486; fk platform path:K87:2); "template"; fk overwrite:K87:5)
					
				Else 
					
					$folder:=$pathForm
					
				End if 
				
			Else 
				
				Logger.error("Invalid path: \""+$pathForm.path+"\"")
				ob_error_add($Obj_out; "Invalid path: "+$pathForm.path)
				
			End if 
			
		Else 
			
			$folder:=Folder:C1567($Obj_template.source; fk platform path:K87:2).folder($t)
			
		End if 
		
		If ($folder.exists)
			
			// Load the manifest file
			var $o : Object
			$o:=OB Copy:C1225($Obj_in)
			$file:=$folder.file("manifest.json")
			$o.template:=ob_parseFile($file)
			
			If ($o.template.success)  // The template existe or not
				
				$o.template:=$o.template.value  // Get the doc object
				$o.template.isInternal:=Not:C34(Bool:C1537($t[[1]]="/"))
				
				// ==============================================================
				//                          TABLE INFOS
				// ==============================================================
				$Obj_table:=OB Copy:C1225($Obj_tableModel)
				
				$Obj_table.tableNumber:=$Txt_tableNumber
				$Obj_table.originalName:=$Obj_table[""].name
				
				// Format name for the tag
				$Obj_table.name:=formatString("table-name"; $Obj_table.originalName)
				
				If ($Obj_table[""].label=Null:C1517)
					
					$Obj_table.label:=formatString("label"; $Obj_table.originalName)
					
				Else 
					
					$Obj_table.label:=$Obj_table[""].label
					
				End if 
				
				If ($Obj_table[""].shortLabel=Null:C1517)
					
					$Obj_table.shortLabel:=formatString("label"; $Obj_table.originalName)
					
				Else 
					
					$Obj_table.shortLabel:=$Obj_table[""].shortLabel
					
				End if 
				
				// ==============================================================
				//                          FIELDS
				// ==============================================================
				
				$Obj_table.fields:=New collection:C1472
				
				// Get expected field count
				var $Lon_count; $i : Integer
				$Lon_count:=Num:C11($o.template.fields.count)
				$i:=0
				
				var $keyPath : Text
				var $tmpTableModel; $fieldModel : Object
				var $keyPaths : Collection
				
				For each ($Obj_field; $Obj_tableList.fields)
					
					Case of 
							
							//……………………………………………………………………………………………………………
						: ((PROJECT.isField($Obj_field)) || (PROJECT.isComputedAttribute($Obj_field)))
							
							$Obj_field:=OB Copy:C1225($Obj_field)
							
							$Obj_field.nameOrPath:=$Obj_field.name
							If (Feature.with("alias") && ($Obj_field.path#Null:C1517))
								$Obj_field.nameOrPath:=$Obj_field.path
							End if 
							
							$keyPaths:=Split string:C1554($Obj_field.nameOrPath; ".")
							$keyPaths.pop()  // we remove field leaf name, because we get info from id, not path
							
							$tmpTableModel:=$Obj_tableModel
							If ($keyPaths.length>0)  // is it a link?
								For each ($keyPath; $keyPaths) Until ($tmpTableModel=Null:C1517)
									$tmpTableModel:=$tmpTableModel[$keyPath]  // get sub model if related field
								End for each 
							End if 
							
							// Add info from dataModel or cache if missing
							$fieldModel:=Null:C1517
							If ($tmpTableModel#Null:C1517)
								If ($Obj_field.id#Null:C1517)
									$fieldModel:=$tmpTableModel[String:C10($Obj_field.id)]  // OLD CODE
								End if 
								If ($fieldModel=Null:C1517)  // computed or NEW CODE
									$fieldModel:=This:C1470._field($tmpTableModel; $Obj_field)
								End if 
								If ($fieldModel#Null:C1517)
									$Obj_field:=ob_deepMerge($Obj_field; $fieldModel; False:C215)
								Else 
									ASSERT:C1129(dev_Matrix; "Unable to get info of field "+JSON Stringify:C1217($Obj_field))
								End if 
								// Else , nothing in data model, nothing to get
							End if 
							
							// Format name for the tag
							This:C1470._fieldTagify($Obj_field)
							
							// Set binding type according to field information
							$Obj_field.bindingType:=This:C1470.fieldBinding($Obj_field; $Obj_in.formatters).bindingType
							
							ASSERT:C1129((Length:C16(String:C10($Obj_field.bindingType))>0); "Not able to compute binding type for field: "+JSON Stringify:C1217($Obj_field)+". Please provide screenshot to support")
							
							//……………………………………………………………………………………………………………
						: ($Obj_field.name#Null:C1517)  // ie. relation
							
							$Obj_field:=OB Copy:C1225($Obj_field)
							
							$Obj_field.nameOrPath:=$Obj_field.name
							If (Feature.with("alias") && ($Obj_field.path#Null:C1517))
								$Obj_field.nameOrPath:=$Obj_field.path
							End if 
							
							$tmpTableModel:=$Obj_tableModel[$Obj_field.nameOrPath]
							If ($tmpTableModel=Null:C1517)
								$keyPaths:=Split string:C1554($Obj_field.nameOrPath; ".")
								If ($keyPaths.length>1)
									$tmpTableModel:=$Obj_tableModel
									For each ($keyPath; $keyPaths) Until ($tmpTableModel=Null:C1517)
										$tmpTableModel:=$tmpTableModel[$keyPath]
									End for each 
								End if 
							End if 
							
							If ($tmpTableModel#Null:C1517)
								$Obj_field:=ob_deepMerge($Obj_field; $tmpTableModel; False:C215)
							End if 
							
							// Format name for the tag
							This:C1470._fieldTagify($Obj_field)
							
							// Set binding type according to field information
							//$Obj_field.bindingType:=This.fieldBinding($Obj_field; $Obj_in.formatters).bindingType
							
							//……………………………………………………………………………………………………………
						: ($i<$Lon_count)
							
							// Create a dummy fields to replace in template
							$Obj_field:=This:C1470._createDummyField()
							
							//……………………………………………………………………………………………………………
						Else 
							
							$Obj_field:=Null:C1517
							
							//……………………………………………………………………………………………………………
					End case 
					
					If ($Obj_field#Null:C1517)  // if valid
						
						$Obj_table.fields.push($Obj_field)
						
					End if 
					
					$i:=$i+1
					
				End for each 
				
				If ($Lon_count>0)
					
					// If there is more fields in template than defined by user (ie. last fields not defined)
					// add dummy fields
					
					While ($Obj_table.fields.length<$Lon_count)
						
						$Obj_table.fields.push(This:C1470._createDummyField())
						
					End while 
				End if 
				
				// ==============================================================
				//                     SEARCH FIELDS
				// ==============================================================
				
				If ($Obj_tableList.searchableField#Null:C1517)
					
					Case of 
							
							//……………………………………………………………………………………………………………
						: (Value type:C1509($Obj_tableList.searchableField)=Is object:K8:27)
							
							If (Feature.with("alias"))
								$Obj_table.searchableField:=formatString("field-name"; String:C10($Obj_tableList.searchableField.path || $Obj_tableList.searchableField.name))
							Else 
								$Obj_table.searchableField:=formatString("field-name"; String:C10($Obj_tableList.searchableField.name))
							End if 
							
							//……………………………………………………………………………………………………………
						: (Value type:C1509($Obj_tableList.searchableField)=Is collection:K8:32)
							
							If (Feature.with("alias"))
								
								$Obj_table.searchableField:=New collection:C1472
								For each ($item; $Obj_tableList.searchableField)
									$Obj_table.searchableField.push(formatString("field-name"; String:C10($item.path || $item.name)))
								End for each 
								$Obj_table.searchableField:=$Obj_table.searchableField.join(",")
								
							Else 
								$Obj_table.searchableField:=$Obj_tableList.searchableField.extract("name").map("col_formula"; Formula:C1597($1.result:=formatString("field-name"; String:C10($1.value)))).join(",")
							End if 
							
							//……………………………………………………………………………………………………………
						: (Value type:C1509($Obj_tableList.searchableField)=Is text:K8:3)
							
							If (Asserted:C1132(Not:C34(Feature.with("alias")); "Old way to defined searchable field"))
								$Obj_table.searchableField:=formatString("field-name"; String:C10($Obj_tableList.searchableField))
							End if 
							
							//……………………………………………………………………………………………………………
					End case 
					
					$Obj_table.searchableWithBarcode:=Bool:C1537($Obj_tableList.searchableWithBarcode)
					
				End if 
				
				// ==============================================================
				//                        SORT FIELDS
				// ==============================================================
				
				If ($Obj_tableList.sortField#Null:C1517)
					
					Case of 
							
							//……………………………………………………………………………………………………………
						: (Value type:C1509($Obj_tableList.sortField)=Is object:K8:27)
							
							If (Feature.with("alias"))
								$Obj_table.sortField:=formatString("field-name"; String:C10($Obj_tableList.sortField.path || $Obj_tableList.sortField.name))
							Else 
								$Obj_table.sortField:=formatString("field-name"; String:C10($Obj_tableList.sortField.name))
							End if 
							
							//……………………………………………………………………………………………………………
						: (Value type:C1509($Obj_tableList.sortField)=Is collection:K8:32)
							
							If (Feature.with("alias"))
								
								$Obj_table.sortField:=New collection:C1472
								For each ($item; $Obj_tableList.sortField)
									$Obj_table.sortField.push(formatString("field-name"; String:C10($item.path || $item.name)))
								End for each 
								$Obj_table.sortField:=$Obj_table.sortField.join(",")
								
							Else 
								$Obj_table.sortField:=$Obj_tableList.sortField.extract("name").map("col_formula"; Formula:C1597($1.result:=formatString("field-name"; String:C10($1.value)))).join(",")
							End if 
							
							//……………………………………………………………………………………………………………
						: (Value type:C1509($Obj_tableList.sortField)=Is text:K8:3)
							
							If (Asserted:C1132(Not:C34(Feature.with("alias")); "Old way to defined sort field"))
								$Obj_table.sortField:=formatString("field-name"; String:C10($Obj_tableList.sortField))
							End if 
							
							//……………………………………………………………………………………………………………
					End case 
					
				Else 
					$Obj_table.sortField:=This:C1470.sortFieldFromAction($Obj_table)
					
					If (Length:C16($Obj_table.sortField)=0)
						// take searchable field as sort field if not defined yet
						$Obj_table.sortField:=$Obj_table.searchableField
						
						If (Length:C16(String:C10($Obj_table.sortField))=0)
							
							// and if no search field find the first one sortable in diplayed field
							For each ($Obj_field; $Obj_table.fields) Until ($Obj_table.sortField#Null:C1517)
								
								If (PROJECT.isField($Obj_field)\
									 && ($Obj_field.fieldType#Is picture:K8:10)\
									 && ($Obj_field.fieldType#-1))  // not image or not defined or not relation
									
									If (Feature.with("alias"))
										$Obj_table.sortField:=$Obj_field.path || $Obj_field.name  // formatString ("field-name";String($Obj_field.originalName))
									Else 
										$Obj_table.sortField:=$Obj_field.name  // formatString ("field-name";String($Obj_field.originalName))
									End if 
									
								End if 
							End for each 
						End if 
					End if 
					
					// XXX maybe if not in displayable fields, go for not displayable fields?
					
				End if 
				
				// If (Length($Obj_table.sortField)=0)
				// XXX maybe primary key field?
				// End if
				
				// ==============================================================
				//                         SECTION
				// ==============================================================
				
				If ($Obj_tableList.sectionField#Null:C1517)
					
					If (Feature.with("alias"))
						$Obj_table.sectionField:=formatString("field-name"; String:C10($Obj_tableList.sectionField.path || $Obj_tableList.sectionField.name))
					Else 
						$Obj_table.sectionField:=formatString("field-name"; String:C10($Obj_tableList.sectionField.name))
					End if 
					$Obj_table.sectionFieldBindingType:=""
					
					// Get format of section field$Obj_tableList
					If ($Obj_tableModel[String:C10($Obj_tableList.sectionField.id || $Obj_tableList.sectionField.name)]#Null:C1517)
						
						$Obj_field:=New object:C1471  // maybe get other info from  $Obj_tableList.fields
						$Obj_field:=ob_deepMerge($Obj_field; $Obj_tableModel[String:C10($Obj_tableList.sectionField.id || $Obj_tableList.sectionField.name)])
						
						$Obj_table.sectionFieldBindingType:=This:C1470.fieldBinding($Obj_field; $Obj_in.formatters).bindingType
						
					End if 
				End if 
				
				$Obj_table.showSection:="NO"  // show or not the section bar at right
				
				// ==============================================================
				//                        ACTIONS
				// ==============================================================
				
				Case of 
						
						//……………………………………………………………………………………………………………
					: (String:C10($Obj_template.userChoiceTag)="list")
						
						// get action on table
						C_COLLECTION:C1488($Col_actions)
						$Col_actions:=mobile_actions("form"; New object:C1471(\
							"project"; $Obj_in.project; \
							"table"; $Obj_table.originalName; \
							"tableNumber"; $Obj_table.tableNumber; \
							"scope"; "table")).actions
						
						If ($Col_actions.length>0)
							
							$Obj_table.tableActions:=JSON Stringify:C1217(New object:C1471(\
								"actions"; $Col_actions))
							
						End if 
						
						$Col_actions:=mobile_actions("form"; New object:C1471(\
							"project"; $Obj_in.project; \
							"table"; $Obj_table.originalName; \
							"tableNumber"; $Obj_table.tableNumber; \
							"scope"; "currentRecord")).actions
						
						If ($Col_actions.length>0)
							
							$Obj_table.recordActions:=JSON Stringify:C1217(New object:C1471(\
								"actions"; $Col_actions))
							
						End if 
						
						// XXX selection actions
						//……………………………………………………………………………………………………………
					: (String:C10($Obj_template.userChoiceTag)="detail")
						
						$Col_actions:=mobile_actions("form"; New object:C1471(\
							"project"; $Obj_in.project; \
							"table"; $Obj_table.originalName; \
							"tableNumber"; $Obj_table.tableNumber; \
							"scope"; "currentRecord")).actions
						
						If ($Col_actions.length>0)
							
							$Obj_table.recordActions:=JSON Stringify:C1217(New object:C1471(\
								"actions"; $Col_actions))
							
						End if 
						
						//……………………………………………………………………………………………………………
					Else 
						
						ASSERT:C1129(dev_assert; "Unknown form type "+String:C10(String:C10($Obj_template.userChoiceTag)))
						
						//……………………………………………………………………………………………………………
				End case 
				
				// ==============================================================
				//                       TYPE AN OTHERS
				// ==============================================================
				
				$Obj_in.tags.detailFormType:=String:C10($o.template.tags.___DETAILFORMTYPE___)  // XXX could do a generic insert of all $Obj_buffer.template.tags here
				$Obj_in.tags.listFormType:=String:C10($o.template.tags.___LISTFORMTYPE___)
				
				$Obj_table.navigationIcon:=Null:C1517
				
				If (Value type:C1509($Obj_in.tags.navigationTables)=Is collection:K8:32)
					
					C_OBJECT:C1216($Obj_navigationTable)
					$Obj_navigationTable:=$Obj_in.tags.navigationTables.query("originalName = :1"; String:C10($Obj_table.originalName)).pop()
					
					If ($Obj_navigationTable#Null:C1517)
						
						$Obj_table.navigationIcon:=String:C10($Obj_navigationTable.navigationIcon)
						
					End if 
					
				Else 
					
					ASSERT:C1129(dev_Matrix; "No navigationTables computed before doing table forms. Need to know if form is in main navigation and get the icon")
					
				End if 
				
				$Obj_in.tags.table:=$Obj_table
				
				// Process the template
				If ($folder.folder("ios").exists)
					$o.template.source:=$folder.folder("ios").platformPath
				Else 
					$o.template.source:=$folder.platformPath
				End if 
				$o.template.parent:=$Obj_template.parent  // or $Obj_template?
				$o.tags:=$Obj_in.tags  // has been modifyed since clone
				$o.projfile:=$Obj_in.projfile  // do not want a copy
				$o.exclude:=JSON Stringify:C1217(SHARED.template.exclude)
				
				$Obj_out.template:=TemplateInstanceFactory($o).run()  // <================================== RECURSIVE
				ob_error_combine($Obj_out; $Obj_out.template)
				
			Else   // cannot read the template
				
				ob_error_combine($Obj_out; $o.template)
				$Obj_out.success:=False:C215
				
			End if 
			
		Else 
			
			Logger.error("Invalid path: \""+$folder.path+"\"")
			ob_error_add($Obj_out; "Invalid path: "+$folder.path)
			
		End if 
	End for each 
	
Function _createDummyField()->$dummy : Object
	$dummy:=New object:C1471(\
		"name"; ""; \
		"originalName"; ""; \
		"originalPath"; ""; \
		"label"; ""; \
		"shortLabel"; ""; \
		"valueType"; ""; \
		"kind"; ""; \
		"bindingType"; "unknown"; \
		"type"; -1; \
		"fieldType"; -1; \
		"id"; -1; \
		"icon"; "")
	
	// change name attribute and add missing value
Function _fieldTagify($Obj_field : Object)
	$Obj_field.originalName:=$Obj_field.name
	If (Feature.with("alias"))
		$Obj_field.originalPath:=$Obj_field.path
		$Obj_field.nameIcon:=$Obj_field.name
		$Obj_field.name:=formatString("field-name"; $Obj_field.nameOrPath)  // NAME is used in tag for binding, but we need path now because name seems to be shortened sometimes...
	Else 
		$Obj_field.nameIcon:=$Obj_field.name
		$Obj_field.name:=formatString("field-name"; $Obj_field.originalName)
	End if 
	
	If ($Obj_field.label=Null:C1517)
		
		$Obj_field.label:=formatString("label"; $Obj_field.originalName)
		
	End if 
	
	If ($Obj_field.shortLabel=Null:C1517)
		
		$Obj_field.shortLabel:=formatString("label"; $Obj_field.originalName)
		
	End if 
	
	// create a comma separated sort field from first action
Function sortFieldFromAction($table : Object)->$sortFields : Text
	$sortFields:=""
	var $actions : Collection
	$actions:=This:C1470.input.project.actions
	If ($actions#Null:C1517)
		var $action; $parameter : Object
		For each ($action; $actions) Until (Length:C16($sortFields)>0)
			If (String:C10($action.preset)="sort")
				If ($action.tableNumber=Num:C11($table.tableNumber))
					For each ($parameter; $action.parameters)
						If (Length:C16($sortFields)#0)
							$sortFields:=$sortFields+","
						End if 
						If (String:C10($parameter.format)="descending")
							$sortFields:=$sortFields+"!"  // because on iOS sortAscending = true by default so we reverse here
						End if 
						$sortFields:=$sortFields+formatString("field-name"; String:C10($table[String:C10($parameter.fieldNumber)].name))
					End for each 
				End if 
			End if 
		End for each 
	End if 
	
	// Return complete info about field
Function _field($table; $field)->$fieldResult : Object
	var $tableResult : Object
	$fieldResult:=Null:C1517
	If (Asserted:C1132(OB Instance of:C1731(This:C1470.project; cs:C1710.project); "project is no more a class, and no method exist to get field from it. use data model?"))
		If (This:C1470.project.table($table)#Null:C1517)
			$fieldResult:=This:C1470.project.field($table; $field)
		End if 
	Else 
		// tmp code in cas of...
		$tableResult:=This:C1470.project.dataModel[This:C1470._tableID($table)]
		var $t : Text
		$t:=This:C1470._fieldKey($field)
		If (Length:C16($t)>0)
			$fieldResult:=$tableResult[$t]
		End if 
	End if 
	
	If (($fieldResult=Null:C1517) && (This:C1470.catalog#Null:C1517))
		// maybe table not published, so get from cache catalog
		$tableResult:=This:C1470.catalog.query("name = :1"; This:C1470._tableName($table)).pop()
		If ($tableResult=Null:C1517)
			$tableResult:=This:C1470.catalog.query("tableNumber = :1"; This:C1470._tableNumber($table)).pop()
		End if 
		If ($tableResult#Null:C1517)
			$fieldResult:=$tableResult.fields.query("name = :1"; This:C1470._fieldName($field)).pop()
			// will not work if name contain full path? (but what we want!!!)
			If ($fieldResult=Null:C1517)  // so try with last path
				var $components : Collection
				$components:=Split string:C1554(This:C1470._fieldName($field); ".")
				If ($components.length>1)
					$fieldResult:=$tableResult.fields.query("name = :1"; $components[$components.length-1]).pop()
				End if 
			End if 
		End if 
	End if 
	
Function _tableNumber($table : Variant)->$number : Integer
	Case of 
		: (Value type:C1509($table)=Is text:K8:3)
			$number:=Num:C11($table)
		: (Value type:C1509($table)#Is object:K8:27)
			ASSERT:C1129(False:C215; "Wrong type for table data "+String:C10(Value type:C1509($table)))
		: ((Value type:C1509($table[""])=Is object:K8:27) && ($table[""].tableNumber#Null:C1517))
			$number:=Num:C11($table[""].tableNumber)
		: ((Value type:C1509($table[""])=Is object:K8:27) && ($table[""].relatedTableNumber#Null:C1517))
			$number:=Num:C11($table[""].relatedTableNumber)
		: ($table.tableNumber#Null:C1517)
			$number:=Num:C11($table.tableNumber)
		Else 
			$number:=Num:C11($table.relatedTableNumber)
	End case 
	
Function _tableID($table) : Text
	
	return (String:C10(This:C1470._tableNumber($table)))
	
Function _fieldKey($field : Variant)->$key : Text
	Case of 
		: (Value type:C1509($field)=Is text:K8:3)
			$key:=$field
		: ((Value type:C1509($field)=Is object:K8:27) && ($field.fieldNumber#Null:C1517))
			$key:=String:C10($field.fieldNumber)
		: ((Value type:C1509($field)=Is object:K8:27) && ($field.id#Null:C1517))
			$key:=String:C10($field.id)
		Else 
			$key:=This:C1470._fieldName($field)
	End case 
	
Function _fieldName($field : Variant)->$name : Text
	Case of 
		: (Value type:C1509($field)=Is text:K8:3)
			$name:=$field
		: (Value type:C1509($field)=Is object:K8:27)
			$name:=String:C10($field.name)
		Else 
			ASSERT:C1129(False:C215; "Wrong type for table data "+String:C10(Value type:C1509($field)))
	End case 
	
Function _tableName($table : Variant)->$name : Text
	Case of 
		: (Value type:C1509($table)=Is text:K8:3)
			$name:=$table
		: (Value type:C1509($table)#Is object:K8:27)
			ASSERT:C1129(False:C215; "Wrong type for table data "+String:C10(Value type:C1509($table)))
		: (Value type:C1509($table[""])=Is object:K8:27)
			$name:=String:C10($table[""].name)
		Else 
			$name:=String:C10($table.name)
	End case 
	
	// return binding information for a field
Function fieldBinding($field : Object; $formatter : Object)->$binding : Object
	
	$binding:=New object:C1471("success"; False:C215)
	
	Case of 
			
			// ----------------------------------------
		: ($field=Null:C1517)
			
			$binding.errors:=New collection:C1472("field must be specified to fill binding type")
			
			// ----------------------------------------
		: ($field.fieldType=Null:C1517)
			
			$binding.errors:=New collection:C1472("field must be have a type to fill binding type")
			ASSERT:C1129(dev_Matrix; "field must be have a type to fill binding type")
			
			// ----------------------------------------
		Else 
			
			Case of 
					
					//________________________________________
				: (Value type:C1509($field.format)=Is object:K8:27)
					
					$binding.format:=$field.format
					
					//________________________________________
				: (Value type:C1509($field.format)=Is text:K8:3)
					
					If (Value type:C1509($formatter)=Is object:K8:27)
						
						If (Value type:C1509($formatter[$field.format])=Is object:K8:27)
							
							$binding.format:=$formatter[$field.format]
							
						Else 
							
							ob_error_add($binding; "Unknown data formatter '"+$field.format+"'")
							
						End if 
						
					Else 
						
						ob_error_add($binding; "No list of formatters provided to resolve '"+$field.format+"'")
						
					End if 
					
					// ........................................
			End case 
			
			If ($binding.format#Null:C1517)
				
				If ((Length:C16(String:C10($binding.format.binding))=0)\
					 | (String:C10($binding.format.binding)=String:C10($binding.format.name)))
					
					$binding.bindingType:=String:C10($binding.format.name)
					
				Else 
					
					$binding.bindingType:=String:C10($binding.format.binding)+","+String:C10($binding.format.name)
					
				End if 
				
				$binding.success:=True:C214
				
			End if 
			
			If (Length:C16(String:C10($binding.bindingType))=0)
				
				If (Length:C16(String:C10($field.relatedDataClass))>0)
					
					$binding.bindingType:="Transformable"
					$binding.success:=True:C214
					
				Else 
					
					// set default value according to type (here type from 4d structure)
					If ($field.fieldType<SHARED.defaultFieldBindingTypes.length)
						
						$binding.bindingType:=SHARED.defaultFieldBindingTypes[$field.fieldType]
						$binding.success:=(Length:C16(String:C10($binding.bindingType))>0)
						
					Else 
						
						ob_error_add($binding; "No default format for type '"+String:C10($field.fieldType)+"'")
						
					End if 
				End if 
			End if 
	End case 
	