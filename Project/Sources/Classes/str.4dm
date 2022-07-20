Class extends tools

// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($content)
	
	Super:C1705()
	
	This:C1470.value:=""
	
	If (Count parameters:C259>=1)
		
		This:C1470.setText($content)
		
	Else 
		
		This:C1470.length:=0
		This:C1470.styled:=False:C215
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Defines the contents of the string & returns the updated object string
Function setText($content) : cs:C1710.str
	
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
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Insertion of the given text into the current string according to the optianal parameters begin & end
	// Also update the inserted text position into the original string (str.begin & str.end)
Function insert($text : Text; $begin : Integer; $end : Integer) : cs:C1710.str
	
	var $length : Integer
	
	If (Length:C16($text)>0)
		
		This:C1470.begin:=$begin
		
		If ($end>$begin)
			
			// Replace the selection with the string to insert
			This:C1470.value:=Substring:C12(This:C1470.value; 1; $begin-1)+$text+Substring:C12(This:C1470.value; $end)
			This:C1470.end:=$begin+Length:C16($text)-1
			
		Else 
			
			// Insert the chain at the insertion point
			$length:=Length:C16(This:C1470.value)  // Keep the current length
			This:C1470.value:=Insert string:C231(This:C1470.value; $text; $begin)
			
			If ($begin=$length)
				
				// We were at the end of the text and we stay
				This:C1470.end:=Length:C16(This:C1470.value)
				
			Else 
				
				// The insertion point is translated from the length of the inserted string
				This:C1470.end:=$begin+Length:C16($text)
				
			End if 
		End if 
		
		This:C1470.length:=Length:C16(This:C1470.value)
		
	Else 
		
		This:C1470.begin:=0
		This:C1470.end:=0
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Append the given text to the current string according eventualy use the optional separator text
	// Also update the inserted text position into the original string (str.begin & str.end)
