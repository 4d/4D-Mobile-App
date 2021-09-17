Class extends Storyboard

Class constructor
	C_OBJECT:C1216($1)
	If (Count parameters:C259>0)
		Super:C1705($1)
	Else 
		Super:C1705()
	End if 
	This:C1470.type:="listform"
	
	This:C1470.relationFolder:=_o_COMPONENT_Pathname("templates").folder("relation")
	
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
		
		C_TEXT:C284($t)
		$t:=This:C1470.path.getText()
		
		If (Length:C16($t)>0)  // a custom template or not well described one (do not warn about it but we could read by reading file)
			
			C_OBJECT:C1216($Obj_element)
			$Obj_element:=New object:C1471(\
				"___TABLE_ACTIONS___"; "tableActions"; \
				"___ENTITY_ACTIONS___"; "recordActions")
			
			C_TEXT:C284($Txt_cmd)
			For each ($Txt_cmd; $Obj_element)
				
				If ($Obj_tags.table[$Obj_element[$Txt_cmd]]#Null:C1517)  // there is selection action
					
					If (Position:C15($Txt_cmd; $t)=0)
						
						ob_warning_add($Obj_out; "List template storyboard '"+This:C1470.path.path+"'do not countains action tag "+$Txt_cmd)
						
						// XXX here could fix by dom manipulation instead of warn (some code in #106033) (fix on source or in destination?)
						// just use code under this one do edit dom
						// $Boo_mustEdit:=True
						
					End if 
				End if 
			End for each 
		End if 
		
		// check if we need to update for relation
		C_BOOLEAN:C305($Boo_buffer)
		$Boo_buffer:=False:C215
		
		C_OBJECT:C1216($Obj_field)
		C_COLLECTION:C1488($Col_fields)
		$Col_fields:=$Obj_tags.table.fields
		
		C_BOOLEAN:C305($Boo_enableBarcode)
		$Boo_enableBarcode:=Bool:C1537($Obj_tags.table.searchableWithBarcode)
		
		// Manage relation field?
		C_BOOLEAN:C305($Boo_hasRelation)
		$Boo_hasRelation:=False:C215
		For each ($Obj_field; $Col_fields) Until ($Boo_hasRelation)
			If ((Num:C11($Obj_field.id)=0) & (Num:C11($Obj_field.type)#-3/*Computed*/))  // relation to N field
				$Boo_hasRelation:=True:C214
			End if 
		End for each 
		
		If ($Boo_hasRelation | $Boo_enableBarcode)
			
			C_OBJECT:C1216($Dom_root; $Dom_child; $Dom_)
			$Dom_root:=xml("load"; This:C1470.path)
			
			// Edit for relations
			If ($Boo_hasRelation)
				C_LONGINT:C283($Lon_j)
				$Lon_j:=1
				For each ($Obj_field; $Col_fields)
					If (Num:C11($Obj_field.id)=0)  // relation to N field
						
						If (This:C1470.xmlAppendRelationAttributeForField($Lon_j; $Dom_root; Bool:C1537($Obj_field.isToMany)).success)
							$Boo_buffer:=True:C214  // we make modification
						End if 
						
					End if 
					$Lon_j:=$Lon_j+1
				End for each 
				
				// segue and connection (OPTI maybe with do not do another loop)
				
				$Lon_j:=1
				For each ($Obj_field; $Col_fields)
					If (Num:C11($Obj_field.id)=0)  // relation to N field
						
						This:C1470.injectSegue($Lon_j; $Dom_root; $Obj_field; $Obj_tags; $Obj_template; $Obj_out)
						
					End if 
					
					$Lon_j:=$Lon_j+1
				End for each 
				
			End if 
			
			If ($Boo_enableBarcode)
				If (This:C1470.xmlAppendSearchWithBarCode($Dom_root).success)
					$Boo_buffer:=True:C214  // we make modification
				End if 
			End if 
			
			// Save file at destination after replacing tags
			If ($Boo_buffer)
				
				This:C1470.exportDom($Obj_template; $target; $Obj_tags; $Dom_root)
				
			End if 
			
			$Dom_root.close()
			
			// Else, no relation, currently no storyboard dynamic edition, only tag replacement done before
		End if 
		
		$Obj_out.success:=Not:C34(ob_error_has($Obj_out))
		
	Else   // Not a document
		
		ASSERT:C1129(dev_Matrix; "Missing "+This:C1470.type+" storyboard")
		
	End if 
	
Function xmlAppendSearchWithBarCode($root : Object)->$node : Object
	
	var $t : Text
	var $parent : Object
	
	$node:=$root.findByXPath("//*/userDefinedRuntimeAttribute[@keyPath='searchableField']")
	
	If ($node.success)
		
		$parent:=$node.parent()
		
		If (Not:C34($parent.findByXPath("[@keyPath=searchUsingCodeScanner]").success))
			
			$t:="<userDefinedRuntimeAttribute type=\"boolean\" keyPath=\"searchUsingCodeScanner\" value=\"YES\"/>"
			$parent.append(xml("parse"; New object:C1471("variable"; $t)))
			
		Else 
			
			$node.success:=False:C215  // Nothing done , so nothing to do (like write file)
			
		End if 
	End if 
	