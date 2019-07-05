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
C_OBJECT:C1216($2)

C_BLOB:C604($x)
C_BOOLEAN:C305($b)
C_LONGINT:C283($i;$l;$Lon_length;$Lon_position)
C_TEXT:C284($t;$Txt_filtered;$Txt_pattern;$Txt_result)
C_OBJECT:C1216($o)
C_COLLECTION:C1488($c)

ARRAY TEXT:C222($tTxt_keywords;0)

If (False:C215)
	C_OBJECT:C1216(str ;$0)
	C_TEXT:C284(str ;$1)
	C_OBJECT:C1216(str ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470._is=Null:C1517)
	
	$o:=New object:C1471(\
		"_is";"str";\
		"value";String:C10($1);\
		"length";0;\
		"setText";Formula:C1597(str ("setText";New object:C1471("value";String:C10($1))));\
		"uperCamelCase";Formula:C1597(str ("uperCamelCase").value);\
		"lowerCamelCase";Formula:C1597(str ("lowerCamelCase").value);\
		"unaccented";Formula:C1597(str ("unaccented").value);\
		"trim";Formula:C1597(str ("trim";New object:C1471("pattern";$1)).value);\
		"trimTrailing";Formula:C1597(str ("trimTrailing";New object:C1471("pattern";$1)).value);\
		"trimLeading";Formula:C1597(str ("trimLeading";New object:C1471("pattern";$1)).value);\
		"wordWrap";Formula:C1597(str ("wordWrap";New object:C1471("length";$1)).value);\
		"spaceSeparated";Formula:C1597(str ("spaceSeparated").value);\
		"isStyled";Formula:C1597(str ("isStyled").value);\
		"isBoolean";Formula:C1597(str ("isBoolean").value);\
		"isDate";Formula:C1597(str ("isDate").value);\
		"isNum";Formula:C1597(str ("isNum").value);\
		"isTime";Formula:C1597(str ("isTime").value);\
		"contains";Formula:C1597(str ("contains";New object:C1471("pattern";String:C10($1);"diacritical";Bool:C1537($2))).value);\
		"match";Formula:C1597(str ("match";New object:C1471("pattern";$1)).value);\
		"fixedLength";Formula:C1597(str ("fixedLength";New object:C1471("length";$1;"filler";$2;"alignment";$3)).value);\
		"distinctLetters";Formula:C1597(str ("distinctLetters";New object:C1471("delimiter";$1)).value);\
		"equal";Formula:C1597(str ("equal";New object:C1471("with";$1)).value);\
		"encode";Formula:C1597(str ("encode").value);\
		"decode";Formula:C1597(str ("decode").value);\
		"quoted";Formula:C1597("\""+This:C1470.value+"\"");\
		"singleQuoted";Formula:C1597("'"+This:C1470.value+"'")\
		)
	
	$o.length:=Length:C16($o.value)
	
