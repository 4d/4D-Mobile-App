//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : str_trimTrailing
  // ID[B5D9DE30480B450FB1A8B09A8C8DCC85]
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

C_LONGINT:C283($Lon_length;$Lon_parameters;$Lon_position)
C_TEXT:C284($Txt_pattern;$Txt_toTrim;$Txt_trim;$Txt_trimmed)

If (False:C215)
	C_TEXT:C284(str_trimTrailing ;$0)
	C_TEXT:C284(str_trimTrailing ;$1)
	C_TEXT:C284(str_trimTrailing ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_toTrim:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Txt_trim:=$2
		
	End if 
	
	If (Length:C16($Txt_trim)=0)
		
		$Txt_pattern:="(?m-si)^(\\s*)"
		
	Else 
		
		$Txt_pattern:="(?m-si)^(TRIM*)"
		$Txt_pattern:=Replace string:C233($Txt_pattern;"TRIM";$Txt_trim;*)
		
	End if 
	
	$Txt_trimmed:=$Txt_toTrim
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Match regex:C1019($Txt_pattern;$Txt_toTrim;1;$Lon_position;$Lon_length;*))
	
	$Txt_trimmed:=Delete string:C232($Txt_toTrim;$Lon_position;$Lon_length)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Txt_trimmed

  // ----------------------------------------------------
  // End