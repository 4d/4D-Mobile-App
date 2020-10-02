Class extends tools

Class constructor
	var $1 : Text
	
	Super:C1705()
	
	This:C1470.value:=""
	
	If (Count parameters:C259>=1)
		
		This:C1470.setText($1)
		
	End if 
	
	//=======================================================================================================
	// Defines the contents of the string & returns the updated object string
Function setText
	var $1 : Text
	
	This:C1470.value:=$1
	This:C1470.length:=Length:C16($1)
	
	//=======================================================================================================
	// Returns True if the passed text is present in the string (diacritical if $2 is True)
Function contains
	var $0 : Boolean
	var $1 : Text
	var $2 : Boolean
	var $isDiacritical : Boolean
	
	If (Count parameters:C259>=2)
		
		$isDiacritical:=$2
		
	End if 
	
	If ($isDiacritical)
		
		$0:=(Position:C15($1; This:C1470.value; *)#0)
		
	Else 
		
		$0:=(Position:C15($1; This:C1470.value)#0)
		
	End if 
	
	//=======================================================================================================
Function shuffle
	var $0 : Text
	var $1 : Integer
	var $pattern; $t; $text : Text
	var $i; $length; $size : Integer
	
	$pattern:="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ,?;.:/=+@#&([{§!)]}-_$€*`£"
	
	If (Length:C16(This:C1470.value)=0)
		
		$text:=$pattern*2
		
	Else 
		
		For each ($t; Split string:C1554(This:C1470.value; ""))
			
			If (Position:C15($t; $pattern)>0)
				
				$text:=$text+$t
				
			End if 
		End for each 
		
		$text:=$text*2
		
	End if 
	
	If (Count parameters:C259>=1)
		
		$size:=$1
		
	Else 
		
		// A "If" statement should never omit "Else"
		
	End if 
	
	$length:=Choose:C955($size=0; Choose:C955(10>Length:C16($text); Length:C16($text); 10); Choose:C955($size>Length:C16($text); Length:C16($text); $size))
	
	$size:=Length:C16($text)
	
	For ($i; 1; $length; 1)
		
		$0:=$0+$text[[(Random:C100%($size-1+1))+1]]
		
	End for 
	
	//=======================================================================================================
	// Returns a base64 encoded UTF-8 string
Function base64
	var $0 : Text
	var $1 : Boolean
	
	var $encoded : Boolean
	var $x : Blob
	
	If (Count parameters:C259>=1)
		$encoded:=$1
	End if 
	
	CONVERT FROM TEXT:C1011(This:C1470.value; "utf-8"; $x)
	
	If ($encoded)
		
		BASE64 ENCODE:C895($x; $0; *)
		
	Else 
		
		BASE64 ENCODE:C895($x; $0)
		
	End if 
	
	//=======================================================================================================
	// Returns an URL-safe base64url encoded UTF-8 string
Function urlBase64Encode
	var $0 : Text
	
	//$0:=This.base64()
	//$0:=Replace string($0; "+"; "-"; *)
	//$0:=Replace string($0; "/"; "_"; *)
	//$0:=Replace string($0; "="; ""; *)
	
	$0:=This:C1470.base64(True:C214)
	
	//=======================================================================================================
	// Returns an URL encoded string
Function urlEncode
	var $0 : Text
	
	var $pattern : Text
	var $i : Integer
	var $x : Blob
	
	// List of safe characters
	$pattern:="1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz:/.?_-$(){}~&@"
	
	If (This:C1470.length>0)
		
		// Use the UTF-8 character set for encoding
		CONVERT FROM TEXT:C1011(This:C1470.value; "utf-8"; $x)
		
		// Convert the characters
		For ($i; 0; BLOB size:C605($x)-1; 1)
			
			If (Position:C15(Char:C90($x{$i}); $pattern; *)>0)
				
				// It's a safe character, append unaltered
				$0:=$0+Char:C90($x{$i})
				
			Else 
				
				// It's an unsafe character, append as a hex string
				$0:=$0+"%"+Substring:C12(String:C10($x{$i}; "&x"); 5)
				
			End if 
		End for 
	End if 
	
	//=======================================================================================================
	// Returns an URL decoded string
Function urlDecode
	var $0 : Text
	
	var $t : Text
	var $i; $length : Integer
	var $x : Blob
	
	SET BLOB SIZE:C606($x; This:C1470.length+1; 0)
	$t:=This:C1470.value
	
	For ($i; 1; This:C1470.length; 1)
		
		Case of 
				
				//________________________________________
			: ($t[[$i]]="%")
				
				$x{$length}:=Position:C15(Substring:C12($t; $i+1; 1); "123456789ABCDEF")*16\
					+Position:C15(Substring:C12($t; $i+2; 1); "123456789ABCDEF")
				$i:=$i+2
				
				//________________________________________
			Else 
				
				$x{$length}:=Character code:C91($t[[$i]])
				
				//________________________________________
		End case 
		
		$length:=$length+1
		
	End for 
	
	// Convert from UTF-8
	SET BLOB SIZE:C606($x; $length)
	$0:=Convert to text:C1012($x; "utf-8")
	
	//=======================================================================================================
	// Returns True if the string passed is exactly the same as the value.
Function equal
	var $0 : Boolean
	var $1 : Text
	
	$0:=New collection:C1472(This:C1470.value).equal(New collection:C1472($1); ck diacritical:K85:3)
	
	//=======================================================================================================
	// Returns the list of distinct letters of the string.
Function distinctLetters
	var $0 : Variant  // Collection or string if delimiter is passed
	var $1 : Text  // {delimiter}
	
	var $c : Collection
	
	$c:=Split string:C1554(This:C1470.value; "").distinct().sort()
	
	If (Count parameters:C259>=1)  // …as string if delimiter is passed
		
		$0:=$c.join($1)
		
	Else   // …as collection
		
		$0:=$c
		
	End if 
	
	//=======================================================================================================
	// Returns value as fixed length string
Function fixedLength
	var $0 : Text
	var $1 : Integer  // Length
	var $2 : Text  // {Filler}
	var $3 : Integer  // {Alignment}
	
	var $filler : Text
	var $alignment : Integer
	
	If (Count parameters:C259>=2)
		
		$filler:=$2
		
		If (Count parameters:C259>=3)
			
			$alignment:=$3
			
		End if 
		
	Else 
		
		// Default is space
		$filler:=" "
		
	End if 
	
	If ($alignment=Align right:K42:4)
		
		$0:=Substring:C12(($filler*($1-This:C1470.length))+This:C1470.value; 1; $1)
		
	Else 
		
		// Default is left
		$0:=Substring:C12(This:C1470.value+($filler*$1); 1; $1)
		
	End if 
	
	//=======================================================================================================
	// Returns value as upper camelcase
Function uperCamelCase
	var $0 : Text
	
	var $t : Text
	var $i : Integer
	var $c : Collection
	ARRAY TEXT:C222($keywords; 0)
	
	If (Length:C16(This:C1470.value)>0)
		
		If (Length:C16(This:C1470.value)>2)
			
			$t:=This:C1470.spaceSeparated()
			GET TEXT KEYWORDS:C1141($t; $keywords)
			$c:=New collection:C1472
			
			For ($i; 1; Size of array:C274($keywords); 1)
				
				$keywords{$i}:=Lowercase:C14($keywords{$i})
				$keywords{$i}[[1]]:=Uppercase:C13($keywords{$i}[[1]])
				$c.push($keywords{$i})
				
			End for 
			
			$0:=$c.join()
			
		Else 
			
			$0:=Lowercase:C14(This:C1470.value)
			
		End if 
	End if 
	
	//=======================================================================================================
	// Returns value as lower camelcase
Function lowerCamelCase
	var $0 : Text
	
	var $t : Text
	var $i : Integer
	var $c : Collection
	
	ARRAY TEXT:C222($keywords; 0)
	
	$t:=This:C1470.spaceSeparated()
	GET TEXT KEYWORDS:C1141($t; $keywords)
	$c:=New collection:C1472
	
	For ($i; 1; Size of array:C274($keywords); 1)
		
		$keywords{$i}:=Lowercase:C14($keywords{$i})
		
		If ($i>1)
			
			$keywords{$i}[[1]]:=Uppercase:C13($keywords{$i}[[1]])
			
		End if 
		
		$c.push($keywords{$i})
		
	End for 
	
	$0:=$c.join()
	
	//=======================================================================================================
	// Returns underscored value & camelcase (lower or upper) value as space separated
Function spaceSeparated
	var $0 : Text
	
	var $t : Text
	var $i; $l : Integer
	var $c : Collection
	
	ARRAY TEXT:C222($keywords; 0)
	
	$t:=Replace string:C233(This:C1470.value; "_"; " ")
	$c:=New collection:C1472
	COLLECTION TO ARRAY:C1562(Split string:C1554($t; ""); $keywords)
	$t:=Lowercase:C14($t)
	$l:=1
	
	For ($i; 2; Size of array:C274($keywords); 1)
		
		If (Character code:C91($keywords{$i})#Character code:C91($t[[$i]]))  // Cesure
			
			$c.push(Substring:C12($t; $l; $i-$l))
			$l:=$i
			
		End if 
	End for 
	
	$c.push(Substring:C12($t; $l))
	
	For each ($t; $c)
		
		$0:=$0+Uppercase:C13($t[[1]])+Lowercase:C14(Substring:C12($t; 2))+" "
		
	End for each 
	
	//=======================================================================================================
	// Trims leading spaces or passed
Function trimLeading
	var $0 : Text
	var $1 : Text
	
	var $pattern; $t : Text
	var $length; $position : Integer
	
	If (Count parameters:C259>=1)
		
		$pattern:="(?m-si)^(TRIM*)"
		$pattern:=Replace string:C233($pattern; "TRIM"; $1; *)
		
	Else 
		
		$pattern:="(?m-si)^(\\s*)"
		
	End if 
	
	$t:=Split string:C1554(This:C1470.value; "").reverse().join("")
	
	$0:=This:C1470.value
	
	If (Match regex:C1019($pattern; $t; 1; $position; $length; *))
		
		$0:=Split string:C1554(Delete string:C232($t; $position; $length); "").reverse().join("")
		
	End if 
	
	//=======================================================================================================
	// Trims Trailing spaces or passed
Function trimTrailing
	var $0 : Text
	var $1 : Text
	
	var $pattern; $t : Text
	var $length; $position : Integer
	
	If (Count parameters:C259>=1)
		
		$pattern:="(?m-si)^(TRIM*)"
		$pattern:=Replace string:C233($pattern; "TRIM"; $1; *)
		
	Else 
		
		$pattern:="(?m-si)^(\\s*)"
		
	End if 
	
	$t:=This:C1470.value
	
	$0:=This:C1470.value
	
	If (Match regex:C1019($pattern; $t; 1; $position; $length; *))
		
		$0:=Delete string:C232(This:C1470.value; $position; $length)
		
	End if 
	
	//=======================================================================================================
	// Trims leading & trailing spaces or passed
Function trim
	var $0 : Text
	var $1 : Text
	
	var $pattern; $t : Text
	var $length; $position : Integer
	
	If (Count parameters:C259>=1)
		
		$pattern:="(?m-si)^(TRIM*)"
		$pattern:=Replace string:C233($pattern; "TRIM"; $1; *)
		
	Else 
		
		$pattern:="(?m-si)^(\\s*)"
		
	End if 
	
	$0:=This:C1470.value
	
	// trimLeading
	$t:=Split string:C1554($0; "").reverse().join("")
	
	If (Match regex:C1019($pattern; $t; 1; $position; $length; *))
		
		$0:=Split string:C1554(Delete string:C232($t; $position; $length); "").reverse().join("")
		
	End if 
	
	// trimTrailing
	$t:=$0
	
	If (Match regex:C1019($pattern; $t; 1; $position; $length; *))
		
		$0:=Delete string:C232($t; $position; $length)
		
	End if 
	
	//=======================================================================================================
	// Returns a word wrapped text based on the line length given (default is 80 characters)
Function wordWrap
	var $0 : Text
	var $1 : Integer  // {Line length}
	
	var $pattern; $result; $t : Text
	var $match : Boolean
	var $l; $length; $position : Integer
	
	If (Count parameters:C259>=1)
		
		$l:=$1
		
	Else 
		
		$l:=79
		
	End if 
	
	$pattern:="^(.{1,COL}|\\S{COL,})(?:\\s[^\\S\\r\\n]*|\\Z)"
	$pattern:=Replace string:C233($pattern; "COL"; String:C10($l); 1; *)
	$pattern:=Replace string:C233($pattern; "COL"; String:C10($l+1); 1; *)
	
	$t:=This:C1470.value
	
	Repeat 
		
		$match:=Match regex:C1019($pattern; $t; 1; $position; $length; *)
		
		If ($match)
			
			$result:=$result+Substring:C12($t; 1; $length)+"\r"
			$t:=Delete string:C232($t; 1; $length)
			
		Else 
			
			If (Length:C16($t)>0)
				
				$result:=$result+$t
				
			Else 
				
				// Remove the last carriage return
				$result:=Delete string:C232($result; Length:C16($result); 1)
				
			End if 
		End if 
	Until (Not:C34($match))
	
	$0:=$result
	
	//=======================================================================================================
	// Replace accented characters with non accented one
Function unaccented
	var $0 : Text
	
	var $t : Text
	var $i; $index : Integer
	
	$0:=This:C1470.value
	
	If (Length:C16($0)>0)
		
		// Specific cases
		$0:=Replace string:C233($0; "ȼ"; "c"; *)
		$0:=Replace string:C233($0; "Ȼ"; "C"; *)
		$0:=Replace string:C233($0; "Ð"; "D"; *)
		$0:=Replace string:C233($0; "Đ"; "D"; *)
		$0:=Replace string:C233($0; "đ"; "d"; *)
		$0:=Replace string:C233($0; "Ħ"; "H"; *)
		$0:=Replace string:C233($0; "ħ"; "h"; *)
		$0:=Replace string:C233($0; "ı"; "i"; *)
		$0:=Replace string:C233($0; "Ŀ"; "L"; *)
		$0:=Replace string:C233($0; "Ŀ"; "L"; *)
		$0:=Replace string:C233($0; "ŀ"; "l"; *)
		$0:=Replace string:C233($0; "Ł"; "L"; *)
		$0:=Replace string:C233($0; "ł"; "l"; *)
		$0:=Replace string:C233($0; "Ŋ"; "N"; *)
		$0:=Replace string:C233($0; "ŋ"; "n"; *)
		$0:=Replace string:C233($0; "ŉ"; "n"; *)
		$0:=Replace string:C233($0; "n̈"; "n"; *)
		$0:=Replace string:C233($0; "N̈"; "N"; *)
		$0:=Replace string:C233($0; "Ø"; "O"; *)
		$0:=Replace string:C233($0; "ð"; "o"; *)
		$0:=Replace string:C233($0; "ø"; "o"; *)
		$0:=Replace string:C233($0; "Þ"; "P"; *)
		$0:=Replace string:C233($0; "þ"; "p"; *)
		$0:=Replace string:C233($0; "Ŧ"; "T"; *)
		$0:=Replace string:C233($0; "ŧ"; "t"; *)
		
		$t:="abcdefghijklmnopqrstuvwxyz"
		
		For ($i; 1; Length:C16($t); 1)
			
			$index:=0
			
			Repeat 
				
				$index:=Position:C15($t[[$i]]; $0; $index+1)
				
				If ($index>0)
					
					If (Position:C15($0[[$index]]; Uppercase:C13($0[[$index]]; *); *)>0)
						
						// UPPERCASE
						$0[[$index]]:=Uppercase:C13($0[[$index]])
						
					Else 
						
						// lowercase
						$0[[$index]]:=Lowercase:C14($0[[$index]])
						
					End if 
				End if 
			Until ($index=0)
		End for 
		
		// Miscellaneous
		$0:=Replace string:C233($0; "ß"; "ss"; *)
		$0:=Replace string:C233($0; "Æ"; "AE"; *)
		$0:=Replace string:C233($0; "æ"; "ae"; *)
		$0:=Replace string:C233($0; "œ"; "oe"; *)
		$0:=Replace string:C233($0; "Œ"; "OE"; *)
		$0:=Replace string:C233($0; "∂"; "d"; *)
		$0:=Replace string:C233($0; "∆"; "D"; *)
		$0:=Replace string:C233($0; "ƒ"; "f"; *)
		$0:=Replace string:C233($0; "µ"; "u"; *)
		$0:=Replace string:C233($0; "π"; "p"; *)
		$0:=Replace string:C233($0; "∏"; "P"; *)
		
	End if 
	
	//=======================================================================================================
	// Returns True if the text contains only ASCII characters
Function isAscii
	var $0 : Boolean
	
	$0:=Match regex:C1019("(?mi-s)^[[:ascii:]]*$"; This:C1470.value; 1)
	
	//=======================================================================================================
	// Returns True if text is "T/true" or "F/false"
Function isBoolean
	var $0 : Boolean
	
	$0:=Match regex:C1019("(?m-is)^(?:[tT]rue|[fF]alse)$"; This:C1470.value; 1)
	
	//=======================================================================================================
	// Returns True if the text is a date string (DOES NOT CHECK IF THE DATE IS VALID)
Function isDate
	var $0 : Boolean
	
	$0:=Match regex:C1019("(?m-si)^\\d+/\\d+/\\d+$"; This:C1470.value; 1)
	
	//=======================================================================================================
	// Returns True if text is a numeric
Function isNum
	var $0 : Boolean
	
	var $t : Text
	
	GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $t)
	$0:=Match regex:C1019("(?m-si)^(?:\\+|-)?\\d+(?:\\.|"+$t+"\\d+)?$"; This:C1470.value; 1)
	
	//=======================================================================================================
	//  Returns True if text is a time string (DOES NOT CHECK IF THE TIME IS VALID)
Function isTime
	var $0 : Boolean
	
	var $t : Text
	
	GET SYSTEM FORMAT:C994(Time separator:K60:11; $t)
	$0:=Match regex:C1019("(?m-si)^\\d+"+$t+"\\d+(?:"+$t+"\\d+)?$"; This:C1470.value; 1)
	
	//=======================================================================================================
	// Returns True if the text conforms to the URL grammar. (DOES NOT CHECK IF THE URL IS VALID)
Function isUrl
	var $0 : Boolean
	
	$0:=Match regex:C1019("(?m-si)^(?:(?:https?):// )?(?:localhost|127.0.0.1|(?:\\S+(?::\\S*)?@)?(?:(?!10(?:\\.\\d{1,3}){3})(?!127(?:\\.\\d{1,3}){3}"+\
		")(?!169\\.254(?:\\.\\d{1,3}){2})(?!192\\.168(?:\\.\\d{1,3}){2})(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})(?:[1-9"+\
		"]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|"+\
		"(?:(?:[a-z\\x{00a1}-\\x{ffff}0-9]+-?)*[a-z\\x{00a1}-\\x{ffff}0-9]+)(?:\\.(?:[a-z\\x{00a1}-\\x{ffff}0-9]+-?)*[a-z\\x{00a1"+\
		"}-\\x{ffff}0-9]+)*(?:\\.(?:[a-z\\x{00a1}-\\x{ffff}]{2,}))))(?::\\d{2,5})?(?:/[^\\s]*)?$"; This:C1470.value; 1)
	
	//=======================================================================================================
	// Returns True if text match given pattern
Function match
	var $0 : Boolean
	var $1 : Text
	
	$0:=Super:C1706.match(This:C1470.value; $1)
	
	//=======================================================================================================
	// Returns the localized string & made replacement if any 
Function localized
	var $0 : Text
	var $1 : Variant
	
	$0:=Super:C1706.localized(This:C1470.value; $1)
	
	//=======================================================================================================
	// Concatenates the values ​​given to the original string
Function concat
	var $0 : Text
	var $1 : Variant
	var $2 : Text
	
	var $t; $text; $tSeparator : Text
	
	If (Count parameters:C259>=2)
		
		$tSeparator:=String:C10($2)
		
	Else 
		
		// Default is space
		$tSeparator:=Char:C90(Space:K15:42)
		
	End if 
	
	$0:=This:C1470.value
	
	If (Value type:C1509($1)=Is collection:K8:32)
		
		For each ($t; $1)
			
			$text:=Get localized string:C991($t)
			$text:=Choose:C955(OK=1; $text; $t)
			
			If (Position:C15($tSeparator; $text)#1)\
				 & (Position:C15($tSeparator; $0)#Length:C16($0))
				
				$0:=$0+$tSeparator
				
			End if 
			
			$0:=$0+$text
			
		End for each 
		
	Else 
		
		$text:=Get localized string:C991($1)
		$text:=Choose:C955(OK=1; $text; $1)
		
		If (Position:C15($tSeparator; $text)#1)\
			 & (Position:C15($tSeparator; $0)#Length:C16($0))
			
			$0:=$0+$tSeparator
			
		End if 
		
		$0:=$0+$text
		
	End if 
	
	
	//=======================================================================================================
	// 
Function filter
	var $0 : Variant
	var $1 : Text
	
	var $value; $pattern; $t; $text : Text
	var $length; $position : Integer
	
	Case of 
			
			//…………………………………………………………………………………
		: ($1="numeric")  // Return extract numeric
			
			$pattern:="(?m-si)^\\D*([+-]?\\d+\\{thousand}?\\d*\\{decimal}?\\d?)\\s?\\D*$"
			$value:=This:C1470.value
			GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $t)
			$pattern:=Replace string:C233($pattern; "{decimal}"; $t)
			
			If ($t#".")
				
				$value:=Replace string:C233($value; "."; $t)
				
			End if 
			
			GET SYSTEM FORMAT:C994(Thousand separator:K60:2; $t)
			$pattern:=Replace string:C233($pattern; "{thousand}"; $t)
			
			If (Match regex:C1019($pattern; $value; 1; $position; $length; *))
				
				$text:=$text+Substring:C12($value; 1; $length)
				$value:=Delete string:C232($value; 1; $length)
				
			Else 
				
				If (Length:C16($value)>0)
					
					$text:=$text+$value
					
				End if 
			End if 
			
			$0:=Num:C11($text)
			
			//…………………………………………………………………………………
	End case 
	
	
	
	
	
	
	