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
		
		cs:C1710.group.new("ok,cancel").distributeRigthToLeft()
		cs:C1710.formObject.new("title").setTitle(UI.str.localize("relatedTable"; String:C10(Form:C1466.relatedDataClass)))
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 