//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_Locked
// ID[F95449718D5844D687507CB9F44CE8B4]
// Created 21-12-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_BOOLEAN:C305($0)
C_TEXT:C284(${1})

C_BOOLEAN:C305($Boo_locked)
C_LONGINT:C283($Lon_i; $Lon_parameters)

If (False:C215)
	C_BOOLEAN:C305(_o_editor_Locked; $0)
	C_TEXT:C284(_o_editor_Locked; ${1})
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
	
	If (Form:C1466.structure#Null:C1517)
		
		$Boo_locked:=Bool:C1537(Form:C1466.structure.unsynchronized)
		
	Else 
		
		$Boo_locked:=Bool:C1537(Form:C1466.$project.structure.unsynchronized)
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
For ($Lon_i; 1; $Lon_parameters; 1)
	
	If (Bool:C1537(Form:C1466.$project.structure.unsynchronized))
		
		OBJECT SET ENTERABLE:C238(*; ${$Lon_i}; Not:C34($Boo_locked))
		
	End if 
End for 

// ----------------------------------------------------
// Return
$0:=$Boo_locked

// ----------------------------------------------------
// End