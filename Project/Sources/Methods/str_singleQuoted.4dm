//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : str_singleQuoted
  // Database: 4D Mobile Express
  // ID[D695CFA3CE9A4257B7464E259CAA2C21]
  // Created #28-6-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // #THREAD_SAFE
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_in;$Txt_out)

If (False:C215)
	C_TEXT:C284(str_singleQuoted ;$0)
	C_TEXT:C284(str_singleQuoted ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Txt_in:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Txt_out:="'"+$Txt_in+"'"

  // ----------------------------------------------------
  // Return
$0:=$Txt_out

  // ----------------------------------------------------
  // End