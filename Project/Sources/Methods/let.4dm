//%attributes = {"invisible":true,"preemptive":"capable"}
var $0 : Boolean
var $1 : Pointer

var $2 : Variant
var $3 : 4D:C1709.Function

Case of 
	: (Value type:C1509($2)#Is object:K8:27)
		$1->:=$2
	: (OB Instance of:C1731($2; 4D:C1709.Function))
		$1->:=$2.call()
	Else   // an object
		$1->:=$2
End case 

$0:=$3.call(Null:C1517; $1->)
