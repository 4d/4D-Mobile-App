//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : formatString
  // ID[9D65A98F933547C0975AC5641FC271BC]
  // Created 24-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($i;$lError;$number)
C_TEXT:C284($t_format;$t_formated;$t_string)

ARRAY TEXT:C222($aTxt_words;0)

If (False:C215)
	C_TEXT:C284(formatString ;$0)
	C_TEXT:C284(formatString ;$1)
	C_TEXT:C284(formatString ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=2;"Missing parameter"))
	
	  // Required parameters
	$t_format:=$1
	$t_string:=$2
	
	  // Optional parameters
	If (Count parameters:C259>=3)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($t_format="bundleApp")
		
		  // Replace accented characters with non accented one.
		$t_formated:=str ($t_string).unaccented()
		
		  // Remove space, other accent, special characters
		$lError:=Rgx_SubstituteText ("[^a-zA-Z0-9\\.]";"-";->$t_formated;0)
		
		  //______________________________________________________
	: ($t_format="short-label")
		
		$t_formated:=formatString ("label";$t_string)
		
		If (Length:C16($t_formated)>10)
			
			$t_formated:=Substring:C12($t_formated;1;10)
			
		End if 
		
		  //______________________________________________________
	: ($t_format="label")
		
		Case of 
				
				  //______________________________________________________
			: (Not:C34(Match regex:C1019("(?mi-s)^[[:ascii:]]*$";$t_string;1)))  //#ACI0099182
				
				$t_formated:=$t_string
				
				  //______________________________________________________
			Else 
				
				$t_string:=Replace string:C233($t_string;"_";" ")
				
				  // Camelcase to spaced
				If (Rgx_SubstituteText ("(?m-si)([[:lower:]])([[:upper:]])";"\\1 \\2";->$t_string)=0)
					
					$t_string:=Lowercase:C14($t_string)
					
				End if 
				
				  // Capitalize first letter of words
				GET TEXT KEYWORDS:C1141($t_string;$aTxt_words)
				$number:=Size of array:C274($aTxt_words)
				
				For ($i;1;$number;1)
					
					If (Length:C16($aTxt_words{$i})>3)\
						 | ($i=1)
						
						$aTxt_words{$i}[[1]]:=Uppercase:C13($aTxt_words{$i}[[1]])
						
					End if 
					
					$t_formated:=$t_formated+((" ")*Num:C11($i>1))+$aTxt_words{$i}
					
				End for 
				
				  //______________________________________________________
		End case 
		
		  //______________________________________________________
	: ($t_format="table-name")
		
		  // Start with alpha
		  // Could start with capital letter (no need to lowercase)
		  // No space
		
		If (Length:C16($t_string)>0)
			
			  // Remove the forbidden at beginning characters
			$lError:=Rgx_SubstituteText ("(?mi-s)^[^[:alpha:]]*([^$]*)$";"\\1";->$t_string;0)
			$t_string:=Replace string:C233($t_string;".";" ")  // #98373
			
			  // Replace accented characters with non accented one.
			$t_string:=str ($t_string).unaccented()  // #98381
			
			  // Remove space {
			GET TEXT KEYWORDS:C1141($t_string;$aTxt_words)
			$number:=Size of array:C274($aTxt_words)
			
			If ($number>1)
				
				For ($i;1;$number;1)
					
					$aTxt_words{$i}[[1]]:=Uppercase:C13($aTxt_words{$i}[[1]])
					
					$t_formated:=$t_formated+$aTxt_words{$i}
					
				End for 
				
			Else 
				
				$t_string[[1]]:=Uppercase:C13($t_string[[1]])
				$t_formated:=$t_string
				
			End if 
			  //}
			
		End if 
		
		  // Modify the forbidden names
		If (SHARED.resources.coreDataForbiddenNames.indexOf($t_formated)#-1)
			
			$t_formated:=$t_formated+"_"
			
		End if 
		
		  //______________________________________________________
	: ($t_format="field-name")
		
		  // Start with alpha
		  // Start with lowercase letter
		  // No space
		
		Case of 
				
				  //----------------------------------------
			: (Position:C15(".";$t_string)>0)
				
				$t_formated:=Split string:C1554($t_string;".").map("col_formula";"$1.result:=formatString (\""+$t_format+"\";$1.value)").join(".")
				
				  //----------------------------------------
			: (Length:C16($t_string)>0)
				
				  // Remove the forbidden at beginning characters
				$lError:=Rgx_SubstituteText ("(?mi-s)^[^[:alpha:]]*([^$]*)$";"\\1";->$t_string;0)
				$t_string:=Replace string:C233($t_string;".";" ")  // #98373
				
				  // Replace accented characters with non accented one.
				$t_string:=str ($t_string).unaccented()
				
				$t_string[[1]]:=Lowercase:C14($t_string[[1]])
				
				  // Remove space {
				GET TEXT KEYWORDS:C1141($t_string;$aTxt_words)
				$number:=Size of array:C274($aTxt_words)
				
				If ($number>1)
					
					For ($i;1;$number;1)
						
						If ($i>1)
							
							$aTxt_words{$i}[[1]]:=Uppercase:C13($aTxt_words{$i}[[1]])
							
						End if 
						
						$t_formated:=$t_formated+$aTxt_words{$i}
						
					End for 
					
				Else 
					
					$t_formated:=$t_string
					
				End if 
				  //}
				
				  //----------------------------------------
		End case 
		
		  // Modify the forbidden names
		If (SHARED.resources.coreDataForbiddenNames.indexOf($t_formated)#-1)
			
			$t_formated:=$t_formated+"_"
			
		End if 
		
		
		  //______________________________________________________
	: ($t_format="coreData")
		
		  //If (Length($Txt_string)>0)
		  //  //#MARK_TODO - Remove the forbidden at beginning characters
		  //  // First character in lowercase
		  //$Txt_string[[1]]:=Lowercase($Txt_string[[1]])
		  //  // Remove space {
		  //GET TEXT KEYWORDS($Txt_string;$tTxt_keywords)
		  //If (Size of array($tTxt_keywords)>1)
		  //For ($Lon_i;1;Size of array($tTxt_keywords);1)
		  //$tTxt_keywords{$Lon_i}:=Lowercase($tTxt_keywords{$Lon_i})
		  //If ($Lon_i>1)
		  //$tTxt_keywords{$Lon_i}[[1]]:=Uppercase($tTxt_keywords{$Lon_i}[[1]])
		  //End if
		  //$Txt_formated:=$Txt_formated+$tTxt_keywords{$Lon_i}
		  //End for
		  //Else
		  //$Txt_formated:=$Txt_string
		  //End if
		  //  //}
		  //End if
		
		ASSERT:C1129(False:C215;"Obsolete entry point")
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown selector: \""+$t_format+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$t_formated

  // ----------------------------------------------------
  // End