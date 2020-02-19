//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : dump
  // ID[BC6599132D8B41458EE1B30856D08E06]
  // Created 27-6-2017 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // dump rest info
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_i;$Lon_parameters)
C_TEXT:C284($File_name;$File_output;$Txt_buffer;$Txt_handler;$Txt_id;$Txt_onError)
C_TEXT:C284($Txt_tableNumber;$Txt_url;$Txt_version)
C_OBJECT:C1216($o;$Obj_buffer;$Obj_dataModel;$Obj_field;$Obj_in;$Obj_out)
C_OBJECT:C1216($Obj_query;$Obj_record;$Obj_rest;$Obj_result;$Obj_table)
C_COLLECTION:C1488($Col_pictureFields)

If (False:C215)
	C_OBJECT:C1216(dump ;$0)
	C_OBJECT:C1216(dump ;$1)
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

  // Check output
If (Length:C16(String:C10($Obj_in.output))=0)
	
	$Obj_in.output:=Temporary folder:C486
	
Else 
	
	$Obj_in.output:=doc_checkFolderSeparator ($Obj_in.output)
	
	If (Test path name:C476($Obj_in.output)#Is a folder:K24:2)
		
		CREATE FOLDER:C475($Obj_in.output;*)
		
	End if 
End if 

  // dataModel
$Obj_dataModel:=$Obj_in.dataModel

If ($Obj_dataModel=Null:C1517)
	
	$Obj_dataModel:=$Obj_in.project.dataModel
	
End if 

  // ----------------------------------------------------
If (Asserted:C1132($Obj_in.action#Null:C1517;"Missing tag \"action\""))
	
	Case of 
			
			  //______________________________________________________
		: ($Obj_in.dataModel=Null:C1517)
			
			$Obj_out.errors:=New collection:C1472("`dataModel` must be specified when dumping")
			$Obj_out.success:=False:C215
			
			  //______________________________________________________
		: ($Obj_in.action="catalog")
			
			$Obj_out.success:=True:C214
			
			$Obj_result:=New object:C1471
			
			  // For each table
			For each ($Txt_tableNumber;$Obj_dataModel)
				
				$Obj_table:=$Obj_dataModel[$Txt_tableNumber]
				
				$o:=Choose:C955(feature.with("newDataModel");$Obj_table[""];$Obj_table)
				
				$Obj_rest:=Rest (New object:C1471(\
					"action";"table";\
					"url";$Obj_in.url;\
					"headers";$Obj_in.headers;\
					"table";$o.name))
				
				If (Value type:C1509($Obj_rest.headers)=Is object:K8:27)
					
					If ($Obj_in.headers["Cookie"]=Null:C1517)
						
						$Obj_in.headers["Cookie"]:=$Obj_rest.headers["Set-Cookie"]
						
					End if 
				End if 
				
				If ($Obj_rest.success)
					
					$File_output:=$Obj_in.output+$o.name
					
					If (Bool:C1537($Obj_in.dataSet))
						
						$File_output:=$File_output+".catalog.dataset"+Folder separator:K24:12+$o.name
						
					End if 
					
					$File_output:=$File_output+".catalog.json"
					
					  // Make sure the folder exist
					CREATE FOLDER:C475($File_output;*)
					
					If (Bool:C1537($Obj_in.dataSet))
						
						asset (New object:C1471("action";"create";\
							"type";"dataset";\
							"target";$Obj_in.output;\
							"tags";New object:C1471(\
							"name";$o.name+".catalog";\
							"fileName";$o.name+".catalog.json";\
							"uti";"public.json")))
						
					End if 
					
					$Txt_onError:=Method called on error:C704
					ob_Lon_Error:=0
					ON ERR CALL:C155("ob_noError")  // CLEAN use another handler?
					
					TEXT TO DOCUMENT:C1237($File_output;JSON Stringify:C1217($Obj_rest.response;*))
					
					ON ERR CALL:C155($Txt_onError)
					
					If (ob_Lon_Error#0)
						
						$Obj_rest.success:=False:C215
						$Obj_rest.errorCode:=ob_Lon_Error
						$Obj_out.success:=False:C215
						
					End if 
					
				Else 
					
					$Obj_out.success:=False:C215  // Global success is false
					
				End if 
				
				$Obj_result[$o.name]:=$Obj_rest
				
				ob_error_combine ($Obj_out;$Obj_rest)
				
			End for each 
			
			$Obj_out.results:=$Obj_result
			
			  //______________________________________________________
		: ($Obj_in.action="data")
			
			$Obj_out.success:=True:C214
			
			$Obj_result:=New object:C1471
			
			  // for each table in model
			For each ($Txt_tableNumber;$Obj_dataModel)
				
				$Obj_table:=$Obj_dataModel[$Txt_tableNumber]
				
				  // Create the query string for rest
				$Obj_query:=New object:C1471(\
					"$limit";String:C10(SHARED.data.dump.limit))
				
				$o:=Choose:C955(feature.with("newDataModel");$Obj_table[""];$Obj_table)
				
				  // Manage  Restricted queries and embedded option
				If (Not:C34(Bool:C1537($o.embedded)))
					
					  // we do not want to dump
					$Obj_query:=Null:C1517
					
				Else 
					
					If ($o.filter#Null:C1517)  // Is filter is available?
						
						If (Bool:C1537($o.filter.validated))  // Is filter is validated?
							
							If (Not:C34(Bool:C1537($o.filter.parameters)))  // There is user parameters?
								
								$Obj_query["$filter"]:=String:C10($o.filter.string)
								$Obj_query["$queryplan"]:="true"
								
							Else 
								
								$Obj_query:=Null:C1517  // do not filter and dump
								
								  // note: core data building already warn if not valided
								
							End if 
						End if 
					End if 
				End if 
				
				  // If query defined, we must dump the table
				If ($Obj_query#Null:C1517)
					
					  // get field list name
					$Obj_buffer:=dataModel (New object:C1471(\
						"action";"fieldNames";\
						"table";$Obj_table))
					
					If (Bool:C1537($Obj_in.expand))  // if we want to use old way to do it, not optimized $expand
						If ($Obj_buffer.expand.length>0)
							
							$Obj_query["$expand"]:=$Obj_buffer.expand.join(",")
							
						End if 
					End if 
					
					  // For each page (if page allowed)
					For ($Lon_i;1;SHARED.data.dump.page;1)
						
						If ($Lon_i>1)
							
							$Obj_query["$skip"]:=String:C10(SHARED.data.dump.limit*($Lon_i-1))
							
						End if 
						
						  // Do the rest request
						$Obj_rest:=Rest (New object:C1471(\
							"action";"records";\
							"url";$Obj_in.url;\
							"headers";$Obj_in.headers;\
							"table";$o.name;\
							"fields";$Obj_buffer.fields;\
							"queryEncode";True:C214;\
							"query";$Obj_query))
						
						If (Value type:C1509($Obj_rest.response)=Is object:K8:27)
							
							$Obj_rest.globalStamp:=$Obj_rest.response.__GlobalStamp  // XXX check table name in https://project.4d.com/issues/90770
							
						End if 
						
						$Obj_result[$o.name]:=$Obj_rest
						
						ob_error_combine ($Obj_out;$Obj_rest)
						
						If ($Obj_rest.success)
							
							$File_output:=$Obj_in.output+$o.name
							
							If (Bool:C1537($Obj_in.dataSet))
								
								$File_output:=$File_output+".dataset"+Folder separator:K24:12+$o.name
								
							End if 
							
							If ($Lon_i#1)
								
								$File_output:=$File_output+"."+String:C10($Lon_i)
								
							End if 
							
							$File_output:=$File_output+".data.json"
							
							  // Make sure the folder exist
							CREATE FOLDER:C475($File_output;*)
							
							If (Bool:C1537($Obj_in.dataSet))
								
								asset (New object:C1471("action";"create";"type";"dataset";\
									"target";$Obj_in.output;\
									"tags";New object:C1471(\
									"name";$o.name;\
									"fileName";$o.name+".data.json";\
									"uti";"public.json")))
								
							End if 
							
							$Obj_rest.write:=ob_writeToDocument ($Obj_rest.response;$File_output;True:C214)
							ob_error_combine ($Obj_out;$Obj_rest.write)
							If (Not:C34($Obj_rest.write.success))
								
								$Obj_rest.success:=False:C215
								$Obj_out.success:=False:C215
								
							End if 
							
						Else 
							
							$Obj_out.success:=False:C215  // global success is false
							
						End if 
					End for 
				End if 
				
				  // Else table skipped
				
			End for each   // end table
			
			$Obj_out.results:=$Obj_result
			
			  //______________________________________________________
		: ($Obj_in.action="pictures")
			
			If ($Obj_in.format=Null:C1517)
				
				$Obj_in.format:=".png"
				
			End if 
			
			$Obj_out.success:=True:C214
			
			$Obj_out.results:=New object:C1471()
			
			  // For each table
			For each ($Txt_tableNumber;$Obj_dataModel)
				
				$Obj_table:=$Obj_dataModel[$Txt_tableNumber]
				
				$o:=Choose:C955(feature.with("newDataModel");$Obj_table[""];$Obj_table)
				
				$Obj_buffer:=dataModel (New object:C1471(\
					"action";"pictureFields";\
					"table";$Obj_table))
				
				  // Check if there is image (XXX use some extract/filter function)
				$Col_pictureFields:=$Obj_buffer.fields
				
				If ($Col_pictureFields=Null:C1517)
					
					$Col_pictureFields:=New collection:C1472()  // just to not failed, CLEAN check status instead
					
				End if 
				
				If ($Col_pictureFields.length>0)
					
					If (Bool:C1537($Obj_in.rest)\
						 | (Length:C16(String:C10($Obj_in.url))>0))
						
						  // ----------------------------------
						  // Get Image from REST server, default local one
						  // ----------------------------------
						
						  // If cached rest result use it
						$Txt_buffer:=String:C10($Obj_in.cache)+Folder separator:K24:12+$o.name
						
						If (Bool:C1537($Obj_in.dataSet))
							
							$Txt_buffer:=$Txt_buffer+".dataset"+Folder separator:K24:12+$o.name
							
						End if 
						
						$Txt_buffer:=$Txt_buffer+".data.json"
						
						If (Test path name:C476($Txt_buffer)=Is a document:K24:1)
							
							$Obj_rest:=ob_parseDocument ($Txt_buffer)
							$Obj_rest.response:=$Obj_rest.value
							
						Else 
							
							  // No more supported, data file must be passed
							$Obj_rest:=New object:C1471(\
								"success";False:C215)
							
						End if 
						
						  // we have succeed to have rest result
						If ($Obj_rest.success)
							
							  // Rest server URL ? (to replace in image url
							$Obj_in.action:="url"
							$Obj_result:=Rest ($Obj_in)
							
							$Obj_result.contentSize:=0
							$Obj_result.count:=0
							If (Bool:C1537($Obj_in.debug))
								$Obj_out.files:=New collection:C1472()
							End if 
							
							  //$Txt_handler:=Choose(Bool(featuresFlags._102457);"mobileapp/";"rest/")
							$Txt_handler:="mobileapp/"
							
							If (Position:C15($Txt_handler;$Obj_result.url)=0)
								
								$Obj_result.url:=$Obj_result.url+$Txt_handler
								ASSERT:C1129(False:C215;"URL must contains "+$Txt_handler)
								
							End if 
							
							If (Value type:C1509($Obj_rest.response.__ENTITIES)=Is collection:K8:32)
								
								  // For each records
								For each ($Obj_record;$Obj_rest.response.__ENTITIES)
									
									  // ... look for images
									For each ($Obj_field;$Col_pictureFields)
										
										$Obj_buffer:=Null:C1517
										$Txt_id:=$Obj_record.__KEY
										
										Case of 
												
												  //----------------------------------------
											: ($Obj_field.relatedField#Null:C1517)
												
												$Obj_buffer:=$Obj_record[$Obj_field.relatedField]
												
												If ($Obj_buffer#Null:C1517)
													
													If ($Obj_field.relatedDataClass#Null:C1517)
														
														$Txt_id:=$Obj_buffer.__KEY
														
													End if 
													
													$Obj_buffer:=$Obj_buffer[$Obj_field.name]
													
												End if 
												
												  //----------------------------------------
											: ($Obj_record[$Obj_field.name]#Null:C1517)
												
												$Obj_buffer:=$Obj_record[$Obj_field.name]
												
												  //----------------------------------------
										End case 
										
										If ($Obj_buffer#Null:C1517)
											
											If (Bool:C1537($Obj_buffer.__deferred.image))
												
												  // Get url for image
												$Txt_url:=String:C10($Obj_buffer.__deferred.uri)
												
												  //If (Bool(featuresFlags._102457))
												
												If (Position:C15("/mobileapp/";$Txt_url)>0)
													
													$Txt_url:=Substring:C12($Txt_url;12)  // remove /mobileapp/
													
												End if 
												
												  //Else
												  //If (Position("/rest/";$Txt_url)>0)
												  //$Txt_url:=Substring($Txt_url;7)  // remove /rest/
												  //End if
												  //End if
												
												If (Length:C16(String:C10($Obj_in.format))#0)
													
													$Txt_buffer:=Replace string:C233($Txt_buffer;"imageformat=best";"imageformat="+$Obj_in.format)
													
												End if 
												
												$Txt_url:=$Obj_result.url+$Txt_url
												$Txt_version:=Substring:C12($Txt_url;Position:C15("$version=";$Txt_url)+Length:C16("$version="))
												
												If (Position:C15("&";$Txt_version)>0)
													
													$Txt_version:=Substring:C12($Txt_version;1;Position:C15("&";$Txt_version)-1)
													
												End if 
												
												$File_output:=$Obj_in.output
												
												Case of 
														
														  //----------------------------------------
													: ($Obj_field.relatedDataClass#Null:C1517)  // want to dump in relation?
														
														If (Bool:C1537($Obj_in.dataSet))
															
															$File_output:=$File_output+$Obj_field.relatedDataClass+Folder separator:K24:12+$Obj_field.relatedDataClass+"("+$Txt_id+")"+"_"+$Obj_field.name+"_"+$Txt_version+".imageset"+Folder separator:K24:12
															
														End if 
														
														$File_name:=$Obj_field.relatedDataClass+"("+$Txt_id+")"+"_"+$Obj_field.name+"_"+$Txt_version+$Obj_in.format
														
														  //----------------------------------------
													: ($Obj_field.relatedField#Null:C1517)  // want to dump in current table as related field
														
														If (Bool:C1537($Obj_in.dataSet))
															
															$File_output:=$File_output+$o.name+Folder separator:K24:12+$o.name+"("+$Txt_id+")"+"_"+$Obj_field.relatedField+"."+$Obj_field.name+"_"+$Txt_version+".imageset"+Folder separator:K24:12
															
														End if 
														
														$File_name:=$o.name+"("+$Txt_id+")"+"_"+$Obj_field.relatedField+"."+$Obj_field.name+"_"+$Txt_version+$Obj_in.format
														
														  //----------------------------------------
													Else 
														
														If (Bool:C1537($Obj_in.dataSet))
															
															$File_output:=$File_output+$o.name+Folder separator:K24:12+$o.name+"("+$Txt_id+")"+"_"+$Obj_field.name+"_"+$Txt_version+".imageset"+Folder separator:K24:12
															
														End if 
														
														$File_name:=$o.name+"("+$Txt_id+")"+"_"+$Obj_field.name+"_"+$Txt_version+$Obj_in.format
														
														  //----------------------------------------
												End case 
												
												CREATE FOLDER:C475($File_output+$File_name;*)
												
												If (Test path name:C476($File_output+$File_name)#Is a document:K24:1)
													
													$Obj_rest:=Rest (New object:C1471("action";"image";\
														"headers";$Obj_in.headers;\
														"url";$Txt_url;\
														"target";$File_output+$File_name\
														))
													ob_error_combine ($Obj_out;$Obj_rest)
													
												Else 
													
													  // No need to dump. File already dumped.
													$Obj_rest:=New object:C1471("success";False:C215)
													
												End if 
												
												If ($Obj_rest.success)
													
													If (Bool:C1537($Obj_in.debug))
														$Obj_result.files.push(New object:C1471(\
															"path";$File_output+$File_name;\
															"contentSize";Num:C11($Obj_rest.contentSize)))
													End if 
													
													$Obj_result.contentSize:=$Obj_result.contentSize+Num:C11($Obj_rest.contentSize)
													$Obj_result.count:=$Obj_result.count+1
													
													If (Bool:C1537($Obj_in.dataSet))
														
														TEXT TO DOCUMENT:C1237($File_output+"Contents.json";\
															JSON Stringify:C1217(New object:C1471(\
															"info";New object:C1471(\
															"version";1;\
															"author";"xcode"\
															);\
															"images";New collection:C1472(New object:C1471(\
															"idiom";"universal";\
															"filename";$File_name)))))
														
													End if 
													
												Else 
													
													  // Remove the image if wrong type
													If (Not:C34(Is picture file:C1113($File_output+$File_name)))
														
														DELETE DOCUMENT:C159($File_output+$File_name)
														
														If (Bool:C1537($Obj_in.dataSet))
															
															DELETE FOLDER:C693($File_output)
															
														End if 
													End if 
												End if 
												
												  // Else ignore
												
											End if 
										End if 
									End for each 
								End for each 
							End if 
							
							If (Num:C11($Obj_result.contentSize)>0)
								
								$File_output:=$Obj_in.output+$o.name+Folder separator:K24:12
								$File_output:=$File_output+"manifest.json"
								TEXT TO DOCUMENT:C1237($File_output;\
									JSON Stringify:C1217(New object:C1471(\
									"contentSize";Num:C11($Obj_result.contentSize);\
									"count";Num:C11($Obj_result.count))))
								
							End if 
							
							$Obj_out.results[String:C10($o.name)]:=$Obj_result
							
						End if 
						
					Else 
						
						  // DUMP without rest is not implemented. Could use ds, with query filters to do it?
						
					End if 
				End if 
			End for each 
			
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