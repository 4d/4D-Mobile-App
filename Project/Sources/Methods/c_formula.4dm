//%attributes = {}
  // Helper method to use with collection map
  // $1 is the value, and the first arg is $2
  // ex: $col.map("c_formula";Formula($1+$2);2) // increment by 2
  // https://github.com/mesopelagique/CollectionUtils
C_OBJECT:C1216($1)
C_OBJECT:C1216($2)
C_VARIANT:C1683(${3})

C_LONGINT:C283($count;$i)
C_TEXT:C284($key)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(c_formula ;$1)
	C_OBJECT:C1216(c_formula ;$2)
	C_VARIANT:C1683(c_formula ;${3})
End if 

$count:=Count parameters:C259

$key:=Choose:C955(Undefined:C82($1.accumulator);"result";"accumulator")

Case of 
		
		  //________________________________________
	: ($count>2)
		
		$c:=New collection:C1472($1.value)
		
		For ($i;3;$count;1)
			
			$c.push(${$i})
			
		End for 
		
		$1[$key]:=$2.apply($1;$c)
		
		  //________________________________________
	: ($count=2)
		
		$1[$key]:=$2.call($1;$1.value)
		
		  //________________________________________
	Else 
		
		  // wrong use ie. assert dev
		
		  //________________________________________
End case 