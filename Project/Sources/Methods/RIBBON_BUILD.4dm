//%attributes = {"invisible":true}
// ----------------------------------------------------
// Object method : RIBBON.151 (Build & Run button)
// ID[B7D612925297469AAD7F6709D491ED2E]
// Created 19-11-2020 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $bottom; $left; $right; $top : Integer
var $device; $e : Object
var $menu : cs:C1710.menu

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($e.code=On Mouse Enter:K2:33)
		
		If (OBJECT Get enabled:C1079(*; $e.objectName))
			
			RIBBON(Num:C11($e.objectName))
			
		Else 
			
/*
If (PROJECT._buildTarget#Null)
			
Case of 
			
//______________________________________________________
: ((PROJECT._buildTarget="ios") & Bool(Not(Bool(EDITOR.xCode.ready))))
			
SET DATABASE PARAMETER(Tips enabled; 1)
SET DATABASE PARAMETER(Tips delay; 1)
OBJECT SET HELP TIP(*; $e.objectName; ".Xcode is not ready")
			
//______________________________________________________
: (False)
			
//______________________________________________________
Else 
			
// A "Case of" statement should never omit "Else"
//______________________________________________________
End case 
			
Else 
			
Case of 
			
//______________________________________________________
: (PROJECT.$ios & Bool(Not(Bool(EDITOR.xCode.ready))))
			
SET DATABASE PARAMETER(Tips enabled; 1)
SET DATABASE PARAMETER(Tips delay; 1)
OBJECT SET HELP TIP(*; $e.objectName; ".Xcode is not ready")
			
//______________________________________________________
: (PROJECT.$android & Bool(Not(Bool(EDITOR.studio.ready))))
			
SET DATABASE PARAMETER(Tips enabled; 1)
SET DATABASE PARAMETER(Tips delay; 1)
OBJECT SET HELP TIP(*; $e.objectName; ".Android studio is not ready")
			
//______________________________________________________
Else 
			
// A "Case of" statement should never omit "Else"
//______________________________________________________
End case 
End if 
*/
			
		End if 
		
		
		//______________________________________________________
	: ($e.code=On Mouse Leave:K2:34)
		
		RIBBON(Num:C11($e.objectName))
		
		//______________________________________________________
	: ($e.code=On Clicked:K2:4)
		
		// Autosave
		PROJECT.save()
		
		If (PROJECT._simulator#Null:C1517)\
			 & (PROJECT._buildTarget#Null:C1517)
			
			CALL SUBFORM CONTAINER:C1086(-151)
			
		Else 
			
			POST_MESSAGE(New object:C1471(\
				"target"; Form:C1466.editor.$mainWindow; \
				"action"; "show"; \
				"type"; "alert"; \
				"title"; "youMustFirstSelectASimulator"))
			
		End if 
		
		//______________________________________________________
		
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 