// ----------------------------------------------------
// Form method : WIZARD_NEW_PROJECT - (4D Mobile App)
// ID[A5933AFAD9094AD9A7A59673CF3B2E79]
// Created 21-1-2021 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $e; $o : Object

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606

// ----------------------------------------------------
Case of 
		
		//__________________________________________________________________________________________
	: ($e.code=On Load:K2:1)
		
		Form:C1466._browse:=cs:C1710.button.new("browse").bestSize(Align left:K42:2)
		Form:C1466._open:=cs:C1710.button.new("open").bestSize(Align right:K42:4).disable()
		Form:C1466._centered:=cs:C1710.group.new("list,open,message")
		Form:C1466._buttons:=cs:C1710.group.new("open,browse")
		Form:C1466._focus:=cs:C1710.static.new("focus")
		
		Form:C1466._centered.centerVertically()
		Form:C1466._buttons.distributeHorizontally()
		
		Form:C1466._list:=cs:C1710.listbox.new("list")
		
		If (Form:C1466._projects.length=0)
			
			cs:C1710.button.new("up").disable()
			cs:C1710.button.new("down").disable()
			
		Else 
			
			Form:C1466._list.select(1)
			
		End if 
		
		SET TIMER:C645(-1)
		
		//__________________________________________________________________________________________
	: ($e.code=On Resize:K2:27)
		
		Form:C1466._centered.centerVertically()
		Form:C1466._buttons.distributeHorizontally()
		
		If (Form:C1466._index#0)
			
			$o:=Form:C1466._list.getRowCoordinates(Form:C1466._index)
			Form:C1466._focus.setCoordinates($o.left; $o.top; $o.right; $o.bottom)
			
		End if 
		
		//__________________________________________________________________________________________
	: ($e.code=On Double Clicked:K2:5)
		
		If (Form:C1466._current#Null:C1517)
			
			ACCEPT:C269
			
		End if 
		
		//__________________________________________________________________________________________
	: ($e.code=On Clicked:K2:4)
		
		SET TIMER:C645(-1)
		
		//__________________________________________________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		If (Form:C1466._index#0)
			
			$o:=Form:C1466._list.getRowCoordinates(Form:C1466._index)
			Form:C1466._focus.setCoordinates($o.left; $o.top; $o.right; $o.bottom).show()
			
			Form:C1466._open.enable()
			
		Else 
			
			Form:C1466._open.disable()
			Form:C1466._focus.hide()
			
		End if 
		
		//__________________________________________________________________________________________
		
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//__________________________________________________________________________________________
End case 