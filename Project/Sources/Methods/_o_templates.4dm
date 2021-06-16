//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : templates
// ID[9D729EF8EA04RC9E92BEF068I8B6CA17]
// Created 9-11-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// - Manage template and its children
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_withIcons)
C_LONGINT:C283($i; $l; $Lon_count; $Lon_parameters)
C_PICTURE:C286($Pic_file; $Pic_scaled)
C_TEXT:C284($Svg_root; $t; $Txt_name; $Txt_tableNumber; $Txt_template; $Txt_type)
C_OBJECT:C1216($file; $folder; $o; $Obj_color; $Obj_dataModel; $Obj_field)
C_OBJECT:C1216($Obj_in; $Obj_navigationTable; $Obj_out; $Obj_table; $Obj_tableList; $Obj_tableModel)
C_OBJECT:C1216($Obj_template; $Obj_userChoice; $Path_hostRoot; $Path_icon; $Path_manifest; $Path_root)
C_OBJECT:C1216($pathForm)
C_COLLECTION:C1488($Col_actions; $Col_catalog; $Col_path)

If (False:C215)
	C_OBJECT:C1216(_o_templates; $0)
	C_OBJECT:C1216(_o_templates; $1)
End if 

// TODO change recursion onChoice and byTable, each table have it's choice

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
		"success"; True:C214)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
// Check parameters
// ----------------------------------------------------
// XXX make clean with errors?
ASSERT:C1129(Value type:C1509($Obj_in.project)=Is object:K8:27)
ASSERT:C1129(Value type:C1509($Obj_in.path)=Is text:K8:3)

ASSERT:C1129(Value type:C1509($Obj_in.template)=Is object:K8:27)
$Obj_template:=$Obj_in.template
ASSERT:C1129(Value type:C1509($Obj_template.source)=Is text:K8:3)

// ----------------------------------------------------
// Manage template files according to type
// ----------------------------------------------------

// First template with recursivety else just copy the files
$Txt_type:=String:C10($Obj_template.type)

