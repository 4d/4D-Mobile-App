// ----------------------------------------------------
// Object method : EDITOR.Subform - (4D Mobile App)
// ID[B259C0E7CB8C44798B0168C4A59E531B]
// Created 2-3-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $e : Object

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606

// ----------------------------------------------------
Case of 
		
		//________________________________________
	: ($e.code<0)  // <SUBFORM EVENTS>
		
		Case of 
				
				//…………………………………………………………………………………………………
			: ($e.code=-1)
				
				_o_editor_OPEN_PROJECT
				
				//…………………………………………………………………………………………………
			Else 
				
				ASSERT:C1129(False:C215; "Unknown call from subform ("+$e.description+")")
				
				//…………………………………………………………………………………………………
		End case 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 