// ----------------------------------------------------
// Object method : RIBBON.151 (Build & Run button)
// ID[B7D612925297469AAD7F6709D491ED2E]
// Created 19-11-2020 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $bottom; $left; $right; $top : Integer
var $e : Object
var $menu : cs:C1710.menu

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($e.code=On Mouse Enter:K2:33)
		
		RIBBON(Num:C11($e.objectName))
		
		//______________________________________________________
	: ($e.code=On Mouse Leave:K2:34)
		
		RIBBON(Num:C11($e.objectName))
		
		//______________________________________________________
	: ($e.code=On Clicked:K2:4)
		
		// Autosave
		PROJECT.save()
		
		If (FEATURE.with("android"))
			
			If (Is Windows:C1573)
				
				PROJECT.buildTarget:="android"
				CALL SUBFORM CONTAINER:C1086(-151)
				
			Else 
				
				$menu:=cs:C1710.menu.new()
				
				$menu.append(cs:C1710.str.new("buildAndRunFor").localized("iOS"); "ios").enable(Bool:C1537(PROJECT.$project.xCode.ready))
				$menu.append(cs:C1710.str.new("buildAndRunFor").localized("Android"); "android").enable(True:C214)  //#MARK_TODO
				
				OBJECT GET COORDINATES:C663(*; $e.objectName; $left; $top; $right; $bottom)
				$menu.popup($left; $bottom)
				
				If ($menu.selected)
					
					PROJECT.buildTarget:=$menu.choice
					CALL SUBFORM CONTAINER:C1086(-151)
					
				End if 
			End if 
			
		Else 
			
			CALL SUBFORM CONTAINER:C1086(-151)
			
		End if 
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 