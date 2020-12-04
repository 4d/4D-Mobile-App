//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : tables_OBJECTS_HANDLER
// ID[F5BAADC99D82486388C2435DEE82B078]
// Created 30-10-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($Lon_; $Lon_bottom; $Lon_column; $Lon_formEvent; $Lon_left; $Lon_parameters)
C_LONGINT:C283($Lon_right; $Lon_row; $Lon_top; $Lon_x; $Lon_y)
C_POINTER:C301($Ptr_ids; $Ptr_me)
C_TEXT:C284($Txt_me)
C_OBJECT:C1216($Obj_context; $Obj_form; $Obj_picker)

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	
	// Optional parameters
	If ($Lon_parameters>=1)
		
		// <NONE>
		
	End if 
	
	$Lon_formEvent:=Form event code:C388
	$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
	$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)
	
	$Obj_form:=tables_Handler(New object:C1471(\
		"action"; "init"))
	
	$Obj_context:=$Obj_form.form
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//==================================================
	: ($Txt_me=$Obj_form.tableList)
		
		LISTBOX GET CELL POSITION:C971(*; $Txt_me; $Lon_column; $Lon_row)
		
		Case of 
				
				//______________________________________________________
			: ($Lon_formEvent=On Selection Change:K2:29)\
				 | ($Lon_formEvent=On Clicked:K2:4)
				
				$Ptr_ids:=UI.pointer($Obj_form.ids)
				
				$Obj_context.currentTableNumber:=Num:C11($Ptr_ids->{$Lon_row})
				
				If ($Obj_context.currentTableNumber>0)
					
					// Keep the table definition
					$Obj_context.currentTable:=Form:C1466.dataModel[$Ptr_ids->{$Lon_row}]
					
				End if 
				
				If ($Lon_formEvent=On Clicked:K2:4)
					
					If ($Lon_row=0)
						
						OB REMOVE:C1226($Obj_context; "currentTable")
						
						// 🚨 CLICKING ON THE ADDED COLUMN DOES NOT DESELECT THE ROW.
						LISTBOX SELECT ROW:C912(*; $Txt_me; 0; lk replace selection:K53:1)
						
						var $ptr : Pointer
						$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; $Txt_me)
						
						var $i : Integer
						For ($i; 1; LISTBOX Get number of rows:C915(*; $Txt_me); 1)
							
							$ptr->{$i}:=False:C215
							
						End for 
						
					Else 
						
						If ($Lon_column=$Obj_form.iconColumn)\
							 & (Not:C34(editor_Locked))
							
							LISTBOX GET CELL COORDINATES:C1330(*; $Obj_form.tableList; $Lon_column; $Lon_row; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
							
							$Obj_picker:=(UI.pointer($Obj_form.iconGrid))->
							
							$Obj_picker.item:=$Obj_picker.pathnames.indexOf($Obj_context.currentTable.icon)
							
							//============================================================
							$Obj_picker.item:=$Obj_picker.item+1  // Widget work with array
							
							//============================================================
							
							$Obj_picker.row:=$Lon_row
							
							$Obj_picker.left:=$Lon_right
							$Obj_picker.top:=-56
							
							$Obj_picker.action:="tableIcons"
							$Obj_picker.background:=0x00FFFFFF
							$Obj_picker.backgroundStroke:=UI.strokeColor
							$Obj_picker.promptColor:=0x00FFFFFF
							$Obj_picker.promptBackColor:=UI.strokeColor
							$Obj_picker.hidePromptSeparator:=True:C214
							$Obj_picker.forceRedraw:=True:C214
							$Obj_picker.prompt:=_o_str.setText("chooseAnIconForTheTable").localized((UI.pointer($Obj_form.tables))->{$Lon_row})
							
							// Display selector
							CALL FORM:C1391($Obj_form.window; "editor_CALLBACK"; "pickerShow"; $Obj_picker)
							
						End if 
					End if 
					
					// Update field properties panel
					CALL FORM:C1391($Obj_form.window; "editor_CALLBACK"; "fieldProperties")
					
				End if 
				
				editor_ui_LISTBOX($Txt_me)
				
				//______________________________________________________
			: ($Lon_formEvent=On Mouse Enter:K2:33)
				
				UI.tips.enable()
				UI.tips.instantly()
				
				//______________________________________________________
			: ($Lon_formEvent=On Mouse Move:K2:35)
				
				GET MOUSE:C468($Lon_x; $Lon_y; $Lon_)
				LISTBOX GET CELL POSITION:C971(*; $Txt_me; $Lon_x; $Lon_y; $Lon_column; $Lon_row)
				
				Case of 
						
						//………………………………………………………………………………
					: ($Lon_row=0)
						
						OBJECT SET HELP TIP:C1181(*; $Txt_me; "")
						
						//………………………………………………………………………………
					: ($Lon_column=$Obj_form.iconColumn)
						
						OBJECT SET HELP TIP:C1181(*; $Txt_me; Get localized string:C991("clickToSet"))
						
						//………………………………………………………………………………
					: ($Lon_column=$Obj_form.shortlabelColumn)
						
						OBJECT SET HELP TIP:C1181(*; $Txt_me; Get localized string:C991("doubleClickToEdit")+"\r"+Get localized string:C991("shouldBe10CharOrLess"))
						
						//………………………………………………………………………………
					: ($Lon_column=$Obj_form.labelColumn)
						
						OBJECT SET HELP TIP:C1181(*; $Txt_me; Get localized string:C991("doubleClickToEdit")+"\r"+Get localized string:C991("shouldBe25CharOrLess"))
						
						//………………………………………………………………………………
					Else 
						
						OBJECT SET HELP TIP:C1181(*; $Txt_me; "")
						
						//………………………………………………………………………………
				End case 
				
				//______________________________________________________
			: ($Lon_formEvent=On Mouse Leave:K2:34)
				
				UI.tips.defaultDelay()
				
				//______________________________________________________
			: ($Lon_formEvent=On Getting Focus:K2:7)
				
				editor_ui_LISTBOX($Txt_me; True:C214)
				
				//______________________________________________________
			: ($Lon_formEvent=On Losing Focus:K2:8)
				
				editor_ui_LISTBOX($Txt_me; False:C215)
				
				//______________________________________________________
			: (editor_Locked)
				
				// NOTHING MORE TO DO
				
				//______________________________________________________
			: ($Lon_formEvent=On Double Clicked:K2:5)
				
				If ($Lon_row#0)
					
					If ($Lon_column=$Obj_form.labelColumn)\
						 | ($Lon_column=$Obj_form.shortlabelColumn)
						
						EDIT ITEM:C870($Ptr_me->; $Ptr_me->)
						
					End if 
				End if 
				
				//______________________________________________________
			: ($Lon_formEvent=On Data Change:K2:15)
				
				// Update data model
				If ($Ptr_me=UI.pointer($Obj_form.labels))\
					 | ($Ptr_me=UI.pointer($Obj_form.shortLabels))
					
					$Ptr_ids:=UI.pointer($Obj_form.ids)
					
					If ($Ptr_me=UI.pointer($Obj_form.labels))
						
						$Obj_context.currentTable[""].label:=$Ptr_me->{$Lon_row}
						
					Else 
						
						$Obj_context.currentTable[""].shortLabel:=$Ptr_me->{$Lon_row}
						
					End if 
				End if 
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown object: \""+$Txt_me+"\"")
		
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