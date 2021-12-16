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

var $File_name; $outputPathname; $format; $tableID; $t; $handler : Text
var $ID; $url; $version : Text
var $imageFound : Boolean
var $i; $posBegin; $posEnd : Integer
var $dataModel; $delay; $meta; $o; $field; $record : Object
var $query; $rest; $result; $table : Object
var $fields : Collection
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
		
		If (FEATURE.with("useTextRestResponse"))
			
			var $rgx : cs:C1710.regex
			$rgx:=cs:C1710.regex.new()
			$rgx.setPattern("(?mi-s),\"__GlobalStamp\":(\\d+),\"__COUNT\":(\\d+),\"__FIRST\":(\\d+).*,\"__SENT\":(\\d+).{1,10}$")
			
		End if 
		
		var $count; $page; $pages : Integer
		
		var $useTextRestResponse : Boolean
		$useTextRestResponse:=FEATURE.with("useTextRestResponse")
		
		var $notify : 4D:C1709.Function
		$notify:=Formula:C1597(CALL FORM:C1391($in.caller; "editor_CALLBACK"; "dump"; $1))
		
		var $targetFolder : 4D:C1709.Folder
		$targetFolder:=Folder:C1567($in.output; fk platform path:K87:2)
		
		// Make sure the folder exist
		$targetFolder.create()
		
		For each ($tableID; $dataModel) While ($out.success & Not:C34($cancelled))
			
			$query:=Null:C1517
			CLEAR VARIABLE:C89($pages)
			
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
					$notify.call(Null:C1517; New object:C1471(\
						"step"; "table"; \
						"table"; $meta))
					
				End if 
				
				// Get field list name
				$o:=dataModel(New object:C1471(\
					"action"; "fieldNames"; \
					"table"; $table))
				
				If (Bool:C1537($in.expand))  // If we want to use old way to do it, not optimized $expand
					
					If ($o.expand.length>0)
						
						$query["$expand"]:=$o.expand.join(",")
						
					End if 
				End if 
				
				// For each page (if page allowed)
				For ($page; 1; SHARED.data.dump.page; 1)
					
					$cancelled:=Bool:C1537(Storage:C1525.flags.stopGeneration)
					
					If (Not:C34($cancelled))
						
						If ($page>1)
							
							If ($withUI & FEATURE.with("cancelableDatasetGeneration"))
								
								If ($pages=0)
									
									If ($useTextRestResponse)
										
										$count:=Num:C11($rgx.matches[2].data)
										
									Else 
										
										$count:=Num:C11($rest.response.__COUNT)
										
									End if 
									
									$pages:=($count\SHARED.data.dump.limit)+Num:C11(($count%SHARED.data.dump.limit)>0)
									
								End if 
								
								// Notify user
								$notify.call(Null:C1517; New object:C1471(\
									"step"; "table"; \
									"table"; $meta; \
									"page"; $page; \
									"pages"; $pages))
								
							End if 
							
							$query["$skip"]:=String:C10(SHARED.data.dump.limit*($page-1))
							
						End if 
						
						// Do the rest request
						$rest:=Rest(New object:C1471(\
							"action"; "records"; \
							"reponseType"; Choose:C955($useTextRestResponse; Is text:K8:3; Is object:K8:27); \
							"url"; $in.url; \
							"headers"; $in.headers; \
							"table"; $meta.name; \
							"fields"; $o.fields; \
							"timeout"; SHARED.data.dump.timeout; \
							"queryEncode"; True:C214; \
							"query"; $query))
						
						If ($rest.errors#Null:C1517)
							
							If ($rest.errors.length>0)
								
								If ($rest.errors[0]="Invalid internal state")
									
									$rest:=Rest(New object:C1471(\
										"action"; "records"; \
										"reponseType"; Choose:C955($useTextRestResponse; Is text:K8:3; Is object:K8:27); \
										"url"; $in.url; \
										"headers"; $in.headers; \
										"table"; $meta.name; \
										"fields"; $o.fields; \
										"timeout"; SHARED.data.dump.timeout; \
										"queryEncode"; True:C214; \
										"query"; $query))
									
								End if 
							End if 
						End if 
						
						$out.success:=$rest.success
						ob_error_combine($out; $rest)
						
						If ($out.success)
							
							// Analyse response
							If ($useTextRestResponse)
								
								$rgx.setTarget($rest.response).match()
								
								If ($rgx.success)
									
									$rest.globalStamp:=Num:C11($rgx.matches[1].data)
									
								End if 
								
							Else 
								
								$rest.globalStamp:=$rest.response.__GlobalStamp
								
							End if 
							
							If ($out.results[$meta.name]=Null:C1517)
								
								$out.results[$meta.name]:=New collection:C1472($rest)
								
							Else 
								
								$out.results[$meta.name].push($rest)
								
							End if 
						End if 
					End if 
					
					$cancelled:=Bool:C1537(Storage:C1525.flags.stopGeneration)
					
					If ($out.success & Not:C34($cancelled))
						
						$outputPathname:=$targetFolder.file($meta.name).platformPath
						
						If (Bool:C1537($in.dataSet))
							
							$outputPathname:=$outputPathname+".dataset"+Folder separator:K24:12+$meta.name
							
							If ($withUI & FEATURE.with("cancelableDatasetGeneration"))
								
								If ($page>=2)
									
									$notify.call(Null:C1517; New object:C1471(\
										"step"; "asset"; \
										"table"; $meta; \
										"page"; $page; \
										"pages"; $pages))
									
								Else 
									
									$notify.call(Null:C1517; New object:C1471(\
										"step"; "asset"; \
										"table"; $meta))
									
								End if 
							End if 
							
							If ($page#1)
								
								$outputPathname:=$outputPathname+"."+String:C10($page-1)
								
							End if 
							
							$outputPathname:=$outputPathname+".data.json"
							
							asset(New object:C1471(\
								"action"; "create"; \
								"type"; "dataset"; \
								"target"; $in.output; \
								"tags"; New object:C1471(\
								"name"; $meta.name; \
								"fileName"; $meta.name+".data.json"; \
								"uti"; "public.json")))
							
						End if 
						
						Case of 
								
								//======================================
							: (Value type:C1509($rest.response)=Is BLOB:K8:12)
								
								File:C1566($outputPathname; fk platform path:K87:2).setContent($rest.response)
								$rest.write:=New object:C1471(\
									"success"; True:C214)
								
								//======================================
							: (Value type:C1509($rest.response)=Is text:K8:3)
								
								File:C1566($outputPathname; fk platform path:K87:2).setText($rest.response)
								$rest.write:=New object:C1471(\
									"success"; True:C214)
								
								//======================================
							: (Value type:C1509($rest.response)=Is object:K8:27)
								
								$rest.write:=ob_writeToDocument($rest.response; $outputPathname; True:C214)
								
								//======================================
							Else 
								
								$rest.write:=New object:C1471(\
									"success"; False:C215; \
									"errors"; New collection:C1472("No dumped data of correct type: "+String:C10(Value type:C1509($rest.response))))
								
								//======================================
						End case 
						
						ob_error_combine($out; $rest.write)
						
						If (Not:C34($rest.write.success))
							
							$rest.success:=False:C215
							$out.success:=False:C215
							
						End if 
					End if 
					
					// Resume
					If (Not:C34($out.success) | $cancelled)
						
						$out.success:=False:C215
						$page:=MAXLONG:K35:2-1  // Break
						
					Else 
						
						If ($useTextRestResponse)
							
							If ((Num:C11($rgx.matches[3].data)+Num:C11($rgx.matches[4].data))>=Num:C11($rgx.matches[2].data))
								
								$page:=MAXLONG:K35:2-1  // BREAK
								
							End if 
							
						Else 
							
							If ((Num:C11($rest.response.__FIRST)+Num:C11($rest.response.__SENT))>=Num:C11($rest.response.__COUNT))
								
								$page:=MAXLONG:K35:2-1  // BREAK
								
							End if 
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
			$o:=dataModel(New object:C1471(\
				"action"; "pictureFields"; \
				"table"; $table))
			
			// Check if there is image (XXX use some extract/filter function)
			$fields:=$o.fields
			
			If ($fields=Null:C1517)
				
				$fields:=New collection:C1472()  // Just to not failed, CLEAN check status instead
				
			End if 
			
			If ($fields.length>0)
				
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
					$t:=String:C10($in.cache)+Folder separator:K24:12+$meta.name
					
					If (Bool:C1537($in.dataSet))
						
						$t:=$t+".dataset"+Folder separator:K24:12+$meta.name
						
					End if 
					
					$t:=$t+".data.json"
					
					If (Test path name:C476($t)=Is a document:K24:1)
						
						$rest:=ob_parseDocument($t)
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
						
						$handler:="mobileapp/"
						
						If (Position:C15($handler; $result.url)=0)
							
							$result.url:=$result.url+$handler
							ASSERT:C1129(False:C215; "URL must contains "+$handler)
							
						End if 
						
						If (Value type:C1509($rest.response.__ENTITIES)=Is collection:K8:32)
							
							// For each records
							For each ($record; $rest.response.__ENTITIES) While (Not:C34($cancelled))
								
								$cancelled:=Bool:C1537(Storage:C1525.flags.stopGeneration)
								
								If (Not:C34($cancelled))
									
									// ... look for images
									For each ($field; $fields) While (Not:C34($cancelled))
										
										$cancelled:=Bool:C1537(Storage:C1525.flags.stopGeneration)
										
										If (Not:C34($cancelled))
											
											$o:=Null:C1517
											$ID:=$record.__KEY
											
											Case of 
													
													//----------------------------------------
												: ($field.relatedField#Null:C1517)
													
													$o:=$record[$field.relatedField]
													
													If ($o#Null:C1517)
														
														If ($field.relatedDataClass#Null:C1517)
															
															$ID:=$o.__KEY
															
														End if 
														
														$o:=$o[$field.name]
														
													End if 
													
													//----------------------------------------
												: ($record[$field.name]#Null:C1517)
													
													$o:=$record[$field.name]
													
													//----------------------------------------
											End case 
											
											If ($o#Null:C1517)
												
												If ($withUI & FEATURE.with("cancelableDatasetGeneration"))
													
													// Notify user
													CALL FORM:C1391($in.caller; "editor_CALLBACK"; "dump"; New object:C1471(\
														"step"; "pictures"; \
														"table"; $meta; \
														"id"; $ID))
													
												End if 
												
												If (Bool:C1537($o.__deferred.image))
													
													// Get url for image
													$url:=String:C10($o.__deferred.uri)
													
													If (Position:C15("/mobileapp/"; $url)>0)
														
														$url:=Substring:C12($url; 12)  // Remove /mobileapp/
														
													End if 
													
													If (Length:C16(String:C10($in.format))#0)
														
														If ($in.format#"best")
															
															$url:=Replace string:C233($url; "imageformat=best"; "imageformat="+$in.format)
															
														End if 
													End if 
													
													$url:=$result.url+$url
													$version:=Substring:C12($url; Position:C15("$version="; $url)+Length:C16("$version="))
													
													If (Position:C15("&"; $version)>0)
														
														$version:=Substring:C12($version; 1; Position:C15("&"; $version)-1)
														
													End if 
													
													$outputPathname:=$in.output
													
													Case of 
															
															//----------------------------------------
														: ($field.relatedDataClass#Null:C1517)  // Want to dump in relation?
															
															If (Bool:C1537($in.dataSet))
																
																$outputPathname:=$outputPathname+$field.relatedDataClass+Folder separator:K24:12+$field.relatedDataClass+"("+$ID+")"+"_"+$field.name+"_"+$version+".imageset"+Folder separator:K24:12
																
															End if 
															
															$File_name:=$field.relatedDataClass+"("+$ID+")"+"_"+$field.name+"_"+$version
															
															//----------------------------------------
														: ($field.relatedField#Null:C1517)  // Want to dump in current table as related field
															
															If (Bool:C1537($in.dataSet))
																
																$outputPathname:=$outputPathname+$meta.name+Folder separator:K24:12+$meta.name+"("+$ID+")"+"_"+$field.relatedField+"."+$field.name+"_"+$version+".imageset"+Folder separator:K24:12
																
															End if 
															
															$File_name:=$meta.name+"("+$ID+")"+"_"+$field.relatedField+"."+$field.name+"_"+$version
															
															//----------------------------------------
														Else 
															
															If (Bool:C1537($in.dataSet))
																
																$outputPathname:=$outputPathname+$meta.name+Folder separator:K24:12+$meta.name+"("+$ID+")"+"_"+$field.name+"_"+$version+".imageset"+Folder separator:K24:12
																
															End if 
															
															$File_name:=$meta.name+"("+$ID+")"+"_"+$field.name+"_"+$version
															
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
															"url"; $url; \
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