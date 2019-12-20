//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : DATA_OBJECTS_HANDLER
  // ID[DE1DC030CB2B497BA1A42C0D39E7CE09]
  // Created 18-12-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($0)

C_BOOLEAN:C305($Boo_caret)
C_LONGINT:C283($Lon_;$Lon_begin;$Lon_column;$Lon_end;$Lon_formEvent;$Lon_parameters)
C_LONGINT:C283($Lon_row;$Lon_x;$Lon_y)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Svg_id;$t;$Txt_me;$Txt_selection;$Txt_tip)
C_OBJECT:C1216($context;$form;$menu;$o;$Obj_table)

If (False:C215)
	C_LONGINT:C283(DATA_OBJECTS_HANDLER ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	$Lon_formEvent:=Form event code:C388
	$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
	$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)
	
	$form:=DATA_Handler (New object:C1471("action";"init"))
	
	$context:=$form.ui
	$Obj_table:=$context.current
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($Txt_me=$form.list)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Getting Focus:K2:7)
				
				$context.listboxUI()
				
				  //______________________________________________________
			: ($Lon_formEvent=On Mouse Enter:K2:33)
				
				  //______________________________________________________
			: ($Lon_formEvent=On Losing Focus:K2:8)
				
				$context.listboxUI()
				
				$context.tables:=$context.tables
				
				  //______________________________________________________
			: ($Lon_formEvent=On Selection Change:K2:29)
				
				$context.lastIndex:=$context.index
				
				$context.current:=$context.tables[$context.index-Num:C11($context.index>0)]
				SET TIMER:C645(-1)
				
				  //______________________________________________________
			: ($Lon_formEvent=On Mouse Enter:K2:33)
				
				ui.tips.enable()
				ui.tips.instantly()
				
				  //______________________________________________________
			: ($Lon_formEvent=On Mouse Move:K2:35)
				
				GET MOUSE:C468($Lon_x;$Lon_y;$Lon_)
				
				  //$Obj_buffer:=LISTBOX Get info at(*;$Obj_form.list;$Lon_x;$Lon_y).element
				LISTBOX GET CELL POSITION:C971(*;$Txt_me;$Lon_x;$Lon_y;$Lon_column;$Lon_row)
				
				If ($Lon_row#0)
					
					$o:=$context.tables[$Lon_row-1]
					
					If (Bool:C1537($o.embedded)) & (Not:C34(Bool:C1537($o.filter.parameters))) & ((Bool:C1537($o.filter.validated)) | (Length:C16(String:C10($o.filter.string))=0))
						
						If (Length:C16(String:C10($o.filter.string))=0)
							
							  // No filter
							$Txt_tip:=Get localized string:C991("allDataWillBeIntegratedIntoTheApplication")
							
						Else 
							
							$Txt_tip:=Get localized string:C991("theFilteredDataWillBeIntegratedIntoTheApplication")
							
						End if 
						
					Else 
						
						If (Length:C16(String:C10($o.filter.string))>0)
							
							If (Bool:C1537($o.filter.validated))
								
								If (Bool:C1537($o.filter.parameters))
									
									  // User filter
									$Txt_tip:=Get localized string:C991("theDataWillBeFilteredAccordingToTheConnectedUserParameters")
									
								Else 
									
									$Txt_tip:=Get localized string:C991("theFilteredDataWillBeLoadedIntoTheApplicationWhenConnecting")
									
								End if 
								
							Else 
								
								If (Length:C16(String:C10($o.filter.error))>0)
									
									  // Return the error encountered
									$Txt_tip:=Get localized string:C991("error:")+$o.filter.error
									
								Else 
									
									$Txt_tip:=Get localized string:C991("notValidatedFilter")
									
								End if 
							End if 
							
						Else 
							
							$Txt_tip:=Get localized string:C991("allDataWillBeLoadedIntoTheApplicationWhenConnecting")
							
						End if 
					End if 
				End if 
				
				OBJECT SET HELP TIP:C1181(*;$form.list;$Txt_tip)
				
				  //______________________________________________________
			: ($Lon_formEvent=On Mouse Leave:K2:34)
				
				ui.tips.defaultDelay()
				
				  //______________________________________________________
			: (editor_Locked )
				
				  // NOTHING MORE TO DO
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Txt_me=$form.queryWidget)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				$t:=Document to text:C1236(Get 4D folder:C485(Current resources folder:K5:16)+"queryWidget.svg")
				
				PROCESS 4D TAGS:C816($t;$t;ui.selectedFillColor;Get localized string:C991("fields");Get localized string:C991("comparators");Get localized string:C991("operators");"🢓")
				
				$Ptr_me->:=svg ("parse";New object:C1471("variable";$t)).getPicture()
				
				OBJECT SET VISIBLE:C603(*;$Txt_me;False:C215)
				
				  //______________________________________________________
			: ($Lon_formEvent=On Clicked:K2:4)
				
				$Svg_id:=SVG Find element ID by coordinates:C1054(*;$Txt_me;MOUSEX;MOUSEY)
				
				$menu:=menu 
				
				If (Length:C16($Svg_id)#0)
					
					Case of 
							
							  //……………………………………………………………………………………………………………………………
						: ($Svg_id="fields")
							
							$o:=catalog ("fields";New object:C1471(\
								"tableName";$Obj_table.name))
							
							If ($o.success)
								
								For each ($o;$o.fields)
									
									$t:=$o.path
									
									If (Position:C15(" ";$t)>0)
										
										$menu.append($t;"'"+$t+"'")
										
									Else 
										
										$menu.append($t;$t)
										
									End if 
									
									$menu.icon("Images/fieldsIcons/field_"+String:C10($o.typeLegacy;"00")+".png")
									
								End for each 
							End if 
							
							  //……………………………………………………………………………………………………………………………
						: ($Svg_id="comparator")
							
							$menu.append(":xliff:equalTo";"= ")
							$menu.append(":xliff:notEqualTo";"!= ")
							$menu.line()
							
							$menu.append("IS";"=== ")
							$menu.append("IS NOT";"!== ")
							$menu.line()
							
							$menu.append(":xliff:lessThan";"< ")
							$menu.append(":xliff:greaterThan";"> ")
							$menu.line()
							
							$menu.append(":xliff:lessThanOrEqualTo";"<= ")
							$menu.append(":xliff:greaterThanOrEqualTo";">= ")
							$menu.line()
							
							$menu.append(":xliff:containsKeyword";"% ")
							
							  //……………………………………………………………………………………………………………………………
						: ($Svg_id="operator")
							
							$menu.append("AND";"& ")
							$menu.append("OR";"| ")
							$menu.line()
							
							$menu.append("NOT";"NOT({sel})")
							$menu.line()
							
							$menu.append("(…)";"NOT(({sel}))")
							
							  //……………………………………………………………………………………………………………………………
					End case 
					
					$menu.popup()
					
					If ($menu.selected)
						
						GET HIGHLIGHT:C209(*;$form.filter;$Lon_begin;$Lon_end)
						
						$Txt_selection:=Substring:C12($Obj_table[""].filter.string;$Lon_begin;$Lon_end-$Lon_begin)
						$Boo_caret:=(Position:C15("{sel}";$menu.choice)>0)
						
						If ($Boo_caret)
							
							$menu.choice:=Replace string:C233($menu.choice;"{sel}";$Txt_selection)
							
						End if 
						
						If ($Lon_begin=$Lon_end) & ($Lon_begin#1)
							
							If (String:C10($Obj_table.filter.string)[[$Lon_begin-1]]#" ") & (String:C10($Obj_table.filter.string)[[$Lon_begin-1]]#"(")
								
								$Obj_table.filter.string:=$Obj_table.filter.string+" "
								$Lon_begin:=$Lon_begin+1
								$Lon_end:=$Lon_end+1
								
							End if 
						End if 
						
						$Obj_table.filter.validated:=False:C215
						
						$o:=str (String:C10($Obj_table.filter.string)).insert($menu.choice;$Lon_begin;$Lon_end)
						$Obj_table.filter.string:=$o.value
						
						If (featuresFlags.with("newDataModel"))
							
							Form:C1466.dataModel[String:C10($Obj_table.tableNumber)][""].filter:=$Obj_table.filter
							
						Else 
							
							Form:C1466.dataModel[String:C10($Obj_table.tableNumber)].filter:=$Obj_table.filter
							
						End if 
						
						If ($Boo_caret) & (Length:C16($Txt_selection)=0)
							
							  // Put the carret into
							$o.begin:=$o.end-1
							$o.end:=$o.end-1
							
						End if 
						
						HIGHLIGHT TEXT:C210(*;$form.filter;$o.begin;$o.end)
						
						$form.filter:=$form.filter
						
						GOTO OBJECT:C206(*;$form.filter)
						
						ui.saveProject()
						
						$context.refresh()
						
					End if 
				End if 
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Txt_me=$form.validate) | ($Txt_me=$form.enter)
		
		GOTO OBJECT:C206(*;$form.list)
		
		$o:=checkQueryFilter (New object:C1471("table";$Obj_table.name;"filter";$Obj_table.filter))
		
		$Obj_table.filter:=$o.filter
		
		If (featuresFlags.with("newDataModel"))
			
			Form:C1466.dataModel[String:C10($Obj_table.tableNumber)][""].filter:=$Obj_table.filter
			
		Else 
			
			$Obj_table.filter:=$o.filter
			Form:C1466.dataModel[String:C10($Obj_table.tableNumber)].filter:=$Obj_table.filter
			
		End if 
		
		ui.saveProject()
		$context.refresh()
		
		Form:C1466.$project.status.project:=project_Audit (New object:C1471("target";New collection:C1472("filters"))).success
		CALL FORM:C1391($form.window;"editor_CALLBACK";"updateRibbon")
		
		  //==================================================
	: ($Txt_me=$form.embedded)
		
		If (featuresFlags.with("newDataModel"))
			
			If (Bool:C1537($Obj_table.embedded))
				
				Form:C1466.dataModel[String:C10($Obj_table.tableNumber)][""].embedded:=True:C214
				
			Else 
				
				OB REMOVE:C1226(Form:C1466.dataModel[String:C10($Obj_table.tableNumber)][""];"embedded")
				
			End if 
			
		Else 
			
			If (Bool:C1537($Obj_table.embedded))
				
				Form:C1466.dataModel[String:C10($Obj_table.tableNumber)].embedded:=True:C214
				
			Else 
				
				OB REMOVE:C1226(Form:C1466.dataModel[String:C10($Obj_table.tableNumber)];"embedded")
				
			End if 
		End if 
		
		ui.saveProject()
		$context.update()
		
		  //==================================================
	: ($Txt_me=$form.filter)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Getting Focus:K2:7)
				
				If ($Obj_table.filter=Null:C1517)
					
					$Obj_table.filter:=New object:C1471("string";"")
					
					$Obj_table.validated:=False:C215
					
				End if 
				
				  // Keep current filter definition
				$context.currentFilter:=OB Copy:C1225($Obj_table.filter)
				
				$context.refresh()
				
				  //______________________________________________________
			: ($Lon_formEvent=On Losing Focus:K2:8)
				
				$context.refresh()
				
				  //______________________________________________________
			: ($Lon_formEvent=On Data Change:K2:15)
				
				If (Length:C16($t)>0)
					
					ui.tips.instantly()
					OBJECT SET HELP TIP:C1181(*;$form.filter;Get localized string:C991("notValidatedFilter"))
					
				Else 
					
					ui.tips.defaultDelay()
					OBJECT SET HELP TIP:C1181(*;$form.filter;"")
					
				End if 
				
				$context.refresh()
				
				  //______________________________________________________
			: ($Lon_formEvent=On After Edit:K2:43)
				
				$t:=Get edited text:C655
				
				If (featuresFlags.with("newDataModel"))
					
					$o:=Form:C1466.dataModel[String:C10($Obj_table.tableNumber)][""]
					
				Else 
					
					$o:=Form:C1466.dataModel[String:C10($Obj_table.tableNumber)]
					
				End if 
				
				If (Value type:C1509($o.filter)#Is object:K8:27)
					
					$o.filter:=New object:C1471
					
				End if 
				
				If (Length:C16($t)>0)
					
					$o.filter.string:=$t
					
					If ($t#$context.currentFilter.string)
						
						$o.filter.validated:=False:C215
						$o.filter.parameters:=False:C215
						OB REMOVE:C1226($o.filter;"error")
						
					Else 
						
						$o.filter.validated:=$context.currentFilter.validated
						$o.filter.parameters:=$context.currentFilter.parameters
						
						If ($context.currentFilter.error#Null:C1517)
							
							$o.filter.error:=$context.currentFilter.error
							$o.filter.errors:=$context.currentFilter.errors
							
						Else 
							
							OB REMOVE:C1226($o.filter;"error")
							
						End if 
					End if 
					
					$Obj_table.filter:=$o.filter
					
				Else 
					
					$Obj_table.filter.string:=""
					OB REMOVE:C1226($o;"filter")
					
				End if 
				
				ui.saveProject()
				$context.refresh()
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Txt_me=$form.method)
		
		SERVER_Handler (New object:C1471("action";"editAuthenticationMethod"))
		
		  //==================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown object: \""+$Txt_me+"\"")
		
		  //==================================================
End case 

If (Bool:C1537(featuresFlags._8858))
	
	ui.saveProject()
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End