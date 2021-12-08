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
var $selected; $t; $tID : Text
var $withInsertion : Boolean
var $column; $end; $l; $Lon_x; $Lon_y; $row : Integer
var $start : Integer
var $context; $e; $form; $o; $table : Object
var $menu : cs:C1710.menu
var $str : cs:C1710.str

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=0; "Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	
	// Optional parameters
	If (Count parameters:C259>=1)
		
		// <NONE>
		
	End if 
	
	$e:=FORM Event:C1606
	
	$form:=DATA_Handler(New object:C1471(\
		"action"; "init"))
	
	$context:=$form.ui
	$table:=$context.current
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//==================================================
	: ($e.objectName=$form.list)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Getting Focus:K2:7)
				
				$context.listboxUI()
				
				//______________________________________________________
			: ($e.code=On Mouse Enter:K2:33)
				
				//______________________________________________________
			: ($e.code=On Losing Focus:K2:8)
				
				$context.listboxUI()
				
				$context.tables:=$context.tables
				
				//______________________________________________________
			: ($e.code=On Selection Change:K2:29)
				
				$context.lastIndex:=$context.index
				
				$context.current:=$context.tables[$context.index-Num:C11($context.index>0)]
				SET TIMER:C645(-1)
				
				//______________________________________________________
			: ($e.code=On Mouse Enter:K2:33) & Not:C34(FEATURE.with("cancelableDatasetGeneration"))
				
				_o_UI.tips.enable()
				_o_UI.tips.instantly()
				
				//______________________________________________________
			: ($e.code=On Mouse Move:K2:35) & Not:C34(FEATURE.with("cancelableDatasetGeneration"))
				
				GET MOUSE:C468($Lon_x; $Lon_y; $l)
				
				//$oInfos:=LISTBOX Get info at(*;$Obj_form.list;$Lon_x;$Lon_y).element
				LISTBOX GET CELL POSITION:C971(*; $e.objectName; $Lon_x; $Lon_y; $column; $row)
				
				If ($row#0)
					
					$o:=$context.tables[$row-1]
					
					If (Bool:C1537($o.embedded))\
						 & (Not:C34(Bool:C1537($o.filter.parameters)))\
						 & ((Bool:C1537($o.filter.validated))\
						 | (Length:C16(String:C10($o.filter.string))=0))
						
						If (Length:C16(String:C10($o.filter.string))=0)
							
							// No filter
							$t:=Get localized string:C991("allDataEmbedded")
							
						Else 
							
							$t:=Get localized string:C991("dataEmbedded")
							
						End if 
						
					Else 
						
						If (Length:C16(String:C10($o.filter.string))>0)
							
							If (Bool:C1537($o.filter.validated))
								
								If (Bool:C1537($o.filter.parameters))
									
									// User filter
									$t:=Get localized string:C991("dataFilteringByUser")
									
								Else 
									
									$t:=Get localized string:C991("dataLoaded")
									
								End if 
								
							Else 
								
								If (Length:C16(String:C10($o.filter.error))>0)
									
									// Return the error encountered
									$t:=Get localized string:C991("error:")+$o.filter.error
									
								Else 
									
									$t:=Get localized string:C991("notValidatedFilter")
									
								End if 
							End if 
							
						Else 
							
							$t:=Get localized string:C991("allDataLoaded")
							
						End if 
					End if 
				End if 
				
				OBJECT SET HELP TIP:C1181(*; $form.list; $t)
				
				//______________________________________________________
			: ($e.code=On Mouse Leave:K2:34) & Not:C34(FEATURE.with("cancelableDatasetGeneration"))
				
				_o_UI.tips.defaultDelay()
				
				//______________________________________________________
			: (PROJECT.isLocked())
				
				// NOTHING MORE TO DO
				
				//______________________________________________________
			: (FEATURE.with("cancelableDatasetGeneration"))
				
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($e.objectName=$form.queryWidget)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Load:K2:1)
				
				$t:=Document to text:C1236(Get 4D folder:C485(Current resources folder:K5:16)+"queryWidget.svg")
				
				PROCESS 4D TAGS:C816($t; $t; EDITOR.selectedFillColor; Get localized string:C991("fields"); Get localized string:C991("comparators"); Get localized string:C991("operators"); "🢓")
				
				OBJECT SET VALUE:C1742($e.objectName; cs:C1710.svg.new($t).picture())
				OBJECT SET VISIBLE:C603(*; $e.objectName; False:C215)
				
				//______________________________________________________
			: ($e.code=On Clicked:K2:4)
				
				$tID:=SVG Find element ID by coordinates:C1054(*; $e.objectName; MOUSEX; MOUSEY)
				
				$menu:=cs:C1710.menu.new()
				
				If (Length:C16($tID)#0)
					
					Case of 
							
							//……………………………………………………………………………………………………………………………
						: ($tID="fields")
							
							$o:=catalog("fields"; New object:C1471(\
								"tableName"; $table.name))
							
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
						
						If ($table[""].filter.string#Null:C1517)
							
							$selected:=Substring:C12($table[""].filter.string; $start; $end-$start)
							
						End if 
						
						$withInsertion:=(Position:C15("{sel}"; $menu.choice)>0)
						
						If ($withInsertion)
							
							$menu.choice:=Replace string:C233($menu.choice; "{sel}"; $selected)
							
						End if 
						
						If ($start=$end)\
							 & ($start#1)
							
							If (String:C10($table.filter.string)[[$start-1]]#" ")\
								 & (String:C10($table.filter.string)[[$start-1]]#"(")
								
								$table.filter.string:=$table.filter.string+" "
								$start:=$start+1
								$end:=$end+1
								
							End if 
						End if 
						
						$table.filter.validated:=False:C215
						
						$str:=EDITOR.str.setText(String:C10($table.filter.string)).insert($menu.choice; $start; $end)
						$table.filter.string:=$str.value
						
						Form:C1466.dataModel[String:C10($table.tableNumber)][""].filter:=$table.filter
						
						If ($withInsertion)\
							 & (Length:C16($selected)=0)
							
							// Put the carret into
							$str.begin:=$str.end-1
							$str.end:=$str.end-1
							
						End if 
						
						HIGHLIGHT TEXT:C210(*; $form.filter; $str.begin; $str.end)
						
						$form.filter:=$form.filter
						
						GOTO OBJECT:C206(*; $form.filter)
						
						PROJECT.save()
						$context.refresh()
						
					End if 
				End if 
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($e.objectName=$form.validate)\
		 | ($e.objectName=$form.enter)
		
		GOTO OBJECT:C206(*; $form.list)
		
		If (PROJECT.dataSource.source="server")
			
			PROJECT.checkRestQueryFilter($table)
			
		Else 
			
			PROJECT.checkLocalQueryFilter($table)
			
		End if 
		
		// Mark: check if necessary
		PROJECT.save()
		
		$context.refresh()
		
		PROJECT.audit(New object:C1471("target"; New collection:C1472("filters")))
		
		EDITOR.updateRibbon()
		
		//==================================================
	: ($e.objectName=$form.embedded)
		
		If (Bool:C1537($table.embedded))
			
			Form:C1466.dataModel[String:C10($table.tableNumber)][""].embedded:=True:C214
			
		Else 
			
			OB REMOVE:C1226(Form:C1466.dataModel[String:C10($table.tableNumber)][""]; "embedded")
			
		End if 
		
		PROJECT.save()
		$context.update()
		
		//==================================================
	: ($e.objectName=$form.filter)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Getting Focus:K2:7)
				
				If ($table.filter=Null:C1517)
					
					$table.filter:=New object:C1471(\
						"string"; "")
					
					$table.validated:=False:C215
					
				End if 
				
				// Keep current filter definition
				$context.currentFilter:=OB Copy:C1225($table.filter)
				
				$context.refresh()
				
				//______________________________________________________
			: ($e.code=On Losing Focus:K2:8)
				
				$context.refresh()
				
				//______________________________________________________
			: ($e.code=On Data Change:K2:15)
				
				If (Not:C34(FEATURE.with("cancelableDatasetGeneration")))
					
					If (Length:C16($t)>0)
						
						_o_UI.tips.instantly()
						OBJECT SET HELP TIP:C1181(*; $form.filter; Get localized string:C991("notValidatedFilter"))
						
					Else 
						
						_o_UI.tips.defaultDelay()
						OBJECT SET HELP TIP:C1181(*; $form.filter; "")
						
					End if 
				End if 
				
				$context.refresh()
				
				//______________________________________________________
			: ($e.code=On After Edit:K2:43)
				
				$t:=Get edited text:C655
				
				$o:=Form:C1466.dataModel[String:C10($table.tableNumber)][""]
				
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
					
					$table.filter:=$o.filter
					
				Else 
					
					$table.filter.string:=""
					OB REMOVE:C1226($o; "filter")
					
				End if 
				
				PROJECT.save()
				$context.refresh()
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($e.objectName=$form.method)
		
		_o_SERVER_Handler(New object:C1471(\
			"action"; "editAuthenticationMethod"))
		
		//==================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown object: \""+$e.objectName+"\"")
		
		//==================================================
End case 