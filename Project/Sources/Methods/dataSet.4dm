//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : dataSet
// ID[BC6566132D8B51458EE1B40856D08E06]
// Created 08-3-2018 by Eric Marchand
// ----------------------------------------------------
// Description:
// data set management
// ----------------------------------------------------
// Declarations
#DECLARE($in : Object)->$out : Object

If (False:C215)
	C_OBJECT:C1216(dataSet; $1)
	C_OBJECT:C1216(dataSet; $0)
End if 

var $cmd; $inputStream; $key; $outputStream; $pathname; $t : Text
var $tableID; $Txt_assets; $Txt_error; $Txt_ID : Text
var $verbose; $withPictures; $withUI : Boolean
var $i : Integer
var $dataModel; $delay; $field; $headers; $o; $table : Object
var $actions; $fields; $tables : Collection
var $file : 4D:C1709.File
var $folder : 4D:C1709.Folder

ARRAY TEXT:C222($tTxt_documents; 0)

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	$out:=New object:C1471(\
		"success"; False:C215)
	
	$withUI:=$in.caller#Null:C1517
	
Else 
	
	ABORT:C156
	
End if 

$verbose:=Bool:C1537($in.verbose) | (Feature.with("vdl"))

If ($in.url=Null:C1517)
	
	If (String:C10($in.project.dataSource.source)="server")
		
		$in.url:=$in.project.server.urls.production
		
	Else 
		
		// localhost
		
	End if 
End if 

