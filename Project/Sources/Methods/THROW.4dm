//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : THROW
  // ID[C0A2A993242342CC9DF5E2C7F733283E]
  // Created 18-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
C_OBJECT:C1216($1)

C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(THROW ;$1)
End if 

C_OBJECT:C1216(err)

  // ----------------------------------------------------
If (Asserted:C1132(Count parameters:C259>0))
	
	$o:=$1
	
	If ($o.component=Null:C1517)
		
		$o.component:=String:C10(err.signature)
		
	End if 
	
	$o.deffered:=True:C214
	
	_4D THROW ERROR:C1520($o)
	
End if 

  // ----------------------------------------------------