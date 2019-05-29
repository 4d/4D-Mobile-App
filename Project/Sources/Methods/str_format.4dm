//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : str_format
  // Database: 4D Mobile App
  // ID[DD9BFFB6CA314863B05F3EB12C73391E]
  // Created #4-12-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_i;$Lon_parameters)
C_TEXT:C284($Txt_filtered;$Txt_formated;$Txt_selector;$Txt_string)

ARRAY TEXT:C222($tTxt_keywords;0)

If (False:C215)
	C_TEXT:C284(str_format ;$0)
	C_TEXT:C284(str_format ;$1)
	C_TEXT:C284(str_format ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Txt_selector:=$1
	$Txt_string:=$2
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Txt_selector="uperCamelCase")
		
		If (Length:C16($Txt_string)>2)
			
			GET TEXT KEYWORDS:C1141($Txt_string;$tTxt_keywords)
			
			For ($Lon_i;1;Size of array:C274($tTxt_keywords);1)
				
				$tTxt_keywords{$Lon_i}:=Lowercase:C14($tTxt_keywords{$Lon_i})
				$tTxt_keywords{$Lon_i}[[1]]:=Uppercase:C13($tTxt_keywords{$Lon_i}[[1]])
				
				$Txt_formated:=$Txt_formated+$tTxt_keywords{$Lon_i}
				
			End for 
			
		Else 
			
			$Txt_formated:=Lowercase:C14($Txt_formated)
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="lowerCamelCase")
		
		GET TEXT KEYWORDS:C1141($Txt_string;$tTxt_keywords)
		
		For ($Lon_i;1;Size of array:C274($tTxt_keywords);1)
			
			$tTxt_keywords{$Lon_i}:=Lowercase:C14($tTxt_keywords{$Lon_i})
			
			If ($Lon_i>1)
				
				$tTxt_keywords{$Lon_i}[[1]]:=Uppercase:C13($tTxt_keywords{$Lon_i}[[1]])
				
			End if 
			
			$Txt_formated:=$Txt_formated+$tTxt_keywords{$Lon_i}
			
		End for 
		
		  //______________________________________________________
	: ($Txt_selector="replace-accent")
		
		$Txt_formated:=$Txt_string
		
		If (Length:C16($Txt_formated)>0)
			
			  // Replace accented characters with non accented one.
			  // XXX not very efficient
			
			$Txt_filtered:="ÀÁÂÃÄÅ"
			
			For ($Lon_i;1;Length:C16($Txt_filtered);1)
				
				$Txt_formated:=Replace string:C233($Txt_formated;$Txt_filtered[[$Lon_i]];"A";*)
				
			End for 
			
			$Txt_filtered:="àáâãäå"
			
			For ($Lon_i;1;Length:C16($Txt_filtered);1)
				
				$Txt_formated:=Replace string:C233($Txt_formated;$Txt_filtered[[$Lon_i]];"a";*)
				
			End for 
			
			$Txt_filtered:="ÈÉÊË"
			
			For ($Lon_i;1;Length:C16($Txt_filtered);1)
				
				$Txt_formated:=Replace string:C233($Txt_formated;$Txt_filtered[[$Lon_i]];"E";*)
				
			End for 
			
			$Txt_filtered:="èéêë"
			
			For ($Lon_i;1;Length:C16($Txt_filtered);1)
				
				$Txt_formated:=Replace string:C233($Txt_formated;$Txt_filtered[[$Lon_i]];"e";*)
				
			End for 
			
			$Txt_filtered:="ÌÍÎÏ"
			
			For ($Lon_i;1;Length:C16($Txt_filtered);1)
				
				$Txt_formated:=Replace string:C233($Txt_formated;$Txt_filtered[[$Lon_i]];"I";*)
				
			End for 
			
			$Txt_filtered:="ÒÓÔÕÖ"
			
			For ($Lon_i;1;Length:C16($Txt_filtered);1)
				
				$Txt_formated:=Replace string:C233($Txt_formated;$Txt_filtered[[$Lon_i]];"O";*)
				
			End for 
			
			$Txt_filtered:="ðòóôõö"
			
			For ($Lon_i;1;Length:C16($Txt_filtered);1)
				
				$Txt_formated:=Replace string:C233($Txt_formated;$Txt_filtered[[$Lon_i]];"o";*)
				
			End for 
			
			$Txt_filtered:="ÙÚÛÜ"
			
			For ($Lon_i;1;Length:C16($Txt_filtered);1)
				
				$Txt_formated:=Replace string:C233($Txt_formated;$Txt_filtered[[$Lon_i]];"U";*)
				
			End for 
			
			$Txt_filtered:="ùúûü"
			
			For ($Lon_i;1;Length:C16($Txt_filtered);1)
				
				$Txt_formated:=Replace string:C233($Txt_formated;$Txt_filtered[[$Lon_i]];"u";*)
				
			End for 
			
			$Txt_filtered:="ćĉčċçḉȼ"
			
			For ($Lon_i;1;Length:C16($Txt_filtered);1)
				
				$Txt_formated:=Replace string:C233($Txt_formated;$Txt_filtered[[$Lon_i]];"c";*)
				
			End for 
			
			$Txt_filtered:="ĆĈČĊÇḈȻȻ"
			
			For ($Lon_i;1;Length:C16($Txt_filtered);1)
				
				$Txt_formated:=Replace string:C233($Txt_formated;$Txt_filtered[[$Lon_i]];"C";*)
				
			End for 
			
			$Txt_filtered:="ŃǸŇÑṄŅṆṊṈN̈"
			
			For ($Lon_i;1;Length:C16($Txt_filtered);1)
				
				$Txt_formated:=Replace string:C233($Txt_formated;$Txt_filtered[[$Lon_i]];"N";*)
				
			End for 
			
			$Txt_filtered:="ņńǹňñṅṇṋṉn̈"
			
			For ($Lon_i;1;Length:C16($Txt_filtered);1)
				
				$Txt_formated:=Replace string:C233($Txt_formated;$Txt_filtered[[$Lon_i]];"n";*)
				
			End for 
			
			$Txt_formated:=Replace string:C233($Txt_formated;"ß";"ss";*)
			$Txt_formated:=Replace string:C233($Txt_formated;"Æ";"AE";*)
			$Txt_formated:=Replace string:C233($Txt_formated;"æ";"ae";*)
			$Txt_formated:=Replace string:C233($Txt_formated;"œ";"oe";*)
			$Txt_formated:=Replace string:C233($Txt_formated;"Œ";"OE";*)
			$Txt_formated:=Replace string:C233($Txt_formated;"∂";"d";*)
			$Txt_formated:=Replace string:C233($Txt_formated;"∆";"D";*)
			$Txt_formated:=Replace string:C233($Txt_formated;"ƒ";"f";*)
			$Txt_formated:=Replace string:C233($Txt_formated;"µ";"u";*)
			$Txt_formated:=Replace string:C233($Txt_formated;"π";"p";*)
			$Txt_formated:=Replace string:C233($Txt_formated;"∏";"P";*)
			
		End if 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown selector: \""+$Txt_selector+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$Txt_formated

  // ----------------------------------------------------
  // End