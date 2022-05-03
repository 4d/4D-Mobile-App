Class extends tools

Class constructor($content : Variant)
	
	Super:C1705()
	
	This:C1470.value:=""
	
	If (Count parameters:C259>=1)
		
		This:C1470.setText($content)
		
	Else 
		
		This:C1470.length:=0
		This:C1470.styled:=False:C215
		
	End if 
	
	//=======================================================================================================
	// Defines the contents of the string & returns the updated object string
Function setText($content : Variant)->$this : cs:C1710.str
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($content)=Is text:K8:3)
			
			This:C1470.value:=$content
			
			//______________________________________________________
		: (Value type:C1509($content)=Is object:K8:27)\
			 | (Value type:C1509($content)=Is collection:K8:32)
			
			This:C1470.value:=JSON Stringify:C1217($content)
			
			//______________________________________________________
		: (Value type:C1509($content)=Is time:K8:8)
			
			This:C1470.value:=Time string:C180($content)
			
			//______________________________________________________
		Else 
			
			This:C1470.value:=String:C10($content)
			
			//______________________________________________________
	End case 
	
	This:C1470.length:=Length:C16(This:C1470.value)
	This:C1470.styled:=This:C1470.isStyled()
	
	$this:=This:C1470
	
	//=======================================================================================================
	// Insertion of the given text into the current string according to the optianal parameters begin & end
	// Also update the inserted text position into the original string (str.begin & str.end)
Function insert($text : Text; $begin : Integer; $end : Integer)->$this : cs:C1710.str
	
	var $length; $start; $stop : Integer
	
	If (Length:C16($text)>0)
		
		If (Count parameters:C259>=2)
			
			$start:=$begin
			
			If (Count parameters:C259>=3)
				
				$stop:=$end
				
			End if 
		End if 
		
		This:C1470.begin:=$start
		
		If ($stop>$start)
			
			// Replace the selection with the string to insert
			This:C1470.value:=Substring:C12(This:C1470.value; 1; $start-1)+$text+Substring:C12(This:C1470.value; $stop)
			
			This:C1470.end:=$start+Length:C16($text)-1
			
		Else 
			
			// Insert the chain at the insertion point
			$length:=Length:C16(This:C1470.value)  // Keep the current length
			This:C1470.value:=Insert string:C231(This:C1470.value; $text; $start)
			
			If ($start=$length)
				
				// We were at the end of the text and we stay
				This:C1470.end:=Length:C16(This:C1470.value)  //+1
				
			Else 
				
				// The insertion point is translated from the length of the inserted string
				This:C1470.end:=$start+Length:C16($text)
				
			End if 
		End if 
		
		This:C1470.length:=Length:C16(This:C1470.value)
		
	Else 
		
		This:C1470.begin:=0
		This:C1470.end:=0
		
	End if 
	
	$this:=This:C1470
	
	//=======================================================================================================
	// Append the given text to the current string according eventualy use the optional separator text
	// Also update the inserted text position into the original string (str.begin & str.end)
Function append($text : Text; $separator : Text)->$this : cs:C1710.str
	
	If (Length:C16($text)>0)
		
		This:C1470.begin:=Length:C16(This:C1470.value)
		This:C1470.value+=$separator+$text
		This:C1470.end:=Length:C16(This:C1470.value)
		
		This:C1470.length:=Length:C16(This:C1470.value)
		
	Else 
		
		This:C1470.begin:=0
		This:C1470.end:=0
		
	End if 
	
	$this:=This:C1470
	
	//=======================================================================================================
	// Returns True if the $toFind text is present in the string (diacritical if $2 is True)
