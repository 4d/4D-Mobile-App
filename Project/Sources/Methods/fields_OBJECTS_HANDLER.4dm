//%attributes = {"invisible":true}
/*
Long Integer := ***fields_OBJECTS_HANDLER***
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : fields_OBJECTS_HANDLER
  // Database: 4D Mobile Express
  // ID[DE1DC030CB2B497BA1A42C0D39E7CE09]
  // Created #18-12-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($0)

C_LONGINT:C283($Lon_;$Lon_bottom;$Lon_column;$Lon_formEvent;$Lon_left;$Lon_parameters)
C_LONGINT:C283($Lon_right;$Lon_row;$Lon_top;$Lon_x;$Lon_y)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Mnu_choice;$Mnu_pop;$Txt_;$Txt_current;$Txt_me)
C_OBJECT:C1216($Obj_buffer;$Obj_context;$Obj_field;$Obj_form;$Obj_picker)
C_COLLECTION:C1488($Col_buffer)

If (False:C215)
	C_LONGINT:C283(fields_OBJECTS_HANDLER ;$0)
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
	
	$Lon_formEvent:=Form event:C388
	$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
	$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)
	
	$Obj_form:=fields_Handler (New object:C1471("action";"init"))
	
	$Obj_context:=$Obj_form.form
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($Txt_me=$Obj_form.fieldList)
		
		LISTBOX GET CELL POSITION:C971(*;$Txt_me;$Lon_column;$Lon_row)
		
		Case of 
				  //______________________________________________________
			: ($Lon_formEvent=On Selection Change:K2:29) | ($Lon_formEvent=On Clicked:K2:4)
				
				editor_ui_LISTBOX ($Txt_me)
				
				Case of 
						  //______________________________________________________
					: ($Lon_formEvent=On Selection Change:K2:29)
						
						  // <NOTHING MORE TO DO>
						  //______________________________________________________
					: (editor_Locked )
						
						  // <NOTHING MORE TO DO>
						
						  //______________________________________________________
					: ($Lon_row=0)
						
						  // NO SELECTION
						
						  //______________________________________________________
					: ($Lon_column=$Obj_form.iconColumn)  // Open the fields icons picker
						
						LISTBOX GET CELL COORDINATES:C1330(*;$Obj_form.fieldList;$Lon_column;$Lon_row;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
						
						$Obj_picker:=(ui.pointer($Obj_form.iconGrid))->
						
						$Obj_field:=fields_Handler (New object:C1471("action";"field";"row";$Lon_row))
						
						If ($Obj_field.icon#Null:C1517)
							
							$Obj_picker.item:=$Obj_picker.pathnames.indexOf($Obj_field.icon)
							$Obj_picker.item:=$Obj_picker.item+1  // Widget work with array
							
						Else 
							
							$Obj_picker.item:=1
							
						End if 
						
						$Obj_picker.row:=$Lon_row
						
						$Obj_picker.left:=$Lon_right
						$Obj_picker.top:=-56  //$Lon_bottom+2
						
						$Obj_picker.action:="fieldIcons"
						$Obj_picker.background:=0x00FFFFFF
						$Obj_picker.backgroundStroke:=ui.strokeColor
						$Obj_picker.promptColor:=0x00FFFFFF
						$Obj_picker.promptBackColor:=ui.strokeColor
						$Obj_picker.hidePromptSeparator:=True:C214
						$Obj_picker.forceRedraw:=True:C214
						$Obj_picker.prompt:=str_localized (New collection:C1472("chooseAnIconForTheField";(ui.pointer($Obj_form.fields))->{$Lon_row}))
						
						  // Display selector
						CALL FORM:C1391($Obj_form.window;"editor_CALLBACK";"pickerShow";$Obj_picker)
						
						  //______________________________________________________
					Else 
						
						  //
						
						  //______________________________________________________
				End case 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Mouse Enter:K2:33)
				
				ui.tips.enable()
				ui.tips.instantly()
				
				  //______________________________________________________
			: ($Lon_formEvent=On Mouse Move:K2:35)
				
				GET MOUSE:C468($Lon_x;$Lon_y;$Lon_)
				LISTBOX GET CELL POSITION:C971(*;$Txt_me;$Lon_x;$Lon_y;$Lon_column;$Lon_row)
				
				Case of 
						
						  //………………………………………………………………………………;
					: ($Lon_row=0)
						
						  //______________________________________________________
					: ($Lon_column=$Obj_form.iconColumn)
						
						OBJECT SET HELP TIP:C1181(*;$Txt_me;Get localized string:C991("clickToSet"))
						
						  //………………………………………………………………………………
					: ($Lon_column=$Obj_form.shortlabelColumn)
						
						OBJECT SET HELP TIP:C1181(*;$Txt_me;Get localized string:C991("doubleClickToEdit")+"\r"+Get localized string:C991("shouldBe10CharOrLess"))
						
						  //………………………………………………………………………………
					: ($Lon_column=$Obj_form.labelColumn)
						
						OBJECT SET HELP TIP:C1181(*;$Txt_me;Get localized string:C991("doubleClickToEdit")+"\r"+Get localized string:C991("shouldBe25CharOrLess"))
						
						  //______________________________________________________
					Else 
						
						OBJECT SET HELP TIP:C1181(*;$Txt_me;"")
						
						  //______________________________________________________
				End case 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Mouse Leave:K2:34)
				
				ui.tips.defaultDelay()
				
				  //______________________________________________________
			: ($Lon_formEvent=On Getting Focus:K2:7)
				
				editor_ui_LISTBOX ($Txt_me;True:C214)
				
				  //______________________________________________________
			: ($Lon_formEvent=On Losing Focus:K2:8)
				
				editor_ui_LISTBOX ($Txt_me;False:C215)
				
				  //______________________________________________________
			: (editor_Locked ) | ($Lon_row=0)
				
				  // NOTHING MORE TO DO
				
				  //______________________________________________________
			: ($Lon_formEvent=On Double Clicked:K2:5)  // Edit current cell if any
				
				editor_ui_LISTBOX ($Txt_me)
				
				  //If ($Lon_row#0)
				
				If ($Lon_column=$Obj_form.labelColumn) | ($Lon_column=$Obj_form.shortlabelColumn)
					
					EDIT ITEM:C870($Ptr_me->;$Ptr_me->)
					
				End if 
				  //End if 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Before Data Entry:K2:39)
				
				If ($Lon_column=$Obj_form.formatColumn)
					
					$0:=-1
					
					$Mnu_pop:=Create menu:C408
					
					  // Get the field definition [
					$Obj_field:=fields_Handler (New object:C1471("action";"field";"row";$Lon_row))
					
					  // Get current format
					If ($Obj_field.format=Null:C1517)
						
						  // Default value
						If (Bool:C1537(featuresFlags.withNewFieldProperties))
							
							$Txt_current:=commonValues.defaultFieldBindingTypes[$Obj_field.fieldType]
							
						Else 
							
							$Txt_current:=commonValues.defaultFieldBindingTypes[$Obj_field.type]
							
						End if 
						
					Else 
						
						If (Value type:C1509($Obj_field.format)=Is object:K8:27)
							
							$Txt_current:=String:C10($Obj_field.format.name)
							
						Else 
							
							  // Internal
							$Txt_current:=$Obj_field.format
							
						End if 
					End if 
					
					For each ($Obj_buffer;formatters (New object:C1471("action";"getByType";"type";Choose:C955(Bool:C1537(featuresFlags.withNewFieldProperties);$Obj_field.fieldType;$Obj_field.type))).formatters)
						
						$Txt_:=String:C10($Obj_buffer.name)
						
						If ($Txt_="-")
							
							APPEND MENU ITEM:C411($Mnu_pop;"-")
							
						Else 
							
							APPEND MENU ITEM:C411($Mnu_pop;str_localized (New collection:C1472("_"+$Txt_)))
							SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;$Txt_)
							SET MENU ITEM MARK:C208($Mnu_pop;-1;ui.checkMark*Num:C11($Txt_=$Txt_current))
							
						End if 
					End for each 
					
					  //If (Bool(featuresFlags._100990))
					
					  // Append user formatters if any {
					$Col_buffer:=formatters (New object:C1471("action";"getByType";"host";True:C214;"type";Num:C11(Choose:C955(Bool:C1537(featuresFlags.withNewFieldProperties);$Obj_field.fieldType;$Obj_field.type)))).formatters
					
					If ($Col_buffer.length>0)
						
						APPEND MENU ITEM:C411($Mnu_pop;"-")
						
						For each ($Obj_buffer;$Col_buffer)
							
							APPEND MENU ITEM:C411($Mnu_pop;$Obj_buffer.name)
							SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"/"+$Obj_buffer.name)
							SET MENU ITEM MARK:C208($Mnu_pop;-1;ui.checkMark*Num:C11($Txt_current=("/"+$Obj_buffer.name)))
							
						End for each 
					End if 
					  //}
					
					  //End if 
					
					$Mnu_choice:=ui_listboxPopUp ($Obj_form.fieldList;$Mnu_pop;$Lon_column;$Lon_row)
					
					If (Length:C16($Mnu_choice)#0)
						
						  // Update data model
						$Obj_field.format:=$Mnu_choice
						
						  // Update me
						If ($Mnu_choice[[1]]="/")
							
							  // User resources
							$Ptr_me->{$Lon_row}:=Substring:C12($Mnu_choice;2)
							
						Else 
							
							$Ptr_me->{$Lon_row}:=str_localized (New collection:C1472("_"+$Mnu_choice))
							
						End if 
					End if 
					
					GOTO OBJECT:C206(*;$Obj_form.fieldList)
					LISTBOX SELECT ROW:C912(*;$Obj_form.fieldList;$Lon_row;lk replace selection:K53:1)
					
					editor_ui_LISTBOX ($Obj_form.fieldList)
					
				End if 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Data Change:K2:15)
				
				  // Update data model
				If ($Lon_column=$Obj_form.labelColumn) | ($Lon_column=$Obj_form.shortlabelColumn)
					
					$Obj_field:=fields_Handler (New object:C1471("action";"field";"row";$Lon_row))
					
					$Obj_field[Choose:C955($Lon_column=$Obj_form.labelColumn;"label";"shortLabel")]:=$Ptr_me->{$Lon_row}
					
				End if 
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
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