//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : BUILD
// ID[0E60C5F1D0B948B0BE313B5059F35010]
// Created 27-4-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Try to make UI building more fluent
// ----------------------------------------------------
// Declarations
#DECLARE($in : Object)

If (False:C215)
	C_OBJECT:C1216(BUILD; $1)
End if 

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	$in:=$1
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------

EDITOR.build:=True:C214  // Stop reentrance

POST_MESSAGE(New object:C1471(\
"target"; $in.caller; \
"action"; "show"; \
"type"; "progress"; \
"title"; Get localized string:C991("product")+" - "+PROJECT.product.name+" ["+Choose:C955(PROJECT._buildTarget="android"; "Android"; "iOS")+"]"; \
"additional"; Get localized string:C991("preparations"); \
"autostart"; New object:C1471("action"; "build_run"; "method"; "EDITOR_RESUME"; "project"; $in)))
