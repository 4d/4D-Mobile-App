//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : FIELDS_OBJECTS_HANDLER
  // Database: 4D Mobile Express
  // ID[DE1DC030CB2B497BA1A42C0D39E7CE09]
  // Created 18-12-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($0)

C_LONGINT:C283($Lon_;$Lon_bottom;$Lon_column;$Lon_formEvent;$Lon_left;$Lon_parameters)
C_LONGINT:C283($Lon_right;$Lon_row;$Lon_top;$Lon_x;$Lon_y)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($t;$Txt_current;$Txt_me)
C_OBJECT:C1216($menu;$o;$Obj_context;$Obj_field;$Obj_form;$Obj_menu)
C_OBJECT:C1216($Obj_picker)
C_COLLECTION:C1488($c)

If (False:C215)
	C_LONGINT:C283(FIELDS_OBJECTS_HANDLER ;$0)
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
	
	$Obj_form:=FIELDS_Handler (New object:C1471(\
		"action";"init"))
	
	$Obj_context:=$Obj_form.$
	
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
			: ($Lon_formEvent=On Selection Change:K2:29)\
				 | ($Lon_formEvent=On Clicked:K2:4)
				
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
						
						$Obj_field:=FIELDS_Handler (New object:C1471(\
							"action";"field";\
							"row";$Lon_row))
						
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
			: (editor_Locked )\
				 | ($Lon_row=0)
				
				  // NOTHING MORE TO DO
				
				  //______________________________________________________
			: ($Lon_formEvent=On Double Clicked:K2:5)  // Edit current cell if any
				
				editor_ui_LISTBOX ($Txt_me)
				
				If ($Lon_column=$Obj_form.labelColumn)\
					 | ($Lon_column=$Obj_form.shortlabelColumn)
					
					EDIT ITEM:C870($Ptr_me->;$Ptr_me->)
					
				End if 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Before Data Entry:K2:39)
				
				If ($Lon_column=$Obj_form.formatColumn)
					
					$0:=-1
					
					  // Get the field definition [
					$Obj_field:=FIELDS_Handler (New object:C1471(\
						"action";"field";\
						"row";$Lon_row))
					
					$Obj_menu:=menu 
					
					If (Num:C11($Obj_field.id)#0)
						
						  // Get current format
						If ($Obj_field.format=Null:C1517)
							
							  // Default value
							$Txt_current:=commonValues.defaultFieldBindingTypes[$Obj_field.fieldType]
							
						Else 
							
							If (Value type:C1509($Obj_field.format)=Is object:K8:27)
								
								$Txt_current:=String:C10($Obj_field.format.name)
								
							Else 
								
								  // Internal
								$Txt_current:=$Obj_field.format
								
							End if 
						End if 
						
						For each ($o;formatters (New object:C1471(\
							"action";"getByType";\
							"type";$Obj_field.fieldType)).formatters)
							
							$t:=String:C10($o.name)
							
							If ($t="-")
								
								$Obj_menu.line()
								
							Else 
								
								$Obj_menu.append(str_localized (New collection:C1472("_"+$t));$t;$Txt_current=$t)
								
							End if 
						End for each 
						
						  // Append user formatters if any
						$c:=formatters (New object:C1471("action";"getByType";"host";True:C214;"type";Num:C11($Obj_field.fieldType))).formatters
						
						If ($c.length>0)
							
							$Obj_menu.line()
							
							For each ($o;$c)
								
								$Obj_menu.append($o.name;"/"+$o.name;$Txt_current=("/"+$o.name))
								
							End for each 
						End if 
						
					Else 
						
						If ($Obj_field.format=Null:C1517)
							
							  // Default value
							$Txt_current:="inline"
							
						Else 
							
							If (Value type:C1509($Obj_field.format)=Is object:K8:27)
								
								$Txt_current:=String:C10($Obj_field.format.name)
								
							Else 
								
								  // Internal
								$Txt_current:=$Obj_field.format
								
							End if 
						End if 
						
						$Obj_menu.append(".In line";"inline";$Txt_current="inline")
						$Obj_menu.append(".New page";"blank";$Txt_current="blank")
						
					End if 
					
					LISTBOX GET CELL COORDINATES:C1330(*;$Obj_form.fieldList;$Lon_column;$Lon_row;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
					CONVERT COORDINATES:C1365($Lon_left;$Lon_bottom;XY Current form:K27:5;XY Current window:K27:6)
					$Obj_menu.popup("";$Lon_left;$Lon_bottom)
					
					If ($Obj_menu.selected)
						
						  // Update data model
						$Obj_field.format:=$Obj_menu.choice
						
						  // Update me
						  //%W-533.1
						If ($Obj_menu.choice[[1]]="/")
							  //%W+533.1
							
							  // User resources
							$Ptr_me->{$Lon_row}:=Substring:C12($Obj_menu.choice;2)
							
						Else 
							
							$Ptr_me->{$Lon_row}:=str_localized (New collection:C1472("_"+$Obj_menu.choice))
							
						End if 
					End if 
					
					GOTO OBJECT:C206(*;$Obj_form.fieldList)
					LISTBOX SELECT ROW:C912(*;$Obj_form.fieldList;$Lon_row;lk replace selection:K53:1)
					
					editor_ui_LISTBOX ($Obj_form.fieldList)
					
				End if 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Data Change:K2:15)
				
				  // Update data model
				If ($Lon_column=$Obj_form.labelColumn)\
					 | ($Lon_column=$Obj_form.shortlabelColumn)
					
					$Obj_field:=FIELDS_Handler (New object:C1471(\
						"action";"field";\
						"row";$Lon_row))
					
					$Obj_field[Choose:C955($Lon_column=$Obj_form.labelColumn;"label";"shortLabel")]:=$Ptr_me->{$Lon_row}
					
				End if 
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Txt_me=$Obj_form.filter.name)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Clicked:K2:4)
				
				$menu:=menu 
				$menu.append(":xliff:fieldsAndRelations";"0";$Obj_context.selector=0)
				$menu.append(":xliff:fieldsOnly";"1";$Obj_context.selector=1)
				$menu.append(":xliff:relationOnly";"2";$Obj_context.selector=2)
				
				If ($menu.popup("";$Obj_form.filter.getCoordinates()).selected)
					
					$Obj_context.selector:=Num:C11($menu.choice)
					$Obj_context.refresh()
					
				End if 
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown object: \""+$Txt_me+"\"")
		
		  //==================================================
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End