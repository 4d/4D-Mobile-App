//%attributes = {}
var $class; $code; $name : Text
var $i : Integer
var $classes; $o : Object
var $c : Collection
var $regex : cs:C1710.regex

ARRAY TEXT:C222($methods; 0)

METHOD GET PATHS:C1163(Path class:K72:19; $methods; *)

$regex:=cs:C1710.regex.new()
$classes:=New object:C1471

For ($i; 1; Size of array:C274($methods); 1)
	
	$name:=Delete string:C232($methods{$i}; 1; 8)
	
	If ($name#"@Entity") && ($name#"DataStore")
		
		METHOD GET CODE:C1190($methods{$i}; $code; *)
		
		$o:=New object:C1471
		
		If ($regex.setPattern("(?m-si)Class extends\\s([[:alpha:]][[:alnum:]]*)").setTarget($code).match())
			
			$o.extend:=$regex.matches[1].data
			
		End if 
		
		$c:=$regex.setPattern("(?m-si)(?!.*[gs]et)Function ([[:alpha:]][^[:blank:]($]*)(?:\\(.*\\))(?:[^$]*)").extract(1)
		
		If ($c.length>0)
			
			$o.functions:=$c
			
		End if 
		
		$classes[$name]:=$o
		
	End if 
End for 

For each ($class; $classes)
	
	$o:=$classes[$class]
	
	If ($o.extend#Null:C1517)
		
		$classes[$o.extend].childs:=$classes[$o.extend].childs || New object:C1471
		$classes[$o.extend].childs[$class]:=$o
		
		OB REMOVE:C1226($o; "extend")
		
	End if 
End for each 

