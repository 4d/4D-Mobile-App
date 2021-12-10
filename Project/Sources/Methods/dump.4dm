//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : dump
// ID[BC6599132D8B41458EE1B30856D08E06]
// Created 27-6-2017 by Eric Marchand
// ----------------------------------------------------
// Description:
// Dump rest info
// ----------------------------------------------------
// Declarations
#DECLARE($in : Object)->$out : Object

If (False:C215)
	C_OBJECT:C1216(dump; $1)
	C_OBJECT:C1216(dump; $0)
End if 

var $File_name; $outputPathname; $format; $tableID; $Txt_buffer; $Txt_handler : Text
var $Txt_id; $Txt_url; $Txt_version : Text
var $imageFound : Boolean
var $i; $posBegin; $posEnd : Integer
var $dataModel; $delay; $meta; $Obj_buffer; $Obj_field; $Obj_record : Object
var $query; $rest; $result; $table : Object
var $Col_pictureFields : Collection
var $destinationFile; $file : 4D:C1709.File
var $ouputFolder : 4D:C1709.Folder
var $error : cs:C1710.error

// ----------------------------------------------------
// Initialisations
ASSERT:C1129($in#Null:C1517)

$out:=New object:C1471(\
"success"; False:C215)

// Check output
If (Length:C16(String:C10($in.output))=0)
	
	$in.output:=Temporary folder:C486
	
Else 
	
	Folder:C1567($in.output; fk platform path:K87:2).create()
	
End if 

// DataModel
$dataModel:=$in.dataModel

If ($dataModel=Null:C1517)
	
	$dataModel:=$in.project.dataModel
	
End if 

var $withUI : Boolean
$withUI:=$in.caller#Null:C1517

var $cancelled : Boolean

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($in.action=Null:C1517)
		
		$out.errors:=New collection:C1472("Missing tag \"action\"")
		
		//______________________________________________________
	: ($in.dataModel=Null:C1517)
		
		$out.errors:=New collection:C1472("`dataModel` must be specified when dumping")
		
		//______________________________________________________
	: ($in.action="catalog")
		
		$result:=New object:C1471
		
		$out.success:=True:C214
		
		// For each table
		For each ($tableID; $dataModel) While ($out.success)
			
			If (Not:C34(Bool:C1537(Storage:C1525.flags.stopGeneration)))
				
				$table:=$dataModel[$tableID]
				$meta:=$table[""]
				
				If ($withUI & FEATURE.with("cancelableDatasetGeneration"))
					
					// Notify user
					CALL FORM:C1391($in.caller; "editor_CALLBACK"; "dump"; New object:C1471(\
						"step"; "catalog"; \
						"table"; $meta))
					
				End if 
				
				$rest:=Rest(New object:C1471(\
					"action"; "table"; \
					"url"; $in.url; \
					"headers"; $in.headers; \
					"table"; $meta.name))
				
				If (Value type:C1509($rest.headers)=Is object:K8:27)
					
					If ($in.headers["Cookie"]=Null:C1517)
						
						$in.headers["Cookie"]:=$rest.headers["Set-Cookie"]
						
					End if 
				End if 
				
				If ($rest.success)
					
					If (Substring:C12($in.output; Length:C16($in.output); 1)=Folder separator:K24:12)
						
						$outputPathname:=$in.output+$meta.name
						
					Else 
						
						$outputPathname:=$in.output+Folder separator:K24:12+$meta.name
						
					End if 
					
					If (Bool:C1537($in.dataSet))
						
						$outputPathname:=$outputPathname+".catalog.dataset"+Folder separator:K24:12+$meta.name
						
					End if 
					
					$outputPathname:=$outputPathname+".catalog.json"
					
					// Make sure the folder exist
					CREATE FOLDER:C475($outputPathname; *)
					
					If (Bool:C1537($in.dataSet))
						
						asset(New object:C1471("action"; "create"; \
							"type"; "dataset"; \
							"target"; $in.output; \
							"tags"; New object:C1471(\
							"name"; $meta.name+".catalog"; \
							"fileName"; $meta.name+".catalog.json"; \
							"uti"; "public.json")))
						
					End if 
					
/* START HIDING ERRORS */
					$error:=cs:C1710.error.new("capture")
					
					TEXT TO DOCUMENT:C1237($outputPathname; JSON Stringify:C1217($rest.response; *))
					
/* STOP HIDING ERRORS */
					$error.show()
					
					If ($error.withError())
						
						$rest.success:=False:C215
						$rest.errorCode:=$error.lastError().error
						$out.success:=False:C215
						
					End if 
					
				Else 
					
					$out.success:=False:C215  // Global success is false
					
				End if 
				
				$result[$meta.name]:=$rest
				
				ob_error_combine($out; $rest)
				
			Else 
				
				$out.success:=False:C215  // Global success is false
				
			End if 
		End for each 
		
		$out.results:=$result
		
		//______________________________________________________
	: ($in.action="data")
		
		$out.success:=True:C214
		
		$out.results:=New object:C1471
		
		For each ($tableID; $dataModel) While (Not:C34($cancelled))
			
			$query:=Null:C1517
			
			$table:=$dataModel[$tableID]
			$meta:=$table[""]
			
			If (Bool:C1537($meta.embedded))  // If the data is to be embedded
				
				// Create the query string for rest
				$query:=New object:C1471(\
					"$limit"; String:C10(SHARED.data.dump.limit))
				
				If ($meta.filter#Null:C1517)  // If there is a filter
					
					If (Bool:C1537($meta.filter.validated))  // If the filter is validated
						
						If (Bool:C1537($meta.filter.parameters))  // If there is user parameters
							
							// Data will be loaded according to the user parameters
							$query:=Null:C1517  // <NOTHING MORE TO DO>
							
						Else 
							
							$query["$filter"]:=String:C10($meta.filter.string)
							$query["$queryplan"]:="true"
							
							If (SHARED.globalFilter#Null:C1517)
								
								// Add the global filter
								$query["$filter"]:="("+$query["$filter"]+") AND "+String:C10(SHARED.globalFilter)
								
							End if 
						End if 
					End if 
					
				Else 
					
					If (SHARED.globalFilter#Null:C1517)
						
						// Use the global filter
						$query["$filter"]:=String:C10(SHARED.globalFilter)
						$query["$queryplan"]:="true"
						
					End if 
				End if 
			End if 
			
			$cancelled:=Bool:C1537(Storage:C1525.flags.stopGeneration)
			
			If ($query#Null:C1517) & (Not:C34($cancelled))  // If query defined, we must dump the table
				
				If ($withUI & FEATURE.with("cancelableDatasetGeneration"))
					
					// Display the table being processed
					CALL FORM:C1391($in.caller; "editor_CALLBACK"; "dump"; New object:C1471(\
						"step"; "table"; \
						"table"; $meta))
					
				End if 
				
				// Get field list name
				$Obj_buffer:=dataModel(New object:C1471(\
					"action"; "fieldNames"; \
					"table"; $table))
				
				If (Bool:C1537($in.expand))  // If we want to use old way to do it, not optimized $expand
					
					If ($Obj_buffer.expand.length>0)
						
						$query["$expand"]:=$Obj_buffer.expand.join(",")
						
					End if 
				End if 
				
				// For each page (if page allowed)
				For ($i; 1; SHARED.data.dump.page; 1)
					
					$cancelled:=Bool:C1537(Storage:C1525.flags.stopGeneration)
					
					If (Not:C34($cancelled))
						
						If ($i>1)
							
							If ($withUI & FEATURE.with("cancelableDatasetGeneration"))
								
								// Notify user
								CALL FORM:C1391($in.caller; "editor_CALLBACK"; "dump"; New object:C1471(\
									"step"; "table"; \
									"table"; $meta; \
									"page"; $i))
								
							End if 
							
							$query["$skip"]:=String:C10(SHARED.data.dump.limit*($i-1))
							
						End if 
						
						// Do the rest request
						$rest:=Rest(New object:C1471(\
							"action"; "records"; \
							"reponseType"; Is object:K8:27; \
							"url"; $in.url; \
							"headers"; $in.headers; \
							"table"; $meta.name; \
							"fields"; $Obj_buffer.fields; \
							"queryEncode"; True:C214; \
							"query"; $query))
						
						If ($rest.errors#Null:C1517)
							
							If ($rest.errors.length>0)
								
								If ($rest.errors[0]="Invalid internal state")
									
									$rest:=Rest(New object:C1471(\
										"action"; "records"; \
										"reponseType"; Is object:K8:27; \
										"url"; $in.url; \
										"headers"; $in.headers; \
										"table"; $meta.name; \
										"fields"; $Obj_buffer.fields; \
										"queryEncode"; True:C214; \
										"query"; $query))
									
								End if 
							End if 
						End if 
						
						// Getting global stamp (maybe no more necessary , except for debug, all is done by swift code)
						$rest.globalStamp:=$rest.response.__GlobalStamp
						
						If ($out.results[$meta.name]=Null:C1517)
							
							$out.results[$meta.name]:=New collection:C1472($rest)
							
						Else 
							
							$out.results[$meta.name].push($rest)
							
						End if 
						
						ob_error_combine($out; $rest)
						
					End if 
					
					$out.success:=$rest.success
					$cancelled:=Bool:C1537(Storage:C1525.flags.stopGeneration)
					
					If (Not:C34($cancelled))
						
						$outputPathname:=Folder:C1567($in.output; fk platform path:K87:2).file($meta.name).platformPath
						
						If (Bool:C1537($in.dataSet))
							
							$outputPathname:=$outputPathname+".dataset"+Folder separator:K24:12+$meta.name
							
						End if 
						
						If ($i#1)
							
							$outputPathname:=$outputPathname+"."+String:C10($i-1)
							
						End if 
						
						$outputPathname:=$outputPathname+".data.json"
						
						// Make sure the folder exist
						CREATE FOLDER:C475($outputPathname; *)
						
					End if 
					
					$cancelled:=Bool:C1537(Storage:C1525.flags.stopGeneration)
					
					If (Not:C34($cancelled))
						
						If (Bool:C1537($in.dataSet))
							
							If ($withUI & FEATURE.with("cancelableDatasetGeneration"))
								
								If ($i>=2)
									
									CALL FORM:C1391($in.caller; "editor_CALLBACK"; "dump"; New object:C1471(\
										"step"; "asset"; \
										"table"; $meta; \
										"page"; $i))
									
								Else 
									
									CALL FORM:C1391($in.caller; "editor_CALLBACK"; "dump"; New object:C1471(\
										"step"; "asset"; \
										"table"; $meta))
									
								End if 
							End if 
							
							asset(New object:C1471(\
								"action"; "create"; \
								"type"; "dataset"; \
								"target"; $in.output; \
								"tags"; New object:C1471(\
								"name"; $meta.name; \
								"fileName"; $meta.name+".data.json"; \
								"uti"; "public.json")))
							
						End if 
						
						$rest.write:=ob_writeToDocument($rest.response; $outputPathname; True:C214)
						ob_error_combine($out; $rest.write)
						
						If (Not:C34($rest.write.success))
							
							$rest.success:=False:C215
							$out.success:=False:C215
							
						End if 
					End if 
					
					If ($cancelled)
						
						$out.success:=False:C215
						$i:=MAXLONG:K35:2-1  // Break
						
					Else 
						
						If ((Num:C11($rest.response.__FIRST)+Num:C11($rest.response.__SENT))>=Num:C11($rest.response.__COUNT))
							
							$i:=MAXLONG:K35:2-1  // BREAK
							
						End if 
					End if 
				End for 
			End if 
		End for each 
		
		//______________________________________________________
	: ($in.action="pictures")
		
		If ($in.format=Null:C1517)
			
			$in.format:="best"
			
		End if 
		
		$out.success:=True:C214
		
		$out.results:=New object:C1471(\
			)
		
		// For each table
		For each ($tableID; $dataModel) While (Not:C34($cancelled))
			
			$cancelled:=Bool:C1537(Storage:C1525.flags.stopGeneration)
			
			$table:=$dataModel[$tableID]
			$meta:=$table[""]
			$Obj_buffer:=dataModel(New object:C1471(\
				"action"; "pictureFields"; \
				"table"; $table))
			
			// Check if there is image (XXX use some extract/filter function)
			$Col_pictureFields:=$Obj_buffer.fields
			
			If ($Col_pictureFields=Null:C1517)
				
				$Col_pictureFields:=New collection:C1472()  // Just to not failed, CLEAN check status instead
				
			End if 
			
			If ($Col_pictureFields.length>0)
				
				If ($withUI & FEATURE.with("cancelableDatasetGeneration"))
					
					// Notify user
					CALL FORM:C1391($in.caller; "editor_CALLBACK"; "dump"; New object:C1471(\
						"step"; "pictures"; \
						"table"; $meta))
					
				End if 
				
				If (Bool:C1537($in.rest)\
					 | (Length:C16(String:C10($in.url))>0))
					
					// ----------------------------------
					// Get Image from REST server, default local one
					// ----------------------------------
					
					// If cached rest result use it
					$Txt_buffer:=String:C10($in.cache)+Folder separator:K24:12+$meta.name
					
					If (Bool:C1537($in.dataSet))
						
						$Txt_buffer:=$Txt_buffer+".dataset"+Folder separator:K24:12+$meta.name
						
					End if 
					
					$Txt_buffer:=$Txt_buffer+".data.json"
					
					If (Test path name:C476($Txt_buffer)=Is a document:K24:1)
						
						$rest:=ob_parseDocument($Txt_buffer)
						$rest.response:=$rest.value
						
					Else 
						
						// No more supported, data file must be passed
						$rest:=New object:C1471(\
							"success"; False:C215)
						
					End if 
					
					// We have succeed to have rest result
					If ($rest.success)
						
						// Rest server URL ? (to replace in image url
						$in.action:="url"
						$result:=Rest($in)
						
						$result.contentSize:=0
						$result.count:=0
						
						If (Bool:C1537($in.debug))
							
							$out.files:=New collection:C1472()
							
						End if 
						
						$Txt_handler:="mobileapp/"
						
						If (Position:C15($Txt_handler; $result.url)=0)
							
							$result.url:=$result.url+$Txt_handler
							ASSERT:C1129(False:C215; "URL must contains "+$Txt_handler)
							
						End if 
						
						If (Value type:C1509($rest.response.__ENTITIES)=Is collection:K8:32)
							
							// For each records
							For each ($Obj_record; $rest.response.__ENTITIES) While (Not:C34($cancelled))
								
								$cancelled:=Bool:C1537(Storage:C1525.flags.stopGeneration)
								
								If (Not:C34($cancelled))
									
									// ... look for images
									For each ($Obj_field; $Col_pictureFields) While (Not:C34($cancelled))
										
										$cancelled:=Bool:C1537(Storage:C1525.flags.stopGeneration)
										
										If (Not:C34($cancelled))
											
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
												
												If ($withUI & FEATURE.with("cancelableDatasetGeneration"))
													
													// Notify user
													CALL FORM:C1391($in.caller; "editor_CALLBACK"; "dump"; New object:C1471(\
														"step"; "pictures"; \
														"table"; $meta; \
														"id"; $Txt_id))
													
												End if 
												
												If (Bool:C1537($Obj_buffer.__deferred.image))
													
													// Get url for image
													$Txt_url:=String:C10($Obj_buffer.__deferred.uri)
													
													If (Position:C15("/mobileapp/"; $Txt_url)>0)
														
														$Txt_url:=Substring:C12($Txt_url; 12)  // Remove /mobileapp/
														
													End if 
													
													If (Length:C16(String:C10($in.format))#0)
														
														If ($in.format#"best")
															
															$Txt_url:=Replace string:C233($Txt_url; "imageformat=best"; "imageformat="+$in.format)
															
														End if 
													End if 
													
													$Txt_url:=$result.url+$Txt_url
													$Txt_version:=Substring:C12($Txt_url; Position:C15("$version="; $Txt_url)+Length:C16("$version="))
													
													If (Position:C15("&"; $Txt_version)>0)
														
														$Txt_version:=Substring:C12($Txt_version; 1; Position:C15("&"; $Txt_version)-1)
														
													End if 
													
													$outputPathname:=$in.output
													
													Case of 
															
															//----------------------------------------
														: ($Obj_field.relatedDataClass#Null:C1517)  // Want to dump in relation?
															
															If (Bool:C1537($in.dataSet))
																
																$outputPathname:=$outputPathname+$Obj_field.relatedDataClass+Folder separator:K24:12+$Obj_field.relatedDataClass+"("+$Txt_id+")"+"_"+$Obj_field.name+"_"+$Txt_version+".imageset"+Folder separator:K24:12
																
															End if 
															
															$File_name:=$Obj_field.relatedDataClass+"("+$Txt_id+")"+"_"+$Obj_field.name+"_"+$Txt_version
															
															//----------------------------------------
														: ($Obj_field.relatedField#Null:C1517)  // Want to dump in current table as related field
															
															If (Bool:C1537($in.dataSet))
																
																$outputPathname:=$outputPathname+$meta.name+Folder separator:K24:12+$meta.name+"("+$Txt_id+")"+"_"+$Obj_field.relatedField+"."+$Obj_field.name+"_"+$Txt_version+".imageset"+Folder separator:K24:12
																
															End if 
															
															$File_name:=$meta.name+"("+$Txt_id+")"+"_"+$Obj_field.relatedField+"."+$Obj_field.name+"_"+$Txt_version
															
															//----------------------------------------
														Else 
															
															If (Bool:C1537($in.dataSet))
																
																$outputPathname:=$outputPathname+$meta.name+Folder separator:K24:12+$meta.name+"("+$Txt_id+")"+"_"+$Obj_field.name+"_"+$Txt_version+".imageset"+Folder separator:K24:12
																
															End if 
															
															$File_name:=$meta.name+"("+$Txt_id+")"+"_"+$Obj_field.name+"_"+$Txt_version
															
															//----------------------------------------
													End case 
													
													$format:=$in.format
													
													$ouputFolder:=Folder:C1567($outputPathname; fk platform path:K87:2)
													
													If (Not:C34($ouputFolder.exists))
														
														$ouputFolder.create()
														
													End if 
													
													$imageFound:=False:C215
													
													If ($format="best")
														
														For each ($file; $ouputFolder.files()) Until ($imageFound)
															
															If (Position:C15($File_name; $file.name)=1)
																
																$imageFound:=True:C214
																$File_name:=$file.fullName
																
															End if 
														End for each 
														
													Else 
														
														$imageFound:=$ouputFolder.file($File_name+$format).exists
														
													End if 
													
													If (Not:C34($imageFound))
														
														$rest:=Rest(New object:C1471("action"; "image"; \
															"headers"; $in.headers; \
															"url"; $Txt_url; \
															"target"; $outputPathname+$File_name+$format\
															))
														ob_error_combine($out; $rest)
														
														If ($rest.success)
															
															If (Not:C34(Folder:C1567($outputPathname; fk platform path:K87:2).file($File_name+$format).exists))
																
																$rest:=New object:C1471(\
																	"success"; False:C215; \
																	"parent"; $rest)
																
																ob_error_add($rest; "No image dumped into target "+$outputPathname+$File_name+$format)
																ob_error_combine($out; $rest)
																
															End if 
														End if 
														
													Else 
														
														// No need to dump. File already dumped.
														$rest:=New object:C1471(\
															"success"; False:C215)
														
													End if 
													
													If ($rest.success)
														
														If ($format="best")
															
															// Find extension according to content type
															If ($rest.headers["Content-Type"]#Null:C1517)
																
																If (Position:C15("image/"; $rest.headers["Content-Type"])=1)
																	
																	$format:="."+Replace string:C233($rest.headers["Content-Type"]; "image/"; "")
																	
																	If (Position:C15("+"; $format)>0)
																		
																		$format:=Substring:C12($format; 1; Position:C15("+"; $format)-1)
																		
																	End if 
																End if 
															End if 
															
															If ($format#"best")
																
																$destinationFile:=$ouputFolder.file($File_name+$format)
																
																If ($destinationFile.exists)
																	
																	$destinationFile.delete()
																	
																End if 
																
																$ouputFolder.file($File_name+"best").rename($File_name+$format)
																
															End if 
														End if 
														
														$File_name:=$File_name+$format
														
														If (Bool:C1537($in.debug))
															
															$result.files.push(New object:C1471(\
																"path"; $outputPathname+$File_name; \
																"contentSize"; Num:C11($rest.contentSize)))
															
														End if 
														
														$result.contentSize:=$result.contentSize+Num:C11($rest.contentSize)
														$result.count:=$result.count+1
														
														If (Bool:C1537($in.dataSet))
															
															TEXT TO DOCUMENT:C1237($outputPathname+"Contents.json"; \
																JSON Stringify:C1217(New object:C1471(\
																"info"; New object:C1471(\
																"version"; 1; \
																"author"; "xcode"\
																); \
																"images"; New collection:C1472(New object:C1471(\
																"idiom"; "universal"; \
																"filename"; $File_name)))))
															
														End if 
														
													Else 
														
														// Remove the image if wrong type
														If (Not:C34(Is picture file:C1113($outputPathname+$File_name)))
															
															DELETE DOCUMENT:C159($outputPathname+$File_name)
															
															If (Bool:C1537($in.dataSet))
																
																DELETE FOLDER:C693($outputPathname)
																
															End if 
														End if 
													End if 
													
													// Else ignore
													
												End if 
											End if 
											
										Else 
											
											// A "If" statement should never omit "Else"
											
										End if 
										
									End for each 
									
								Else 
									
								End if 
							End for each 
						End if 
						
						If (Num:C11($result.contentSize)>0)
							
							$outputPathname:=$in.output+$meta.name+Folder separator:K24:12
							$outputPathname:=$outputPathname+"manifest.json"
							TEXT TO DOCUMENT:C1237($outputPathname; \
								JSON Stringify:C1217(New object:C1471(\
								"contentSize"; Num:C11($result.contentSize); \
								"count"; Num:C11($result.count))))
							
						End if 
						
						$out.results[String:C10($meta.name)]:=$result
						
					End if 
					
				Else 
					
					// DUMP without rest is not implemented. Could use ds, with query filters to do it?
					
				End if 
			End if 
		End for each 
		
		//________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$in.action+"\"")
		
		//________________________________________
End case 