//%attributes = {"invisible":true}
/*
out := ***ob_setProperties*** ( in ; properties )
 -> in (Object)
 -> properties (Object) - {"name1";"value1";…;"nameN";"valueN"}
 <- out (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : ob_setProperties
  // Database: 4D Mobile App
  // ID[B00EFC0F8600415A91DD6D2CE6536318]
  // Created #15-4-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($t)
C_OBJECT:C1216($Obj_in;$Obj_out;$Obj_properties)

If (False:C215)
	C_OBJECT:C1216(ob_setProperties ;$0)
	C_OBJECT:C1216(ob_setProperties ;$1)
	C_OBJECT:C1216(ob_setProperties ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	$Obj_properties:=$2  //{"name1";"value1";…;"nameN";"valueN"}
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		  // <NONE>
		
	End if 
	
	$Obj_out:=$Obj_in
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
For each ($t;$Obj_properties)
	
	$Obj_out[$t]:=$Obj_properties[$t]
	
End for each 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End