Else 
	
	Case of 
			
			  //=======================================================================================================
		: (This:C1470=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //=======================================================================================================
		: ($1="setText")  // Defines the contents of the string & returns the updated object string
			
			$o:=This:C1470
			$o.value:=$2.value
			$o.length:=Length:C16($o.value)
			
			  //=======================================================================================================
		Else 
			
			$o:=New object:C1471(\
				"value";"")
			
			Case of 
					
					  //______________________________________________________
				: ($1="contains")  // Returns True if the passed text is present in the string (diacritical if $2 is True)
					
					If ($2.diacritical)
						
						  // Diacritical query
						$o.value:=(Position:C15($2.pattern;This:C1470.value;*)#0)
						
					Else 
						
						$o.value:=(Position:C15($2.pattern;This:C1470.value)#0)
						
					End if 
					
					  //______________________________________________________
				: ($1="encode")  // Returns a URL encoded string
					
					  // List of safe characters
					$t:="1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz:/.?_-$(){}~&"
					
					If (This:C1470.length>0)
						
						  // Use the UTF-8 character set for encoding
						CONVERT FROM TEXT:C1011(This:C1470.value;"utf-8";$x)
						
						  // Convert the characters
						For ($i;0;BLOB size:C605($x)-1;1)
							
							If (Position:C15(Char:C90($x{$i});$t;*)>0)
								
								  // It's a safe character, append unaltered
								$o.value:=$o.value+Char:C90($x{$i})
								
							Else 
								
								  // It's an unsafe character, append as a hex string
								$o.value:=$o.value+"%"+Substring:C12(String:C10($x{$i};"&x");5)
								
							End if 
						End for 
					End if 
					
					  //______________________________________________________
				: ($1="decode")  // Returns a URL decoded string
					
					SET BLOB SIZE:C606($x;This:C1470.length+1;0)
					
					$t:=This:C1470.value
					
					For ($i;1;This:C1470.length;1)
						
						Case of 
								
								  //________________________________________
							: ($t[[$i]]="%")
								
								$x{$Lon_length}:=Position:C15(Substring:C12($t;$i+1;1);"123456789ABCDEF")*16\
									+Position:C15(Substring:C12($t;$i+2;1);"123456789ABCDEF")
								
								$i:=$i+2
								
								  //________________________________________
							Else 
								
								$x{$Lon_length}:=Character code:C91($t[[$i]])
								
								  //________________________________________
						End case 
						
						$Lon_length:=$Lon_length+1
						
					End for 
					
					  // Convert from UTF-8
					SET BLOB SIZE:C606($x;$Lon_length)
					
					$o.value:=Convert to text:C1012($x;"utf-8")
					
					  //______________________________________________________
				: ($1="equal")  // Returns True if the string passed is exactly the same as the value.
					
					$o.value:=New collection:C1472(This:C1470.value).equal(New collection:C1472($2.with);ck diacritical:K85:3)
					
					  //______________________________________________________
				: ($1="distinctLetters")  // Returns the list of distinct letters of the string…
					
					$c:=Split string:C1554(This:C1470.value;"").distinct().sort()
					
					If ($2.delimiter#Null:C1517)  // …as string if delimiter is passed
						
						$o.value:=$c.join(String:C10($2.delimiter))
						
					Else   // …as collection
						
						$o.value:=$c
						
					End if 
					
					  //______________________________________________________
				: ($1="fixedLength")  // Returns value as fixed length string
					
					$l:=Num:C11($2.length)
					ASSERT:C1129($l>0)
					
					If ($2.filler#Null:C1517)
						
						$t:=String:C10($2.filler)
						
					Else 
						
						  // Default is space
						$t:="*"
						
					End if 
					
					If (Num:C11($2.alignment)=Align right:K42:4)
						
						$o.value:=Substring:C12(($t*($l-This:C1470.length))+This:C1470.value;1;$l)
						
					Else 
						
						  // Default is left
						$o.value:=Substring:C12(This:C1470.value+($t*$l);1;$l)
						
					End if 
					
					  //______________________________________________________
				: ($1="uperCamelCase")  // Returns value as upper camelcase
					
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
				: ($1="lowerCamelCase")  // Returns value as lower camelcase
					
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
				: ($1="spaceSeparated")  // Returns underscored value & camelcase (lower or upper) value as space separated
					
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
					
					If ($2.pattern#Null:C1517)
						
						$Txt_pattern:="(?m-si)^(TRIM*)"
						$Txt_pattern:=Replace string:C233($Txt_pattern;"TRIM";String:C10($2.pattern);*)
						
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
					
					If ($2.pattern#Null:C1517)
						
						$Txt_pattern:="(?m-si)^(TRIM*)"
						$Txt_pattern:=Replace string:C233($Txt_pattern;"TRIM";String:C10($2.pattern);*)
						
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
				: ($1="wordWrap")  // Returns a word wrapped text based on the line length given (default is 80 characters)
					
					If ($2.length#Null:C1517)
						
						$l:=Num:C11($2.length)
						ASSERT:C1129($l>0)
						
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
					$o.value:=Match regex:C1019("(?m-si)^\\d+"+$t+"\\d+(?:"+$t+"\\d+)?$";String:C10(This:C1470.value);1)
					
					  //______________________________________________________
				: ($1="match")  // Returns True if text match given pattern
					
					$o.value:=Match regex:C1019(String:C10($2.pattern);String:C10(This:C1470.value);1)
					
					  //______________________________________________________
					  //: (Formula(process ).call().isPreemptif)
					
					  //_4D THROW ERROR(New object("component";"CLAS";"code";1;"description";"The method "+String($1)+"() for class "+String(This._is)+" can't be called in preemptive mode";"something";"my bug"))
					
					  //______________________________________________________
				: ($1="isStyled")  // Returns True if text is styled
					
					  //#BYPASS THREAD-SAFE COMPATIBILITY
					$t:=Replace string:C233(String:C10(This:C1470.value);"\r\n";"\r")
					$Txt_filtered:=Formula from string:C1601(":C1092($1)").call(Null:C1517;$t)
					$Txt_result:=Formula from string:C1601(":C1116($1)").call(Null:C1517;$t)
					
					$o.value:=($Txt_result#$Txt_filtered)
					
					  //______________________________________________________
				Else 
					
					ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
					
					  //______________________________________________________
			End case 
			
			  //=======================================================================================================
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End