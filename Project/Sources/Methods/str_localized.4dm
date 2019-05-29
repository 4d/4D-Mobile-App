//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : str_localized
  // Database: 4D Mobile Express
  // ID[1F8E6A001AB447E9AE074F87F3CF3227]
  // Created #7-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Returns a text by concatenation of the members of the collection.
  // Firts a localized text is searched for the given item.
  // If found (you passed a resname), the localized string is used, otherwise the
  // item text is used.
  //
  // If the localized string contains variable elements "{xxx}",
  // they are replaced by the next members of the collection
  // ----------------------------------------------------
  // #THREAD_SAFE
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_COLLECTION:C1488($1)

C_BOOLEAN:C305($Boo_multistyle)
C_LONGINT:C283($Lon_i;$Lon_j;$Lon_parameters)
C_TEXT:C284($Txt_buffer;$Txt_replacement;$Txt_string)
C_COLLECTION:C1488($Coll_strings)

ARRAY TEXT:C222($tTxt_replacement;0)

If (False:C215)
	C_TEXT:C284(str_localized ;$0)
	C_COLLECTION:C1488(str_localized ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Coll_strings:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Asserted:C1132($Coll_strings.length>0;"Empty collection"))
	
	For ($Lon_i;0;$Coll_strings.length-1;1)
		
		$Txt_buffer:=Get localized string:C991($Coll_strings[$Lon_i])
		$Txt_buffer:=Choose:C955(OK=1;$Txt_buffer;$Coll_strings[$Lon_i])  // Revert if no localization
		
		$Boo_multistyle:=(Position:C15("</span>";$Txt_buffer)>0)
		
		If (Rgx_ExtractText ("(?m-si)(\\{[\\w\\s]+\\})";$Txt_buffer;"1";->$tTxt_replacement)=0)
			
			For ($Lon_j;1;Size of array:C274($tTxt_replacement);1)
				
				  // Use the next available value for replacement
				If (Asserted:C1132(($Lon_i+1)<=($Coll_strings.length-1);"Missing items into the collection"))
					
					$Lon_i:=$Lon_i+1
					
					$Txt_replacement:=Get localized string:C991($Coll_strings[$Lon_i])
					$Txt_replacement:=Choose:C955(OK=1;$Txt_replacement;$Coll_strings[$Lon_i])
					
					If ($Boo_multistyle)
						
						$Txt_replacement:=Replace string:C233($Txt_replacement;"&";"&amp;")
						$Txt_replacement:=Replace string:C233($Txt_replacement;"<";"&lt;")
						$Txt_replacement:=Replace string:C233($Txt_replacement;">";"&gt;")
						
					End if 
					
					$Txt_buffer:=Replace string:C233($Txt_buffer;$tTxt_replacement{$Lon_j};$Txt_replacement)
					
				Else 
					
					$Lon_i:=MAXLONG:K35:2-1
					$Lon_j:=MAXLONG:K35:2-1
					
				End if 
			End for 
			
		Else 
			
			If ($Boo_multistyle)
				
				$Txt_replacement:=Replace string:C233($Txt_replacement;"&";"&amp;")
				$Txt_replacement:=Replace string:C233($Txt_replacement;"<";"&lt;")
				$Txt_replacement:=Replace string:C233($Txt_replacement;">";"&gt;")
				
			End if 
		End if 
		
		$Txt_string:=$Txt_string+$Txt_buffer
		
	End for 
End if 

  // ----------------------------------------------------
$0:=$Txt_string

  // ----------------------------------------------------
  // End