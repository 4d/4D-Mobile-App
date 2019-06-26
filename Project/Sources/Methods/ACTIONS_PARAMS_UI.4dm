//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ACTIONS_PARAMS_UI
  // Database: 4D Mobile App
  // ID[43429814D9324358882F88A14298D45D]
  // Created #11-4-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_BOOLEAN:C305($b)
C_LONGINT:C283($l)
C_TEXT:C284($t)
C_OBJECT:C1216($o;$Obj_action;$Obj_form;$Obj_parameter)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(ACTIONS_PARAMS_UI ;$0)
	C_TEXT:C284(ACTIONS_PARAMS_UI ;$1)
	C_OBJECT:C1216(ACTIONS_PARAMS_UI ;$2)
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($1="refresh")  // Update the panel UI according to the selection
		
		ASSERT:C1129(Not:C34(Macintosh option down:C545))
		
		$o:=$2  // The form definition
		
		$o.noSelection.hide()
		$o.noTable.hide()
		$o.withSelection.hide()
		$o.deleteAction.hide()
		
		If (Form:C1466.actions=Null:C1517)\
			 | (Num:C11(Form:C1466.actions.length)=0)  // No actions
			
			$o.noAction.show()
			
		Else 
			
			$o.noAction.hide()
			
			$Obj_action:=This:C1470.action
			$Obj_parameter:=This:C1470.parameter
			
			If ($Obj_action=Null:C1517)  // No action selected
				
				$o.noSelection.show()
				$o.withSelection.hide()
				
			Else 
				
				If (String:C10($Obj_action.style)="destructive")
					
					$o.noSelection.hide()
					$o.deleteAction.show()
					
				Else 
					
					$o.withSelection.show()
					
					If ($Obj_action.tableNumber=Null:C1517)  // No target table
						
						$o.noTable.show()
						$o.properties.hide()
						$o.remove.disable()
						$o.add.disable()
						
					Else 
						
						$o.add.enable()
						
						If ($Obj_parameter=Null:C1517)  // No current parameter
							
							$o.properties.hide()
							$o.remove.disable()
							
						Else 
							
							If ($Obj_action.parameters.length>0)
								
								$o.remove.enable()
								$o.properties.show()
								
								$o.variable.setVisible($Obj_parameter.fieldNumber=Null:C1517)  // If variable
								
								$o.field.setVisible($Obj_parameter.fieldNumber#Null:C1517)  // If field
								
								$o.number.setVisible(String:C10($Obj_parameter.type)="number")
								
								$o.mandatory.setValue(ACTIONS_PARAMS_UI ("mandatory").value)
								$o.min.setValue(ACTIONS_PARAMS_UI ("min").value)
								$o.max.setValue(ACTIONS_PARAMS_UI ("max").value)
								
								$o.placeholder.show()
								
								If (String:C10($Obj_action.preset)#"edition")
									
									$o.withDefault.show()
									
								Else 
									
									$o.withDefault.setVisible($Obj_parameter.fieldNumber=Null:C1517)
									
								End if 
								
								If ($o.withDefault.visible())
									
									$o.default.setValue(String:C10($Obj_parameter.default))
									
									Case of 
											
											  //…………………………………………………………………………………………………………………………………………
										: ($Obj_parameter.type="number")
											
											Case of 
													
													  //________________________________________
												: (String:C10($Obj_parameter.format)="integer")
													
													$o.default.setFilter(Is integer:K8:5)
													
													  //________________________________________
												: (String:C10($Obj_parameter.format)="spellOut")
													
													$o.default.setFilter(Is text:K8:3)
													
													  //________________________________________
												Else 
													
													$o.default.setFilter(Is real:K8:4)
													
													  //________________________________________
											End case 
											
											  //…………………………………………………………………………………………………………………………………………
										: ($Obj_parameter.type="date")
											
											  // Should accept "today", "yesterday", "tomorrow"
											GET SYSTEM FORMAT:C994(Date separator:K60:10;$t)
											$o.default.setFilter(Replace string:C233("&\"0-9;%;-;/;a;d;e;m;o;r-t;w;y\"";"%";$t))
											
											  //…………………………………………………………………………………………………………………………………………
										: ($Obj_parameter.type="time")
											
											$o.default.setFilter(Is time:K8:8)
											
											  //…………………………………………………………………………………………………………………………………………
										: ($Obj_parameter.type="string")
											
											$o.default.setFilter(Is text:K8:3)
											
											  //…………………………………………………………………………………………………………………………………………
										: ($Obj_parameter.type="bool")
											
											If ($Obj_parameter.default#Null:C1517)
												
												$o.default.setValue(Choose:C955($Obj_parameter.default;"true";"false"))
												
											Else 
												
												$o.default.setValue("")
												
											End if 
											
											  // Should accept "true", "false", 0 or 1
											$o.default.setFilter("&\"0;1;a;e;f;l;r-u\"")
											
											$o.placeholder.hide()  // No placeholder
											
											  //…………………………………………………………………………………………………………………………………………
										: ($Obj_parameter.type="image")
											
											$o.withDefault.hide()  // No default value
											
											  //…………………………………………………………………………………………………………………………………………
									End case 
								End if 
								
							Else 
								
								$o.properties.hide()
								$o.remove.disable()
								
							End if 
						End if 
					End if 
				End if 
			End if 
		End if 
		
		  //______________________________________________________
	: ($1="min")\
		 | ($1="max")  // Return the min or max rule value as string
		
		$Obj_parameter:=This:C1470.parameter
		
		If ($Obj_parameter.rules#Null:C1517)
			
			$c:=$Obj_parameter.rules.extract($1)
			
			If ($c.length>0)
				
				$t:=String:C10($c[0])
				
			End if 
		End if 
		
		$o:=New object:C1471(\
			"value";$t)
		
		  //______________________________________________________
	: ($1="mandatory")  // Return the mandatory rule value as boolean
		
		$Obj_parameter:=This:C1470.parameter
		
		If ($Obj_parameter.rules#Null:C1517)
			
			$b:=($Obj_parameter.rules.countValues("mandatory")>0)
			
		End if 
		
		$o:=New object:C1471(\
			"value";$b)
		
		  //______________________________________________________
	: ($1="comment")  // Comment associated with the parameter linked to a field
		
		$Obj_action:=This:C1470.action
		$Obj_parameter:=This:C1470.parameter
		
		If (Num:C11($Obj_parameter.fieldNumber)#0)  // One parameter slected
			
			If (Num:C11($Obj_action.tableNumber)#0)
				
				$o:=New object:C1471(\
					"value";Replace string:C233(Get localized string:C991("thisParameterIsLinkedToTheField");\
					"{field}";\
					String:C10(Form:C1466.dataModel[String:C10($Obj_action.tableNumber)][String:C10($Obj_parameter.fieldNumber)].name))\
					)
				
			End if 
			
		Else 
			
			$o:=New object:C1471(\
				"value";"")
			
		End if 
		
		  //______________________________________________________
	: ($1="formatLabel")  // display format according to format or type
		
		$Obj_parameter:=This:C1470.parameter
		
		If (Length:C16(String:C10($Obj_parameter.format))=0)
			
			  // Take type
			$t:=Choose:C955($Obj_parameter.type="string";"text";String:C10($Obj_parameter.type))
			
		Else 
			
			  // Prefer format
			$t:=Choose:C955($Obj_parameter.format#$Obj_parameter.type;"f_"+String:C10($Obj_parameter.format);String:C10($Obj_parameter.type))
			
		End if 
		
		$o:=New object:C1471(\
			"value";Get localized string:C991($t))
		
		  //______________________________________________________
	: ($1="listUI")  // Colors UI according to focus
		
		$Obj_form:=ACTIONS_PARAMS_Handler (New object:C1471(\
			"action";"init"))
		
		If ($Obj_form.form.focusedWidget=$Obj_form.parameters.name)\
			  // & (Form event=On Getting Focus)
			
			OBJECT SET RGB COLORS:C628(*;$Obj_form.form.focusedWidget;Foreground color:K23:1;ui.highlightColor;ui.highlightColor)
			OBJECT SET RGB COLORS:C628(*;$Obj_form.form.focusedWidget+".border";ui.selectedColor;Background color none:K23:10)
			
		Else 
			
			OBJECT SET RGB COLORS:C628(*;$Obj_form.form.focusedWidget;Foreground color:K23:1;0x00FFFFFF;0x00FFFFFF)
			OBJECT SET RGB COLORS:C628(*;$Obj_form.form.focusedWidget+".border";ui.backgroundUnselectedColor;Background color none:K23:10)
			
		End if 
		
		  //______________________________________________________
	: ($1="backgroundColor")  // <Background Color Expression>
		
		$o:=New object:C1471(\
			"color";0x00FFFFFF)  // Default is white
		
		If (Num:C11(This:C1470.index)#0)
			
			$Obj_form:=ACTIONS_PARAMS_Handler (New object:C1471(\
				"action";"init"))
			
			$b:=($Obj_form.form.focusedWidget=$Obj_form.parameters.name)
			
			If (ob_equal (This:C1470.parameter;$2))  // Selected row
				
				$o.color:=Choose:C955($b;ui.backgroundSelectedColor;ui.alternateSelectedColor)
				
			Else 
				
				$l:=Choose:C955($b;ui.highlightColor;ui.highlightColorNoFocus)
				$o.color:=Choose:C955($b;$l;0x00FFFFFF)
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($1="metaInfo")  // <Meta info expression>
		
		  // Default values
		$o:=New object:C1471(\
			"stroke";"black";\
			"fontWeight";"normal")
		
		  // Mark duplicate names
		ob_createPath ($o;"cell.names")
		$o.cell.names.stroke:=Choose:C955(This:C1470.action.parameters.indices("name = :1";$2.name).length>1;ui.errorRGB;"black")
		
		  //______________________________________________________
		
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End