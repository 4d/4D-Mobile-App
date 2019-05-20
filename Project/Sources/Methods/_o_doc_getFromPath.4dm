//%attributes = {"invisible":true,"preemptive":"capable"}
/*
result := ***_o_doc_getFromPath*** ( selector ; path ; separator )
 -> selector (Text) -  "parent" | "fullName" | "shortName" | "extension" | "volume"
 -> path (Text)
 -> separator (Text) -  If omitted, the separator used is the current platform separator.
 <- result (Text)
________________________________________________________

*/
  // ----------------------------------------------------
  // Method :  _o_doc_getFromPath
  // Created 20/05/10 by Vincent de Lachaux
  // ----------------------------------------------------
  // #THREAD_SAFE
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)
C_TEXT:C284($3)

C_LONGINT:C283($Lon_i;$Lon_parameters)
C_TEXT:C284($kTxt_separator;$Txt_path;$Txt_pattern;$Txt_result;$Txt_selector)

ARRAY LONGINT:C221($tLon_lengths;0)
ARRAY LONGINT:C221($tLon_positions;0)

If (False:C215)
	C_TEXT:C284(_o_doc_getFromPath ;$0)
	C_TEXT:C284(_o_doc_getFromPath ;$1)
	C_TEXT:C284(_o_doc_getFromPath ;$2)
	C_TEXT:C284(_o_doc_getFromPath ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

$kTxt_separator:=Folder separator:K24:12
$kTxt_separator:=$kTxt_separator+($kTxt_separator*Num:C11($kTxt_separator="\\"))

If (Asserted:C1132($Lon_parameters>=2))
	
	$Txt_selector:=$1  // "parent" | "fullName" | "shortName" | "extension" | "volume"
	$Txt_path:=$2
	
	If ($Lon_parameters>=3)
		
		$kTxt_separator:=$3  // If omitted, the separator used is the current platform separator.
		
	End if 
	
	If ($kTxt_separator="\\")
		
		  // The antislash must be escaped in a regular expression !
		$kTxt_separator:=$kTxt_separator*2
		
	End if 
End if 

If (Length:C16($Txt_path)>0)
	
	Case of 
			
			  //……………………………………………………………………
		: ($Txt_selector="parent")
			
			$Txt_pattern:="(?s)^(.*?"+$kTxt_separator+")[^"+$kTxt_separator+"]+"+$kTxt_separator+"*$"
			
			  //……………………………………………………………………
		: ($Txt_selector="fullName")
			
			$Txt_pattern:="(?s)([^"+$kTxt_separator+"]+?)"+$kTxt_separator+"*$"
			
			  //……………………………………………………………………
		: ($Txt_selector="shortName")
			
			$Txt_pattern:="(?m-si)(?:[^"+$kTxt_separator+"]*"+$kTxt_separator+")*(.*)\\.(?:[^\\.]*)$"
			
			  //……………………………………………………………………
		: ($Txt_selector="extension")
			
			If ($Txt_path=("@"+Folder separator:K24:12))
				
				  // Remove the final separator
				$Txt_path:=Delete string:C232($Txt_path;Length:C16($Txt_path);1)
				
			End if 
			
			$Txt_pattern:="(?mi-s)\\.([^\\.]*)$"
			
			  //……………………………………………………………………
		: ($Txt_selector="volume")
			
			$Txt_pattern:="(?mi-s)^\\W*(?:([^:]{1,}:)\\\\[^\\n]*)|(?:\\\\{2}([^\\\\]*)\\\\)|(?:([^:]*):){1}[^\\$]*$"
			
			  //……………………………………………………………………
		Else 
			
			ASSERT:C1129(False:C215;"TRACE")
			
			  //……………………………………………………………………
	End case 
	
	If (Match regex:C1019($Txt_pattern;$Txt_path;1;$tLon_positions;$tLon_lengths))
		
		If ($Txt_selector="volume")
			
			For ($Lon_i;1;Size of array:C274($tLon_lengths);1)
				
				If ($tLon_positions{$Lon_i}>0)
					
					$Txt_result:=Substring:C12($Txt_path;$tLon_positions{$Lon_i};$tLon_lengths{$Lon_i})
					
					$Lon_i:=MAXLONG:K35:2-1  // Break
					
				End if 
			End for 
			
		Else 
			
			$Txt_result:=Substring:C12($Txt_path;$tLon_positions{1};$tLon_lengths{1})
			
		End if 
	End if 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Txt_result

  // ----------------------------------------------------