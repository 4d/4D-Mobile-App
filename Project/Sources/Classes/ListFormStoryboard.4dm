Class extends Storyboard

Class constructor($path : 4D:C1709.File)
	Super:C1705($path)
	This:C1470.type:="listform"
	This:C1470.relationFolder:=cs:C1710.path.new().templates().folder("relation")
	
	// MARK:- run
Function run($Obj_template : Object; $target : Object/*4D.Folder*/; $Obj_tags : Object)->$Obj_out : Object
	$Obj_out:=New object:C1471()
	$Obj_out.doms:=New collection:C1472()
	
	This:C1470.checkStoryboardPath($Obj_template)  // set default path if not defined
	
	If (This:C1470.path.exists)
		
		var $t : Text
		$t:=This:C1470.path.getText()
		
		If (Length:C16($t)>0)  // a custom template or not well described one (do not warn about it but we could read by reading file)
			
			var $Obj_element : Object
			$Obj_element:=New object:C1471(\
				"___TABLE_ACTIONS___"; "tableActions"; \
				"___ENTITY_ACTIONS___"; "recordActions")
			
			var $Txt_cmd : Text
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
		var $Boo_buffer : Boolean
		$Boo_buffer:=False:C215
		
		var $Col_fields : Collection
		$Col_fields:=$Obj_tags.table.fields
		
		var $Boo_enableBarcode : Boolean
		$Boo_enableBarcode:=Bool:C1537($Obj_tags.table.searchableWithBarcode)
		
		// Manage relation field?
		var $Boo_hasRelation : Boolean
		$Boo_hasRelation:=False:C215
		
		var $Obj_field : Object
		For each ($Obj_field; $Col_fields) Until ($Boo_hasRelation)
			If (This:C1470.isRelationField($Obj_field))  // relation to N field
				$Boo_hasRelation:=True:C214
			End if 
		End for each 
		
		If ($Boo_hasRelation | $Boo_enableBarcode)
			
			var $Dom_root; $Dom_child; $Dom_ : Object/*_o_xml*/
			$Dom_root:=_o_xml("load"; This:C1470.path)
			
			// Edit for relations
			If ($Boo_hasRelation)
				C_LONGINT:C283($Lon_j)
				$Lon_j:=1
				For each ($Obj_field; $Col_fields)
					If (This:C1470.isRelationField($Obj_field))  // relation to N field
						If ($Obj_field.isToMany=Null:C1517)
							$Obj_field.isToMany:=(Num:C11($Obj_field.fieldType)=8859) || (String:C10($Obj_field.kind)="relatedEntities")
						End if 
						If (This:C1470.xmlAppendRelationAttributeForField($Lon_j; $Dom_root; Bool:C1537($Obj_field.isToMany)).success)
							$Boo_buffer:=True:C214  // we make modification
						End if 
						
					End if 
					$Lon_j:=$Lon_j+1
				End for each 
				
				// segue and connection (OPTI maybe with do not do another loop)
				
				$Lon_j:=1
				For each ($Obj_field; $Col_fields)
					If (This:C1470.isRelationField($Obj_field))  // relation to N field
						
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
	
	// MARK:- features
Function xmlAppendSearchWithBarCode($root : Object)->$node : Object
	
	var $t : Text
	var $parent : Object
	
	$node:=$root.findByXPath("//*/userDefinedRuntimeAttribute[@keyPath='searchableField']")
	
	If ($node.success)
		
		$parent:=$node.parent()
		
		If (Not:C34($parent.findByXPath("[@keyPath=searchUsingCodeScanner]").success))
			
			$t:="<userDefinedRuntimeAttribute type=\"boolean\" keyPath=\"searchUsingCodeScanner\" value=\"YES\"/>"
			$parent.append(_o_xml("parse"; New object:C1471("variable"; $t)))
			
		Else 
			
			$node.success:=False:C215  // Nothing done , so nothing to do (like write file)
			
		End if 
	End if 
	