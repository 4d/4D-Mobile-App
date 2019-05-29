//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : asset
  // Created #2017 by Eric Marchand
  // ----------------------------------------------------
  // Description: Create, Edit Xcode asset
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_)
C_LONGINT:C283($Lon_height;$Lon_i;$Lon_parameters;$Lon_scale;$Lon_width)
C_PICTURE:C286($Pic_buffer;$Pic_icon)
C_TEXT:C284($Dir_buffer;$Dir_source;$File_source;$Txt_buffer;$Txt_name;$Txt_value)
C_OBJECT:C1216($Obj_;$Obj_buffer;$Obj_file;$Obj_formatter;$Obj_image;$Obj_in)
C_OBJECT:C1216($Obj_out;$Obj_path;$Obj_template)

If (False:C215)
	C_OBJECT:C1216(asset ;$0)
	C_OBJECT:C1216(asset ;$1)
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

If (($Obj_in.path#Null:C1517)\
 | ($Obj_in.posix#Null:C1517))
	
	If ($Obj_in.path=Null:C1517)
		
		$Obj_in.path:=Convert path POSIX to system:C1107($Obj_in.posix)
		
	End if 
End if 

  // ----------------------------------------------------
If (Asserted:C1132($Obj_in.action#Null:C1517;"Missing the tag \"action\""))
	
	Case of 
			
			  //______________________________________________________
		: ($Obj_in.action="path")
			
			$Txt_buffer:="Resources"+Folder separator:K24:12+"Assets.xcassets"+Folder separator:K24:12
			
			Case of 
					
					  //----------------------------------------
				: (Length:C16(String:C10($Obj_in.path))=0)
					
					$Obj_out.path:=$Txt_buffer
					
					  //----------------------------------------
				: (Substring:C12($Obj_in.path;Length:C16($Obj_in.path);1)=Folder separator:K24:12)
					
					$Obj_out.path:=$Obj_in.path+$Txt_buffer
					
					  //----------------------------------------
				Else 
					
					$Obj_out.path:=$Obj_in.path+Folder separator:K24:12+$Txt_buffer
					
					  //----------------------------------------
			End case 
			
			$Obj_out.success:=True:C214
			
			  //______________________________________________________
		: ($Obj_in.action="formatter")
			
			Case of 
					
					  //…………………………………………………………………………………………………………………
				: (Value type:C1509($Obj_in.formatter)#Is object:K8:27)
					
					$Obj_out.errors:=New collection:C1472("No formatter defined to create an xcode files")
					
					  //…………………………………………………………………………………………………………………
				: (Length:C16(String:C10($Obj_in.formatter.name))=0)
					
					$Obj_out.errors:=New collection:C1472("No formatter name defined."+JSON Stringify:C1217($Obj_in.formatter))
					
					  // ----------------------------------------
				: (Length:C16(String:C10($Obj_in.target))=0)
					
					$Obj_out.errors:=New collection:C1472("No target defined when creating formatter asset.")
					
					  // ----------------------------------------
				Else 
					
					If (Test path name:C476($Obj_in.target+$Obj_in.formatter.name)#Is a folder:K24:2)
						
						asset (New object:C1471(\
							"action";"create";\
							"type";"folder";\
							"target";$Obj_in.target+$Obj_in.formatter.name\
							))
						
					End if 
					
					$Obj_formatter:=$Obj_in.formatter
					
					  // Get path for formatter assets
					Case of 
							
							  // ........................................
						: (Length:C16(String:C10($Obj_in.source))>0)
							
							$Dir_source:=$Obj_in.source  // specify the path as argument (useful for testing)
							
							  // ........................................
						: (Length:C16(String:C10($Obj_in.assets.source))>0)
							
							$Dir_source:=$Obj_in.assets.source  // specify the source in formatter
							
							  // ........................................
						: (Bool:C1537($Obj_formatter.isHost))  // with /, host formatters? XXX maybe find another way to identifiy it
							
							$Dir_source:=Choose:C955(Length:C16(String:C10($Obj_formatter.path))>0;$Obj_formatter.path;_o_Pathname ("host_formatters")+$Obj_formatter.name+Folder separator:K24:12)
							
							$Dir_source:=$Dir_source+"images"+Folder separator:K24:12
							
							  // ........................................
						Else 
							
							$Dir_source:=_o_Pathname ("formatterImages")
							
							  // ........................................
					End case 
					
					  // Could create a choice list from pattern and file on disk
					If ($Obj_formatter.choiceList=Null:C1517)
						
						If (Value type:C1509($Obj_formatter.choicePattern)=Is text:K8:3)
							
							ARRAY TEXT:C222($tTxt_documents;0x0000)
							DOCUMENT LIST:C474($Dir_source;$tTxt_documents)
							
							$Obj_formatter.choiceList:=New object:C1471(\
								)
							
							For ($Lon_i;1;Size of array:C274($tTxt_documents);1)
								
								ARRAY TEXT:C222($tTxt_result;0x0000)
								
								If (Rgx_ExtractText ($Obj_formatter.choicePattern;$tTxt_documents{$Lon_i};"1";->$tTxt_result)=0)
									
									$Obj_formatter.choiceList[$tTxt_result{1}]:=$tTxt_documents{$Lon_i}
									
								End if 
							End for 
						End if 
					End if 
					
					  // Create an image asset for each values
					$Obj_buffer:=formatters (New object:C1471(\
						"action";"objectify";\
						"value";$Obj_formatter.choiceList))
					
					If ($Obj_buffer.success)
						
						$Obj_:=$Obj_buffer.value
						
						For each ($Txt_buffer;$Obj_)
							
							$Txt_value:=$Obj_formatter.name+"_"+$Txt_buffer
							
							$File_source:=$Dir_source+$Obj_[$Txt_buffer]
							
							$Obj_buffer:=asset (New object:C1471(\
								"action";"create";\
								"type";"imageset";\
								"source";$File_source;\
								"tags";New object:C1471("name";$Txt_value);\
								"target";$Obj_in.target+$Obj_formatter.name+Folder separator:K24:12;\
								"format";$Obj_formatter.assets.format;\
								"size";$Obj_formatter.assets.size))
							
							ob_error_combine ($Obj_out;$Obj_buffer)
							
						End for each 
						
						$Obj_out.success:=Not:C34(ob_error_has ($Obj_out))
						
					Else 
						
						ob_error_combine ($Obj_out;$Obj_buffer;"No choice list in formatter:"+JSON Stringify:C1217($Obj_in.formatter))
						
					End if 
					
					  //…………………………………………………………………………………………………………………
			End case 
			
			  //______________________________________________________
		: ($Obj_in.action="create")
			
			If (($Obj_in.tags=Null:C1517)\
				 & ($Obj_in.name#Null:C1517))
				
				$Obj_in.tags:=New object:C1471(\
					"name";$Obj_in.name)
				
			End if 
			
			Case of 
					
					  //…………………………………………………………………………………………………………………
				: ($Obj_in.type=Null:C1517)
					
					$Obj_out.errors:=New collection:C1472("type must be defined when creating asset")
					
					  //…………………………………………………………………………………………………………………
				: ($Obj_in.target=Null:C1517)
					
					$Obj_out.errors:=New collection:C1472("target must be defined when creating asset")
					
					  //…………………………………………………………………………………………………………………
				: ($Obj_in.tags=Null:C1517)
					
					$Obj_out.errors:=New collection:C1472("tags must be defined when creating asset")
					
					  //…………………………………………………………………………………………………………………
				Else 
					
					Case of 
							
							  // ........................................
						: (($Obj_in.type="imageset")\
							 | ($Obj_in.type="background"))
							
							If ($Obj_in.format=Null:C1517)
								
								$Obj_in.format:="png"
								
							End if 
							
							$Txt_buffer:=_o_Pathname ("templates")+"asset"+Folder separator:K24:12+$Obj_in.type+Folder separator:K24:12+$Obj_in.format+Folder separator:K24:12
							$Obj_out.success:=Test path name:C476($Txt_buffer)=Is a folder:K24:2
							
							  // ........................................
						: ($Obj_in.type="colorset")
							
							If ($Obj_in.space#Null:C1517)
								
								$Txt_buffer:=_o_Pathname ("templates")+"asset"+Folder separator:K24:12+$Obj_in.type+Folder separator:K24:12+$Obj_in.space+Folder separator:K24:12
								
								If ($Obj_in.tags.alpha=Null:C1517)
									
									$Obj_in.tags.alpha:=255  // alpha could also be defined using float 1.000 (.0 is mandatory)
									
								End if 
								
								$Obj_out.success:=Test path name:C476($Txt_buffer)=Is a folder:K24:2
								
							Else 
								
								  // Or maybe latter according to tag find the color space
								$Obj_out.errors:=New collection:C1472("space must be defined for colorset: srgb, or gray")
								
							End if 
							
							  // ........................................
						: ($Obj_in.type="dataset")
							
							$Txt_buffer:=_o_Pathname ("templates")+"asset"+Folder separator:K24:12+$Obj_in.type+Folder separator:K24:12
							$Obj_out.success:=Test path name:C476($Txt_buffer)=Is a folder:K24:2
							
							If ($Obj_in.tags.filename=Null:C1517)
								
								$Obj_in.tags.filename:=$Obj_in.name
								
							End if 
							
							  // ........................................
						: ($Obj_in.type="folder")
							
							$Txt_buffer:=_o_Pathname ("templates")+"asset"+Folder separator:K24:12+$Obj_in.type+Folder separator:K24:12
							$Obj_out.success:=Test path name:C476($Txt_buffer)=Is a folder:K24:2
							
							  // ........................................
						Else 
							
							$Obj_out.errors:=New collection:C1472("Unknown type "+String:C10($Obj_in.type))
							$Obj_out.success:=False:C215
							
							  // ........................................
					End case 
					
					$Obj_buffer:=Path to object:C1547($Txt_buffer)
					$Obj_buffer.isFolder:=True:C214
					$Txt_buffer:=Object to path:C1548($Obj_buffer)
					
					If ($Obj_out.success)
						
						If (Test path name:C476($Obj_in.target)#Is a folder:K24:2)
							
							  // Create intermediate asset folder if necessary
							
							ARRAY TEXT:C222($tDirs_buffer;0x0000)
							$Dir_buffer:=$Obj_in.target
							
							While (Test path name:C476($Dir_buffer)#Is a folder:K24:2)
								
								APPEND TO ARRAY:C911($tDirs_buffer;$Dir_buffer)
								$Dir_buffer:=Path to object:C1547($Dir_buffer).parentFolder
								
							End while 
							
							For ($Lon_i;Size of array:C274($tDirs_buffer);1;-1)
								
								$Dir_buffer:=$tDirs_buffer{$Lon_i}
								
								$Obj_path:=Path to object:C1547($Dir_buffer)
								
								asset (New object:C1471(\
									"action";"create";\
									"type";"folder";\
									"target";$Obj_path.parentFolder;\
									"tags";New object:C1471("name";$Obj_path.name+$Obj_path.extension)\
									))
								
							End for 
						End if 
						
						$Obj_out.template:=TEMPLATE (New object:C1471(\
							"source";$Txt_buffer;\
							"target";$Obj_in.target;\
							"tags";$Obj_in.tags;\
							"catalog";doc_catalog ($Txt_buffer)))
						
						$Obj_template:=ob_parseDocument ($Txt_buffer+"manifest.json").value
						
						If (String:C10($Obj_template.contents)#"")
							
							$Txt_buffer:=Process_tags ($Obj_template.contents;$Obj_in.tags;New collection:C1472("filename"))
							
							$Obj_:=ob_parseDocument ($Obj_in.target+$Txt_buffer+Folder separator:K24:12+"Contents.json").value
							
							Case of 
									
									  // ........................................
								: ($Obj_.images#Null:C1517)
									
									$Obj_out.errors:=New collection:C1472
									
									  // Read source file (XXX here source is String; later could have object or collection if image is already scaled)
									If (Test path name:C476(String:C10($Obj_in.source))=Is a document:K24:1)
										
										READ PICTURE FILE:C678($Obj_in.source;$Pic_buffer)
										
										If ($Obj_in.size=Null:C1517)
											
											PICTURE PROPERTIES:C457($Pic_buffer;$Lon_width;$Lon_height)
											
											$Obj_in.size:=New object:C1471(\
												"width";$Lon_width;\
												"height";$Lon_height)
											
										End if 
										
										If (OK=1)
											
											  // Create file for each defined file
											For each ($Obj_image;$Obj_.images)
												
												$Lon_scale:=1
												
												  // Read potential scale factor
												If (Length:C16(String:C10($Obj_image.scale))#0)
													
													$Lon_scale:=Num:C11(String:C10($Obj_image.scale))
													
												End if 
												
												If (Value type:C1509($Obj_in.size)=Is object:K8:27)
													
													$Lon_width:=$Obj_in.size.width
													$Lon_height:=$Obj_in.size.height
													
												Else   // suppose single num
													
													$Lon_width:=$Obj_in.size
													$Lon_height:=$Obj_in.size
													
												End if 
												
												  // Check if there is specific size for idiom, subtype of scale
												Case of 
														
														  //…………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………
													: (Value type:C1509($Obj_in.sizes[$Obj_image.idiom+String:C10($Obj_image.subtype)+$Obj_image.scale])=Is object:K8:27)
														
														$Lon_width:=$Obj_in.sizes[$Obj_image.idiom+String:C10($Obj_image.subtype)+$Obj_image.scale].width
														$Lon_height:=$Obj_in.sizes[$Obj_image.idiom+String:C10($Obj_image.subtype)+$Obj_image.scale].height
														
														  //…………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………
													: (Value type:C1509($Obj_in.sizes[$Obj_image.idiom])=Is object:K8:27)
														
														$Lon_width:=$Obj_in.sizes[$Obj_image.idiom].width*$Lon_scale
														$Lon_height:=$Obj_in.sizes[$Obj_image.idiom].height*$Lon_scale
														
														  //…………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………
													Else 
														
														$Lon_width:=$Lon_width*$Lon_scale
														$Lon_height:=$Lon_height*$Lon_scale
														
														  //…………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………
												End case 
												
												CREATE THUMBNAIL:C679($Pic_buffer;$Pic_icon;$Lon_width;$Lon_height;Scaled to fit:K6:2)  // XXX Scaled to fit prop centered?
												
												If (OK=1)
													
													WRITE PICTURE FILE:C680($Obj_in.target+$Txt_buffer+Folder separator:K24:12+$Obj_image.filename;$Pic_icon;"."+$Obj_in.format)
													
													If (OK=0)
														
														$Obj_out.errors.push("Failed to write picture "+$Obj_in.target+$Txt_buffer+Folder separator:K24:12+$Obj_image.filename+\
															", created from "+$Obj_in.source+" with format ."+$Obj_in.format)
														
													End if 
													
												Else 
													
													$Obj_out.errors.push("Failed to create thumbnail for "+$Obj_in.source+" with size "+JSON Stringify:C1217($Obj_in.size)+" and scale "+$Lon_scale)
													
												End if 
											End for each 
											
										Else 
											
											$Obj_out.errors.push("Failed to read picture "+$Obj_in.source)
											
										End if 
										
									Else 
										
										$Obj_out.errors.push("No source file to read picture "+String:C10($Obj_in.source))
										
									End if 
									
									  // reset errors if no error
									If ($Obj_out.errors.length=0)
										
										$Obj_out.errors:=Null:C1517
										
									Else 
										
										$Obj_out.success:=False:C215
										
									End if 
									
									  //………………………………………………………………………
								: ($Obj_.colors#Null:C1517)
									
									  // Check all tags defined
									For ($Lon_i;1;$Obj_template.tags.length;1)
										
										If ($Obj_in.tags[$Obj_template.tags[$Lon_i-1]]=Null:C1517)
											
											If ($Obj_out.errors=Null:C1517)
												
												$Obj_out.errors:=New collection:C1472
												
											End if 
											
											$Obj_out.errors.push("missing tag "+$Obj_template.tags[$Lon_i-1])
											
										End if 
									End for 
									
									$Obj_out.success:=$Obj_out.errors=Null:C1517
									
									  //………………………………………………………………………
							End case 
						End if 
					End if 
					
					  //…………………………………………………………………………………………………………………
			End case 
			
			  //______________________________________________________
		: ($Obj_in.action="read")
			
			If ($Obj_in.path#Null:C1517)
				
				If (Test path name:C476($Obj_in.path)=Is a folder:K24:2)
					
					If (Test path name:C476($Obj_in.path+Folder separator:K24:12+"Contents.json")=Is a document:K24:1)
						
						$Obj_out.value:=JSON Parse:C1218(Document to text:C1236($Obj_in.path+Folder separator:K24:12+"Contents.json"))
						$Obj_out.success:=True:C214
						
					Else 
						
						$Obj_out.errors:=New collection:C1472("missing asset file Contents.json under path "+$Obj_in.path)
						
					End if 
					
				Else 
					
					$Obj_out.errors:=New collection:C1472("path must be a folder")
					
				End if 
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("path must be defined")
				
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="list")
			
			If ($Obj_in.path#Null:C1517)
				
				  // Remove final folder separator
				$Obj_file:=Path to object:C1547($Obj_in.path)
				$Obj_file.isFolder:=False:C215
				$Obj_in.path:=Object to path:C1548($Obj_file)
				
				If (Test path name:C476($Obj_in.path)=Is a folder:K24:2)
					
					ARRAY TEXT:C222($tTxt_folder;0x0000)
					FOLDER LIST:C473($Obj_in.path;$tTxt_folder)
					
					$Obj_out.children:=New collection:C1472
					
					If (Bool:C1537($Obj_in.contents))
						
						If (Test path name:C476($Obj_in.path+Folder separator:K24:12+"Contents.json")=Is a document:K24:1)
							
							$Obj_out.contents:=JSON Parse:C1218(Document to text:C1236($Obj_in.path+Folder separator:K24:12+"Contents.json"))
							
							  // Else error
							
						End if 
					End if 
					
					For ($Lon_i;1;Size of array:C274($tTxt_folder);1)
						
						$Obj_path:=Path to object:C1547($tTxt_folder{$Lon_i})
						
						If (Length:C16($Obj_path.extension)=0)
							
							  // No extension
							$Txt_name:=$tTxt_folder{$Lon_i}
							$Txt_buffer:=""
							
						Else 
							
							  // Get short name if extension
							$Txt_name:=$Obj_path.name
							$Txt_buffer:=Substring:C12($Obj_path.extension;2)
							
						End if 
						
						$Obj_:=New object:C1471(\
							"name";$Txt_name;\
							"type";$Txt_buffer;\
							"path";$Obj_in.path+Folder separator:K24:12+$tTxt_folder{$Lon_i})
						
						$Boo_:=True:C214
						
						If ($Obj_in.filter#Null:C1517)
							
							  // ex: imageset; appiconset; empty string for folder
							$Boo_:=$Obj_in.filter=$Obj_.type
							
						End if 
						
						If ($Boo_)
							
							If (Bool:C1537($Obj_in.contents))
								
								If (Test path name:C476($Obj_.path+Folder separator:K24:12+"Contents.json")=Is a document:K24:1)
									
									$Obj_.contents:=JSON Parse:C1218(Document to text:C1236($Obj_.path+Folder separator:K24:12+"Contents.json"))
									
									  // Else errors?
									
								End if 
							End if 
						End if 
						
						If (Bool:C1537($Obj_in.recursive)\
							 & (Length:C16($Obj_.type)=0))
							
							$Obj_.children:=asset (New object:C1471(\
								"action";"list";\
								"path";$Obj_.path;\
								"contents";$Obj_in.contents;\
								"recursive";$Obj_in.recursive;\
								"filter";$Obj_in.filter))
							ob_error_combine ($Obj_out;$Obj_.children)
							
							If (Bool:C1537($Obj_.children.success))
								
								If (Value type:C1509($Obj_.children.children)=Is collection:K8:32)
									
									$Boo_:=$Boo_ | ($Obj_.children.children.length>0)
									$Obj_.children:=$Obj_.children.children
									
								End if 
							End if 
						End if 
						
						If ($Boo_)
							
							$Obj_out.children.push($Obj_)
							
						End if 
					End for 
					
					$Obj_out.success:=True:C214
					
				Else 
					
					$Obj_out.errors:=New collection:C1472("path must be a folder")
					
				End if 
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("path must be defined")
				
			End if 
			
			  //________________________________________
		Else 
			
			$Obj_out.errors:=New collection:C1472("Unknown action "+$Obj_in.action)
			
			  //________________________________________
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End