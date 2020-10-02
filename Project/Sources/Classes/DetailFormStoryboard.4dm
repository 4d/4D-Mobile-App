Class extends Storyboard

Class constructor
	C_OBJECT:C1216($1)
	If (Count parameters:C259>0)
		Super:C1705($1)
	Else 
		Super:C1705()
	End if 
	This:C1470.type:="detailform"
	
Function run
	C_OBJECT:C1216($0; $Obj_out)
	$Obj_out:=New object:C1471()
	$Obj_out.doms:=New collection:C1472()
	
	C_OBJECT:C1216($1; $Obj_template)
	$Obj_template:=$1
	C_OBJECT:C1216($2; $target)
	$target:=$2
	C_OBJECT:C1216($3; $Obj_tags)
	$Obj_tags:=$3
	
	This:C1470.checkStoryboardPath($Obj_template)  // set default path if not defined
	
	C_OBJECT:C1216($Dom_root; $Dom_child; $Dom_)
	$Dom_root:=xml("load"; This:C1470.path)
	
	If ($Dom_root.success)
		
		C_TEXT:C284($Txt_buffer)
		$Txt_buffer:=This:C1470.path.getText()
		
		If (Length:C16($Txt_buffer)>0)  // a little check on record action if needed to inject it
			
			If ($Obj_tags.table.recordActions#Null:C1517)
				
				C_TEXT:C284($Txt_cmd)
				$Txt_cmd:="___ENTITY_ACTIONS___"
				
				If (Position:C15($Txt_cmd; $Txt_buffer)=0)
					
					ob_warning_add($Obj_out; "Detail template storyboard '"+$File_.path+"'do not countains action tag "+$Txt_cmd)
					
					// XXX here could fix by dom manipulation instead of warn (some code in #106033) (fix on source or in destination?)
					
				End if 
			End if 
		End if 
		
		// create elements if not defined in manifest (if defined, this is an opti)
		This:C1470.checkTemplateElements($Obj_template; $Txt_buffer; $Dom_root)
		
		C_OBJECT:C1216($Folder_template)
		$Folder_template:=Folder:C1567($Obj_template.source; fk platform path:K87:2)
		
		// Try to determine if must duplicate or not element
		// elements are specified or 0 is set as "infinite" representation or if  max > count or one of them defined to 0
		If (($Obj_template.elements#Null:C1517)\
			 | (($Obj_template.fields.count#Null:C1517) & (Num:C11($Obj_template.fields.count)=0))\
			 | (($Obj_template.fields.max#Null:C1517) & (Num:C11($Obj_template.fields.max)=0))\
			 | (Num:C11($Obj_template.fields.max)>Num:C11($Obj_template.fields.count)))
			
			C_BOOLEAN:C305($Boo_buffer)
			$Boo_buffer:=True:C214  // We found some element to duplicate, so we must write to file
			
			If ($Obj_template.elements=Null:C1517)
				$Obj_template.elements:=New collection:C1472()  // prevent errors, but there is issues maybe if we define count or max without elements...
			End if 
			
			// Look up first all the elements in Dom. Dom could be modifyed
			C_OBJECT:C1216($Obj_element)
			For each ($Obj_element; $Obj_template.elements)
				
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
							
							If (Not:C34(Bool:C1537($Obj_template.isInternal)))  // to optimize, suppose our template do not need to have fix...
								$Obj_element:=This:C1470.fixDomChildID($Obj_element).element  // potentially fix subnodes if copy our storyboard to modify it
							End if 
							
						Else 
							
							$Obj_element.dom:=Null:C1517
							ASSERT:C1129(False:C215; "Invalid xpath "+$Obj_element.xpath+" for file "+$File_.path)
							
						End if 
						
					Else   // or look up with id TAG-INTERFIX-001
						
						C_LONGINT:C283($Lon_length)
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
								
								$Obj_element:=This:C1470.fixDomChildID($Obj_element).element  // potentially fix subnodes
								
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
					
					This:C1470.checkIDCount($Obj_element)
					This:C1470.checkInsert($Obj_element; $Obj_tags)
					
				End if 
			End for each 
			
			// Find a node to duplicate for relation
			C_OBJECT:C1216($Folder_relation)
			$Folder_relation:=COMPONENT_Pathname("templates").folder("relation")
			
			C_BOOLEAN:C305($Boo_hasRelation)
			$Boo_hasRelation:=False:C215
			C_OBJECT:C1216($Obj_field)
			For each ($Obj_field; $Obj_tags.table.fields; Num:C11($Obj_template.fields.count)) Until ($Boo_hasRelation)
				If (Num:C11($Obj_field.id)=0)  // relation to N field
					$Boo_hasRelation:=True:C214
				End if 
			End for each 
			
			If ($Boo_hasRelation)  // opti: do relation part only if there is relation
				
				If ($Obj_template.relation=Null:C1517)
					$Obj_template.relation:=New object:C1471()
				End if 
				$Obj_template.relation.elements:=New collection:C1472()
				
				
				C_OBJECT:C1216($Dom_relation)
				
				Case of 
					: (Length:C16(String:C10($Obj_template.relation.xpath))>0)  // specified by xpath in current storyboard
						
						//%W-533.1
						If ($Obj_template.relation.xpath[[1]]#"/")
							//%W+533.1
							
							$Obj_template.relation.xpath:="/"+$Obj_template.relation.xpath
							
						End if 
						
						$Dom_relation:=$Dom_root.findByXPath(String:C10($Obj_template.relation.xpath))
						$Dom_relation.isDefault:=False:C215
						$Dom_relation.doNotClose:=True:C214
						
					: ($Folder_template.file("relationButton.xml").exists)  // there is 
						
						$Dom_relation:=xml("load"; $Folder_template.file("relationButton.xml"))
						$Dom_relation.isDefault:=False:C215
						
					: ($Folder_template.file("relationButton.xib").exists)
						
						$Dom_relation:=xml("load"; $Folder_template.file("relationButton.xib")).findByXPath("/document/objects/view")  // XXX the root must be close, or we must free memory or parent element here?
						$Dom_relation.isDefault:=False:C215
						
					: (let(->$Dom_relation; Formula:C1597($Obj_element.dom.findById("TAG-RL-001")); Formula:C1597($1.success)))  // using tag id injected in storyboard
						
						$Dom_relation.isDefault:=False:C215
						$Dom_relation.doNotClose:=True:C214
						
					Else   // else us default one
						
						$Dom_relation:=xml("load"; $Folder_relation.file("relationButton.xib")).findByXPath("/document/objects/view")  // XXX the root must be close, or we must free memory or parent element here?
						$Dom_relation.isDefault:=True:C214
						
				End case 
				
				// 1- element
				$Obj_element:=New object:C1471(\
					"dom"; $Dom_relation; \
					"tagInterfix"; "RL"; \
					"insertMode"; "append")
				
				If (Num:C11($Obj_template.relation.idCount)>0)  // defined by designer, YES!
					
					$Obj_element.idCount:=Num:C11($Obj_template.relation.idCount)
					
				Else   // not defined, we an check
					
					C_LONGINT:C283($Lon_ids)
					If (Not:C34($Dom_relation.isDefault))  // fix id count if not defined by reading dom
						This:C1470.checkIDCount($Obj_element)
					Else 
						$Obj_element.idCount:=6
					End if 
				End if 
				
				// Must be inserted into a stack view (with a subviews as intermediate)
				C_OBJECT:C1216($Obj_)
				For each ($Obj_; $Obj_template.elements) Until ($Obj_element.insertInto#Null:C1517)
					If (String:C10($Obj_.insertInto.parent().getName().name)="stackView")
						$Obj_element.insertInto:=$Obj_.insertInto
					End if 
				End for each 
				$Obj_template.relation.elements.push($Obj_element)
				
				// 2- scene
				
				$Obj_element:=New object:C1471(\
					"insertInto"; $Dom_root.findByXPath("/document/scenes"); \
					"dom"; xml("load"; $Folder_relation.file("storyboardScene.xml")); \
					"idCount"; 3; \
					"tagInterfix"; "SN"; \
					"insertMode"; "append")
				$Obj_template.relation.elements.push($Obj_element)
				
				// 3- connection
				$Obj_element:=New object:C1471("idCount"; 1; \
					"tagInterfix"; "SG"; \
					"insertMode"; "append"\
					)
				
				// find controller of where we inject relation element button
				$Obj_element.insertInto:=$Obj_template.relation.elements[0].insertInto.parentWithName("viewController")
				C_LONGINT:C283($Lon_j)
				If (Not:C34($Obj_element.insertInto.success))  // find with old code
					$Lon_j:=3
					Repeat 
						
						$Obj_element.insertInto:=$Dom_root.findByXPath("/document/scenes/scene["+String:C10($Lon_j)+"]/objects/viewController")
						$Lon_j:=$Lon_j-1
						
					Until ($Obj_element.insertInto.success | ($Lon_j<0))
				End if 
				
				$Txt_buffer:=This:C1470.relationSegue($Obj_template.relation)
				
				If ($Obj_element.insertInto.success)
					$Obj_element.insertInto:=$Obj_element.insertInto.findOrCreate("connections")  // Find its <connections> children, if not exist create it
					$Obj_element.dom:=xml("parse"; New object:C1471("variable"; $Txt_buffer))
					$Obj_template.relation.elements.push($Obj_element)
					
				Else 
					
					// Invalid relation
					ASSERT:C1129(dev_Matrix; "Cannot add relation on this template. Cannot find viewController: "+JSON Stringify:C1217($Obj_element))
					
				End if 
				
			End if 
			
			// START browser fields
			
			// ... and fields
			$Lon_j:=Num:C11($Obj_template.fields.count)  // Start at first element, not in header
			C_VARIANT:C1683($Var_field)
			For each ($Var_field; $Obj_tags.table.fields; Num:C11($Obj_template.fields.count))
				
				Case of 
					: (Value type:C1509($Var_field)=Is object:K8:27)
						
						$Lon_j:=$Lon_j+1  // pos
						This:C1470.injectElement($Var_field; $Obj_tags; $Obj_template; $Lon_j; False:C215; $Obj_out)
						
					: (Value type:C1509($Var_field)=Is collection:K8:32)  // #114338 support collection
						
						$Lon_j:=$Lon_j+1  // pos, used for "insertAt" method, maybe not compatible with rows
						
						For each ($Obj_field; $Var_field)
							
							This:C1470.injectElement($Obj_field; $Obj_tags; $Obj_template; $Lon_j; True:C214; $Obj_out)
							
						End for each   // $Col_fields
						
					Else 
						// unknown
						ASSERT:C1129(dev_Matrix; "unknown data type of fields: "+String:C10(Value type:C1509($Var_field))+", must be field or a collection of fields")
						
				End case 
			End for each 
			
			// Remove original template duplicated element
			For each ($Obj_element; $Obj_template.elements)
				
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
				
				For each ($Obj_element; $Obj_template.relation.elements)
					
					If ($Obj_element.dom#Null:C1517)
						If (Not:C34(Bool:C1537($Obj_element.dom.doNotClose)))  // do not close if in global storyboard, if external file or string must be closed
							$Obj_element.dom.root().close()
						End if 
					End if 
				End for each 
			End if 
			
		End if 
		
		
		// Manage relation in header fields (before stack view and diplicated element)
		$Lon_j:=1
		For each ($Obj_field; $Obj_tags.table.fields; 0; Num:C11($Obj_template.fields.count))
			If (Num:C11($Obj_field.id)=0)  // relation to N field
				
				If (Length:C16(String:C10($Obj_field.bindingType))=0)
					$Obj_field.bindingType:="relation"  // TODO this must be done before when we are looking for binding
				End if 
				// find the element $Lon_j by looking at userDefinedRuntimeAttribute
				
				$Dom_:=$Dom_root.findByXPath("//*/userDefinedRuntimeAttribute[@keyPath='bindTo.record.___FIELD_"+String:C10($Lon_j)+"___']")  // or value="___FIELD_1_BINDING_TYPE___"
				If ($Dom_.success)
					C_OBJECT:C1216($Dom_parent)
					$Dom_parent:=$Dom_.parent()
					
					If (Not:C34($Dom_parent.findByXPath("[@keyPath=relationFormat]").success))
						$Txt_buffer:="<userDefinedRuntimeAttribute type=\"string\" keyPath=\"relationFormat\" value=\"___FIELD_"+String:C10($Lon_j)+"_FORMAT___\"/>"
						$Dom_parent.append(xml("parse"; New object:C1471("variable"; $Txt_buffer)))
					End if 
					If (Not:C34($Dom_parent.findByXPath("[@keyPath=relationName]").success))
						$Txt_buffer:="<userDefinedRuntimeAttribute type=\"string\" keyPath=\"relationName\" value=\"___FIELD_"+String:C10($Lon_j)+"___\"/>"
						$Dom_parent.append(xml("parse"; New object:C1471("variable"; $Txt_buffer)))
					End if 
					
					$Boo_buffer:=True:C214
				End if 
				
			End if 
			$Lon_j:=$Lon_j+1
		End for each 
		
		$Lon_j:=1
		For each ($Obj_field; $Obj_tags.table.fields)
			If (Num:C11($Obj_field.id)=0)  // relation to N field
				
				$Dom_:=$Dom_root.findByXPath("//*/userDefinedRuntimeAttribute[@keyPath='bindTo.record.___FIELD_"+String:C10($Lon_j)+"___']")  // or value="___FIELD_1_BINDING_TYPE___"
				$Dom_:=$Dom_.parentWithName("scene").firstChild().firstChild()  // objects.XController (table view , view , collection view)
				
				If ($Dom_.success)
					
					$Obj_template.relation:=New object:C1471("elements"; New collection:C1472())
					$Obj_element:=New object:C1471(\
						"insertInto"; $Dom_root.findByXPath("/document/scenes"); \
						"dom"; xml("load"; $Folder_relation.file("storyboardScene.xml")); \
						"idCount"; 3; \
						"tagInterfix"; "SN"; \
						"insertMode"; "append")
					$Obj_template.relation.elements.push($Obj_element)
					
					$Obj_element:=New object:C1471("idCount"; 1; \
						"insertInto"; $Dom_; \
						"tagInterfix"; "SG"; \
						"insertMode"; "append"\
						)
					
					$Txt_buffer:=This:C1470.relationSegue($Obj_template.relation)
					$Obj_element.insertInto:=$Obj_element.insertInto.findOrCreate("connections")  // Find its <connections> children, if not exist create it
					$Obj_element.dom:=xml("parse"; New object:C1471("variable"; $Txt_buffer))
					$Obj_template.relation.elements.push($Obj_element)
					
					This:C1470.injectElement($Obj_field; $Obj_tags; $Obj_template; $Lon_j; False:C215; $Obj_out)
					
				Else 
					
					// Invalid relation
					ASSERT:C1129(dev_Matrix; "Cannot add relation on this template. Cannot find viewController: "+JSON Stringify:C1217($Obj_field))
					
				End if 
			End if 
			$Lon_j:=$Lon_j+1
		End for each 
		
		// Save file at destination after replacing tags
		If ($Boo_buffer)
			
			$Txt_buffer:=$Dom_root.export().variable
			$Txt_buffer:=Process_tags($Txt_buffer; $Obj_tags; New collection:C1472("storyboard"; "___TABLE___"))
			$Txt_buffer:=Replace string:C233($Txt_buffer; "<userDefinedRuntimeAttribute type=\"image\" keyPath=\"image\"/>"; "")  // Remove useless empty image
			
			C_OBJECT:C1216($File_)
			$File_:=$target.file(Process_tags(String:C10($Obj_template.storyboard); $Obj_tags; New collection:C1472("filename")))
			$File_.setText($Txt_buffer; "UTF-8"; Document with CRLF:K24:20)
			
			$Obj_out.format:=This:C1470.format($target)
			
		End if 
		
		$Dom_root.close()
		
		$Obj_out.success:=Not:C34(ob_error_has($Obj_out))  // XXX maybe better error managing, take into account all "doms"
		
	Else   // Not a document
		
		ASSERT:C1129(dev_Matrix; "Missing or not decodable "+This:C1470.type+"storyboard")
		
		$Obj_out.errors:=New collection:C1472("Template "+This:C1470.path.path+" not decodable or available")
		$Obj_out.success:=False:C215
		
	End if 
	
	$0:=$Obj_out
	
	
Function checkTemplateElements($Obj_template : Object; $Txt_buffer : Text; $Dom_root : Object/*xml node*/)
	
	If ($Obj_template.elements=Null:C1517)
		
		C_OBJECT:C1216($Obj_element)
		// Elements not defined in manifest, try to compute it using storyboard XMLs
		ARRAY TEXT:C222($tTxt_result; 0)
		
		C_COLLECTION:C1488($Col_)
		Case of 
				// ----------------------------------------
			: (Rgx_ExtractText("TAG-(.?.?)-001"; $Txt_buffer; "1"; ->$tTxt_result)=0)
				
				$Col_:=New collection:C1472()
				ARRAY TO COLLECTION:C1563($Col_; $tTxt_result)
				$Col_:=$Col_.distinct()
				$Col_:=$Col_.map("col_valueToObject"; "tagInterfix")
				
				$Obj_template.elements:=$Col_
				
				// ----------------------------------------
			: (Value type:C1509($Obj_template.elementsID)=Is collection:K8:32)  // alernative way not documented, declare id of elements
				
				$Col_:=New collection:C1472()
				C_TEXT:C284($Txt_id)
				For each ($Txt_id; $Obj_template.elementsID)
					
					$Obj_element:=New object:C1471()
					$Obj_element.dom:=$Dom_root.findById($Txt_id)
					$Obj_element.originalId:=$Txt_id
					
					$Obj_element:=This:C1470.fixDomChildID($Obj_element).element
					
				End for each 
				
				$Obj_template.elements:=$Col_
			Else 
				
				// find by attributes? find by children kel value?
				C_OBJECT:C1216($result)
				$result:=$Dom_root.findByAttribute("userLabel"; "stack")
				If ($result.success)
					If ($result.elements.length>0)  // Value type($result.elements)=Is collection)
						
						$Obj_element:=New object:C1471()
						$Obj_element.dom:=$result.elements[0]
						$Obj_element:=This:C1470.fixDomChildID($Obj_element).element
						
						$Obj_template.elements:=New collection:C1472($Obj_element)
						
					End if 
				End if 
				
		End case 
		
	End if 
	
	