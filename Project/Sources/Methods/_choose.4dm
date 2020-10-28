//%attributes = {"invisible":true,"preemptive":"capable"}
var $0; $1
var ${2} : Object

If (Value type:C1509($1)=Is real:K8:4)
	
	$0:=${Num:C11($1)+2}.call()
	
Else 
	
	$0:=${3-Num:C11(Bool:C1537($1))}.call()
	
End if 