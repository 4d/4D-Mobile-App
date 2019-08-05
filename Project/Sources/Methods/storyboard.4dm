//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : storyboard
  // Database: 4D Mobile Express
  // Created #27-6-2017 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // manage storyboard xml
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_buffer)
C_LONGINT:C283($Lon_i;$Lon_ii;$Lon_parameters;$Lon_ids;$Lon_length)
C_TEXT:C284($Dom_;$Dom_root);
C_TEXT:C284($Txt_buffer;$Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
C_OBJECT:C1216($File_;$Obj_color;$Obj_in;$Obj_out;$Obj_element;$Obj_table;$Obj_field;$Obj_tag)
C_COLLECTION:C1488($Col_)

If (False:C215)
	C_OBJECT:C1216(storyboard ;$0)
	C_OBJECT:C1216(storyboard ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_out:=New object:C1471(\
		"success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Asserted:C1132($Obj_in.action#Null:C1517;"Missing the tag \"action\""))
	
	Case of 
			
			  //______________________________________________________
		: ($Obj_in.action="fieldBinding")
			
			Case of 
					
					  //----------------------------------------
				: ($Obj_in.field=Null:C1517)
					
					$Obj_out.errors:=New collection:C1472("field must be specified to fill binding type")
					
					  //----------------------------------------
				: ($Obj_in.field.type=Null:C1517)
					
					$Obj_out.errors:=New collection:C1472("field must be have a type to fill binding type")
					
					  //----------------------------------------
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
									
									ob_error_add ($Obj_out;"Unknown data formatter '"+$Obj_field.format+"'")
									
								End if 
								
							Else 
								
								ob_error_add ($Obj_out;"No list of formatters provided to resolve '"+$Obj_field.format+"'")
								
							End if 
							
							  //........................................
					End case 
					
					If ($Obj_out.format#Null:C1517)
						
						$Obj_out.bindingType:=Choose:C955(Length:C16(String:C10($Obj_out.format.binding))>0;\
							String:C10($Obj_out.format.binding)+","+String:C10($Obj_out.format.name);\
							String:C10($Obj_out.format.name))
						
						$Obj_out.success:=True:C214
						
					End if 
					
					If (Length:C16(String:C10($Obj_out.bindingType))=0)
						
						If (Length:C16(String:C10($Obj_in.field.relatedDataClass))>0)
							
							$Obj_out.bindingType:="Transformable"
							$Obj_out.success:=True:C214
							
						Else 
							
							  // set default value according to type (here type from 4d structure)
							If ($Obj_field.fieldType<commonValues.defaultFieldBindingTypes.length)
								
								$Obj_out.bindingType:=commonValues.defaultFieldBindingTypes[$Obj_in.field.fieldType]
								$Obj_out.success:=(Length:C16(String:C10($Obj_out.bindingType))>0)
								
							Else 
								
								ob_error_add ($Obj_out;"No default format for type '"+String:C10($Obj_field.fieldType)+"'")
								
							End if 
						End if 
					End if 
					
					  //----------------------------------------
			End case 
			
			  //______________________________________________________
		: ($Obj_in.action="randomId")  // Return one random id for storyboard xml element
			
			$Txt_buffer:=Generate UUID:C1066
			$Txt_buffer:=Substring:C12($Txt_buffer;1;3)+"-"+Substring:C12($Txt_buffer;4;2)+"-"+Substring:C12($Txt_buffer;7;3)
			
			$Obj_out.value:=$Txt_buffer
			$Obj_out.success:=True:C214
			
			  //______________________________________________________
		: ($Obj_in.action="randomIds")  // Return `length` random id for storyboard xml element
			
			$Obj_out.value:=New collection:C1472
			
			For ($Lon_i;1;$Obj_in.length;1)
				
				$Txt_buffer:=Generate UUID:C1066
				$Txt_buffer:=Substring:C12($Txt_buffer;1;3)+"-"+Substring:C12($Txt_buffer;4;2)+"-"+Substring:C12($Txt_buffer;7;3)
				
				$Obj_out.value.push($Txt_buffer)
				
			End for 
			
			  // XXX maybe add a list of forbidden id from current storyboard, then check if collection have distinct element
			  // storyboard (New object("action";"attributelist";"path";$Obj_in.path;"attribute";"id"))
			  // and do a while value.count < $Obj_in.length
			
			  //______________________________________________________
		: ($Obj_in.action="object")
			
			If ($Obj_in.path#Null:C1517)
				
				  // Load as object
				
				$Obj_out:=xml_fileToObject ($Obj_in.path)
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("path  must be specified")
				
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="navigation")
			
			If ($Obj_in.template.storyboard=Null:C1517)
				
				$Obj_in.template.storyboard:="Sources/Forms/Navigation/MainNavigation.storyboard"  // TODO try to get on parent template
				
			End if 
			
			$File_:=Folder:C1567($Obj_in.template.source;fk platform path:K87:2).file(String:C10($Obj_in.template.storyboard))  // maybe a list of files later, or doc_catalog
			
			$Dom_root:=DOM Parse XML source:C719($File_.platformPath)
			
			  // Look up first all the elements. Dom could be modifyed
			
			For each ($Obj_element;$Obj_in.template.elements)
				
				If (Length:C16(String:C10($Obj_element.xpath))>0)
					
					$Obj_element.xmlId:=xml_findElement ($Dom_root;$Obj_element.xpath).reference
					
					ASSERT:C1129($Obj_element.xmlId#"00000000000000000000000000000000";"Invalid xpath "+$Obj_element.xpath+" for file "+$File_.path)
					ASSERT:C1129($Obj_element.xmlId#"";"Invalid xpath "+$Obj_element.xpath+" for file "+$File_.path)
					
				Else 
					
					$Lon_length:=Length:C16(String:C10($Obj_element.tagInterfix))
					
					Case of 
							
							  //----------------------------------------
						: ($Lon_length=2)
							
							$Obj_element.xmlId:=DOM Find XML element by ID:C1010($Dom_root;"TAG-"+$Obj_element.tagInterfix+"-001")
							
							ASSERT:C1129($Obj_element.xmlId#"00000000000000000000000000000000";"Root element with id 'TAG-"+$Obj_element.tagInterfix+"-001' not found for file "+$File_.path)
							ASSERT:C1129($Obj_element.xmlId#"";"Root element with id 'TAG-"+$Obj_element.tagInterfix+"-001' not found for file "+$File_.path)
							
							  //----------------------------------------
						: ($Lon_length>0)
							
							ASSERT:C1129(False:C215;"Element 'tagInterfix' defined in manifest.json "+$Obj_element.tagInterfix+" must have exactly two caracters")
							
							  //----------------------------------------
						Else 
							
							ASSERT:C1129(False:C215;"No xpath defined for template file "+$File_.path+" to find element "+JSON Stringify:C1217($Obj_element))
							
							  //----------------------------------------
					End case 
				End if 
				
				$Obj_element.xmlIdParent:=DOM Get parent XML element:C923($Obj_element.xmlId)  // XXX add check on id
				
			End for each 
			
			  // For each table create a storyboard id shared by all xml elements
			
			For each ($Obj_table;$Obj_in.tags.navigationTables)
				
				$Obj_table.segueDestinationId:=storyboard (New object:C1471("action";"randomId")).value
				
			End for each 
			
			  // For each element... (scene, cell, ...)
			For each ($Obj_element;$Obj_in.template.elements)
				
				  // ... and table
				$Lon_ii:=0
				
				For each ($Obj_table;$Obj_in.tags.navigationTables)
					
					$Lon_ii:=$Lon_ii+1  // pos
					
					  // set tags
					$Obj_in.tags.table:=$Obj_table
					
					If (Length:C16(String:C10($Obj_element.tagInterfix))>0)
						
						$Obj_in.tags.tagInterfix:=$Obj_element.tagInterfix
						
						$Lon_ids:=Num:C11($Obj_element.idCount)
						
						If ($Lon_ids=0)
							
							  // idCount, not defined, try to count into storyboard
							$Lon_ids:=0
							$Dom_:=$Obj_element.xmlId
							
							While ($Dom_#"00000000000000000000000000000000")
								
								$Lon_ids:=$Lon_ids+1
								$Dom_:=DOM Find XML element by ID:C1010($Obj_element.xmlId;"TAG-"+$Obj_element.tagInterfix+"-"+String:C10($Lon_ids+1;"##000"))
								
							End while 
							
							If ($Lon_ids=1)
								
								$Lon_ids:=32
								
							End if 
						End if 
						
						$Obj_element.idCount:=$Lon_ids
						$Obj_in.tags.storyboardIDs:=storyboard (New object:C1471("action";"randomIds";"length";$Lon_ids)).value
						
					End if 
					
					  // Insert after processing tags
					DOM EXPORT TO VAR:C863($Obj_element.xmlId;$Txt_buffer)
					$Txt_buffer:=Process_tags ($Txt_buffer;$Obj_in.tags;$Obj_in.template.tagtypes)
					
					If (Length:C16(String:C10($Obj_element.insertMode))=0)
						
						$Obj_element.insertMode:="append"
						
					End if 
					
					Case of 
							
							  // ----------------------------------------
						: $Obj_element.insertMode="append"
							
							$Dom_:=DOM Append XML element:C1082($Obj_element.xmlIdParent;DOM Parse XML variable:C720($Txt_buffer))
							
							  // ----------------------------------------
						: $Obj_element.insertMode="first"
							
							$Dom_:=DOM Insert XML element:C1083($Obj_element.xmlIdParent;DOM Parse XML variable:C720($Txt_buffer);1)
							
							  // ----------------------------------------
						: $Obj_element.insertMode="iteration"
							
							$Dom_:=DOM Insert XML element:C1083($Obj_element.xmlIdParent;DOM Parse XML variable:C720($Txt_buffer);$Lon_ii)
							
							  // ----------------------------------------
							
							  //----------------------------------------
					End case 
				End for each 
				
				  // Remove originals template element
				DOM REMOVE XML ELEMENT:C869($Obj_element.xmlId)
				
			End for each 
			
			  // Save file at destination after replacing tags
			DOM EXPORT TO VAR:C863($Dom_root;$Txt_buffer)
			DOM CLOSE XML:C722($Dom_root)
			$Txt_buffer:=Process_tags ($Txt_buffer;$Obj_in.tags;New collection:C1472("navigation.storyboard"))
			
			$File_:=Folder:C1567($Obj_in.target;fk platform path:K87:2).file(String:C10($Obj_in.template.storyboard))
			$File_.setText($Txt_buffer;"UTF-8";Document with CRLF:K24:20)
			
			$Obj_out.format:=storyboard (New object:C1471(\
				"action";"format";\
				"path";$File_))
			
			$Obj_out.success:=True:C214  // XXX maybe better error managing
			
			  //______________________________________________________
		: ($Obj_in.action="detailform")
			
			If ($Obj_in.template.storyboard=Null:C1517)  // set default path if not defined
				
				$Obj_in.template.storyboard:="Sources/Forms/Tables/___TABLE___/___TABLE___DetailsForm.storyboard"  // TODO try to get this info from parent manifest file
				
			End if 
			
			$File_:=Folder:C1567($Obj_in.template.source;fk platform path:K87:2).file(String:C10($Obj_in.template.storyboard))
			
			If ($File_.exists)
				
				$Dom_root:=DOM Parse XML source:C719($File_.platformPath)
				
				If ($Obj_in.template.elements=Null:C1517)  // element not defined, try to compute it?
					
					DOM EXPORT TO VAR:C863($Dom_root;$Txt_buffer)  // or $Txt_buffer:=Document to text($File_)
					ARRAY TEXT:C222($tTxt_result;0)
					
					If (Rgx_ExtractText ("TAG-(.?.?)-001";$Txt_buffer;"1";->$tTxt_result)=0)
						
						$Col_:=New collection:C1472()
						ARRAY TO COLLECTION:C1563($Col_;$tTxt_result)
						$Col_:=$Col_.distinct()
						$Col_:=$Col_.map("col_valueToObject";"tagInterfix")
						
						$Obj_in.template.elements:=$Col_
						
					End if 
				End if 
				
				  //If (Bool(featuresFlags._103505))
				
				If (Length:C16($Txt_buffer)=0)  // there is element defined so we need to read here
					
					$Txt_buffer:=$File_.getText()
					
				End if 
				
				If (Length:C16($Txt_buffer)>0)
					
					If ($Obj_in.tags.table.recordActions#Null:C1517)
						
						$Txt_cmd:="___ENTITY_ACTIONS___"
						
						If (Position:C15($Txt_cmd;$Txt_buffer)=0)
							
							ob_warning_add ($Obj_out;"Detail template storyboard '"+$File_.path+"'do not countains action tag "+$Txt_cmd)
							
							  // XXX here could fix by dom manipulation instead of warn (some code in #106033) (fix on source or in destination?)
							
						End if 
					End if 
				End if 
				  //End if 
				
				  // Try to determine if must duplicate or not element
				  // elements are specified or 0 is set as "infinite" representation or if  max > count or one of them defined to 0
				If (($Obj_in.template.elements#Null:C1517)\
					 | (($Obj_in.template.fields.count#Null:C1517) & (Num:C11($Obj_in.template.fields.count)=0))\
					 | (($Obj_in.template.fields.max#Null:C1517) & (Num:C11($Obj_in.template.fields.max)=0))\
					 | (Num:C11($Obj_in.template.fields.max)>Num:C11($Obj_in.template.fields.count)))
					
					$Boo_buffer:=True:C214  // We found some element to duplicate, so we must write to file
					
					  // Look up first all the elements. Dom could be modifyed
					For each ($Obj_element;$Obj_in.template.elements)
						
						If (Length:C16(String:C10($Obj_element.xpath))>0)
							
							$Obj_element.xmlId:=xml_findElement ($Dom_root;$Obj_element.xpath).reference
							
							If ($Obj_element.xmlId="00000000000000000000000000000000")  // Num( ) = 0 ? or = a dom constant for invalid node
								
								$Obj_element.xmlId:=""
								
							End if 
							
							ASSERT:C1129($Obj_element.xmlId#"";"Invalid xpath "+$Obj_element.xpath+" for file "+$File_.path)
							
						Else 
							
							$Lon_length:=Length:C16(String:C10($Obj_element.tagInterfix))
							
							Case of 
									
									  //----------------------------------------
								: ($Lon_length=2)
									
									  // if "AS" document/resources and read children, to find ___FIELD_ICON___ ?? (no id for image, let ibtool fix that for the moment)
									
									$Obj_element.xmlId:=DOM Find XML element by ID:C1010($Dom_root;"TAG-"+String:C10($Obj_element.tagInterfix)+"-001")  // work only because element use it as xml id (sceneID will not work)
									
									If ($Obj_element.xmlId="00000000000000000000000000000000")
										
										$Obj_element.xmlId:=""
										
									End if 
									
									ASSERT:C1129($Obj_element.xmlId#"";"Root element with id 'TAG-"+String:C10($Obj_element.tagInterfix)+"-001' not found for file "+$File_.path)
									
									  //----------------------------------------
								: ($Lon_length>0)
									
									ASSERT:C1129(False:C215;"Element 'tagInterfix' defined in manifest.json "+String:C10($Obj_element.tagInterfix)+" must have exactly two caracters.")
									
									  //----------------------------------------
								Else 
									
									ASSERT:C1129(False:C215;"No tag interfix defined for element "+JSON Stringify:C1217($Obj_element)+" (TAG->tagInterfix>-001). Alternatively you can defined node xpath for template file "+$File_.path+" to find the xml element in storyboard.")
									
									  //----------------------------------------
							End case 
						End if 
						
						If (Length:C16(String:C10($Obj_element.xmlId))>0)
							
							$Obj_element.xmlIdParent:=DOM Get parent XML element:C923($Obj_element.xmlId)  // will failed if empty or wrong XXX add check
							
						End if 
					End for each 
					
					  // For each element... (scene, cell, ...)
					For each ($Obj_element;$Obj_in.template.elements)
						
						If (Length:C16(String:C10($Obj_element.xmlId))>0)
							
							  // ... and fields
							$Lon_ii:=Num:C11($Obj_in.template.fields.count)  // Start at first element, not in header
							
							For each ($Obj_field;$Obj_in.tags.table.detailFields;Num:C11($Obj_in.template.fields.count))
								
								$Lon_ii:=$Lon_ii+1  // pos
								
								  // Set tags:
								  // - field
								$Obj_in.tags.field:=$Obj_field
								
								  // - randoms ids
								If (Length:C16(String:C10($Obj_element.tagInterfix))>0)
									
									C_OBJECT:C1216($Obj_storyboardID)
									$Obj_storyboardID:=New object:C1471()
									$Obj_storyboardID.tagInterfix:=$Obj_element.tagInterfix
									
									If ($Obj_in.tags.storyboardID=Null:C1517)
										$Obj_in.tags.storyboardID:=New collection:C1472()
									End if 
									$Obj_in.tags.storyboardID.push($Obj_storyboardID)  // By using a collection we have now TAG for previous elements also injected (could be useful for "connections")
									
									
									$Lon_ids:=Num:C11($Obj_element.idCount)  // define id count allow to speed up and pass that
									
									If ($Lon_ids=0)
										
										  // idCount, not defined, try to count into storyboard
										$Lon_ids:=0
										$Dom_:=$Obj_element.xmlId
										
										While ($Dom_#"00000000000000000000000000000000")
											
											$Lon_ids:=$Lon_ids+1
											$Dom_:=DOM Find XML element by ID:C1010($Obj_element.xmlId;"TAG-"+$Obj_element.tagInterfix+"-"+String:C10($Lon_ids+1;"##000"))
											
										End while 
										
										If ($Lon_ids=1)
											
											$Lon_ids:=32  // default value if not found
											
										End if 
									End if 
									
									$Obj_element.idCount:=$Lon_ids  // as a result purpose
									$Obj_storyboardID.storyboardIDs:=storyboard (New object:C1471("action";"randomIds";"length";$Lon_ids)).value
									
								End if 
								
								  // Process tags on the element
								DOM EXPORT TO VAR:C863($Obj_element.xmlId;$Txt_buffer)
								$Txt_buffer:=Process_tags ($Txt_buffer;$Obj_in.tags;New collection:C1472("___TABLE___";"detailform"))
								
								  // Insert node for this element
								
								  // - Check how to insert new node (ie. the insertMode)
								If (Length:C16(String:C10($Obj_element.insertMode))=0)
									
									$Obj_element.insertMode:="append"
									
								End if 
								
								  // - Check if there is some mandatories tags before inserting
								If (Value type:C1509($Obj_element.tags.mandatories)=Is collection:K8:32)
									
									For each ($Obj_tag;$Obj_element.tags.mandatories)
										
										If (String:C10($Obj_in.tags[String:C10($Obj_tag.key)])="")  // support not empty rules now
											
											$Obj_element.insertMode:="none"  // do not insert
											
										End if 
									End for each 
								End if 
								
								  // - Do insert in dom
								Case of 
										
										  // ----------------------------------------
									: $Obj_element.insertMode="append"
										
										$Dom_:=DOM Append XML element:C1082($Obj_element.xmlIdParent;DOM Parse XML variable:C720($Txt_buffer))
										
										  // ----------------------------------------
									: $Obj_element.insertMode="first"
										
										$Dom_:=DOM Insert XML element:C1083($Obj_element.xmlIdParent;DOM Parse XML variable:C720($Txt_buffer);1)
										
										  // ----------------------------------------
									: $Obj_element.insertMode="iteration"
										
										$Dom_:=DOM Insert XML element:C1083($Obj_element.xmlIdParent;DOM Parse XML variable:C720($Txt_buffer);$Lon_ii)
										
										  // ----------------------------------------
										
										  //----------------------------------------
								End case 
								
								  // Check if some xml element must be added after
								  //If((Num($Obj_element.modulo)>0) & (Value type($Obj_element.xmlIds)=Is collection))
								
								  //For each ($Txt_buffer;$Obj_element.xmlIds)
								
								  //If ($Lon_ii % $Obj_element.modulo)
								  //DOM EXPORT TO VAR($Txt_buffer;$Txt_buffer)
								  //$Dom_:=DOM Append XML element(DOM Get parent XML element($Obj_element.xmlId);DOM Parse XML variable($Txt_buffer))
								
								  // End if
								
								  // End for each
								
								  // End if
								
							End for each 
							
							  // Remove originals template element
							DOM REMOVE XML ELEMENT:C869($Obj_element.xmlId)
							
						End if 
					End for each 
				End if 
				
				  // Save file at destination after replacing tags
				If ($Boo_buffer)
					
					DOM EXPORT TO VAR:C863($Dom_root;$Txt_buffer)
					$Txt_buffer:=Process_tags ($Txt_buffer;$Obj_in.tags;New collection:C1472("storyboard";"___TABLE___"))
					$Txt_buffer:=Replace string:C233($Txt_buffer;"<userDefinedRuntimeAttribute type=\"image\" keyPath=\"image\"/>";"")  // Remove useless empty image
					
					$File_:=Folder:C1567($Obj_in.target;fk platform path:K87:2).file(Process_tags (String:C10($Obj_in.template.storyboard);$Obj_in.tags;New collection:C1472("filename")))
					$File_.setText($Txt_buffer;"UTF-8";Document with CRLF:K24:20)
					
					storyboard (New object:C1471(\
						"action";"format";\
						"path";$File_))
					
				End if 
				
				DOM CLOSE XML:C722($Dom_root)
				
				$Obj_out.success:=True:C214
				
			Else   // Not a document
				
				ASSERT:C1129(dev_Matrix ;"Missing detail form storyboard")
				
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="listform")
			
			If ($Obj_in.template.storyboard=Null:C1517)  // set default path if not defined
				
				$Obj_in.template.storyboard:="Sources/Forms/Tables/___TABLE___/___TABLE___ListForm.storyboard"  // TODO try to get this info from parent manifest file
				
			End if 
			
			$File_:=Folder:C1567($Obj_in.template.source;fk platform path:K87:2).file(String:C10($Obj_in.template.storyboard))
			
			If ($File_.exists)
				
				$Txt_buffer:=$File_.getText()
				
				If (Length:C16($Txt_buffer)>0)  // a custom template or not well described one (do not warn about it but we could read by reading file)
					
					$Obj_element:=New object:C1471(\
						"___TABLE_ACTIONS___";"tableActions";\
						"___ENTITY_ACTIONS___";"recordActions")
					
					For each ($Txt_cmd;$Obj_element)
						
						If ($Obj_in.tags.table[$Obj_element[$Txt_cmd]]#Null:C1517)  // there is selection action
							
							If (Position:C15($Txt_cmd;$Txt_buffer)=0)
								
								ob_warning_add ($Obj_out;"List template storyboard '"+$File_.path+"'do not countains action tag "+$Txt_cmd)
								
								  // XXX here could fix by dom manipulation instead of warn (some code in #106033) (fix on source or in destination?)
								
							End if 
						End if 
					End for each 
				End if 
				
				$Obj_out.success:=True:C214
				
			Else   // Not a document
				
				ASSERT:C1129(dev_Matrix ;"Missing list form storyboard")
				
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="colorAssetFix")
			
			If (Test path name:C476(String:C10($Obj_in.path))=Is a folder:K24:2)
				
				ARRAY TEXT:C222($DocumentPaths_at;0x0000)
				DOCUMENT LIST:C474($Obj_in.path;$DocumentPaths_at;Recursive parsing:K24:13)  // TODO replace by Folder
				
				$Obj_out.files:=New collection:C1472
				
				For ($Lon_i;1;Size of array:C274($DocumentPaths_at);1)
					
					$File_:=Folder:C1567($Obj_in.path;fk platform path:K87:2).file($DocumentPaths_at{$Lon_i})
					
					If ($File_.extension=".storyboard")
						
						  // read file
						$Dom_root:=DOM Parse XML source:C719($File_.platformPath)
						
						  // find named colors
						ARRAY TEXT:C222($tDom_dicts;0x0000)
						$tDom_dicts{0}:=DOM Find XML element:C864($Dom_root;"document/resources/namedColor";$tDom_dicts)
						
						If (Size of array:C274($tDom_dicts)>0)
							
							For ($Lon_ii;1;Size of array:C274($tDom_dicts);1)
								
								  // get color name
								DOM GET XML ATTRIBUTE BY NAME:C728($tDom_dicts{$Lon_ii};"name";$Txt_buffer)
								
								If ($Obj_in.theme[$Txt_buffer]#Null:C1517)
									
									If (Value type:C1509($Obj_in.theme[$Txt_buffer])=Is object:K8:27)
										
										  // get color xml child
										$Dom_:=DOM Get first child XML element:C723($tDom_dicts{$Lon_ii})
										
										$Obj_color:=$Obj_in.theme[$Txt_buffer]
										
										  // recreate node
										DOM REMOVE XML ELEMENT:C869($Dom_)
										$Dom_:=DOM Create XML element:C865($tDom_dicts{$Lon_ii};"color")
										
										Case of 
												
												  //______________________________________________________
											: ($Obj_color.space="gray")
												
												If ($Obj_color.alpha=Null:C1517)
													
													$Obj_color.alpha:=1
													
												End if 
												
												DOM SET XML ATTRIBUTE:C866($Dom_;\
													"white";String:C10($Obj_color.white);\
													"alpha";String:C10($Obj_color.alpha);\
													"colorSpace";"custom";\
													"customColorSpace";"genericGamma22GrayColorSpace")
												
												  //______________________________________________________
											: ($Obj_color.space="srgb")
												
												If ($Obj_color.alpha=Null:C1517)
													
													$Obj_color.alpha:=255
													
												End if 
												
												DOM SET XML ATTRIBUTE:C866($Dom_;\
													"alpha";String:C10($Obj_color.alpha/255;"&xml");\
													"red";String:C10($Obj_color.red/255;"&xml");\
													"green";String:C10($Obj_color.green/255;"&xml");\
													"blue";String:C10($Obj_color.blue/255;"&xml");\
													"colorSpace";"custom";\
													"customColorSpace";"sRGB")
												
												  // ----------------------------------------
												  //----------------------------------------
											Else 
												
												ASSERT:C1129("Unknown color space "+$Obj_color.space)
												
												  // ----------------------------------------
												
												  //----------------------------------------
										End case 
									End if 
								End if 
							End for 
							
							  // write if there is one named colors (could also do it only if one attribute change)
							doc_UNLOCK_DIRECTORY (New object:C1471("path";$File_.parent.platformPath))
							DOM EXPORT TO FILE:C862($Dom_root;$File_.platformPath)
							DOM CLOSE XML:C722($Dom_root)
							$Obj_out.files.push($File_.platformPath)
							
							storyboard (New object:C1471(\
								"action";"format";\
								"path";$File_))  // XXX to do it only one time, maybe do it in caller, using the "files"
							
						End if 
					End if 
				End for 
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("path not defined or do not exist")
				
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="imageAssetFix")
			
			  // remove all empty image asset, and double
			
			If (Test path name:C476(String:C10($Obj_in.path))=Is a folder:K24:2)
				
				ARRAY TEXT:C222($DocumentPaths_at;0x0000)
				DOCUMENT LIST:C474($Obj_in.path;$DocumentPaths_at;Recursive parsing:K24:13)
				
				$Obj_out.files:=New collection:C1472
				
				For ($Lon_i;1;Size of array:C274($DocumentPaths_at);1)
					
					$File_:=$Obj_in.path+$DocumentPaths_at{$Lon_i}
					
					If ($File_.extension=".storyboard")
						
						  // read file
						$Dom_root:=DOM Parse XML source:C719($File_.platformPath)
						$Boo_buffer:=False:C215
						
						  // find named colors
						ARRAY TEXT:C222($tDom_dicts;0x0000)
						$tDom_dicts{0}:=DOM Find XML element:C864($Dom_root;"document/resources/image";$tDom_dicts)
						
						If (Size of array:C274($tDom_dicts)>0)
							
							$Col_:=New collection:C1472
							
							For ($Lon_ii;1;Size of array:C274($tDom_dicts);1)
								
								  // get  name
								DOM GET XML ATTRIBUTE BY NAME:C728($tDom_dicts{$Lon_ii};"name";$Txt_buffer)
								
								If (Length:C16($Txt_buffer)=0)
									
									DOM REMOVE XML ELEMENT:C869($tDom_dicts{$Lon_ii})
									$Boo_buffer:=True:C214
									
								Else 
									
									If ($Col_.indexOf($Txt_buffer)>-1)
										
										DOM REMOVE XML ELEMENT:C869($tDom_dicts{$Lon_ii})
										$Boo_buffer:=True:C214
										
									Else 
										
										$Col_.push($Txt_buffer)
										
									End if 
								End if 
							End for 
						End if 
						
						  // Remove empty value attribute of userDefinedRuntimeAttribute with type image
						For each ($Dom_;xml_findByName ($Dom_root;"userDefinedRuntimeAttribute");1)
							
							C_OBJECT:C1216($Obj_attributes)
							$Obj_attributes:=xml_attributes ($Dom_)
							
							If (String:C10($Obj_attributes.type)="image")
								
								If ($Obj_attributes.value#Null:C1517)\
									 & (Length:C16(String:C10($Obj_attributes.value))=0)
									
									DOM REMOVE XML ATTRIBUTE:C1084($Dom_;"value")
									$Boo_buffer:=True:C214
									
								End if 
							End if 
						End for each 
						
						  // write if there is one modification
						If ($Boo_buffer)
							
							DOM EXPORT TO FILE:C862($Dom_root;$File_.platformPath)
							DOM CLOSE XML:C722($Dom_root)
							$Obj_out.files.push($File_.platformPath)
							
							storyboard (New object:C1471(\
								"action";"format";\
								"path";$File_))  // XXX to do it only one time, maybe do it in caller, using the "files" and a "set" behaviour
							
						End if 
					End if 
					
					$Obj_out.success:=True:C214
					
				End for 
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("path not defined or do not exist")
				
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="format")
			
			  // Reformat storyboard document to follow xcode rules (line ending, attributes order, add missing resources)
			
			If (Value type:C1509($Obj_in.path)=Is text:K8:3)
				If (Test path name:C476(String:C10($Obj_in.path))=Is a document:K24:1)
					
					ASSERT:C1129(dev_Matrix ;"Must not be string, now File")  // Deprecated, maybe be test ...
					$Obj_in.path:=File:C1566($Obj_in.path;fk platform path:K87:2)
					
				End if 
			End if 
			
			Case of 
				: ($Obj_in.path=Null:C1517)
					
					$Obj_out.errors:=New collection:C1472("path not defined")
					
				: ($Obj_in.path.exists)
					
					  // Use temp file because inplace command do not reformat
					$File_:=Folder:C1567(Temporary folder:C486;fk platform path:K87:2).file(Generate UUID:C1066+".storyboard")
					$Obj_in.path.copyTo($Obj_in.path)
					
					$Txt_cmd:="ibtool --upgrade "+str_singleQuoted ($File_.path)+" --write "+str_singleQuoted ($Obj_in.path.path)
					LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
					
					If (Asserted:C1132(Ok=1;"LEP failed: "+$Txt_cmd))
						
						$Obj_out.success:=True:C214
						
						If (Length:C16($Txt_out)>0)
							
							$File_:=Folder:C1567(Temporary folder:C486;fk platform path:K87:2).file(Generate UUID:C1066+"ibtool.plist")
							$File_.setText($Txt_out)
							$Obj_out:=plist (New object:C1471(\
								"action";"object";\
								"domain";$File_.path))
							$File_.delete()
							
							If (($Obj_out.success)\
								 & ($Obj_out.value#Null:C1517))
								
								  // errors
								Case of 
										
										  //----------------------------------------
									: (Value type:C1509($Obj_out.value["com.apple.ibtool.document.errors"])=Is collection:K8:32)
										
										$Obj_out.errors:=$Obj_out.value["com.apple.ibtool.document.errors"]
										
										  //----------------------------------------
									: (Value type:C1509($Obj_out.value["com.apple.ibtool.document.errors"])=Is object:K8:27)
										
										$Obj_out.errors:=New collection:C1472($Obj_out.value["com.apple.ibtool.document.errors"])
										
										  //----------------------------------------
									: (Value type:C1509($Obj_out.value["com.apple.ibtool.errors"])=Is collection:K8:32)
										
										$Obj_out.errors:=$Obj_out.value["com.apple.ibtool.errors"]
										
										  //----------------------------------------
									: (Value type:C1509($Obj_out.value["com.apple.ibtool.errors"])=Is object:K8:27)
										
										$Obj_out.errors:=New collection:C1472($Obj_out.value["com.apple.ibtool.errors"])
										
										  //----------------------------------------
								End case 
								
								If (Value type:C1509($Obj_out.errors)=Is collection:K8:32)
									
									$Obj_out.success:=$Obj_out.errors.length=0
									
								End if 
							End if 
						End if 
					End if 
					
				Else 
					
					$Obj_out.errors:=New collection:C1472("path do not exist")
					
			End case 
			
			  //______________________________________________________
		: ($Obj_in.action="addScene")
			
			ASSERT:C1129(Length:C16(String:C10($Obj_in.name))>0)
			
			  // Have a DOM or load a new DOM
			
			  //If (String($Obj_in.file))
			  //  $Obj_in.dom:= DOM Parse
			  //End if
			
			If (Length:C16(String:C10($Obj_in.dom))>0)
				
				$Obj_out.dom:=$Obj_in.dom  // edit inline
				
				  // Create a new scene
				$Col_:=storyboard (New object:C1471("action";"randomIds";"length";3)).value
				$Obj_tag:=New object:C1471("name";String:C10($Obj_in.name);"tagInterfix";"SN";"storyboardIDs";$Col_)
				$Obj_out.scene:=storyboard (New object:C1471("action";"scene";"tags";$Obj_tag))
				If ($Obj_out.scene.success)
					
					  // inject into <scenes>
					$Obj_out.domScenes:=DOM Find XML element:C864($Obj_in.dom;"document/scenes")
					
					If ($Obj_out.domScenes#"00000000000000000000000000000000")
						
						$Obj_out.success:=True:C214
						$Obj_out.domScene:=DOM Append XML element:C1082($Obj_out.domScenes;$Obj_out.scene.dom)
						
						  // Create a connection
						If (Bool:C1537($Obj_in.connection))
							
							  // Find main viewController DOM (ex: <scene sceneID="fK0-6P-J5Y"><objects> <viewController>
							$Obj_out.domVC:=DOM Find XML element:C864($Obj_in.dom;"document/scenes/scene[2]/objects/viewController")
							
							If ($Obj_out.domVC#"00000000000000000000000000000000")
								
								  // Find its <connections> children
								$Obj_out.domConnections:=DOM Find XML element:C864($Obj_out.domVC;"<connections>")
								If ($Obj_out.domConnections="00000000000000000000000000000000")
									$Obj_out.domConnections:=DOM Create XML element:C865($Obj_out.domVC;"connections")
								End if 
								
								  // Create a segue with First random id as SCENE ID is destination id
								$Col_:=New collection:C1472($Col_[0];storyboard (New object:C1471("action";"randomId")).value)
								$Obj_tag:=New object:C1471("name";String:C10($Obj_in.name);"kind";"show";"tagInterfix";"SG";"storyboardIDs";$Col_)
								$Obj_out.segue:=storyboard (New object:C1471("action";"segue";"tags";$Obj_tag))
								
								  // Inject it into <connections>
								$Obj_out.domSegue:=DOM Append XML element:C1082($Obj_out.domConnections;$Obj_out.segue.dom)
								
							Else 
								
								$Obj_out.success:=False:C215
								ob_error_add ($Obj_out;"Cannot find view controller to add connection on "+String:C10($Obj_in.name))
								
							End if 
							
						End if 
						
					End if 
				Else 
					
					ob_error_add ($Obj_out;"Cannot read scene template")
					
				End if 
				
			Else 
				
				ob_error_add ($Obj_out;"No dom element to edit when adding a scene")
				
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="scene")
			
			$Obj_element:=COMPONENT_Pathname ("templates").folder("relation").file("storyboardScene.xml")
			
			If ($Obj_element.exists)
				
				If (Value type:C1509($Obj_in.tags)=Is object:K8:27)
					
					ASSERT:C1129($Obj_in.tags.storyboardIDs.length=3)
					
					$Txt_buffer:=$Obj_element.getText()
					$Txt_buffer:=Process_tags ($Txt_buffer;$Obj_in.tags;New collection:C1472("automatic";"storyboardID"))
					$Obj_out.dom:=DOM Parse XML variable:C720($Txt_buffer)
					$Obj_out.success:=True:C214
					
				Else 
					$Obj_out.dom:=DOM Parse XML source:C719($Obj_element.platformPath)
					$Obj_out.success:=True:C214
				End if 
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="segue")
			
			$Txt_buffer:="<segue destination=\"TAG-SG-001\" kind=\"___KIND___\" identifier=\"___NAME___\" id=\"TAG-SG-002\"/>"
			
			If (Value type:C1509($Obj_in.tags)=Is object:K8:27)
				ASSERT:C1129($Obj_in.tags.storyboardIDs.length=2)
				$Txt_buffer:=Process_tags ($Txt_buffer;$Obj_in.tags;New collection:C1472("automatic";"storyboardID"))
			End if 
			
			$Obj_out.dom:=DOM Parse XML variable:C720($Txt_buffer)
			$Obj_out.success:=True:C214
			
			  //______________________________________________________
		: ($Obj_in.action="version")
			
			  // Get storyboard tool version (could be used to replace in storyboard header)
			$Txt_cmd:="ibtool --version"
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
			
			If (Asserted:C1132(Ok=1;"LEP failed: "+$Txt_cmd))
				
				If (Length:C16($Txt_out)>0)
					
					$File_:=Folder:C1567(Temporary folder:C486;fk platform path:K87:2).file(Generate UUID:C1066+"ibtool.plist")
					$File_.setText($Txt_out)
					$Obj_out:=plist (New object:C1471(\
						"action";"object";\
						"domain";$File_.path))
					$File_.delete()
					
					If (($Obj_out.success)\
						 & ($Obj_out.value#Null:C1517))
						
						$Obj_out.version:=String:C10($Obj_out.value["com.apple.ibtool.version"]["bundle-version"])
						
					End if 
				End if 
			End if 
			
			  //________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_in.action+"\"")
			
			  //________________________________________
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End