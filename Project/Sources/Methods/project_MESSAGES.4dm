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

C_LONGINT:C283($bottom;$height;$i;$indx;$left;$right)
C_LONGINT:C283($top;$width)
C_POINTER:C301($Ptr_)
C_TEXT:C284($t;$tPanel;$tSelector)
C_OBJECT:C1216($form;$oIN)

If (False:C215)
	C_TEXT:C284(project_MESSAGES ;$1)
	C_OBJECT:C1216(project_MESSAGES ;$2)
	C_OBJECT:C1216(project_MESSAGES ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=3;"Missing parameter"))
	
	  // Required parameters
	$tSelector:=$1
	$form:=$2
	$oIN:=$3
	
	  // Default values
	
	  // Optional parameters
	If (Count parameters:C259>=4)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($tSelector="pickerShow")  // Display the picture grid widget
		
		  // Get the viewport
		OBJECT GET SUBFORM CONTAINER SIZE:C1148($width;$height)
		
		  // Places the background invisible button
		OBJECT SET COORDINATES:C1248(*;"picker.close";0;Num:C11($oIN.vOffset);$width;$height)
		
		Case of 
				
				  //……………………………………………………………………………………………
			: (String:C10($oIN.action)="tableIcons")\
				 | (String:C10($oIN.action)="fieldIcons")
				
				$width:=$width-5
				$height:=$height-5
				
				OBJECT GET COORDINATES:C663(*;panel_Find_by_name ($form.tableProperties);$left;$top;$right;$bottom)
				
				$left:=Num:C11($oIN.left)
				$top:=$top+Num:C11($oIN.top)
				$right:=$width
				$bottom:=$height
				
				$width:=$width-$left
				
				  //……………………………………………………………………………………………
			: (String:C10($oIN.action)="forms")
				
				$width:=$width-15
				$height:=$height-15
				
				OBJECT GET COORDINATES:C663(*;panel_Find_by_name ($form.views);$left;$top;$right;$bottom)
				
				$left:=18
				$top:=$top+165
				$right:=$width
				$bottom:=$height
				
				  //……………………………………………………………………………………………
			: (String:C10($oIN.action)="actionIcons")
				
				$width:=$width-5
				$width:=$width-5
				$height:=$height-5
				
				OBJECT GET COORDINATES:C663(*;panel_Find_by_name ($form.tableProperties);$left;$top;$right;$bottom)
				
				$left:=Num:C11($oIN.left)
				$top:=$top+Num:C11($oIN.top)
				$right:=$width
				$bottom:=$height
				
				$width:=$width-$left
				
				  //……………………………………………………………………………………………
			Else 
				
				ASSERT:C1129(False:C215;"Unknown entry point: \""+String:C10($oIN.action)+"\"")
				
				  //……………………………………………………………………………………………
		End case 
		
		$oIN.maxColumns:=($width-19)\$oIN.celluleWidth
		
		OBJECT SET COORDINATES:C1248(*;"picker";$left;$top;$right;$bottom)
		OBJECT SET VISIBLE:C603(*;"picker@";True:C214)
		
		  // Touch picker subform
		(OBJECT Get pointer:C1124(Object named:K67:5;"picker"))->:=$oIN
		
		Form:C1466.$dialog.picker:=True:C214
		
		  //______________________________________________________
	: ($tSelector="pickerHide")  // Hide the picture grid widget
		
		OBJECT SET VISIBLE:C603(*;"picker@";False:C215)
		
		If (Form:C1466.$dialog#Null:C1517)
			
			OB REMOVE:C1226(Form:C1466.$dialog;"picker")
			
		End if 
		
		If ($form.currentForm=$form.project)
			
			  // Pass to target panel
			Case of 
					
					  //……………………………………………………………………………………………
				: (String:C10($oIN.action)="forms")
					
					$tPanel:=panel_Find_by_name ($form.views)
					
					  //……………………………………………………………………………………………
				Else 
					
					  //ASSERT(False;"Unknown entry point: \""+String($Obj_in.action)+"\"")
					
					  //……………………………………………………………………………………………
			End case 
			
			If (Length:C16($tPanel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($tPanel;$form.callback;*;$tSelector;$oIN)
				
			End if 
			
		Else 
			
			Case of 
					
					  //……………………………………………………………………………………………
				: (String:C10($oIN.action)="forms")
					
					$oIN.action:=Choose:C955(Bool:C1537($oIN.onResize);"show";$tSelector)
					VIEWS_Handler ($oIN)
					
					  //……………………………………………………………………………………………
			End case 
		End if 
		
		  //______________________________________________________
	: ($tSelector="pickerResume")  // Return the picture grid widget result to the caller
		
		If ($form.currentForm=$form.project)
			
			  // Hide the picture grid widget
			OBJECT SET VISIBLE:C603(*;"picker@";False:C215)
			OB REMOVE:C1226(Form:C1466.$dialog;"picker")
			
			  // Pass to target panel
			$tSelector:=String:C10($oIN.action)
			
			Case of 
					
					  //……………………………………………………………………………………………
				: ($tSelector="tableIcons")
					
					$tPanel:=panel_Find_by_name ($form.tableProperties)
					
					  //……………………………………………………………………………………………
				: ($tSelector="fieldIcons")
					
					$tPanel:=panel_Find_by_name ($form.fieldProperties)
					
					  //……………………………………………………………………………………………
				: ($tSelector="forms")
					
					$tPanel:=panel_Find_by_name ($form.views)
					
					  //……………………………………………………………………………………………
				: ($tSelector="actionIcons")
					
					$tPanel:=panel_Find_by_name ($form.actions)
					
					  //……………………………………………………………………………………………
				Else 
					
					ASSERT:C1129(False:C215;"Unknown entry point: \""+$tSelector+"\"")
					
					  //……………………………………………………………………………………………
			End case 
			
			If (Length:C16($tPanel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($tPanel;$form.callback;*;"pickerResume";$oIN)
				
			End if 
			
		Else 
			
			Case of 
					
					  //……………………………………………………………………………………………
				: ($form.currentForm=$form.tableProperties)
					
					tables_Handler ($oIN)
					
					  //……………………………………………………………………………………………
				: ($form.currentForm=$form.fieldProperties)
					
					FIELDS_Handler ($oIN)
					
					  //……………………………………………………………………………………………
				: ($form.currentForm=$form.views)
					
					VIEWS_Handler ($oIN)
					
					  //……………………………………………………………………………………………
				: ($form.currentForm=$form.actions)
					
					ACTIONS_Handler ($oIN)
					
					  //……………………………………………………………………………………………
			End case 
		End if 
		
		  //______________________________________________________
	: ($tSelector="projectAudit")  // Verify the project integrity
		
		PROJECT_Handler (New object:C1471("action";$tSelector))
		
		  //______________________________________________________
	: ($tSelector="projectFixErrors")  // Fix the project errors
		
		$oIN.action:=$tSelector
		PROJECT_Handler ($oIN)
		
		  //______________________________________________________
	: ($tSelector="mainMenu")  // Update Main menu panel
		
		If ($form.currentForm=$form.project)
			
			  // Pass to target panel
			$tPanel:=panel_Find_by_name ($form.mainMenu)
			
			If (Length:C16($tPanel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($tPanel;$form.callback;*;$tSelector)
				
			End if 
			
		Else 
			
			main_Handler (New object:C1471("action";"update"))
			
			main_Handler (New object:C1471("action";"order"))
			
		End if 
		
		  //______________________________________________________
	: ($tSelector="tableProperties")  // Update table properties panel
		
		If ($form.currentForm=$form.project)
			
			  // Pass to target panel
			$tPanel:=panel_Find_by_name ($form.tableProperties)
			
			If (Length:C16($tPanel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($tPanel;$form.callback;*;$tSelector)
				
			End if 
			
		Else 
			
			tables_Handler (New object:C1471("action";"update"))
			
		End if 
		
		  //______________________________________________________
	: ($tSelector="tableIcons")  // Preload the table icons
		
		If ($form.currentForm=$form.project)
			
			  // Pass to target panel
			$tPanel:=panel_Find_by_name ($form.tableProperties)
			
			If (Length:C16($tPanel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($tPanel;$form.callback;*;$tSelector;$oIN)
				
			End if 
			
		Else 
			
			tables_Handler (New object:C1471("action";"icons"))
			
		End if 
		
		  //______________________________________________________
	: ($tSelector="fieldProperties")  // Update field properties panel
		
		If ($form.currentForm=$form.project)
			
			  // Pass to target panel
			$tPanel:=panel_Find_by_name ($form.fieldProperties)
			
			If (Length:C16($tPanel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($tPanel;$form.callback;*;$tSelector)
				
			End if 
			
		Else 
			
			FIELDS_Handler (New object:C1471(\
				"action";"update"))
			
		End if 
		
		  //______________________________________________________
	: ($tSelector="fieldIcons")  // Preload the field icons
		
		If ($form.currentForm=$form.project)
			
			  // Pass to target panel
			$tPanel:=panel_Find_by_name ($form.fieldProperties)
			
			If (Length:C16($tPanel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($tPanel;$form.callback;*;$tSelector;$oIN)
				
			End if 
			
		Else 
			
			FIELDS_Handler (New object:C1471(\
				"action";"icons"))
			
		End if 
		
		  //______________________________________________________
	: ($tSelector="actionIcons")  // Preload the actions icons
		
		If ($form.currentForm=$form.project)
			
			  // Pass to target panel
			$tPanel:=panel_Find_by_name ($form.actions)
			
			If (Length:C16($tPanel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($tPanel;$form.callback;*;$tSelector;$oIN)
				
			End if 
			
		Else 
			
			ACTIONS_Handler (New object:C1471("action";"icons"))
			
		End if 
		
		  //______________________________________________________
	: ($tSelector="dataSet")  // Dataset generation result
		
		OB REMOVE:C1226(Form:C1466.$project;"dataSetGeneration")
		
		If ($form.currentForm=$form.project)
			
			  // Pass to target panel
			$tPanel:=panel_Find_by_name ($form.dataSource)
			
			If (Length:C16($tPanel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($tPanel;$form.callback;*;$tSelector)
				
			End if 
			
		Else 
			
			SOURCE_Handler (New object:C1471("action";"dataset"))
			
		End if 
		
		  //______________________________________________________
	: ($tSelector="update_data")  // Update data panel after a dataset generation
		
		If ($form.currentForm=$form.project)
			
			  // Pass to target panel
			$tPanel:=panel_Find_by_name ($form.data)
			
			If (Length:C16($tPanel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($tPanel;$form.callback;*;$tSelector)
				
			End if 
			
		Else 
			
			DATA_Handler (New object:C1471("action";"update"))
			
		End if 
		
		  //______________________________________________________
	: ($tSelector="checkingServerConfiguration")  // Verify the web server configuration
		
		If ($form.currentForm=$form.project)
			
			  // Pass to target panel
			$tPanel:=panel_Find_by_name ($form.dataSource)
			
			If (Length:C16($tPanel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($tPanel;$form.callback;*;$tSelector)
				
			End if 
			
		Else 
			
			SOURCE_Handler (New object:C1471("action";$tSelector))
			
		End if 
		
		  //______________________________________________________
	: ($tSelector="teamId")
		
		If ($form.currentForm=$form.project)
			
			  // Pass to target panel
			$tPanel:=panel_Find_by_name ($form.developer)
			
			If (Length:C16($tPanel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($tPanel;$form.callback;*;$tSelector;$oIN)
				
			End if 
			
		Else 
			
			If ($oIN.success)
				
				DEVELOPER_Handler (New object:C1471("action";$tSelector;"value";$oIN.value))
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($tSelector="tableList") | ($tSelector="fieldList")
		
		If ($form.currentForm=$form.project)
			
			  // Pass to target panel
			$tPanel:=panel_Find_by_name ($form.structure)
			
			If (Length:C16($tPanel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($tPanel;$form.callback;*;$tSelector;$oIN)
				
			End if 
			
		Else 
			
			STRUCTURE_Handler (New object:C1471("action";$tSelector;"value";$oIN))
			
		End if 
		
		  //______________________________________________________
	: ($tSelector="onLosingFocus")
		
		OBJECT GET SUBFORM:C1139(*;$oIN.panel;$Ptr_;$tPanel)
		
		Case of 
				
				  //…………………………………………………………………………………………………………
			: ($tPanel=$form.structure)
				
				EXECUTE METHOD IN SUBFORM:C1085($oIN.panel;"structure_Handler";*;New object:C1471("action";$tSelector))
				
				  //…………………………………………………………………………………………………………
		End case 
		
		  //______________________________________________________
	: ($tSelector="resizePanel")
		
		$tPanel:=panel_Find_by_name ($oIN.panel;->$indx)
		
		If (Length:C16($tPanel)>0)
			
			  // Resize the current panel
			OBJECT MOVE:C664(*;$tPanel;0;0;0;$oIN.offset)
			EXECUTE METHOD IN SUBFORM:C1085($tPanel;"structure_Handler";*;New object:C1471("action";"geometry";"target";$oIN.panel))
			
			  // Move all the following panels
			For ($i;$indx+1;panel_Count ;1)
				
				OBJECT MOVE:C664(*;"title.label."+String:C10($i);0;$oIN.offset)
				OBJECT MOVE:C664(*;"panel."+String:C10($i);0;$oIN.offset)
				
			End for 
		End if 
		
		  //______________________________________________________
	: ($tSelector="goTo")
		
		If ($form.currentForm=$form.project)
			
			If (Asserted:C1132($oIN.panel#Null:C1517))
				
				  // Pass to target panel
				$tPanel:=panel_Find_by_name ($oIN.panel;->$indx)
				
				If (Length:C16($tPanel)>0)
					
					  // Open the panel, if any
					panel_OPEN ($indx)
					
					EXECUTE METHOD IN SUBFORM:C1085($tPanel;$form.callback;*;$tSelector;$oIN)
					
				End if 
			End if 
			
		Else 
			
			Case of 
					
					  //……………………………………………………………………………………………………
				: ($oIN.object#Null:C1517)  // Go to object
					
					GOTO OBJECT:C206(*;$oIN.object)
					
					  //……………………………………………………………………………………………………
				: ($oIN.table#Null:C1517)  // Select table
					
					Case of 
							
							  //___________________________
						: ($oIN.panel="TABLES")
							
							  // Set the selected table
							tables_Handler (New object:C1471("action";"select";"tableNumber";Num:C11($oIN.table)))
							
							If ($oIN.field#Null:C1517)  // Select field
								
								  // Set the selected field
								FIELDS_Handler (New object:C1471(\
									"action";"select";\
									"fieldNumber";Num:C11($oIN.field)))
								
							End if 
							
							  // Update field properties panel
							CALL FORM:C1391($form.window;$form.callback;"fieldProperties")
							
							  //___________________________
						: ($oIN.panel="DATA")
							
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
	: ($tSelector="selectTab")
		
		If ($form.currentForm=$form.project)
			
			  // Pass to target panel
			$tPanel:=panel_Find_by_name ($form.views;->$indx)
			
			If (Length:C16($tPanel)>0)
				
				  // Open the panel, if any
				panel_OPEN ($indx)
				
				EXECUTE METHOD IN SUBFORM:C1085($tPanel;$form.callback;*;$tSelector;$oIN)
				
			End if 
			
		Else 
			
			$oIN.action:=$tSelector
			VIEWS_Handler ($oIN)
			
		End if 
		
		  //______________________________________________________
	: ($tSelector="setForm")  // Set form from browser
		
		If ($form.currentForm=$form.project)
			
			  // Pass to target panel
			$tPanel:=panel_Find_by_name ($form.views)
			
			If (Length:C16($tPanel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($tPanel;$form.callback;*;$tSelector;$oIN)
				
			End if 
			
		Else 
			
			VIEWS_Handler ($oIN)
			
		End if 
		
		  //______________________________________________________
	: ($tSelector="refreshViews")  // Update VIEWS panel
		
		If ($form.currentForm=$form.project)
			
			  // Pass to target panel
			$tPanel:=panel_Find_by_name ($form.views)
			
			If (Length:C16($tPanel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($tPanel;$form.callback;*;$tSelector;$oIN)
				
			End if 
			
		Else 
			
			If ($oIN=Null:C1517)
				
				$oIN:=New object:C1471("action";$tSelector)
				
			Else 
				
				$oIN.action:=$tSelector
				
			End if 
			
			VIEWS_Handler ($oIN)
			
		End if 
		
		  //______________________________________________________
	: ($tSelector="refreshParameters")  // Update ACTIONS PARAMERS panel
		
		If ($form.currentForm=$form.project)
			
			  // Pass to target panel
			$tPanel:=panel_Find_by_name ($form.actionParameters)
			
			If (Length:C16($tPanel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($tPanel;"panel_REFRESH")
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($tSelector="selectParameters")  // Update ACTIONS PARAMERS panel
		
		If ($form.currentForm=$form.project)
			
			  // Pass to target panel
			$tPanel:=panel_Find_by_name ($form.actionParameters)
			
			If (Length:C16($tPanel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($tPanel;"ACTIONS_PARAMS_Handler";*;New object:C1471("action";"refresh"))
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($tSelector="refreshServer")  // Update SERVER panel
		
		If ($form.currentForm=$form.project)
			
			  // Pass to target panel
			$tPanel:=panel_Find_by_name ($form.server)
			
			If (Length:C16($tPanel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($tPanel;$form.callback;*;$tSelector;$oIN)
				
			End if 
			
		Else 
			
			_o_SERVER_Handler (New object:C1471("action";"authenticationMethod"))
			
		End if 
		
		  //______________________________________________________
	: ($tSelector="testServer")  // Server checking response
		
		If ($form.currentForm=$form.project)
			
			  // Pass to target panel
			$tPanel:=panel_Find_by_name ($form.dataSource)
			
			If (Length:C16($tPanel)>0)
				
				EXECUTE METHOD IN SUBFORM:C1085($tPanel;$form.callback;*;$tSelector;$oIN)
				
			End if 
			
		Else 
			
			SOURCE_Handler (New object:C1471("action";$tSelector;"response";$oIN))
			
		End if 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$tSelector+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End