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
C_TEXT:C284($t; $Txt_current)
C_OBJECT:C1216($o; $context; $Obj_field; $ƒorm; $Obj_popup; $Obj_widget)
C_COLLECTION:C1488($c)

If (False:C215)
	C_LONGINT:C283(FIELDS_OBJECTS_HANDLER; $0)
End if 

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)

$ƒorm:=FIELDS_class("editor_CALLBACK")

$context:=$ƒorm.$

// ----------------------------------------------------
Case of 
		
		//==================================================
	: ($ƒorm.form.current=$ƒorm.fieldList.name)
		
		$Obj_widget:=$ƒorm.fieldList.update()
		
		Case of 
				
				//______________________________________________________
			: ($ƒorm.form.eventCode=On Selection Change:K2:29)\
				 | ($ƒorm.form.eventCode=On Clicked:K2:4)
				
				editor_ui_LISTBOX($Obj_widget.name)
				
				Case of 
						
						//______________________________________________________
					: ($ƒorm.form.eventCode=On Selection Change:K2:29)
						
						// <NOTHING MORE TO DO>
						
						//______________________________________________________
					: (editor_Locked)
						
						// <NOTHING MORE TO DO>
						
						//______________________________________________________
					: ($Obj_widget.row=0)
						
						// NO SELECTION
						
						//______________________________________________________
					: ($Obj_widget.column=$Obj_widget.columns[$ƒorm.icons.name].number)  // Open the fields icons picker
						
						// Get the current field
						$Obj_widget.cellCoordinates()
						
						// Get the field definition
						If (FEATURE.with("moreRelations"))
							
							If (Num:C11($context.selector)=1)
								
								//%W-533.3
								$c:=Split string:C1554(($Obj_widget.columns["fields"].pointer)->{$Obj_widget.row}; ".")
								//%W+533.3
								
								If ($c.length>1)
									
									// 1 -> 1 -> N
									$Obj_field:=Form:C1466.dataModel[String:C10($context.tableNumber)][String:C10($c[0])][String:C10($c[1])]
									
								Else 
									
									$Obj_field:=OB Copy:C1225($context.field($Obj_widget.row))
									
									//%W-533.3
									$Obj_field.path:=($Obj_widget.columns["fields"].pointer)->{$Obj_widget.row}
									//%W+533.3
									
								End if 
								
							Else 
								
								$Obj_field:=$context.field($Obj_widget.row)
								
							End if 
						End if 
						
						// Display the picker
						$o:=$ƒorm.picker.pointer()->
						
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
						$o.backgroundStroke:=UI.strokeColor
						$o.promptColor:=0x00FFFFFF
						$o.promptBackColor:=UI.strokeColor
						$o.hidePromptSeparator:=True:C214
						$o.forceRedraw:=True:C214
						$o.prompt:=cs:C1710.str.new("chooseAnIconForTheField").localized($Obj_field.path)
						
						$context.showPicker($o)
						
						//______________________________________________________
				End case 
				
				//______________________________________________________
			: ($ƒorm.form.eventCode=On Mouse Enter:K2:33)
				
				UI.tips.instantly()
				
				//______________________________________________________
			: ($ƒorm.form.eventCode=On Mouse Move:K2:35)
				
				$context.setHelpTip($Obj_widget.name; $ƒorm)
				
				//______________________________________________________
			: ($ƒorm.form.eventCode=On Mouse Leave:K2:34)
				
				UI.tips.default()
				
				//______________________________________________________
			: ($ƒorm.form.eventCode=On Getting Focus:K2:7)
				
				editor_ui_LISTBOX($Obj_widget.name; True:C214)
				
				$context.setHelpTip($Obj_widget.name; $ƒorm)
				
				//______________________________________________________
			: ($ƒorm.form.eventCode=On Losing Focus:K2:8)
				
				editor_ui_LISTBOX($Obj_widget.name; False:C215)
				
				//______________________________________________________
			: (editor_Locked)\
				 | ($Obj_widget.row=0)
				
				// NOTHING MORE TO DO
				
				//______________________________________________________
			: ($ƒorm.form.eventCode=On Double Clicked:K2:5)  // Edit current cell if any
				
				editor_ui_LISTBOX($Obj_widget.name)
				
				If ($Obj_widget.column=$Obj_widget.columns[$ƒorm.labels.name].number)\
					 | ($Obj_widget.column=$Obj_widget.columns[$ƒorm.shortLabels.name].number)\
					 | ($Obj_widget.column=$Obj_widget.columns[$ƒorm.titles.name].number)
					
					EDIT ITEM:C870($Ptr_me->; $Ptr_me->)
					
				End if 
				
				//______________________________________________________
			: ($ƒorm.form.eventCode=On Before Data Entry:K2:39)
				
				If ($Obj_widget.column=$Obj_widget.columns[$ƒorm.formats.name].number)
					
					$0:=-1
					
					// Get the field definition
					$Obj_field:=$context.field($Obj_widget.row)
					
					$Obj_popup:=cs:C1710.menu.new()
					
					// Get current format
					If ($Obj_field.format=Null:C1517)
						
						// Default value
						$Txt_current:=SHARED.defaultFieldBindingTypes[$Obj_field.fieldType]
						
					Else 
						
						If (Value type:C1509($Obj_field.format)=Is object:K8:27)
							
							$Txt_current:=String:C10($Obj_field.format.name)
							
						Else 
							
							// Internal
							$Txt_current:=$Obj_field.format
							
						End if 
					End if 
					
					For each ($o; formatters(New object:C1471(\
						"action"; "getByType"; \
						"type"; $Obj_field.fieldType)).formatters)
						
						$t:=String:C10($o.name)
						
						If ($t="-")
							
							$Obj_popup.line()
							
						Else 
							
							$Obj_popup.append(cs:C1710.str.new("_"+$t).localized(); $t; $Txt_current=$t)
							
						End if 
					End for each 
					
					// Append user formatters if any
					$c:=formatters(New object:C1471("action"; "getByType"; "host"; True:C214; "type"; Num:C11($Obj_field.fieldType))).formatters
					
					If ($c.length>0)
						
						$Obj_popup.line()
						
						For each ($o; $c)
							
							$Obj_popup.append($o.name; "/"+$o.name; $Txt_current=("/"+$o.name))
							
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
							$Ptr_me->{$Obj_widget.row}:=Substring:C12($Obj_popup.choice; 2)
							
						Else 
							
							$Ptr_me->{$Obj_widget.row}:=cs:C1710.str.new("_"+$Obj_popup.choice).localized()
							
						End if 
						//%W+533.3
						
						PROJECT.save()
						
					End if 
					
					$Obj_widget.focus()
					$Obj_widget.select($Obj_widget.row)
					
					editor_ui_LISTBOX($Obj_widget.name)
					
				End if 
				
				$context.inEdition:=$Obj_widget
				
				//______________________________________________________
			: ($ƒorm.form.eventCode=On Data Change:K2:15)
				
				var $e : Object
				$e:=FORM Event:C1606
				
				// Get the edited field definition
				var $field : Object
				$field:=$context.field($e.row)
				
				// Update data model
				//%W-533.3
				$field[Choose:C955($e.columnName="title"; "format"; $e.columnName)]:=$Ptr_me->{$e.row}
				//%W+533.3
				
				$context.updateForms()
				
				//PROJECT IS ALWAYS SAVED ON DATA CHANGE
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+String:C10($ƒorm.form.eventCode)+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($ƒorm.form.current=$ƒorm.selectorFields.name)\
		 | ($ƒorm.form.current=$ƒorm.selectorRelations.name)
		
		Case of 
				
				//______________________________________________________
			: ($ƒorm.form.eventCode=On Clicked:K2:4)
				
				// Update tab
				$context.selector:=Num:C11($ƒorm.form.current=$ƒorm.selectorRelations.name)
				$context.setTab()
				$context.update()
				
				//______________________________________________________
			: ($ƒorm.form.eventCode=On Mouse Enter:K2:33)
				
				If ($context.selector#(Num:C11($ƒorm.form.current=$ƒorm.selectorRelations.name)))
					
					// Highlights
					$o:=Choose:C955($ƒorm.form.current=$ƒorm.selectorFields.name; $ƒorm.selectorFields; $ƒorm.selectorRelations)
					$o.setColors(UI.selectedColor; Background color none:K23:10)
					
				End if 
				
				//______________________________________________________
			: ($ƒorm.form.eventCode=On Mouse Leave:K2:34)
				
				$o:=Choose:C955($ƒorm.form.current=$ƒorm.selectorFields.name; $ƒorm.selectorFields; $ƒorm.selectorRelations)
				$o.setColors(Foreground color:K23:1; Background color none:K23:10)
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($ƒorm.form.current=$ƒorm.resources.name)
		
		If (FEATURE.with("formatMarketPlace"))
			
			// Show browser
			$o:=New object:C1471(\
				"url"; Get localized string:C991("res_formatters"))
			$ƒorm.form.call(New collection:C1472("initBrowser"; $o))
			
		Else 
			
			OPEN URL:C673(Get localized string:C991("res_formatters"); *)
			
		End if 
		//==================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown object: \""+$ƒorm.form.current+"\"")
		
		//==================================================
End case 

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End