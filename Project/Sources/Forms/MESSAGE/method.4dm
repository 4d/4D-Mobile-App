// ----------------------------------------------------
// Form method : MESSAGE - (4D Mobile Express)
// ID[F362D3E200984FF7AFD3F7FD4B4311BC]
// Created 30-6-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $e : Object

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606

// ----------------------------------------------------

Case of 
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		Form:C1466.ƒ.update(Form:C1466)
		
		//______________________________________________________
	: ($e.code=On Bound Variable Change:K2:52)
		
		If (Form:C1466.ƒ=Null:C1517)
			
			Form:C1466.ƒ:=cs:C1710.widgetMessage.new()
			
		End if 
		
		Form:C1466.ƒ.display()
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 