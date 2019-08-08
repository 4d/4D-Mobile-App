//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ACTIONS_PARAMS_Handler
  // Database: 4D Mobile App
  // ID[3FB32AB369A0439BB4469E866D8C3C10]
  // Created 11-03-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_formEvent;$Lon_parameters)
C_OBJECT:C1216($Obj_context;$Obj_form;$Obj_in;$Obj_out)

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
		"withDefault";UI.group("@_default@");\
		"dropCursor";ui.static("dropCursor");\
		"placeholder";ui.widget("@_placeholder@")\
		)
	
	  //"boolDefault";UI.group("@_bool@")
	
	$Obj_context:=$Obj_form.$
	
	If (OB Is empty:C1297($Obj_context))\
		 | (Structure file:C489=Structure file:C489(*))  // First load
		
		  // Constraints definition
		ob_createPath ($Obj_context;"constraints")
		
		  // Define form member methods
		$Obj_context.listUI:=Formula:C1597(ACTIONS_PARAMS_UI ("listUI"))
		
		$Obj_context.formatLabel:=Formula:C1597(ACTIONS_PARAMS_UI ("formatLabel").value)
		$Obj_context.comment:=Formula:C1597(ACTIONS_PARAMS_UI ("comment").value)
		
		$Obj_context.backgroundColor:=Formula:C1597(ACTIONS_PARAMS_UI ("backgroundColor";$1).color)
		$Obj_context.metaInfo:=Formula:C1597(ACTIONS_PARAMS_UI ("metaInfo";$1))
		
		$Obj_context.update:=Formula:C1597(ACTIONS_PARAMS_UI ("refresh";$1))
		
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
				
				  // Set colors
				$Obj_form.dropCursor.setColors(Highlight menu background color:K23:7)
				
				  //______________________________________________________
			: ($Lon_formEvent=On Timer:K2:25)  // Refresh UI
				
				$Obj_context.update($Obj_form)
				
				  //______________________________________________________
		End case 
		
		  //=========================================================
	: ($Obj_in.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215;"Missing parameter \"action\"")
		
		  //=========================================================
	: ($Obj_in.action="init")  // Return the form objects definition
		
		$Obj_out:=$Obj_form
		
		  //=========================================================
	: ($Obj_in.action="refresh")
		
		If ($Obj_context.action#Null:C1517)
			
			If ($Obj_context.action.parameters#Null:C1517)\
				 & (Num:C11($Obj_context.action.parameters.length)#0)
				
				  // Select the first one
				$Obj_form.parameters.select(1)
				$Obj_context.parameter:=$Obj_context.parameters[0]
				
			End if 
		End if 
		
		$Obj_form.form.refresh()
		
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