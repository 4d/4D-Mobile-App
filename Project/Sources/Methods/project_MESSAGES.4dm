//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : project_MESSAGES
  // ID[289212F4F0EE41A1BA699256DA276FD1]
  // Created 10-1-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Management of messages addressed to PROJECT form or its subforms
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_OBJECT:C1216($2)
C_OBJECT:C1216($3)

C_LONGINT:C283($Lon_bottom;$Lon_height;$Lon_i;$Lon_index;$Lon_left;$Lon_parameters)
C_LONGINT:C283($Lon_right;$Lon_top;$Lon_width)
C_POINTER:C301($Ptr_)
C_TEXT:C284($Txt_selector;$Txt_panel)
C_OBJECT:C1216($Obj_form;$Obj_in)

If (False:C215)
	C_TEXT:C284(project_MESSAGES ;$1)
	C_OBJECT:C1216(project_MESSAGES ;$2)
	C_OBJECT:C1216(project_MESSAGES ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=3;"Missing parameter"))
	
	  // Required parameters
	$Txt_selector:=$1
	$Obj_form:=$2
	$Obj_in:=$3
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=4)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Txt_selector="pickerShow")  // Display the picture grid widget
		
		  // Get the viewport
		OBJECT GET SUBFORM CONTAINER SIZE:C1148($Lon_width;$Lon_height)
		
		  // Places the background invisible button
		OBJECT SET COORDINATES:C1248(*;"picker.close";0;Num:C11($Obj_in.vOffset);$Lon_width;$Lon_height)
		
		Case of 
				
				  //……………………………………………………………………………………………
			: (String:C10($Obj_in.action)="tableIcons") | (String:C10($Obj_in.action)="fieldIcons")
				
				$Lon_width:=$Lon_width-5
				$Lon_height:=$Lon_height-5
				
				OBJECT GET COORDINATES:C663(*;panel_Find_by_name ($Obj_form.tableProperties);$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
				
				$Lon_left:=Num:C11($Obj_in.left)
				$Lon_top:=$Lon_top+Num:C11($Obj_in.top)
				$Lon_right:=$Lon_width
				$Lon_bottom:=$Lon_height
				
				$Lon_width:=$Lon_width-$Lon_left
				
				  //……………………………………………………………………………………………
			: (String:C10($Obj_in.action)="forms")
				
				$Lon_width:=$Lon_width-15
				$Lon_height:=$Lon_height-15
				
				OBJECT GET COORDINATES:C663(*;panel_Find_by_name ($Obj_form.views);$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
				
				$Lon_left:=18
				$Lon_top:=$Lon_top+165
				$Lon_right:=$Lon_width
				$Lon_bottom:=$Lon_height
				
				  //……………………………………………………………………………………………
			: (String:C10($Obj_in.action)="actionIcons")
				
				$Lon_width:=$Lon_width-5
				$Lon_width:=$Lon_width-5
				$Lon_height:=$Lon_height-5
				
				OBJECT GET COORDINATES:C663(*;panel_Find_by_name ($Obj_form.tableProperties);$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
				
				$Lon_left:=Num:C11($Obj_in.left)
				$Lon_top:=$Lon_top+Num:C11($Obj_in.top)
				$Lon_right:=$Lon_width
				$Lon_bottom:=$Lon_height
				
				$Lon_width:=$Lon_width-$Lon_left
				
				  //……………………………………………………………………………………………
			Else 
				
				ASSERT:C1129(False:C215;"Unknown entry point: \""+String:C10($Obj_in.action)+"\"")
				
				  //……………………………………………………………………………………………
		End case 
		
		$Obj_in.maxColumns:=($Lon_width-19)\$Obj_in.celluleWidth
		
		OBJECT SET COORDINATES:C1248(*;"picker";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		OBJECT SET VISIBLE:C603(*;"picker@";True:C214)
		
		  // Touch picker subform
		(OBJECT Get pointer:C1124(Object named:K67:5;"picker"))->:=$Obj_in
		
		Form:C1466.$dialog.picker:=True:C214
		
		  //______________________________________________________
	: ($Txt_selector="pickerHide")  // Hide the picture grid widget
		
		OBJECT SET VISIBLE:C603(*;"picker@";False:C215)
		
		If (Form:C1466.$dialog#Null:C1517)
			
			OB REMOVE:C1226(Form:C1466.$dialog;"picker")
			
		End if 
		
		If ($Obj_form.currentForm=$Obj_form.project)
			
			  // Pass to target panel
			Case of 
					
					  //……………………………………………………………………………………………
				: (String:C10($Obj_in.action)="forms")
					
					$Txt_panel:=panel_Find_by_name ($Obj_form.views)
					
					  //……………………………………………………………………………………………
				Else 
					
					  //ASSERT(False;"Unknown entry point: \""+String($Obj_in.action)+"\"")
					
					  //……………………………………………………………………………………………
			End case 
			
			If (Length:C16($Txt_panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;$Obj_form.callback;*;$Txt_selector;$Obj_in)
				
			End if 
			
		Else 
			
			Case of 
					
					  //……………………………………………………………………………………………
				: (String:C10($Obj_in.action)="forms")
					
					$Obj_in.action:=Choose:C955(Bool:C1537($Obj_in.onResize);"show";$Txt_selector)
					VIEWS_Handler ($Obj_in)
					
					  //……………………………………………………………………………………………
			End case 
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="pickerResume")  // Return the picture grid widget result to the caller
		
		If ($Obj_form.currentForm=$Obj_form.project)
			
			  // Hide the picture grid widget
			OBJECT SET VISIBLE:C603(*;"picker@";False:C215)
			OB REMOVE:C1226(Form:C1466.$dialog;"picker")
			
			  // Pass to target panel
			Case of 
					
					  //……………………………………………………………………………………………
				: (String:C10($Obj_in.action)="tableIcons")
					
					$Txt_panel:=panel_Find_by_name ($Obj_form.tableProperties)
					
					  //……………………………………………………………………………………………
				: (String:C10($Obj_in.action)="fieldIcons")
					
					$Txt_panel:=panel_Find_by_name ($Obj_form.fieldProperties)
					
					  //……………………………………………………………………………………………
				: (String:C10($Obj_in.action)="forms")
					
					$Txt_panel:=panel_Find_by_name ($Obj_form.views)
					
					  //……………………………………………………………………………………………
				: (String:C10($Obj_in.action)="actionIcons")
					
					$Txt_panel:=panel_Find_by_name ($Obj_form.actions)
					
					  //……………………………………………………………………………………………
				Else 
					
					ASSERT:C1129(False:C215;"Unknown entry point: \""+String:C10($Obj_in.action)+"\"")
					
					  //……………………………………………………………………………………………
			End case 
			
			If (Length:C16($Txt_panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;$Obj_form.callback;*;$Txt_selector;$Obj_in)
				
			End if 
			
		Else 
			
			Case of 
					
					  //……………………………………………………………………………………………
				: (String:C10($Obj_in.action)="tableIcons")
					
					tables_Handler ($Obj_in)
					
					  //……………………………………………………………………………………………
				: (String:C10($Obj_in.action)="fieldIcons")
					
					FIELDS_HANDLER ($Obj_in)
					
					  //……………………………………………………………………………………………
				: (String:C10($Obj_in.action)="forms")
					
					VIEWS_Handler ($Obj_in)
					
					  //……………………………………………………………………………………………
				: (String:C10($Obj_in.action)="actionIcons")
					
					ACTIONS_Handler ($Obj_in)
					
					  //……………………………………………………………………………………………
			End case 
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="projectAudit")  // Verify the project integrity
		
		PROJECT_HANDLER (New object:C1471("action";$Txt_selector))
		
		  //______________________________________________________
	: ($Txt_selector="projectFixErrors")  // Fix the project errors
		
		$Obj_in.action:=$Txt_selector
		PROJECT_HANDLER ($Obj_in)
		
		  //______________________________________________________
	: ($Txt_selector="mainMenu")  // Update Main menu panel
		
		If ($Obj_form.currentForm=$Obj_form.project)
			
			  // Pass to target panel
			$Txt_panel:=panel_Find_by_name ($Obj_form.mainMenu)
			
			If (Length:C16($Txt_panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;$Obj_form.callback;*;$Txt_selector)
				
			End if 
			
		Else 
			
			main_Handler (New object:C1471("action";"update"))
			
			main_Handler (New object:C1471("action";"order"))
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="tableProperties")  // Update table properties panel
		
		If ($Obj_form.currentForm=$Obj_form.project)
			
			  // Pass to target panel
			$Txt_panel:=panel_Find_by_name ($Obj_form.tableProperties)
			
			If (Length:C16($Txt_panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;$Obj_form.callback;*;$Txt_selector)
				
			End if 
			
		Else 
			
			tables_Handler (New object:C1471("action";"update"))
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="tableIcons")  // Preload the table icons
		
		If ($Obj_form.currentForm=$Obj_form.project)
			
			  // Pass to target panel
			$Txt_panel:=panel_Find_by_name ($Obj_form.tableProperties)
			
			If (Length:C16($Txt_panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;$Obj_form.callback;*;$Txt_selector;$Obj_in)
				
			End if 
			
		Else 
			
			tables_Handler (New object:C1471("action";"icons"))
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="fieldProperties")  // Update field properties panel
		
		If ($Obj_form.currentForm=$Obj_form.project)
			
			  // Pass to target panel
			$Txt_panel:=panel_Find_by_name ($Obj_form.fieldProperties)
			
			If (Length:C16($Txt_panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;$Obj_form.callback;*;$Txt_selector)
				
			End if 
			
		Else 
			
			FIELDS_HANDLER (New object:C1471(\
				"action";"update"))
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="fieldIcons")  // Preload the field icons
		
		If ($Obj_form.currentForm=$Obj_form.project)
			
			  // Pass to target panel
			$Txt_panel:=panel_Find_by_name ($Obj_form.fieldProperties)
			
			If (Length:C16($Txt_panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;$Obj_form.callback;*;$Txt_selector;$Obj_in)
				
			End if 
			
		Else 
			
			FIELDS_HANDLER (New object:C1471(\
				"action";"icons"))
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="actionIcons")  // Preload the actions icons
		
		If ($Obj_form.currentForm=$Obj_form.project)
			
			  // Pass to target panel
			$Txt_panel:=panel_Find_by_name ($Obj_form.actions)
			
			If (Length:C16($Txt_panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;$Obj_form.callback;*;$Txt_selector;$Obj_in)
				
			End if 
			
		Else 
			
			ACTIONS_Handler (New object:C1471("action";"icons"))
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="dataSet")  // Dataset generation result
		
		If ($Obj_form.currentForm=$Obj_form.project)
			
			  // Pass to target panel
			$Txt_panel:=panel_Find_by_name ($Obj_form.dataSource)
			
			If (Length:C16($Txt_panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;$Obj_form.callback;*;$Txt_selector)
				
			End if 
			
		Else 
			
			SOURCE_Handler (New object:C1471("action";"dataset"))
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="update_data")  // Update data panel after a dataset generation
		
		If ($Obj_form.currentForm=$Obj_form.project)
			
			  // Pass to target panel
			$Txt_panel:=panel_Find_by_name ($Obj_form.data)
			
			If (Length:C16($Txt_panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;$Obj_form.callback;*;$Txt_selector)
				
			End if 
			
		Else 
			
			DATA_Handler (New object:C1471("action";"update"))
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="checkingServerConfiguration")  // Verify the web server configuration
		
		If ($Obj_form.currentForm=$Obj_form.project)
			
			  // Pass to target panel
			$Txt_panel:=panel_Find_by_name ($Obj_form.dataSource)
			
			If (Length:C16($Txt_panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;$Obj_form.callback;*;$Txt_selector)
				
			End if 
			
		Else 
			
			SOURCE_Handler (New object:C1471("action";$Txt_selector))
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="teamId")
		
		If ($Obj_form.currentForm=$Obj_form.project)
			
			  // Pass to target panel
			$Txt_panel:=panel_Find_by_name ($Obj_form.developer)
			
			If (Length:C16($Txt_panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;$Obj_form.callback;*;$Txt_selector;$Obj_in)
				
			End if 
			
		Else 
			
			If ($Obj_in.success)
				
				DEVELOPER_Handler (New object:C1471("action";$Txt_selector;"value";$Obj_in.value))
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="tableList") | ($Txt_selector="fieldList")
		
		If ($Obj_form.currentForm=$Obj_form.project)
			
			  // Pass to target panel
			$Txt_panel:=panel_Find_by_name ($Obj_form.structure)
			
			If (Length:C16($Txt_panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;$Obj_form.callback;*;$Txt_selector;$Obj_in)
				
			End if 
			
		Else 
			
			STRUCTURE_Handler (New object:C1471("action";$Txt_selector;"value";$Obj_in))
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="onLosingFocus")
		
		OBJECT GET SUBFORM:C1139(*;$Obj_in.panel;$Ptr_;$Txt_panel)
		
		Case of 
				
				  //…………………………………………………………………………………………………………
			: ($Txt_panel=$Obj_form.structure)
				
				EXECUTE METHOD IN SUBFORM:C1085($Obj_in.panel;"structure_Handler";*;New object:C1471("action";$Txt_selector))
				
				  //…………………………………………………………………………………………………………
		End case 
		
		  //______________________________________________________
	: ($Txt_selector="resizePanel")
		
		$Txt_panel:=panel_Find_by_name ($Obj_in.panel;->$Lon_index)
		
		If (Length:C16($Txt_panel)>0)
			
			  // Resize the current panel
			OBJECT MOVE:C664(*;$Txt_panel;0;0;0;$Obj_in.offset)
			EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;"structure_Handler";*;New object:C1471("action";"geometry";"target";$Obj_in.panel))
			
			  // Move all the following panels
			For ($Lon_i;$Lon_index+1;panel_Count ;1)
				
				OBJECT MOVE:C664(*;"title.label."+String:C10($Lon_i);0;$Obj_in.offset)
				OBJECT MOVE:C664(*;"panel."+String:C10($Lon_i);0;$Obj_in.offset)
				
			End for 
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="goTo")
		
		If ($Obj_form.currentForm=$Obj_form.project)
			
			If (Asserted:C1132($Obj_in.panel#Null:C1517))
				
				  // Pass to target panel
				$Txt_panel:=panel_Find_by_name ($Obj_in.panel;->$Lon_index)
				
				If (Length:C16($Txt_panel)>0)
					
					  // Open the panel, if any
					panel_OPEN ($Lon_index)
					
					EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;$Obj_form.callback;*;$Txt_selector;$Obj_in)
					
				End if 
			End if 
			
		Else 
			
			Case of 
					
					  //……………………………………………………………………………………………………
				: ($Obj_in.object#Null:C1517)  // Go to object
					
					GOTO OBJECT:C206(*;$Obj_in.object)
					
					  //……………………………………………………………………………………………………
				: ($Obj_in.table#Null:C1517)  // Select table
					
					Case of 
							
							  //___________________________
						: ($Obj_in.panel="TABLES")
							
							  // Set the selected table
							tables_Handler (New object:C1471("action";"select";"tableNumber";Num:C11($Obj_in.table)))
							
							If ($Obj_in.field#Null:C1517)  // Select field
								
								  // Set the selected field
								FIELDS_HANDLER (New object:C1471(\
									"action";"select";\
									"fieldNumber";Num:C11($Obj_in.field)))
								
							End if 
							
							  // Update field properties panel
							CALL FORM:C1391($Obj_form.window;$Obj_form.callback;"fieldProperties")
							
							  //___________________________
						: ($Obj_in.panel="DATA")
							
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
	: ($Txt_selector="selectTab")
		
		If ($Obj_form.currentForm=$Obj_form.project)
			
			  // Pass to target panel
			$Txt_panel:=panel_Find_by_name ($Obj_form.views;->$Lon_index)
			
			If (Length:C16($Txt_panel)>0)
				
				  // Open the panel, if any
				panel_OPEN ($Lon_index)
				
				EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;$Obj_form.callback;*;$Txt_selector;$Obj_in)
				
			End if 
			
		Else 
			
			$Obj_in.action:=$Txt_selector
			VIEWS_Handler ($Obj_in)
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="refreshViews")  // Update VIEWS panel
		
		If ($Obj_form.currentForm=$Obj_form.project)
			
			  // Pass to target panel
			$Txt_panel:=panel_Find_by_name ($Obj_form.views)
			
			If (Length:C16($Txt_panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;$Obj_form.callback;*;$Txt_selector;$Obj_in)
				
			End if 
			
		Else 
			
			VIEWS_Handler (New object:C1471("action";$Txt_selector))
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="refreshParameters")  // Update ACTIONS PARAMERS panel
		
		If ($Obj_form.currentForm=$Obj_form.project)
			
			  // Pass to target panel
			$Txt_panel:=panel_Find_by_name ($Obj_form.actionParameters)
			
			If (Length:C16($Txt_panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;"panel_REFRESH")
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="selectParameters")  // Update ACTIONS PARAMERS panel
		
		If ($Obj_form.currentForm=$Obj_form.project)
			
			  // Pass to target panel
			$Txt_panel:=panel_Find_by_name ($Obj_form.actionParameters)
			
			If (Length:C16($Txt_panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;"ACTIONS_PARAMS_Handler";*;New object:C1471("action";"refresh"))
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="refreshServer")  // Update SERVER panel
		
		If ($Obj_form.currentForm=$Obj_form.project)
			
			  // Pass to target panel
			$Txt_panel:=panel_Find_by_name ($Obj_form.server)
			
			If (Length:C16($Txt_panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;$Obj_form.callback;*;$Txt_selector;$Obj_in)
				
			End if 
			
		Else 
			
			SERVER_Handler (New object:C1471("action";"authenticationMethod"))
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="testServer")  // Server checking response
		
		If ($Obj_form.currentForm=$Obj_form.project)
			
			  // Pass to target panel
			$Txt_panel:=panel_Find_by_name ($Obj_form.dataSource)
			
			If (Length:C16($Txt_panel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;$Obj_form.callback;*;$Txt_selector;$Obj_in)
				
			End if 
			
		Else 
			
			SOURCE_Handler (New object:C1471("action";$Txt_selector;"response";$Obj_in))
			
		End if 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_selector+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End