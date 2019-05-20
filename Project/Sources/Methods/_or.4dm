//%attributes = {"invisible":true}
/*
Boolean := ***_or*** ( Param_1 ; … ; N )
 -> Param_1 ; … ; N (Object)
________________________________________________________

*/
C_BOOLEAN:C305($0)
C_OBJECT:C1216(${1})

C_LONGINT:C283($i)

If (False:C215)
	C_BOOLEAN:C305(_or ;$0)
	C_OBJECT:C1216(_or ;${1})
End if 

For ($i;1;Count parameters:C259;1)
	
	$0:=${$i}.call()
	
	If ($0)
		
		$i:=MAXLONG:K35:2-1  // Stop at the 1st success
		
	End if 
End for 