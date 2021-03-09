// ----------------------------------------------------
// Form method : RELATED - (4D Mobile App)
// ID[FC51239B819F405287A5D751167C2CE3]
// Created 12-12-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $e : Object

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606

// ----------------------------------------------------

Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		_o_ui_BEST_SIZE(New object:C1471(\
			"widgets"; New collection:C1472("ok"; "cancel"); \
			"alignment"; Align right:K42:4))
		
		OBJECT SET TITLE:C194(*; "title"; Replace string:C233(Get localized string:C991("relatedTable"); "{entity}"; String:C10(Form:C1466.relatedDataClass)))
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 