//%attributes = {"invisible":true,"preemptive":"capable"}
/*
***POST_FORM_MESSAGE*** ( message )
 -> message (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : POST_FORM_MESSAGE
  // Database: 4D Mobile Express
  // ID[9EA6C0AFDD1E426C86CA28F644F30845]
  // Created #3-7-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // #THREAD_SAFE
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($Obj_message)

If (False:C215)
	C_OBJECT:C1216(POST_FORM_MESSAGE ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Obj_message:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Bool:C1537(Num:C11(String:C10($Obj_message.target))#0))
	
	CALL FORM:C1391($Obj_message.target;"DO_MESSAGE";$Obj_message)
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End