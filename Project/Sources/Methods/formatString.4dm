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

C_LONGINT:C283($i; $number)
C_TEXT:C284($t_format; $t_formated; $t_string)

ARRAY TEXT:C222($aTxt_words; 0)

If (False:C215)
	C_TEXT:C284(formatString; $0)
	C_TEXT:C284(formatString; $1)
	C_TEXT:C284(formatString; $2)
End if 

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=2; "Missing parameter"))
	
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
		
		//MARK:- urlScheme
	: ($t_format="urlScheme")
		
		// Replace accented characters with non accented one.
		$t_formated:=cs:C1710.str.new($t_string).unaccented()
		
		// Remove space, other accent, special characters
		$t_formated:=cs:C1710.regex.new($t_formated; "[^-+\\.a-zA-Z0-9]").substitute("-")
		
		//MARK:- bundleApp
	: ($t_format="bundleApp")
		
		// Replace accented characters with non accented one.
		$t_formated:=cs:C1710.str.new($t_string).trim()
		$t_formated:=cs:C1710.str.new($t_formated).unaccented()
		
		// Remove space, other accent, special characters
		$t_formated:=cs:C1710.regex.new($t_formated; "[^a-zA-Z0-9\\.]").substitute("-")
		
		//MARK:- short-label
	: ($t_format="short-label")
		
		$t_formated:=formatString("label"; $t_string)
		
		If (Length:C16($t_formated)>10)
			
			$t_formated:=Substring:C12($t_formated; 1; 10)
			
		End if 
		
		//MARK:- label
	: ($t_format="label")
		
		Case of 
				
				//______________________________________________________
			: (Not:C34(Match regex:C1019("(?mi-s)^[[:ascii:]]*$"; $t_string; 1)))  //#ACI0099182
				
				$t_formated:=$t_string
				
				//______________________________________________________
			Else 
				
				$t_string:=Replace string:C233($t_string; "_"; " ")
				
				// Camelcase to spaced
				$t_string:=Lowercase:C14(cs:C1710.regex.new($t_string; "(?m-si)([[:lower:]])([[:upper:]])").substitute("\\1 \\2"))
				
				// Capitalize first letter of words
				GET TEXT KEYWORDS:C1141($t_string; $aTxt_words)
				$number:=Size of array:C274($aTxt_words)
				
				For ($i; 1; $number; 1)
					
					If (Length:C16($aTxt_words{$i})>3)\
						 | ($i=1)
						
						$aTxt_words{$i}[[1]]:=Uppercase:C13($aTxt_words{$i}[[1]])
						
					End if 
					
					$t_formated:=$t_formated+((" ")*Num:C11($i>1))+$aTxt_words{$i}
					
				End for 
				
				//______________________________________________________
		End case 
		
		//MARK:- table-name
	: ($t_format="table-name")
		
		// Start with alpha
		// Could start with capital letter (no need to lowercase)
		// No space
		
		If (Length:C16($t_string)>0)
			
			// Remove the forbidden at beginning characters
			$t_string:=cs:C1710.regex.new($t_string; "(?mi-s)^[^[:alpha:]]*([^$]*)$").substitute("\\1")
			
			// Replace dot by space
			$t_string:=Replace string:C233($t_string; "."; " ")  // #98373
			
			// Replace accented characters with non accented one.
			$t_string:=cs:C1710.str.new($t_string).unaccented()  // #98381
			
			// Remove space {
			GET TEXT KEYWORDS:C1141($t_string; $aTxt_words)
			$number:=Size of array:C274($aTxt_words)
			
			If ($number>1)
				
				For ($i; 1; $number; 1)
					
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
		
		//MARK:- field-name
	: ($t_format="field-name")
		
		// Start with alpha
		// Start with lowercase letter
		// No space
		
		Case of 
				
				//----------------------------------------
			: (Position:C15("."; $t_string)>0)
				
				$t_formated:=Split string:C1554($t_string; ".").map(Formula:C1597(col_formula).source; Formula:C1597($1.result:=formatString($t_format; $1.value))).join(".")
				// $t_formated:=Split string($t_stringh; ".").map(Formula(formatString($t_format; $1.value))).join(".")
				
				//----------------------------------------
			: (Length:C16($t_string)>0)
				
				// Remove the forbidden at beginning characters
				$t_string:=cs:C1710.regex.new($t_string; "(?mi-s)^[^[:alpha:]]*([^$]*)$").substitute("\\1")
				
				// Replace dot by space
				$t_string:=Replace string:C233($t_string; "."; " ")  // #98373
				
				// Replace accented characters with non accented one.
				$t_string:=cs:C1710.str.new($t_string).unaccented()
				
				If (Length:C16($t_string)>0)
					
					$t_string[[1]]:=Lowercase:C14($t_string[[1]])
					
					// Remove space {
					GET TEXT KEYWORDS:C1141($t_string; $aTxt_words)
					$number:=Size of array:C274($aTxt_words)
					
					If ($number>1)
						
						For ($i; 1; $number; 1)
							
							If ($i>1)
								
								$aTxt_words{$i}[[1]]:=Uppercase:C13($aTxt_words{$i}[[1]])
								
							End if 
							
							$t_formated:=$t_formated+$aTxt_words{$i}
							
						End for 
						
					Else 
						
						$t_formated:=$t_string
						
					End if 
				End if 
				//}
				
				//----------------------------------------
		End case 
		
		// Modify the forbidden names
		If (SHARED.resources.coreDataForbiddenNames.indexOf($t_formated)#-1)
			
			$t_formated:=$t_formated+"_"
			
		End if 
		
		//MARK:- storyboardProduct
	: ($t_format="storyboardProduct")
		
		C_LONGINT:C283($l)
		C_TEXT:C284($t; $tt)
		
		// Space and some charaters are replaced by _
		// Some accuented charactere are replaced by one without accent but with _
		// japanese, other ss all are not replaced...
		
		$t:=$t_string
		$tt:="abcdefghijklmnopqrstuvwxyz"
		For ($i; 1; Length:C16($tt); 1)
			
			$l:=0
			
			Repeat 
				
				$l:=Position:C15($tt[[$i]]; $t; $l+1)
				
				If ($l>0)
					
					If (Position:C15($t[[$l]]; Uppercase:C13($t[[$l]]; *); *)>0)
						
						// UPPERCASE
						$t[[$l]]:=Uppercase:C13($t[[$l]])
						
					Else 
						
						// lowercase
						$t[[$l]]:=Lowercase:C14($t[[$l]])
						
					End if 
				End if 
			Until ($l=0)
		End for 
		
		$t_formated:=""
		For ($i; 1; Length:C16($t); 1)
			$t_formated:=$t_formated+$t[[$i]]
			If (Compare strings:C1756($t[[$i]]; $t_string[[$i]]; 0)#0)
				$t_formated:=$t_formated+"_"
			End if 
		End for 
		
		$t_formated:=Replace string:C233($t_formated; " "; "_")
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown selector: \""+$t_format+"\"")
		
		//______________________________________________________
End case 

// ----------------------------------------------------
// Return
$0:=$t_formated

// ----------------------------------------------------
// End