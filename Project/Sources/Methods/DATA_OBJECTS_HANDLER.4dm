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

C_BOOLEAN:C305($bCaret)
C_LONGINT:C283($column; $end; $l; $Lon_x; $Lon_y; $row)
C_LONGINT:C283($start)
C_TEXT:C284($t; $tID; $tSelection; $tTip)
C_OBJECT:C1216($context; $event; $form; $menu; $o; $oTable)

If (False:C215)
	C_LONGINT:C283(DATA_OBJECTS_HANDLER; $0)
End if 

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=0; "Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	
	// Optional parameters
	If (Count parameters:C259>=1)
		
		// <NONE>
		
	End if 
	
	$event:=FORM Event:C1606
	
	$form:=DATA_Handler(New object:C1471(\
		"action"; "init"))
	
	$context:=$form.ui
	$oTable:=$context.current
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//==================================================
	: ($event.objectName=$form.list)
		
		Case of 
				
				//______________________________________________________
			: ($event.code=On Getting Focus:K2:7)
				
				$context.listboxUI()
				
				//______________________________________________________
			: ($event.code=On Mouse Enter:K2:33)
				
				//______________________________________________________
			: ($event.code=On Losing Focus:K2:8)
				
				$context.listboxUI()
				
				$context.tables:=$context.tables
				
				//______________________________________________________
			: ($event.code=On Selection Change:K2:29)
				
				$context.lastIndex:=$context.index
				
				$context.current:=$context.tables[$context.index-Num:C11($context.index>0)]
				SET TIMER:C645(-1)
				
				//______________________________________________________
			: ($event.code=On Mouse Enter:K2:33)
				
				_o_UI.tips.enable()
				_o_UI.tips.instantly()
				
				//______________________________________________________
			: ($event.code=On Mouse Move:K2:35)
				
				GET MOUSE:C468($Lon_x; $Lon_y; $l)
				
				//$oInfos:=LISTBOX Get info at(*;$Obj_form.list;$Lon_x;$Lon_y).element
				LISTBOX GET CELL POSITION:C971(*; $event.objectName; $Lon_x; $Lon_y; $column; $row)
				
				If ($row#0)
					
					$o:=$context.tables[$row-1]
					
					If (Bool:C1537($o.embedded))\
						 & (Not:C34(Bool:C1537($o.filter.parameters)))\
						 & ((Bool:C1537($o.filter.validated))\
						 | (Length:C16(String:C10($o.filter.string))=0))
						
						If (Length:C16(String:C10($o.filter.string))=0)
							
							// No filter
							$tTip:=Get localized string:C991("allDataWillBeIntegratedIntoTheApplication")
							
						Else 
							
							$tTip:=Get localized string:C991("theFilteredDataWillBeIntegratedIntoTheApplication")
							
						End if 
						
					Else 
						
						If (Length:C16(String:C10($o.filter.string))>0)
							
							If (Bool:C1537($o.filter.validated))
								
								If (Bool:C1537($o.filter.parameters))
									
									// User filter
									$tTip:=Get localized string:C991("theDataWillBeFilteredAccordingToTheConnectedUserParameters")
									
								Else 
									
									$tTip:=Get localized string:C991("theFilteredDataWillBeLoadedIntoTheApplicationWhenConnecting")
									
								End if 
								
							Else 
								
								If (Length:C16(String:C10($o.filter.error))>0)
									
									// Return the error encountered
									$tTip:=Get localized string:C991("error:")+$o.filter.error
									
								Else 
									
									$tTip:=Get localized string:C991("notValidatedFilter")
									
								End if 
							End if 
							
						Else 
							
							$tTip:=Get localized string:C991("allDataWillBeLoadedIntoTheApplicationWhenConnecting")
							
						End if 
					End if 
				End if 
				
				OBJECT SET HELP TIP:C1181(*; $form.list; $tTip)
				
				//______________________________________________________
			: ($event.code=On Mouse Leave:K2:34)
				
				_o_UI.tips.defaultDelay()
				
				//______________________________________________________
			: (PROJECT.isLocked())
				
				// NOTHING MORE TO DO
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$event.description+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($event.objectName=$form.queryWidget)
		
		Case of 
				
				//______________________________________________________
			: ($event.code=On Load:K2:1)
				
				$t:=Document to text:C1236(Get 4D folder:C485(Current resources folder:K5:16)+"queryWidget.svg")
				
				PROCESS 4D TAGS:C816($t; $t; EDITOR.selectedFillColor; Get localized string:C991("fields"); Get localized string:C991("comparators"); Get localized string:C991("operators"); "🢓")
				
				OBJECT SET VALUE:C1742($event.objectName; cs:C1710.svg.new($t).picture())
				
				OBJECT SET VISIBLE:C603(*; $event.objectName; False:C215)
				
				//______________________________________________________
			: ($event.code=On Clicked:K2:4)
				
				$tID:=SVG Find element ID by coordinates:C1054(*; $event.objectName; MOUSEX; MOUSEY)
				
				$menu:=cs:C1710.menu.new()
				
				If (Length:C16($tID)#0)
					
					Case of 
							
							//……………………………………………………………………………………………………………………………
						: ($tID="fields")
							
							$o:=catalog("fields"; New object:C1471(\
								"tableName"; $oTable.name))
							
							If ($o.success)
								
								For each ($o; $o.fields)
									//For each ($o; $o.fields.orderBy("name asc"))
									
									$t:=$o.path
									
									If (Position:C15(" "; $t)>0)
										
										$menu.append($t; "'"+$t+"'")
										
									Else 
										
										$menu.append($t; $t)
										
									End if 
									
									If (EDITOR.isDark)
										
										$menu.icon("Images/dark/fieldsIcons/field_"+String:C10($o.typeLegacy; "00")+".png")
										
									Else 
										
										$menu.icon("Images/fieldsIcons/field_"+String:C10($o.typeLegacy; "00")+".png")
										
									End if 
								End for each 
							End if 
							
							//……………………………………………………………………………………………………………………………
						: ($tID="comparator")
							
							$menu.append(":xliff:equalTo"; "= ")
							$menu.append(":xliff:notEqualTo"; "!= ")
							$menu.line()
							
							$menu.append("IS"; "=== ")
							$menu.append("IS NOT"; "!== ")
							$menu.line()
							
							$menu.append(":xliff:lessThan"; "< ")
							$menu.append(":xliff:greaterThan"; "> ")
							$menu.line()
							
							$menu.append(":xliff:lessThanOrEqualTo"; "<= ")
							$menu.append(":xliff:greaterThanOrEqualTo"; ">= ")
							$menu.line()
							
							$menu.append(":xliff:containsKeyword"; "% ")
							
							//……………………………………………………………………………………………………………………………
						: ($tID="operator")
							
							$menu.append("AND"; "& ")
							$menu.append("OR"; "| ")
							$menu.line()
							
							$menu.append("NOT"; "NOT({sel})")
							$menu.line()
							
							$menu.append("(…)"; "NOT(({sel}))")
							
							//……………………………………………………………………………………………………………………………
					End case 
					
					$menu.popup()
					
					If ($menu.selected)
						
						GET HIGHLIGHT:C209(*; $form.filter; $start; $end)
						
						If ($oTable[""].filter.string#Null:C1517)
							
							$tSelection:=Substring:C12($oTable[""].filter.string; $start; $end-$start)
							
						End if 
						
						$bCaret:=(Position:C15("{sel}"; $menu.choice)>0)
						
						If ($bCaret)
							
							$menu.choice:=Replace string:C233($menu.choice; "{sel}"; $tSelection)
							
						End if 
						
						If ($start=$end)\
							 & ($start#1)
							
							If (String:C10($oTable.filter.string)[[$start-1]]#" ")\
								 & (String:C10($oTable.filter.string)[[$start-1]]#"(")
								
								$oTable.filter.string:=$oTable.filter.string+" "
								$start:=$start+1
								$end:=$end+1
								
							End if 
						End if 
						
						$oTable.filter.validated:=False:C215
						
						$o:=cs:C1710.str.new(String:C10($oTable.filter.string)).insert($menu.choice; $start; $end)
						$oTable.filter.string:=$o.value
						
						Form:C1466.dataModel[String:C10($oTable.tableNumber)][""].filter:=$oTable.filter
						
						If ($bCaret)\
							 & (Length:C16($tSelection)=0)
							
							// Put the carret into
							$o.begin:=$o.end-1
							$o.end:=$o.end-1
							
						End if 
						
						HIGHLIGHT TEXT:C210(*; $form.filter; $o.begin; $o.end)
						
						$form.filter:=$form.filter
						
						GOTO OBJECT:C206(*; $form.filter)
						
						PROJECT.save()
						$context.refresh()
						
					End if 
				End if 
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$event.description+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($event.objectName=$form.validate)\
		 | ($event.objectName=$form.enter)
		
		GOTO OBJECT:C206(*; $form.list)
		
		$o:=checkQueryFilter(New object:C1471(\
			"table"; $oTable.name; \
			"filter"; $oTable.filter))
		
		$oTable.filter:=$o.filter
		$oTable.count:=Num:C11($o.count)
		
		Form:C1466.dataModel[String:C10($oTable.tableNumber)][""].filter:=$oTable.filter
		
		PROJECT.save()
		$context.refresh()
		
		PROJECT.audit(New object:C1471("target"; New collection:C1472("filters")))
		EDITOR.updateRibbon()
		
		//==================================================
	: ($event.objectName=$form.embedded)
		
		If (Bool:C1537($oTable.embedded))
			
			Form:C1466.dataModel[String:C10($oTable.tableNumber)][""].embedded:=True:C214
			
		Else 
			
			OB REMOVE:C1226(Form:C1466.dataModel[String:C10($oTable.tableNumber)][""]; "embedded")
			
		End if 
		
		PROJECT.save()
		$context.update()
		
		//==================================================
	: ($event.objectName=$form.filter)
		
		Case of 
				
				//______________________________________________________
			: ($event.code=On Getting Focus:K2:7)
				
				If ($oTable.filter=Null:C1517)
					
					$oTable.filter:=New object:C1471(\
						"string"; "")
					
					$oTable.validated:=False:C215
					
				End if 
				
				// Keep current filter definition
				$context.currentFilter:=OB Copy:C1225($oTable.filter)
				
				$context.refresh()
				
				//______________________________________________________
			: ($event.code=On Losing Focus:K2:8)
				
				$context.refresh()
				
				//______________________________________________________
			: ($event.code=On Data Change:K2:15)
				
				If (Length:C16($t)>0)
					
					_o_UI.tips.instantly()
					OBJECT SET HELP TIP:C1181(*; $form.filter; Get localized string:C991("notValidatedFilter"))
					
				Else 
					
					_o_UI.tips.defaultDelay()
					OBJECT SET HELP TIP:C1181(*; $form.filter; "")
					
				End if 
				
				$context.refresh()
				
				//______________________________________________________
			: ($event.code=On After Edit:K2:43)
				
				$t:=Get edited text:C655
				
				$o:=Form:C1466.dataModel[String:C10($oTable.tableNumber)][""]
				
				If (Value type:C1509($o.filter)#Is object:K8:27)
					
					$o.filter:=New object:C1471
					
				End if 
				
				If (Length:C16($t)>0)
					
					$o.filter.string:=$t
					
					If ($t#$context.currentFilter.string)
						
						$o.filter.validated:=False:C215
						$o.filter.parameters:=False:C215
						OB REMOVE:C1226($o.filter; "error")
						
					Else 
						
						$o.filter.validated:=$context.currentFilter.validated
						$o.filter.parameters:=$context.currentFilter.parameters
						
						If ($context.currentFilter.error#Null:C1517)
							
							$o.filter.error:=$context.currentFilter.error
							$o.filter.errors:=$context.currentFilter.errors
							
						Else 
							
							OB REMOVE:C1226($o.filter; "error")
							
						End if 
					End if 
					
					$oTable.filter:=$o.filter
					
				Else 
					
					$oTable.filter.string:=""
					OB REMOVE:C1226($o; "filter")
					
				End if 
				
				PROJECT.save()
				$context.refresh()
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$event.description+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($event.objectName=$form.method)
		
		_o_SERVER_Handler(New object:C1471(\
			"action"; "editAuthenticationMethod"))
		
		//==================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown object: \""+$event.objectName+"\"")
		
		//==================================================
End case 

If (Bool:C1537(FEATURE._8858))
	
	PROJECT.save()
	
End if 

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End