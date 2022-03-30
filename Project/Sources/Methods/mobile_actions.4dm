//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($Txt_action : Text; $Obj_in : Object)->$Obj_out : Object
// ----------------------------------------------------
// Project method : actions
// ID[66E9AA75F234494E96C5C0514F05D6C4]
// Created 7-3-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations

var $t : Text
var $o; $oResult : Object
var $action; $parameter; $manifest; $dataModel : Object
var $hasImage; $isObject : Boolean
var $format : Variant/*Text or Object*/
var $folder; $formatFolder : 4D:C1709.Folder
var $formats : Collection


If (False:C215)
	C_OBJECT:C1216(mobile_actions; $0)
	C_TEXT:C284(mobile_actions; $1)
	C_OBJECT:C1216(mobile_actions; $2)
End if 

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	$Obj_out:=New object:C1471(\
		"success"; False:C215)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		// MARK:- getFilteredActions
	: ($Txt_action="getFilteredActions")
		
		$Obj_out.actions:=New collection:C1472
		
		If (Value type:C1509($Obj_in.project.actions)=Is collection:K8:32)
			
			For each ($t; $Obj_in.names)
				For each ($action; $Obj_in.project.actions)
					If ($t=$action.name)
						$Obj_out.actions.push($action)
						break
					End if 
				End for each 
			End for each 
			
			$Obj_out.success:=$Obj_out.actions.length=$Obj_in.names.length
			
		End if 
		
		
		// MARK:- capabilities
	: ($Txt_action="capabilities")
		
		$Obj_out.capabilities:=New object:C1471(\
			"photo"; False:C215)
		
		If (Value type:C1509($Obj_in.project.actions)=Is collection:K8:32)
			
			For each ($action; $Obj_in.project.actions) Until ($hasImage)
				
				If (Value type:C1509($action.parameters)=Is collection:K8:32)
					
					For each ($parameter; $action.parameters) Until ($hasImage)
						
						Case of 
							: (String:C10($parameter.type)="image")
								
								$hasImage:=True:C214
								
							: (String:C10($parameter.format)="barcode")
								
								$hasImage:=True:C214  // Maybe separate and want only camera and not photo...
								
						End case 
						
					End for each 
				End if 
			End for each 
		End if 
		
		If ($hasImage)
			
			$Obj_out.capabilities.photo:=True:C214
			$Obj_out.capabilities.camera:=True:C214
			
		End if 
		
		// read capabilities from manifest files
		$formats:=$Obj_in.formats  // to implement a cache passed by caller
		If ($formats=Null:C1517)
			$Obj_in:=OB Copy:C1225($Obj_in)
			$Obj_in.read:=True:C214
			$formats:=mobile_actions("hostFormatList"; $Obj_in).formats
		End if 
		
		$folder:=cs:C1710.path.new().hostInputControls()
		For each ($format; $formats)
			Case of 
				: (Value type:C1509($format)=Is text:K8:3)
					$formatFolder:=$folder.folder(Substring:C12($format; 2))
					$manifest:=ob_parseFile($formatFolder.file("manifest.json")).value
				: (Value type:C1509($format)=Is object:K8:27)
					$formatFolder:=$format.folder
					$manifest:=$format
				Else 
					$manifest:=New object:C1471
					ASSERT:C1129(dev_Matrix; "Wrong type of format")
			End case 
			
			If ($manifest.capabilities#Null:C1517)
				
				$Obj_out.capabilities:=capabilities(New object:C1471("action"; "mergeObjects"; "value"; New collection:C1472($Obj_out.capabilities; capabilities(New object:C1471("action"; "natify"; "value"; $manifest.capabilities))))).value
				
			End if 
			
		End for each 
		
		$Obj_out.success:=True:C214
		
		// MARK:- form
	: ($Txt_action="form")
		
		$Obj_out.success:=True:C214
		
		$Obj_out.actions:=mobile_actions("filter"; $Obj_in).actions  // it make copy
		
		For each ($action; $Obj_out.actions)
			
			For each ($t; $action)
				
				If ($t[[1]]="$")
					
					OB REMOVE:C1226($action; $t)
					
				End if 
			End for each 
			
			If (Length:C16(String:C10($action.icon))>0)
				
				$action.icon:=$action.name
				
			End if 
			
			If ($action.label=Null:C1517)
				
				$action.label:=$action.name
				
			End if 
			
			// remove slash from json injected for action format
			If ($action.parameters#Null:C1517)
				For each ($parameter; $action.parameters)
					If (PROJECT.isCustomResource($parameter.format))
						$parameter.format:=Delete string:C232($parameter.format; 1; 1)
					End if 
				End for each 
			End if 
			
		End for each 
		
		// MARK:- filter
	: ($Txt_action="filter")
		
		If ($Obj_in.project#Null:C1517)  // Could be not(null) for test
			
			$Obj_in.actions:=$Obj_in.project.actions
			
		End if 
		
		$Obj_out.actions:=New collection:C1472()
		
		If ($Obj_in.actions#Null:C1517)
			
			If (Value type:C1509($Obj_in.actions)=Is collection:K8:32)
				
				$Obj_out.actions:=$Obj_in.actions.copy()
				
				// Filter empty names
				$Obj_out.actions:=$Obj_out.actions.query("name !=''")
				
				If (Num:C11($Obj_in.tableNumber)#0)  // Filter according to the tableNumber
					
					$Obj_out.actions:=$Obj_out.actions.query("tableNumber = :1"; Num:C11($Obj_in.tableNumber))
					
				End if 
				
				If (Length:C16($Obj_in.scope)>0)  // Filter according to the scope
					
					$Obj_out.actions:=$Obj_out.actions.query("scope = :1"; $Obj_in.scope)
					
				End if 
			End if 
		End if 
		
		// MARK:- assets
	: ($Txt_action="assets")
		
		Case of 
				
				//……………………………………………………………………………………………………………
			: ($Obj_in.target=Null:C1517)
				
				ASSERT:C1129(dev_Matrix; "target must be defined for action assets files")
				
				//……………………………………………………………………………………………………………
			Else 
				
				If ($Obj_in.project#Null:C1517)
					
					$Obj_in.actions:=$Obj_in.project.actions
					
				End if 
				
				If (Value type:C1509($Obj_in.actions)=Is collection:K8:32)
					
					$Obj_out.results:=New object:C1471
					
					$Obj_out.path:=asset(New object:C1471("action"; "path"; "path"; $Obj_in.target)).path+"Actions"+Folder separator:K24:12
					
					For each ($action; $Obj_in.actions)
						
						$o:=mobile_actions("iconPath"; New object:C1471(\
							"action"; $action))
						
						Case of 
								
								//……………………………………………………
							: (Bool:C1537($o.exists))
								
								$Obj_out.results[$action.name]:=asset(New object:C1471(\
									"action"; "create"; \
									"type"; "imageset"; \
									"source"; $o.platformPath; \
									"tags"; New object:C1471("name"; $action.name); \
									"target"; $Obj_out.path; \
									"size"; 32))
								
								ob_error_combine($Obj_out; $Obj_out.results[$action.name])
								
								//……………………………………………………
							: ($o.success)
								
								// No icon
								
								//……………………………………………………
							Else 
								
								// Icon file is missing
								ob_warning_add($Obj_out; "Missing action icon file: "+String:C10($Obj_in.action.icon))
								
								//……………………………………………………
						End case 
					End for each 
					
					$Obj_out.success:=Not:C34(ob_error_has($Obj_out))
					
				End if 
				
				//……………………………………………………………………………………………………………
		End case 
		
		// MARK:- iconPath
	: ($Txt_action="iconPath")  // RECURSIVE CALL
		
		Case of 
				
				//……………………………………………………………………………………………………………
			: ($Obj_in.action=Null:C1517)
				
				ASSERT:C1129(dev_Matrix; "action must be defined to get icon path")
				
				//……………………………………………………………………………………………………………
			: (Length:C16(String:C10($Obj_in.action.icon))=0)
				
				$Obj_out.success:=True:C214  // No icon but success
				
				//……………………………………………………………………………………………………………
			: (String:C10($Obj_in.action.icon)[[1]]="/")  // host icons
				
				$Obj_out:=cs:C1710.path.new().hostIcons().file(Delete string:C232($Obj_in.action.icon; 1; 1))
				
				//……………………………………………………………………………………………………………
			Else 
				
				$Obj_out:=cs:C1710.path.new().actionIcons().file($Obj_in.action.icon)
				
				//……………………………………………………………………………………………………………
		End case 
		
		// MARK:- addChoiceList
	: ($Txt_action="addChoiceList")  // RECURSIVE CALL
		
		// Add choice lists if any to action parameters
		If ($Obj_in.project.actions#Null:C1517)
			
			
			$dataModel:=$Obj_in.project.dataModel
			
			For each ($action; $Obj_in.project.actions)
				
				If ($action.parameters#Null:C1517)
					
					For each ($parameter; $action.parameters)
						
						$format:=Choose:C955($parameter.source=Null:C1517; String:C10($parameter.format); String:C10($parameter.source))
						
						Case of 
								
							: (PROJECT.isCustomResource($format))
								
								$format:=Delete string:C232($format; 1; 1)
								$manifest:=$Obj_in.inputControls[$format]
								If ($manifest=Null:C1517)
									// clean must be obsolete if not needed
									$manifest:=ob_parseFile(cs:C1710.path.new().hostInputControls().folder($format).file("manifest.json")).value
								End if 
								If ($manifest#Null:C1517)
									
									If ($manifest.choiceList#Null:C1517)
										
										$parameter.choiceList:=$manifest.choiceList
										
										If (Value type:C1509($parameter.choiceList)=Is object:K8:27)
											If ($parameter.choiceList.dataSource=Null:C1517)  // ie. normal source
												$parameter.choiceList:=OB Entries:C1720($parameter.choiceList)  // to try to keep order
											End if 
										End if 
										
										If ($manifest.format#Null:C1517)
											$parameter.format:=$manifest.format  // could take from manifest another way to display choice list
										Else 
											$parameter.format:="push"
										End if 
										If ($manifest.binding#Null:C1517)
											$parameter.binding:=$manifest.binding  // imageNamed for instance
										End if 
										
										If (String:C10($manifest.binding)="imageNamed")
											If ((String:C10($manifest.format)="sheet") | (String:C10($manifest.format)="picker"))
												ob_warning_add($Obj_out; "Image format not compatible with sheet or picker")
											End if 
											
											// generate images
											$folder:=Folder:C1567($Obj_in.path; fk platform path:K87:2).folder("Resources/Assets.xcassets/Action/Input")
											$manifest.isHost:=True:C214
											If ($manifest.folder=Null:C1517)
												// obsolete?
												$manifest.path:=cs:C1710.path.new().hostInputControls().folder($format).platformPath
											Else 
												$manifest.path:=$manifest.folder.platformPath
											End if 
											If (Not:C34($folder.folder($format).exists))
												
												$oResult:=asset(New object:C1471(\
													"action"; "input"; \
													"formatter"; $manifest; \
													"target"; $folder.platformPath))
												
												ob_error_combine($Obj_out; $oResult)
												
											End if 
										End if 
									End if 
									
									If ($manifest.rules#Null:C1517)
										$parameter.rules:=$manifest.rules
									End if 
								End if 
								
							: ($parameter.fieldNumber#Null:C1517)  // Linked to a field
								
								$t:=String:C10($dataModel[String:C10($action.tableNumber)][String:C10($parameter.fieldNumber)].format)
								
								If (Length:C16($t)>0)
									
									If ($t[[1]]="/")
										
										// User
										$manifest:=ob_parseFile(cs:C1710.path.new().hostFormatters().file(Substring:C12($t; 2)+"/manifest.json"))
										If ($manifest.success)
											
											$manifest:=$manifest.value
											
											If ($manifest.choiceList#Null:C1517)
												
												If ($parameter.type="bool")  // Kep only 2 values
													
													Case of 
															
															//______________________________________________________
														: (Value type:C1509($manifest.choiceList)=Is collection:K8:32)
															
															$manifest.choiceList.resize(2)
															$parameter.choiceList:=$manifest.choiceList
															
															//______________________________________________________
														: (Value type:C1509($manifest.choiceList)=Is object:K8:27)
															
															$parameter.choiceList:=New collection:C1472($manifest.choiceList["0"]; $manifest.choiceList["1"])
															
															//______________________________________________________
														Else 
															
															// IGNORE
															
															//______________________________________________________
													End case 
													
												Else 
													
													If (Value type:C1509($manifest.choiceList)=Is object:K8:27)
														
														// To keep order
														$parameter.choiceList:=OB Entries:C1720($manifest.choiceList)
														
													Else 
														
														$parameter.choiceList:=$manifest.choiceList
														
													End if 
												End if 
											End if 
										End if 
										
									Else 
										
										$manifest:=SHARED.resources.definitions
										
										If ($manifest[$t].choiceList#Null:C1517)
											
											$parameter.choiceList:=$manifest[$t].choiceList
											
										End if 
									End if 
								End if 
								
						End case 
					End for each 
				End if 
			End for each 
		End if 
		
		// MARK:- hasAction
	: ($Txt_action="hasAction")
		
		If ($Obj_in.project.actions#Null:C1517)
			
			$Obj_out.value:=$Obj_in.project.actions.length>0
			
		Else 
			
			$Obj_out.value:=False:C215
			
		End if 
		
		$Obj_out.success:=True:C214
		
		// MARK:- getByName
	: ($Txt_action="getByName")
		
		$Obj_out.inputControls:=New object:C1471
		
		$folder:=cs:C1710.path.new().hostInputControls()
		If ($folder.exists)
			For each ($formatFolder; $folder.folders())
				$manifest:=ob_parseFile($formatFolder.file("manifest.json")).value
				If ($manifest#Null:C1517)
					$manifest.folder:=$formatFolder
					$manifest.isHost:=True:C214
					If (Value type:C1509($manifest.name)=Is text:K8:3)
						$Obj_out.inputControls[$manifest.name]:=$manifest
					End if 
				End if 
			End for each 
		End if 
		
		$Obj_out.success:=True:C214
		
		// MARK:- hostFormatList
	: ($Txt_action="hostFormatList")
		// list all custom format from project
		
		$isObject:=Bool:C1537($Obj_in.read)  // parse manifest or not
		If (Asserted:C1132($isObject; "without is object, folder could not be found"))
			$folder:=cs:C1710.path.new().hostInputControls()
		End if 
		
		$Obj_out.formats:=New collection:C1472
		If ($Obj_in.project.actions#Null:C1517)
			For each ($action; $Obj_in.project.actions)
				If ($action.parameters#Null:C1517)
					For each ($parameter; $action.parameters)
						$format:=Choose:C955($parameter.source=Null:C1517; String:C10($parameter.format); String:C10($parameter.source))
						If (PROJECT.isCustomResource($format))
							If ($isObject)
								$format:=Delete string:C232($format; 1; 1)
								If ($Obj_in.inputControls#Null:C1517)  // ASSERT it.?
									$manifest:=$Obj_in.inputControls[$format]
								Else 
									ASSERT:C1129(dev_assert; "input control map not passed, we could not find some control")
								End if 
								
								If ($manifest=Null:C1517)
									$formatFolder:=$folder.folder($format)
									$manifest:=ob_parseFile($formatFolder.file("manifest.json")).value
									If ($manifest#Null:C1517)
										$manifest.folder:=$formatFolder
									End if 
								End if 
								
								If ($manifest#Null:C1517)
									$Obj_out.formats.push($manifest)
								End if 
								$manifest:=Null:C1517
							Else 
								$Obj_out.formats.push($parameter.format)
							End if 
						End if 
					End for each 
				End if 
			End for each 
			$Obj_out.formats:=$Obj_out.formats.distinct()
		End if 
		
		$Obj_out.success:=True:C214
		
		// MARK:- injectHost
	: ($Txt_action="injectHost")  // for custom Action Formatters
		
		$formats:=$Obj_in.formats  // to implement a cache passed by caller
		If ($formats=Null:C1517)
			$Obj_in:=OB Copy:C1225($Obj_in)
			$Obj_in.read:=True:C214
			$formats:=mobile_actions("hostFormatList"; $Obj_in).formats
		End if 
		
		$folder:=cs:C1710.path.new().hostInputControls()
		
		For each ($format; $formats)
			
			Case of 
				: (Value type:C1509($format)=Is text:K8:3)
					$formatFolder:=$folder.folder(Substring:C12($format; 2))
					$manifest:=ob_parseFile($formatFolder.file("manifest.json")).value
				: (Value type:C1509($format)=Is object:K8:27)
					$formatFolder:=$format.folder
					$manifest:=$format
				Else 
					ASSERT:C1129(dev_Matrix; "Wront type of format")
			End case 
			
			If (Bool:C1537($manifest.inject))
				If ($formatFolder.folder("ios").exists)
					$formatFolder:=$formatFolder.folder("ios")
				End if 
				
/*var $Col_catalog : Collection
$Col_catalog:=doc_catalog(This.template.source; This.getCatalogExcludePattern())*/
				var $copyFilesResult : Object
				$copyFilesResult:=template(New object:C1471(\
					"source"; $formatFolder.platformPath; \
					"target"; $Obj_in.path; \
					"tags"; $Obj_in.tags\
					))
				
				$copyFilesResult:=XcodeProjInject(New object:C1471(\
					"node"; $copyFilesResult; \
					"mapping"; $Obj_in.projfile.mapping; \
					"proj"; $Obj_in.projfile.value; \
					"target"; $Obj_in.path; \
					"uuid"; $Obj_in.template.uuid))
				
			End if 
		End for each 
		
		// MARK:- putTableNames
	: ($Txt_action="putTableNames")
		ASSERT:C1129(Feature.with("actionsInTabBar"); "For this feature")
		
		// Add table names instead of number
		If ($Obj_in.project.actions#Null:C1517)
			
			$dataModel:=$Obj_in.project.dataModel
			
			For each ($action; $Obj_in.project.actions)
				If ($action.tableNumber#Null:C1517)
					If ($dataModel[String:C10($action.tableNumber)]#Null:C1517)
						$action.tableName:=formatString("table-name"; $dataModel[String:C10($action.tableNumber)][""].name)
					Else 
						ob_warning_add($Obj_out; "missing table in datamodel with number "+String:C10($action.tableNumber)+" found in action")
					End if 
				End if 
			End for each 
			
		End if 
		
		$Obj_out.success:=True:C214
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$Txt_action+"\"")
		
		//______________________________________________________
End case 

// ----------------------------------------------------
// Return
$0:=$Obj_out

// ----------------------------------------------------
// End
