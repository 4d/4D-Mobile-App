//%attributes = {"invisible":true}
/*
***LOG_EVENT*** ( in )
 -> in (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : LOG_EVENT
  // Database: 4D Mobile Express
  // ID[96B758353E7C46B2AC1896B15D9C0058]
  // Created #14-9-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_importance;$Lon_parameters)
C_TEXT:C284($Txt_header)
C_OBJECT:C1216($Obj_in)

If (False:C215)
	C_OBJECT:C1216(LOG_EVENT ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Txt_header:=Choose:C955(Bool:C1537($Obj_in.header);$Obj_in.header;"[4D Mobile] ")
	$Lon_importance:=Choose:C955(Bool:C1537($Obj_in.importance);$Obj_in.importance;Warning message:K38:2)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
LOG EVENT:C667(Into 4D debug message:K38:5;$Txt_header+$Obj_in.message;$Lon_importance)

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End