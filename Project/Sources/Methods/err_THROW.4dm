//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : THROW
// ID[C0A2A993242342CC9DF5E2C7F733283E]
// Created 18-5-2017 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($error : Object)

If (False:C215)
	C_OBJECT:C1216(err_THROW; $1)
End if 

//C_OBJECT(err)

// ----------------------------------------------------
If (Asserted:C1132(Count parameters:C259>0))
	
	//If ($o.component=Null)
	//$o.component:=String(err.signature)
	//End if
	
	$error.deffered:=True:C214
	
	_4D THROW ERROR:C1520($error)
	
End if 

// ----------------------------------------------------