Case of 
		
		//________________________________________
	: ($Txt_type="folder")
		
		// Do not inject files
		
		//______________________________________________________
	: ($Txt_type="choice")
		
		// Later must be a user choice by table Feature #93726, here we take default one
		// in Feature #93726 make it choice a byTable=True
		$t:=$Obj_template.default
		
		// Check choice make by tag path
		If (Length:C16(String:C10($Obj_template.tag))>0)
			
			If (Length:C16(String:C10($Obj_in.tags[$Obj_template.tag]))>0)
				
				$t:=$Obj_in.tags[$Obj_template.tag]
				
			End if 
		End if 
		
		$t:=$Obj_template.source+$t+Folder separator:K24:12
		
		If (Length:C16(String:C10($Obj_template.projectTag))>0)
			
			$Txt_name:=String:C10($Obj_in.project[String:C10($Obj_template.projectTag)])
			
			If (Length:C16($Txt_name)>0)
				
				$pathForm:=_o_tmpl_form($Txt_name; String:C10($Obj_template.projectTag))
				
				If (Path to object:C1547($Txt_name).extension=SHARED.archiveExtension)  // Archive
					
					// Extract
					$o:=$pathForm.copyTo(Folder:C1567(Temporary folder:C486; fk platform path:K87:2); "template"; fk overwrite:K87:5)
					$t:=$o.platformPath
					
				Else 
					
					$t:=$pathForm.platformPath
					
				End if 
				
			Else 
				
				// Project file doesn't contain any custom template key
				
			End if 
			
		Else 
			
			// No projectTag in template manifest
			
		End if 
		
		$o:=OB Copy:C1225($Obj_in)
		
		$Obj_out.template:=ob_parseDocument($t+"manifest.json")
		
		If ($Obj_out.template.success)
			
			$o.template:=$Obj_out.template.value
			$o.template.source:=$t
			$o.template.parent:=$Obj_template.parent  // or $Obj_template?
			$o.projfile:=$Obj_in.projfile  // do not want a copy
			
			$Obj_out.template:=_o_templates($o)  // <================================== RECURSIVE
			
		Else 
			
			ob_error_combine($Obj_out; $Obj_out.template)
			
		End if 
		
		//________________________________________
	: ($Txt_type="tablesForms")
		
		// Manage root templates for all tables forms according to user choice
		
		// Get the user choice information
		$Obj_userChoice:=$Obj_in.project[String:C10($Obj_template.userChoiceTag)]  // list or detail from project
		
		// For each on tags here, maybe on data view instead?
		$Obj_out.tables:=New collection:C1472
		
		$Obj_out.success:=True:C214
		
		$Obj_dataModel:=$Obj_in.project.dataModel
		
		// Create table form for each table in data model
		For each ($Txt_tableNumber; $Obj_dataModel)
			
			// Get dataModel information
			$Obj_tableModel:=$Obj_dataModel[$Txt_tableNumber]
			
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
			$t:=Choose:C955(Length:C16(String:C10($Obj_tableList.form))>0; String:C10($Obj_tableList.form); $Obj_template.default)  // Use default if not defined
			
			If ($t[[1]]="/")  // custom form
				
				$pathForm:=_o_tmpl_form($t; String:C10($Obj_template.userChoiceTag))
				
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
					$Lon_count:=Num:C11($o.template.fields.count)
					
					$i:=0
					
					For each ($Obj_field; $Obj_tableList.fields)
						
						Case of 
								
								//……………………………………………………………………………………………………………
							: (Num:C11($Obj_field.id)#0)
								
								$Obj_field:=OB Copy:C1225($Obj_field)
								$Obj_field.originalName:=$Obj_field.name
								
								$Col_path:=Split string:C1554($Obj_field.name; ".")
								
								If ($Col_path.length>1)  // is it a link?
									
									$Obj_tableModel:=$Obj_tableModel[$Col_path[0]]  // get sub model if related field
									
								End if 
								
								// Add info from dataModel
								If ($Obj_tableModel[String:C10($Obj_field.id)]#Null:C1517)
									
									$Obj_field:=ob_deepMerge($Obj_field; $Obj_tableModel[String:C10($Obj_field.id)])
									
									// TODO instead of deep merge, try to not override left side, add option?
									
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
								$Obj_field.bindingType:=_o_storyboard(New object:C1471("action"; "fieldBinding"; "field"; $Obj_field; "formatters"; $Obj_in.formatters)).bindingType
								
								If ($Col_path.length>1)  // is it a link?
									
									// restore original table model
									$Obj_tableModel:=$Obj_dataModel[$Txt_tableNumber]
									
								End if 
								
								//……………………………………………………………………………………………………………
							: ($Obj_field.name#Null:C1517)  // ie. relation
								
								$Obj_field:=OB Copy:C1225($Obj_field)
								
								$Obj_field.originalName:=$Obj_field.name
								
								C_OBJECT:C1216($tmp)
								C_COLLECTION:C1488($keyPaths)
								C_TEXT:C284($keyPath)
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
									$Obj_field:=ob_deepMerge($Obj_field; $tmp)
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
								//$Obj_field.bindingType:=storyboard (New object("action";"fieldBinding";"field";$Obj_field;"formatters";$Obj_in.formatters)).bindingType
								
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
									 & ($Obj_field.fieldType#-1))  // not image or not defined
									
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
							
							$Obj_table.sectionFieldBindingType:=_o_storyboard(New object:C1471(\
								"action"; "fieldBinding"; \
								"field"; $Obj_field; \
								"formatters"; $Obj_in.formatters)).bindingType
							
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
					
					$Obj_out.template:=_o_templates($o)  // <================================== RECURSIVE
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
		
		//______________________________________________________
	: ($Txt_type="detailform")
		
		// Do nothing here, do not remove or tag will be replaced
		// The TEMPLATE method is called later after replacing some tag
		
		//________________________________________
		
	Else 
		
		// Default template management code, a copy with tag replacement
		
		Case of 
				
				//……………………………………………………………………………………………………………
			: (Value type:C1509($Obj_in.exclude)=Is text:K8:3)
				
				$Col_catalog:=doc_catalog($Obj_template.source; $Obj_in.exclude)
				
				//……………………………………………………………………………………………………………
			: (Value type:C1509($Obj_in.exclude)=Is collection:K8:32)
				
				$Col_catalog:=doc_catalog($Obj_template.source; JSON Stringify:C1217($Obj_in.exclude))
				
				//……………………………………………………………………………………………………………
			: ($Txt_type="main")
				
				//Folder($obj_template.source;fk platform path).files().extract("fullName")
				
				$Col_catalog:=doc_catalog($Obj_template.source; "*")
				
				//……………………………………………………………………………………………………………
			: (Bool:C1537($Obj_in.template.inject))
				
				$Col_catalog:=doc_catalog($Obj_template.source; JSON Stringify:C1217(SHARED.template.exclude))
				
				//……………………………………………………………………………………………………………
			Else 
				
				$Col_catalog:=doc_catalog($Obj_template.source)
				
				//……………………………………………………………………………………………………………
		End case 
		
		$Obj_out.template:=template(New object:C1471(\
			"source"; $Obj_template.source; \
			"target"; $Obj_in.path; \
			"tags"; $Obj_in.tags; \
			"caller"; $Obj_in.caller; \
			"catalog"; $Col_catalog\
			))
		
		$Obj_out.capabilities:=$Obj_template.capabilities
		
		ob_error_combine($Obj_out; $Obj_out.template)
		
		//________________________________________
End case 

// Then code for final template
Case of 
		
		//________________________________________
	: ($Txt_type="main")
		
		// Update Assets
		If (String:C10($Obj_template.assets.source)#"")
			
			$Obj_out.assets:=template(New object:C1471(\
				"source"; $Obj_template.assets.source; \
				"target"; $Obj_template.assets.target; \
				"catalog"; doc_catalog($Obj_template.assets.source)\
				))
			
			ob_error_combine($Obj_out; $Obj_out.assets)
			
			// Temporary or by default take app icon, later could be customizable by UI, and must be managed like AppIcon
			$Obj_out.theme:=New object:C1471(\
				"success"; False:C215)
			
			$file:=Folder:C1567($Obj_template.assets.source; fk platform path:K87:2).folder("AppIcon.appiconset").file("ios-marketing1024.png")
			$l:=SHARED.theme.colorjuicer.scale
			
			If ($l#1024)\
				 & ($l>0)
				
				READ PICTURE FILE:C678($file.platformPath; $Pic_file)
				CREATE THUMBNAIL:C679($Pic_file; $Pic_scaled; $l; $l)  // This change result of algo..., let tools scale using argument
				$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066)
				WRITE PICTURE FILE:C680($file.platformPath; $Pic_scaled; ".png")
				
			End if 
			
			$Obj_color:=colors(New object:C1471(\
				"action"; "juicer"; \
				"posix"; $file.path))
			
			If ($Obj_color.success)
				
				$Obj_out.theme.BackgroundColor:=$Obj_color.value
				$Obj_out.theme.BackgroundColor.name:="BackgroundColor"
				
				$Obj_out.theme.BackgroundColor.asset:=asset(New object:C1471(\
					"action"; "create"; \
					"target"; $Obj_template.assets.target+"NavigationBar"+Folder separator:K24:12; \
					"type"; "colorset"; \
					"space"; $Obj_out.theme.BackgroundColor.space; \
					"tags"; $Obj_out.theme.BackgroundColor))
				
				$Obj_color:=colors(New object:C1471(\
					"action"; "contrast"; \
					"color"; $Obj_out.theme.BackgroundColor))
				
				If ($Obj_color.success)
					
					$Obj_out.theme.ForegroundColor:=$Obj_color.value
					$Obj_out.theme.ForegroundColor.name:="ForegroundColor"
					
					$Obj_out.theme.ForegroundColor.asset:=asset(New object:C1471(\
						"action"; "create"; \
						"target"; $Obj_template.assets.target+"NavigationBar"+Folder separator:K24:12; \
						"type"; "colorset"; \
						"space"; $Obj_out.theme.ForegroundColor.space; \
						"tags"; $Obj_out.theme.ForegroundColor))
					
					$Obj_out.theme.success:=True:C214
					
				End if 
			End if 
			
			If (($l#1024)\
				 & ($l>0))
				
				$file.delete()  // delete scaled files
				
			End if 
			
			$Obj_in.theme:=$Obj_out.theme  // to pass to children
			
		End if 
		
		//________________________________________
	: ($Txt_type="navigation")
		
		// Get navigation tables as tag
		$Obj_in.tags.navigationTables:=dataModel(New object:C1471(\
			"action"; "tableCollection"; \
			"dataModel"; $Obj_in.project.dataModel; \
			"tag"; True:C214; \
			"tables"; $Obj_in.project.main.order)).tables
		
		// Compute table row height, not very responsive. Check if possible with storyboard
		$i:=$Obj_in.tags.navigationTables.length
		
		Case of 
				
				//……………………………………………………………………………………
			: ($i>10)
				
				$Obj_in.tags.navigationRowHeight:="-1"  // https://developer.apple.com/documentation/uikit/uitableviewautomaticdimension
				
				//……………………………………………………………………………………
			: ($i<3)
				
				$Obj_in.tags.navigationRowHeight:="300"
				
				//……………………………………………………………………………………
			: ($i<4)
				
				$Obj_in.tags.navigationRowHeight:="200"
				
				//……………………………………………………………………………………
			Else 
				
				$Obj_in.tags.navigationRowHeight:=String:C10(100+(100/$i))
				
				//……………………………………………………………………………………
		End case 
		
		// need asset?
		$Boo_withIcons:=Bool:C1537($Obj_template.assets.mandatory)\
			 | ($Obj_in.tags.navigationTables.query("icon != ''").length>0)
		
		For each ($Obj_table; $Obj_in.tags.navigationTables)
			
			If ($Boo_withIcons)
				
				$Obj_table.labelAlignment:="left"
				$Obj_table.navigationIcon:="Main"+$Obj_table.name
				
			Else 
				
				$Obj_table.labelAlignment:="center"
				$Obj_table.navigationIcon:=""
				
			End if 
		End for each 
		
		// Modify storyboards with navigation tables
		$Obj_out.storyboard:=_o_storyboard(New object:C1471(\
			"action"; "navigation"; \
			"template"; $Obj_template; \
			"target"; $Obj_in.path; \
			"tags"; $Obj_in.tags\
			))
		
		If (Not:C34($Obj_out.storyboard.success))
			
			$Obj_out.success:=False:C215
			
			ob_error_combine($Obj_out; $Obj_out.storyboard; "Storyboard for navigation template failed")
			
		End if 
		
		If ($Boo_withIcons)
			
			$Path_root:=COMPONENT_Pathname("fieldIcons")
			$Path_hostRoot:=COMPONENT_Pathname("host_fieldIcons")
			
			// If avigation need asset, create it
			$Obj_out.assets:=New collection:C1472  // result of asset operations
			
			For each ($Obj_table; $Obj_in.tags.navigationTables)
				
				If (Length:C16(String:C10($Obj_table[""].icon))=0)  // no icon defined
					
					If ($Obj_table[""].shortLabel#Null:C1517)
						
						// Generate asset using first table letter
						$file:=Folder:C1567(fk resources folder:K87:11).folder("images").file("missingIcon.svg")
						
						If (Asserted:C1132($file.exists; "Missing ressources: "+$file.path))
							
							$Svg_root:=DOM Parse XML source:C719($file.platformPath)
							
							If (Asserted:C1132(OK=1; "Failed to parse: "+$file.path))
								
								$t:=Choose:C955(Bool:C1537($Obj_template.shortLabel); $Obj_table[""].shortLabel; $Obj_table[""].label)
								
								If (Length:C16($t)>0)
									
									// Take first letter
									$t:=Uppercase:C13($t[[1]])
									
								Else 
									
									//%W-533.1
									$t:=Uppercase:C13($Obj_table[""].name[[1]])  // 4D table names are not empty
									//%W+533.1
									
								End if 
								
								DOM SET XML ELEMENT VALUE:C868($Svg_root; "/svg/textArea"; $t)
								
								$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file($Obj_in.project.product.bundleIdentifier+".svg")
								$file.delete()
								
								DOM EXPORT TO FILE:C862($Svg_root; $file.platformPath)
								
								DOM CLOSE XML:C722($Svg_root)
								
								$o:=asset(New object:C1471(\
									"action"; "create"; \
									"type"; "imageset"; \
									"tags"; New object:C1471("name"; "Main"+$Obj_table[""].name); \
									"source"; $file.platformPath; \
									"target"; $Obj_template.parent.assets.target+$Obj_template.assets.target+Folder separator:K24:12; \
									"format"; $Obj_template.assets.format; \
									"size"; $Obj_template.assets.size\
									))
								
								$Obj_out.assets.push($o)
								ob_error_combine($Obj_out; $o)
								
							End if 
						End if 
					End if 
					
				Else 
					
					If (Position:C15("/"; $Obj_table[""].icon)=1)
						
						// User icon
						$Path_icon:=$Path_hostRoot.file(Substring:C12($Obj_table[""].icon; 2))
						
					Else 
						
						$Path_icon:=$Path_root.file($Obj_table[""].icon)
						
					End if 
					
					$o:=asset(New object:C1471(\
						"action"; "create"; \
						"type"; "imageset"; \
						"tags"; New object:C1471("name"; "Main"+$Obj_table[""].name); \
						"source"; $Path_icon.platformPath; \
						"target"; $Obj_template.parent.assets.target+$Obj_template.assets.target+Folder separator:K24:12; \
						"format"; $Obj_template.assets.format; \
						"size"; $Obj_template.assets.size))
					
					$Obj_out.assets.push($o)
					ob_error_combine($Obj_out; $o)
					
				End if 
				
			End for each 
		End if 
		
		$Obj_out.tags:=New object:C1471(\
			"navigationTables"; $Obj_in.tags.navigationTables)  // Tag to transmit
		
		//________________________________________
	: ($Txt_type="ls")
		
		// Specific code for launch screen
		If (Value type:C1509($Obj_template.assets)=Is object:K8:27)
			
			ASSERT:C1129(String:C10($Obj_template.parent.assets.source)#"")  // Suppose main template is parent, to get app icon
			
			$Obj_out.assets:=New object:C1471
			
			ARRAY TEXT:C222($tTxt_keys; 0x0000)
			OB GET PROPERTY NAMES:C1232($Obj_template.assets; $tTxt_keys)
			
			For ($i; 1; Size of array:C274($tTxt_keys); 1)
				
				// Hardcoding image path (maybe could do better)
				Case of 
						
						//________________________________________
					: ($tTxt_keys{$i}="center")
						
						// Temporary or by default take app icon, later could be customizable by UI, and must be managed like AppIcon
						$file:=Folder:C1567($Obj_template.parent.assets.source; fk platform path:K87:2).folder("AppIcon.appiconset").file("ios-marketing1024.png")
						
						//________________________________________
					: ($tTxt_keys{$i}="background")
						
						$file:=Folder:C1567(fk resources folder:K87:11).folder("images").file("monochrome.svg")
						
						// Inject color on background if defined
						If ((Bool:C1537(SHARED.launchScreen.useThemeColor))\
							 & (Value type:C1509($Obj_in.theme.BackgroundColor)=Is object:K8:27))
							
							$o:=colors(New object:C1471(\
								"action"; "rgbtohex"; \
								"color"; $Obj_in.theme.BackgroundColor\
								))
							
							If ($o.success)
								
								$Obj_in.tags.launchScreenBackgroundColor:=$o.value
								
							End if 
						End if 
						
						If (String:C10($Obj_in.tags.launchScreenBackgroundColor)#"")
							
							If (Asserted:C1132($file.exists; "Missing ressources: "+$file.path))
								
								$Svg_root:=DOM Parse XML source:C719($file.platformPath)
								
								If (Asserted:C1132(OK=1; "Failed to parse: "+$file.path))
									
									DOM SET XML ATTRIBUTE:C866(DOM Find XML element:C864($Svg_root; "/svg/rect"); \
										"fill"; $Obj_in.tags.launchScreenBackgroundColor)
									
									$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+".svg")
									DOM EXPORT TO FILE:C862($Svg_root; $file.platformPath)
									
									DOM CLOSE XML:C722($Svg_root)
									
								End if 
							End if 
						End if 
						
						//________________________________________
					Else 
						
						$file:=Null:C1517
						
						//________________________________________
				End case 
				
				If ($file#Null:C1517)
					
					$o:=$Obj_template.assets[$tTxt_keys{$i}]
					
					$Obj_out.assets[$tTxt_keys{$i}]:=asset(New object:C1471(\
						"action"; "create"; \
						"source"; $file.platformPath; \
						"target"; $Obj_template.parent.assets.target+$o.target+Folder separator:K24:12; \
						"tags"; New object:C1471("name"; $o.name); \
						"type"; $o.type; \
						"format"; $o.format; \
						"size"; $o.size; \
						"sizes"; $o.sizes\
						))
					
					ob_error_combine($Obj_out; $Obj_out.assets[$tTxt_keys{$i}])
					
				End if 
			End for 
		End if 
		
		//________________________________________
	: ($Txt_type="listform")
		
		If ($Obj_out.template.success)  // we have copied the source in previous case of
			
			$Obj_out.success:=False:C215
			
			$Obj_out.project:=XcodeProjInject(New object:C1471(\
				"node"; $Obj_out.template; \
				"mapping"; $Obj_in.projfile.mapping; \
				"proj"; $Obj_in.projfile.value; \
				"target"; $Obj_in.path; \
				"uuid"; $Obj_template.parent.parent.uuid\
				))
			
			$Obj_in.projfile.mustSave:=True:C214  // project modified
			
		End if 
		
		// If (Bool(featuresFlags._103505))
		$Obj_out.storyboard:=_o_storyboard(New object:C1471(\
			"action"; "listform"; \
			"template"; $Obj_template; \
			"target"; $Obj_in.path; \
			"tags"; $Obj_in.tags\
			))
		
		// End if
		
		//________________________________________
	: ($Txt_type="detailform")
		
		// XXX factorize with navigation template code for image?
		
		$Obj_in.tags.table.detailFields:=$Obj_in.tags.table.fields
		
		// Need asset?
		$Boo_withIcons:=Bool:C1537($Obj_template.assets.mandatory)\
			 | ($Obj_in.tags.table.detailFields.query("icon != ''").length>0)
		
		// Create by field icon alignment or icon name
		For each ($Obj_field; $Obj_in.tags.table.detailFields)
			
			If ($Boo_withIcons)
				
				$Obj_field.labelAlignment:="left"
				$Obj_field.detailIcon:=$Obj_in.tags.table.name+"Detail"+$Obj_field.name
				
			Else 
				
				$Obj_field.labelAlignment:="center"
				$Obj_field.detailIcon:=""
				
			End if 
		End for each 
		
		// Create the icons
		If ($Boo_withIcons)
			
			$Path_root:=COMPONENT_Pathname("fieldIcons")
			$Path_hostRoot:=COMPONENT_Pathname("host_fieldIcons")
			
			// If need asset, create it
			$Obj_out.assets:=New collection:C1472  // result of asset operations
			
			If (Value type:C1509($Obj_template.assets)#Is object:K8:27)
				
				$Obj_template.assets:=New object:C1471(\
					"format"; "png")  // Fill missing information for detail template only
				
			End if 
			
			If ($Obj_template.assets.target=Null:C1517)
				
				$Obj_template.assets.target:="___TABLE___/Detail"  // Default path for detail template resource
				
			End if 
			
			For each ($Obj_field; $Obj_in.tags.table.detailFields)
				
				If (Length:C16(String:C10($Obj_field.icon))=0)  // no icon defined
					
					// Generate asset using first table letter
					$file:=Folder:C1567(fk resources folder:K87:11).folder("images").file("missingIcon.svg")
					
					If (Asserted:C1132($file.exists; "Missing ressources: "+$file.path))
						
						$Svg_root:=DOM Parse XML source:C719($file.platformPath)
						
						If (Asserted:C1132(OK=1; "Failed to parse: "+$file.path))
							
							$t:=Choose:C955(Bool:C1537($Obj_template.shortLabel); $Obj_field.shortLabel; $Obj_field.label)
							
							Case of 
									
									//……………………………………………………………………………………………………………
								: (Length:C16($t)>0)
									
									// Take first letter
									$t:=Uppercase:C13($t[[1]])
									
									//……………………………………………………………………………………………………………
								: (Length:C16($Obj_field.name)>0)
									
									//%W-533.1
									$t:=Uppercase:C13($Obj_field.name[[1]])
									//%W+533.1
									
									//……………………………………………………………………………………………………………
							End case 
							
							If (Length:C16($t)>0)  // Else no image for dummy fields
								
								DOM SET XML ELEMENT VALUE:C868($Svg_root; "/svg/textArea"; $t)
								
								$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+".svg")
								DOM EXPORT TO FILE:C862($Svg_root; $file.platformPath)
								
								DOM CLOSE XML:C722($Svg_root)
								
								$Obj_out.assets.push(asset(New object:C1471(\
									"action"; "create"; \
									"type"; "imageset"; \
									"tags"; New object:C1471("name"; $Obj_in.tags.table.name+"Detail"+$Obj_field.name); \
									"source"; $file.platformPath; \
									"target"; $Obj_template.parent.parent.assets.target+Replace string:C233(Process_tags($Obj_template.assets.target; $Obj_in.tags; New collection:C1472("filename")); "/"; Folder separator:K24:12)+Folder separator:K24:12; \
									"format"; $Obj_template.assets.format; \
									"size"; $Obj_template.assets.size)))
								
							End if 
						End if 
					End if 
					
				Else   // There is an icon defined
					
					If (Position:C15("/"; $Obj_field.icon)=1)
						
						// Custom icon
						$Path_icon:=$Path_hostRoot.file(Substring:C12($Obj_field.icon; 2))
						
					Else 
						
						// Product icon
						$Path_icon:=$Path_root.file($Obj_field.icon)
						
					End if 
					
					$o:=asset(New object:C1471(\
						"action"; "create"; \
						"type"; "imageset"; \
						"tags"; New object:C1471("name"; $Obj_in.tags.table.name+"Detail"+$Obj_field.name); \
						"source"; $Path_icon.platformPath; \
						"target"; $Obj_template.parent.parent.assets.target+Replace string:C233(Process_tags($Obj_template.assets.target; $Obj_in.tags; New collection:C1472("filename")); "/"; Folder separator:K24:12)+Folder separator:K24:12; \
						"format"; $Obj_template.assets.format; \
						"size"; $Obj_template.assets.size))
					
					$Obj_out.assets.push($o)
					ob_error_combine($Obj_out; $o)
					
				End if 
			End for each 
		End if 
		
		// Standard code to copy template (not done before tags replacement, that's why nothing is done in first case of)
		$Obj_out.template:=template(New object:C1471(\
			"source"; $Obj_template.source; \
			"target"; $Obj_in.path; \
			"tags"; $Obj_in.tags; \
			"caller"; $Obj_in.caller; \
			"catalog"; doc_catalog($Obj_template.source; JSON Stringify:C1217(SHARED.template.exclude))))
		
		$Obj_out.project:=XcodeProjInject(New object:C1471(\
			"node"; $Obj_out.template; \
			"mapping"; $Obj_in.projfile.mapping; \
			"proj"; $Obj_in.projfile.value; \
			"target"; $Obj_in.path; \
			"uuid"; ob_inHierarchy($Obj_template; "uuid").uuid))
		
		ob_error_combine($Obj_out; $Obj_out.project)
		
		$Obj_in.projfile.mustSave:=True:C214  // project modified
		
		// Manage template elements duplication
		
		$Obj_out.storyboard:=_o_storyboard(New object:C1471(\
			"action"; "detailform"; \
			"template"; $Obj_template; \
			"target"; $Obj_in.path; \
			"tags"; $Obj_in.tags))
		
		If (Not:C34($Obj_out.storyboard.success))  // just in case no errors is generated and success is false
			
			$Obj_out.success:=False:C215
			ob_error_combine($Obj_out; $Obj_out.storyboard; "detail form storyboard creation failed for table "+$Obj_in.tags.table.name)
			
		End if 
		
		//________________________________________
		// Else // (case) Nothing to do
		
		//________________________________________
End case 

// ----------------------------------------------------
// Inject source in project if template request it
// ----------------------------------------------------

If (Bool:C1537($Obj_template.inject))
	
	$Obj_out.project:=XcodeProjInject(New object:C1471(\
		"node"; $Obj_out.template; \
		"mapping"; $Obj_in.projfile.mapping; \
		"proj"; $Obj_in.projfile.value; \
		"target"; $Obj_in.path; \
		"uuid"; ob_inHierarchy($Obj_template; "uuid").uuid))
	
End if 

// ----------------------------------------------------
// Install additionnal sdk defined by name
// ----------------------------------------------------

If (Value type:C1509($Obj_template.sdk)=Is object:K8:27)
	
	If (Length:C16(String:C10($Obj_template.sdk.name))>0)
		
		$Obj_out.sdk:=sdk(New object:C1471(\
			"action"; "installAdditionnalSDK"; \
			"template"; $Obj_template; \
			"target"; $Obj_in.path))
		ob_error_combine($Obj_out; $Obj_out.sdk)
		
	End if 
End if 

// ----------------------------------------------------
// Read xcode project at destination
// ----------------------------------------------------
If ($Obj_in.projfile=Null:C1517)
	
	$Obj_in.projfile:=XcodeProj(New object:C1471(\
		"action"; "read"; \
		"path"; $Obj_in.path))
	ob_error_combine($Obj_out; $Obj_in.projfile)
	
	XcodeProj(New object:C1471(\
		"action"; "mapping"; \
		"projObject"; $Obj_in.projfile))
	
	// no return, mapping is added to projfile
	
End if 

$Obj_out.projfile:=$Obj_in.projfile

// ----------------------------------------------------
// Template has children template?
// ----------------------------------------------------
If (Value type:C1509($Obj_template.children)=Is collection:K8:32)
	
	$Obj_out.children:=New collection:C1472
	
	// For each children template
	For each ($Txt_template; $Obj_template.children)
		
		// Read its manifest
		$Path_manifest:=COMPONENT_Pathname("templates").folder($Txt_template).file("manifest.json")
		
		$o:=OB Copy:C1225($Obj_in)
		
		If ($Path_manifest.exists)
			
			// Load the manifest
			$o.template:=JSON Parse:C1218($Path_manifest.getText())
			
		Else 
			
			$o.template:=New object:C1471
			
		End if 
		
		$o.template.source:=$Path_manifest.parent.platformPath
		$o.template.parent:=$Obj_template
		$o.projfile:=$Obj_in.projfile  // do not want a copy
		
		$o:=_o_templates($o)  // <================================== RECURSIVE
		$Obj_out.children.push($o)
		ob_error_combine($Obj_out; $o)
		
		// transmit tags created
		If (Value type:C1509($o.template.tags)=Is object:K8:27)
			
			$Obj_in.tags:=ob_deepMerge($Obj_in.tags; $o.template.tags)
			
		End if 
	End for each 
End if 

// ----------------------------------------------------
// Manage the project file for main template
// ----------------------------------------------------
If (($Txt_type="main"))
	
	// / Possible files near the projet file
	If (Value type:C1509($Obj_in.project.$project)=Is object:K8:27)
		
		$t:="main"  // XXX maybe later a list
		
		If (Test path name:C476(String:C10($Obj_in.project.$project.root)+$t)=Is a folder:K24:2)
			
			$o:=New object:C1471(\
				"template"; New object:C1471(\
				"name"; "project"+$t; \
				"inject"; True:C214; \
				"source"; $Obj_in.project.$project.root+$t+Folder separator:K24:12; \
				"parent"; $Obj_template); \
				"project"; $Obj_in.project; \
				"path"; $Obj_in.path; \
				"projfile"; $Obj_in.projfile)
			
			$Obj_out["project"+$t]:=_o_templates($o)  // <================================== RECURSIVE
			
		End if 
	End if 
	
	// /    Inject all SDK
	If (String:C10($Obj_template.sdk.frameworks)#"")
		
		$Obj_out.sdk:=sdk(New object:C1471(\
			"action"; "inject"; \
			"projfile"; $Obj_out.projfile; \
			"folder"; $Obj_template.sdk.frameworks; \
			"target"; $Obj_in.path))
		
		ob_error_combine($Obj_out; $Obj_out.sdk)
		
	End if 
	
	// Add data from formatters definition
	$Obj_out.formatters:=formatters(New object:C1471(\
		"action"; "extract"; \
		"formatters"; $Obj_in.formatters; \
		"dataModel"; $Obj_in.project.dataModel))
	
	If ($Obj_out.formatters.success)
		
		// pass the collection of formatters and generate it
		$Obj_out.formatters:=formatters(New object:C1471(\
			"action"; "generate"; \
			"formatters"; $Obj_out.formatters.formatters; \
			"tags"; $Obj_in.tags; \
			"target"; $Obj_in.path))
		
		If ($Obj_out.formatters.success)
			
			// If (Bool(featuresFlags._100990))
			// Add all files provided
			$o:=XcodeProjInject(New object:C1471(\
				"node"; $Obj_out.formatters; \
				"mapping"; $Obj_out.projfile.mapping; \
				"proj"; $Obj_out.projfile.value; \
				"target"; $Obj_in.path; \
				"uuid"; $Obj_in.template.uuid))
			
			// Else
			//  // * Formatters.strings file has been generated, add it
			//If (Length(String($Obj_out.formatters.target))>0)
			//$Obj_out.formatters:=XcodeProjInject (New object("path";$Obj_out.formatters.target;"mapping";$Obj_out.projfile.mapping;"proj";$Obj_out.projfile.value;"target";$Obj_in.path;"types";New collection();"uuid";$Obj_in.template.uuid))
			// End if
			// End if
			
		End if 
	End if 
	
	ob_error_combine($Obj_out; $Obj_out.formatters)
	
	If (Bool:C1537($Obj_in.project.server.pushNotification))
		
		$o:=New object:C1471(\
			"template"; New object:C1471(\
			"name"; "pushNotification"; \
			"inject"; True:C214; \
			"source"; COMPONENT_Pathname("templates").folder("pushNotification").platformPath; \
			"parent"; $Obj_template); \
			"project"; $Obj_in.project; \
			"path"; $Obj_in.path; \
			"projfile"; $Obj_in.projfile)
		
		$Obj_out["pushNotification"]:=_o_templates($o)  // <================================== RECURSIVE
		
	End if 
	
	// /  Save project file if has been modified
	If (Bool:C1537($Obj_out.projfile.mustSave))
		
		$Obj_out.projfile:=XcodeProj(New object:C1471(\
			"action"; "write"; \
			"object"; $Obj_out.projfile.value; \
			"project"; $Obj_in.tags.product; \
			"path"; $Obj_out.projfile.path))
		
		// PRODUCT tag for PBXProject could be removed by write process
		Process_tags_on_file($Obj_out.projfile.path; $Obj_out.projfile.path; $Obj_in.tags; New collection:C1472("project.pbxproj"))
		
		If (Not:C34(Bool:C1537($Obj_out.projfile.success)))
			
			ob_error_combine($Obj_out; $Obj_out.projfile; "Failed to write project file to "+$Obj_out.projfile.path)
			
		End if 
	End if 
End if 

// ----------------------------------------------------
// transmit capabilities
// ----------------------------------------------------

If (Value type:C1509($Obj_out.template)=Is object:K8:27)
	$Obj_out.template.capabilities:=$Obj_template.capabilities
End if 

// ----------------------------------------------------
// Compute status
// ----------------------------------------------------

$Obj_out.success:=Not:C34(ob_error_has($Obj_out))

// ----------------------------------------------------
// Return
$0:=$Obj_out

// ----------------------------------------------------
// End