//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : str
  // ID[69A5F0B04405480CA4218A430C3322D9]
  // Created #14-6-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_BOOLEAN:C305($b)
C_LONGINT:C283($i;$l;$Lon_length;$Lon_position)
C_TEXT:C284($t;$Txt_filtered;$Txt_pattern;$Txt_result)
C_OBJECT:C1216($o)
C_COLLECTION:C1488($c)

ARRAY TEXT:C222($tTxt_keywords;0)

If (False:C215)
	C_OBJECT:C1216(str ;$0)
	C_TEXT:C284(str ;$1)
	C_TEXT:C284(str ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470._is=Null:C1517)
	
	$o:=New object:C1471(\
		"_is";Current method name:C684;\
		"value";$1;\
		"length";0;\
		"uperCamelCase";Formula:C1597(str ("uperCamelCase").value);\
		"lowerCamelCase";Formula:C1597(str ("lowerCamelCase").value);\
		"unaccented";Formula:C1597(str ("unaccented").value);\
		"trim";Formula:C1597(str ("trim";String:C10($1)).value);\
		"trimTrailing";Formula:C1597(str ("trimTrailing";String:C10($1)).value);\
		"trimLeading";Formula:C1597(str ("trimLeading";String:C10($1)).value);\
		"wordWrap";Formula:C1597(str ("wordWrap";String:C10($1)).value);\
		"spaceSeparated";Formula:C1597(str ("spaceSeparated").value);\
		"isStyled";Formula:C1597(str ("isStyled").value);\
		"isBoolean";Formula:C1597(str ("isBoolean").value);\
		"isDate";Formula:C1597(str ("isDate").value);\
		"isNum";Formula:C1597(str ("isNum").value);\
		"isTime";Formula:C1597(str ("isTime").value);\
		"match";Formula:C1597(str ("match";String:C10($1)).value)\
		)
	
	$o.length:=Length:C16($o.value)
	
