//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : str_trim
  // Database: 4D Mobile App
  // ID[866BA214BBE54608B4E93EEB48B21E13]
  // Created 8-6-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // #THREAD-SAFE
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_toTrim;$Txt_trim;$Txt_trimmed)

If (False:C215)
	C_TEXT:C284(str_trim ;$0)
	C_TEXT:C284(str_trim ;$1)
	C_TEXT:C284(str_trim ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Txt_toTrim:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		$Txt_trim:=$2
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Txt_trimmed:=str_trimLeading (str_trimTrailing ($Txt_toTrim;$Txt_trim);$Txt_trim)

  // ----------------------------------------------------
  // Return
$0:=$Txt_trimmed
  // ----------------------------------------------------
  // End