//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ACTIONS_PARAMS_Handler
  // Database: 4D Mobile App
  // ID[3FB32AB369A0439BB4469E866D8C3C10]
  // Created #11-03-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_formEvent;$Lon_parameters)
C_OBJECT:C1216($o;$Obj_context;$Obj_form;$Obj_in;$Obj_out)

If (False:C215)
	C_OBJECT:C1216(ACTIONS_PARAMS_Handler ;$0)
	C_OBJECT:C1216(ACTIONS_PARAMS_Handler ;$1)
End if 

  // ----------------------------------------------------
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
	End if 
	
	$Obj_form:=New object:C1471(\
		"$";editor_INIT ;\
		"form";ui.form("editor_CALLBACK").get();\
		"noSelection";ui.static("empty");\
		"noAction";ui.static("noAction");\
		"noTable";ui.static("noTable");\
		"withSelection";ui.group("@parameters@;@property@;@variable@");\
		"field";ui.group("@_field_@");\
		"variable";ui.group("@variable@");\
		"properties";ui.group("@property@;@variable@");\
		"number";ui.group("@number@");\
		"parameters";ui.listbox("01_Parameters");\
		"add";ui.button("parameters.add");\
		"remove";ui.button("parameters.remove");\
		"format";ui.button("05_property_type.popup");\
		"formatBorder";ui.static("05_property_type.border");\
		"linked";ui.group("02_property_name;03_property_label;04_property_shortLabel;06_property_placeholder;07_variable_default");\
		"deleteAction";ui.static("deleteAction");\
		"mandatory";ui.button("02_property_mandatory");\
		"min";ui.button("09_property_constraint_number_min");\
		"max";ui.button("10_property_constraint_number_max");\
		"default";UI.widget("07_variable_default");\
		"withDefault";UI.group("@_default@")\
		)
	
	$Obj_context:=$Obj_form.$
	
	If (OB Is empty:C1297($Obj_context))\
		 | (Shift down:C543 & (Structure file:C489=Structure file:C489(*)))  // First load
		
		  // Constraints definition
		ob_createPath ($Obj_context;"constraints")
		
		  // Define form member methods
		$Obj_context.listUI:=Formula:C1597(ACTIONS_PARAMS_UI ("listUI"))
		
		$Obj_context.formatLabel:=Formula:C1597(ACTIONS_PARAMS_UI ("formatLabel").value)
		$Obj_context.comment:=Formula:C1597(ACTIONS_PARAMS_UI ("comment").value)
		
		$Obj_context.backgroundColor:=Formula:C1597(ACTIONS_PARAMS_UI ("backgroundColor";$1).color)
		$Obj_context.metaInfo:=Formula:C1597(ACTIONS_PARAMS_UI ("metaInfo";$1))
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$Lon_formEvent:=panel_Form_common (On Load:K2:1;On Timer:K2:25)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				  // This trick remove the horizontal gap
				$Obj_form.parameters.setScrollbar(0;2)
				
				  //button ("02_property_mandatory").forceBoolean()
				
				  //______________________________________________________
			: ($Lon_formEvent=On Timer:K2:25)  // Refresh UI
				
				ASSERT:C1129(Not:C34(Shift down:C543))
				
				$o:=$Obj_form
				
				  //If ($Obj_context.parameter=Null)
				
				  //$Obj_form.parameters.select(1)
				
				  //End if 
				
				
				$o.noSelection.hide()
				$o.noTable.hide()
				$o.withSelection.hide()
				$o.deleteAction.hide()
				
				If (Form:C1466.actions=Null:C1517)\
					 | (Num:C11(Form:C1466.actions.length)=0)  // No actions
					
					$o.noAction.show()
					
				Else 
					
					$o.noAction.hide()
					
					If ($Obj_context.action=Null:C1517)  // No action selected
						
						$o.noSelection.show()
						$o.withSelection.hide()
						
					Else 
						
						If (String:C10($Obj_context.action.style)="destructive")
							
							$o.noSelection.hide()
							$o.deleteAction.show()
							
						Else 
							
							$o.withSelection.show()
							
							
							
							If ($Obj_context.action.tableNumber=Null:C1517)  // No target table
								
								$o.noTable.show()
								$o.remove.disable()
								$o.add.disable()
								
							Else 
								
								$o.add.enable()
								
								If ($Obj_context.parameter=Null:C1517)  // No current parameter
									
									$o.properties.hide()
									$o.remove.disable()
									
								Else 
									
									If ($Obj_context.action.parameters.length>0)
										
										$o.remove.enable()
										$o.properties.show()
										
										$o.variable.setVisible($Obj_context.parameter.fieldNumber=Null:C1517)  // If variable
										$o.field.setVisible($Obj_context.parameter.fieldNumber#Null:C1517)  // If field
										
										$o.number.setVisible(String:C10($Obj_context.parameter.type)="number")
										
										$o.mandatory.setValue(ACTIONS_PARAMS_UI ("mandatory").value)
										$o.min.setValue(ACTIONS_PARAMS_UI ("min").value)
										$o.max.setValue(ACTIONS_PARAMS_UI ("max").value)
										
										  //$o.default.setFilter("")
										
										$o.withDefault.show()
										
										Case of 
												
												  //______________________________________________________
											: ($Obj_context.parameter.type="number")
												
												Case of 
														
														  //……………………………………………………………………………………………………
													: ($Obj_context.parameter.format="integer")
														
														$o.default.setFilter("&9")
														
														  //……………………………………………………………………………………………………
													: ($Obj_context.parameter.format="percent")
														
														$o.default.setFilter("&\"0-9;%;.;,;-;\"")
														
														  //……………………………………………………………………………………………………
													: ($Obj_context.parameter.format="spellOut")
														
														$o.default.setFilter("")
														
														  //……………………………………………………………………………………………………
													Else 
														
														$o.default.setFilter("&\"0-9;.;,;-;\"")
														
														  //……………………………………………………………………………………………………
												End case 
												
												  //______________________________________________________
											: ($Obj_context.parameter.type="date")
												
												$o.default.setFilter("&\"0-9;/;-;\"")
												
												  //______________________________________________________
											: ($Obj_context.parameter.type="time")
												
												$o.default.setFilter("&\"0-9;:\"")
												
												  //______________________________________________________
											: ($Obj_context.parameter.type="text")
												
												$o.default.setFilter("")
												
												  //______________________________________________________
											Else 
												
												$o.withDefault.hide()
												
												  //______________________________________________________
										End case 
										
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
		End case 
		
		  //=========================================================
	: ($Obj_in.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215;"Missing parameter \"action\"")
		
		  //=========================================================
	: ($Obj_in.action="init")  // Return the form objects definition
		
		$Obj_out:=$Obj_form
		
		  //=========================================================
	: ($Obj_in.action="xxxx")
		
		  //
		
		  //=========================================================
		
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_in.action+"\"")
		
		  //=========================================================
End case 

  // ----------------------------------------------------
  // Return
If ($Obj_out#Null:C1517)
	
	$0:=$Obj_out
	
End if 

  // ----------------------------------------------------
  // End