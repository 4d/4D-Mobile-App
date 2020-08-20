Class extends Storyboard

Class constructor
	C_OBJECT:C1216($1)
	Super:C1705($1)
	This:C1470.type:="navigation"
	
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
	
	$Obj_out.doms:=New collection:C1472()
	
	If ($Obj_template.storyboard=Null:C1517)
		
		$Obj_template.storyboard:=$Obj_template.parent[This:C1470.type].storyboard
		
	End if 
	
	This:C1470.path:=Folder:C1567($Obj_template.source; fk platform path:K87:2).file(String:C10($Obj_template.storyboard))
	
	If (This:C1470.path.exists)
		
		C_OBJECT:C1216($Dom_root; $Dom_child; $Dom_)
		$Dom_root:=xml("load"; This:C1470.path)
		
		// Look up first all the elements. Dom could be modifyed
		C_OBJECT:C1216($Obj_element)
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
				
				C_LONGINT:C283($Lon_length)
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
				
				C_LONGINT:C283($Lon_ids)
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
		C_OBJECT:C1216($Obj_table)
		For each ($Obj_table; $Obj_tags.navigationTables)
			
			$Obj_table.segueDestinationId:=This:C1470.randomID()
			
		End for each 
		
		// For each element... (scene, cell, ...)
		For each ($Obj_element; $Obj_template.elements)
			
			If ($Obj_element.dom#Null:C1517)
				
				// ... and table
				C_LONGINT:C283($Lon_j)
				$Lon_j:=0
				
				For each ($Obj_table; $Obj_tags.navigationTables)
					
					$Lon_j:=$Lon_j+1  // pos
					
					// set tags
					$Obj_tags.table:=$Obj_table
					
					If (Length:C16(String:C10($Obj_element.tagInterfix))>0)
						
						$Obj_tags.tagInterfix:=$Obj_element.tagInterfix
						$Obj_tags.storyboardIDs:=This:C1470.randomIDS($Obj_element.idCount)
						
					End if 
					
					// Insert after processing tags
					C_TEXT:C284($Txt_buffer)
					$Txt_buffer:=$Obj_element.dom.export().variable
					$Txt_buffer:=Process_tags($Txt_buffer; $Obj_tags; $Obj_template.tagtypes)
					
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
		$Txt_buffer:=Process_tags($Txt_buffer; $Obj_tags; New collection:C1472(This:C1470.type+".storyboard"))
		
		C_OBJECT:C1216($File_)
		$File_:=$target.file(String:C10($Obj_template.storyboard))
		$File_.setText($Txt_buffer; "UTF-8"; Document with CRLF:K24:20)
		
		$Obj_out.format:=This:C1470.format()
		
		$Obj_out.success:=True:C214  // XXX maybe better error managing, take into account all "doms"
		
	Else   // Not a document
		
		ASSERT:C1129(dev_Matrix; "Missing "+This:C1470.type+" storyboard")
		$Obj_out.errors:=New collection:C1472("Missing "+This:C1470.type+" storyboard: "+This:C1470.path.path)
		
	End if 
	
	$0:=$Obj_out