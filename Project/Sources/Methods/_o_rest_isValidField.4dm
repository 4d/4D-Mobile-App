//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : rest_isValidField
  // ID[0F0D6B3602C94E3BA39832C6C701DEA9]
  // Created 30-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Check if a field is available thru the REST API
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_valid)
C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($Obj_field)

If (False:C215)
	C_BOOLEAN:C305(_o_rest_isValidField ;$0)
	C_OBJECT:C1216(_o_rest_isValidField ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_field:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //…………………………………………………………………………
	: ($Obj_field=Null:C1517)
		
		  //…………………………………………………………………………
	: ($Obj_field.type=18)  // Is BLOB
		
		  //…………………………………………………………………………
	: ($Obj_field.type=21)  // Is object
		
		  //…………………………………………………………………………
	: (Bool:C1537($Obj_field.hide_in_REST))
		
		  //…………………………………………………………………………
	Else 
		
		$Boo_valid:=True:C214
		
		  //…………………………………………………………………………
End case 

  // ----------------------------------------------------
  // Return
$0:=$Boo_valid

  // ----------------------------------------------------
  // End