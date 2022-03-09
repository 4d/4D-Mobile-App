//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : storyboard
// Created 27-6-2017 by Eric Marchand
// ----------------------------------------------------
// Description:
// manage storyboard xml
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_buffer)
C_LONGINT:C283($Lon_i; $Lon_j; $Lon_parameters; $Lon_ids; $Lon_length)
C_OBJECT:C1216($Dom_; $Dom_child; $Dom_root)
C_TEXT:C284($Txt_buffer; $Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
C_OBJECT:C1216($File_; $Obj_color; $Obj_in; $Obj_out; $Obj_element; $Obj_table; $Obj_field; $Obj_tag; $Obj_storyboardID)
C_COLLECTION:C1488($Col_; $Col_elements)
C_VARIANT:C1683($Var_field)

If (False:C215)
	C_OBJECT:C1216(_o_storyboard; $0)
	C_OBJECT:C1216(_o_storyboard; $1)
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
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Asserted:C1132($Obj_in.action#Null:C1517; "Missing the tag \"action\""))
	
	Case of 
			
			//______________________________________________________
		: ($Obj_in.action="fieldBinding")
			
			Case of 
					
					// ----------------------------------------
				: ($Obj_in.field=Null:C1517)
					
					$Obj_out.errors:=New collection:C1472("field must be specified to fill binding type")
					
					// ----------------------------------------
				: ($Obj_in.field.type=Null:C1517)
					
					$Obj_out.errors:=New collection:C1472("field must be have a type to fill binding type")
					
					// ----------------------------------------
				Else 
					
					$Obj_field:=$Obj_in.field
					
					Case of 
							
							//________________________________________
						: (Value type:C1509($Obj_field.format)=Is object:K8:27)
							
							$Obj_out.format:=$Obj_field.format
							
							//________________________________________
						: (Value type:C1509($Obj_field.format)=Is text:K8:3)
							
							If (Value type:C1509($Obj_in.formatters)=Is object:K8:27)
								
								If (Value type:C1509($Obj_in.formatters[$Obj_field.format])=Is object:K8:27)
									
									$Obj_out.format:=$Obj_in.formatters[$Obj_field.format]
									
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
						
						If (Length:C16(String:C10($Obj_in.field.relatedDataClass))>0)
							
							$Obj_out.bindingType:="Transformable"
							$Obj_out.success:=True:C214
							
						Else 
							
							// set default value according to type (here type from 4d structure)
							If ($Obj_field.fieldType<SHARED.defaultFieldBindingTypes.length)
								
								$Obj_out.bindingType:=SHARED.defaultFieldBindingTypes[$Obj_in.field.fieldType]
								$Obj_out.success:=(Length:C16(String:C10($Obj_out.bindingType))>0)
								
							Else 
								
								ob_error_add($Obj_out; "No default format for type '"+String:C10($Obj_field.fieldType)+"'")
								
							End if 
						End if 
					End if 
					
					// ----------------------------------------
			End case 
			
			//______________________________________________________
		: ($Obj_in.action="randomId")  // Return one random id for storyboard xml element
			
			$Txt_buffer:=Generate UUID:C1066
			$Txt_buffer:=Substring:C12($Txt_buffer; 1; 3)+"-"+Substring:C12($Txt_buffer; 4; 2)+"-"+Substring:C12($Txt_buffer; 7; 3)
			
			$Obj_out.value:=$Txt_buffer
			$Obj_out.success:=True:C214
			
			//______________________________________________________
		: ($Obj_in.action="randomIds")  // Return `length` random id for storyboard xml element
			
			$Obj_out.value:=New collection:C1472
			
			For ($Lon_i; 1; $Obj_in.length; 1)
				
				$Txt_buffer:=Generate UUID:C1066
				$Txt_buffer:=Substring:C12($Txt_buffer; 1; 3)+"-"+Substring:C12($Txt_buffer; 4; 2)+"-"+Substring:C12($Txt_buffer; 7; 3)
				
				$Obj_out.value.push($Txt_buffer)
				
			End for 
			
			// XXX maybe add a list of forbidden id from current storyboard, then check if collection have distinct element
			// storyboard (New object("action";"attributelist";"path";$Obj_in.path;"attribute";"id"))
			// and do a while value.count < $Obj_in.length
			
			//______________________________________________________
		: ($Obj_in.action="object")
			
			If ($Obj_in.path#Null:C1517)
				
				// Load as object
				
				$Obj_out:=_o_xml_fileToObject($Obj_in.path)
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("path  must be specified")
				
			End if 
			
			//______________________________________________________
		: ($Obj_in.action="navigation")
			
			$Obj_out.doms:=New collection:C1472()
			
			If ($Obj_in.template.storyboard=Null:C1517)
				
				$Obj_in.template.storyboard:=$Obj_in.template.parent[$Obj_in.action].storyboard
				
			End if 
			
			$File_:=Folder:C1567($Obj_in.template.source; fk platform path:K87:2).file(String:C10($Obj_in.template.storyboard))
			
			If ($File_.exists)
				
				$Dom_root:=_o_xml("load"; $File_)
				
				// Look up first all the elements. Dom could be modifyed
				For each ($Obj_element; $Obj_in.template.elements)
					
					If (Length:C16(String:C10($Obj_element.xpath))>0)
						
						//%W-533.1
						If ($Obj_element.xpath[[1]]#"/")
							//%W+533.1
							
							$Obj_element.xpath:="/"+$Obj_element.xpath
							
						End if 
						
						$Obj_element.dom:=$Dom_root.findByXPath($Obj_element.xpath)
						
						If (Not:C34($Obj_element.dom.success))
							
							$Obj_element.dom:=Null:C1517
							ASSERT:C1129(False:C215; "Invalid xpath "+$Obj_element.xpath+" for file "+$File_.path)
							
						End if 
						
					Else 
						
						$Lon_length:=Length:C16(String:C10($Obj_element.tagInterfix))
						
						Case of 
								
								// ----------------------------------------
							: ($Lon_length=2)
								
								$Obj_element.dom:=$Dom_root.findById("TAG-"+$Obj_element.tagInterfix+"-001")
								
								If (Not:C34($Obj_element.dom.success))
									
									$Obj_element.dom:=Null:C1517
									ASSERT:C1129(False:C215; "Root element with id 'TAG-"+$Obj_element.tagInterfix+"-001' not found for file "+$File_.path)
									
								End if 
								
								// ----------------------------------------
							: ($Lon_length>0)
								
								ASSERT:C1129(False:C215; "Element 'tagInterfix' defined in manifest.json "+$Obj_element.tagInterfix+" must have exactly two caracters")
								
								// ----------------------------------------
							Else 
								
								ASSERT:C1129(False:C215; "No xpath defined for template file "+$File_.path+" to find element "+JSON Stringify:C1217($Obj_element))
								
								// ----------------------------------------
						End case 
					End if 
					
					If ($Obj_element.dom#Null:C1517)
						
						If ($Obj_element.insertInto=Null:C1517)
							$Obj_element.insertInto:=$Obj_element.dom.parent()
						End if 
						
						$Lon_ids:=Num:C11($Obj_element.idCount)
						
						If ($Lon_ids=0)  // idCount, not defined, try to count into storyboard
							
							$Dom_child:=$Obj_element.dom  // 001 must be encapsulated node
							$Lon_ids:=0
							
							While ($Dom_child.success)
								
								$Lon_ids:=$Lon_ids+1
								$Dom_child:=$Obj_element.dom.findById("TAG-"+$Obj_element.tagInterfix+"-"+String:C10($Lon_ids+1; "##000"))
								
							End while 
							
							If ($Lon_ids=1)
								
								$Lon_ids:=32  // default value if not found
								
							End if 
						End if 
						
						$Obj_element.idCount:=$Lon_ids
						
						If (Length:C16(String:C10($Obj_element.insertMode))=0)
							
							$Obj_element.insertMode:="append"
							
						End if 
					End if 
				End for each 
				
				// For each table create a storyboard id shared by all xml elements
				
				For each ($Obj_table; $Obj_in.tags.navigationTables)
					
					$Obj_table.segueDestinationId:=_o_storyboard(New object:C1471("action"; "randomId")).value
					
				End for each 
				
				// For each element... (scene, cell, ...)
				For each ($Obj_element; $Obj_in.template.elements)
					
					If ($Obj_element.dom#Null:C1517)
						
						// ... and table
						$Lon_j:=0
						
						For each ($Obj_table; $Obj_in.tags.navigationTables)
							
							$Lon_j:=$Lon_j+1  // pos
							
							// set tags
							$Obj_in.tags.table:=$Obj_table
							
							If (Length:C16(String:C10($Obj_element.tagInterfix))>0)
								
								$Obj_in.tags.tagInterfix:=$Obj_element.tagInterfix
								$Obj_in.tags.storyboardIDs:=_o_storyboard(New object:C1471("action"; "randomIds"; "length"; $Obj_element.idCount)).value
								
							End if 
							
							// Insert after processing tags
							$Txt_buffer:=$Obj_element.dom.export().variable
							$Txt_buffer:=Process_tags($Txt_buffer; $Obj_in.tags; $Obj_in.template.tagtypes)
							
							$Dom_:=Null:C1517
							
							If (Bool:C1537($Obj_element.insertInto.success))
								
								Case of 
										
										// ----------------------------------------
									: ($Obj_element.insertMode="append")
										
										$Dom_:=$Obj_element.insertInto.append($Txt_buffer)
										
										// ----------------------------------------
									: ($Obj_element.insertMode="first")
										
										$Dom_:=$Obj_element.insertInto.insertFirst($Txt_buffer)
										
										// ----------------------------------------
									: ($Obj_element.insertMode="iteration")
										
										$Dom_:=$Obj_element.insertInto.insertAt($Txt_buffer; $Lon_j)
										
										// ----------------------------------------
								End case 
								
								If ($Dom_#Null:C1517)
									
									ob_removeFormula($Dom_)  // For debugging purpose remove all formula
									
								End if 
								
								$Obj_out.doms.push($Dom_)
								
							Else 
								
								ob_error_add($Obj_out; "Failed to nsert after processing tags '"+$Txt_buffer+"'")
								
							End if 
						End for each 
						
						// Remove originals template element
						$Obj_element.dom.remove()
						
					End if 
				End for each 
				
				// Save file at destination after replacing tags
				$Txt_buffer:=$Dom_root.export().variable
				$Dom_root.close()
				$Txt_buffer:=Process_tags($Txt_buffer; $Obj_in.tags; New collection:C1472("navigation.storyboard"))
				
				$File_:=Folder:C1567($Obj_in.target; fk platform path:K87:2).file(String:C10($Obj_in.template.storyboard))
				$File_.setText($Txt_buffer; "UTF-8"; Document with CRLF:K24:20)
				
				$Obj_out.format:=_o_storyboard(New object:C1471(\
					"action"; "format"; \
					"path"; $File_))
				
				$Obj_out.success:=True:C214  // XXX maybe better error managing, take into account all "doms"
				
			Else   // Not a document
				
				ASSERT:C1129(dev_Matrix; "Missing "+$Obj_in.action+" storyboard")
				$Obj_out.errors:=New collection:C1472("Missing "+$Obj_in.action+" storyboard")
				
			End if 
			
			//______________________________________________________
		: ($Obj_in.action="detailform")
			
			$Obj_out.doms:=New collection:C1472()
			
			If ($Obj_in.template.storyboard=Null:C1517)  // set default path if not defined
				
				$Obj_in.template.storyboard:=$Obj_in.template.parent[$Obj_in.action].storyboard
				
			End if 
			
			C_OBJECT:C1216($Folder_template)
			$Folder_template:=Folder:C1567($Obj_in.template.source; fk platform path:K87:2)
			$File_:=$Folder_template.file(String:C10($Obj_in.template.storyboard))
			$Dom_root:=_o_xml("load"; $File_)
			
			If ($Dom_root.success)
				
				$Txt_buffer:=$File_.getText()
				
				If (Length:C16($Txt_buffer)>0)  // a little check on record action if needed to inject it
					
					If ($Obj_in.tags.table.recordActions#Null:C1517)
						
						$Txt_cmd:="___ENTITY_ACTIONS___"
						
						If (Position:C15($Txt_cmd; $Txt_buffer)=0)
							
							ob_warning_add($Obj_out; "Detail template storyboard '"+$File_.path+"'do not countains action tag "+$Txt_cmd)
							
							// XXX here could fix by dom manipulation instead of warn (some code in #106033) (fix on source or in destination?)
							
						End if 
					End if 
				End if 
				
				If ($Obj_in.template.elements=Null:C1517)
					
					// Elements not defined in manifest, try to compute it using storyboard XMLs
					ARRAY TEXT:C222($tTxt_result; 0)
					
					Case of 
							// ----------------------------------------
						: (Rgx_ExtractText("TAG-(.?.?)-001"; $Txt_buffer; "1"; ->$tTxt_result)=0)
							
							$Col_:=New collection:C1472()
							ARRAY TO COLLECTION:C1563($Col_; $tTxt_result)
							$Col_:=$Col_.distinct()
							$Col_:=$Col_.map("col_valueToObject"; "tagInterfix")
							
							$Obj_in.template.elements:=$Col_
							
							// ----------------------------------------
						: (Value type:C1509($Obj_in.template.elementsID)=Is collection:K8:32)  // alernative way not documented, declare id of elements
							
							$Col_:=New collection:C1472()
							C_TEXT:C284($Txt_id)
							For each ($Txt_id; $Obj_in.template.elementsID)
								
								$Obj_element:=New object:C1471()
								$Obj_element.dom:=$Dom_root.findById($Txt_id)
								$Obj_element.originalId:=$Txt_id
								
								$Obj_element:=_o_storyboard_fix_id($Obj_element).element
								
							End for each 
							
							$Obj_in.template.elements:=$Col_
						Else 
							
							// find by attributes? find by children kel value?
							C_OBJECT:C1216($result)
							$result:=$Dom_root.findByAttribute("userLabel"; "stack")
							If ($result.success)
								If ($result.elements.length>0)  // Value type($result.elements)=Is collection)
									
									$Obj_element:=New object:C1471()
									$Obj_element.dom:=$result.elements[0]
									$Obj_element:=_o_storyboard_fix_id($Obj_element).element
									
									$Obj_in.template.elements:=New collection:C1472($Obj_element)
									
								End if 
							End if 
							
					End case 
					
				End if 
				
				// Try to determine if must duplicate or not element
				// elements are specified or 0 is set as "infinite" representation or if  max > count or one of them defined to 0
				If (($Obj_in.template.elements#Null:C1517)\
					 | (($Obj_in.template.fields.count#Null:C1517) & (Num:C11($Obj_in.template.fields.count)=0))\
					 | (($Obj_in.template.fields.max#Null:C1517) & (Num:C11($Obj_in.template.fields.max)=0))\
					 | (Num:C11($Obj_in.template.fields.max)>Num:C11($Obj_in.template.fields.count)))
					
					$Boo_buffer:=True:C214  // We found some element to duplicate, so we must write to file
					
					If ($Obj_in.template.elements=Null:C1517)
						$Obj_in.template.elements:=New collection:C1472()  // prevent errors, but there is issues maybe if we define count or max without elements...
					End if 
					
					// Look up first all the elements in Dom. Dom could be modifyed
					For each ($Obj_element; $Obj_in.template.elements)
						
						Case of 
							: ($Obj_element.dom#Null:C1517)
								// already found by construction, nothing to do
								
							: (Length:C16(String:C10($Obj_element.xpath))>0)  // look up with xpath
								
								//%W-533.1
								If ($Obj_element.xpath[[1]]#"/")
									//%W+533.1
									
									$Obj_element.xpath:="/"+$Obj_element.xpath
									
								End if 
								
								$Obj_element.dom:=$Dom_root.findByXPath($Obj_element.xpath)
								
								If ($Obj_element.dom.success)
									
									If (Not:C34(Bool:C1537($Obj_in.template.isInternal)))  // to optimize, suppose our template do not need to have fix...
										$Obj_element:=_o_storyboard_fix_id($Obj_element).element  // potentially fix subnodes if copy our storyboard to modify it
									End if 
									
								Else 
									
									$Obj_element.dom:=Null:C1517
									ASSERT:C1129(False:C215; "Invalid xpath "+$Obj_element.xpath+" for file "+$File_.path)
									
								End if 
								
							Else   // or look up with id TAG-INTERFIX-001
								
								$Lon_length:=Length:C16(String:C10($Obj_element.tagInterfix))
								
								Case of 
										
										// ----------------------------------------
									: ($Lon_length=2)
										
										// if "AS" document/resources and read children, to find ___FIELD_ICON___ ?? (no id for image, let ibtool fix that for the moment)
										$Obj_element.dom:=$Dom_root.findById("TAG-"+String:C10($Obj_element.tagInterfix)+"-001")
										
										If (Not:C34($Obj_element.dom.success))
											
											$Obj_element.dom:=Null:C1517
											ASSERT:C1129(False:C215; "Root element with id 'TAG-"+String:C10($Obj_element.tagInterfix)+"-001' not found for file "+$File_.path)
											
										End if 
										
										$Obj_element:=_o_storyboard_fix_id($Obj_element).element  // potentially fix subnodes
										
										// ----------------------------------------
									: ($Lon_length>0)
										
										ASSERT:C1129(False:C215; "Element 'tagInterfix' defined in manifest.json "+String:C10($Obj_element.tagInterfix)+" must have exactly two caracters.")
										
										// ----------------------------------------
									Else 
										
										ASSERT:C1129(False:C215; "No tag interfix defined for element "+JSON Stringify:C1217($Obj_element)+" (TAG->tagInterfix>-001). Alternatively you can defined node xpath for template file "+$File_.path+" to find the xml element in storyboard.")
										
										// ----------------------------------------
								End case 
						End case 
						
						If ($Obj_element.dom#Null:C1517)
							
							If ($Obj_element.insertInto=Null:C1517)
								$Obj_element.insertInto:=$Obj_element.dom.parent()  // define where to insert
							End if 
							
							// - define id count allow to speed up and pass that
							$Lon_ids:=Num:C11($Obj_element.idCount)
							
							If ($Lon_ids=0)  // idCount, not defined, try to count into storyboard
								
								$Dom_child:=$Obj_element.dom
								$Lon_ids:=0
								
								While ($Dom_child.success)
									
									$Lon_ids:=$Lon_ids+1
									$Dom_child:=$Obj_element.dom.findById("TAG-"+$Obj_element.tagInterfix+"-"+String:C10($Lon_ids+1; "##000"))
									
								End while 
								
								If ($Lon_ids=1)
									
									$Lon_ids:=32  // default value if not found
									
								End if 
							End if 
							
							$Obj_element.idCount:=$Lon_ids  // as a result purpose
							
							// - Check how to insert new node (ie. the insertMode)
							If (Length:C16(String:C10($Obj_element.insertMode))=0)
								
								$Obj_element.insertMode:="append"
								
							End if 
							
							// - Check if there is some mandatories tags before inserting
							If (Value type:C1509($Obj_element.tags.mandatories)=Is collection:K8:32)
								
								For each ($Obj_tag; $Obj_element.tags.mandatories)
									If (String:C10(ob_getByPath($Obj_in.tags; String:C10($Obj_tag.key)).value)="")  // support not empty rules now
										
										$Obj_element.insertMode:="none"  // do not insert
										
									End if 
								End for each 
							End if 
						End if 
					End for each 
					
					C_BOOLEAN:C305($Boo_hasRelation)
					$Boo_hasRelation:=False:C215
					For each ($Obj_field; $Obj_in.tags.table.detailFields) Until ($Boo_hasRelation)
						If (Num:C11($Obj_field.id)=0)  // relation to N field
							$Boo_hasRelation:=True:C214
						End if 
					End for each 
					
					If ($Boo_hasRelation)  // opti: do relation part only if there is relation
						
						If ($Obj_in.template.relation=Null:C1517)
							$Obj_in.template.relation:=New object:C1471()
						End if 
						$Obj_in.template.relation.elements:=New collection:C1472()
						
						C_OBJECT:C1216($Folder_relation)
						$Folder_relation:=cs:C1710.path.new().templates().folder("relation")
						
						C_OBJECT:C1216($Dom_relation)
						
						Case of 
							: (Length:C16(String:C10($Obj_in.template.relation.xpath))>0)
								
								//%W-533.1
								If ($Obj_in.template.relation.xpath[[1]]#"/")
									//%W+533.1
									
									$Obj_in.template.relation.xpath:="/"+$Obj_in.template.relation.xpath
									
								End if 
								
								$Dom_relation:=$Dom_root.findByXPath(String:C10($Obj_in.template.relation.xpath))
								$Dom_relation.isDefault:=False:C215
								$Dom_relation.doNotClose:=True:C214
								
							: ($Folder_template.file("relationButton.xml").exists)
								
								$Dom_relation:=_o_xml("load"; $Folder_template.file("relationButton.xml"))
								$Dom_relation.isDefault:=False:C215
								
							: ($Folder_template.file("relationButton.xib").exists)
								
								//$Dom_relation:=xml("load";$Folder_template.file("relationButton.xib")).findByXPath("document/objects/view")  // XXX the root must be close, or we must free memory or parent element here?
								$Dom_relation:=_o_xml("load"; $Folder_template.file("relationButton.xib")).findByXPath("/document/objects/view")  // XXX the root must be close, or we must free memory or parent element here?
								$Dom_relation.isDefault:=False:C215
								
							Else 
								
								$Dom_relation:=$Obj_element.dom.findById("TAG-RL-001")  // try by tag in storyboard
								
								If (Not:C34($Dom_relation.success))  // else us default one
									
									//$Dom_relation:=xml("load";$Folder_relation.file("relationButton.xib")).findByXPath("document/objects/view")  // XXX the root must be close, or we must free memory or parent element here?
									
									$Dom_relation:=_o_xml("load"; $Folder_relation.file("relationButton.xib")).findByXPath("/document/objects/view")  // XXX the root must be close, or we must free memory or parent element here?
									//$Dom_relation:=xml ("load";$Folder_relation.file("relationButton.xml"))
									$Dom_relation.isDefault:=True:C214
									
								Else 
									
									$Dom_relation.isDefault:=False:C215
									$Dom_relation.doNotClose:=True:C214
									
								End if 
								
						End case 
						
						// 1- element
						$Obj_element:=New object:C1471(\
							"dom"; $Dom_relation; \
							"idCount"; 6; \
							"tagInterfix"; "RL"; \
							"insertMode"; "append")
						
						If (Num:C11($Obj_in.template.relation.idCount)>0)  // defined by designer, YES!
							
							$Obj_element.idCount:=Num:C11($Obj_in.template.relation.idCount)
							
						Else   // not defined, we an check
							
							If (Not:C34($Dom_relation.isDefault))  // fix id count if not defined by reading dom
								
								$Dom_child:=$Obj_element.dom
								$Lon_ids:=0
								
								While ($Dom_child.success)
									
									$Lon_ids:=$Lon_ids+1
									$Dom_child:=$Obj_element.dom.findById("TAG-"+$Obj_element.tagInterfix+"-"+String:C10($Lon_ids+1; "##000"))
									
								End while 
								
								If ($Lon_ids=1)
									
									$Lon_ids:=32  // default value if not found
									
								End if 
							End if 
							
							$Obj_element.idCount:=$Lon_ids  // as a result purpose
						End if 
						
						// Must be inserted into a stack view (with a subviews as intermediate)
						C_OBJECT:C1216($Obj_)
						For each ($Obj_; $Obj_in.template.elements) Until ($Obj_element.insertInto#Null:C1517)
							If (String:C10($Obj_.insertInto.parent().getName().name)="stackView")
								$Obj_element.insertInto:=$Obj_.insertInto
							End if 
						End for each 
						$Obj_in.template.relation.elements.push($Obj_element)
						
						// 2- scene
						//$Obj_element:=New object(\
																																																																																																																							"insertInto";$Dom_root.findByXPath("document/scenes");\
																																																																																																																							"dom";xml("load";$Folder_relation.file("storyboardScene.xml"));\
																																																																																																																							"idCount";3;\
																																																																																																																							"tagInterfix";"SN";\
																																																																																																																							"insertMode";"append")
						$Obj_element:=New object:C1471(\
							"insertInto"; $Dom_root.findByXPath("/document/scenes"); \
							"dom"; _o_xml("load"; $Folder_relation.file("storyboardScene.xml")); \
							"idCount"; 3; \
							"tagInterfix"; "SN"; \
							"insertMode"; "append")
						$Obj_in.template.relation.elements.push($Obj_element)
						
						// 3- connection
						$Obj_element:=New object:C1471("idCount"; 1; \
							"tagInterfix"; "SG"; \
							"insertMode"; "append"\
							)
						
						// find controller of where we inject relation element button
						$Obj_element.insertInto:=$Obj_in.template.relation.elements[0].insertInto.parentWithName("viewController")
						If (Not:C34($Obj_element.insertInto.success))  // find with old code
							$Lon_j:=3
							Repeat 
								
								//$Obj_element.insertInto:=$Dom_root.findByXPath("document/scenes/scene["+String($Lon_j)+"]/objects/viewController")
								$Obj_element.insertInto:=$Dom_root.findByXPath("/document/scenes/scene["+String:C10($Lon_j)+"]/objects/viewController")
								$Lon_j:=$Lon_j-1
								
							Until ($Obj_element.insertInto.success | ($Lon_j<0))
						End if 
						
						If ($Obj_in.template.relation.transition=Null:C1517)
							$Obj_in.template.relation.transition:=New object:C1471()
						End if 
						If (Length:C16(String:C10($Obj_in.template.relation.transition.kind))=0)
							$Obj_in.template.relation.transition.kind:="show"
							// else check type?
						End if 
						
						$Txt_buffer:="<segue destination=\"TAG-SN-001\""
						
						If ($Obj_in.template.relation.transition.customClass#Null:C1517)
							$Txt_buffer:=$Txt_buffer+" customClass=\""+String:C10($Obj_in.template.relation.transition.customClass)+"\""
						End if 
						If ($Obj_in.template.relation.transition.customModule#Null:C1517)
							$Txt_buffer:=$Txt_buffer+" customModule=\""+String:C10($Obj_in.template.relation.transition.customModule)+"\""
						End if 
						If ($Obj_in.template.relation.transition.modalPresentationStyle#Null:C1517)
							$Txt_buffer:=$Txt_buffer+" modalPresentationStyle=\""+String:C10($Obj_in.template.relation.transition.modalPresentationStyle)+"\""
						End if 
						If ($Obj_in.template.relation.transition.modalTransitionStyle#Null:C1517)
							$Txt_buffer:=$Txt_buffer+" modalTransitionStyle=\""+String:C10($Obj_in.template.relation.transition.modalTransitionStyle)+"\""
						End if 
						$Txt_buffer:=$Txt_buffer+" kind=\""+String:C10($Obj_in.template.relation.transition.kind)+"\""
						$Txt_buffer:=$Txt_buffer+" identifier=\"___FIELD___\" id=\"TAG-SG-001\"/>"
						
						If ($Obj_element.insertInto.success)
							$Obj_element.insertInto:=$Obj_element.insertInto.findOrCreate("connections")  // Find its <connections> children, if not exist create it
							$Obj_element.dom:=_o_xml("parse"; New object:C1471("variable"; $Txt_buffer))
							$Obj_in.template.relation.elements.push($Obj_element)
							
						Else 
							
							// Invalid relation
							ASSERT:C1129(dev_Matrix; "Cannot add relation on this template. Cannot find viewController: "+JSON Stringify:C1217($Obj_element))
							
						End if 
						
					End if 
					
					// START browser fields
					
					// ... and fields
					$Lon_j:=Num:C11($Obj_in.template.fields.count)  // Start at first element, not in header
					For each ($Var_field; $Obj_in.tags.table.detailFields; Num:C11($Obj_in.template.fields.count))
						
						Case of 
							: (Value type:C1509($Var_field)=Is object:K8:27)
								
								$Obj_field:=$Var_field
								
								$Lon_j:=$Lon_j+1  // pos
								
								// Set tags:
								// - field
								$Obj_in.tags.field:=$Obj_field
								
								$Obj_in.tags.storyboardID:=New collection:C1472
								
								If (Num:C11($Obj_field.id)=0)  // relation to N field
									
									$Col_elements:=$Obj_in.template.relation.elements
									
								Else 
									
									$Col_elements:=$Obj_in.template.elements
									
								End if 
								
								// For each element... (scene, cell, ...)
								For each ($Obj_element; $Col_elements)
									
									If ($Obj_element.dom#Null:C1517)  // if valid element
										
										// - randoms ids
										If (Length:C16(String:C10($Obj_element.tagInterfix))>0)
											
											$Obj_storyboardID:=New object:C1471(\
												"tagInterfix"; $Obj_element.tagInterfix; \
												"storyboardIDs"; _o_storyboard(New object:C1471(\
												"action"; "randomIds"; \
												"length"; $Obj_element.idCount)).value)
											
											$Obj_in.tags.storyboardID.push($Obj_storyboardID)  // By using a collection we have now TAG for previous elements also injected (could be useful for "connections")
											
										End if 
										
										// Process tags on the element
										$Txt_buffer:=$Obj_element.dom.export().variable
										$Txt_buffer:=Process_tags($Txt_buffer; $Obj_in.tags; New collection:C1472("___TABLE___"; "detailform"; "storyboardID"))
										
										// Insert node for this element
										$Dom_:=Null:C1517
										//Case of
										
										//  // ----------------------------------------
										//: $Obj_element.insertMode="append"
										
										//$Dom_:=$Obj_element.insertInto.append($Txt_buffer)
										
										//  // ----------------------------------------
										//: $Obj_element.insertMode="first"
										
										//$Dom_:=$Obj_element.insertInto.insertFirst($Txt_buffer)
										
										//  // ----------------------------------------
										//: $Obj_element.insertMode="iteration"
										
										//$Dom_:=$Obj_element.insertInto.insertAt($Txt_buffer;$Lon_j)
										
										//  // ----------------------------------------
										//End case
										
										//If ($Dom_#Null)
										//ob_removeFormula ($Dom_)  // For debugging purpose remove all formula
										//End if
										
										//$Obj_out.doms.push($Dom_)
										
										If (Bool:C1537($Obj_element.insertInto.success))
											
											Case of 
													
													// ----------------------------------------
												: ($Obj_element.insertMode="append")
													
													$Dom_:=$Obj_element.insertInto.append($Txt_buffer)
													
													// ----------------------------------------
												: ($Obj_element.insertMode="first")
													
													$Dom_:=$Obj_element.insertInto.insertFirst($Txt_buffer)
													
													// ----------------------------------------
												: ($Obj_element.insertMode="iteration")
													
													$Dom_:=$Obj_element.insertInto.insertAt($Txt_buffer; $Lon_j)
													
													// ----------------------------------------
											End case 
											
											If ($Dom_#Null:C1517)
												
												ob_removeFormula($Dom_)  // For debugging purpose remove all formula
												
											End if 
											
											$Obj_out.doms.push($Dom_)
											
										Else 
											
											ob_error_add($Obj_out; "Failed to nsert after processing tags '"+$Txt_buffer+"'")
											
										End if 
										
									End if 
								End for each 
								
							: (Value type:C1509($Var_field)=Is collection:K8:32)  // #114338 support collection
								
								C_COLLECTION:C1488($Col_fields)
								$Col_fields:=$Var_field
								
								$Lon_j:=$Lon_j+1  // pos, used for "insertAt" method, maybe not compatible with rows
								
								For each ($Obj_field; $Col_fields)
									
									// Set tags:
									// - field
									$Obj_in.tags.field:=$Obj_field
									
									$Obj_in.tags.storyboardID:=New collection:C1472
									
									If (Num:C11($Obj_field.id)=0)  // relation to N field
										
										$Col_elements:=$Obj_in.template.relation.elements
										
									Else 
										
										$Col_elements:=$Obj_in.template.elements
										
									End if 
									
									// For each element... (scene, cell, ...)
									For each ($Obj_element; $Col_elements)
										
										If ($Obj_element.dom#Null:C1517)  // if valid element
											
											/// HEADER for row
											If ($Obj_element.insertIntoRow=Null:C1517)
												
												If ($Obj_element.insertInto.parent().getName().name="stackView")  // only on stack view (suppose only one element has stack view parent..., same as relation)
													$Txt_buffer:="<stackView opaque=\"NO\" contentMode=\"scaleToFill\" distribution=\"fillEqually\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"ROW-SV"+String:C10($Lon_j; "##000")+"\"></stackView>"
													$Obj_element.insertIntoRow:=$Obj_element.insertInto.append($Txt_buffer)
													$Txt_buffer:="<rect key=\"frame\" x=\"0.0\" y=\"200\" width=\"375\" height=\"97\"/>"
													$Dom_:=$Obj_element.insertIntoRow.append($Txt_buffer)
													$Txt_buffer:="<subviews></subviews>"
													$Obj_element.insertIntoRow:=$Obj_element.insertIntoRow.append($Txt_buffer)
												Else 
													$Obj_element.insertIntoRow:=$Obj_element.insertInto
												End if 
											End if 
											/// END HEADER for row
											
											// - randoms ids
											If (Length:C16(String:C10($Obj_element.tagInterfix))>0)
												
												$Obj_storyboardID:=New object:C1471(\
													"tagInterfix"; $Obj_element.tagInterfix; \
													"storyboardIDs"; _o_storyboard(New object:C1471(\
													"action"; "randomIds"; \
													"length"; $Obj_element.idCount)).value)
												
												$Obj_in.tags.storyboardID.push($Obj_storyboardID)  // By using a collection we have now TAG for previous elements also injected (could be useful for "connections")
												
											End if 
											
											// Process tags on the element
											$Txt_buffer:=$Obj_element.dom.export().variable
											$Txt_buffer:=Process_tags($Txt_buffer; $Obj_in.tags; New collection:C1472("___TABLE___"; "detailform"; "storyboardID"))
											
											// Insert node for this element
											$Dom_:=Null:C1517
											Case of 
													
													// ----------------------------------------
												: $Obj_element.insertMode="append"
													
													$Dom_:=$Obj_element.insertIntoRow.append($Txt_buffer)
													
													// ----------------------------------------
												: $Obj_element.insertMode="first"
													
													$Dom_:=$Obj_element.insertIntoRow.insertFirst($Txt_buffer)
													
													// ----------------------------------------
												: $Obj_element.insertMode="iteration"
													
													$Dom_:=$Obj_element.insertIntoRow.insertAt($Txt_buffer; $Lon_j)
													
													// ----------------------------------------
											End case 
											
											If ($Dom_#Null:C1517)
												ob_removeFormula($Dom_)  // For debugging purpose remove all formula
											End if 
											
											$Obj_out.doms.push($Dom_)
											
										End if 
									End for each 
									
								End for each   // $Col_fields
								
							Else 
								// unknown
								ASSERT:C1129(dev_Matrix; "unknown data type of fields: "+String:C10(Value type:C1509($Var_field))+", must be field or a collection of fields")
								
						End case 
					End for each 
					
					// Remove original template duplicated element
					For each ($Obj_element; $Obj_in.template.elements)
						
						If ($Obj_element.dom#Null:C1517)
							
							If ($Obj_element.originalDom#Null:C1517)
								$Obj_element.originalDom.remove()  // we have a memory virtual element, so delete the original
							Else 
								$Obj_element.dom.remove()
							End if 
							
						End if 
					End for each 
					
					// close relation elements dom elements
					If ($Boo_hasRelation)
						
						For each ($Obj_element; $Obj_in.template.relation.elements)
							
							If ($Obj_element.dom#Null:C1517)
								If (Not:C34(Bool:C1537($Obj_element.dom.doNotClose)))  // do not close if in global storyboard, if external file or string must be closed
									$Obj_element.dom.root().close()
								End if 
							End if 
						End for each 
					End if 
					
				End if 
				
				// Save file at destination after replacing tags
				If ($Boo_buffer)
					
					$Txt_buffer:=$Dom_root.export().variable
					$Txt_buffer:=Process_tags($Txt_buffer; $Obj_in.tags; New collection:C1472("storyboard"; "___TABLE___"))
					$Txt_buffer:=Replace string:C233($Txt_buffer; "<userDefinedRuntimeAttribute type=\"image\" keyPath=\"image\"/>"; "")  // Remove useless empty image
					
					$File_:=Folder:C1567($Obj_in.target; fk platform path:K87:2).file(Process_tags(String:C10($Obj_in.template.storyboard); $Obj_in.tags; New collection:C1472("filename")))
					$File_.setText($Txt_buffer; "UTF-8"; Document with CRLF:K24:20)
					
					$Obj_out.format:=_o_storyboard(New object:C1471(\
						"action"; "format"; \
						"path"; $File_))
					
				End if 
				
				$Dom_root.close()
				
				$Obj_out.success:=True:C214  // XXX maybe better error managing, take into account all "doms"
				
			Else   // Not a document
				
				ASSERT:C1129(dev_Matrix; "Missing or not decodable "+$Obj_in.action+" storyboard")
				
				$Obj_out.errors:=New collection:C1472("Template "+$File_.path+" not decodable or available")
				$Obj_out.success:=False:C215
				
			End if 
			
			//______________________________________________________
		: ($Obj_in.action="listform")
			
			If ($Obj_in.template.storyboard=Null:C1517)  // set default path if not defined
				
				$Obj_in.template.storyboard:=$Obj_in.template.parent[$Obj_in.action].storyboard
				
			End if 
			
			$File_:=Folder:C1567($Obj_in.template.source; fk platform path:K87:2).file(String:C10($Obj_in.template.storyboard))
			
			If ($File_.exists)
				
				$Txt_buffer:=$File_.getText()
				
				If (Length:C16($Txt_buffer)>0)  // a custom template or not well described one (do not warn about it but we could read by reading file)
					
					$Obj_element:=New object:C1471(\
						"___TABLE_ACTIONS___"; "tableActions"; \
						"___ENTITY_ACTIONS___"; "recordActions")
					
					For each ($Txt_cmd; $Obj_element)
						
						If ($Obj_in.tags.table[$Obj_element[$Txt_cmd]]#Null:C1517)  // there is selection action
							
							If (Position:C15($Txt_cmd; $Txt_buffer)=0)
								
								ob_warning_add($Obj_out; "List template storyboard '"+$File_.path+"'do not countains action tag "+$Txt_cmd)
								
								// XXX here could fix by dom manipulation instead of warn (some code in #106033) (fix on source or in destination?)
								
							End if 
						End if 
					End for each 
				End if 
				
				$Obj_out.success:=True:C214
				
			Else   // Not a document
				
				ASSERT:C1129(dev_Matrix; "Missing "+$Obj_in.action+" storyboard")
				
			End if 
			
			//______________________________________________________
		: ($Obj_in.action="colorAssetFix")
			
			If (Test path name:C476(String:C10($Obj_in.path))=Is a folder:K24:2)
				
				$Obj_out.files:=New collection:C1472
				
				For each ($File_; Folder:C1567($Obj_in.path; fk platform path:K87:2).files(fk recursive:K87:7))
					
					If ($File_.extension=".storyboard")
						
						// read file
						$Dom_root:=_o_xml("load"; $File_)
						
						// find named colors
						$Boo_buffer:=False:C215
						
						For each ($Dom_; $Dom_root.findMany("/document/resources/namedColor").elements)
							
							// get color name
							$Txt_buffer:=$Dom_.getAttribute("name").value
							
							If ($Obj_in.theme[$Txt_buffer]#Null:C1517)
								
								If (Value type:C1509($Obj_in.theme[$Txt_buffer])=Is object:K8:27)
									
									// get color xml child
									$Dom_child:=$Dom_.firstChild()
									
									$Obj_color:=$Obj_in.theme[$Txt_buffer]
									
									// recreate node
									$Dom_child.remove()
									$Dom_child:=$Dom_.create("color")
									$Boo_buffer:=True:C214
									
									Case of 
											
											//______________________________________________________
										: ($Obj_color.space="gray")
											
											If ($Obj_color.alpha=Null:C1517)
												
												$Obj_color.alpha:=1
												
											End if 
											
											$Dom_child.setAttributes(New object:C1471(\
												"white"; String:C10($Obj_color.white); \
												"alpha"; String:C10($Obj_color.alpha); \
												"colorSpace"; "custom"; \
												"customColorSpace"; "genericGamma22GrayColorSpace"))
											
											//______________________________________________________
										: ($Obj_color.space="srgb")
											
											If ($Obj_color.alpha=Null:C1517)
												
												$Obj_color.alpha:=255
												
											End if 
											
											$Dom_child.setAttributes(New object:C1471(\
												"alpha"; String:C10($Obj_color.alpha/255; "&xml"); \
												"red"; String:C10($Obj_color.red/255; "&xml"); \
												"green"; String:C10($Obj_color.green/255; "&xml"); \
												"blue"; String:C10($Obj_color.blue/255; "&xml"); \
												"colorSpace"; "custom"; \
												"customColorSpace"; "sRGB"))
											
											// ----------------------------------------
										Else 
											
											ASSERT:C1129("Unknown color space "+$Obj_color.space)
											
											// ----------------------------------------
									End case 
								End if 
							End if 
						End for each 
						
						If ($Boo_buffer)
							
							// write if there is one named colors (could also do it only if one attribute change)
							_o_doc_UNLOCK_DIRECTORY(New object:C1471(\
								"path"; $File_.parent.platformPath))
							$Dom_root.save($File_)
							$Dom_root.close()
							$Obj_out.files.push($File_.platformPath)
							
							_o_storyboard(New object:C1471(\
								"action"; "format"; \
								"path"; $File_))  // XXX to do it only one time, maybe do it in caller, using the "files"
							
						End if 
						
						$Obj_out.success:=True:C214  // we manage one file
						
					End if 
					
				End for each 
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("path not defined or do not exist")
				
			End if 
			
			//______________________________________________________
		: ($Obj_in.action="imageAssetFix")
			
			// remove all empty image asset, and double
			
			If (Test path name:C476(String:C10($Obj_in.path))=Is a folder:K24:2)
				
				$Obj_out.files:=New collection:C1472
				
				For each ($File_; Folder:C1567($Obj_in.path; fk platform path:K87:2).files(fk recursive:K87:7))
					
					If ($File_.extension=".storyboard")
						
						// read file
						$Dom_root:=_o_xml("load"; $File_)
						$Boo_buffer:=False:C215
						
						// find named colors
						For each ($Dom_; $Dom_root.findMany("/document/resources/image").elements)
							
							$Col_:=New collection:C1472
							
							// get  name
							$Txt_buffer:=$Dom_.getAttribute("name").value
							
							If (Length:C16($Txt_buffer)=0)
								
								$Dom_.remove()
								$Boo_buffer:=True:C214
								
							Else 
								
								If ($Col_.indexOf($Txt_buffer)>-1)
									
									$Boo_buffer:=True:C214
									
								Else 
									
									$Col_.push($Txt_buffer)
									
								End if 
							End if 
						End for each 
						
						// Remove empty value attribute of userDefinedRuntimeAttribute with type image
						For each ($Dom_; $Dom_root.findByName("userDefinedRuntimeAttribute").elements)
							
							C_OBJECT:C1216($Obj_attributes)
							$Obj_attributes:=$Dom_.attributes().attributes
							
							If (String:C10($Obj_attributes.type)="image")
								
								If ($Obj_attributes.value#Null:C1517)\
									 & (Length:C16(String:C10($Obj_attributes.value))=0)
									
									$Dom_.removeAttribute("value")
									$Boo_buffer:=True:C214
									
								End if 
							End if 
						End for each 
						
						// write if there is one modification
						If ($Boo_buffer)
							
							$Dom_root.save($File_)
							$Dom_root.close()
							$Obj_out.files.push($File_.platformPath)
							
							_o_storyboard(New object:C1471(\
								"action"; "format"; \
								"path"; $File_))  // XXX to do it only one time, maybe do it in caller, using the "files" and a "set" behaviour
							
						End if 
						
						$Obj_out.success:=True:C214  // we manage one file
						
					End if 
					
				End for each 
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("path not defined or do not exist")
				
			End if 
			
			//______________________________________________________
		: ($Obj_in.action="format")
			
			// Reformat storyboard document to follow xcode rules (line ending, attributes order, add missing resources)
			
			If (Value type:C1509($Obj_in.path)=Is text:K8:3)
				
				If (Test path name:C476(String:C10($Obj_in.path))=Is a document:K24:1)
					
					ASSERT:C1129(dev_Matrix; "Must not be string, now File")  // Deprecated, maybe be test ...
					$Obj_in.path:=File:C1566($Obj_in.path; fk platform path:K87:2)
					
				End if 
			End if 
			
			Case of 
					
					// ----------------------------------------
				: ($Obj_in.path=Null:C1517)
					
					$Obj_out.errors:=New collection:C1472("path not defined")
					
					// ----------------------------------------
				: ($Obj_in.path.exists)
					
					// Use temp file because inplace command do not reformat
					$File_:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+".storyboard")
					$Obj_in.path.copyTo($File_.parent; $File_.name+$File_.extension)
					
					$Txt_cmd:="ibtool --upgrade "+str_singleQuoted($File_.path)+" --write "+str_singleQuoted($Obj_in.path.path)
					LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
					
					If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
						
						$Obj_out.success:=True:C214
						$File_.delete()  // delete temporary file
						
						If (Length:C16($Txt_out)>0)
							
							$File_:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+"ibtool.plist")
							$File_.setText($Txt_out)
							$Obj_out:=_o_plist(New object:C1471(\
								"action"; "object"; \
								"domain"; $File_.path))
							$File_.delete()  // delete temporary file
							
							If (($Obj_out.success)\
								 & ($Obj_out.value#Null:C1517))
								
								// errors
								Case of 
										
										//........................................
									: (Value type:C1509($Obj_out.value["com.apple.ibtool.document.errors"])=Is collection:K8:32)
										
										$Obj_out.errors:=$Obj_out.value["com.apple.ibtool.document.errors"]
										
										//........................................
									: (Value type:C1509($Obj_out.value["com.apple.ibtool.document.errors"])=Is object:K8:27)
										
										$Obj_out.errors:=New collection:C1472($Obj_out.value["com.apple.ibtool.document.errors"])
										
										//........................................
									: (Value type:C1509($Obj_out.value["com.apple.ibtool.errors"])=Is collection:K8:32)
										
										$Obj_out.errors:=$Obj_out.value["com.apple.ibtool.errors"]
										
										//........................................
									: (Value type:C1509($Obj_out.value["com.apple.ibtool.errors"])=Is object:K8:27)
										
										$Obj_out.errors:=New collection:C1472($Obj_out.value["com.apple.ibtool.errors"])
										
										//........................................
								End case 
								
								If (Value type:C1509($Obj_out.errors)=Is collection:K8:32)
									
									$Obj_out.success:=$Obj_out.errors.length=0
									
								End if 
							End if 
						End if 
					End if 
					
					// ----------------------------------------
				Else 
					
					$File_.delete()  // delete temporary file
					$Obj_out.errors:=New collection:C1472("path do not exist")
					
					// ----------------------------------------
			End case 
			
			//______________________________________________________
			
			//______________________________________________________
		: ($Obj_in.action="version")
			
			// Get storyboard tool version (could be used to replace in storyboard header)
			$Txt_cmd:="ibtool --version"
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
			
			If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
				
				If (Length:C16($Txt_out)>0)
					
					$File_:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+"ibtool.plist")
					$File_.setText($Txt_out)
					$Obj_out:=_o_plist(New object:C1471(\
						"action"; "object"; \
						"domain"; $File_.path))
					$File_.delete()
					
					If (($Obj_out.success)\
						 & ($Obj_out.value#Null:C1517))
						
						$Obj_out.version:=String:C10($Obj_out.value["com.apple.ibtool.version"]["bundle-version"])
						
					End if 
				End if 
			End if 
			
			//________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "Unknown entry point: \""+$Obj_in.action+"\"")
			
			//________________________________________
	End case 
End if 

// ----------------------------------------------------
// Return
$0:=$Obj_out

// ----------------------------------------------------
// End