// ----------------------------------------------------
If (Asserted:C1132($in.action#Null:C1517; "Missing tag \"action\""))
	
	Case of 
			
			// MARK:- path
		: ($in.action="path")
			
			Case of 
					
					//----------------------------------------
				: (Value type:C1509($in.project)=Is object:K8:27)
					
					Case of 
							
							//======================================
						: ($in.project._folder#Null:C1517)
							
							$out.path:=$in.project._folder.folder("project.dataSet").platformPath
							$out.success:=True:C214
							
							//======================================
						: (Value type:C1509($in.project.$project)#Is object:K8:27)
							
							$out.errors:=New collection:C1472("No product path defined to get dataset path")
							$out.success:=False:C215
							
							//======================================
						Else 
							
							// Just in case root not defined, recreate it with project path
							If ($in.project.$project.root=Null:C1517)
								
								If ($in.project.$project.project#Null:C1517)
									
									$in.project.$project.root:=Path to object:C1547($in.project.$project.project).parentFolder
									ASSERT:C1129(Length:C16($in.project.$project.root)>0; "It seems that profect folder do match file")
									
								End if 
							End if 
							
							If ($in.project.$project.project#Null:C1517)
								
								$out.path:=$in.project.$project.root+"project.dataSet"+Folder separator:K24:12
								$out.success:=True:C214
								
							Else 
								
								$out.errors:=New collection:C1472("No project file path")
								$out.success:=False:C215
								
							End if 
							
							//======================================
					End case 
					
					//----------------------------------------
				: (Value type:C1509($in.project)=Is text:K8:3)  // For test purpose, allow to inject file path
					
					Case of 
							
							//........................................
						: (File:C1566($in.project; fk platform path:K87:2).exists)
							
							$out.path:=File:C1566($in.project; fk platform path:K87:2).parent.platformPath+"project.dataSet"+Folder separator:K24:12
							$out.success:=True:C214
							
							//........................................
						: (Folder:C1567($in.project; fk platform path:K87:2).exists)
							
							$out.path:=$in.project+"project.dataSet"+Folder separator:K24:12
							$out.success:=True:C214
							
							//........................................
						Else 
							
							$out.errors:=New collection:C1472($in.project+" do not exits. Project file is not correctly defined")
							$out.success:=False:C215
							
							//........................................
					End case 
					
					//----------------------------------------
				Else 
					
					$out.errors:=New collection:C1472("No product path defined to get dataset path")
					$out.success:=False:C215
					
					//----------------------------------------
			End case 
			
			// MARK:- check
		: ($in.action="check")
			
			// / Check if exist, and if digest check also if same digest = same structure and url ...
			If ($in.path=Null:C1517)
				
				$in.action:="path"
				$out:=dataSet($in)  // -> need project parameter
				
			Else 
				
				$out:=New object:C1471(\
					"success"; True:C214; \
					"path"; String:C10($in.path))
				
			End if 
			
			$dataModel:=$in.dataModel
			
			If ($dataModel=Null:C1517)
				
				$dataModel:=$in.project.dataModel  // compatibility issue (try to pass dataModel)
				
			End if 
			
			If ($out.success)
				
				$out.exists:=Folder:C1567($out.path; fk platform path:K87:2).exists
				
				If (Bool:C1537($in.digest))
					
					If (File:C1566($out.path+"dataSetDigest"; fk platform path:K87:2).exists)
						
						$out.digest:=New object:C1471(\
							"old"; dataSet(New object:C1471(\
							"action"; "digest"; \
							"dataModel"; $dataModel; \
							"url"; $in.url)).digest; \
							"new"; File:C1566($out.path+"dataSetDigest"; fk platform path:K87:2).getText())
						
						$out.valid:=$out.digest.old=$out.digest.new
						
					Else 
						
						$out.valid:=False:C215  // no digest file
						ob_warning_add($out; "No digest file. Maybe failed to generated correctly data dump")
						
					End if 
					
				Else 
					
					$out.valid:=True:C214  // check only path existance
					
				End if 
				
				If ($out.valid && Bool:C1537($in.coreDataSet))
					$out.valid:=cs:C1710.path.new().iOSDb($out.path).exists
				End if 
				
				If ($out.valid && Bool:C1537($in.androidDataSet))
					$out.valid:=cs:C1710.path.new().androidDb($out.path).exists
				End if 
				
			End if 
			
			// MARK:- digest
		: ($in.action="digest")
			
			// Remove some info in table not concerned
			$tables:=New collection:C1472()
			$dataModel:=$in.dataModel
			
			Case of 
					
					//----------------------------------------
				: ($dataModel=Null:C1517)
					
					$out.errors:=New collection:C1472("dataModel must be defined to create dataSet digest")
					
					//----------------------------------------
				Else 
					
					For each ($tableID; $dataModel)
						
						$table:=$dataModel[$tableID]
						
						$o:=$table[""]
						
						If (Bool:C1537($o.embedded))
							
							$fields:=New collection:C1472()
							
							For each ($key; $table)
								
								Case of 
										
										//……………………………………………………………………………………………………………
									: (Match regex:C1019("(?m-si)^\\d+$"; $key; 1; *))  // fieldNumber
										
										// TODO: Change field.id to field.fieldNumber
										$field:=New object:C1471(\
											"id"; $table[$key].id; \
											"type"; $table[$key].fielType)
										
										$fields.push($field)
										
										//……………………………………………………………………………………………………………
									: (Value type:C1509($dataModel[$tableID][$key])=Is object:K8:27)
										
										If ($table[$key].relatedDataClass#Null:C1517)  // Relation
											
											For each ($Txt_ID; $table[$key])
												
												If (Match regex:C1019("(?m-si)^\\d+$"; $Txt_ID; 1; *))  // related fieldNumber
													
													// TODO: Change field.id to field.fieldNumber
													$field:=New object:C1471(\
														"id"; $table[$key][$Txt_ID].id; \
														"type"; $table[$key][$Txt_ID].fielType)
													
													$fields.push($field)
													
												End if 
											End for each 
										End if 
										
										//........................................
									Else 
										
										//........................................
								End case 
							End for each 
							
							$tables.push(New object:C1471(\
								"id"; $tableID; \
								"filter"; $o.filter; \
								"fields"; $fields))
							
						End if 
					End for each 
					
					// Information needed to check data digest
					$out.digest:=Generate digest:C1147(JSON Stringify:C1217(New object:C1471(\
						"tables"; $tables; \
						"url"; $in.url; \
						"version"; 1)); \
						0)
					
					$out.success:=True:C214
					
					//----------------------------------------
			End case 
			
			// MARK:- erase
		: ($in.action="erase")
			
			If ($in.path=Null:C1517)
				
				$in.action:="path"
				$out:=dataSet($in)
				
			Else 
				
				$out:=New object:C1471(\
					"success"; True:C214; \
					"path"; String:C10($in.path))
				
			End if 
			
			If ($out.success)
				
				If (Folder:C1567($out.path; fk platform path:K87:2).exists)
					
					Folder:C1567($out.path; fk platform path:K87:2).delete(Delete with contents:K24:24)
					
				Else 
					
					$out.errors:=New collection:C1472("Trying to erase dataSet without folder")
					
				End if 
			End if 
			
			// MARK:- copy
		: ($in.action="copy")
			
			$in.action:="check"
			$out:=dataSet($in)
			
			If ($out.success)
				
				var $source; $target : 4D:C1709.Folder
				
				$target:=Folder:C1567($in.target; fk platform path:K87:2)
				$source:=Folder:C1567($out.path; fk platform path:K87:2)
				
				For each ($pathname; New collection:C1472("Sources"; "Resources"))
					
					folder_copyMerge($source.folder($pathname); $target)
					
				End for each 
			End if 
			
			// MARK:- create
		: ($in.action="create")  // later allow to do it with remove
			
			If ($withUI)
				
				$delay:=New object:C1471(\
					"minimumDisplayTime"; 3*60; \
					"start"; Tickcount:C458)
				
			End if 
			
			If (($in.path=Null:C1517)\
				 & (Value type:C1509($in.project)=Is object:K8:27))
				
				// Check if we must erase if exist
				If (Bool:C1537($in.eraseIfExists))
					
					$out:=dataSet(New object:C1471(\
						"action"; "check"; \
						"digest"; False:C215; \
						"project"; $in.project))
					
					If (Bool:C1537($out.exists))
						
						$out:=dataSet(New object:C1471(\
							"action"; "erase"; \
							"project"; $in.project))
						
					End if 
				End if 
				
				// Manage default path
				$in.path:=dataSet(New object:C1471(\
					"action"; "path"; \
					"project"; $in.project)).path
				
			End if 
			
			$dataModel:=$in.dataModel
			$actions:=$in.actions
			
			If ($dataModel=Null:C1517)
				
				$dataModel:=$in.project.dataModel  // compatibility issue (try to pass dataModel)
				
			End if 
			
			If ($actions=Null:C1517)
				
				$actions:=$in.project.actions  // compatibility issue (try to pass dataModel)
				
			End if 
			
			$folder:=Folder:C1567($in.path; fk platform path:K87:2)
			$folder.create()
			
			$out.path:=$folder.platformPath
			
			If (Asserted:C1132($folder.exists))
				
				If (WEB Get server info:C1531.started | (Length:C16(String:C10($in.url))>0))
					
					If ($verbose)
						
						LOG_EVENT(New object:C1471(\
							"message"; "Dump catalog"; \
							"importance"; Information message:K38:1))
						
					End if 
					
					If ($withUI)
						
						$delay.start:=Tickcount:C458
						DELAY PROCESS:C323(Current process:C322; ($delay.minimumDisplayTime/2))
						
					End if 
					
					$Txt_assets:=asset(New object:C1471("action"; "path")).path
					
					Case of 
							
							//----------------------------------------
						: (Value type:C1509($in.headers)=Is object:K8:27)
							
							$headers:=$in.headers
							
							//----------------------------------------
						: (dump_Headers#Null:C1517)  // a cache for each dump
							
							$headers:=dump_Headers
							
							//----------------------------------------
						Else 
							
							$headers:=New object:C1471
							dump_Headers:=$headers
							
							//----------------------------------------
					End case 
					
					If ($headers["X-MobileApp"]=Null:C1517)
						
						$headers["X-MobileApp"]:="1"  // Help server to identify request type
						
					End if 
					
					$out.headers:=$headers
					
					// Simply put file content in header (could instead encode/encrypt some information if   file allow it)
					Case of 
							
							//----------------------------------------
						: (Length:C16(String:C10($in.key))=0)
							
							// Ignore
							
						: (File:C1566($in.key; fk platform path:K87:2).exists)
							
							//$headers.Authorization:="Bearer "+Document to text($in.key)
							$headers.Authorization:="Bearer "+File:C1566($in.key; fk platform path:K87:2).getText()
							
							//----------------------------------------
						: (Length:C16(Path to object:C1547(String:C10($in.key)).parentFolder)=0)  // normal string
							
							$headers.Authorization:="Bearer "+$in.key
							
							//----------------------------------------
						Else 
							
							ob_error_add($out; "Key file "+String:C10($in.key)+" do not exists")
							
							//----------------------------------------
					End case 
					
					$out.catalog:=dump(New object:C1471(\
						"action"; "catalog"; \
						"url"; $in.url; \
						"headers"; $headers; \
						"output"; $out.path+Choose:C955(Bool:C1537($in.dataSet); $Txt_assets+"Catalog"; "JSON"); \
						"dataSet"; $in.dataSet; \
						"debug"; Bool:C1537($in.debug); \
						"dataModel"; $dataModel; \
						"caller"; $in.caller; \
						"method"; $in.method))
					
					ob_error_combine($out; $out.catalog)
					
					If ($out.catalog.success)  // Do not dump data if catalog failed
						
						If ($verbose)
							
							LOG_EVENT(New object:C1471(\
								"message"; "Dump Data"; \
								"importance"; Information message:K38:1))
							
						End if 
						
						$out.data:=dump(New object:C1471(\
							"action"; "data"; \
							"url"; $in.url; \
							"headers"; $headers; \
							"output"; $out.path+Choose:C955(Bool:C1537($in.dataSet); $Txt_assets+"Data"; "JSON"); \
							"dataSet"; $in.dataSet; \
							"debug"; Bool:C1537($in.debug); \
							"dataModel"; $dataModel; \
							"catalog"; $in.project.getCatalog(); \
							"caller"; $in.caller; \
							"method"; $in.method))
						
						ob_error_combine($out; $out.data)
						
						$out.success:=$out.catalog.success & $out.data.success
						
						$withPictures:=True:C214  // Default = with images
						
						If ($in.picture#Null:C1517)
							
							$withPictures:=(Bool:C1537($in.picture))  // Test purpose
							
						Else 
							
							$withPictures:=(Not:C34(Bool:C1537($in.project.dataSource.doNotExportImages)))
							
						End if 
						
						If ($withPictures)
							
							If ($verbose)
								
								LOG_EVENT(New object:C1471(\
									"message"; "Dump Pictures"; \
									"importance"; Information message:K38:1))
								
							End if 
							
							If ($withUI)
								
								CALL FORM:C1391($in.caller; $in.method; "dump"; New object:C1471("step"; "pictures"))
								
							End if 
							
							$out.picture:=dump(New object:C1471(\
								"action"; "pictures"; \
								"url"; $in.url; \
								"headers"; $headers; \
								"rest"; True:C214; "cache"; $out.path+Choose:C955(Bool:C1537($in.dataSet); $Txt_assets+"Data"; "JSON"); \
								"dataSet"; $in.dataSet; \
								"debug"; Bool:C1537($in.debug); \
								"output"; $out.path+Choose:C955(Bool:C1537($in.dataSet); $Txt_assets+"Pictures"; "Resources"+Folder separator:K24:12+"Pictures"); \
								"dataModel"; $dataModel; \
								"caller"; $in.caller; \
								"method"; $in.method))
							
							ob_error_combine($out; $out.picture)
							
							$out.success:=$out.success & $out.picture.success
							
						End if 
						
						If (Bool:C1537($in.accordingToTarget))
							
							If (Value type:C1509($in.project.info.target)=Is collection:K8:32)
								
								$in.coreDataSet:=Is macOS:C1572 && ($in.project.info.target.indexOf("iOS")>-1)
								$in.androidDataSet:=$in.project.info.target.indexOf("android")>-1
								
							Else 
								
								$in.coreDataSet:=Is macOS:C1572 && (String:C10($in.project.info.target)="iOS")
								$in.androidDataSet:=(String:C10($in.project.info.target)="android")
								
							End if 
						End if 
						
						$out.removeAsset:=Bool:C1537($in.androidDataSet) | Bool:C1537($in.coreDataSet)
						
						If (Bool:C1537($in.coreDataSet) & $out.success)
							
							$out.coreData:=cs:C1710.xcDataModel.new($in.project).run(\
								/*path*/Folder:C1567($out.path; fk platform path:K87:2).file("Sources/Structures.xcdatamodeld").platformPath; \
								/*options*/New object:C1471("flat"; False:C215; "relationship"; True:C214))
							
							ob_error_combine($out; $out.coreData)
							
							$out.coreDataSet:=dataSet(New object:C1471(\
								"action"; "coreData"; \
								"removeAsset"; Feature.disabled("androidDataSet")/*False*/; \
								"path"; $out.path; \
								"caller"; $in.caller; \
								"method"; $in.method))
							
							ob_error_combine($out; $out.coreDataSet)
							
						End if 
						
						If (Bool:C1537($in.androidDataSet) & $out.success)
							
							$out.androidDataSet:=dataSet(New object:C1471(\
								"action"; "androidDataSet"; \
								"path"; $out.path; \
								"project"; $in.project; \
								"caller"; $in.caller))
							
							ob_error_combine($out; $out.androidDataSet)
							
						End if 
						
						$out.success:=Not:C34(ob_error_has($out))
						
						If ($out.success & $out.removeAsset)
							
							$out.removeAsset:=dataSet(New object:C1471(\
								"action"; "removeAsset"; \
								"path"; $out.path))
							
						End if 
						// Generate a digest according to structure
						If (Bool:C1537($in.digest) & $out.success)
							
							$out.digest:=dataSet(New object:C1471(\
								"action"; "digest"; \
								"dataModel"; $dataModel; \
								"url"; $in.url)).digest
							
							File:C1566($out.path+"dataSetDigest"; fk platform path:K87:2).setText($out.digest)
							
						End if 
					End if 
					
				Else 
					
					$out.success:=False:C215
					$out.errors:=New collection:C1472("Web server not running")
					
					If ($verbose)
						
						LOG_EVENT(New object:C1471(\
							"message"; "Web server not running"; \
							"importance"; Error message:K38:3))
						
					End if 
				End if 
			End if 
			
			If ($withUI)
				
				If (Bool:C1537(Storage:C1525.flags.stopGeneration))
					
					// Display cancelled message
					CALL FORM:C1391($in.caller; $in.method; "dump"; New object:C1471("step"; "cancelledOperation"))
					
					// Reset to allow user read the message
					$delay.start:=Tickcount:C458
					
				End if 
				
				$delay.duration:=Tickcount:C458-$delay.start
				
				If ($delay.duration<$delay.minimumDisplayTime)
					
					DELAY PROCESS:C323(Current process:C322; $delay.minimumDisplayTime-$delay.duration)
					
				End if 
				
				If (Not:C34(Bool:C1537($in.keepUI)))
					
					// Notify the end of the process
					CALL FORM:C1391($in.caller; $in.method; "dump"; New object:C1471("step"; "end"))
					
				End if 
			End if 
			
			// MARK:- readCatalog
		: ($in.action="readCatalog")
			
			If ((Value type:C1509($in.project)=Is object:K8:27))
				
				$out.catalog:=New object:C1471
				
				$in.path:=dataSet(New object:C1471(\
					"action"; "path"; \
					"project"; $in.project)).path
				
				$folder:=asset(New object:C1471("action"; "path"; "path"; $in.path)).path.folder("Catalog")
				
				If ($folder.exists)
					
					For each ($file; $folder.files())
						
						If (Position:C15(".catalog.json"; $file.fullName)>0)
							
							$out.catalog[Path to object:C1547(Path to object:C1547($tTxt_documents{$i}).name).name]:=ob_parseFile($file).value
							
						End if 
					End for each 
					
					$out.success:=True:C214
					
				End if 
				
			Else 
				
			End if 
			
			// MARK:- coreData
		: ($in.action="coreData")
			
			If (Not:C34(Bool:C1537(Storage:C1525.flags.stopGeneration)))
				
				If ($withUI)
					
					CALL FORM:C1391($in.caller; $in.method; "dump"; New object:C1471("step"; "coreDataInjection"))
					
				End if 
				
				$cmd:=str_singleQuoted(cs:C1710.path.new().scripts().file("coredataimport").path)
				
				If ($in.posix=Null:C1517)\
					 & ($in.path#Null:C1517)
					
					$in.posix:=Convert path system to POSIX:C1106($in.path)
					
				End if 
				
				If ($in.posix#Null:C1517)
					
					$cmd+=" --asset "+str_singleQuoted($in.posix+"Resources/Assets.xcassets")\
						+" --structure "+str_singleQuoted($in.posix+"Sources/Structures.xcdatamodeld")\
						+" --output "+str_singleQuoted($in.posix+"Resources")
					
					SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
					LAUNCH EXTERNAL PROCESS:C811($cmd; $inputStream; $outputStream; $Txt_error)
					
					If (Asserted:C1132(OK=1; "LEP failed: "+$cmd))
						
						If ((Position:C15("[Error]"; $outputStream)=0) && (Position:C15("NSException"; $Txt_error)=0))
							
							$out.success:=True:C214
							
							If (Bool:C1537($in.removeAsset))
								
								Folder:C1567($in.posix+"Resources/Assets.xcassets/Data"; fk posix path:K87:1).delete(Delete with contents:K24:24)
								Folder:C1567($in.posix+"Resources/Assets.xcassets/Catalog"; fk posix path:K87:1).delete(Delete with contents:K24:24)
								
							End if 
							
						Else 
							
							For each ($t; Split string:C1554($outputStream; "\n"))
								
								If (Position:C15("[Error]"; $t)>0)
									
									ob_error_add($out; $t)
									
								End if 
							End for each 
							
							
							If (Length:C16($Txt_error)>0)
								
								Logger.error("Coredata import exception:\n "+$Txt_error)
								
							End if 
							
						End if 
						
					Else 
						
						// Out return an error message
						$out.success:=False:C215
						
						If (Length:C16($outputStream)>0)
							
							ob_error_add($out; $outputStream)
							
							Logger.error("Coredata import exception:\n "+$outputStream)
							
						Else 
							
							ob_error_add($out; "No output when dumping into mobile database")
							
						End if 
					End if 
					
					If ((Length:C16($Txt_error)>0))  // Add always error from command output if any, but do not presume if success or not
						
						ob_warning_add($out; $Txt_error)
						
					End if 
					
				Else 
					
					$out.errors:=New collection:C1472("path or posix must be defined to produce dataset")
					
				End if 
			End if 
			
			// MARK:- coreDataAddToProject
		: ($in.action="coreDataAddToProject")
			
			$file:=Folder:C1567($in.path; fk platform path:K87:2).file("Resources/Structures.sqlite")
			
			If ($file.exists)
				
				$out.projfile:=XcodeProj(New object:C1471(\
					"action"; "read"; \
					"path"; $in.path))
				ob_error_combine($out; $out.projfile)
				
				If (Bool:C1537($out.projfile.success))
					
					XcodeProj(New object:C1471(\
						"action"; "mapping"; \
						"projObject"; $out.projfile))
					
					$out.inject:=XcodeProjInject(New object:C1471(\
						"path"; $file.platformPath; \
						"types"; New collection:C1472(); \
						"mapping"; $out.projfile.mapping; \
						"proj"; $out.projfile.value; \
						"uuid"; $in.uuid; \
						"target"; $in.path\
						))
					ob_error_combine($out; $out.inject)
					
					If (Bool:C1537($out.inject.success))
						
						$out.projfile:=XcodeProj(New object:C1471(\
							"action"; "write"; \
							"object"; $out.projfile.value; \
							"project"; $in.tags.product; \
							"path"; $out.projfile.path))
						ob_error_combine($out; $out.projfile)
						
						$out.success:=$out.projfile.success
						
					End if 
				End if 
			End if 
			
			// MARK:- androidDataSet
		: ($in.action="androidDataSet")
			
			$out.androidPrepackaged:=cs:C1710.AndroidPrepackaged.new().generate($in.project; $in.project._folder)
			ob_error_combine($out; $out.androidPrepackaged)
			
			$out.success:=$out.androidPrepackaged.success
			
			
			// MARK:- removeAsset
		: ($in.action="removeAsset")
			
			$folder:=Folder:C1567($in.path; fk platform path:K87:2)
			
			$folder.folder("Resources/Assets.xcassets/Data").delete(Delete with contents:K24:24)
			$folder.folder("Resources/Assets.xcassets/Catalog").delete(Delete with contents:K24:24)
			
			//________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "Unknown entry point: \""+$in.action+"\"")
			
			//________________________________________
	End case 
End if 

If ($withUI && ($in.action="create"))
	
	$out.caller:=$in.caller
	CALL FORM:C1391($in.caller; $in.method; $in.message; $out)
	
End if 