Else 
	
	$o:=New object:C1471(\
		"value";"")
	
	Case of 
			
			  //______________________________________________________
		: (This:C1470=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="uperCamelCase")  // Returns name as upper camelcase
			
			If (Length:C16(This:C1470.value)>0)
				If (Length:C16(This:C1470.value)>2)
					
					$t:=This:C1470.spaceSeparated()
					
					GET TEXT KEYWORDS:C1141($t;$tTxt_keywords)
					$c:=New collection:C1472
					
					For ($i;1;Size of array:C274($tTxt_keywords);1)
						
						$tTxt_keywords{$i}:=Lowercase:C14($tTxt_keywords{$i})
						$tTxt_keywords{$i}[[1]]:=Uppercase:C13($tTxt_keywords{$i}[[1]])
						
						$c.push($tTxt_keywords{$i})
						
					End for 
					
					$o.value:=$c.join()
					
				Else 
					
					$o.value:=Lowercase:C14(This:C1470.value)
					
				End if 
			End if 
			
			  //______________________________________________________
		: ($1="lowerCamelCase")  // Returns name as lower camelcase
			
			$t:=This:C1470.spaceSeparated()
			
			GET TEXT KEYWORDS:C1141($t;$tTxt_keywords)
			$c:=New collection:C1472
			
			For ($i;1;Size of array:C274($tTxt_keywords);1)
				
				$tTxt_keywords{$i}:=Lowercase:C14($tTxt_keywords{$i})
				
				If ($i>1)
					
					$tTxt_keywords{$i}[[1]]:=Uppercase:C13($tTxt_keywords{$i}[[1]])
					
				End if 
				
				$c.push($tTxt_keywords{$i})
				
			End for 
			
			$o.value:=$c.join()
			
			  //______________________________________________________
		: ($1="spaceSeparated")  // Returns underscored name & camelcase (lower or upper) name as space separated
			
			$t:=Replace string:C233(This:C1470.value;"_";" ")
			
			$c:=New collection:C1472
			COLLECTION TO ARRAY:C1562(Split string:C1554($t;"");$tTxt_keywords)
			
			$t:=Lowercase:C14($t)
			
			$l:=1
			
			For ($i;2;Size of array:C274($tTxt_keywords);1)
				
				If (Character code:C91($tTxt_keywords{$i})#Character code:C91($t[[$i]]))  // Cesure
					
					$c.push(Substring:C12($t;$l;$i-$l))
					$l:=$i
					
				End if 
			End for 
			
			$c.push(Substring:C12($t;$l))
			
			For each ($t;$c)
				
				$Txt_result:=$Txt_result+Uppercase:C13($t[[1]])+Lowercase:C14(Substring:C12($t;2))+" "
				
			End for each 
			
			$o.value:=$Txt_result
			
			  //______________________________________________________
		: ($1="trimLeading")\
			 | ($1="trimTrailing")  // Trims leading or trailing spaces
			
			If (Length:C16($2)>0)
				
				$Txt_pattern:="(?m-si)^(TRIM*)"
				$Txt_pattern:=Replace string:C233($Txt_pattern;"TRIM";$2;*)
				
			Else 
				
				$Txt_pattern:="(?m-si)^(\\s*)"
				
			End if 
			
			$Txt_result:=This:C1470.value
			
			If ($1="trimLeading")
				
				  // Split & reverse
				$t:=Split string:C1554(This:C1470.value;"").reverse().join("")
				
			Else 
				
				$t:=This:C1470.value
				
			End if 
			
			If (Match regex:C1019($Txt_pattern;$t;1;$Lon_position;$Lon_length;*))
				
				If ($1="trimLeading")
					
					  // Split & reverse
					$Txt_result:=Split string:C1554(Delete string:C232($t;$Lon_position;$Lon_length);"").reverse().join("")
					
				Else 
					
					$Txt_result:=Delete string:C232(This:C1470.value;$Lon_position;$Lon_length)
					
				End if 
			End if 
			
			$o.value:=$Txt_result
			
			  //______________________________________________________
		: ($1="trim")  // Trims leading & trailing spaces
			
			If (Length:C16($2)>0)
				
				$Txt_pattern:="(?m-si)^(TRIM*)"
				$Txt_pattern:=Replace string:C233($Txt_pattern;"TRIM";$2;*)
				
			Else 
				
				$Txt_pattern:="(?m-si)^(\\s*)"
				
			End if 
			
			$Txt_result:=This:C1470.value
			
			  // trimLeading
			$t:=Split string:C1554($Txt_result;"").reverse().join("")
			
			If (Match regex:C1019($Txt_pattern;$t;1;$Lon_position;$Lon_length;*))
				
				$Txt_result:=Split string:C1554(Delete string:C232($t;$Lon_position;$Lon_length);"").reverse().join("")
				
			End if 
			
			  // trimTrailing
			$t:=$Txt_result
			
			If (Match regex:C1019($Txt_pattern;$t;1;$Lon_position;$Lon_length;*))
				
				$Txt_result:=Delete string:C232($t;$Lon_position;$Lon_length)
				
			End if 
			
			$o.value:=$Txt_result
			
			  //______________________________________________________
		: ($1="wordWrap")  // Returns a word wrapped text based on the line length given in $1 (default is 80 characters)
			
			If (Num:C11($1)#0)
				
				$l:=Num:C11($2)
				
			Else 
				
				$l:=79
				
			End if 
			
			$Txt_pattern:="^(.{1,COL}|\\S{COL,})(?:\\s[^\\S\\r\\n]*|\\Z)"
			$Txt_pattern:=Replace string:C233($Txt_pattern;"COL";String:C10($l);1;*)
			$Txt_pattern:=Replace string:C233($Txt_pattern;"COL";String:C10($l+1);1;*)
			
			$t:=This:C1470.value
			
			Repeat 
				
				$b:=Match regex:C1019($Txt_pattern;$t;1;$Lon_position;$Lon_length;*)
				
				If ($b)
					
					$Txt_result:=$Txt_result+Substring:C12($t;1;$Lon_length)+"\r"
					$t:=Delete string:C232($t;1;$Lon_length)
					
				Else 
					
					If (Length:C16($t)>0)
						
						$Txt_result:=$Txt_result+$t
						
					Else 
						
						  // Remove the last carriage return
						$Txt_result:=Delete string:C232($Txt_result;Length:C16($Txt_result);1)
						
					End if 
				End if 
			Until (Not:C34($b))
			
			$o.value:=$Txt_result
			
			  //______________________________________________________
		: ($1="unaccented")  // Replace accented characters with non accented one
			
			  // XXX not very efficient
			
			$t:=This:C1470.value
			
			If (Length:C16($t)>0)
				
				$Txt_filtered:="ÀÁÂÃÄÅ"
				
				For ($i;1;Length:C16($Txt_filtered);1)
					
					$t:=Replace string:C233($t;$Txt_filtered[[$i]];"A";*)
					
				End for 
				
				$Txt_filtered:="àáâãäå"
				
				For ($i;1;Length:C16($Txt_filtered);1)
					
					$t:=Replace string:C233($t;$Txt_filtered[[$i]];"a";*)
					
				End for 
				
				$Txt_filtered:="ÈÉÊË"
				
				For ($i;1;Length:C16($Txt_filtered);1)
					
					$t:=Replace string:C233($t;$Txt_filtered[[$i]];"E";*)
					
				End for 
				
				$Txt_filtered:="èéêë"
				
				For ($i;1;Length:C16($Txt_filtered);1)
					
					$t:=Replace string:C233($t;$Txt_filtered[[$i]];"e";*)
					
				End for 
				
				$Txt_filtered:="ÌÍÎÏ"
				
				For ($i;1;Length:C16($Txt_filtered);1)
					
					$t:=Replace string:C233($t;$Txt_filtered[[$i]];"I";*)
					
				End for 
				
				$Txt_filtered:="ÒÓÔÕÖ"
				
				For ($i;1;Length:C16($Txt_filtered);1)
					
					$t:=Replace string:C233($t;$Txt_filtered[[$i]];"O";*)
					
				End for 
				
				$Txt_filtered:="ðòóôõö"
				
				For ($i;1;Length:C16($Txt_filtered);1)
					
					$t:=Replace string:C233($t;$Txt_filtered[[$i]];"o";*)
					
				End for 
				
				$Txt_filtered:="ÙÚÛÜ"
				
				For ($i;1;Length:C16($Txt_filtered);1)
					
					$t:=Replace string:C233($t;$Txt_filtered[[$i]];"U";*)
					
				End for 
				
				$Txt_filtered:="ùúûü"
				
				For ($i;1;Length:C16($Txt_filtered);1)
					
					$t:=Replace string:C233($t;$Txt_filtered[[$i]];"u";*)
					
				End for 
				
				$Txt_filtered:="ćĉčċçḉȼ"
				
				For ($i;1;Length:C16($Txt_filtered);1)
					
					$t:=Replace string:C233($t;$Txt_filtered[[$i]];"c";*)
					
				End for 
				
				$Txt_filtered:="ĆĈČĊÇḈȻȻ"
				
				For ($i;1;Length:C16($Txt_filtered);1)
					
					$t:=Replace string:C233($t;$Txt_filtered[[$i]];"C";*)
					
				End for 
				
				$Txt_filtered:="ŃǸŇÑṄŅṆṊṈN̈"
				
				For ($i;1;Length:C16($Txt_filtered);1)
					
					$t:=Replace string:C233($t;$Txt_filtered[[$i]];"N";*)
					
				End for 
				
				$Txt_filtered:="ņńǹňñṅṇṋṉn̈"
				
				For ($i;1;Length:C16($Txt_filtered);1)
					
					$t:=Replace string:C233($t;$Txt_filtered[[$i]];"n";*)
					
				End for 
				
				$t:=Replace string:C233($t;"ß";"ss";*)
				$t:=Replace string:C233($t;"Æ";"AE";*)
				$t:=Replace string:C233($t;"æ";"ae";*)
				$t:=Replace string:C233($t;"œ";"oe";*)
				$t:=Replace string:C233($t;"Œ";"OE";*)
				$t:=Replace string:C233($t;"∂";"d";*)
				$t:=Replace string:C233($t;"∆";"D";*)
				$t:=Replace string:C233($t;"ƒ";"f";*)
				$t:=Replace string:C233($t;"µ";"u";*)
				$t:=Replace string:C233($t;"π";"p";*)
				$t:=Replace string:C233($t;"∏";"P";*)
				
			End if 
			
			$o.value:=$t
			
			  //______________________________________________________
		: ($1="isStyled")  // Returns True if text is styled
			
			  //#BYPASS THREAD-SAFE COMPATIBILITY
			  //$Txt_filtered:=Replace string(String(This.value);"\r\n";"\r")
			  //$Txt_result:=$Txt_filtered
			  //$Txt_filtered:=ST Get plain text($Txt_filtered)
			  //$Txt_result:=ST Get text($Txt_result)
			
			$t:=DOCUMENT  // Retain the value of the system variable
			
			DOCUMENT:=Replace string:C233(String:C10(This:C1470.value);"\r\n";"\r")
			EXECUTE FORMULA:C63("DOCUMENT:=:C1092(DOCUMENT)")
			$Txt_filtered:=DOCUMENT
			
			DOCUMENT:=Replace string:C233(String:C10(This:C1470.value);"\r\n";"\r")
			EXECUTE FORMULA:C63("DOCUMENT:=:C1116(DOCUMENT)")
			$Txt_result:=DOCUMENT
			
			DOCUMENT:=$t  // Restore the value of the system variable
			
			$o.value:=($Txt_result#$Txt_filtered)
			
			  //______________________________________________________
		: ($1="isBoolean")  // Returns True if text is "T/true" or "F/false"
			
			$o.value:=Match regex:C1019("(?m-is)^(?:[tT]rue|[fF]alse)$";String:C10(This:C1470.value);1)
			
			  //______________________________________________________
		: ($1="isDate")  // Returns True if the text is a date string (DOES NOT CHECK IF THE DATE IS VALID)
			
			$o.value:=Match regex:C1019("(?m-si)^\\d+/\\d+/\\d+$";String:C10(This:C1470.value);1)
			
			  //______________________________________________________
		: ($1="isNum")  // Returns True if text is a numeric
			
			GET SYSTEM FORMAT:C994(Decimal separator:K60:1;$t)
			$o.value:=Match regex:C1019("(?m-si)^(?:\\+|-)?\\d+(?:\\.|"+$t+"\\d+)?$";String:C10(This:C1470.value);1)
			
			  //______________________________________________________
		: ($1="isTime")  // Returns True if text is a time string (DOES NOT CHECK IF THE TIME IS VALID)
			
			GET SYSTEM FORMAT:C994(Time separator:K60:11;$t)
			$o.value:=Match regex:C1019("(?m-si)^\\d+:\\d+(?:"+$t+"\\d+)?$";String:C10(This:C1470.value);1)
			
			  //______________________________________________________
		: ($1="match")  // Returns True if text match given pattern
			
			$o.value:=Match regex:C1019($2;String:C10(This:C1470.value);1)
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End