//%attributes = {"invisible":true}
/*
string := ***str_date*** ( entrypoint ; date ; hour )
 -> entrypoint (Text)
 -> date (Date)
 -> hour (Time)
 <- string (Text)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : str_date
  // Database: 4D Mobile App
  // ID[9B02BB49FB2F459891FEA4B3176DC081]
  // Created #30-1-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Date to string
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_DATE:C307($2)
C_TIME:C306($3)

C_DATE:C307($Dat_date)
C_LONGINT:C283($Lon_parameters)
C_TIME:C306($Gmt_hour)
C_TEXT:C284($Txt_entrypoint;$Txt_string)

If (False:C215)
	C_TEXT:C284(str_date ;$0)
	C_TEXT:C284(str_date ;$1)
	C_DATE:C307(str_date ;$2)
	C_TIME:C306(str_date ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_entrypoint:=$1
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Dat_date:=$2
		
		If ($Lon_parameters>=3)
			
			$Gmt_hour:=$3
			
		End if 
	End if 
	
	If ($Dat_date=!00-00-00!)
		
		$Dat_date:=Current date:C33
		
	End if 
	
	If ($Gmt_hour=?00:00:00?)
		
		$Gmt_hour:=Current time:C178
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Txt_entrypoint="stamp")
		
		$Txt_string:=String:C10($Dat_date;ISO date GMT:K1:10;$Gmt_hour)
		$Txt_string:=Replace string:C233($Txt_string;"T";" ")
		$Txt_string:=Replace string:C233($Txt_string;":";"-")
		$Txt_string:=Replace string:C233($Txt_string;"Z";"")
		
		  //______________________________________________________
	: (False:C215)
		
		  //______________________________________________________
	Else 
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$Txt_string

  // ----------------------------------------------------
  // End