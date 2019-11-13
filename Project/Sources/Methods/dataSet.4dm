//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : dataSet
  // ID[BC6566132D8B51458EE1B40856D08E06]
  // Created 08-3-2018 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // data set management
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_verbose)
C_LONGINT:C283($Lon_parameters;$Lon_pos;$Lon_i)
C_TEXT:C284($File_;$Txt_cmd;$Txt_error;$Txt_in;$Txt_out;$Txt_assets;$Txt_value;$Txt_tableNumber;$Txt_ID)
C_OBJECT:C1216($Obj_in;$Obj_out;$Obj_headers;$Obj_table;$Obj_field;$Obj_dataModel;$Obj_file)
C_COLLECTION:C1488($Col_fields;$Col_tables)

If (False:C215)
	C_OBJECT:C1216(dataSet ;$0)
	C_OBJECT:C1216(dataSet ;$1)
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

$Boo_verbose:=Bool:C1537($Obj_in.verbose)

If ($Obj_in.url=Null:C1517)
	
	If (String:C10($Obj_in.project.dataSource.source)="server")
		
		$Obj_in.url:=$Obj_in.project.server.urls.production
		
	Else 
		
		  // localhost
		
	End if 
End if 

  // ----------------------------------------------------
If (Asserted:C1132($Obj_in.action#Null:C1517;"Missing tag \"action\""))
	
	Case of 
			
			  //______________________________________________________
		: ($Obj_in.action="path")
			
			  //If (Bool(featuresFlags._103112))
			
			Case of 
					
					  //----------------------------------------
				: (Value type:C1509($Obj_in.project)=Is object:K8:27)
					
					If (Value type:C1509($Obj_in.project.$project)=Is object:K8:27)
						
						  // Just in case root not defined, recreate it with project path
						If ($Obj_in.project.$project.root=Null:C1517)
							
							If ($Obj_in.project.$project.project#Null:C1517)
								
								$Obj_in.project.$project.root:=Path to object:C1547($Obj_in.project.$project.project).parentFolder
								
							End if 
						End if 
						
						If ($Obj_in.project.$project.project#Null:C1517)
							
							$Obj_out.path:=$Obj_in.project.$project.root+"project.dataSet"+Folder separator:K24:12
							$Obj_out.success:=True:C214
							
						Else 
							
							$Obj_out.errors:=New collection:C1472("No project file path")
							$Obj_out.success:=False:C215
							
						End if 
						
					Else 
						
						$Obj_out.errors:=New collection:C1472("No product path defined to get dataset path")
						$Obj_out.success:=False:C215
						
					End if 
					
					  //----------------------------------------
				: (Value type:C1509($Obj_in.project)=Is text:K8:3)
					
					  // for test purpose, allow to inject file path
					
					Case of 
							
							  //........................................
						: (Test path name:C476($Obj_in.project)=Is a document:K24:1)
							
							$Obj_out.path:=Path to object:C1547($Obj_in.project).parentFolder+"project.dataSet"+Folder separator:K24:12
							$Obj_out.success:=True:C214
							
							  //........................................
						: (Test path name:C476($Obj_in.project)=Is a folder:K24:2)
							
							$Obj_out.path:=$Obj_in.project+"project.dataSet"+Folder separator:K24:12
							$Obj_out.success:=True:C214
							
							  //........................................
						Else 
							
							$Obj_out.errors:=New collection:C1472($Obj_in.project+" do not exits. Project file is not correctly defined")
							$Obj_out.success:=False:C215
							
							  //........................................
					End case 
					
					  //----------------------------------------
				Else 
					
					$Obj_out.errors:=New collection:C1472("No product path defined to get dataset path")
					$Obj_out.success:=False:C215
					
					  //----------------------------------------
			End case 
			
			  //Else 
			  //Case of 
			  //  //----------------------------------------
			  //: (Value type($Obj_in.project)=Is object)
			  //If (Asserted(Length(String($Obj_in.project.product.name))>0;"Project product name must not be empty"))
			  //$Obj_out.path:=_o_Pathname ("dataSet")+$Obj_in.project.product.name+Folder separator
			  //$Obj_out.success:=True
			  //End if 
			  //  //----------------------------------------
			  //: (Value type($Obj_in.name)=Is text)
			  //If (Asserted(Length(String($Obj_in.name))>0;"Project name must not be empty"))
			  //$Obj_out.path:=_o_Pathname ("dataSet")+$Obj_in.name+Folder separator
			  //$Obj_out.success:=True
			  //End if 
			  //  //----------------------------------------
			  //Else 
			  //$Obj_out.errors:=New collection("No product and project name to get data set path")
			  //$Obj_out.success:=False
			  //  //----------------------------------------
			  //End case 
			  //End if 
			
			  //______________________________________________________
		: ($Obj_in.action="check")
			
			  // / Check if exist, and if digest check also if same digest = same structure and url ...
			If ($Obj_in.path=Null:C1517)
				
				$Obj_in.action:="path"
				$Obj_out:=dataSet ($Obj_in)  // -> need project parameter
				
			Else 
				
				$Obj_out:=New object:C1471(\
					"success";True:C214;\
					"path";String:C10($Obj_in.path))
				
			End if 
			
			$Obj_dataModel:=$Obj_in.dataModel
			If ($Obj_dataModel=Null:C1517)
				$Obj_dataModel:=$Obj_in.project.dataModel  // compatibility issue (try to pass dataModel)
			End if 
			
			If ($Obj_out.success)
				
				$Obj_out.exists:=Test path name:C476($Obj_out.path)=Is a folder:K24:2
				
				If (Bool:C1537($Obj_in.digest))
					
					If (Test path name:C476($Obj_out.path+"dataSetDigest")=Is a document:K24:1)
						
						$Obj_out.digest:=New object:C1471(\
							"old";dataSet (New object:C1471(\
							"action";"digest";\
							"dataModel";$Obj_dataModel;\
							"url";$Obj_in.url)).digest;\
							"new";Document to text:C1236($Obj_out.path+"dataSetDigest"))
						
						$Obj_out.valid:=$Obj_out.digest.old=$Obj_out.digest.new
						
					Else 
						
						$Obj_out.valid:=False:C215  // no digest file
						
					End if 
					
				Else 
					
					$Obj_out.valid:=True:C214  // check only path existance
					
				End if 
			End if 
			
			  //$Obj_out.exists:=False
			
			  //______________________________________________________
		: ($Obj_in.action="digest")
			
			  // Remove some info in table not concerned
			$Col_tables:=New collection:C1472()
			$Obj_dataModel:=$Obj_in.dataModel
			
			Case of 
				: ($Obj_dataModel=Null:C1517)
					
					$Obj_out.errors:=New collection:C1472("dataModel must be defined to create dataSet digest")
					
				Else 
					
					For each ($Txt_tableNumber;$Obj_dataModel)
						
						$Obj_table:=$Obj_dataModel[$Txt_tableNumber]
						
						If (Bool:C1537($Obj_table.embedded))
							$Col_fields:=New collection:C1472()
							
							For each ($Txt_value;$Obj_table)
								
								Case of 
										  //……………………………………………………………………………………………………………
									: (Match regex:C1019("(?m-si)^\\d+$";$Txt_value;1;*))  // fieldNumber
										
										$Obj_field:=New object:C1471(\
											"id";$Obj_table[$Txt_value].id;\
											"type";$Obj_table[$Txt_value].fielType)
										
										$Col_fields.push($Obj_field)
										
										  //……………………………………………………………………………………………………………
									: (Value type:C1509($Obj_dataModel[$Txt_tableNumber][$Txt_value])=Is object:K8:27)
										
										If ($Obj_table[$Txt_value].relatedDataClass#Null:C1517)  // Relation
											
											For each ($Txt_ID;$Obj_table[$Txt_value])
												
												If (Match regex:C1019("(?m-si)^\\d+$";$Txt_ID;1;*))  // related fieldNumber
													
													$Obj_field:=New object:C1471(\
														"id";$Obj_table[$Txt_value][$Txt_ID].id;\
														"type";$Obj_table[$Txt_value][$Txt_ID].fielType)
													
													$Col_fields.push($Obj_field)
													
												End if 
												
											End for each 
											
										End if 
										
									Else 
										
								End case 
								
							End for each 
							
							$Col_tables.push(New object:C1471(\
								"id";$Txt_tableNumber;\
								"filter";$Obj_table.filter;\
								"fields";$Col_fields))
							
						End if 
						
					End for each 
					
					  // Information needed to check data digest
					$Obj_out.digest:=Generate digest:C1147(JSON Stringify:C1217(New object:C1471(\
						"tables";$Col_tables;\
						"url";$Obj_in.url;\
						"version";1));\
						0)
					
					$Obj_out.success:=True:C214
					
			End case 
			
			  //______________________________________________________
		: ($Obj_in.action="erase")
			
			If ($Obj_in.path=Null:C1517)
				
				$Obj_in.action:="path"
				$Obj_out:=dataSet ($Obj_in)
				
			Else 
				
				$Obj_out:=New object:C1471(\
					"success";True:C214;\
					"path";String:C10($Obj_in.path))
				
			End if 
			
			If ($Obj_out.success)
				
				If (Test path name:C476($Obj_out.path)=Is a folder:K24:2)
					
					$Txt_cmd:="rm -Rf "+str_singleQuoted (Convert path system to POSIX:C1106($Obj_out.path))
					LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
					
					If (Asserted:C1132(OK=1;"erase path failed: "+$Txt_cmd))
						
						If (Length:C16($Txt_error)#0)
							
							$Obj_out.errors:=New collection:C1472($Txt_error)
							
						End if 
					End if 
					
				Else 
					
					$Obj_out.errors:=New collection:C1472("Trying to erase dataSet without folder")
					
				End if 
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="copy")
			
			$Obj_in.action:="check"
			$Obj_out:=dataSet ($Obj_in)
			
			If ($Obj_out.success)
				
				Case of 
						
						  // ----------------------------------------
					: (Test path name:C476($Obj_in.target)=Is a document:K24:1)
						
						$Obj_out.errors:=New collection:C1472("Destination "+$Obj_in.target+" is a document")
						
						  //: (Test path name($Obj_in.path)=Is a folder)
						  // ----------------------------------------
					Else 
						
						$Txt_cmd:="cp -R "+str_singleQuoted (Convert path system to POSIX:C1106($Obj_out.path))+" "+str_singleQuoted (Convert path system to POSIX:C1106($Obj_in.target))
						LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
						
						If (Asserted:C1132(OK=1;"copy failed: "+$Txt_cmd))
							
							If (Length:C16($Txt_error)#0)
								
								$Obj_out.errors:=New collection:C1472($Txt_error)
								
							Else 
								
								$Obj_out.success:=True:C214
								
							End if 
							
						Else 
							
							$Obj_out.errors:=New collection:C1472("Unable to copy dataSet")
							
						End if 
						
						  // ----------------------------------------
				End case 
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="create")  // later allow to do it with remove
			
			If (($Obj_in.path=Null:C1517)\
				 & (Value type:C1509($Obj_in.project)=Is object:K8:27))
				
				  // Check if we must erase if exit
				If (Bool:C1537($Obj_in.eraseIfExists))
					
					$Obj_out:=dataSet (New object:C1471(\
						"action";"check";\
						"digest";False:C215;\
						"project";$Obj_in.project))
					
					If (Bool:C1537($Obj_out.exists))
						
						$Obj_out:=dataSet (New object:C1471(\
							"action";"erase";\
							"project";$Obj_in.project))
						
					End if 
				End if 
				
				  // Manage default path
				$Obj_in.path:=dataSet (New object:C1471(\
					"action";"path";\
					"project";$Obj_in.project)).path
				
				CREATE FOLDER:C475($Obj_in.path;*)
				
			End if 
			
			$Obj_dataModel:=$Obj_in.dataModel
			If ($Obj_dataModel=Null:C1517)
				$Obj_dataModel:=$Obj_in.project.dataModel  // compatibility issue (try to pass dataModel)
			End if 
			
			If (Asserted:C1132(Test path name:C476($Obj_in.path)=Is a folder:K24:2))
				
				If (WEB Is server running:C1313 | (Length:C16(String:C10($Obj_in.url))>0))
					
					  // Data set name
					$File_:=$Obj_in.path
					
					CREATE FOLDER:C475($File_;*)
					
					If ($Boo_verbose)
						
						CALL FORM:C1391($Obj_in.caller;"LOG_EVENT";New object:C1471(\
							"message";"Dump Catalog";\
							"importance";Information message:K38:1))
						
					End if 
					
					$Txt_assets:=asset (New object:C1471("action";"path")).path
					
					Case of 
							
							  //----------------------------------------
						: (Value type:C1509($Obj_in.headers)=Is object:K8:27)
							
							$Obj_headers:=$Obj_in.headers
							
							  //----------------------------------------
						: (dump_Headers#Null:C1517)  // a cache for each dump
							
							$Obj_headers:=dump_Headers
							
							  //----------------------------------------
						Else 
							
							$Obj_headers:=New object:C1471
							dump_Headers:=$Obj_headers
							
							  //----------------------------------------
					End case 
					
					If ($Obj_headers["X-MobileApp"]=Null:C1517)
						
						$Obj_headers["X-MobileApp"]:="1"  // help server to identify request type
						
					End if 
					
					$Obj_out.headers:=$Obj_headers
					
					  //If (Bool(featuresFlags._102457))
					
					  // Simply put file content in header (could instead encode/encrypt some information if key file allow it)
					Case of 
							
							  //----------------------------------------
						: (Length:C16(String:C10($Obj_in.key))=0)
							
							  // Ignore
							
							  //----------------------------------------
						: (Test path name:C476($Obj_in.key)=Is a document:K24:1)
							
							$Obj_headers["Authorization"]:="Bearer "+Document to text:C1236($Obj_in.key)
							
							  //----------------------------------------
						: (Length:C16(Path to object:C1547(String:C10($Obj_in.key)).parentFolder)=0)  // normal string
							
							$Obj_headers["Authorization"]:="Bearer "+$Obj_in.key
							
							  //----------------------------------------
						Else 
							
							ob_error_add ($Obj_out;"Key file "+String:C10($Obj_in.key)+" do not exists")
							
							  //----------------------------------------
					End case 
					  //End if 
					
					$Obj_out.catalog:=dump (New object:C1471(\
						"action";"catalog";\
						"url";$Obj_in.url;\
						"headers";$Obj_headers;\
						"output";$File_+Choose:C955(Bool:C1537($Obj_in.dataSet);$Txt_assets+"Catalog";"JSON");\
						"dataSet";$Obj_in.dataSet;\
						"debug";Bool:C1537($Obj_in.debug);\
						"dataModel";$Obj_dataModel))
					ob_error_combine ($Obj_out;$Obj_out.catalog)
					
					If ($Obj_out.catalog.success)
						
						  // Do not dump data if catalog failed
						
						If ($Boo_verbose)
							
							CALL FORM:C1391($Obj_in.caller;"LOG_EVENT";New object:C1471(\
								"message";"Dump Data";\
								"importance";Information message:K38:1))
							
						End if 
						
						$Obj_out.data:=dump (New object:C1471(\
							"action";"data";\
							"url";$Obj_in.url;\
							"headers";$Obj_headers;\
							"output";$File_+Choose:C955(Bool:C1537($Obj_in.dataSet);$Txt_assets+"Data";"JSON");\
							"dataSet";$Obj_in.dataSet;\
							"debug";Bool:C1537($Obj_in.debug);\
							"dataModel";$Obj_dataModel))
						
						ob_error_combine ($Obj_out;$Obj_out.data)
						
						$Obj_out.success:=$Obj_out.catalog.success & $Obj_out.data.success
						
						If (Bool:C1537($Obj_in.picture))
							
							If ($Boo_verbose)
								
								CALL FORM:C1391($Obj_in.caller;"LOG_EVENT";New object:C1471(\
									"message";"Dump Pictures";\
									"importance";Information message:K38:1))
								
							End if 
							
							$Obj_out.picture:=dump (New object:C1471(\
								"action";"pictures";\
								"url";$Obj_in.url;\
								"headers";$Obj_headers;\
								"rest";True:C214;"cache";$File_+Choose:C955(Bool:C1537($Obj_in.dataSet);$Txt_assets+"Data";"JSON");\
								"dataSet";$Obj_in.dataSet;\
								"debug";Bool:C1537($Obj_in.debug);\
								"output";$File_+Choose:C955(Bool:C1537($Obj_in.dataSet);$Txt_assets+"Pictures";"Resources"+Folder separator:K24:12+"Pictures");\
								"dataModel";$Obj_dataModel))
							ob_error_combine ($Obj_out;$Obj_out.picture)
							
							$Obj_out.success:=$Obj_out.success & $Obj_out.picture.success
							
						End if 
						
						$Obj_out.path:=$File_
						
						If (Bool:C1537($Obj_in.coreDataSet) & $Obj_out.success)
							
							$Obj_out.coreData:=dataModel (New object:C1471(\
								"action";"xcdatamodel";\
								"dataModel";$Obj_dataModel;\
								"flat";False:C215;\
								"relationship";True:C214;\
								"path";$File_+"Sources"+Folder separator:K24:12+"Structures.xcdatamodeld"))  // XXX maybe output in temp directory and pass it to coreDataSet
							
							$Obj_out.coreDataSet:=dataSet (New object:C1471(\
								"action";"coreData";\
								"removeAsset";True:C214;\
								"path";$File_))
							
						End if 
						
						  // Generate a digest according to structure
						If (Bool:C1537($Obj_in.digest) & $Obj_out.success)
							
							$Obj_out.digest:=dataSet (New object:C1471(\
								"action";"digest";\
								"dataModel";$Obj_dataModel;\
								"url";$Obj_in.url)).digest
							TEXT TO DOCUMENT:C1237($Obj_out.path+"dataSetDigest";$Obj_out.digest)
							
						End if 
					End if 
					
				Else 
					
					If ($Boo_verbose)
						
						CALL FORM:C1391($Obj_in.caller;"LOG_EVENT";New object:C1471(\
							"message";"Web server not running";\
							"importance";Error message:K38:3))
						
						$Obj_out.errors:=New collection:C1472("Web server not running")
						
					End if 
				End if 
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="readCatalog")
			
			If ((Value type:C1509($Obj_in.project)=Is object:K8:27))
				
				$Obj_out.catalog:=New object:C1471
				
				$Obj_in.path:=dataSet (New object:C1471(\
					"action";"path";\
					"project";$Obj_in.project)).path
				
				$File_:=asset (New object:C1471("action";"path";"path";$Obj_in.path)).path+"Catalog"
				
				If (Test path name:C476($File_)=Is a folder:K24:2)
					
					ARRAY TEXT:C222($tTxt_documents;0)
					DOCUMENT LIST:C474($File_;$tTxt_documents;Recursive parsing:K24:13+Absolute path:K24:14)
					
					For ($Lon_i;1;Size of array:C274($tTxt_documents);1)
						$Lon_pos:=Position:C15(".catalog.json";$tTxt_documents{$Lon_i})
						If ($Lon_pos>0)
							$Obj_out.catalog[Path to object:C1547(Path to object:C1547($tTxt_documents{$Lon_i}).name).name]:=ob_parseDocument ($tTxt_documents{$Lon_i}).value
						End if 
					End for 
					
					$Obj_out.success:=True:C214
					
				End if 
			Else 
				
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="coreData")
			
			$Txt_cmd:=str_singleQuoted (COMPONENT_Pathname ("scripts").file("coredataimport").path)
			
			If ($Obj_in.posix=Null:C1517)
				
				If ($Obj_in.path#Null:C1517)
					
					$Obj_in.posix:=Convert path system to POSIX:C1106($Obj_in.path)
					
				End if 
			End if 
			
			If ($Obj_in.posix#Null:C1517)
				
				$Txt_cmd:=$Txt_cmd+" --asset "+str_singleQuoted ($Obj_in.posix+"Resources/Assets.xcassets")
				$Txt_cmd:=$Txt_cmd+" --structure "+str_singleQuoted ($Obj_in.posix+"Sources/Structures.xcdatamodeld")
				$Txt_cmd:=$Txt_cmd+" --output "+str_singleQuoted ($Obj_in.posix+"Resources")
				
				LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
				
				If (Asserted:C1132(OK=1;"LEP failed: "+$Txt_cmd))
					
					C_BOOLEAN:C305($Bool_errorInOut)
					$Bool_errorInOut:=(Position:C15("[Error]";$Txt_out)>0)
					
					If (Not:C34($Bool_errorInOut))
						
						$Obj_out.success:=True:C214
						
						If (Bool:C1537($Obj_in.removeAsset))
							
							Folder:C1567($Obj_in.posix+"Resources/Assets.xcassets/Data";fk posix path:K87:1).delete(Delete with contents:K24:24)
							Folder:C1567($Obj_in.posix+"Resources/Assets.xcassets/Catalog";fk posix path:K87:1).delete(Delete with contents:K24:24)
							
						End if 
						
					Else 
						
						C_TEXT:C284($line)
						
						For each ($line;Split string:C1554($Txt_out;"\n"))
							
							If (Position:C15("[Error]";$line)>0)
								
								ob_error_add ($Obj_out;$line)
								
							End if 
						End for each 
					End if 
					
				Else 
					  // out return an error message
					$Obj_out.success:=False:C215
					ob_error_add ($Obj_out;$Txt_out)
					
				End if 
				
				If ((Length:C16($Txt_error)>0))  // add always error from command output if any, but do not presume if success or not
					ob_warning_add ($Obj_out;$Txt_error)
				End if 
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("path or posix must be defined")
				
			End if 
			  //________________________________________
		: ($Obj_in.action="coreDataAddToProject")
			
			$Obj_file:=Folder:C1567($Obj_in.path;fk platform path:K87:2).folder("Resources").file("Structures.sqlite")
			
			If ($Obj_file.exists)
				
				$Obj_out.projfile:=XcodeProj (New object:C1471(\
					"action";"read";\
					"path";$Obj_in.path))
				ob_error_combine ($Obj_out;$Obj_out.projfile)
				
				If (Bool:C1537($Obj_out.projfile.success))
					
					XcodeProj (New object:C1471(\
						"action";"mapping";\
						"projObject";$Obj_out.projfile))
					
					$Obj_out.inject:=XcodeProjInject (New object:C1471(\
						"path";$Obj_file.platformPath;\
						"types";New collection:C1472();\
						"mapping";$Obj_out.projfile.mapping;\
						"proj";$Obj_out.projfile.value;\
						"uuid";$Obj_in.uuid;\
						"target";$Obj_in.path\
						))
					ob_error_combine ($Obj_out;$Obj_out.inject)
					
					
					If (Bool:C1537($Obj_out.inject.success))
						
						$Obj_out.projfile:=XcodeProj (New object:C1471(\
							"action";"write";\
							"object";$Obj_out.projfile.value;\
							"project";$Obj_in.tags.product;\
							"path";$Obj_out.projfile.path))
						ob_error_combine ($Obj_out;$Obj_out.projfile)
						
						$Obj_out.success:=$Obj_out.projfile.success
						
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
If (Bool:C1537($Obj_in.caller))
	
	CALL FORM:C1391($Obj_in.caller;"editor_CALLBACK";"dataSet";$Obj_out)
	
End if 

$0:=$Obj_out

  // ----------------------------------------------------
  // End