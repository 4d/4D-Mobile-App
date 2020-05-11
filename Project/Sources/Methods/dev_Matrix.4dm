//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : dev_Matrix
  // ID[97D0B2121EB04F4AB112F94A4342ABEE]
  // Created 16-3-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)

C_BOOLEAN:C305($Boo_throwAssert)
C_LONGINT:C283($Lon_parameters)

If (False:C215)
	C_BOOLEAN:C305(dev_Matrix ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Boo_throwAssert:=(Structure file:C489=Structure file:C489(*))  // Dev mode

  // ----------------------------------------------------
  // Return
$0:=$Boo_throwAssert

  // ----------------------------------------------------
  // End