//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : FIELDS_OBJECTS_HANDLER
  // ID[DE1DC030CB2B497BA1A42C0D39E7CE09]
  // Created 18-12-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($0)

C_POINTER:C301($Ptr_me)
C_TEXT:C284($t;$Txt_current)
C_OBJECT:C1216($o;$Obj_context;$Obj_field;$Obj_form;$Obj_popup;$Obj_widget)
C_COLLECTION:C1488($c)

If (False:C215)
	C_LONGINT:C283(FIELDS_OBJECTS_HANDLER ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations

  // NO PARAMETERS REQUIRED

$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)

$Obj_form:=FIELDS_class ("editor_CALLBACK")

$Obj_context:=$Obj_form.$

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($Obj_form.form.current=$Obj_form.fieldList.name)
		
		$Obj_widget:=$Obj_form.fieldList.update()
		
		Case of 
				
				  //______________________________________________________
			: ($Obj_form.form.eventCode=On Selection Change:K2:29)\
				 | ($Obj_form.form.eventCode=On Clicked:K2:4)
				
				editor_ui_LISTBOX ($Obj_widget.name)
				
				Case of 
						
						  //______________________________________________________
					: ($Obj_form.form.eventCode=On Selection Change:K2:29)
						
						  // <NOTHING MORE TO DO>
						
						  //______________________________________________________
					: (editor_Locked )
						
						  // <NOTHING MORE TO DO>
						
						  //______________________________________________________
					: ($Obj_widget.row=0)
						
						  // NO SELECTION
						
						  //______________________________________________________
					: ($Obj_widget.column=$Obj_widget.columns[$Obj_form.icons.name].number)  // Open the fields icons picker
						
						  // Get the current field
						$Obj_widget.cellCoordinates()
						
						  // Get the field definition
						$Obj_field:=$Obj_context.field($Obj_widget.row)
						
						  // Display the picker
						$o:=$Obj_form.picker.pointer()->
						
						  // #MARK_TODO WIDGET WORK WITH ARRAY
						If ($Obj_field.icon#Null:C1517)
							
							$o.item:=$o.pathnames.indexOf($Obj_field.icon)
							$o.item:=$o.item+1
							
						Else 
							
							$o.item:=1
							
						End if 
						
						$o.row:=$Obj_widget.row
						$o.left:=$Obj_widget.cellBox.right
						$o.top:=-56  //$Lon_bottom+2
						$o.action:="fieldIcons"
						$o.background:=0x00FFFFFF
						$o.backgroundStroke:=ui.strokeColor
						$o.promptColor:=0x00FFFFFF
						$o.promptBackColor:=ui.strokeColor
						$o.hidePromptSeparator:=True:C214
						$o.forceRedraw:=True:C214
						$o.prompt:=str ("chooseAnIconForTheField").localized($Obj_field.name)
						
						$Obj_context.showPicker($o)
						
						  //______________________________________________________
				End case 
				
				  //______________________________________________________
			: ($Obj_form.form.eventCode=On Mouse Enter:K2:33)
				
				ui.tips.instantly()
				
				  //______________________________________________________
			: ($Obj_form.form.eventCode=On Mouse Move:K2:35)
				
				$Obj_context.setHelpTip($Obj_widget.name;$Obj_form)
				
				  //______________________________________________________
			: ($Obj_form.form.eventCode=On Mouse Leave:K2:34)
				
				ui.tips.default()
				
				  //______________________________________________________
			: ($Obj_form.form.eventCode=On Getting Focus:K2:7)
				
				editor_ui_LISTBOX ($Obj_widget.name;True:C214)
				
				$Obj_context.setHelpTip($Obj_widget.name;$Obj_form)
				
				  //______________________________________________________
			: ($Obj_form.form.eventCode=On Losing Focus:K2:8)
				
				editor_ui_LISTBOX ($Obj_widget.name;False:C215)
				
				  //______________________________________________________
			: (editor_Locked )\
				 | ($Obj_widget.row=0)
				
				  // NOTHING MORE TO DO
				
				  //______________________________________________________
			: ($Obj_form.form.eventCode=On Double Clicked:K2:5)  // Edit current cell if any
				
				editor_ui_LISTBOX ($Obj_widget.name)
				
				If ($Obj_widget.column=$Obj_widget.columns[$Obj_form.labels.name].number)\
					 | ($Obj_widget.column=$Obj_widget.columns[$Obj_form.shortLabels.name].number)\
					 | ($Obj_widget.column=$Obj_widget.columns[$Obj_form.titles.name].number)
					
					EDIT ITEM:C870($Ptr_me->;$Ptr_me->)
					
				End if 
				
				  //______________________________________________________
			: ($Obj_form.form.eventCode=On Before Data Entry:K2:39)
				
				If ($Obj_widget.column=$Obj_widget.columns[$Obj_form.formats.name].number)
					
					$0:=-1
					
					  // Get the field definition
					$Obj_field:=$Obj_context.field($Obj_widget.row)
					
					$Obj_popup:=menu 
					
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
							
							$Obj_popup.line()
							
						Else 
							
							$Obj_popup.append(str ("_"+$t).localized();$t;$Txt_current=$t)
							
						End if 
					End for each 
					
					  // Append user formatters if any
					$c:=formatters (New object:C1471("action";"getByType";"host";True:C214;"type";Num:C11($Obj_field.fieldType))).formatters
					
					If ($c.length>0)
						
						$Obj_popup.line()
						
						For each ($o;$c)
							
							$Obj_popup.append($o.name;"/"+$o.name;$Txt_current=("/"+$o.name))
							
						End for each 
					End if 
					
					If ($Obj_widget.popup($Obj_popup).selected)
						
						  // Update data model
						$Obj_field.format:=$Obj_popup.choice
						
						  //%W-533.3
						  //%W-533.1
						  // Update me
						If ($Obj_popup.choice[[1]]="/")
							  //%W+533.1
							
							  // User resources
							$Ptr_me->{$Obj_widget.row}:=Substring:C12($Obj_popup.choice;2)
							
						Else 
							
							$Ptr_me->{$Obj_widget.row}:=str ("_"+$Obj_popup.choice).localized()
							
						End if 
						  //%W+533.3
						
						project.save()
						
					End if 
					
					$Obj_widget.focus()
					$Obj_widget.select($Obj_widget.row)
					
					editor_ui_LISTBOX ($Obj_widget.name)
					
				End if 
				
				$Obj_context.inEdition:=$Obj_widget
				
				  //______________________________________________________
			: ($Obj_form.form.eventCode=On Data Change:K2:15)
				
				  // Get the edited field definition
				$Obj_field:=$Obj_context.field($Obj_context.inEdition.row)
				
				  // Update data model
				Case of 
						
						  //………………………………………………………………………………………
					: ($Ptr_me=$Obj_widget.columns[$Obj_form.titles.name].pointer)
						
						  //%W-533.3
						$Obj_field.format:=$Ptr_me->{$Obj_context.inEdition.row}
						  //%W+533.3
						
						  //………………………………………………………………………………………
					: ($Ptr_me=$Obj_widget.columns[$Obj_form.labels.name].pointer)
						
						  //%W-533.3
						$Obj_field.label:=$Ptr_me->{$Obj_context.inEdition.row}
						  //%W+533.3
						
						  //………………………………………………………………………………………
					: ($Ptr_me=$Obj_widget.columns[$Obj_form.shortLabels.name].pointer)
						
						  //%W-533.3
						$Obj_field.shortLabel:=$Ptr_me->{$Obj_context.inEdition.row}
						  //%W+533.3
						
						  //______________________________________________________
				End case 
				
				project.save()
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Obj_form.form.eventCode)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Obj_form.form.current=$Obj_form.selectorFields.name)\
		 | ($Obj_form.form.current=$Obj_form.selectorRelations.name)
		
		Case of 
				
				  //______________________________________________________
			: ($Obj_form.form.eventCode=On Clicked:K2:4)
				
				  // Update tab
				$Obj_context.selector:=Num:C11($Obj_form.form.current=$Obj_form.selectorRelations.name)
				$Obj_context.setTab()
				$Obj_context.update()
				
				  //______________________________________________________
			: ($Obj_form.form.eventCode=On Mouse Enter:K2:33)
				
				If ($Obj_context.selector#(Num:C11($Obj_form.form.current=$Obj_form.selectorRelations.name)))
					
					  // Highlights
					$o:=Choose:C955($Obj_form.form.current=$Obj_form.selectorFields.name;$Obj_form.selectorFields;$Obj_form.selectorRelations)
					$o.setColors(ui.selectedColor;Background color none:K23:10)
					
				End if 
				
				  //______________________________________________________
			: ($Obj_form.form.eventCode=On Mouse Leave:K2:34)
				
				$o:=Choose:C955($Obj_form.form.current=$Obj_form.selectorFields.name;$Obj_form.selectorFields;$Obj_form.selectorRelations)
				$o.setColors(Foreground color:K23:1;Background color none:K23:10)
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Obj_form.form.current=$Obj_form.resources.name)
		
		OPEN URL:C673(Get localized string:C991("doc_fornatters");*)
		
		  //==================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown object: \""+$Obj_form.form.current+"\"")
		
		  //==================================================
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End