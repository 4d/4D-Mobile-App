//%attributes = {"invisible":true}
/*  nul (variant{; long}) -> variant
$1: some variable, null or undefined var
$2: empty var to return
$0:
https://discuss.4d.com/t/for-each-smarter-handling-of-null-collections/16605/6
*/
var $0 : Variant
var $1 : Variant
var $2 : Integer

If (False:C215)
	C_VARIANT:C1683(nvl; $0)
	C_VARIANT:C1683(nvl; $1)
	C_LONGINT:C283(nvl; $2)
End if 

var $type : Integer

If ($1=Null:C1517)
	
	If (Count parameters:C259=2)
		
		$type:=$2
		
	Else 
		
		$type:=Value type:C1509($1)
		
	End if 
	
	Case of 
			
			//________________________________________
		: ($type=Is collection:K8:32)
			
			$0:=New collection:C1472()
			
			//________________________________________
		: ($type=Is object:K8:27)
			
			$0:=New object:C1471
			
			//________________________________________
		: ($type=Is real:K8:4)\
			 | ($type=Is longint:K8:6)\
			 | ($type=Is integer:K8:5)
			
			$0:=0
			
			//________________________________________
		: ($type=Is date:K8:7)
			
			$0:=!00-00-00!
			
			//________________________________________
		: ($type=Is text:K8:3)
			
			$0:=""
			
			//________________________________________
		: ($type=Is boolean:K8:9)
			
			$0:=False:C215
			
			//________________________________________
		: ($type=Is time:K8:8)
			
			$0:=?00:00:00?
			
			//________________________________________
	End case 
	
Else 
	
	$0:=$1
	
End if 