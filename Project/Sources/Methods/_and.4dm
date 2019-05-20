//%attributes = {"invisible":true,"preemptive":"capable"}
/*
Boolean := ***_and*** ( Param_1 ; … ; N )
 -> Param_1 ; … ; N (Object)
________________________________________________________

*/
C_BOOLEAN:C305($0)
C_OBJECT:C1216(${1})

C_LONGINT:C283($i)

If (False:C215)
	C_BOOLEAN:C305(_and ;$0)
	C_OBJECT:C1216(_and ;${1})
End if 

$0:=True:C214

For ($i;1;Count parameters:C259;1)
	
	$0:=${$i}.call()
	
	If (Not:C34($0))
		
		$i:=MAXLONG:K35:2-1  // Stop at the 1st fail
		
	End if 
End for 