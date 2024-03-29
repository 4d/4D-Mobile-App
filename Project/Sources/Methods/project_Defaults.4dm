//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : project_Defaults
// ID[91A8D069DBD54A97BA0CA6EFD5C8D3AC]
// Created 3-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)

C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($Obj_default)

If (False:C215)
	C_OBJECT:C1216(project_Defaults; $0)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	
	// Optional parameters
	If ($Lon_parameters>=1)
		
		// <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
$Obj_default:=New object:C1471(\
"create"; True:C214; \
"build"; False:C215; \
"run"; False:C215; \
"sdk"; "iphonesimulator"; \
"template"; "list"; \
"testing"; False:C215; \
"archive"; False:C215\
)

// Caller is the UI window reference
// For an execution without UI editor_CALLBACK caller must be 0
$Obj_default.caller:=0

// ----------------------------------------------------
// Return
$0:=$Obj_default

// ----------------------------------------------------
// End