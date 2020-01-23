//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ob MERGE
  // ID[22AB79336CCE4F08AD3078FE45C201D7]
  // Created 23-5-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Add the missing properties of the model to the target
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)
C_OBJECT:C1216($2)

C_TEXT:C284($t)

If (False:C215)
	C_OBJECT:C1216(ob MERGE ;$1)
	C_OBJECT:C1216(ob MERGE ;$2)
End if 

  // ----------------------------------------------------
For each ($t;$2)
	
	If ($1[$t]=Null:C1517)
		
		$1[$t]:=$2[$t]
		
	Else 
		
		If (Value type:C1509($2[$t])=Is object:K8:27)
			
			ob MERGE ($1[$t];$2[$t])  // <- RECURSIVE
			
		End if 
	End if 
End for each 