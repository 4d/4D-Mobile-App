//%attributes = {"invisible":true,"preemptive":"capable"}
var $0 : Boolean
var ${1} : Object
var $i : Integer

$0:=True:C214

For ($i; 1; Count parameters:C259; 1)
	
	$0:=${$i}.call()
	
	If (Not:C34($0))
		
		$i:=MAXLONG:K35:2-1  // Stop at the 1st fail
		
	End if 
End for 