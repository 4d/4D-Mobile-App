//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : ACTIONS_PARAMS_Handler
// ID[3FB32AB369A0439BB4469E866D8C3C10]
// Created 11-03-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $0 : Object
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(ACTIONS_PARAMS_Handler; $0)
	C_OBJECT:C1216(ACTIONS_PARAMS_Handler; $1)
End if 

var $formEvent : Integer
var $form; $ƒ; $IN; $OUT : Object

// ----------------------------------------------------
// NO PARAMETERS REQUIRED

// Optional parameters
If (Count parameters:C259>=1)
	
	$IN:=$1
	
End if 

$form:=New object:C1471(\
"$"; editor_INIT; \
"form"; UI.form("editor_CALLBACK").get(); \
"noSelection"; UI.static("empty"); \
"noAction"; UI.static("noAction"); \
"noTable"; UI.static("noTable"); \
"withSelection"; UI.group("@parameters@;@property@;@variable@"); \
"field"; UI.group("@_field_@"); \
"variable"; UI.group("@variable@"); \
"properties"; UI.group("@property@;@variable@"); \
"number"; UI.group("@number@"); \
"parameters"; UI.listbox("01_Parameters"); \
"add"; UI.button("parameters.add"); \
"remove"; UI.button("parameters.remove"); \
"format"; UI.button("05_property_type.popup"); \
"formatBorder"; UI.static("05_property_type.border"); \
"linked"; UI.group("02_property_name;03_property_label;04_property_shortLabel;06_property_placeholder;07_variable_default"); \
"deleteAction"; UI.static("deleteAction"); \
"mandatory"; UI.button("02_property_mandatory"); \
"min"; UI.button("09_property_constraint_number_min"); \
"max"; UI.button("10_property_constraint_number_max"); \
"default"; UI.widget("07_variable_default"); \
"withDefault"; UI.group("@_default@"); \
"dropCursor"; UI.static("dropCursor"); \
"placeholder"; UI.widget("@_placeholder@"); \
"description"; UI.widget("01_description")\
)

//"boolDefault";UI.group("@_bool@")

$ƒ:=$form.$

If (OB Is empty:C1297($ƒ))\
 | (Structure file:C489=Structure file:C489(*))  // First load
	
	// Constraints definition
	ob_createPath($ƒ; "constraints")
	
	// Define form member methods
	$ƒ.listUI:=Formula:C1597(ACTIONS_PARAMS_UI("listUI"))
	
	$ƒ.formatLabel:=Formula:C1597(ACTIONS_PARAMS_UI("formatLabel").value)
	$ƒ.comment:=Formula:C1597(ACTIONS_PARAMS_UI("comment").value)
	
	$ƒ.backgroundColor:=Formula:C1597(ACTIONS_PARAMS_UI("backgroundColor"; $1).color)
	$ƒ.metaInfo:=Formula:C1597(ACTIONS_PARAMS_UI("metaInfo"; $1))
	
	$ƒ.update:=Formula:C1597(ACTIONS_PARAMS_UI("refresh"; $1))
	
End if 

// ----------------------------------------------------
Case of 
		
		//=========================================================
	: ($IN=Null:C1517)  // Form method
		
		$formEvent:=_o_panel_Form_common(On Load:K2:1; On Timer:K2:25)
		
		Case of 
				
				//______________________________________________________
			: ($formEvent=On Load:K2:1)
				
				// This trick remove the horizontal gap
				$form.parameters.setScrollbar(0; 2)
				
				// Set colors
				$form.dropCursor.setColors(Highlight menu background color:K23:7)
				
				//______________________________________________________
			: ($formEvent=On Timer:K2:25)  // Refresh UI
				
				$ƒ.update($form)
				
				//______________________________________________________
		End case 
		
		//=========================================================
	: ($IN.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215; "Missing parameter \"action\"")
		
		//=========================================================
	: ($IN.action="init")  // Return the form objects definition
		
		$OUT:=$form
		
		//=========================================================
	: ($IN.action="refresh")
		
		If ($ƒ.action#Null:C1517)
			
			If ($ƒ.action.parameters#Null:C1517)\
				 & (Num:C11($ƒ.action.parameters.length)#0)
				
				// Select the first one
				$form.parameters.select(1)
				$ƒ.parameter:=$ƒ.parameters[0]
				
			End if 
		End if 
		
		$form.form.refresh()
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$IN.action+"\"")
		
		//=========================================================
End case 

// ----------------------------------------------------
// Return
If ($OUT#Null:C1517)
	
	$0:=$OUT
	
End if 

// ----------------------------------------------------
// End