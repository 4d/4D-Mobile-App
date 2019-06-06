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
		"withSelection";ui.group(New collection:C1472("@parameters@";"@property@";"@variable@"));\
		"field";ui.group(New collection:C1472("@parameters@";"@property@"));\
		"variable";ui.group("@variable@");\
		"properties";ui.group(New collection:C1472("@property@";"@variable@"));\
		"parameters";ui.listbox("01_Parameters");\
		"add";ui.button("parameters.add");\
		"remove";ui.button("parameters.remove");\
		"typeMenu";ui.button("05_property_type.popup");\
		"typeBorder";ui.static("05_property_type.border")\
		)
	
	$Obj_context:=$Obj_form.$
	
	If (OB Is empty:C1297($Obj_context))
		
		  // Constraints definition
		ob_createPath ($Obj_context;"constraints")
		
		  // Define form member methods
		$Obj_context.listUI:=Formula:C1597(ACTIONS_PARAMS_UI ("listUI"))
		  //$Obj_context.meta:=Formula(ACTIONS_PARAMS_UI ("meta"))
		
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
				
				  //______________________________________________________
			: ($Lon_formEvent=On Timer:K2:25)  // Refresh UI
				
				ASSERT:C1129(Not:C34(Shift down:C543))
				
				$o:=$Obj_form
				
				If (Form:C1466.actions=Null:C1517)\
					 | (Num:C11(Form:C1466.actions.length)=0)  //no actions
					
					$o.noAction.show()
					$o.noSelection.hide()
					$o.noTable.hide()
					$o.withSelection.hide()
					
				Else 
					
					$o.noAction.hide()
					
					If ($Obj_context.action=Null:C1517)  // No action selected
						
						$o.noSelection.show()
						$o.noTable.hide()
						$o.withSelection.hide()
						
					Else 
						
						$Obj_context.action.parameters:=$Obj_context.action.parameters
						
						$o.noSelection.hide()
						$o.withSelection.show()
						
						If ($Obj_context.action.tableNumber=Null:C1517)  // No target table
							
							$o.noTable.show()
							$o.properties.hide()
							$o.remove.disable()
							$o.add.disable()
							
						Else 
							
							$o.noTable.hide()
							$o.add.enable()
							
							If ($Obj_context.parameter=Null:C1517)  // No current parameter
								
								$o.remove.disable()
								$o.properties.hide()
								
							Else 
								
								$o.remove.enable()
								$o.properties.show()
								
								If ($Obj_context.parameter.fieldNumber=Null:C1517)  // Variable
									
									$o.variable.show()
									
								Else 
									
									$o.variable.hide()
									
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
Case of 
		  //: (Undefined($Obj_out))
	: ($Obj_out=Null:C1517)
		  //: (Value type(($Obj_out=Null))=Is undefined)
	Else 
		$0:=$Obj_out
End case 

  // ----------------------------------------------------
  // End