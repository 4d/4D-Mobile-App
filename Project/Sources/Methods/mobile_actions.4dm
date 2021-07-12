//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : actions
// ID[66E9AA75F234494E96C5C0514F05D6C4]
// Created 7-3-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($t; $Txt_action)
C_OBJECT:C1216($o; $Obj_action; $Obj_parameters; $Obj_in; $Obj_out)
C_BOOLEAN:C305($Boo_hasImage)

If (False:C215)
	C_OBJECT:C1216(mobile_actions; $0)
	C_TEXT:C284(mobile_actions; $1)
	C_OBJECT:C1216(mobile_actions; $2)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	// Required parameters
	$Txt_action:=$1
	
	// Optional parameters
	If ($Lon_parameters>=2)
		
		$Obj_in:=$2
		
	End if 
	
	$Obj_out:=New object:C1471(\
		"success"; False:C215)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Txt_action="capabilities")
		
		$Obj_out.capabilities:=New object:C1471(\
			"photo"; False:C215)
		
		If (Value type:C1509($Obj_in.project.actions)=Is collection:K8:32)
			
			For each ($Obj_action; $Obj_in.project.actions) Until ($Boo_hasImage)
				
				If (Value type:C1509($Obj_action.parameters)=Is collection:K8:32)
					
					For each ($Obj_parameters; $Obj_action.parameters) Until ($Boo_hasImage)
						
						If (String:C10($Obj_parameters.type)="image")
							
							$Boo_hasImage:=True:C214
							
						End if 
						
						If (String:C10($Obj_parameters.format)="barcode")
							
							$Boo_hasImage:=True:C214  // Maybe separate and want only camera and not photo...
							
						End if 
					End for each 
				End if 
			End for each 
		End if 
		
		If ($Boo_hasImage)
			
			$Obj_out.capabilities.photo:=True:C214
			$Obj_out.capabilities.camera:=True:C214
			
		End if 
		
		$Obj_out.success:=True:C214
		
		//______________________________________________________
	: ($Txt_action="form")
		
		$Obj_out.success:=True:C214
		
		$Obj_out.actions:=mobile_actions("filter"; $Obj_in).actions
		
		For each ($Obj_action; $Obj_out.actions)
			
			For each ($t; $Obj_action)
				
				If ($t[[1]]="$")
					
					OB REMOVE:C1226($Obj_action; $t)
					
				End if 
			End for each 
			
			If (Length:C16(String:C10($Obj_action.icon))>0)
				
				$Obj_action.icon:="action_"+$Obj_action.name
				
			End if 
			
			If ($Obj_action.label=Null:C1517)
				
				$Obj_action.label:=$Obj_action.name
				
			End if 
		End for each 
		
		//______________________________________________________
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
		
		//______________________________________________________
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
					
					For each ($Obj_action; $Obj_in.actions)
						
						$o:=mobile_actions("iconPath"; New object:C1471(\
							"action"; $Obj_action))
						
						Case of 
								
								//……………………………………………………
							: (Bool:C1537($o.exists))
								
								$Obj_out.results[$Obj_action.name]:=asset(New object:C1471(\
									"action"; "create"; \
									"type"; "imageset"; \
									"source"; $o.platformPath; \
									"tags"; New object:C1471("name"; "action_"+$Obj_action.name); \
									"target"; $Obj_out.path; \
									"size"; 32))
								
								ob_error_combine($Obj_out; $Obj_out.results[$Obj_action.name])
								
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
		
		//______________________________________________________
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
				
				$Obj_out:=COMPONENT_Pathname("host_actionIcons").file(Delete string:C232($Obj_in.action.icon; 1; 1))
				
				//……………………………………………………………………………………………………………
			Else 
				
				$Obj_out:=COMPONENT_Pathname("actionIcons").file($Obj_in.action.icon)
				
				//……………………………………………………………………………………………………………
		End case 
		
		//______________________________________________________
	: ($Txt_action="addChoiceList")  // RECURSIVE CALL
		
		// Add choice lists if any to action parameters
		If ($Obj_in.project.actions#Null:C1517)
			
			C_OBJECT:C1216($Obj_dataModel; $Path_manifest; $Obj_manifest)
			C_TEXT:C284($t)
			
			$Obj_dataModel:=$Obj_in.project.dataModel
			
			For each ($Obj_action; $Obj_in.project.actions)
				
				If ($Obj_action.parameters#Null:C1517)
					
					For each ($Obj_parameters; $Obj_action.parameters)
						
						Case of 
								
								//%W-533.1
							: (_and(Formula:C1597(FEATURE.with("customActionFormatter")); \
								Formula:C1597(Length:C16(String:C10($Obj_parameters.format))>0); \
								Formula:C1597(String:C10($Obj_parameters.format[[1]])="/")))
								//%W+533.1
								
								$Path_manifest:=cs:C1710.path.new().hostActionParameterFormatters().folder(Substring:C12($Obj_parameters.format; 2)).file("manifest.json")
								If ($Path_manifest.exists)
									$Obj_manifest:=JSON Parse:C1218($Path_manifest.getText())
									
									If ($Obj_manifest.choiceList#Null:C1517)
										
										$Obj_parameters.choiceList:=$Obj_manifest.choiceList
										
										If (Value type:C1509($Obj_parameters.choiceList)=Is object:K8:27)
											If ($Obj_parameters["dataSource"]=Null:C1517)  // ie. normal source
												$Obj_parameters.choiceList:=OB Entries:C1720($Obj_parameters.choiceList)  // to try to keep order
											End if 
										End if 
										
										If ($Obj_manifest.format#Null:C1517)
											$Obj_parameters.format:=$Obj_manifest.format  // could take from manifest another way to display choice list
										End if 
										If ($Obj_manifest.binding#Null:C1517)
											$Obj_parameters.binding:=$Obj_manifest.binding  // imageNamed for instance
										End if 
										
										If (String:C10($Obj_manifest.binding)="imageNamed")
											If ((String:C10($Obj_manifest.format)="sheet") | (String:C10($Obj_manifest.format)="picker"))
												ob_warning_add($Obj_out; "Image format not compatible with sheet or picker")
											End if 
											
											// generate images
											var $destination : 4D:C1709.Folder
											$destination:=Folder:C1567($Obj_in.path; fk platform path:K87:2).folder("Resources/Assets.xcassets/ActionParametersFormatters")
											$Obj_manifest.isHost:=True:C214
											$Obj_manifest.path:=cs:C1710.path.new().hostActionParameterFormatters().folder(Substring:C12($Obj_parameters.format; 2)).platformPath
											If (Not:C34($destination.folder(Substring:C12($Obj_parameters.format; 2)).exists))
												
												var $oResult : Object
												$oResult:=asset(New object:C1471(\
													"action"; "formatter"; \
													"formatter"; $Obj_manifest; \
													"target"; $destination.platformPath))
												
												ob_error_combine($Obj_out; $oResult)
												
											End if 
										End if 
									End if 
								End if 
								
							: ($Obj_parameters.fieldNumber#Null:C1517)  // Linked to a field
								
								$t:=String:C10($Obj_dataModel[String:C10($Obj_action.tableNumber)][String:C10($Obj_parameters.fieldNumber)].format)
								
								If (Length:C16($t)>0)
									
									If ($t[[1]]="/")
										
										// User
										$Path_manifest:=COMPONENT_Pathname("host_formatters").file(Substring:C12($t; 2)+"/manifest.json")
										
										If ($Path_manifest.exists)
											
											$Obj_manifest:=JSON Parse:C1218($Path_manifest.getText())
											
											If ($Obj_manifest.choiceList#Null:C1517)
												
												If ($Obj_parameters.type="bool")  // Kep only 2 values
													
													Case of 
															
															//______________________________________________________
														: (Value type:C1509($Obj_manifest.choiceList)=Is collection:K8:32)
															
															$Obj_manifest.choiceList.resize(2)
															$Obj_parameters.choiceList:=$Obj_manifest.choiceList
															
															//______________________________________________________
														: (Value type:C1509($Obj_manifest.choiceList)=Is object:K8:27)
															
															$Obj_parameters.choiceList:=New collection:C1472($Obj_manifest.choiceList["0"]; $Obj_manifest.choiceList["1"])
															
															//______________________________________________________
														Else 
															
															// IGNORE
															
															//______________________________________________________
													End case 
													
												Else 
													
													If (Value type:C1509($Obj_manifest.choiceList)=Is object:K8:27)
														
														// To keep order
														$Obj_parameters.choiceList:=OB Entries:C1720($Obj_manifest.choiceList)
														
													Else 
														
														$Obj_parameters.choiceList:=$Obj_manifest.choiceList
														
													End if 
												End if 
											End if 
										End if 
										
									Else 
										
										$Obj_manifest:=SHARED.resources.definitions
										
										If ($Obj_manifest[$t].choiceList#Null:C1517)
											
											$Obj_parameters.choiceList:=$Obj_manifest[$t].choiceList
											
										End if 
									End if 
								End if 
								
						End case 
					End for each 
				End if 
			End for each 
		End if 
		
		//______________________________________________________
	: ($Txt_action="hasAction")
		
		If ($Obj_in.project.actions#Null:C1517)
			
			$Obj_out.value:=$Obj_in.project.actions.length>0
			
		Else 
			
			$Obj_out.value:=False:C215
			
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
