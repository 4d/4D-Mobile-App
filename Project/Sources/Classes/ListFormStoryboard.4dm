Class extends Storyboard

Class constructor
	C_OBJECT:C1216($1)
	Super:C1705($1)
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
	
	If ($Obj_template.storyboard=Null:C1517)  // set default path if not defined
		
		$Obj_template.storyboard:=$Obj_template.parent[This:C1470.type].storyboard
		
	End if 
	
	This:C1470.path:=Folder:C1567($Obj_template.source; fk platform path:K87:2).file(String:C10($Obj_template.storyboard))
	
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
						
					End if 
				End if 
			End for each 
		End if 
		
		$Obj_out.success:=True:C214
		
	Else   // Not a document
		
		ASSERT:C1129(dev_Matrix; "Missing "+This:C1470.type+" storyboard")
		
	End if 