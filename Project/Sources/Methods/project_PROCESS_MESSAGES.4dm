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

var $panel; $t : Text
var $bottom; $height; $i; $indx; $left; $right; $top; $width : Integer
var $nilPtr : Pointer
var $ƒ : Object

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
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
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
				
				OBJECT GET COORDINATES:C663(*; panel_Find_by_name($ƒ.tableProperties); $left; $top; $right; $bottom)
				
				$left:=Num:C11($data.left)
				$top:=$top+Num:C11($data.top)
				$right:=$width
				$bottom:=$height
				
				$width:=$width-$left
				
				//……………………………………………………………………………………………
			: (String:C10($data.action)="forms")
				
				$width:=$width-15
				$height:=$height-15
				
				OBJECT GET COORDINATES:C663(*; panel_Find_by_name($ƒ.views); $left; $top; $right; $bottom)
				
				$left:=18
				$top:=$top+165
				$right:=$width
				$bottom:=$height
				
				//……………………………………………………………………………………………
			: (String:C10($data.action)="actionIcons")
				
				$width:=$width-5
				$width:=$width-5
				$height:=$height-5
				
				OBJECT GET COORDINATES:C663(*; panel_Find_by_name($ƒ.tableProperties); $left; $top; $right; $bottom)
				
				$left:=Num:C11($data.left)
				$top:=$top+Num:C11($data.top)
				$right:=$width
				$bottom:=$height
				
				$width:=$width-$left
				
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
		
		//______________________________________________________
	: ($selector="pickerHide")  // Hide the picture grid widget
		
		OBJECT SET VISIBLE:C603(*; "picker@"; False:C215)
		
		If (Form:C1466.$dialog#Null:C1517)
			
			OB REMOVE:C1226(Form:C1466.$dialog; "picker")  // Picker closed
			
		End if 
		
		If (Current form name:C1298=$ƒ.project)
			
			// Pass to target panel
			Case of 
					
					//……………………………………………………………………………………………
				: (String:C10($data.action)="forms")
					
					$panel:=panel_Find_by_name($ƒ.views)
					
					//……………………………………………………………………………………………
				Else 
					
					//ASSERT(False;"Unknown entry point: \""+String($Obj_in.action)+"\"")
					
					//……………………………………………………………………………………………
			End case 
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $ƒ.callback; *; $selector; $data)
				
			End if 
			
		Else 
			
			Case of 
					
					//……………………………………………………………………………………………
				: (String:C10($data.action)="forms")
					
					$data.action:=Choose:C955(Bool:C1537($data.onResize); "show"; $selector)
					VIEWS_Handler($data)
					
					//……………………………………………………………………………………………
			End case 
		End if 
		
		//______________________________________________________
	: ($selector="pickerResume")  // Return the picture grid widget result to the caller
		
		If ($ƒ.currentForm=$ƒ.project)
			
			// Hide the picture grid widget
			OBJECT SET VISIBLE:C603(*; "picker@"; False:C215)
			OB REMOVE:C1226(Form:C1466.$dialog; "picker")
			
			// Pass to target panel
			$selector:=String:C10($data.action)
			
			Case of 
					
					//……………………………………………………………………………………………
				: ($selector="tableIcons")
					
					$panel:=panel_Find_by_name($ƒ.tableProperties)
					
					//……………………………………………………………………………………………
				: ($selector="fieldIcons")
					
					$panel:=panel_Find_by_name($ƒ.fieldProperties)
					
					//……………………………………………………………………………………………
				: ($selector="forms")
					
					$panel:=panel_Find_by_name($ƒ.views)
					
					//……………………………………………………………………………………………
				: ($selector="actionIcons")
					
					$panel:=panel_Find_by_name($ƒ.actions)
					
					//……………………………………………………………………………………………
				Else 
					
					ASSERT:C1129(False:C215; "Unknown entry point: \""+$selector+"\"")
					
					//……………………………………………………………………………………………
			End case 
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $ƒ.callback; *; "pickerResume"; $data)
				
			End if 
			
		Else 
			
			Case of 
					
					//……………………………………………………………………………………………
				: ($ƒ.currentForm=$ƒ.tableProperties)
					
					tables_Handler($data)
					
					//……………………………………………………………………………………………
				: ($ƒ.currentForm=$ƒ.fieldProperties)
					
					FIELDS_CALLBACK($data)
					
					//……………………………………………………………………………………………
				: ($ƒ.currentForm=$ƒ.views)
					
					VIEWS_Handler($data)
					
					//……………………………………………………………………………………………
				: ($ƒ.currentForm=$ƒ.actions)
					
					ACTIONS_CALLBACK("IconPickerResume"; $data)
					
					//……………………………………………………………………………………………
			End case 
		End if 
		
		//______________________________________________________
	: ($selector="projectAudit")  // Verify the project integrity
		
		PROJECT_Handler(New object:C1471("action"; $selector))
		
		//______________________________________________________
	: ($selector="projectFixErrors")  // Fix the project errors
		
		$data.action:=$selector
		PROJECT_Handler($data)
		
		//______________________________________________________
	: ($selector="mainMenu")  // Update Main menu panel
		
		If ($ƒ.currentForm=$ƒ.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($ƒ.mainMenu)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $ƒ.callback; *; $selector)
				
			End if 
			
		Else 
			
			main_Handler(New object:C1471("action"; "update"))
			
			main_Handler(New object:C1471("action"; "order"))
			
		End if 
		
		//______________________________________________________
	: ($selector="tableProperties")  // Update table properties panel
		
		If ($ƒ.currentForm=$ƒ.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($ƒ.tableProperties)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $ƒ.callback; *; $selector)
				
			End if 
			
		Else 
			
			tables_Handler(New object:C1471("action"; "update"))
			
		End if 
		
		//______________________________________________________
	: ($selector="tableIcons")  // Preload the table icons
		
		If ($ƒ.currentForm=$ƒ.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($ƒ.tableProperties)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $ƒ.callback; *; $selector; $data)
				
			End if 
			
		Else 
			
			tables_Handler(New object:C1471("action"; "icons"))
			
		End if 
		
		//______________________________________________________
	: ($selector="fieldProperties")  // Update field properties panel
		
		If ($ƒ.currentForm=$ƒ.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($ƒ.fieldProperties)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $ƒ.callback; *; $selector)
				
			End if 
			
		Else 
			
			FIELDS_CALLBACK(New object:C1471(\
				"action"; "update"))
			
		End if 
		//______________________________________________________
	: ($selector="loadActionIcons")  // Preload the actions icons
		
		If ($ƒ.currentForm=$ƒ.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($ƒ.actions)
			
			If (Length:C16($panel)>0)
				
				EDITOR.callChild($panel; "ACTIONS_CALLBACK"; $selector; $data)
				
			End if 
		End if 
		
		//______________________________________________________
	: ($selector="dataSet")  // Dataset generation result
		
		OB REMOVE:C1226(Form:C1466.$project; "dataSetGeneration")
		
		If ($ƒ.currentForm=$ƒ.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($ƒ.dataSource)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $ƒ.callback; *; $selector)
				
			End if 
			
		Else 
			
			SOURCE_Handler(New object:C1471("action"; "dataset"))
			
		End if 
		
		//______________________________________________________
	: ($selector="update_data")  // Update data panel after a dataset generation
		
		If ($ƒ.currentForm=$ƒ.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($ƒ.data)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $ƒ.callback; *; $selector)
				
			End if 
			
		Else 
			
			DATA_Handler(New object:C1471("action"; "update"))
			
		End if 
		
		//______________________________________________________
	: ($selector="checkingServerConfiguration")  // Verify the web server configuration
		
		If ($ƒ.currentForm=$ƒ.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($ƒ.dataSource)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $ƒ.callback; *; $selector)
				
			End if 
			
		Else 
			
			SOURCE_Handler(New object:C1471("action"; $selector))
			
		End if 
		
		//______________________________________________________
	: ($selector="teamId")
		
		If ($ƒ.currentForm=$ƒ.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($ƒ.developer)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $ƒ.callback; *; $selector; $data)
				
			End if 
			
		Else 
			
			If ($data.success)
				
				DEVELOPER_CALLBACK(New object:C1471("action"; $selector; "value"; $data.value))
				
			End if 
		End if 
		
		//______________________________________________________
	: ($selector="tableList")\
		 | ($selector="fieldList")
		
		If ($ƒ.currentForm=$ƒ.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($ƒ.structure)
			
			If (Length:C16($panel)>0)
				
				If (FEATURE.with("wizards"))
					
					EDITOR.callChild($panel; EDITOR.callback; $selector)
					
				Else 
					
					EXECUTE METHOD IN SUBFORM:C1085($panel; $ƒ.callback; *; $selector; $data)
					
				End if 
			End if 
			
		Else 
			
			If (FEATURE.with("wizards"))
				
				STRUCTURE_Handler(New object:C1471("action"; $selector; "value"; PROJECT))
				
			Else 
				
				STRUCTURE_Handler(New object:C1471("action"; $selector; "value"; $data))
				
			End if 
		End if 
		
		//______________________________________________________
	: ($selector="onLosingFocus")
		
		OBJECT GET SUBFORM:C1139(*; $data.panel; $nilPtr; $panel)
		
		Case of 
				
				//…………………………………………………………………………………………………………
			: ($panel=$ƒ.structure)
				
				EXECUTE METHOD IN SUBFORM:C1085($data.panel; "structure_Handler"; *; New object:C1471("action"; $selector))
				
				//…………………………………………………………………………………………………………
		End case 
		
		//______________________________________________________
	: ($selector="resizePanel")
		
		$panel:=panel_Find_by_name($data.panel; ->$indx)
		
		If (Length:C16($panel)>0)
			
			// Resize the current panel
			OBJECT MOVE:C664(*; $panel; 0; 0; 0; $data.offset)
			EXECUTE METHOD IN SUBFORM:C1085($panel; "structure_Handler"; *; New object:C1471("action"; "geometry"; "target"; $data.panel))
			
			// Move all the following panels
			For ($i; $indx+1; panel_Count; 1)
				
				OBJECT MOVE:C664(*; "title.label."+String:C10($i); 0; $data.offset)
				OBJECT MOVE:C664(*; "panel."+String:C10($i); 0; $data.offset)
				
			End for 
		End if 
		
		//______________________________________________________
	: ($selector="goTo")
		
		If ($ƒ.currentForm=$ƒ.project)
			
			If (Asserted:C1132($data.panel#Null:C1517))
				
				// Pass to target panel
				$panel:=panel_Find_by_name($data.panel; ->$indx)
				
				If (Length:C16($panel)>0)
					
					// Open the panel, if any
					panel_OPEN($indx)
					
					EXECUTE METHOD IN SUBFORM:C1085($panel; $ƒ.callback; *; $selector; $data)
					
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
							CALL FORM:C1391($ƒ.window; $ƒ.callback; "fieldProperties")
							
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
		
		//______________________________________________________
	: ($selector="selectTab")
		
		If ($ƒ.currentForm=$ƒ.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($ƒ.views; ->$indx)
			
			If (Length:C16($panel)>0)
				
				// Open the panel, if any
				panel_OPEN($indx)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $ƒ.callback; *; $selector; $data)
				
			End if 
			
		Else 
			
			$data.action:=$selector
			VIEWS_Handler($data)
			
		End if 
		
		//______________________________________________________
	: ($selector="setForm")  // Set form from browser
		
		If ($ƒ.currentForm=$ƒ.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($ƒ.views)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $ƒ.callback; *; $selector; $data)
				
			End if 
			
		Else 
			
			VIEWS_Handler($data)
			
		End if 
		
		//______________________________________________________
	: ($selector="refresh")  // Refresh displayed panels
		
		For each ($t; panels)
			
			EXECUTE METHOD IN SUBFORM:C1085($t; "panel_REFRESH")
			
		End for each 
		
		//______________________________________________________
	: ($selector="refreshViews")  // Update VIEWS panel
		
		If ($ƒ.currentForm=$ƒ.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($ƒ.views)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $ƒ.callback; *; $selector; $data)
				
			End if 
			
		Else 
			
			If ($data=Null:C1517)
				
				$data:=New object:C1471("action"; $selector)
				
			Else 
				
				$data.action:=$selector
				
			End if 
			
			VIEWS_Handler($data)
			
		End if 
		
		//______________________________________________________
	: ($selector="refreshParameters")  // Update ACTIONS PARAMETERS panel
		
		If ($ƒ.currentForm=$ƒ.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($ƒ.actionParameters)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; "panel_REFRESH")
				
			End if 
		End if 
		
		//______________________________________________________
	: ($selector="refreshServer")  // Update SERVER panel
		
		If ($ƒ.currentForm=$ƒ.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($ƒ.server)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $ƒ.callback; *; $selector; $data)
				
			End if 
			
		Else 
			
			_o_SERVER_Handler(New object:C1471("action"; "authenticationMethod"))
			
		End if 
		
		//______________________________________________________
	: ($selector="testServer")  // Server checking response
		
		If ($ƒ.currentForm=$ƒ.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($ƒ.dataSource)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $ƒ.callback; *; $selector; $data)
				
			End if 
			
		Else 
			
			SOURCE_Handler(New object:C1471("action"; $selector; "response"; $data))
			
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$selector+"\"")
		
		//______________________________________________________
End case 