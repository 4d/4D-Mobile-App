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
var $1 : Text
var $2 : Object
var $3 : Object

var $panel; $selector; $t : Text
var $bottom; $height; $i; $indx; $left; $right; $top; $width : Integer
var $Ptr_ : Pointer
var $form; $params : Object

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=3; "Missing parameter"))
	
	// Required parameters
	$selector:=$1
	$form:=$2
	$params:=$3
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
		OBJECT SET COORDINATES:C1248(*; "picker.close"; 0; Num:C11($params.vOffset); $width; $height)
		
		Case of 
				
				//……………………………………………………………………………………………
			: (String:C10($params.action)="tableIcons")\
				 | (String:C10($params.action)="fieldIcons")
				
				$width:=$width-5
				$height:=$height-5
				
				OBJECT GET COORDINATES:C663(*; panel_Find_by_name($form.tableProperties); $left; $top; $right; $bottom)
				
				$left:=Num:C11($params.left)
				$top:=$top+Num:C11($params.top)
				$right:=$width
				$bottom:=$height
				
				$width:=$width-$left
				
				//……………………………………………………………………………………………
			: (String:C10($params.action)="forms")
				
				$width:=$width-15
				$height:=$height-15
				
				OBJECT GET COORDINATES:C663(*; panel_Find_by_name($form.views); $left; $top; $right; $bottom)
				
				$left:=18
				$top:=$top+165
				$right:=$width
				$bottom:=$height
				
				//……………………………………………………………………………………………
			: (String:C10($params.action)="actionIcons")
				
				$width:=$width-5
				$width:=$width-5
				$height:=$height-5
				
				OBJECT GET COORDINATES:C663(*; panel_Find_by_name($form.tableProperties); $left; $top; $right; $bottom)
				
				$left:=Num:C11($params.left)
				$top:=$top+Num:C11($params.top)
				$right:=$width
				$bottom:=$height
				
				$width:=$width-$left
				
				//……………………………………………………………………………………………
			Else 
				
				ASSERT:C1129(False:C215; "Unknown entry point: \""+String:C10($params.action)+"\"")
				
				//……………………………………………………………………………………………
		End case 
		
		$params.maxColumns:=($width-19)\$params.celluleWidth
		
		OBJECT SET COORDINATES:C1248(*; "picker"; $left; $top; $right; $bottom)
		OBJECT SET VISIBLE:C603(*; "picker@"; True:C214)
		
		// Touch picker subform
		(OBJECT Get pointer:C1124(Object named:K67:5; "picker"))->:=$params
		
		Form:C1466.$dialog.picker:=True:C214
		
		//______________________________________________________
	: ($selector="pickerHide")  // Hide the picture grid widget
		
		OBJECT SET VISIBLE:C603(*; "picker@"; False:C215)
		
		If (Form:C1466.$dialog#Null:C1517)
			
			OB REMOVE:C1226(Form:C1466.$dialog; "picker")
			
		End if 
		
		If ($form.currentForm=$form.project)
			
			// Pass to target panel
			Case of 
					
					//……………………………………………………………………………………………
				: (String:C10($params.action)="forms")
					
					$panel:=panel_Find_by_name($form.views)
					
					//……………………………………………………………………………………………
				Else 
					
					//ASSERT(False;"Unknown entry point: \""+String($Obj_in.action)+"\"")
					
					//……………………………………………………………………………………………
			End case 
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $form.callback; *; $selector; $params)
				
			End if 
			
		Else 
			
			Case of 
					
					//……………………………………………………………………………………………
				: (String:C10($params.action)="forms")
					
					$params.action:=Choose:C955(Bool:C1537($params.onResize); "show"; $selector)
					VIEWS_Handler($params)
					
					//……………………………………………………………………………………………
			End case 
		End if 
		
		//______________________________________________________
	: ($selector="pickerResume")  // Return the picture grid widget result to the caller
		
		If ($form.currentForm=$form.project)
			
			// Hide the picture grid widget
			OBJECT SET VISIBLE:C603(*; "picker@"; False:C215)
			OB REMOVE:C1226(Form:C1466.$dialog; "picker")
			
			// Pass to target panel
			$selector:=String:C10($params.action)
			
			Case of 
					
					//……………………………………………………………………………………………
				: ($selector="tableIcons")
					
					$panel:=panel_Find_by_name($form.tableProperties)
					
					//……………………………………………………………………………………………
				: ($selector="fieldIcons")
					
					$panel:=panel_Find_by_name($form.fieldProperties)
					
					//……………………………………………………………………………………………
				: ($selector="forms")
					
					$panel:=panel_Find_by_name($form.views)
					
					//……………………………………………………………………………………………
				: ($selector="actionIcons")
					
					$panel:=panel_Find_by_name($form.actions)
					
					//……………………………………………………………………………………………
				Else 
					
					ASSERT:C1129(False:C215; "Unknown entry point: \""+$selector+"\"")
					
					//……………………………………………………………………………………………
			End case 
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $form.callback; *; "pickerResume"; $params)
				
			End if 
			
		Else 
			
			Case of 
					
					//……………………………………………………………………………………………
				: ($form.currentForm=$form.tableProperties)
					
					tables_Handler($params)
					
					//……………………………………………………………………………………………
				: ($form.currentForm=$form.fieldProperties)
					
					FIELDS_CALLBACK($params)
					
					//……………………………………………………………………………………………
				: ($form.currentForm=$form.views)
					
					VIEWS_Handler($params)
					
					//……………………………………………………………………………………………
				: ($form.currentForm=$form.actions)
					
					ACTIONS_CALLBACK("IconPickerResume"; $params)
					
					//……………………………………………………………………………………………
			End case 
		End if 
		
		//______________________________________________________
	: ($selector="projectAudit")  // Verify the project integrity
		
		PROJECT_Handler(New object:C1471("action"; $selector))
		
		//______________________________________________________
	: ($selector="projectFixErrors")  // Fix the project errors
		
		$params.action:=$selector
		PROJECT_Handler($params)
		
		//______________________________________________________
	: ($selector="mainMenu")  // Update Main menu panel
		
		If ($form.currentForm=$form.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($form.mainMenu)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $form.callback; *; $selector)
				
			End if 
			
		Else 
			
			main_Handler(New object:C1471("action"; "update"))
			
			main_Handler(New object:C1471("action"; "order"))
			
		End if 
		
		//______________________________________________________
	: ($selector="tableProperties")  // Update table properties panel
		
		If ($form.currentForm=$form.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($form.tableProperties)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $form.callback; *; $selector)
				
			End if 
			
		Else 
			
			tables_Handler(New object:C1471("action"; "update"))
			
		End if 
		
		//______________________________________________________
	: ($selector="tableIcons")  // Preload the table icons
		
		If ($form.currentForm=$form.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($form.tableProperties)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $form.callback; *; $selector; $params)
				
			End if 
			
		Else 
			
			tables_Handler(New object:C1471("action"; "icons"))
			
		End if 
		
		//______________________________________________________
	: ($selector="fieldProperties")  // Update field properties panel
		
		If ($form.currentForm=$form.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($form.fieldProperties)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $form.callback; *; $selector)
				
			End if 
			
		Else 
			
			FIELDS_CALLBACK(New object:C1471(\
				"action"; "update"))
			
		End if 
		//______________________________________________________
	: ($selector="loadActionIcons")  // Preload the actions icons
		
		If ($form.currentForm=$form.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($form.actions)
			
			If (Length:C16($panel)>0)
				
				EDITOR.callChild($panel; "ACTIONS_CALLBACK"; $selector; $params)
				
			End if 
		End if 
		
		//______________________________________________________
	: ($selector="dataSet")  // Dataset generation result
		
		OB REMOVE:C1226(Form:C1466.$project; "dataSetGeneration")
		
		If ($form.currentForm=$form.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($form.dataSource)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $form.callback; *; $selector)
				
			End if 
			
		Else 
			
			SOURCE_Handler(New object:C1471("action"; "dataset"))
			
		End if 
		
		//______________________________________________________
	: ($selector="update_data")  // Update data panel after a dataset generation
		
		If ($form.currentForm=$form.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($form.data)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $form.callback; *; $selector)
				
			End if 
			
		Else 
			
			DATA_Handler(New object:C1471("action"; "update"))
			
		End if 
		
		//______________________________________________________
	: ($selector="checkingServerConfiguration")  // Verify the web server configuration
		
		If ($form.currentForm=$form.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($form.dataSource)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $form.callback; *; $selector)
				
			End if 
			
		Else 
			
			SOURCE_Handler(New object:C1471("action"; $selector))
			
		End if 
		
		//______________________________________________________
	: ($selector="teamId")
		
		If ($form.currentForm=$form.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($form.developer)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $form.callback; *; $selector; $params)
				
			End if 
			
		Else 
			
			If ($params.success)
				
				DEVELOPER_CALLBACK(New object:C1471("action"; $selector; "value"; $params.value))
				
			End if 
		End if 
		
		//______________________________________________________
	: ($selector="tableList")\
		 | ($selector="fieldList")
		
		If ($form.currentForm=$form.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($form.structure)
			
			If (Length:C16($panel)>0)
				
				If (FEATURE.with("wizards"))
					
					EDITOR.callChild($panel; EDITOR.callback; $selector)
					
				Else 
					
					EXECUTE METHOD IN SUBFORM:C1085($panel; $form.callback; *; $selector; $params)
					
				End if 
			End if 
			
		Else 
			
			If (FEATURE.with("wizards"))
				
				STRUCTURE_Handler(New object:C1471("action"; $selector; "value"; PROJECT))
				
			Else 
				
				STRUCTURE_Handler(New object:C1471("action"; $selector; "value"; $params))
				
			End if 
		End if 
		
		//______________________________________________________
	: ($selector="onLosingFocus")
		
		OBJECT GET SUBFORM:C1139(*; $params.panel; $Ptr_; $panel)
		
		Case of 
				
				//…………………………………………………………………………………………………………
			: ($panel=$form.structure)
				
				EXECUTE METHOD IN SUBFORM:C1085($params.panel; "structure_Handler"; *; New object:C1471("action"; $selector))
				
				//…………………………………………………………………………………………………………
		End case 
		
		//______________________________________________________
	: ($selector="resizePanel")
		
		$panel:=panel_Find_by_name($params.panel; ->$indx)
		
		If (Length:C16($panel)>0)
			
			// Resize the current panel
			OBJECT MOVE:C664(*; $panel; 0; 0; 0; $params.offset)
			EXECUTE METHOD IN SUBFORM:C1085($panel; "structure_Handler"; *; New object:C1471("action"; "geometry"; "target"; $params.panel))
			
			// Move all the following panels
			For ($i; $indx+1; panel_Count; 1)
				
				OBJECT MOVE:C664(*; "title.label."+String:C10($i); 0; $params.offset)
				OBJECT MOVE:C664(*; "panel."+String:C10($i); 0; $params.offset)
				
			End for 
		End if 
		
		//______________________________________________________
	: ($selector="goTo")
		
		If ($form.currentForm=$form.project)
			
			If (Asserted:C1132($params.panel#Null:C1517))
				
				// Pass to target panel
				$panel:=panel_Find_by_name($params.panel; ->$indx)
				
				If (Length:C16($panel)>0)
					
					// Open the panel, if any
					panel_OPEN($indx)
					
					EXECUTE METHOD IN SUBFORM:C1085($panel; $form.callback; *; $selector; $params)
					
				End if 
			End if 
			
		Else 
			
			Case of 
					
					//……………………………………………………………………………………………………
				: ($params.object#Null:C1517)  // Go to object
					
					GOTO OBJECT:C206(*; $params.object)
					
					//……………………………………………………………………………………………………
				: ($params.table#Null:C1517)  // Select table
					
					Case of 
							
							//___________________________
						: ($params.panel="TABLES")
							
							// Set the selected table
							tables_Handler(New object:C1471("action"; "select"; "tableNumber"; Num:C11($params.table)))
							
							If ($params.field#Null:C1517)  // Select field
								
								// Set the selected field
								FIELDS_CALLBACK(New object:C1471(\
									"action"; "select"; \
									"fieldNumber"; Num:C11($params.field)))
								
							End if 
							
							// Update field properties panel
							CALL FORM:C1391($form.window; $form.callback; "fieldProperties")
							
							//___________________________
						: ($params.panel="DATA")
							
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
		
		If ($form.currentForm=$form.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($form.views; ->$indx)
			
			If (Length:C16($panel)>0)
				
				// Open the panel, if any
				panel_OPEN($indx)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $form.callback; *; $selector; $params)
				
			End if 
			
		Else 
			
			$params.action:=$selector
			VIEWS_Handler($params)
			
		End if 
		
		//______________________________________________________
	: ($selector="setForm")  // Set form from browser
		
		If ($form.currentForm=$form.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($form.views)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $form.callback; *; $selector; $params)
				
			End if 
			
		Else 
			
			VIEWS_Handler($params)
			
		End if 
		
		//______________________________________________________
	: ($selector="refresh")  // Refresh displayed panels
		
		For each ($t; panels)
			
			EXECUTE METHOD IN SUBFORM:C1085($t; "panel_REFRESH")
			
		End for each 
		
		//______________________________________________________
	: ($selector="refreshViews")  // Update VIEWS panel
		
		If ($form.currentForm=$form.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($form.views)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $form.callback; *; $selector; $params)
				
			End if 
			
		Else 
			
			If ($params=Null:C1517)
				
				$params:=New object:C1471("action"; $selector)
				
			Else 
				
				$params.action:=$selector
				
			End if 
			
			VIEWS_Handler($params)
			
		End if 
		
		//______________________________________________________
	: ($selector="refreshParameters")  // Update ACTIONS PARAMERS panel
		
		If ($form.currentForm=$form.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($form.actionParameters)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; "panel_REFRESH")
				
			End if 
		End if 
		
		//______________________________________________________
	: ($selector="selectParameters")  // [OBSOLETE] **************************************** Update ACTIONS PARAMERS panel
		
		If ($form.currentForm=$form.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($form.actionParameters)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; "ACTIONS_PARAMS_Handler"; *; New object:C1471("action"; "refresh"))
				
			End if 
		End if 
		
		//______________________________________________________
	: ($selector="refreshServer")  // Update SERVER panel
		
		If ($form.currentForm=$form.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($form.server)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $form.callback; *; $selector; $params)
				
			End if 
			
		Else 
			
			_o_SERVER_Handler(New object:C1471("action"; "authenticationMethod"))
			
		End if 
		
		//______________________________________________________
	: ($selector="testServer")  // Server checking response
		
		If ($form.currentForm=$form.project)
			
			// Pass to target panel
			$panel:=panel_Find_by_name($form.dataSource)
			
			If (Length:C16($panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($panel; $form.callback; *; $selector; $params)
				
			End if 
			
		Else 
			
			SOURCE_Handler(New object:C1471("action"; $selector; "response"; $params))
			
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$selector+"\"")
		
		//______________________________________________________
End case 

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End