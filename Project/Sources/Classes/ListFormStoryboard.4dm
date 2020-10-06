Class extends Storyboard

Class constructor
	C_OBJECT:C1216($1)
	If (Count parameters:C259>0)
		Super:C1705($1)
	Else 
		Super:C1705()
	End if 
	This:C1470.type:="listform"
	
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
	
	If (This:C1470.path.exists)
		
		C_TEXT:C284($Txt_buffer)
		$Txt_buffer:=This:C1470.path.getText()
		
		If (Length:C16($Txt_buffer)>0)  // a custom template or not well described one (do not warn about it but we could read by reading file)
			
			C_OBJECT:C1216($Obj_element)
			$Obj_element:=New object:C1471(\
				"___TABLE_ACTIONS___"; "tableActions"; \
				"___ENTITY_ACTIONS___"; "recordActions")
			
			C_TEXT:C284($Txt_cmd)
			For each ($Txt_cmd; $Obj_element)
				
				If ($Obj_tags.table[$Obj_element[$Txt_cmd]]#Null:C1517)  // there is selection action
					
					If (Position:C15($Txt_cmd; $Txt_buffer)=0)
						
						ob_warning_add($Obj_out; "List template storyboard '"+This:C1470.path.path+"'do not countains action tag "+$Txt_cmd)
						
						// XXX here could fix by dom manipulation instead of warn (some code in #106033) (fix on source or in destination?)
						// just use code under this one do edit dom
						
					End if 
				End if 
			End for each 
		End if 
		
		// check if we need to update for relation
		C_OBJECT:C1216($Obj_field)
		C_BOOLEAN:C305($Boo_buffer; $Boo_hasRelation)
		$Boo_buffer:=False:C215
		// Manage relation field?
		$Boo_hasRelation:=False:C215
		For each ($Obj_field; $Obj_tags.table.fields) Until ($Boo_hasRelation)
			If (Num:C11($Obj_field.id)=0)  // relation to N field
				$Boo_hasRelation:=True:C214
			End if 
		End for each 
		
		If ($Boo_hasRelation)
			
			C_OBJECT:C1216($Dom_root; $Dom_child; $Dom_)
			$Dom_root:=xml("load"; This:C1470.path)
			
			// TODO factorize with detailFormStoryboard if possible
			C_LONGINT:C283($Lon_j)
			$Lon_j:=1
			For each ($Obj_field; $Obj_tags.table.fields)
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
			
			// segue and connection (OPTI maybe with do not do another loop)
			C_OBJECT:C1216($Folder_relation)
			$Folder_relation:=COMPONENT_Pathname("templates").folder("relation")
			
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
						
						If (Length:C16(String:C10($Obj_field.format))=0)
							$Obj_field.format:=$Obj_field.shortLabel  // TODO #117601 check si ob copy? not edit project ?
						End if 
						
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
		End if 
		
		$Obj_out.success:=Not:C34(ob_error_has($Obj_out))
		
	Else   // Not a document
		
		ASSERT:C1129(dev_Matrix; "Missing "+This:C1470.type+" storyboard")
		
	End if 