Class extends Storyboard

Class constructor($in : Object)
	If (Count parameters:C259>0)
		Super:C1705($in)
	Else 
		Super:C1705()
	End if 
	This:C1470.type:="navigation"
	
Function run($Obj_template : Object; $target : Object; $Obj_tags : Object)->$Obj_out : Object
	$Obj_out:=New object:C1471()
	$Obj_out.doms:=New collection:C1472()
	
	
	
	This:C1470.checkStoryboardPath($Obj_template)  // set default path if not defined
	
	If (This:C1470.path.exists)
		
		var $Dom_root; $Dom_ : Object
		$Dom_root:=_o_xml("load"; This:C1470.path)
		
		// Look up first all the elements. Dom could be modifyed
		var $Obj_element : Object
		For each ($Obj_element; $Obj_template.elements)
			
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
				
				var $Lon_length : Integer
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
				This:C1470.checkIDCount($Obj_element)
				This:C1470.checkInsertInto($Obj_element)
				This:C1470.checkInsert($Obj_element; $Obj_tags)
			End if 
		End for each 
		
		// For each table create a storyboard id shared by all xml elements
		var $Obj_table : Object
		For each ($Obj_table; $Obj_tags.navigationTables)
			
			$Obj_table.segueDestinationId:=This:C1470._randomID()
			
		End for each 
		
		// For each element... (scene, cell, ...)
		For each ($Obj_element; $Obj_template.elements)
			
			If ($Obj_element.dom#Null:C1517)
				
				// ... and table
				var $Lon_j : Integer
				$Lon_j:=0
				
				For each ($Obj_table; $Obj_tags.navigationTables)
					
					$Lon_j:=$Lon_j+1  // pos
					
					// set tags
					$Obj_tags.table:=$Obj_table
					
					If (Length:C16(String:C10($Obj_element.tagInterfix))>0)
						
						$Obj_tags.tagInterfix:=$Obj_element.tagInterfix
						$Obj_tags.storyboardIDs:=This:C1470._randomIDS($Obj_element.idCount)
						
					End if 
					
					// Insert after processing tags
					var $Txt_buffer : Text
					$Txt_buffer:=$Obj_element.dom.export().variable
					If ($Obj_table.storyboard#Null:C1517)  // for action for instance is not a list form, so replace
						$Txt_buffer:=Replace string:C233($Txt_buffer; "___TABLE___ListForm"; $Obj_table.storyboard)
					End if 
					
					$Txt_buffer:=Process_tags($Txt_buffer; $Obj_tags; $Obj_template.tagtypes)
					
					$Dom_:=Null:C1517
					
					If (Bool:C1537($Obj_element.insertInto.success))
						
						$Dom_:=This:C1470.insertInto($Obj_element; $Txt_buffer; $Lon_j)
						$Obj_out.doms.push($Dom_)
						
					Else 
						
						ob_error_add($Obj_out; "Failed to insert after processing tags '"+$Txt_buffer+"'")
						
					End if 
				End for each 
				
				// Remove originals template element
				$Obj_element.dom.remove()
				
			End if 
		End for each 
		
		// Save file at destination after replacing tags
		$Txt_buffer:=$Dom_root.export().variable
		$Dom_root.close()
		$Txt_buffer:=Process_tags($Txt_buffer; $Obj_tags; New collection:C1472(This:C1470.type+".storyboard"))
		
		var $File_ : Object
		$File_:=$target.file(String:C10($Obj_template.storyboard))
		$File_.setText($Txt_buffer; "UTF-8"; Document with CRLF:K24:20)
		
		$Obj_out.format:=This:C1470.format($File_)
		
		$Obj_out.success:=True:C214  // XXX maybe better error managing, take into account all "doms"
		
	Else   // Not a document
		
		ASSERT:C1129(dev_Matrix; "Missing "+This:C1470.type+" storyboard")
		$Obj_out.errors:=New collection:C1472("Missing "+This:C1470.type+" storyboard: "+This:C1470.path.path)
		
	End if 
	