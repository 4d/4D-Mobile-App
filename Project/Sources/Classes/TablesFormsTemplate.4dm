Class extends Template

Class constructor
	C_OBJECT:C1216($1)
	Super:C1705($1)
	ASSERT:C1129(This:C1470.template.type="tablesForms")
	
Function doRun
	C_OBJECT:C1216($0; $Obj_out)
	
	$Obj_out:=New object:C1471()
	
	C_OBJECT:C1216($Obj_in; $Obj_template)
	$Obj_in:=This:C1470.input
	$Obj_template:=This:C1470.template
	
	// Manage root templates for all tables forms according to user choice
	// Get the user choice information
	C_OBJECT:C1216($Obj_userChoice)
	$Obj_userChoice:=$Obj_in.project[String:C10($Obj_template.userChoiceTag)]  // list or detail from project
	
	// For each on tags here, maybe on data view instead?
	$Obj_out.tables:=New collection:C1472
	
	$Obj_out.success:=True:C214
	
	C_OBJECT:C1216($Obj_dataModel)
	$Obj_dataModel:=$Obj_in.project.dataModel
	
	// Create table form for each table in data model
	C_TEXT:C284($Txt_tableNumber)
	For each ($Txt_tableNumber; $Obj_dataModel)
		
		// Get dataModel information
		$Obj_tableModel:=$Obj_dataModel[$Txt_tableNumber]
		
		// Get userChoice for one table
		C_OBJECT:C1216($Obj_tableList)
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
		C_TEXT:C284($t)
		$t:=Choose:C955(Length:C16(String:C10($Obj_tableList.form))>0; String:C10($Obj_tableList.form); $Obj_template.default)  // Use default if not defined
		
		C_OBJECT:C1216($pathForm; $folder; $file)
		If ($t[[1]]="/")  // custom form
			
			$pathForm:=tmpl_form($t; String:C10($Obj_template.userChoiceTag))
			
			If (Bool:C1537($pathForm.exists))
				
				If (Path to object:C1547($t).extension=SHARED.archiveExtension)  // Archive
					
					// Extract
					$folder:=$pathForm.copyTo(Folder:C1567(Temporary folder:C486; fk platform path:K87:2); "template"; fk overwrite:K87:5)
					
				Else 
					
					$folder:=$pathForm
					
				End if 
				
			Else 
				
				RECORD.error("Invalid path: \""+$pathForm.path+"\"")
				
				If ($Obj_out.errors=Null:C1517)
					
					$Obj_out.errors:=New collection:C1472
					
				End if 
				
				$Obj_out.errors.push("Invalid path: "+$pathForm.path)
				
			End if 
			
		Else 
			
			$folder:=Folder:C1567($Obj_template.source; fk platform path:K87:2).folder($t)
			
		End if 
		
		If ($folder.exists)
			
			// Load the manifest file
			$o:=OB Copy:C1225($Obj_in)
			$file:=$folder.file("manifest.json")
			C_OBJECT:C1216($o)
			$o.template:=ob_parseFile($file)
			
			If ($o.template.success)  // The template existe or not
				
				$o.template:=$o.template.value  // Get the doc object
				$o.template.isInternal:=Not:C34(Bool:C1537($t[[1]]="/"))
				
				// ==============================================================
				//                          TABLE INFOS
				// ==============================================================
				C_OBJECT:C1216($Obj_table)
				$Obj_table:=OB Copy:C1225($Obj_tableModel)
				
				$Obj_table.tableNumber:=$Txt_tableNumber
				$Obj_table.originalName:=$Obj_table[""].name
				
				// Format name for the tag
				$Obj_table.name:=formatString("table-name"; $Obj_table.originalName)
				
				If ($Obj_table[""].label=Null:C1517)
					
					$Obj_table.label:=formatString("label"; $Obj_table.originalName)
					
				Else 
					
					// User label
					$Obj_table.label:=$Obj_table[""].label
					
				End if 
				
				If ($Obj_table[""].shortLabel=Null:C1517)
					
					$Obj_table.shortLabel:=formatString("label"; $Obj_table.originalName)
					
				Else 
					
					// User label
					$Obj_table.shortLabel:=$Obj_table[""].shortLabel
					
				End if 
				
				// ==============================================================
				//                          FIELDS
				// ==============================================================
				
				$Obj_table.fields:=New collection:C1472
				
				// Get expected field count
				C_LONGINT:C283($Lon_count)
				$Lon_count:=Num:C11($o.template.fields.count)
				
				C_LONGINT:C283($i)
				$i:=0
				C_OBJECT:C1216($Obj_tableModel)
				
				C_OBJECT:C1216($Obj_field)
				For each ($Obj_field; $Obj_tableList.fields)
					
					Case of 
							
							//……………………………………………………………………………………………………………
						: (Num:C11($Obj_field.id)#0)
							
							$Obj_field:=OB Copy:C1225($Obj_field)
							$Obj_field.originalName:=$Obj_field.name
							
							var $keyPath : Text
							var $tmp : Object
							var $keyPaths : Collection
							
							$keyPaths:=Split string:C1554($Obj_field.name; ".")
							$keyPaths.pop()  // we remove field leaf name, because we get info from id, not path
							
							$tmp:=$Obj_tableModel
							If ($keyPaths.length>0)  // is it a link?
								For each ($keyPath; $keyPaths)
									$tmp:=$tmp[$keyPath]  // get sub model if related field
								End for each 
							End if 
							
							// Add info from dataModel
							If ($tmp[String:C10($Obj_field.id)]#Null:C1517)
								
								$Obj_field:=ob_deepMerge($Obj_field; $tmp[String:C10($Obj_field.id)]; False:C215)
								
								
							End if 
							
							// Format name for the tag
							$Obj_field.name:=formatString("field-name"; $Obj_field.originalName)
							
							If ($Obj_field.label=Null:C1517)
								
								$Obj_field.label:=formatString("label"; $Obj_field.originalName)
								
							End if 
							
							If ($Obj_field.shortLabel=Null:C1517)
								
								$Obj_field.shortLabel:=formatString("label"; $Obj_field.originalName)
								
							End if 
							
							// Set binding type according to field information
							$Obj_field.bindingType:=This:C1470.fieldBinding($Obj_field; $Obj_in.formatters).bindingType
							
							//……………………………………………………………………………………………………………
						: ($Obj_field.name#Null:C1517)  // ie. relation
							
							$Obj_field:=OB Copy:C1225($Obj_field)
							
							$Obj_field.originalName:=$Obj_field.name
							
							var $tmp : Object
							var $keyPaths : Collection
							var $keyPath : Text
							$tmp:=$Obj_tableModel[$Obj_field.name]
							If ($tmp=Null:C1517)
								$keyPaths:=Split string:C1554($Obj_field.name; ".")
								If ($keyPaths.length>1)
									$tmp:=$Obj_tableModel
									For each ($keyPath; $keyPaths) Until ($tmp=Null:C1517)
										$tmp:=$tmp[$keyPath]
									End for each 
								End if 
							End if 
							
							If ($tmp#Null:C1517)
								$Obj_field:=ob_deepMerge($Obj_field; $tmp; False:C215)
							End if 
							
							// Format name for the tag
							$Obj_field.name:=formatString("field-name"; $Obj_field.originalName)
							
							If ($Obj_field.label=Null:C1517)
								
								$Obj_field.label:=formatString("label"; $Obj_field.originalName)
								
							End if 
							
							If ($Obj_field.shortLabel=Null:C1517)
								
								$Obj_field.shortLabel:=formatString("label"; $Obj_field.originalName)
								
							End if 
							
							// Set binding type according to field information
							//$Obj_field.bindingType:=This.fieldBinding($Obj_field; $Obj_in.formatters).bindingType
							
							//……………………………………………………………………………………………………………
						: ($i<$Lon_count)
							
							// Create a dummy fields to replace in template
							$Obj_field:=New object:C1471(\
								"name"; ""; \
								"originalName"; ""; \
								"label"; ""; \
								"shortLabel"; ""; \
								"bindingType"; "unknown"; \
								"type"; -1; \
								"fieldType"; -1; \
								"id"; -1; \
								"icon"; "")
							
							//……………………………………………………………………………………………………………
						Else 
							
							$Obj_field:=Null:C1517
							
							//……………………………………………………………………………………………………………
					End case 
					
					If ($Obj_field#Null:C1517)
						
						$Obj_table.fields.push($Obj_field)
						
					End if 
					
					$i:=$i+1
					
				End for each 
				
				If ($Lon_count>0)
					
					// If there is more fields in template than defined by user (ie. last fields not defined)
					// add dummy fields
					
					While ($Obj_table.fields.length<$Lon_count)
						
						$Obj_table.fields.push(New object:C1471(\
							"name"; ""; \
							"originalName"; ""; \
							"label"; ""; \
							"shortLabel"; ""; \
							"bindingType"; "unknown"; \
							"type"; -1; \
							"fieldType"; -1; \
							"id"; -1; \
							"icon"; ""))
						
					End while 
				End if 
				
				// ==============================================================
				//                     SEARCH FIELDS
				// ==============================================================
				
				If ($Obj_tableList.searchableField#Null:C1517)
					
					Case of 
							
							//……………………………………………………………………………………………………………
						: (Value type:C1509($Obj_tableList.searchableField)=Is object:K8:27)
							
							$Obj_table.searchableField:=formatString("field-name"; String:C10($Obj_tableList.searchableField.name))
							
							//……………………………………………………………………………………………………………
						: (Value type:C1509($Obj_tableList.searchableField)=Is collection:K8:32)
							
							$Obj_table.searchableField:=$Obj_tableList.searchableField.extract("name").map("col_formula"; Formula:C1597($1.result:=formatString("field-name"; String:C10($1.value)))).join(",")
							
							//……………………………………………………………………………………………………………
						: (Value type:C1509($Obj_tableList.searchableField)=Is text:K8:3)
							
							$Obj_table.sortField:=formatString("field-name"; String:C10($Obj_tableList.searchableField))
							
							//……………………………………………………………………………………………………………
					End case 
				End if 
				
				// ==============================================================
				//                        SORT FIELDS
				// ==============================================================
				
				If ($Obj_tableList.sortField#Null:C1517)
					
					Case of 
							
							//……………………………………………………………………………………………………………
						: (Value type:C1509($Obj_tableList.sortField)=Is object:K8:27)
							
							$Obj_table.sortField:=formatString("field-name"; String:C10($Obj_tableList.sortField.name))
							
							//……………………………………………………………………………………………………………
						: (Value type:C1509($Obj_tableList.sortField)=Is collection:K8:32)
							
							$Obj_table.sortField:=$Obj_tableList.sortField.extract("name").map("col_formula"; Formula:C1597($1.result:=formatString("field-name"; String:C10($1.value)))).join(",")
							
							//……………………………………………………………………………………………………………
						: (Value type:C1509($Obj_tableList.sortField)=Is text:K8:3)
							
							$Obj_table.sortField:=formatString("field-name"; String:C10($Obj_tableList.sortField))
							
							//……………………………………………………………………………………………………………
					End case 
					
				Else 
					
					// take searchable field as sort field if not defined yet
					$Obj_table.sortField:=$Obj_table.searchableField
					
					If (Length:C16(String:C10($Obj_table.sortField))=0)
						
						// and if no search field find the first one sortable in diplayed field
						For each ($Obj_field; $Obj_table.fields) Until ($Obj_table.sortField#Null:C1517)
							
							If (($Obj_field.fieldType#Is picture:K8:10)\
								 & ($Obj_field.fieldType#-1)\
								 & (Num:C11($Obj_field.id)#0))  // not image or not defined or not relation
								
								$Obj_table.sortField:=$Obj_field.name  // formatString ("field-name";String($Obj_field.originalName))
								
							End if 
						End for each 
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
					
					$Obj_table.sectionField:=formatString("field-name"; String:C10($Obj_tableList.sectionField.name))
					$Obj_table.sectionFieldBindingType:=""
					
					// Get format of section field$Obj_tableList
					If ($Obj_tableModel[String:C10($Obj_tableList.sectionField.id)]#Null:C1517)
						
						$Obj_field:=New object:C1471  // maybe get other info from  $Obj_tableList.fields
						$Obj_field:=ob_deepMerge($Obj_field; $Obj_tableModel[String:C10($Obj_tableList.sectionField.id)])
						
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
						$Col_actions:=actions("form"; New object:C1471(\
							"project"; $Obj_in.project; \
							"table"; $Obj_table.originalName; \
							"tableNumber"; $Obj_table.tableNumber; \
							"scope"; "table")).actions
						
						If ($Col_actions.length>0)
							
							$Obj_table.tableActions:=JSON Stringify:C1217(New object:C1471(\
								"actions"; $Col_actions))
							
						End if 
						
						$Col_actions:=actions("form"; New object:C1471(\
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
						
						$Col_actions:=actions("form"; New object:C1471(\
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
				$o.template.source:=$folder.platformPath
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
			
			RECORD.error("Invalid path: \""+$folder.path+"\"")
			
			If ($Obj_out.errors=Null:C1517)
				
				$Obj_out.errors:=New collection:C1472
				
			End if 
			
			$Obj_out.errors.push("Invalid path: "+$folder.path)
			
		End if 
	End for each 
	$0:=$Obj_out
	
	
Function fieldBinding
	C_OBJECT:C1216($0; $Obj_out)
	$Obj_out:=New object:C1471("success"; False:C215)
	
	C_OBJECT:C1216($1; $Obj_field)
	$Obj_field:=$1
	
	C_OBJECT:C1216($2; $Obj_formatters)
	$Obj_formatters:=$2
	
	Case of 
			
			// ----------------------------------------
		: ($Obj_field=Null:C1517)
			
			$Obj_out.errors:=New collection:C1472("field must be specified to fill binding type")
			
			// ----------------------------------------
		: ($Obj_field.type=Null:C1517)
			
			$Obj_out.errors:=New collection:C1472("field must be have a type to fill binding type")
			
			// ----------------------------------------
		Else 
			
			Case of 
					
					//________________________________________
				: (Value type:C1509($Obj_field.format)=Is object:K8:27)
					
					$Obj_out.format:=$Obj_field.format
					
					//________________________________________
				: (Value type:C1509($Obj_field.format)=Is text:K8:3)
					
					If (Value type:C1509($Obj_formatters)=Is object:K8:27)
						
						If (Value type:C1509($Obj_formatters[$Obj_field.format])=Is object:K8:27)
							
							$Obj_out.format:=$Obj_formatters[$Obj_field.format]
							
						Else 
							
							ob_error_add($Obj_out; "Unknown data formatter '"+$Obj_field.format+"'")
							
						End if 
						
					Else 
						
						ob_error_add($Obj_out; "No list of formatters provided to resolve '"+$Obj_field.format+"'")
						
					End if 
					
					// ........................................
			End case 
			
			If ($Obj_out.format#Null:C1517)
				
				If ((Length:C16(String:C10($Obj_out.format.binding))=0) | (String:C10($Obj_out.format.binding)=String:C10($Obj_out.format.name)))
					
					$Obj_out.bindingType:=String:C10($Obj_out.format.name)
					
				Else 
					
					$Obj_out.bindingType:=String:C10($Obj_out.format.binding)+","+String:C10($Obj_out.format.name)
					
				End if 
				
				$Obj_out.success:=True:C214
				
			End if 
			
			If (Length:C16(String:C10($Obj_out.bindingType))=0)
				
				If (Length:C16(String:C10($Obj_field.relatedDataClass))>0)
					
					$Obj_out.bindingType:="Transformable"
					$Obj_out.success:=True:C214
					
				Else 
					
					// set default value according to type (here type from 4d structure)
					If ($Obj_field.fieldType<SHARED.defaultFieldBindingTypes.length)
						
						$Obj_out.bindingType:=SHARED.defaultFieldBindingTypes[$Obj_field.fieldType]
						$Obj_out.success:=(Length:C16(String:C10($Obj_out.bindingType))>0)
						
					Else 
						
						ob_error_add($Obj_out; "No default format for type '"+String:C10($Obj_field.fieldType)+"'")
						
					End if 
				End if 
			End if 
	End case 
	
	$0:=$Obj_out