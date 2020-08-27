//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : ACTIONS_PARAMS_UI
// ID[43429814D9324358882F88A14298D45D]
// Created 11-4-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $0 : Object
var $1 : Text
var $2 : Object

If (False:C215)
	C_OBJECT:C1216(ACTIONS_PARAMS_UI; $0)
	C_TEXT:C284(ACTIONS_PARAMS_UI; $1)
	C_OBJECT:C1216(ACTIONS_PARAMS_UI; $2)
End if 

var $t : Text
var $isFocused; $isMandatory; $withDefault : Boolean
var $color : Integer
var $action; $form; $o; $parameter; $rgx : Object
var $c : Collection

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($1="refresh")  // Update the panel UI according to the selection
		
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
			
			$action:=This:C1470.action
			$parameter:=This:C1470.parameter
			
			ASSERT:C1129(Not:C34(Shift down:C543))
			
			If ($action=Null:C1517)  // No action selected
				
				FORM GOTO PAGE:C247(1; *)
				
				$o.noSelection.show()
				$o.withSelection.hide()
				
			Else 
				
				Case of 
						//______________________________________________________
					: (String:C10($action.preset)="suppression")
						
						FORM GOTO PAGE:C247(1; *)
						
						$o.noSelection.hide()
						$o.deleteAction.show()
						
						//______________________________________________________
					: (String:C10($action.preset)="share")
						
						FORM GOTO PAGE:C247(2; *)
						
						//______________________________________________________
					Else 
						
						FORM GOTO PAGE:C247(1; *)
						
						$o.withSelection.show()
						
						If ($action.tableNumber=Null:C1517)  // No target table
							
							$o.noTable.show()
							$o.properties.hide()
							$o.remove.disable()
							$o.add.disable()
							
						Else 
							
							$o.add.enable()
							
							If ($parameter=Null:C1517)  // No current parameter
								
								$o.properties.hide()
								$o.remove.disable()
								
							Else 
								
								If ($action.parameters.length>0)
									
									$o.remove.enable()
									$o.properties.show()
									
									$o.variable.setVisible($parameter.fieldNumber=Null:C1517)  // User parameter
									$o.field.setVisible($parameter.fieldNumber#Null:C1517)  // Linked to a field
									
									$o.number.setVisible(String:C10($parameter.type)="number")
									
									$o.mandatory.setValue(ACTIONS_PARAMS_UI("mandatory").value)
									$o.min.setValue(ACTIONS_PARAMS_UI("min").value)
									$o.max.setValue(ACTIONS_PARAMS_UI("max").value)
									
									$o.placeholder.setVisible($parameter.type#"bool")
									
									If ($parameter.type#"image")
										
										$withDefault:=Choose:C955(String:C10($action.preset)#"edition"; True:C214; ($parameter.fieldNumber=Null:C1517))
										
									End if 
									
									If ($withDefault)
										
										$o.withDefault.show()
										
										$o.default.setValue(String:C10($parameter.default))
										
										Case of 
												
												//…………………………………………………………………………………………………………………………………………
											: ($parameter.type="number")
												
												Case of 
														
														//________________________________________
													: (String:C10($parameter.format)="integer")
														
														$o.default.setFilter(Is integer:K8:5)
														
														//________________________________________
													: (String:C10($parameter.format)="spellOut")
														
														$o.default.setFilter(Is integer:K8:5)
														
														//________________________________________
													Else 
														
														$o.default.setFilter(Is real:K8:4)
														
														//________________________________________
												End case 
												
												//…………………………………………………………………………………………………………………………………………
											: ($parameter.type="date")
												
												// Should accept "today", "yesterday", "tomorrow"
												GET SYSTEM FORMAT:C994(Date separator:K60:10; $t)
												$o.default.setFilter("&\"0-9;"+$t+";-;/;"+str("todayyesterdaytomorrow").distinctLetters(";")+"\"")
												
												If (Position:C15(String:C10($o.default.value()); "todayyesterdaytomorrow")=0)
													
													$rgx:=Rgx_match(New object:C1471(\
														"pattern"; "(?m-si)^(\\d{2})!(\\d{2})!(\\d{4})$"; \
														"target"; $o.default.value()))
													
													If ($rgx.success)
														
														$o.default.setValue(String:C10(Add to date:C393(!00-00-00!; Num:C11($rgx.match[3].data); Num:C11($rgx.match[2].data); Num:C11($rgx.match[1].data))))
														
													End if 
												End if 
												
												//…………………………………………………………………………………………………………………………………………
											: ($parameter.type="time")
												
												$o.default.setFilter(Is time:K8:8)
												
												//…………………………………………………………………………………………………………………………………………
											: ($parameter.type="string")
												
												$o.default.setFilter(Is text:K8:3)
												
												//…………………………………………………………………………………………………………………………………………
											: ($parameter.type="bool")
												
												If (String:C10($parameter.format)="check")
													
													If ($parameter.default#Null:C1517)
														
														If (Value type:C1509($parameter.default)=Is boolean:K8:9)
															
															$o.default.setValue(Choose:C955($parameter.default; "checked"; "unchecked"))
															
														End if 
													End if 
													
													// Should accept "checked", "unchecked", 0 or 1
													$o.default.setFilter("&\"0;1;"+str("unchecked").distinctLetters(";")+"\"")
													
												Else 
													
													If ($parameter.default#Null:C1517)
														
														If (Value type:C1509($parameter.default)=Is boolean:K8:9)
															
															$o.default.setValue(Choose:C955($parameter.default; "true"; "false"))
															
														End if 
													End if 
													
													// Should accept "true", "false", 0 or 1
													$o.default.setFilter("&\"0;1;"+str("truefalse").distinctLetters(";")+"\"")
													
												End if 
												
												//…………………………………………………………………………………………………………………………………………
										End case 
										
									Else 
										
										$o.withDefault.hide()
										
									End if 
									
								Else 
									
									$o.properties.hide()
									$o.remove.disable()
									
								End if 
							End if 
						End if 
						//______________________________________________________
				End case 
			End if 
		End if 
		
		//______________________________________________________
	: ($1="min")\
		 | ($1="max")  // Return the min or max rule value as string
		
		$parameter:=This:C1470.parameter
		
		If ($parameter.rules#Null:C1517)
			
			$c:=$parameter.rules.extract($1)
			
			If ($c.length>0)
				
				$t:=String:C10($c[0])
				
			End if 
		End if 
		
		$o:=New object:C1471(\
			"value"; $t)
		
		//______________________________________________________
	: ($1="mandatory")  // Return the mandatory rule value as boolean
		
		$parameter:=This:C1470.parameter
		
		If ($parameter.rules#Null:C1517)
			
			$isMandatory:=($parameter.rules.countValues("mandatory")>0)
			
		End if 
		
		$o:=New object:C1471(\
			"value"; $isMandatory)
		
		//______________________________________________________
	: ($1="comment")  // Comment associated with the parameter linked to a field
		
		$action:=This:C1470.action
		$parameter:=This:C1470.parameter
		
		If (Num:C11($parameter.fieldNumber)#0)  // One parameter slected
			
			If (Num:C11($action.tableNumber)#0)
				
				$o:=New object:C1471(\
					"value"; Replace string:C233(Get localized string:C991("thisParameterIsLinkedToTheField"); \
					"{field}"; \
					String:C10(Form:C1466.dataModel[String:C10($action.tableNumber)][String:C10($parameter.fieldNumber)].name))\
					)
				
			End if 
			
		Else 
			
			$o:=New object:C1471(\
				"value"; "")
			
		End if 
		
		//______________________________________________________
	: ($1="formatLabel")  // display format according to format or type
		
		$parameter:=This:C1470.parameter
		
		If (Length:C16(String:C10($parameter.format))=0)
			
			// Take type
			$t:=Choose:C955($parameter.type="string"; "text"; String:C10($parameter.type))
			
		Else 
			
			// Prefer format
			$t:=Choose:C955($parameter.format#$parameter.type; "f_"+String:C10($parameter.format); String:C10($parameter.type))
			
		End if 
		
		$o:=New object:C1471(\
			"value"; Get localized string:C991($t))
		
		//______________________________________________________
	: ($1="listUI")  // Colors UI according to focus
		
		$form:=ACTIONS_PARAMS_Handler(New object:C1471(\
			"action"; "init"))
		
		If ($form.form.focusedWidget=$form.parameters.name)\
			 & (Form event code:C388=On Getting Focus:K2:7)
			
			OBJECT SET RGB COLORS:C628(*; $form.form.focusedWidget; Foreground color:K23:1; ui.highlightColor; ui.highlightColor)
			OBJECT SET RGB COLORS:C628(*; $form.form.focusedWidget+".border"; ui.selectedColor; Background color none:K23:10)
			
		Else 
			
			OBJECT SET RGB COLORS:C628(*; $form.form.focusedWidget; Foreground color:K23:1; 0x00FFFFFF; 0x00FFFFFF)
			OBJECT SET RGB COLORS:C628(*; $form.form.focusedWidget+".border"; ui.backgroundUnselectedColor; Background color none:K23:10)
			
		End if 
		
		//______________________________________________________
	: ($1="backgroundColor")  // <Background Color Expression>
		
		$o:=New object:C1471(\
			"color"; 0x00FFFFFF)  // Default is white
		
		If (Num:C11(This:C1470.index)#0)
			
			$form:=ACTIONS_PARAMS_Handler(New object:C1471(\
				"action"; "init"))
			
			$isFocused:=($form.form.focusedWidget=$form.parameters.name)
			
			If (ob_equal(This:C1470.parameter; $2))  // Selected row
				
				$o.color:=Choose:C955($isFocused; ui.backgroundSelectedColor; ui.alternateSelectedColor)
				
			Else 
				
				$color:=Choose:C955($isFocused; ui.highlightColor; ui.highlightColorNoFocus)
				$o.color:=Choose:C955($isFocused; $color; 0x00FFFFFF)
				
			End if 
		End if 
		
		//______________________________________________________
	: ($1="metaInfo")  // <Meta info expression>
		
		// Default values
		$o:=New object:C1471(\
			"stroke"; "black"; \
			"fontWeight"; "normal")
		
		// Mark duplicate names
		ob_createPath($o; "cell.names")
		$o.cell.names.stroke:=Choose:C955(This:C1470.action.parameters.indices("name = :1"; $2.name).length>1; ui.errorRGB; "black")
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$1+"\"")
		
		//______________________________________________________
End case 

// ----------------------------------------------------
// Return
$0:=$o

// ----------------------------------------------------
// End