Function append($text : Text; $separator : Text) : cs:C1710.str
	
	If (Length:C16($text)>0)
		
		This:C1470.begin:=Length:C16(This:C1470.value)
		This:C1470.value+=$separator+$text
		This:C1470.end:=Length:C16(This:C1470.value)
		
		This:C1470.length:=Length:C16(This:C1470.value)
		
	Else 
		
		This:C1470.begin:=0
		This:C1470.end:=0
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if the $toFind text is present in the string (diacritical if any)
Function containsString($target : Text; $toFind; $diacritical : Boolean) : Boolean
	
	Case of 
			//______________________________________________________
		: (Count parameters:C259=3)
			
			return $diacritical ? (Position:C15(String:C10($toFind); $target; *)#0) : (Position:C15(String:C10($toFind); $target)#0)
			
			//______________________________________________________
		: (Count parameters:C259=2)
			
			If (Value type:C1509($toFind)=Is boolean:K8:9)
				
				return $toFind ? (Position:C15($target; This:C1470.value; *)#0) : (Position:C15($target; This:C1470.value)#0)
				
			Else 
				
				return (Position:C15($toFind; $target)#0)
				
			End if 
			
			//______________________________________________________
		Else 
			
			return (Position:C15($target; This:C1470.value)#0)
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the position of the last occurence of a string
Function lastOccurrenceOf($target : Text; $toFind; $diacritic : Boolean) : Integer
	
	var $index; $position; $start : Integer
	
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
				
				$index:=Position:C15($toFind; This:C1470.value; $start; *)
				
				If ($index>0)
					
					$position:=$index
					$start:=$position+Length:C16($toFind)
					
				End if 
			Until ($index=0)
			
		Else 
			
			Repeat 
				
				$index:=Position:C15($toFind; This:C1470.value; $start)
				
				If ($index>0)
					
					$position:=$index
					$start:=$position+Length:C16($toFind)
					
				End if 
			Until ($index=0)
		End if 
	End if 
	
	return $position
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function shuffle($target; $length : Integer) : Text
	
	var $pattern; $shuffle; $t; $text : Text
	var $charNumber; $count; $i : Integer
	
	$pattern:="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ,?;.:/=+@#&([{§!)]}-_$€*`£"
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)
			
			$target:=This:C1470.value
			
			//______________________________________________________
		: (Value type:C1509($target)=Is integer:K8:5)\
			 | (Value type:C1509($target)=Is real:K8:4)
			
			$length:=$target
			$target:=This:C1470.value
			
			//______________________________________________________
		Else 
			
			$target:=String:C10($target)
			
			//______________________________________________________
	End case 
	
	If (Length:C16($target)=0)
		
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a base64 encoded UTF-8 string
Function base64($target; $html : Boolean) : Text
	
	Case of 
			//______________________________________________________
		: (Count parameters:C259=0)
			
			$target:=This:C1470.value
			
			//______________________________________________________
		: (Value type:C1509($target)=Is boolean:K8:9)
			
			$html:=$target
			$target:=This:C1470.value
			
			//______________________________________________________
		Else 
			
			$target:=String:C10($target)
			
			//______________________________________________________
	End case 
	
	If ($html)
		
		// Encode in Base64URL format
		BASE64 ENCODE:C895($target; *)
		
	Else 
		
		BASE64 ENCODE:C895($target)
		
	End if 
	
	return $target
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns an URL-safe base64url encoded UTF-8 string
Function urlBase64Encode($target : Text) : Text
	
	return (Count parameters:C259=0 ? This:C1470.base64(True:C214) : This:C1470.base64($target; True:C214))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns an URL encoded string
Function urlEncode($target : Text) : Text
	
	var $encoded; $pattern : Text
	var $i : Integer
	var $x : Blob
	
	$target:=Count parameters:C259=0 ? This:C1470.value : $target
	
	// List of safe characters
	$pattern:="1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz:/.?_-$(){}~&@"
	
	If (Length:C16($target)>0)
		
		// Use the UTF-8 character set for encoding
		CONVERT FROM TEXT:C1011($target; "UTF-8"; $x)
		
		// Convert the characters
		For ($i; 0; BLOB size:C605($x)-1; 1)
			
			If (Position:C15(Char:C90($x{$i}); $pattern; *)>0)
				
				// It's a safe character, append unaltered
				$encoded+=Char:C90($x{$i})
				
			Else 
				
				// It's an unsafe character, append as a hex string
				$encoded+="%"+Substring:C12(String:C10($x{$i}; "&x"); 5)
				
			End if 
		End for 
	End if 
	
	return $encoded
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns an URL decoded string
Function urlDecode($target : Text) : Text
	
	var $i; $length; $size : Integer
	var $x : Blob
	
	$target:=Count parameters:C259=0 ? This:C1470.value : $target
	$size:=Length:C16($target)
	
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if the string passed is exactly the same as the value.
Function equal($target : Text; $string : Text) : Boolean
	
	If (Count parameters:C259=1)
		
		$string:=$target
		$target:=This:C1470.value
		
	End if 
	
	return (Length:C16($target)=Length:C16($string)) && ((Length:C16($target)=0) | (Position:C15($target; $string; 1; *)=1))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the list of distinct letters of the string.
Function distinctLetters($delimitor : Text) : Variant
	
	//TODO: Accept target
	
	var $c : Collection
	
	$c:=Split string:C1554(This:C1470.value; "").distinct().sort()
	
	// As string if delimiter is passed else as collection
	return (Count parameters:C259>=1 ? $c.join($delimitor) : $c)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Replace spaces, accented characters & special characters
Function alphaNum($target : Text; $replacement : Text) : Text
	
	var $i : Integer
	
	$target:=Count parameters:C259=0 ? This:C1470.value : $target
	
	For ($i; 1; Length:C16($target); 1)
		
		If (Position:C15($target[[$i]]; "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789."; *)=0)
			
			$target[[$i]]:=$replacement
			
		End if 
	End for 
	
	return $target
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns value as fixed length string
Function fixedLength($length : Integer; $filler; $alignment : Integer) : Text
	
	//TODO: Accept target
	
	$filler:=(Count parameters:C259>=2) && ($filler#Null:C1517) ? String:C10($filler) : "*"  // Default is star
	
	If ($alignment=Align right:K42:4)
		
		return Substring:C12(($filler*($length-This:C1470.length))+This:C1470.value; 1; $length)
		
	Else 
		
		// Default is left
		return Substring:C12(This:C1470.value+($filler*$length); 1; $length)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns value as upper camelcase
Function uperCamelCase($target : Text) : Text
	
	var $t : Text
	var $i : Integer
	var $c : Collection
	
	$target:=Lowercase:C14(Count parameters:C259=0 ? This:C1470.value : $target)
	
	If (Length:C16($target)>0)
		
		If (Length:C16($target)>2)
			
			$t:=This:C1470.spaceSeparated($target)
			
			// Remove spaces
			$c:=Split string:C1554($t; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			
			// Capitalize first letter of words
			For ($i; 0; $c.length-1; 1)
				
				$t:=$c[$i]
				
				If (Length:C16($t)>2)
					
					$t[[1]]:=Uppercase:C13($t[[1]])
					
				Else 
					
					$t:=Uppercase:C13($t)
					
				End if 
				
				$c[$i]:=$t
				
			End for 
			
			return $c.join()
			
		Else 
			
			return $target
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns value as lower camelcase
Function lowerCamelCase($target : Text) : Text
	
	var $t : Text
	var $i : Integer
	var $c : Collection
	
	$target:=Count parameters:C259=0 ? This:C1470.value : $target
	
	If (Length:C16($target)>0)
		
		If (Length:C16($target)>=2)
			
			$t:=This:C1470.spaceSeparated($target)
			
			// Remove spaces
			$c:=Split string:C1554($t; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			
			// Capitalization of the first letter of words from the 2nd
			If ($c.length>1)
				
				$c[0]:=Lowercase:C14($c[0])
				
				For ($i; 1; $c.length-1; 1)
					
					$t:=Lowercase:C14($c[$i])
					$t[[1]]:=Uppercase:C13($t[[1]])
					$c[$i]:=$t
					
				End for 
				
				return $c.join()
				
			Else 
				
				return Lowercase:C14($t)
				
			End if 
			
		Else 
			
			return $target
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns underscored value & camelcase (lower or upper) value as space separated
Function spaceSeparated($target : Text) : Text
	
	var $char : Text
	var $uppercase : Boolean
	var $i; $l : Integer
	var $c : Collection
	
	$target:=Count parameters:C259=0 ? This:C1470.value : $target
	$target:=Replace string:C233($target; "_"; " ")
	
	$c:=New collection:C1472
	
	If (Position:C15(" "; $target)>0)
		
		$c:=Split string:C1554($target; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
		
	Else 
		
		For each ($char; Split string:C1554($target; ""))
			
			$i+=1
			
			If ($i=1)
				
				$uppercase:=Character code:C91(Uppercase:C13($char))=Character code:C91($target[[$i]])
				
			Else 
				
				If (Character code:C91(Lowercase:C14($char))#Character code:C91($target[[$i]])) & Not:C34($uppercase)  // Cesure
					
					$c.push(Substring:C12($target; $l; $i-$l-1))
					$l:=$i
					$uppercase:=False:C215
					
				Else 
					
					$uppercase:=Character code:C91(Uppercase:C13($char))=Character code:C91($target[[$i]])
					
				End if 
			End if 
		End for each 
		
		$c.push(Substring:C12($target; $l))
		
	End if 
	
	return $c.join(" ")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Trims Trailing spaces or passed
Function trimTrailing($target : Text; $trim : Text) : Text
	
	var $length; $position : Integer
	var $o : Object
	
	$o:=This:C1470._trimInit(Copy parameters:C1790())
	
	$target:=Split string:C1554($o.target; "").reverse().join("")
	
	If (Match regex:C1019($o.pattern; $target; 1; $position; $length; *))
		
		return Split string:C1554(Delete string:C232($target; $position; $length); "").reverse().join("")
		
	Else 
		
		return $o.target
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Trims leading spaces or passed
Function trimLeading($target : Text; $trim : Text) : Text
	
	var $length; $position : Integer
	var $o : Object
	
	$o:=This:C1470._trimInit(Copy parameters:C1790())
	
	If (Match regex:C1019($o.pattern; $o.target; 1; $position; $length; *))
		
		return Delete string:C232($o.target; $position; $length)
		
	Else 
		
		return $o.target
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Trims leading & trailing spaces or passed
Function trim($target : Text; $trim : Text) : Text
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)
			
			$target:=This:C1470.value
			
			//______________________________________________________
		: (Count parameters:C259=1)
			
			If (Length:C16($target)=1)
				
				$trim:=Position:C15($target; ".$^{[(|)*+?\\^")>0 ? "\\"+$target : $target
				$target:=This:C1470.value
				
			End if 
			
			//______________________________________________________
		: (Count parameters:C259=2)
			
			$trim:=Position:C15($trim; ".$^{[(|)*+?\\^")>0 ? "\\"+$trim : $trim
			
			//______________________________________________________
	End case 
	
	return This:C1470.trimTrailing(This:C1470.trimLeading($target; $trim); $trim)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a word wrapped text based on the line length given (default is 80 characters)
Function wordWrap($target; $columns : Integer) : Text
	
	var $pattern : Text
	var $match : Boolean
	var $length; $position : Integer
	var $c : Collection
	
	$columns:=79  //default is 80 colums (-1 for "…")
	
	Case of 
			
			//______________________________
		: (Count parameters:C259=0)
			
			$target:=This:C1470.value
			
			//______________________________
		: (Value type:C1509($target)=Is integer:K8:5) | (Value type:C1509($target)=Is real:K8:4)
			
			$columns:=$target
			$target:=This:C1470.value
			
			//______________________________
	End case 
	
	If (Length:C16($target)>0)
		
		$pattern:="^(.{1,"+String:C10($columns)+"}|\\S{"+String:C10($columns+1)+",})(?:\\s[^\\S\\r\\n]*|\\Z)"
		
		$c:=New collection:C1472
		
		Repeat 
			
			$match:=Match regex:C1019($pattern; $target; 1; $position; $length; *)
			
			If ($match)
				
				$c.push(Substring:C12($target; 1; $length))
				$target:=Delete string:C232($target; 1; $length)
				
			Else 
				
				If (Length:C16($target)>0)
					
					$c.push($target)
					
				End if 
			End if 
		Until (Not:C34($match))
		
		If ($c.length>0)
			
			return $c.join(Is macOS:C1572 ? "\r" : "\n")
			
		Else 
			
			return $target
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Return extract numeric
Function toNum($target : Text) : Real
	
	$target:=Count parameters:C259>=1 ? $target : This:C1470.value
	
	return This:C1470.extract($target; "numeric")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the number of occurennces of $1 into the string
Function occurrencesOf($target : Text; $toFind : Text) : Integer
	
	If (Count parameters:C259<2)
		
		$toFind:=$target
		$target:=This:C1470.value
		
	End if 
	
	return Split string:C1554($target; $toFind; sk trim spaces:K86:2).length-1
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Replace accented and special characters with non-accented or equivalent characters.
Function unaccented($target : Text) : Text
	
	var $t : Text
	var $i; $index : Integer
	
	$target:=Count parameters:C259=0 ? This:C1470.value : $target
	
	If (Length:C16($target)>0)
		
		// Specific cases
		$target:=Replace string:C233($target; "ȼ"; "c"; *)
		$target:=Replace string:C233($target; "Ȼ"; "C"; *)
		$target:=Replace string:C233($target; "Ð"; "D"; *)
		$target:=Replace string:C233($target; "Đ"; "D"; *)
		$target:=Replace string:C233($target; "đ"; "d"; *)
		$target:=Replace string:C233($target; "Ħ"; "H"; *)
		$target:=Replace string:C233($target; "ħ"; "h"; *)
		$target:=Replace string:C233($target; "ı"; "i"; *)
		$target:=Replace string:C233($target; "Ŀ"; "L"; *)
		$target:=Replace string:C233($target; "Ŀ"; "L"; *)
		$target:=Replace string:C233($target; "ŀ"; "l"; *)
		$target:=Replace string:C233($target; "Ł"; "L"; *)
		$target:=Replace string:C233($target; "ł"; "l"; *)
		$target:=Replace string:C233($target; "Ŋ"; "N"; *)
		$target:=Replace string:C233($target; "ŋ"; "n"; *)
		$target:=Replace string:C233($target; "ŉ"; "n"; *)
		$target:=Replace string:C233($target; "n̈"; "n"; *)
		$target:=Replace string:C233($target; "N̈"; "N"; *)
		$target:=Replace string:C233($target; "Ø"; "O"; *)
		$target:=Replace string:C233($target; "ð"; "o"; *)
		$target:=Replace string:C233($target; "ø"; "o"; *)
		$target:=Replace string:C233($target; "Þ"; "P"; *)
		$target:=Replace string:C233($target; "þ"; "p"; *)
		$target:=Replace string:C233($target; "Ŧ"; "T"; *)
		$target:=Replace string:C233($target; "ŧ"; "t"; *)
		
		$t:="abcdefghijklmnopqrstuvwxyz"
		
		For ($i; 1; Length:C16($t); 1)
			
			$index:=0
			
			Repeat 
				
				$index:=Position:C15($t[[$i]]; $target; $index+1)
				
				If ($index>0)
					
					If (Position:C15($target[[$index]]; Uppercase:C13($target[[$index]]; *); *)>0)
						
						// UPPERCASE
						$target[[$index]]:=Uppercase:C13($target[[$index]])
						
					Else 
						
						// lowercase
						$target[[$index]]:=Lowercase:C14($target[[$index]])
						
					End if 
				End if 
			Until ($index=0)
		End for 
		
		// Miscellaneous
		$target:=Replace string:C233($target; "ß"; "ss"; *)
		$target:=Replace string:C233($target; "Æ"; "AE"; *)
		$target:=Replace string:C233($target; "æ"; "ae"; *)
		$target:=Replace string:C233($target; "œ"; "oe"; *)
		$target:=Replace string:C233($target; "Œ"; "OE"; *)
		$target:=Replace string:C233($target; "∂"; "d"; *)
		$target:=Replace string:C233($target; "∆"; "D"; *)
		$target:=Replace string:C233($target; "ƒ"; "f"; *)
		$target:=Replace string:C233($target; "µ"; "u"; *)
		$target:=Replace string:C233($target; "π"; "p"; *)
		$target:=Replace string:C233($target; "∏"; "P"; *)
		
	End if 
	
	return $target
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if the text contains only ASCII characters
Function isAscii($target : Text) : Boolean
	
	$target:=Count parameters:C259=0 ? This:C1470.value : $target
	return Match regex:C1019("(?mi-s)^[[:ascii:]]*$"; $target; 1)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if text is "T/true" or "F/false"
Function isBoolean($target : Text) : Boolean
	
	$target:=Count parameters:C259=0 ? This:C1470.value : $target
	return Match regex:C1019("(?m-is)^(?:[tT]rue|[fF]alse)$"; $target; 1)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if the text is a date string (DOES NOT CHECK IF THE DATE IS VALID)
Function isDate($target : Text) : Boolean
	
	$target:=Count parameters:C259=0 ? This:C1470.value : $target
	return Match regex:C1019("(?m-si)^\\d+/\\d+/\\d+$"; $target; 1)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if text is a numeric
Function isNum($target : Text) : Boolean
	
	var $t : Text
	
	$target:=Count parameters:C259=0 ? This:C1470.value : $target
	GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $t)
	return Match regex:C1019("(?m-si)^(?:\\+|-)?\\d+(?:\\.|"+$t+"\\d+)?$"; $target; 1)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	//  Returns True if text is a time string (DOES NOT CHECK IF THE TIME IS VALID)
Function isTime($target : Text) : Boolean
	
	var $t : Text
	
	$target:=Count parameters:C259=0 ? This:C1470.value : $target
	GET SYSTEM FORMAT:C994(Time separator:K60:11; $t)
	return Match regex:C1019("(?m-si)^\\d+"+$t+"\\d+(?:"+$t+"\\d+)?$"; $target; 1)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if the text conforms to the URL grammar. (DOES NOT CHECK IF THE URL IS VALID)
Function isUrl($target : Text) : Boolean
	
	$target:=Count parameters:C259=0 ? This:C1470.value : $target
	return Match regex:C1019("(?m-si)^(?:(?:https?):// )?(?:localhost|127.0.0.1|(?:\\S+(?::\\S*)?@)?(?:(?!10(?:\\.\\d{1,3}){3})(?!127(?:\\.\\d{1,3}){3}"+\
		")(?!169\\.254(?:\\.\\d{1,3}){2})(?!192\\.168(?:\\.\\d{1,3}){2})(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})(?:[1-9"+\
		"]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|"+\
		"(?:(?:[a-z\\x{00a1}-\\x{ffff}0-9]+-?)*[a-z\\x{00a1}-\\x{ffff}0-9]+)(?:\\.(?:[a-z\\x{00a1}-\\x{ffff}0-9]+-?)*[a-z\\x{00a1"+\
		"}-\\x{ffff}0-9]+)*(?:\\.(?:[a-z\\x{00a1}-\\x{ffff}]{2,}))))(?::\\d{2,5})?(?:/[^\\s]*)?$"; $target; 1)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if the text is a json string
Function isJson($target : Text) : Boolean
	
	$target:=Count parameters:C259=0 ? This:C1470.value : $target
	return Match regex:C1019("(?msi)^(?:\\{.*\\})|(?:\\[.*\\])$"; $target; 1)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if the text is a json array string
Function isJsonArray($target : Text) : Boolean
	
	$target:=Count parameters:C259=0 ? This:C1470.value : $target
	return Match regex:C1019("(?msi)^\\[.*\\]$"; $target; 1)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if the text is a json object string
Function isJsonObject($target : Text) : Boolean
	
	$target:=Count parameters:C259=0 ? This:C1470.value : $target
	return Match regex:C1019("(?msi)^\\{.*\\}$"; $target; 1)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	//  ⚠️ Returns True if text match given pattern
Function match($target : Text; $pattern) : Boolean
	
	$pattern:=Count parameters:C259=1 ? $target : $pattern
	$target:=Count parameters:C259=1 ? This:C1470.value : $target
	
	return Super:C1706.match($pattern; $target)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	//  ⚠️ Returns the localized string & made replacement if any 
Function localized($replacements) : Text
	
	return Count parameters:C259>=1 ? Super:C1706.localized(This:C1470.value; $replacements) : Super:C1706.localized(This:C1470.value)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	//  ⚠️ Returns the available localized string for the given "resname" and makes replacements, if any. 
Function localize($resname : Text; $replacements) : Text
	
	This:C1470.setText($resname)
	
	return Count parameters:C259>=2 ? Super:C1706.localized(This:C1470.value; $replacements) : Super:C1706.localized(This:C1470.value)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a HTML encoded string
Function htmlEncode($target : Text) : Text
	
	var $char; $encoded : Text
	var $code : Integer
	var $o : Object
	
	$o:=New object:C1471(\
		"&"; "&amp;"; \
		"<"; "&lt;"; \
		">"; "&gt;"; \
		"\""; "&quot;"; \
		"\r"; "<br/>")
	
	$target:=Count parameters:C259<1 ? This:C1470.value : $target
	
	For each ($char; Split string:C1554($target; ""))
		
		If ($o[$char]=Null:C1517)
			
			$code:=Character code:C91($char)
			$char:=$code<32 ? "&#"+String:C10($code)+";" : $char
			
		Else 
			
			$char:=$o[$char]
			
		End if 
		
		$encoded+=$char
		
	End for each 
	
	return $encoded
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a XML encoded string
Function xmlEncode($target : Text) : Text
	
	var $root; $t : Text
	
	$target:=Count parameters:C259<1 ? This:C1470.value : $target
	
	// Use DOM api to encode XML
	$root:=DOM Create XML Ref:C861("r")
	
	If (OK=1)
		
		DOM SET XML ATTRIBUTE:C866($root; "v"; $target)
		
		If (OK=1)
			
			DOM EXPORT TO VAR:C863($root; $t)
			
			If (OK=1)  // Extract from result
				
				$t:=Substring:C12($t; Position:C15("v=\""; $t)+3)
				$target:=Substring:C12($t; 1; Length:C16($t)-4)
				
			End if 
		End if 
		
		DOM CLOSE XML:C722($root)
		
	End if 
	
	return $target
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Replacing characters that could be wrongfully interpreted as markup
Function xmlSafe($target : Text) : Text
	
	$target:=Count parameters:C259<1 ? This:C1470.value : $target
	
	$target:=Replace string:C233($target; "&"; "&amp;")
	$target:=Replace string:C233($target; "'"; "&apos;")
	$target:=Replace string:C233($target; "\""; "&quot;")
	$target:=Replace string:C233($target; "<"; "&lt;")
	$target:=Replace string:C233($target; ">"; "&gt;")
	
	return $target
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if text is a 4D styled text
Function isStyled($target : Text) : Boolean
	
	$target:=Count parameters:C259<1 ? This:C1470.value : $target
	
	return Match regex:C1019("(?i-ms)<span [^>]*>"; String:C10($target); 1)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// ⚠️ Returns a string that can be used in multistyles texts
Function multistyleCompatible($target : Text) : Text
	
	$target:=Count parameters:C259<1 ? This:C1470.value : $target
	
	$target:=Replace string:C233($target; "&"; "&amp;")
	$target:=Replace string:C233($target; "<"; "&lt;")
	$target:=Replace string:C233($target; ">"; "&gt;")
	
	return $target
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns, if any, a truncated string with ellipsis character
Function truncate($maxChar : Integer; $position : Integer) : Text
	
	var $truncated : Text
	var $midle : Integer
	
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
				
				$truncated:="…"+Substring:C12($truncated; Length:C16($truncated)-$maxChar+1)
				
			End if 
			
			//______________________________________________________
		: ($position=Align center:K42:3)
			
			If (This:C1470.length>$maxChar)
				
				$midle:=$maxChar\2
				
				Case of 
						
						//_________________
					: ($midle=0)
						
						$truncated:=Substring:C12($truncated; 1; $maxChar)+"…"
						
						//_________________
					: ($midle>=1) & (($midle%2)#0) & (($midle%2)#1)
						
						$truncated:=Substring:C12($truncated; 1; 1)+"…"+Substring:C12($truncated; Length:C16($truncated)-$midle)
						
						//_________________
					Else 
						
						$truncated:=Substring:C12($truncated; 1; $midle)+"…"+Substring:C12($truncated; Length:C16($truncated)-$midle+1)
						
						//______________________________________________________
				End case 
			End if 
			
			//______________________________________________________
	End case 
	
	return $truncated
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a collection of unique words
Function keywords($target; $sorted : Boolean) : Collection
	
	var $keywords : Collection
	
	ARRAY TEXT:C222($a; 0)
	
	Case of 
			
			//______________________________________
		: (Count parameters:C259=0)
			
			$target:=This:C1470.value
			
			//______________________________________
		: (Count parameters:C259=1)\
			 && (Value type:C1509($target)=Is boolean:K8:9)
			
			$sorted:=$target
			$target:=This:C1470.value
			
			//______________________________________
		Else 
			
			$target:=String:C10($target)
			
			//______________________________________
	End case 
	
	$keywords:=New collection:C1472
	GET TEXT KEYWORDS:C1141($target; $a; *)
	
	If ($sorted)
		
		SORT ARRAY:C229($a)
		
	End if 
	
	ARRAY TO COLLECTION:C1563($keywords; $a)
	
	return $keywords
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// 
Function extract($target : Text; $type : Text) : Variant
	
	var $pattern; $t : Text
	var $length; $position : Integer
	
	If (Count parameters:C259=1)
		
		$target:=This:C1470.value
		$type:=$target
		
	End if 
	
	Case of 
			
			// Mark:Numeric
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($type="numeric")  // Return extracted numeric
			
			$pattern:="(?m-si)^\\D*([+-]?\\d+\\{thousand}?\\d*\\{decimal}?\\d?)\\s?\\D*$"
			
			GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $t)
			$pattern:=Replace string:C233($pattern; "{decimal}"; $t)
			
			If ($t#".")
				
				$target:=Replace string:C233($target; "."; $t)
				
			End if 
			
			GET SYSTEM FORMAT:C994(Thousand separator:K60:2; $t)
			$pattern:=Replace string:C233($pattern; "{thousand}"; $t)
			
			If (Match regex:C1019($pattern; $target; 1; $position; $length; *))
				
				return Num:C11(Substring:C12($target; 1; $length))
				
			Else 
				
				return Num:C11($target)
				
			End if 
			
			//…………………………………………………………………………………
		Else 
			
			// Mark:TO DO (date, time, …)
			
			//…………………………………………………………………………………
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// ⚠️ Compare two string version
	// -  0 if the version and the reference are equal
	// -  1 if the version is higher than the reference
	// - -1 if the version is lower than the reference
Function versionCompare($with : Text; $separator : Text) : Integer
	
	If (Count parameters:C259>=2)
		
		return Super:C1706.versionCompare(This:C1470.value; $with; $separator)
		
	Else 
		
		return Super:C1706.versionCompare(This:C1470.value; $with)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Return a user friendly string from json prettified string
Function jsonSimplify($target : Text) : Text
	
	$target:=Count parameters:C259>=1 ? $target : This:C1470.value
	
	$target:=Replace string:C233($target; "\t"; "")
	$target:=Replace string:C233($target; "{\n"; "")
	$target:=Replace string:C233($target; "\n}"; "")
	$target:=Replace string:C233($target; ",\n"; "\n")
	$target:=Replace string:C233($target; "[\n"; "")
	$target:=Replace string:C233($target; "\n]"; "")
	
	return $target
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Enforcing Standard Password Compliance
Function passwordCompliance($target; $length : Integer) : Boolean
	
	// At least $length characters with at least one number, one lower case, one upper case and one special character
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)
			
			$target:=This:C1470.value
			$length:=8  // Default length
			
			//______________________________________________________
		: (Value type:C1509($target)=Is text:K8:3)
			
			$length:=Count parameters:C259<2 ? 8 : $length
			
			//______________________________________________________
		: (Value type:C1509($target)=Is real:K8:4) || (Value type:C1509($target)=Is integer:K8:5)
			
			$length:=$target
			$target:=This:C1470.value
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "Incompatible argument type")
			
			return 
			
			//______________________________________________________
	End case 
	
	return Match regex:C1019("(?m-si)^(?=.{"+String:C10($length)+",})(?=.*[[:digit:]])(?=.*[[:lower:]])(?=.*[[:upper:]])(?=.*[[:punct:]]).*$"; $target; 1)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a string compatible with a file name
Function suitableWithFileName($target : Text) : Text
	
	var $length; $position : Integer
	
/*
All non-permitted characters are removed. Example: way*fast becomes wayfast:
<(less than)
>(greater than)
: (colon)
" (right quotation mark)"
 | (vertical bar or pipe)
? (question mark)
*(asterisk)
.(Period)or space at the begin or end of the file or folder name
*/
	
	$target:=Count parameters:C259<1 ? This:C1470.value : $target
	
	While (Match regex:C1019("(?mi-s)((?:^[\\.\\s]+)|(?:[\\.\\s]+$)|(?:[:\\\\*?\"<>|/]+))+"; $target; 1; $position; $length))
		
		$target:=Delete string:C232($target; $position; $length)
		
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
		.indexOf($target)>-1)
		
		$target:="_"+$target
		
	End if 
	
	return $target
	
	//MARK:-PRIVATE
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _trimInit($parameters : Collection) : Object
	
	var $pattern; $target; $trim : Text
	
	$pattern:="(?m-si)^(\\s*)"  // Default is space
	
	Case of 
			
			//______________________________________________________
		: ($parameters.length=0)
			
			$target:=This:C1470.value
			
			//______________________________________________________
		: ($parameters.length=1)
			
			If (Length:C16($parameters[0])=1)
				
				$trim:=Position:C15($parameters[0]; ".$^{[(|)*+?\\^")>0 ? "\\"+$parameters[0] : $parameters[0]
				$target:=This:C1470.value
				$pattern:="(?m-si)^("+$trim+"*)"
				
			Else 
				
				$target:=$parameters[0]
				
			End if 
			
			//______________________________________________________
		: ($parameters.length=2)
			
			$target:=$parameters[0]
			$trim:=Position:C15($parameters[1]; ".$^{[(|)*+?\\^")>0 ? "\\"+$parameters[1] : $parameters[1]
			$pattern:=Length:C16($trim)>0 ? "(?m-si)^("+$trim+"*)" : $pattern
			
			//______________________________________________________
	End case 
	
	return New object:C1471("target"; $target; "pattern"; $pattern)
	