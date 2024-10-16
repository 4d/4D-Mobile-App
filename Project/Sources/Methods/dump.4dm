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
var $Txt_field : Text
var $ID; $url; $version : Text
var $imageFound : Boolean
var $dataModel; $meta; $o; $field; $record : Object
var $query; $rest; $result; $table : Object
var $fields : Collection
var $destinationFile; $file : 4D:C1709.File
var $ouputFolder : 4D:C1709.Folder
var $error : cs:C1710.error
var $targetFolder : 4D:C1709.Folder

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
	: (($in.dataModel=Null:C1517) && (Position:C15("_"; $in.action)#1)/*private methods*/)
		
		$out.errors:=New collection:C1472("`dataModel` must be specified when dumping")
		
		// MARK:- catalog
	: ($in.action="catalog")
		
		$result:=New object:C1471
		
		$out.success:=True:C214
		
		// For each table
		For each ($tableID; $dataModel) While ($out.success)
			
			If (Not:C34(Bool:C1537(Storage:C1525.flags.stopGeneration)))
				
				$table:=$dataModel[$tableID]
				$meta:=$table[""]
				
				If ($withUI)
					
					// Notify user
					CALL FORM:C1391($in.caller; $in.method; "dump"; New object:C1471(\
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
					var $target : 4D:C1709.File
					$target:=File:C1566($outputPathname; fk platform path:K87:2)
					$target.create()
					
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
					
					$target.setText(JSON Stringify:C1217($rest.response; *))
					
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
				
				If (Not:C34($rest.success))
					ob_error_add($out; "Failed to dump data class '"+String:C10($meta.name)+"' definition")
				End if 
				ob_error_combine($out; $rest)
				
			Else 
				
				$out.success:=False:C215  // Global success is false
				
			End if 
		End for each 
		
		$out.results:=$result
		
		// MARK:- data
	: ($in.action="data")
		
		$out.success:=True:C214
		
		$out.results:=New object:C1471
		
		var $rgx : cs:C1710.regex
		$rgx:=cs:C1710.regex.new()
		$rgx.pattern:="(?mi-s),\"__GlobalStamp\":(\\d+),\"__COUNT\":(\\d+),\"__FIRST\":(\\d+).*,\"__SENT\":(\\d+).{1,10}$"
		
		var $count; $page; $pages : Integer
		
		//var $useTextRestResponse : Boolean
		//$useTextRestResponse:=Feature.with("useTextRestResponse")
		
		var $notify : 4D:C1709.Function
		$notify:=Formula:C1597(CALL FORM:C1391($in.caller; $in.method; "dump"; $1))
		
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
				
				If ($withUI)
					
					// Display the table being processed
					$notify.call(Null:C1517; New object:C1471(\
						"step"; "table"; \
						"table"; $meta))
					
				End if 
				
				// Get field list name
				If (False:C215)
					$o:=dump(New object:C1471(\
						"action"; "_fieldNames"; \
						"catalog"; $in.catalog; \
						"table"; $table))
				Else 
					$o:=dumpFieldNames(New object:C1471(\
						"catalog"; $in.catalog; \
						"table"; $table))
				End if 
				
				If (Bool:C1537($in.expand))  // If we want to use old way to do it, not optimized $expand
					ASSERT:C1129(Not:C34(dev_Matrix); "Expand code must not be used, remove?")  // check if not used
					If ($o.expand.length>0)
						
						$query["$expand"]:=$o.expand.join(",")
						
					End if 
				End if 
				
				// For each page (if page allowed)
				For ($page; 1; SHARED.data.dump.page; 1)
					
					$cancelled:=Bool:C1537(Storage:C1525.flags.stopGeneration)
					
					If (Not:C34($cancelled))
						
						If ($page>1)
							
							If ($withUI)
								
								If ($pages=0) & ($rgx.matches.length>0)
									
									$count:=Num:C11($rgx.matches[2].data)
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
							"reponseType"; Is text:K8:3; \
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
										"reponseType"; Is text:K8:3; \
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
						If (Not:C34($rest.success))
							ob_error_add($out; "Failed to dump data class '"+String:C10($meta.name)+"' data")
						End if 
						ob_error_combine($out; $rest)
						
						If ($out.success)
							
							// Analyse response
							$rgx.setTarget($rest.response)
							
							If ($rgx.match())
								
								$rest.globalStamp:=Num:C11($rgx.matches[1].data)
								
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
							
							If ($withUI)
								
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
						
						If ($rgx.matches.length=0) || ((Num:C11($rgx.matches[3].data)+Num:C11($rgx.matches[4].data))>=Num:C11($rgx.matches[2].data))
							
							$page:=MAXLONG:K35:2-1  // BREAK
							
						End if 
					End if 
				End for 
			End if 
		End for each 
		
		// MARK: _fieldNames
	: ($in.action="_fieldNames")  // Get field names for dump with table (model format) - CALLERS : dump
		
		$out.success:=($in.table#Null:C1517)
		If (Not:C34($out.success))
			$out.errors:=New collection:C1472("Missing table property")
			return 
		End if 
		
		$out.fields:=New collection:C1472()
		$out.expand:=New collection:C1472()
		
		For each ($Txt_field; $in.table)
			
			Case of 
					
					//………………………………………………………………………………………………………………………
				: (Length:C16($Txt_field)=0)
					
					// <NOTHING MORE TO DO>
					
					//………………………………………………………………………………………………………………………
				: (Match regex:C1019("(?m-si)^\\d+$"; $Txt_field; 1; *))  // CLEAN: use PROJECT.isField (ie. scalaire only)
					
					$out.fields.push($in.table[$Txt_field].name)
					
					//………………………………………………………………………………………………………………………
				: ((Value type:C1509($in.table[$Txt_field])=Is object:K8:27))
					
					$Obj_buffer:=$in.table[$Txt_field]
					
					Case of 
						: (PROJECT.isAlias($Obj_buffer))
							
							$out.fields.push($Obj_buffer.path)
							
							// TODO: Fix get last point instead
							
							If (Position:C15("."; $Obj_buffer.path)>0)
								$Txt_field:=Substring:C12($Obj_buffer.path; 1; Position:C15("."; $Obj_buffer.path)-1)
								If ($out.expand.indexOf($Txt_field)<0)
									$out.expand.push($Txt_field)
								End if 
							End if 
							
							
						: (PROJECT.isComputedAttribute($Obj_buffer))
							
							$out.fields.push($Txt_field)
							
						Else 
							// CLEAN: use PROJECT.isRelati...
							If ($Obj_buffer.relatedEntities#Null:C1517)  // To remove if relatedEntities deleted and relatedDataClass already filled #109019
								
								$Obj_buffer.relatedDataClass:=$Obj_buffer.relatedEntities
								
							End if 
							
							If ($Obj_buffer.relatedDataClass#Null:C1517)  // Is is a link?
								
								If ($out.expand.indexOf($Txt_field)<0)
									
									$out.expand.push($Txt_field)
									
								End if 
								
								var $Txt_fieldNumber : Text
								For each ($Txt_fieldNumber; $Obj_buffer)
									
									Case of 
										: (Match regex:C1019("(?m-si)^\\d+$"; $Txt_fieldNumber; 1; *))  // fieldNumber
											
											$out.fields.push($Txt_field+"."+$Obj_buffer[$Txt_fieldNumber].name)
											
										: (Value type:C1509($Obj_buffer[$Txt_fieldNumber])=Is object:K8:27)
											
											Case of 
												: (PROJECT.isAlias($Obj_buffer[$Txt_fieldNumber]))
													
													$out.fields.push($Txt_field+"."+$Obj_buffer[$Txt_fieldNumber].path)
													
													// TODO: alias, maybe some other intermediated expand values
													
												: (PROJECT.isComputedAttribute($Obj_buffer[$Txt_fieldNumber]))
													
													$out.fields.push($Txt_field+"."+$Obj_buffer[$Txt_fieldNumber].name)
													
											End case 
											
										Else 
											
											// Ignore (primary key, etc...)
											
									End case 
								End for each 
								
								// Else  Ignore
								
							End if 
					End case 
					
					//………………………………………………………………………………………………………………………
				Else 
					
					// Ignore
					
					//………………………………………………………………………………………………………………………
			End case 
		End for each 
		
		var $Obj_buffer; $Obj_table : Object
		var $Txt_buffer : Text
		
		// Add primary key if needed for expanded data
		For each ($Txt_field; $out.expand)
			
			ASSERT:C1129($in.catalog#Null:C1517; "Need catalog definition to dump data")
			
			$Obj_table:=$in.catalog.query("name = :1"; $in.table[""].name).pop()
			
			// TODO: if contain "." split and get first, and loop
			$field:=$Obj_table.fields.query("name = :1"; $Txt_field).pop()
			
			$Obj_buffer:=New object:C1471
			$Obj_buffer.tableInfo:=$in.catalog.query("name = :1"; String:C10($field.relatedDataClass)).pop()
			$Obj_buffer.success:=$Obj_buffer.tableInfo#Null:C1517
			
			If ($Obj_buffer.success)
				
				$Txt_buffer:=$Txt_field+"."+$Obj_buffer.tableInfo.primaryKey
				
				If ($out.fields.indexOf($Txt_buffer)<0)
					
					$out.fields.push($Txt_buffer)
					
				End if 
				
			Else 
				
				ob_warning_add($out; "Cannot get information for related table , related by link "+$Txt_field+" in "+$in.table+")")
				
			End if 
		End for each 
		
		$o:=$in.table[""]
		
		// Append the primaryKey if any
		If ((Length:C16(String:C10($o.primaryKey))>0) & \
			($out.fields.indexOf(String:C10($o.primaryKey))<0))
			
			$out.fields.push($o.primaryKey)
			
		End if 
		
		// MARK:- pictures
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
			$o:=dump(New object:C1471(\
				"action"; "_pictureFields"; \
				"table"; $table))
			
			// Check if there is image (XXX use some extract/filter function)
			$fields:=$o.fields
			
			If ($fields=Null:C1517)
				
				$fields:=New collection:C1472()  // Just to not failed, CLEAN check status instead
				
			End if 
			
			If ($fields.length>0)
				
				If ($withUI)
					
					// Notify user
					CALL FORM:C1391($in.caller; $in.method; "dump"; New object:C1471(\
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
					
					var $fileT : 4D:C1709.File
					$fileT:=File:C1566($t; fk platform path:K87:2)
					
					If ($fileT.exists)
						
						$rest:=ob_parseFile($fileT)
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
												: ($field.name#Null:C1517)
													
													If ($record[$field.name]#Null:C1517)
														
														$o:=$record[$field.name]
														
													End if 
													
													//----------------------------------------
												: (($field.path#Null:C1517) && ($field.kind="alias"))
													
													var $aliasName; $relatedDataClass : Text
													var $partCol : Collection
													var $aliasObj : Object
													var $partCount : Integer
													
													If (Position:C15("."; $field.path)>0)
														
														$partCol:=Split string:C1554($field.path; ".")
														
														$partCount:=1
														
														$aliasName:=$partCol[0]
														
														If ($record[$aliasName]#Null:C1517)
															
															$aliasObj:=$record[$aliasName]
															
															$partCol.remove(0)
															
															// For a scalar field, we want to know the dataclass containing the field
															$relatedDataClass:=ds:C1482[$meta.name][$aliasName].relatedDataClass
															
															// Go through path parts
															For each ($aliasName; $partCol)
																
																If ($aliasObj#Null:C1517)
																	
																	If ($aliasObj[$aliasName]#Null:C1517)
																		
																		If ($partCount<$partCol.count())
																			
																			$relatedDataClass:=ds:C1482[$relatedDataClass][$aliasName].relatedDataClass
																			
																			$aliasObj:=$aliasObj[$aliasName]
																			
																		Else   // last path item
																			
																			$o:=$aliasObj[$aliasName]
																			// Add informations for image file naming
																			$o.ID:=$aliasObj["__KEY"]
																			$o.name:=$aliasName
																			$o.relatedDataClass:=$relatedDataClass
																			
																		End if 
																		
																	End if 
																	
																Else 
																	break
																End if 
																
																$partCount+=1
																
															End for each 
															
														End if 
														
													Else 
														
														If ($record[$field.path]#Null:C1517)
															
															$o:=$record[$field.path]
															// Add informations for image file naming
															$o.ID:=$record["__KEY"]
															$o.name:=$field.path
															$o.relatedDataClass:=$meta.name
															
														End if 
														
													End if 
													
													//----------------------------------------
											End case 
											
											If ($o#Null:C1517)
												
												If ($withUI)
													
													// Notify user
													CALL FORM:C1391($in.caller; $in.method; "dump"; New object:C1471(\
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
													
													// Make sure the folder exist
													$targetFolder:=Folder:C1567($in.output; fk platform path:K87:2)
													$targetFolder.create()
													
													//TODO: Work with the File and Folder instead of the path to avoid the headache of folder separators.
													$outputPathname:=$targetFolder.platformPath
													
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
															
														: (($field.path#Null:C1517) && ($field.kind="alias"))
															
															If (($o.relatedDataClass#Null:C1517) && ($o.ID#Null:C1517) && ($o.name#Null:C1517))
																
																If (Bool:C1537($in.dataSet))
																	
																	$outputPathname:=$outputPathname+$o.relatedDataClass+Folder separator:K24:12+$o.relatedDataClass+"("+$o.ID+")"+"_"+$o.name+"_"+$version+".imageset"+Folder separator:K24:12
																	
																End if 
																
																$File_name:=$o.relatedDataClass+"("+$o.ID+")"+"_"+$o.name+"_"+$version
																
															End if 
															
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
															
															File:C1566($outputPathname+"Contents.json"; fk platform path:K87:2).setText(JSON Stringify:C1217(New object:C1471(\
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
							
							$outputPathname:=$in.output+Folder separator:K24:12+$meta.name+Folder separator:K24:12
							$outputPathname:=$outputPathname+"manifest.json"
							
							File:C1566($outputPathname; fk platform path:K87:2).setText(JSON Stringify:C1217(New object:C1471(\
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
		
		// MARK: _pictureFields
	: ($in.action="_pictureFields")  // get field names for dump with table (model format) - CALLERS : dump
		
		$out.fields:=New collection:C1472()
		
		If ($out.success)
			$out.errors:=New collection:C1472("Missing table property")
			return 
		End if 
		
		$out.success:=True:C214
		
		For each ($Txt_field; $in.table)
			Case of 
					//………………………………………………………………………………………………………………………
				: (Match regex:C1019("(?m-si)^\\d+$"; $Txt_field; 1; *))
					
					If ($in.table[$Txt_field].fieldType=Is picture:K8:10)
						
						$out.fields.push($in.table[$Txt_field])
						
					End if 
					
					//………………………………………………………………………………………………………………………
				: (Value type:C1509($in.table[$Txt_field])#Is object:K8:27)
					
					//………………………………………………………………………………………………………………………
				: ($in.table[$Txt_field].relatedDataClass#Null:C1517)  // Is it a link?
					
					For each ($Txt_fieldNumber; $in.table[$Txt_field])
						
						If (Match regex:C1019("(?m-si)^\\d+$"; $Txt_fieldNumber; 1; *))  // fieldNumber
							
							If ($in.table[$Txt_field][$Txt_fieldNumber].fieldType=Is picture:K8:10)  // if image
								
								$field:=OB Copy:C1225($in.table[$Txt_field][$Txt_fieldNumber])
								$field.relatedDataClass:=$in.table[$Txt_field].relatedDataClass  // copy it only if wanted to index picture on this table
								$field.relatedField:=$Txt_field
								$out.fields.push($field)
								
							End if 
							
						Else 
							
							// Ignore (primary key, etc...)
							
						End if 
					End for each 
					
					//………………………………………………………………………………………………………………………
				: ($in.table[$Txt_field].fieldType#Null:C1517)
					
					If ($in.table[$Txt_field].fieldType=Is picture:K8:10)
						
						$out.fields.push($in.table[$Txt_field])
						
					End if 
					
					//………………………………………………………………………………………………………………………
			End case 
		End for each 
		
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$in.action+"\"")
		
		//________________________________________
End case 