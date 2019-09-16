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

C_LONGINT:C283($Lon_error;$Lon_i;$Lon_parameters)
C_TEXT:C284($Txt_filtered;$Txt_formated;$Txt_selector;$Txt_string)

ARRAY TEXT:C222($tTxt_keywords;0)

If (False:C215)
	C_TEXT:C284(formatString ;$0)
	C_TEXT:C284(formatString ;$1)
	C_TEXT:C284(formatString ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Txt_selector:=$1
	$Txt_string:=$2
	
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
	: ($Txt_selector="bundleApp")
		
		  // Replace accented characters with non accented one.
		$Txt_formated:=str ($Txt_string).unaccented()
		
		
		  // Remove space, other accent, special characters
		$Lon_error:=Rgx_SubstituteText ("[^a-zA-Z0-9\\.]";"-";->$Txt_formated;0)
		
		  //______________________________________________________
	: ($Txt_selector="short-label")
		
		$Txt_formated:=formatString ("label";$Txt_string)
		
		If (Length:C16($Txt_formated)>10)
			
			$Txt_formated:=Substring:C12($Txt_formated;1;10)
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="label")
		
		Case of 
				
				  //______________________________________________________
			: (Get database localization:C1009(Current localization:K5:22)="ja")  //#ACI0099182
				
				$Txt_formated:=$Txt_string
				
				  //______________________________________________________
			Else 
				
				$Txt_string:=Replace string:C233($Txt_string;"_";" ")
				
				  // Camelcase to spaced
				If (Rgx_SubstituteText ("(?m-si)([[:lower:]])([[:upper:]])";"\\1 \\2";->$Txt_string)=0)
					
					$Txt_string:=Lowercase:C14($Txt_string)
					
				End if 
				
				  // Capitalize first letter of words
				GET TEXT KEYWORDS:C1141($Txt_string;$tTxt_keywords)
				
				For ($Lon_i;1;Size of array:C274($tTxt_keywords);1)
					
					If (Length:C16($tTxt_keywords{$Lon_i})>3)\
						 | ($Lon_i=1)
						
						$tTxt_keywords{$Lon_i}[[1]]:=Uppercase:C13($tTxt_keywords{$Lon_i}[[1]])
						
					End if 
					
					$Txt_formated:=$Txt_formated+((" ")*Num:C11($Lon_i>1))+$tTxt_keywords{$Lon_i}
					
				End for 
				
				  //______________________________________________________
		End case 
		
		  //______________________________________________________
	: ($Txt_selector="table-name")
		
		  // Start with alpha
		  // Could start with capital letter (no need to lowercase)
		  // No space
		
		If (Length:C16($Txt_string)>0)
			
			  // Remove the forbidden at beginning characters
			$Lon_error:=Rgx_SubstituteText ("(?mi-s)^[^[:alpha:]]*([^$]*)$";"\\1";->$Txt_string;0)
			$Txt_string:=Replace string:C233($Txt_string;".";" ")  // #98373
			
			  // Replace accented characters with non accented one.
			$Txt_string:=str ($Txt_string).unaccented()  // #98381
			
			  // Remove space {
			GET TEXT KEYWORDS:C1141($Txt_string;$tTxt_keywords)
			
			If (Size of array:C274($tTxt_keywords)>1)
				
				For ($Lon_i;1;Size of array:C274($tTxt_keywords);1)
					
					$tTxt_keywords{$Lon_i}[[1]]:=Uppercase:C13($tTxt_keywords{$Lon_i}[[1]])
					
					$Txt_formated:=$Txt_formated+$tTxt_keywords{$Lon_i}
					
				End for 
				
			Else 
				
				$Txt_string[[1]]:=Uppercase:C13($Txt_string[[1]])
				$Txt_formated:=$Txt_string
				
			End if 
			  //}
			
		End if 
		
		  // Modify the forbidden names
		OB GET ARRAY:C1229(JSON Parse:C1218(Document to text:C1236(Get 4D folder:C485(Current resources folder:K5:16)+"Resources.json"));"coreDataForbiddenNames";$tTxt_keywords)
		
		If (Find in array:C230($tTxt_keywords;$Txt_formated)>0)
			
			$Txt_formated:=$Txt_formated+"_"
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="field-name")
		
		  // Start with alpha
		  // Start with lowercase letter
		  // No space
		
		Case of 
				
				  //----------------------------------------
			: (Position:C15(".";$Txt_string)>0)
				
				$Txt_formated:=Split string:C1554($Txt_string;".").map("col_formula";"$1.result:=formatString (\""+$Txt_selector+"\";$1.value)").join(".")
				
				  //----------------------------------------
			: (Length:C16($Txt_string)>0)
				
				  // Remove the forbidden at beginning characters
				$Lon_error:=Rgx_SubstituteText ("(?mi-s)^[^[:alpha:]]*([^$]*)$";"\\1";->$Txt_string;0)
				$Txt_string:=Replace string:C233($Txt_string;".";" ")  // #98373
				
				  // Replace accented characters with non accented one.
				$Txt_string:=str ($Txt_string).unaccented()
				
				$Txt_string[[1]]:=Lowercase:C14($Txt_string[[1]])
				
				  // Remove space {
				GET TEXT KEYWORDS:C1141($Txt_string;$tTxt_keywords)
				
				If (Size of array:C274($tTxt_keywords)>1)
					
					For ($Lon_i;1;Size of array:C274($tTxt_keywords);1)
						
						If ($Lon_i>1)
							
							$tTxt_keywords{$Lon_i}[[1]]:=Uppercase:C13($tTxt_keywords{$Lon_i}[[1]])
							
						End if 
						
						$Txt_formated:=$Txt_formated+$tTxt_keywords{$Lon_i}
						
					End for 
					
				Else 
					
					$Txt_formated:=$Txt_string
					
				End if 
				  //}
				
				  //----------------------------------------
		End case 
		
		  // Modify the forbidden names
		OB GET ARRAY:C1229(JSON Parse:C1218(Document to text:C1236(Get 4D folder:C485(Current resources folder:K5:16)+"Resources.json"));"coreDataForbiddenNames";$tTxt_keywords)
		
		If (Find in array:C230($tTxt_keywords;$Txt_formated)>0)
			
			$Txt_formated:=$Txt_formated+"_"
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="coreData")
		
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
		
		ASSERT:C1129(False:C215;"Unknown selector: \""+$Txt_selector+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$Txt_formated

  // ----------------------------------------------------
  // End