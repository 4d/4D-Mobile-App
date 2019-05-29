//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : WAIT_FORM_MESSAGE
  // Database: 4D Mobile App
  // ID[E2B348F707724D33B2987738CBEFA828]
  // Created #10-4-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($Obj_message)

If (False:C215)
	C_OBJECT:C1216(WAIT_FORM_MESSAGE ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_message:=$1
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Bool:C1537(Num:C11(String:C10($Obj_message.target))#0))
	
	$Obj_message.signal:=New signal:C1641
	
	CALL FORM:C1391($Obj_message.target;"DO_MESSAGE";$Obj_message)
	
	$Obj_message.signal.wait()
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End