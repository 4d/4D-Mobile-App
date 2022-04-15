//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : project_PROCESS_MESSAGES
// ID[289212F4F0EE41A1BA699256DA276FD1]
// Created 10-1-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Management of messages addressed to PROJECT form or its subforms
// ----------------------------------------------------
// Declarations
#DECLARE($selector : Text; $data : Object)

If (False:C215)
	C_TEXT:C284(project_PROCESS_MESSAGES; $1)
	C_OBJECT:C1216(project_PROCESS_MESSAGES; $2)
End if 

var $container; $currentForm; $t : Text
var $isProjectForm : Boolean
var $bottom; $height; $i; $indx; $left; $right : Integer
var $top; $width : Integer
var $nilPtr : Pointer
var $ƒ; $panel : Object

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	$ƒ:=New object:C1471(\
		"window"; Current form window:C827; \
		"callback"; Current method name:C684; \
		"currentForm"; Current form name:C1298; \
		"editor"; "PROJECT_EDITOR"; \
		"project"; "PROJECT"; \
		"developer"; "DEVELOPER"; \
		"structure"; "STRUCTURE"; \
		"tableProperties"; "TABLES"; \
		"fieldProperties"; "FIELDS"; \
		"mainMenu"; "MAIN"; \
		"views"; "VIEWS"; \
		"server"; "SERVER"; \
		"data"; "DATA"; \
		"dataSource"; "SOURCE"; \
		"actions"; "ACTIONS"; \
		"actionParameters"; "ACTIONS_PARAMS"; \
		"ribbon"; "RIBBON"; \
		"footer"; "FOOTER")
	
	$currentForm:=Current form name:C1298
	$isProjectForm:=($currentForm="PROJECT")
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//mark:-pickerShow
		//______________________________________________________
	: ($selector="pickerShow")  // Display the picture grid widget
		
		// Get the viewport
		OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
		
		// Places the background invisible button
		OBJECT SET COORDINATES:C1248(*; "picker.close"; 0; Num:C11($data.vOffset); $width; $height)
		
		Case of 
				
				//……………………………………………………………………………………………
			: (String:C10($data.action)="tableIcons")\
				 | (String:C10($data.action)="fieldIcons")
				
				$width:=$width-5
				$height:=$height-5
				
				OBJECT GET COORDINATES:C663(*; panel_Find($ƒ.tableProperties); $left; $top; $right; $bottom)
				
				$left:=Num:C11($data.left)
				$top:=$top+Num:C11($data.top)
				$right:=$width
				$bottom:=$height
				
				$width:=$width-$left
				
				//……………………………………………………………………………………………
			: (String:C10($data.action)="forms")
				
				$width:=$width-15
				$height:=$height-15
				
				OBJECT GET COORDINATES:C663(*; panel_Find($ƒ.views); $left; $top; $right; $bottom)
				
				$left:=18
				$top:=$top+165
				$right:=$width
				$bottom:=$height
				
				//……………………………………………………………………………………………
			: (String:C10($data.action)="actionIcons")
				
				OBJECT GET COORDINATES:C663(*; panel_Find($ƒ.tableProperties); $left; $top; $right; $bottom)
				
				$width:=$width-5
				
				$left:=Num:C11($data.left)
				$top:=$top+Num:C11($data.top)
				$right:=Num:C11($data.right)
				$bottom:=$height-5
				
				//……………………………………………………………………………………………
			Else 
				
				ASSERT:C1129(False:C215; "Unknown entry point: \""+String:C10($data.action)+"\"")
				
				//……………………………………………………………………………………………
		End case 
		
		$data.maxColumns:=($width-19)\$data.celluleWidth
		
		OBJECT SET COORDINATES:C1248(*; "picker"; $left; $top; $right; $bottom)
		OBJECT SET VISIBLE:C603(*; "picker@"; True:C214)
		
		// Touch picker subform
		OBJECT SET VALUE:C1742("picker"; $data)
		Form:C1466.$dialog.picker:=True:C214  // Picker opened
		
		//mark:pickerHide
		//______________________________________________________
	: ($selector="pickerHide")  // Hide the picture grid widget
		
		OBJECT SET VISIBLE:C603(*; "picker@"; False:C215)
		
		If (Form:C1466.$dialog#Null:C1517)
			
			OB REMOVE:C1226(Form:C1466.$dialog; "picker")  // Picker closed
			
		End if 
		
		If ($isProjectForm)
			
			Case of 
					
					//……………………………………………………………………………………………
				: (Count parameters:C259=1)
					
					// <NOTHING MORE TO DO>
					
					//……………………………………………………………………………………………
				: (String:C10($data.action)="forms")
					
					EDITOR.sendMessageToPanel($ƒ.views; $selector; $data)
					
					//……………………………………………………………………………………………
				Else 
					
					//ASSERT(False;"Unknown entry point: \""+String($Obj_in.action)+"\"")
					
					//……………………………………………………………………………………………
			End case 
			
		Else 
			
			Case of 
					
					//……………………………………………………………………………………………
				: (String:C10($data.action)="forms")
					
					$data.action:=Choose:C955(Bool:C1537($data.onResize); "show"; $selector)
					VIEWS_Handler($data)
					
					//……………………………………………………………………………………………
			End case 
		End if 
		
		//mark:pickerResume
		//______________________________________________________
	: ($selector="pickerResume")  // Return the picture grid widget result to the caller
		
		If ($isProjectForm)
			
			// Hide the picture grid widget
			OBJECT SET VISIBLE:C603(*; "picker@"; False:C215)
			OB REMOVE:C1226(Form:C1466.$dialog; "picker")
			
			$selector:=String:C10($data.action)
			
			Case of 
					
					//……………………………………………………………………………………………
				: ($selector="tableIcons")
					
					EDITOR.sendMessageToPanel($ƒ.tableProperties; "pickerResume"; $data)
					
					//……………………………………………………………………………………………
				: ($selector="fieldIcons")
					
					EDITOR.sendMessageToPanel($ƒ.fieldProperties; "pickerResume"; $data)
					
					//……………………………………………………………………………………………
				: ($selector="forms")
					
					EDITOR.sendMessageToPanel($ƒ.views; "pickerResume"; $data)
					
					//……………………………………………………………………………………………
				: ($selector="actionIcons")
					
					EDITOR.sendMessageToPanel($ƒ.actions; "pickerResume"; $data)
					
					//……………………………………………………………………………………………
				Else 
					
					ASSERT:C1129(False:C215; "Unknown entry point: \""+$selector+"\"")
					
					//……………………………………………………………………………………………
			End case 
			
		Else 
			
			Case of 
					
					//……………………………………………………………………………………………
				: ($currentForm=$ƒ.tableProperties)
					
					tables_Handler($data)
					
					//……………………………………………………………………………………………
				: ($currentForm=$ƒ.fieldProperties)
					
					FIELDS_CALLBACK($data)
					
					//……………………………………………………………………………………………
				: ($currentForm=$ƒ.views)
					
					VIEWS_Handler($data)
					
					//……………………………………………………………………………………………
				: ($currentForm=$ƒ.actions)
					
					panel($ƒ.actions).setIcon($data)
					
					//……………………………………………………………………………………………
			End case 
		End if 
		
		//mark:-update_data
		//______________________________________________________
	: ($selector="update_data")
		
		If ($isProjectForm)
			
			EDITOR.sendMessageToPanel($ƒ.data; $selector)
			
		Else 
			
			Logger.info("Message update_data -> DATA")
			panel.update()
			
		End if 
		
		//mark:getSQLiteResponse
		//______________________________________________________
	: ($selector="getSQLiteResponse")
		
		If ($isProjectForm)
			
			EDITOR.sendMessageToPanel($ƒ.data; $selector; $data)
			
		Else 
			
			$panel:=panel
			
			Case of 
					
					//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
				: (String:C10($data.target)="ios")
					
					Logger.info("Message getSQLiteResponse(iOS) -> DATA")
					$panel.sqlite:=$data.database
					
					//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
				: (String:C10($data.target)="android")
					
					Logger.info("Message getSQLiteResponse(Android) -> DATA")
					$panel.datasetAndroid:=$data.database
					
					//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
				Else 
					
					Logger.error("Message -> DATA getSQLiteResponse = Missing target")
					ASSERT:C1129(dev_Matrix; "Missing target")
					
					//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			End case 
			
			$panel.updateTableListWithDataSizes()
			
		End if 
		
		//mark:endOfDatasetGeneration
		//______________________________________________________
	: ($selector="endOfDatasetGeneration")
		
		If ($isProjectForm)
			
			EDITOR.sendMessageToPanel($ƒ.dataSource; $selector; $data)
			
		Else 
			
			Logger.info("🏁 END DATA GENERATION")
			panel.endOfDatasetGeneration($data)
			
		End if 
		
		//mark:updateSourcePanel
		//______________________________________________________
	: ($selector="updateSourcePanel")
		
		If ($isProjectForm)
			
			EDITOR.sendMessageToPanel($ƒ.dataSource; $selector)
			
		Else 
			
			Logger.info("Message updateSourcePanel -> SOURCE")
			panel.update()
			
		End if 
		
		//mark:checkingServerConfiguration
		//______________________________________________________
	: ($selector="checkingServerConfiguration")
		
		If ($isProjectForm)
			
			EDITOR.sendMessageToPanel($ƒ.dataSource; $selector)
			
		Else 
			
			Logger.info("Message checkingServerConfiguration -> SOURCE")
			panel.checkingDatasourceConfiguration()
			
		End if 
		
		//mark:checkingServerResponse
		//______________________________________________________
	: ($selector="checkingServerResponse")
		
		If ($isProjectForm)
			
			EDITOR.sendMessageToPanel($ƒ.dataSource; $selector; $data)
			
		Else 
			
			Logger.info("Message checkingServerResponse -> SOURCE")
			panel.checkingServerResponse($data)
			
		End if 
		
		//mark:-projectAudit
		//______________________________________________________
	: ($selector="projectAudit")  // Verify the project integrity
		
		PROJECT_Handler(New object:C1471("action"; $selector))
		
		//mark:projectFixErrors
		//______________________________________________________
	: ($selector="projectFixErrors")  // Fix the project errors
		
		$data.action:=$selector
		PROJECT_Handler($data)
		
		//mark:-mainMenu
		//______________________________________________________
	: ($selector="mainMenu")  // Update Main menu panel
		
		ASSERT:C1129(DATABASE.isMatrix)
		
		If ($isProjectForm)
			
			EDITOR.sendMessageToPanel($ƒ.mainMenu; $selector)
			
		Else 
			
			//main_Handler(New object("action"; "update"))
			//main_Handler(New object("action"; "order"))
			panel._updateOrder()
			
		End if 
		
		//mark:-Update table properties panel
		//______________________________________________________
	: ($selector="tableProperties")  // Update table properties panel
		
		If ($isProjectForm)
			
			EDITOR.sendMessageToPanel($ƒ.tableProperties; $selector)
			
		Else 
			
			tables_Handler(New object:C1471("action"; "update"))
			
		End if 
		
		//mark:Preload the table icons
		//______________________________________________________
	: ($selector="tableIcons")
		
		If ($isProjectForm)
			
			EDITOR.sendMessageToPanel($ƒ.tableProperties; $selector)
			
		Else 
			
			tables_Handler(New object:C1471("action"; "icons"))
			
		End if 
		
		//mark:-Update field properties panel
		//______________________________________________________
	: ($selector="fieldProperties")
		
		If ($isProjectForm)
			
			EDITOR.sendMessageToPanel($ƒ.fieldProperties; $selector)
			
		Else 
			
			FIELDS_CALLBACK(New object:C1471(\
				"action"; "update"))
			
		End if 
		
		//mark:-loadActionIcons
		//______________________________________________________
	: ($selector="loadActionIcons")  // Preload the actions icons
		
		If ($isProjectForm)
			
			$container:=panel_Find($ƒ.actions)
			
			If (Length:C16($container)>0)
				
				EDITOR.callChild($container; Formula:C1597(ACTIONS_CALLBACK).source; $selector)
				
			End if 
		End if 
		
		//mark:-teamId
		//______________________________________________________
	: ($selector="teamId")
		
		If ($isProjectForm)
			
			EDITOR.sendMessageToPanel($ƒ.developer; $selector; $data)
			
		Else 
			
			If ($data.success)
				
				panel.updateTeamID(New object:C1471("action"; $selector; "value"; $data.value))
				
			End if 
		End if 
		
		//MARK:-STRUCTURE
		//______________________________________________________
	: ($selector="tableList")\
		 | ($selector="fieldList")
		
		If ($isProjectForm)
			
			EDITOR.sendMessageToPanel($ƒ.structure; $selector)
			
		Else 
			
			STRUCTURE_Handler(New object:C1471(\
				"action"; $selector; \
				"value"; PROJECT))
			
		End if 
		//______________________________________________________
	: ($selector="onLosingFocus")
		
		OBJECT GET SUBFORM:C1139(*; $data.panel; $nilPtr; $container)
		
		Case of 
				
				//…………………………………………………………………………………………………………
			: ($container=$ƒ.structure)
				
				EDITOR.callChild($container; "structure_Handler"; New object:C1471("action"; $selector))
				
				//…………………………………………………………………………………………………………
		End case 
		
		//______________________________________________________
	: ($selector="resizePanel")
		
		$container:=panel_Find($data.panel; ->$indx)
		
		If (Length:C16($container)>0)
			
			// Resize the current panel
			OBJECT MOVE:C664(*; $container; 0; 0; 0; $data.offset)
			EDITOR.callChild($container; "structure_Handler"; New object:C1471("action"; "geometry"; "target"; $data.panel))
			
			// Move all the following panels
			For ($i; $indx+1; panel_Count; 1)
				
				OBJECT MOVE:C664(*; "title.label."+String:C10($i); 0; $data.offset)
				OBJECT MOVE:C664(*; "panel."+String:C10($i); 0; $data.offset)
				
			End for 
		End if 
		
		//______________________________________________________
	: ($selector="goTo")
		
		If ($isProjectForm)
			
			If (Asserted:C1132($data.panel#Null:C1517))
				
				$container:=panel_Find($data.panel; ->$indx)
				
				If (Length:C16($container)>0)
					
					EDITOR.callChild($container; Current method name:C684; $selector; $data)
					
				End if 
			End if 
			
		Else 
			
			Case of 
					
					//……………………………………………………………………………………………………
				: ($data.object#Null:C1517)  // Go to object
					
					GOTO OBJECT:C206(*; $data.object)
					
					//……………………………………………………………………………………………………
				: ($data.table#Null:C1517)  // Select table
					
					Case of 
							
							//___________________________
						: ($data.panel="TABLES")
							
							// Set the selected table
							tables_Handler(New object:C1471("action"; "select"; "tableNumber"; Num:C11($data.table)))
							
							If ($data.field#Null:C1517)  // Select field
								
								// Set the selected field
								FIELDS_CALLBACK(New object:C1471(\
									"action"; "select"; \
									"fieldNumber"; Num:C11($data.field)))
								
							End if 
							
							// Update field properties panel
							CALL FORM:C1391($ƒ.window; Current method name:C684; "fieldProperties")
							
							//___________________________
						: ($data.panel="DATA")
							
							//
							
							//___________________________
						Else 
							
							//
							
							//___________________________
					End case 
					
					//……………………………………………………………………………………………………
				Else 
					
					//
					
					//……………………………………………………………………………………………………
			End case 
		End if 
		
		//MARK:-VIEWS
		//______________________________________________________
	: ($selector="selectTab")
		
		If ($isProjectForm)
			
			$container:=panel_Find($ƒ.views; ->$indx)
			
			If (Length:C16($container)>0)
				
				EDITOR.callChild($container; Current method name:C684; $selector; $data)
				
			End if 
			
		Else 
			
			$data.action:=$selector
			VIEWS_Handler($data)
			
		End if 
		
		//______________________________________________________
	: ($selector="setForm")  // Set form from browser
		
		If ($isProjectForm)
			
			EDITOR.sendMessageToPanel($ƒ.views; $selector; $data)
			
		Else 
			
			VIEWS_Handler($data)
			
		End if 
		
		//______________________________________________________
	: ($selector="refreshViews")  // Update VIEWS panel
		
		If ($isProjectForm)
			
			EDITOR.sendMessageToPanel($ƒ.views; $selector; $data)
			
		Else 
			
			If ($data=Null:C1517)
				
				$data:=New object:C1471("action"; $selector)
				
			Else 
				
				$data.action:=$selector
				
			End if 
			
			VIEWS_Handler($data)
			
		End if 
		
		//______________________________________________________
	: ($selector="refresh")  // Refresh displayed panels
		
		For each ($t; panels)
			
			EDITOR.callChild($t; "panel_REFRESH")
			
		End for each 
		
		//______________________________________________________
	: ($selector="refreshParameters")  // Update ACTIONS PARAMETERS panel
		
		If ($isProjectForm)
			
			$container:=panel_Find($ƒ.actionParameters)
			
			If (Length:C16($container)>0)
				
				EDITOR.callChild($container; "panel_REFRESH")
				
			End if 
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$selector+"\"")
		
		//______________________________________________________
End case 