Function containsString($target : Text; $toFind; $diacritical : Boolean)->$contains : Boolean
	
	Case of 
			//______________________________________________________
		: (Count parameters:C259=3)
			
			return $diacritical ? (Position:C15(String:C10($toFind); $target; *)#0) : (Position:C15(String:C10($toFind); $target)#0)
			
			//______________________________________________________
		: (Count parameters:C259=2)
			
			If (Value type:C1509($toFind)=Is boolean:K8:9)
				
				return $toFind ? (Position:C15($target; This:C1470.value; *)#0) : (Position:C15($target; This:C1470.value)#0)
				
			Else 
				
				return (Position:C15($target; This:C1470.value)#0)
				
			End if 
			
			//______________________________________________________
		Else 
			
			return (Position:C15($target; This:C1470.value)#0)
			
			//______________________________________________________
	End case 
	
	//=======================================================================================================
	// Returns True if the string contains one or more words passed by a collection or parameters.
Function contains($words; $word; $word_2 : Text; $word_N : Text) : Boolean
	
	var $t : Text
	var $contains : Boolean
	var $i : Integer
	var $v
	var $formula : Object
	
	C_TEXT:C284(${3})
	
	$contains:=True:C214
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($words)=Is collection:K8:32)
			
			$t:=This:C1470.value
			$formula:=Formula:C1597($t%$1)
			
			For each ($v; $words) While ($contains)
				
				$contains:=$contains & $formula.call(Null:C1517; String:C10($v))
				
			End for each 
			
			//______________________________________________________
		: (Value type:C1509($words)=Is text:K8:3) & (Value type:C1509($word)=Is collection:K8:32)
			
			$formula:=Formula:C1597($words%$1)
			
			For each ($v; $word) While ($contains)
				
				$contains:=$contains & $formula.call(Null:C1517; String:C10($v))
				
			End for each 
			
			//______________________________________________________
		Else 
			
			$t:=This:C1470.value
			$formula:=Formula:C1597($t%$1)
			
			For ($i; 1; Count parameters:C259; 1)
				
				$contains:=$contains & $formula.call(Null:C1517; ${$i})
				
				If (Not:C34($contains))
					
					break
					
				End if 
			End for 
			
			//______________________________________________________
	End case 
	
	return $contains
	
	//=======================================================================================================
	// Returns the position of the last occurence of a string
Function lastOccurrenceOf($target : Text; $toFind; $diacritic : Boolean) : Integer
	
	var $pos; $position; $start : Integer
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=1)
			
			$toFind:=$target
			$target:=This:C1470.value
			
			//______________________________________________________
		: (Count parameters:C259=2)
			
			If (Value type:C1509($toFind)=Is boolean:K8:9)
				
				$diacritic:=$toFind
				$toFind:=$target
				$target:=This:C1470.value
				
			End if 
			
			//______________________________________________________
		: (Count parameters:C259=3)
			
			$toFind:=String:C10($toFind)
			
			//______________________________________________________
	End case 
	
	If (Length:C16($toFind)>0)
		
		$start:=1
		
		If ($diacritic)
			
			Repeat 
				
				$pos:=Position:C15($toFind; This:C1470.value; $start; *)
				
				If ($pos>0)
					
					$position:=$pos
					$start:=$pos+Length:C16($toFind)
					
				End if 
			Until ($pos=0)
			
		Else 
			
			Repeat 
				
				$pos:=Position:C15($toFind; This:C1470.value; $start)
				
				If ($pos>0)
					
					$position:=$pos
					$start:=$pos+Length:C16($toFind)
					
				End if 
			Until ($pos=0)
		End if 
	End if 
	
	return $position
	
	//=======================================================================================================
Function shuffle($string; $length : Integer) : Text
	
	var $pattern; $shuffle; $t; $text : Text
	var $charNumber; $count; $i : Integer
	
	$pattern:="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ,?;.:/=+@#&([{§!)]}-_$€*`£"
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)
			
			$string:=This:C1470.value
			
			//______________________________________________________
		: (Value type:C1509($string)=Is integer:K8:5)\
			 | (Value type:C1509($string)=Is real:K8:4)
			
			$length:=$string
			$string:=This:C1470.value
			
			//______________________________________________________
		Else 
			
			$string:=String:C10($string)
			
			//______________________________________________________
	End case 
	
	If (Length:C16($string)=0)
		
		$text:=$pattern
		
	Else 
		
		For each ($t; Split string:C1554(This:C1470.value; ""))
			
			If (Position:C15($t; $pattern)>0)
				
				$text+=$t
				
			End if 
		End for each 
	End if 
	
	$text:=$text*2
	
	$charNumber:=Length:C16($text)
	$count:=$length=0 ? (10>$charNumber ? $charNumber : 10) : ($length>$charNumber ? $charNumber : $length)
	$length:=$charNumber
	
	For ($i; 1; $count; 1)
		
		$shuffle+=$text[[(Random:C100%($length-1+1))+1]]
		
	End for 
	
	return $shuffle
	
	//=======================================================================================================
	// Returns a base64 encoded UTF-8 string
Function base64($toEncode; $html : Boolean) : Text
	
	Case of 
			//______________________________________________________
		: (Count parameters:C259=0)
			
			$toEncode:=This:C1470.value
			
			//______________________________________________________
		: (Value type:C1509($toEncode)=Is boolean:K8:9)
			
			$html:=$toEncode
			$toEncode:=This:C1470.value
			
			//______________________________________________________
		Else 
			
			$toEncode:=String:C10($toEncode)
			
			//______________________________________________________
	End case 
	
	If ($html)
		
		// Encode in Base64URL format
		BASE64 ENCODE:C895($toEncode; *)
		
	Else 
		
		BASE64 ENCODE:C895($toEncode)
		
	End if 
	
	return $toEncode
	
	//=======================================================================================================
	// Returns an URL-safe base64url encoded UTF-8 string
Function urlBase64Encode() : Text
	
	return This:C1470.base64(True:C214)
	
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
		CONVERT FROM TEXT:C1011(This:C1470.value; "UTF-8"; $x)
		
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
Function urlDecode($target : Text) : Text
	
	var $i; $length; $size : Integer
	var $x : Blob
	
	If (Count parameters:C259=0)
		
		$target:=This:C1470.value
		$size:=This:C1470.length
		
	Else 
		
		$size:=Length:C16($target)
		
	End if 
	
	SET BLOB SIZE:C606($x; $size+1; 0)
	
	For ($i; 1; $size; 1)
		
		Case of 
				
				//________________________________________
			: ($target[[$i]]="%")
				
				$x{$length}:=Position:C15(Substring:C12($target; $i+1; 1); "123456789ABCDEF")*16\
					+Position:C15(Substring:C12($target; $i+2; 1); "123456789ABCDEF")
				$i+=2
				
				//________________________________________
			Else 
				
				$x{$length}:=Character code:C91($target[[$i]])
				
				//________________________________________
		End case 
		
		$length+=1
		
	End for 
	
	// Convert from UTF-8
	SET BLOB SIZE:C606($x; $length)
	
	return Convert to text:C1012($x; "UTF-8")
	
	//=======================================================================================================
	// Returns True if the string passed is exactly the same as the value.
Function equal($target : Text; $string : Text) : Boolean
	
	If (Count parameters:C259>=2)
		
		return (Length:C16($target)=Length:C16($string)) && ((Length:C16($target)=0) | (Position:C15($target; $string; 1; *)=1))
		
	Else 
		
		return (Length:C16(This:C1470.value)=Length:C16($target)) && ((Length:C16(This:C1470.value)=0) | (Position:C15(This:C1470.value; $target; 1; *)=1))
		
	End if 
	
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
	var $2 : Variant  // {Filler}
	var $3 : Integer  // {Alignment}
	
	var $filler : Text
	var $alignment : Integer
	
	$filler:="*"  // Default is star
	
	If (Count parameters:C259>=2)
		
		If ($2#Null:C1517)
			
			$filler:=String:C10($2)
			
		End if 
		
		
		If (Count parameters:C259>=3)
			
			$alignment:=$3
			
		End if 
	End if 
	
	If ($alignment=Align right:K42:4)
		
		$0:=Substring:C12(($filler*($1-This:C1470.length))+This:C1470.value; 1; $1)
		
	Else 
		
		// Default is left
		$0:=Substring:C12(This:C1470.value+($filler*$1); 1; $1)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns value as upper camelcase
Function uperCamelCase($string : Text) : Text
	
	var $t : Text
	var $i : Integer
	var $c : Collection
	
	$string:=Count parameters:C259=0 ? This:C1470.value : $string
	
	If (Length:C16($string)>0)
		
		If (Length:C16($string)>2)
			
			$t:=This:C1470.spaceSeparated()
			
			// Remove spaces
			$c:=Split string:C1554($t; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			
			// Capitalize first letter of words
			For ($i; 0; $c.length-1; 1)
				
				$t:=$c[$i]
				$t[[1]]:=Uppercase:C13($t[[1]])
				$c[$i]:=$t
				
			End for 
			
			return $c.join()
			
		Else 
			
			return Lowercase:C14($string)
			
		End if 
	End if 
	
	//=======================================================================================================
	// Returns value as lower camelcase
Function lowerCamelCase($string : Text) : Text
	
	var $t : Text
	var $i : Integer
	var $c : Collection
	
	$string:=Count parameters:C259=0 ? This:C1470.value : $string
	
	If (Length:C16($string)>0)
		
		If (Length:C16($string)>=2)
			
			$t:=This:C1470.spaceSeparated()
			
			// Remove spaces
			$c:=Split string:C1554(This:C1470.value; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			
			// Capitalization of the first letter of words from the 2nd
			If ($c.length>1)
				
				For ($i; 1; $c.length-1; 1)
					
					$t:=$c[$i]
					$t[[1]]:=Uppercase:C13($t[[1]])
					$c[$i]:=$t
					
				End for 
				
				return $c.join()
				
			Else 
				
				return Lowercase:C14($t)
				
			End if 
			
		Else 
			
			return Lowercase:C14($string)
			
		End if 
	End if 
	
	//=======================================================================================================
	// Returns underscored value & camelcase (lower or upper) value as space separated
Function spaceSeparated($string : Text) : Text
	
	var $char : Text
	var $i; $l : Integer
	var $c : Collection
	
	$string:=Count parameters:C259=0 ? This:C1470.value : $string
	$c:=New collection:C1472
	
	$string:=Replace string:C233($string; "_"; " ")
	
	If (Position:C15(" "; $string)>0)
		
		$c:=Split string:C1554($string; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
		
	Else 
		
		For each ($char; Split string:C1554($string; ""))
			
			$i+=1
			
			If (Character code:C91($char)#Character code:C91($string[[$i]]))  // Cesure
				
				$c.push(Substring:C12($string; $l; $i-$l))
				$l:=$i
				
			End if 
		End for each 
		
		$c.push(Substring:C12($string; $l))
		
	End if 
	
	return $c.join(" ")
	
	//=======================================================================================================
	// Trims leading spaces or passed
Function trimLeading
	var $0 : Text
	var $1 : Text
	
	var $pattern; $t : Text
	var $length; $position : Integer
	
	If (Count parameters:C259>=1)
		
		$pattern:="(?m-si)^(TRIM*)"
		If ($1=".")
			
			$1:="\\."
			
		End if 
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
		If ($1=".")
			
			$1:="\\."
			
		End if 
		
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
		If ($1=".")
			
			$1:="\\."
			
		End if 
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
Function wordWrap($lineLength : Integer)->$wrapped : Text
	
	var $pattern; $t : Text
	var $match : Boolean
	var $columns; $length; $position : Integer
	var $c : Collection
	
	If (Count parameters:C259>=1)
		
		$columns:=$1
		
	Else 
		
		$columns:=79
		
	End if 
	
	$t:=This:C1470.value
	$wrapped:=$t
	
	$pattern:="^(.{1,"+String:C10($columns)+"}|\\S{"+String:C10($columns+1)+",})(?:\\s[^\\S\\r\\n]*|\\Z)"
	$c:=New collection:C1472
	
	Repeat 
		
		$match:=Match regex:C1019($pattern; $t; 1; $position; $length; *)
		
		If ($match)
			
			$c.push(Substring:C12($t; 1; $length))
			$t:=Delete string:C232($t; 1; $length)
			
		Else 
			
			If (Length:C16($t)>0)
				
				$c.push($t)
				
			End if 
		End if 
	Until (Not:C34($match))
	
	$wrapped:=$c.join(Choose:C955(Is macOS:C1572; "\r"; "\n"))
	
	//=======================================================================================================
	// Return extract numeric
Function toNum()->$num : Real
	
	$num:=This:C1470.filter("numeric")
	
	//=======================================================================================================
	// Returns the number of occurennces of $1 into the string
Function occurrencesOf($toFind : Text)->$occurences : Integer
	
	$occurences:=Split string:C1554(This:C1470.value; $toFind; sk trim spaces:K86:2).length-1
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Replace accented and special characters with non-accented or equivalent characters.
Function unaccented($string : Text) : Text
	
	var $t : Text
	var $i; $index : Integer
	
	$string:=Count parameters:C259=0 ? This:C1470.value : $string
	
	If (Length:C16($string)>0)
		
		// Specific cases
		$string:=Replace string:C233($string; "ȼ"; "c"; *)
		$string:=Replace string:C233($string; "Ȼ"; "C"; *)
		$string:=Replace string:C233($string; "Ð"; "D"; *)
		$string:=Replace string:C233($string; "Đ"; "D"; *)
		$string:=Replace string:C233($string; "đ"; "d"; *)
		$string:=Replace string:C233($string; "Ħ"; "H"; *)
		$string:=Replace string:C233($string; "ħ"; "h"; *)
		$string:=Replace string:C233($string; "ı"; "i"; *)
		$string:=Replace string:C233($string; "Ŀ"; "L"; *)
		$string:=Replace string:C233($string; "Ŀ"; "L"; *)
		$string:=Replace string:C233($string; "ŀ"; "l"; *)
		$string:=Replace string:C233($string; "Ł"; "L"; *)
		$string:=Replace string:C233($string; "ł"; "l"; *)
		$string:=Replace string:C233($string; "Ŋ"; "N"; *)
		$string:=Replace string:C233($string; "ŋ"; "n"; *)
		$string:=Replace string:C233($string; "ŉ"; "n"; *)
		$string:=Replace string:C233($string; "n̈"; "n"; *)
		$string:=Replace string:C233($string; "N̈"; "N"; *)
		$string:=Replace string:C233($string; "Ø"; "O"; *)
		$string:=Replace string:C233($string; "ð"; "o"; *)
		$string:=Replace string:C233($string; "ø"; "o"; *)
		$string:=Replace string:C233($string; "Þ"; "P"; *)
		$string:=Replace string:C233($string; "þ"; "p"; *)
		$string:=Replace string:C233($string; "Ŧ"; "T"; *)
		$string:=Replace string:C233($string; "ŧ"; "t"; *)
		
		$t:="abcdefghijklmnopqrstuvwxyz"
		
		For ($i; 1; Length:C16($t); 1)
			
			$index:=0
			
			Repeat 
				
				$index:=Position:C15($t[[$i]]; $string; $index+1)
				
				If ($index>0)
					
					If (Position:C15($string[[$index]]; Uppercase:C13($string[[$index]]; *); *)>0)
						
						// UPPERCASE
						$string[[$index]]:=Uppercase:C13($string[[$index]])
						
					Else 
						
						// lowercase
						$string[[$index]]:=Lowercase:C14($string[[$index]])
						
					End if 
				End if 
			Until ($index=0)
		End for 
		
		// Miscellaneous
		$string:=Replace string:C233($string; "ß"; "ss"; *)
		$string:=Replace string:C233($string; "Æ"; "AE"; *)
		$string:=Replace string:C233($string; "æ"; "ae"; *)
		$string:=Replace string:C233($string; "œ"; "oe"; *)
		$string:=Replace string:C233($string; "Œ"; "OE"; *)
		$string:=Replace string:C233($string; "∂"; "d"; *)
		$string:=Replace string:C233($string; "∆"; "D"; *)
		$string:=Replace string:C233($string; "ƒ"; "f"; *)
		$string:=Replace string:C233($string; "µ"; "u"; *)
		$string:=Replace string:C233($string; "π"; "p"; *)
		$string:=Replace string:C233($string; "∏"; "P"; *)
		
	End if 
	
	return $string
	
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
	// Returns True if the text is a json string
Function isJson
	var $0 : Boolean
	
	$0:=Match regex:C1019("(?msi)^(?:\\{.*\\})|(?:\\[.*\\])$"; This:C1470.value; 1)
	
	//=======================================================================================================
	// Returns True if the text is a json array string
Function isJsonArray
	var $0 : Boolean
	
	$0:=Match regex:C1019("(?msi)^\\[.*\\]$"; This:C1470.value; 1)
	
	//=======================================================================================================
	// Returns True if the text is a json object string
Function isJsonObject
	var $0 : Boolean
	
	$0:=Match regex:C1019("(?msi)^\\{.*\\}$"; This:C1470.value; 1)
	
	//=======================================================================================================
	//  ⚠️ Returns True if text match given pattern
Function match
	var $0 : Boolean
	var $1 : Text
	
	$0:=Super:C1706.match($1; This:C1470.value)
	
	//=======================================================================================================
	//  ⚠️ Returns the localized string & made replacement if any 
Function localized($replacements)->$localizedString : Text
	
	If (Count parameters:C259>=1)
		
		$localizedString:=Super:C1706.localized(This:C1470.value; $replacements)
		
	Else 
		
		$localizedString:=Super:C1706.localized(This:C1470.value)
		
	End if 
	
	//=======================================================================================================
	//  ⚠️ Returns the available localized string for the given "resname" and makes replacements, if any. 
Function localize($resname : Text; $replacements)->$localizedString : Text
	
	This:C1470.setText($resname)
	
	If (Count parameters:C259>=2)
		
		$localizedString:=Super:C1706.localized(This:C1470.value; $replacements)
		
	Else 
		
		$localizedString:=Super:C1706.localized(This:C1470.value)
		
	End if 
	
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
			
			If (Length:C16($t)>0)\
				 & (Length:C16($t)<=255)
				
				//%W-533.1
				If ($t[[1]]#Char:C90(1))
					
					$text:=Get localized string:C991($t)
					$text:=Choose:C955(Length:C16($text)>0; $text; $t)  // Revert if no localization
					
				End if 
				//%W+533.1
				
			End if 
			
			If (Position:C15($tSeparator; $text)#1)\
				 & (Position:C15($tSeparator; $0)#Length:C16($0))
				
				$0:=$0+$tSeparator
				
			End if 
			
			$0:=$0+$text
			
		End for each 
		
	Else 
		
		$text:=Get localized string:C991($1)
		$text:=Choose:C955(Length:C16($text)>0; $text; $1)
		
		If (Position:C15($tSeparator; $text)#1)\
			 & (Position:C15($tSeparator; $0)#Length:C16($0))
			
			$0:=$0+$tSeparator
			
		End if 
		
		$0:=$0+$text
		
	End if 
	
	//=======================================================================================================
	// Returns the string after replacements
Function replace
	var $0 : Text
	var $1 : Variant  // Old
	var $2 : Variant  // New
	
	var $t : Text
	var $i : Integer
	
	$0:=This:C1470.value
	
	If (Value type:C1509($1)=Is collection:K8:32)
		
		If ((Value type:C1509($2)=Is collection:K8:32))
			
			If (Asserted:C1132($1.length<=$2.length))
				
				For each ($t; $1)
					
					$0:=Replace string:C233($0; $t; Choose:C955($2[$i]=Null:C1517; ""; String:C10($2[$i])))
					
					$i:=$i+1
					
				End for each 
			End if 
			
		Else 
			
			$0:=Replace string:C233($0; $t; Choose:C955($2=Null:C1517; ""; String:C10($2)))
			
		End if 
		
	Else 
		
		$0:=Replace string:C233($0; String:C10($1); Choose:C955($2=Null:C1517; ""; String:C10($2)))
		
	End if 
	
	//=======================================================================================================
	// Returns a HTML encoded string
Function htmlEncode()->$html : Text
	var $code; $i : Integer
	var $char; $substitute : Text
	var $o : Object
	
	$o:=New object:C1471(\
		"&"; "&amp;"; \
		"<"; "&lt;"; \
		">"; "&gt;"; \
		"\""; "&quot;"; \
		"\r"; "<br/>")
	
	For ($i; 1; Length:C16(This:C1470.value); 1)
		
		//%W-533.1
		$char:=This:C1470.value[[$i]]
		//%W+533.1
		
		If ($o[$char]=Null:C1517)
			
			$code:=Character code:C91($char)
			
			$substitute:=Choose:C955($code<32; "&#"+String:C10($code)+";"; $char)
			
		Else 
			
			$substitute:=$o[$char]
			
		End if 
		
		$html:=$html+$substitute
		
	End for 
	
	//=======================================================================================================
	// Returns a XML encoded string
Function xmlEncode()->$xml : Text
	var $root; $t : Text
	
	$xml:=This:C1470.value
	
	// Use DOM api to encode XML
	$root:=DOM Create XML Ref:C861("r")
	
	If (OK=1)
		
		DOM SET XML ATTRIBUTE:C866($root; "v"; $xml)
		
		If (OK=1)
			
			DOM EXPORT TO VAR:C863($root; $t)
			
			If (OK=1)  // Extract from result
				
				$t:=Substring:C12($t; Position:C15("v=\""; $t)+3)
				$xml:=Substring:C12($t; 1; Length:C16($t)-4)
				
			End if 
		End if 
		
		DOM CLOSE XML:C722($root)
		
	End if 
	
	//=======================================================================================================
	// Replacing characters that could be wrongfully interpreted as markup
Function xmlSafe()->$xml : Text
	
	$xml:=This:C1470.value
	
	$xml:=Replace string:C233($xml; "&"; "&amp;")
	$xml:=Replace string:C233($xml; "'"; "&apos;")
	$xml:=Replace string:C233($xml; "\""; "&quot;")
	$xml:=Replace string:C233($xml; "<"; "&lt;")
	$xml:=Replace string:C233($xml; ">"; "&gt;")
	
	//=======================================================================================================
	// Returns True if text is styled
Function isStyled
	var $0 : Boolean
	
	$0:=Match regex:C1019("(?i-ms)<span [^>]*>"; String:C10(This:C1470.value); 1)
	
	//====================================================================
	// ⚠️ Returns a string that can be used in multistyles texts
Function multistyleCompatible($src : Text)->$text : Text
	
	//$text:=Super.multistyleCompatible(This.value)
	
	$text:=This:C1470.value
	
	If (Count parameters:C259>=1)
		
		$text:=$src
		
	End if 
	
	$text:=Replace string:C233($text; "&"; "&amp;")
	$text:=Replace string:C233($text; "<"; "&lt;")
	$text:=Replace string:C233($text; ">"; "&gt;")
	
	//=======================================================================================================
	// Returns, if any, a truncated string with ellipsis character
Function truncate($maxChar : Integer; $position : Integer)->$truncated : Text
	
	$truncated:=This:C1470.value
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=1)
			
			If (This:C1470.length>$maxChar)
				
				$truncated:=Substring:C12($truncated; 1; $maxChar)+"…"
				
			End if 
			
			//______________________________________________________
		: ($position=Align left:K42:2)
			
			If (This:C1470.length>$maxChar)
				
				$truncated:=Substring:C12($truncated; 1; $maxChar)+"…"
				
			End if 
			
			//______________________________________________________
		: ($position=Align right:K42:4)
			
			If (This:C1470.length>$maxChar)
				
				$truncated:="…"+Substring:C12($truncated; Length:C16($truncated)-$maxChar)
				
			End if 
			
			//______________________________________________________
		: ($position=Align center:K42:3)
			
			var $midle : Integer
			$midle:=$maxChar\2
			$truncated:=Substring:C12($truncated; 1; $midle)+"…"+Substring:C12($truncated; Length:C16($truncated)-$midle)
			
			//______________________________________________________
	End case 
	
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
	
	//=======================================================================================================
	// ⚠️ Compare two string version
	// -  0 if the version and the reference are equal
	// -  1 if the version is higher than the reference
	// - -1 if the version is lower than the reference
Function versionCompare($with : Text; $separator : Text)->$result : Integer
	
	If (Count parameters:C259>=2)
		
		$result:=Super:C1706.versionCompare(This:C1470.value; $with; $separator)
		
	Else 
		
		$result:=Super:C1706.versionCompare(This:C1470.value; $with)
		
	End if 
	
	//=======================================================================================================
	// Return a user friendly string from json prettified string
Function jsonSimplify()->$formatted : Text
	$formatted:=Replace string:C233(This:C1470.value; "\t"; "")
	$formatted:=Replace string:C233($formatted; "{\n"; "")
	$formatted:=Replace string:C233($formatted; "\n}"; "")
	$formatted:=Replace string:C233($formatted; ",\n"; "\n")
	$formatted:=Replace string:C233($formatted; "[\n"; "")
	$formatted:=Replace string:C233($formatted; "\n]"; "")
	
	//=======================================================================================================
	// Enforcing Standard Password Compliance
Function passwordCompliance($length : Integer)->$compliant : Boolean
	
	If (Count parameters:C259>=1)
		
		// At least $length characters with at least one number, one lower case, one upper case and one special character
		$compliant:=Match regex:C1019("(?m-si)^(?=.{"+String:C10($length)+",})(?=.*[[:digit:]])(?=.*[[:lower:]])(?=.*[[:upper:]])(?=.*[[:punct:]]).*$"; This:C1470.value; 1)
		
	Else 
		
		// At least 8 characters with at least one number, one lower case, one upper case and one special character
		$compliant:=Match regex:C1019("(?m-si)^(?=.{8,})(?=.*[[:digit:]])(?=.*[[:lower:]])(?=.*[[:upper:]])(?=.*[[:punct:]]).*$"; This:C1470.value; 1)
		
	End if 
	
	//=======================================================================================================
Function suitableWithFileName()->$suitable : Text
	
/*
All non-permitted characters are removed. Example: way*fast becomes wayfast:
  < (less than) 
  > (greater than) 
  : (colon) 
  " (right quotation mark) 
  | (vertical bar or pipe) 
  ? (question mark) 
  * (asterisk) 
  . (period) or space at the begin or end of the file or folder name
*/
	
	var $pos; $len : Integer
	
	$suitable:=This:C1470.value
	
	While (Match regex:C1019("(?mi-s)((?:^[\\.\\s]+)|(?:[\\.\\s]+$)|(?:[:\\\\*?\"<>|/]+))+"; $suitable; 1; $pos; $len))
		
		$suitable:=Delete string:C232($suitable; $pos; $len)
		
	End while 
	
/*
Windows reserved names 
com1, com2, com3, com4, com5, com6, com7, com8, com9
lpt1, lpt2, lpt3, lpt4, lpt5, lpt6, lpt7, lpt8, lpt9
con, nul, prn
*/
	
	If (New collection:C1472(\
		"com1"; \
		"com2"; \
		"com3"; \
		"com4"; \
		"com5"; \
		"com6"; \
		"com7"; \
		"com8"; \
		"com9"; \
		"lpt1"; \
		"lpt2"; \
		"lpt3"; \
		"lpt4"; \
		"lpt5"; \
		"lpt6"; \
		"lpt7"; \
		"lpt8"; \
		"lpt9"; \
		"con"; \
		"nul"; \
		"prn")\
		.indexOf($suitable)>-1)
		
		$suitable:="_"+$suitable
		
	End if 
	